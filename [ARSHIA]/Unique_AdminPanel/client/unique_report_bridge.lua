--[[ Unique RP - Unique-style report bridge | client/unique_report_bridge.lua
    Drives the report UI that lives in BASE/chat (events chat:*), talks to
    server/unique_report_bridge.lua. Commands:
      /report   - player: category form (or the pending rating first)
      /areport  - admin:  toggle the Unique queue panel (replaces the old NUI panel; F12 / menu button use it too)
]]

local CC = Client_Config or {}   -- کانفیگ کلاینت (بعد از لود شدنش مقدار میگیره؛ با fallback امن)
ESX = ESX or nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local lastCmd = 0
local function throttled()
    if GetGameTimer() - lastCmd < ((Client_Config or CC).commandCooldown or 1500) then return true end
    lastCmd = GetGameTimer()
    return false
end

local function uniqueCategories()
    local list = {}
    for _, c in ipairs(Config_Shared.Categories) do
        if c.unique then list[#list + 1] = { key = c.uniqueKey, label = c.label } end
    end
    return list
end

-- ------------------------------------------------------------------ player ---
RegisterCommand('report', function()
    if throttled() or not ESX then return end
    ESX.TriggerServerCallback('UniqueRep:checkPendingRating', function(res)
        if res and res.hasPending then
            TriggerEvent('chat:openRatingDirect', res.adminName, res.reportId)
        else
            TriggerEvent('chat:openReportSubmit', uniqueCategories())
        end
    end)
end, false)

AddEventHandler('chat:reportSubmitted', function(message, category)
    TriggerServerEvent('UniqueRep:submit', message, category)
end)

AddEventHandler('chat:ratingSubmitted', function(reportId, rating)
    TriggerServerEvent('UniqueRep:rate', reportId, rating)
end)

AddEventHandler('chat:ticketCancel', function()
    TriggerServerEvent('UniqueRep:cancel')
end)

RegisterNetEvent('UniqueRep:status')
AddEventHandler('UniqueRep:status', function(d)
    TriggerEvent('chat:ticketStatusUpdate', d.status, d.adminName, d.cat, d.message, d.time, nil, d.reportId)
    TriggerEvent('chat:setTicketCancelAllowed', d.status == 'open')   -- only while still waiting in the queue
end)

RegisterNetEvent('UniqueRep:hide')
AddEventHandler('UniqueRep:hide', function()
    TriggerEvent('chat:ticketHide')
end)

-- restore the indicator after joining / restarting this resource
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function() Wait(3000); TriggerServerEvent('UniqueRep:sync') end)
CreateThread(function()
    Wait(6000)
    if ESX and ESX.GetPlayerData and ESX.GetPlayerData().job then TriggerServerEvent('UniqueRep:sync') end
end)

RegisterNetEvent('UniqueRep:startCall')
AddEventHandler('UniqueRep:startCall', function(number)
    if GetResourceState('Unique_Phone') ~= 'started' then
        if ESX then ESX.ShowNotification('~r~گوشی در دسترس نیست.') end
        return
    end
    local ok = pcall(function() exports['Unique_Phone']:StartCall(tostring(number)) end)
    if not ok and ESX then ESX.ShowNotification('~r~شروع تماس ناموفق بود.') end
end)

-- ------------------------------------------------------------------- admin ---
local panelOpen = false

local function fetch(cb)
    ESX.TriggerServerCallback('UniqueRep:getReports', function(res)
        if res and res.r then cb(res.reports or {}, res.closed or {}) end
    end)
end

RegisterCommand((Client_Config or CC).CommandForAdmin or 'areport', function()
    if throttled() or not ESX then return end
    if panelOpen then
        panelOpen = false
        return TriggerEvent('chat:rpHidePanel')
    end
    ESX.TriggerServerCallback('UniqueRep:getReports', function(res)
        if not (res and res.r) then return end            -- no admin access: silently nothing
        panelOpen = true
        TriggerEvent('chat:rpShowPanel', res.reports or {}, res.closed or {})
        CreateThread(function()
            while panelOpen do
                Wait(3000)
                if panelOpen then
                    fetch(function(r, c) TriggerEvent('chat:rpUpdatePanel', r, c) end)
                end
            end
        end)
    end)
end, false)

AddEventHandler('chat:rpActionFromNUI', function(action, id)
    if action == 'tickets' then return OpenTicketPanel() end   -- admin ticket section (client/ticket_client.lua)
    id = tonumber(id)
    if not id then return end
    if action == 'spectate' then
        TriggerServerEvent('UniqueRep:spectate', id)
    elseif action == 'acall' then
        TriggerServerEvent('UniqueRep:accept', id)
    end
end)

if ((Client_Config or CC).KeyForAdmin or '') ~= '' then
    RegisterKeyMapping((Client_Config or CC).CommandForAdmin or 'areport', 'پنل ریپورت ادمین', 'keyboard', (Client_Config or CC).KeyForAdmin)
end
