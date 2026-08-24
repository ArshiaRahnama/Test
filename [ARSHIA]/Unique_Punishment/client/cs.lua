local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
INPUT_CONTEXT = 51
local thread = false
local reason = ''
local isSentenced, communityServiceFinished, disable_actions, actionsRemaining, vassour_net, spatula_net, availableActions = false, false, false, 0, nil, nil, {}
local vassoumodel, spatulamodel = "prop_tool_broom", "bkr_prop_coke_spatula_04"
local peds = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ESX.SetPlayerData('jailed', false)
    ESX.SetPlayerData('inCS', false)
end)

function dpemote(state)

end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
end)

AddEventHandler('loading:Loaded', function()
    TriggerServerEvent('esx_communityGGservice:checkIfSentenced')
end)

RegisterNetEvent('esx_communityGGservice:inCommunityService_reason')
AddEventHandler('esx_communityGGservice:inCommunityService_reason', function(newReason)
    reason = newReason
end)

function FillActionTable(last_action)
    if #availableActions < 1 then
        while #availableActions < 4 do
            local service_does_not_exist = true
            local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]

            for i = 1, #availableActions do
                if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then

                    service_does_not_exist = false

                end
            end

            if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
                service_does_not_exist = false
            end
            if service_does_not_exist then
                table.insert(availableActions, random_selection)
            end
        end
    end
end

RegisterNetEvent('esx_communityGGservice:inCommunityService')
AddEventHandler('esx_communityGGservice:inCommunityService', function(actions_remaining)
    dpemote(false)
    deleteCSped()
    spawnCSped()
    local playerPed = PlayerPedId()
    actionsRemaining = actions_remaining
    FillActionTable()
    ApplyPrisonerSkin()
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    ESX.Game.Teleport(playerPed, Config.ServiceLocation)
    communityServiceFinished = false
    if not isSentenced then
        isSentenced = true
        Citizen.CreateThread(function()
            local exemptRefresh = GetGameTimer()
            while actionsRemaining > 0 and communityServiceFinished ~= true do
                if IsPedInAnyVehicle(playerPed, false) then
                    ClearPedTasksImmediately(playerPed)
                end
                dpemote(false)
                if GetGameTimer() - exemptRefresh > 3000 then
                    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 4000, { teleport = true, speed = true })
                    exemptRefresh = GetGameTimer()
                end
                if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z,true) > Config.DistanceExtension then
                    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    ESX.Game.Teleport(playerPed, Config.ServiceLocation)
                end
                Citizen.Wait(1000)
            end
        end)
    end
    startThread()
    ESX.SetPlayerData('jailed', true)
    ESX.SetPlayerData('inCS', true)

end)

RegisterNetEvent('esx_communityGGservice:finishCommunityService')
AddEventHandler('esx_communityGGservice:finishCommunityService', function(source)
    TriggerEvent('chat:addMessage', { args = { _U('judge'), _U('end_work') }, color = { 0, 255, 0 } })
    dpemote(true)
    communityServiceFinished = true
    isSentenced = false
    ESX.SetPlayerData('jailed', false)
    ESX.SetPlayerData('inCS', false)
    actionsRemaining = 0
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    ESX.Game.Teleport(PlayerPedId(), Config.ReleaseLocation)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)

    SetTimeout(10000,function()
        dpemote(true)


    end)
    deleteCSped()
end)

