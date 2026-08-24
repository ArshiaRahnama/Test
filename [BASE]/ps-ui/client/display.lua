local storedText = ""
local storedColor = "primary"

exports("DisplayText", function(text, color, icon)
    if text == nil then storedText = "" else storedText = text end
    if color == nil then storedColor = "primary" else storedColor = color end
    DebugPrint("DisplayText called with " .. text .. " text and " .. color .. " color")
    SendNUIMessage({
        action = "ShowDrawTextMenu",
        data = {
            title = "No Title",
            keys = storedText,
            icon = icon or 'fa-solid fa-circle-info',
            color = storedColor,
        }
    })
end)

exports("HideText", function()
    storedText = ""
    storedColor = "primary"
    SendNUIMessage({
        action = "HideDrawTextMenu",
    })
end)

exports("UpdateText", function(text, color, icon)
    if text == nil then storedText = "" else storedText = text end
    if color == nil then storedColor = "primary" else storedColor = color end
    SendNUIMessage({
        action = "ShowDrawTextMenu",
        data = {
            keys = storedText,
            icon = icon or 'fa-solid fa-circle-info',
            color = storedColor,
        }
    })
end)