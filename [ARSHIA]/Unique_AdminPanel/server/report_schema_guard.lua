--[[ ===========================================================================
    Unique RP - Report System | server/report_schema_guard.lua
    arshiahub.ir

    ⚠ باید همون اول server_scripts لود بشه (بعد از esm_callback_bridge.lua،
      قبل از report_function.lua / report_main.lua).

    ---------------------------------------------------------------------------
    چرا این فایل وجود داره
    ---------------------------------------------------------------------------
    لاگِ واقعیِ سرور:

        Unable to execute a query!
        Unknown column 'r.target_identifier' in 'field list'

    یعنی sql/reports.sql بعد از آپدیتِ آخر (که ستون‌های target_identifier /
    target_name / admin_note رو اضافه کرد) دوباره روی دیتابیس اجرا نشده بود.
    نتیجه: getAll کاملاً fail می‌شد و صفِ ادمین همیشه خالی می‌موند - بدونِ
    هیچ خطای قابل‌دیدنی تو خودِ بازی، فقط تو کنسولِ سرور.

    این کلاسِ باگ («یادم رفت SQL جدید رو import کنم») خیلی رایجه و کاملاً
    قابلِ پیشگیریه. این فایل به‌جای اینکه دوباره از همه بخواد یادش بمونه
    فایلِ SQL رو دستی اجرا کنه، خودش موقعِ استارت چک می‌کنه هر ستون/جدولی
    که کدِ ریسورس بهش نیاز داره وجود داره یا نه، و اگه نبود خودش می‌سازتش.
    از این به بعد آپدیت کردنِ ریسورس یعنی فقط کپی کردنِ فایل‌ها - دیگه
    هیچ‌وقت لازم نیست یادت بمونه SQL رو دستی بزنی.
=========================================================================== ]]

local RES = GetCurrentResourceName()

-- ---------------------------------------------------------- ستون‌ها ---
-- هر ردیف: {جدول, ستون, تعریفِ کاملِ ستون برای ALTER TABLE ... ADD COLUMN}
local REQUIRED_COLUMNS = {
    { 'reports', 'category',           "VARCHAR(32)  DEFAULT 'other'" },
    { 'reports', 'priority',           "TINYINT(2)   DEFAULT 1" },
    { 'reports', 'admin_name',         "VARCHAR(128) DEFAULT NULL" },
    { 'reports', 'meta',               "TEXT         DEFAULT NULL" },
    { 'reports', 'rating',             "TINYINT(2)   DEFAULT 0" },
    { 'reports', 'sla_warned',         "TINYINT(1)   DEFAULT 0" },
    { 'reports', 'accepted_at',        "INT(11)      DEFAULT 0" },
    { 'reports', 'closed_at',          "INT(11)      DEFAULT 0" },
    { 'reports', 'target_identifier',  "VARCHAR(64)  DEFAULT NULL" },
    { 'reports', 'target_name',        "VARCHAR(128) DEFAULT NULL" },
    { 'reports', 'admin_note',         "TEXT         DEFAULT NULL" },
    { 'users',   Config_Server and Config_Server.AdminXPColumn or 'unique_admin_xp',
                                        "INT(11) NOT NULL DEFAULT 0" },
}

local REQUIRED_INDEXES = {
    { 'reports', 'idx_target_created', '(`target_identifier`, `created_at`)' },
    { 'reports', 'idx_status',         '(`status`)' },
    { 'reports', 'idx_identifier',     '(`identifier`)' },
    { 'reports', 'idx_admin',          '(`admin`)' },
    { 'reports', 'idx_created',        '(`created_at`)' },
}

