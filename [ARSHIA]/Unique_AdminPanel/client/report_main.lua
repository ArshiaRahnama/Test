--[[ ===========================================================================
    Unique RP - Report System | client/report_main.lua
    arshiahub.ir

    اصلاحات کلیدی نسبت به نسخه قبلی:
      • هر NUI callback حتما cb() صدا زده میشه. نسخه قبلی برای create /
        revive / teleport / givecar / spect / feed / exit / notif هیچوقت
        cb رو صدا نمیزد؛ نتیجه‌اش این بود که fetch های NUI هیچوقت resolve
        نمیشدن و بعد از چندبار استفاده پنل قفل میشد.
      • کول‌داونِ /report و /areport از هم جدا شد (قبلا یک متغیر مشترک بود
        و زدن یکی، اون یکی رو ۲ ثانیه قفل میکرد).
      • ESX محلی و lazy است؛ به گلوبال ESX ریسورس دست نمیزنیم.
=========================================================================== ]]

local ESX             = nil
local nuiFocusActive  = false
local activePanel     = nil        -- 'user' | 'admin' | 'rating'
local lastUserCmd     = 0
local lastAdminCmd    = 0
local returnCoords    = nil        -- برای /report return
local adminCarHandle  = nil
local isFrozen        = false

-- ============================================================ ESX ===

CreateThread(function()
    if Config_Shared.ESX_Version == 2 then
        while ESX == nil do
            local ok, obj = pcall(function()
                return exports[Config_Shared.ESX_Export]:getSharedObject()
            end)
            if ok and obj then ESX = obj end
            Wait(200)
        end
    else
        while ESX == nil do
            TriggerEvent(Config_Shared.ESX_Event, function(obj) ESX = obj end)
            Wait(100)
        end
    end
end)

local function notify(msg)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(msg)
    else
        TriggerEvent('chat:addMessage', { color = { 232, 163, 61 }, args = { ReportLan.prefix, msg } })
    end
end

local function send(action, payload)
    payload = payload or {}
    payload._uniqueReport = true
    payload.ureport = action
    SendNUIMessage(payload)
end

local function setFocus(on, panel)
    SetNuiFocus(on, on)
    nuiFocusActive = on
    activePanel = on and panel or nil
end

-- ============================================================== Esc ===
-- بستن با Esc قبلاً فقط سمت جاوااسکریپت (ui/report/js/script.js) بود:
-- یک document.addEventListener('keydown', ...) که خودِ آیفریمِ ریپورت باید
-- فوکوس کیبورد رو داشته باشه تا اون رویداد رو بگیره. پنل ریپورت اما داخل
-- یک آیفریمِ تو دلِ آیفریمِ دیگه‌ست (html/index.html میزبانِ سه پنله)، و
-- روتینگِ فوکوس بین اونا با postMessage/contentWindow.focus() انجام میشه -
-- شکننده و به ترتیب اجرا/تایمینگِ پیام‌ها حساسه. نتیجه همون چیزی بود که تو
-- اسکرین‌شات دیده شد: پنل باز می‌مونه و Esc هیچ اثری نداره.
--
-- درمان: کاملاً مستقل از DOM/فوکوسِ آیفریم، مستقیم از روی کنترل نیتیوِ
-- بازی (200 = INPUT_FRONTEND_PAUSE) گوش میدیم. این همیشه کار میکنه چون به
-- هیچ چیزی تو NUI وابسته نیست، و همزمان کنترل رو دیزیبل میکنیم تا Esc باعث
-- باز شدن منوی pause بازی هم نشه.
CreateThread(function()
    while true do
        Wait(0)
        if nuiFocusActive then
            DisableControlAction(0, 200, true)   -- INPUT_FRONTEND_PAUSE
            if IsDisabledControlJustPressed(0, 200) then
                send('hideAll')
                setFocus(false)
            end
        else
            Wait(250)   -- وقتی پنلی باز نیست هر فریم چک نکن
        end
    end
end)

-- ======================================================== باز/بسته کردن ===

local function openUserPanel()
    send('showUserPanel', {
        config = {
            categories = Config_Shared.Categories,
            priorities = Config_Shared.Priorities,
            limits     = Config_Shared.Limits,
            server     = Config_Shared.ServerName,
            site       = Config_Shared.ServerSite,
        }
    })
    setFocus(true, 'user')
end

local function openAdminPanel()
    send('showAdminPanel', {
        config = {
            categories = Config_Shared.Categories,
            priorities = Config_Shared.Priorities,
            limits     = Config_Shared.Limits,
            server     = Config_Shared.ServerName,
            site       = Config_Shared.ServerSite,
            canned     = Config_Shared.CannedReplies,
        }
    })
    setFocus(true, 'admin')
