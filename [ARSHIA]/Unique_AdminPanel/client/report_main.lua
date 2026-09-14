-- تعریف متغیرهای اولیه و تنظیمات
local lastCommandTime = 0
local nuiFocusActive = false
local debounceTime = 2000
local ESX = nil

-- نام ایونت‌ها و کانفیگ‌ها
local ESXResourceName = "es_extended"
local ESXEventName = "esx:getSharedObject"
local chatAddMessageEvent = "chat:addMessage"

local reportPrefix = "^3 [ Report System ] "
local chatMessageColor = {255, 0, 0} -- رنگ قرمز
local allowMultilineChat = true

-- پیام‌ها
local spamWarning = "لطفا اسپم نکنید"

-- NUI Actions
local actionShowUserPanel = "showuserpannel"
local actionHideUserPanel = "hideuserpannel"
local actionShowAdminPanel = "showadminpannel"
local actionHideAdminPanel = "hideadminpannel"
local actionFeedback = "feedBack"
local actionUpdateUIMessage = "UpdateUIMessage"
local actionUpdateReportList = "updatereportList"
local actionCreateReport = "create"
local actionGetDataReport = "GetDataReport"
local actionGetTopAdmin = "GetTopAdmin"
local actionGetAllReport = "GetAllreport"
local actionAcceptReport = "acceptReport"
local actionDeleteReport = "deleteReport"
local actionCloseReport = "closeReport"
local actionRevive = "revive"
local actionTeleport = "teleport"
local actionGiveCar = "givecar"
local actionSpectate = "spect"
local actionFeedBackXP = "feedBackXP"
local actionNewChat = "newChat"
local actionExit = "exit"
local actionNotif = "notif"
local actionSpawnManager = "spwanManager"
local actionTpToPlayer = "tptoplayer"

-- مقدار رنگ رادیو خودرو
local radioOff = "OFF"

