AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    print('^3--------------------------------------------------^7')
    print('^2[Chat System]^7 Running Fix -> ^5arshiahub.ir^7')
    print('^3★^7 This resource is Owner by ^5arshiahub.ir^7')
    print('^3--------------------------------------------------^7')
end)

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

function SendChannelMessage(target, channel, args, color)
    TriggerClientEvent('chat:addMessage', target, {
        channel = channel,
        color = color or { 170, 102, 204 },
        multiline = true,
        args = args
    })
end

function SetChatPinned(target, author, text)
    TriggerClientEvent('chat:setPinned', target, author and {
        author = author,
        text = text
    } or nil)
end

RegisterCommand('pin', function(source, args)
    local text = table.concat(args, ' ')
    SetChatPinned(-1, GetPlayerName(source), text)
end, false)

RegisterServerEvent('chat:logMessage')
AddEventHandler('chat:logMessage', function(message)

TriggerEvent('DiscordBot:ToDiscord', 'chat', GetPlayerName(source), "```cs\nID: [ "..source.." ]\n[ Name : " .. GetPlayerName(source) .. " ]\n[ Message : ]  \n[ " .. message .. " ]```",'user', source, false, false)
end)

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Citizen.Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and '[ System ] : ',{ 255,0,0 }, rawCommand:sub(5))
end)

AddEventHandler('playerConnecting', function()

end)

AddEventHandler('playerDropped', function(reason)

end)


