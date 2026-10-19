-- ╔═╗ ╔╗╔╗ ╔╗╔══╗    ╔═══╗╔╗  ╔╗╔═══╗╔═╗ ╔╗╔════╗╔═══╗
-- ║║╚╗║║║║ ║║╚╣╠╝    ║╔══╝║╚╗╔╝║║╔══╝║║╚╗║║║╔╗╔╗║║╔═╗║
-- ║╔╗╚╝║║║ ║║ ║║     ║╚══╗╚╗║║╔╝║╚══╗║╔╗╚╝║╚╝║║╚╝║╚══╗
-- ║║╚╗║║║║ ║║ ║║     ║╔══╝ ║╚╝║ ║╔══╝║║╚╗║║  ║║  ╚══╗║
-- ║║ ║║║║╚═╝║╔╣╠╗    ║╚══╗ ╚╗╔╝ ║╚══╗║║ ║║║ ╔╝╚╗ ║╚═╝║
-- ╚╝ ╚═╝╚═══╝╚══╝    ╚═══╝  ╚╝  ╚═══╝╚╝ ╚═╝ ╚══╝ ╚═══╝

RegisterNUICallback('loaded', function(data, cb)
    data = data or {}
    SendBarberNUI({
        action = "loaded",
        lang = Config_vmsbarber.Language,
        useBuildInBalance = Config_vmsbarber.UseBuildInCompanyBalance,
        removeBalanceFromMenu = Config_vmsbarber.RemoveBalanceFromMenu,
        
        useTattooshopFade = Config_vmsbarber.UseVMSTattooshop and Config_vmsbarber.UseHairFadeInBarber,

        useCityHall = Config_vmsbarber.UseVMSCityHall,
        useCityHallResumes = Config_vmsbarber.UseCityHallResumes,
        useCityHallTaxes = Config_vmsbarber.UseCityHallTaxes,
        useCityHallIncludedTaxes = Config_vmsbarber.UseCityHallIncludedTaxes,

        taxBusinessAllowMakeDelayedDeclarations = Config_vmsbarber.UseVMSCityHall and Config_vmsbarber.UseCityHallTaxes and exports[Config_vmsbarber.VMSCityHallResource]:TaxBusinessAllowMakeDelayedDeclarations() or nil,
        taxBusinessPercentagePerMonthForDelay = Config_vmsbarber.UseVMSCityHall and Config_vmsbarber.UseCityHallTaxes and exports[Config_vmsbarber.VMSCityHallResource]:TaxBusinessPercentagePerMonthForDelay() or nil,
    })
end)

RegisterNUICallback("clicked", function(data)
    data = data or {}
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end)

