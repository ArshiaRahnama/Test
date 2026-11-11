--[[ Unique RP - Sun-style report bridge | client/sun_report_bridge.lua
    Drives the report UI that lives in BASE/chat (events chat:*), talks to
    server/sun_report_bridge.lua. Commands:
      /report   - player: category form (or the pending rating first)
      /areport  - admin:  toggle the Sun queue panel (replaces the old NUI panel; F12 / menu button use it too)
]]

ESX = ESX or nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local lastCmd = 0
local function throttled()
    if GetGameTimer() - lastCmd < (Client_Config.commandCooldown or 1500) then return true end
    lastCmd = GetGameTimer()
    return false
end

local function sunCategories()
    local list = {}
    for _, c in ipairs(Config_Shared.Categories) do
        if c.sun then list[#list + 1] = { key = c.sunKey, label = c.label } end
    end
    return list
end

-- ------------------------------------------------------------------ player ---
RegisterCommand('report', function()
    if throttled() or not ESX then return end
    ESX.TriggerServerCallback('SunRep:checkPendingRating', function(res)
        if res and res.hasPending then
            TriggerEvent('chat:openRatingDirect', res.adminName, res.reportId)
        else
            TriggerEvent('chat:openReportSubmit', sunCategories())
        end
    end)
end, false)

AddEventHandler('chat:reportSubmitted', function(message, category)
    TriggerServerEvent('SunRep:submit', message, category)
end)

AddEventHandler('chat:ratingSubmitted', function(reportId, rating)
    TriggerServerEvent('SunRep:rate', reportId, rating)
end)

AddEventHandler('chat:ticketCancel', function()
    TriggerServerEvent('SunRep:cancel')
end)

RegisterNetEvent('SunRep:status')
AddEventHandler('SunRep:status', function(d)
    TriggerEvent('chat:ticketStatusUpdate', d.status, d.adminName, d.cat, d.message, d.time, nil, d.reportId)
    TriggerEvent('chat:setTicketCancelAllowed', d.status == 'open')   -- only while still waiting in the queue
end)

RegisterNetEvent('SunRep:hide')
AddEventHandler('SunRep:hide', function()
    TriggerEvent('chat:ticketHide')
end)

-- restore the indicator after joining / restarting this resource
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function() Wait(3000); TriggerServerEvent('SunRep:sync') end)
CreateThread(function()
    Wait(6000)
    if ESX and ESX.GetPlayerData and ESX.GetPlayerData().job then TriggerServerEvent('SunRep:sync') end
end)

-- ------------------------------------------------------------------- admin ---
local panelOpen = false

local function fetch(cb)
    ESX.TriggerServerCallback('SunRep:getReports', function(res)
        if res and res.r then cb(res.reports or {}, res.closed or {}) end
    end)
end

RegisterCommand(Client_Config.CommandForAdmin or 'areport', function()
    if throttled() or not ESX then return end
    if panelOpen then
        panelOpen = false
        return TriggerEvent('chat:rpHidePanel')
    end
    ESX.TriggerServerCallback('SunRep:getReports', function(res)
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
    id = tonumber(id)
    if not id then return end
    if action == 'spectate' then
        TriggerServerEvent('SunRep:spectate', id)
    elseif action == 'acall' then
        TriggerServerEvent('SunRep:accept', id)
    end
end)

if (Client_Config.KeyForAdmin or '') ~= '' then
    RegisterKeyMapping(Client_Config.CommandForAdmin or 'areport', 'پنل ریپورت ادمین', 'keyboard', Client_Config.KeyForAdmin)
end
