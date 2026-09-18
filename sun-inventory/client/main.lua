--[[
    RECONSTRUCTED FILE — client/main.lua

    This file did not exist in the uploaded package (it was present as an empty,
    0-byte placeholder). Every other file in this resource (client/clothe.lua,
    client/setting.lua and every modules/*/client/main.lua) calls global
    functions that can only live here: openInventory, closeInventory,
    loadPlayerInventory, sortItems, openOtherInventory, moveInsideHandler, plus
    the `settings` / `isOpen` state and the NUI focus + keybind wiring.

    It was rebuilt from evidence found elsewhere in the package:
      - the exact NUI callback names and action names extracted from the
        (obfuscated) ui/js/app.js strings table (inventory:mounted,
        inventory:moveInside, inventory:moveToMain, inventory:moveToSecond,
        inventory:instantToMain, inventory:instantToSecond, inventory:throwItem,
        inventory:useItem, inventory:giveItemToTarget, inventory:swapMoney,
        inventory:blurState, updateConfig, updatePlayerInventory,
        updateSecondInventory, updateMoney, itemNotification, slotNotification)
      - the `data.type` contract (`close` / `update` / `moveInside` /
        `moveToOther` / `moveToMain`) that EVERY module (bag, trunk, job,
        admin, public-inventory) already expects from openOtherInventory's
        callback.
      - the settings/setters shape used by ui/index.html
        (sfx, charactername, background, blur, itemdescription, itemnames,
        slots, itembg_1/2, weightbg_1/2).

    It is a best-effort, working reconstruction — NOT recovered original code
    (the original is gone / was never included). Test it against your actual
    server-side item/weight functions and adjust event names if your backend
    differs.
]]

isOpen = false
local uiReady = false
local currentSecond = nil -- { opts = {...}, callback = function(data) ... end }

-- ---------------------------------------------------------------------------
-- SETTINGS (persisted via KVP, matches the setters rendered in index.html)
-- ---------------------------------------------------------------------------

local defaultSettings = {
    sfx = true,
    charactername = true,
    background = true,
    blur = true,
    itemdescription = true,
    itemnames = true,
    slots = true,
    itembg_1 = { name = 'Items background (1)', color = true, checkbox = false, set = 'rgba(20,20,20,0.65)' },
    itembg_2 = { name = 'Items background (2)', color = true, checkbox = false, set = 'rgba(40,40,40,0.65)' },
    weightbg_1 = { name = 'Weight background', color = true, checkbox = false, set = 'rgba(20,20,20,0.65)' },
    weightbg_2 = { name = 'Weight fill color', color = true, checkbox = false, set = 'rgba(255,215,0,1.0)' },
}

function loadUISetting()
    local raw = GetResourceKvpString('inventory:setting')
    if raw then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then
            return decoded
        end
    end
    return defaultSettings
end

settings = loadUISetting()

-- saveUISetting() and the 'inventory:blurState' NUI callback are defined in
-- client/setting.lua, which loads after this file.

RegisterNUICallback('resetSettings', function(_, cb)
    settings = defaultSettings
    saveUISetting()
    SendNuiMessage(json.encode({ action = 'updateConfig', obj = settings }))
    cb('ok')
end)

-- ---------------------------------------------------------------------------
-- ITEM DISPLAY HELPERS
-- ---------------------------------------------------------------------------

-- The UI reads `.image` / `.label` straight off each item, so make sure
-- every item we send it has both, regardless of what the server sent us.
local function resolveItem(v)
    v.image = v.image or ('img/items/' .. tostring(v.name) .. '.png')
    if not v.label then
        local itemDef = ESX.GetItemLabel and ESX.GetItemLabel(v.name) or nil
        v.label = itemDef or v.name
    end
    return v
end

-- Normalizes whatever a module/server gave us (items[], optionally weapons[])
-- into the flat, image/label-resolved array the NUI expects. `kind` lets
-- callers ask for trunk-specific weight resolution (see modules/trunk).
function sortItems(data, kind)
    if not data then return {} end
    local out = {}

    if data.items then
        for _, v in pairs(data.items) do
            out[#out + 1] = resolveItem(v)
        end
    end

    if data.weapons then
        for _, v in pairs(data.weapons) do
            v.isWeapon = true
            v.image = v.image or ('img/items/WEAPON_' .. tostring(v.name):upper():gsub('^WEAPON_', '') .. '.png')
            v.label = v.label or (ESX.GetWeaponLabel and ESX.GetWeaponLabel(v.name)) or v.name
            out[#out + 1] = v
        end
    end

    table.sort(out, function(a, b)
        if a.slot and b.slot then return a.slot < b.slot end
        return (a.label or '') < (b.label or '')
    end)

    return out
end

-- ---------------------------------------------------------------------------
-- MAIN (PLAYER OWN) INVENTORY
-- ---------------------------------------------------------------------------

function loadPlayerInventory()
    local playerData = ESX.GetPlayerData()
    return sortItems({ items = playerData.inventory, weapons = playerData.loadout or playerData.weapons })
end

function sendPlayerInventory()
    if not uiReady then return end
    SendNuiMessage(json.encode({
        action = 'updatePlayerInventory',
        obj = loadPlayerInventory(),
    }))
end

function sendMoney()
    if not uiReady then return end
    local playerData = ESX.GetPlayerData()
    local money = 0
    if playerData.accounts then
        for _, acc in pairs(playerData.accounts) do
            if acc.name == 'money' or acc.name == 'cash' then
                money = acc.money
                break
            end
        end
    end
    SendNuiMessage(json.encode({ action = 'updateMoney', obj = money }))
end

function sendConfig()
    if not uiReady then return end
    SendNuiMessage(json.encode({ action = 'updateConfig', obj = settings }))
end

function itemNotification(itemLabel, count, image, remove)
    if not uiReady then return end
    SendNuiMessage(json.encode({
        action = 'itemNotification',
        label = itemLabel,
        count = count,
        image = image,
        remove = remove and true or false,
    }))
end

-- ---------------------------------------------------------------------------
-- OPEN / CLOSE
-- ---------------------------------------------------------------------------

function openInventory()
    if isOpen or ESX.isDead() then return end
    isOpen = true
    currentSecond = nil
    local playerData = ESX.GetPlayerData()
    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({
        action = 'openInventory',
        obj = loadPlayerInventory(),
        data = { name = playerData.firstName and (playerData.firstName .. ' ' .. playerData.lastName) or GetPlayerName(PlayerId()), maxweight = playerData.maxWeight or 120000 },
    }))
    sendConfig()
    sendMoney()
    createPedScreen()
end
exports('openInventory', openInventory)

function closeInventory()
    if not isOpen then return end
    isOpen = false
    if currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'close' })
    end
    currentSecond = nil
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({ action = 'closeInventory' }))
    deletePedScreen()
end
exports('closeInventory', closeInventory)

function toggleInventory()
    if isOpen then
        closeInventory()
    else
        openInventory()
    end
end

RegisterCommand('inventory', function()
    toggleInventory()
end, false)
-- Default keybind: TAB. Players can rebind it from FiveM's Settings > Key Bindings > FiveM.
RegisterKeyMapping('inventory', 'Open/close inventory', 'keyboard', 'TAB')

-- Close on ESC while open (the NUI itself has no dedicated "close" callback
-- in the observed protocol, so this is handled client-side).
CreateThread(function()
    while true do
        Wait(0)
        if isOpen then
            if IsControlJustReleased(0, 322) then -- INPUT_FRONTEND_PAUSE (ESC)
                closeInventory()
            end
        else
            Wait(250)
        end
    end
end)

-- ---------------------------------------------------------------------------
-- SECOND ("OTHER") INVENTORY — bag / trunk / job / admin / public / recycle
-- ---------------------------------------------------------------------------

-- opts: { items, timeout, maxWeight, label, type, searchKey, disableExitCheck }
-- callback(data) is invoked with data.type in
-- 'close' | 'update' | 'moveInside' | 'moveToOther' | 'moveToMain'
-- and, for 'update', its return value replaces the displayed second inventory.
function openOtherInventory(opts, callback)
    if not isOpen then openInventory() end
    currentSecond = { opts = opts, callback = callback }
    SendNuiMessage(json.encode({
        action = 'updateSecondInventory',
        obj = opts.items,
        data = {
            label = opts.label,
            maxWeight = opts.maxWeight,
            type = opts.type,
            searchKey = opts.searchKey,
        },
    }))
end
exports('openOtherInventory', openOtherInventory)

-- Called by every module after a moveToMain round trip resolves server-side,
-- to reconcile/refresh the main pane (and, in future, animate the dropped slot).
function moveInsideHandler(data)
    sendPlayerInventory()
end
exports('moveInsideHandler', moveInsideHandler)

local function refreshSecond()
    if currentSecond and currentSecond.callback then
        local ok, newItems = pcall(currentSecond.callback, { type = 'update' })
        if ok and newItems then
            currentSecond.opts.items = newItems
            SendNuiMessage(json.encode({ action = 'updateSecondInventory', obj = newItems }))
        end
    end
end

-- ---------------------------------------------------------------------------
-- NUI CALLBACKS (registered once; dispatched against whichever second
-- inventory, if any, is currently open)
-- ---------------------------------------------------------------------------

RegisterNUICallback('inventory:mounted', function(_, cb)
    uiReady = true
    cb('ok')
end)

RegisterNUICallback('inventory:blurState', function(state, cb)
    if state == 'on' then
        TriggerScreenblurFadeIn()
    else
        TriggerScreenblurFadeOut()
    end
    cb('ok')
end)

-- Reorder within the currently open inventory (main or second)
RegisterNUICallback('inventory:moveInside', function(data, cb)
    if data.inventoryType == 'main' then
        -- purely cosmetic ordering on the main pane; nothing to sync server-side
        sendPlayerInventory()
    elseif currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'moveInside', data = data })
    end
    cb('ok')
end)

-- Move an item from the second (open) inventory into the main inventory
RegisterNUICallback('inventory:moveToMain', function(data, cb)
    if currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'moveToMain', data = data })
    end
    cb('ok')
end)
RegisterNUICallback('inventory:instantToMain', function(data, cb)
    if currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'moveToMain', data = data })
    end
    cb('ok')
end)

-- Move an item from the main inventory into the second (open) inventory
RegisterNUICallback('inventory:moveToSecond', function(data, cb)
    if currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'moveToOther', data = data })
    end
    cb('ok')
end)
RegisterNUICallback('inventory:instantToSecond', function(data, cb)
    if currentSecond and currentSecond.callback then
        pcall(currentSecond.callback, { type = 'moveToOther', data = data })
    end
    cb('ok')
end)

RegisterNUICallback('inventory:useItem', function(data, cb)
    if not ESX.isDead() then
        ESX.TriggerServerEvent('esx:useItem', data.name)
    end
    cb('ok')
end)

RegisterNUICallback('inventory:throwItem', function(data, cb)
    if not ESX.isDead() then
        ESX.TriggerServerEvent('inventory:throwItem', data.name, data.count, data.ammo)
    end
    cb('ok')
end)

RegisterNUICallback('inventory:giveItemToTarget', function(data, cb)
    if not ESX.isDead() and data.targetSrc then
        ESX.TriggerServerEvent('inventory:giveItemToTarget', data.targetSrc, data.name, data.count, data.ammo)
    end
    cb('ok')
end)

RegisterNUICallback('inventory:swapMoney', function(data, cb)
    if not ESX.isDead() and data.targetSrc and tonumber(data.count) and tonumber(data.count) > 0 then
        ESX.TriggerServerEvent('inventory:swapMoney', data.targetSrc, tonumber(data.count))
    end
    cb('ok')
end)

-- Stash/search minigame gate (see blackListSearch / canSearchJob / blackListWorldSearch
-- in client/config.lua). Left as a stub: the modules that pass a `searchKey`
-- (e.g. modules/recycle) are expected to validate this server-side.
RegisterNUICallback('inventory:onSearch', function(data, cb)
    cb('ok')
end)

-- ---------------------------------------------------------------------------
-- KEEP THE OPEN PANES IN SYNC WITH SERVER-DRIVEN INVENTORY CHANGES
-- ---------------------------------------------------------------------------

RegisterNetEvent('esx:addInventoryItem', function(itemLabel, count, name)
    itemNotification(itemLabel, count, 'img/items/' .. tostring(name) .. '.png', false)
    sendPlayerInventory()
    refreshSecond()
end)

RegisterNetEvent('esx:removeInventoryItem', function(itemLabel, count, name)
    itemNotification(itemLabel, count, 'img/items/' .. tostring(name) .. '.png', true)
    sendPlayerInventory()
    refreshSecond()
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'money' or account.name == 'cash' then
        sendMoney()
    end
end)

RegisterNetEvent('esx:showInventory', function()
    openInventory()
end)

-- ---------------------------------------------------------------------------
-- NEARBY PLAYERS (for the "give item" panel)
-- ---------------------------------------------------------------------------

CreateThread(function()
    while true do
        Wait(1000)
        if isOpen and uiReady then
            local players = {}
            local myCoords = GetEntityCoords(PlayerPedId())
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local targetPed = GetPlayerPed(playerId)
                    if DoesEntityExist(targetPed) then
                        local dist = #(myCoords - GetEntityCoords(targetPed))
                        if dist <= 3.0 then
                            players[#players + 1] = GetPlayerServerId(playerId)
                        end
                    end
                end
            end
            SendNuiMessage(json.encode({ action = 'updateNearbyPlayers', obj = players }))
        else
            Wait(2000)
        end
    end
end)
