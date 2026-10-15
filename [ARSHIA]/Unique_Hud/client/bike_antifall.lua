-- ============================================================
-- Unique_Hud / client / bike_antifall.lua
-- ============================================================
-- بلک‌لیست موتور: برای مدل‌هایی که اینجا لیست میشن، راکب هر چقدر هم تصادف کنه یا
-- بخوره زمین، از موتور پرت نمیشه (SetPedCanBeKnockedOffVehicle).
-- مدل‌های دیگه کاملاً عادی می‌مونن (بعد از پیاده شدن/سوار شدن روی مدل دیگه،
-- حالت پیش‌فرض بازی برمی‌گرده).
--
-- چطور اسم مدل رو پیدا کنم؟ (فقط ادمین‌ها) سوار همون موتور شو و تو چت بزن:  /bikemodel
-- اسم اسپان (مثلاً SANCHEZ) تو چت و F8 چاپ میشه؛ همون رو اینجا بنویس.
-- ============================================================

-- ✏️ دو مدل موتور موردنظر رو اینجا بنویس (اسم اسپان یا عدد hash):
local NoFallBikes = {
    'bf400',
    -- مدل دوم رو بعداً اینجا اضافه کن، مثلاً: 'sanchez',
}

local blocked = {}
for _, m in ipairs(NoFallBikes) do
    local hash = (type(m) == 'number') and m or GetHashKey(m)
    blocked[hash] = true
end

CreateThread(function()
    local applied = false
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and blocked[GetEntityModel(veh)] then
            -- 1 = هیچ‌وقت از وسیله پرت نشه. بازی گاهی این فلگ رو ری‌ست می‌کنه
            -- (مثلاً موقع سوار شدن/تعویض صندلی)، برای همین هر ۱۰۰ms دوباره ست میشه.
            SetPedCanBeKnockedOffVehicle(ped, 1)
            applied = true
            Wait(100)
        else
            if applied then
                SetPedCanBeKnockedOffVehicle(ped, 0) -- برگردوندن به حالت پیش‌فرض
                applied = false
            end
            Wait(500)
        end
    end
end)

-- ابزار کمکی برای گرفتن اسم دقیق مدل (فقط ادمین‌ها، سوار وسیله باشی).
-- چک ادمین سمت سرور انجام میشه (server/bike_model.lua) نه سمت کلاینت.
RegisterCommand('bikemodel', function()
    TriggerServerEvent('Unique_Hud:bikeModel:request')
end, false)

RegisterNetEvent('Unique_Hud:bikeModel:allowed', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        TriggerEvent('chat:addMessage', { args = { 'BIKE', 'اول سوار موتور شو.' } })
        return
    end
    local model = GetEntityModel(veh)
    local name = GetDisplayNameFromVehicleModel(model)
    local msg = ('model = %s | hash = %s'):format(name, tostring(model))
    print('[bikemodel] ' .. msg)
    TriggerEvent('chat:addMessage', { args = { 'BIKE', msg } })
end)
