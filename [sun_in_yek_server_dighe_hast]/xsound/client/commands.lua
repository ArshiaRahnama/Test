-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- i recommend to NOT change the command name. it will make easier for people to use this command
-- when ever is this library.. so please keep this command name on "streamermode" command
RegisterCommand("streamermode", function(source, args, rawCommand)
    disableMusic = not disableMusic
    if disableMusic then
        TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_on"] } }, 'plarms')

        for k, v in pairs(soundInfo) do
            Destroy(v.id)
        end

    else
        TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_off"] } }, 'plarms')
    end
end, false)