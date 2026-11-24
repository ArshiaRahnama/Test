--[[ Boss UI - the rest of the classic menu, rebuilt with ox_lib (client/boss_ui_more.lua)
    Everything here runs through BossUI.flow(): the NUI hides, an ox_lib menu/dialog does the job, then the Boss UI comes back.
    It uses the same server callbacks/events as the classic menu, so permissions and logs are unchanged.

      hire (Members tab)            nearby jobless players -> confirm -> setJob(hire)
      outfits (Outfit tab)          grade or division, male/female -> clothing store session -> setUniform
      Home > extras                 division members | division vehicles/helis | rank helis | edit division (name/label/icon)
                                    wash money toggle | pads | options | org recruit
]]

-- jobs that never get weapon/heli/division management (copy of uwuNoWeaponJobs in client/main.lua, which is a local there)
BossUI.noWeapon = {
    uwucafe = true, obsidian = true, voltage = true, ember = true, anchor = true, crimson = true,
    flourish = true, goldcrust = true, carwash = true,
    firebrick = true, slice = true, frostbite = true, sundae = true,
    static = true, nightjar = true, koi = true, wasabi = true,
    meridian = true, blacktide = true, cratecarry = true, turfco = true,
}

local function sc(...) return BossUI.sc(...) end
local function notify(msg) ESX.ShowNotification(msg) end
local function asList(v) return type(v) == 'table' and v or {} end
local function lower(v) return string.lower(tostring(v or '')) end

-- Blocking ox_lib list: returns the chosen item's `value`, or nil when the player backs out.
local function pick(title, items)
    local p = promise.new()
    local options = {}
    for _, it in ipairs(items) do
        options[#options + 1] = {
            title = it.label, description = it.desc, icon = it.icon, metadata = it.metadata,
            onSelect = function() p:resolve({ it.value }) end,
        }
    end
    if #options == 0 then options[1] = { title = 'Mored-i vojood nadarad', disabled = true } end
    lib.registerContext({ id = 'boss_ui_pick', title = title, options = options, onExit = function() p:resolve(nil) end })
    lib.showContext('boss_ui_pick')
    local r = Citizen.Await(p)
    return r and r[1] or nil
end

local function confirm(header, content)
    return lib.alertDialog({ header = header, content = content, centered = true, cancel = true }) == 'confirm'
end

