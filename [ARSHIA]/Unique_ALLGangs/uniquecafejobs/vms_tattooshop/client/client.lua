if Config_vmstattoo.Core == "ESX" then
    ESX = nil
    if Config_vmstattoo.CoreDefine == "" then
        ESX = Config_vmstattoo.CoreExport()
    else
        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent(Config_vmstattoo.CoreDefine, function(definedCore)
                    ESX = definedCore
                end)
                Citizen.Wait(1)
            end
        end)
    end
elseif Config_vmstattoo.Core == "QBCore" then
    QBCore = Config_vmstattoo.CoreExport()
end

local CURRENT_TATTOOSHOP, CURRENT_CHAIR
local barberId, chairId
local UCPlayerData = {}
local Ped = nil
local currentTattoos = {}
local cam = nil
local canCancel

Citizen.CreateThread(function()
    for k, v in pairs(Config_vmstattoo.Tattooshops) do
        local blip = AddBlipForCoord(v.position)
	    SetBlipSprite(blip, Config_vmstattoo.Blip.Sprite)
	    SetBlipDisplay(blip, Config_vmstattoo.Blip.Display)
	    SetBlipScale(blip, Config_vmstattoo.Blip.Scale)
	    SetBlipColour(blip, Config_vmstattoo.Blip.Color)
	    SetBlipAsShortRange(blip, true)
	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentString(GetDisplayLabel(v.ownerJob, VmsDisplayName(v.ownerJob)))
	    EndTextCommandSetBlipName(blip)
	    TrackBusinessBlip(v.ownerJob, blip, VmsDisplayName(v.ownerJob))
    end
end)

RegisterNetEvent(Config_vmstattoo.PlayerLoaded)
AddEventHandler(Config_vmstattoo.PlayerLoaded, function()
    if Config_vmstattoo.Core == "ESX" then
        Citizen.Wait(1000)
        ESX.TriggerServerCallback('vms_tattooshop:requestPlayerTattoos', function(tattooList)
            if tattooList then
                for k,v in pairs(tattooList) do
                    Config_vmstattoo.TattooList[v.collection][v.texture].hasTattoo = true
                    ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config_vmstattoo.TattooList[v.collection][v.texture].nameHash))
                end
                currentTattoos = tattooList
            end
        end)
    elseif Config_vmstattoo.Core == "QBCore" then
        Citizen.Wait(1000)
        QBCore.Functions.TriggerCallback('vms_tattooshop:requestPlayerTattoos', function(tattooList)
            if tattooList then
                for k,v in pairs(tattooList) do
                    Config_vmstattoo.TattooList[v.collection][v.texture].hasTattoo = true
                    ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config_vmstattoo.TattooList[v.collection][v.texture].nameHash))
                end
                currentTattoos = tattooList
            end
        end)
    end
end)

RegisterNetEvent(Config_vmstattoo.PlayerLogout)
AddEventHandler(Config_vmstattoo.PlayerLogout, function()
    currentTattoos = {}
end)

if Config_vmstattoo.Core == "ESX" then
    RegisterNetEvent(Config_vmstattoo.PlayerLoaded)
    AddEventHandler(Config_vmstattoo.PlayerLoaded, function(xPlayer)
        UCPlayerData = xPlayer
    end)

    RegisterNetEvent(Config_vmstattoo.JobUpdated)
    AddEventHandler(Config_vmstattoo.JobUpdated, function(job)
        UCPlayerData.job = job 
    end)

    AddEventHandler('skinchanger:modelLoaded', function()
        ESX.TriggerServerCallback('vms_tattooshop:requestPlayerTattoos', function(tattooList)
            if tattooList then
                for k,v in pairs(tattooList) do
                    Config_vmstattoo.TattooList[v.collection][v.texture].hasTattoo = true
                    ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config_vmstattoo.TattooList[v.collection][v.texture].nameHash))
                end
                currentTattoos = tattooList
            end
        end)
    end)
elseif Config_vmstattoo.Core == "QBCore" then
    RegisterNetEvent(Config_vmstattoo.PlayerLoaded, function()
        CreateThread(function()
            QBCore.Functions.GetPlayerData(function(UCPlayerData)
                UCPlayerData = UCPlayerData
            end)
        end)
    end)

    RegisterNetEvent(Config_vmstattoo.JobUpdated, function(JobInfo)
        UCPlayerData.job = JobInfo
    end)