-- گرفتن شیء ESX
if Config_Shared.ESX_Version == 1 then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent(ESXEventName, function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
else
    ESX = exports[ESXResourceName]:getSharedObject()
end

-- تابع ارسال نوتیفیکیشن
local function sendNotification(message)
    ESX.ShowNotification(message)
end

-- تابع ارسال پیام به چت
local function sendChatMessage(message)
    TriggerEvent(chatAddMessageEvent, {
        color = chatMessageColor,
        multiline = allowMultilineChat,
        args = {reportPrefix, message}
    })
end

-- تابع گرفتن دسترسی از سرور (callback)
local function getAccess(permission, callback)
    ESX.TriggerServerCallback("PNG_ReportSystem:Getaccess", function(hasAccess)
        callback(hasAccess)
    end, permission)
end

-- فرمان برای باز و بسته کردن پنل کاربر
RegisterCommand(Client_Config.CommandForUser, function()
    local currentTime = GetGameTimer()
    if currentTime - lastCommandTime > debounceTime then
        if not nuiFocusActive then
            SendNUIMessage({_pngReport = true, action = actionShowUserPanel})
            SetNuiFocus(true, true)
            nuiFocusActive = true
        else
            SendNUIMessage({_pngReport = true, action = actionHideUserPanel})
            SetNuiFocus(false, false)
            nuiFocusActive = false
        end
        lastCommandTime = currentTime
    else
        sendNotification(spamWarning)
        lastCommandTime = currentTime
    end
end)

-- فرمان برای باز و بسته کردن پنل ادمین با بررسی دسترسی
RegisterCommand(Client_Config.CommandForAdmin, function()
    getAccess(Config_Shared.accessToAdminCommand, function(hasAccess)
        if not hasAccess then
            return
        end
        local currentTime = GetGameTimer()
        if currentTime - lastCommandTime > debounceTime then
            if not nuiFocusActive then
                SendNUIMessage({_pngReport = true, action = actionShowAdminPanel})
                SetNuiFocus(true, true)
                nuiFocusActive = true
            else
                SendNUIMessage({_pngReport = true, action = actionHideAdminPanel})
                SetNuiFocus(false, false)
                nuiFocusActive = false
            end
            lastCommandTime = currentTime
        else
            sendNotification(spamWarning)
            lastCommandTime = currentTime
        end
    end)
end)

-- مدیریت ایونت‌های NUI
RegisterNetEvent("PNG_ReportSystem:feedBack")
AddEventHandler("PNG_ReportSystem:feedBack", function(type, adminId)
    if type == "show" then
        SetNuiFocus(true, true)
        SendNUIMessage({_pngReport = true, action = actionFeedback, type = type, adminId = adminId})
    elseif type == "hide" then
        SetNuiFocus(false, false)
        SendNUIMessage({_pngReport = true, action = actionFeedback, type = type})
    end
end)

RegisterNetEvent("PNG_ReportSystem:UpdateUIMessage")
AddEventHandler("PNG_ReportSystem:UpdateUIMessage", function(type)
    if type == "user" then
        SendNUIMessage({_pngReport = true, action = "updateChatUser"})
    else
        SendNUIMessage({_pngReport = true, action = "updateChatadmin"})
    end
end)

RegisterNetEvent("PNG_ReportSystem:updateReportListAllAdmin")
AddEventHandler("PNG_ReportSystem:updateReportListAllAdmin", function()
    SendNUIMessage({_pngReport = true, action = actionUpdateReportList})
end)

-- مدیریت درخواست‌های NUI callback
RegisterNUICallback("action", function(data, cb)
    if data.action == actionCreateReport then
        TriggerServerEvent("PNG_ReportSystem:CreateNewRepot", data.data)
    elseif data.action == actionGetDataReport then
        ESX.TriggerServerCallback("PNG_ReportSystem:GetDataReport", cb)
    elseif data.action == actionGetTopAdmin then
        ESX.TriggerServerCallback("PNG_ReportSystem:GetTopAdmin", cb)
    elseif data.action == actionGetAllReport then
        ESX.TriggerServerCallback("PNG_ReportSystem:GetAllreport", cb)
    elseif data.action == actionAcceptReport then
        ESX.TriggerServerCallback("PNG_ReportSystem:acceptReport", cb, data.reportId)
    elseif data.action == actionDeleteReport then
        ESX.TriggerServerCallback("PNG_ReportSystem:deleteReport", cb, data.reportId)
    elseif data.action == "GetDataReportAdmin" then
        ESX.TriggerServerCallback("PNG_ReportSystem:GetDataReportAdmin", cb, data.reportId)
    elseif data.action == actionCloseReport then
        ESX.TriggerServerCallback("PNG_ReportSystem:closeReport", cb, data.id)
    elseif data.action == actionRevive then
        TriggerServerEvent("PNG_ReportSystem:revive", data.id)
    elseif data.action == actionTeleport then
        TriggerServerEvent("PNG_ReportSystem:teleport", data.id)
    elseif data.action == actionGiveCar then
        TriggerServerEvent("PNG_ReportSystem:givecar", data.id)
    elseif data.action == actionSpectate then
        TriggerServerEvent("PNG_ReportSystem:spect", data.id)
    elseif data.action == "feed" then
        TriggerServerEvent("PNG_ReportSystem:feedBackXP", data.id, data.adminId)
        TriggerEvent("PNG_ReportSystem:feedBack", "hide")
    elseif data.action == actionNewChat then
        ESX.TriggerServerCallback("PNG_ReportSystem:newChat", cb, data.id, data.user, data.text)
    elseif data.action == actionExit then
        SetNuiFocus(false, false)
        nuiFocusActive = false
    elseif data.action == actionNotif then
        sendNotification(data.msg)
    end
end)

-- مدیریت اسپاون ماشین ادمین
RegisterNetEvent("PNG_ReportSystem:spwanManager")
AddEventHandler("PNG_ReportSystem:spwanManager", function()
    local adminCarModel = Client_Config.AdminCar
    if not IsModelAVehicle(adminCarModel) or not IsModelInCdimage(adminCarModel) then
        return
    end
    ESX.ShowNotification("ماشین در حال بارگذاری است، لطفا صبر کنید")
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    Citizen.CreateThread(function()
        RequestModel(adminCarModel)
        while not HasModelLoaded(adminCarModel) do
            Citizen.Wait(0)
        end
        local vehicle = CreateVehicle(adminCarModel, playerCoords.x, playerCoords.y, playerCoords.z, playerHeading, true, false)
        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
        SetPedIntoVehicle(playerPed, vehicle, -1)
        SetNetworkIdCanMigrate(vehicleNetId, true)
        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(adminCarModel)
        RequestCollisionAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            RequestCollisionAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            Citizen.Wait(0)
        end
        SetVehRadioStation(vehicle, radioOff)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        TriggerServerEvent(Client_Config.AddKeyAfterSpwanCar, GetVehicleNumberPlateText(vehicle))
    end)
end)

-- تله‌پورت کردن بازیکن
RegisterNetEvent("PNG_ReportSystem:tptoplayer")
AddEventHandler("PNG_ReportSystem:tptoplayer", function(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
end)

-- ریوایو مستقل (به esx_ambulancejob وابسته نیست، چون اون فقط برای جاب آمبولانسه)
RegisterNetEvent("PNG_ReportSystem:doRevive")
AddEventHandler("PNG_ReportSystem:doRevive", function()
    local playerPed = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(playerPed), GetEntityHeading(playerPed), GetPedModel(playerPed), true, false)
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    ClearPedBloodDamage(playerPed)
    ClearPedTasksImmediately(playerPed)
end)
