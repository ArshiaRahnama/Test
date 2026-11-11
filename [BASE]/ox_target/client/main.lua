if not lib.checkDependency('ox_lib', '3.30.0', true) then return end

lib.locale()

local utils = require 'client.utils'
local state = require 'client.state'
local options = require 'client.api'.getTargetOptions()

require 'client.debug'
require 'client.defaults'
require 'client.compat.qtarget'

local SendNuiMessage = SendNuiMessage
local GetEntityCoords = GetEntityCoords
local GetEntityType = GetEntityType
local HasEntityClearLosToEntity = HasEntityClearLosToEntity
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local GetEntityModel = GetEntityModel
local IsDisabledControlJustPressed = IsDisabledControlJustPressed
local DisableControlAction = DisableControlAction
local DisablePlayerFiring = DisablePlayerFiring
local GetModelDimensions = GetModelDimensions
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local currentTarget = {}
local currentMenu
local menuChanged
local menuHistory = {}
local nearbyZones

-- Toggle ox_target, instead of holding the hotkey
local toggleHotkey = GetConvarInt('ox_target:toggleHotkey', 1) == 1
local mouseButton = GetConvarInt('ox_target:leftClick', 1) == 1 and 24 or 25
local debug = GetConvarInt('ox_target:debug', 0) == 1
local vec0 = vec3(0, 0, 0)

-- Unique behaviour: the eye is only usable while unarmed (or holding these)
local whiteListWeapon = {
    [`WEAPON_UNARMED`] = true,
    [`WEAPON_OBJECT`] = true,
    [`WEAPON_PETROLCAN`] = true,
}

local ESX
local playerDead = false

---Lazily grabs the shared ESX object (safe if essentialmode is not started yet)
local function getPlayerData()
    if not ESX and GetResourceState('essentialmode') == 'started' then
        local ok, obj = pcall(function() return exports['essentialmode']:getSharedObject() end)
        if ok and type(obj) == 'table' then ESX = obj end
    end

    if ESX and ESX.GetPlayerData then
        local ok, data = pcall(ESX.GetPlayerData)
        if ok and type(data) == 'table' then return data end
    end

    return {}
end

local function isPlayerDead()
    local ped = cache.ped
    local ls = LocalPlayer.state

    if ls.isDead or ls.isInjure then return true end
    if ped and ped ~= 0 and IsEntityDead(ped) then return true end

    local data = getPlayerData()

    return (data.IsDead or data.IsInjure) and true or false
end

local function isPlayerCuffed()
    return getPlayerData().HandCuffed == 1
end

local function isHandsUp()
    if GetResourceState('Unique_utils') ~= 'started' then return false end

    local ok, result = pcall(function() return exports['Unique_utils']:getHandupState() end)

    return ok and result and true or false
end

local function isEyeDisabled()
    if LocalPlayer.state.disableEye then return true end

    if GetResourceState('essentialmode') == 'started' then
        local ok, result = pcall(function() return exports['essentialmode']:isControlDisabled('f2') end)

        if ok and result then return true end
    end

    return false
end

---Returns true when the player is currently not allowed to use the eye
local function isTargetingBlocked()
    if not whiteListWeapon[GetSelectedPedWeapon(cache.ped)] then return true end
    if cache.vehicle then return true end

    return isHandsUp() or isPlayerCuffed()
end

---Resolves labels that are functions / function references (cross-resource exports)
---@param label any
---@return string
local function resolveLabel(label)
    local labelType = type(label)

    if labelType == 'string' then return label end
    if labelType ~= 'function' and labelType ~= 'table' then return '' end

    local ok, result = pcall(label)

    if not ok and labelType == 'table' then
        ok, result = pcall(function() return msgpack.unpack(msgpack.pack(label))() end)
    end

    if ok and result ~= nil then return tostring(result) end

    return ''
end

---@param list table
---@param extra? table
---@return table
local function copyOptions(list, extra)
    local copy = {}
    local count = #list

    for i = 1, count do
        local option = list[i]

        if option.label ~= nil and type(option.label) ~= 'string' then
            option = table.clone(option)
            option.label = resolveLabel(option.label)
        end

        copy[i] = option
    end

    if extra then copy[count + 1] = extra end

    return copy
end

