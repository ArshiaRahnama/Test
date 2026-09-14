

local function statusShow(title, description, icon, values)
    DebugPrint("StatusBar called with " .. title .. " title, " .. description .. " description, " .. icon .. " icon, and " .. json.encode(values) .. " values")
    SendNUI("ShowStatusBar", nil, {
        title = title,
        description = description,
        icon = icon,
        items = values,
    }, false)
end

local function statusHide()
    SendNUI("HideStatusBar", nil, {}, false)
end

local function statusUpdate(title, values)
    SendNUI("updateStatusBar", nil, {
        update = true,
        title = title,
        values = values,
    }, false)
end

exports("StatusShow", statusShow)
exports("StatusHide", statusHide)
exports("StatusUpdate", statusUpdate)