-- ScriptPack / change world (client)

local currentWorld = 0
local currentLabel = nil
local flags = {}
local savedHealth, savedArmor = nil, nil
local savedSkin = nil
local pedChanged = false
local spawnedVehicles = {}
local givenWeapons = {}
local openPedMenu, openSkinMenu, hidePreview, closeModern, updateBadge, resetFx, rememberVehicle, rememberPed
local openManagerNui, openShopNui, openMyWorldsNui, openJoinNui
local currentSpawn, currentExpire = nil, 0

-- Same menu look as the old F9 menu: ESX.UI.Menu "default" (top-left) + "dialog" for typed input.
local ESXc = nil
CreateThread(function()
    while ESXc == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESXc = obj end)
        Wait(200)
    end
end)

local function esxMenu()
    return ESXc and ESXc.UI and ESXc.UI.Menu or nil
end

-- ox_target (the "eye") is switched off inside worlds so that normal-world interactions (ATM, garage peds ...) are unusable.
local function setTargeting(disabled)
    if not CWConfig.BlockTargetInWorlds then return end
    if GetResourceState('ox_target') ~= 'started' then return end
    pcall(function() exports.ox_target:disableTargeting(disabled) end)
end

local function notify(text, kind)
    if ESXc and ESXc.ShowNotification then
        ESXc.ShowNotification(text)
    else
        lib.notify({ description = text, type = kind or 'inform' })
    end
end

local REASONS = {
    not_found = 'World Peyda Nashod.',
    expired = 'Zaman In World Tamam Shode Ast.',
    no_access = 'Shoma Dastresi Be In World Nadarid.',
    no_permission = 'Shoma Dastresi Kafi Nadarid.',
    exists = 'In World Ghablan Sakhte Shode Ast.',
    range = 'Shomare World Dar Mahdude Nist.',
    invalid = 'Voroodi Eshtebah Ast.',
    same = 'Taghiri Anjam Nashod.',
    not_ready = 'System World Hanouz Load Nashode Ast.',
    no_money = 'Pool Kafi Nadarid.',
    limit = 'Be Hadde Majaz Residid.',
    full = 'Hich World Khalii Mojood Nist.',
    busy = 'Lotfan Kami Sabr Konid.',
    too_far_shop = 'Aval Be Foroshgah World Beravid.',
    not_streamer = 'Shoma Dastresi Be In Komand Ra Nadarid!',
    too_far = 'Bazikon Mored Nazar Nazdik Be Noghteye Vared Shodan Nist!',
    too_far_entrance = 'Baraye Vared Shodan Bayad Nazdike Noghteye Vorood Bashid.',
    not_allowed = 'Shoma Ejaze Estefade Az In Dastor Ra Nadarid.',
    no_gang = 'Baraye Vared Shodan Bayad Dar Yek Gang Bashid.',
    no_boss = 'Noghteye Gang Shoma Moshakhas Nashode Ast.',
    too_far_gang = 'Baraye Vared Shodan Bayad Kenare Gang Khod Bashid.',
    too_far_place = 'Baraye Vared Shodan Bayad Be Mahale Vorood Beravid.',
}

local function loadModel(hash)
    local ok = pcall(lib.requestModel, hash, 5000)
    return ok and HasModelLoaded(hash)
end

local function explain(ok, why)
    if ok then return true end
    notify(REASONS[why] or 'Action failed.', 'error')
    return false
end

-- ---------------------------------------------------------------- enter / leave

local function fade(ms, out)
    if out then
        DoScreenFadeOut(ms)
        while not IsScreenFadedOut() do Wait(0) end
    else
        DoScreenFadeIn(ms)
    end
end

-- Teleport with the ground frozen until the map around the target has streamed in.
local function moveTo(c)
    if not c or not c.x or not c.y or not c.z then return end
    local ped = PlayerPedId()
    local ent = ped
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then ent = veh end

    FreezeEntityPosition(ent, true)
    RequestCollisionAtCoord(c.x, c.y, c.z)
    SetEntityCoords(ent, c.x, c.y, c.z, false, false, false, false)
    if c.h then SetEntityHeading(ent, c.h + 0.0) end

    local waited = 0
    while not HasCollisionLoadedAroundEntity(ent) and waited < 8000 do
        Wait(100)
        waited = waited + 100
    end
    FreezeEntityPosition(ent, false)
end

local function deleteSpawnedVehicles()
    for i = #spawnedVehicles, 1, -1 do
        local veh = spawnedVehicles[i]
        if DoesEntityExist(veh) then
            NetworkRequestControlOfEntity(veh)
            SetEntityAsMissionEntity(veh, true, true)
            DeleteEntity(veh)
        end
        spawnedVehicles[i] = nil
    end
end

local function removeWorldWeapons()
    local ped = PlayerPedId()
    for hash in pairs(givenWeapons) do
        RemoveWeaponFromPed(ped, hash)
        givenWeapons[hash] = nil
    end
end

local function restorePed()
    if not pedChanged then return end
    pedChanged = false
    if savedSkin then
        local skin = savedSkin
        TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0, function()
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end

RegisterNetEvent('unique_cw:client:entered', function(world, newFlags, spawn, label, expire)
    local first = currentWorld == 0
    currentWorld = world
    currentLabel = label
    currentSpawn = spawn
    currentExpire = tonumber(expire) or 0
    flags = newFlags or {}

    if first then
        setTargeting(true)
        local ped = PlayerPedId()
        savedHealth = GetEntityHealth(ped)
        savedArmor = GetPedArmour(ped)
        savedSkin = nil
        TriggerEvent('skinchanger:getSkin', function(skin) savedSkin = skin end)
    end

    if first or spawn then
        fade(400, true)
        if spawn then moveTo(spawn) else Wait(300) end
        fade(400, false)
    end
    notify(('Shoma Be World %d Vared Shodid!'):format(world), 'success')
    updateBadge()
end)

RegisterNetEvent('unique_cw:client:teleport', function(coords)
    if currentWorld == 0 then return end
    fade(300, true)
    moveTo(coords)
    fade(300, false)
end)

RegisterNetEvent('unique_cw:client:flags', function(newFlags)
    flags = newFlags or {}
end)

RegisterNetEvent('unique_cw:client:notify', function(text, kind)
    notify(text, kind)
end)

RegisterNetEvent('unique_cw:client:left', function(ret, silent)
    currentWorld = 0
    currentLabel = nil
    currentSpawn, currentExpire = nil, 0
    flags = {}
    closeModern()
    resetFx()
    updateBadge()

    setTargeting(false)
    fade(500, true)
    local M = esxMenu()
    if M then M.CloseAll() end
    hidePreview()
    deleteSpawnedVehicles()
    removeWorldWeapons()
    restorePed()
    moveTo(ret)

    -- Anything healed inside the world does not carry out of it.
    local ped = PlayerPedId()
    if savedHealth and savedHealth > 0 and savedHealth < GetEntityHealth(ped) then
        SetEntityHealth(ped, savedHealth)
    end
    if savedArmor and savedArmor < GetPedArmour(ped) then
        SetPedArmour(ped, savedArmor)
    end
    savedHealth, savedArmor = nil, nil

    fade(500, false)
    if not silent then notify('Shoma Be World Asli Bargashtid!', 'success') end
end)

-- ---------------------------------------------------------------- in-world tools

local function can(feature)
    if currentWorld == 0 or not flags[feature] then
        notify('Shoma Dastresi Be In Komand Ra Dar in World Nadarid.', 'error')
        return false
    end
    return lib.callback.await('unique_cw:can', false, feature) == true
end

