-- Chat (Sun-style UI) | adapted to this server's essentialmode/ESX

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local active = true
local chatInputActive = false
local chatInputActivating = false
local muted = false
local AntiSpam = 0
local panelOpen = false   -- true while a report/ticket/rating panel owns NUI focus

-- ------------------------------------------------------------------
-- Tab routing
-- Tabs in the UI: live | chat (System) | helper | gang | job | event | staff
-- A resource can pick the tab explicitly (message.type / message.category,
-- or the 2nd arg of chat:addMessage). Messages without one fall back to this
-- keyword detection (kept from the old chat) and otherwise land in Live.
-- ------------------------------------------------------------------
local channelKeywords = {
    { channel = 'chat',   keywords = { 'system' } },
    { channel = 'event',  keywords = { 'event' } },
    { channel = 'job',    keywords = { '[f]', 'faction', 'job', 'duty', 'commissioner' } },
    { channel = 'gang',   keywords = { '[g]', 'gang' } },
    { channel = 'staff',  keywords = { 'staff', 'admin', 'report' } },
}

local function detectChannel(args)
    if not args then return nil end
    local parts = {}
    for _, a in ipairs(args) do parts[#parts + 1] = tostring(a) end
    local text = table.concat(parts, ' '):lower()
    for _, entry in ipairs(channelKeywords) do
        for _, kw in ipairs(entry.keywords) do
            if text:find(kw, 1, true) then
                return entry.channel
            end
        end
    end
    return nil
end

local function applyRouting(message)
    if not message.category and not message.type then
        local ch = detectChannel(message.args)
        if ch then message.category = ch end
    end
    return message
end

function setChatDecor(state)
    DecorSetInt(PlayerPedId(), 'typing', state)
end

local function OpenChatInput()
    if not chatInputActive then
        chatInputActive = true
        chatInputActivating = true
        SendNUIMessage({ type = 'ON_OPEN' })
    end

    if chatInputActivating then
        SetNuiFocus(true, true)
        chatInputActivating = false
        setChatDecor(true)
    end
end

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent('_chat:messageEnteredOps')

-- chatMessage(author, color, text [, printB|category [, category]])
AddEventHandler('chatMessage', function(author, color, text, printB, category)
    if not active then return end

    local finalCategory, finalColor, finalText, finalAuthor
    local shouldPrint = false

    if type(color) ~= 'table' and text == nil then
        finalCategory = color
        finalText = author
        finalAuthor = ''
        finalColor = nil
    elseif type(printB) == 'string' then
        finalCategory = printB
        finalText = text
        finalAuthor = author
        finalColor = color
    elseif type(printB) == 'boolean' then
        finalCategory = category
        finalText = text
        finalAuthor = author
        finalColor = color
        shouldPrint = printB
    else
        finalText = text or author
        finalAuthor = text and author or ''
        finalColor = type(color) == 'table' and color or nil
    end

    local args = { finalText }
    if finalAuthor ~= '' and finalAuthor ~= nil then
        table.insert(args, 1, finalAuthor)
    end

    if shouldPrint then
        print(finalAuthor, finalColor, finalText)
    end

    local message = { color = finalColor, multiline = true, args = args }
    if type(finalCategory) == 'string' then
        message.category = finalCategory
        message.type = finalCategory
    end

    SendNUIMessage({ type = 'ON_MESSAGE', message = applyRouting(message) })
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = { color = { 0, 255, 0 }, multiline = true, args = { msg } }
    })
end)

AddEventHandler('chat:addMessage', function(message, messageType)
    if not active then return end
    if messageType then message.type = messageType end
    SendNUIMessage({ type = 'ON_MESSAGE', message = applyRouting(message) })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
    TriggerEvent('chat:removeSuggestion', name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = { name = name, help = help, params = params or nil }
    })
end)

AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({ type = 'ON_SUGGESTION_REMOVE', name = name })
end)

AddEventHandler('chat:addTemplate', function(id, html)
    if not active then return end
    SendNUIMessage({ type = 'ON_TEMPLATE_ADD', template = { id = id, html = html } })
end)

AddEventHandler('chat:clear', function()
    SendNUIMessage({ type = 'ON_CLEAR' })
end)

RegisterNetEvent('chat:setMuteStatus')
AddEventHandler('chat:setMuteStatus', function(status)
    muted = status
end)

local function muteWarning()
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { '[SYSTEM]', '^0Shoma nemitavanid hengami ke ^1mute ^0hastid chat konid!' }
    })
