-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local openPanels = {}   -- { [moduleName] = true }
local openOverlays = {} -- { [moduleName] = true }
local focusState = false

--- Open a UI module
--- @param moduleName string
--- @param data table|nil
--- @param options table|nil { type = 'panel'|'overlay', focus = bool, cursor = bool }
function SUN.OpenUI(moduleName, data, options)
    options = options or {}
    local uiType = options.type or 'panel'

    if uiType == 'panel' then
        -- close existing panels
        for name in pairs(openPanels) do
            closePanel(name, true)
        end
        openPanels[moduleName] = true
    else
        openOverlays[moduleName] = true
    end

    SendNUIMessage({
        type = 'openUI',
        module = moduleName,
        uiPath = options.path or moduleName,
        uiType = uiType,
        payload = data or {}
    })

    if uiType == 'panel' then
        local showFocus = options.focus ~= false
        local showCursor = options.cursor ~= false
        if showFocus then
            SetNuiFocus(true, showCursor)
            focusState = true
        end
    end

    TriggerEvent('sunset_utils:uiOpened', moduleName, uiType)
end

--- Close a specific UI module
--- @param moduleName string|nil  if nil, closes current panel
function SUN.CloseUI(moduleName)
    if moduleName then
        if openPanels[moduleName] then
            closePanel(moduleName)
        elseif openOverlays[moduleName] then
            closeOverlay(moduleName)
        end
    else
        -- close active panel
        for name in pairs(openPanels) do
            closePanel(name)
            break
        end
    end
end

--- Close all UIs (panels + overlays)
function SUN.CloseAllUI()
    for name in pairs(openPanels) do
        closePanel(name, true)
    end
    for name in pairs(openOverlays) do
        closeOverlay(name, true)
    end

    SendNUIMessage({ type = 'closeAllUI' })

    if focusState then
        SetNuiFocus(false, false)
        focusState = false
    end
end

--- Send data to a specific module UI
--- @param moduleName string
--- @param data table
function SUN.SendUIData(moduleName, data)
    SendNUIMessage({
        type = 'sendData',
        module = moduleName,
        payload = data or {}
    })
end

--- Get all open UIs
--- @return table panels
--- @return table overlays
function SUN.GetOpenUIs()
    return openPanels, openOverlays
end

--- Check if a specific module UI is open
--- @param moduleName string
--- @return boolean
function SUN.IsUIOpen(moduleName)
    return openPanels[moduleName] or openOverlays[moduleName] or false
end

--- Get the active panel name (first open panel)
--- @return string|nil
function SUN.GetActivePanel()
    for name in pairs(openPanels) do
        return name
    end
    return nil
end

-- Internal helpers
function closePanel(name, skipMessage)
    if not openPanels[name] then return end
    openPanels[name] = nil

    if not skipMessage then
        SendNUIMessage({
            type = 'closeUI',
            module = name
        })
    end

    -- release focus if no panels left
    if not next(openPanels) and focusState then
        SetNuiFocus(false, false)
        focusState = false
    end

    TriggerEvent('sunset_utils:uiClosed', name)
end

function closeOverlay(name, skipMessage)
    if not openOverlays[name] then return end
    openOverlays[name] = nil

    if not skipMessage then
        SendNUIMessage({
            type = 'closeUI',
            module = name
        })
    end

    TriggerEvent('sunset_utils:uiClosed', name)
end

-- Event API
AddEventHandler('sunset_utils:openUI', function(moduleName, data, options)
    SUN.OpenUI(moduleName, data, options)
end)

AddEventHandler('sunset_utils:closeUI', function(moduleName)
    SUN.CloseUI(moduleName)
end)

AddEventHandler('sunset_utils:closeAllUI', function()
    SUN.CloseAllUI()
end)

AddEventHandler('sunset_utils:sendUIData', function(moduleName, data)
    -- backward compat: if moduleName is a table, it's old-style (data only, send to panel)
    if type(moduleName) == 'table' then
        local panel = SUN.GetActivePanel()
        if panel then
            SUN.SendUIData(panel, moduleName)
        end
        return
    end
    SUN.SendUIData(moduleName, data)
end)

-- NUI Callbacks
RegisterNUICallback('moduleCallback', function(data, cb)
    if data.module and data.action then
        TriggerEvent('sunset_utils:uiCallback:' .. data.module, data.action, data.data or {})
        TriggerEvent('sunset_utils:uiCallback', data.module, data.action, data.data or {})
    end
    cb('ok')
end)

RegisterNUICallback('requestClose', function(data, cb)
    if data.module then
        SUN.CloseUI(data.module)
    else
        SUN.CloseUI()
    end
    cb('ok')
end)

-- Exports
exports('OpenUI', function(moduleName, data, options)
    SUN.OpenUI(moduleName, data, options)
end)

exports('CloseUI', function(moduleName)
    SUN.CloseUI(moduleName)
end)

exports('CloseAllUI', function()
    SUN.CloseAllUI()
end)

exports('SendUIData', function(moduleName, data)
    SUN.SendUIData(moduleName, data)
end)

exports('GetOpenUIs', function()
    return SUN.GetOpenUIs()
end)

exports('IsUIOpen', function(moduleName)
    return SUN.IsUIOpen(moduleName)
end)

exports('GetActivePanel', function()
    return SUN.GetActivePanel()
end)
