-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inJob = false
local doesPointRegistred = false
local registerPoint = nil
local doesThreadRunning = false
local runThread = nil
local drawedText = {}
local blips = {}
Citizen.CreateThread(function()
    waitForLoad()
    Wait(1000)
    if ESX.PlayerData.job.name == 'wash' then
        inJob = true
    end
    if inJob then
        registerPoint()
        runThread()
    end
end)

RegisterNetEvent('esx:setJob',function(job)
    if job.name == 'wash' then
        inJob = true
        registerPoint()
        runThread()
    else
        inJob = false
        doesThreadRunning = false
    end
end)

registerPoint = function()
    if not doesPointRegistred then
        doesPointRegistred = true
        for k, v in pairs(configWashJob.positions) do
            for k2, v2 in pairs(v.coords) do
                table.insert(blips,ESX.AddBlipForCoord(v2,0.5,1,2,v.label))
                exports['ox_target']:addSphereZone({
                    coords = v2,
                    radius = 1.5,
                    options = {
                        {
                            label = "📕باز کردن منو",
                            onSelect = function()
                                if inJob then
                                    v.cb()
                                    ESX.registerExitPoint(2,function()
                                        ESX.UI.Menu.CloseAll()
                                        exports['icon_menu']:ForceCloseMenu()
                                    end)
                                end
                            end,
                        },
                    },
                })
            end
        end
    end
end

runThread = function()
    if not doesThreadRunning then
        doesThreadRunning = true
        Citizen.CreateThread(function()
            while doesThreadRunning do
                Wait(1000)
                for k, v in pairs(configWashJob.positions) do
                    for k2, v2 in pairs(v.coords) do
                        local distance = ESX.GetDistance(SUN.PlayerCoords, v2)
                        if distance <= 5 then
                            if not drawedText[k..k2] then
                                drawedText[k..k2] = true
                                Citizen.CreateThread(function()
                                    while drawedText[k..k2] do
                                        Wait(0)
                                        ESX.Game.Utils.DrawText3D(v2, v.label, 1.0)
                                    end
                                end)
                            end
                        else
                            drawedText[k..k2] = nil
                        end
                    end 
                end 
            end
        end)
    end
end