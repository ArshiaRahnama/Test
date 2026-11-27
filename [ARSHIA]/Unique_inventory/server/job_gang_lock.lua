--[[ ===========================================================================
    Unique_inventory | server/job_gang_lock.lua

    ---------------------------------------------------------------------------
    هدف
    ---------------------------------------------------------------------------
    همون قفلی که تو گنگ سیستم بود (نشون بده، ولی نتونه برش داره) رو برای
    آرموری جاب‌ها (job1 = سلاح، job2 = آیتم استاندارد) هم بیار. دو تابع:

        IsGangItemLocked(xPlayer, itemName)  -- گنگ
        IsJobItemLocked(xPlayer, itemName)   -- انبار جاب (job2)
        IsJobWeaponLocked(src, xPlayer, weaponName, authorizedSet) -- آرموری جاب (job1)

    این‌ها فقط "آیا قفله؟" رو برمی‌گردونن؛ هم تو ساختن لیست UI (که آیتم رو
    نشون بده با locked=true) و هم تو خودِ رویدادهای برداشتن واقعی
    (Parzival:GetJobItem/GetJobWeapon/gangs:getFromInventory) صدا زده میشن -
    یعنی حتی اگه NUI/کلاینت دستکاری بشه، سرور دوباره همین چک رو می‌کنه و رد
    می‌کنه (never trust the client).

    ---------------------------------------------------------------------------
    ارتباط با Unique_ALLGangs (بدون exports - طبق تجربه‌ی ثبت‌شده‌ی خودِ این
    کدبیس، پاس‌دادن تابع callback از طریق exports بین دو ریسورس رو این
    build از FXServer شکسته؛ الگوی امن همونیه که همه‌جای این کدبیس با
    esx_datastore/esx_addoninventory استفاده شده: TriggerEvent با یه تابع
    callback به‌عنوان آرگومان، نه exports)
    ---------------------------------------------------------------------------
    Unique_ALLGangs باید این رویداد رو رجیستر کنه (اضافه‌ش کردم، پایین‌تر تو
    changelog توضیح دادم):

        AddEventHandler('Unique_ALLGangs:checkItemAccess', function(src, gangName, itemName, cb)
            ...
            cb(allowedBoolean)
        end)

    اگه Unique_ALLGangs نصب/روشن نباشه، هیچ‌کس به این event گوش نمیده،
    callback هیچ‌وقت صدا زده نمیشه، و `locked` پیش‌فرض false می‌مونه - یعنی
    نبود Unique_ALLGangs هیچ‌وقت اینونتوری گنگ رو خراب نمی‌کنه.
=========================================================================== ]]


function DLog(fmt, ...)
    if Config and Config.DebugLock then
        local ok, msg = pcall(string.format, fmt, ...)
        print('^5[LOCKDBG]^0 ' .. (ok and msg or tostring(fmt)))
    end
end

function IsGangItemLocked(xPlayer, itemName, armoryKey)
    if not xPlayer or not xPlayer.gang or not itemName then return false end

    local locked = false
    local answered = false
    TriggerEvent('Unique_ALLGangs:checkItemAccess', xPlayer.source, xPlayer.gang.name, itemName, function(allowed)
        answered = true
        locked = not (allowed and true or false)
    end, armoryKey)

    DLog('GANG item=%s gang=%s grade=%s answered=%s locked=%s', tostring(itemName), tostring(xPlayer.gang.name), tostring(xPlayer.gang.grade), tostring(answered), tostring(locked))
    if not answered then return false end -- Unique_ALLGangs not running / didn't answer -> don't lock
    return locked
end


--[[ GetJobGradePerm(job, grade, column) -> list, found
    Reads the rank permission list straight from job_grades (`weapons` / `items`),
    which is exactly what the boss action's Manage Weapons / Manage Inventory save.
    Using the database directly (instead of asking esx_society over an event) means the
    lock can never silently "fail open" just because that event did not answer.
    `found` is false only when the job/grade row does not exist at all. ]]
function GetJobGradePerm(job, grade, column)
    if column ~= 'weapons' and column ~= 'items' then return {}, false end
    local row = MySQL.Sync.fetchAll('SELECT `' .. column .. '` AS v FROM job_grades WHERE job_name = @j AND grade = @g LIMIT 1',
        { ['@j'] = job, ['@g'] = tonumber(grade) or 0 })
    if not row or not row[1] then
        DLog('JOBPERM %s job=%s grade=%s -> NO job_grades ROW (fail-open)', column, tostring(job), tostring(grade))
        return {}, false
    end
    local list = {}
    local raw = row[1].v
    DLog('JOBPERM %s job=%s grade=%s raw=%s', column, tostring(job), tostring(grade), tostring(raw))
    if raw and raw ~= '' then
        local ok, dec = pcall(json.decode, raw)
        if ok and type(dec) == 'table' then list = dec end
    end
    return list, true
end

function IsJobItemLocked(xPlayer, itemName)
    if not xPlayer or not xPlayer.job or not itemName then return false end
    local lname = string.lower(itemName)

    -- 1) static minimum-grade table (config_joblock.lua) - still honoured
    local jobTable = Config.JobStockMinGrade and Config.JobStockMinGrade[xPlayer.job.name]
    if jobTable then
        local minGrade = jobTable[lname]
        if minGrade ~= nil and xPlayer.job.grade < minGrade then DLog('JOBITEM %s LOCKED by Config.JobStockMinGrade (need grade %s, have %s)', lname, tostring(minGrade), tostring(xPlayer.job.grade)) return true end
    end

    -- 2) the boss action's "Manage Inventory": an item is open for a rank ONLY when
    -- ticked (status == true).
    -- (no boss exemption: items follow the ticks for every rank, exactly like weapons)
    local list, found = GetJobGradePerm(xPlayer.job.name, xPlayer.job.grade, 'items')
    if not found then return false end
    for _, row in ipairs(list) do
        if row.name and string.lower(row.name) == lname then
            DLog('JOBITEM %s job=%s grade=%s status=%s -> locked=%s', lname, xPlayer.job.name, tostring(xPlayer.job.grade), tostring(row.status), tostring(row.status ~= true))
            return row.status ~= true
        end
    end
    DLog('JOBITEM %s job=%s grade=%s NOT in rank list -> locked=true', lname, xPlayer.job.name, tostring(xPlayer.job.grade))
    return true -- not ticked / never configured = locked
end


-- Which shared store belongs to the armory the player opened? (gangs can own several armories)
-- Returns the store name, or nil when that armory does not exist. Unanswered = default store.
function ResolveGangStoreName(xPlayer, armoryKey)
    if not xPlayer or not xPlayer.gang then return nil end
    local answered, name = false, nil
    TriggerEvent('Unique_ALLGangs:getArmoryStore', xPlayer.source, xPlayer.gang.name, armoryKey, function(n) answered = true name = n end)
    DLog('RESOLVE gang store src=%s gang=%s key=%s answered=%s -> %s', tostring(xPlayer.source), tostring(xPlayer.gang.name), tostring(armoryKey), tostring(answered), tostring(name))
    if not answered then
        if armoryKey ~= nil then return nil end -- never show another armory's chest by mistake
        return 'gang_' .. string.lower(xPlayer.gang.name)
    end
    return name
end
