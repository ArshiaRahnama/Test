-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local near = 0
local boxcoords = {
    vec(260.3, -780.1, 30.56),      -- parking markazi
    vec(655.64, 588.69, 129.05),    -- mc 1
    vec(-264.37, -893.87, 31.22),   -- job center
    vec(892.29, -1581.91, 30.6),    -- mineri
    vec(587.63, 2743.92, 42.07),    -- sandy
    vec(1720.13, 3697.77, 34.51),   -- sandy sheriff
    vec(159.02, 6638.98, 31.58),    -- paleto
    vec(-1602.6, 203.17, 59.4),     -- restran shams
    vec(-1027.29, -2125.03, 13.37), -- ghasabi
    vec(110.25, -1572.54, 29.6),    -- barbari
    vec(953.3, -1693.13, 30.06),    -- Car meeting
    vec(-1590.12, -2740.97, 13.94)  -- g_200
}
local kaduid = 0
local kaduname = 'prop_veg_crop_03_pump'
local kaduhash = GetHashKey(kaduname)
Citizen.CreateThread(function()
    while ESX == nil do Wait(100) end
    
    while true do
        Wait(500)
        local coords = GetEntityCoords(PlayerPedId())
        for k , v in pairs(boxcoords) do
            local distance = ESX.GetDistance(coords,v)
            if distance <= 3 then
                if near == 0 then
                    near = k
                    Citizen.CreateThread(function()
                        while near ~= 0 do
                            Wait(10)
                            ESX.ShowHelpNotification('~INPUT_CONTEXT~ To open mail box')
                        end
                    end)
                end
            elseif near == k then
                near = 0
            end
        end
        -- local kadu = GetClosestObjectOfType(coords, 3.0, kaduhash, false)
        -- if DoesEntityExist(kadu) and not DecorGetBool(kadu,'prog') then
        --     if kaduid == 0 then
        --         kaduid = kadu
        --         Citizen.CreateThread(function()
        --             while kaduid ~= 0 do
        --                 Wait(10)
        --                 if DoesEntityExist(kaduid) and ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(kaduid)) < 3 and not DecorGetBool(kaduid,'prog') then
        --                     ESX.ShowHelpNotification('~INPUT_CONTEXT~ Jahat baz kardan kadu')
        --                 else
        --                     kaduid = 0
        --                 end
        --             end
        --         end)
        --     end
        -- else
        --     kaduid = 0
        -- end
    end
end)
--
AddEventHandler('onKeyDown',function(key)
    if key == 'e' then
        if near ~= 0 then
            openMailBox('self')
        elseif kaduid ~= 0 then
            Wait(500,2000)
            if DoesEntityExist(kaduid) and not Entity(kaduid).state.prog then
                ESX.Game.DeleteObject(kaduid)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "kadu",
                    duration = math.random(10000,15000),
                    label = "Dar hal baz kardan kadu",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@heists@box_carry@",
                        anim = "idle",
                    },
                    prop = {
                        model = "prop_veg_crop_03_pump",
                    }
                }, function(status)
                    if not status then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        ESX.TriggerServerEvent('sunset_quest:Hallowen')
                        TriggerEvent('InteractSound_CL:PlayOnOne','evil', 10.0)
                    elseif status then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('mailbox:openother')
AddEventHandler('mailbox:openother',function(name)
    openMailBox(name)
end)

function openMailBox(name)
    local data = getMailboxInventory(name)
    local items = exports['sun-inventory-hud']:sortItems(data)
    exports['sun-inventory-hud']:openOtherInventory({items = items, timeout = 1000, label = 'Mailbox'}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return exports['sun-inventory-hud']:sortItems(getMailboxInventory(name))
        elseif data.type == 'moveInside' then
            -- ESX.TriggerServerEvent('mailbox:updateSlot', name, data.data)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('mailbox:put', name, data.data.itemType, data.data.name, data.data.count, data.data)
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('mailbox:get', name, data.data.itemType, data.data.name, data.data.count, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                exports['sun-inventory-hud']:moveInside(data.data)
            end
        end
    end)
end

function getMailboxInventory(name)
    local p = promise.new()
    ESX.TriggerServerCallback('mailbox:getInventory',function(data)
        p:resolve(data) 
    end, name)
    return Citizen.Await(p)
end