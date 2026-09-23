--[[
    Unique_Event - WARZONE (client)
    Lobby, parachute drop, loot crates, zone circle, downed/revive, gulag, kill feed, HUD wiring.
]]

local WZ = { inMatch = false, crates = {}, squad = {}, hp = 100, armor = 0, cash = 0, uav = 0, heal = 2, vest = 1, revive = 0, downed = false, inGulag = false }

-- ---------------------------------------------------------------------------
-- Lobby
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:warzone:joinLobby')
AddEventHandler('ue:warzone:joinLobby', function(lobbyCoord)
    UE.SetEvent('warzone')
    UE.Teleport(lobbyCoord.x + math.random(-5, 5) + 0.0, lobbyCoord.y + math.random(-5, 5) + 0.0, lobbyCoord.z)
    UE.Send('wzShow', { show = true })
    UE.Send('wzLobby', { show = true, players = 1, needed = Config.WarZone.MinPlayers })
end)

RegisterNetEvent('ue:warzone:lobby')
AddEventHandler('ue:warzone:lobby', function(d)
    UE.Send('wzLobby', { show = true, players = d.players, needed = d.needed, mode = d.mode, map = d.map, countdown = d.countdown })
end)

RegisterNetEvent('ue:warzone:leave')
AddEventHandler('ue:warzone:leave', function(exit)
    WZ.inMatch = false
    UE.SetEvent(nil)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.RestoreSkin()
    if exit then UE.Teleport(exit.x, exit.y, exit.z) end
    UE.Send('wzShow', { show = false })
end)

-- ---------------------------------------------------------------------------
-- Match start / parachute drop
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:warzone:matchStart')
AddEventHandler('ue:warzone:matchStart', function(data)
    WZ.inMatch = true
    WZ.crates = {}
    for _, c in ipairs(data.crates) do WZ.crates[c.id] = c end
    WZ.squad = data.squad
    WZ.zoneCenter, WZ.zoneRadius = data.center, data.radius
    WZ.cash, WZ.uav, WZ.heal, WZ.vest, WZ.revive, WZ.hp, WZ.armor, WZ.downed = 0, 0, 2, 1, 0, 100, 0, false

    UE.Send('wzLobby', { show = false })
    UE.ApplyOutfit(Config.WarZone.Uniform.male, Config.WarZone.Uniform.female)
    RemoveAllPedWeapons(PlayerPedId(), true)

    -- spawn high above the map center and fall with a parachute
    local sx = data.center.x + math.random(-260, 260)
    local sy = data.center.y + math.random(-260, 260)
    local groundZ = UE.GroundZ(sx, sy, 900.0) or data.center.z
    UE.Teleport(sx + 0.0, sy + 0.0, groundZ + 700.0)
    Wait(200)
    SetEntityHealth(PlayerPedId(), 200)
    GiveWeaponToPed(PlayerPedId(), GetHashKey('gadget_parachute'), 1, false, true)
    SetPedParachuteTintIndex(PlayerPedId(), 0)

    WZ.Push()
    WZ.PushSquad()
    UE.WatchDeath(function() return WZ.inMatch and not WZ.inGulag end, function(ped)
        TriggerServerEvent('ue:warzone:died', UE.ResolveKiller(ped))
    end)
end)

RegisterNetEvent('ue:warzone:zoneUpdate')
AddEventHandler('ue:warzone:zoneUpdate', function(center, radius) WZ.zoneCenter, WZ.zoneRadius = center, radius end)

RegisterNetEvent('ue:warzone:zoneDamage')
AddEventHandler('ue:warzone:zoneDamage', function(amount)
    local ped = PlayerPedId()
    if IsEntityDead(ped) or WZ.downed then return end
    local hp = GetEntityHealth(ped) - amount
    if hp <= 101 then
        SetEntityHealth(ped, 101)
        TriggerServerEvent('ue:warzone:downed')
    else
        SetEntityHealth(ped, hp)
    end
end)

RegisterNetEvent('ue:warzone:counts')
AddEventHandler('ue:warzone:counts', function(squads, alive) UE.Send('wzCounts', { squads = squads, alive = alive, kills = WZ.kills or 0 }) end)

function WZ.Push()
    UE.Send('wzStats', { hp = WZ.hp, armor = WZ.armor, vest = WZ.vest, heal = WZ.heal, uav = WZ.uav, revive = WZ.revive, cash = WZ.cash, lives = WZ.downed and 0 or 1 })
