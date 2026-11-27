-- ============================================================================
-- Unique_inventory | client/jobs.lua
-- Job lockers and the gang armory chest in the new inventory UI, plus the events the old
-- inventory answered (so Unique_ALLGangs / esx_uniquejobs / sun-jobs keep working unchanged):
--   esx_inventoryhud:OpenJobInventory1   (armory)   -> openJobInventory()
--   esx_inventoryhud:OpenJobInventory2   (storage)  -> openJobInventory()   (same window, tabs Items / Guns)
--   esx_inventoryhud:OpenGangInventory   (key)      -> openGangInventory(key)
-- The server (server/jobs.lua) decides what is locked and enforces every move.
-- ============================================================================

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

local function isClothe(name)
    local ok, data = pcall(function() return exports['Unique_Clothe']:getClotheData(name) end)
    return ok and data ~= nil
end

-- opts: key = stash key, id = what the put/get events get as first argument, label, putEvent, getEvent
local function openCounted(opts)
    openOtherInventory({
        label = opts.label,
        fetch = function(mode, weaponName) return getSecondLazy(opts.key, mode, weaponName) end,
        timeout = 1000,
    }, function(data)
        if data.type == 'moveToOther' then
            if ESX.isDead() then return end
            if isClothe(data.data.name) then
                return notify('لباس را نمی‌توانید داخل صندوق بگذارید')
            end
            ESX.TriggerServerEvent(opts.putEvent, opts.id, data.data)
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent(opts.getEvent, opts.id, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                moveInsideHandler(data.data)
            end
        end
        -- 'close', 'update' and 'moveInside': nothing to do for a counted list
    end)
end

function openJobInventory()
    local job = ESX.GetPlayerData().job
    if not job or not job.name or job.name == 'unemployed' then
        return notify('شما شغلی ندارید')
    end
    if ESX.isDead() then return end
    ESX.UI.Menu.CloseAll()
    openCounted({
        key = 'job:' .. job.name, id = job.name, label = (job.label or job.name),
        putEvent = 'inventory-job:put', getEvent = 'inventory-job:get',
    })
end
exports('openJobInventory', openJobInventory)

function openGangInventory(armoryKey)
    local gang = ESX.GetPlayerData().gang
    if not gang or not gang.name or gang.name == 'nogang' then
        return notify('شما عضو گنگ نیستید')
    end
    if ESX.isDead() then return end
    ESX.UI.Menu.CloseAll()
    local title = 'Gang Armory & Storage'
    local p = promise.new()
    ESX.TriggerServerCallback('Unique_inventory:getGangArmoryTitle', function(t) p:resolve(t) end, armoryKey)
    local got = Citizen.Await(p)
    if type(got) == 'string' and got ~= '' then title = got end
    openCounted({
        key = 'gang:' .. tostring(armoryKey or ''), id = armoryKey or '', label = title,
        putEvent = 'inventory-gang:put', getEvent = 'inventory-gang:get',
    })
end
exports('openGangInventory', openGangInventory)

-- the events the old inventory handled
RegisterNetEvent('esx_inventoryhud:OpenJobInventory1', function() openJobInventory() end)
RegisterNetEvent('esx_inventoryhud:OpenJobInventory2', function() openJobInventory() end)
RegisterNetEvent('esx_inventoryhud:OpenGangInventory', function(armoryKey) openGangInventory(armoryKey) end)