end

local function closePanels()
    send('hideAll')
    setFocus(false)
end

RegisterCommand(Client_Config.CommandForUser, function()
    local now = GetGameTimer()
    if now - lastUserCmd < Client_Config.commandCooldown then return end
    lastUserCmd = now

    if nuiFocusActive and activePanel == 'user' then
        closePanels()
    else
        openUserPanel()
    end
end, false)

RegisterCommand(Client_Config.CommandForAdmin, function()
    local now = GetGameTimer()
    if now - lastAdminCmd < Client_Config.commandCooldown then return end
    lastAdminCmd = now

    if nuiFocusActive and activePanel == 'admin' then
        return closePanels()
    end

    if not ESX then return notify(ReportLan.esxNotReady) end
    ESX.TriggerServerCallback('Unique_Report:getAccess', function(has)
        if not has then return notify(ReportLan.notAccess) end
        openAdminPanel()
    end, Config_Shared.accessToAdminCommand)
end, false)

if Client_Config.KeyForUser ~= "" then
    RegisterKeyMapping(Client_Config.CommandForUser, 'باز کردن ریپورت', 'keyboard', Client_Config.KeyForUser)
end
if Client_Config.KeyForAdmin ~= "" then
    RegisterKeyMapping(Client_Config.CommandForAdmin, 'پنل ریپورت ادمین', 'keyboard', Client_Config.KeyForAdmin)
end

-- ==================================================== NUI Callbacks ===
-- قانون: هر شاخه باید cb(...) رو صدا بزنه.

local function cbWrap(cb)
    local done = false
    return function(result)
        if done then return end
        done = true
        cb(result == nil and { ok = true } or result)
    end
end

RegisterNUICallback('create', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, msg = ReportLan.esxNotReady }) end
    ESX.TriggerServerCallback('Unique_Report:create', cb, {
        title    = data.title,
        info     = data.info,
        category = data.category,
        targetId = data.targetId,   -- گسترش: بازیکنِ گزارش‌شده (اختیاری)
    })
end)

RegisterNUICallback('getMine', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:getMine', cb)
end)

RegisterNUICallback('getAll', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:getAll', cb, { status = data and data.status })
end)

RegisterNUICallback('getActive', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:getActive', cb)
end)

RegisterNUICallback('topAdmins', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:topAdmins', cb)
end)

RegisterNUICallback('stats', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:stats', cb)
end)

RegisterNUICallback('accept', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:accept', cb, data.id)
end)

RegisterNUICallback('close', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:close', cb, data.id)
end)

RegisterNUICallback('archive', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:archive', cb, data.id)
end)

RegisterNUICallback('delete', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:delete', cb, data.id)
end)

RegisterNUICallback('chat', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:chat', cb, data.id, data.text)
end)

RegisterNUICallback('rate', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:rate', cb, data.id, data.rating)
    setFocus(false)
end)

-- =============================================================== گسترش‌ها ===

RegisterNUICallback('setNote', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:setNote', cb, data.id, data.note)
end)

RegisterNUICallback('voiceCheck', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:voiceCheck', cb, data.pid)
end)

RegisterNUICallback('banPresets', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    -- همون کال‌بکِ موجودِ investigation.lua - چیزِ جدیدی سمت سرور لازم نداره
    ESX.TriggerServerCallback('Unique_AdminPanel:GetBanPresets', function(presets)
        cb({ r = true, data = presets or {} })
    end)
end)

RegisterNUICallback('banClose', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Report:banClose', cb, data.id, data.presetId)
end)

RegisterNUICallback('action', function(data, rawCb)
    local cb = cbWrap(rawCb)
    local allowed = {
        revive = true, teleport = true, bring = true,
        givecar = true, spect = true, freeze = true, ['return'] = true,
    }
    if allowed[data.kind] then
        if data.kind == 'teleport' or data.kind == 'spect' then
            -- موقعیت فعلی رو ذخیره کن تا بشه برگشت
            returnCoords = GetEntityCoords(PlayerPedId())
        end
        if data.kind == 'spect' then closePanels() end
        TriggerServerEvent('Unique_Report:action', data.kind, data.id)
    end
    cb({ ok = true })
end)

RegisterNUICallback('notify', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if data and data.msg then notify(data.msg) end
    cb({ ok = true })
end)

RegisterNUICallback('exit', function(_, rawCb)
    local cb = cbWrap(rawCb)
    -- فقط اگه خودِ این پنل فوکوس رو داره. بدون این چک، Escape ای که برای
    -- پنل دیگه‌ای (منوی ادمین / AC) زده شده، فوکوس اون رو هم میکشت و اون
    -- پنل روی صفحه گیر میکرد.
    if nuiFocusActive then setFocus(false) end
    cb({ ok = true })
end)

