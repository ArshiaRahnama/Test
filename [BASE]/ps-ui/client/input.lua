local p = nil
local active = false

local function input(InputData)
    DebugPrint("Input called with " .. json.encode(InputData))
    p = promise.new()
    while active do Wait(0) end
    active = true
    SendNUIMessage({
        action = "ShowInput",
        data = InputData
    })
    SetNuiFocus(true, true)

    local inputs = Citizen.Await(p)
    return inputs
end

RegisterNUICallback('input-callback', function(data, cb)
    SetNuiFocus(false, false)
    p:resolve(data)
    p = nil
    active = false
    cb('ok')
end)

RegisterNUICallback('input-close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Input", input)