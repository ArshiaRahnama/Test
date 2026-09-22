--[[
    Unique_Event - CAPTURE (client)
    Zone blips/markers, capture-point detection, out-of-zone damage, HUD wiring, death handling.
]]

local Cap = { active = false, zones = {}, round = { active = false, endsAt = 0 }, blips = {}, currentZone = nil, myGang = 'nogang', boardsOn = true }

local function clearBlips()
    for _, b in pairs(Cap.blips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    Cap.blips = {}
end

local function ownerColor(owner)
    if not owner or owner == '' then return 255, 255, 255 end
    if owner == Cap.myGang then return 0, 220, 100 end
    return 255, 45, 85
end

local function drawBlips()
    clearBlips()
    for i, z in ipairs(Cap.zones) do
        local blip = AddBlipForCoord(z.x, z.y, z.z)
        SetBlipSprite(blip, Config.Capture.ZoneBlip.Sprite)
        SetBlipScale(blip, Config.Capture.ZoneBlip.Scale)
        local r, g, b = ownerColor(z.owner)
        SetBlipColour(blip, (z.owner == Cap.myGang) and 2 or (z.owner and 1 or 0))
        BeginTextCommandSetBlipName('STRING'); AddTextComponentSubstringPlayerName(z.name .. (z.owner and (' (' .. z.owner .. ')') or ''))
        EndTextCommandSetBlipName(blip)
        Cap.blips[i] = blip
    end
end

RegisterNetEvent('ue:capture:join')
AddEventHandler('ue:capture:join', function(data)
    Cap.active = true
    Cap.zones = data.zones
    Cap.round = { active = data.active, endsAt = data.endsAt }
    Cap.myGang = data.gang or UE.Gang
    drawBlips()
    UE.SetEvent('capture')
    if data.entry then UE.Teleport(data.entry.x, data.entry.y, data.entry.z) end
    Cap.Show(true)
    UE.WatchDeath(function() return Cap.active end, function()
        TriggerServerEvent('ue:capture:died')
    end)
end)

RegisterNetEvent('ue:capture:leave')
AddEventHandler('ue:capture:leave', function(returnCoord)
    Cap.active = false
    clearBlips()
    Cap.Show(false)
    UE.SetEvent(nil)
    if returnCoord then UE.Teleport(returnCoord.x, returnCoord.y, returnCoord.z) end
end)

RegisterNetEvent('ue:capture:zones')
AddEventHandler('ue:capture:zones', function(zones)
    -- merge owners into the full zone list we already have (keeps x/y/z)
    for _, z in ipairs(zones) do
        for _, full in ipairs(Cap.zones) do
            if full.name == z.name then full.owner = z.owner break end
        end
    end
    drawBlips()
    Cap.PushZoneChips()
end)

RegisterNetEvent('ue:capture:respawn')
AddEventHandler('ue:capture:respawn', function()
    CreateThread(function()
        UE.Fade(true, 600)
        Wait(650)
        UE.Revive(8000)
        SetEntityHealth(PlayerPedId(), 200)
        if not Config.Capture.UsePersonalWeapons then RemoveAllPedWeapons(PlayerPedId(), true) end
        SetPedArmour(PlayerPedId(), Config.Capture.DefaultArmor)
        local z = Cap.zones[math.random(#Cap.zones)]
        if z then UE.Teleport(z.x + math.random(-20, 20) + 0.0, z.y + math.random(-20, 20) + 0.0, z.z + 5.0) end
        Wait(300)
        UE.Fade(false, 600)
    end)
end)

RegisterNetEvent('ue:capture:applyDamage')
AddEventHandler('ue:capture:applyDamage', function(amount)
    local ped = PlayerPedId()
    if IsEntityDead(ped) then return end
    local hp = GetEntityHealth(ped) - amount
    SetEntityHealth(ped, math.max(hp, 101))
end)

RegisterNetEvent('ue:capture:captureProgress')
AddEventHandler('ue:capture:captureProgress', function(zone, sec, need, state)
    UE.Send('capProgress', { zone = zone, sec = sec, need = need, state = state })
end)

RegisterNetEvent('ue:capture:captureProgressHide')
AddEventHandler('ue:capture:captureProgressHide', function() UE.Send('capProgressHide') end)

RegisterNetEvent('ue:capture:kill')
AddEventHandler('ue:capture:kill', function(d) UE.Send('capKill', d) end)
RegisterNetEvent('ue:capture:killPersonal')
AddEventHandler('ue:capture:killPersonal', function(youKilled, youDied)
    if youKilled then UE.Sound('kill.ogg', 0.5) end
end)

function Cap.Show(on) UE.Send('capShow', { show = on }) end
function Cap.PushZoneChips()
    local list = {}
    for _, z in ipairs(Cap.zones) do
        local dist = #(GetEntityCoords(PlayerPedId()) - vector3(z.x, z.y, z.z))
        list[#list + 1] = { name = z.name, owner = z.owner, state = (not z.owner and 'free') or (z.owner == Cap.myGang and 'mine' or 'enemy'), _d = dist }
    end
    table.sort(list, function(a, b) return a._d < b._d end)
    UE.Send('capZones', { zones = list })
end

-- ---------------------------------------------------------------------------
-- Zone tracking: which zone (if any) is the player standing near/at the point of
-- ---------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(500)
        if Cap.active then
            local pc = GetEntityCoords(PlayerPedId())
            local nearestZone, nearestDist, atPoint = nil, 999999.0, false
            for i, z in ipairs(Cap.zones) do
                local d = UE.Dist(pc, vector3(z.x, z.y, z.z))
                if d < nearestDist then nearestDist = d nearestZone = i atPoint = d <= Config.Capture.CaptureRadius end
            end
            if nearestZone and atPoint then
                if Cap.currentZone ~= nearestZone then
                    Cap.currentZone = nearestZone
                    TriggerServerEvent('ue:capture:inZone', nearestZone)
                end
                if nearestDist > Config.Capture.ZoneRadius then
                    TriggerServerEvent('ue:capture:outOfZoneDamage')
                end
            else
                if Cap.currentZone then
                    Cap.currentZone = nil
                    TriggerServerEvent('ue:capture:inZone', nil)
                end
                -- still apply out-of-zone damage if far from every zone
                if nearestDist > Config.Capture.ZoneRadius then TriggerServerEvent('ue:capture:outOfZoneDamage') end
            end
            Cap.PushZoneChips()
        end
        Wait(0)
    end
end)

-- Capture point markers
CreateThread(function()
    while true do
        Wait(0)
        if Cap.active then
            local pc = GetEntityCoords(PlayerPedId())
            for _, z in ipairs(Cap.zones) do
                local d = UE.Dist2D(pc, vector3(z.x, z.y))
                if d < 60.0 then
                    local r, g, b = ownerColor(z.owner)
                    DrawMarker(1, z.x, z.y, z.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Capture.CaptureRadius * 2, Config.Capture.CaptureRadius * 2, 2.0, r, g, b, 90, false, true, 2, false, nil, nil, false)
                end
            end
        else
            Wait(500)
        end
    end
end)

-- board toggle (G)
UE.BindKey('G', 'Unique Event: toggle scoreboard', 'capture', function()
    Cap.boardsOn = not Cap.boardsOn
    UE.Send('capBoards', { show = Cap.boardsOn })
end)

RegisterNetEvent('ue:capture:board')
AddEventHandler('ue:capture:board', function(d) UE.Send('capData', d) end)
