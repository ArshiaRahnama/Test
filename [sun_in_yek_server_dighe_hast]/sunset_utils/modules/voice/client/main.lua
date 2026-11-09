-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local muteList = {}
CreateThread(function()
    waitForLoad()
    ESX.RegisterCommand('mute', function(src, args)
        local id = tonumber(args[1])
        if id then
            if muteList[id] then
                MumbleSetVolumeOverrideByServerId(id, -1.0)
                ESX.chatMessage(('[%s] unmute shod'):format(id), 'plarms')
            else
                MumbleSetVolumeOverrideByServerId(id, 0.0)
                ESX.chatMessage(('[%s] mute shod'):format(id), 'plarms')
            end
            muteList[id] = not muteList[id]
        else
            ESX.chatMessage(ESX.lang.missing, 'plarms')
        end
    end, {help = 'Mute kardan player', params = {{name = 'ID', help = 'ID'}}})
end)