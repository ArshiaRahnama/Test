-- تعریف متغیرهای اولیه و تنظیمات
local Debug_PNGReport = true -- ست کن false بعد از پیدا کردن باگ
local function dbg(fmt, ...)
    if Debug_PNGReport then
        print(("^5[PNG_ReportSystem DEBUG]^0 " .. fmt):format(...))
    end
end

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
    dbg("/%s pressed | now=%d lastCommandTime=%d diff=%d debounceTime=%d nuiFocusActive(BEFORE)=%s",
        Client_Config.CommandForUser, currentTime, lastCommandTime, currentTime - lastCommandTime, debounceTime, tostring(nuiFocusActive))

    if currentTime - lastCommandTime > debounceTime then
        if not nuiFocusActive then
            dbg("branch: OPEN user panel -> SendNUIMessage(action=%s) + SetNuiFocus(true,true)", actionShowUserPanel)
            SendNUIMessage({_pngReport = true, action = actionShowUserPanel})
            SetNuiFocus(true, true)
            nuiFocusActive = true
        else
            dbg("branch: CLOSE user panel -> SendNUIMessage(action=%s) + SetNuiFocus(false,false)", actionHideUserPanel)
            SendNUIMessage({_pngReport = true, action = actionHideUserPanel})
            SetNuiFocus(false, false)
            nuiFocusActive = false
        end
        lastCommandTime = currentTime
        dbg("nuiFocusActive(AFTER)=%s", tostring(nuiFocusActive))
    else
        -- NOTE: lastCommandTime is shared between CommandForUser AND
        -- CommandForAdmin (same variable, declared once above). Pressing
        -- /report then /areport (or vice versa) within debounceTime(2s)
        -- of EACH OTHER also hits this branch and does nothing but warn -
        -- worth ruling out if you tested both commands back to back.
        dbg("branch: DEBOUNCED (spam warning) - diff=%d <= debounceTime=%d. If you didn't press this command twice, check whether /%s was pressed recently (lastCommandTime is shared between both commands).",
            currentTime - lastCommandTime, debounceTime, Client_Config.CommandForAdmin)
        sendNotification(spamWarning)
        lastCommandTime = currentTime
    end
end)

-- فرمان برای باز و بسته کردن پنل ادمین با بررسی دسترسی
RegisterCommand(Client_Config.CommandForAdmin, function()
    dbg("/%s pressed | requesting access (permission=%s)", Client_Config.CommandForAdmin, tostring(Config_Shared.accessToAdminCommand))
    getAccess(Config_Shared.accessToAdminCommand, function(hasAccess)
        dbg("access callback returned: hasAccess=%s", tostring(hasAccess))
        if not hasAccess then
            dbg("STOPPED HERE: access denied by server (PNG_ReportSystem:Getaccess returned false) - this is why nothing opens.")
            return
        end
        local currentTime = GetGameTimer()
        dbg("now=%d lastCommandTime=%d diff=%d debounceTime=%d nuiFocusActive(BEFORE)=%s",
            currentTime, lastCommandTime, currentTime - lastCommandTime, debounceTime, tostring(nuiFocusActive))
        if currentTime - lastCommandTime > debounceTime then
            if not nuiFocusActive then
                dbg("branch: OPEN admin panel -> SendNUIMessage(action=%s) + SetNuiFocus(true,true)", actionShowAdminPanel)
                SendNUIMessage({_pngReport = true, action = actionShowAdminPanel})
                SetNuiFocus(true, true)
                nuiFocusActive = true
            else
                dbg("branch: CLOSE admin panel -> SendNUIMessage(action=%s) + SetNuiFocus(false,false)", actionHideAdminPanel)
                SendNUIMessage({_pngReport = true, action = actionHideAdminPanel})
                SetNuiFocus(false, false)
                nuiFocusActive = false
            end
            lastCommandTime = currentTime
            dbg("nuiFocusActive(AFTER)=%s", tostring(nuiFocusActive))
        else
            dbg("branch: DEBOUNCED (spam warning) - diff=%d <= debounceTime=%d. lastCommandTime is shared with /%s.",
                currentTime - lastCommandTime, debounceTime, Client_Config.CommandForUser)
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

-- کانال دیباگ جداگونه: F8 کنسولِ کلاینت فقط console.log صفحه‌ی اصلی NUI
-- (html/index.html) رو نشون میده، نه چیزی که داخل یه iframe جدا (مثل
-- ui/report/index.html) لاگ بشه. برای همین گزارش‌های خودِ report-frame
-- به‌جای console.log از این مسیر (fetch -> این NUI callback -> print)
-- میان که تو F8 قطعاً دیده بشن.
RegisterNUICallback("reportFrameDebug", function(data, cb)
    dbg("[report-frame] %s", tostring(data and data.msg))
    cb("ok")
end)

-- مدیریت درخواست‌های NUI callback
RegisterNUICallback("action", function(data, cb)
    dbg("NUI callback 'action' fired: action=%s (this confirms the report iframe's JS ran and posted back to Lua)", tostring(data and data.action))
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
        -- Guard: only release focus/reset state if the Report panel itself
        -- is the one that actually holds NUI focus right now. Without this,
        -- a stray "exit" (e.g. Escape reaching this iframe while a
        -- different panel - admin menu, AC menu - is the one visually
        -- open) would force SetNuiFocus(false,false) out from under that
        -- other panel without telling it to close, leaving it stuck
        -- rendered on screen with no working mouse/keyboard.
        dbg("exit action received | nuiFocusActive(BEFORE)=%s", tostring(nuiFocusActive))
        if nuiFocusActive then
            SetNuiFocus(false, false)
            nuiFocusActive = false
            dbg("-> SetNuiFocus(false,false) applied, nuiFocusActive(AFTER)=false")
        else
            dbg("-> IGNORED (nuiFocusActive was already false, so this exit did NOT come from a panel this script actually opened - likely a stale keyup/focus leak from another panel/iframe). If your mouse is stuck right after this line, the panel that's actually stuck open is NOT the report panel - check nui_panel.lua/ac_menu.lua's InAdminNui flag.")
        end
    elseif data.action == actionNotif then
        sendNotification(data.msg)
    else
        dbg("UNHANDLED action received: %s (no branch in this callback matches it - check for a typo/renamed action string between Lua and ui/report/js/script.js)", tostring(data.action))
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
