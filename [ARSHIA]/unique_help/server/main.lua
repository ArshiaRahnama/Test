-- Unique_Help | server
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local S = UniqueHelpSettings

local function openFor(target, pageId)
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return false end
    TriggerClientEvent('unique_help:open', target, pageId)
    return true
end

-- /help
RegisterCommand(S.Command, function(source, args)
    if source == 0 then return end
    openFor(source, args[1])
end, false)

-- /openhelp [id] [pageId]  (فقط گروه‌های ادمین)
RegisterCommand(S.AdminCommand, function(source, args)
    if source == 0 then
        print('[Unique_Help] این کامند فقط داخل بازی قابل استفاده است')
        return
    end

    local xPlayer = ESX and ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local allowed = false
    local group = xPlayer.getGroup()
    for _, g in ipairs(S.AdminGroups) do
        if g == group then allowed = true break end
    end
    if not allowed then
        xPlayer.showNotification('~r~شما دسترسی به این کامند را ندارید')
        return
    end

    if not args[1] then
        xPlayer.showNotification('~r~استفاده: /' .. S.AdminCommand .. ' [playerId] [pageId]')
        return
    end

    if openFor(args[1], args[2]) then
        xPlayer.showNotification('~g~منوی راهنما برای بازیکن ' .. args[1] .. ' باز شد')
    else
        xPlayer.showNotification('~r~بازیکن مورد نظر یافت نشد')
    end
end, false)

-- exports['Unique_Help']:OpenHelpMenu(playerId, pageId)
exports('OpenHelpMenu', function(playerId, pageId)
    return openFor(playerId, pageId)
end)

if S.Welcome then
    AddEventHandler('esx:playerLoaded', function(playerId)
        SetTimeout(5000, function()
            if GetPlayerName(playerId) then
                TriggerClientEvent('esx:showNotification', playerId, S.WelcomeText)
            end
        end)
    end)
end
