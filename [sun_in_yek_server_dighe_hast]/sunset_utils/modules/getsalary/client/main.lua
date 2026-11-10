-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local coords = {
    vector3(247.36,222.59,106.29),
}

Citizen.CreateThread(function()
    while ESX == nil do Wait(10) end
    for k , v in pairs(coords) do
        ESX.RegisterPoint(v,2,{
            Color = {R = 0,G = 255,B = 0,A = 255},
            DrawDistance = 3,
            Radius = 0.5,
            Type = 18
        },{
            Notification = nil,
            DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu bank',
            DrawTextRadius = 2,
            DrawTextCoords = v,
            Key = 'e',
            CB = function()
                if ESX.GetPlayerData().World ~= 0 then return end
                ESX.TriggerServerCallback('getsalary:getData',function(salary)
                    local darsad = 0
                    if salary > 50000 then
                        if salary <= 100000 then
                            darsad = 0
                        elseif salary <= 200000 then
                            darsad = 10
                        elseif salary <= 1000000 then
                            darsad = 30
                        elseif salary <= 10000000 then
                            darsad = 60
                        else
                            darsad = 90
                        end
                    end
                    salary = salary - ESX.Math.Round((salary / 100) * darsad)
                    local List = {}
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Daryaft salary ' .. ESX.Math.GroupDigits(salary) .. '$', 
                        text2 = ESX.Math.GroupDigits(salary) .. '$', 
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            ESX.TriggerServerEvent('getsalay:give')
                    end})
                    exports.icon_menu:OpenMenu(List)
                end)
            end,
        },{
            In = nil,
            Out = function()
                exports.icon_menu:ForceCloseMenu()
            end
        })
    end
end)

RegisterNetEvent('moneywash:alarm',function(coords)
    local alpha = 250
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 50.0)

    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 5)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, true)
    ESX.ShowNotification('~r~Poul shuee tu ruze roshan :| ! ~w~')
    while alpha ~= 0 do
        Citizen.Wait(20 * 4)
        alpha = alpha - 1
        SetBlipAlpha(blip, alpha)

        if alpha == 0 then
            RemoveBlip(blip)
            return
        end
    end
end)