function startThread()
    if not thread then
        thread = true
        Citizen.CreateThread(function()
            while true do
                :: start_over ::
                Citizen.Wait(0)
                if actionsRemaining > 0 and isSentenced then
                    DrawMarker(1, Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.DistanceExtension*2, Config.DistanceExtension*2, 50.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                    draw2dText( _U('remaining_msg', ESX.Math.Round(actionsRemaining)), { 0.3, 0.940 } )
                    draw2dText('~g~Reason~w~ : '.. reason, { 0.3, 0.97 } )
                    DrawAvailableActions()
                    DisableViolentActions()
                    DisableFirstPersonCamThisFrame()
                    local pCoords    = GetEntityCoords(PlayerPedId())
                    for i = 1, #availableActions do
                        local distance = GetDistanceBetweenCoords(pCoords, availableActions[i].coords, true)
                        if distance < 1.5 then
                            DisplayHelpText(_U('press_to_start'))
                            if(IsControlJustReleased(1, 38))then
                                local suka = true
                                CreateThread(function()
                                    while suka do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                end)
                                if true then
                                    tmp_action = availableActions[i]
                                    RemoveAction(tmp_action)
                                    FillActionTable(tmp_action)
                                    disable_actions = true
                                    if (tmp_action.type == "cleaning") then
                                        local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                                        local vassouspawn = ESX.Game.SpawnObject(GetHashKey(vassoumodel), vector3(cSCoords.x, cSCoords.y, cSCoords.z),function(vassouspawn)
                                        local netid = ObjToNet(vassouspawn)
                                        ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
                                            TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
                                            AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
                                            vassour_net = netid
                                        end)
                                        SetTimeout(10000, function()
                                            disable_actions = false
                                            DetachEntity(NetToObj(vassour_net), 1, 1)
                                            DeleteEntity(NetToObj(vassour_net))
                                            vassour_net = nil
                                            ClearPedTasks(PlayerPedId())
                                            if true then
                                                actionsRemaining = actionsRemaining - 1
                                                TriggerServerEvent('esx_communityGGservice:completeService')
                                            end
                                            SetEntityHeading(PlayerPedId(), math.random(0,360))
                                        end)
                                        end)
                                    end
                                    if (tmp_action.type == "gardening") then
                                        SetEntityHeading(PlayerPedId(), math.random(0,360))
                                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
                                        SetTimeout(10000, function()
                                            disable_actions = false
                                            ClearPedTasks(PlayerPedId())
                                            actionsRemaining = actionsRemaining - 1
                                            TriggerServerEvent('esx_communityGGservice:completeService')
                                        end)
                                    end
                                end
                                suka = false
                                goto start_over
                            end
                        end
                    end
                elseif isSentenced then
                    isSentenced = false
                    TriggerServerEvent('esx_communityGGservice:finishCommunityService')
                    thread = false
                    break
                else
                    Citizen.Wait(1000)
                    thread = false
                    break
                end
            end
        end)
    end
end

function RemoveAction(action)
    local action_pos = -1

    for i=1, #availableActions do
        if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
            action_pos = i
        end
    end

    if action_pos ~= -1 then
        table.remove(availableActions, action_pos)
    else
        print("User tried to remove an unavailable action")
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawAvailableActions()
    for i = 1, #availableActions do
        DrawMarker(21, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
    end
    for k, v in pairs(ESX.Game.GetPlayers()) do
        local coords = GetEntityCoords(GetPlayerPed(v))
        DrawMarker(21, coords.x + 1, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
        DrawMarker(21, coords.x, coords.y + 1, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
    end

    for k, v in pairs(Config.pedLocation) do
        local coords = v
        DrawMarker(21, coords.x + 1, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
        DrawMarker(21, coords.x, coords.y + 1, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
    end
end

function DisableViolentActions()
    local playerPed = PlayerPedId()
    DisableControlAction(0, Keys['F2'],true)
    DisableControlAction(0, Keys['F1'],true)
	DisableControlAction(0, Keys['F3'],true)
	DisableControlAction(0, Keys['F5'],true)
	DisableControlAction(0, Keys['PAGEUP'], true)
	DisableControlAction(0, Keys['R'], true)
	DisableControlAction(0, Keys['M'], true)
    DisableControlAction(0, Keys[','], true)
    DisableControlAction(0, Keys['X'],true)
    DisableControlAction(2, 37, true)
    DisableControlAction(0, 36, true)
    DisablePlayerFiring(playerPed,true)
    DisableControlAction(0, 106, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, Keys['LEFTSHIFT'], true)
    DisableControlAction(0, Keys['SPACE'], true)
    if IsDisabledControlJustPressed(2, 37) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end
    if IsDisabledControlJustPressed(0, 106) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end


end

function ApplyPrisonerSkin()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        Citizen.CreateThread(function()
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
                end
            end)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            ResetPedMovementClipset(playerPed, 0)
        end)
    end
end

function draw2dText(text, pos)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(table.unpack(pos))
end

function deleteCSped()
    for k, v in pairs(peds) do
        DeleteEntity(v)
    end
    peds = {}
end

function spawnCSped()
    for k, v in pairs(Config.pedLocation) do
        SpawnLocalPed_Callback(4, 'ig_orleans', v - vec(0, 0, 1), math.random(1, 360), function(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            table.insert(peds, ped)
        end)
    end
end