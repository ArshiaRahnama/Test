waitingForLoadAfterRestart = false
currentBarberManagement = nil
stores = {}

CURRENT_BARBER, CURRENT_CHAIR, CURRENT_CLIENT, CLIENT_ID, CLIENT_PED = nil, nil, nil, nil, nil

CURRENT_FADES_LIST = nil

barberId, chairId = nil, nil
Ped = nil

billCache = {};

PlayerData = {}
local heading = 0.0

cam = nil;

Character_AP = {}

Character_Temp_Tattoos = {}
currentTattoos = {}

local canCancel = false

function SafeGetHairFadesList()
    if not (Config.VMSTattooshopName and GetResourceState(Config.VMSTattooshopName) == 'started') then return {} end
    local ok, result = pcall(function()
        return exports[Config.VMSTattooshopName]:GetHairFadesList()
    end)
    if not ok then
        print(('[vms_barber] ^1ERROR:^7 exports["%s"]:GetHairFadesList() failed: %s'):format(Config.VMSTattooshopName, tostring(result)))
        print('[vms_barber] ^3Check that vms_tattooshop is up to date and actually exports a function named "GetHairFadesList".^7')
        return {}
    end
    return result or {}
end

-- Safe wrappers around the vms_tattooshop integration.
-- Prevents a hard script error / stuck UI if the export is missing,
-- renamed, or vms_tattooshop hasn't finished starting yet.
function SafeReloadPlayerTattoos()
    if not (Config.VMSTattooshopName and GetResourceState(Config.VMSTattooshopName) == 'started') then return end
    local ok, err = pcall(function()
        exports[Config.VMSTattooshopName]:reloadPlayerTattoos()
    end)
    if not ok then
        print(('[vms_barber] ^1ERROR:^7 exports["%s"]:reloadPlayerTattoos() failed: %s'):format(Config.VMSTattooshopName, tostring(err)))
        print('[vms_barber] ^3Check that vms_tattooshop is up to date and actually exports a function named "reloadPlayerTattoos".^7')
    end
end

function SafeReloadPlayerTattoosByBarber(tempTattoos, cb)
    if not (Config.VMSTattooshopName and GetResourceState(Config.VMSTattooshopName) == 'started') then
        if cb then cb() end
        return
    end
    local ok, err = pcall(function()
        exports[Config.VMSTattooshopName]:reloadPlayerTattoosByBarber(tempTattoos, cb)
    end)
    if not ok then
        print(('[vms_barber] ^1ERROR:^7 exports["%s"]:reloadPlayerTattoosByBarber() failed: %s'):format(Config.VMSTattooshopName, tostring(err)))
        print('[vms_barber] ^3Check that vms_tattooshop is up to date and actually exports a function named "reloadPlayerTattoosByBarber".^7')
        if cb then cb() end -- still continue the UI flow instead of hanging
    end
end

if Config.Core == "ESX" then
    ESX = Config.CoreExport()
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()
end

RegisterNetEvent(Config.PlayerLoaded)
AddEventHandler(Config.PlayerLoaded, function(PLAYER_DATA)
    PlayerData = Config.Core == "ESX" and PLAYER_DATA or Config.Core == "QB-Core" and QBCore.Functions.GetPlayerData()
    waitingForLoadAfterRestart = true
	TriggerServerEvent("vms_barber:fetchData")
end)

RegisterNetEvent(Config.JobUpdated)
AddEventHandler(Config.JobUpdated, function(job)
    PlayerData.job = job 
end) 

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if Config.Core == "ESX" then
        while not ESX do
            Citizen.Wait(200)
        end
        if ESX.IsPlayerLoaded() then
			PlayerData = ESX.GetPlayerData()
            waitingForLoadAfterRestart = true
            Citizen.Wait(2500)
            TriggerServerEvent("vms_barber:fetchData")
        end
    elseif Config.Core == "QB-Core" then
        while not QBCore do
            Citizen.Wait(200)
        end
        if QBCore.Functions.GetPlayerData() and QBCore.Functions.GetPlayerData().job then
			PlayerData = QBCore.Functions.GetPlayerData()
            waitingForLoadAfterRestart = true
            Citizen.Wait(2500)
            TriggerServerEvent("vms_barber:fetchData")
        end
    end
end)

RegisterNetEvent("vms_barber:fetchedData", function(_stores, dbVehiclePrices)
	stores = _stores

    if Config.UseVMSCityHall and Config.UseCityHallTaxes then
        for _, v in pairs(Config.Barbers) do
            local prices = {}
            for name, data in pairs(v.prices) do
                local totalAmount, taxAmount, taxPercentage = exports[Config.VMSCityHallResource]:getTaxAmount(data.price, 'barber')
                prices[name] = {
                    price = data.price,
                    totalAmount = totalAmount,
                    taxAmount = taxAmount,
                    taxPercentage = taxPercentage,
                }
            end
            v.prices = prices
        end
    end

	waitingForLoadAfterRestart = false
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Barbers) do
        local blip = AddBlipForCoord(v.position)
	    SetBlipSprite(blip, Config.Blip.Sprite)
	    SetBlipDisplay(blip, Config.Blip.Display)
	    SetBlipScale(blip, Config.Blip.Scale)
	    SetBlipColour(blip, Config.Blip.Color)
	    SetBlipAsShortRange(blip, true)
	    BeginTextCommandSetBlipName("STRING")
	    AddTextComponentString(TRANSLATE("blip.barber"))
	    EndTextCommandSetBlipName(blip)
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function loadPedModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(5)
    end
