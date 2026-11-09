-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

CreateThread(function()
    waitForLoad()
    local wait = 5000
    local try = 0
    local function sendHeartBeat()
        ESX.TriggerServerCallback('lan:check', function()
            try = 0
        end)
    end
    local thread = false
    local function limitThread()
        if not thread then
            thread = true
            CreateThread(function()
                while thread and try > 0 do
                    Wait(0)
                    disableFiring()
                    DisableControlAction(0, 21, true)
                    DisableControlAction(0, 30, true)
                    DisableControlAction(0, 31, true)
                    DisableControlAction(0, 36, true)
                    ESX.Game.Utils.DrawText2D('~r~Connection lost', 0.5, 0.5, 2.0)
                end
                thread = false
            end)
        end
    end
    while true do
        while not ESX.doesExportExist('sun-robbery', 'doesInRob') do Wait(1000) end
        local inRob, robSuccess = exports['sun-robbery']:doesInRob(), exports['sun-robbery']:doesRobSuccess()
        if (inRob and robSuccess) and not ESX.isDead() then
            wait = 1500
            sendHeartBeat()
            try = try + 1
            if try >= 5 then
                limitThread()
                Wait(3000)
                while true do end
            end
        else
            wait = 5000
        end
        Wait(wait)
    end
end)