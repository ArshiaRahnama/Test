-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.state = PB.state or {}
PB.HUD = PB.HUD or 'paintball-hud'

local hcActive = false

local function enableHardcore()
    if hcActive then return end
    hcActive = true
    PB.state.hardcore = true
    SUN.SendUIData(PB.HUD, {type = 'hardcore', payload = {enabled = true}})
end

local function disableHardcore()
    if not hcActive then return end
    hcActive = false
    PB.state.hardcore = false
    SUN.SendUIData(PB.HUD, {type = 'hardcore', payload = {enabled = false}})
    DisplayRadar(true)
    DisplayHud(true)
end

local hardcoreHudRunning = false
local function startHardcoreHud()
    if hardcoreHudRunning then return end
    hardcoreHudRunning = true
    CreateThread(function()
        local lastNameHide = 0
        while PB.state.inMatch do
            if hcActive and PB.state.inMatch then
                local cfg = paintballConfig.hardcoreMode or {}
                if cfg.hideMinimap then DisplayRadar(false) end
                if cfg.hideHud then
                    for i = 1, 22 do
                        if i ~= 17 and i ~= 19 then
                            HideHudComponentThisFrame(i)
                        end
                    end
                end
                local now = GetGameTimer()
                if cfg.hideTeammateNames and (now - lastNameHide > 500) then
                    lastNameHide = now
                    if PB.iterateMatchPlayers then
                        PB.iterateMatchPlayers(function(sid, team, pid, ped)
                            SetPlayerVisibleLocally(pid, true)
                            HidePedFromMinimapAndExplosionFloater(ped)
                        end)
                    end
                end
                Wait(0)
            else
                Wait(1500)
            end
        end
        hardcoreHudRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startHardcoreHud)

RegisterNetEvent('paintball:matchStart', function(payload)
    if payload and payload.hardcore then
        enableHardcore()
    else
        disableHardcore()
    end
end)

RegisterNetEvent('paintball:matchEnd', function()
    disableHardcore()
end)

RegisterNetEvent('paintball:cleanup', function()
    disableHardcore()
end)

AddEventHandler('onResourceStop', function(rn)
    if GetCurrentResourceName() == rn then
        DisplayRadar(true)
        DisplayHud(true)
    end
end)
