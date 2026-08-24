

local function notify(text, type, length)
    type = type or 'primary'
    length = length or 5000
    DebugPrint("Notify called with " .. text .. " text and " .. type .. " type")
    SendNUI("ShowNotification", nil, {
        text = text,
        type = type,
        length = length
    }, false)
end

RegisterNetEvent('ps-ui:Notify', notify)

exports('Notify', notify)