end

function unloadPlayerProps()
    local myPed = PlayerPedId()
    SetPedComponentVariation(myPed, 1, -1, 0, 2)
    ClearPedProp(myPed, 0)
    ClearPedProp(myPed, 1)
end

Citizen.CreateThread(function()
    if Config.UseTarget then
        for k, v in pairs(Config.Barbers) do
            for k2, v2 in pairs(v.Chairs) do
                v2.targetId = CL.Target('point', {
                    coords = v2.chairCoord.xyz,
                    size = v2.targetSize,
                    rotation = v2.chairCoord.w,
                    icon = 'fa-solid fa-scissors',
                    label = TRANSLATE('target.barber_chair'),
                }, function()
                    if v2.taken then
                        if v.business and PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob then
                            CURRENT_CLIENT = v2
                            barberId = k
                            TriggerServerEvent("vms_barber:getClientSkin", v2.taken)
                            TaskPedSlideToCoord(PlayerPedId(), v2.barberPos.x, v2.barberPos.y, v2.barberPos.z, v2.barberPos.w, 1.0)
                            Citizen.Wait(1200)
                            SetEntityCoords(PlayerPedId(), v2.barberPos.x, v2.barberPos.y, v2.barberPos.z)
                            SetEntityHeading(PlayerPedId(), v2.barberPos.w)
                        end
                    else
                        if v.business then
                            barberId, chairId = k, k2
                            TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, true)
                            readyCutHair(v2, true)
                        else
                            barberId, chairId = k, k2
                            TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, true)
                            readyCutHair(v2)
                            createBarber(v, v2)
                        end
                    end
                end)
            end

            if v.business and v.ownerJob and v.bossMenu then
                v.bossMenu.targetId = CL.Target('point', {
                    coords = v.bossMenu.coords.xyz,
                    rotation = v.bossMenu.coords.w or 0.0,
                    size = v.bossMenu.targetSize.xyz,
                    job = v.ownerJob,
                    label = TRANSLATE('target.boss_menu'),
                    icon = 'fa-solid fa-dollar-sign'
                }, function()
                    openBossMenu(k)
                end)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    while not Config.UseTarget do
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local sleep = 2000
        for k, v in pairs(Config.Barbers) do
            for k2, v2 in pairs(Config.Barbers[k].Chairs) do
                local distance = #(myCoords - v2.position)
                if distance < Config.DistanceView then
                    sleep = 2
                    if not v2.taken then
                        DrawMarker(Config.Markers['FreeSeat'].id, v2.position.x, v2.position.y, v2.position.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['FreeSeat'].size, v.takeSitMarker.FreeColor[1], v.takeSitMarker.FreeColor[2], v.takeSitMarker.FreeColor[3], v.takeSitMarker.FreeColor[4], Config.Markers['FreeSeat'].bobUpAndDown, false, false, Config.Markers['FreeSeat'].rotate)
                    else
                        if not v.business then
                            DrawMarker(Config.Markers['TakenSeat'].id, v2.position.x, v2.position.y, v2.position.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['TakenSeat'].size, v.takeSitMarker.TakenColor[1], v.takeSitMarker.TakenColor[2], v.takeSitMarker.TakenColor[3], v.takeSitMarker.TakenColor[4], Config.Markers['TakenSeat'].bobUpAndDown, false, false, Config.Markers['TakenSeat'].rotate)
                        else
                            if PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob then
                                DrawMarker(Config.Markers['TakenSeat'].id, v2.position.x, v2.position.y, v2.position.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['TakenSeat'].size, v.takeSitMarker.TakenColor[1], v.takeSitMarker.TakenColor[2], v.takeSitMarker.TakenColor[3], v.takeSitMarker.TakenColor[4], Config.Markers['TakenSeat'].bobUpAndDown, false, false, Config.Markers['TakenSeat'].rotate)
                            end
                        end
                    end
                end
                if distance < Config.DistanceAccess and not CURRENT_CHAIR then
                    if not v.business then
                        if CL.TextUI.Enabled then
                            inRange = TRANSLATE("textui.take_a_sit")
                        else
                            if Config.Core == "ESX" then
                                ESX.ShowHelpNotification(TRANSLATE("help.take_a_sit"))
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            inRange = false
                            barberId, chairId = k, k2
                            TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, true)
                            readyCutHair(v2)
                            createBarber(v, v2)
                        end
                    else
                        if v2.taken then
                            if PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob then
                                if CL.TextUI.Enabled then
                                    inRange = TRANSLATE("textui.open_barber")
                                else
                                    if Config.Core == "ESX" then
                                        ESX.ShowHelpNotification(TRANSLATE("help.open_barber"))
                                    end
                                end
                            end
                        else
                            if CL.TextUI.Enabled then
                                inRange = TRANSLATE("textui.take_a_sit")
                            else
                                if Config.Core == "ESX" then
                                    ESX.ShowHelpNotification(TRANSLATE("help.take_a_sit"))
                                end
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            if PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob and v2.taken then
                                inRange = false
                                CURRENT_CLIENT = v2
                                barberId, chairId = k, k2
                                TriggerServerEvent("vms_barber:getClientSkin", v2.taken)
                                TaskPedSlideToCoord(PlayerPedId(), v2.barberPos.x, v2.barberPos.y, v2.barberPos.z, v2.barberPos.w, 1.0)
                                Citizen.Wait(1200)
                                SetEntityCoords(PlayerPedId(), v2.barberPos.x, v2.barberPos.y, v2.barberPos.z)
                                SetEntityHeading(PlayerPedId(), v2.barberPos.w)
                            elseif not v2.taken then
                                inRange = false
                                barberId, chairId = k, k2
                                TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, true)
                                readyCutHair(v2, true)
                            end
                        end
                    end
                end
            end
        end
        if inRange and not shown then
            shown = true
            CL.TextUI.Open(inRange)
        elseif not inRange and shown then
            shown = false
            CL.TextUI.Close()
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    local shown = false
    while not Config.UseTarget do
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local sleep = 2000
        for k, v in pairs(Config.Barbers) do
            if v.bossMenu and v.bossMenu.coords then
                local distance = #(myCoords - v.bossMenu.coords.xyz)
                if v.bossMenuGrades then
                    v.hasAccessToThis = false
                    if PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob then
                        if type(v.bossMenuGrades) == "table" then
                            for gradeK, gradeV in ipairs(v.bossMenuGrades) do
                                if Config.Core == "ESX" and (PlayerData.job.grade_name == gradeV) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == gradeV) then
                                    v.hasAccessToThis = true
                                end
                            end
                        else
                            if Config.Core == "ESX" and (PlayerData.job.grade_name == v.bossMenuGrades) or Config.Core == "QB-Core" and (PlayerData.job.grade.name == v.bossMenuGrades) then
                                v.hasAccessToThis = true
                            end
                        end
                    end
                end
                if v.hasAccessToThis and distance < Config.DistanceView then
                    sleep = 1
                    if PlayerData.job ~= nil and PlayerData.job.name == v.ownerJob then
                        DrawMarker(Config.Markers['BossMenu'].id, v.bossMenu.coords.x, v.bossMenu.coords.y, v.bossMenu.coords.z+.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Markers['BossMenu'].size, Config.Markers['BossMenu'].color[1], Config.Markers['BossMenu'].color[2], Config.Markers['BossMenu'].color[3], Config.Markers['BossMenu'].color[4], Config.Markers['BossMenu'].bobUpAndDown, false, false, Config.Markers['BossMenu'].rotate, false, false, false)
                        if distance < Config.DistanceAccess then
                            if v.business then
                                if CL.TextUI.Enabled then
                                    inRange = TRANSLATE("textui.boss_menu")
                                else
                                    if Config.Core == "ESX" then
                                        ESX.ShowHelpNotification(TRANSLATE("help.boss_menu"))
                                    end
                                end
                                if IsControlJustPressed(0, 38) then
                                    openBossMenu(k)
                                end
                            end
                        end
                    end
                end
            end
        end
        if inRange and not shown then
            shown = true
            CL.TextUI.Open(inRange)
        elseif not inRange and shown then
            shown = false
            CL.TextUI.Close()
        end
        Citizen.Wait(sleep)
    end