RegisterNUICallback("payment", function(data)
    data = data or {}
    local barberData = Config_vmsbarber.Barbers[barberId];
    local totalPrice = 0;
    local taxAmount = 0;
    local values = {};

    if Config_vmsbarber.UseVMSCityHall and Config_vmsbarber.UseCityHallTaxes then
        for k, v in pairs(data.currentValues) do
            if tonumber(v.default) ~= tonumber(v.value) then
                values[k] = barberData.prices[k].totalAmount
                totalPrice = totalPrice + barberData.prices[k].totalAmount
                taxAmount = taxAmount + barberData.prices[k].taxAmount
            end
        end
        if Config_vmsbarber.UseVMSTattooshop and Config_vmsbarber.UseHairFadeInBarber then
            for k, v in pairs(currentTattoos) do
                values['fade:'..k] = barberData.prices['hair_fade'].totalAmount
                totalPrice = totalPrice + barberData.prices['hair_fade'].totalAmount
                taxAmount = taxAmount + barberData.prices['hair_fade'].taxAmount
            end
        end
    else
        for k, v in pairs(data.currentValues) do
            if tonumber(v.default) ~= tonumber(v.value) then
                values[k] = barberData.prices[k].price
                totalPrice = totalPrice + barberData.prices[k].price
            end
        end
        if Config_vmsbarber.UseVMSTattooshop and Config_vmsbarber.UseHairFadeInBarber then
            for k, v in pairs(currentTattoos) do
                values['fade:'..k] = barberData.prices['hair_fade'].price
                totalPrice = totalPrice + barberData.prices['hair_fade'].price
            end
        end
    end
    
    if CLIENT_ID then
        if data.type == "receipt" then
            TriggerServerEvent("vms_barber:sv:buyClientReceipt", CLIENT_ID, barberId, data.isChangingHairStyle, values, totalPrice, taxAmount)
        end
    else
        if Config_vmsbarber.Core == "ESX" then
            ESX.TriggerServerCallback("vms_barber:getMoney", function(success, callback)
                if success then
                    currentTattoos = {}

                    if Config_vmsbarber.UseVMSTattooshop and Config_vmsbarber.UseHairFadeInBarber then
                        CURRENT_FADES_LIST = SafeGetHairFadesList()
                        
                        for k, v in pairs(CURRENT_FADES_LIST) do
                            if v.hasTattoo then
                                Character_Temp_Tattoos[tostring(k)] = true
                            end
                        end
                    end

                    CL.Notification(TRANSLATE("notify.paid", callback), 3500, "success")
                    if CURRENT_BARBER.barber then
                        FreezeEntityPosition(Ped, false)
                        SendBarberNUI({action = "billFeedback", status = 1})
                        loadAnimDict(Config_vmsbarber.AnimDict)
                        TaskPlayAnim(Ped, Config_vmsbarber.AnimDict, Config_vmsbarber.Anim, 8.0, 8.0, 15000, 0, 0, -1, -1, -1)
                        Citizen.Wait(11500)
                    end
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if Config_vmsbarber.SkinManager == "esx_skin" then
                            TriggerServerEvent('esx_skin:save', skin)

                        elseif Config_vmsbarber.SkinManager == "fivem-appearance" then
                            TriggerEvent('fivem-appearance:setOutfit', Character_AP)
                            TriggerServerEvent('fivem-appearance:save', Character_AP)

                        elseif Config_vmsbarber.SkinManager == "illenium-appearance" then
                            TriggerServerEvent('illenium-appearance:server:saveAppearance', Character_AP)

                        end
                    end)
                    unloadPlayerProps()
                    SendBarberNUI({action = "openAgain"})
                    FreezeEntityPosition(Ped, true)
                else
                    CL.Notification(TRANSLATE("notify.nomoney"), 3500, "error")
                end
            end, totalPrice, data.type, currentTattoos)
        elseif Config_vmsbarber.Core == "QB-Core" then
            QBCore.Functions.TriggerCallback('vms_barber:getMoney', function(success, callback)
                if success then
                    currentTattoos = {}

                    if Config_vmsbarber.UseVMSTattooshop and Config_vmsbarber.UseHairFadeInBarber then
                        CURRENT_FADES_LIST = SafeGetHairFadesList()
                
                        for k, v in pairs(CURRENT_FADES_LIST) do
                            if v.hasTattoo then
                                Character_Temp_Tattoos[tostring(k)] = true
                            end
                        end
                    end

                    CL.Notification(TRANSLATE("notify.paid", callback), 3500, "success")
                    if CURRENT_BARBER.barber then
                        FreezeEntityPosition(Ped, false)
                        SendBarberNUI({action = "billFeedback", status = 1})
                        loadAnimDict(Config_vmsbarber.AnimDict)
                        TaskPlayAnim(Ped, Config_vmsbarber.AnimDict, Config_vmsbarber.Anim, 8.0, 8.0, 15000, 0, 0, -1, -1, -1)
                        Citizen.Wait(11500)
                    end
                    if Config_vmsbarber.SkinManager == 'qb-clothing' then
                        local model = GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') and GetHashKey('mp_m_freemode_01') or GetHashKey('mp_f_freemode_01')
                        local character_encode = json.encode(Character_QB)
                        TriggerServerEvent("qb-clothing:saveSkin", model, character_encode)
                        
                    elseif Config_vmsbarber.SkinManager == "fivem-appearance" or Config_vmsbarber.SkinManager == "illenium-appearance" then
                        local playerPed = PlayerPedId()
                        local appearance = exports[Config_vmsbarber.SkinManager]:getPedAppearance(playerPed)
                        TriggerServerEvent(Config_vmsbarber.SkinManager..':server:saveAppearance', appearance)

                    end
                    unloadPlayerProps()
                    SendBarberNUI({action = "openAgain"})
                    FreezeEntityPosition(Ped, true)
                else
                    CL.Notification(TRANSLATE("notify.nomoney"), 3500, "error")
                end
            end, totalPrice, data.type, currentTattoos)
        end
    end
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    
end)

