-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

function getJobPerm()
    local p = promise.new()
    ESX.TriggerServerCallback('esx_society:getInventoryPermission', function(perm, perm2)
        p:resolve({ perm or {}, perm2 or {} })
    end)
    local r = Citizen.Await(p)
    return r[1], r[2]
end

function applyJobPerm(raw, mode, perm, perm2, gradeName)
    local function allowed(name)
        return gradeName == 'boss' or perm[name] or perm2[name] or perm[name:lower()] or perm2[name:lower()]
    end
    if mode == 'groups' then
        for _, g in ipairs(raw or {}) do
            if not allowed(g.name) then g.locked = true end
        end
    elseif mode == 'instances' then
        for _, v in ipairs(raw or {}) do
            if not allowed(v.name) then v.locked = true end
        end
    elseif raw and raw.items then
        for _, v in ipairs(raw.items) do
            if not allowed(v.name) then v.locked = true end
        end
    end
end

function openJobInventory()
    jobName = ESX.GetPlayerData().job.name
    ESX.UI.Menu.CloseAll()
    local gradeName = ESX.GetPlayerData().job.grade_name
    local jobPerm, jobPerm2 = getJobPerm()
    openOtherInventory({fetch = function(mode, weaponName)
        local raw = getSecondLazy('job:' .. jobName, mode, weaponName)
        applyJobPerm(raw, mode, jobPerm, jobPerm2, gradeName)
        return raw
    end, timeout = 1000}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getJobInventory(jobName))
        elseif data.type == 'moveInside' then
            ESX.TriggerServerEvent('inventory-job:updateSlot', jobName, data.data)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            local clotheData = exports['Unique_Clothe']:getClotheData(data.data.name)
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
            local allItem = perm.allitem or perm2.allitem
            local allWeapon = perm.allweapon or perm2.allweapon
            for k , v in ipairs(data.items) do
                if allItem or perm[v.name] or perm2[v.name] or perm[v.name:lower()] or perm2[v.name:lower()] or gradeName == 'boss' then
                    table.insert(items.items,v)
                else
                    v.locked = true
                    table.insert(items.items,v)
                end
            end
            for k , v in ipairs(data.weapons) do
                if allWeapon or perm[v.name] or perm2[v.name] or perm[v.name:lower()] or perm2[v.name:lower()] or gradeName == 'boss' then
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