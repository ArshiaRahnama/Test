--[[
    ========================================
    Nexora RP - Help Menu System
    Server Side Script
    Developed for Nexora RP
    ========================================
]]

-- دریافت ESX Object (روش جدید و استاندارد)
ESX = exports['es_extended']:getSharedObject()

-- ========================================
-- بخش 1: ثبت کامند /help از سمت سرور
-- ========================================
RegisterCommand('help', function(source, args, rawCommand)
    -- بررسی اینکه بازیکن وجود داره
    if source == 0 then
        print('[Nexora RP Help] ❌ Command cannot be used from server console')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print(string.format('[Nexora RP Help] ❌ Player with ID %s not found', source))
        return
    end
    
    -- لاگ استفاده از کامند
    print(string.format('[Nexora RP Help] ✅ Player %s (ID: %s) used /help command', 
        xPlayer.getName(), source))
    
    -- ارسال ایونت به کلاینت برای باز کردن منو
    TriggerClientEvent('nexora:help:openMenu', source, nil)
end, false)

-- ========================================
-- بخش 2: ایونت‌های سرور برای باز کردن منو
-- ========================================
-- باز کردن منو برای خود بازیکن
RegisterNetEvent('nexora:help:serverOpen')
AddEventHandler('nexora:help:serverOpen', function(defaultId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        print(string.format('[Nexora RP Help] ❌ Cannot open menu - Player ID %s not found', src))
        return
    end
    
    -- لاگ
    if defaultId then
        print(string.format('[Nexora RP Help] 📖 Opening help menu for %s (ID: %s) with default page: %s', 
            xPlayer.getName(), src, defaultId))
    else
        print(string.format('[Nexora RP Help] 📖 Opening help menu for %s (ID: %s)', 
            xPlayer.getName(), src))
    end
    
    -- ارسال به کلاینت
    TriggerClientEvent('nexora:help:openMenu', src, defaultId)
end)

-- باز کردن منو برای یک بازیکن خاص (توسط ادمین یا اسکریپت دیگه)
RegisterNetEvent('nexora:help:openForPlayer')
AddEventHandler('nexora:help:openForPlayer', function(targetId, defaultId)
    local src = source
    local xPlayerSrc = ESX.GetPlayerFromId(src)
    local xPlayerTarget = ESX.GetPlayerFromId(targetId)
    
    if not xPlayerSrc then
        print('[Nexora RP Help] ❌ Source player not found')
        return
    end
    
    if not xPlayerTarget then
        print(string.format('[Nexora RP Help] ❌ Target player ID %s not found', targetId))
        TriggerClientEvent('esx:showNotification', src, '~r~بازیکن مورد نظر یافت نشد')
        return
    end
    
    -- لاگ
    print(string.format('[Nexora RP Help] 📤 %s (ID: %s) opened help menu for %s (ID: %s)', 
        xPlayerSrc.getName(), src, xPlayerTarget.getName(), targetId))
    
    -- ارسال به کلاینت مقصد
    TriggerClientEvent('nexora:help:openMenu', targetId, defaultId)
    
    -- پیام تایید برای فرستنده
    TriggerClientEvent('esx:showNotification', src, 
        string.format('~g~منوی راهنما برای %s باز شد', xPlayerTarget.getName()))
end)

-- ========================================
-- بخش 3: Export برای استفاده سایر اسکریپت‌ها
-- ========================================
--[[
    نحوه استفاده در سایر اسکریپت‌ها:
    
    -- باز کردن منو برای یک بازیکن
    exports['nexora_help']:OpenHelpMenu(playerId, defaultId)
    
    -- مثال:
    exports['nexora_help']:OpenHelpMenu(5, 'bank')  -- منوی بانک رو برای بازیکن 5 باز می‌کنه
]]

exports('OpenHelpMenu', function(playerId, defaultId)
    if not playerId then
        print('[Nexora RP Help] ❌ OpenHelpMenu: playerId is required')
        return false
    end
    
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        print(string.format('[Nexora RP Help] ❌ OpenHelpMenu: Player ID %s not found', playerId))
        return false
    end
    
    TriggerClientEvent('nexora:help:openMenu', playerId, defaultId)
    return true
end)

-- Export برای دریافت لیست بازیکنان آنلاین (اختیاری - برای آمار)
exports('GetOnlinePlayersCount', function()
    return #ESX.GetPlayers()
end)

-- ========================================
-- بخش 4: رویدادهای ورود و خروج بازیکن
-- ========================================
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    print(string.format('[Nexora RP] 🎮 Player loaded: %s (ID: %s)', 
        xPlayer.getName(), playerId))
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        print(string.format('[Nexora RP] 👋 Player disconnected: %s (ID: %s) - Reason: %s', 
            xPlayer.getName(), src, reason))
    end
end)

-- ========================================
-- بخش 5: پیام خوش‌آمدگویی هنگام ورود
-- ========================================
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    -- بعد از 5 ثانیه پیام راهنما رو نمایش بده
    SetTimeout(5000, function()
        local currentPlayer = ESX.GetPlayerFromId(playerId)
        if currentPlayer then
            TriggerClientEvent('esx:showNotification', playerId, 
                '~g~به Nexora RP خوش آمدید!~s~\nبرای راهنما از کامند ~y~/help~s~ استفاده کنید')
        end
    end)
end)

-- ========================================
-- بخش 6: کامند ادمین برای باز کردن منو برای دیگران
-- ========================================
RegisterCommand('openhelp', function(source, args, rawCommand)
    if source == 0 then
        print('[Nexora RP Help] ❌ This command must be used in-game')
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- بررسی دسترسی ادمین (می‌تونی گروه‌های مجاز رو تغییر بدی)
    local allowedGroups = {'admin', 'superadmin', 'mod'}
    local playerGroup = xPlayer.getGroup()
    local hasPermission = false
    
    for _, group in ipairs(allowedGroups) do
        if playerGroup == group then
            hasPermission = true
            break
        end
    end
    
    if not hasPermission then
        TriggerClientEvent('esx:showNotification', source, '~r~شما دسترسی به این کامند را ندارید')
        return
    end
    
    -- بررسی آرگومان‌ها
    if not args[1] then
        TriggerClientEvent('esx:showNotification', source, '~r~استفاده: /openhelp [playerId] [pageId]')
        return
    end
    
    local targetId = tonumber(args[1])
    local defaultId = args[2] or nil
    
    if not targetId then
        TriggerClientEvent('esx:showNotification', source, '~r~شناسه بازیکن نامعتبر است')
        return
    end
    
    -- ارسال ایونت
    TriggerEvent('nexora:help:openForPlayer', targetId, defaultId)
    
    print(string.format('[Nexora RP Help] 🔧 Admin %s used /openhelp for player %s', 
        xPlayer.getName(), targetId))
end, false)

-- ========================================
-- پایان اسکریپت
-- ========================================
print('[Nexora RP Help] ✅ Help Menu Server Side Loaded Successfully')
print('[Nexora RP Help] 📖 Commands: /help, /openhelp [admin]')