end)

function readyCutHair(v2, isBusiness)
    local myPed = PlayerPedId();

    if isBusiness then
        canCancel = true
    end

    CURRENT_CHAIR = v2

    TaskPedSlideToCoord(myPed, v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z, v2.chairCoord.w)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    -- SetEntityCoords(myPed, v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z)
    -- SetEntityHeading(myPed, v2.chairCoord.w)
    FreezeEntityPosition(myPed, true)
    Citizen.Wait(100)
    SetEntityCoords(myPed, v2.chairCoord.x, v2.chairCoord.y, v2.chairCoord.z)
    SetEntityHeading(myPed, v2.chairCoord.w)

    loadAnimDict(Config.ChairSittingAnim[1])
    TaskPlayAnim(myPed, Config.ChairSittingAnim[1], Config.ChairSittingAnim[2], 1.0, 1.0, -1, 2, 0, false, false, false)

    -- FreezeEntityPosition(myPed, true)
    Citizen.Wait(100)
    SetEntityHeading(myPed, v2.chairCoord.w)
    Citizen.Wait(1300)
    SetEntityHeading(myPed, v2.chairCoord.w)
    DoScreenFadeIn(5000)
    if isBusiness then
        CancelingThread()
    end
end

function CancelingThread(start)
    Citizen.CreateThread(function()
        if start ~= nil then
            canCancel = start
            Citizen.Wait(10)
        end
        while canCancel do
            Citizen.Wait(1)
            if Config.Core == "ESX" and not CL.TextUI.Enabled then
                ESX.ShowHelpNotification(TRANSLATE("help.get_up"))
            end
            if IsControlJustPressed(0, 73) then
                DeleteSkinCam(true)
                break
            end
        end
    end)
end

