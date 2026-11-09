--[[
    Nexora RP - Help Menu Client Side
]]

-- دریافت ESX Object
ESX = exports['es_extended']:getSharedObject()

-- ========================================
-- توابع کمکی
-- ========================================
local function openMenu(data)
    SendNUIMessage({
        app = 'sun-helpmenu',
        method = 'open',
        data = data
    })
    SetNuiFocus(true, true)
end

-- ========================================
-- دریافت ایونت از سرور برای باز کردن منو
-- ========================================
RegisterNetEvent('nexora:help:openMenu')
AddEventHandler('nexora:help:openMenu', function(defaultId)
    local playerData = ESX.GetPlayerData()
    
    openMenu({
        allowed = { playerData.job.name },
        helpConfig = helpConfig,
        defaultId = defaultId,
    })
end)

-- ========================================
-- بستن منو با NUI Callback
-- ========================================
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- ========================================
-- Export برای استفاده در سایر اسکریپت‌های کلاینت
-- ========================================
exports('open', function(data)
    openMenu(data)
end)

exports('openWithPage', function(defaultId)
    local playerData = ESX.GetPlayerData()
    
    openMenu({
        allowed = { playerData.job.name },
        helpConfig = helpConfig,
        defaultId = defaultId,
    })
end)

-- ========================================
-- پیام هنگام لود شدن اسکریپت
-- ========================================
print('[Nexora RP Help] ✅ Client Side Loaded Successfully')