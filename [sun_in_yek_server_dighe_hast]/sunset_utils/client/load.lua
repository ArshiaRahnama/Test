-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local lastLoad = load
local loadedScript = {}
function load(code)
    pcall(lastLoad(code))
end

function loadScript(name, index)
    while ESX == nil do Citizen.Wait(10) end
    local wait = true
    local code = nil
    ESX.TriggerServerCallback('sunset_utils:loadCode',function(_)
        code = _
        wait = false
    end,name,index)
    while wait do Citizen.Wait(10) end
    SetTimeout(1000, function()
        loadedScript[name..index] = true
    end)
    return code
end
exports('loadScript',loadScript)
exports('waitForScriptLoad', function(name, index)
    while not loadedScript[name..index] do Wait(100) end
    return true
end)