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

function IsGangItemLocked(xPlayer, itemName)
    if not xPlayer or not xPlayer.gang or not itemName then return false end

    local locked = false
    local answered = false
    TriggerEvent('Unique_ALLGangs:checkItemAccess', xPlayer.source, xPlayer.gang.name, itemName, function(allowed)
        answered = true
        locked = not (allowed and true or false)
    end)

    if not answered then return false end -- Unique_ALLGangs not running / didn't answer -> don't lock
    return locked
end

function IsJobItemLocked(xPlayer, itemName)
    if not xPlayer or not xPlayer.job or not itemName then return false end
    local jobTable = Config.JobStockMinGrade and Config.JobStockMinGrade[xPlayer.job.name]
    if not jobTable then return false end

    local minGrade = jobTable[string.lower(itemName)]
    if minGrade == nil then return false end -- item not listed = no restriction

    return xPlayer.job.grade < minGrade
end
