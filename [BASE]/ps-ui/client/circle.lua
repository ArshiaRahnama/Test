local p = nil

local function circle(cb, circles, seconds)
    if circles == nil or circles < 1 then circles = 1 end
    if seconds == nil or seconds < 1 then seconds = 10 end
    DebugPrint("Circle called with " .. circles .. " circles and " .. seconds .. " seconds")
    p = promise.new()
    SendNUIMessage({
        action = 'CircleGame',
        data = {
            circles = circles,
            time = seconds,
        }
    })
    SetNuiFocus(true, true)
    local result = Citizen.Await(p)
    cb(result)
end

RegisterNuiCallback('circle-result', function(data, cb)
    local result = data.endResult
    p:resolve(result)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Circle", circle)