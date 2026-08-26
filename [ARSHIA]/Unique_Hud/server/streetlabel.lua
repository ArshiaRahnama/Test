-- ============================================================
-- Unique_Hud / server / streetlabel.lua  (از sun-streetlabel ادغام شد)
-- ============================================================

local UH_ESX = nil
CreateThread(function()
    while UH_ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) UH_ESX = obj end)
        Wait(0)
    end
end)

while UH_ESX == nil do Wait(0) end
while MySQL == nil do Wait(0) end

UH_ESX.RegisterServerCallback('sun-streetlabel:getWorld', function(source, cb)
    cb(GetPlayerRoutingBucket(source) or 0)
end)

-- account_num: ستون AUTO_INCREMENT موجود تو جدول users. برای اکانت‌های قدیمی
-- (که قبل از اضافه شدن این ستون ساخته شدن)، MySQL به‌جای شماره‌ی واقعی مقدار
-- 0 گذاشته - این خودِ خاصیت AUTO_INCREMENT هست، نه باگ کدی. اینجا خودش رو
-- ترمیم می‌کنه: هر حسابی که account_num=0 داره، همون لحظه که وصل میشه یه بار
-- برای همیشه شماره‌ی واقعی و یکتا می‌گیره.
--
-- ✅ فیکس شد (بار سوم): مشکل باقی‌مونده یه race condition بود - بار اولی که
-- یه پلیر تازه وصل میشه، ممکنه xPlayer هنوز کامل ساخته نشده باشه (identifier
-- نال) دقیقاً همون لحظه‌ای که این callback صدا زده میشه. الان تا ۱۵ بار (هر
-- نیم‌ثانیه) صبر می‌کنه تا xPlayer واقعاً آماده بشه، به‌علاوه‌ی print برای
-- دیباگ - اگه بازم مشکلی بود، این پرینت‌ها تو کنسول سرور دقیق نشون می‌دن کجا
-- گیر کرده.
UH_ESX.RegisterServerCallback('sun-streetlabel:getAccountId', function(source, cb)
    local xPlayer = nil
    for i = 1, 15 do
        xPlayer = UH_ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.identifier then break end
        Wait(500)
        xPlayer = nil
    end

    if not xPlayer or not xPlayer.identifier then
        print('[Unique_Hud] getAccountId: xPlayer/identifier آماده نشد برای source=' .. tostring(source))
        return cb(0)
    end

    local ok, row = pcall(function()
        return MySQL.single.await('SELECT account_num FROM users WHERE identifier = ?', { xPlayer.identifier })
    end)

    if not ok or not row then
        print('[Unique_Hud] getAccountId: SELECT اولیه fail شد برای identifier=' .. tostring(xPlayer.identifier) .. ' ok=' .. tostring(ok))
        return cb(0)
    end

    if row.account_num and row.account_num ~= 0 then
        return cb(row.account_num)
    end

    local fixOk, fixErr = pcall(function()
        -- ساب‌کوئری داخل یه derived table (AS t) لازمه چون MySQL اجازه نمیده
        -- مستقیم از همون جدولی که داره UPDATE میشه SELECT بزنی.
        MySQL.update.await([[
            UPDATE users
            SET account_num = (SELECT next_num FROM (SELECT COALESCE(MAX(account_num), 0) + 1 AS next_num FROM users) AS t)
            WHERE identifier = ? AND account_num = 0
        ]], { xPlayer.identifier })
    end)

    if not fixOk then
        print('[Unique_Hud] getAccountId: UPDATE بک‌فیل fail شد: ' .. tostring(fixErr))
    end

    if fixOk then
        local okAfter, rowAfter = pcall(function()
            return MySQL.single.await('SELECT account_num FROM users WHERE identifier = ?', { xPlayer.identifier })
        end)
        if okAfter and rowAfter and rowAfter.account_num then
            return cb(rowAfter.account_num)
        end
    end

    print('[Unique_Hud] getAccountId: نهایتاً 0 برگشت برای identifier=' .. tostring(xPlayer.identifier))
    cb(0)
end)

UH_ESX.RegisterServerCallback('sun-streetlabel:getServerTime', function(source, cb)
    cb(os.time())
end)