end

function TattooLoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

function requestPedModel(model)
    if not HasModelLoaded(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end
	end
end

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    while true do
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local sleep = 2000
        for k, v in pairs(Config_vmstattoo.Tattooshops) do
            for k2, v2 in pairs(Config_vmstattoo.Tattooshops[k].Chairs) do
                local distance = #(myCoords - v2.position)
                if distance < Config_vmstattoo.DistanceView then
                    sleep = 2
                    if not v2.busy then
                        --DrawMarker(1, v2.position.x, v2.position.y, v2.position.z+.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, v.takeSitMarker.FreeColor[1], v.takeSitMarker.FreeColor[2], v.takeSitMarker.FreeColor[3], v.takeSitMarker.FreeColor[4], false, false, false, true)
                        DrawMarker(1, v2.position.x, v2.position.y, v2.position.z+.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 126, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0) 
                    else
                        if not v.business then
                            DrawMarker(1, v2.position.x, v2.position.y, v2.position.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.takeSitMarker.BusyColor[1], v.takeSitMarker.BusyColor[2], v.takeSitMarker.BusyColor[3], v.takeSitMarker.BusyColor[4], false, false, false, true)
                        else
                            if UCPlayerData.job ~= nil and UCPlayerData.job.name == v.ownerJob then
                                DrawMarker(1, v2.position.x, v2.position.y, v2.position.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, v.takeSitMarker.BusyColor[2], v.takeSitMarker.BusyColor[3], v.takeSitMarker.BusyColor[4], false, false, false, true)
                            end
                        end
                    end
                end
                if distance < Config_vmstattoo.DistanceAccess and not CURRENT_CHAIR then
                    if not v.business then
                        if Config_vmstattoo.TextUI_Enabled then
                            inRange = Config_vmstattoo.Translate[Config_vmstattoo.Lang]["take_a_sit"]
                        else
                            if Config_vmstattoo.Core == "ESX" then
                                ESX.ShowHelpNotification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["take_a_sit"])
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            inRange = false
                            barberId, chairId = k, k2
                            readyToTattooing(v2)
                            createTattooPed(v, v2)
                            TriggerServerEvent("vms_tattooshop:sv:setBusyChair", barberId, chairId, true)
                        end
                    else
                        if v2.busy then
                            if UCPlayerData.job ~= nil and UCPlayerData.job.name == v.ownerJob then
                                if Config_vmstattoo.TextUI_Enabled then
                                    inRange = Config_vmstattoo.Translate[Config_vmstattoo.Lang]["open_tattooshop"]
                                else
                                    if Config_vmstattoo.Core == "ESX" then
                                        ESX.ShowHelpNotification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["open_tattooshop"])
                                    end
                                end
                            end
                        else
                            if Config_vmstattoo.TextUI_Enabled then
                                inRange = Config_vmstattoo.Translate[Config_vmstattoo.Lang]["take_a_sit"]
                            else
                                if Config_vmstattoo.Core == "ESX" then
                                    ESX.ShowHelpNotification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["take_a_sit"])
                                end
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            if UCPlayerData.job ~= nil and UCPlayerData.job.name == v.ownerJob and v2.busy then
                                inRange = false
                                barberId, chairId = k, k2
                                TriggerServerEvent("vms_tattooshop:getClientSkin", v2.busy)
                                TaskPedSlideToCoord(PlayerPedId(), v2.tattooerPos.x, v2.tattooerPos.y, v2.tattooerPos.z, v2.tattooerPos.w, 1.0)
                                Citizen.Wait(1200)
                                SetEntityCoords(PlayerPedId(), v2.tattooerPos.x, v2.tattooerPos.y, v2.tattooerPos.z)
                                SetEntityHeading(PlayerPedId(), v2.tattooerPos.w)
                            else
                                inRange = false
                                barberId, chairId = k, k2
                                readyToTattooing(v2, true)
                                TriggerServerEvent("vms_tattooshop:sv:setBusyChair", barberId, chairId, true)
                            end
                        end
                    end
                end
            end
        end
        if inRange and not shown then
            shown = true
            Config_vmstattoo.TextUI_Open(inRange)
        elseif not inRange and shown then
            shown = false
            Config_vmstattoo.TextUI_Close()
        end
        Citizen.Wait(sleep)
    end
end)

