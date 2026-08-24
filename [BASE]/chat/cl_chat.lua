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
local AntiSpam = 0

local channelKeywords = {
    { channel = 'system',  keywords = { 'system' } },
    { channel = 'event',   keywords = { 'event' } },
    { channel = 'tabligh', keywords = { 'tabligh', 'agahi', 'weazel news', 'ads' } },
    { channel = 'job',     keywords = { '[f]', 'faction', 'job', 'duty', 'commissioner' } },
    { channel = 'gang',    keywords = { '[g]', 'gang' } },
    { channel = 'staff',   keywords = { 'staff', 'admin', 'report' } },
}

local function detectChannel(args)
    if not args then return nil end
    local text = table.concat(args, ' '):lower()
    for _, entry in ipairs(channelKeywords) do
        for _, kw in ipairs(entry.keywords) do
            if text:find(kw, 1, true) then
                return entry.channel
            end
        end
    end
    return nil
end

function setChatDecor(state)
    DecorSetInt(PlayerPedId(),'typing',state)
end

local function OpenChatInput()
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

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:setPinned')

RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEnteredOps')

AddEventHandler('chatMessage', function(author, color, text)
    if not active then return end


    local args = { text }
    if author ~= "" then
        table.insert(args, 1, author)
    end
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            color = color,
            multiline = true,
            args = args,
            channel = detectChannel(args) or 'live'
        }
    })


end)

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

AddEventHandler('chat:addMessage', function(message)
    if not active then return end

    if not message.channel then
        message.channel = detectChannel(message.args) or 'live'
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

AddEventHandler('chat:setPinned', function(pinned)
    SendNUIMessage({
        type = 'ON_PIN',
        pinned = pinned
    })
end)

RegisterNetEvent("chat:setMuteStatus")
AddEventHandler("chat:setMuteStatus", function(status)
    muted = status
end)

RegisterNUICallback('chatResult', function(data, cb)


    chatInputActive = false
    SetNuiFocus(false)
    setChatDecor(false)
    if not data.canceled then
        local id = PlayerId()

        local r, g, b = 0, 0x99, 255
        data.message = data.message:gsub('^','')
        if data.message:sub(2):len() > 300 and ESX.GetPlayerData().job.name ~= 'weazel' then
            cb('ok')
            return
        end
        TriggerServerEvent('chat:logMessage', data.message)
        if data.message:sub(1, 1) == '/' then



            if data.message:sub(2) == 'chatsetting' then
                OpenChatInput()
                SendNUIMessage({ type = 'ON_OPEN_SETTINGS' })
                cb('ok')
                return
            end



            if (GetGameTimer() - AntiSpam) > 2000 then
                AntiSpam = GetGameTimer()
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



                if not muted then
                    TriggerServerEvent('_chat:messageEnteredOps', GetPlayerName(id), { r, g, b }, data.message)
                else

                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"[SYSTEM]", "^0Shoma nemitavanid hengami ke ^1mute ^0hastid chat konid!"}
                    })

                end

            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "^1Lotfan Spam Nakonid!"}
                })


            end

        end
    end

    cb('ok')

end)

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');

    local saved = GetResourceKvpString('chat_settings')
    if saved then
        SendNUIMessage({
            type = 'ON_SETTINGS',
            settings = json.decode(saved)
        })
    end

    local savedStars = GetResourceKvpString('chat_starred')
    if savedStars then
        SendNUIMessage({
            type = 'ON_STARRED',
            starred = json.decode(savedStars)
        })
    end

    cb('ok')
end)

RegisterNUICallback('saveSettings', function(data, cb)
    SetResourceKvp('chat_settings', json.encode(data))
    cb('ok')
end)

RegisterNUICallback('saveStarred', function(data, cb)
    SetResourceKvp('chat_starred', json.encode(data.starred or {}))
    cb('ok')
end)

RegisterNUICallback('action', function(data, cb)
    if data and data.event then
        TriggerEvent(data.event, table.unpack(data.args or {}))
    end
    cb('ok')
end)

RegisterNUICallback('openInput', function(data, cb)
    OpenChatInput()
    cb('ok')
end)

AddEventHandler("onKeyDown", function(key)
  if ESX.GetPlayerData().InPhone then return end
  if key == "t" then
    OpenChatInput()
  end
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
end)

RegisterCommand('togglechat2', function()
  if ESX.GetPlayerData().permission_level >= 9 or ESX.GetPlayerData().job.name == 'weazel' then
    active = not active
    local state = active and 'active' or 'deactive'
    lib.notify({ position = 'center-right', title = '', description = 'chat ' .. state, type = 'info', duration = 3000 })
  end
end, false)

RegisterCommand('chatsetting', function()
    OpenChatInput()
    SendNUIMessage({ type = 'ON_OPEN_SETTINGS' })
end, false)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerEvent('chat:addSuggestion', '/chatsetting', 'باز کردن پنل تنظیمات چت')
end)
