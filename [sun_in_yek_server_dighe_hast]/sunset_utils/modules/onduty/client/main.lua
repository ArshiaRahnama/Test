-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Citizen.CreateThread(function ()
    waitForLoad()
    local spam = false
    for k,v in pairs(configDuty.Blips) do
        local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
        SetBlipSprite (blip, v.Sprite)
        SetBlipDisplay(blip, v.Display)
        SetBlipScale  (blip, v.Scale)
        SetBlipColour (blip, v.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Label)
        EndTextCommandSetBlipName(blip)
    end

    for k,v in pairs(configDuty.Zones) do
        ESX.RegisterPoint(vector3(v.Pos.x,v.Pos.y,v.Pos.z),2,{
            Color = {R = 255,G = 0,B = 0,A = 255},
            DrawDistance = 10,
            Radius = 0.5,
            Type = 17
        },{
            Notification = nil,
            DrawText = 'Dokme ~INPUT_CONTEXT~ jahat on/off duty',
            DrawTextRadius = 3,
            DrawTextCoords = vector3(v.Pos.x,v.Pos.y,v.Pos.z),
            Key = 'e',
            CB = function()
                local targetjob = configDuty.Zones[k].job
                if targetjob and targetjob[ESX.GetPlayerData().job.name:gsub("off","")] then
                    if not spam then
                        spam = true
                        SetTimeout(15000, function()
                            spam = false
                        end)
                        TriggerServerEvent('duty:toggle', 'manual')
                        Wait(1000)
                        if string.find(ESX.GetPlayerData().job.name,'off') then
                            ExecuteCommand('f man off duty shodam')
                        else
                            ExecuteCommand('f man on duty shodam')
                        end
                    else
                        ESX.chatMessage('Spam nakonid!', 'plarms')
                    end
                else
                    ESX.Alert('Error','Shoma nemitavanid az in location estefade konid', 5000 , 'error')
                    Wait(1000)
                end
            end,
        },{
            In = nil,
            Out = ESX.UI.Menu.CloseAll
        })
    end
end)