function readyToTattooing(v2, isBusiness)
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    SetEntityCoords(PlayerPedId(), v2.chair_coord.x, v2.chair_coord.y, v2.chair_coord.z)
    SetEntityHeading(PlayerPedId(), v2.chair_coord.w)
    local myPed = PlayerPedId()
    TattooLoadAnimDict(Config_vmstattoo.LiesAnims["backAnimDict"])
    TaskPlayAnim(myPed, Config_vmstattoo.LiesAnims["backAnimDict"], Config_vmstattoo.LiesAnims["backAnim"], 8.0, 8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(400)
    DoScreenFadeIn(200)
    if isBusiness then
        TattooCancelingThread(true)
    end
end

function TattooCancelingThread(start)
    Citizen.CreateThread(function()
        canCancel = start
        while canCancel do
            Citizen.Wait(1)
            if Config_vmstattoo.Core == "ESX" then
                ESX.ShowHelpNotification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["get_up"])
            end
            if IsControlJustPressed(0, 73) then
                TattooDeleteSkinCam(true)
                break
            end
        end
    end)
end

function createTattooPed(v, v2)
    CURRENT_TATTOOSHOP = v
    if not v.business and v.pedModel then
        local pedModel = GetHashKey(v.pedModel)
        requestPedModel(pedModel)
        Ped = CreatePed(1, pedModel, v.tattooPedSpawnPos.x, v.tattooPedSpawnPos.y, v.tattooPedSpawnPos.z, v.tattooPedSpawnPos.w, true, true)
        SetEntityHeading(Ped, v.tattooPedSpawnPos.w)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
        TaskPedSlideToCoord(Ped, v2.position.x, v2.position.y, v2.position.z, v2.position.w, 1.0)
        Citizen.Wait(5000)
        TaskPedSlideToCoord(Ped, v2.tattooerPos.x, v2.tattooerPos.y, v2.tattooerPos.z, v2.tattooerPos.w, 1.0)
        Citizen.Wait(1000)
        SetEntityCoords(Ped, v2.tattooerPos.x, v2.tattooerPos.y, v2.tattooerPos.z)
        SetEntityHeading(Ped, v2.tattooerPos.w)
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, true)
    end
    if Config_vmstattoo.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, Config_vmstattoo.ClothesOff["male"])
            elseif skin.sex == 1 then
                TriggerEvent('skinchanger:loadClothes', skin, Config_vmstattoo.ClothesOff["female"])
            end
        end)
    elseif Config_vmstattoo.Core == "QBCore" then
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        if gender == 0 then
            TriggerEvent('qb-clothing:client:loadOutfit', Config_vmstattoo.ClothesOff["male"])
        else
            TriggerEvent('qb-clothing:client:loadOutfit', Config_vmstattoo.ClothesOff["female"])
        end
    end
    TattooCreateSkinCam()
end

function TattooCreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    SendTattooNUI({
        action = "show",
        TattooList = Config_vmstattoo.TattooList
    })
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1500, true, true)
    SetNuiFocus(true, true)
    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), Config_vmstattoo.StartingCam[1]))
    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), Config_vmstattoo.StartingCam[2]))
end

function TattooDeleteSkinCam(isOwnerBarber)
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
    if not isOwnerBarber then
        SetNuiFocus(false, false)
        SendTattooNUI({action = "hide"})
        DeletePed(Ped)
        Ped = nil
    end
    if isOwnerBarber then
        local coords = Config_vmstattoo.Tattooshops[barberId].Chairs[chairId].position
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    end
    TriggerServerEvent("vms_tattooshop:sv:setBusyChair", barberId, chairId, false)
    FreezeEntityPosition(PlayerPedId(),false)
    ClearPedTasks(PlayerPedId())
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        reloadPlayerTattoos()
    end)
end

