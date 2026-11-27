-- ============================================================================
-- Unique_inventory | client/weapon-life.lua
-- Counts shots, blocks a broken weapon (0%) and runs the cleaner item.
-- The truth (shots, expiry) lives on the server; see server/weapons.lua.
-- ============================================================================

local WL = WeaponLife
local UNARMED = 0xA2719263

local meta = {}            -- [serial] = { shots, expireTS }  (pushed by the server)
local pending = {}         -- [serial] = shots counted since the last report
local byHash = {}          -- [weapon hash] = { serial, name } for weapons in slots, slot order
local lastNotice = 0

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

-- which inventory weapon is in the ped's hand: the first slotted one with that weapon type
local function refreshSlots()
    local ok, slots = pcall(function() return exports[GetCurrentResourceName()]:getWeaponSlot() end)
    if not ok or type(slots) ~= 'table' then return end
    local keys, map = {}, {}
    for k in pairs(slots) do keys[#keys + 1] = tonumber(k) end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local v = slots[k] or slots[tostring(k)]
        if type(v) == 'table' and v.name and v.serial then
            local h = GetHashKey(v.name)
            if not map[h] then map[h] = { serial = v.serial, name = tostring(v.name):upper() } end
        end
    end
    byHash = map
end

local function metaOf(serial)
    if meta[serial] then return meta[serial] end
    for _, w in ipairs(ESX.GetPlayerData().loadout or {}) do
        if w.serial == serial then
            local md = w.metadata or {}
            return { shots = tonumber(md.shots) or 0, expireTS = md.expireTS }
        end
    end
    return nil
end

RegisterNetEvent('Unique_inventory:weaponMeta', function(serial, shots, expireTS)
    meta[serial] = { shots = tonumber(shots) or 0, expireTS = expireTS }
end)

AddEventHandler('core:client:giveWeapon', function() SetTimeout(300, refreshSlots) end)
AddEventHandler('core:client:removeWeapon', function() SetTimeout(300, refreshSlots) end)

CreateThread(function()
    Wait(7000)
    while true do
        refreshSlots()
        Wait(3000)
    end
end)

-- 1) count shots of the weapon in hand
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local armed, hash = GetCurrentPedWeapon(ped, true)
        if armed and hash ~= UNARMED then
            if IsPedShooting(ped) then
                local entry = byHash[hash]
                if entry then
                    pending[entry.serial] = (pending[entry.serial] or 0) + 1
                    local m = meta[entry.serial] or metaOf(entry.serial)
                    if m then
                        m.shots = (m.shots or 0) + 1
                        meta[entry.serial] = m
                    end
                end
            end
            Wait(0)
        else
            Wait(300)
        end
    end
end)

-- report to the server every few seconds
CreateThread(function()
    while true do
        Wait(3000)
        for serial, n in pairs(pending) do
            local send = math.min(n, 60)
            TriggerServerEvent('Unique_inventory:weaponShots', serial, send)
            if n > send then pending[serial] = n - send else pending[serial] = nil end
        end
    end
end)

-- 2) a broken weapon (0%) cannot fire
CreateThread(function()
    while true do
        local blocked = false
        if WL.brokenBlocksFiring then
            local ped = PlayerPedId()
            local armed, hash = GetCurrentPedWeapon(ped, true)
            if armed and hash ~= UNARMED then
                local entry = byHash[hash]
                local m = entry and metaOf(entry.serial)
                if m and (tonumber(m.shots) or 0) >= WL.MaxShots(entry.name) then blocked = true end
            end
        end
        if blocked then
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)    -- attack
            DisableControlAction(0, 257, true)   -- attack 2
            if IsDisabledControlJustPressed(0, 24) and GetGameTimer() - lastNotice > 4000 then
                lastNotice = GetGameTimer()
                notify(('این اسلحه خراب است (۰٪). با «%s» تمیزش کن'):format(WL.cleaner.label))
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

-- 3) the cleaner item was used: clean the weapon in hand
RegisterNetEvent('Unique_inventory:useCleaner', function()
    local ped = PlayerPedId()
    local armed, hash = GetCurrentPedWeapon(ped, true)
    if not armed or hash == UNARMED then
        return notify('اسلحه‌ای را که می‌خواهی تمیز کنی در دست بگیر')
    end
    refreshSlots()
    local entry = byHash[hash]
    if not entry then return notify('این اسلحه داخل اسلات نیست') end
    local m = metaOf(entry.serial)
    if m and (tonumber(m.shots) or 0) <= 0 then return notify('این اسلحه تمیز است') end

    local done = true
    if lib and lib.progressCircle then
        done = lib.progressCircle({
            duration = WL.cleaner.seconds * 1000, position = 'bottom', label = 'تمیز کردن اسلحه', canCancel = true,
            disable = { move = true, car = true, combat = true },
        })
    end
    if done then TriggerServerEvent('Unique_inventory:cleanWeapon', entry.serial) end
end)