---Builds the NUI payload without touching the stored options (labels resolved, close button appended)
---@param zones table
---@return table
local function buildPayload(zones)
    local payload = {}

    for key, list in pairs(options) do
        if type(list) == 'table' then
            local extra

            if key == 'globalTarget' and #list > 0 then
                extra = {
                    icon = 'fa-solid fa-circle-chevron-left',
                    label = 'بستن',
                    name = 'builtin:close',
                }
            end

            payload[key] = copyOptions(list, extra)
        end
    end

    local zonePayload = {}

    for i = 1, #zones do
        zonePayload[i] = copyOptions(zones[i])
    end

    return { event = 'setTarget', options = payload, zones = zonePayload }
end

---Finds an entity that can be targeted without aiming at it (addModel2 / addLocalEntity2)
---@param playerCoords vector3
---@return number? entity, number? model, vector3? coords
local function findNoRayEntity(playerCoords)
    local bestEntity, bestModel, bestDistance

    for model in pairs(state.getNoRayModels()) do
        local entity = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, model, false, false, false)

        if entity and entity ~= 0 and DoesEntityExist(entity) then
            local dist = #(playerCoords - GetEntityCoords(entity))

            if not bestDistance or dist < bestDistance then
                bestEntity, bestModel, bestDistance = entity, model, dist
            end
        end
    end

    for entity in pairs(state.getNoRayEntities()) do
        if DoesEntityExist(entity) then
            local dist = #(playerCoords - GetEntityCoords(entity))

            if dist < 3.0 and (not bestDistance or dist < bestDistance) then
                bestEntity, bestModel, bestDistance = entity, GetEntityModel(entity), dist
            end
        end
    end

    if bestEntity then return bestEntity, bestModel, GetEntityCoords(bestEntity) end
end

---@param option OxTargetOption
---@param distance number
---@param endCoords vector3
---@param entityHit? number
---@param entityType? number
---@param entityModel? number | false
local function shouldHide(option, distance, endCoords, entityHit, entityType, entityModel)
    if option.menuName ~= currentMenu then
        return true
    end

    if distance > (option.distance or 3) then
        return true
    end

    if option.groups and not utils.hasPlayerGotGroup(option.groups) then
        return true
    end

    if option.items and not utils.hasPlayerGotItems(option.items, option.anyItem) then
        return true
    end

    local bone = entityModel and option.bones or nil

    if bone then
        ---@cast entityHit number
        ---@cast entityType number
        ---@cast entityModel number

        local _type = type(bone)

        if _type == 'string' then
            local boneId = GetEntityBoneIndexByName(entityHit, bone)

            if boneId ~= -1 and #(endCoords - GetEntityBonePosition_2(entityHit, boneId)) <= 2 then
                bone = boneId
            else
                return true
            end
        elseif _type == 'table' then
            local closestBone, boneDistance

            for j = 1, #bone do
                local boneId = GetEntityBoneIndexByName(entityHit, bone[j])

                if boneId ~= -1 then
                    local dist = #(endCoords - GetEntityBonePosition_2(entityHit, boneId))

                    if dist <= (boneDistance or 1) then
                        closestBone = boneId
                        boneDistance = dist
                    end
                end
            end

            if closestBone then
                bone = closestBone
            else
                return true
            end
        end
    end

    local offset = entityModel and option.offset or nil

    if offset then
        ---@cast entityHit number
        ---@cast entityType number
        ---@cast entityModel number

        if not option.absoluteOffset then
            local min, max = GetModelDimensions(entityModel)
            offset = (max - min) * offset + min
        end

        offset = GetOffsetFromEntityInWorldCoords(entityHit, offset.x, offset.y, offset.z)

        if #(endCoords - offset) > (option.offsetSize or 1) then
            return true
        end
    end

    if entityType == 1 and entityHit and entityHit ~= 0 and not IsEntityVisible(entityHit) then
        return true
    end

    if playerDead then
        return true
    end

    if option.canInteract then
        local success, resp = pcall(option.canInteract, entityHit, distance, endCoords, option.name, bone)
        return not success or not resp
    end
end