RegisterNUICallback("change", function(data)
    data = data or {}
    if data.clientId then
        TriggerServerEvent("vms_tattooshop:sv:updateClientSkin", data.clientId, data.item, data.collection)
    else
        local item = tonumber(data.item)
        if item and data.collection and Config_vmstattoo.TattooList[data.collection] and Config_vmstattoo.TattooList[data.collection][item + 1] then
            drawTattoo(item, data.collection)
        end
    end
    PlaySoundFrontend(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", true)
end)

RegisterNUICallback("switchCategory", function(data)
    data = data or {}
    PlaySoundFrontend(-1, "Hit_1", "LONG_PLAYER_SWITCH_SOUNDS", true)
    if not data.clientId then
        reloadPlayerTattoos()
    end
end)

RegisterNUICallback("buy", function(data)
    data = data or {}
    local dataid = data.id+1
    if data.clientId then
        TriggerServerEvent("vms_tattooshop:sv:buyClient", data.clientId, data.collection, data.id)
        Config_vmstattoo.Notification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["started_tattooing"], 2500, "success")
    else
        if Config_vmstattoo.Core == "ESX" then
            ESX.TriggerServerCallback("vms_tattooshop:buyTattoo", function(callback)
                if callback then
                    currentTattoos[#currentTattoos+1] = {collection = data.collection, texture = dataid}
                    Config_vmstattoo.TattooList[data.collection][dataid].hasTattoo = true
                    SendTattooNUI({action = "updateui", TattooList = Config_vmstattoo.TattooList, collection = data.collection})
                    PlaySoundFrontend(-1, 'REMOTE_PLYR_CASH_COUNTER_COMPLETE', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', 0)
                    reloadPlayerTattoos()
                else
                    PlaySoundFrontend(-1, 'Place_Prop_Fail', 'DLC_Dmod_Prop_Editor_Sounds', 0)
                end
            end, currentTattoos, data.collection, dataid, Config_vmstattoo.TattooList[data.collection][dataid].price, VmsCurrentShopJob())
        elseif Config_vmstattoo.Core == "QBCore" then
            QBCore.Functions.TriggerCallback("vms_tattooshop:buyTattoo", function(callback)
                if callback then
                    currentTattoos[#currentTattoos+1] = {collection = data.collection, texture = dataid}
                    Config_vmstattoo.TattooList[data.collection][dataid].hasTattoo = true
                    SendTattooNUI({action = "updateui", TattooList = Config_vmstattoo.TattooList, collection = data.collection})
                    reloadPlayerTattoos()
                    PlaySoundFrontend(-1, 'REMOTE_PLYR_CASH_COUNTER_COMPLETE', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', 0)
                else
                    PlaySoundFrontend(-1, 'Place_Prop_Fail', 'DLC_Dmod_Prop_Editor_Sounds', 0)
                end
            end, currentTattoos, data.collection, dataid, Config_vmstattoo.TattooList[data.collection][dataid].price, VmsCurrentShopJob())
        end
    end
end)

RegisterNUICallback("remove", function(data)
    data = data or {}
    local dataid = data.id+1
    if data.clientId then
        TriggerServerEvent("vms_tattooshop:sv:removeClient", data.clientId, data.collection, dataid)
        Config_vmstattoo.Notification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["removing_tattooing"], 2500, "success")
    else
        for k, v in pairs(currentTattoos) do
            if v.collection == data.collection and v.texture == dataid then
                table.remove(currentTattoos, k)
            end
        end
        Config_vmstattoo.TattooList[data.collection][dataid].hasTattoo = false
        SendTattooNUI({action = "updateui", TattooList = Config_vmstattoo.TattooList, collection = data.collection})
        TriggerServerEvent("vms_tattooshop:removeTattoo", currentTattoos, Config_vmstattoo.TattooList[data.collection][dataid].removePrice, VmsCurrentShopJob())
        reloadPlayerTattoos()
    end
end)

RegisterNUICallback("hide", function(data)
    data = data or {}
    if data.clientId then
        TriggerServerEvent("vms_tattooshop:sv:closeCam", data.clientId)
        SetNuiFocus(false, false)
        SendTattooNUI({action = "hide"})
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 500, true, true)
        cam = nil
    else
        TattooDeleteSkinCam()
        if Config_vmstattoo.Core == "ESX" then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin) 
            end)
        elseif Config_vmstattoo.Core == "QBCore" then
		    if Config_vmstattoo.SkinMenu == "qb-clothes" then
                TriggerServerEvent('qb-clothes:loadPlayerSkin')
            elseif Config_vmstattoo.SkinMenu == "fivem-appearance" then
                TriggerEvent("fivem-appearance:client:reloadSkin")
            end
        end
    end
end)

RegisterNetEvent("vms_tattooshop:cl:setBusyChair")
AddEventHandler("vms_tattooshop:cl:setBusyChair", function(barberId, chairId, toggle)
    local shop = Config_vmstattoo.Tattooshops[barberId]
    if shop and shop.Chairs and shop.Chairs[chairId] then shop.Chairs[chairId].busy = toggle end
end)

