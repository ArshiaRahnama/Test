-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
muted = false
inmute = false
misTxtDis = "~r~~h~Dar yek mantaghe az map RP pause ast lotfan vared mantaghe nashavid."

local blips = {}
local coordsformarker = {}
function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end
alredypause = true
RegisterNetEvent('Fax:AdminAreaSet')
AddEventHandler("Fax:AdminAreaSet", function(blip, s)
    coords = blip.coords
    coordsformarker[blip.index] =  coords
    if not blips[blip.index] then
        blips[blip.index] = {}
    end

    if not givenCoords then
        TriggerServerEvent('AdminArea:setCoords', tonumber(blip.index), coords)
    end
    if blip.world == world then
        blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
        blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
        SetBlipSprite(blips[blip.index].blip, blip.id)
        SetBlipAsShortRange(blips[blip.index].blip, true)
        SetBlipColour(blips[blip.index].blip, blip.color)
        SetBlipScale(blips[blip.index].blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blip.name)
        EndTextCommandSetBlipName(blips[blip.index].blip)
    end
    blips[blip.index]["coords"] = coords
    blips[blip.index]["radius2"] = blip.radius
    blips[blip.index]["mute"] = blip.mute
    blips[blip.index]["world"] = blip.world
    SetBlipAlpha(blips[blip.index]["radius"], 80)
    SetBlipColour(blips[blip.index]["radius"], blip.color)
    -- if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), blips[blip.index]["coords"], true) < 40.000 then
    --     missionTextDisplay(misTxtDis, 8000)
    -- end

    blips[blip.index]["active"] = true
    while blips[blip.index] and blips[blip.index]["active"] do
        Wait(0)
        if blips[blip.index] ~= nil then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local coords2 = blips[blip.index]["coords"]
            local distance = math.floor(GetDistanceBetweenCoords(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z,1))
            if blips[blip.index].world == world then
                if distance > blips[blip.index]["radius2"] - 1 then
                    DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 255,255,0, 100, false, true, 2, false, false, false, false)
                    if blips[blip.index]["mute"] and blips[blip.index].haya then
                        if muted then
                            muted = false
                            inmute = false
                            blips[blip.index].haya = false
                            TriggerEvent('pma-voice:mutePlayer',false)
                        end
                    end
                else
                    if blips[blip.index]["mute"] then
                        if not muted and not blips[blip.index].haya then
                            muted = true
                            inmute = true
                            TriggerEvent('pma-voice:mutePlayer',true)
                            mutethread()
                            blips[blip.index].haya = true
                        end
                    end
                    DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius, blip.radius, blip.radius, 255,255,255, 100, false, true, 2, false, false, false, false)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 24, true) -- Attack
                    DisableControlAction(0, 257, true) -- Attack 2
                    DisableControlAction(0, 25, true) -- Right click
                    DisableControlAction(0, 47, true)  -- Disable weapon
                    DisableControlAction(0, 264, true) -- Disable melee
                    DisableControlAction(0, 257, true) -- Disable melee
                    DisableControlAction(0, 140, true) -- Disable melee
                    DisableControlAction(0, 141, true) -- Disable melee
                    DisableControlAction(0, 142, true) -- Disable melee
                    DisableControlAction(0, 143, true) -- Disable melee
                    DisableControlAction(0, 263, true) -- Melee Attack 1
                    DisableControlAction(0, 170, true) -- Melee Attack 1
    
                end
            end
        end
    end
end)

RegisterNetEvent('unmute')
AddEventHandler('unmute',function()
    if muted then
        muted = false
        inmute = false
        TriggerEvent('pma-voice:mutePlayer',false)
    end
end)

RegisterNetEvent('unmute2')
AddEventHandler('unmute2',function()
    if muted then
        inmute = false
        TriggerEvent('pma-voice:mutePlayer',false)
    end
end)

RegisterNetEvent('mute')
AddEventHandler('mute',function()
    if not inmute then
        inmute = true
        muted = true
        TriggerEvent('pma-voice:mutePlayer',true)
        mutethread()
    end
end)


RegisterNetEvent('Fax:AdminAreaClear')
AddEventHandler("Fax:AdminAreaClear", function(blipID)
    if blips[blipID] then
        blips[blipID]["active"] = false
        if blips[blipID].blip then
            RemoveBlip(blips[blipID].blip)
            RemoveBlip(blips[blipID].radius)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), blips[blipID]["coords"], true) < 50.000 then
            --missionTextDisplay("RP Dar mantaghe ~o~Admin Area(" .. blipID .. ")~r~ unpause ~w~shod!", 5000)
            if muted then
                muted = false
                inmute = false
                TriggerEvent('pma-voice:mutePlayer',false)
            end
        end
        blips[blipID] = nil
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)

function mutethread()
    Citizen.CreateThread(function()
        while inmute do
            Wait(0)
            Draw('You are muted')
        end
    end)
end
Draw = function(text, size)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
    SetTextColour( 255,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.4, 0.95)
end

