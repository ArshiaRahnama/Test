-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isFreeze = false
local function openCloset(identifier, job, zoneData, gang, militaryPut, justPutout)
    local data = getClosetInventory(identifier, job, gang)
    local items = exports['sun-inventory-hud']:sortItems(data)
    exports['sun-inventory-hud']:openOtherInventory({items = items, timeout = 1000, label = 'Komod', maxWeight = zoneData.maxWeight}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            local closet = getClosetInventory(identifier, job, gang)
            local sorted = exports['sun-inventory-hud']:sortItems(closet)
            sorted.weight = closet.weight
            return sorted
        elseif data.type == 'moveInside' then
            if not isFreeze then
                ESX.TriggerServerEvent('jobCloset:updateSlot', identifier, job, data.data, gang)
            end
        elseif data.type == 'moveToOther' then
            if not isFreeze or militaryPut then
                if ESX.isDead() or justPutout then return end
                ESX.TriggerServerEvent('jobCloset:put', {itemType = data.data.itemType, name = data.data.name, count = data.data.count, identifier = identifier, job = job, data = data.data, zoneData = zoneData, gang = gang, militaryPut = militaryPut})
            end
        elseif data.type == 'moveToMain' then
            if not isFreeze then
                if ESX.isDead() then return end
                ESX.TriggerServerEvent('jobCloset:get', data.data.itemType, data.data.name, data.data.count, identifier, job, data.data, zoneData, gang)
                Wait(500)
                if data.data.droppedTo then
                    data.data.inventoryType = 'main'
                    exports['sun-inventory-hud']:moveInside(data.data)
                end
            end
        end
    end)
end

local function createZone(k)
    local data = ConfigJobCloset[k]
    if not data.created then
        data.created = true
        for k , v in pairs(data.coords) do
            ESX.RegisterPoint(v - vector3(0,0,1),2,{
                Color = {R = 102,G = 153,B = 255,A = 255},
                DrawDistance = 4,
                Radius = 0.7,
                Type = 0,
                worldCheck = false,
            },{
                Notification = nil,
                DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan komod',
                DrawTextRadius = 2,
                DrawTextCoords = v,
                Key = 'e',
                CB = function()
                    if SUN.world == 0 or exports['gangs']:isInGangWorld() then
                        isFreeze = false
                        if ESX.PlayerData.job.name == data.job then
                            openCloset(nil, nil, data)
                        elseif ESX.PlayerData.gang.name == data.gang then
                            openCloset(nil, nil, data, true)
                        end
                    end
                end,
            },{
                In = nil,
                Out = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
        end
    end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(10000)
	local job = xPlayer.job
    for k , v in pairs(ConfigJobCloset) do
        if (v.job == job.name or v.gang == xPlayer.gang.name) and not v.created then
            createZone(k)
        end
    end
end)

RegisterNetEvent('esx:setJob',function(job)
    ESX.PlayerData.job = job
    for k , v in pairs(ConfigJobCloset) do
        if v.job == job.name and not v.created then
            createZone(k)
        end
    end
end)

RegisterNetEvent('esx:setGang',function(gang)
    ESX.PlayerData.gang = gang
    for k , v in pairs(ConfigJobCloset) do
        if v.gang == gang.name and not v.created then
            createZone(k)
        end
    end
end)


function getClosetInventory(hex, job, gang)
    local p = promise.new()
    ESX.TriggerServerCallback('jobCloset:getData',function(data)
        p:resolve(data) 
    end, hex, job, gang)
    return Citizen.Await(p)
end

RegisterNetEvent('jobCloset:openJobCloset', function(hex, job, freeze, gang, militaryPut, justPutout)
    isFreeze = freeze
    openCloset(hex, job, {maxWeight = 500}, gang, militaryPut, justPutout)
end)

function openOldGangCloset()
    ESX.TriggerServerCallback('jobCloset:getGangList', function(result)
        local list = {}
        for k, v in pairs(result) do
            if v.name:find('jobCloset') then
                local data = ESX.splitString(v.name, ':')
                if not ESX.militaryJobs[data[2]] and data[2] ~= ESX.PlayerData.job.name and data[2] ~= 'nojob' then
                    table.insert(list, {label = data[2], args = {type = 1, name = data[2]}})
                end
            elseif v.name:find('gangCloset') then
                local data = ESX.splitString(v.name, ':')
                if data[2] ~= ESX.PlayerData.gang.name and data[2] ~= 'nogang' then
                    table.insert(list, {label = data[2], args = {type = 2, name = data[2]}})
                end
            end
        end
        lib.registerMenu({
            id = 'oldCloset',
            title = 'Old closet',
            options = list
        }, function(selected, scrollIndex, args)
            openCloset(nil, args.name, {maxWeight = 500}, args.type == 2 and args.name, nil, true)
        end)
        lib.showMenu('oldCloset')
    end)
end

exports('openOldGangCloset', openOldGangCloset)