-- ---------------------------------------------------- جدول‌های جدید ---
-- CREATE TABLE IF NOT EXISTS خودش idempotent-ه، پس همیشه امن اجرا میشه؛
-- نیازی به چکِ INFORMATION_SCHEMA نداره.
local CREATE_TABLES = {
    [[
    CREATE TABLE IF NOT EXISTS `admin_report_ratings` (
      `id`         INT(11)      NOT NULL AUTO_INCREMENT,
      `report_id`  VARCHAR(32)  DEFAULT NULL,
      `admin_name` VARCHAR(128) DEFAULT NULL,
      `rating`     TINYINT(2)   DEFAULT NULL,
      `created_at` DATETIME     DEFAULT NULL,
      PRIMARY KEY (`id`),
      KEY `idx_admin` (`admin_name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    ]],
    [[
    CREATE TABLE IF NOT EXISTS `admin_report_response_times` (
      `id`               INT(11)      NOT NULL AUTO_INCREMENT,
      `admin_name`       VARCHAR(128) DEFAULT NULL,
      `response_seconds` INT(11)      DEFAULT NULL,
      `created_at`       DATETIME     DEFAULT NULL,
      PRIMARY KEY (`id`),
      KEY `idx_admin` (`admin_name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    ]],
    [[
    CREATE TABLE IF NOT EXISTS `admin_xp_log` (
      `id`         INT(11)      NOT NULL AUTO_INCREMENT,
      `identifier` VARCHAR(64)  DEFAULT NULL,
      `amount`     INT(11)      DEFAULT 0,
      `reason`     VARCHAR(64)  DEFAULT NULL,
      `created_at` INT(11)      DEFAULT 0,
      PRIMARY KEY (`id`),
      KEY `idx_identifier_created` (`identifier`, `created_at`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    ]],
    [[
    CREATE TABLE IF NOT EXISTS `admin_streak_state` (
      `identifier`        VARCHAR(64) NOT NULL,
      `current_streak`    INT(11)     DEFAULT 0,
      `last_bonus_streak` INT(11)     DEFAULT 0,
      `updated_at`        INT(11)     DEFAULT 0,
      PRIMARY KEY (`identifier`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    ]],
}

-- ================================================================ اجرا ===

SchemaGuard = { ready = false, log = {} }

local function columnExists(table_, column)
    local rows = MySQL.Sync.fetchAll([[
        SELECT COUNT(*) AS n FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = @c
    ]], { ['@t'] = table_, ['@c'] = column })
    return rows and rows[1] and tonumber(rows[1].n) > 0
end

local function indexExists(table_, indexName)
    local rows = MySQL.Sync.fetchAll([[
        SELECT COUNT(*) AS n FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND INDEX_NAME = @i
    ]], { ['@t'] = table_, ['@i'] = indexName })
    return rows and rows[1] and tonumber(rows[1].n) > 0
end

local function tableExists(table_)
    local rows = MySQL.Sync.fetchAll([[
        SELECT COUNT(*) AS n FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t
    ]], { ['@t'] = table_ })
    return rows and rows[1] and tonumber(rows[1].n) > 0
end

local function runMigration()
    if not tableExists('reports') then
        -- نصب کاملاً تازه‌ست - sql/reports.sql هنوز اصلاً اجرا نشده. اینجا
        -- کاری نمی‌کنیم (خودِ CREATE TABLE اصلی تو reports.sql هست)، فقط
        -- هشدار واضح می‌دیم تا معلوم باشه مشکل از کجاست.
        print(('^1[%s]^0 جدولِ `reports` اصلاً وجود نداره. sql/reports.sql رو import کن، بعد ریسورس رو ری‌استارت کن.'):format(RES))
        return
    end

    local addedCols, addedIdx, addedTables = 0, 0, 0

    for _, def in ipairs(REQUIRED_COLUMNS) do
        local table_, column, definition = def[1], def[2], def[3]
        local ok, exists = pcall(columnExists, table_, column)
        if ok and not exists then
            local alterOk, err = pcall(function()
                MySQL.Sync.execute(("ALTER TABLE `%s` ADD COLUMN `%s` %s"):format(table_, column, definition), {})
            end)
            if alterOk then
                addedCols = addedCols + 1
                print(('^3[%s]^0 ستونِ جدید اضافه شد: %s.%s'):format(RES, table_, column))
            else
                print(('^1[%s]^0 نتونستم ستونِ %s.%s رو اضافه کنم: %s'):format(RES, table_, column, tostring(err)))
            end
        elseif not ok then
            print(('^1[%s]^0 چکِ وجودِ ستونِ %s.%s ناموفق بود: %s'):format(RES, table_, column, tostring(exists)))
        end
    end

    for _, def in ipairs(REQUIRED_INDEXES) do
        local table_, indexName, cols = def[1], def[2], def[3]
        local ok, exists = pcall(indexExists, table_, indexName)
        if ok and not exists then
            local alterOk, err = pcall(function()
                MySQL.Sync.execute(("ALTER TABLE `%s` ADD INDEX `%s` %s"):format(table_, indexName, cols), {})
            end)
            if alterOk then
                addedIdx = addedIdx + 1
            end
            -- ایندکس نبودن باعث خطا نمیشه، فقط کندتره - شکستش fatal نیست، لاگ نمی‌کنیم که شلوغ نشه
        end
    end

    for _, createSql in ipairs(CREATE_TABLES) do
        local ok, err = pcall(function() MySQL.Sync.execute(createSql, {}) end)
        if not ok then
            print(('^1[%s]^0 ساختِ یکی از جدول‌های آماری ناموفق بود: %s'):format(RES, tostring(err)))
        else
            addedTables = addedTables + 1
        end
    end

    if addedCols > 0 or addedIdx > 0 then
        print(('^2[%s]^0 اسکیمای دیتابیس خودکار به‌روز شد: %d ستونِ جدید، %d ایندکسِ جدید.'):format(RES, addedCols, addedIdx))
    end

    SchemaGuard.ready = true
end

-- MySQL.ready تضمین می‌کنه oxmysql کاملاً وصل شده قبل از اینکه چیزی رو
-- کوئری کنیم. این باید قبل از هر فایلِ دیگه‌ای که به reports جدول نیاز
-- داره کامل بشه - به همین خاطر این فایل باید اول از همه لود بشه.
MySQL.ready(function()
    local ok, err = pcall(runMigration)
    if not ok then
        print(('^1[%s]^0 SchemaGuard با خطا مواجه شد: %s'):format(RES, tostring(err)))
        print(('^1[%s]^0 برای رفع دستی: sql/reports.sql رو مستقیم روی دیتابیس اجرا کن.'):format(RES))
    end
end)

RegisterCommand('reportschema', function(source)
    if source ~= 0 then return end
    print(('[%s] SchemaGuard ready: %s'):format(RES, tostring(SchemaGuard.ready)))
    for _, def in ipairs(REQUIRED_COLUMNS) do
        local exists = columnExists(def[1], def[2])
        print(('   %s %s.%s'):format(exists and '✓' or '✗', def[1], def[2]))
    end
end, true)