end

local mutedBlocked = { '/ooc', '/b', '/s', '/mp', '/me', '/do' }
local function isMutedBlocked(msg)
    for _, c in ipairs(mutedBlocked) do
        if msg:sub(1, #c) == c then return true end
    end
    return false
end

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false, false)
    setChatDecor(false)

    if not data.canceled then
        local id = PlayerId()
        local r, g, b = 0, 0x99, 255
        -- strip colour codes so players can't colourise their own text
        data.message = data.message:gsub('%^', ''):gsub('~', '')

        local pd = ESX and ESX.GetPlayerData() or nil
        local isWeazel = pd and pd.job and pd.job.name == 'weazel'
        if data.message:sub(2):len() > 300 and not isWeazel then
            cb('ok')
            return
        end

        TriggerServerEvent('chat:logMessage', data.message)

        if data.message:sub(1, 1) == '/' then
            if data.message:sub(2) == 'chatsetting' then
                ExecuteCommand('chatsetting')
                cb('ok')
                return
            end

            if (GetGameTimer() - AntiSpam) > 2000 then
                AntiSpam = GetGameTimer()
                if not muted then
                    ExecuteCommand(data.message:sub(2))
                    TriggerServerEvent('_chat:messageEnteredOps', GetPlayerName(id), { r, g, b }, data.message)
                elseif isMutedBlocked(data.message) then
                    muteWarning()
                else
                    ExecuteCommand(data.message:sub(2))
                end
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { '[SYSTEM]', '^1Lotfan Spam Nakonid!' }
                })
            end
        else
            if not muted then
                TriggerServerEvent('_chat:messageEnteredOps', GetPlayerName(id), { r, g, b }, data.message)
            else
                muteWarning()
            end
        end
    end

    cb('ok')
end)

-- push the player's current role flags to the UI (used on load + on every change)
local function pushRoleState(xPlayer)
    if not xPlayer then return end
    local permLevel = xPlayer.permission_level or 0
    SendNUIMessage({ type = 'SET_ADMIN', isAdmin = permLevel >= 1 })
    SendNUIMessage({ type = 'SET_HELPER', isHelper = xPlayer.group == 'helper' })
    SendNUIMessage({
        type = 'SET_GANG_STATUS',
        hasGang = (xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang') and true or false
    })
    SendNUIMessage({
        type = 'SET_JOB_STATUS',
        hasJob = (xPlayer.job and xPlayer.job.name and xPlayer.job.name ~= 'nojob') and true or false
    })
end

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init')
    -- covers restarting this resource while players are already in game
    Citizen.CreateThread(function()
        local tries = 0
        while ESX == nil and tries < 50 do Citizen.Wait(100); tries = tries + 1 end
        if ESX then
            local pd = ESX.GetPlayerData()
            if pd and pd.job then pushRoleState(pd) end
        end
    end)
    cb('ok')
end)

-- menu colours / positions chosen in Settings -> Menus (consumed by the menu resources)
RegisterNUICallback('saveMenuSettings', function(data, cb)
    TriggerEvent('sun_menu:settings', data)
    if data.skill then
        pcall(function()
            exports['sun-ui']:sendMessage({ id = 'skill', event = 'settings', colors = data.skill })
        end)
    end
    cb('ok')
end)

AddEventHandler('onKeyDown', function(key)
    if ESX and ESX.GetPlayerData().InPhone then return end
    if panelOpen then return end
    if key == 't' then
        OpenChatInput()
    end
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false, false)
end)

RegisterCommand('togglechat2', function()
    local pd = ESX.GetPlayerData()
    if pd.permission_level >= 9 or (pd.job and pd.job.name == 'weazel') then
        active = not active
        lib.notify({ position = 'center-right', title = '', description = 'chat ' .. (active and 'active' or 'deactive'), type = 'info', duration = 3000 })
    end
end, false)

RegisterCommand('chatsetting', function()
    OpenChatInput()
    SendNUIMessage({ type = 'OPEN_SETTINGS' })
end, false)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerEvent('chat:addSuggestion', '/chatsetting', 'Baz kardane panele tanzimate chat (font size, width, height, filters)')
end)

-- ------------------------------------------------------------------
-- Role / state updates -> tab visibility
-- ------------------------------------------------------------------
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    pushRoleState(xPlayer)
end)