function createBarber(v, v2)
    CURRENT_FADES_LIST = nil
    CURRENT_BARBER = v
    if not v.business and v.barber then
        local barber = GetHashKey(v.barber)
        loadPedModel(barber)
        Ped = CreatePed(1, barber, v.barberSpawnPos.x, v.barberSpawnPos.y, v.barberSpawnPos.z, v.barberSpawnPos.w, true, true)
        SetEntityHeading(Ped, v.barberSpawnPos.w)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
        TaskPedSlideToCoord(Ped, v2.position.x, v2.position.y, v2.position.z, v2.position.w, 1.0)
        Citizen.Wait(5000)
        TaskPedSlideToCoord(Ped, v2.barberPos.x, v2.barberPos.y, v2.barberPos.z, v2.barberPos.w, 1.0)
        Citizen.Wait(1000)
        SetEntityCoords(Ped, v2.barberPos.x, v2.barberPos.y, v2.barberPos.z)
        SetEntityHeading(Ped, v2.barberPos.w)
        FreezeEntityPosition(Ped, true)
    end
    if Config.Core == "ESX" then 
        if Config.SkinManager == "esx_skin" then
            refreshValues()
        end
    end
    local data = {}
    local components, maxVals = getMaxValues()
    for i=1, #components, 1 do
        data[components[i].name] = {
            value = components[i].value,
            min = components[i].min,
        }
        for k,v in pairs(maxVals) do
            if k == components[i].name then
                data[k].max = v
                break
            end
        end
    end
    
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        SafeReloadPlayerTattoos()
    end

    -- if Config.UseQSInventory then
    --     exports[Config.QSInventoryName]:setInClothing(true)
    -- end
    
    if Config.SkinManager == "esx_skin" then
        TriggerEvent('skinchanger:getData', function(comp, max)
            for k, v in pairs(comp) do
                if data[v.name] then
                    data[v.name].value = tonumber(v.value)
                end
            end
        end)

    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
        Character_AP = exports[Config.SkinManager]:getPedAppearance(PlayerPedId())
        
    elseif Config.SkinManager == "qb-clothing" then
        QBCore.Functions.TriggerCallback('vms_barber:getCurrentSkin', function(skin)
            Character_QB = json.decode(skin)
        end)
        
    end

    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        CURRENT_FADES_LIST = SafeGetHairFadesList()

        for k, v in pairs(CURRENT_FADES_LIST) do
            if v.hasTattoo then
                Character_Temp_Tattoos[tostring(k)] = true
            end
        end
    end

    unloadPlayerProps()
    SendNUIMessage({
        action = "showBarberMenu",
        data = data,
        Makeup = Config.CanMakeup,
        CustomNames = Config.CustomNames,
        prices = v.prices,

        hairFades = CURRENT_FADES_LIST,
        tempTattoos = Character_Temp_Tattoos,
        
        skinManager = Config.SkinManager
    })
    CreateSkinCam()
end

function CreateSkinCam(clientId)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = clientId and GetPlayerPed(GetPlayerFromServerId(tonumber(clientId))) or PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    heading = GetEntityHeading(playerPed) - 225.0
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetNuiFocus(true, true)
    
    changeCam(playerPed)
end

function DeleteSkinCam(isOwnerBarber)
    CLIENT_ID = nil
    CLIENT_PED = nil
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam, true)
    cam = nil
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
    if not isOwnerBarber then
        SetNuiFocus(false, false)
        SendNUIMessage({action = "hideBarberMenu"})
        DeletePed(Ped)
        Ped = nil
    end
    if isOwnerBarber then
        local coords = Config.Barbers[barberId].Chairs[chairId].position
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    end
    heading = 0.0
    TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, false)
    FreezeEntityPosition(PlayerPedId(),false)
    ClearPedTasks(PlayerPedId())
    barberId = nil
    CURRENT_CHAIR = nil
    SetNuiFocus(false, false)
    SendNUIMessage({action='closeBarberPreview'})
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        SafeReloadPlayerTattoos()
    end
end

RegisterNUICallback("change", function(data)
    if data.clientId then
        TriggerServerEvent("vms_barber:sv:updateClientSkin", data.clientId, data.type, data.new)
    else
        Character_ESX[data.type] = data.new
        if Config.Core == "ESX" then
            if Config.SkinManager == "esx_skin" then
                TriggerEvent('skinchanger:change', data.type, data.new)
            elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                appearance_switcher(data.type, data.new)
            end
        elseif Config.Core == "QB-Core" then
            if Config.SkinManager == "qb-clothing" then
                qbcore_switcher(data.type, data.new)
            elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                appearance_switcher(data.type, data.new)
            end
        end
        unloadPlayerProps()
    end
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)

RegisterNUICallback("removeFade", function(data)
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        if data.clientId then
            TriggerServerEvent("vms_barber:sv:removeClientTattoo", data.clientId, data.id)
        else
            currentTattoos[tostring(data.id)] = nil
            if CURRENT_FADES_LIST[tonumber(data.id)] and CURRENT_FADES_LIST[tonumber(data.id)].hasTattoo then
                Character_Temp_Tattoos[tostring(data.id)] = true
                currentTattoos[tostring(data.id)] = nil
            else
                Character_Temp_Tattoos[tostring(data.id)] = false
            end

            SafeReloadPlayerTattoosByBarber(Character_Temp_Tattoos, function()
                SendNUIMessage({
                    action = 'updateCurrentFades',
                    tempTattoos = Character_Temp_Tattoos,
                    currentTattoos = currentTattoos,
                })
            end)
        end
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end)
    
