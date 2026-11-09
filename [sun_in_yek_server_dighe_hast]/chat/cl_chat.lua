-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

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
local muted  = false
local panelOpen = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEnteredOps') 

AddEventHandler('chatMessage', function(author, color, text, printB, category)
    if not active then return end

    local finalCategory = nil
    local finalColor = nil
    local finalText = nil
    local finalAuthor = ""
    local shouldPrint = false

    if type(color) ~= 'table' and text == nil then
        finalCategory = color
        finalText = author
        finalAuthor = ""
        finalColor = nil
    elseif type(printB) == 'string' then
        finalCategory = printB
        finalText = text
        finalAuthor = author
        finalColor = color
        shouldPrint = false
    elseif type(printB) == 'boolean' then
        finalCategory = category
        finalText = text
        finalAuthor = author
        finalColor = color
        shouldPrint = printB
    else
        finalText = text or author
        finalAuthor = text and author or ""
        finalColor = type(color) == 'table' and color or nil
    end

    local args = { finalText }
    if finalAuthor ~= "" then
        table.insert(args, 1, finalAuthor)
    end

    if shouldPrint then
        print(finalAuthor, finalColor, finalText)
    end

    local message = {
        color = finalColor,
        multiline = true,
        args = args
    }

    if finalCategory then
        message.category = finalCategory
        message.type = finalCategory
    end

    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

-- AddEventHandler('__cfx_internal:serverPrint', function(msg)
--     SendNUIMessage({
--         type = 'ON_MESSAGE',
--         message = {
--             color = { 0, 0, 0 },
--             multiline = true,
--             args = { msg }
--         }
--     })
-- end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            color = { 0, 255, 0 },
            multiline = true,
            args = { msg }
        }
    })
end)

AddEventHandler('chat:addMessage', function(message, messageType)
    if not active then return end
    if messageType then
        message.type = messageType
    end
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
    TriggerEvent('chat:removeSuggestion',name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = {
            name = name,
            help = help,
            params = params or nil
        }
    })
end)

AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_REMOVE',
        name = name
    })
end)

AddEventHandler('chat:addTemplate', function(id, html)
    if not active then return end
    SendNUIMessage({
        type = 'ON_TEMPLATE_ADD',
        template = {
            id = id,
            html = html
        }
    })
end)

AddEventHandler('chat:clear', function(name)
    SendNUIMessage({
        type = 'ON_CLEAR'
    })
end)

RegisterNetEvent("chat:setMuteStatus")
AddEventHandler("chat:setMuteStatus", function(status)
    muted = status
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false, false)
    setChatDecor(false)
    if not data.canceled then
        local id = PlayerId()
        --deprecated
        local r, g, b = 0, 0x99, 255
        data.message = data.message:gsub('%^',''):gsub('~','')
        if data.message:sub(2):len() > 300 and ESX.GetPlayerData().job.name ~= 'weazel' then
            return
        end

        TriggerServerEvent('chat:logMessage', data.message)
        if data.message:sub(1, 1) == '/' then
            if not muted then
                ExecuteCommand(data.message:sub(2))
            else
                if data.message:sub(1, 4) == '/ooc' or data.message:sub(1, 2) == '/b' or data.message:sub(1, 2) == '/s' or data.message:sub(1, 3) == '/mp' or data.message:sub(1, 3) == '/me' or data.message:sub(1, 4) == '/do' then
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "^0Shoma nemitavanid hengami ke ^1mute ^0hastid chat konid!"}
                    })
                else
                    ExecuteCommand(data.message:sub(2))
                end
            end
        else

            if not muted then
                TriggerServerEvent('_chat:messageEnteredOps', GetPlayerName(id), { r, g, b }, data.message)
            else

                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "^0Shoma nemitavanid hengami ke ^1mute ^0hastid chat konid!"}
                })

            end

        end
    end

    cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('saveMenuSettings', function(data, cb)
    TriggerEvent('sun_menu:settings', data)
    if data.skill then
        pcall(function()
            exports['sun-ui']:sendMessage({id = 'skill', event = 'settings', colors = data.skill})
        end)
    end
    cb('ok')
end)