local function spawnVehicle(modelName, ask)
    if not can('vehicle') then return end
    if type(modelName) ~= 'string' or modelName == '' then
        if not ask then return notify('Lotfan Esm Mashin Ra Vared Konid.', 'error') end
        local input = lib.inputDialog('Spawn vehicle', { { type = 'input', label = 'Model name', required = true, max = 32 } })
        if not input or not input[1] then return end
        modelName = tostring(input[1])
    end

    local model = joaat(modelName:lower())
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        return notify('Hamchin Mashini Vojood Nadarad.', 'error')
    end
    if not loadModel(model) then
        return notify('Model Mashin Load Nashod.', 'error')
    end

    -- Keep the player's spawned vehicles under the cap.
    while #spawnedVehicles >= CWConfig.MaxSpawnedVehicles do
        local oldest = table.remove(spawnedVehicles, 1)
        if DoesEntityExist(oldest) then
            NetworkRequestControlOfEntity(oldest)
            SetEntityAsMissionEntity(oldest, true, true)
            DeleteEntity(oldest)
        end
    end

    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local veh = CreateVehicle(model, c.x, c.y, c.z, GetEntityHeading(ped), true, false)
    SetModelAsNoLongerNeeded(model)
    if veh == 0 then return notify('Mashin Spawn Nashod.', 'error') end

    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(ped, veh, -1)
    spawnedVehicles[#spawnedVehicles + 1] = veh
    if rememberVehicle then rememberVehicle(modelName) end
end

local function deleteVehicle()
    if not can('vehicle') then return end
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return notify('Shoma Dar Hich Mashini Nistid.', 'error') end

    TaskLeaveVehicle(ped, veh, 16)
    Wait(300)
    NetworkRequestControlOfEntity(veh)
    SetEntityAsMissionEntity(veh, true, true)
    DeleteEntity(veh)
    for i = #spawnedVehicles, 1, -1 do
        if spawnedVehicles[i] == veh then table.remove(spawnedVehicles, i) end
    end
end

local function teleportToWaypoint()
    if not can('tp') then return end
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then return notify('Markeri Baraye Teleport Shodan Vojoud Nadarad!', 'error') end

    local target = GetBlipInfoIdCoord(blip)
    local ped = PlayerPedId()
    local ent = ped
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then ent = veh end

    fade(300, true)
    local landed = false
    for height = 1000.0, 0.0, -25.0 do
        RequestCollisionAtCoord(target.x, target.y, height)
        SetEntityCoords(ent, target.x, target.y, height, false, false, false, false)
        Wait(25)
        local found, z = GetGroundZFor_3dCoord(target.x, target.y, height, false)
        if found then
            SetEntityCoords(ent, target.x, target.y, z + 1.0, false, false, false, false)
            landed = true
            break
        end
    end
    fade(300, false)
    if landed then
        notify('Shoma Be Marker Rojaye Map Teleport Shodid!', 'success')
    else
        notify('Zamin Dar In Noghte Peyda Nashod.', 'error')
    end
end

local function fixVehicle()
    if not can('vehicle') then return end
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return notify('Shoma Dar Hich Mashini Nistid.', 'error') end
    SetVehicleFixed(veh)
    SetVehicleDeformationFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleUndriveable(veh, false)
    SetVehicleEngineOn(veh, true, true, false)
    notify('Mashin Shoma Tamir Shod!', 'success')
end

local function giveWeapon(name, ammo, bulk)
    if not bulk and not can('weapon') then return end
    if type(name) ~= 'string' or name == '' then
        local input = lib.inputDialog('Give weapon', {
            { type = 'input', label = 'Weapon name (e.g. WEAPON_PISTOL)', required = true, max = 40 },
            { type = 'number', label = 'Ammo', default = CWConfig.DefaultWeaponAmmo, min = 0, max = CWConfig.MaxWeaponAmmo },
        })
        if not input or not input[1] then return end
        name, ammo = tostring(input[1]), input[2]
    end

    name = name:upper():gsub('[^%w_]', '')
    if name:sub(1, 7) ~= 'WEAPON_' and name:sub(1, 7) ~= 'GADGET_' then name = 'WEAPON_' .. name end
    local hash = joaat(name)
    if not IsWeaponValid(hash) then
        if not bulk then notify('Hamchin Aslahei Vojood Nadarad.', 'error') end
        return false
    end

    ammo = math.floor(tonumber(ammo) or CWConfig.DefaultWeaponAmmo)
    ammo = math.max(0, math.min(ammo, CWConfig.MaxWeaponAmmo))
    local ped = PlayerPedId()
    if not HasPedGotWeapon(ped, hash, false) then givenWeapons[hash] = true end   -- only remove what the world gave
    GiveWeaponToPed(ped, hash, ammo, false, true)
    if not bulk then notify(('%s Be Shoma Dade Shod!'):format(name), 'success') end
    return true
end

local function pickMember(title, callbackName)
    if not can('tp') then return end
    local members = lib.callback.await('unique_cw:members', false) or {}
    if #members == 0 then return notify('Kasi Digar Dar In World Nist.', 'inform') end
    local options = {}
    for _, m in ipairs(members) do
        options[#options + 1] = {
            title = ('%s [%d]'):format(m.name, m.id), icon = 'user',
            onSelect = function() explain(lib.callback.await('unique_cw:' .. callbackName, false, m.id)) end,
        }
    end
    lib.registerContext({ id = 'unique_cw_members_' .. callbackName, title = title, menu = 'unique_cw_tools', options = options })
    lib.showContext('unique_cw_members_' .. callbackName)
end

local function reviveSelf()
    if not can('revive') then return end
    if lib.callback.await('unique_cw:revive', false) then
        notify('Shoma Revive Shodid!', 'success')
    else
        notify('Shoma Dastresi Be In Komand Ra Dar in World Nadarid.', 'error')
    end
end

local function fillArmor()
    if not can('armor') then return end
    TriggerEvent('esx_status:set', 'armor', 100)
    AddArmourToPed(PlayerPedId(), 100)
    notify('Armor Shoma Por Shod!', 'success')
end

local function refillAmmo()
    if not can('weapon') then return end
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if weapon == joaat('WEAPON_UNARMED') then return notify('Shoma Hich Aslahe Darid!', 'error') end
    AddAmmoToPed(ped, weapon, 250)
    notify('Tir Aslahe Shoma Por Shod!', 'success')
end

local function setPed(model)
    if not can('peds') then return end
    if model then
        local hash = joaat(model)
        if not IsModelInCdimage(hash) or not loadModel(hash) then
            return notify('Model Ped Load Nashod.', 'error')
        end
        if not pedChanged and not savedSkin then
            TriggerEvent('skinchanger:getSkin', function(skin) savedSkin = skin end)
        end
        pedChanged = true
        SetPlayerModel(PlayerId(), hash)
        SetModelAsNoLongerNeeded(hash)
        SetPedDefaultComponentVariation(PlayerPedId())
        if rememberPed then rememberPed(model) end
    else
        restorePed()
    end
end

-- Big preview of the highlighted ped on the right side of the screen.
local preview = { dui = nil, active = false }
local PREVIEW_TXD, PREVIEW_TXN = 'unique_cw_preview', 'unique_cw_preview_txn'

local function showPreview(url)
    if not preview.dui then
        preview.dui = CreateDui(url, 512, 512)
        local txd = CreateRuntimeTxd(PREVIEW_TXD)
        CreateRuntimeTextureFromDuiHandle(txd, PREVIEW_TXN, GetDuiHandle(preview.dui))
    else
        SetDuiUrl(preview.dui, url)
    end
    if preview.active then return end
    preview.active = true
    CreateThread(function()
        while preview.active do
            DrawSprite(PREVIEW_TXD, PREVIEW_TXN, 0.85, 0.5, 0.25, 0.4, 0.0, 255, 255, 255, 255)
            Wait(0)
        end
    end)
end

hidePreview = function()
    preview.active = false
end

local function openPedMenuOx()
    if not can('peds') then return end
    local options = {}
    local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
    local categories = (static and static.peds) or CWConfig.Peds
    for ci, category in ipairs(categories) do
        local menuId = ('unique_cw_peds_%d_%d'):format(currentWorld, ci)
        local entries = { { label = 'Back to my own ped', args = { model = false } } }
        for _, p in ipairs(category.list) do
            entries[#entries + 1] = { label = p.label, description = p.model, args = { model = p.model } }
        end
        lib.registerMenu({
            id = menuId,
            title = 'Ped: ' .. category.label,
            position = 'top-left',
            options = entries,
            onSelected = function(selected)
                local entry = entries[selected]
                if entry and entry.args.model and CWConfig.PedImageUrl then
                    showPreview(CWConfig.PedImageUrl:format(entry.args.model))
                else
                    hidePreview()
                end
            end,
            onClose = hidePreview,
        }, function(_, _, args)
            setPed(args.model or nil)
        end)
        options[#options + 1] = {
            title = category.label, icon = 'user', arrow = true,
            onSelect = function() lib.showMenu(menuId) end,
        }
    end
    lib.registerContext({ id = 'unique_cw_peds', title = 'Change ped', menu = 'unique_cw_tools', options = options })
    lib.showContext('unique_cw_peds')
end

-- ---------------------------------------------------------------- world skins (saved outfits)

local function applyWorldSkin(name)
    if not can('skins') then return end
    local clothes = lib.callback.await('unique_cw:skinGet', false, name)
    if not clothes then return notify('In Lebas Dige Mojood Nist.', 'error') end

    if not pedChanged and not savedSkin then
        TriggerEvent('skinchanger:getSkin', function(skin) savedSkin = skin end)
    end
    pedChanged = true
    TriggerEvent('skinchanger:getSkin', function(current)
        TriggerEvent('skinchanger:loadClothes', current, clothes)
    end)
end

local function openSkinMenuOx()
    if not can('skins') then return end
    local names = lib.callback.await('unique_cw:skinNames', false) or {}
    if #names == 0 then return notify('Hich Lebasi Baraye In World Zakhire Nashode Ast.', 'inform') end

    local options = {
        { title = 'My own outfit', icon = 'rotate-left', onSelect = function() setPed(nil) end },
    }
    for _, entry in ipairs(names) do
        options[#options + 1] = { title = entry.label or entry.name, icon = 'shirt', onSelect = function() applyWorldSkin(entry.name) end }
    end
    lib.registerContext({ id = 'unique_cw_skins', title = 'World outfits', menu = 'unique_cw_tools', options = options })
    lib.showContext('unique_cw_skins')
end

RegisterCommand('worldskin', function() openSkinMenu() end, false)

-- Admin: stand in the world wearing the outfit, then /saveworldskin <name>
RegisterCommand('saveworldskin', function(_, args)
    if currentWorld == 0 then return notify('Aval Vared Yek World Shavid.', 'error') end
    local name = table.concat(args, ' ')
    if name == '' then return notify('Usage: /saveworldskin <name>', 'error') end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local ok, why = lib.callback.await('unique_cw:skinSave', false, name, skin)
        if explain(ok, why) then notify(('Lebas "%s" Zakhire Shod.'):format(name), 'success') end
    end)
end, false)

local function openToolsContext()
    if currentWorld == 0 or not flags.menu then return notify('Shoma Dastresi Be In Komand Ra Dar in World Nadarid.', 'error') end

    local options = {}
    if flags.revive then options[#options + 1] = { title = 'Revive', icon = 'heart-pulse', onSelect = reviveSelf } end
    if flags.armor then options[#options + 1] = { title = 'Full armor', icon = 'shield', onSelect = fillArmor } end
    if flags.weapon then
        options[#options + 1] = { title = 'Give weapon', description = 'Removed when you leave the world', icon = 'gun', onSelect = giveWeapon }
        options[#options + 1] = { title = 'Refill ammo', icon = 'box', onSelect = refillAmmo }
    end
    if flags.vehicle then
        options[#options + 1] = { title = 'Spawn vehicle', icon = 'car', onSelect = function() spawnVehicle(nil, true) end }
        options[#options + 1] = { title = 'Fix vehicle', icon = 'wrench', onSelect = fixVehicle }
        options[#options + 1] = { title = 'Delete vehicle', icon = 'trash', onSelect = deleteVehicle }
    end
    if flags.tp then
        options[#options + 1] = { title = 'Teleport to waypoint', icon = 'location-dot', onSelect = teleportToWaypoint }
        options[#options + 1] = { title = 'Go to a player', icon = 'person-walking-arrow-right', onSelect = function() pickMember('Go to a player', 'goto') end }
        options[#options + 1] = { title = 'Bring a player', description = 'Admins and the owner of the world', icon = 'person-walking-arrow-loop-left', onSelect = function() pickMember('Bring a player', 'bring') end }
    end
    if flags.peds then options[#options + 1] = { title = 'Change ped', icon = 'user', onSelect = openPedMenu } end
    if flags.skins then options[#options + 1] = { title = 'World outfits', icon = 'shirt', onSelect = openSkinMenu } end
    options[#options + 1] = {
        title = 'Leave world', icon = 'door-open',
        onSelect = function() explain(lib.callback.await('unique_cw:leave', false)) end,
    }

    local title = currentLabel and ('World %d - %s'):format(currentWorld, currentLabel) or ('World %d'):format(currentWorld)
    lib.registerContext({ id = 'unique_cw_tools', title = title, options = options })
    lib.showContext('unique_cw_tools')
end

-- ---------------------------------------------------------------- ESX-style menu (same look as the old F9 menu)

local function openEsx(name, title, elements, onSubmit, onChange, onClose)
    esxMenu().Open('default', GetCurrentResourceName(), name, {
        title = title,
        align = 'top-left',
        elements = elements,
    }, function(data, menu)
        onSubmit(data.current, menu)
    end, function(_, menu)
        menu.close()
        if onClose then onClose() end
    end, onChange and function(data, menu)
        onChange(data.current, menu)
    end or nil)
end

local function askEsx(name, title, onValue)
    esxMenu().Open('dialog', GetCurrentResourceName(), name, { title = title }, function(data, menu)
        menu.close()
        local value = data.value
        if value and value ~= '' then onValue(value) end
    end, function(_, menu)
        menu.close()
    end)
end

openPedMenu = function()
    if not esxMenu() then return openPedMenuOx() end
    if not can('peds') then return end

    local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
    local categories = (static and static.peds) or CWConfig.Peds
    local elements = {}
    for ci, category in ipairs(categories) do
        elements[#elements + 1] = { label = category.label, value = ci }
    end

    openEsx('cw_peds', 'Ped Options', elements, function(current)
        local category = categories[current.value]
        local list = { { label = 'Default', value = 'default' } }
        for _, p in ipairs(category.list) do
            list[#list + 1] = { label = p.label, value = p.model }
        end
        openEsx('cw_peds_list', category.label, list, function(chosen)
            setPed(chosen.value ~= 'default' and chosen.value or nil)
        end, function(chosen)
            if chosen.value ~= 'default' and CWConfig.PedImageUrl then
                showPreview(CWConfig.PedImageUrl:format(chosen.value))
            else
                hidePreview()
            end
        end, hidePreview)
    end)
end

openSkinMenu = function()
    if not esxMenu() then return openSkinMenuOx() end
    if not can('skins') then return end
    local names = lib.callback.await('unique_cw:skinNames', false) or {}
    if #names == 0 then return notify('Hich Lebasi Baraye In World Zakhire Nashode Ast.', 'inform') end

    local elements = { { label = 'Default', value = false } }
    for _, entry in ipairs(names) do
        elements[#elements + 1] = { label = entry.label or entry.name, value = entry.name }
    end
    openEsx('cw_skins', 'Outfit Options', elements, function(current)
        if current.value then applyWorldSkin(current.value) else setPed(nil) end
    end)
end

local function openToolsClassic()
    if currentWorld == 0 or not flags.menu then return notify('Shoma Dastresi Be In Komand Ra Dar in World Nadarid.', 'error') end
    if not esxMenu() then return openToolsContext() end

    -- Same menu as the old F9 menu: ESX.UI.Menu "default", top-left, Main Menu -> Self / Vehicle / Weapon / Teleport.
    -- (A group is left out when that tool is switched off in the world.)
    local elements = {}
    if flags.revive or flags.armor then elements[#elements + 1] = { label = 'Self Options', value = 'self_options' } end
    if flags.vehicle then elements[#elements + 1] = { label = 'Vehicle Options', value = 'vehicle_options' } end
    if flags.weapon then elements[#elements + 1] = { label = 'Weapon Options', value = 'weapon_options' } end
    if flags.tp then elements[#elements + 1] = { label = 'Teleport Options', value = 'teleport_options' } end

    openEsx('main_menu', 'Main Menu', elements, function(current)
        local v = current.value
        if v == 'self_options' then
            local list = {}
            if flags.revive then list[#list + 1] = { label = 'Revive', value = 'revme' } end
            if flags.armor then list[#list + 1] = { label = 'Armor', value = 'armorme' } end
            openEsx('self_options_menu', 'Self Options', list, function(c)
                if c.value == 'revme' then reviveSelf() else fillArmor() end
            end)
        elseif v == 'vehicle_options' then
            openEsx('vehicle_options_menu', 'Vehicle Options', {
                { label = 'Spawn Vehicle', value = 'spawn_vehicle' },
                { label = 'Delete Vehicle', value = 'delete_vehicle' },
            }, function(c)
                if c.value == 'spawn_vehicle' then
                    askEsx('vehicle_name_input', 'Enter Vehicle Name', function(name) spawnVehicle(name) end)
                else
                    deleteVehicle()
                end
            end)
        elseif v == 'weapon_options' then
            openEsx('weapon_options_menu', 'Weapon Options', {
                { label = 'Get Max Ammo', value = 'cgetmaxammo' },
            }, function()
                refillAmmo()
            end)
        else
            openEsx('teleport_options_menu', 'Teleport Options', {
                { label = 'Teleport to Waypoint', value = 'teleport_waypoint' },
            }, function()
                teleportToWaypoint()
            end)
        end
    end)
end

-- ---------------------------------------------------------------- modern menu (NUI, html/changeworld)

local nuiOpen = false
local NAV = { stack = {} }   -- screens of the manager / shop (see "NUI screens" below)
local MGR = {}               -- action id -> function, for those screens

local function timeLeftText(expire)
    if not expire or expire <= 0 then return nil end
    local left = expire - GetCloudTimeAsInt()
    if left <= 0 then return 'expired' end
    if left >= 86400 then return ('%dd %dh left'):format(left // 86400, (left % 86400) // 3600) end
    return ('%dh %dm left'):format(left // 3600, (left % 3600) // 60)
end

updateBadge = function()
    if not CWConfig.ShowBadge then return end
    if currentWorld == 0 then
        SendNUIMessage({ cw = true, action = 'badge', show = false })
        return
    end
    SendNUIMessage({
        cw = true, action = 'badge', show = true, accent = CWConfig.Accent,
        text = ('World %d'):format(currentWorld),
        sub = currentLabel and (timeLeftText(currentExpire) and ('%s - %s'):format(currentLabel, timeLeftText(currentExpire)) or currentLabel)
            or timeLeftText(currentExpire) or '',
    })
end

-- keeps the "time left" of the badge fresh
CreateThread(function()
    while true do
        Wait(30000)
        if currentWorld ~= 0 and currentExpire > 0 then updateBadge() end
    end
end)

closeModern = function()
    if not nuiOpen then return end
    nuiOpen = false
    NAV.stack = {}
    SetNuiFocus(false, false)
    SendNUIMessage({ cw = true, action = 'close' })
end

-- ---------------------------------------------------------------- toggles + personal lists

-- Everything the menu switches on lives here and is switched off again when the player leaves the world.
local FX = {
    on = { god = false, stamina = false, run = false, jump = false, invisible = false, ragdoll = false, ammo = false },
    vehTires = {},   -- [vehicle] = true while its tyres are bullet proof
    vehGod = {},     -- [vehicle] = true while it cannot be damaged
    vehDoors = {},   -- [vehicle] = true while "open all doors" is on
    vehInt = {},     -- [vehicle] = true while the interior light is on
    frozen = false,  -- frozen by the host
    isHost = false,  -- may this player use the Host tab (asked once per menu open)
    recentVehicles = nil, recentPeds = nil, spots = nil, pins = nil,
}

local KVP = { vehicles = 'unique_cw_recent_vehicles', peds = 'unique_cw_recent_peds', spots = 'unique_cw_spots' }

local function kvpList(key)
    local raw = GetResourceKvpString(key)
    if not raw or raw == '' then return {} end
    local ok, value = pcall(json.decode, raw)
    return (ok and type(value) == 'table') and value or {}
end

local function recentList(kind)
    local field = kind == 'peds' and 'recentPeds' or 'recentVehicles'
    if not FX[field] then FX[field] = kvpList(KVP[kind]) end
    return FX[field]
end

local function remember(kind, value, max)
    value = tostring(value):lower()
    local list = recentList(kind)
    for i = #list, 1, -1 do
        if list[i] == value then table.remove(list, i) end
    end
    table.insert(list, 1, value)
    while #list > max do table.remove(list) end
    SetResourceKvp(KVP[kind], json.encode(list))
end

rememberVehicle = function(model) remember('vehicles', model, 6) end
rememberPed = function(model) remember('peds', model, 8) end

local function spotList()
    if not FX.spots then FX.spots = kvpList(KVP.spots) end
    return FX.spots
end

-- Actions that can be pinned to the Quick tab with F (simple one-click actions only: no toggles, prompts or lists).
local PINNABLE = {}
for _, id in ipairs({ 'revive', 'heal', 'clean', 'armor', 'armor_remove', 'spawn', 'vfix', 'vclean', 'vflip', 'vtune', 'vfuel', 'vdelete',
    'vpaint', 'vneoncolor', 'vtint', 'vxenon', 'vlivery', 'give', 'pack', 'ammo', 'wremove', 'tint', 'tpw', 'tpspawn',
    'time', 'time_reset', 'weather', 'weather_reset', 'emote', 'emote_stop', 'ped', 'ped_default', 'ped_random', 'qheal', 'qfix' }) do
    PINNABLE[id] = true
end

local function pinList()
    if not FX.pins then FX.pins = kvpList('unique_cw_pins') end
    return FX.pins
end

local function findPin(id, value)
    for i, p in ipairs(pinList()) do
        if p.id == id and tostring(p.value) == tostring(value) then return i end
    end
    return nil
end

-- marks the rows of a tab that can be pinned / are pinned
local function decorate(items)
    for _, it in ipairs(items) do
        if it.id and PINNABLE[it.id] and not it.prompt and it.toggle == nil and not it.disabled then
            it.pinnable = true
            if findPin(it.id, it.value) then it.pinned = true end
        end
    end
    return items
end

local function statsNow()
    local ped = PlayerPedId()
    local maxHp = GetEntityMaxHealth(ped)
    local health = 0
    if maxHp and maxHp > 100 then health = math.floor(((GetEntityHealth(ped) - 100) / (maxHp - 100)) * 100 + 0.5) end
    return { health = math.max(0, math.min(100, health)), armor = math.max(0, math.min(100, GetPedArmour(ped) or 0)) }
end

local function setFx(name, on)
    FX.on[name] = on and true or false
    local ped = PlayerPedId()
    if name == 'god' then
        SetEntityInvincible(ped, FX.on.god)
        SetPlayerInvincible(PlayerId(), FX.on.god)
    elseif name == 'run' then
        SetRunSprintMultiplierForPlayer(PlayerId(), FX.on.run and 1.49 or 1.0)
    elseif name == 'invisible' then
        SetEntityVisible(ped, not FX.on.invisible, false)
    elseif name == 'ragdoll' then
        SetPedCanRagdoll(ped, not FX.on.ragdoll)
    elseif name == 'ammo' then
        SetPedInfiniteAmmoClip(ped, FX.on.ammo)
    end
    -- stamina and super jump are applied every frame by the thread below
end

resetFx = function()
    for name, on in pairs(FX.on) do
        if on then setFx(name, false) end
    end
    NetworkClearClockTimeOverride()
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    for veh in pairs(FX.vehGod) do
        if DoesEntityExist(veh) then
            SetEntityInvincible(veh, false)
            SetVehicleCanBeVisiblyDamaged(veh, true)
        end
    end
    for veh in pairs(FX.vehTires) do
        if DoesEntityExist(veh) then SetVehicleTyresCanBurst(veh, true) end
    end
    FX.vehGod, FX.vehTires, FX.vehDoors, FX.vehInt = {}, {}, {}, {}
    if FX.frozen then
        FX.frozen = false
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then FreezeEntityPosition(veh, false) end
    end
end

-- every frame while stamina / super jump are on; once a second the rest is re-applied (respawn resets them)
CreateThread(function()
    while true do
        local sleep = 500
        if currentWorld ~= 0 and (FX.on.stamina or FX.on.jump) then
            sleep = 0
            if FX.on.stamina then RestorePlayerStamina(PlayerId(), 1.0) end
            if FX.on.jump then SetSuperJumpThisFrame(PlayerId()) end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if currentWorld ~= 0 then
            local ped = PlayerPedId()
            if FX.on.god then SetEntityInvincible(ped, true) SetPlayerInvincible(PlayerId(), true) end
            if FX.on.ragdoll then SetPedCanRagdoll(ped, false) end
            if FX.on.invisible then SetEntityVisible(ped, false, false) end
        end
    end
end)

-- ---------------------------------------------------------------- model of the menu

local function hexRgb(hex)
    local r, g, b = tostring(hex or ''):match('^#?(%x%x)(%x%x)(%x%x)$')
    if not r then return nil end
    return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

local function currentVeh()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then return veh end
    return nil
end

local function worldList(field)
    local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
    return (static and static[field]) or CWConfig[field == 'teleports' and 'Teleports' or field]
end

local function teleportItems()
    local items = {
        { id = 'tpw', label = 'Teleport to waypoint', desc = 'Set a waypoint on the map first', icon = 'pin' },
    }
    if currentSpawn then
        items[#items + 1] = { id = 'tpspawn', label = 'Go to the spawn point', icon = 'flag' }
    end
    items[#items + 1] = { id = 'tpcoords', label = 'Teleport to coordinates', desc = 'x y z', icon = 'compass',
        prompt = { title = 'Teleport to coordinates', placeholder = 'x y z  (e.g. 215.4 -810.2 30.7)' } }

    local places = worldList('teleports') or {}
    if #places > 0 then
        items[#items + 1] = { section = 'Places' }
        for i, p in ipairs(places) do
            items[#items + 1] = { id = 'tpplace', label = p.label, value = i, icon = 'crosshair' }
        end
    end

    items[#items + 1] = { section = 'My spots' }
    items[#items + 1] = { id = 'spot_save', label = 'Save this spot', desc = 'Bookmark where you stand', icon = 'save',
        prompt = { title = 'Save this spot', placeholder = 'Name (max 24 letters)' } }
    for i, s in ipairs(spotList()) do
        items[#items + 1] = { id = 'tpspot', alt = 'spot_del', label = s.name, desc = 'Enter = go there  -  Del = remove', value = i, icon = 'bookmark' }
    end
    return items
end

local function vehicleItems()
    local veh = currentVeh()
    local items = {
        { id = 'spawn', label = 'Spawn vehicle', desc = 'Type a model name', icon = 'plus',
          prompt = { title = 'Spawn vehicle', placeholder = 'e.g. sultan' } },
    }

    local recents = recentList('vehicles')
    if #recents > 0 then
        items[#items + 1] = { section = 'Recent' }
        for _, model in ipairs(recents) do
            items[#items + 1] = { id = 'spawn', label = model, value = model, icon = 'history' }
        end
    end

    items[#items + 1] = { section = 'Quick spawn' }
    for _, model in ipairs(CWConfig.QuickVehicles or {}) do
        items[#items + 1] = { id = 'spawn', label = model, value = model, icon = 'car' }
    end

    items[#items + 1] = { section = 'Current vehicle' }
    items[#items + 1] = { id = 'vfix', label = 'Fix', desc = 'Repair body and engine', icon = 'wrench' }
    items[#items + 1] = { id = 'vclean', label = 'Wash', icon = 'sparkle' }
    items[#items + 1] = { id = 'vflip', label = 'Flip upright', icon = 'refresh' }
    items[#items + 1] = { id = 'vtune', label = 'Max tuning', desc = 'Performance mods + turbo', icon = 'bolt' }
    items[#items + 1] = { id = 'vengine', label = 'Engine', icon = 'power', toggle = veh and GetIsVehicleEngineRunning(veh) and true or false }
    items[#items + 1] = { id = 'vlock', label = 'Doors locked', icon = 'lock', toggle = veh and (GetVehicleDoorLockStatus(veh) or 0) >= 2 or false }
    items[#items + 1] = { id = 'vneon', label = 'Neon lights', icon = 'bulb', toggle = veh and IsVehicleNeonLightEnabled(veh, 0) and true or false }
    items[#items + 1] = { id = 'vtires', label = 'Bullet proof tyres', icon = 'tire', toggle = veh and FX.vehTires[veh] and true or false }
    if flags.extras then
        items[#items + 1] = { id = 'vgod', label = 'Indestructible', desc = 'Cannot be damaged', icon = 'shield', toggle = veh and FX.vehGod[veh] and true or false }
    end
    items[#items + 1] = { id = 'vfuel', label = 'Refuel', desc = 'Fill the tank', icon = 'gauge' }
    items[#items + 1] = { id = 'vplate', label = 'Plate text', desc = 'Up to 8 letters or numbers', icon = 'edit',
        prompt = { title = 'Plate text', placeholder = 'e.g. EVENT 01' } }
    items[#items + 1] = { id = 'vdoors', label = 'Open all doors', icon = 'door', toggle = veh and FX.vehDoors[veh] and true or false }
    items[#items + 1] = { id = 'vint', label = 'Interior light', icon = 'bulb', toggle = veh and FX.vehInt[veh] and true or false }
    items[#items + 1] = { id = 'vlivery', label = 'Next livery', desc = 'If the vehicle has liveries', icon = 'paint' }
    items[#items + 1] = { id = 'vdelete', label = 'Delete', icon = 'trash', danger = true }

    items[#items + 1] = { section = 'Paint' }
    for _, c in ipairs(CWConfig.VehicleColors or {}) do
        items[#items + 1] = { id = 'vpaint', label = c.label, value = c.color, swatch = c.color }
    end
    items[#items + 1] = { section = 'Neon colour' }
    for _, c in ipairs(CWConfig.VehicleColors or {}) do
        items[#items + 1] = { id = 'vneoncolor', label = c.label, value = c.color, swatch = c.color }
    end
    items[#items + 1] = { section = 'Window tint' }
    for _, t in ipairs(CWConfig.WindowTints or {}) do
        items[#items + 1] = { id = 'vtint', label = t[1], value = t[2], icon = 'eye' }
    end
    items[#items + 1] = { section = 'Headlights' }
    for _, h in ipairs(CWConfig.HeadlightColors or {}) do
        items[#items + 1] = { id = 'vxenon', label = h[1], value = h[2], icon = 'bulb' }
    end
    return items
end

local function weaponItems()
    local items = {
        { id = 'give', label = 'Give weapon', desc = 'Type a weapon name', icon = 'plus',
          prompt = { title = 'Give weapon', placeholder = 'e.g. WEAPON_PISTOL' } },
    }
    if #(CWConfig.WeaponPacks or {}) > 0 then
        items[#items + 1] = { section = 'Packs' }
        for i, pack in ipairs(CWConfig.WeaponPacks) do
            items[#items + 1] = { id = 'pack', label = pack.label, desc = ('%d weapons'):format(#pack.weapons), value = i, icon = 'box' }
        end
    end
    items[#items + 1] = { section = 'Quick weapons' }
    for _, name in ipairs(CWConfig.QuickWeapons or {}) do
        items[#items + 1] = { id = 'give', label = (name:gsub('^WEAPON_', '')), value = name, icon = 'gun' }
    end
    items[#items + 1] = { section = 'Ammo' }
    items[#items + 1] = { id = 'ammo', label = 'Get max ammo', desc = '+250 for the weapon in your hand', icon = 'box' }
    items[#items + 1] = { id = 'ammo_inf', label = 'Infinite ammo', desc = 'No reloading', icon = 'infinity', toggle = FX.on.ammo }
    items[#items + 1] = { section = 'Weapon tint' }
    local tints = { 'Default', 'Green', 'Gold', 'Pink', 'Army', 'LSPD', 'Orange', 'Platinum' }
    for i, label in ipairs(tints) do
        items[#items + 1] = { id = 'tint', label = label, value = i - 1, icon = 'palette' }
    end
    items[#items + 1] = { section = 'Clean up' }
    items[#items + 1] = { id = 'wremove', label = 'Remove world weapons', desc = 'Only the ones this world gave you', icon = 'trash', danger = true }
    return items
end

local function funItems()
    local items = {
        { section = 'You' },
        { id = 'fx_god', label = 'God mode', desc = 'Cannot be hurt', icon = 'shield', toggle = FX.on.god },
        { id = 'fx_stamina', label = 'Infinite stamina', icon = 'bolt', toggle = FX.on.stamina },
        { id = 'fx_run', label = 'Super run', icon = 'run', toggle = FX.on.run },
        { id = 'fx_jump', label = 'Super jump', icon = 'jump', toggle = FX.on.jump },
        { id = 'fx_ragdoll', label = 'No ragdoll', desc = 'Stay on your feet', icon = 'user', toggle = FX.on.ragdoll },
        { id = 'fx_invisible', label = 'Invisible', icon = 'eyeoff', toggle = FX.on.invisible },
        { section = 'Time (only for you)' },
    }
    for _, t in ipairs(CWConfig.TimePresets or {}) do
        items[#items + 1] = { id = 'time', label = t.label, value = t.hour, icon = (t.hour >= 19 or t.hour < 5) and 'moon' or 'sun' }
    end
    items[#items + 1] = { id = 'time_reset', label = 'Reset time', icon = 'refresh' }
    items[#items + 1] = { section = 'Weather (only for you)' }
    for _, w in ipairs(CWConfig.WeatherTypes or {}) do
        local icon = (w.type == 'RAIN' or w.type == 'THUNDER') and 'rain' or ((w.type == 'CLOUDS' or w.type == 'OVERCAST' or w.type == 'FOGGY' or w.type == 'XMAS') and 'cloud' or 'sun')
        items[#items + 1] = { id = 'weather', label = w.label, value = w.type, icon = icon }
    end
    items[#items + 1] = { id = 'weather_reset', label = 'Reset weather', icon = 'refresh' }
    if #(CWConfig.Emotes or {}) > 0 then
        items[#items + 1] = { section = 'Emotes' }
        for _, e in ipairs(CWConfig.Emotes) do
            items[#items + 1] = { id = 'emote', label = e[1], value = e[2], icon = 'user' }
        end
        items[#items + 1] = { id = 'emote_stop', label = 'Stop emote', icon = 'close' }
    end
    return items
end

local function pedItems()
    local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
    local categories = (static and static.peds) or CWConfig.Peds
    local items = {
        { id = 'ped_default', label = 'My own ped', desc = 'Back to your character', icon = 'user' },
        { id = 'ped_random', label = 'Random ped', desc = 'Surprise me', icon = 'dice' },
    }
    local recents = recentList('peds')
    if #recents > 0 then
        items[#items + 1] = { section = 'Recent' }
        for _, model in ipairs(recents) do
            items[#items + 1] = {
                id = 'ped', label = model, value = model, icon = 'history',
                preview = CWConfig.PedImageUrl and CWConfig.PedImageUrl:format(model) or nil,
            }
        end
    end
    for _, category in ipairs(categories) do
        items[#items + 1] = { section = category.label }
        for _, p in ipairs(category.list) do
            items[#items + 1] = {
                id = 'ped', label = p.label, value = p.model, icon = 'ped',
                preview = CWConfig.PedImageUrl and CWConfig.PedImageUrl:format(p.model) or nil,
            }
        end
    end
    return items
end

local function hostItems()
    return {
        { id = 'h_announce', label = 'Announce', desc = 'A banner for everybody in the world', icon = 'send',
          prompt = { title = 'Announcement', placeholder = 'Message (max 120 letters)' } },
        { section = 'Countdown' },
        { id = 'h_countdown', label = '3 seconds', value = 3, icon = 'clock' },
        { id = 'h_countdown', label = '5 seconds', value = 5, icon = 'clock' },
        { id = 'h_countdown', label = '10 seconds', value = 10, icon = 'clock' },
        { section = 'Everybody in the world' },
        { id = 'h_revive_all', label = 'Revive all', icon = 'heart' },
        { id = 'h_heal_all', label = 'Heal all', icon = 'heart' },
        { id = 'h_armor_all', label = 'Armor all', icon = 'shield' },
        { id = 'h_bring_all', label = 'Bring all to me', icon = 'users' },
        { id = 'h_freeze_all', label = 'Freeze all', desc = 'Everybody but you', icon = 'lock' },
        { id = 'h_unfreeze_all', label = 'Unfreeze all', icon = 'key' },
    }
end

local function quickItems()
    local quick = {}
    local pins = pinList()
    if #pins > 0 then
        quick[#quick + 1] = { section = 'Pinned' }
        for _, p in ipairs(pins) do
            quick[#quick + 1] = { id = p.id, value = p.value, label = p.label, icon = p.icon or 'star' }
        end
        quick[#quick + 1] = { section = 'Quick' }
    end
    if flags.revive or flags.armor then
        quick[#quick + 1] = { id = 'qheal', label = 'Heal everything', desc = 'Health and armor', icon = 'heart' }
    end
    if flags.vehicle then
        quick[#quick + 1] = { id = 'qfix', label = 'Fix and wash vehicle', icon = 'wrench' }
        local last = recentList('vehicles')[1]
        if last then quick[#quick + 1] = { id = 'spawn', label = ('Spawn again: %s'):format(last), value = last, icon = 'history' } end
    end
    if flags.weapon then quick[#quick + 1] = { id = 'ammo', label = 'Get max ammo', icon = 'box' } end
    if flags.tp then quick[#quick + 1] = { id = 'tpw', label = 'Teleport to waypoint', icon = 'pin' } end
    return decorate(quick)
end

local function buildModel()
    local tabs = {}

    -- Quick: pinned actions + the things you reach for most -------------------
    local quick = quickItems()
    if #quick > 0 then tabs[#tabs + 1] = { id = 'quick', label = 'Quick', icon = 'star', items = quick } end

    -- Self -------------------------------------------------------------------
    if flags.revive or flags.armor then
        local items = {}
        if flags.revive then
            items[#items + 1] = { id = 'revive', label = 'Revive', desc = 'Bring yourself back', icon = 'heart' }
            items[#items + 1] = { id = 'heal', label = 'Heal', desc = 'Fill your health', icon = 'heart' }
            items[#items + 1] = { id = 'clean', label = 'Clean ped', desc = 'Remove blood and dirt', icon = 'eraser' }
        end
        if flags.armor then
            items[#items + 1] = { id = 'armor', label = 'Full armor', desc = 'Armor to 100', icon = 'shield' }
            items[#items + 1] = { id = 'armor_remove', label = 'Remove armor', icon = 'minus' }
        end
        tabs[#tabs + 1] = { id = 'self', label = 'Self', icon = 'user', items = items }
    end

    if flags.vehicle then tabs[#tabs + 1] = { id = 'vehicle', label = 'Vehicle', icon = 'car', items = vehicleItems() } end
    if flags.weapon then tabs[#tabs + 1] = { id = 'weapons', label = 'Weapons', icon = 'gun', items = weaponItems() } end

    if flags.tp then
        tabs[#tabs + 1] = { id = 'teleport', label = 'Teleport', icon = 'pin', items = teleportItems() }
        tabs[#tabs + 1] = { id = 'players', label = 'Players', icon = 'users', dynamic = 'members', searchable = true, emptyText = 'Nobody else is in this world' }
    end

    if flags.extras then tabs[#tabs + 1] = { id = 'fun', label = 'Fun', icon = 'sparkle', items = funItems() } end
    if flags.host and FX.isHost then tabs[#tabs + 1] = { id = 'host', label = 'Host', icon = 'crown', items = hostItems() } end

    if flags.peds then
        tabs[#tabs + 1] = { id = 'peds', label = 'Peds', icon = 'ped', searchable = true, preview = CWConfig.PedImageUrl ~= nil, items = pedItems() }
    end
    if flags.skins then
        tabs[#tabs + 1] = { id = 'outfits', label = 'Outfits', icon = 'shirt', dynamic = 'outfits', emptyText = 'This world has no saved outfits' }
    end

    -- World ------------------------------------------------------------------
    local info = {
        { id = 'info', label = ('World %d'):format(currentWorld), desc = currentLabel or 'No name', icon = 'globe', disabled = true },
    }
    local left = timeLeftText(currentExpire)
    if left then info[#info + 1] = { id = 'info', label = left, desc = 'Ends automatically', icon = 'clock', disabled = true } end
    info[#info + 1] = { id = 'leave', label = 'Leave world', desc = 'Go back to the main world', icon = 'door', danger = true }
    tabs[#tabs + 1] = { id = 'world', label = 'World', icon = 'globe', items = info }

    for _, tab in ipairs(tabs) do
        if tab.items and tab.id ~= 'quick' then decorate(tab.items) end
    end

    return {
        title = 'Main Menu',
        subtitle = currentLabel and ('World %d - %s'):format(currentWorld, currentLabel) or ('World %d'):format(currentWorld),
        accent = CWConfig.Accent,
        icon = 'globe',
        stats = statsNow(),
        tabs = tabs,
    }
end

local function openModern()
    if currentWorld == 0 or not flags.menu then
        return notify('Shoma Dastresi Be In Komand Ra Dar in World Nadarid.', 'error')
    end
    FX.isHost = flags.host and lib.callback.await('unique_cw:hostInfo', false) == true or false
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ cw = true, action = 'open', model = buildModel() })
end

-- ---------------------------------------------------------------- actions

local function parseCoords(text)
    local nums = {}
    for n in tostring(text):gmatch('[%-%d%.]+') do nums[#nums + 1] = tonumber(n) end
    if #nums < 3 then return nil end
    for i = 1, 3 do
        if not nums[i] or nums[i] ~= nums[i] or nums[i] < -10000 or nums[i] > 10000 then return nil end
    end
    return { x = nums[1] + 0.0, y = nums[2] + 0.0, z = nums[3] + 0.0 }
end

local function needVehicle(feature)
    if not can(feature) then return nil end
    local veh = currentVeh()
    if not veh then notify('Shoma Dar Hich Mashini Nistid.', 'error') end
    return veh
end

local function cleanVehicle()
    local veh = needVehicle('vehicle')
    if not veh then return end
    SetVehicleDirtLevel(veh, 0.0)
    WashDecalsFromVehicle(veh, 1.0)
end

local function flipVehicle()
    local veh = needVehicle('vehicle')
    if veh then SetVehicleOnGroundProperly(veh) end
end

local function tuneVehicle()
    local veh = needVehicle('vehicle')
    if not veh then return end
    SetVehicleModKit(veh, 0)
    for _, modType in ipairs({ 11, 12, 13, 15, 16 }) do   -- engine, brakes, transmission, suspension, armor
        local count = GetNumVehicleMods(veh, modType)
        if count and count > 0 then SetVehicleMod(veh, modType, count - 1, false) end
    end
    ToggleVehicleMod(veh, 18, true)   -- turbo
    notify('Mashin Shoma Tune Shod!', 'success')
end

local function healSelf()
    if not can('revive') then return end
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
end

local function cleanSelf()
    if not can('revive') then return end
    local ped = PlayerPedId()
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
end

local function removeArmor()
    if not can('armor') then return end
    SetPedArmour(PlayerPedId(), 0)
end

local function teleportTo(coords)
    if not can('tp') then return end
    fade(300, true)
    moveTo(coords)
    fade(300, false)
end

local function toggleFx(name, feature)
    if not can(feature) then return false end
    setFx(name, not FX.on[name])
    return false, { toggle = FX.on[name] }
end

local function savedSpotsReply(toast)
    return false, { items = teleportItems(), toast = toast }
end

local function weaponInHand()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if weapon == joaat('WEAPON_UNARMED') then return nil end
    return ped, weapon
end

-- host tools: the server decides who may do this (admin, owner of the world, streamer group)
local function hostCall(action, arg, toast, extra)
    if not flags.host then return false end
    local ok, why = lib.callback.await('unique_cw:host', false, action, arg)
    explain(ok, why)
    if not ok then return false end
    local reply = { toast = toast or 'Done' }
    if extra then for k, x in pairs(extra) do reply[k] = x end end
    return false, reply
end

-- every id the menu can send -> what it does.
-- returns: closeMenu?, extra   (extra is merged into the answer: toggle / items / toast)
local ACTIONS = {
    -- quick
    qheal        = function()
        if flags.revive then healSelf() end
        if flags.armor then fillArmor() end
    end,
    qfix         = function() fixVehicle() cleanVehicle() end,

    -- self
    revive       = function() reviveSelf() end,
    heal         = function() healSelf() end,
    clean        = function() cleanSelf() end,
    armor        = function() fillArmor() end,
    armor_remove = function() removeArmor() end,

    -- vehicle
    spawn        = function(v) spawnVehicle(v) return true end,
    vfix         = function() fixVehicle() end,
    vclean       = function() cleanVehicle() end,
    vflip        = function() flipVehicle() end,
    vtune        = function() tuneVehicle() end,
    vdelete      = function() deleteVehicle() end,
    vengine      = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local on = not GetIsVehicleEngineRunning(veh)
        SetVehicleEngineOn(veh, on, true, true)
        return false, { toggle = on }
    end,
    vlock        = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local locked = (GetVehicleDoorLockStatus(veh) or 0) >= 2
        SetVehicleDoorsLocked(veh, locked and 1 or 2)
        return false, { toggle = not locked }
    end,
    vneon        = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local on = not IsVehicleNeonLightEnabled(veh, 0)
        for side = 0, 3 do SetVehicleNeonLightEnabled(veh, side, on) end
        return false, { toggle = on }
    end,
    vtires       = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local on = not FX.vehTires[veh]
        FX.vehTires[veh] = on or nil
        SetVehicleTyresCanBurst(veh, not on)
        return false, { toggle = on }
    end,
    vgod         = function()
        local veh = needVehicle('extras')
        if not veh then return false end
        local on = not FX.vehGod[veh]
        FX.vehGod[veh] = on or nil
        SetEntityInvincible(veh, on)
        SetVehicleCanBeVisiblyDamaged(veh, not on)
        return false, { toggle = on }
    end,
    vfuel        = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        if GetResourceState('LegacyFuel') == 'started' then
            pcall(function() exports['LegacyFuel']:SetFuel(veh, 100.0) end)
        end
        SetVehicleFuelLevel(veh, 100.0)
        notify('Baak Por Shod!', 'success')
    end,
    vplate       = function(v)
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local text = tostring(v or ''):upper():gsub('[^A-Z0-9 ]', ''):sub(1, 8)
        if text == '' then return notify('Voroodi Eshtebah Ast.', 'error') end
        SetVehicleNumberPlateText(veh, text)
    end,
    vdoors       = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local on = not FX.vehDoors[veh]
        FX.vehDoors[veh] = on or nil
        for door = 0, 5 do
            if on then SetVehicleDoorOpen(veh, door, false, false) else SetVehicleDoorShut(veh, door, false) end
        end
        return false, { toggle = on }
    end,
    vint         = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local on = not FX.vehInt[veh]
        FX.vehInt[veh] = on or nil
        SetVehicleInteriorlight(veh, on)
        return false, { toggle = on }
    end,
    vlivery      = function()
        local veh = needVehicle('vehicle')
        if not veh then return false end
        local count = GetVehicleLiveryCount(veh)
        if not count or count <= 0 then return false, { toast = 'This vehicle has no liveries', error = true } end
        local index = ((GetVehicleLivery(veh) or 0) + 1) % count
        SetVehicleLivery(veh, index)
        return false, { toast = ('Livery %d / %d'):format(index + 1, count) }
    end,
    vtint        = function(v)
        local veh = needVehicle('vehicle')
        if not veh then return false end
        for _, t in ipairs(CWConfig.WindowTints or {}) do
            if t[2] == tonumber(v) then SetVehicleWindowTint(veh, t[2]) return end
        end
    end,
    vxenon       = function(v)
        local veh = needVehicle('vehicle')
        if not veh then return false end
        for _, h in ipairs(CWConfig.HeadlightColors or {}) do
            if h[2] == tonumber(v) then
                ToggleVehicleMod(veh, 22, true)
                SetVehicleXenonLightsColour(veh, h[2])
                return
            end
        end
    end,
    vpaint       = function(v)
        local veh = needVehicle('vehicle')
        local r, g, b = hexRgb(v)
        if not veh or not r then return end
        SetVehicleCustomPrimaryColour(veh, r, g, b)
        SetVehicleCustomSecondaryColour(veh, r, g, b)
    end,
    vneoncolor   = function(v)
        local veh = needVehicle('vehicle')
        local r, g, b = hexRgb(v)
        if not veh or not r then return end
        SetVehicleNeonLightsColour(veh, r, g, b)
        for side = 0, 3 do SetVehicleNeonLightEnabled(veh, side, true) end
    end,

    -- weapons
    give         = function(v) giveWeapon(v, CWConfig.DefaultWeaponAmmo) end,
    pack         = function(v)
        local pack = (CWConfig.WeaponPacks or {})[tonumber(v) or 0]
        if not pack or not can('weapon') then return end
        local given = 0
        for _, name in ipairs(pack.weapons) do
            if giveWeapon(name, CWConfig.DefaultWeaponAmmo, true) then given = given + 1 end
        end
        notify(('%d Aslahe Be Shoma Dade Shod!'):format(given), 'success')
    end,
    ammo         = function() refillAmmo() end,
    ammo_inf     = function() return toggleFx('ammo', 'weapon') end,
    tint         = function(v)
        if not can('weapon') then return end
        local ped, weapon = weaponInHand()
        local index = math.floor(tonumber(v) or -1)
        if not ped then return notify('Shoma Hich Aslahe Darid!', 'error') end
        if index < 0 or index > 7 then return end
        SetPedWeaponTintIndex(ped, weapon, index)
    end,
    wremove      = function() removeWorldWeapons() notify('World weapons removed.', 'success') end,

    -- teleport
    tpw          = function() teleportToWaypoint() return true end,
    tpspawn      = function() if currentSpawn then teleportTo(currentSpawn) end return true end,
    tpcoords     = function(v)
        local c = parseCoords(v)
        if not c then return notify('Mokhtasat Eshtebah Ast.', 'error') end
        teleportTo(c)
        return true
    end,
    tpplace      = function(v)
        local place = (worldList('teleports') or {})[tonumber(v) or 0]
        if not place then return end
        teleportTo({ x = place.x + 0.0, y = place.y + 0.0, z = place.z + 0.0, h = place.h })
        return true
    end,
    tpspot       = function(v)
        local spot = spotList()[tonumber(v) or 0]
        if not spot then return end
        teleportTo({ x = spot.x, y = spot.y, z = spot.z, h = spot.h })
        return true
    end,
    spot_save    = function(v)
        local name = tostring(v or ''):gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 24)
        if name == '' then return false end
        local list = spotList()
        for i = #list, 1, -1 do
            if list[i].name == name then table.remove(list, i) end
        end
        if #list >= (CWConfig.MaxSavedSpots or 12) then
            notify('Be Hadde Majaz Residid.', 'error')
            return false
        end
        local ped = PlayerPedId()
        local c = GetEntityCoords(ped)
        list[#list + 1] = {
            name = name,
            x = math.floor(c.x * 100 + 0.5) / 100, y = math.floor(c.y * 100 + 0.5) / 100, z = math.floor(c.z * 100 + 0.5) / 100,
            h = math.floor(GetEntityHeading(ped) * 10 + 0.5) / 10,
        }
        SetResourceKvp(KVP.spots, json.encode(list))
        return savedSpotsReply('Saved')
    end,
    spot_del     = function(v)
        local list = spotList()
        local index = tonumber(v) or 0
        if not list[index] then return false end
        table.remove(list, index)
        SetResourceKvp(KVP.spots, json.encode(list))
        return savedSpotsReply('Removed')
    end,
    ['goto']     = function(v) explain(lib.callback.await('unique_cw:goto', false, tonumber(v))) return true end,
    bring        = function(v) explain(lib.callback.await('unique_cw:bring', false, tonumber(v))) return true end,

    -- fun (needs the world's `extras` tool)
    fx_god       = function() return toggleFx('god', 'extras') end,
    fx_stamina   = function() return toggleFx('stamina', 'extras') end,
    fx_run       = function() return toggleFx('run', 'extras') end,
    fx_jump      = function() return toggleFx('jump', 'extras') end,
    fx_ragdoll   = function() return toggleFx('ragdoll', 'extras') end,
    fx_invisible = function() return toggleFx('invisible', 'extras') end,
    time         = function(v)
        local hour = tonumber(v)
        if not can('extras') or not hour or hour < 0 or hour > 23 then return end
        NetworkOverrideClockTime(math.floor(hour), 0, 0)
    end,
    time_reset   = function() if can('extras') then NetworkClearClockTimeOverride() end end,
    weather      = function(v)
        if not can('extras') then return end
        for _, w in ipairs(CWConfig.WeatherTypes or {}) do
            if w.type == v then   -- only the types listed in the config
                ClearOverrideWeather()
                ClearWeatherTypePersist()
                SetWeatherTypePersist(v)
                SetWeatherTypeNow(v)
                SetWeatherTypeNowPersist(v)
                SetOverrideWeather(v)
                return
            end
        end
    end,
    weather_reset = function()
        if not can('extras') then return end
        ClearOverrideWeather()
        ClearWeatherTypePersist()
    end,

    -- peds / outfits
    ped          = function(v) setPed(v) end,
    ped_default  = function() setPed(nil) end,
    ped_random   = function()
        local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
        local categories = (static and static.peds) or CWConfig.Peds
        local pool = {}
        for _, category in ipairs(categories) do
            for _, p in ipairs(category.list) do pool[#pool + 1] = p.model end
        end
        if #pool > 0 then setPed(pool[math.random(1, #pool)]) end
    end,
    outfit       = function(v) applyWorldSkin(v) end,
    outfit_default = function() setPed(nil) end,

    emote        = function(v)
        if not can('extras') then return false end
        for _, e in ipairs(CWConfig.Emotes or {}) do
            if e[2] == v then
                TaskStartScenarioInPlace(PlayerPedId(), v, 0, true)
                return true
            end
        end
    end,
    emote_stop   = function() ClearPedTasks(PlayerPedId()) end,

    -- host (events)
    h_announce     = function(v) return hostCall('announce', v, 'Sent') end,
    h_countdown    = function(v) return hostCall('countdown', tonumber(v), 'Sent') end,
    h_revive_all   = function() return hostCall('revive_all') end,
    h_heal_all     = function() return hostCall('heal_all') end,
    h_armor_all    = function() return hostCall('armor_all') end,
    h_bring_all    = function() return hostCall('bring_all') end,
    h_freeze_all   = function() return hostCall('freeze_all') end,
    h_unfreeze_all = function() return hostCall('unfreeze_all') end,
    p_revive       = function(v) return hostCall('revive', tonumber(v)) end,
    p_heal         = function(v) return hostCall('heal', tonumber(v)) end,
    p_armor        = function(v) return hostCall('armor', tonumber(v)) end,
    p_freeze       = function(v) return hostCall('freeze', tonumber(v)) end,
    p_unfreeze     = function(v) return hostCall('unfreeze', tonumber(v)) end,
    p_kick         = function(v) return hostCall('kick', tonumber(v), 'Done', { refresh = true }) end,

    leave        = function() explain(lib.callback.await('unique_cw:leave', false)) return true end,
}

RegisterNUICallback('cw_action', function(data, cb)
    local id = type(data) == 'table' and data.id
    local isScreen = type(data) == 'table' and data.ns == 'mgr'
    local handler = type(id) == 'string' and (isScreen and MGR[id] or (not isScreen and ACTIONS[id]))
    -- the tools menu only works inside a world; the manager / shop screens work in the main world
    if not handler or (not isScreen and currentWorld == 0) then return cb({}) end
    if isScreen and #NAV.stack == 0 then return cb({}) end

    local value = data.value
    if type(value) == 'string' then value = value:sub(1, 120) end
    local close, extra = handler(value)
    if close then closeModern() end

    local reply = { close = close and true or false }
    if type(extra) == 'table' then
        for k, x in pairs(extra) do reply[k] = x end
    end
    if not isScreen then reply.stats = statsNow() end
    cb(reply)
end)

RegisterNUICallback('cw_fetch', function(data, cb)
    if currentWorld == 0 or type(data) ~= 'table' then return cb({ items = {} }) end

    if data.what == 'members' then
        if not flags.tp then return cb({ items = {} }) end
        local members, canBring, isHost = lib.callback.await('unique_cw:members', false)
        local items = {}
        for _, m in ipairs(members or {}) do
            local who = ('%s [%d]'):format(m.name, m.id)
            if isHost then
                -- hosts get a block of tools per player (the rows carry the name so the search finds them)
                items[#items + 1] = { section = who }
                items[#items + 1] = { id = 'goto', label = 'Go to', desc = who, value = m.id, icon = 'walk' }
                items[#items + 1] = { id = 'bring', label = 'Bring', desc = who, value = m.id, icon = 'users' }
                items[#items + 1] = { id = 'p_revive', label = 'Revive', desc = who, value = m.id, icon = 'heart' }
                items[#items + 1] = { id = 'p_heal', label = 'Heal', desc = who, value = m.id, icon = 'heart' }
                items[#items + 1] = { id = 'p_armor', label = 'Armor', desc = who, value = m.id, icon = 'shield' }
                items[#items + 1] = { id = 'p_freeze', label = 'Freeze', desc = who, value = m.id, icon = 'lock' }
                items[#items + 1] = { id = 'p_unfreeze', label = 'Unfreeze', desc = who, value = m.id, icon = 'key' }
                items[#items + 1] = { id = 'p_kick', label = 'Kick from the world', desc = who, value = m.id, icon = 'door', danger = true }
            else
                items[#items + 1] = { id = 'goto', label = who, desc = 'Teleport to this player', value = m.id, icon = 'walk' }
                if canBring ~= false then
                    items[#items + 1] = { id = 'bring', label = who, desc = 'Bring this player to you', value = m.id, icon = 'users' }
                end
            end
        end
        return cb({ items = items })
    end

    if data.what == 'outfits' then
        if not flags.skins then return cb({ items = {} }) end
        local names = lib.callback.await('unique_cw:skinNames', false) or {}
        local items = { { id = 'outfit_default', label = 'My own outfit', icon = 'user' } }
        for _, entry in ipairs(names) do
            items[#items + 1] = { id = 'outfit', label = entry.label or entry.name, value = entry.name, icon = 'shirt' }
        end
        return cb({ items = #items > 1 and items or {} })
    end

    cb({ items = {} })
end)

RegisterNUICallback('cw_close', function(_, cb)
    NAV.stack = {}
    if nuiOpen then
        nuiOpen = false
        SetNuiFocus(false, false)
    end
    cb({})
end)

-- F on a row pins it to the Quick tab (or unpins it)
RegisterNUICallback('cw_pin', function(data, cb)
    if type(data) ~= 'table' or currentWorld == 0 or data.ns == 'mgr' then return cb({}) end
    local id = data.id
    if type(id) ~= 'string' or not PINNABLE[id] then return cb({}) end

    local value = data.value
    if type(value) == 'string' then value = value:sub(1, 120)
    elseif value ~= nil and type(value) ~= 'number' then return cb({}) end
    local label = type(data.label) == 'string' and data.label:sub(1, 40) or id
    local icon = (type(data.icon) == 'string' and #data.icon <= 12 and data.icon:match('^[a-z]+$')) and data.icon or 'star'

    local pins = pinList()
    local index = findPin(id, value)
    local pinned
    if index then
        table.remove(pins, index)
        pinned = false
    else
        if #pins >= 12 then return cb({ toast = 'Be Hadde Majaz Residid.', error = true }) end
        pins[#pins + 1] = { id = id, value = value, label = label, icon = icon }
        pinned = true
    end
    SetResourceKvp('unique_cw_pins', json.encode(pins))
    cb({ toast = pinned and 'Pinned to Quick' or 'Unpinned', pin = { id = id, value = value, pinned = pinned }, tabItems = { quick = quickItems() } })
end)

-- sent by the host tools (server -> every player of the world)
RegisterNetEvent('unique_cw:client:heal', function()
    if currentWorld == 0 then return end
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    notify('Salamat Shoma Por Shod!', 'success')
end)

RegisterNetEvent('unique_cw:client:armor', function()
    if currentWorld == 0 then return end
    AddArmourToPed(PlayerPedId(), 100)
    notify('Armor Shoma Por Shod!', 'success')
end)

RegisterNetEvent('unique_cw:client:freeze', function(state)
    if currentWorld == 0 then return end
    FX.frozen = state and true or false
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, FX.frozen)
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then FreezeEntityPosition(veh, FX.frozen) end
    notify(FX.frozen and 'Shoma Freeze Shodid!' or 'Shoma Azad Shodid!', FX.frozen and 'error' or 'success')
end)

RegisterNetEvent('unique_cw:client:announce', function(text, from)
    if currentWorld == 0 or type(text) ~= 'string' then return end
    SendNUIMessage({ cw = true, action = 'announce', text = text:sub(1, 120), from = type(from) == 'string' and from:sub(1, 40) or '' })
end)

RegisterNetEvent('unique_cw:client:countdown', function(seconds)
    if currentWorld == 0 then return end
    seconds = math.floor(tonumber(seconds) or 0)
    if seconds < 3 or seconds > 10 then return end
    SendNUIMessage({ cw = true, action = 'countdown', seconds = seconds })
    CreateThread(function()
        for _ = seconds, 1, -1 do
            PlaySoundFrontend(-1, '3_2_1', 'HUD_MINI_GAME_SOUNDSET', true)
            Wait(1000)
        end
        PlaySoundFrontend(-1, 'GO', 'HUD_MINI_GAME_SOUNDSET', true)
    end)
end)

local function openTools()
    if CWConfig.MenuStyle == 'classic' then return openToolsClassic() end
    return openModern()
end

-- Short commands (same tools as the menu, same per-world switches).
if CWConfig.LegacyCommands then
    RegisterCommand('spawn', function(_, args) spawnVehicle(args[1]) end, false)
    RegisterCommand('dveh', deleteVehicle, false)
    RegisterCommand('revme', reviveSelf, false)
    RegisterCommand('ctp', teleportToWaypoint, false)
    RegisterCommand('armorme', fillArmor, false)
    RegisterCommand('cgetmaxammo', refillAmmo, false)
    RegisterCommand('openmenu', openTools, false)
end

RegisterCommand('wfix', fixVehicle, false)
RegisterCommand('wweapon', function(_, args) giveWeapon(args[1], args[2]) end, false)
RegisterCommand('wgoto', function(_, args)
    if args[1] then explain(lib.callback.await('unique_cw:goto', false, args[1])) else pickMember('Go to a player', 'goto') end
end, false)
RegisterCommand('wbring', function(_, args)
    if args[1] then explain(lib.callback.await('unique_cw:bring', false, args[1])) else pickMember('Bring a player', 'bring') end
end, false)

RegisterCommand('worldmenu', openTools, false)
RegisterKeyMapping('worldmenu', 'World tools menu', 'keyboard', CWConfig.MenuKey)
RegisterCommand('cped', function() openPedMenu() end, false)

-- ---------------------------------------------------------------- join / leave

local function timeLeft(expire)
    if not expire or expire <= 0 then return 'no expiry' end
    local left = expire - GetCloudTimeAsInt()
    if left <= 0 then return 'expired' end
    return ('%d d %d h left'):format(left // 86400, (left % 86400) // 3600)
end

RegisterCommand('joinworld', function(_, args)
    local id = tonumber(args[1])
    if id then
        local ok, why = lib.callback.await('unique_cw:join', false, id)
        explain(ok, why)
        return
    end

    if CWConfig.MenuStyle == 'modern' then return openJoinNui() end

    local data = lib.callback.await('unique_cw:list', false)
    local options = {}
    for _, w in ipairs(data.worlds or {}) do
        if w.canEnter then
            options[#options + 1] = {
                title = w.label and ('%s (%d)'):format(w.label, w.id) or ('World %d'):format(w.id),
                description = timeLeft(w.expire),
                icon = 'earth-europe',
                onSelect = function() explain(lib.callback.await('unique_cw:join', false, w.id)) end,
            }
        end
    end
    if #options == 0 then return notify('You do not have access to any world.', 'error') end
    lib.registerContext({ id = 'unique_cw_join', title = 'Worlds', options = options })
    lib.showContext('unique_cw_join')
end, false)

RegisterCommand('leaveworld', function()
    explain(lib.callback.await('unique_cw:leave', false))
end, false)

-- ---------------------------------------------------------------- admin manager

local openManager, openWorldMenu

local function findWorld(id)
    local data = lib.callback.await('unique_cw:list', false)
    if not data.admin then return nil end
    for _, w in ipairs(data.worlds) do
        if w.id == id then return w end
    end
    return nil
end

local function toggleLabel(title, state)
    return ('%s: %s'):format(title, state and 'ON' or 'OFF')
end

openWorldMenu = function(id)
    local w = findWorld(id)
    if not w then return openManager() end

    local function act(name, ...)
        local ok, why = lib.callback.await('unique_cw:' .. name, false, id, ...)
        explain(ok, why)
        openWorldMenu(id)
    end

    local options = {
        { title = 'Enter this world', icon = 'right-to-bracket', onSelect = function()
            explain(lib.callback.await('unique_cw:join', false, id))
        end },
        { title = 'Label', description = w.label or 'none', icon = 'tag', onSelect = function()
            local input = lib.inputDialog('Label', { { type = 'input', label = 'Name', default = w.label, max = 64 } })
            if input then act('label', input[1] or '') else openWorldMenu(id) end
        end },
        { title = toggleLabel('Gang access', w.gang_access), icon = 'users', onSelect = function()
            act('gangAccess', not w.gang_access)
        end },
    }

    for _, gang in ipairs(w.gangs or {}) do
        options[#options + 1] = { title = 'Gang: ' .. gang, description = 'Select to remove', icon = 'minus', onSelect = function()
            act('gang', gang, false)
        end }
    end
    options[#options + 1] = { title = 'Add gang', icon = 'plus', onSelect = function()
        local input = lib.inputDialog('Add gang', { { type = 'input', label = 'Gang name', required = true, max = 50 } })
        if input and input[1] then act('gang', input[1], true) else openWorldMenu(id) end
    end }

    for _, identifier in ipairs(w.players or {}) do
        options[#options + 1] = { title = 'Player: ' .. identifier, description = 'Select to remove', icon = 'minus', onSelect = function()
            act('player', identifier, false)
        end }
    end
    options[#options + 1] = { title = 'Add player', description = 'Online server id or identifier', icon = 'plus', onSelect = function()
        local input = lib.inputDialog('Add player', { { type = 'input', label = 'Server id or identifier', required = true, max = 80 } })
        if input and input[1] then act('player', input[1], true) else openWorldMenu(id) end
    end }

    for _, name in ipairs({ 'menu', 'vehicle', 'tp', 'revive', 'weapon', 'armor', 'peds', 'skins', 'extras', 'host' }) do
        local state = w.flags and w.flags[name]
        options[#options + 1] = { title = toggleLabel('Tool ' .. name, state), icon = 'sliders', onSelect = function()
            act('flag', name, not state)
        end }
    end

    options[#options + 1] = { title = 'Saved outfits', description = 'Use /saveworldskin <name> inside the world to add one', icon = 'shirt', onSelect = function()
        local ok, names = lib.callback.await('unique_cw:skinList', false, id)
        if not ok then return explain(false, names) end
        local sub = {}
        for _, skinName in ipairs(names or {}) do
            sub[#sub + 1] = { title = skinName, description = 'Select to delete', icon = 'trash', onSelect = function()
                explain(lib.callback.await('unique_cw:skinDelete', false, id, skinName))
                openWorldMenu(id)
            end }
        end
        if #sub == 0 then
            notify('No saved outfits in this world.', 'inform')
            return openWorldMenu(id)
        end
        lib.registerContext({ id = 'unique_cw_skinlist_' .. id, title = 'Saved outfits', menu = 'unique_cw_world_' .. id, options = sub })
        lib.showContext('unique_cw_skinlist_' .. id)
    end }
    options[#options + 1] = {
        title = 'Spawn point',
        description = w.spawn and ('%.1f, %.1f, %.1f'):format(w.spawn.x, w.spawn.y, w.spawn.z) or 'none (players stay where they are)',
        icon = 'location-crosshairs',
        onSelect = function()
            local choice = lib.alertDialog({
                header = 'Spawn point', centered = true, cancel = true,
                content = 'Use the spot you are standing on as the spawn point of this world?',
                labels = { confirm = 'Set here', cancel = w.spawn and 'Clear' or 'Back' },
            })
            if choice == 'confirm' then act('spawn', false)
            elseif w.spawn then act('spawn', true)
            else openWorldMenu(id) end
        end,
    }
    options[#options + 1] = { title = 'Expiry', description = timeLeft(w.expire), icon = 'clock', onSelect = function()
        local input = lib.inputDialog('Expiry', { { type = 'number', label = 'Days from now (0 = never)', required = true, min = 0, max = 3650 } })
        if input and input[1] then act('expire', input[1]) else openWorldMenu(id) end
    end }
    options[#options + 1] = { title = 'Delete world', description = 'Everyone inside is sent back', icon = 'trash', iconColor = 'red', onSelect = function()
        local confirm = lib.alertDialog({ header = 'Delete world ' .. id, content = 'This cannot be undone.', centered = true, cancel = true })
        if confirm == 'confirm' then
            local ok, why = lib.callback.await('unique_cw:delete', false, id)
            explain(ok, why)
            openManager()
        else
            openWorldMenu(id)
        end
    end }

    lib.registerContext({
        id = 'unique_cw_world_' .. id,
        title = w.label and ('%s (%d)'):format(w.label, id) or ('World %d'):format(id),
        menu = 'unique_cw_manager',
        options = options,
    })
    lib.showContext('unique_cw_world_' .. id)
end

openManager = function()
    local data = lib.callback.await('unique_cw:list', false)
    if not data.admin then return notify('You do not have permission.', 'error') end

    local options = {
        { title = 'New world', icon = 'plus', onSelect = function()
            local input = lib.inputDialog('New world', { { type = 'number', label = 'World id', required = true, min = 1, max = 99999 } })
            if input and input[1] then
                local ok, why = lib.callback.await('unique_cw:create', false, input[1])
                explain(ok, why)
                if ok then return openWorldMenu(math.floor(input[1])) end
            end
            openManager()
        end },
        { title = 'Send player to world', description = 'Online server id + world id (0 = main world)', icon = 'paper-plane', onSelect = function()
            local input = lib.inputDialog('Send player', {
                { type = 'number', label = 'Player server id', required = true, min = 1 },
                { type = 'number', label = 'World id', required = true, min = 0, max = 99999 },
            })
            if input and input[1] and input[2] then
                local ok, why = lib.callback.await('unique_cw:send', false, input[1], input[2])
                explain(ok, why)
            end
            openManager()
        end },
    }
    for _, w in ipairs(data.worlds) do
        local title = w.label and ('%s (%d)'):format(w.label, w.id) or ('World %d'):format(w.id)
        if w.static then
            options[#options + 1] = {
                title = title, description = 'Defined in changeworld_config.lua - select to enter', icon = 'file-code',
                onSelect = function() explain(lib.callback.await('unique_cw:join', false, w.id)) end,
            }
        else
            options[#options + 1] = {
                title = title,
                description = timeLeft(w.expire),
                icon = 'earth-europe',
                arrow = true,
                onSelect = function() openWorldMenu(w.id) end,
            }
        end
    end

    lib.registerContext({ id = 'unique_cw_manager', title = 'World manager', options = options })
    lib.showContext('unique_cw_manager')
end

RegisterCommand('worldmanage', function()
    if CWConfig.MenuStyle == 'modern' then return openManagerNui() end
    openManager()
end, false)

-- ---------------------------------------------------------------- world shop (E at the marker)

local function money(n)
    local s = tostring(math.floor(n))
    local formatted = s:reverse():gsub('(%d%d%d)', '%1,'):reverse()
    return '$' .. formatted:gsub('^,', '')
end

local openOwnerMenu, openMyWorlds

local function ownerAct(id, name, ...)
    local ok, why = lib.callback.await('unique_cw:' .. name, false, id, ...)
    explain(ok, why)
    return ok
end

openOwnerMenu = function(id)
    local data = lib.callback.await('unique_cw:list', false)
    local w
    for _, entry in ipairs(data.worlds or {}) do
        if entry.id == id and entry.owner then w = entry end
    end
    if not w then return openMyWorlds() end

    local S = CWConfig.Shop
    local options = {
        { title = 'Enter this world', icon = 'right-to-bracket', disabled = not w.canEnter, onSelect = function()
            explain(lib.callback.await('unique_cw:join', false, id))
        end },
        { title = 'Time left', description = (w.expired and 'expired - renew at the world shop' or timeLeft(w.expire)), icon = 'clock', readOnly = true },
        { title = 'Name', description = w.label or 'none', icon = 'tag', onSelect = function()
            local input = lib.inputDialog('Name', { { type = 'input', label = 'World name', default = w.label, max = 64 } })
            if input then ownerAct(id, 'label', input[1] or '') end
            openOwnerMenu(id)
        end },
        { title = 'Add player', description = ('%d / %d allowed players'):format(#(w.players or {}), S.maxPlayers), icon = 'plus', onSelect = function()
            local input = lib.inputDialog('Add player', { { type = 'input', label = 'Server id or identifier', required = true, max = 80 } })
            if input and input[1] then ownerAct(id, 'player', input[1], true) end
            openOwnerMenu(id)
        end },
    }
    for _, identifier in ipairs(w.players or {}) do
        options[#options + 1] = { title = identifier, description = 'Select to remove', icon = 'minus', onSelect = function()
            ownerAct(id, 'player', identifier, false)
            openOwnerMenu(id)
        end }
    end
    options[#options + 1] = {
        title = 'Spawn point',
        description = w.spawn and ('%.1f, %.1f, %.1f'):format(w.spawn.x, w.spawn.y, w.spawn.z) or 'none (players stay where they are)',
        icon = 'location-crosshairs',
        onSelect = function()
            local choice = lib.alertDialog({
                header = 'Spawn point', centered = true, cancel = true,
                content = 'Use the spot you are standing on as the spawn point of your world?',
                labels = { confirm = 'Set here', cancel = w.spawn and 'Clear' or 'Back' },
            })
            if choice == 'confirm' then ownerAct(id, 'spawn', false)
            elseif w.spawn then ownerAct(id, 'spawn', true) end
            openOwnerMenu(id)
        end,
    }
    options[#options + 1] = {
        title = 'Renew', description = ('%s per day, at the world shop'):format(money(S.pricePerDay)), icon = 'rotate',
        onSelect = function()
            local input = lib.inputDialog('Renew', { { type = 'number', label = ('Days (%d - %d)'):format(S.minDays, S.maxDays), required = true, min = S.minDays, max = S.maxDays } })
            if input and input[1] then
                if ownerAct(id, 'shopRenew', math.floor(input[1])) then notify('World renewed.', 'success') end
            end
            openOwnerMenu(id)
        end,
    }

    lib.registerContext({
        id = 'unique_cw_owner_' .. id,
        title = w.label and ('%s (%d)'):format(w.label, id) or ('My world %d'):format(id),
        menu = 'unique_cw_myworlds',
        options = options,
    })
    lib.showContext('unique_cw_owner_' .. id)
end

openMyWorlds = function()
    local data = lib.callback.await('unique_cw:list', false)
    local options = {}
    for _, w in ipairs(data.worlds or {}) do
        if w.owner then
            options[#options + 1] = {
                title = w.label and ('%s (%d)'):format(w.label, w.id) or ('World %d'):format(w.id),
                description = w.expired and 'expired' or timeLeft(w.expire),
                icon = 'earth-europe', arrow = true,
                onSelect = function() openOwnerMenu(w.id) end,
            }
        end
    end
    if #options == 0 then return notify('You do not own a world.', 'inform') end
    lib.registerContext({ id = 'unique_cw_myworlds', title = 'My worlds', options = options })
    lib.showContext('unique_cw_myworlds')
end

local function openShop()
    local S = CWConfig.Shop
    local options = {
        { title = 'Rent a private world', description = ('%s per day, %d - %d days'):format(money(S.pricePerDay), S.minDays, S.maxDays), icon = 'cart-shopping', onSelect = function()
            local input = lib.inputDialog('Rent a world', { { type = 'number', label = ('Days (%d - %d)'):format(S.minDays, S.maxDays), required = true, min = S.minDays, max = S.maxDays } })
            if not input or not input[1] then return end
            local days = math.floor(input[1])
            local confirm = lib.alertDialog({
                header = 'Rent a world', centered = true, cancel = true,
                content = ('%d day(s) for %s?'):format(days, money(days * S.pricePerDay)),
            })
            if confirm ~= 'confirm' then return end
            local ok, idOrWhy = lib.callback.await('unique_cw:shopBuy', false, days)
            if ok then
                notify(('World %d is yours. Open "My worlds" to set it up, or use /joinworld.'):format(idOrWhy), 'success')
            else
                explain(false, idOrWhy)
            end
        end },
        { title = 'My worlds', icon = 'earth-europe', onSelect = openMyWorlds },
    }
    lib.registerContext({ id = 'unique_cw_shop', title = 'World shop', options = options })
    lib.showContext('unique_cw_shop')
end

RegisterCommand('myworld', function()
    if CWConfig.MenuStyle == 'modern' then return openMyWorldsNui() end
    openMyWorlds()
end, false)

CreateThread(function()
    local S = CWConfig.Shop
    if not S or not S.enabled then return end

    if S.blip and S.blip.enabled then
        local blip = AddBlipForCoord(S.coords.x, S.coords.y, S.coords.z)
        SetBlipSprite(blip, S.blip.sprite or 40)
        SetBlipColour(blip, S.blip.colour or 3)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(S.blip.label or 'World shop')
        EndTextCommandSetBlipName(blip)
    end

    local shown = false
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local c = GetEntityCoords(ped)
        local dx, dy, dz = c.x - S.coords.x, c.y - S.coords.y, c.z - S.coords.z
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

        if dist < 25.0 then
            sleep = 0
            DrawMarker(1, S.coords.x, S.coords.y, S.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                S.radius, S.radius, 0.8, 80, 160, 255, 120, false, false, 2, false, nil, nil, false)
        end

        local atShop = dist <= S.radius and currentWorld == 0 and not IsPedInAnyVehicle(ped, false)
        if atShop then
            if not shown then
                lib.showTextUI('[E] World shop')
                shown = true
            end
            if IsControlJustReleased(0, 38) then
                if CWConfig.MenuStyle == 'modern' then openShopNui() else openShop() end
            end
        elseif shown then
            lib.hideTextUI()
            shown = false
        end
        Wait(sleep)
    end
end)

-- ---------------------------------------------------------------- NUI screens: world manager, shop, my worlds, join
-- Same page as the tools menu (html/changeworld) in "screen" mode. NAV keeps the stack, so Back / Backspace
-- walks up one screen. Every change goes through the same server callbacks the ox_lib screens use.

local SCREENS = {}

local FLAG_LABELS = {
    menu = 'In-world menu', vehicle = 'Vehicles', tp = 'Teleport', revive = 'Revive and heal', weapon = 'Weapons',
    armor = 'Armor', peds = 'Peds', skins = 'Outfits', extras = 'Fun (god mode, time, weather, emotes)',
    host = 'Host tools (revive, freeze, kick, announce)',
}
local FLAG_ORDER = { 'menu', 'vehicle', 'tp', 'revive', 'weapon', 'armor', 'peds', 'skins', 'extras', 'host' }

local function listData()
    return lib.callback.await('unique_cw:list', false) or { worlds = {} }
end

local function findWorld(id)
    for _, w in ipairs(listData().worlds or {}) do
        if w.id == id then return w end
    end
    return nil
end

local function worldTitle(w)
    return w.label and ('%s (%d)'):format(w.label, w.id) or ('World %d'):format(w.id)
end

local function leftText(w)
    if w.expired then return 'expired' end
    return timeLeftText(w.expire) or 'no expiry'
end

local function callServer(name, ...)
    local ok, why = lib.callback.await('unique_cw:' .. name, false, ...)
    explain(ok, why)
    return ok, why
end

local function topScreen() return NAV.stack[#NAV.stack] end

local function renderTop()
    local top = topScreen()
    local model = SCREENS[top.name](top.arg)
    model.screen = true
    model.ns = 'mgr'
    model.accent = CWConfig.Accent
    model.back = #NAV.stack > 1
    model.icon = model.icon or 'globe'
    return model
end

local function pushScreen(name, arg)
    NAV.stack[#NAV.stack + 1] = { name = name, arg = arg }
end

local function openScreen(name, arg)
    NAV.stack = {}
    pushScreen(name, arg)
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ cw = true, action = 'open', model = renderTop() })
end

-- answers of the actions: false (keep the menu open) + what the page should do
local function go(name, arg)
    pushScreen(name, arg)
    return false, { screen = renderTop() }
end

local function refresh(extra)
    local reply = { screen = renderTop() }
    if extra then for k, v in pairs(extra) do reply[k] = v end end
    return false, reply
end

local function worldArg() local top = topScreen() return top and top.arg end

local function noopRow(text, icon)
    return { id = 'noop', label = text, icon = icon or 'info', disabled = true }
end

-- ------------------------------------------------------------ screens

SCREENS.home = function()
    local data = listData()
    if not data.admin then
        return { title = 'World manager', subtitle = 'Admins only', items = { noopRow('You do not have permission.', 'lock') } }
    end
    local items = {
        { id = 'new', label = 'New world', desc = 'Create an empty world', icon = 'plus',
          prompt = { title = 'New world', placeholder = 'World id (1 - 99999)' } },
        { id = 'send', label = 'Send a player to a world', desc = 'Online server id + world id (0 = main world)', icon = 'send',
          prompt = { title = 'Send player', fields = { { placeholder = 'Player server id' }, { placeholder = 'World id (0 = main world)' } } } },
        { section = 'Worlds' },
    }
    for _, w in ipairs(data.worlds or {}) do
        if w.static then
            items[#items + 1] = { id = 'enter', value = w.id, label = worldTitle(w), desc = 'Defined in changeworld_config.lua - Enter = join', icon = 'file', tag = 'config' }
        else
            items[#items + 1] = { id = 'open', value = w.id, label = worldTitle(w), desc = leftText(w), icon = 'globe',
                tag = ('%d players'):format(#(w.players or {})) }
        end
    end
    return { title = 'World manager', subtitle = ('%d worlds'):format(#(data.worlds or {})), items = items, searchable = #(data.worlds or {}) > 8 }
end

SCREENS.world = function(id)
    local w = findWorld(id)
    if not w then return { title = 'World', subtitle = 'Not found', items = { noopRow('This world does not exist any more.', 'close') } } end

    local items = {
        { id = 'w_enter', label = 'Enter this world', icon = 'door' },
        { id = 'w_label', label = 'Name', desc = w.label or 'none', icon = 'edit', prompt = { title = 'World name', placeholder = 'Name (max 64 letters)' } },
        { section = 'Access' },
        { id = 'w_gangaccess', label = 'Gang access', desc = 'Members of the gangs below may join', icon = 'users', toggle = w.gang_access and true or false },
        { id = 'w_gang_add', label = 'Add gang', icon = 'plus', prompt = { title = 'Add gang', placeholder = 'Gang name' } },
    }
    for _, gang in ipairs(w.gangs or {}) do
        items[#items + 1] = { id = 'w_gang_rm', value = gang, label = gang, desc = 'Gang - Enter = remove', icon = 'minus' }
    end
    items[#items + 1] = { id = 'w_player_add', label = 'Add player', desc = 'Online server id or identifier', icon = 'plus', prompt = { title = 'Add player', placeholder = 'Server id or identifier' } }
    for _, identifier in ipairs(w.players or {}) do
        items[#items + 1] = { id = 'w_player_rm', value = identifier, label = identifier, desc = 'Player - Enter = remove', icon = 'minus' }
    end

    items[#items + 1] = { section = 'Tools in this world' }
    for _, name in ipairs(FLAG_ORDER) do
        items[#items + 1] = { id = 'w_flag', value = name, label = FLAG_LABELS[name], icon = 'bolt', toggle = (w.flags and w.flags[name]) and true or false }
    end

    items[#items + 1] = { section = 'World' }
    items[#items + 1] = { id = 'w_spawn_set', label = 'Set the spawn point here', desc = w.spawn and ('%.1f, %.1f, %.1f'):format(w.spawn.x, w.spawn.y, w.spawn.z) or 'none (players stay where they are)', icon = 'flag' }
    if w.spawn then items[#items + 1] = { id = 'w_spawn_clear', label = 'Clear the spawn point', icon = 'minus' } end
    items[#items + 1] = { id = 'w_expire', label = 'Expiry', desc = leftText(w), icon = 'clock', prompt = { title = 'Expiry', placeholder = 'Days from now (0 = never)' } }
    items[#items + 1] = { id = 'w_skins', label = 'Saved outfits', desc = 'Use /saveworldskin <name> inside the world to add one', icon = 'shirt' }
    items[#items + 1] = { id = 'w_delete', label = 'Delete world', desc = 'Everyone inside is sent back', icon = 'trash', danger = true }

    return { title = worldTitle(w), subtitle = leftText(w), items = items }
end

SCREENS.outfits = function(id)
    local ok, names = lib.callback.await('unique_cw:skinList', false, id)
    local items = {}
    if ok then
        for _, name in ipairs(names or {}) do
            items[#items + 1] = { id = 'skin_rm', value = name, label = name, desc = 'Enter = delete', icon = 'shirt', danger = true }
        end
    end
    if #items == 0 then items[1] = noopRow('No saved outfits in this world.', 'shirt') end
    return { title = 'Saved outfits', subtitle = ('World %d'):format(id), items = items, icon = 'shirt' }
end

SCREENS.confirm_delete = function(id)
    return {
        title = ('Delete world %d?'):format(id), subtitle = 'This cannot be undone', icon = 'trash',
        items = {
            { id = 'del_yes', label = ('Yes, delete world %d'):format(id), desc = 'Everyone inside is sent back to the main world', icon = 'trash', danger = true },
            { id = 'del_no', label = 'No, keep it', icon = 'check' },
        },
    }
end

SCREENS.shop = function()
    local S = CWConfig.Shop
    return {
        title = 'World shop', subtitle = ('%s per day'):format(money(S.pricePerDay)), icon = 'cart',
        items = {
            { id = 'rent', label = 'Rent a private world', desc = ('%d - %d days'):format(S.minDays, S.maxDays), icon = 'cart',
              prompt = { title = 'Rent a world', placeholder = ('Days (%d - %d)'):format(S.minDays, S.maxDays) } },
            { id = 'open_mine', label = 'My worlds', desc = 'Manage the worlds you own', icon = 'globe' },
            { id = 'open_join', label = 'Join a world', desc = 'Worlds you have access to', icon = 'door' },
        },
    }
end

SCREENS.confirm_rent = function(days)
    local S = CWConfig.Shop
    return {
        title = 'Confirm', subtitle = ('%d day(s) - %s'):format(days, money(days * S.pricePerDay)), icon = 'cart',
        items = {
            { id = 'rent_yes', label = ('Pay %s'):format(money(days * S.pricePerDay)), desc = ('Rent a world for %d day(s)'):format(days), icon = 'check' },
            { id = 'rent_no', label = 'Cancel', icon = 'close' },
        },
    }
end

SCREENS.mine = function()
    local items = {}
    for _, w in ipairs(listData().worlds or {}) do
        if w.owner then
            items[#items + 1] = { id = 'open_owner', value = w.id, label = worldTitle(w), desc = leftText(w), icon = 'globe', tag = w.expired and 'expired' or nil }
        end
    end
    if #items == 0 then items[1] = noopRow('You do not own a world.', 'globe') end
    return { title = 'My worlds', subtitle = 'Worlds you rented', items = items }
end

SCREENS.owner = function(id)
    local w = findWorld(id)
    if not w or not w.owner then return { title = 'My world', items = { noopRow('This world is not yours.', 'lock') } } end
    local S = CWConfig.Shop
    local items = {
        { id = 'w_enter', label = 'Enter this world', icon = 'door', disabled = not w.canEnter },
        { id = 'info', label = leftText(w), desc = w.expired and 'Renew it at the world shop' or 'Time left', icon = 'clock', disabled = true },
        { id = 'w_label', label = 'Name', desc = w.label or 'none', icon = 'edit', prompt = { title = 'World name', placeholder = 'Name (max 64 letters)' } },
        { section = 'Players' },
        { id = 'w_player_add', label = 'Add player', desc = ('%d / %d allowed'):format(#(w.players or {}), S.maxPlayers), icon = 'plus',
          prompt = { title = 'Add player', placeholder = 'Server id or identifier' } },
    }
    for _, identifier in ipairs(w.players or {}) do
        items[#items + 1] = { id = 'w_player_rm', value = identifier, label = identifier, desc = 'Enter = remove', icon = 'minus' }
    end
    items[#items + 1] = { section = 'World' }
    items[#items + 1] = { id = 'w_spawn_set', label = 'Set the spawn point here', desc = w.spawn and ('%.1f, %.1f, %.1f'):format(w.spawn.x, w.spawn.y, w.spawn.z) or 'none (players stay where they are)', icon = 'flag' }
    if w.spawn then items[#items + 1] = { id = 'w_spawn_clear', label = 'Clear the spawn point', icon = 'minus' } end
    items[#items + 1] = { id = 'o_renew', label = 'Renew', desc = ('%s per day - only at the world shop'):format(money(S.pricePerDay)), icon = 'refresh',
        prompt = { title = 'Renew', placeholder = ('Days (%d - %d)'):format(S.minDays, S.maxDays) } }
    return { title = worldTitle(w), subtitle = leftText(w), items = items }
end

SCREENS.join = function()
    local items = {}
    local data = listData()
    local tag = data.gate == 'gang' and 'at your gang' or (data.gate == 'place' and 'at the gate') or nil
    for _, w in ipairs(data.worlds or {}) do
        if w.canEnter then
            items[#items + 1] = { id = 'enter', value = w.id, label = worldTitle(w), desc = leftText(w), icon = 'globe', tag = tag }
        end
    end
    if #items == 0 then items[1] = noopRow('You do not have access to any world.', 'lock') end
    return { title = 'Worlds', subtitle = 'Pick one to enter', icon = 'door', items = items }
end

-- ------------------------------------------------------------ actions of the screens

local function toDays(v)
    local n = tonumber(v)
    return n and math.floor(n) or nil
end

MGR.new = function(v)
    local id = toDays(v)
    if not id then return false, { toast = 'Voroodi Eshtebah Ast.', error = true } end
    if callServer('create', id) then return go('world', id) end
    return false
end

MGR.send = function(v)
    if type(v) ~= 'table' then return false end
    local target, world = tonumber(v[1]), tonumber(v[2])
    if not target or not world then return false, { toast = 'Voroodi Eshtebah Ast.', error = true } end
    if callServer('send', target, world) then return false, { toast = 'Done' } end
    return false
end

MGR.open = function(v) return go('world', tonumber(v)) end
MGR.enter = function(v)
    local ok = explain(lib.callback.await('unique_cw:join', false, tonumber(v)))
    return ok and true or false
end
MGR.open_mine = function() return go('mine') end
MGR.open_join = function() return go('join') end
MGR.open_owner = function(v) return go('owner', tonumber(v)) end

-- world level actions (manager and owner screens share them; the server decides who may do what)
MGR.w_enter = function()
    local ok = explain(lib.callback.await('unique_cw:join', false, worldArg()))
    return ok and true or false
end
MGR.w_label = function(v) callServer('label', worldArg(), v) return refresh() end
MGR.w_gangaccess = function()
    local w = findWorld(worldArg())
    if not w then return false end
    local state = not w.gang_access
    if callServer('gangAccess', worldArg(), state) then return false, { toggle = state } end
    return false
end
MGR.w_gang_add = function(v) callServer('gang', worldArg(), v, true) return refresh() end
MGR.w_gang_rm = function(v) callServer('gang', worldArg(), v, false) return refresh() end
MGR.w_player_add = function(v) callServer('player', worldArg(), v, true) return refresh() end
MGR.w_player_rm = function(v) callServer('player', worldArg(), v, false) return refresh() end
MGR.w_flag = function(v)
    local w = findWorld(worldArg())
    if not w or type(v) ~= 'string' then return false end
    local state = not (w.flags and w.flags[v])
    if callServer('flag', worldArg(), v, state) then return false, { toggle = state } end
    return false
end
MGR.w_spawn_set = function() callServer('spawn', worldArg(), false) return refresh() end
MGR.w_spawn_clear = function() callServer('spawn', worldArg(), true) return refresh() end
MGR.w_expire = function(v)
    local days = tonumber(v)
    if not days then return false, { toast = 'Voroodi Eshtebah Ast.', error = true } end
    callServer('expire', worldArg(), days)
    return refresh()
end
MGR.w_skins = function() return go('outfits', worldArg()) end
MGR.w_delete = function() return go('confirm_delete', worldArg()) end
MGR.skin_rm = function(v) callServer('skinDelete', worldArg(), v) return refresh() end

MGR.del_yes = function()
    local id = worldArg()
    if callServer('delete', id) then
        NAV.stack = { NAV.stack[1] }   -- back to the manager home
        return refresh({ toast = 'Deleted' })
    end
    return false
end
MGR.del_no = function()
    table.remove(NAV.stack)
    return refresh()
end

MGR.rent = function(v)
    local S = CWConfig.Shop
    local days = toDays(v)
    if not days or days < S.minDays or days > S.maxDays then
        return false, { toast = 'Voroodi Eshtebah Ast.', error = true }
    end
    return go('confirm_rent', days)
end
MGR.rent_no = function()
    table.remove(NAV.stack)
    return refresh()
end
MGR.rent_yes = function()
    local days = worldArg()
    local ok, idOrWhy = lib.callback.await('unique_cw:shopBuy', false, days)
    if not ok then
        explain(false, idOrWhy)
        table.remove(NAV.stack)
        return refresh()
    end
    notify(('World %d Male Shoma Shod!'):format(idOrWhy), 'success')
    NAV.stack = { { name = 'shop' } }
    return go('owner', idOrWhy)
end
MGR.o_renew = function(v)
    local days = toDays(v)
    if not days then return false, { toast = 'Voroodi Eshtebah Ast.', error = true } end
    if callServer('shopRenew', worldArg(), days) then return refresh({ toast = 'Renewed' }) end
    return false
end

RegisterNUICallback('cw_back', function(_, cb)
    if #NAV.stack <= 1 then
        NAV.stack = {}
        nuiOpen = false
        SetNuiFocus(false, false)
        return cb({ close = true })
    end
    table.remove(NAV.stack)
    cb({ screen = renderTop() })
end)

openManagerNui = function() openScreen('home') end
openShopNui = function() openScreen('shop') end
openMyWorldsNui = function() openScreen('mine') end
openJoinNui = function() openScreen('join') end

-- ---------------------------------------------------------------- streamer menu (/cw)

RegisterNetEvent('unique_cw:client:streamerMenu', function(data)
    local options = {}

    options[#options + 1] = {
        title = data.inWorld and ('You are in world %d'):format(data.world) or ('Enter world %d'):format(data.world),
        icon = data.inWorld and 'circle-check' or 'play',
        disabled = data.inWorld,
        onSelect = function() explain(lib.callback.await('unique_cw:stSend', false, data.me)) end,
    }
    if data.inWorld then
        options[#options + 1] = {
            title = 'Leave world', icon = 'door-open',
            onSelect = function() explain(lib.callback.await('unique_cw:leave', false)) end,
        }
    end

    for _, p in ipairs(data.nearby or {}) do
        options[#options + 1] = {
            title = ('%s [%d]'):format(p.name, p.id), description = ('Send to world %d'):format(data.world), icon = 'user-plus',
            onSelect = function() explain(lib.callback.await('unique_cw:stSend', false, p.id)) end,
        }
    end
    for _, p in ipairs(data.inside or {}) do
        options[#options + 1] = {
            title = ('%s [%d]'):format(p.name, p.id), description = 'Bring back to the main world', icon = 'user-minus',
            onSelect = function() explain(lib.callback.await('unique_cw:stReturn', false, p.id)) end,
        }
    end

    lib.registerContext({ id = 'unique_cw_streamer', title = ('Streamer world %d'):format(data.world), options = options })
    lib.showContext('unique_cw_streamer')
end)

-- ---------------------------------------------------------------- disabled controls inside worlds

CreateThread(function()
    while true do
        local sleep = 500
        if currentWorld ~= 0 then
            local static = CWConfig.StaticWorlds and CWConfig.StaticWorlds[currentWorld]
            local list = (static and static.disableControls) or CWConfig.DisableControlsInWorlds
            if list and #list > 0 then
                sleep = 0
                for i = 1, #list do DisableControlAction(0, list[i], true) end
            end
        end
        Wait(sleep)
    end
end)

-- ox_target restarted while the player is inside a world: switch it off again.
AddEventHandler('onClientResourceStart', function(resource)
    if resource == 'ox_target' and currentWorld ~= 0 then
        Wait(500)
        setTargeting(true)
    end
end)

exports('IsInWorld', function() return currentWorld ~= 0 end)

-- ---------------------------------------------------------------- cleanup

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteSpawnedVehicles()
    removeWorldWeapons()
    setTargeting(false)
    resetFx()
    if nuiOpen then SetNuiFocus(false, false) end
    preview.active = false
    if preview.dui then DestroyDui(preview.dui) end
end)