RegisterNetEvent("vms_tattooshop:cl:updateClientSkin")
AddEventHandler("vms_tattooshop:cl:updateClientSkin", function(id, collection, tattooer)
    drawTattoo(id, collection, tattooer or nil)
end)

RegisterNetEvent("vms_tattooshop:cl:updateTattooerCam")
AddEventHandler("vms_tattooshop:cl:updateTattooerCam", function(data, client)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
    end
    local playerindex = GetPlayerFromServerId(tonumber(client))
    local ped = GetPlayerPed(playerindex)

    if data.anim == "FRONT" then
        SetEntityHeading(ped, Config_vmstattoo.Tattooshops[barberId].pedHeadingToChair)
        TattooLoadAnimDict(Config_vmstattoo.LiesAnims["frontAnimDict"])
        TaskPlayAnim(ped, Config_vmstattoo.LiesAnims["frontAnimDict"], Config_vmstattoo.LiesAnims["frontAnim"], 8.0, 8.0, -1, 1, 1, true, true, true)
    elseif data.anim == "BACK" then
        SetEntityHeading(ped, Config_vmstattoo.Tattooshops[barberId].pedHeadingToChairBack)
        TattooLoadAnimDict(Config_vmstattoo.LiesAnims["backAnimDict"])
        TaskPlayAnim(ped, Config_vmstattoo.LiesAnims["backAnimDict"], Config_vmstattoo.LiesAnims["backAnim"], 8.0, 8.0, -1, 1, 1, true, true, true)
    end

    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(ped, data.camera[1]))
    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(ped, data.camera[2]))
end)

RegisterNetEvent("vms_tattooshop:cl:loadPlayerSkin")
AddEventHandler("vms_tattooshop:cl:loadPlayerSkin", function()
    if Config_vmstattoo.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
        end)
    elseif Config_vmstattoo.Core == "QBCore" then
		if Config_vmstattoo.SkinMenu == "qb-clothes" then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        elseif Config_vmstattoo.SkinMenu == "fivem-appearance" then
            TriggerEvent("fivem-appearance:client:reloadSkin")
        end
    end
end)

RegisterNetEvent("vms_tattooshop:cl:buyClient")
AddEventHandler("vms_tattooshop:cl:buyClient", function(collection, id, tattooer)
    local id = id + 1
    Config_vmstattoo.Notification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["started_tattooing"], 2500, "success")
    currentTattoos[#currentTattoos+1] = {collection = collection, texture = id}
    Config_vmstattoo.TattooList[collection][id].hasTattoo = true
    reloadPlayerTattoos()
    TriggerServerEvent("vms_tattooshop:sv:sendUpdated", Config_vmstattoo.TattooList, collection, tattooer)
    TriggerServerEvent("vms_tattooshop:saveClientTattoos", currentTattoos)
end)

RegisterNetEvent("vms_tattooshop:cl:removeClient")
AddEventHandler("vms_tattooshop:cl:removeClient", function(collection, id, tattooer)
    Config_vmstattoo.Notification(Config_vmstattoo.Translate[Config_vmstattoo.Lang]["removing_tattooing"], 2500, "success")
    for k, v in pairs(currentTattoos) do
        if v.collection == collection and v.texture == id then
            table.remove(currentTattoos, k)
        end
    end
    Config_vmstattoo.TattooList[collection][id].hasTattoo = false
    reloadPlayerTattoos()
    TriggerServerEvent("vms_tattooshop:sv:sendUpdated", Config_vmstattoo.TattooList, collection, tattooer)
    TriggerServerEvent("vms_tattooshop:saveClientTattoos", currentTattoos)
end)

RegisterNetEvent("vms_tattooshop:cl:updateUi")
AddEventHandler("vms_tattooshop:cl:updateUi", function(data, currentCollection)
    SendTattooNUI({action = "updateui", TattooList = data, collection = currentCollection})
end)

RegisterNetEvent("vms_tattooshop:cl:closeCam")
AddEventHandler("vms_tattooshop:cl:closeCam", function()
    TattooDeleteSkinCam(true)
    if Config_vmstattoo.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
        end)
    elseif Config_vmstattoo.Core == "QBCore" then
		if Config_vmstattoo.SkinMenu == "qb-clothes" then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        elseif Config_vmstattoo.SkinMenu == "fivem-appearance" then
            TriggerEvent("fivem-appearance:client:reloadSkin")
        end
    end
