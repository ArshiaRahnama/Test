-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local cd = false
RegisterNetEvent('campfire:useTur',function()
    if cd then return end
    TriggerEvent('esx_inventoryhud:closeHud')
    local nearEntity = 0
    local coords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(configCampFire.objects) do
        local entity,distance = ESX.Game.GetClosestObject(k,coords)
        if entity ~= -1 and distance < 4 then
            nearEntity = entity
        end
    end
    if nearEntity ~= 0 then
        local elements = {}
        local inventory = ESX.GetPlayerData().inventory
        table.insert(elements,{
            img = '',
            text = 'Kodum ro mikhay bepazi?', 
            text2 = '', 
            callBack = function()
        end})
        for k,v in pairs(inventory) do
            if configCampFire.items[v.name] and v.count > 0 then
                local data = configCampFire.items[v.name]
                table.insert(elements,{
                    img = 'nui://sun-inventory-hud/ui/img/items/' .. v.name .. '.png',
                    text = v.count >= data.need and (v.label .. '✔️') or (v.label .. '❌') , 
                    text2 = v.count >= data.need and ('') or (data.need .. 'x niaz darad'), 
                    callBack = v.count >= data.need and function()
                        cd = true
                        SetEntityProofs(PlayerPedId(), false, true, false, false, false, false, false, false)
                        exports.icon_menu:ForceCloseMenu()
                        exports['sun-animmenu']:PlayEmote('bbq',true)
                        local time = math.random((configCampFire.cookingTime - 10),configCampFire.cookingTime)
                        Citizen.SetTimeout(time * 1000,function()
                            SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
                            TriggerEvent('mythic_progbar:client:cancel')
                            ESX.TriggerServerEvent('campfire:cook',v.name,exports['esx_vehiclecontrol']:taskBar(3500,10) == 100)
                            cd = false
                        end)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "cooking",
                            duration = configCampFire.cookingTime * 1000,
                            label = "",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        },function()
                            
                        end)
                    end or function() end})
            end
        end
        exports.icon_menu:OpenMenu(elements)
    else
        ESX.Alert('Error','Shoma bayad dar nazdiki yek atash bashid.',10000,'error')
    end
end)