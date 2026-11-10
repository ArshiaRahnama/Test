-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Cinema, receptionPeds = false, {}

RegisterNetEvent('esx_beds:revive')
AddEventHandler('esx_beds:revive', function(hospital)
    local armor = GetPedArmour(PlayerPedId())
    print(hospital)
    DoScreenFadeOut(750)
    TriggerEvent('onKeyDown','l')
    Wait(500)
    TriggerEvent('medic:revive', true)
    Wait(2000)
    DoScreenFadeOut(750)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "rev",
        duration = 20000,
        label = "",
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
        ESX.SetEntityHealth(PlayerPedId(), 200)
        DoScreenFadeIn(1500)
        Wait(1000)
        ESX.SetPedArmour(PlayerPedId(),armor)
    end) 
end)

local drawTxt = function(text)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.95)
end


RegisterNetEvent('esx_beds:notify')
AddEventHandler('esx_beds:notify', function(txt)
    local timer = GetGameTimer() + 7000
    while timer >= GetGameTimer() do
        drawTxt(txt)
        Wait(0)
    end
end)


local createPed = function(hash, coords, heading, networked)
    while not HasModelLoaded(hash) do Wait(0) RequestModel(hash) end
    local ped = CreatePed(0, hash, coords, heading, networked, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end

Citizen.CreateThread(function()
    waitForLoad()
    while not NetworkIsSessionStarted() do Wait(0) end
    for k, v in pairs(configAsghar.Hospitals) do
        receptionPeds[k] = createPed(v.Peds.pedHash, v.Peds.reception.coords - vec(0, 0, 1), v.Peds.reception.heading, false)  
        FreezeEntityPosition(receptionPeds[k], true) 
    end
    while true do
        local sleep = 2000
        local me = PlayerPedId()
            for k, v in pairs(receptionPeds) do
                if DoesEntityExist(v) then
                    if ESX.GetDistance(GetEntityCoords(me), GetOffsetFromEntityInWorldCoords(v, 0.0, 1.0, 0.0), true) <= 2.0 then
                       -- if (not configAsghar.Hospitals[k].job or (PlayerData.job and configAsghar.Hospitals[k].job == PlayerData.job.name)) and not IsPedDeadOrDying(me) and GetEntityHealth(me) < GetEntityMaxHealth(me) then
                            sleep = 0
                            ESX.ShowHelpNotification('~INPUT_CONTEXT~ jahat darman')                      
                            if IsControlJustReleased(0, 38) and not Cinema and not ESX.GetPlayerData().IsDead then
                                local data = configAsghar.Hospitals[k]
                                local Access = data.Access['all'] or data.Access[ESX.GetPlayerData().job.name]
                                if not Access then
                                    -- if ESX.GetPlayerData().IsInjure then
                                    --     ESX.SetEntityHealth(PlayerPedId(),0)
                                    -- end
                                    goto next
                                end
                                --if ESX.GetPlayerData().IsInjure then
                                    local medic = 0
                                    for k2 , v2 in ipairs(GetActivePlayers()) do
                                        if v2 ~= PlayerId() and ESX.GetDistance(GetEntityCoords(GetPlayerPed(v2)),GetEntityCoords(PlayerPedId())) < 35.0 then
                                            local playerJob = ESX.GetPlayerState(GetPlayerServerId(v2),'job')
                                            if playerJob == "ambulance" then
                                                medic = medic + 1
                                            end
                                        end
                                        Wait(1)
                                    end
                                    Wait(2000)
                                    if medic < 3 then
                                        local chance = math.random(1,100)
                                        if chance <= 10 and ESX.GetPlayerData().IsInjure then
                                            TriggerEvent('medic:killMe')
                                            ESX.Alert('Mord','To mordi',10000,'error')
                                        else
                                            TriggerServerEvent('esx_beds:gethelp', k)
                                        end
                                    else
                                        ESX.ShowNotification('tedad medic mojoud dar hospital : '.. medic)
                                    end
                                --else
                                --    TriggerServerEvent('esx_beds:gethelp', k)
                                --end
                            end
                            ::next::
                      --  end
                    end
                end
            end
        Wait(sleep)
    end
end)