end
function WZ.PushSquad()
    local mates = {}
    for _, s in ipairs(WZ.squad) do mates[#mates + 1] = { name = GetPlayerName(GetPlayerFromServerId(s)) or ('#' .. s), hp = 100, armor = 0, downed = false, src = s } end
    UE.Send('wzSquad', { mates = mates })
end

-- ---------------------------------------------------------------------------
-- Loot crates (blips/markers + pickup)
-- ---------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        if WZ.inMatch and not WZ.inGulag then
            local pc = GetEntityCoords(PlayerPedId())
            for id, c in pairs(WZ.crates) do
                if not c.taken then
                    local pos = vector3(c.pos.x, c.pos.y, c.pos.z)
                    local d = UE.Dist(pc, pos)
                    if d < 30.0 then
                        DrawMarker(1, pos.x, pos.y, pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 1.2, 46, 230, 200, 160, false, true, 2, false, nil, nil, false)
                        if d < 1.8 then
                            UE.HelpText('Press ~INPUT_CONTEXT~ to loot')
                            if IsControlJustPressed(0, 38) then TriggerServerEvent('ue:warzone:loot', id) end
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('ue:warzone:lootResult')
AddEventHandler('ue:warzone:lootResult', function(id, weapon, ammo, cash)
    local c = WZ.crates[id]
    if c then c.taken = true end
    GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), ammo, false, true)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon), true)
    WZ.cash = WZ.cash + cash
    WZ.Push()
    UE.Notify('Picked up ' .. weapon:gsub('WEAPON_', '') .. ' (+$' .. cash .. ')', 'success')
end)

RegisterNetEvent('ue:warzone:crateTaken')
AddEventHandler('ue:warzone:crateTaken', function(id) if WZ.crates[id] then WZ.crates[id].taken = true end end)

-- ---------------------------------------------------------------------------
-- Items (Y armor, U heal, Q uav)
-- ---------------------------------------------------------------------------
local function useItem(kind) TriggerServerEvent('ue:warzone:useItem', kind) end
UE.BindKey('Y', 'WarZone: use armor plate', 'warzone', function() useItem('vest') end)
UE.BindKey('U', 'WarZone: use bandage', 'warzone', function() useItem('heal') end)
UE.BindKey('Q', 'WarZone: use UAV', 'warzone', function() useItem('uav') end)

RegisterNetEvent('ue:warzone:itemUsed')
AddEventHandler('ue:warzone:itemUsed', function(kind, left)
    if kind == 'heal' then
        WZ.heal = left
        local ped = PlayerPedId()
        SetEntityHealth(ped, math.min(200, GetEntityHealth(ped) + 60))
        UE.Notify('Used a bandage.', 'success')
    elseif kind == 'vest' then
        WZ.vest = left
        SetPedArmour(PlayerPedId(), math.min(100, GetPedArmour(PlayerPedId()) + 50))
        UE.Notify('Used an armor plate.', 'success')
    elseif kind == 'uav' then
        WZ.uav = left
    end
    WZ.Push()
end)

RegisterNetEvent('ue:warzone:uavPing')
AddEventHandler('ue:warzone:uavPing', function(enemies)
    UE.Notify(('UAV: %d enemies spotted'):format(#enemies), 'info')
    -- lightweight ping: draw temporary blips for a few seconds
    local blips = {}
    for _, e in ipairs(enemies) do
        local b = AddBlipForCoord(e.x, e.y, e.z)
        SetBlipSprite(b, 1) SetBlipColour(b, 1) SetBlipScale(b, 0.8) SetBlipAsShortRange(b, true)
        blips[#blips + 1] = b
    end
    SetTimeout(12000, function() for _, b in ipairs(blips) do if DoesBlipExist(b) then RemoveBlip(b) end end end)
end)

-- ---------------------------------------------------------------------------
-- Downed / revive
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:warzone:downedSelf')
AddEventHandler('ue:warzone:downedSelf', function(bleedoutMs)
    WZ.downed = true
    local ped = PlayerPedId()
    SetEntityHealth(ped, 110)
    SetPedCanRagdoll(ped, true)
    UE.Send('wzDowned', { show = true, text = 'Waiting for a teammate to revive you...', pct = 100 })
    CreateThread(function()
        local startedAt = GetGameTimer()
        while WZ.downed and (GetGameTimer() - startedAt) < bleedoutMs do
            Wait(200)
            local pct = 100 - (((GetGameTimer() - startedAt) / bleedoutMs) * 100)
            UE.Send('wzDowned', { show = true, text = 'Waiting for a teammate to revive you...', pct = pct })
            DisableControlAction(0, 24, true) DisableControlAction(0, 25, true) DisableControlAction(0, 47, true)
        end
        UE.Send('wzDowned', { show = false })
    end)
end)

RegisterNetEvent('ue:warzone:mateDowned')
AddEventHandler('ue:warzone:mateDowned', function(src, name)
    UE.Notify(name .. ' is down!', 'warn')
    UE.Interact.Add('wz_revive_' .. src, {
        coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)) or PlayerPedId()),
        radius = Config.WarZone.Downed.reviveDistance, markerDist = 20.0, text = 'Press ~INPUT_CONTEXT~ to revive ' .. name,
        cond = function()
            local target = GetPlayerFromServerId(src)
            if target == -1 then return false end
            return true
        end,
        onUse = function() TriggerServerEvent('ue:warzone:reviveRequest', src) end,
    })
end)

RegisterNetEvent('ue:warzone:revived')
AddEventHandler('ue:warzone:revived', function(hp)
    WZ.downed = false
    SetEntityHealth(PlayerPedId(), 100 + hp)
    UE.Send('wzDowned', { show = false })
    UE.Notify('You were revived!', 'success')
end)

