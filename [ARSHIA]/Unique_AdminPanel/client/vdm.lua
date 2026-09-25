-- Unique_AdminPanel | client/vdm.lua
-- Client half of the anti-VDM system: reports our own death by vehicle, applies the revive
-- protection, and removes the vehicle if the server-side delete didn't stick.
-- The server decides everything; this only supplies information and effects.

local Cfg = VDMConfig
local reported = false
NLRSkipUntil = 0   -- GetGameTimer() until which New Life / revive handicap must be ignored

local CAUSES = {
    [GetHashKey('weapon_run_over_by_car')] = true,
    [GetHashKey('weapon_rammed_by_car')]   = true,
}

if Cfg.Enabled and Cfg.ClientReport then
    CreateThread(function()
        while true do
            Wait(500)
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                if not reported then
                    reported = true
                    local cause = GetPedCauseOfDeath(ped)
                    if CAUSES[cause] then
                        local killer = GetPedSourceOfDeath(ped)
                        local driverPed = killer
                        if killer ~= 0 and IsEntityAVehicle(killer) then driverPed = GetPedInVehicleSeat(killer, -1) end
                        if driverPed and driverPed ~= 0 and IsPedAPlayer(driverPed) then
                            local idx = NetworkGetPlayerIndexFromPed(driverPed)
                            if idx and idx ~= -1 then
                                TriggerServerEvent('vdm:sv:report', GetPlayerServerId(idx), cause)
                            end
                        end
                    end
                end
            else
                reported = false
            end
        end
    end)
end

-- the server revived us because of a VDM: no New Life, no revive handicap, short invincibility
RegisterNetEvent('vdm:cl:revived', function(protectSeconds)
    NLRSkipUntil = GetGameTimer() + 25000
    TriggerEvent('antiNonRP:stopReviveThread')
    TriggerEvent('antiNonRP:cl:clear')
    local secs = tonumber(protectSeconds) or 0
    if secs > 0 then
        CreateThread(function()
            Wait(1500) -- let the revive finish first
            local ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            local untilT = GetGameTimer() + secs * 1000
            while GetGameTimer() < untilT do Wait(200) end
            SetEntityInvincible(PlayerPedId(), false)
        end)
    end
end)

-- fallback deletion (only used when the server-side DeleteEntity did not remove it)
RegisterNetEvent('vdm:cl:removeVehicle', function(netId)
    if not netId or not NetworkDoesNetworkIdExist(netId) then return end
    local veh = NetToVeh(netId)
    if veh and veh ~= 0 and DoesEntityExist(veh) then
        NetworkRequestControlOfEntity(veh)
        local t = GetGameTimer() + 1500
        while not NetworkHasControlOfEntity(veh) and GetGameTimer() < t do Wait(50) end
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end
end)
