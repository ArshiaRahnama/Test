function openJobInventory()
    jobName = ESX.GetPlayerData().job.name
    ESX.UI.Menu.CloseAll()
    local items = sortItems(getJobInventory(jobName))
    openOtherInventory({items = items, timeout = 1000}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getJobInventory(jobName))
        elseif data.type == 'moveInside' then
            ESX.TriggerServerEvent('inventory-job:updateSlot', jobName, data.data)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            local clotheData = exports['sunset_clothe']:getClotheData(data.data.name)
            if not clotheData then
                ESX.TriggerServerEvent('inventory-job:put', jobName, data.data)
            else
                ESX.Alert('', 'Shoma nemitavanid dar komod job lebas bezarid!', 7000, 'error')
            end
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('inventory-job:get', jobName, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                moveInsideHandler(data.data)
            end
        end
    end)
end

function getJobInventory(jobName)
    local p = promise.new()
    local gradeName = ESX.GetPlayerData().job.grade_name
    ESX.TriggerServerCallback('inventory-job:getInventory', function(data)
        ESX.TriggerServerCallback('esx_society:getInventoryPermission', function(perm, perm2)
            local items = {
                items = {},
                weapons = {},
                slots = {}
            }
            for k , v in ipairs(data.items) do
                if perm[v.name] or perm2[v.name] or perm[v.name:lower()] or perm2[v.name:lower()] or gradeName == 'boss' then
                    table.insert(items.items,v)
                else
                    v.locked = true
                    table.insert(items.items,v)
                end
            end
            for k , v in ipairs(data.weapons) do
                if perm[v.name] or perm2[v.name] or perm[v.name:lower()] or perm2[v.name:lower()] or gradeName == 'boss' then
                    table.insert(items.weapons, v)
                else
                    v.locked = true
                    table.insert(items.weapons, v)
                end
            end
            items.slots = data.slots
            p:resolve(items)
        end)
        -- p:resolve(data)
    end, jobName)
    return Citizen.Await(p)
end

exports('openJobInventory', openJobInventory)
exports('getJobInventory', getJobInventory)