-- ================================================================= --
-- EVENT TAB — نمایش همه‌ی ایونت‌های ریسورس Unique_Event (WarZone,
-- GunGame, Capture) داخل منوی HUD.
-- فقط SELECT (read-only) روی جدول‌هایی که خودِ ماژول‌ها از قبل می‌سازن.
-- اگه جدولی وجود نداشته باشه (مثلاً GunGame با UseDatabase=false) اون
-- ایونت فقط بدون لیدربورد نشون داده میشه و منو خراب نمیشه.
-- ================================================================= --

local EventDefs = {
    {
        id = 'warzone', name = 'وار زون', nameEn = 'WARZONE', icon = 'fa-skull-crossbones',
        color = '#ff9d2f', cmd = '/wz', desc = 'بتل‌رویال تیمی؛ اسکواد ببند و آخرین نفر باش.',
        sql = 'SELECT name, kills, wins FROM wz_leaderboard ORDER BY kills DESC LIMIT 5',
        sumSql = 'SELECT COUNT(*) AS players, COALESCE(SUM(kills),0) AS kills, COALESCE(SUM(wins),0) AS wins FROM wz_leaderboard',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'wins', label = 'برد' } },
    },
    {
        id = 'gungame', name = 'گان گیم', nameEn = 'GUNGAME', icon = 'fa-gun',
        color = '#39ff6a', cmd = '/jgg', desc = 'با هر کیل یه اسلحه‌ی جدید؛ اولین نفر که به آخر برسه برنده‌ست.',
        sql = 'SELECT name, kills, wins FROM unique_gungame_stats ORDER BY kills DESC LIMIT 5',
        sumSql = 'SELECT COUNT(*) AS players, COALESCE(SUM(kills),0) AS kills, COALESCE(SUM(wins),0) AS wins FROM unique_gungame_stats',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'wins', label = 'برد' } },
    },
    {
        id = 'capture', name = 'کپچر گنگ‌ها', nameEn = 'CAPTURE', icon = 'fa-flag',
        color = '#ff5468', cmd = '/joinCap', desc = 'گنگ‌ها برای تصرف زون‌ها می‌جنگن.',
        sql = 'SELECT name, kills, gang_points AS points FROM capture_player_stats ORDER BY kills DESC LIMIT 5',
        sumSql = 'SELECT COUNT(*) AS players, COALESCE(SUM(kills),0) AS kills, COALESCE(SUM(gang_points),0) AS wins FROM capture_player_stats',
        cols = { { key = 'kills', label = 'کیل' }, { key = 'points', label = 'امتیاز' } },
    },
}

local function query(sql, cb)
    local done = false
    local function finish(rows)
        if done then return end
        done = true
        cb(rows)
    end
    SetTimeout(2500, function() finish(nil) end)
    local ok = pcall(function()
        MySQL.Async.fetchAll(sql, {}, function(rows) finish(rows) end)
    end)
    if not ok then finish(nil) end
end

ESX.RegisterServerCallback('HUD_Menu:GetEvents', function(source, cb)
    local out, pending = {}, #EventDefs * 2
    local function step()
        pending = pending - 1
        if pending == 0 then cb({ events = out }) end
    end

    for i, def in ipairs(EventDefs) do
        local ev = {
            id = def.id, name = def.name, nameEn = def.nameEn, icon = def.icon,
            color = def.color, cmd = def.cmd, desc = def.desc, cols = def.cols,
            top = {}, summary = nil, queue = nil,
        }
        out[i] = ev

        if def.id == 'gungame' then
            local ok, q = pcall(function() return exports['Unique_Event']:GetQueueSize() end)
            if ok and type(q) == 'number' then ev.queue = q end
        end

        query(def.sql, function(rows) ev.top = rows or {}; step() end)
        query(def.sumSql, function(rows) ev.summary = rows and rows[1] or nil; step() end)
    end
end)