AddEventHandler("onKeyDown", function(key)
  if ESX.GetPlayerData().InPhone then return end
  if panelOpen then return end
  if key == "t" then
    if not chatInputActive then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
            type = 'ON_OPEN'
        })
    end

    if chatInputActivating then
        SetNuiFocus(true, true)
        chatInputActivating = false
        setChatDecor(true)
    end
  end
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false, false)
end)


function setChatDecor(state)
    --ESX.TriggerServerEvent('chat:typing',state)
    ESX.SetPlayerState('typing',state)
end


RegisterCommand('togglechat2', function()
    if ESX.GetPlayerData().permission_level >= 20 then
        active = not active
        local state = active and 'active' or 'deactive'
        ESX.ShowNotification('chat ' .. state)
    end
end, false)

-- /chatsetting command - Opens chat with settings panel
RegisterCommand('chatsetting', function()
    -- Open chat window
    SendNUIMessage({
        type = 'ON_OPEN'
    })
    -- Open settings panel
    SendNUIMessage({
        type = 'OPEN_SETTINGS'
    })
    SetNuiFocus(true, true)
    setChatDecor(true)
end, false)

-- Send admin/gang/job status to NUI when player loads
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    -- Add suggestion for /chatsetting (must be after player loads)
    TriggerEvent('chat:addSuggestion', '/chatsetting', 'Baz kardane panele tanzimate chat (font size, width, height, filters)')

    -- Set admin status
    local permLevel = xPlayer.permission_level or 0
    SendNUIMessage({
        type = 'SET_ADMIN',
        isAdmin = permLevel >= 1
    })

    if permLevel >= 1 then
        TriggerEvent('sundl:requestCategories')
    end

    -- Set helper status
    local isHelper = xPlayer.group == 'helper'
    SendNUIMessage({
        type = 'SET_HELPER',
        isHelper = isHelper
    })

    -- Add /hc suggestion for helpers and admins
    if isHelper or permLevel >= 1 then
        TriggerEvent('chat:addSuggestion', '/hc', 'Helper Chat - Faghat baraye helper va admin', {{name = 'message', help = 'Payam'}})
    end

    -- Set gang status
    local hasGang = xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang'
    SendNUIMessage({
        type = 'SET_GANG_STATUS',
        hasGang = hasGang
    })

    -- Set job status
    local hasJob = xPlayer.job and xPlayer.job.name and xPlayer.job.name ~= 'nojob'
    SendNUIMessage({
        type = 'SET_JOB_STATUS',
        hasJob = hasJob
    })
end)

-- Also update admin status when permission changes
RegisterNetEvent('esx:setPermission')
AddEventHandler('esx:setPermission', function(permission_level)
    SendNUIMessage({
        type = 'SET_ADMIN',
        isAdmin = permission_level >= 1
    })
end)

-- Update gang status when gang changes
RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    local hasGang = gang and gang.name and gang.name ~= 'nogang'
    SendNUIMessage({
        type = 'SET_GANG_STATUS',
        hasGang = hasGang
    })
end)

-- Update job status when job changes
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    local hasJob = job and job.name and job.name ~= 'nojob'
    SendNUIMessage({
        type = 'SET_JOB_STATUS',
        hasJob = hasJob
    })
end)

-- Admin PM Overlay - Epic notification for /pm and /ww commands
RegisterNetEvent('chat:showAdminPM')
AddEventHandler('chat:showAdminPM', function(from, message)
    SendNUIMessage({
        type = 'SHOW_ADMIN_PM',
        from = from,
        message = message
    })
end)

-- ========================================
-- Report Panel (Admin) - Display Only
-- ========================================
AddEventHandler('chat:rpShowPanel', function(reports, closedReports)
    SendNUIMessage({
        type = "SHOW_REPORT_PANEL",
        reports = reports or {},
        closedReports = closedReports or {}
    })
end)

AddEventHandler('chat:rpUpdatePanel', function(reports, closedReports)
    SendNUIMessage({
        type = "UPDATE_REPORT_PANEL",
        reports = reports or {},
        closedReports = closedReports or {}
    })
end)

AddEventHandler('chat:rpHidePanel', function()
    SendNUIMessage({ type = "HIDE_REPORT_PANEL" })
end)

