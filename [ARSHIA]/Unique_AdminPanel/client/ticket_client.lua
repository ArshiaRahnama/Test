--[[ ===========================================================================
    Unique RP - Ticket System | client/ticket_client.lua
    arshiahub.ir

    Mirrors client/report_main.lua's conventions exactly:
      - lazy/local ESX, never touches the resource-wide global
      - send()/setFocus() helpers tag every NUI message with _uniqueTicket so
        html/index.html's shell can route focus to the right iframe without
        colliding with the AdminMenu / AC / Report frames
      - every RegisterNUICallback always calls cb(), and cb() is wrapped so a
        second accidental call can't happen (same bug class report_main.lua's
        header comment calls out and fixes)
=========================================================================== ]]

local ESX = nil
CreateThread(function()
    if Config_Shared.ESX_Version == 2 then
        while ESX == nil do
            local ok, obj = pcall(function() return exports[Config_Shared.ESX_Export]:getSharedObject() end)
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

local nuiFocusActive = false
local isAdminPanel   = false

local function send(action, payload)
    payload = payload or {}
    payload._uniqueTicket = true
    payload.uticket = action
    SendNUIMessage(payload)
end

local function setFocus(on)
    SetNuiFocus(on, on)
    nuiFocusActive = on
end

local function notify(msg)
    if UapToast then UapToast('admin', 'تیکت', { msg }) end
end

local function openPanel(asAdmin)
    isAdminPanel = asAdmin
    send('open', { admin = asAdmin })
    setFocus(true)
end

local function closePanel()
    send('close')
    setFocus(false)
end

-- ------------------------------------------------------------- دستورات ---
RegisterCommand(Ticket_Config.CommandForUser, function()
    openPanel(false)
end, false)

RegisterCommand(Ticket_Config.CommandForAdmin, function()
    ESX.TriggerServerCallback('Unique_AdminPanel:GetMyPermissionLevel', function(level)
        if (level or 0) < Ticket_Config.MinPermissionLevel then
            return notify('شما دسترسی مدیریت تیکت را ندارید.')
        end
        openPanel(true)
    end)
end, false)

if Ticket_Config.KeyForUser ~= '' then
    RegisterKeyMapping(Ticket_Config.CommandForUser, 'باز کردن تیکت‌های من', 'keyboard', Ticket_Config.KeyForUser)
end
if Ticket_Config.KeyForAdmin ~= '' then
    RegisterKeyMapping(Ticket_Config.CommandForAdmin, 'پنل مدیریت تیکت‌ها', 'keyboard', Ticket_Config.KeyForAdmin)
end

-- Called from client/menuv_ui.lua's "🎫 Tickets" button (F4 menu) - same
-- entry point as the command, so permissions stay in exactly one place.
function OpenTicketPanel() ExecuteCommand(Ticket_Config.CommandForAdmin) end

-- ---------------------------------------------------------- live pushes ---
-- server/ticket_main.lua's broadcastTicketUpdate() sends this to anyone
-- viewing/assigned to a ticket so the thread/participant list updates
-- without the user needing to manually refresh.
RegisterNetEvent('Unique_Ticket:push', function(ticketId, detail)
    send('live', { id = ticketId, detail = detail })
end)

-- ============================================================ callbacks ===

local function cbWrap(cb)
    local done = false
    return function(result)
        if done then return end
        done = true
        cb(result == nil and { r = true } or result)
    end
end

RegisterNUICallback('create', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:create', cb, data)
end)

RegisterNUICallback('createFromReport', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:createFromReport', cb, data.reportId)
end)

RegisterNUICallback('listOpenReports', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, data = {} }) end
    ESX.TriggerServerCallback('Unique_Ticket:listOpenReports', cb)
end)

RegisterNUICallback('getMine', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, data = {} }) end
    ESX.TriggerServerCallback('Unique_Ticket:getMine', cb)
end)

RegisterNUICallback('getAll', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, data = {} }) end
    ESX.TriggerServerCallback('Unique_Ticket:getAll', cb, data)
end)

RegisterNUICallback('getDetail', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:getDetail', cb, data.id)
end)

RegisterNUICallback('sendMessage', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:sendMessage', cb, data.id, data.text)
end)

RegisterNUICallback('setStatus', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:setStatus', cb, data.id, data.status)
end)

RegisterNUICallback('setPriority', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:setPriority', cb, data.id, data.priority)
end)

RegisterNUICallback('getLinkedReport', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:getLinkedReport', cb, data.reportId)
end)

RegisterNUICallback('searchPlayer', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, data = {} }) end
    ESX.TriggerServerCallback('Unique_Ticket:searchPlayer', cb, data.query)
end)

RegisterNUICallback('addParticipant', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:addParticipant', cb, data.id, data.identifier, data.name)
end)

RegisterNUICallback('removeParticipant', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:removeParticipant', cb, data.id, data.identifier)
end)

RegisterNUICallback('getOnlineAdmins', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false, data = {} }) end
    ESX.TriggerServerCallback('Unique_Ticket:getOnlineAdmins', cb)
end)

RegisterNUICallback('assignAdmin', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:assignAdmin', cb, data.id, data.identifier, data.name)
end)

RegisterNUICallback('unassignAdmin', function(data, rawCb)
    local cb = cbWrap(rawCb)
    if not ESX then return cb({ r = false }) end
    ESX.TriggerServerCallback('Unique_Ticket:unassignAdmin', cb, data.id, data.identifier)
end)

RegisterNUICallback('exit', function(_, rawCb)
    local cb = cbWrap(rawCb)
    if nuiFocusActive then setFocus(false) end
    cb({ ok = true })
end)

RegisterNUICallback('config', function(_, rawCb)
    local cb = cbWrap(rawCb)
    cb({
        r = true,
        categories = Ticket_Config.Categories,
        priorities = Ticket_Config.Priorities,
        statuses   = Ticket_Config.Statuses,
        isAdmin    = isAdminPanel,
    })
end)

-- ------------------------------------------------------------------ Esc ---
-- Same pattern as client/report_main.lua's own Esc thread: read the native
-- control directly so it isn't at the mercy of DOM focus routing across
-- nested iframes.
CreateThread(function()
    while true do
        Wait(0)
        if nuiFocusActive then
            if IsControlJustReleased(0, 200) or IsControlJustReleased(0, 322) then
                closePanel()
            end
        else
            Wait(250)
        end
    end
end)
