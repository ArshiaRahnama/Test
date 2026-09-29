ESX = nil
TriggerEvent(HubConfig.ESX, function(obj) ESX = obj end)

--[[
    این تنها کاری که سمت سرورِ هاب انجام میده: سطح پرمیژن پلیر رو
    برمیگردونه تا کلاینت بدونه کدوم دکمه‌های «شروع رویداد» رو نشون بده.

    توجه: این فقط ظاهریه. چک واقعیِ پرمیژن، همونطور که همیشه بوده،
    داخل خودِ ماژول‌های warzone / gungame / capture انجام میشه
    (دقیقاً همون کدی که قبلاً بود، دست‌نخورده). یعنی حتی اگه یکی با
    ترفند این دکمه رو ببینه یا کامند رو دستی بزنه، خودِ منطق اصلی
    جلوشو میگیره - اینجا هیچ دری باز نمیشه.
]]
ESX.RegisterServerCallback('Unique_Event:getAccess', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb({ permission_level = 0 })
        return
    end
    cb({ permission_level = xPlayer.permission_level or 0 })
end)

--[[
    پنل آمار یکپارچه‌ی هاب. این فقط SELECT میزنه (read-only) روی همون
    جدول‌هایی که خودِ هر ماژول از قبل میسازه - هیچ جدول جدیدی نمیسازه و
    هیچ چیزی رو تغییر نمیده. اگه اسم جدول/ستون رو تو ماژول اصلی عوض
    کردی، همینجا هم باید عوض کنی.
]]
local StatsQueries = {
    warzone = {
        sql = 'SELECT name, kills, wins, deaths FROM wz_leaderboard ORDER BY kills DESC LIMIT 10',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'wins', label = 'برد' }, { key = 'deaths', label = 'مرگ' } },
    },
    gungame = {
        sql = 'SELECT name, kills, wins, matches_played AS matches FROM unique_gungame_stats ORDER BY kills DESC LIMIT 10',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'wins', label = 'برد' }, { key = 'matches', label = 'بازی' } },
    },
    capture = {
        sql = 'SELECT name, kills, gang_points, top5_count FROM capture_player_stats ORDER BY kills DESC LIMIT 10',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'gang_points', label = 'امتیاز گنگ' }, { key = 'top5_count', label = 'تاپ ۵' } },
    },
}

ESX.RegisterServerCallback('Unique_Event:getStats', function(source, cb, eventId)
    local q = StatsQueries[eventId]
    if not q then
        cb({ cols = {}, rows = {} })
        return
    end

    -- GunGame only creates/uses its stats table when GGConfig.UseDatabase is
    -- on (see modules/gungame/server.lua). If it's off the table doesn't
    -- exist, so don't query it - just report no stats.
    if eventId == 'gungame' and not GGConfig.UseDatabase then
        cb({ cols = q.cols, rows = {} })
        return
    end

    exports.oxmysql:query(q.sql, {}, function(rows)
        cb({ cols = q.cols, rows = rows or {} })
    end)
end)

