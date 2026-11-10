-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local unit = nil
local inUnit = false
local tOut = 0
local blips = {}
local spam = false

local function blipPofak()
    for k , v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}
    ESX.TriggerServerCallback('police:getUnits',function(units)
        for k , v in pairs(units[ESX.PlayerData.job.name] or units.all) do
            if v.responders and v.responders[unit] then
                for k2 , v2 in pairs(v.members) do
                    if v2.owner then
                        ESX.TriggerServerCallback('getplayercoords', function(coords)
                            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                            SetBlipAlpha(blip, 180)
                            SetBlipSprite(blip, 58)
                            SetBlipScale(blip, 1.0)
                            SetBlipShrink(blip, 1)
                            SetBlipCategory(blip, 7)
                            SetBlipDisplay(blip, 6)
                            SetBlipColour(blip, 1)
                            SetBlipRoute(blip,true)
                            SetBlipRouteColour(blip,46)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentSubstringPlayerName(k .. "-" .. v2.name)
                            EndTextCommandSetBlipName(blip)
                            table.insert(blips,blip)
                        end,v2.src)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent('police:setUnit',function(name)
    unit = name
    local oldin = inUnit
    inUnit = name ~= nil
    if not oldin and inUnit then
        Citizen.CreateThread(function()
            while inUnit do
                Citizen.Wait(10000)
                blipPofak()
            end
        end)
    end
    if not inUnit then
        for k , v in pairs(blips) do
            RemoveBlip(v)
        end
        blips = {}
    end
end)

AddEventHandler('KeyDown:e',function()
    if spam then return end
    spam = true
    Citizen.SetTimeout(5000,function()
        spam = false
    end)
    for k , v in pairs(blips) do
        RemoveBlip(v)
    end
    blips = {}
    ESX.ClearTimeout(tOut)
    tOut = ESX.SetTimeout(30000,function()
        for k , v in pairs(blips) do
            RemoveBlip(v)
        end
        blips = {}
    end)
    if inUnit then
        blipPofak()
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/createunit', 'Sakhte unit', {
        { name="Esm", help="Esm unit" }
    })
    TriggerEvent('chat:addSuggestion', '/joinunit', 'Join unit', {
        { name="Esm", help="Esm unit" }
    })
    TriggerEvent('chat:addSuggestion', '/leaveunit', 'Leave unit')
    TriggerEvent('chat:addSuggestion', '/disbandunit', 'Disband unit', {
        { name="Esm", help="Esm unit" }
    })
    TriggerEvent('chat:addSuggestion', '/clearunit', 'Disband tamami unitha')
    TriggerEvent('chat:addSuggestion', '/units', 'Namayesh unit ha')
    TriggerEvent('chat:addSuggestion', '/getunit', 'Daryaft etela\'at unit',{
        { name="Esm", help="Esm unit" }
    })
    TriggerEvent('chat:addSuggestion', '/fo', 'List officer haye bedun unit')
    TriggerEvent('chat:addSuggestion', '/u', 'Chat beyn unit',{
        { name="Message", help="Message" }
    })
    TriggerEvent('chat:addSuggestion', '/calls', 'Namayes call ha',{
        { name="Message", help="Message" }
    })
    TriggerEvent('chat:addSuggestion', '/resp', 'Javab dadan be call',{
        { name="ID", help="Call ID" }
    })
    TriggerEvent('chat:addSuggestion', '/resp', 'Decline kardan call',{
        { name="ID", help="Call ID" }
    })
    TriggerEvent('chat:addSuggestion', '/closecall', 'Bastan kardan call')
    TriggerEvent('chat:addSuggestion', '/bc', 'Start call')
    TriggerEvent('chat:addSuggestion', '/pc', 'Start panic call')
    TriggerEvent('chat:addSuggestion', '/changejob', 'Change job',{
        { name="Job", help="Job" },
        { name="Grade", help="Grade" }
    })
    TriggerEvent('chat:addSuggestion', '/acceptrob', 'Accept robbery',{
        {name='ID', help='Rob ID'},
    })
    TriggerEvent('chat:addSuggestion', '/s11', 'S11')
    TriggerEvent('chat:addSuggestion', '/rr', 'Code Red')
end)


function doesHaveUnit()
    return inUnit
end
exports('doesHaveUnit', doesHaveUnit)

function getUnit()
    return unit
end
exports('getUnit', getUnit)