RegisterNUICallback("reportPanelAction", function(data, cb)
    TriggerEvent('chat:rpActionFromNUI', data.action, data.id)
    cb('ok')
end)

-- ============================================================
-- Sun Dispatch — bridge az reportPanel
-- ============================================================
local sundCategories = {}

local function resetChatState()
    chatInputActive = false
    chatInputActivating = false
    panelOpen = false
    setChatDecor(false)
    SendNUIMessage({ type = 'FORCE_CLOSE_CHAT' })
end

local function sundOpenJoinPanel()
    resetChatState()
    panelOpen = true
    SendNUIMessage({ type = 'SUND_OPEN_JOIN_PANEL' })
    SetNuiFocus(true, true)
end

RegisterNUICallback("sundSmallMenu", function(data, cb)
    local xPlayer = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if not xPlayer or (xPlayer.permission_level or 0) < 1 then
        cb('ok'); return
    end
    local action = data and data.action
    if action == 'openJoin' then
        sundOpenJoinPanel()
    elseif action == 'joinConfirm' then
        resetChatState()
        SetNuiFocus(false, false)
        TriggerEvent('sundl:smallmenu:joinQueue', data.cats)
    elseif action == 'closeJoin' then
        resetChatState()
        SetNuiFocus(false, false)
    elseif action == 'leave' then
        TriggerEvent('sundl:smallmenu:leaveQueue')
    elseif action == 'lostPick' then
        TriggerEvent('sundl:smallmenu:lostPick', data.id)
    end
    cb('ok')
end)

AddEventHandler('sundl:smallmenu:openJoin', function()
    sundOpenJoinPanel()
end)

AddEventHandler('sundl:smallmenu:membershipChanged', function(cats, manager, count)
    SendNUIMessage({
        type    = 'SUND_MEMBERSHIP',
        cats    = cats or {},
        manager = manager and true or false,
        count   = count,
    })
end)

AddEventHandler('sundl:smallmenu:queueCount', function(count)
    SendNUIMessage({
        type  = 'SUND_QUEUE_COUNT',
        count = count or 0,
    })
end)

AddEventHandler('sundl:provideCategories', function(cats)
    if type(cats) == 'table' then
        sundCategories = cats
    end
    SendNUIMessage({ type = 'SUND_SET_CATEGORIES', categories = sundCategories })
end)

-- ----- More menu fetch (queue/lost/unaccepted) ---------------
RegisterNUICallback("sundFetch", function(data, cb)
    local xPlayer = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if not xPlayer or (xPlayer.permission_level or 0) < 1 then
        cb('ok'); return
    end
    local kind = data and data.kind
    if kind == 'categories' then
        TriggerEvent('sundl:requestCategories')
        SendNUIMessage({ type = 'SUND_SET_CATEGORIES', categories = sundCategories })
        cb('ok')
    elseif kind == 'queue' then
        ESX.TriggerServerCallback('dispatch:queue:fetch', function(res)
            SendNUIMessage({ type = 'SUND_DATA', kind = 'queue', data = res or {} })
            cb('ok')
        end, -1)
    elseif kind == 'lost' then
        ESX.TriggerServerCallback('dispatch:lost:fetch', function(res)
            SendNUIMessage({ type = 'SUND_DATA', kind = 'lost', data = res or {} })
            cb('ok')
        end)
    elseif kind == 'unaccepted' then
        ESX.TriggerServerCallback('dispatch:unaccepted:fetch', function(res)
            SendNUIMessage({ type = 'SUND_DATA', kind = 'unaccepted', data = res or {} })
            cb('ok')
        end)
    elseif kind == 'pickedHistory' then
        ESX.TriggerServerCallback('dispatch:pickedHistory:fetch', function(res)
            SendNUIMessage({ type = 'SUND_DATA', kind = 'pickedHistory', data = res or {} })
            cb('ok')
        end)
    else
        cb('ok')
    end
end)

RegisterNetEvent('dispatch:pickedHistory:upsert', function(key, bucket)
    SendNUIMessage({ type = 'SUND_PICKED_UPSERT', key = key, bucket = bucket })
end)