end)

RegisterNetEvent("vms_tattooshop:openBusiness")
AddEventHandler("vms_tattooshop:openBusiness", function(data, clientId)
    SetNuiFocus(true, true)
    SendTattooNUI({
        action = "show",
        TattooList = data,
        clientId = clientId
    })
end)

RegisterNetEvent("vms_tattooshop:getData")
AddEventHandler("vms_tattooshop:getData", function(plBarberId)
    TriggerServerEvent("vms_tattooshop:sendData", Config_vmstattoo.TattooList, plBarberId)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = PlayerPedId()
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    canCancel = false
    if Config_vmstattoo.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                TriggerEvent('skinchanger:loadClothes', skin, Config_vmstattoo.ClothesOff["male"])
            elseif skin.sex == 1 then
                TriggerEvent('skinchanger:loadClothes', skin, Config_vmstattoo.ClothesOff["female"])
            end
        end)
    elseif Config_vmstattoo.Core == "QBCore" then
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        if gender == 0 then
            TriggerEvent('qb-clothing:client:loadOutfit', Config_vmstattoo.ClothesOff["male"])
        else
            TriggerEvent('qb-clothing:client:loadOutfit', Config_vmstattoo.ClothesOff["female"])
        end
    end
    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), Config_vmstattoo.StartingCam[1]))
    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(PlayerPedId(), Config_vmstattoo.StartingCam[2]))
end)

drawTattoo = function(current, collection, tattooer)
    if not current or not collection or not Config_vmstattoo.TattooList[collection] or not Config_vmstattoo.TattooList[collection][current + 1] then return end
    local current = current + 1
	ClearPedDecorations(PlayerPedId())
    for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config_vmstattoo.TattooList[v.collection][v.texture].nameHash))
	end
    selectedCamera(collection, current, tattooer or nil)
	ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(Config_vmstattoo.TattooList[collection][current].nameHash))
end

reloadPlayerTattoos = function()
    ClearPedDecorations(PlayerPedId())
    for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config_vmstattoo.TattooList[v.collection][v.texture].nameHash))
	end
end
exports('reloadPlayerTattoos', reloadPlayerTattoos) -- vms_barber (and other vms_ resources) call this cross-resource after changing appearance; was never exported in the vendor's shipped file

selectedCamera = function(collection, id, tattooer)
    local selectedTattoo = Config_vmstattoo.TattooList[collection][id]
    local myPed = PlayerPedId()
    if selectedTattoo.anim == "FRONT" then
        SetEntityHeading(myPed, Config_vmstattoo.Tattooshops[barberId].pedHeadingToChair)
        TattooLoadAnimDict(Config_vmstattoo.LiesAnims["frontAnimDict"])
        TaskPlayAnim(myPed, Config_vmstattoo.LiesAnims["frontAnimDict"], Config_vmstattoo.LiesAnims["frontAnim"], 3.0, 3.0, -1, 1, 0, false, false, false)
    elseif selectedTattoo.anim == "BACK" then
        SetEntityHeading(myPed, Config_vmstattoo.Tattooshops[barberId].pedHeadingToChairBack)
        TattooLoadAnimDict(Config_vmstattoo.LiesAnims["backAnimDict"])
        TaskPlayAnim(myPed, Config_vmstattoo.LiesAnims["backAnimDict"], Config_vmstattoo.LiesAnims["backAnim"], 3.0, 3.0, -1, 1, 0, false, false, false)
    end
    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(myPed, selectedTattoo.camera[1]))
    PointCamAtCoord(cam, GetOffsetFromEntityInWorldCoords(myPed, selectedTattoo.camera[2]))
    if tattooer then
        TriggerServerEvent("vms_tattooshop:sv:updateTattooerCam", tattooer, selectedTattoo)
    end
end

RegisterNetEvent("vms_tattooshop:cl:notification", function(message, time, type)
    Config_vmstattoo.Notification(message, time, type)
end)

-- uniquecafejobs bridge (see vms_tattooshop/server/server.lua)
function SendTattooNUI(msg) SendNUIMessage({ __routeTo = 'tattoo', payload = msg }) end
function VmsCurrentShopJob()
    local shop = barberId and Config_vmstattoo.Tattooshops[barberId]
    return shop and shop.ownerJob or nil
end
