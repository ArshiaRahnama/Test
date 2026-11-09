-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


RegisterNetEvent('countdown', function(rawCommand)
    SendNUIMessage({
        uiName = 'countdown',
        text = rawCommand
	})
end)