-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local weaponSet = {}
local weaponSys = {}

local currentPreview
local currentConfig

CreateThread(function()
    waitForLoad()
    for k, v in pairs(weaponFactoryConfig.locations) do
        local model = weaponFactoryConfig.peds[math.random(1, #weaponFactoryConfig.peds)]
        createLocalPed(4, model, v - vec(0, 0, 1, 0), function(ped)
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            local options = {}
            table.insert(options, {
                label = 'Weapon customization🔫',
                onSelect = function()
                    if SUN.world == 0 then
                        currentConfig = k
                        openWeaponCustomMenu()
                        ESX.registerExitPoint(5, function()
                            lib.hideMenu()
                        end)
                    end
                end,
            })
            exports['ox_target']:addLocalEntity({ped}, options)
        end, function(ped)
            exports['ox_target']:removeLocalEntity(ped)
        end)
    end
    Wait(1000)
    ESX.TriggerServerCallback('weapon:getSet', function(data)
        weaponSet = data or {}
        weaponSys.applySet()
    end)
end)

local function weaponToSkill(name)
    return name:gsub('WEAPON_', ''):lower() .. '_skill'
end

local function haveAccessToWeapon(name)
    if weaponFactoryConfig.list[name] then
        for k, v in pairs(weaponFactoryConfig.list[name]) do
            if (v.access.gang and v.access.gang[ESX.PlayerData.gang.name]) or (v.access.skill and doesSkillCompleted(weaponToSkill(name))) or v.access.all then
                return true
            end
        end
    end
end

function weaponSys.haveAccessToAttach(name, key)
    local weaponConfig = weaponFactoryConfig.list[name]
    for k, v in pairs(weaponConfig) do
        if v.key == key and ((v.access.gang and v.access.gang[ESX.PlayerData.gang.name]) or (v.access.skill and doesSkillCompleted(weaponToSkill(name))) or v.access.all) then
            return true
        end
    end
end

function weaponSys.getConfigByKey(name, key)
    local weaponConfig = weaponFactoryConfig.list[name]
    for k, v in pairs(weaponConfig) do
        if v.key == key then
            return v
        end
    end
end

local function openWeapon(name, _weaponPreview)
    local weaponConfig = weaponFactoryConfig.list[name]
    local options = {}
    local header = {}
    local weaponPreview = _weaponPreview or startWeaponPreview(name, joaat(name), weaponFactoryConfig.preview[currentConfig])
    for k, v in pairs(weaponConfig) do
        local access = (v.access.gang and v.access.gang[ESX.PlayerData.gang.name]) or (v.access.skill and doesSkillCompleted(weaponToSkill(name))) or v.access.all
        if not header[v.type] then
            header[v.type] = true
            table.insert(options, {label = ('---%s---'):format(weaponFactoryConfig.types[v.type]), disableInput = true, close = false})
        end
        local config = ESX.CopyTable(v)
        config.access = access
        config.active = weaponSet[name] and weaponSet[name][v.key] and weaponSet[name][v.key] ~= 'removed'
        table.insert(options, {label = ('%s %s%s'):format(v.label, access and '🔓' or '', weaponSet[name] and weaponSet[name][v.key] and weaponSet[name][v.key] ~= 'removed' and '✔️' or '❌'), disableInput = true, args = config})
        if weaponSet[name] and weaponSet[name][v.key] and weaponSet[name][v.key] ~= 'removed' then
            if v.type == 1 then
                weaponPreview.changeTint(v.num)
            elseif v.type == 2 then
                weaponPreview.changeComponents(v.name, true)
            end
        end
    end
    lib.registerMenu({
        id = 'weapon_custom2',
        title = ESX.GetWeaponLabel(name),
        position = 'top-left',
        options = options,
        onClose = function(keyPressed)
            weaponPreview.destroy()
            openWeaponCustomMenu()
        end,
        onSelected = function(selected, secondary, args)
            if args then
                if args.type == 1 then
                    weaponPreview.changeTint(args.num)
                elseif args.type == 2 then
                    weaponPreview.changeComponents(args.name, false)
                end
            end
        end,
    }, function(selected, scrollIndex, args)
        if args then
            if not args.access then
                ESX.notification('error', 'Shoma in gozine ra hanooz be be dast nayavardid')
                openWeapon(name, weaponPreview)
                return
            end
            if args.active then
                local alert = lib.alertDialog({
                    header = 'Deactive Attachment',
                    content = 'Aya mayel be gheyre fa\'al kardan in attachment hastid?',
                    centered = true,
                    cancel = true
                })
                if alert ~= 'confirm' then
                    openWeapon(name, weaponPreview)
                    return
                end
            end
            ESX.TriggerServerEvent('weapon:toggleSet', name, args)
            Wait(1000)
            openWeapon(name, weaponPreview)
        end
    end)
    lib.showMenu('weapon_custom2')
end

function openWeaponCustomMenu()
    local options = {}
    for k, v in pairs(weaponFactoryConfig.list) do
        local access = haveAccessToWeapon(k)
        table.insert(options, {label = ESX.GetWeaponLabel(k) .. (access and '✔️' or '❌'), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(k), args = {name = k}})
    end
    table.sort(options, function(a, b)
        return a.args.name < b.args.name
    end)
    if #options > 0 then
        lib.registerMenu({
            id = 'weapon_custom',
            title = 'Weapon customization🔫',
            position = 'top-left',
            options = options
        }, function(selected, scrollIndex, args)
            openWeapon(args.name)
        end)
        lib.showMenu('weapon_custom')
    else
        ESX.chatMessage('Shoma dastresi be guni nadarid', 'plarms')
    end
end

function weaponSys.applyWeapon(name)
    if weaponSet[name] then
        local weaponHash = weaponSys.getWeaponHash(name)
        --
        for k, v in pairs(weaponSet[name]) do
            local config = weaponSys.getConfigByKey(name, k)
            if v == 'removed' and weaponSys.haveAccessToAttach(name, k) then
                if config.type == 1 then
                    if GetPedWeaponTintIndex(SUN.ped, weaponHash) == config.num then
                        SetPedWeaponTintIndex(SUN.ped, weaponHash, 0)
                    end
                elseif config.type == 2 then
                    local componentHash = ESX.GetWeaponComponent(ESX.GetWeapon(name).name, config.name).hash
                    if HasPedGotWeaponComponent(SUN.ped, weaponHash, componentHash) then
                        RemoveWeaponComponentFromPed(SUN.ped, weaponHash, componentHash)
                    end
                elseif config.type == 3 then
                    local realWeaponHash = joaat(name)
                    local weaponHash = joaat(config.name)
                    if HasPedGotWeapon(SUN.ped, weaponHash, false) then
                        local ammo = GetAmmoInPedWeapon(SUN.ped, weaponHash)
                        RemoveWeaponFromPed(SUN.ped, weaponHash)
                        GiveWeaponToPed(SUN.ped, realWeaponHash, 0, false, false)
                        SetPedAmmo(PlayerPedId(), realWeaponHash, ammo)
                        TriggerEvent('core:reloadWeaponComponent', name)
                    end
                end
                weaponSet[name][k] = nil
            end
        end
        --
        for k, v in pairs(weaponSet[name]) do
            local config = weaponSys.getConfigByKey(name, k)
            if v ~= 'removed' and weaponSys.haveAccessToAttach(name, k) then
                if config.type == 1 then
                    if GetPedWeaponTintIndex(SUN.ped, weaponHash) ~= config.num then
                        SetPedWeaponTintIndex(SUN.ped, weaponHash, config.num)
                    end
                elseif config.type == 2 then
                    local componentHash = ESX.GetWeaponComponent(ESX.GetWeapon(name).name, config.name).hash
                    if not HasPedGotWeaponComponent(SUN.ped, weaponHash, componentHash)then
                        GiveWeaponComponentToPed(SUN.ped, weaponHash, componentHash)
                    end
                elseif config.type == 3 then
                    local realWeaponHash = joaat(name)
                    local weaponHash = joaat(config.name)
                    if not HasPedGotWeapon(SUN.ped, weaponHash, false) then
                        local ammo = GetAmmoInPedWeapon(SUN.ped, realWeaponHash)
                        RemoveWeaponFromPed(SUN.ped, realWeaponHash)
                        GiveWeaponToPed(SUN.ped, weaponHash, 0, false, false)
                        SetPedAmmo(PlayerPedId(), weaponHash, ammo)
                        TriggerEvent('core:reloadWeaponComponent', name)
                    end
                end
            end
        end
    end
end

function weaponSys.applySet()
    for k, v in pairs(weaponSet) do
        weaponSys.applyWeapon(k)
    end
end

function weaponSys.getWeaponHash(name, m2)
    name = name:upper()
    -- if not m2 then
    --     if weaponFactoryConfig.weapons[name] then
    --         for k, v in pairs(weaponFactoryConfig.weapons[name]) do
    --             if HasPedGotWeapon(SUN.ped, joaat(v), false) then
    --                 return joaat(v)
    --             end
    --         end
    --         return joaat(name)
    --     else
    --         return joaat(name)
    --     end
    -- else
    --     for k, v in pairs(weaponSet[name]) do
    --         if v.type == 3 then
    --             local config = weaponSys.getConfigByKey(name, k)
    --             return config.name
    --         end
    --     end
    -- end
    if weaponSet[name] then
        for k, v in pairs(weaponSet[name]) do
            if v.type == 3 then
                local config = weaponSys.getConfigByKey(name, k)
                if HasPedGotWeapon(SUN.ped, joaat(config.name), false) then
                    return joaat(config.name)
                end
            end
        end
    end
    return joaat(name)
end

function weaponSys.getRealWeaponHash(name, m2)
    if name then
        name = name:upper()
        -- if not m2 then
        --     if weaponFactoryConfig.weapons[name] then
        --         for k, v in pairs(weaponFactoryConfig.weapons[name]) do
        --             if HasPedGotWeapon(SUN.ped, joaat(v), false) then
        --                 return joaat(v)
        --             end
        --         end
        --         return joaat(name)
        --     else
        --         return joaat(name)
        --     end
        -- else
        --     for k, v in pairs(weaponSet[name]) do
        --         if v.type == 3 then
        --             local config = weaponSys.getConfigByKey(name, k)
        --             return config.name
        --         end
        --     end
        -- end
        for k, v in pairs(weaponFactoryConfig.weapons) do
            for k2, v2 in pairs(v) do
                if v2 == name then
                    return joaat(k)
                end
            end
        end
        return joaat(name)
    end
end

function weaponSys.getRealWeaponName(name, m2)
    name = name:upper()
    for k, v in pairs(weaponFactoryConfig.weapons) do
        for k2, v2 in pairs(v) do
            if v2 == name then
                return k
            end
        end
    end
end


RegisterNetEvent('weapon:updateWeaponSet', function(name, data)
    weaponSet[name] = data
    weaponSys.applyWeapon(name)
end)

RegisterNetEvent('weapon:applyWeapon', function(name)
    weaponSys.applyWeapon(name)
end)

exports('getWeaponHash', weaponSys.getWeaponHash)
exports('getRealWeaponHash', weaponSys.getRealWeaponHash)
exports('getRealWeaponName', weaponSys.getRealWeaponName)


function startWeaponPreview(name, weaponHash, coords)
    if currentPreview ~= name then
        currentPreview = name
        local currentWeaponName = name
        local currentHash = weaponHash
        local currentModel = GetWeapontypeModel(weaponHash)
        local object = 0
        local rotation = vec(0, 0, coords.w + 90)
        local camera
        local currentEdit = {components = {}}
        local currentZoom = 60.0

        RequestModel(currentModel)
        while not HasModelLoaded(currentModel) do
            Wait(100)
        end
        object = CreateWeaponObject(currentHash, 0, coords.x, coords.y, coords.z, false, 1.0, 0)
        AddEventHandler('onResourceStop', function()
            DeleteEntity(object)
        end)
        SetEntityCollision(object, false, false)
        FreezeEntityPosition(object, true)
        SetEntityRotation(object, rotation.x, rotation.y, rotation.z, 2, true)
        -- SetEntityHeading(object, coords.w + 90)
        SetEntityAsMissionEntity(object, true, true)
        camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(camera, GetOffsetFromEntityInWorldCoords(object, 0.0, -1.0, 0.0))
        SetCamFov(camera, currentZoom)
        PointCamAtEntity(camera, object, 0.0, 0.0, 0.0, true)
        SetCamActive(camera, true)
        RenderScriptCams(true, true, 500, true, true)

        CreateThread(function()
            while currentPreview == name do
                Wait(0)
                local x, y = GetDisabledControlNormal(0, 1), GetDisabledControlNormal(0, 2)
                rotation = vector3(rotation.x + y * 5.0, rotation.y, rotation.z + x * 5.0)
                SetEntityRotation(object, rotation.x, rotation.y, rotation.z, 2, true)

                local scrollUp = IsControlJustPressed(0, 15)  -- Scroll Up (INPUT_WEAPON_WHEEL_NEXT)
                local scrollDown = IsControlJustPressed(0, 14)  -- Scroll Down (INPUT_WEAPON_WHEEL_PREV)

                if scrollUp then
                    currentZoom = math.max(currentZoom - 7.0, 10.0)  -- Zoom in
                elseif scrollDown then
                    currentZoom = math.min(currentZoom + 7.0, 200.0)  -- Zoom out
                end

                -- Apply the updated zoom level (FOV) to the camera
                SetCamFov(camera, currentZoom)
            end
        end)
        local cb = {}
        function cb.destroy()
            SetModelAsNoLongerNeeded(currentModel)
            DeleteEntity(object)
            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(camera, false)
            currentPreview = nil
        end
        function cb.clear()
            currentEdit.tint = nil

            local coords = GetEntityCoords(object)
            DeleteObject(object)
            object = CreateWeaponObject(currentHash, 0, coords.x, coords.y, coords.z, false, 1.0, 0)
            SetEntityCollision(object, false, false)
            FreezeEntityPosition(object, true)
            SetEntityRotation(object, rotation.x, rotation.y, rotation.z, 2, true)
            SetEntityCoords(object, coords)
            -- SetEntityHeading(object, coords.w + 90)
            SetEntityAsMissionEntity(object, true, true)
            PointCamAtEntity(camera, object, 0.0, 0.0, 0.0, true)
            for k, v in pairs(currentEdit.components) do
                if v == true then
                    local model = GetWeaponComponentTypeModel(k)
                    if IsModelValid(model) then
                        ESX.Streaming.RequestModel(model, function()
                            GiveWeaponComponentToWeaponObject(object, k)
                            SetModelAsNoLongerNeeded(model)
                        end)
                    end
                else
                    currentEdit.components[k] = nil
                end
            end
        end
        function cb.changeTint(tint)
            cb.clear()
            currentEdit.tint = tint
            SetWeaponObjectTintIndex(object, tint)
        end
        function cb.changeComponents(name, permanent)
            cb.clear()
            local compdata = ESX.GetWeaponComponent(currentWeaponName, name)
            if compdata and compdata.hash and not currentEdit.components[compdata.hash] then
                local model = GetWeaponComponentTypeModel(compdata.hash)
                if IsModelValid(model) then
                    ESX.Streaming.RequestModel(model, function()
                        GiveWeaponComponentToWeaponObject(object, compdata.hash)
                        currentEdit.components[compdata.hash] = permanent
                        SetModelAsNoLongerNeeded(model)
                    end)
                end
            end
        end
        return cb
    end
end