RegisterNUICallback("changeFade", function(data)
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                
        if data.clientId then
            TriggerServerEvent("vms_barber:sv:updateClientTattoos", data.clientId, data.id)
        else
            if Character_Temp_Tattoos[tostring(data.id)] then
                Character_Temp_Tattoos[tostring(data.id)] = false
                currentTattoos[tostring(data.id)] = true
                
                if not CURRENT_FADES_LIST[tonumber(data.id)].hasTattoo then
                    currentTattoos[tostring(data.id)] = nil
                end
            else
                Character_Temp_Tattoos[tostring(data.id)] = true
            end

            SafeReloadPlayerTattoosByBarber(Character_Temp_Tattoos, function()
                if CURRENT_FADES_LIST[tonumber(data.id)] then
                    if CURRENT_FADES_LIST[tonumber(data.id)].hasTattoo then
                        if Character_Temp_Tattoos[tostring(data.id)] then
                            currentTattoos[tostring(data.id)] = nil
                        end
                    else
                        if Character_Temp_Tattoos[tostring(data.id)] then
                            currentTattoos[tostring(data.id)] = true
                        end
                    end
                end
                
                SendNUIMessage({
                    action = 'updateCurrentFades',
                    tempTattoos = Character_Temp_Tattoos,
                    currentTattoos = currentTattoos,
                })
            end)
        end
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end)

RegisterNUICallback("hide", function(data)
    if data and data.clientId then
        TriggerServerEvent("vms_barber:sv:closeCam", data.clientId)
        CLIENT_ID = nil
        CLIENT_PED = nil
        SetNuiFocus(false, false)
        SendNUIMessage({action = "hideBarberMenu"})
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, true)
        cam = nil
    else
        DeleteSkinCam()
        if Config.Core == "ESX" then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin) 
            end)
            
        elseif Config.Core == "QB-Core" then
            if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                TriggerEvent(Config.SkinManager..':client:reloadSkin')
                
            elseif Config.SkinManager == "qb-clothing" then
                TriggerServerEvent("qb-clothes:loadPlayerSkin")
                TriggerServerEvent("qb-clothing:loadPlayerSkin")

            end
        end
    end
end)

RegisterNetEvent("vms_barber:cl:takeChair")
AddEventHandler("vms_barber:cl:takeChair", function(barberId, chairId, toggle)
    Config.Barbers[barberId].Chairs[chairId].taken = toggle
end)

RegisterNetEvent("vms_barber:cl:updateClientSkin")
AddEventHandler("vms_barber:cl:updateClientSkin", function(type, new)
    Character_ESX[type] = new
    if Config.Core == "ESX" then
        if Config.SkinManager == "esx_skin" then
            TriggerEvent('skinchanger:change', type, new)
        elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            appearance_switcher(type, new)
        end
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "qb-clothing" then
            qbcore_switcher(type, new)
        elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            appearance_switcher(type, new)
        end
    end
    unloadPlayerProps()
end)

RegisterNetEvent("vms_barber:cl:updateClientTattoos")
AddEventHandler("vms_barber:cl:updateClientTattoos", function(barber, id)
    if Character_Temp_Tattoos[tostring(id)] then
        Character_Temp_Tattoos[tostring(id)] = false
        currentTattoos[tostring(id)] = true
        
        if not CURRENT_FADES_LIST[tonumber(id)].hasTattoo then
            currentTattoos[tostring(id)] = nil
        end
    else
        Character_Temp_Tattoos[tostring(id)] = true
    end

    SafeReloadPlayerTattoosByBarber(Character_Temp_Tattoos, function()
        if CURRENT_FADES_LIST[tonumber(id)] then
            if CURRENT_FADES_LIST[tonumber(id)].hasTattoo then
                if Character_Temp_Tattoos[tostring(id)] then
                    currentTattoos[tostring(id)] = nil
                end

            else
                if Character_Temp_Tattoos[tostring(id)] then
                    currentTattoos[tostring(id)] = true
                end
            end
        end

        TriggerServerEvent("vms_barber:sv:updatedClientTattoos", barber, Character_Temp_Tattoos, currentTattoos)
    end)
end)

RegisterNetEvent("vms_barber:cl:removeClientTattoo")
AddEventHandler("vms_barber:cl:removeClientTattoo", function(barber, id)
    currentTattoos[tostring(data.id)] = nil
    if CURRENT_FADES_LIST[tonumber(data.id)] and CURRENT_FADES_LIST[tonumber(data.id)].hasTattoo then
        Character_Temp_Tattoos[tostring(data.id)] = true
        currentTattoos[tostring(data.id)] = nil
    else
        Character_Temp_Tattoos[tostring(data.id)] = false
    end

    SafeReloadPlayerTattoosByBarber(Character_Temp_Tattoos, function()
        TriggerServerEvent("vms_barber:sv:updatedClientTattoos", barber, Character_Temp_Tattoos, currentTattoos)
    end)
end)

RegisterNetEvent('vms_barber:cl:closedCam')
AddEventHandler('vms_barber:cl:closedCam', function(clientId)
    TriggerServerEvent("vms_barber:sv:closeCam", clientId)
    SetNuiFocus(false, false)
    SendNUIMessage({action = "hideBarberMenu"})
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end)


RegisterNetEvent('vms_barber:cl:updatedClientTattoos')
AddEventHandler('vms_barber:cl:updatedClientTattoos', function(_Character_Temp_Tattoos, _currentTattoos)
    Character_Temp_Tattoos = _Character_Temp_Tattoos
    currentTattoos = _currentTattoos
    SendNUIMessage({
        action = 'updateCurrentFades',
        tempTattoos = Character_Temp_Tattoos,
        currentTattoos = currentTattoos,
    })
end)

