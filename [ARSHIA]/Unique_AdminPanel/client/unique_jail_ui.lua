--[[ Unique RP - Jail picker UI | client/unique_jail_ui.lua
    Preset reasons + minutes per job (shared/jailui_config.lua), shown in the html/jailui iframe.
    The UI only collects reason + minutes; the jailing is done by the `sender` the caller passes:

      openJailMenu(job, onJailed, targetServerId, sender)       -- global + export
        sender(target, minutes, reason)    -> does the jailing (default: the server's jjjailpd command)
        onJailed(target, minutes, reason)  -> called afterwards (webhooks...)
      returns true when the UI opened.   Colour: /chatsetting -> Menus -> Jail.
]]

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local jailColor    = GetResourceKvpString('unique_jail_color') or '#e0463b'
local jailMenuOpen = false
local currentJail  = nil

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

-- everything for the jail iframe is tagged _uniqueJail: html/index.html routes it ONLY to that iframe
local function nui(payload)
    payload._uniqueJail = true
    SendNUIMessage(payload)
end

local function closeJail()
    jailMenuOpen = false
    currentJail = nil
    SetNuiFocus(false, false)
    nui({ action = 'close' })
end

AddEventHandler('unique_menu:settings', function(s)
    if type(s) == 'table' and type(s.jail) == 'table' and s.jail.color then
        jailColor = s.jail.color
        SetResourceKvp('unique_jail_color', jailColor)
        if jailMenuOpen then nui({ action = 'setColor', color = jailColor }) end
    end
end)

function openJailMenu(job, onJailed, targetServerId, sender)
    if jailMenuOpen or not ESX then return false end
    local presets = JailUIConfig and JailUIConfig.suggestionjail
    local jobData = presets and (presets[job] or presets.default)
    local target = tonumber(targetServerId)
    if not jobData or not target then
        notify(('~r~Baraye shoghle shoma (~y~%s~r~) jail tarif nashode'):format(tostring(job)))
        return false
    end
    currentJail = { maxTime = jobData.maxTime or 40, target = target, onJailed = onJailed, sender = sender }
    jailMenuOpen = true
    SetNuiFocus(true, true)
    nui({ action = 'open', job = job, color = jailColor, list = jobData.list })

    -- Esc is read from the native controls (same approach as the report panel): keyboard events
    -- don't reliably cross the iframe boundary.
    CreateThread(function()
        while jailMenuOpen do
            Wait(0)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 322) then
                closeJail()
            end
        end
    end)
    return true
end
exports('openJailMenu', openJailMenu)

RegisterNUICallback('jailPick', function(data, cb)
    local j = currentJail
    closeJail()
    cb('ok')
    if not j then return end

    local reason = tostring(data.reason or ''):gsub('%c', ' '):sub(1, 80)
    local minutes = math.floor(tonumber(data.time) or 0)
    if reason:gsub('%s', '') == '' or minutes <= 0 then return notify('~r~Etelaate jail namoatabar ast') end
    if minutes > j.maxTime then
        return notify(('~r~Zaman bayad kamtar az %s daghighe bashad'):format(j.maxTime))
    end

    local idx = GetPlayerFromServerId(j.target)
    local ped = idx ~= -1 and GetPlayerPed(idx) or 0
    if ped == 0 or not DoesEntityExist(ped) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(ped)) > 20.0 then
        return notify('~r~Fard kheyli dur ast (bishtar az 20 metr)')
    end

    if j.sender then
        j.sender(j.target, minutes, reason)
    else
        ExecuteCommand(('jjjailpd %d %d %s'):format(j.target, minutes, reason))
        notify(('~g~Player %d has been jailed.'):format(j.target))
    end
    if j.onJailed then pcall(j.onJailed, j.target, minutes, reason) end
end)

RegisterNUICallback('jailClose', function(_, cb)
    closeJail()
    cb('ok')
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and jailMenuOpen then SetNuiFocus(false, false) end
end)