RegisterNetEvent('ue:warzone:reviveDone')
AddEventHandler('ue:warzone:reviveDone', function() end)

-- ---------------------------------------------------------------------------
-- Death, killcam, gulag
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:warzone:killFeed')
AddEventHandler('ue:warzone:killFeed', function(killer, victim, youKilled)
    UE.Send('wzKill', { killer = killer, victim = victim, you = youKilled })
    if youKilled then WZ.kills = (WZ.kills or 0) + 1 end
end)

RegisterNetEvent('ue:warzone:killcam')
AddEventHandler('ue:warzone:killcam', function(killerSrc, durationMs)
    local target = GetPlayerFromServerId(killerSrc)
    if target == -1 then return end
    local ped = GetPlayerPed(target)
    if not ped or ped == 0 then return end
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', GetEntityCoords(ped), GetEntityRotation(ped), 50.0)
    AttachCamToEntity(cam, ped, 0.0, -4.0, 1.6, true)
    PointCamAtEntity(cam, ped, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetTimeout(durationMs, function()
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
    end)
end)

RegisterNetEvent('ue:warzone:dead')
AddEventHandler('ue:warzone:dead', function()
    WZ.downed = false
    UE.Send('wzDowned', { show = false })
end)

RegisterNetEvent('ue:warzone:toGulag')
AddEventHandler('ue:warzone:toGulag', function()
    WZ.inGulag = false
    UE.Notify('Eliminated - waiting for a Gulag opponent...', 'warn')
    UE.Fade(true, 700)
end)

RegisterNetEvent('ue:warzone:gulagStart')
AddEventHandler('ue:warzone:gulagStart', function(spawn, opponentName, seconds, zoneCenter, radius)
    WZ.inGulag = true
    UE.Revive(6000)
    SetEntityHealth(PlayerPedId(), 200)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.GiveWeapon('WEAPON_PISTOL', 60)
    UE.Teleport(spawn.x, spawn.y, spawn.z)
    UE.Fade(false, 700)
    UE.Announce('GULAG - defeat ' .. opponentName .. ' to return to the fight', seconds, 'warn')

    UE.WatchDeath(function() return WZ.inGulag end, function()
        WZ.inGulag = false
        TriggerServerEvent('ue:warzone:gulagDied')
    end)

    CreateThread(function()
        local left = seconds
        while WZ.inGulag and left > 0 do Wait(1000) left = left - 1 end
    end)
end)

RegisterNetEvent('ue:warzone:gulagReturn')
AddEventHandler('ue:warzone:gulagReturn', function(center, radius)
    WZ.inGulag = false
    WZ.zoneCenter, WZ.zoneRadius = center, radius
    UE.Fade(true, 600)
    SetEntityHealth(PlayerPedId(), 150)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.ApplyOutfit(Config.WarZone.Uniform.male, Config.WarZone.Uniform.female)
    local sx = center.x + math.random(-200, 200)
    local sy = center.y + math.random(-200, 200)
    local groundZ = UE.GroundZ(sx, sy, 600.0) or center.z
    UE.Teleport(sx + 0.0, sy + 0.0, groundZ + 400.0)
    GiveWeaponToPed(PlayerPedId(), GetHashKey('gadget_parachute'), 1, false, true)
    Wait(200)
    UE.Fade(false, 600)
    UE.WatchDeath(function() return WZ.inMatch and not WZ.inGulag end, function(ped) TriggerServerEvent('ue:warzone:died', UE.ResolveKiller(ped)) end)
end)

RegisterNetEvent('ue:warzone:matchEnd')
AddEventHandler('ue:warzone:matchEnd', function(d)
    WZ.inMatch = false
    UE.Send('wzWinner', { names = d.names, isYou = d.isYou })
    SetTimeout(5500, function() UE.Send('wzWinnerHide') end)
end)

-- ---------------------------------------------------------------------------
-- Zone HUD (distance to safe zone edge)
-- ---------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(500)
        if WZ.inMatch and not WZ.inGulag and WZ.zoneCenter then
            local pc = GetEntityCoords(PlayerPedId())
            local center = vector3(WZ.zoneCenter.x, WZ.zoneCenter.y, WZ.zoneCenter.z)
            local dist = UE.Dist2D(pc, center)
            local out = dist > WZ.zoneRadius
            UE.Send('wzZone', { show = true, out = out, label = out and 'OUTSIDE THE ZONE' or 'SAFE ZONE', text = out and (math.floor(dist - WZ.zoneRadius) .. 'm to safety') or (math.floor(WZ.zoneRadius - dist) .. 'm to edge'), pct = UE.Clamp((dist / math.max(1, WZ.zoneRadius)) * 100, 0, 100) })
        end
        Wait(0)
    end
end)

-- health/armor bar refresh
CreateThread(function()
    while true do
        Wait(400)
        if WZ.inMatch then
            local ped = PlayerPedId()
            if not IsEntityDead(ped) then
                WZ.hp = math.max(0, math.floor((GetEntityHealth(ped) - 100) / 1.0))
                WZ.armor = GetPedArmour(ped)
                WZ.Push()
            end
        end
        Wait(0)
    end
end)
