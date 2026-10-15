-- ============================================================
-- Unique_Hud / server / bike_model.lua
-- ============================================================
-- چک ادمین برای کامند /bikemodel (کلاینت فقط درخواست می‌فرسته؛ تصمیم اینجاست،
-- پس با تغییر کلاینت قابل دور زدن نیست).

local BM_ESX = nil
CreateThread(function()
    while BM_ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) BM_ESX = obj end)
        Wait(0)
    end
end)

-- ادمین بودن مثل بقیه‌ی سرور با xPlayer.permission_level چک میشه
-- (permission_level >= 1 یعنی حداقل ادمین). اگه حداقل رتبه‌ی دیگه‌ای می‌خوای اینو عوض کن.
local MIN_PERMISSION_LEVEL = 1

RegisterNetEvent('Unique_Hud:bikeModel:request', function()
    local src = source
    if not BM_ESX then return end
    local xPlayer = BM_ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local perm = tonumber(xPlayer.permission_level) or 0
    if perm >= MIN_PERMISSION_LEVEL then
        TriggerClientEvent('Unique_Hud:bikeModel:allowed', src)
    else
        TriggerClientEvent('chat:addMessage', src, { args = { 'BIKE', 'این کامند فقط برای ادمین‌هاست.' } })
    end
end)
