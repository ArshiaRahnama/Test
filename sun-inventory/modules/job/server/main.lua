--[[
    sun-inventory — job stash storage.
]]

local function jobKey(jobName)
    return 'job_' .. tostring(jobName)
end

ESX.RegisterServerCallback('inventory-job:getInventory', function(source, cb, jobName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.job.name ~= jobName then return cb({ items = {}, weapons = {} }) end
    cb(Inventory.Get(jobKey(jobName)))
end)

RegisterServerEvent('inventory-job:updateSlot')
AddEventHandler('inventory-job:updateSlot', function(jobName, data)
    -- Reordering only; nothing authoritative to change with a flat items[] model.
end)

RegisterServerEvent('inventory-job:put')
AddEventHandler('inventory-job:put', function(jobName, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.job.name ~= jobName then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end
        local playerItem = xPlayer.getInventoryItem(data.name)
        if not playerItem or playerItem.count < count then return end

        local inv = Inventory.Get(jobKey(jobName))
        xPlayer.removeInventoryItem(data.name, count)
        local found = false
        for _, v in ipairs(inv.items) do
            if v.name == data.name then
                v.count = v.count + count
                found = true
                break
            end
        end
        if not found then
            inv.items[#inv.items + 1] = { name = data.name, count = count }
        end
        Inventory.Save(jobKey(jobName), inv)
    end)
end)

RegisterServerEvent('inventory-job:get')
AddEventHandler('inventory-job:get', function(jobName, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.job.name ~= jobName then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end

        local inv = Inventory.Get(jobKey(jobName))
        for i, v in ipairs(inv.items) do
            if v.name == data.name and v.count >= count then
                if not xPlayer.canCarryItem(data.name, count) then
                    xPlayer.showNotification('You cannot carry that much weight.')
                    return
                end
                v.count = v.count - count
                if v.count <= 0 then table.remove(inv.items, i) end
                xPlayer.addInventoryItem(data.name, count)
                Inventory.Save(jobKey(jobName), inv)
                return
            end
        end
    end)
end)
