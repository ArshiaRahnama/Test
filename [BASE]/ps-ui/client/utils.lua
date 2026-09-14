local callback = nil
local isActive = false
local debug = false

RegisterNUICallback('minigame:callback', function(res, cb)
    SetNuiFocus(false, false)

    if callback then
        callback(res)
    end

    DebugPrint("Minigame closed. Result: " .. tostring(res))

    isActive = false

    cb('ok')
end)

function SendNUI(action, cb, data, nuiFocus)
    if not isActive then
        isActive = true
        SetNuiFocus(nuiFocus, nuiFocus)
        SendNUIMessage({
            action = action,
            data = data
        })
        if not cb then
            isActive = false
        end
    end

    if cb then
        callback = cb
    end
end

function DebugPrint(...)
	if not debug then return end
	local args <const> = { ... }

	local appendStr = ''
	for _, v in ipairs(args) do
		appendStr = appendStr .. ' ' .. tostring(v)
	end
	local msgTemplate = '^3[%s]^0%s'
	local finalMsg = msgTemplate:format("ps-ui", appendStr)
	print(finalMsg)
end