local function startTargeting()
    if state.isDisabled() or state.isActive() or IsNuiFocused() or IsPauseMenuActive() then return end

    state.setActive(true)

    local flag = 511
    local hit, entityHit, endCoords, distance, lastEntity, entityType, entityModel, hasTarget, zonesChanged
    local zones = {}

    CreateThread(function()
        local dict, texture = utils.getTexture()
        local lastCoords

        while state.isActive() do
            lastCoords = endCoords == vec0 and lastCoords or endCoords or vec0

            if debug then
                DrawMarker(28, lastCoords.x, lastCoords.y, lastCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2,
                    0.2,
                    ---@diagnostic disable-next-line: param-type-mismatch
                    255, 42, 24, 100, false, false, 0, true, false, false, false)
            end

            utils.drawZoneSprites(dict, texture)
            DisablePlayerFiring(cache.playerId, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            if state.isNuiFocused() then
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)

                if not hasTarget or options and IsDisabledControlJustPressed(0, 25) then
                    state.setNuiFocus(false, false)
                end
            elseif hasTarget and IsDisabledControlJustPressed(0, mouseButton) then
                state.setNuiFocus(true, true)
            end

            Wait(0)
        end

        SetStreamedTextureDictAsNoLongerNeeded(dict)
    end)

    while state.isActive() do
        playerDead = isPlayerDead()

        if not state.isNuiFocused() and lib.progressActive() or isTargetingBlocked() then
            state.setActive(false)
            break
        end

        local playerCoords = GetEntityCoords(cache.ped)
        hit, entityHit, endCoords = lib.raycast.fromCamera(flag, 4, 20)
        distance = #(playerCoords - endCoords)

        if entityHit ~= 0 and entityHit ~= lastEntity then
            local success, result = pcall(GetEntityType, entityHit)
            entityType = success and result or 0
        end

        if entityType == 0 then
            local _flag = flag == 511 and 26 or 511
            local _hit, _entityHit, _endCoords = lib.raycast.fromCamera(_flag, 4, 20)
            local _distance = #(playerCoords - _endCoords)

            if _distance < distance then
                flag, hit, entityHit, endCoords, distance = _flag, _hit, _entityHit, _endCoords, _distance

                if entityHit ~= 0 then
                    local success, result = pcall(GetEntityType, entityHit)
                    entityType = success and result or 0
                end
            end
        end

        -- addModel2 / addLocalEntity2: target without aiming when nothing else is hit
        if entityHit == 0 then
            local noRayEntity, noRayModel, noRayCoords = findNoRayEntity(playerCoords)

            if noRayEntity then
                entityHit, entityType, entityModel = noRayEntity, GetEntityType(noRayEntity), noRayModel
                endCoords = noRayCoords
                distance = #(playerCoords - endCoords)
                hit = true
            end
        end

        nearbyZones, zonesChanged = utils.getNearbyZones(endCoords)

        local entityChanged = entityHit ~= lastEntity
        local newOptions = (zonesChanged or entityChanged or menuChanged) and true

        if entityHit > 0 and entityChanged then
            currentMenu = nil

            if flag ~= 511 then
                entityHit = HasEntityClearLosToEntity(entityHit, cache.ped, 7) and entityHit or 0
            end

            if lastEntity ~= entityHit and debug then
                if lastEntity then
                    SetEntityDrawOutline(lastEntity, false)
                end

                if entityType ~= 1 then
                    SetEntityDrawOutline(entityHit, true)
                end
            end

            if entityHit > 0 then
                local success, result = pcall(GetEntityModel, entityHit)
                entityModel = success and result
            end
        end

        if hasTarget and (zonesChanged or entityChanged and hasTarget > 1) then
            SendNuiMessage('{"event": "leftTarget"}')

            if entityChanged then options:wipe() end

            if debug and lastEntity > 0 then SetEntityDrawOutline(lastEntity, false) end

            hasTarget = false
        end

        if newOptions and entityModel and entityHit > 0 then
            options:set(entityHit, entityType, entityModel)
        end

        lastEntity = entityHit
        currentTarget.entity = entityHit
        currentTarget.coords = endCoords
        currentTarget.distance = distance
        local hidden = 0
        local totalOptions = 0

        for k, v in pairs(options) do
            local optionCount = #v
            local dist = k == '__global' and 0 or distance
            totalOptions += optionCount

            for i = 1, optionCount do
                local option = v[i]
                local hide = shouldHide(option, dist, endCoords, entityHit, entityType, entityModel)

                if option.hide ~= hide then
                    option.hide = hide
                    newOptions = true
                end

                if hide then hidden += 1 end
            end
        end

        if zonesChanged then table.wipe(zones) end

        for i = 1, #nearbyZones do
            local zoneOptions = nearbyZones[i].options
            local optionCount = #zoneOptions
            totalOptions += optionCount
            zones[i] = zoneOptions

            for j = 1, optionCount do
                local option = zoneOptions[j]
                local hide = shouldHide(option, distance, endCoords, entityHit)

                if option.hide ~= hide then
                    option.hide = hide
                    newOptions = true
                end

                if hide then hidden += 1 end
            end
        end

        if newOptions then
            if hasTarget == 1 and (totalOptions - hidden) > 1 then
                hasTarget = true
            end

            if hasTarget and hidden == totalOptions then
                if hasTarget and hasTarget ~= 1 then
                    hasTarget = false
                    SendNuiMessage('{"event": "leftTarget"}')
                end
            elseif menuChanged or hasTarget ~= 1 and hidden ~= totalOptions then
                hasTarget = options.size

                if currentMenu and options.__global[1]?.name ~= 'builtin:goback' then
                    table.insert(options.__global, 1,
                        {
                            icon = 'fa-solid fa-circle-chevron-left',
                            label = 'بازگشت',
                            name = 'builtin:goback',
                            menuName = currentMenu,
                            openMenu = 'home'
                        })
                end

                SendNuiMessage(json.encode(buildPayload(zones), { sort_keys = true }))
            end

            menuChanged = false
        end

        if toggleHotkey and IsPauseMenuActive() then
            state.setActive(false)
        end

        if not hasTarget or hasTarget == 1 then
            flag = flag == 511 and 26 or 511
        end

        Wait(hit and 50 or 100)
    end

    if lastEntity and debug then
        SetEntityDrawOutline(lastEntity, false)
    end

    -- only release focus if it is still ours (an onSelect may have opened another menu)
    if state.isNuiFocused() then
        state.setNuiFocus(false)
    end

    SendNuiMessage('{"event": "visible", "state": false}')
    table.wipe(currentTarget)
    options:wipe()

    if nearbyZones then table.wipe(nearbyZones) end