RegisterNUICallback('bill', function(data, cb)
    data = data or {}
    if data.action == 'pay' then
        TriggerServerEvent("vms_barber:sv:payBill", 'pay', data.type, currentTattoos)
    else
        TriggerServerEvent("vms_barber:sv:payBill", 'cancel')
        -- SetNuiFocus(false, false)
        SendBarberNUI({action = "closeReceipt"})
        billCache = {}
    end
end)

RegisterNUICallback('closeByClient', function(data, cb)
    data = data or {}
    TriggerServerEvent('vms_barber:sv:closedCam')
end)

RegisterNUICallback('updateCamera', function(data, cb)
    data = data or {}
    FreeCamNewPosition({
        x = data.deltaX/2,
        y = data.deltaY/2,
    })
end)

RegisterNUICallback('updateCameraZoom', function(data, cb)
    data = data or {}
    if data.type then
        if IsCamActive(cam) then
            local camFov = GetCamFov(cam)
            if data.type == 'plus' and camFov - 1.5 > 8.0 or data.type == 'minus' and camFov + 1.5 < 50.0 then
                camFov = data.type == 'plus' and camFov - 1.5 or camFov + 1.5
                SetCamFov(cam, camFov)
            end
        end
    end
end)

RegisterNUICallback('closeMenu', function(data, cb)
    data = data or {}
    closeManagementMenu()
end)

RegisterNUICallback('closeManagementMenu', function(data, cb)
    data = data or {}
    closeManagementMenu()
end)

RegisterNUICallback('sendAnnouncement', function(data, cb)
    data = data or {}
    if data.text then
        TriggerServerEvent("vms_barber:sendAnnouncement", currentBarberManagement, data.text)
    end
end)

RegisterNUICallback('getClosestPlayers', function(data, cb)
    data = data or {}
    if not currentBarberManagement then
        return
    end
    local players = CL.GetClosestPlayers()
    local playerInArea = {}
    if not players then
        Config_vmsbarber.Notification(TRANSLATE('notify.employees:no_players_around'), 3000, 'error')
        return
    end
    for k, v in pairs(players) do
        playerInArea[#playerInArea + 1] = GetPlayerServerId(v)
    end
    SendBarberNUI({
        action = "updateManagementMenu",
        players = playerInArea,
    })
end)

RegisterNUICallback('hireEmployee', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    TriggerServerEvent("vms_barber:hireAnEmployee", currentBarberManagement, data.playerId)
end)

RegisterNUICallback('bonusEmployee', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    TriggerServerEvent("vms_barber:bonusEmployee", currentBarberManagement, data.identifier, data.bonusMoney)
end)

RegisterNUICallback('changeGradeEmployee', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    TriggerServerEvent("vms_barber:changeGradeEmployee", currentBarberManagement, data.identifier, data.grade)
end)

RegisterNUICallback('fireEmployee', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    TriggerServerEvent("vms_barber:fireEmployee", currentBarberManagement, data.identifier)
end)

RegisterNUICallback('withdraw', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    if tonumber(data.money) and tonumber(data.money) >= 1 then
        if not Config_vmsbarber.UseBuildInCompanyBalance then
            TriggerServerEvent(Config_vmsbarber.ESXSocietyEvents['withdraw'], Config_vmsbarber.Barbers[currentBarberManagement].ownerJob, tonumber(data.money))
        else
            TriggerServerEvent("vms_barber:withdraw", currentBarberManagement, tonumber(data.money))
        end
    end
end)

RegisterNUICallback('uc_deposit', function(data, cb)
    data = data or {}
    if not currentBarberManagement then return end
    if tonumber(data.money) and tonumber(data.money) >= 1 then
        if not Config_vmsbarber.UseBuildInCompanyBalance then
            TriggerServerEvent(Config_vmsbarber.ESXSocietyEvents['deposit'], Config_vmsbarber.Barbers[currentBarberManagement].ownerJob, tonumber(data.money))
        else
            TriggerServerEvent("vms_barber:deposit", currentBarberManagement, tonumber(data.money))
        end
    end
end)