-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

local KVP = 'inv_shortcuts'
InvShortcuts = {}

local okLoad, decoded = pcall(function()
    local raw = GetResourceKvpString(KVP)
    return raw and json.decode(raw) or nil
end)
if okLoad and type(decoded) == 'table' then
    InvShortcuts = decoded
    for k, v in pairs(InvShortcuts) do
        if type(v) == 'string' then
            InvShortcuts[k] = { name = v, label = v }
        end
    end
end

local function save()
    SetResourceKvp(KVP, json.encode(InvShortcuts))
end

local function pushToUI()
    SendNUIMessage({ action = 'shortcuts', map = InvShortcuts })
end

exports('getShortcuts', function()
    return InvShortcuts
end)

local function useShortcut(slot)
    local entry = InvShortcuts[slot]
    if type(entry) == 'table' and entry.name and entry.name ~= '' then
        ESX.TriggerServerEvent('esx:useItem', entry.name)
    end
end

RegisterNUICallback('inventory:setShortcut', function(data, cb)
    local slot = data and data.slot ~= nil and tostring(data.slot) or nil
    if slot then
        for k, v in pairs(InvShortcuts) do
            if type(v) == 'table' and v.name == data.name then
                InvShortcuts[k] = nil
            end
        end
        if data.name and data.name ~= '' then
            InvShortcuts[slot] = { name = data.name, label = data.label or data.name }
        else
            InvShortcuts[slot] = nil
        end
        save()
        pushToUI()
    end
    cb({ ok = true })
end)

RegisterNUICallback('inventory:useShortcut', function(data, cb)
    if data and data.slot ~= nil then
        useShortcut(tostring(data.slot))
    end
    cb({ ok = true })
end)

local function tryUse(slot)
    if IsNuiFocused() then return end
    if not IsControlPressed(0, 19) then return end
    useShortcut(slot)
end

for i = 0, 9 do
    AddEventHandler('KeyDown:' .. i, function()
        tryUse(tostring(i))
    end)
end