local function gradeItems(society)
    local job = sc('esx_society:getJob', society)
    local items = {}
    for _, g in ipairs(asList(job and job.grades)) do
        items[#items + 1] = { label = (g.label and g.label ~= '' and g.label) or g.name, desc = g.name, icon = 'user-tie', value = g.grade }
    end
    return items
end

local function divisionItems(society)
    local items = {}
    for _, d in ipairs(asList(sc('esx_society:getdivision', society))) do
        items[#items + 1] = { label = d.label or d.name, desc = d.name, icon = 'sitemap', value = d }
    end
    return items
end

-- toggle list: loadRows() -> rows { label, value(bool), ... }; apply(rows, row, newState) calls the server setter
local function toggleLoop(title, loadRows, apply)
    while true do
        local rows = loadRows()
        local items = {}
        for _, r in ipairs(rows) do
            items[#items + 1] = { label = r.label, desc = r.value and 'Faal' or 'Gheyre faal', icon = r.value and 'check' or 'xmark', value = r }
        end
        local row = pick(title, items)
        if not row then return end
        apply(rows, row, not row.value)
    end
end

-- -------------------------------------------------------------------------- hire ---
local function hireFlow(society)
    while true do
        local players, myCoords = sc('esx_society:getOnlinePlayers', society)
        local items = {}
        for _, pl in ipairs(asList(players)) do
            if pl.job and pl.job.name == 'nojob' and pl.coords and myCoords and #(vector3(myCoords.x, myCoords.y, myCoords.z) - vector3(pl.coords.x, pl.coords.y, pl.coords.z)) <= 15.0 then
                items[#items + 1] = { label = tostring(pl.name):gsub('_', ' '), desc = 'Bikar', icon = 'user-plus', value = pl }
            end
        end
        local pl = pick('Estekhdam (bazikonane nazdik)', items)
        if not pl then return end
        if confirm('Estekhdam', ('Aya mikhahid ~%s~ ra estekhdam konid?'):format(tostring(pl.name):gsub('_', ' '))) then
            sc('esx_society:setJob', pl.identifier, society, 1, 'hire')
            notify('~g~Fard estekhdam shod.')
        end
    end
end
BossUI.hireFlow = hireFlow

-- ----------------------------------------------------------------- division members ---
local function divisionMembersFlow(society)
    local mode = pick('Aaza-ye division', {
        { label = 'Ezafe kardan be division', icon = 'user-plus', value = 'set' },
        { label = 'Hazf az division', icon = 'user-minus', value = 'remove' },
    })
    if not mode then return end
    while true do
        local players = asList(sc('esx_society:getOnlinePlayersDivision', society))
        local items = {}
        for _, pl in ipairs(players) do items[#items + 1] = { label = pl.name, icon = 'user', value = pl } end
        local pl = pick(mode == 'set' and 'Ke ra be division ezafe konid?' or 'Az division-e ke hazf konid?', items)
        if not pl then return end

        local divisions = asList(sc('esx_society:getdivision', society))
        local assigned = asList(sc('esx_society:GetDivisionsPlayer', pl.identifier))
        local has = {}
        for _, a in pairs(assigned) do has[a.name] = true end
        local choices = {}
        for _, d in ipairs(divisions) do
            if (mode == 'set') ~= (has[d.name] == true) then
                choices[#choices + 1] = { label = d.label or d.name, desc = d.name, icon = 'sitemap', value = d }
            end
        end
        local d = pick(pl.name, choices)
        if d and confirm('Tayid', ('%s: %s'):format(pl.name, d.label or d.name)) then
            sc('esx_society:setJobDivision', pl.identifier, society,
                { job = society, name = d.name, label = d.label, status = false }, mode == 'set' and 'hire' or 'fire')
            notify('~g~Anjam shod.')
        end
    end
end

-- ------------------------------------------------------- vehicles / helis permissions ---
local function stateMap(states)
    local m = {}
    for _, st in ipairs(asList(states)) do m[lower(st.model)] = (st.status == true) end
    return m
end

local function helisForRank(society)
    local authorized = Config.Heli and Config.Heli[society]
    if not authorized then notify('~r~Heli baraye in shoghl tarif nashode') return end
    local rank = pick('Heli - Rank', gradeItems(society))
    if rank == nil then return end
    toggleLoop('Heli | ' .. tostring(rank), function()
        local m = stateMap(sc('esx_society:getHelis', rank, society))
        local rows = {}
        for _, h in ipairs(authorized) do rows[#rows + 1] = { label = h.label, model = h.name, helimodel = h.label, value = m[lower(h.name)] or false } end
        return rows
    end, function(rows, row, state)
        sc('esx_society:setSocietyHeliPerm', society, rank, rows, state, row.model, row.helimodel)
    end)
end

local function divisionVehicles(society, helis)
    local authorized = helis and Config.Heli and Config.Heli[society] or (not helis and GetMergedGarage(society))
    if not authorized then notify('~r~Baraye in shoghl tarif nashode') return end
    local d = pick(helis and 'Heli - Division' or 'Khodro - Division', divisionItems(society))
    if not d then return end
    toggleLoop((helis and 'Heli' or 'Khodro') .. ' | ' .. (d.label or d.name), function()
        local m = stateMap(sc(helis and 'esx_society:getHelisdivision' or 'esx_society:getVehiclesdivision', d.name, society))
        local rows = {}
        for _, v in ipairs(authorized) do rows[#rows + 1] = { label = v.label, model = v.name, Vehiclelabel = v.label, Helilabel = v.label, value = m[lower(v.name)] or false } end
        return rows
    end, function(rows, row, state)
        sc(helis and 'esx_society:setSocietyHelidivisionPerm' or 'esx_society:setSocietyVehdivisionPerm',
            society, d.name, rows, state, row.model, helis and row.Helilabel or row.Vehiclelabel)
    end)
end

-- ----------------------------------------------------------------------- edit division ---
local function editDivisionFlow(society)
    while true do
        local d = pick('Virayesh-e division', divisionItems(society))
        if not d then return end
        local what = pick(d.label or d.name, {
            { label = 'Tagheer-e name (englisi)', desc = d.name, icon = 'pen', value = 'name' },
            { label = 'Tagheer-e label', desc = d.label, icon = 'tag', value = 'label' },
            { label = 'Tagheer-e icon (link-e aks)', desc = d.icon or 'nadarad', icon = 'image', value = 'icon' },
        })
        if what then
            local input = lib.inputDialog('Virayesh-e division', {
                { type = 'input', label = what == 'icon' and 'Link (http/https, khali = hazf)' or 'Meghdar-e jadid', required = what ~= 'icon', max = what == 'icon' and 255 or 12 },
            })
            local value = input and tostring(input[1] or '')
            if value ~= nil then
                if what == 'name' then
                    value = string.lower(value:gsub('%s+', ''))
                elseif what == 'label' then
                    value = value:sub(1, 1):upper() .. value:sub(2)
                end
                if value ~= '' or what == 'icon' then
                    sc('esx_society:ChangeDivision', society, d.id, value, what)
                    notify('~g~Anjam shod.')
                end
            end
        end
    end
end

-- --------------------------------------------------------------------------- outfits ---
-- same clothing-store session as the classic menu (esx_society:getEmployeclothes / setUniform)
local function outfitSession(society, kind, target, sex)
    Wait(500)
    local myskin = sc('esx_skin:getPlayerSkin')
    local skinjob
    if kind == 'grade' then
        skinjob = sc('esx_society:getEmployeclothes', tonumber(target), sex, society)
    else
        skinjob = sc('esx_society:getEmployeclothesdivision', target, sex, society)
    end
    local default = sex == 'female' and Config.FemaleDefault or Config.MaleDefault
    if skinjob ~= nil then TriggerEvent('skinchanger:loadClothes', default, skinjob)
    else TriggerEvent('skinchanger:loadSkin', default) end
    Wait(100)
    OpenOutfitEditor()
    while true do
        Wait(1000)
        if not IsOutfitEditorOpen() then
            -- current (edited) skin from skinchanger; esx_skin:getPlayerSkin would
            -- return the boss's saved DB skin, not the uniform just edited.
            local skinP = promise.new()
            TriggerEvent('skinchanger:getSkin', function(s) skinP:resolve(s) end)
            local skin = Citizen.Await(skinP)
            if kind == 'grade' then sc('esx_society:setUniform', society, tonumber(target), sex, skin)
            else sc('esx_society:setUniformdivision', society, target, sex, skin) end
            break
        end
    end
    TriggerEvent('skinchanger:loadSkin', myskin)      -- put the boss's own clothes back
end

local function outfitFlow(society)
    local kind = pick('Lebas-e sazman', {
        { label = 'Lebas-e Rank', icon = 'user-tie', value = 'grade' },
        { label = 'Lebas-e Division', icon = 'sitemap', value = 'division' },
    })
    if not kind then return end
    local sex = pick('Jens', {
        { label = 'Mard', icon = 'person', value = 'male' },
        { label = 'Zan', icon = 'person-dress', value = 'female' },
    })
    if not sex then return end
    local target
    if kind == 'grade' then
        target = pick('Rank', gradeItems(society))
    else
        local d = pick('Division', divisionItems(society))
        target = d and d.name
    end
    if target == nil then return end
    outfitSession(society, kind, target, sex)
end
BossUI.outfitFlow = outfitFlow

-- ---------------------------------------------------------------- Home > extras entries ---
local function bossOnly(ctx) return ctx.isBoss and ctx.canView and ctx.options.job ~= false end
local function hasDivisionTools(ctx) return bossOnly(ctx) and not BossUI.noWeapon[ctx.society] end

BossUI.addExtra({ key = 'div_members', label = 'اعضای دیویژن (افزودن / حذف)', show = hasDivisionTools,
    run = function(ctx) divisionMembersFlow(ctx.society) end, reopen = true })
BossUI.addExtra({ key = 'div_edit', label = 'ویرایش دیویژن (نام / لیبل / آیکون)', show = hasDivisionTools,
    run = function(ctx) editDivisionFlow(ctx.society) end, reopen = true })
BossUI.addExtra({ key = 'div_vehicles', label = 'دسترسی خودروهای دیویژن', show = function(ctx) return hasDivisionTools(ctx) and ctx.society ~= 'uwucafe' end,
    run = function(ctx) divisionVehicles(ctx.society, false) end, reopen = true })
BossUI.addExtra({ key = 'div_helis', label = 'دسترسی هلی‌کوپتر دیویژن', show = function(ctx) return hasDivisionTools(ctx) and Config.Heli and Config.Heli[ctx.society] ~= nil end,
    run = function(ctx) divisionVehicles(ctx.society, true) end, reopen = true })
BossUI.addExtra({ key = 'rank_helis', label = 'دسترسی هلی‌کوپتر رنک‌ها', show = function(ctx) return hasDivisionTools(ctx) and Config.Heli and Config.Heli[ctx.society] ~= nil end,
    run = function(ctx) helisForRank(ctx.society) end, reopen = true })

-- wash money toggle (same gate as the classic menu)
local function washEligible(ctx)
    if not (ctx.canView and ctx.isBoss) then return false end
    if not ((ctx.job.grade or 0) >= 16 or ctx.job.name == 'government') then return false end
    local ok, eligible = pcall(function() return exports['ScriptPack']:IsWashMoneyEligibleJob(ctx.job.name) end)
    return ok and eligible == true
end
BossUI.addExtra({ key = 'wash', show = washEligible, reopen = true,
    label = function(ctx)
        local on = sc('esx_society:GetPermWashMoney', ctx.job.name) == 'true'
        return on and 'شستن پول: فعال ✅ (کلیک = غیرفعال)' or 'شستن پول: غیرفعال ❌ (کلیک = فعال)'
    end,
    run = function(ctx)
        local on = sc('esx_society:GetPermWashMoney', ctx.job.name) == 'true'
        TriggerServerEvent('esx_society:SetPermWash', ctx.job.name, tostring(not on))
        Wait(400)
    end })

-- launchers into other resources (same events the classic manage-job menu fired)
BossUI.addExtra({ key = 'org_pads', label = 'مدیریت پدها', show = bossOnly, run = function(ctx) TriggerEvent('org_peds:bossPads', ctx.society) end })
BossUI.addExtra({ key = 'org_options', label = 'مدیریت آپشن‌های ارگان', show = bossOnly, run = function(ctx) TriggerEvent('org_options:open', ctx.society) end })
BossUI.addExtra({ key = 'org_recruit', label = 'استخدام / دیویژن (سیستم ریکروت)', show = bossOnly, run = function(ctx) TriggerEvent('ujrec:openOrg', ctx.society) end })