RegisterNetEvent('esx:setPermission')
AddEventHandler('esx:setPermission', function(permission_level)
    SendNUIMessage({ type = 'SET_ADMIN', isAdmin = (permission_level or 0) >= 1 })
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    SendNUIMessage({
        type = 'SET_GANG_STATUS',
        hasGang = (gang and gang.name and gang.name ~= 'nogang') and true or false
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    SendNUIMessage({
        type = 'SET_JOB_STATUS',
        hasJob = (job and job.name and job.name ~= 'nojob') and true or false
    })
end)

-- admin PM overlay -> Staff tab + sound (fire from any admin resource)
RegisterNetEvent('chat:showAdminPM')
AddEventHandler('chat:showAdminPM', function(from, message)
    SendNUIMessage({ type = 'SHOW_ADMIN_PM', from = from, message = message })
end)

-- ==================================================================
-- Report / Ticket panels (Sun-style UI)
-- The server side lives in Unique_AdminPanel (client/sun_report_bridge.lua
-- + server/sun_report_bridge.lua). This file only drives the NUI and
-- re-emits plain events the bridge listens to.
-- ==================================================================
local function resetChatState()
    chatInputActive = false
    chatInputActivating = false
    panelOpen = false
    setChatDecor(false)
    SendNUIMessage({ type = 'FORCE_CLOSE_CHAT' })
end

-- admin queue panel
AddEventHandler('chat:rpShowPanel', function(reports, closedReports)
    SendNUIMessage({ type = 'SHOW_REPORT_PANEL', reports = reports or {}, closedReports = closedReports or {} })
end)
AddEventHandler('chat:rpUpdatePanel', function(reports, closedReports)
    SendNUIMessage({ type = 'UPDATE_REPORT_PANEL', reports = reports or {}, closedReports = closedReports or {} })
end)
AddEventHandler('chat:rpHidePanel', function()
    SendNUIMessage({ type = 'HIDE_REPORT_PANEL' })
end)
RegisterNUICallback('reportPanelAction', function(data, cb)
    TriggerEvent('chat:rpActionFromNUI', data.action, data.id)
    cb('ok')
end)

-- player: submit form
AddEventHandler('chat:openReportSubmit', function(categories)
    resetChatState()
    panelOpen = true
    SendNUIMessage({ type = 'OPEN_REPORT_SUBMIT', categories = categories })
    SetNuiFocus(true, true)
end)
RegisterNUICallback('reportSubmitAction', function(data, cb)
    resetChatState()
    SetNuiFocus(false, false)
    if data.action == 'submit' then
        TriggerEvent('chat:reportSubmitted', data.message, data.category)
    end
    cb('ok')
end)

-- player: ticket indicator / detail / rating
AddEventHandler('chat:ticketStatusUpdate', function(status, adminName, cat, message, time, _, reportId)
    SendNUIMessage({
        type = 'TICKET_STATUS_UPDATE', status = status, adminName = adminName,
        cat = cat, message = message, time = time, reportId = reportId
    })
end)
AddEventHandler('chat:ticketHide', function()
    SendNUIMessage({ type = 'TICKET_HIDE' })
end)
AddEventHandler('chat:setTicketCancelAllowed', function(allowed)
    SendNUIMessage({ type = 'SET_TICKET_CANCEL_ALLOWED', allowed = allowed and true or false })
end)
AddEventHandler('chat:openRatingDirect', function(adminName, reportId)
    resetChatState()
    panelOpen = true
    SendNUIMessage({ type = 'OPEN_RATING_DIRECT', adminName = adminName, reportId = reportId })
    SetNuiFocus(true, true)
end)
RegisterNUICallback('ticketAction', function(data, cb)
    if data.action == 'cancel' then
        resetChatState()
        SetNuiFocus(false, false)
        TriggerEvent('chat:ticketCancel')
    elseif data.action == 'openDetail' then
        resetChatState()
        panelOpen = true
        SetNuiFocus(true, true)
    elseif data.action == 'closeDetail' then
        resetChatState()
        SetNuiFocus(false, false)
    end
    cb('ok')
end)
RegisterNUICallback('ticketRatingAction', function(data, cb)
    resetChatState()
    SetNuiFocus(false, false)
    if data.action == 'submit' then
        TriggerEvent('chat:ratingSubmitted', data.reportId, data.rating, data.comment)
    elseif data.action == 'skip' then
        TriggerEvent('chat:ratingSkipped', data.reportId)
    end
    cb('ok')
end)
