-- Unique_Help | client
ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

-- اسم app باید با اسم ریسورس یکی باشه (UI از همین اسم برای callback ها استفاده می‌کنه)
local APP        = GetCurrentResourceName()
local IMG_DIR    = 'ui/img/guides/'
local MEDIA_DIR  = 'ui/media/'
local isOpen     = false
local prepared   = nil
local exists     = {}

-- وجود فایل داخل ریسورس (کش میشه) - برای اینکه عکس خراب نمایش داده نشه
local function fileExists(path)
    if exists[path] == nil then
        exists[path] = LoadResourceFile(GetCurrentResourceName(), path) ~= nil
    end
    return exists[path]
end

local function imageOk(rel)
    return type(rel) == 'string' and rel ~= '' and fileExists(IMG_DIR .. rel)
end

local function mediaOk(rel)
    -- ویدیو/صدا حجیمه؛ فقط وقتی فعال باشه و از تنظیمات اجازه داده شده باشه
    return UniqueHelpSettings.EnableVideos and type(rel) == 'string' and rel ~= ''
end

-- نسخه‌ی آماده‌ی کانفیگ: مسیر عکس‌ها به مسیر NUI تبدیل میشه و موارد ناموجود حذف میشن
local function prepareConfig()
    local out = { menu = UniqueHelp.menu, content = {} }

    for group, pages in pairs(UniqueHelp.content) do
        out.content[group] = {}
        for _, page in ipairs(pages) do
            local p = {}
            for k, v in pairs(page) do p[k] = v end

            p.icon = imageOk(page.icon) and ('img/guides/' .. page.icon) or UniqueHelpSettings.DefaultIcon

            if type(page.video) == 'string' then
                p.video = mediaOk(page.video) and ('media/' .. page.video) or false
            end
            if type(page.audio) == 'string' then
                p.audio = mediaOk(page.audio) and ('media/' .. page.audio) or false
            end

            p.image = {}
            for _, img in ipairs(page.image or {}) do
                local e = {}
                for k, v in pairs(img) do e[k] = v end
                if e.url then
                    if imageOk(e.url) then
                        e.url = 'img/guides/' .. e.url
                    else
                        e.url = nil
                    end
                end
                if e.url or e.text then p.image[#p.image + 1] = e end
            end

            out.content[group][#out.content[group] + 1] = p
        end
    end
    return out
end

local function openMenu(defaultId)
    if isOpen then return end
    if not prepared then prepared = prepareConfig() end

    local job = 'unemployed'
    if ESX then
        local pd = ESX.GetPlayerData()
        if pd and pd.job and pd.job.name then job = pd.job.name end
    end

    isOpen = true
    SendNUIMessage({
        app    = APP,
        method = 'open',
        data   = {
            allowed    = { job },
            helpConfig = prepared,
            defaultId  = defaultId,
        },
    })
    SetNuiFocus(true, true)
end

RegisterNetEvent('unique_help:open')
AddEventHandler('unique_help:open', function(defaultId)
    openMenu(defaultId)
end)

RegisterNUICallback('close', function(_, cb)
    isOpen = false
    SetNuiFocus(false, false)
    cb({})
end)

-- ESC یا ری‌استارت ریسورس هنگام باز بودن منو، فوکوس رو قفل نکنه
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and isOpen then
        SetNuiFocus(false, false)
    end
end)

-- ایمنی: اگه منو باز بود و بازیکن ESC زد ولی UI جواب نداد، فوکوس آزاد بشه
CreateThread(function()
    while true do
        Wait(0)
        if isOpen then
            if IsControlJustReleased(0, 200) or IsDisabledControlJustReleased(0, 200) then
                Wait(300)
                if isOpen then
                    isOpen = false
                    SetNuiFocus(false, false)
                    SendNUIMessage({ app = APP, method = 'close' })
                end
            end
        else
            Wait(500)
        end
    end
end)

exports('open', function(defaultId) openMenu(defaultId) end)
