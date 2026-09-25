-- Unique_AdminPanel | client/devtools.lua
-- Developer tools ported from esx_adminmenu (Entity View, copy coords/heading,
-- on-screen coords, vehicle info) and cleaned up for ESX:
--   * no QBCore/Lang/NUI-clipboard dependencies (uses ox_lib's lib.setClipboard)
--   * no 2 MB entity-hash table - model names come from the game itself
--   * destructive actions (delete entity) are announced to the anti-cheat and
--     written to the admin log
-- Everything here is only reachable from the admin menu (Developer Tools),
-- which itself only exists while the player is an on-duty admin.

DevTools = {}

local function round(v, d)
    local p = 10 ^ (d or 0)
    return math.floor(v * p + 0.5) / p
end

local function notify(msg) drawNotification(msg) end

local function copy(text, okMsg)
    lib.setClipboard(tostring(text))
    notify(okMsg or "~g~Copied to clipboard")
end

-- ------------------------------------------------------------- COPY TOOLS --

function DevTools.CopyCoords(kind)
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local h = round(GetEntityHeading(ped), 2)
    local x, y, z = round(c.x, 2), round(c.y, 2), round(c.z, 2)
    if kind == 'vec2' then
        copy(("vector2(%s, %s)"):format(x, y), "~g~vector2 copied")
    elseif kind == 'vec3' then
        copy(("vector3(%s, %s, %s)"):format(x, y, z), "~g~vector3 copied")
    elseif kind == 'vec4' then
        copy(("vector4(%s, %s, %s, %s)"):format(x, y, z, h), "~g~vector4 copied")
    elseif kind == 'heading' then
        copy(h, "~g~Heading copied")
    end
end

-- -------------------------------------------------------- ON-SCREEN TEXT ---

local function draw2D(text, x, y, scale, r, g, b)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r or 255, g or 255, b or 255, 255)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local showCoords = false
function DevTools.ToggleCoords()
    showCoords = not showCoords
    if not showCoords then return showCoords end
    CreateThread(function()
        while showCoords do
            local ped = PlayerPedId()
            local c = GetEntityCoords(ped)
            draw2D(("~w~Ped  ~b~vector4(~w~%s~b~, ~w~%s~b~, ~w~%s~b~, ~w~%s~b~)"):format(
                round(c.x, 2), round(c.y, 2), round(c.z, 2), round(GetEntityHeading(ped), 2)), 0.4, 0.025, 0.4)
            Wait(0)
        end
    end)
    return showCoords
end

local vehInfo = false
function DevTools.ToggleVehicleInfo()
    vehInfo = not vehInfo
    if not vehInfo then return vehInfo end
    CreateThread(function()
        while vehInfo do
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                local hash = GetEntityModel(veh)
                local name = GetLabelText(GetDisplayNameFromVehicleModel(hash))
                draw2D("~b~Vehicle info", 0.4, 0.86, 0.4)
                draw2D(("Entity ~b~%s~s~ | Net ~b~%s"):format(veh, VehToNet(veh)), 0.4, 0.885, 0.35)
                draw2D(("Model ~b~%s~s~ | Hash ~b~%s"):format(name, hash), 0.4, 0.905, 0.35)
                draw2D(("Plate ~b~%s~s~ | Engine ~b~%s~s~ | Body ~b~%s"):format(
                    GetVehicleNumberPlateText(veh), round(GetVehicleEngineHealth(veh), 1), round(GetVehicleBodyHealth(veh), 1)),
                    0.4, 0.925, 0.35)
            end
            Wait(0)
        end
    end)
    return vehInfo
end

-- ------------------------------------------------------------ ENTITY VIEW --

local EV = { distance = 10, freeAim = false, vehicles = false, peds = false, objects = false, running = false }
local aimedEntity = nil
local frozen = {}

DevTools.EntityView = EV

local function modelName(entity)
    local hash = GetEntityModel(entity)
    local ok, name = pcall(GetEntityArchetypeName, entity)
    if ok and name and name ~= '' then return name, hash end
    return 'unknown', hash
end