RegisterNetEvent('dispatch:pickedHistory:remove', function(key)
    SendNUIMessage({ type = 'SUND_PICKED_REMOVE', key = key })
end)

-- ============================================================
-- Sun Dispatch — Offer popup bridge
-- ============================================================
local sundActiveOffer = nil

AddEventHandler('sundl:offer:show', function(data)
    sundActiveOffer = data and data.id
    SendNUIMessage({
        type    = 'SUND_OFFER_SHOW',
        id      = data and data.id,
        cat     = data and data.cat,
        msg     = data and data.msg,
        owner   = data and data.owner,
        ownerId = data and data.ownerId,
        window  = data and data.window or 30,
    })
end)

AddEventHandler('dispatch:hidden:fromServer', function(toHide, mine)
    SendNUIMessage({
        type = 'SUND_HIDDEN_SET',
        ids  = toHide or {},
        mine = mine  or {},
    })
end)

AddEventHandler('sundl:offer:hide', function()
    sundActiveOffer = nil
    SendNUIMessage({ type = 'SUND_OFFER_HIDE' })
end)

AddEventHandler('sundl:offer:armAR', function(targetId)
    SendNUIMessage({
        type = 'SUND_ARM_AR',
        targetId = tostring(targetId),
    })
end)

AddEventHandler('sundl:offer:command', function(action)
    if not sundActiveOffer then return end
    if action ~= 'accept' and action ~= 'acceptSpectate' then return end
    SendNUIMessage({ type = 'OFFER_COMMAND', action = action })
end)

RegisterNUICallback("sundOffer", function(data, cb)
    local xPlayer = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if not xPlayer or (xPlayer.permission_level or 0) < 1 then
        cb('ok'); return
    end
    if data and sundActiveOffer then
        if data.action == 'accept' then
            TriggerEvent('sundl:offer:userAccept', sundActiveOffer)
        elseif data.action == 'acceptSpectate' then
            TriggerEvent('sundl:offer:userAcceptSpectate', sundActiveOffer)
        end
    end
    sundActiveOffer = nil
    cb('ok')
end)

AddEventHandler('chat:openReportSubmit', function(categories)
    resetChatState()
    panelOpen = true
    SendNUIMessage({
        type = "OPEN_REPORT_SUBMIT",
        categories = categories
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("reportSubmitAction", function(data, cb)
    resetChatState()
    SetNuiFocus(false, false)
    if data.action == "submit" then
        TriggerEvent('chat:reportSubmitted', data.message, data.category)
    end
    cb('ok')
end)

AddEventHandler('chat:ticketStatusUpdate', function(status, adminName, cat, message, time, _, reportId)
    SendNUIMessage({
        type = "TICKET_STATUS_UPDATE",
        status = status,
        adminName = adminName,
        cat = cat,
        message = message,
        time = time,
        reportId = reportId
    })
end)

AddEventHandler('chat:ticketHide', function()
    SendNUIMessage({ type = "TICKET_HIDE" })
end)

AddEventHandler('chat:setTicketCancelAllowed', function(allowed)
    SendNUIMessage({ type = "SET_TICKET_CANCEL_ALLOWED", allowed = allowed and true or false })
end)

AddEventHandler('chat:openRatingDirect', function(adminName, reportId)
    resetChatState()
    panelOpen = true
    SendNUIMessage({
        type = "OPEN_RATING_DIRECT",
        adminName = adminName,
        reportId = reportId
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("ticketAction", function(data, cb)
    if data.action == "cancel" then
        resetChatState()
        SetNuiFocus(false, false)
        ExecuteCommand('cancelreport')
    elseif data.action == "openDetail" then
        resetChatState()
        panelOpen = true
        SetNuiFocus(true, true)
    elseif data.action == "closeDetail" then
        resetChatState()
        SetNuiFocus(false, false)
    end
    cb('ok')
end)

RegisterNUICallback("ticketRatingAction", function(data, cb)
    resetChatState()
    SetNuiFocus(false, false)
    if data.action == "submit" then
        TriggerEvent('chat:ratingSubmitted', data.reportId, data.rating, data.comment)
    elseif data.action == "skip" then
        TriggerEvent('chat:ratingSkipped', data.reportId)
    end
    cb('ok')
end)
