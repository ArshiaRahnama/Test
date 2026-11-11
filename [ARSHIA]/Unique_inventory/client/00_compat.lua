-- ============================================================================
-- Unique_inventory | client/00_compat.lua
-- Glue between the original "Sunset" client and Unique RP's essentialmode.
-- Loads FIRST. Builds ESX (essentialmode has no getObject export) and adds the
-- helpers the Sunset client calls but essentialmode does not have.
-- ============================================================================

local function loadESX()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end
loadESX()
CreateThread(function()
    while ESX == nil do
        Wait(200)
        loadESX()
    end
end)

-- The shared ESX object is a copy: functions still call into essentialmode,
-- but tables we add below live only in this resource. That is what we want.
local function waitESX() while ESX == nil do Wait(50) end end

-- --------------------------------------------------------------------------
-- exports stubs: resources of the original server that this server lacks.
-- A stub is used only while the real resource is NOT started.
-- --------------------------------------------------------------------------
local realExports = exports
local stubs = {
    sunset_clothe = {
        getUsedType = function() return {} end,
        getClotheData = function() return nil end,
        getUsed = function() return {} end,
        getOwnedClotheByType = function() return {} end,
        getOwnedPack = function() return {} end,
        toggleClothe = function() return false end,
        unUseByType = function() end,
    },
    sunset_utils = {
        GetServerOSTime = function() return GetCloudTimeAsInt() end,
        checkncz = function() return false end,
        canAccessToVehicle = function() return true end,
        deactiveArmoredHelmet = function() end,
        checkArmoredHelmetActive = function() return false end,
        getHandupState = function() return false end,
        tradeUICallback = function() end,
        startTrade = function() end,
        me = function() end,
    },
    ['sun-jobs'] = { notBlackListCoords = function() return true end },
    ['sun-robbery'] = { doesInRob = function() return false end },
    ['sun-animmenu'] = { PlayEmote = function() end },
    gangs = { isInGangWorld = function() return false end },
    esx_vehiclecontrol = {
        IsGOV = function() return false end,
        HaveAccess = function() return true end,
    },
}

exports = setmetatable({}, {
    __call = function(_, ...) return realExports(...) end,
    __index = function(_, res)
        local stub = stubs[res]
        if stub and GetResourceState(res) ~= 'started' then
            return setmetatable({}, {
                __index = function(_, fn)
                    local f = stub[fn]
                    return function(_, ...)
                        if f then return f(...) end
                    end
                end,
            })
        end
        return realExports[res]
    end,
})

-- --------------------------------------------------------------------------
-- key events: the original server got 'KeyDown:<key>' events from its
-- sunset_utils resource. Without it F2 / Alt+number do nothing, so we raise the
-- same events ourselves by polling controls - the same method this server's
-- Unique_inventory used for F2 (control 289), so it is known to work here.
-- --------------------------------------------------------------------------
local SUN_DEBUG = false
if GetResourceState('sunset_utils') ~= 'started' then
    local controls = {
        f2 = 289, lmenu = 19,
        ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165,
        ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163,
    }
    CreateThread(function()
        while true do
            Wait(0)
            for name, ctrl in pairs(controls) do
                -- disabled controls (sunset disables weapon-select while Alt is held) report via the Disabled variant
                if IsControlJustPressed(0, ctrl) or IsDisabledControlJustPressed(0, ctrl) then
                    if SUN_DEBUG then print(('[Unique_inventory] KeyDown:%s'):format(name)) end
                    TriggerEvent('KeyDown:' .. name)
                elseif IsControlJustReleased(0, ctrl) or IsDisabledControlJustReleased(0, ctrl) then
                    TriggerEvent('KeyUp:' .. name)
                end
            end
        end
    end)
end