local function rotToDir(rot)
    local z, x = math.rad(rot.z), math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function rayFromCamera(dist)
    local cam = GetGameplayCamCoord()
    local dest = cam + rotToDir(GetGameplayCamRot(2)) * dist
    local ray = StartShapeTestRay(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 0)
    local _, hit, coords, _, entity = GetShapeTestResult(ray)
    return hit == 1, coords, entity
end

local function drawBox(entity, r, g, b, a)
    local min, max = GetModelDimensions(GetEntityModel(entity))
    local p = {}
    for _, x in ipairs({ min.x, max.x }) do
        for _, y in ipairs({ min.y, max.y }) do
            for _, z in ipairs({ min.z, max.z }) do
                p[#p + 1] = GetOffsetFromEntityInWorldCoords(entity, x, y, z)
            end
        end
    end
    -- corner index = x*4 + y*2 + z  ->  connect corners that differ in one axis
    local edges = { {1,2},{3,4},{5,6},{7,8},{1,3},{2,4},{5,7},{6,8},{1,5},{2,6},{3,7},{4,8} }
    for _, e in ipairs(edges) do
        local a1, b1 = p[e[1]], p[e[2]]
        DrawLine(a1.x, a1.y, a1.z, b1.x, b1.y, b1.z, r, g, b, a)
    end
end

local function entityLines(entity)
    local name, hash = modelName(entity)
    local etype = GetEntityType(entity)
    local pc = GetEntityCoords(PlayerPedId())
    local ec = GetEntityCoords(entity)
    local L = {
        "~y~Entity View",
        ("Model ~y~%s"):format(name),
        ("Hash ~y~%s"):format(hash),
        ("Entity ID ~y~%s~s~ | Net ID ~y~%s"):format(entity, NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or 'n/a'),
    }
    if etype == 1 then
        L[#L + 1] = ("Health ~y~%s~s~/~y~%s~s~ | Armour ~y~%s"):format(GetEntityHealth(entity), GetEntityMaxHealth(entity), GetPedArmour(entity))
    elseif etype == 2 then
        L[#L + 1] = ("Plate ~y~%s"):format(GetVehicleNumberPlateText(entity))
        L[#L + 1] = ("Speed ~y~%s~s~ km/h | Gear ~y~%s"):format(round(GetEntitySpeed(entity) * 3.6, 1), GetVehicleCurrentGear(entity))
        L[#L + 1] = ("Engine ~y~%s~s~ | Body ~y~%s"):format(round(GetVehicleEngineHealth(entity), 1), round(GetVehicleBodyHealth(entity), 1))
    elseif etype == 3 then
        L[#L + 1] = ("Health ~y~%s"):format(GetEntityHealth(entity))
    end
    L[#L + 1] = ("Distance ~y~%s~s~ | Heading ~y~%s"):format(round(#(pc - ec), 2), round(GetEntityHeading(entity), 2))
    L[#L + 1] = ("Coords ~y~vector3(%s, %s, %s)"):format(round(ec.x, 2), round(ec.y, 2), round(ec.z, 2))
    return L
end

local function drawInfoBox(lines)
    local x, y = 0.60, 0.02
    DrawRect(x + 0.09, y + (#lines * 0.0235) / 2 + 0.005, 0.20, #lines * 0.0235 + 0.02, 11, 11, 11, 200)
    for i, line in ipairs(lines) do
        draw2D(line, x + 0.005, y + (i - 1) * 0.0235, i == 1 and 0.45 or 0.33)
    end
end

local function scan(finder, first, nxt, close, drawFn)
    local handle, ent = first()
    if not handle or handle == -1 then return end
    local ok
    local pp = GetEntityCoords(PlayerPedId())
    repeat
        if ent ~= aimedEntity and ent ~= PlayerPedId() and DoesEntityExist(ent) then
            local d = #(pp - GetEntityCoords(ent))
            if d < EV.distance then drawFn(ent, d) end
        end
        ok, ent = nxt(handle)
    until not ok
    close(handle)
end

local function boxIfFar(ent, d)
    if d > 5.0 then drawBox(ent, 255, 255, 255, 200) else drawBox(ent, 255, 220, 0, 220) end
end

local function evThread()
    if EV.running then return end
    EV.running = true
    CreateThread(function()
        while EV.running do
            Wait(0)
            if EV.peds then scan(nil, FindFirstPed, FindNextPed, EndFindPed, boxIfFar) end
            if EV.vehicles then scan(nil, FindFirstVehicle, FindNextVehicle, EndFindVehicle, boxIfFar) end
            if EV.objects then scan(nil, FindFirstObject, FindNextObject, EndFindObject, boxIfFar) end

            if EV.freeAim then
                draw2D("~y~Entity View~w~  [~y~E~w~] delete  [~y~G~w~] freeze  [~y~H~w~] copy coords", 0.36, 0.02, 0.45)
                local hit, coords, entity = rayFromCamera(1000.0)
                local ped = PlayerPedId()
                local pc = GetEntityCoords(ped)
                local r, g, b = 255, 255, 255
                if hit and entity and entity ~= 0 and entity ~= ped and DoesEntityExist(entity)
                    and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                    aimedEntity = entity
                    r, g, b = 0, 255, 0
                    drawBox(entity, 0, 255, 0, 220)
                    drawInfoBox(entityLines(entity))

                    if IsControlJustReleased(0, 47) then -- G
                        frozen[entity] = not frozen[entity]
                        FreezeEntityPosition(entity, frozen[entity])
                        notify(frozen[entity] and "~b~Entity frozen" or "~b~Entity unfrozen")
                    end
                    if IsControlJustReleased(0, 38) then -- E
                        local name = modelName(entity)
                        TriggerServerEvent('Unique_AdminPanel:AntiCheatExempt', 4000, {})
                        NetworkRequestControlOfEntity(entity)
                        SetEntityAsMissionEntity(entity, true, true)
                        DeleteEntity(entity)
                        Wait(50)
                        if DoesEntityExist(entity) then
                            notify("~r~Couldn't delete that entity")
                        else
                            notify("~g~Entity deleted")
                            TriggerServerEvent('Unique_AdminPanel:LogClientAction', "entity_delete", ("model: %s"):format(name))
                        end
                        aimedEntity = nil
                    end
                else
                    aimedEntity = nil
                end
                if hit then
                    if IsControlJustReleased(0, 74) then -- H
                        copy(("vector3(%s, %s, %s)"):format(round(coords.x, 2), round(coords.y, 2), round(coords.z, 2)), "~g~Aim coords copied")
                    end
                    DrawLine(pc.x, pc.y, pc.z, coords.x, coords.y, coords.z, r, g, b, 200)
                    DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, r, g, b, 200, false, true, 2, false, nil, nil, false)
                end
            end

            if not (EV.peds or EV.vehicles or EV.objects or EV.freeAim) then EV.running = false end
        end
    end)
end

function DevTools.SetEntityView(what, state)
    EV[what] = state and true or false
    if EV[what] then evThread() end
end

function DevTools.SetEntityViewDistance(d) EV.distance = tonumber(d) or 10 end

function DevTools.CopyAimedEntityInfo()
    local e = aimedEntity
    if not e or not DoesEntityExist(e) then
        notify("~r~Aim at an entity with Free-aim Entity View first")
        return
    end
    local name, hash = modelName(e)
    local c, rot = GetEntityCoords(e), GetEntityRotation(e)
    copy(("Model Name:\t%s\nModel Hash:\t%s\n\nHeading:\t%s\nCoords:\t\tvector3(%s, %s, %s)\nRotation:\tvector3(%s, %s, %s)"):format(
        name, hash, round(GetEntityHeading(e), 2), round(c.x, 2), round(c.y, 2), round(c.z, 2),
        round(rot.x, 2), round(rot.y, 2), round(rot.z, 2)), "~g~Entity info copied")
end

function DevTools.StopAll()
    EV.freeAim, EV.vehicles, EV.peds, EV.objects = false, false, false, false
    showCoords, vehInfo = false, false
end