RegisterNetEvent('vms_barber:cl:businessUpdatedFades')
AddEventHandler('vms_barber:cl:businessUpdatedFades', function(fadesData, isBarber)
    currentTattoos = {}
    CURRENT_FADES_LIST = fadesData
    for k, v in pairs(CURRENT_FADES_LIST) do
        if v.hasTattoo then
            Character_Temp_Tattoos[tostring(k)] = true
        end
    end

    if isBarber then
        SendNUIMessage({
            action = 'updateCurrentFades',
            tempTattoos = Character_Temp_Tattoos,
            currentTattoos = currentTattoos,
        })
    end
end)

RegisterNetEvent("vms_barber:cl:loadPlayerSkin")
AddEventHandler("vms_barber:cl:loadPlayerSkin", function(type, new)
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
            if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                Character_AP = skin
            end
            unloadPlayerProps()
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
        end)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            TriggerEvent(Config.SkinManager..':client:reloadSkin', true)
            unloadPlayerProps()
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
        elseif Config.SkinManager == "qb-clothing" then
            TriggerServerEvent("qb-clothes:loadPlayerSkin")
            TriggerServerEvent("qb-clothing:loadPlayerSkin")
            unloadPlayerProps()
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
        end
    end
end)

RegisterNetEvent("vms_barber:cl:buyClient")
AddEventHandler("vms_barber:cl:buyClient", function()
    -- SetNuiFocus(false, false)
    SendNUIMessage({action = "closeReceipt"})
    billCache = {}

    if Config.Core == "ESX" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if Config.SkinManager == "esx_skin" then
                TriggerServerEvent('esx_skin:save', skin)
                
            elseif Config.SkinManager == "fivem-appearance" then
                TriggerEvent('fivem-appearance:setOutfit', Character_AP)
                TriggerServerEvent('fivem-appearance:save', Character_AP)
                
            elseif Config.SkinManager == "illenium-appearance" then
                TriggerServerEvent('illenium-appearance:server:saveAppearance', Character_AP)

            end
        end)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == 'qb-clothing' then
            local model = GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') and GetHashKey('mp_m_freemode_01') or GetHashKey('mp_f_freemode_01')
            local character_encode = json.encode(Character_QB)
            TriggerServerEvent("qb-clothing:saveSkin", model, character_encode)

        elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            local playerPed = PlayerPedId()
            local appearance = exports[Config.SkinManager]:getPedAppearance(playerPed)
            TriggerServerEvent(Config.SkinManager..':server:saveAppearance', appearance)

        end
    end
    unloadPlayerProps()
    CL.Notification(TRANSLATE("notify.started_cutting_hair_by_employee"), 3500, "success")
end)

RegisterNetEvent("vms_barber:cl:closeCam")
AddEventHandler("vms_barber:cl:closeCam", function()
    DeleteSkinCam(true)
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
            if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                SafeReloadPlayerTattoos()
            end

        end)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            TriggerEvent(Config.SkinManager..':client:reloadSkin', true)
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
            if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                SafeReloadPlayerTattoos()
            end

        elseif Config.SkinManager == "qb-clothing" then
            TriggerServerEvent("qb-clothes:loadPlayerSkin")
            TriggerServerEvent("qb-clothing:loadPlayerSkin")
            -- if Config.UseQSInventory then
            --     exports[Config.QSInventoryName]:setInClothing(false)
            -- end
            if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                SafeReloadPlayerTattoos()
            end

        end
    end
end)

RegisterNetEvent("vms_barber:cl:animation")
AddEventHandler("vms_barber:cl:animation", function(playAnimation)
    CURRENT_FADES_LIST = {}
    Character_Temp_Tattoos = {}
    currentTattoos = {}
    if playAnimation then
        local myPed = PlayerPedId()
        SendNUIMessage({action = "hideBarberMenu"})
        SetNuiFocus(true, false)
        loadAnimDict(Config.AnimDict)
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 500, true, true)
        TaskPlayAnim(myPed, Config.AnimDict, Config.Anim, 8.0, 8.0, 15000, 0, 0, false, false, false)
        CL.Notification(TRANSLATE("notify.you_started_cutting_customer"), 2500, "success")
        Citizen.Wait(11500)
        TaskPedSlideToCoord(myPed, CURRENT_CLIENT.barberPos.x, CURRENT_CLIENT.barberPos.y, CURRENT_CLIENT.barberPos.z, CURRENT_CLIENT.barberPos.w, 1.0)
        SendNUIMessage({action = "openAgain"})
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        SetNuiFocus(true, true)
    else
        SendNUIMessage({action = "openAgain"})
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent("vms_barber:openBusiness")
AddEventHandler("vms_barber:openBusiness", function(data, tattoos, clientId)
    SetNuiFocus(true, true)
    CreateSkinCam(clientId)
    
    local barberData = Config.Barbers[barberId]
    CLIENT_ID = clientId
    CLIENT_PED = GetPlayerFromServerId(CLIENT_ID)

    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        CURRENT_FADES_LIST = tattoos
        for k, v in pairs(CURRENT_FADES_LIST) do
            if v.hasTattoo then
                Character_Temp_Tattoos[tostring(k)] = true
            end
        end
    end

    SendNUIMessage({
        action = "showBarberMenu",
        data = data,
        Makeup = Config.CanMakeup,
        CustomNames = Config.CustomNames,
        prices = barberData.prices,

        hairFades = Config.UseVMSTattooshop and Config.UseHairFadeInBarber and CURRENT_FADES_LIST or nil,
        tempTattoos = Config.UseVMSTattooshop and Config.UseHairFadeInBarber and Character_Temp_Tattoos or nil,

        clientId = clientId
    })
end)

