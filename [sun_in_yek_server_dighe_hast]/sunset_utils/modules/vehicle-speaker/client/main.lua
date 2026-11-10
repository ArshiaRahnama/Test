-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local list = {}
local edited = {}
local effect = CreateAudioSubmix('effect')
SetAudioSubmixEffectRadioFx(effect, 1)
SetAudioSubmixEffectParamInt(effect, 1, GetHashKey('default'), 1)
SetAudioSubmixEffectParamFloat(effect, 1, GetHashKey('freq_low'), 300.0)
SetAudioSubmixEffectParamFloat(effect, 1, GetHashKey('freq_hi'), 10000.0)
AddAudioSubmixOutput(effect, 1)
-- Citizen.CreateThread(function()
-- 	waitForLoad()
--     local svid = GetPlayerServerId(PlayerId())
--     while true do
--         for k , v in pairs(list) do
--             if k ~= svid then
--                 if GetPlayerFromServerId(k) ~= -1 then
--                     local distance = ESX.GetDistance(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(k))),GetEntityCoords(PlayerPedId()))
--                     if distance <= v then
--                         local vol = (1 - (1.0 / v) * distance)
--                         MumbleSetVolumeOverrideByServerId(k,vol)
--                         MumbleSetSubmixForServerId(k, effect)
--                         edited[k] = true
--                     else
--                         if edited[k] then
--                             edited[k] = nil
--                             MumbleSetVolumeOverrideByServerId(k,-1.0)
--                             MumbleSetSubmixForServerId(k, -1)
--                         end
--                     end
--                 else
--                     if edited[k] then
--                         edited[k] = nil
--                         MumbleSetVolumeOverrideByServerId(k,-1.0)
--                         MumbleSetSubmixForServerId(k, -1)
--                     end
--                 end
--             end
--         end
--         Wait(1000)
--     end
-- end)
RegisterNetEvent('speaker:addplayer',function(src,distance)
    list[src] = distance
    TriggerEvent('pname:changePlayerSetting', src, 'nameTag', 'Speaker')
    TriggerEvent('pname:changePlayerSetting', src, 'distance', 6000)
    MumbleSetSubmixForServerId(src, effect)
end)

RegisterNetEvent('speaker:removeplayer',function(src)
    --if edited[src] then
        edited[src] = nil
        list[src] = nil
        Wait(500)
        -- MumbleSetVolumeOverrideByServerId(src,-1.0)
        -- MumbleSetSubmixForServerId(src, -1)
        TriggerEvent('pname:changePlayerSetting', src, 'nameTag', nil)
        TriggerEvent('pname:changePlayerSetting', src, 'distance', nil)
        MumbleSetSubmixForServerId(src, -1)
    --end
end)

RegisterNetEvent('speaker:enable', function(active)
    exports['pma-voice']:overrideProximityRange(active and 50.0 or 4.0, active)
end)