-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local MODULE_NAME = 'test-ui'

-- /testui → opens as a panel (with cursor + focus)
RegisterCommand('testui', function()
    SUN.OpenUI(MODULE_NAME, {
        message = 'Salam! In ye test UI hast.',
        serverId = SUN.src,
        job = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name or 'unknown'
    }, { type = 'panel' })
end)

-- /testoverlay → opens as an overlay (no cursor, always visible)
RegisterCommand('testoverlay', function()
    if SUN.IsUIOpen(MODULE_NAME .. '-overlay') then
        SUN.CloseUI(MODULE_NAME .. '-overlay')
    else
        SUN.OpenUI(MODULE_NAME .. '-overlay', {
            message = 'Overlay mode - bedone cursor',
            serverId = SUN.src,
            job = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name or 'unknown'
        }, { type = 'overlay', path = MODULE_NAME })
    end
end)

-- /closeui → close panel
RegisterCommand('closeui', function()
    SUN.CloseUI(MODULE_NAME)
end)

-- Callbacks from panel UI
AddEventHandler('sunset_utils:uiCallback:' .. MODULE_NAME, function(action, data)
    if action == 'send' then
        TriggerEvent('chat:addMessage', {
            color = {255, 200, 0},
            args = {"Test UI", "Text: " .. (data.text or '')}
        })
        SUN.SendUIData(MODULE_NAME, {
            response = 'Text ersal shod: ' .. (data.text or '')
        })

    elseif action == 'ping' then
        SUN.SendUIData(MODULE_NAME, {
            response = 'Pong! Time: ' .. GetGameTimer()
        })

    elseif action == 'escape' then
        SUN.CloseUI(MODULE_NAME)
    end
end)

AddEventHandler('sunset_utils:uiClosed', function(moduleName)
    if moduleName == MODULE_NAME then
        TriggerEvent('chat:addMessage', {
            color = {150, 150, 150},
            args = {"Test UI", "Panel baste shod"}
        })
    end
end)