RegisterNetEvent("vms_barber:getData")
AddEventHandler("vms_barber:getData", function(plBarberId)
    if Config.Core == "ESX" then 
        if Config.SkinManager == "esx_skin" then
            refreshValues()
        end
    end
    local data = {}
    local components, maxVals = getMaxValues()
    for i=1, #components, 1 do
        data[components[i].name] = {
            value = components[i].value,
            min = components[i].min,
        }
        for k,v in pairs(maxVals) do
            if k == components[i].name then
                data[k].max = v
                break
            end
        end
    end

    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        SafeReloadPlayerTattoos()
    end

    canCancel = false
    -- if Config.UseQSInventory then
    --     exports[Config.QSInventoryName]:setInClothing(true)
    -- end

    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        CURRENT_FADES_LIST = SafeGetHairFadesList()

        for k, v in pairs(CURRENT_FADES_LIST) do
            if v.hasTattoo then
                Character_Temp_Tattoos[tostring(k)] = true
            end
        end
    end

    if Config.SkinManager == "esx_skin" then
        TriggerEvent('skinchanger:getData', function(comp, max)
            for k, v in pairs(comp) do
                if data[v.name] then
                    data[v.name].value = tonumber(v.value)
                end
            end
        end)
        
    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
        Character_AP = exports[Config.SkinManager]:getPedAppearance(PlayerPedId())
        
    elseif Config.SkinManager == "qb-clothing" then
        QBCore.Functions.TriggerCallback('vms_barber:getCurrentSkin', function(skin)
            Character_QB = json.decode(skin)
        end)
        
    end
    unloadPlayerProps()
    TriggerServerEvent("vms_barber:sendData", data, CURRENT_FADES_LIST, plBarberId)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    heading = GetEntityHeading(playerPed) - 225.0
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    canCancel = false
    SetEntityHeading(playerPed, 0.0)
    changeCam(playerPed)

    SetNuiFocus(true, true)
    SetEntityHeading(playerPed, CURRENT_CHAIR.chairCoord.w)
    SendNUIMessage({action='openBarberPreview'})
end)

RegisterNetEvent('vms_barber:cl:getBillFeedback', function(receiver, playerId, type)
    if receiver == 'customer' then
        SendNUIMessage({action = "closeReceipt"})
        billCache = {}
        return
    end

    if type == 'wait' then
        SendNUIMessage({action = "billFeedback", status = 1})
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({action = "billFeedback"})
end)

RegisterNetEvent('vms_barber:cl:getBill', function(values, total)
    billCache = {
        values = values,
        total = total
    }
    SetNuiFocus(true, true)
    SendNUIMessage({action = "openReceipt", totalPrice = billCache.total, values = billCache.values})
end)


RegisterNetEvent("vms_barber:notification", function(message, time, type)
    CL.Notification(message, time, type)
end)

changeCam = function(ped)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.7, 0.0)
    local pCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 31086))

    SetCamFov(cam, 50.0)
    SetCamCoord(cam, vec(offsetCoords.x, offsetCoords.y, pCoords.z))
    PointCamAtPedBone(cam, ped, 31086)
end

local angleY = 0.0
local angleZ = 0.0
function FreeCamNewPosition(data)
    local mouseX = data.x
    local mouseY = data.y
    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    if (angleY > 89.0) then
      angleY = 89.0
    elseif (angleY < -89.0) then
      angleY = -89.0
    end

    local ped = CLIENT_PED and GetPlayerPed(CLIENT_PED) or PlayerPedId()
    local pCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 31086))

    local behindCam = {x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (5.5 + 0.5), y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (5.5 + 0.5), z = pCoords.z + ((Sin(angleY))) * (5.5 + 0.5)}
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, ped, 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    local maxRadius = 1
    local offset = {x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius, y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius, z = ((Sin(angleY))) * maxRadius}
    local pos = {x = pCoords.x + offset.x, y = pCoords.y + offset.y, z = pCoords.z + offset.z}

    if IsCamActive(cam) then
        SetCamCoord(cam, pos.x, pos.y, pos.z)
        PointCamAtPedBone(cam, ped, 31086)
    end
end

RegisterNetEvent("vms_cityhall:updatedStatusResume", function(jobName, val)
    if not Config.UseCityHallResumes then
        return
    end
    
    if currentBarberManagement then
        if Config.Barbers[currentBarberManagement].ownerJob == jobName then
            SendNUIMessage({
				action = "updateManagementMenu",
                isResumesAllowed = val
			})
        end
    end
end)

RegisterNetEvent("vms_cityhall:updatedBusinessTaxes", function(jobName, taxesList)
    if not Config.UseCityHallTaxes then
        return
    end
    
    if currentBarberManagement then
        if Config.Barbers[currentBarberManagement].ownerJob == jobName then
            SendNUIMessage({
				action = "updateManagementMenu",
                taxes = taxesList,
			})
        end
    end
end)

