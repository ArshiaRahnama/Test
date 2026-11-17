--[[ Unique RP - Ghabz (fine presets UI) | esx_billing/client/ghabz.lua
    Sunset-style fine picker: search + pinned presets + manual reason/amount + confirm box.
    Presets live in config.lua (Config.suggestionghabz, per job). Colour comes from /chatsetting -> Menus -> Ghabz.

    From a job script:
        exports['esx_billing']:openGhabzMenu('sheriff', onSent, targetServerId, sender)
        onSent(target, reason, amount)  |  targetServerId and sender are optional
        sender(target, account, reason, amount) replaces the default esx_billing:send2Bill call
    returns true when the UI opened (false = no presets for that job / nobody close enough).
]]

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local billingColor = GetResourceKvpString('unique_billing_color') or '#65aeff'
local ghabzOpen    = false
local currentGhabz = nil

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

AddEventHandler('unique_menu:settings', function(s)
    if type(s) == 'table' and type(s.ghabz) == 'table' and s.ghabz.color then
        billingColor = s.ghabz.color
        SetResourceKvp('unique_billing_color', billingColor)
        if ghabzOpen then SendNUIMessage({ action = 'setColor', color = billingColor }) end
    end
end)

function openGhabzMenu(job, onSent, targetServerId, sender)
    if ghabzOpen or not ESX then return false end
    local jobData = Config.suggestionghabz and Config.suggestionghabz[job]
    if not jobData then
        notify(('~r~Baraye shoghle shoma (~y~%s~r~) hich ghabze pishnahadi tarif nashode'):format(tostring(job)))
        return false
    end

    local target = tonumber(targetServerId)
    if not target then
        local player, distance = ESX.Game.GetClosestPlayer()
        if player == -1 or distance > 3.0 then
            notify('~r~Kasi Baraye Ghabz Nazdike Shoma Nist.')
            return false
        end
        target = GetPlayerServerId(player)
    end

    currentGhabz = {
        account   = jobData.account ~= nil and jobData.account or ('society_' .. job),
        maxAmount = jobData.maxAmount or 50000,
        target    = target,
        onSent    = onSent,
        sender    = sender,        -- optional: function(target, account, reason, amount) replaces esx_billing:send2Bill
    }
    ghabzOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', job = job, color = billingColor, list = jobData.list })
    return true
end
exports('openGhabzMenu', openGhabzMenu)

RegisterNUICallback('ghabzPick', function(data, cb)
    ghabzOpen = false
    SetNuiFocus(false, false)
    cb('ok')

    local g = currentGhabz
    currentGhabz = nil
    if not g then return end

    local reason = tostring(data.reason or ''):sub(1, 80)
    local amount = math.floor(tonumber(data.amount) or 0)
    if reason == '' or amount <= 0 then return notify('~r~Ghabz namoatabar ast') end
    if amount > g.maxAmount then
        return notify(('~r~Mablagh bayad kamtar az %s$ bashad'):format(ESX.Math.GroupDigits(g.maxAmount)))
    end

    local idx = GetPlayerFromServerId(g.target)
    local ped = idx ~= -1 and GetPlayerPed(idx) or 0
    if ped == 0 or not DoesEntityExist(ped) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(ped)) > 10.0 then
        return notify('~r~Fard kheyli dur ast')
    end

    if g.sender then
        g.sender(g.target, g.account, reason, amount)
    else
        TriggerServerEvent('esx_billing:send2Bill', g.target, g.account, reason, amount)
        notify('~g~Ghabz ba movafaghiat ersal shod.')
    end
    if g.onSent then pcall(g.onSent, g.target, reason, amount) end
end)

RegisterNUICallback('ghabzClose', function(_, cb)
    ghabzOpen = false
    currentGhabz = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and ghabzOpen then SetNuiFocus(false, false) end
end)
