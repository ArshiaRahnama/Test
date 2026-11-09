-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local doesSpeakerActive = false
local micProp = 0
local speakerThread = false
local speakerLoaded = false
local speakerList = {}
local loundedPlayer = {}
local loundedZone = {}
local sedaKam = false

RegisterNetEvent('speaker:active', function()
    if not doesSpeakerActive then
        doesSpeakerActive = true
        TriggerEvent('esx:spawnObject', 'v_ilev_fos_mic', function(entity)
            micProp = entity
            SetEntityHeading(micProp, 90.0)
            Wait(500)
            local range = 50
            local gain = 3
            local keyboard, range = exports["input"]:Keyboard({
                header = "Range speaker ra vared konid(10 ta 50)", 
                rows = {"Range"}
            })
            if keyboard then
                if tonumber(range) then
                    range = tonumber(range)
                end
            else
                range = 50
            end
            if LocalPlayer.state.admin then
                local keyboard, gain = exports["input"]:Keyboard({
                    header = "Gain speaker ra vared konid(1 ta 20)", 
                    rows = {"Gain"}
                })
                if keyboard then
                    if tonumber(gain) and tonumber(gain) <= 20 then
                        gain = tonumber(gain)
                    end
                else
                    gain = 3
                end
            end
            ESX.TriggerServerEvent('speaker:setMicObject', NetworkGetNetworkIdFromEntity(entity), range, gain + .0)
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(entity), 'antiDelete',true)
            Citizen.CreateThread(function()
                while doesSpeakerActive do
                    Wait(1000)
                    local distance = ESX.GetDistance(SUN.PlayerCoords, GetEntityCoords(entity))
                    if distance > 200 then
                        ESX.TriggerServerEvent('speaker:destroy')
                        doesSpeakerActive = false
                        break
                    end
                end
            end)
        end)
    else
        doesSpeakerActive = false
        ESX.Game.DeleteEntity(micProp)
        ESX.TriggerServerEvent('speaker:destroy')
    end
end)

RegisterNetEvent('core:playerLoaded', function()
    if not speakerLoaded then
        waitForLoad()
        ESX.TriggerServerCallback('speaker:getList', function(list)
            speakerList = list
            speakerLoaded = true
            speakerThread()
        end)
    end
end)

RegisterNetEvent('speaker:updateList', function(key, value)
    if speakerLoaded then
        if not value then
            if loundedZone[key] then
                TriggerEvent('chatMessage', '[Speaker]', {255, 0, 0}, '^0Exit zone['.. key ..']', 'plarms')
                loundedZone[key] = nil
                for k2, v2 in pairs(speakerList[key].party) do
                    if loundedPlayer[k2] then
                        loundedPlayer[k2] = nil
                        if k2 == SUN.src then
                            exports['pma-voice']:overrideProximityRange(4.0, false)
                            ESX.chatMessage('Shoma az mic fasele gereftid!', 'plarms')
                        end
                    end
                end
            end
        end
        speakerList[key] = value
    end
end)

function speakerThread()
    speakerThread = true
    Citizen.CreateThread(function()
        local wait = 5000
        while speakerThread do
            Wait(wait)
            local nearAny = false
            for k, v in pairs(speakerList) do
                if NetworkDoesEntityExistWithNetworkId(v.entity) then
                    local entity = NetworkGetEntityFromNetworkId(v.entity)
                    local micCoords = GetEntityCoords(entity)
                    local distance = ESX.GetDistance(micCoords, SUN.PlayerCoords)
                    if distance <= v.range then
                        wait = 1000
                        if not loundedZone[k] then
                            loundedZone[k] = true
                            TriggerEvent('chatMessage', '[Speaker]', {255, 0, 0}, '^0Enter zone['.. k ..']', 'plarms')
                            Citizen.CreateThread(function()
                                while loundedZone[k] do
                                    Wait(0)
                                    local micCoords = GetEntityCoords(entity)
                                    DrawMarker(27, micCoords.x, micCoords.y, micCoords.z + 0.1, 0, 0, 0, 0, 0,0, v.gain, v.gain, 0.0, 0, 255, 0, 30, 0, 0, 0, true)
                                    -- DrawMarker(27, micCoords.x, micCoords.y, micCoords.z + 0.1, 0, 0, 0, 0, 0,0, v.range * 2.0, v.range * 2.0, 0.0, 0, 255, 0, 100, 0, 0, 0, true)
                                end
                            end)
                        end
                        nearAny = true
                        if not v.party[SUN.src] then
                            sedaKam = true
                            if NetworkGetTalkerProximity() ~= 0.5 then
                                NetworkSetTalkerProximity(0.5)
                            end
                        end
                        for k2, v2 in pairs(v.party) do
                            if ESX.Game.DoesPlayerExist(k2) then
                                local distance = ESX.GetDistance(micCoords, GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(k2))))
                                if distance <= v.gain then
                                    if not loundedPlayer[k2] then
                                        if k2 == SUN.src then
                                            exports['pma-voice']:overrideProximityRange(50.0, true)
                                            MumbleSetAudioInputIntent(`music`)
                                            ESX.chatMessage('Shoma kenar mic gharar darid!', 'plarms')
                                        end
                                        -- MumbleSetVolumeOverrideByServerId(k2, 1.0)
                                        loundedPlayer[k2] = true
                                    end
                                elseif loundedPlayer[k2] then
                                    loundedPlayer[k2] = nil
                                    -- MumbleSetVolumeOverrideByServerId(k2, -1)
                                    if k2 == SUN.src then
                                        exports['pma-voice']:overrideProximityRange(4.0, false)
                                        ESX.chatMessage('Shoma az mic fasele gereftid!', 'plarms')
                                    end
                                end
                            elseif loundedPlayer[k2] then
                                loundedPlayer[k2] = nil
                                -- MumbleSetVolumeOverrideByServerId(k2, -1)
                            end
                        end
                    elseif loundedZone[k] then
                        TriggerEvent('chatMessage', '[Speaker]', {255, 0, 0}, '^0Exit zone['.. k ..']', 'plarms')
                        loundedZone[k] = nil
                        for k2, v2 in pairs(v.party) do
                            if loundedPlayer[k2] then
                                loundedPlayer[k2] = nil
                                -- MumbleSetVolumeOverrideByServerId(k2, -1)
                                if k2 == SUN.src then
                                    exports['pma-voice']:overrideProximityRange(4.0, false)
                                end
                            end
                        end
                    end
                end
            end
            if not nearAny then
                if sedaKam then
                    sedaKam = false
                    NetworkSetTalkerProximity(3.0)
                end
                wait = 5000
            end
        end
    end)
end

RegisterNetEvent('esx:removeInventoryItemss',function(label,count,name,newcount)
    if name == 'speaker' and newcount <= 0 then
		if doesSpeakerActive then
            ESX.TriggerServerEvent('speaker:destroy')
            doesSpeakerActive = false
		end
    end
end)