end

do
    ---@type KeybindProps
    local keybind = {
        name = 'ox_target',
        defaultKey = GetConvar('ox_target:defaultHotkey', 'LMENU'),
        defaultMapper = 'keyboard',
        description = locale('toggle_targeting'),
    }

    if toggleHotkey then
        function keybind:onPressed()
            if state.isActive() then
                return state.setActive(false)
            end

            if isTargetingBlocked() or isPlayerDead() or isEyeDisabled() then return end

            return startTargeting()
        end
    else
        keybind.onPressed = startTargeting

        function keybind:onReleased()
            state.setActive(false)
        end
    end

    lib.addKeybind(keybind)
end

---@generic T
---@param option T
---@param server? boolean
---@return T
local function getResponse(option, server)
    local response = table.clone(option)
    response.entity = currentTarget.entity
    response.zone = currentTarget.zone
    response.coords = currentTarget.coords
    response.distance = currentTarget.distance

    if server then
        response.entity = response.entity ~= 0 and NetworkGetEntityIsNetworked(response.entity) and
            NetworkGetNetworkIdFromEntity(response.entity) or 0
    end

    response.icon = nil
    response.groups = nil
    response.items = nil
    response.canInteract = nil
    response.onSelect = nil
    response.export = nil
    response.event = nil
    response.serverEvent = nil
    response.command = nil

    return response
end

RegisterNUICallback('select', function(data, cb)
    cb(1)

    local zone = data[3] and nearbyZones[data[3]]

    ---@type OxTargetOption?
    local option = zone and zone.options[data[2]] or options[data[1]][data[2]]

    if option then
        if option.openMenu then
            local menuDepth = #menuHistory

            if option.name == 'builtin:goback' then
                option.menuName = option.openMenu
                option.openMenu = menuHistory[menuDepth]

                if menuDepth > 0 then
                    menuHistory[menuDepth] = nil
                end
            else
                menuHistory[menuDepth + 1] = currentMenu
            end

            menuChanged = true
            currentMenu = option.openMenu ~= 'home' and option.openMenu or nil

            options:wipe()
        else
            state.setNuiFocus(false)
            state.setActive(false)
        end

        currentTarget.zone = zone?.id

        if option.onSelect then
            option.onSelect(option.qtarget and currentTarget.entity or getResponse(option))
        elseif option.export then
            exports[option.resource or zone.resource][option.export](nil, getResponse(option))
        elseif option.event then
            TriggerEvent(option.event, getResponse(option))
        elseif option.serverEvent then
            TriggerServerEvent(option.serverEvent, getResponse(option, true))
        elseif option.command then
            ExecuteCommand(option.command)
        end

        if option.menuName == 'home' then return end
    end

    if not option?.openMenu and IsNuiFocused() then
        state.setActive(false)
    end
end)
