

RegisterCommand("streamermode", function(source, args, rawCommand)
    disableMusic = not disableMusic
    if disableMusic then
        TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_on"] } })

        for k, v in pairs(soundInfo) do
            Destroy(v.id)
        end

    else
        TriggerEvent('chat:addMessage', { args = { "^1[xSound]", config.Messages["streamer_off"] } })
    end
end, false)