-- manual open (works even if a key is blocked) and a quick self-check
RegisterCommand('suninv', function() TriggerEvent('KeyDown:f2') end, false)
RegisterCommand('suninv_debug', function()
    SUN_DEBUG = not SUN_DEBUG
    local items = ESX and ESX.getItems and ESX.getItems() or nil
    local function n(t) local c = 0 for _ in pairs(t or {}) do c = c + 1 end return c end
    print('^3[Unique_inventory] debug ' .. (SUN_DEBUG and 'ON' or 'OFF') .. '^7')
    print(('  ESX: %s | items loaded: %s (%d) | isOpen: %s | state.nui: %s | HandCuffed: %s'):format(
        tostring(ESX ~= nil), tostring(items ~= nil), n(items), tostring(isOpen),
        tostring(LocalPlayer.state.nui), tostring(ESX and ESX.GetPlayerData().HandCuffed)))
    print(('  ox_target: %s | ox_lib: %s | essentialmode: %s'):format(
        GetResourceState('ox_target'), GetResourceState('ox_lib'), GetResourceState('essentialmode')))
    -- what the client itself sees
    local pd = ESX and ESX.GetPlayerData() or {}
    local withCount = 0
    for _, it in ipairs(pd.inventory or {}) do if (it.count or 0) > 0 then withCount = withCount + 1 end end
    print(('  client sees: %d inventory rows (%d with count>0), %d weapons'):format(#(pd.inventory or {}), withCount, #(pd.loadout or {})))
    -- what the server answers for the slots/weight request
    if ESX then
        ESX.TriggerServerCallback('inventory:getSlots', function(r)
            if not r then print('  ^1server answered NOTHING for inventory:getSlots^7 (check the server console for a red [sun-inventory-hud] line)') return end
            print(('  server getSlots: maxWeight=%s | weapons=%d'):format(tostring(r.maxWeight), #(r.loadout or {})))
        end)
    end
    print('  Press F2 now - a "KeyDown:f2" line should appear here.')
end, false)
SUN_VERSION = 'stage2-v10'
print(('^2[%s] client compat loaded (%s) - F2 or /suninv to open, /suninv_debug to diagnose^7'):format(GetCurrentResourceName(), SUN_VERSION))

-- --------------------------------------------------------------------------
-- stand-ins for functions that live in modules not loaded in stage 1
-- (modules/*/client/*.lua redefine these when they are enabled in stage 2)
-- --------------------------------------------------------------------------
function openTrunk() return false end
function setBag() end
function getRandomRecycle() return nil end
deleteCoords = deleteCoords or {}

-- --------------------------------------------------------------------------
-- ESX helpers
-- --------------------------------------------------------------------------
local function installHelpers()
    local baseGetPlayerData = ESX.GetPlayerData
    ESX.src = GetPlayerServerId(PlayerId())

    ESX.TriggerServerEvent = function(name, ...) TriggerServerEvent(name, ...) end

    -- items table (name -> {label, weight, limit, canRemove, rare}) from the server
    local itemsCache, fetching = nil, false
    ESX.getItems = function()
        if itemsCache then return itemsCache end
        if not fetching then
            fetching = true
            ESX.TriggerServerCallback('Unique_inventory:getItems', function(res)
                itemsCache = res or {}
            end)
        end
        return nil
    end
    ESX.getItem = function(name)
        local it = itemsCache and itemsCache[name]
        if it then return it end
        return { name = name, label = name, weight = 0.5, limit = -1, canRemove = true }
    end
    ESX.getItemWeight = function(name) return ESX.getItem(name).weight or 0.5 end
    ESX.fetchListedItems = function() end

    -- player state (replicated via state bags). canGive defaults to true.
    ESX.GetPlayerState = function(src, key)
        local v = Player(src).state[key]
        if v == nil and key == 'canGive' then return true end
        return v
    end
    ESX.SetPlayerState = function(key, val) LocalPlayer.state:set(key, val, true) end

    -- notifications
    local function notify(msg)
        if ESX.ShowNotification then ESX.ShowNotification(tostring(msg)) end
    end
    ESX.Alert = function(_, msg) notify(msg) end
    ESX.notification = function(_, msg) notify(msg) end
    ESX.chatMessage = function(msg) notify(msg) end

    ESX.isDead = function(src)
        if src then
            return ESX.GetPlayerState(src, 'isInjure') or ESX.GetPlayerState(src, 'isDead')
        end
        local pd = baseGetPlayerData and baseGetPlayerData() or {}
        return pd.IsInjure or pd.IsDead or IsEntityDead(PlayerPedId())
    end
    ESX.GetDistance = function(a, b) if a and b then return #(a - b) end end

    ESX.Game = ESX.Game or {}
    ESX.Game.GetPlayersToSend = function(dist)
        local out, me = {}, GetEntityCoords(PlayerPedId())
        for _, p in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(p)
            if #(GetEntityCoords(ped) - me) <= (dist or 50.0) then
                out[#out + 1] = GetPlayerServerId(p)
            end
        end
        return out
    end
    ESX.Game.doesPlayerExist = function(id)
        for _, p in ipairs(GetActivePlayers()) do
            if GetPlayerServerId(p) == tonumber(id) then return true end
        end
        return false
    end

    -- jobs / blocked items: copied 1:1 from the original server's essentialmode/shared/config.lua
    ESX.blockedItems = { -- ghabele enteghal nist - soulbound
        customtoken = true,
        zombie_head = true,
        decals_m_174_0 = true,
        decals_f_178_0 = true,
        decals_m_181_0 = true,
        decals_m_183_0 = true,

        WEAPON_LUCILLE = true,
        WEAPON_KATANA = true,
        WEAPON_KATANA2 = true,

        persuit_1 = true,
        darktape = true,

        speaker = true,
        tvpub = true,

        sim_912 = true,
        sim_913 = true,
        sim_915 = true,
        sim_917 = true,
        sim_910 = true,
        sim_930 = true,

        chests_1 = true,
        chests_2 = true,
        chests_3 = true,
        chests_4 = true,
    }

    ESX.blockedItemsJob = {
        -- ['phone'] = {
        --     'police',
        -- }
    }

    ESX.blockedItemButCanGive = { -- can give
        persuit_1 = true,

        chests_1 = true,
        chests_2 = true,
        chests_3 = true,
        chests_4 = true,
    }

    ESX.blackListSearch = {
        kit50 = true,
        kit100 = true,
        kittire = true,
        cleaner = true,
        adrenaline = true,
        medikit = true,
        bandage = true,
        jack = true,
        compass = true,

        sim_912 = true,
        sim_913 = true,
        sim_915 = true,
        sim_917 = true,
        sim_910 = true,
        sim_930 = true,
        sim_982 = true,
    }

    ESX.militaryJobs = {
        police = true,
        sheriff = true,
        mt = true,
        detective = true,
        fbi = true,
        justice = true,
        offpolice = true,
        offsheriff = true,
        offmt = true,
        offdetective = true,
        offfbi = true,
        offjustice = true,
    }

    ESX.militaryJobs2 = {
        police = true,
        sheriff = true,
        mt = true,
        detective = true,
        fbi = true,
        justice = true,
    }


    ESX.doesBlockedItem = function(name)
        return ESX.blockedItems[name] or ESX.blockedItems[name:lower()]
    end
    ESX.doesBlockedItemJob = function(name, jobName)
        local config = ESX.blockedItemsJob[name] or ESX.blockedItemsJob[name:lower()]
        if not config or not jobName then return false end
        local job = jobName:gsub('off', '')
        for _, j in ipairs(config) do if j == job then return true end end
        return false
    end
    ESX.doesBlockedItemButCanGive = function(name)
        return ESX.blockedItemButCanGive[name] or ESX.blockedItemButCanGive[name:lower()]
    end

    -- essentialmode here returns (index, weapon) from ESX.GetWeapon, the original
    -- server returned only the weapon table. The inventory does
    --   item = ESX.GetWeapon(name); item.difficulty
    -- so with the index it crashed the moment the player owned any weapon.
    local baseGetWeapon = ESX.GetWeapon
    if baseGetWeapon then
        ESX.GetWeapon = function(name)
            local a, b = baseGetWeapon(name)
            if type(a) == 'table' then return a end
            return b or {}
        end
    end

    -- helpers of the original server that this essentialmode does not have
    ESX.getCoords = function() return GetEntityCoords(PlayerPedId()) end
    ESX.SetPedArmour = function(ped, armour) SetPedArmour(ped, armour) end
    ESX.isDeadOrCuff = function()
        return ESX.isDead() or (ESX.GetPlayerData().HandCuffed == 1)
    end
    ESX.canInteract = function()
        local ped = PlayerPedId()
        if ESX.isDeadOrCuff() then return false end
        if IsPedFalling(ped) or IsPedRagdoll(ped) or IsPedBeingStunned(ped) then return false end
        return true
    end
    ESX.displayTime = function(time)
        local days = (((time) / 60) / 60) / 24
        local d = math.floor(days)
        local h = math.floor((days - d) * 24)
        local m = math.floor(((days - d) * 24 - h) * 60)
        return string.format('%sD : %sH : %sM', d, h, m)
    end
    ESX.registerExitPoint = function(radius, cb)
        CreateThread(function()
            local coords = GetEntityCoords(PlayerPedId())
            while true do
                Wait(100)
                if #(coords - GetEntityCoords(PlayerPedId())) > radius then
                    if cb then
                        cb()
                    else
                        if ESX.UI and ESX.UI.Menu and ESX.UI.Menu.CloseAll then ESX.UI.Menu.CloseAll() end
                        if lib and lib.hideMenu then lib.hideMenu() end
                    end
                    break
                end
            end
        end)
    end
    -- the original ESX.Game.SpawnObject(model, coords, cb, await) can return the object
    -- synchronously (await = true); this server's version only has the callback form
    ESX.Game = ESX.Game or {}
    local baseSpawnObject = ESX.Game.SpawnObject
    if baseSpawnObject then
        ESX.Game.SpawnObject = function(model, coords, cb, await)
            if not await then return baseSpawnObject(model, coords, cb) end
            local p = promise.new()
            baseSpawnObject(model, coords, function(obj)
                if cb then cb(obj) end
                p:resolve(obj)
            end)
            return Citizen.Await(p)
        end
    end
    ESX.Game = ESX.Game or {}
    ESX.Game.DeleteEntity = function(entity)
        if entity and DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, false, true)
            DeleteEntity(entity)
        end
    end

    -- used by the trunk module
    ESX.getWeaponWeight = function(name) return 2.0 end
    ESX.progressCircle = function(ms, canCancel)
        if lib and lib.progressCircle then
            return lib.progressCircle({ duration = ms, position = 'bottom', canCancel = canCancel ~= false,
                disable = { move = true, car = true, combat = true } }) and true or false
        end
        Wait(ms)
        return true
    end
    -- the original ESX.Math.Round(value, decimals, floor) has a third "round down" flag
    if ESX.Math and ESX.Math.Round then
        local baseRound = ESX.Math.Round
        ESX.Math.Round = function(value, decimals, floor)
            if floor then
                local m = 10 ^ (decimals or 0)
                return math.floor((tonumber(value) or 0) * m) / m
            end
            return baseRound(value, decimals)
        end
    end

    ESX.DoesHaveItem2 = function(name, count)
        for _, it in ipairs(ESX.GetPlayerData().inventory or {}) do
            if it.name == name then return (it.count or 0) >= (count or 1) end
        end
        return false
    end

    -- essentialmode's client rebuilds PlayerData.loadout from the ped's weapons
    -- every few seconds (one entry per weapon TYPE, no serial). The Sunset client
    -- needs the real, serial-bearing loadout, so we keep the server's copy here:
    --   * captured from every 'inventory:getSlots' answer (sent when the UI opens)
    --   * refreshed by the server's 'esx:updateLoadout' push after any weapon change
    local serverLoadout = nil

    local baseTSC = ESX.TriggerServerCallback
    ESX.TriggerServerCallback = function(name, cb, ...)
        if name == 'inventory:getSlots' then
            return baseTSC(name, function(res)
                if type(res) == 'table' and type(res.loadout) == 'table' then
                    serverLoadout = res.loadout
                end
                cb(res)
            end, ...)
        end
        return baseTSC(name, cb, ...)
    end

    AddEventHandler('Unique_inventory:setLoadout', function(loadout)
        if type(loadout) == 'table' then serverLoadout = loadout end
    end)

    ESX.GetPlayerData = function()
        local d = baseGetPlayerData() or {}
        local src = serverLoadout or d.loadout or {}
        local loadout = {}
        for _, w in ipairs(src) do
            local e = {}
            for k, v in pairs(w) do e[k] = v end
            e.serial = e.serial or ('NOSERIAL-' .. tostring(e.name))
            e.metadata = e.metadata or {}
            e.metadata.serial = e.metadata.serial or e.serial
            e.metadata.shots = e.metadata.shots or 0
            loadout[#loadout + 1] = e
        end
        d.loadout = loadout
        -- essentialmode inserts the weapon notification {label = "..."} (no name / count)
        -- straight into PlayerData.inventory whenever a weapon is added or removed.
        -- Rows like that crashed the inventory (v.name:find) and left the mouse stuck.
        local inv = {}
        for _, it in ipairs(d.inventory or {}) do
            if type(it) == 'table' and type(it.name) == 'string' and it.name ~= '' then
                it.count = tonumber(it.count) or 0
                inv[#inv + 1] = it
            end
        end
        d.inventory = inv
        d.World = d.World or 0
        d.name2 = d.name2 or d.name or GetPlayerName(PlayerId())
        return d
    end
end

if ESX ~= nil then
    installHelpers()
else
    CreateThread(function() waitESX() installHelpers() end)
end

-- server pushes the whole loadout after any weapon change
RegisterNetEvent('esx:updateLoadout', function(loadout)
    TriggerEvent('Unique_inventory:setLoadout', loadout)
end)


-- --------------------------------------------------------------------------
-- safety nets
-- --------------------------------------------------------------------------
-- 1) any error while filling the inventory is printed loudly instead of leaving an empty window
CreateThread(function()
    while type(loadPlayerInventory) ~= 'function' do Wait(100) end
    local original = loadPlayerInventory
    loadPlayerInventory = function(...)
        local ok, res = xpcall(original, debug.traceback, ...)
        if not ok then
            print(('^1[%s] loadPlayerInventory FAILED:\n%s^7'):format(GetCurrentResourceName(), tostring(res)))
            if ESX and ESX.ShowNotification then ESX.ShowNotification('خطا در بارگذاری اینونتوری - F8 را ببین') end
            return nil
        end
        return res
    end
end)

-- 1b) if openui itself fails, release the mouse / NUI focus instead of leaving it stuck
CreateThread(function()
    while type(openui) ~= 'function' do Wait(100) end
    local originalOpenui = openui
    openui = function(...)
        local ok, res = xpcall(originalOpenui, debug.traceback, ...)
        if not ok then
            print(('^1[%s] openui FAILED:\n%s^7'):format(GetCurrentResourceName(), tostring(res)))
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({ action = 'hideInventory' })
            pcall(originalOpenui, false)
            return nil
        end
        return res
    end
end)

-- 2) detect other copies of this inventory running at the same time (they fight over F2 and the NUI)
CreateThread(function()
    Wait(8000)
    local me, dups = GetCurrentResourceName(), {}
    for i = 0, GetNumResources() - 1 do
        local res = GetResourceByFindIndex(i)
        if res and res ~= me and GetResourceState(res) == 'started'
            and LoadResourceFile(res, 'client/weapon-slots.lua') and LoadResourceFile(res, 'ui/index.html') then
            dups[#dups + 1] = res
        end
    end
    if #dups > 0 then
        print(('^1[%s] ANOTHER COPY OF THIS INVENTORY IS RUNNING: %s - stop/delete it, two copies fight over F2 and the UI^7'):format(me, table.concat(dups, ', ')))
    end
end)