RegisterNUICallback('copy', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if data and data.text then notify("کپی شد: " .. data.text) end
    cb({ ok = true })
end)

-- ==================================================== ایونت‌های سرور ===

RegisterNetEvent('Unique_Report:refreshList')
AddEventHandler('Unique_Report:refreshList', function()
    send('refreshList')
end)

RegisterNetEvent('Unique_Report:refreshChat')
AddEventHandler('Unique_Report:refreshChat', function(which)
    send('refreshChat', { side = which })
end)

RegisterNetEvent('Unique_Report:ping')
AddEventHandler('Unique_Report:ping', function(kind)
    send('ping', { kind = kind })
end)

RegisterNetEvent('Unique_Report:askRating')
AddEventHandler('Unique_Report:askRating', function(reportId, adminName)
    send('askRating', { id = reportId, adminName = adminName })
    setFocus(true, 'rating')
end)

RegisterNetEvent('Unique_Report:closedCleanup')
AddEventHandler('Unique_Report:closedCleanup', function()
    if Client_Config.DeleteAdminCarOnClose and adminCarHandle and DoesEntityExist(adminCarHandle) then
        DeleteEntity(adminCarHandle)
        adminCarHandle = nil
    end
    send('activeClosed')
end)

RegisterNetEvent('Unique_Report:doRevive')
AddEventHandler('Unique_Report:doRevive', function()
    local ped = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), GetPedModel(ped), true, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    ClearPedTasksImmediately(ped)
    SetPlayerInvincible(PlayerId(), false)
end)

RegisterNetEvent('Unique_Report:teleportTo')
AddEventHandler('Unique_Report:teleportTo', function(coords, isAdmin)
    if isAdmin then returnCoords = GetEntityCoords(PlayerPedId()) end

    local ped = PlayerPedId()
    DoScreenFadeOut(300)
    Wait(350)
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0, false, false, false, false)

    -- منتظر لود شدن زمین بمون تا زیر مپ نیفته
    local t = GetGameTimer()
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() - t < 5000 do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(10)
    end
    local ok, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 10.0, false)
    if ok then SetEntityCoords(ped, coords.x, coords.y, ground + 1.0, false, false, false, false) end

    DoScreenFadeIn(400)
end)

RegisterNetEvent('Unique_Report:returnBack')
AddEventHandler('Unique_Report:returnBack', function()
    if not returnCoords then return notify(ReportLan.noReturnPoint) end
    local ped = PlayerPedId()
    DoScreenFadeOut(300); Wait(350)
    SetEntityCoords(ped, returnCoords.x, returnCoords.y, returnCoords.z, false, false, false, false)
    DoScreenFadeIn(400)
    returnCoords = nil
    notify(ReportLan.AdminReturn)
end)

RegisterNetEvent('Unique_Report:toggleFreeze')
AddEventHandler('Unique_Report:toggleFreeze', function()
    isFrozen = not isFrozen
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, isFrozen)
    SetEntityInvincible(ped, isFrozen)
    notify(isFrozen and ReportLan.frozen or ReportLan.unfrozen)
end)

-- ============================================ اسپاون ماشین ادمین ===

RegisterNetEvent('Unique_Report:spawnAdminCar')
AddEventHandler('Unique_Report:spawnAdminCar', function()
    local model = Client_Config.AdminCar
    local hash  = (type(model) == 'string') and GetHashKey(model) or model

    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        return notify("مدل ماشین ادمین معتبر نیست: " .. tostring(model))
    end

    if adminCarHandle and DoesEntityExist(adminCarHandle) then
        DeleteEntity(adminCarHandle)
        adminCarHandle = nil
    end

    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) do
        if GetGameTimer() - t > 10000 then return notify("بارگذاری ماشین ناموفق بود.") end
        Wait(10)
    end

    local ped     = PlayerPedId()
    local coords  = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    adminCarHandle = veh

    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, "OFF")
    SetEntityAsMissionEntity(veh, true, false)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(veh), true)
    SetModelAsNoLongerNeeded(hash)

    TaskWarpPedIntoVehicle(ped, veh, -1)

    if Client_Config.AddKeyAfterSpwanCar and Client_Config.AddKeyAfterSpwanCar ~= "" then
        TriggerServerEvent(Client_Config.AddKeyAfterSpwanCar, GetVehicleNumberPlateText(veh))
    end
end)

-- ============================================================ پاکسازی ===

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if nuiFocusActive then SetNuiFocus(false, false) end
    if adminCarHandle and DoesEntityExist(adminCarHandle) then DeleteEntity(adminCarHandle) end
    if isFrozen then FreezeEntityPosition(PlayerPedId(), false) end
end)
