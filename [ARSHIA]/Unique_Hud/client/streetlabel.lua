-- ============================================================
-- Unique_Hud / client / streetlabel.lua  (از sun-streetlabel ادغام شد)
-- ============================================================

local UH_ESX = nil
local UH_world = 0
CreateThread(function()
    while UH_ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) UH_ESX = obj end)
        Wait(0)
    end
end)

RegisterNetEvent('esx:changeworld', function(w)
    UH_world = w
end)

CreateThread(function()
    while UH_ESX == nil do Wait(0) end
    while true do
        UH_ESX.TriggerServerCallback('sun-streetlabel:getWorld', function(w)
            UH_world = w or 0
        end)
        Wait(2000)
    end
end)

-- ✅ فیکس شد (باگ «تایم/جهت گاهی خراب میشه و عدد اعشاری روی آدرس میفته»):
-- قبلاً جهت با مقایسه‌ی |heading - مقدار| < 22.5 پیدا می‌شد و «N» فقط برای 360 تعریف
-- شده بود، نه 0. وقتی heading بین 0 تا 22.5 بود (مثلاً 0.039) هیچ جهتی مچ نمی‌شد و
-- خودِ عدد خام (0.0390246407959...) به‌جای N تو UI چاپ می‌شد - همون چیزی که تو
-- اسکرین‌شات دیده شد. الان heading نرمال میشه (0..360 با wrap) و همیشه یکی از ۸ جهت برمیگرده.
-- ترتیب خلاف عقربه‌های ساعت چون heading تو GTA از شمال به سمت غرب زیاد میشه (W = 90).
local UH_dirNames = { 'N', 'NW', 'W', 'SW', 'S', 'SE', 'E', 'NE' }

local function UH_headingToDirection(heading)
    if type(heading) ~= 'number' or heading ~= heading then return 'N' end
    local h = heading % 360.0
    local idx = math.floor((h + 22.5) / 45.0) % 8
    return UH_dirNames[idx + 1]
end

-- ساعت بازی با صفر پشت دقیقه/ساعت (قبلاً 1:5 به‌جای 01:05 نشون میداد)
local function UH_formatClock()
    return string.format('%d:%02d', GetClockHours(), GetClockMinutes())
end

local UH_isGpsOn = true
local UH_isLoaded = false
local UH_streetHash1, UH_streetHash2, UH_playerDirection
local UH_accountId = 0
local UH_ts = 0

local function UH_sendUIMessage(data)
    data.type = 'streetLabel:MSG'
    SendNUIMessage(data)
end

RegisterCommand('gps', function()
    if GetResourceKvpInt('gps') == 1 then
        SetResourceKvpInt('gps', 0)
        UH_isLoaded = false
    else
        SetResourceKvpInt('gps', 1)
        UH_isLoaded = true
    end
end, false)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/gps', 'Toggle street label', {})
    UH_isLoaded = GetResourceKvpInt('gps') == 1

    while UH_ESX == nil do Wait(0) end

    -- ✅ محافظت اضافه: حتی با فیکس سمت سرور، اگه به هر دلیلی بار اول 0
    -- برگشت، چندبار دیگه هم امتحان می‌کنه به‌جای اینکه برای همیشه رو 0 بمونه.
    local function RequestAccountId(attempt)
        UH_ESX.TriggerServerCallback('sun-streetlabel:getAccountId', function(id)
            UH_accountId = id or 0
            if UH_accountId == 0 and attempt < 6 then
                Citizen.SetTimeout(1500, function()
                    RequestAccountId(attempt + 1)
                end)
            end
        end)
    end
    RequestAccountId(1)

    UH_ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
        UH_ts = time or UH_ts
    end)

    local svID = GetPlayerServerId(PlayerId())

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local zone = GetNameOfZone(coords.x, coords.y, coords.z)
        local zoneLabel = GetLabelText(zone)
        local street2 = ''

        if UH_isGpsOn then
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            UH_streetHash1 = GetStreetNameFromHashKey(var1)
            UH_streetHash2 = GetStreetNameFromHashKey(var2)
            UH_playerDirection = UH_headingToDirection(GetEntityHeading(ped))

            street2 = (UH_streetHash2 == '') and zoneLabel or (UH_streetHash2 .. ', ' .. zoneLabel)
        end

        UH_sendUIMessage({
            active = UH_isLoaded,
            direction = UH_playerDirection,
            zone = UH_streetHash1,
            street = street2,
            time = UH_formatClock(),
            ts = UH_ts .. ' | ' .. UH_accountId .. ' | W' .. UH_world .. ' | ID : ',
            src = svID,
            server = (UH_ESX.serverNum == 1) and '*' or '**',
            hud = true,
        })

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        UH_ts = UH_ts + 1
    end
end)

CreateThread(function()
    while true do
        -- اگه اولین گرفتن زمان سرور جواب نداده بود (ts هنوز ۰ یا خیلی کوچیکه)،
        -- هر ۳ ثانیه دوباره امتحان کن به‌جای اینکه ۶۰ ثانیه عدد خراب نشون بدیم.
        Wait((UH_ts or 0) < 1000000000 and 3000 or 60000)
        if UH_ESX then
            UH_ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
                if time then UH_ts = time end
            end)
        end
    end
end)
