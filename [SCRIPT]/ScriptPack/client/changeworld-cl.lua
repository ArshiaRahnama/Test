-- ScriptPack / change world (client)

local currentWorld = 0
local currentLabel = nil
local flags = {}
local savedHealth, savedArmor = nil, nil
local savedSkin = nil
local pedChanged = false
local spawnedVehicles = {}

local function notify(text, kind)
    lib.notify({ description = text, type = kind or 'inform' })
end

local REASONS = {
    not_found = 'World does not exist.',
    expired = 'This world has expired.',
    no_access = 'You do not have access to this world.',
    no_permission = 'You do not have permission.',
    exists = 'This world already exists.',
    range = 'World id is out of range.',
    invalid = 'Invalid input.',
    same = 'Nothing changed.',
    not_ready = 'World system is still loading.',
    not_streamer = 'You do not have access to this command.',
    too_far = 'The player must be near the entrance.',
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

RegisterNetEvent('unique_cw:client:entered', function(world, newFlags, spawn, label)
    local first = currentWorld == 0
    currentWorld = world
    currentLabel = label
    flags = newFlags or {}

    if first then
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
    notify(label and ('You are now in world %d (%s).'):format(world, label) or ('You are now in world %d.'):format(world), 'success')
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
    flags = {}

    fade(500, true)
    deleteSpawnedVehicles()
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
    if not silent then notify('You are back in the main world.', 'success') end
end)

-- ---------------------------------------------------------------- in-world tools

local function can(feature)
    if currentWorld == 0 or not flags[feature] then
        notify('This is not available here.', 'error')
        return false
    end
    return lib.callback.await('unique_cw:can', false, feature) == true
end

local function spawnVehicle(modelName)
    if not can('vehicle') then return end
    if type(modelName) ~= 'string' or modelName == '' then
        local input = lib.inputDialog('Spawn vehicle', { { type = 'input', label = 'Model name', required = true, max = 32 } })
        if not input or not input[1] then return end
        modelName = tostring(input[1])
    end

    local model = joaat(modelName:lower())
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        return notify('That vehicle model does not exist.', 'error')
    end
    if not loadModel(model) then
        return notify('Could not load the model.', 'error')
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
    if veh == 0 then return notify('Could not spawn the vehicle.', 'error') end

    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(ped, veh, -1)
    spawnedVehicles[#spawnedVehicles + 1] = veh
end

local function deleteVehicle()
    if not can('vehicle') then return end
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return notify('You are not in a vehicle.', 'error') end

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
    if not DoesBlipExist(blip) then return notify('Set a waypoint first.', 'error') end

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
    if not landed then notify('Could not find the ground there.', 'error') end
end

local function reviveSelf()
    if not can('revive') then return end
    if not lib.callback.await('unique_cw:revive', false) then
        notify('This is not available here.', 'error')
    end
end

local function fillArmor()
    if not can('armor') then return end
    SetPedArmour(PlayerPedId(), 100)
end

local function refillAmmo()
    if not can('weapon') then return end
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if weapon == joaat('WEAPON_UNARMED') then return notify('You are not holding a weapon.', 'error') end
    local _, maxAmmo = GetMaxAmmo(ped, weapon)
    SetPedAmmo(ped, weapon, maxAmmo > 0 and maxAmmo or 250)
    notify('Ammo refilled.', 'success')
end

local function setPed(model)
    if not can('peds') then return end
    if model then
        local hash = joaat(model)
        if not IsModelInCdimage(hash) or not loadModel(hash) then
            return notify('Could not load that ped.', 'error')
        end
        if not pedChanged and not savedSkin then
            TriggerEvent('skinchanger:getSkin', function(skin) savedSkin = skin end)
        end
        pedChanged = true
        SetPlayerModel(PlayerId(), hash)
        SetModelAsNoLongerNeeded(hash)
        SetPedDefaultComponentVariation(PlayerPedId())
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

local function hidePreview()
    preview.active = false
end

local function openPedMenu()
    if not can('peds') then return end
    local options = {}
    for ci, category in ipairs(CWConfig.Peds) do
        local menuId = 'unique_cw_peds_' .. ci
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
    if not clothes then return notify('That outfit is no longer available.', 'error') end

    if not pedChanged and not savedSkin then
        TriggerEvent('skinchanger:getSkin', function(skin) savedSkin = skin end)
    end
    pedChanged = true
    TriggerEvent('skinchanger:getSkin', function(current)
        TriggerEvent('skinchanger:loadClothes', current, clothes)
    end)
end

local function openSkinMenu()
    if not can('skins') then return end
    local names = lib.callback.await('unique_cw:skinNames', false) or {}
    if #names == 0 then return notify('This world has no saved outfits.', 'inform') end

    local options = {
        { title = 'My own outfit', icon = 'rotate-left', onSelect = function() setPed(nil) end },
    }
    for _, name in ipairs(names) do
        options[#options + 1] = { title = name, icon = 'shirt', onSelect = function() applyWorldSkin(name) end }
    end
    lib.registerContext({ id = 'unique_cw_skins', title = 'World outfits', menu = 'unique_cw_tools', options = options })
    lib.showContext('unique_cw_skins')
end

RegisterCommand('worldskin', openSkinMenu, false)

-- Admin: stand in the world wearing the outfit, then /saveworldskin <name>
RegisterCommand('saveworldskin', function(_, args)
    if currentWorld == 0 then return notify('Enter a world first.', 'error') end
    local name = table.concat(args, ' ')
    if name == '' then return notify('Usage: /saveworldskin <name>', 'error') end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local ok, why = lib.callback.await('unique_cw:skinSave', false, name, skin)
        if explain(ok, why) then notify(('Outfit "%s" saved.'):format(name), 'success') end
    end)
end, false)

local function openTools()
    if currentWorld == 0 or not flags.menu then return notify('This is not available here.', 'error') end

    local options = {}
    if flags.revive then options[#options + 1] = { title = 'Revive', icon = 'heart-pulse', onSelect = reviveSelf } end
    if flags.armor then options[#options + 1] = { title = 'Full armor', icon = 'shield', onSelect = fillArmor } end
    if flags.weapon then options[#options + 1] = { title = 'Refill ammo', icon = 'gun', onSelect = refillAmmo } end
    if flags.vehicle then
        options[#options + 1] = { title = 'Spawn vehicle', icon = 'car', onSelect = spawnVehicle }
        options[#options + 1] = { title = 'Delete vehicle', icon = 'trash', onSelect = deleteVehicle }
    end
    if flags.tp then options[#options + 1] = { title = 'Teleport to waypoint', icon = 'location-dot', onSelect = teleportToWaypoint } end
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

RegisterCommand('worldmenu', openTools, false)
RegisterKeyMapping('worldmenu', 'World tools menu', 'keyboard', CWConfig.MenuKey)
RegisterCommand('cped', openPedMenu, false)

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

    for _, name in ipairs({ 'menu', 'vehicle', 'tp', 'revive', 'weapon', 'armor', 'peds', 'skins' }) do
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
        options[#options + 1] = {
            title = w.label and ('%s (%d)'):format(w.label, w.id) or ('World %d'):format(w.id),
            description = timeLeft(w.expire),
            icon = 'earth-europe',
            arrow = true,
            onSelect = function() openWorldMenu(w.id) end,
        }
    end

    lib.registerContext({ id = 'unique_cw_manager', title = 'World manager', options = options })
    lib.showContext('unique_cw_manager')
end

RegisterCommand('worldmanage', function() openManager() end, false)

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

-- ---------------------------------------------------------------- cleanup

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteSpawnedVehicles()
    preview.active = false
    if preview.dui then DestroyDui(preview.dui) end
end)
