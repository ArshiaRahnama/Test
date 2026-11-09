-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local tradeBanState, checked = false, false


exports('isTradeBan', function()
    if not checked then
        local p = promise.new()
        ESX.TriggerServerCallback('tradeban:check', function(state)
            checked = true
            tradeBanState = state
            p:resolve()
        end)
        Citizen.Await(p)
    end
    return tradeBanState
end)

AddStateBagChangeHandler('talkBan', nil, function(bagName, _, value)
    local playerId = GetPlayerFromStateBagName(bagName)
    if playerId == 0 then return end

    local serverId = GetPlayerServerId(playerId)

    if value then
        MumbleSetVolumeOverrideByServerId(serverId, 0.0)
    else
        MumbleSetVolumeOverrideByServerId(serverId, -1.0)
    end
end)

local isTalkBanned = false

AddStateBagChangeHandler('talkBan', ('player:%s'):format(GetPlayerServerId(PlayerId())), function(_, _, value)
    isTalkBanned = value == true
end)

AddEventHandler('KeyDown:n', function()
    if isTalkBanned and ESX.checkCooldown('talkban_info', 10000) then
        ESX.TriggerServerCallback('talkban:getInfo', function(data)
            if data.banned then
                ESX.chatMessage(('Shoma talk ban hastid | Dalil: %s | %s rooz mande'):format(data.reason, data.remaining), 'alarms')
            end
        end)
    end
end)