RegisterNetEvent("vms_barber:updateBusiness", function(_storeId, _storeData, specificValues)
    if not stores[_storeId] then return end;
    local societyBalance = 0
	if specificValues then
		if specificValues.sub then
			if specificValues.sub == 'balance' or specificValues.sub == 'totalEarned' or specificValues.sub == 'totalCustomers' then
                if specificValues.sub == 'balance' and not Config.UseBuildInCompanyBalance then
					societyBalance = specificValues.value
				else
					stores[_storeId].data[specificValues.sub] = specificValues.value
				end
			else
				stores[_storeId][specificValues.sub] = specificValues.value
			end
		else
			for k, v in pairs(specificValues) do
				if v.sub == "data" then
					stores[_storeId][v.sub] = v.value
				else
                    if v.sub == 'balance' and not Config.UseBuildInCompanyBalance then
						societyBalance = v.value
					else
                        stores[_storeId].data[v.sub] = v.value
                    end
				end
			end
		end
	else
		stores[_storeId] = _storeData
	end
	if currentBarberManagement and currentBarberManagement == _storeId then
		if specificValues and specificValues.sub and specificValues.sub == "employees" then
			CL.GetEmployees(function(employees)
				SendNUIMessage({
					action = "updateManagementMenu",
					storeData = stores[currentBarberManagement],
					employees = employees,
					employeesCount = #employees,
				})
			end, Config.Barbers[currentBarberManagement].ownerJob)
		else
			SendNUIMessage({
				action = "updateManagementMenu",
				storeData = stores[currentBarberManagement],
                societyBalance = not Config.UseBuildInCompanyBalance and (tonumber(societyBalance) and tostring(societyBalance)) or nil
			})
		end
	end
end)

openBossMenu = function(barberPointId)
    if waitingForLoadAfterRestart then
        return
    end

    if Config.UseVMSCityHall then
        if Config.Core == "ESX" then
            ESX.TriggerServerCallback('vms_cityhall:getBusinessData', function(resumesList, taxesList)
                local resumesList = resumesList;
                local taxesList = taxesList;
                CL.GetEmployees(function(employees)
                    currentBarberManagement = barberPointId
                    SendNUIMessage({
                        action = "openManagementMenu",
                        storeData = stores[barberPointId],
                        storeCfg = Config.Barbers[barberPointId],
                        employees = employees,
                        employeesCount = #employees,
                        isEmployee = CL.IsEmployee(Config.Barbers[barberPointId].ownerJob),
                        isManager = CL.IsManager(Config.Barbers[barberPointId].ownerJob, barberPointId),
                        isBoss = CL.IsBoss(Config.Barbers[barberPointId].ownerJob, barberPointId),
                        
                        cityhallGrades = CL.IsAllowedCityhall(Config.Barbers[barberPointId].ownerJob, barberPointId),

                        isResumesAllowed = Config.UseCityHallResumes and exports[Config.VMSCityHallResource]:isResumesAllowed(Config.Barbers[barberPointId].ownerJob) or false,
                        resumes = resumesList,
    
                        isTaxesAllowed = Config.UseCityHallTaxes,
                        taxes = taxesList,
                        
                    })
                end, Config.Barbers[barberPointId].ownerJob)
            end, Config.UseCityHallResumes, Config.UseCityHallTaxes)
        else
            QBCore.Functions.TriggerCallback('vms_cityhall:getBusinessData', function(resumesList, taxesList)
                local resumesList = resumesList;
                local taxesList = taxesList;
                CL.GetEmployees(function(employees)
                    currentBarberManagement = barberPointId
                    SendNUIMessage({
                        action = "openManagementMenu",
                        storeData = stores[barberPointId],
                        storeCfg = Config.Barbers[barberPointId],
                        employees = employees,
                        employeesCount = #employees,
                        isEmployee = CL.IsEmployee(Config.Barbers[barberPointId].ownerJob),
                        isManager = CL.IsManager(Config.Barbers[barberPointId].ownerJob, barberPointId),
                        isBoss = CL.IsBoss(Config.Barbers[barberPointId].ownerJob, barberPointId),
    
                        cityhallGrades = CL.IsAllowedCityhall(Config.Barbers[barberPointId].ownerJob, barberPointId),
                        
                        isResumesAllowed = Config.UseCityHallResumes and exports[Config.VMSCityHallResource]:isResumesAllowed(Config.Barbers[barberPointId].ownerJob) or false,
                        resumes = resumesList,
    
                        isTaxesAllowed = Config.UseCityHallTaxes,
                        taxes = taxesList,
                        
                    })
                end, Config.Barbers[barberPointId].ownerJob)
            end, Config.UseCityHallResumes, Config.UseCityHallTaxes)
        end
    else
        CL.GetEmployees(function(employees)
            currentBarberManagement = barberPointId
            SendNUIMessage({
                action = "openManagementMenu",
                storeData = stores[barberPointId],
                storeCfg = Config.Barbers[barberPointId],
                employees = employees,
                employeesCount = #employees,
                isEmployee = CL.IsEmployee(Config.Barbers[barberPointId].ownerJob),
                isManager = CL.IsManager(Config.Barbers[barberPointId].ownerJob, barberPointId),
                isBoss = CL.IsBoss(Config.Barbers[barberPointId].ownerJob, barberPointId),
            })
        end, Config.Barbers[barberPointId].ownerJob)
    end
    
	SetNuiFocus(true, true)
    if not Config.UseBuildInCompanyBalance then
		Citizen.Wait(300)
		TriggerServerEvent(Config.ESXSocietyEvents['check'], Config.Barbers[barberPointId].ownerJob)
	end
end

closeManagementMenu = function()
	SendNUIMessage({action = "closeManagementMenu"})
    currentBarberManagement = nil
	SetNuiFocus(false, false)
end