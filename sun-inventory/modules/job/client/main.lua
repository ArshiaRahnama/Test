--[[
    sun-inventory — job stash client.

    FIXES:
      - ESX.Alert doesn't exist -> ESX.ShowNotification.
      - 'esx_society:getInventoryPermission' is not a callback esx_society
        (or anything else in this project) registers - TriggerServerCallback
        on a name nobody answers never resolves, so Citizen.Await(p) below
        would have hung forever the first time anyone opened a job stash.
        Removed the whole per-item-permission layer it was trying to
        build: access is already gated server-side, uniformly per job, by
        modules/job/server/main.lua (xPlayer.job.name == jobName) - that's
        the actual security boundary, so this just matches it instead of
        pretending a finer-grained, nonexistent permission system exists.
]]

function openJobInventory()
    jobName = ESX.GetPlayerData().job.name
    ESX.UI.Menu.CloseAll()
    local items = sortItems(getJobInventory(jobName))
    openOtherInventory({items = items, timeout = 1000}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getJobInventory(jobName))
        elseif data.type == 'moveInside' then
            TriggerServerEvent('inventory-job:updateSlot', jobName, data.data)
        elseif data.type == 'moveToOther' then
            if IsPlayerDead() then return end
            local clotheData = GetClotheData(data.data.name)
            if not clotheData then
                TriggerServerEvent('inventory-job:put', jobName, data.data)
            else
                ESX.ShowNotification('Shoma nemitavanid dar komod job lebas bezarid!')
            end
        elseif data.type == 'moveToMain' then
            if IsPlayerDead() then return end
            TriggerServerEvent('inventory-job:get', jobName, data.data)
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
    ESX.TriggerServerCallback('inventory-job:getInventory', function(data)
        p:resolve(data)
    end, jobName)
    return Citizen.Await(p)
end

exports('openJobInventory', openJobInventory)
exports('getJobInventory', getJobInventory)
