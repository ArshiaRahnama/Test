--[[
    Unique_Event - GUNGAME (client)
    Queue lobby, countdown, weapon ladder, arena leash, death/kill HUD wiring.
]]

local GG = { inArena = false, weapon = nil, level = 1, total = #Config.GunGame.Weapons, center = nil, boardsOn = true }

RegisterNetEvent('ue:gungame:queued')
AddEventHandler('ue:gungame:queued', function(lobby)
    UE.SetEvent('gungame')
    UE.Teleport(lobby.x, lobby.y, lobby.z)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.Send('ggShow', { show = true })
end)

RegisterNetEvent('ue:gungame:leave')
AddEventHandler('ue:gungame:leave', function(exit)
    GG.inArena = false
    UE.SetEvent(nil)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.RestoreSkin()
    if exit then UE.Teleport(exit.x, exit.y, exit.z) end
    UE.Send('ggShow', { show = false })
end)

RegisterNetEvent('ue:gungame:arenaStart')
AddEventHandler('ue:gungame:arenaStart', function(data)
    GG.inArena = true
    GG.center = data.center
    GG.level = 1
    GG.total = data.total
    GG.weapon = data.weapon
    UE.Teleport(data.center.x + math.random(-8, 8) + 0.0, data.center.y + math.random(-8, 8) + 0.0, data.center.z + 1.0)
    UE.Freeze(true)
    UE.Send('ggLevel', { level = 1, total = GG.total, weapon = GG.weapon })

    CreateThread(function()
        local left = data.countdown
        while left > 0 and GG.inArena do
            UE.Send('ggCountdown', { n = left })
            Wait(1000)
            left = left - 1
        end
        UE.Send('ggCountdownHide')
    end)
end)

RegisterNetEvent('ue:gungame:go')
AddEventHandler('ue:gungame:go', function()
    UE.Freeze(false)
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.GiveWeapon(GG.weapon, Config.GunGame.WeaponAmmo)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey(GG.weapon), true)
    SetEntityHealth(PlayerPedId(), 200)
    if Config.GunGame.GiveParachuteOnSpawn then GiveWeaponToPed(PlayerPedId(), GetHashKey('GADGET_PARACHUTE'), 1, false, true) end
    if Config.GunGame.Sounds.MatchStart ~= '' then UE.Sound(Config.GunGame.Sounds.MatchStart, 0.5) end
    UE.WatchDeath(function() return GG.inArena end, function(ped) TriggerServerEvent('ue:gungame:died', UE.ResolveKiller(ped)) end)
end)

RegisterNetEvent('ue:gungame:respawn')
AddEventHandler('ue:gungame:respawn', function(center)
    CreateThread(function()
        UE.Fade(true, 500)
        Wait(550)
        UE.Revive(6000)
        SetEntityHealth(PlayerPedId(), 200)
        RemoveAllPedWeapons(PlayerPedId(), true)
        UE.GiveWeapon(GG.weapon, Config.GunGame.WeaponAmmo)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(GG.weapon), true)
        if Config.GunGame.GiveParachuteOnSpawn then GiveWeaponToPed(PlayerPedId(), GetHashKey('GADGET_PARACHUTE'), 1, false, true) end
        UE.Teleport(center.x + math.random(-8, 8) + 0.0, center.y + math.random(-8, 8) + 0.0, center.z + 1.0)
        Wait(250)
        UE.Fade(false, 500)
    end)
end)

RegisterNetEvent('ue:gungame:levelUp')
AddEventHandler('ue:gungame:levelUp', function(level, weapon)
    GG.level = level
    GG.weapon = weapon
    RemoveAllPedWeapons(PlayerPedId(), true)
    UE.GiveWeapon(weapon, Config.GunGame.WeaponAmmo)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon), true)
    if Config.GunGame.GiveParachuteOnSpawn then GiveWeaponToPed(PlayerPedId(), GetHashKey('GADGET_PARACHUTE'), 1, false, true) end
    UE.Send('ggLevel', { level = level, total = GG.total, weapon = weapon })
    if Config.GunGame.Sounds.Kill ~= '' then UE.Sound(Config.GunGame.Sounds.Kill, 0.5) end
    UE.Notify('Level up! Now using ' .. weapon:gsub('WEAPON_', ''), 'success')
end)

RegisterNetEvent('ue:gungame:killFeed')
AddEventHandler('ue:gungame:killFeed', function(killer, victim, youKilled)
    UE.Send('ggKill', { killer = killer, victim = victim, you = youKilled })
end)

RegisterNetEvent('ue:gungame:board')
AddEventHandler('ue:gungame:board', function(rows) UE.Send('ggBoard', { rows = rows, visible = GG.boardsOn }) end)

RegisterNetEvent('ue:gungame:mvp')
AddEventHandler('ue:gungame:mvp', function(d)
    GG.inArena = false
    UE.Freeze(false)
    UE.Send('ggMvp', d)
    if Config.GunGame.Sounds.MatchWin ~= '' then UE.Sound(Config.GunGame.Sounds.MatchWin, 0.6) end
    SetTimeout((Config.GunGame.WinnerCameraSeconds - 1) * 1000, function() UE.Send('ggMvpHide') end)
end)

RegisterNetEvent('ue:gungame:leashCheck')
AddEventHandler('ue:gungame:leashCheck', function(center, radius)
    if not GG.inArena then return end
    local pc = GetEntityCoords(PlayerPedId())
    local c = vector3(center.x, center.y, center.z)
    if UE.Dist2D(pc, c) > radius then
        UE.Notify('Return to the arena!', 'warn')
        UE.Teleport(c.x + math.random(-10, 10) + 0.0, c.y + math.random(-10, 10) + 0.0, c.z + 1.0)
    end
end)

UE.BindKey('G', 'Unique Event: toggle scoreboard', 'gungame', function()
    GG.boardsOn = not GG.boardsOn
    UE.Send('ggBoardToggle', { show = GG.boardsOn })
end)
