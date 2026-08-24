

do
    local versionFile = LoadResourceFile(GetCurrentResourceName(), "VERSION")
    if versionFile then
        local trimmed = versionFile:gsub("%s+", "")
        if trimmed ~= "" then
            UNIQUE_AC.Version = trimmed
        end
    end
end

local COLORS = math.random(1, 9)

local HEALTH_SAMPLES = {}
local HEALTH_START_TIME = GetGameTimer()

CreateThread(function()
    while true do
        local sampleStart = GetGameTimer()
        Wait(1000)
        local drift = (GetGameTimer() - sampleStart) - 1000
        table.insert(HEALTH_SAMPLES, math.max(0, drift))
        if #HEALTH_SAMPLES > 30 then table.remove(HEALTH_SAMPLES, 1) end
    end
end)

function UNIQUE_AC_GET_HEALTH()
    local sum = 0
    for _, v in ipairs(HEALTH_SAMPLES) do sum = sum + v end
    local avgDrift = #HEALTH_SAMPLES > 0 and (sum / #HEALTH_SAMPLES) or 0
    return {
        avgFrameDriftMs = math.floor(avgDrift + 0.5),
        uptimeSeconds = math.floor((GetGameTimer() - HEALTH_START_TIME) / 1000),
        resourceCount = GetNumResources(),
    }
end

function UNIQUE_AC_TR(key)
    local lang = UNIQUE_AC.Language or "en"
    local locale = (UNIQUE_AC.Locales and UNIQUE_AC.Locales[lang]) or (UNIQUE_AC.Locales and UNIQUE_AC.Locales.en)
    local fallback = UNIQUE_AC.Locales and UNIQUE_AC.Locales.en
    return (locale and locale[key]) or (fallback and fallback[key]) or key
end
local SPAWNED = {}
local SPAMLIST = {}
local TEMP_WHITELIST = {}
local PLAYER_STATE = {}
local PERMISSION_CACHE = {}
local TRUSTED_ADMINS = {}
local PENDING_QUARANTINE = {}
local FRAMEWORK_PERM_CACHE = {}
local PLAYER_BLIP_SUBSCRIBERS = {}
local CLUSTER_RECENT_DETECTIONS = {}
local invalidatePermissionCache

local function cfg(name, fallback)
    if UNIQUE_AC.Detection and UNIQUE_AC.Detection[name] ~= nil then
        return UNIQUE_AC.Detection[name]
    end
    return fallback
end

local function connectionCfg(name, fallback)
    if UNIQUE_AC.Connection and UNIQUE_AC.Connection[name] ~= nil then
        return UNIQUE_AC.Connection[name]
    end
    return fallback
end

local function runtimeCfg(name, fallback)
    if UNIQUE_AC.ServerRuntime and UNIQUE_AC.ServerRuntime[name] ~= nil then
        return UNIQUE_AC.ServerRuntime[name]
    end
    return fallback
end

local function monotonicMs()
    return GetGameTimer()
end

local function playerState(src)
    src = tonumber(src)
    if not src then return nil end
    PLAYER_STATE[src] = PLAYER_STATE[src] or {
        connectedAt = monotonicMs(),
        readyAt = 0,
        graceUntil = 0,
        reportWindowAt = 0,
        reportCount = 0,
        lastReasonAt = {}
    }
    return PLAYER_STATE[src]
end

AddEventHandler('playerConnecting', function()
    playerState(source)
end)

AddEventHandler('playerDropped', function()
    local src = tonumber(source)
    local st = PLAYER_STATE[src]
    if st and st.license and UNIQUE_AC.PersistentTrust and UNIQUE_AC.PersistentTrust.Enable then
        UNIQUE_AC_SAVE_TRUST(src, st)
    end
    PLAYER_STATE[src] = nil
    TEMP_WHITELIST[src] = nil
    PERMISSION_CACHE[src] = nil
    TRUSTED_ADMINS[src] = nil
    SPAMLIST[src] = nil
    if PENDING_QUARANTINE then PENDING_QUARANTINE[src] = nil end
    FRAMEWORK_PERM_CACHE[src] = nil
    PLAYER_BLIP_SUBSCRIBERS[src] = nil
end)

local function uniqueacNormalizeName(name)
    return tostring(name or ""):lower():gsub("[%s,%-%_]", "")
end

local DB_COLUMN_READY = {}
local function uniqueacDbName(value)
    local name = tostring(value or "Unknown")
    name = name:gsub("[%c]", " "):gsub("%s+", " "):sub(1, 96)
    if name == "" then name = "Unknown" end
    return name
end

local function uniqueacEnsureColumn(tableName, columnName, definition)
    tableName, columnName = tostring(tableName or ""), tostring(columnName or "")
    if tableName == "" or columnName == "" then return false end
    local key = tableName .. "." .. columnName
    if DB_COLUMN_READY[key] ~= nil then return DB_COLUMN_READY[key] end

    local p = promise.new()
    MySQL.Async.fetchAll(("SHOW COLUMNS FROM `%s` LIKE @column"):format(tableName), {
        ["@column"] = columnName
    }, function(rows)
        if rows and rows[1] then
            DB_COLUMN_READY[key] = true
            p:resolve(true)
            return
        end
        MySQL.Async.execute(("ALTER TABLE `%s` ADD COLUMN `%s` %s"):format(tableName, columnName, definition), {}, function(rowsChanged)
            DB_COLUMN_READY[key] = true
            p:resolve(true)
        end)
    end)
    return Citizen.Await(p)
end

local function uniqueacGrantActionGrace(target, durationMs, reason)
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return false end
    durationMs = math.max(5000, math.min(tonumber(durationMs) or 30000, 600000))
    UNIQUE_AC_CHANGE_TEMP_WHHITELIST(target, true, durationMs)
    TriggerClientEvent("UNIQUE_AC:clientGrace", target, durationMs)
    local st = playerState(target)
    if st then st.graceUntil = math.max(st.graceUntil or 0, monotonicMs() + durationMs) end
    return true
end

local function UNIQUE_AC_PostConnectValidation(src, playerName)
    src = tonumber(src)
    if not src or not GetPlayerName(src) then return end

    local okBan, banData = pcall(UNIQUE_AC_INBANLIST, src)
    if okBan and banData and banData[1] then
        local reason = tostring(banData[1].REASON or "Unknown")
        local banId = tostring(banData[1].BANID or "N/A")
        print(("^%sUNIQUE_AC^0: ^1Blocked banned player ^3%s^0 | Ban ID: %s"):format(COLORS, playerName or GetPlayerName(src) or src, banId))
        DropPlayer(src, ("\n[UNIQUE_AC]\nYou are banned from this server.\nReason: %s\nBan ID: #%s"):format(reason, banId))
        return
    elseif not okBan then
        print("^1[UNIQUE_AC]^0 Ban-list lookup failed during post-connect validation; player was allowed fail-open.")
    end

    if UNIQUE_AC.Connection and UNIQUE_AC.Connection.AntiBlackListName and type(Names) == "table" then
        local normalizedName = uniqueacNormalizeName(playerName or GetPlayerName(src))
        for _, blocked in ipairs(Names) do
            local needle = uniqueacNormalizeName(blocked)
            if needle ~= "" and normalizedName:find(needle, 1, true) then
                DropPlayer(src, ("\n[UNIQUE_AC]\nYour player name contains a blocked term: %s"):format(tostring(blocked)))
                return
            end
        end
    end



    if UNIQUE_AC.CentralHub and UNIQUE_AC.CentralHub.Enable and UNIQUE_AC.CentralHub.ShareBans then
        local license = uniqueacPlayerLicense(src)
        if license then
            UNIQUE_AC_HUB_POST("/api/check-shared-ban.php", { identifier = license }, function(statusCode, body)
                if statusCode ~= 200 or not body then return end
                local ok, data = pcall(json.decode, body)
                if ok and data and data.found and data.match and GetPlayerName(src) then
                    local reason = ("Banned on another server in your network (%s): %s"):format(
                        tostring(data.match.source_server or "sibling server"), tostring(data.match.reason or "Unknown"))
                    print(("^1[UNIQUE_AC]^0 ^3%s^0 matched a cross-server ban | %s"):format(playerName or src, reason))
                    DropPlayer(src, ("\n[UNIQUE_AC]\n" .. reason))
                end
            end)
        end
    end
end

AddEventHandler('playerJoining', function()
    local src = tonumber(source)
    if not src then return end
    SetTimeout(2500, function()
        UNIQUE_AC_PostConnectValidation(src, GetPlayerName(src))
    end)
end)

CreateThread(function()
    Wait(0)
    StartAntiCheat()
end)

local function uniqueacChecksum(text)
    local hash1, hash2 = 5381, 52711
    for i = 1, #text do
        local byte = text:byte(i)
        hash1 = (hash1 * 33 + byte) % 4294967296
        hash2 = (hash2 * 37 + byte) % 4294967296
    end
    return ("%08x%08x"):format(hash1, hash2)
end

CreateThread(function()
    if not UNIQUE_AC.Integrity or not UNIQUE_AC.Integrity.Enable then return end
    Wait(3000)

    local resourceName = GetCurrentResourceName()
    local baseline = {}
    for _, path in ipairs(UNIQUE_AC.Integrity.Files or {}) do
        local content = LoadResourceFile(resourceName, path)
        if content then baseline[path] = uniqueacChecksum(content) end
    end

    local interval = tonumber(UNIQUE_AC.Integrity.IntervalMs) or 300000
    while true do
        Wait(interval)
        for path, originalHash in pairs(baseline) do
            local content = LoadResourceFile(resourceName, path)
            local currentHash = content and uniqueacChecksum(content) or nil
            if currentHash ~= originalHash then
                print(("^1[UNIQUE_AC]^0 ^1INTEGRITY ALERT^0: `%s` changed on disk since startup — resource may have been tampered with. Restart to re-baseline once verified safe."):format(path))
                UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, ("Integrity check failed: `%s` changed while the resource was running."):format(path))
                baseline[path] = currentHash
            end
        end
    end
end)

CreateThread(function()
    if not UNIQUE_AC.ConfigBackup or not UNIQUE_AC.ConfigBackup.Enable then return end
    Wait(4000)

    local ok, err = pcall(function()
        local resourceName = GetCurrentResourceName()
        local current = LoadResourceFile(resourceName, "configs/fire-config.lua")
        if not current then return end
        local currentHash = uniqueacChecksum(current)
        local lastHash = LoadResourceFile(resourceName, "configs/backups/.last-hash")

        if lastHash == currentHash then return end

        local stamp = os.date("%Y%m%d-%H%M%S")
        SaveResourceFile(resourceName, ("configs/backups/fire-config-%s.lua"):format(stamp), current, -1)
        SaveResourceFile(resourceName, "configs/backups/.last-hash", currentHash, -1)
        print(("^2[UNIQUE_AC]^0 fire-config.lua changed since last boot — backup saved as configs/backups/fire-config-%s.lua"):format(stamp))



        local indexRaw = LoadResourceFile(resourceName, "configs/backups/.index") or ""
        local names = {}
        for line in indexRaw:gmatch("[^\r\n]+") do names[#names + 1] = line end
        names[#names + 1] = ("fire-config-%s.lua"):format(stamp)

        local keep = math.max(1, tonumber(UNIQUE_AC.ConfigBackup.Keep) or 20)
        while #names > keep do
            local oldest = table.remove(names, 1)
            SaveResourceFile(resourceName, "configs/backups/" .. oldest, "", -1)
        end
        SaveResourceFile(resourceName, "configs/backups/.index", table.concat(names, "\n"), -1)
    end)

    if not ok then
        print(("^3[UNIQUE_AC]^0 Config Backup skipped — SaveResourceFile isn't available on this build (%s)."):format(tostring(err)))
    end
end)

local ALLOWED_REPORT_REASONS = {
    ["Anti Health Hack"] = function() return UNIQUE_AC.HealthPunishment end,
    ["Anti Armor Hack"] = function() return UNIQUE_AC.ArmorPunishment end,
    ["Anti Spectate"] = function() return UNIQUE_AC.SpectatePunishment or UNIQUE_AC.SpactatePunishment end,
    ["Anti Godmode"] = function() return UNIQUE_AC.GodPunishment end,
    ["Anti Invisible"] = function() return UNIQUE_AC.InvisiblePunishment end,
    ["Anti Tiny Ped"] = function() return UNIQUE_AC.PedFlagPunishment end,
    ["Anti Ped Changer"] = function() return UNIQUE_AC.PedChangePunishment end,
    ["Anti Free Cam"] = function() return UNIQUE_AC.CamPunishment end,
    ["Anti Teleport"] = function() return UNIQUE_AC.TeleportPunishment end,
    ["Anti Noclip"] = function() return UNIQUE_AC.NoclipPunishment end,
    ["Anti Black List Weapon"] = function() return UNIQUE_AC.WeaponPunishment end,
    ["Anti Weapon Damage Changer"] = function() return UNIQUE_AC.DamagePunishment or UNIQUE_AC.WeaponPunishment end,
    ["Anti Infinite Stamina"] = function() return UNIQUE_AC.InfinitePunishment end,
    ["Anti Night Vision"] = function() return UNIQUE_AC.VisionPunishment end,
    ["Anti Thermal Vision"] = function() return UNIQUE_AC.VisionPunishment end,
    ["Anti Black List Tasks"] = function() return UNIQUE_AC.TasksPunishment end,
    ["Anti Black List Animation"] = function() return UNIQUE_AC.AnimsPunishment end,
    ["Anti Plate Changer"] = function() return UNIQUE_AC.PlatePunishment end,
    ["Anti Black List Plate"] = function() return UNIQUE_AC.PlatePunishment end,
    ["Anti Rainbow"] = function() return UNIQUE_AC.RainbowPunishment end,
    ["Anti Speed Changer"] = function() return UNIQUE_AC.SpeedPunishment end,
    ["Anti Collected Pickup"] = function() return UNIQUE_AC.PickupPunishment end,
    ["Anti Suicide"] = function() return UNIQUE_AC.SuicidePunishment end,
    ["Anti Weapon Component"] = function() return UNIQUE_AC.ComponentPunishment or UNIQUE_AC.WeaponPunishment end,
    ["Anti Out Of Bounds"] = function() return UNIQUE_AC.UndergroundPunishment end,
    ["Anti Underground"] = function() return UNIQUE_AC.UndergroundPunishment end,
    ["Anti Vehicle God Mode"] = function() return UNIQUE_AC.VehicleGodPunishment end,
    ["Anti Macro Fire"] = function() return UNIQUE_AC.MacroFirePunishment end,
    ["Anti Aimbot Pattern"] = function() return UNIQUE_AC.AimbotPunishment end,
}

local DETERMINISTIC_REASONS = {
    ["Anti Health Hack"] = true, ["Anti Armor Hack"] = true, ["Anti Black List Weapon"] = true,
    ["Anti Weapon Component"] = true, ["Anti Black List Plate"] = true, ["Anti Black List Tasks"] = true,
    ["Anti Black List Animation"] = true, ["Anti Tiny Ped"] = true, ["Anti Rainbow"] = true,
    ["Anti Plate Changer"] = true, ["Anti Weapon Damage Changer"] = true, ["Anti Collected Pickup"] = true,
    ["Anti Suicide"] = true, ["Anti Night Vision"] = true, ["Anti Thermal Vision"] = true,
}

local function trustCfg(name, fallback)
    if UNIQUE_AC.TrustScore and UNIQUE_AC.TrustScore[name] ~= nil then return UNIQUE_AC.TrustScore[name] end
    return fallback
end

local function quarantineCfg(name, fallback)
    if UNIQUE_AC.Quarantine and UNIQUE_AC.Quarantine[name] ~= nil then return UNIQUE_AC.Quarantine[name] end
    return fallback
end

local function uniqueacNotify(target, text, color)
    if not UNIQUE_AC.ChatSettings or not UNIQUE_AC.ChatSettings.Enable then return end
    TriggerClientEvent("chat:addMessage", target, {
        color = color or { 0, 200, 255 }, multiline = true, args = { "UNIQUE_AC", text }
    })
end

local function uniqueacNotifyAdmins(text, color)
    for _, otherId in ipairs(GetPlayers()) do
        local aid = tonumber(otherId)
        if aid and UNIQUE_AC_GETADMINS(aid) then
            uniqueacNotify(aid, text, color)
        end
    end
end

local function uniqueacRecomputeRisk(st)
    local cfg = UNIQUE_AC.RiskScore
    if not cfg or not cfg.Enable or not st then return end
    local trust = st.trust or 100
    local score = (100 - trust) * (tonumber(cfg.WeightLowTrust) or 0.45)
    score = score + (st.flagCount or 0) * (tonumber(cfg.WeightFlagCount) or 6)
    score = score + (st.quarantineCount or 0) * (tonumber(cfg.WeightQuarantine) or 12)

    if st.firstSeen then
        local ageHours = (os.time() - st.firstSeen) / 3600.0
        if ageHours < (tonumber(cfg.NewAccountHours) or 6) then
            score = score + (tonumber(cfg.WeightNewAccount) or 15)
        end
    end

    if (st.reconnectCount or 0) > 0 then
        score = score + math.min((st.reconnectCount or 0), 5) * (tonumber(cfg.WeightRapidReconnect) or 10)
    end

    st.riskScore = math.max(0, math.min(100, math.floor(score + 0.5)))
end

function UNIQUE_AC_SAVE_TRUST(src, st)
    if not (UNIQUE_AC.PersistentTrust and UNIQUE_AC.PersistentTrust.Enable) then return end
    if not st or not st.license then return end
    MySQL.Async.execute([[
        UPDATE uniqueac_trust SET trust_score=@trust, risk_score=@risk, flag_count=@flags,
            quarantine_count=@quar, player_name=@name WHERE identifier=@id
    ]], {
        ["@trust"] = st.trust or 100, ["@risk"] = st.riskScore or 0, ["@flags"] = st.flagCount or 0,
        ["@quar"] = st.quarantineCount or 0, ["@name"] = GetPlayerName(src) or "Unknown", ["@id"] = st.license
    })
end

local function uniqueacLoadTrust(src)
    if not (UNIQUE_AC.PersistentTrust and UNIQUE_AC.PersistentTrust.Enable) then return end
    local license = uniqueacPlayerLicense(src)
    if not license then return end
    local st = playerState(src)
    if not st then return end

    MySQL.Async.fetchAll(
        "SELECT trust_score, risk_score, flag_count, quarantine_count, reconnect_count, last_reconnect_at, UNIX_TIMESTAMP(first_seen) AS first_seen_unix FROM uniqueac_trust WHERE identifier = @id LIMIT 1",
        { ["@id"] = license }, function(rows)
            local stillOnline = playerState(src) == st and GetPlayerName(src)
            if not stillOnline then return end

            local nowMs = monotonicMs()
            if rows and rows[1] then
                st.trust = tonumber(rows[1].trust_score) or tonumber(trustCfg("Start", 100)) or 100
                st.flagCount = tonumber(rows[1].flag_count) or 0
                st.quarantineCount = tonumber(rows[1].quarantine_count) or 0
                st.firstSeen = tonumber(rows[1].first_seen_unix) or os.time()

                local windowMs = tonumber(UNIQUE_AC.RiskScore and UNIQUE_AC.RiskScore.RapidReconnectWindowMs) or 120000
                local lastReconnect = tonumber(rows[1].last_reconnect_at) or 0
                local reconnectCount = tonumber(rows[1].reconnect_count) or 0
                if lastReconnect > 0 and (nowMs - lastReconnect) < windowMs then
                    reconnectCount = reconnectCount + 1
                end
                st.reconnectCount = reconnectCount

                MySQL.Async.execute("UPDATE uniqueac_trust SET player_name=@name, reconnect_count=@rc, last_reconnect_at=@lr WHERE identifier=@id", {
                    ["@name"] = GetPlayerName(src), ["@rc"] = reconnectCount, ["@lr"] = nowMs, ["@id"] = license
                })
            else
                st.trust = tonumber(trustCfg("Start", 100)) or 100
                st.flagCount, st.quarantineCount, st.reconnectCount = 0, 0, 0
                st.firstSeen = os.time()
                MySQL.Async.execute("INSERT IGNORE INTO uniqueac_trust (identifier, player_name, trust_score, last_reconnect_at) VALUES (@id, @name, @trust, @lr)", {
                    ["@id"] = license, ["@name"] = GetPlayerName(src), ["@trust"] = st.trust, ["@lr"] = nowMs
                })
            end
            st.license = license
            uniqueacRecomputeRisk(st)

            local recogCfg = UNIQUE_AC.TrustRecognition
            if recogCfg and recogCfg.Enable and rows and rows[1] and st.trust >= (tonumber(recogCfg.Threshold) or 90) then
                uniqueacNotify(src, "✓ Welcome back — your account is in good standing. Thanks for playing fair.", { 89, 201, 122 })
            end
        end)
end

local function uniqueacLogDetection(src, reason, details, action)
    if not UNIQUE_AC.RiskScore or not UNIQUE_AC.RiskScore.Enable then return end
    local license = uniqueacPlayerLicense(src)
    if not license then return end
    MySQL.Async.execute("INSERT INTO uniqueac_detections (identifier, player_name, reason, details, action) VALUES (@id, @name, @reason, @details, @action)", {
        ["@id"] = license, ["@name"] = GetPlayerName(src) or "Unknown",
        ["@reason"] = tostring(reason or ""):sub(1, 128), ["@details"] = tostring(details or ""):sub(1, 900),
        ["@action"] = tostring(action or "FLAG"):sub(1, 32)
    })

    if UNIQUE_AC.CentralHub and UNIQUE_AC.CentralHub.Enable and UNIQUE_AC.CentralHub.ShareHeatmap then
        local x, y = tostring(details or ""):match("Coords:%s*([%-%d%.]+),%s*([%-%d%.]+)")
        if x and y then
            UNIQUE_AC_HUB_POST("/api/report-heatmap.php", { reason = reason, x = tonumber(x), y = tonumber(y) })
        end
    end

    if UNIQUE_AC.BehavioralClustering and UNIQUE_AC.BehavioralClustering.Enable then
        local now = os.time()
        local windowStart = now - math.floor((tonumber(UNIQUE_AC.BehavioralClustering.WindowMs) or 300000) / 1000)


        for i = #CLUSTER_RECENT_DETECTIONS, 1, -1 do
            if CLUSTER_RECENT_DETECTIONS[i].at < windowStart then table.remove(CLUSTER_RECENT_DETECTIONS, i) end
        end
        table.insert(CLUSTER_RECENT_DETECTIONS, { reason = reason, license = license, at = now })

        local distinctPlayers = {}
        for _, entry in ipairs(CLUSTER_RECENT_DETECTIONS) do
            if entry.reason == reason then distinctPlayers[entry.license] = true end
        end
        local count = 0
        for _ in pairs(distinctPlayers) do count = count + 1 end

        local minPlayers = tonumber(UNIQUE_AC.BehavioralClustering.MinPlayers) or 2
        if count == minPlayers then
            uniqueacNotifyAdmins(("🧬 Possible pattern: %d different players triggered \"%s\" within a few minutes — could be alt accounts or a shared tool. Worth a look."):format(count, reason), { 148, 163, 184 })
        end
    end
end

function UNIQUE_AC_LOG_ADMIN_ACTION(adminSrc, action, targetIdentifier, targetName, reason)
    if not UNIQUE_AC.AdminLog or not UNIQUE_AC.AdminLog.Enable then return end
    local adminLicense = adminSrc and uniqueacPlayerLicense(adminSrc) or nil
    MySQL.Async.execute("INSERT INTO uniqueac_admin_log (admin_identifier, admin_name, action, target_identifier, target_name, reason) VALUES (@aid, @aname, @action, @tid, @tname, @reason)", {
        ["@aid"] = adminLicense, ["@aname"] = adminSrc and (GetPlayerName(adminSrc) or "Unknown") or "System",
        ["@action"] = tostring(action or "Unknown"):sub(1, 64), ["@tid"] = targetIdentifier,
        ["@tname"] = tostring(targetName or "Unknown"):sub(1, 128), ["@reason"] = tostring(reason or ""):sub(1, 900)
    })
end

CreateThread(function()
    if not UNIQUE_AC.PersistentTrust or not UNIQUE_AC.PersistentTrust.Enable then return end
    local interval = math.max(15000, tonumber(UNIQUE_AC.PersistentTrust.SaveEveryMs) or 60000)
    while true do
        Wait(interval)
        for _, pid in ipairs(GetPlayers()) do
            local id = tonumber(pid)
            local st = id and PLAYER_STATE[id]
            if st and st.license then UNIQUE_AC_SAVE_TRUST(id, st) end
        end
    end
end)

local function enterQuarantine(src, action, reason, details)
    local playerName = GetPlayerName(src) or ("ID " .. src)
    local st = playerState(src)
    if st then
        st.quarantineCount = (st.quarantineCount or 0) + 1
        uniqueacRecomputeRisk(st)
        UNIQUE_AC_SAVE_TRUST(src, st)
    end
    uniqueacLogDetection(src, reason, details, "QUARANTINE")
    PENDING_QUARANTINE[src] = {
        action = action, reason = reason, details = details,
        playerName = playerName, at = os.time()
    }
    TriggerClientEvent("UNIQUE_AC:quarantineFreeze", src, true)
    print(("^3[UNIQUE_AC]^0 ^3%s^0 sent to Quarantine for admin review | %s"):format(playerName, reason))
    UNIQUE_AC_SENDLOG(src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Ban or "", "QUARANTINE", reason, details)
    UNIQUE_AC_SCREENSHOT_BURST(src, reason, details, "WARN")
    uniqueacNotify(src, UNIQUE_AC_TR("quarantine"), { 255, 170, 0 })
    uniqueacNotifyAdmins(("⚠ %s flagged (%s) — sent to Quarantine, review in the admin panel."):format(playerName, reason), { 255, 100, 100 })
    UNIQUE_AC_HUB_NOTIFY_QUARANTINE(reason)
end

function UNIQUE_AC_ENFORCE(src, action, reason, details)
    src = tonumber(src)
    if not src then return end

    if not trustCfg("Enable", true) or DETERMINISTIC_REASONS[reason] then
        UNIQUE_AC_ACTION(src, action, reason, details)
        return
    end

    local st = playerState(src)
    if not st then
        UNIQUE_AC_ACTION(src, action, reason, details)
        return
    end

    st.trust = st.trust or tonumber(trustCfg("Start", 100)) or 100
    local weight = tonumber(trustCfg("DeductWeight", 20)) or 20
    st.trust = math.max(0, st.trust - weight)
    st.flagCount = (st.flagCount or 0) + 1
    uniqueacRecomputeRisk(st)
    uniqueacLogDetection(src, reason, details, "FLAG")

    if reason == "Anti Aimbot Pattern" and UNIQUE_AC.AimbotWatch and UNIQUE_AC.AimbotWatch.NotifyAdminsOnFlag then
        local playerName = GetPlayerName(src) or ("ID " .. src)
        print(("^3[UNIQUE_AC]^0 ^3Aimbot pattern flagged^0 for ^3%s^0 | %s | trust now %d"):format(playerName, details, st.trust))
        UNIQUE_AC_SENDLOG(src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Ban or "", "AIMBOT", reason, details)
        uniqueacNotifyAdmins(("🎯 %s shows an aimbot-like pattern (%s) — not punished automatically, please review."):format(playerName, details), { 255, 170, 0 })
    end

    if UNIQUE_AC.PunishmentLadder and UNIQUE_AC.PunishmentLadder.Enable then
        st.ladderStepsApplied = st.ladderStepsApplied or {}
        for _, step in ipairs(UNIQUE_AC.PunishmentLadder.Steps or {}) do
            local key = tostring(step.threshold)
            if st.trust <= (tonumber(step.threshold) or 0) and not st.ladderStepsApplied[key] then
                st.ladderStepsApplied[key] = true
                local stepAction = tostring(step.action or "WARN"):upper()
                if stepAction == "KICK" then
                    UNIQUE_AC_LOG_ADMIN_ACTION(nil, "LADDER_KICK", uniqueacPlayerLicense(src), GetPlayerName(src), reason)
                    DropPlayer(src, tostring(step.message or "Kicked as a precaution."))
                    return
                else
                    uniqueacNotify(src, tostring(step.message or "Your recent activity looks suspicious."), { 255, 170, 0 })
                end
            end
        end
    end

    if st.trust > 0 then
        print(("^3[UNIQUE_AC]^0 Trust score for ^3%s^0 now %d/100 | %s"):format(GetPlayerName(src) or src, st.trust, reason))
        return
    end

    if quarantineCfg("Enable", true) then
        enterQuarantine(src, action, reason, details)
    else
        UNIQUE_AC_ACTION(src, action, reason, details)
    end
end

RegisterNetEvent("UNIQUE_AC:getQuarantineList")
AddEventHandler("UNIQUE_AC:getQuarantineList", function()
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    local list = {}
    for pid, case in pairs(PENDING_QUARANTINE) do
        if GetPlayerName(pid) then
            list[#list + 1] = { id = pid, name = case.playerName, reason = case.reason, details = case.details, action = case.action, at = case.at }
        else
            PENDING_QUARANTINE[pid] = nil
        end
    end
    TriggerClientEvent("UNIQUE_AC:updateQuarantineList", src, list)
end)

RegisterNetEvent("UNIQUE_AC:quarantineApprove")
AddEventHandler("UNIQUE_AC:quarantineApprove", function(targetId)
    local src = tonumber(source)
    targetId = tonumber(targetId)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    local case = PENDING_QUARANTINE[targetId]
    if not case then return end
    PENDING_QUARANTINE[targetId] = nil
    UNIQUE_AC_LOG_ADMIN_ACTION(src, "QUARANTINE_APPROVE", uniqueacPlayerLicense(targetId), GetPlayerName(targetId), case.reason)
    UNIQUE_AC_ACTION(targetId, case.action, case.reason, case.details .. " | Reviewed & approved by " .. (GetPlayerName(src) or tostring(src)))
end)

RegisterNetEvent("UNIQUE_AC:quarantineRelease")
AddEventHandler("UNIQUE_AC:quarantineRelease", function(targetId)
    local src = tonumber(source)
    targetId = tonumber(targetId)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    if not PENDING_QUARANTINE[targetId] then return end
    PENDING_QUARANTINE[targetId] = nil
    local st = playerState(targetId)
    if st then
        st.trust = tonumber(trustCfg("RecoverOnRelease", 60)) or 60
        uniqueacRecomputeRisk(st)
        UNIQUE_AC_SAVE_TRUST(targetId, st)
    end
    UNIQUE_AC_LOG_ADMIN_ACTION(src, "QUARANTINE_RELEASE", uniqueacPlayerLicense(targetId), GetPlayerName(targetId), "Released from review")
    TriggerClientEvent("UNIQUE_AC:quarantineFreeze", targetId, false)
    if GetPlayerName(targetId) then
        uniqueacNotify(targetId, UNIQUE_AC_TR("quarantine_released"), { 75, 227, 154 })
    end
end)

local function uniqueacSendPlayerProfile(src, targetId)
    if not GetPlayerName(targetId) then return end
    local st = playerState(targetId)
    local license = uniqueacPlayerLicense(targetId)
    local profile = {
        id = targetId, name = GetPlayerName(targetId),
        trust = st and st.trust or 100, risk = st and st.riskScore or 0,
        flagCount = st and st.flagCount or 0, quarantineCount = st and st.quarantineCount or 0,
        notes = {}, detections = {}
    }

    if not license then
        TriggerClientEvent("UNIQUE_AC:updatePlayerProfile", src, profile)
        return
    end

    MySQL.Async.fetchAll("SELECT id, author_name, note, UNIX_TIMESTAMP(created_at) AS at FROM uniqueac_notes WHERE target_identifier = @id ORDER BY id DESC LIMIT 50", { ["@id"] = license }, function(noteRows)
        profile.notes = noteRows or {}
        MySQL.Async.fetchAll("SELECT reason, details, action, UNIX_TIMESTAMP(created_at) AS at FROM uniqueac_detections WHERE identifier = @id ORDER BY id DESC LIMIT 30", { ["@id"] = license }, function(detRows)
            profile.detections = detRows or {}
            TriggerClientEvent("UNIQUE_AC:updatePlayerProfile", src, profile)
        end)
    end)
end

RegisterNetEvent("UNIQUE_AC:getPlayerProfile")
AddEventHandler("UNIQUE_AC:getPlayerProfile", function(targetId)
    local src = tonumber(source)
    targetId = tonumber(targetId)
    if not src or not targetId or not UNIQUE_AC_GETADMINS(src) then return end
    uniqueacSendPlayerProfile(src, targetId)
end)

RegisterNetEvent("UNIQUE_AC:addPlayerNote")
AddEventHandler("UNIQUE_AC:addPlayerNote", function(targetId, note)
    local src = tonumber(source)
    targetId = tonumber(targetId)
    if not src or not targetId or not UNIQUE_AC_GETADMINS(src) then return end
    if not (UNIQUE_AC.PlayerNotes and UNIQUE_AC.PlayerNotes.Enable) then return end
    if not GetPlayerName(targetId) then return end
    local license = uniqueacPlayerLicense(targetId)
    if not license then return end

    note = tostring(note or ""):gsub("[%c]", " "):sub(1, tonumber(UNIQUE_AC.PlayerNotes.MaxLength) or 500)
    if note == "" then return end

    MySQL.Async.execute("INSERT INTO uniqueac_notes (target_identifier, target_name, author_identifier, author_name, note) VALUES (@tid, @tname, @aid, @aname, @note)", {
        ["@tid"] = license, ["@tname"] = GetPlayerName(targetId), ["@aid"] = uniqueacPlayerLicense(src),
        ["@aname"] = GetPlayerName(src) or "Unknown", ["@note"] = note
    })
    UNIQUE_AC_LOG_ADMIN_ACTION(src, "NOTE_ADD", license, GetPlayerName(targetId), note)
    SetTimeout(300, function() uniqueacSendPlayerProfile(src, targetId) end)
end)

RegisterNetEvent("UNIQUE_AC:getAdminLog")
AddEventHandler("UNIQUE_AC:getAdminLog", function()
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    local limit = math.max(20, math.min(tonumber(UNIQUE_AC.AdminLog and UNIQUE_AC.AdminLog.Keep) or 500, 1000))
    MySQL.Async.fetchAll("SELECT admin_name, action, target_name, reason, UNIX_TIMESTAMP(created_at) AS at FROM uniqueac_admin_log ORDER BY id DESC LIMIT " .. limit, {}, function(rows)
        TriggerClientEvent("UNIQUE_AC:updateAdminLog", src, rows or {})
    end)
end)

RegisterNetEvent("UNIQUE_AC:getChangelog")
AddEventHandler("UNIQUE_AC:getChangelog", function()
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    local content = LoadResourceFile(GetCurrentResourceName(), "update.txt") or "update.txt not found."
    TriggerClientEvent("UNIQUE_AC:updateChangelog", src, content)
end)

RegisterNetEvent("UNIQUE_AC:getBranding")
AddEventHandler("UNIQUE_AC:getBranding", function()
    local src = tonumber(source)
    if not src then return end
    local branding = UNIQUE_AC.Branding or {}
    TriggerClientEvent("UNIQUE_AC:updateBranding", src, {
        panelName = branding.PanelName or "UNIQUE_AC",
        footerCredit = branding.FooterCredit or "",
        version = (branding.BuildLabel and branding.BuildLabel ~= "") and branding.BuildLabel or tostring(UNIQUE_AC.Version)
    })
end)

RegisterNetEvent("UNIQUE_AC:getAppeals")
AddEventHandler("UNIQUE_AC:getAppeals", function()
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    MySQL.Async.fetchAll("SELECT id, identifier, player_name, ban_id, message, UNIX_TIMESTAMP(created_at) AS at FROM uniqueac_appeals WHERE status = 'pending' ORDER BY id DESC LIMIT 100", {}, function(rows)
        TriggerClientEvent("UNIQUE_AC:updateAppeals", src, rows or {})
    end)
end)

CreateThread(function()
    if not UNIQUE_AC.Appeals or not UNIQUE_AC.Appeals.Enable or not UNIQUE_AC.Appeals.NotifyAdminsOnNew then return end
    local lastKnownIds = {}
    local firstPoll = true
    while true do
        Wait(60000)
        MySQL.Async.fetchAll("SELECT id, player_name FROM uniqueac_appeals WHERE status = 'pending' ORDER BY id DESC LIMIT 20", {}, function(rows)
            if not rows then return end
            for _, row in ipairs(rows) do
                if not lastKnownIds[row.id] then
                    lastKnownIds[row.id] = true
                    if not firstPoll then
                        uniqueacNotifyAdmins(("📮 New ban appeal from %s — review it in the Appeals tab."):format(row.player_name or "a player"), { 245, 166, 35 })
                        UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, ("New ban appeal submitted by %s (appeal #%d)."):format(row.player_name or "a player", row.id))
                    end
                end
            end
            firstPoll = false
        end)
    end
end)

RegisterNetEvent("UNIQUE_AC:reviewAppeal")
AddEventHandler("UNIQUE_AC:reviewAppeal", function(appealId, approve)
    local src = tonumber(source)
    appealId = tonumber(appealId)
    if not src or not appealId or not UNIQUE_AC_GETADMINS(src) then return end
    if not (UNIQUE_AC.Appeals and UNIQUE_AC.Appeals.Enable) then return end

    MySQL.Async.fetchAll("SELECT identifier, ban_id FROM uniqueac_appeals WHERE id = @id AND status = 'pending' LIMIT 1", { ["@id"] = appealId }, function(rows)
        if not rows or not rows[1] then return end
        local status = approve and "approved" or "rejected"
        MySQL.Async.execute("UPDATE uniqueac_appeals SET status=@status, reviewed_by=@by, reviewed_at=NOW() WHERE id=@id", {
            ["@status"] = status, ["@by"] = GetPlayerName(src) or ("ID " .. src), ["@id"] = appealId
        })
        UNIQUE_AC_LOG_ADMIN_ACTION(src, "APPEAL_" .. status:upper(), rows[1].identifier, nil, "Appeal #" .. appealId)
        if approve and rows[1].ban_id then
            MySQL.Async.execute("DELETE FROM uniqueac_banlist WHERE BANID = @banid", { ["@banid"] = rows[1].ban_id })
        end
    end)
end)

local function uniqueacHubServerName()
    local cfg = UNIQUE_AC.CentralHub
    if cfg.ServerName and cfg.ServerName ~= "" then return cfg.ServerName end
    return (UNIQUE_AC.ServerConfig and UNIQUE_AC.ServerConfig.Name) or "Unnamed Server"
end

function UNIQUE_AC_HUB_POST(path, payload, onDone)
    local cfg = UNIQUE_AC.CentralHub
    if not cfg or not cfg.Enable then return end
    if not cfg.URL or cfg.URL == "" or not cfg.LicenseKey or cfg.LicenseKey == "" then return end
    payload.license_key = cfg.LicenseKey
    payload.server_name = uniqueacHubServerName()
    PerformHttpRequest(cfg.URL:gsub("/+$", "") .. path, function(statusCode, body, _)
        if onDone then onDone(statusCode, body) end
    end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

function UNIQUE_AC_HUB_NOTIFY_QUARANTINE(reason)
    local cfg = UNIQUE_AC.CentralHub
    if not cfg or not cfg.Enable or not cfg.NotifyOnQuarantine then return end
    UNIQUE_AC_HUB_POST("/api/urgent.php", {
        kind = "quarantine",
        message = "New Quarantine case: " .. tostring(reason or "Unknown reason")
    })
end

CreateThread(function()
    local cfg = UNIQUE_AC.CentralHub
    if not cfg or not cfg.Enable then return end
    Wait(10000)
    local interval = math.max(20000, tonumber(cfg.HeartbeatIntervalMs) or 60000)
    while true do
        local quarantineCount = 0
        for _ in pairs(PENDING_QUARANTINE) do quarantineCount = quarantineCount + 1 end

        MySQL.Async.fetchAll("SELECT (SELECT COUNT(*) FROM uniqueac_banlist) AS bans, (SELECT COUNT(*) FROM uniqueac_appeals WHERE status='pending') AS appeals", {}, function(rows)
            local counts = rows and rows[1] or {}
            local health = UNIQUE_AC_GET_HEALTH()
            UNIQUE_AC_HUB_POST("/api/heartbeat.php", {
                version = tostring(UNIQUE_AC.Version or "unknown"),
                player_count = #GetPlayers(),
                max_players = GetConvarInt("sv_maxclients", 48),
                quarantine_count = quarantineCount,
                appeal_count = tonumber(counts.appeals) or 0,
                ban_count_total = tonumber(counts.bans) or 0,
                avg_frame_drift_ms = health.avgFrameDriftMs,
                uptime_seconds = health.uptimeSeconds,
                resource_count = health.resourceCount,
            })
        end)

        Wait(interval)
    end
end)

local resourceBaseline = nil
local resourceIgnoreSet = {}
for _, name in ipairs((UNIQUE_AC.ResourceMonitor and UNIQUE_AC.ResourceMonitor.IgnoreList) or {}) do
    resourceIgnoreSet[name] = true
end

CreateThread(function()
    local cfg = UNIQUE_AC.ResourceMonitor
    if not cfg or not cfg.Enable then return end
    Wait(math.max(3000, tonumber(cfg.BaselineDelayMs) or 25000))

    resourceBaseline = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        if name then resourceBaseline[name] = true end
    end
    print(("^2[UNIQUE_AC]^0 Resource baseline captured: %d resources."):format(GetNumResources()))
end)

CreateThread(function()
    local cfg = UNIQUE_AC.KnownConflicts
    if not cfg or not cfg.Enable then return end
    Wait(5000)

    local running = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        if name then running[name] = true end
    end

    for _, badName in ipairs(cfg.Resources or {}) do
        if running[badName] then
            print(("^1[UNIQUE_AC]^0 ^1KNOWN CONFLICT DETECTED^0: `%s` is running on this server. This resource is known to be malicious or conflict with UNIQUE_AC — remove it."):format(badName))
            UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, ("Known-conflicting resource detected: `%s`. Remove it — see UNIQUE_AC.KnownConflicts in the config for details."):format(badName))
        end
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if not resourceBaseline then return end
    if resourceName == GetCurrentResourceName() then return end
    if resourceBaseline[resourceName] or resourceIgnoreSet[resourceName] then return end

    print(("^1[UNIQUE_AC]^0 ^1UNKNOWN RESOURCE STARTED^0: `%s` was not in the startup baseline."):format(resourceName))
    UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, ("Unrecognized resource started mid-session: `%s`. Review it if you didn't start it yourself."):format(resourceName))

    if UNIQUE_AC.ResourceMonitor.NotifyAdminsOnFlag then
        for _, otherId in ipairs(GetPlayers()) do
            local aid = tonumber(otherId)
            if aid and UNIQUE_AC_GETADMINS(aid) then
                uniqueacNotify(aid, ("🧩 Unknown resource started: %s — review it if you didn't start it yourself."):format(resourceName), { 245, 166, 35 })
            end
        end
    end
end)

local function acceptClientReport(src, requestedAction, reason, details)
    src = tonumber(src)
    if not src or src <= 0 or not GetPlayerName(src) then return end
    if UNIQUE_AC_IS_TRUSTED and UNIQUE_AC_IS_TRUSTED(src) then return end
    if type(reason) ~= "string" or type(details) ~= "string" then return end
    if #reason > 80 or #details > 1200 then return end

    local resolver = ALLOWED_REPORT_REASONS[reason]
    if not resolver then return end

    local st = playerState(src)
    local t = monotonicMs()
    if not st or st.readyAt == 0 or t < st.graceUntil then return end

    local window = cfg("ServerReportWindowMs", 10000)
    if t - st.reportWindowAt > window then
        st.reportWindowAt = t
        st.reportCount = 0
    end
    st.reportCount = st.reportCount + 1
    if st.reportCount > cfg("ServerReportLimit", 6) then
        return
    end

    local last = st.lastReasonAt[reason] or 0
    if t - last < window then return end
    st.lastReasonAt[reason] = t

    local action = tostring(resolver() or requestedAction or "WARN"):upper()
    if action ~= "WARN" and action ~= "KICK" and action ~= "BAN" then action = "WARN" end

    if reason == "Anti Teleport" and UNIQUE_AC_ISNEARADMIN(src) then return end
    UNIQUE_AC_ENFORCE(src, action, reason, details)
end

local RP_ZONES = {}
local RP_ZONE_NEXT_ID = 1

local function uniqueacRpZoneList()
    local list = {}
    for id, z in pairs(RP_ZONES) do
        list[#list + 1] = { id = id, x = z.x, y = z.y, z = z.z, radius = z.radius }
    end
    return list
end

local function broadcastRpZones(targetSrc)
    TriggerClientEvent("UNIQUE_AC:updateRpZones", targetSrc or -1, uniqueacRpZoneList())
end

RegisterNetEvent("UNIQUE_AC:createRpZone")
AddEventHandler("UNIQUE_AC:createRpZone", function(radius)
    local src = tonumber(source)
    if not src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Admin Action", "Unauthorized RP zone create")
        return
    end
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local coords = GetEntityCoords(ped)
    radius = math.max(3.0, math.min(tonumber(radius) or 15.0, 100.0))
    local id = RP_ZONE_NEXT_ID
    RP_ZONE_NEXT_ID = RP_ZONE_NEXT_ID + 1
    RP_ZONES[id] = { x = coords.x, y = coords.y, z = coords.z, radius = radius, createdBy = src }
    broadcastRpZones()
end)

RegisterNetEvent("UNIQUE_AC:clearMyRpZones")
AddEventHandler("UNIQUE_AC:clearMyRpZones", function()
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    for id, z in pairs(RP_ZONES) do
        if z.createdBy == src then RP_ZONES[id] = nil end
    end
    broadcastRpZones()
end)

RegisterNetEvent("UNIQUE_AC:clientReady", function(spawnSerial, reason)
    local src = tonumber(source)
    local st = playerState(src)
    if not st then return end

    reason = tostring(reason or "unknown"):sub(1, 48)
    local connectedFor = monotonicMs() - (st.connectedAt or monotonicMs())
    local minimumMs = tonumber(cfg("MinimumClientReadyMs", 12000)) or 12000
    if connectedFor < minimumMs then
        return
    end

    st.readyAt = monotonicMs()
    SPAWNED[src] = true
    st.graceUntil = st.readyAt + cfg("PostReadyGraceMs", cfg("SpawnGraceMs", 20000))
    st.spawnSerial = tonumber(spawnSerial) or 0
    st.readyReason = reason
    broadcastRpZones(src)



    if not st.license then
        uniqueacLoadTrust(src)
    end
end)

RegisterNetEvent("UNIQUE_AC:reportDetection", function(action, reason, details)
    acceptClientReport(source, action, reason, details)
end)

RegisterNetEvent("UNIQUE_AC:BanFromClient", function(action, reason, details)
    acceptClientReport(source, action, reason, tostring(details or "legacy report"))
end)

local function verifyInjectionReport(src, resource, info)
    src = tonumber(src)
    if not src or not UNIQUE_AC.AntiInject or type(resource) ~= "string" or type(info) ~= "string" then return end
    if UNIQUE_AC_IS_TRUSTED(src) then return end
    resource = resource:sub(1, 100)
    info = info:sub(1, 300)
    if resource ~= "" and GetResourceState(resource) == "missing" then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.InjectPunishment, "Anti Inject",
            ("Unknown client resource `%s`: %s"):format(resource, info))
    end
end

RegisterNetEvent("UNIQUE_AC:BanForInject", function(_, details, resource)
    verifyInjectionReport(source, resource, tostring(details or "legacy report"))
end)

RegisterNetEvent("UNIQUE_AC:AntiInject", function(resource, info)
    verifyInjectionReport(source, resource, info)
end)

RegisterNetEvent("UNIQUE_AC:checkIsAdmin")
AddEventHandler("UNIQUE_AC:checkIsAdmin", function()
    local src = tonumber(source)
    if not src then return end
    local allowed = UNIQUE_AC.AdminMenu.Enable == true and UNIQUE_AC_GETADMINS(src)
    TriggerClientEvent("UNIQUE_AC:allowToOpen", src, allowed == true)
end)

RegisterNetEvent("UNIQUE_AC:CheckIsAdmin")
AddEventHandler("UNIQUE_AC:CheckIsAdmin", function()
    local src = tonumber(source)
    if not src then return end
    local allowed = UNIQUE_AC.AdminMenu.Enable == true and UNIQUE_AC_GETADMINS(src)
    TriggerClientEvent("UNIQUE_AC:allowToOpen", src, allowed == true)
end)

local function uniqueacCountPlayers()
    local count = 0
    for _, _ in ipairs(GetPlayers()) do
        count = count + 1
    end
    return count
end

local function uniqueacSafeListCount(fn, filter)
    if type(fn) ~= "function" then return 0 end

    local ok, list = pcall(fn)
    if not ok or type(list) ~= "table" then return 0 end
    if type(filter) ~= "function" then return #list end

    local count = 0
    for _, entity in ipairs(list) do
        local okFilter, result = pcall(filter, entity)
        if okFilter and result then count = count + 1 end
    end
    return count
end

local function uniqueacSendDashboardStats(src, databaseStats, recentAdmins, recentBans)
    if not src or not GetPlayerName(src) then return end
    local stats = {
        players = uniqueacCountPlayers(),
        vehicles = uniqueacSafeListCount(GetAllVehicles),
        props = uniqueacSafeListCount(GetAllObjects),
        peds = uniqueacSafeListCount(GetAllPeds, function(ped)
            return DoesEntityExist(ped) and not IsPedAPlayer(ped)
        end),
        bans = 0,
        admins = 0,
        whitelist = 0,
        unban = 0,
        recentAdmins = type(recentAdmins) == "table" and recentAdmins or {},
        recentBans = type(recentBans) == "table" and recentBans or {},
    }

    if type(databaseStats) == "table" then
        stats.bans = tonumber(databaseStats.bans) or 0
        stats.admins = tonumber(databaseStats.admins) or 0
        stats.whitelist = tonumber(databaseStats.whitelist) or 0
        stats.unban = tonumber(databaseStats.unban) or 0
    end

    TriggerClientEvent("UNIQUE_AC:updateDashboardStats", src, stats)
end

RegisterNetEvent("UNIQUE_AC:getDashboardStats")
AddEventHandler("UNIQUE_AC:getDashboardStats", function()
    local src = tonumber(source)
    if not src then return end

    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get UNIQUE_AC dashboard stats.")
        return
    end

    MySQL.Async.fetchAll([[
        SELECT
            (SELECT COUNT(*) FROM uniqueac_banlist) AS bans,
            (SELECT COUNT(*) FROM uniqueac_admin) AS admins,
            (SELECT COUNT(*) FROM uniqueac_whitelist) AS whitelist,
            (SELECT COUNT(*) FROM uniqueac_unban) AS unban
    ]], {}, function(rows)
        local row = rows and rows[1] or {}
        MySQL.Async.fetchAll('SELECT * FROM uniqueac_admin ORDER BY id DESC LIMIT 5', {}, function(adminRows)
            MySQL.Async.fetchAll('SELECT * FROM uniqueac_banlist ORDER BY id DESC LIMIT 5', {}, function(banRows)
                uniqueacSendDashboardStats(src, row, adminRows or {}, banRows or {})
            end)
        end)
    end)
end)

RegisterNetEvent("UNIQUE_AC:getAllPlayerData")
AddEventHandler("UNIQUE_AC:getAllPlayerData", function()
    local source = source

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try For Open Admin Menu (Not Admin)")
    else
        local PlayerList = {}
        for _, value in pairs(GetPlayers()) do
            local pid = tonumber(value)
            local st = playerState(pid)
            table.insert(PlayerList, {
                name = GetPlayerName(value),
                id   = value,
                identifier = uniqueacPlayerLicense(pid) or "no license yet",
                isAdmin = UNIQUE_AC_GETADMINS(pid) == true,
                isWhitelist = UNIQUE_AC_WHITELIST(pid) == true,
                trust = st and st.trust or 100,
                risk = st and st.riskScore or 0,
            })
        end
        TriggerClientEvent("UNIQUE_AC:sendAllPlayerData", source, PlayerList)
    end
end)

RegisterNetEvent("UNIQUE_AC:getPlayerData")
AddEventHandler("UNIQUE_AC:getPlayerData", function(playerId)
    local source = source
    playerId = tonumber(playerId)

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try for get a player data")
    else
        if GetPlayerName(playerId) then
            local data = {
                id     = playerId,
                name   = GetPlayerName(playerId),
                health = GetEntityHealth(GetPlayerPed(playerId)),
                armour = GetPedArmour(GetPlayerPed(playerId)),
                identifier = uniqueacPlayerLicense(playerId) or "no license yet",
                isAdmin = UNIQUE_AC_GETADMINS(playerId) == true,
                isWhitelist = UNIQUE_AC_WHITELIST(playerId) == true,
            }
            TriggerClientEvent("UNIQUE_AC:openPlayerData", source, data)
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:addPlayerAsAdmin")
AddEventHandler("UNIQUE_AC:addPlayerAsAdmin", function(playerId)
    local source = source
    playerId = tonumber(playerId)

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to set player as admin")
    else
        if GetPlayerName(playerId) then
            if not UNIQUE_AC_GETADMINS(playerId) then
                local added = UNIQUE_AC:ADDADMIN(playerId)
                if added then
                    TRUSTED_ADMINS[playerId] = true
                    invalidatePermissionCache(playerId)
                    UNIQUE_AC_CHANGE_TEMP_WHHITELIST(playerId, true, 120000)
                    TriggerClientEvent("UNIQUE_AC:clientGrace", playerId, 120000)
                    TriggerClientEvent("UNIQUE_AC:allowToOpen", playerId, true)
                end
            end
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:addPlayerAsWhiteList")
AddEventHandler("UNIQUE_AC:addPlayerAsWhiteList", function(playerId)
    local source = source
    playerId = tonumber(playerId)

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to set player as admin")
    else
        if GetPlayerName(playerId) then
            if not UNIQUE_AC_WHITELIST(playerId) then
                local added = UNIQUE_AC:ADDWHITELIST(playerId)
                if added then
                    invalidatePermissionCache(playerId)
                    UNIQUE_AC_CHANGE_TEMP_WHHITELIST(playerId, true, 120000)
                    TriggerClientEvent("UNIQUE_AC:clientGrace", playerId, 120000)
                end
            end
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:addPlayerUnbanAccess")
AddEventHandler("UNIQUE_AC:addPlayerUnbanAccess", function(playerId)
    local source = source
    playerId = tonumber(playerId)

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Try to add player unban access")
    else
        if GetPlayerName(playerId) then
            if not UNIQUE_AC_UNBANACCESS(playerId) then
                UNIQUE_AC:ADDUNBAN(playerId)
                invalidatePermissionCache(playerId)
            end
        end
    end
end)

function uniqueacPlayerLicense(src)
    src = tonumber(src)
    if not src then return nil end
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if type(identifier) == "string" and identifier:sub(1, 8) == "license:" then
            return identifier
        end
    end
    return nil
end

RegisterNetEvent("UNIQUE_AC:getAccessOnlinePlayers")
AddEventHandler("UNIQUE_AC:getAccessOnlinePlayers", function(scope)
    local src = tonumber(source)
    scope = tostring(scope or "")
    if not src or not UNIQUE_AC_GETADMINS(src) then
        if src then
            UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
                "Attempt to get online access picker data")
        end
        return
    end

    if scope ~= "admins" and scope ~= "whitelist" then return end

    local players = {}
    for _, value in ipairs(GetPlayers()) do
        local playerId = tonumber(value)
        if playerId and GetPlayerName(playerId) then
            table.insert(players, {
                id = playerId,
                name = GetPlayerName(playerId),
                identifier = uniqueacPlayerLicense(playerId) or "no license yet",
                isAdmin = UNIQUE_AC_GETADMINS(playerId) == true,
                isWhitelist = UNIQUE_AC_WHITELIST(playerId) == true
            })
        end
    end

    TriggerClientEvent("UNIQUE_AC:updateAccessOnlinePlayers", src, scope, players)
end)

local function spawnAdminVehicle(requester, data)
    local src = tonumber(requester)
    if not src or not UNIQUE_AC_GETADMINS(src) then
        if src then
            UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Spawn Vehicle",
                "Unauthorized admin vehicle spawn event")
        end
        return false
    end

    if type(data) ~= "table" or type(data.vehicleName) ~= "string" then return false end
    local vehicleName = data.vehicleName:lower():match("^[%w_%-]+$")
    if not vehicleName or #vehicleName > 64 then return false end

    local target = tonumber(data.targetId) or src
    if not target or not GetPlayerName(target) then return false end
    local ped = GetPlayerPed(target)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end

    uniqueacGrantActionGrace(src, 45000, "adminVehicleSpawn")
    uniqueacGrantActionGrace(target, 45000, "adminVehicleSpawn")

    local model = GetHashKey(vehicleName)
    if model == 0 then return false end
    local pos = GetEntityCoords(ped)
    local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, GetEntityHeading(ped), true, false)
    if not vehicle or vehicle == 0 then return false end

    local timeout = GetGameTimer() + 5000
    while not DoesEntityExist(vehicle) and GetGameTimer() < timeout do Wait(0) end
    if not DoesEntityExist(vehicle) then return false end

    SetPedIntoVehicle(ped, vehicle, -1)
    return true
end

RegisterNetEvent("UNIQUE_AC:spawnVehicle")
AddEventHandler("UNIQUE_AC:spawnVehicle", function(data)
    spawnAdminVehicle(source, data)
end)

local UNIQUE_AC_LIST_TABLES = {
    admins = {
        tableName = "uniqueac_admin",
        orderBy = "id",
        columns = "`id`, `identifier`, `player_name`",
        searchable = {"identifier", "player_name", "id"},
    },
    unban = {
        tableName = "uniqueac_unban",
        orderBy = "id",
        columns = "`id`, `identifier`, `player_name`",
        searchable = {"identifier", "player_name", "id"},
    },
    whitelist = {
        tableName = "uniqueac_whitelist",
        orderBy = "id",
        columns = "`id`, `identifier`, `player_name`",
        searchable = {"identifier", "player_name", "id"},
    },
    bans = {
        tableName = "uniqueac_banlist",
        orderBy = "id",
        columns = "*",
        searchable = {"PLAYER_NAME", "LICENSE", "DISCORD", "STEAM", "BANID", "REASON", "IP"},
    }
}

local function uniqueacListRequest(data)
    data = type(data) == "table" and data or {}
    local page = math.max(1, tonumber(data.page) or 1)
    local pageSize = math.max(5, math.min(100, tonumber(data.pageSize) or 25))
    local search = tostring(data.search or ""):gsub("[%c]", " "):sub(1, 96)
    return page, pageSize, search
end

local function uniqueacFetchPagedList(scope, request, cb)
    local cfgList = UNIQUE_AC_LIST_TABLES[scope]
    if not cfgList then cb({}, { page = 1, pageSize = 25, total = 0, search = "" }) return end

    if scope == "admins" or scope == "unban" or scope == "whitelist" then
        uniqueacEnsureColumn(cfgList.tableName, "player_name", "varchar(128) NULL DEFAULT NULL AFTER `identifier`")
    elseif scope == "bans" then
        uniqueacEnsureColumn(cfgList.tableName, "PLAYER_NAME", "varchar(128) NULL DEFAULT NULL AFTER `id`")
    end

    local page, pageSize, search = uniqueacListRequest(request)
    local offset = (page - 1) * pageSize
    local params = { ["@limit"] = pageSize, ["@offset"] = offset }
    local where = ""

    if search ~= "" then
        local pieces = {}
        for index, column in ipairs(cfgList.searchable or {}) do
            local key = "@q" .. tostring(index)
            params[key] = "%" .. search .. "%"
            pieces[#pieces + 1] = ("CAST(`%s` AS CHAR) LIKE %s"):format(column, key)
        end
        if #pieces > 0 then
            where = " WHERE " .. table.concat(pieces, " OR ")
        end
    end

    local countSql = ("SELECT COUNT(*) AS total FROM `%s`%s"):format(cfgList.tableName, where)
    MySQL.Async.fetchAll(countSql, params, function(countRows)
        local total = tonumber(countRows and countRows[1] and countRows[1].total) or 0
        local maxPage = math.max(1, math.ceil(total / pageSize))
        if page > maxPage then
            page = maxPage
            offset = (page - 1) * pageSize
            params["@offset"] = offset
        end

        local sql = ("SELECT %s FROM `%s`%s ORDER BY `%s` DESC LIMIT %d OFFSET %d"):format(
            cfgList.columns, cfgList.tableName, where, cfgList.orderBy, pageSize, offset
        )

        MySQL.Async.fetchAll(sql, params, function(rows)
            cb(rows or {}, {
                page = page,
                pageSize = pageSize,
                total = total,
                search = search
            })
        end)
    end)
end

RegisterNetEvent('UNIQUE_AC:getAdminListData')
AddEventHandler('UNIQUE_AC:getAdminListData', function(request)
    local source = source
    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get admins data by admin menu event.")
        return
    end

    uniqueacFetchPagedList("admins", request, function(rows, meta)
        TriggerClientEvent("UNIQUE_AC:updateAdminData", source, rows, meta)
    end)
end)

RegisterNetEvent('UNIQUE_AC:removeSelectedAdmin')
AddEventHandler('UNIQUE_AC:removeSelectedAdmin', function(id)
    local source = source

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove admins data by admin menu event.")
    else
        MySQL.Async.execute('DELETE FROM uniqueac_admin WHERE id=@id', {
            ['@id'] = tonumber(id) or -1
        }, function()
            TRUSTED_ADMINS = {}
            invalidatePermissionCache()
        end)
    end
end)

RegisterNetEvent('UNIQUE_AC:getUnbanAccessData')
AddEventHandler('UNIQUE_AC:getUnbanAccessData', function(request)
    local source = source
    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get unban data by admin menu event.")
        return
    end

    uniqueacFetchPagedList("unban", request, function(rows, meta)
        TriggerClientEvent("UNIQUE_AC:updateUnbanAccess", source, rows, meta)
    end)
end)

RegisterNetEvent('UNIQUE_AC:removeUnbanAccess')
AddEventHandler('UNIQUE_AC:removeUnbanAccess', function(id)
    local source = source

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove player from unban access list.")
    else
        MySQL.Async.execute('DELETE FROM uniqueac_unban WHERE id=@id', {
            ['@id'] = tonumber(id) or -1
        }, function() invalidatePermissionCache() end)
    end
end)

RegisterNetEvent('UNIQUE_AC:removeWhitelistUser')
AddEventHandler('UNIQUE_AC:removeWhitelistUser', function(id)
    local source = source

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove user from whitelist by admin menu event.")
    else
        MySQL.Async.execute('DELETE FROM uniqueac_whitelist WHERE id=@id', {
            ['@id'] = tonumber(id) or -1
        }, function() invalidatePermissionCache() end)
    end
end)

RegisterNetEvent('UNIQUE_AC:getWhitelistData')
AddEventHandler('UNIQUE_AC:getWhitelistData', function(request)
    local source = source
    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get whitelist data by admin menu event.")
        return
    end

    uniqueacFetchPagedList("whitelist", request, function(rows, meta)
        TriggerClientEvent("UNIQUE_AC:updateWhiteList", source, rows, meta)
    end)
end)

RegisterNetEvent('UNIQUE_AC:getBanListData')
AddEventHandler('UNIQUE_AC:getBanListData', function(request)
    local source = source
    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to get banlist data by admin menu event.")
        return
    end

    uniqueacFetchPagedList("bans", request, function(rows, meta)
        TriggerClientEvent("UNIQUE_AC:updateBanListData", source, rows, meta)
    end)
end)

RegisterNetEvent('UNIQUE_AC:unbanSelectedPlayer')
AddEventHandler('UNIQUE_AC:unbanSelectedPlayer', function(banID)
    local source = source

    if not UNIQUE_AC_GETADMINS(source) then
        UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Attempt to remove player from banlist by admin menu event.")
    else
        MySQL.Async.execute('DELETE FROM uniqueac_banlist WHERE BANID=@banid', {
            ['@banid'] = tonumber(banID) or -1
        })
    end
end)

RegisterNetEvent("UNIQUE_AC:deleteEntitys")
AddEventHandler("UNIQUE_AC:deleteEntitys", function(entityType)
    local source = source

    if entityType ~= nil then
        if UNIQUE_AC_GETADMINS(source) then
            if entityType == "vehicles" then
                for index, vehicles in ipairs(GetAllVehicles()) do
                    if DoesEntityExist(vehicles) then
                        DeleteEntity(vehicles)
                    end
                end
            elseif entityType == "peds" then
                for _, ped in ipairs(GetAllPeds()) do
                    if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                        DeleteEntity(ped)
                    end
                end
            elseif entityType == "props" then
                for index, objects in ipairs(GetAllObjects()) do
                    if DoesEntityExist(objects) then
                        DeleteEntity(objects)
                    end
                end
            end
        else
            UNIQUE_AC_ACTION(source, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Delete Entity", "Try For Delete Entitys")
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:TeleportToPlayer", function(targetId)
    local src = tonumber(source)
    local target = tonumber(targetId)
    if not src or not target or not GetPlayerName(target) then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Teleport", "Unauthorized admin teleport event")
        return
    end
    local sourcePed, targetPed = GetPlayerPed(src), GetPlayerPed(target)
    if sourcePed == 0 or targetPed == 0 then return end
    uniqueacGrantActionGrace(src, 90000, "adminGoto")
    uniqueacGrantActionGrace(target, 90000, "adminGotoTargetNear")
    local coords = GetEntityCoords(targetPed)
    SetEntityCoords(sourcePed, coords.x, coords.y, coords.z, false, false, false, false)
end)

RegisterNetEvent("UNIQUE_AC:BringPlayerToAdmin", function(targetId)
    local src = tonumber(source)
    local target = tonumber(targetId)
    if not src or not target or not GetPlayerName(target) or target == src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Teleport", "Unauthorized admin bring event")
        return
    end
    local sourcePed, targetPed = GetPlayerPed(src), GetPlayerPed(target)
    if sourcePed == 0 or targetPed == 0 then return end
    uniqueacGrantActionGrace(src, 90000, "adminBring")
    uniqueacGrantActionGrace(target, 120000, "adminBringTarget")
    local coords = GetEntityCoords(sourcePed)
    SetEntityCoords(targetPed, coords.x + 1.0, coords.y + 1.0, coords.z, false, false, false, false)
end)

RegisterNetEvent("UNIQUE_AC:SlapPlayer", function(targetId)
    local src = tonumber(source)
    local target = tonumber(targetId)
    if not src or not target or not GetPlayerName(target) or target == src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Admin Action", "Unauthorized admin slap event")
        return
    end
    uniqueacGrantActionGrace(target, 6000, "adminSlap")
    TriggerClientEvent("UNIQUE_AC:applySlap", target)
end)

RegisterNetEvent("UNIQUE_AC:KickPlayerByAdmin", function(targetId, reason)
    local src = tonumber(source)
    local target = tonumber(targetId)
    if not src or not target or not GetPlayerName(target) or target == src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Kick Players", "Unauthorized admin kick event")
        return
    end
    reason = tostring(reason or "Kicked by admin menu"):gsub("[%c]", " "):sub(1, 160)
    DropPlayer(target, ("\n[UNIQUE_AC]\nYou have been kicked by an administrator.\nReason: %s"):format(reason))
end)

RegisterNetEvent("UNIQUE_AC:GiveVehicleToPlayer", function(vehicleName, targetId)
    spawnAdminVehicle(source, { vehicleName = vehicleName, targetId = tonumber(targetId) })
end)

RegisterNetEvent("UNIQUE_AC:GetScreenShot", function(playerId)
    local src, target = tonumber(source), tonumber(playerId)
    if not src or not target or not GetPlayerName(target) then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Get ScreenShot", "Unauthorized screenshot request")
        return
    end
    if GetResourceState("discord-screenshot") ~= "started" then return end
    local webhook = UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.ScreenShot or ""
    if type(webhook) ~= "string" or not webhook:match("^https?://") then return end
    UNIQUE_AC_SCREENSHOT(target, "By Admin Menu", "Requested by " .. (GetPlayerName(src) or tostring(src)), "WARN")
end)

RegisterNetEvent("UNIQUE_AC:banPlayerByAdmin", function(targetId, reason, confirmName)
    local src, target = tonumber(source), tonumber(targetId)
    if not src or not target or not GetPlayerName(target) then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Ban Players", "Unauthorized admin ban event")
        return
    end
    if target == src then return end

    if UNIQUE_AC.ConfirmBan and UNIQUE_AC.ConfirmBan.Enable then
        local actualName = tostring(GetPlayerName(target) or ""):lower():gsub("%s+", "")
        local typedName = tostring(confirmName or ""):lower():gsub("%s+", "")
        if typedName == "" or typedName ~= actualName then
            uniqueacNotify(src, "Ban not sent — the name you typed didn't match the target's current name.", { 255, 100, 100 })
            return
        end
    end

    local adminName = GetPlayerName(src) or ("ID " .. tostring(src))
    local targetLicense = uniqueacPlayerLicense(target)
    local targetName = GetPlayerName(target) or ("ID " .. tostring(target))
    UNIQUE_AC_LOG_ADMIN_ACTION(src, "BAN", targetLicense, targetName, reason or "Banned by UNIQUE_AC admin menu")
    UNIQUE_AC_BAN_PLAYER(target, reason or "Banned by UNIQUE_AC admin menu", "Admin " .. adminName .. " (" .. tostring(src) .. ")")
end)

RegisterNetEvent("UNIQUE_AC:requestSpectate", function(targetId)
    local src, target = tonumber(source), tonumber(targetId)
    if not src or not target or not GetPlayerName(target) or target == src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Spectate Players", "Unauthorized spectate event")
        return
    end
    local targetPed = GetPlayerPed(target)
    if not targetPed or targetPed == 0 or not DoesEntityExist(targetPed) then return end
    uniqueacGrantActionGrace(src, 90000, "adminSpectate")
    TriggerClientEvent("UNIQUE_AC:spectatePlayer", src, target, GetEntityCoords(targetPed))
end)

RegisterNetEvent("UNIQUE_AC:CheckJumping", function()
    local src = tonumber(source)
    if not src or not GetPlayerName(src) then return end
    local st = playerState(src)
    if not st or st.readyAt == 0 or monotonicMs() < st.graceUntil then return end
    if UNIQUE_AC_IS_TRUSTED(src) then return end
    if IsPlayerUsingSuperJump(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.JumpPunishment, "Anti Superjump", "Server native confirmed super jump")
    end
end)

RegisterNetEvent("UNIQUE_AC:ScreenShotFromClient", function()
    return
end)

AddEventHandler("playerDropped", function(reason)
    local src = tonumber(source)
    local name = GetPlayerName(src) or ("ID " .. tostring(src))
    reason = tostring(reason or "Unknown")
    print(("^%s[UNIQUE_AC]^0 ^1Player ^3%s ^1disconnected | ^0%s"):format(COLORS, name, reason))
    if GetPlayerName(src) then
        UNIQUE_AC_SENDLOG(src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Disconnect or "", "DISCONNECT", reason)
    end
end)

AddEventHandler("giveWeaponEvent", function(SRC, DATA)
    if UNIQUE_AC.AntiAddWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not UNIQUE_AC_IS_TRUSTED(SRC) then
                CancelEvent()
                UNIQUE_AC_ACTION(SRC, UNIQUE_AC.WeaponPunishment, "Anti Add Weapon", "Try for add weapon for player")
            end
        else
            UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

AddEventHandler("RemoveWeaponEvent", function(SRC, DATA)
    if UNIQUE_AC.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not UNIQUE_AC_IS_TRUSTED(SRC) then
                CancelEvent()
                UNIQUE_AC_ACTION(SRC, UNIQUE_AC.WeaponPunishment, "Anti Remove Weapon", "Try for remove weapon for player")
            end
        else
            UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

AddEventHandler("RemoveAllWeaponsEvent", function(SRC, DATA)
    if UNIQUE_AC.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not UNIQUE_AC_IS_TRUSTED(SRC) then
                CancelEvent()
                UNIQUE_AC_ACTION(SRC, UNIQUE_AC.WeaponPunishment, "Anti Remove All Weapon",
                    "Try for remove all weapon for player")
            end
        else
            UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:AddToSpawnList", function()
    local src = tonumber(source)
    local st = playerState(src)
    if not st or st.readyAt == 0 then return end
    SPAWNED[src] = true
    st.graceUntil = math.max(st.graceUntil, monotonicMs() + cfg("RespawnGraceMs", 10000))
end)

local EVENTS = {}
if UNIQUE_AC.AntiSpamTrigger then
    for i = 1, #SpamCheck do
        local eventName = SpamCheck[i].EVENT
        local maxCount = tonumber(SpamCheck[i].MAX_TIME) or 10
        RegisterNetEvent(eventName)
        AddEventHandler(eventName, function()
            local src = tonumber(source)
            if not src or src <= 0 then return end
            local now = os.time()
            EVENTS[src] = EVENTS[src] or {}
            local state = EVENTS[src][eventName]
            if not state or now - state.startedAt >= 10 then
                state = { count = 0, startedAt = now }
                EVENTS[src][eventName] = state
            end
            state.count = state.count + 1
            if state.count > maxCount then
                UNIQUE_AC_ACTION(src, UNIQUE_AC.TriggerPunishment, "Anti Spam Trigger",
                    ("Event `%s` fired %s times within 10 seconds"):format(eventName, state.count))
                CancelEvent()
            end
        end)
    end
end

local SERVER_CMDS = {}
if type(Commands) == "table" then
    for _, blockedCommand in ipairs(Commands) do
        local commandName = tostring(blockedCommand)
        if commandName ~= "" then
            RegisterCommand(commandName, function(src)
                src = tonumber(src)
                if UNIQUE_AC.AntiBlackListCommands and src and src > 0 then
                    UNIQUE_AC_ACTION(src, UNIQUE_AC.CMDPunishment, "Anti Black List Commands",
                        "Attempted blocked command: " .. commandName)
                end
            end, false)
        end
    end
end

local MESSAGE = {}
AddEventHandler("chatMessage", function(src, _, word)
    src = tonumber(src)
    if not src or src <= 0 or not GetPlayerName(src) then return end
    if UNIQUE_AC_IS_TRUSTED(src) then return end

    local text = tostring(word or "")
    local lower = text:lower()
    if UNIQUE_AC.AntiBlackListWord and type(Words) == "table" then
        for _, blocked in ipairs(Words) do
            local needle = tostring(blocked):lower()
            if needle ~= "" and lower:find(needle, 1, true) then
                UNIQUE_AC_ACTION(src, UNIQUE_AC.WordPunishment, "Anti Bad Word", "Blocked chat term detected")
                CancelEvent()
                return
            end
        end
    end

    if not UNIQUE_AC.AntiSpamChat then return end
    local now = os.time()
    local state = MESSAGE[src]
    if not state or now - state.startedAt >= (tonumber(UNIQUE_AC.CoolDownSec) or 3) then
        state = { count = 0, startedAt = now, acted = false }
        MESSAGE[src] = state
    end
    state.count = state.count + 1
    local maximum = tonumber(UNIQUE_AC.MaxMessage) or 10
    if state.count >= maximum and not state.acted then
        state.acted = true
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.ChatPunishment, "Anti Spam Chat",
            ("Sent %s messages in %s seconds"):format(state.count, tonumber(UNIQUE_AC.CoolDownSec) or 3))
    end
end)

if UNIQUE_AC.AntiBlackListTrigger and type(Events) == "table" then
    for _, blockedEvent in ipairs(Events) do
        local eventName = tostring(blockedEvent)
        RegisterNetEvent(eventName)
        AddEventHandler(eventName, function()
            local src = tonumber(source)
            if not src or UNIQUE_AC_IS_TRUSTED(src) then return end
            CancelEvent()
            UNIQUE_AC_ACTION(src, UNIQUE_AC.TriggerPunishment, "Anti Black List Trigger",
                "Attempted blocked event: " .. eventName)
        end)
    end
end

AddEventHandler("db:updateUser", function(data)
    local src = tonumber(source)
    if not UNIQUE_AC.AntiChangePerm or not src or UNIQUE_AC_IS_TRUSTED(src) then return end
    if type(data) ~= "table" or not data.playerName or not data.dateofbirth then
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.PermPunishment, "Anti Change Perm", "Malformed db:updateUser payload")
    end
end)

local EXPLOSION = {}
AddEventHandler("explosionEvent", function(src, data)
    src = tonumber(src)
    if not src or src <= 0 or type(data) ~= "table" then
        CancelEvent()
        return
    end
    if UNIQUE_AC_IS_TRUSTED(src) then return end

    local definition = type(Explosion) == "table" and Explosion[tonumber(data.explosionType)] or nil
    if definition then
        local name = tostring(definition.NAME or data.explosionType or "Unknown")
        if definition.Log then
            UNIQUE_AC_SENDLOG(src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Exoplosion or "", "EXPLOSION", name)
        end
        local punishment = type(definition.Punishment) == "string" and definition.Punishment:upper() or nil
        if punishment == "WARN" or punishment == "KICK" or punishment == "BAN" then
            CancelEvent()
            UNIQUE_AC_ACTION(src, punishment, "Anti Explosion", "Blocked explosion type: " .. name)
            return
        end
    end

    if not UNIQUE_AC.AntiExplosionSpam then return end
    local key = GetPlayerToken(src, 0) or tostring(src)
    local now = os.time()
    local state = EXPLOSION[key]
    if not state or now - state.startedAt >= 10 then
        state = { count = 0, startedAt = now, acted = false }
        EXPLOSION[key] = state
    end
    state.count = state.count + 1
    if state.count >= (tonumber(UNIQUE_AC.MaxExplosion) or 10) and not state.acted then
        state.acted = true
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.ExplosionSpamPunishment, "Anti Spam Explosion",
            ("Created %s explosions within 10 seconds"):format(state.count))
    end
end)

if GetResourceState("interact-sound") == "started" then
    local blockedSounds = {
        ["10000:handcuff"] = true, ["1000:Cuff"] = true, ["103232:lock"] = true,
        ["10:szajbusek"] = true, ["5:alarm"] = true, ["13232:pasysound"] = true,
        ["5000:demo"] = true,
    }
    AddEventHandler("InteractSound_SV:PlayWithinDistance", function(maxDistance, soundFile)
        local src = tonumber(source)
        if not UNIQUE_AC.AntiPlaySound or not src or UNIQUE_AC_IS_TRUSTED(src) then return end
        local key = tostring(tonumber(maxDistance) or maxDistance) .. ":" .. tostring(soundFile)
        if blockedSounds[key] then
            CancelEvent()
            UNIQUE_AC_ACTION(src, UNIQUE_AC.SoundPunishment, "Anti Play Sound", "Blocked sound payload: " .. key)
        end
    end)
end

local TAZE, FREEZE = {}, {}
AddEventHandler("weaponDamageEvent", function(src, data)
    src = tonumber(src)
    if not UNIQUE_AC.AntiTazePlayers or not src or type(data) ~= "table" or data.weaponType ~= 911657153 then return end
    if UNIQUE_AC_IS_TRUSTED(src) then return end
    local key = GetPlayerToken(src, 0) or tostring(src)
    local now = os.time()
    local state = TAZE[key]
    if not state or now - state.startedAt >= 10 then
        state = { count = 0, startedAt = now, acted = false }
        TAZE[key] = state
    end
    state.count = state.count + 1
    if state.count >= (tonumber(UNIQUE_AC.MaxTazeSpam) or 8) and not state.acted then
        state.acted = true
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.TazePunishment, "Anti Spam Tazer",
            ("Tazer damage repeated %s times within 10 seconds"):format(state.count))
    end
end)

AddEventHandler("clearPedTasksEvent", function(src)
    src = tonumber(src)
    if not UNIQUE_AC.AntiClearPedTasks or not src then return end
    if UNIQUE_AC_IS_TRUSTED(src) then return end
    local key = GetPlayerToken(src, 0) or tostring(src)
    local now = os.time()
    local state = FREEZE[key]
    if not state or now - state.startedAt >= 10 then
        state = { count = 0, startedAt = now, acted = false }
        FREEZE[key] = state
    end
    state.count = state.count + 1
    if state.count >= (tonumber(UNIQUE_AC.MaxClearPedTasks) or 8) and not state.acted then
        state.acted = true
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.CPTPunishment, "Anti Clear Ped Tasks",
            ("clearPedTasksEvent repeated %s times within 10 seconds"):format(state.count))
    end
end)

RegisterNetEvent("esx_ambulancejob:syncDeadBody")
AddEventHandler("esx_ambulancejob:syncDeadBody", function(ped, target)
    local src = tonumber(source)
    if not UNIQUE_AC.AntiBringAll or not src or UNIQUE_AC_IS_TRUSTED(src) then return end
    local targetId = tonumber(target)
    if targetId == -1 or (targetId and targetId ~= src and not GetPlayerName(targetId)) then
        CancelEvent()
        UNIQUE_AC_ACTION(src, UNIQUE_AC.BringAllPunishment, "Anti Bring All Players", "Invalid ambulance sync target")
    end
end)

AddEventHandler("onResourceStarting", function(RES)
    UNIQUE_AC_REFRESHCMD()
end)

AddEventHandler("onResourceStop", function(RES)
    UNIQUE_AC_REFRESHCMD()
end)

local function uniqueacConnectionConfig(name, fallback)
    if UNIQUE_AC and UNIQUE_AC.Connection and UNIQUE_AC.Connection[name] ~= nil then
        return UNIQUE_AC.Connection[name]
    end
    return fallback
end

local function uniqueacDeferralMode()
    local mode = tostring(uniqueacConnectionConfig("DeferralMode", "legacy") or "legacy"):lower()
    if mode == "legacy" then mode = "update" end
    if mode ~= "card" and mode ~= "update" and mode ~= "silent" then
        mode = "update"
    end
    if mode == "card" and not uniqueacConnectionConfig("AdaptiveCard", false) then
        mode = "update"
    end
    return mode
end

local function uniqueacConnectionUiEnabled()
    return uniqueacConnectionConfig("ShowConnectUI", true) ~= false
end

local function uniqueacProblemOnlyMode()
    return uniqueacConnectionConfig("ProblemOnlyMode", false) == true
end

local function uniqueacShouldShowConnectionStep(isProblem)
    if uniqueacConnectionUiEnabled() then
        return true
    end
    return isProblem == true and uniqueacConnectionConfig("ShowProblemCard", true) == true
end

local function uniqueacDeferralWait(multiplier)
    local ms = tonumber(uniqueacConnectionConfig("DeferralStepMs", 150)) or 150
    if ms < 0 then ms = 0 end
    if ms > 1000 then ms = 1000 end
    Wait(math.floor(ms * (tonumber(multiplier) or 1)))
end

local function uniqueacText(value, fallback, maxLen)
    local out = tostring(value or fallback or "")
    out = out:gsub("[%c]", "")
    maxLen = tonumber(maxLen) or 180
    if #out > maxLen then
        out = out:sub(1, maxLen - 3) .. "..."
    end
    return out
end

local function uniqueacDeferralUpdate(deferrals, message)
    if uniqueacDeferralMode() == "silent" then
        uniqueacDeferralWait()
        return true
    end
    if not deferrals or not deferrals.update then return false end
    local ok = pcall(function()
        deferrals.update(uniqueacText(message, "UNIQUE_AC security validation is running...", 240))
    end)
    uniqueacDeferralWait()
    return ok
end

local function uniqueacVisualDelay(multiplier)
    local ms = tonumber(uniqueacConnectionConfig("VisualStepMs", 420)) or 420
    if ms < 0 then ms = 0 end
    if ms > 1500 then ms = 1500 end
    Wait(math.floor(ms * (tonumber(multiplier) or 1)))
end

local function uniqueacProgress(step, total)
    step = tonumber(step) or 1
    total = tonumber(total) or 4
    if step < 1 then step = 1 end
    if step > total then step = total end
    local slots = 10
    local filled = math.floor((step / total) * slots + 0.5)
    if filled < 1 then filled = 1 end
    if filled > slots then filled = slots end
    return "[" .. string.rep("#", filled) .. string.rep("-", slots - filled) .. "]"
end

local function uniqueacConnectBrand()
    return uniqueacText(uniqueacConnectionConfig("CardTitle", "UNIQUE_AC SECURITY"), "UNIQUE_AC SECURITY", 32):upper()
end

local function uniqueacStatus(deferrals, step, total, title, detail, delayMultiplier)
    if not deferrals or not deferrals.update then return false end
    local brand = uniqueacConnectBrand()
    local msg = string.format("[%s] %s %s", brand, uniqueacProgress(step, total), uniqueacText(title, "Checking connection", 80))
    if detail and tostring(detail) ~= "" then
        msg = msg .. " | " .. uniqueacText(detail, "", 80)
    end
    local ok = pcall(function()
        deferrals.update(uniqueacText(msg, "[UNIQUE_AC] Checking connection...", 220))
    end)
    uniqueacVisualDelay(delayMultiplier or 1)
    return ok
end

local function uniqueacAdaptivePercent(step, total)
    step = tonumber(step) or 1
    total = tonumber(total) or 4
    if step < 1 then step = 1 end
    if step > total then step = total end
    local value = math.floor((step / total) * 100 + 0.5)
    if value < 0 then value = 0 end
    if value > 100 then value = 100 end
    return value
end

local UNIQUE_AC_CONNECT_STEP_LABELS = {
    [1] = "Gateway initialization",
    [2] = "Identity verification",
    [3] = "Security validation",
    [4] = "Connection result"
}

local function uniqueacBuildConnectCard(step, total, title, detail, accent)
    local brand = uniqueacConnectBrand()
    local percent = uniqueacAdaptivePercent(step, total)
    local safeTitle = uniqueacText(title, "Checking connection", 70)
    local safeDetail = uniqueacText(detail, "Please wait", 120)
    local color = uniqueacText(accent, "Accent", 16)


    local barSlots = 12
    local barFilled = math.floor((tonumber(step) or 1) / (tonumber(total) or 4) * barSlots + 0.5)
    if barFilled < 1 then barFilled = 1 end
    if barFilled > barSlots then barFilled = barSlots end
    local barColumns = {}
    for i = 1, barSlots do
        barColumns[#barColumns + 1] = {
            type = "Column",
            width = "stretch",
            spacing = i == 1 and "None" or "Small",
            items = {
                {
                    type = "TextBlock",
                    text = "▬",
                    size = "Large",
                    weight = "Bolder",
                    horizontalAlignment = "Center",
                    spacing = "None",
                    color = i <= barFilled and color or "Default",
                    isSubtle = i > barFilled
                }
            }
        }
    end

    local body = {
        {
            type = "Container",
            style = "emphasis",
            items = {
                {
                    type = "TextBlock",
                    text = "🛡️ " .. brand,
                    weight = "Bolder",
                    size = "Large",
                    color = "Attention",
                    horizontalAlignment = "Center",
                    wrap = true
                },
                {
                    type = "TextBlock",
                    text = "Protected connection screening",
                    isSubtle = true,
                    spacing = "None",
                    horizontalAlignment = "Center",
                    wrap = true
                }
            }
        },
        {
            type = "TextBlock",
            text = safeTitle,
            weight = "Bolder",
            size = "Medium",
            color = color,
            horizontalAlignment = "Center",
            wrap = true,
            spacing = "Medium"
        },
        {
            type = "TextBlock",
            text = safeDetail,
            isSubtle = true,
            horizontalAlignment = "Center",
            wrap = true,
            spacing = "Small"
        },
        {
            type = "ColumnSet",
            spacing = "Medium",
            columns = barColumns
        },
        {
            type = "TextBlock",
            text = tostring(percent) .. "% complete",
            weight = "Bolder",
            size = "Small",
            horizontalAlignment = "Center",
            wrap = true,
            spacing = "Small"
        },
        {
            type = "TextBlock",
            text = "Security pipeline",
            weight = "Bolder",
            color = "Accent",
            spacing = "Medium",
            separator = true,
            wrap = true
        }
    }

    for index = 1, total do
        local isDone = index < step
        local isLive = index == step
        local icon = isDone and "✅" or (isLive and "🔷" or "⚪")
        local rowColor = isDone and "Good" or (isLive and color or "Default")
        local label = uniqueacText(UNIQUE_AC_CONNECT_STEP_LABELS[index] or ("Step " .. tostring(index)), "Step", 48)

        body[#body + 1] = {
            type = "ColumnSet",
            spacing = index == 1 and "Small" or "None",
            columns = {
                {
                    type = "Column",
                    width = "auto",
                    items = { { type = "TextBlock", text = icon, wrap = true, spacing = "None" } }
                },
                {
                    type = "Column",
                    width = "stretch",
                    items = {
                        {
                            type = "TextBlock",
                            text = label,
                            color = rowColor,
                            weight = isLive and "Bolder" or "Default",
                            isSubtle = not isDone and not isLive,
                            wrap = true,
                            spacing = "None"
                        }
                    }
                }
            }
        }
    end

    body[#body + 1] = {
        type = "TextBlock",
        text = "🔒 Please keep this screen open while the connection is being validated.",
        isSubtle = true,
        wrap = true,
        separator = true,
        spacing = "Medium"
    }

    body[#body + 1] = {
        type = "TextBlock",
        text = "UNIQUE_AC  •  arshiahub.ir",
        color = "Accent",
        isSubtle = true,
        size = "Small",
        horizontalAlignment = "Center",
        wrap = true,
        spacing = "Medium"
    }

    return {
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        type = "AdaptiveCard",
        version = "1.0",
        body = body
    }
end

local function uniqueacPresentCard(deferrals, step, total, title, detail, accent)
    if uniqueacDeferralMode() ~= "card" then
        return uniqueacStatus(deferrals, step, total, title, detail, 1)
    end
    if not deferrals or not deferrals.presentCard then
        return uniqueacStatus(deferrals, step, total, title, detail, 1)
    end

    uniqueacDeferralWait()

    local card = uniqueacBuildConnectCard(step, total, title, detail, accent)
    local encoded = nil
    local okJson = pcall(function()
        encoded = json.encode(card)
    end)
    if not okJson or not encoded or encoded == "" then
        return uniqueacStatus(deferrals, step, total, title, detail, 1)
    end

    local ok = pcall(function()
        deferrals.presentCard(encoded)
    end)

    uniqueacDeferralWait()
    if not ok then
        print("^3[UNIQUE_AC]^0 presentCard failed at Lua level; falling back to deferrals.update.")
        return uniqueacStatus(deferrals, step, total, title, detail, 1)
    end

    local hold = tonumber(uniqueacConnectionConfig("PresentCardHoldMs", 1600)) or 1600
    if hold < 0 then hold = 0 end
    if hold > 5000 then hold = 5000 end
    if hold > 0 then Wait(math.floor(hold)) end
    return true
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local src = tonumber(source)
    if not src then return end
    playerState(src)

    if connectionCfg("UseDeferrals", true) ~= true then
        return
    end

    local name = uniqueacText(playerName or GetPlayerName(src) or ("ID " .. tostring(src)), "Player", 64)
    print(("^%sUNIQUE_AC^0: ^2Player ^3%s ^2Connecting ...^0"):format(COLORS, name))

    local hasDeferral = deferrals and deferrals.defer and deferrals.update and deferrals.done
    if not hasDeferral then
        return
    end

    deferrals.defer()
    Wait(0)

    local function showStatus(step, total, title, detail, delayMultiplier, accent, isProblem)
        if not uniqueacShouldShowConnectionStep(isProblem == true) then
            uniqueacDeferralWait(delayMultiplier or 1)
            return true
        end

        if uniqueacDeferralMode() == "card" then
            return uniqueacPresentCard(deferrals, step, total, title, detail, accent or "Attention")
        end

        return uniqueacStatus(deferrals, step, total, title, detail, delayMultiplier or 1)
    end

    local startDelay = tonumber(uniqueacConnectionConfig("DeferralDelayMs", 0)) or 0
    if startDelay < 0 then startDelay = 0 end
    if startDelay > 10000 then startDelay = 10000 end
    if startDelay > 0 then Wait(math.floor(startDelay)) end

    showStatus(1, 4, "Initializing secure gateway", "Protected by UNIQUE_AC", 1, "Attention")
    showStatus(2, 4, "Verifying player identity", name, 1, "Accent")

    local function finish(message)
        if message and message ~= "" then
            pcall(function() deferrals.done(message) end)
        else
            pcall(function() deferrals.done() end)
        end
    end

    showStatus(3, 4, "Checking ban database", "Please wait", 0.8, "Accent")
    local okBan, banData = pcall(UNIQUE_AC_INBANLIST, src)
    if okBan and banData and banData[1] then
        local reason = uniqueacText(banData[1].REASON, "Unknown", 160)
        local banId = uniqueacText(banData[1].BANID, "N/A", 48)
        print(("^%sUNIQUE_AC^0: ^1Blocked banned player ^3%s^0 | Ban ID: %s"):format(COLORS, name, banId))
        pcall(UNIQUE_AC_SENDLOG, src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Connect or "", "TFJ", banId, reason)
        showStatus(4, 4, "Connection blocked", "Ban ID #" .. banId, 1, "Attention", true)
        Wait(600)
        finish(("\n[UNIQUE_AC]\nYou are banned from this server.\nReason: %s\nBan ID: #%s"):format(reason, banId))
        return
    elseif not okBan then
        print("^3[UNIQUE_AC]^0 Ban-list lookup failed during connection; allowing player fail-open.")
    end

    if UNIQUE_AC.Connection and UNIQUE_AC.Connection.AntiBlackListName and type(Names) == "table" then
        local normalizedName = uniqueacNormalizeName(playerName or name)
        for _, blocked in ipairs(Names) do
            local needle = uniqueacNormalizeName(blocked)
            if needle ~= "" and normalizedName:find(needle, 1, true) then
                print(("^%sUNIQUE_AC^0: ^1Player ^3%s ^3Try For Join ^0| ^3Black List Word in name: ^3%s^0"):format(COLORS, name, tostring(blocked)))
                pcall(UNIQUE_AC_SENDLOG, src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Connect or "", "BLN", "Black List Name", "Found " .. tostring(blocked) .. " in player name")
                showStatus(4, 4, "Connection blocked", "Invalid player name", 1, "Attention", true)
                Wait(600)
                finish(("\n[UNIQUE_AC]\nYour player name contains a blocked term: %s"):format(tostring(blocked)))
                return
            end
        end
    end

    local endpoint = tostring(GetPlayerEndpoint(src) or "")
    local localEndpoint = endpoint == "" or endpoint == "127.0.0.1" or endpoint:find("192.168.", 1, true) == 1 or endpoint:find("10.", 1, true) == 1 or endpoint:find("172.16.", 1, true) == 1
    local function allow(statusDetail)
        if not uniqueacProblemOnlyMode() then
            showStatus(4, 4, "Connection accepted", statusDetail or "Welcome to the server", 1, "Good")
        else
            uniqueacDeferralWait(0.5)
        end
        pcall(UNIQUE_AC_SENDLOG, src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Connect or "", "CONNECT")
        local hold = tonumber(uniqueacConnectionConfig("ConnectHoldMs", 1800)) or 1800
        if hold < 0 then hold = 0 end
        if hold > 5000 then hold = 5000 end
        if hold > 0 then Wait(math.floor(hold)) end
        finish()
    end

    if UNIQUE_AC.Connection and UNIQUE_AC.Connection.AntiVPN and not localEndpoint then
        showStatus(3, 4, "Checking network reputation", "VPN/proxy scan", 1, "Accent")
        local finished = false
        PerformHttpRequest("http://ip-api.com/json/" .. endpoint .. "?fields=status,message,proxy,hosting,isp,country,city", function(statusCode, body)
            if finished then return end
            finished = true
            if statusCode ~= 200 or not body or body == "" then
                print("^3[UNIQUE_AC]^0 VPN lookup unavailable; allowing player fail-open.")
                allow("VPN lookup unavailable")
                return
            end
            local ok, data = pcall(json.decode, body)
            if not ok or type(data) ~= "table" or data.status == "fail" then
                print("^3[UNIQUE_AC]^0 Invalid VPN lookup response; allowing player fail-open.")
                allow("VPN lookup invalid")
                return
            end
            if data.proxy == true or data.hosting == true then
                local isp = uniqueacText(data.isp, "Unknown", 80)
                local country = uniqueacText(data.country, "Unknown", 60)
                local city = uniqueacText(data.city, "Unknown", 60)
                print(("^%sUNIQUE_AC^0: ^1Player ^3%s ^3Try For Join ^0| ^3VPN/Hosting ^3 ISP: %s / Country: %s / City: %s^0"):format(COLORS, name, isp, country, city))
                pcall(UNIQUE_AC_SENDLOG, src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Connect or "", "VPN")
                showStatus(4, 4, "Connection blocked", "VPN/proxy is not allowed", 1, "Attention", true)
                Wait(600)
                finish(("\n[UNIQUE_AC]\nVPN/hosting connections are not allowed.\nISP: %s\nCountry: %s\nCity: %s"):format(isp, country, city))
                return
            end
            allow("Network reputation passed")
        end, "GET")

        CreateThread(function()
            Wait(8000)
            if not finished then
                finished = true
                print("^3[UNIQUE_AC]^0 VPN lookup timed out; allowing player fail-open.")
                allow("VPN lookup timed out")
            end
        end)
        return
    end

    allow("Security checks passed")
end)

local SV_VEHICLES, SV_PEDS, SV_OBJECT = {}, {}, {}
local ENTITY_LISTS = { [1] = Peds, [2] = Vehicle, [3] = Objects }
local ENTITY_NAMES = { [1] = "Ped", [2] = "Vehicle", [3] = "Object" }
local ENTITY_BLACKLIST_FLAGS = {
    [1] = function() return UNIQUE_AC.AntiBlackListPed end,
    [2] = function() return UNIQUE_AC.AntiBlackListVehicle end,
    [3] = function() return UNIQUE_AC.AntiBlackListObject or UNIQUE_AC.AntiBlackListBuilding end,
}
local ENTITY_SPAM_FLAGS = {
    [1] = function() return UNIQUE_AC.AntiSpamPed end,
    [2] = function() return UNIQUE_AC.AntiSpamVehicle end,
    [3] = function() return UNIQUE_AC.AntiSpamObject end,
}
local ENTITY_SPAM_TABLES = { [1] = SV_PEDS, [2] = SV_VEHICLES, [3] = SV_OBJECT }

local function modelInList(model, list)
    if type(list) ~= "table" then return false end
    for _, value in ipairs(list) do
        if model == GetHashKey(value) then return true end
    end
    return false
end

local function getEntitiesByType(entityType)
    if entityType == 1 then return GetAllPeds() end
    if entityType == 2 then return GetAllVehicles() end
    if entityType == 3 then return GetAllObjects() end
    return {}
end

local function UNIQUE_AC_InspectCreatedEntity(entity)
    if not runtimeCfg("EntityCreatedMonitor", false) then return end
    if not entity or entity == 0 then return end

    local delay = tonumber(runtimeCfg("EntityCreatedDelayMs", 750)) or 750
    if delay < 0 then delay = 0 end
    if delay > 5000 then delay = 5000 end

    SetTimeout(delay, function()
        if not runtimeCfg("EntityCreatedMonitor", false) then return end
        if not DoesEntityExist(entity) then return end

        local owner = tonumber(NetworkGetFirstEntityOwner(entity))
        if not owner or owner <= 0 or not GetPlayerName(owner) then return end

        local entityType = GetEntityType(entity)
        if not ENTITY_NAMES[entityType] then return end

        local population = GetEntityPopulationType(entity)
        if population ~= 0 then return end
        if UNIQUE_AC_IS_TRUSTED(owner) then return end

        local model = GetEntityModel(entity)
        local kind = ENTITY_NAMES[entityType]
        if ENTITY_BLACKLIST_FLAGS[entityType]() and modelInList(model, ENTITY_LISTS[entityType]) then
            if DoesEntityExist(entity) then DeleteEntity(entity) end
            UNIQUE_AC_ACTION(owner, UNIQUE_AC.EntityPunishment, "Anti Spawn " .. kind,
                ("Blocked %s model: %s"):format(kind:lower(), tostring(model)))
            return
        end

        if not ENTITY_SPAM_FLAGS[entityType]() then return end
        local key = GetPlayerToken(owner, 0) or tostring(owner)
        local bucket = ENTITY_SPAM_TABLES[entityType]
        local now = os.time()
        local state = bucket[key]
        if not state or now - state.startedAt >= 10 then
            state = { count = 0, startedAt = now, acted = false }
            bucket[key] = state
        end
        state.count = state.count + 1

        local maximum = tonumber(UNIQUE_AC["Max" .. kind]) or 10
        if state.count < maximum or state.acted then return end
        state.acted = true

        if DoesEntityExist(entity) then DeleteEntity(entity) end
        UNIQUE_AC_ACTION(owner, UNIQUE_AC.SpamPunishment, "Anti Spam " .. kind,
            ("Created %s entities within 10 seconds"):format(state.count))
    end)
end

AddEventHandler("entityCreated", function(entity)
    UNIQUE_AC_InspectCreatedEntity(entity)
end)

function StartAntiCheat()
    local newTables = {
        uniqueac_trust = [[CREATE TABLE IF NOT EXISTS `uniqueac_trust` (
            `identifier` varchar(128) NOT NULL, `player_name` varchar(128) DEFAULT NULL,
            `trust_score` int NOT NULL DEFAULT 100, `risk_score` int NOT NULL DEFAULT 0,
            `flag_count` int unsigned NOT NULL DEFAULT 0, `quarantine_count` int unsigned NOT NULL DEFAULT 0,
            `reconnect_count` int unsigned NOT NULL DEFAULT 0, `last_reconnect_at` bigint unsigned NOT NULL DEFAULT 0,
            `first_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin]],
        uniqueac_notes = [[CREATE TABLE IF NOT EXISTS `uniqueac_notes` (
            `id` bigint unsigned NOT NULL AUTO_INCREMENT, `target_identifier` varchar(128) NOT NULL,
            `target_name` varchar(128) DEFAULT NULL, `author_identifier` varchar(128) DEFAULT NULL,
            `author_name` varchar(128) DEFAULT NULL, `note` text NOT NULL,
            `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`), KEY `idx_uniqueac_notes_target` (`target_identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin]],
        uniqueac_admin_log = [[CREATE TABLE IF NOT EXISTS `uniqueac_admin_log` (
            `id` bigint unsigned NOT NULL AUTO_INCREMENT, `admin_identifier` varchar(128) DEFAULT NULL,
            `admin_name` varchar(128) DEFAULT NULL, `action` varchar(64) NOT NULL,
            `target_identifier` varchar(128) DEFAULT NULL, `target_name` varchar(128) DEFAULT NULL,
            `reason` text, `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`), KEY `idx_uniqueac_adminlog_admin` (`admin_identifier`),
            KEY `idx_uniqueac_adminlog_target` (`target_identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin]],
        uniqueac_detections = [[CREATE TABLE IF NOT EXISTS `uniqueac_detections` (
            `id` bigint unsigned NOT NULL AUTO_INCREMENT, `identifier` varchar(128) NOT NULL,
            `player_name` varchar(128) DEFAULT NULL, `reason` varchar(128) NOT NULL,
            `details` text, `action` varchar(32) DEFAULT NULL,
            `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`), KEY `idx_uniqueac_detections_identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin]],
        uniqueac_appeals = [[CREATE TABLE IF NOT EXISTS `uniqueac_appeals` (
            `id` bigint unsigned NOT NULL AUTO_INCREMENT, `identifier` varchar(128) NOT NULL,
            `player_name` varchar(128) DEFAULT NULL, `ban_id` bigint unsigned DEFAULT NULL,
            `message` text NOT NULL, `status` varchar(16) NOT NULL DEFAULT 'pending',
            `reviewed_by` varchar(128) DEFAULT NULL, `reviewed_at` datetime DEFAULT NULL,
            `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`), KEY `idx_uniqueac_appeals_identifier` (`identifier`),
            KEY `idx_uniqueac_appeals_status` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin]]
    }
    for tableName, sql in pairs(newTables) do
        MySQL.Async.execute(sql, {}, function()
            print(("^2[UNIQUE_AC]^0 Table `%s` ready."):format(tableName))
        end)
    end

    local resources = {
        "configs/fire-config.lua", "tables/fire-event.lua", "tables/fire-explosions.lua",
        "tables/fire-name.lua", "tables/fire-object.lua", "tables/fire-peds.lua",
        "tables/fire-plate.lua", "tables/fire-vehicle.lua", "tables/fire-weapon.lua",
        "tables/fire-words.lua", "tables/fire-task.lua", "tables/fire-anim.lua",
        "tables/fire-emoji.lua"
    }

    local missing = {}
    for _, resource in ipairs(resources) do
        if LoadResourceFile(GetCurrentResourceName(), resource) then
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^2" .. resource .. " LOADED !^0")
        else
            missing[#missing + 1] = resource
        end
    end

    if #missing > 0 then
        print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 Some Files Of UNIQUE_AC Not Found! Please Replace or Repair Them^0")
        print("^1[UNIQUE_AC]^0 Missing required files: " .. table.concat(missing, ", "))
        return false
    end

    print("^" .. COLORS .. "")
    print([[
    #   # #   # #####  ###  #   # #####        ###   ####
    #   # ##  #   #   #   # #   # #           #   # #
    #   # # # #   #   #   # #   # #           #   # #
    #   # #  ##   #   #   # #   # ####        ##### #
    #   # #   #   #   # # # #   # #           #   # #
    #   # #   #   #   #  ## #   # #           #   # #
     ###  #   # #####  ####  ###  ##### ##### #   #  ####
                    ]])

    local configuredPort = tostring(UNIQUE_AC.ServerConfig.Port or "auto")
    local actualPort = GetConvar("netPort", configuredPort)
    local artifact = GetConvar("version", "unknown build")

    print("^3═════════════════════════════════════════════════════════════════════════════════")
    print("^1★ ^3Arshia ^1-> ^5arshiahub.ir")
    print("^1★ ^3Payamresan ^1-> ^5arshiahub.ir/payamresan")
    print("^1★ ^3Derive ^1-> ^5arshiahub.ir/derive")
    print("^1★ ^3Mail ^1-> ^5arshiahub.ir/mail")
    print("^1★ ^3Music ^1-> ^5arshiahub.ir/music")
    print("^3═════════════════════════════════════════════════════════════════════════════════")
    print("^6This resource is Owner by ^5arshiahub.ir^6!")
    print("^" .. COLORS .. "[UNIQUE_AC]^0: ^3Server Build : " .. tostring(artifact))
    print("^" .. COLORS .. "[UNIQUE_AC]^0: ^2Version " .. tostring(UNIQUE_AC.Version) .. " started successfully on port " .. tostring(actualPort) .. ".^0")

    local webhook = UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Ban or ""
    if type(webhook) == "string" and webhook:match("^https?://") then
        PerformHttpRequest(webhook, function() end, "POST", json.encode({
            username = "UNIQUE_AC",
            embeds = {{
                title = "UNIQUE_AC started",
                description = ("Version: %s\nServer: %s\nPort: %s\nBuild: %s"):format(
                    tostring(UNIQUE_AC.Version), tostring(UNIQUE_AC.ServerConfig.Name), tostring(actualPort), tostring(artifact)),
                color = 16733440
            }}
        }), { ["Content-Type"] = "application/json" })
    end

    return true
end

function UNIQUE_AC_ISNEARADMIN(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    local myPed = GetPlayerPed(src)
    if not myPed or myPed == 0 or not DoesEntityExist(myPed) then return false end
    local myPos = GetEntityCoords(myPed)
    for _, value in ipairs(GetPlayers()) do
        local other = tonumber(value)
        if other and other ~= src and UNIQUE_AC_GETADMINS(other) then
            local adminPed = GetPlayerPed(other)
            if adminPed and adminPed ~= 0 and DoesEntityExist(adminPed) then
                local adminPos = GetEntityCoords(adminPed)
                if #(myPos - adminPos) < 30.0 then return true end
            end
        end
    end
    return false
end

local PERMISSION_TABLES = {
    whitelist = "uniqueac_whitelist",
    admin = "uniqueac_admin",
    unban = "uniqueac_unban"
}

local function permissionIdentifiers(src)
    local result, seen = {}, {}
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier and identifier ~= "" and not seen[identifier] then
            seen[identifier] = true
            result[#result + 1] = identifier
        end
        if identifier and identifier:sub(1, 8) == "discord:" then
            local legacy = identifier:sub(9)
            if legacy ~= "" and not seen[legacy] then
                seen[legacy] = true
                result[#result + 1] = legacy
            end
        end
    end
    return result
end

local function databasePermission(src, kind)
    src = tonumber(src)
    local tableName = PERMISSION_TABLES[kind]
    if not src or not tableName or not GetPlayerName(src) then return false end

    PERMISSION_CACHE[src] = PERMISSION_CACHE[src] or {}
    local cached = PERMISSION_CACHE[src][kind]
    local t = monotonicMs()
    if cached and cached.expiresAt > t then return cached.value end

    local identifiers = permissionIdentifiers(src)
    if #identifiers == 0 then return false end

    local placeholders, params = {}, {}
    for index, identifier in ipairs(identifiers) do
        local key = "@id" .. index
        placeholders[#placeholders + 1] = key
        params[key] = identifier
    end

    local p = promise.new()
    MySQL.Async.fetchAll(("SELECT id FROM %s WHERE identifier IN (%s) LIMIT 1"):format(tableName, table.concat(placeholders, ",")), params,
        function(rows)
            local value = rows ~= nil and rows[1] ~= nil
            PERMISSION_CACHE[src][kind] = { value = value, expiresAt = monotonicMs() + 15000 }
            p:resolve(value)
        end)
    return Citizen.Await(p)
end

local function acePermission(src, permission)
    if not permission or permission == "" then return false end
    return IsPlayerAceAllowed(tostring(src), permission) == true
end

local function frameworkPermissionAdmin(src)
    src = tonumber(src)
    local cfg = UNIQUE_AC.FrameworkPermission
    if not src or not cfg or not cfg.Enable then return false end
    if not cfg.Table or not cfg.IdentifierColumn or not cfg.PermissionColumn then return false end
    if not GetPlayerName(src) then return false end

    local t = monotonicMs()
    local cached = FRAMEWORK_PERM_CACHE[src]
    if cached and cached.expiresAt > t then return cached.value end

    local identifiers = permissionIdentifiers(src)
    if #identifiers == 0 then return false end

    local placeholders, params = {}, {}
    for index, identifier in ipairs(identifiers) do
        local key = "@id" .. index
        placeholders[#placeholders + 1] = key
        params[key] = identifier
    end

    local minLevel = tonumber(cfg.MinLevel) or 1
    local sql = ("SELECT `%s` AS perm FROM `%s` WHERE `%s` IN (%s) LIMIT 1")
        :format(cfg.PermissionColumn, cfg.Table, cfg.IdentifierColumn, table.concat(placeholders, ","))

    local p = promise.new()
    MySQL.Async.fetchAll(sql, params, function(rows)
        local value = false
        if rows and rows[1] then
            local level = tonumber(rows[1].perm)
            value = level ~= nil and level >= minLevel
        end
        FRAMEWORK_PERM_CACHE[src] = { value = value, expiresAt = monotonicMs() + 15000 }
        p:resolve(value)
    end)
    return Citizen.Await(p)
end

function UNIQUE_AC_WHITELIST(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    if UNIQUE_AC.ACE and UNIQUE_AC.ACE.Enable == true then
        return acePermission(src, UNIQUE_AC.ACE.Whitelist)
    end
    return databasePermission(src, "whitelist")
end

function UNIQUE_AC_GETADMINS(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    if frameworkPermissionAdmin(src) then return true end
    if UNIQUE_AC.ACE and UNIQUE_AC.ACE.Enable == true then
        return acePermission(src, UNIQUE_AC.ACE.Admin)
    end
    return databasePermission(src, "admin")
end

function UNIQUE_AC_UNBANACCESS(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    if UNIQUE_AC.ACE and UNIQUE_AC.ACE.Enable == true then
        return acePermission(src, UNIQUE_AC.ACE.Unban)
    end
    return databasePermission(src, "unban")
end

function UNIQUE_AC_IS_TRUSTED(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    if TRUSTED_ADMINS[src] == true then return true end
    if UNIQUE_AC_CHECK_TEMP_WHITELIST(src) then return true end
    if UNIQUE_AC_WHITELIST(src) then return true end
    if UNIQUE_AC_GETADMINS(src) then return true end
    return false
end

invalidatePermissionCache = function(src)
    if src then
        PERMISSION_CACHE[tonumber(src)] = nil
    else
        PERMISSION_CACHE = {}
    end
end

function UNIQUE_AC_DISCORD_SEND(url, payload, attemptsLeft)
    attemptsLeft = attemptsLeft or 3
    if type(url) ~= "string" or not url:match("^https?://") then return end
    PerformHttpRequest(url, function(statusCode)
        local failed = not statusCode or statusCode == 0 or statusCode >= 400
        if failed and attemptsLeft > 1 then
            local delay = (4 - attemptsLeft) * 8000
            SetTimeout(delay, function()
                UNIQUE_AC_DISCORD_SEND(url, payload, attemptsLeft - 1)
            end)
        elseif failed then
            print(("^3[UNIQUE_AC]^0 Discord webhook failed after retries (last status: %s)."):format(tostring(statusCode)))
        end
    end, "POST", payload, { ["Content-Type"] = "application/json" })
end

function UNIQUE_AC_ERROR(SERVER_NAME, ERROR_MESSAGE)
    local message = tostring(ERROR_MESSAGE or "Unknown UNIQUE_AC error")
    print(("^1[UNIQUE_AC ERROR]^0 %s"):format(message))

    local webhook = UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Error or ""
    if type(webhook) ~= "string" or not webhook:match("^https?://") then return end

    UNIQUE_AC_DISCORD_SEND(webhook, json.encode({
        username = "UNIQUE_AC",
        embeds = {{
            title = "UNIQUE_AC warning",
            description = ("Server: %s\nError: `%s`"):format(tostring(SERVER_NAME or "Unknown"), message:sub(1, 1500)),
            color = 16753920
        }}
    }))
end

function UNIQUE_AC_BAN(SRC, REASON)
    local src = tonumber(SRC)
    local reason = type(REASON) == "string" and REASON:sub(1, 1000) or nil
    if not src or not reason or not GetPlayerName(src) then
        UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "UNIQUE_AC_BAN received an invalid source or reason")
        return false
    end

    local identifiers = {
        steam = "__NONE__", discord = "__NONE__", license = "__NONE__",
        live = "__NONE__", xbl = "__NONE__"
    }
    for _, value in ipairs(GetPlayerIdentifiers(src)) do
        local kind, identifier = value:match("^([^:]+):(.+)$")
        if kind == "discord" then identifiers.discord = identifier
        elseif kind and identifiers[kind] then identifiers[kind] = value end
    end

    local tokens = {}
    local tokenCount = tonumber(GetNumPlayerTokens(src)) or 0
    for index = 0, tokenCount - 1 do
        local token = GetPlayerToken(src, index)
        if type(token) == "string" and token ~= "" then tokens[#tokens + 1] = token end
    end

    local banId = os.time() * 1000 + math.random(0, 999)
    local playerName = uniqueacDbName(GetPlayerName(src))
    local hasNameColumn = uniqueacEnsureColumn("uniqueac_banlist", "PLAYER_NAME", "varchar(128) NULL DEFAULT NULL AFTER `id`")
    local p = promise.new()

    local params = {
        ["@steam"] = identifiers.steam, ["@discord"] = identifiers.discord,
        ["@license"] = identifiers.license, ["@live"] = identifiers.live,
        ["@xbl"] = identifiers.xbl, ["@ip"] = GetPlayerEndpoint(src) or "__NONE__",
        ["@tokens"] = json.encode(tokens), ["@banid"] = banId, ["@reason"] = reason,
        ["@player_name"] = playerName
    }

    if hasNameColumn then
        MySQL.Async.execute([[INSERT INTO uniqueac_banlist
            (PLAYER_NAME, STEAM, DISCORD, LICENSE, LIVE, XBL, IP, TOKENS, BANID, REASON)
            VALUES (@player_name, @steam, @discord, @license, @live, @xbl, @ip, @tokens, @banid, @reason)]], params, function(rowsChanged)
            p:resolve((tonumber(rowsChanged) or 0) > 0)
        end)
    else
        MySQL.Async.execute([[INSERT INTO uniqueac_banlist
            (STEAM, DISCORD, LICENSE, LIVE, XBL, IP, TOKENS, BANID, REASON)
            VALUES (@steam, @discord, @license, @live, @xbl, @ip, @tokens, @banid, @reason)]], params, function(rowsChanged)
            p:resolve((tonumber(rowsChanged) or 0) > 0)
        end)
    end

    local inserted = Citizen.Await(p)
    return inserted and banId or false
end

local function uniqueacCleanBanReason(value, fallback)
    local text = tostring(value or fallback or "Banned by UNIQUE_AC")
    text = text:gsub("[%c]", " "):gsub("%s+", " "):sub(1, 240)
    if text == "" then text = fallback or "Banned by UNIQUE_AC" end
    return text
end

function UNIQUE_AC_BAN_PLAYER(targetId, reason, issuer)
    local target = tonumber(targetId)
    if not target or target <= 0 or not GetPlayerName(target) then
        return false, "invalid_player"
    end

    local finalReason = uniqueacCleanBanReason(reason, "Banned by UNIQUE_AC")
    local finalIssuer = uniqueacCleanBanReason(issuer or GetInvokingResource() or "server", "server")
    local playerName = GetPlayerName(target) or ("ID " .. tostring(target))
    local details = "Issued by " .. finalIssuer

    if UNIQUE_AC.ScreenShot and UNIQUE_AC.ScreenShot.Enable
        and GetResourceState("discord-screenshot") == "started"
        and UNIQUE_AC.Webhooks and type(UNIQUE_AC.Webhooks.ScreenShot) == "string"
        and UNIQUE_AC.Webhooks.ScreenShot:match("^https?://") then
        UNIQUE_AC_SCREENSHOT(target, finalReason, details, "BAN")
    end

    UNIQUE_AC_SENDLOG(target, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Ban or "", "BAN", finalReason, details)
    UNIQUE_AC_MESSAGE(target, "BAN", playerName, finalReason)

    local banId = UNIQUE_AC_BAN(target, finalReason)
    local fireEmoji = Emoji and Emoji.Fire or "🔥"

    if banId then
        print(("^1[UNIQUE_AC]^0 Banned ^3%s^0 | %s | By: %s | Ban ID: %s"):format(playerName, finalReason, finalIssuer, tostring(banId)))
        DropPlayer(target, ("\n[%s UNIQUE_AC %s]\n%s\nReason: %s\nBan ID: #%s"):format(fireEmoji, fireEmoji,
            (UNIQUE_AC.Message and UNIQUE_AC.Message.Ban ~= "" and UNIQUE_AC.Message.Ban) or UNIQUE_AC_TR("ban"), finalReason, tostring(banId)))

        if UNIQUE_AC.CentralHub and UNIQUE_AC.CentralHub.Enable and UNIQUE_AC.CentralHub.ShareBans then
            local license = uniqueacPlayerLicense(target)
            if license then
                UNIQUE_AC_HUB_POST("/api/report-ban.php", { identifier = license, reason = finalReason })
            end
        end

        return true, banId
    end

    UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "External/admin ban could not be persisted; player was kicked instead")
    DropPlayer(target, ("\n[%s UNIQUE_AC %s]\n%s\nReason: %s"):format(fireEmoji, fireEmoji,
        (UNIQUE_AC.Message and UNIQUE_AC.Message.Kick ~= "" and UNIQUE_AC.Message.Kick) or UNIQUE_AC_TR("kick"), finalReason))
    return false, "db_failed"
end

function BanPlayer(targetId, reason, issuer)
    return UNIQUE_AC_BAN_PLAYER(targetId, reason, issuer)
end

RegisterCommand("uniqueacban", function(src, args)
    args = args or {}
    local executor = tonumber(src) or 0
    if executor > 0 and not UNIQUE_AC_GETADMINS(executor) then
        UNIQUE_AC_ACTION(executor, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Ban Players", "Unauthorized uniqueacban command")
        return
    end

    local target = tonumber(args and args[1])
    if not target or not GetPlayerName(target) then
        print("^1[UNIQUE_AC]^0 Usage: uniqueacban [server_id] [reason]")
        return
    end

    table.remove(args, 1)
    local reason = table.concat(args or {}, " ")
    if reason == "" then reason = "Banned by UNIQUE_AC command" end

    local issuer = executor > 0 and ("Admin " .. (GetPlayerName(executor) or tostring(executor)) .. " (" .. tostring(executor) .. ")") or "server console"
    UNIQUE_AC_BAN_PLAYER(target, reason, issuer)
end, false)

RegisterCommand("uniqueacunban", function(src, args)
    args = args or {}
    local executor = tonumber(src) or 0
    if executor > 0 and not UNIQUE_AC_GETADMINS(executor) then
        UNIQUE_AC_ACTION(executor, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Unban", "Unauthorized uniqueacunban command")
        return
    end

    local banId = tonumber(args and args[1])
    if not banId then
        print("^1[UNIQUE_AC]^0 Usage: uniqueacunban [ban_id]")
        return
    end

    local issuer = executor > 0 and ("Admin " .. (GetPlayerName(executor) or tostring(executor)) .. " (" .. tostring(executor) .. ")") or "server console"
    local ok, result = UNIQUE_AC_UNBAN_PLAYER(banId, issuer)
    if not ok then
        print(("^1[UNIQUE_AC]^0 Unban failed for Ban ID %s | %s"):format(tostring(banId), tostring(result)))
    end
end, false)

function UNIQUE_AC:UNBAN(BanID)
    local p = promise.new()
    if tonumber(BanID) then
        MySQL.Async.execute('DELETE FROM uniqueac_banlist WHERE BANID=@BANID', {
            ['@BANID'] = tonumber(BanID)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end

function UNIQUE_AC_UNBAN_PLAYER(banId, issuer)
    local id = tonumber(banId)
    if not id then
        return false, "invalid_ban_id"
    end

    local ok = UNIQUE_AC:UNBAN(id)
    if ok then
        local who = tostring(issuer or GetInvokingResource() or "server"):gsub("[%c]", " "):sub(1, 120)
        print(("^2[UNIQUE_AC]^0 Unbanned Ban ID ^3%s^0 | By: %s"):format(tostring(id), who))
        return true, id
    end

    return false, "not_found"
end

function UnbanPlayer(banId, issuer)
    return UNIQUE_AC_UNBAN_PLAYER(banId, issuer)
end

local ACCESS_TABLE_ALLOWLIST = {
    uniqueac_admin = true,
    uniqueac_whitelist = true,
    uniqueac_unban = true
}

local function addAccessIdentifier(playerId, tableName)
    local p = promise.new()
    playerId = tonumber(playerId)
    if not playerId or not ACCESS_TABLE_ALLOWLIST[tableName] or not GetPlayerName(playerId) then
        p:resolve(false)
        return Citizen.Await(p)
    end

    local license
    for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if identifier:sub(1, 8) == "license:" then
            license = identifier
            break
        end
    end
    if not license then
        p:resolve(false)
        return Citizen.Await(p)
    end

    local playerName = uniqueacDbName(GetPlayerName(playerId))
    local hasNameColumn = uniqueacEnsureColumn(tableName, "player_name", "varchar(128) NULL DEFAULT NULL AFTER `identifier`")

    MySQL.Async.fetchScalar(("SELECT id FROM `%s` WHERE identifier=@identifier LIMIT 1"):format(tableName), {
        ["@identifier"] = license
    }, function(existing)
        if existing then
            if hasNameColumn then
                MySQL.Async.execute(("UPDATE `%s` SET player_name=@player_name WHERE identifier=@identifier"):format(tableName), {
                    ["@identifier"] = license,
                    ["@player_name"] = playerName
                }, function()
                    invalidatePermissionCache(playerId)
                    p:resolve(true)
                end)
            else
                invalidatePermissionCache(playerId)
                p:resolve(true)
            end
            return
        end

        if hasNameColumn then
            MySQL.Async.execute(("INSERT INTO `%s` (`identifier`, `player_name`) VALUES (@identifier, @player_name)"):format(tableName), {
                ["@identifier"] = license,
                ["@player_name"] = playerName
            }, function(rowsChanged)
                invalidatePermissionCache(playerId)
                p:resolve((tonumber(rowsChanged) or 0) > 0)
            end)
        else
            MySQL.Async.execute(("INSERT INTO `%s` (`identifier`) VALUES (@identifier)"):format(tableName), {
                ["@identifier"] = license
            }, function(rowsChanged)
                invalidatePermissionCache(playerId)
                p:resolve((tonumber(rowsChanged) or 0) > 0)
            end)
        end
    end)
    return Citizen.Await(p)
end

function UNIQUE_AC:ADDADMIN(Player_ID)
    return addAccessIdentifier(Player_ID, "uniqueac_admin")
end

function UNIQUE_AC:ADDWHITELIST(Player_ID)
    return addAccessIdentifier(Player_ID, "uniqueac_whitelist")
end

function UNIQUE_AC:ADDUNBAN(Player_ID)
    return addAccessIdentifier(Player_ID, "uniqueac_unban")
end

function UNIQUE_AC_INBANLIST(SRC)
    local p = promise.new()
    local src = tonumber(SRC)
    if not src then
        p:resolve(false)
        return Citizen.Await(p)
    end

    local identifiers = {
        steam = "__NO_STEAM__", discord = "__NO_DISCORD__", license = "__NO_LICENSE__",
        live = "__NO_LIVE__", xbl = "__NO_XBL__"
    }
    for _, value in ipairs(GetPlayerIdentifiers(src)) do
        local kind, identifier = value:match("^([^:]+):(.+)$")
        if kind == "discord" then
            identifiers.discord = identifier
        elseif kind and identifiers[kind] then
            identifiers[kind] = value
        end
    end

    local token = GetPlayerToken(src, 0)
    local tokenPattern = type(token) == "string" and token ~= "" and ("%%" .. token .. "%%") or "%__NO_TOKEN__%"
    MySQL.Async.fetchAll([[SELECT * FROM uniqueac_banlist
        WHERE STEAM = @steam OR DISCORD = @discord OR LICENSE = @license
           OR LIVE = @live OR XBL = @xbl OR IP = @ip OR TOKENS LIKE @token
        ORDER BY id DESC LIMIT 1]], {
        ["@steam"] = identifiers.steam,
        ["@discord"] = identifiers.discord,
        ["@license"] = identifiers.license,
        ["@live"] = identifiers.live,
        ["@xbl"] = identifiers.xbl,
        ["@ip"] = GetPlayerEndpoint(src) or "__NO_IP__",
        ["@token"] = tokenPattern,
    }, function(result)
        p:resolve(result and #result > 0 and result or false)
    end)

    return Citizen.Await(p)
end

function UNIQUE_AC_ACTION(SRC, ACTION, REASON, DETAILS)
    local src = tonumber(SRC)
    local action = tostring(ACTION or "WARN"):upper()
    local reason = tostring(REASON or "Unknown detection")
    local details = tostring(DETAILS or "No details")

    if not src or src <= 0 or not GetPlayerName(src) then return false end
    if action ~= "WARN" and action ~= "KICK" and action ~= "BAN" then action = "WARN" end
    if UNIQUE_AC_IS_TRUSTED(src) then return false end
    if UNIQUE_AC_IS_SPAMLIST(src, action, reason, details) then return false end
    UNIQUE_AC_ADD_SPAMLIST(src, action, reason, details)

    if UNIQUE_AC.SandboxMode and UNIQUE_AC.SandboxMode.Enable then
        local playerName = GetPlayerName(src) or ("ID " .. src)
        print(("^5[UNIQUE_AC SANDBOX]^0 Would have applied ^3%s^0 to ^3%s^0 | %s | %s (no action actually taken)"):format(action, playerName, reason, details))
        uniqueacLogDetection(src, reason, details, "SANDBOX_" .. action)
        if UNIQUE_AC.SandboxMode.NotifyAdmins then
            uniqueacNotifyAdmins(("🧪 SANDBOX: would have %sed %s (%s) — no action taken."):format(action:lower(), playerName, reason), { 0, 209, 255 })
        end
        return false
    end

    if UNIQUE_AC.ScreenShot and UNIQUE_AC.ScreenShot.Enable
        and GetResourceState("discord-screenshot") == "started"
        and UNIQUE_AC.Webhooks and type(UNIQUE_AC.Webhooks.ScreenShot) == "string"
        and UNIQUE_AC.Webhooks.ScreenShot:match("^https?://") then
        UNIQUE_AC_SCREENSHOT(src, reason, details, action)
    end

    local playerName = GetPlayerName(src) or ("ID " .. src)
    UNIQUE_AC_SENDLOG(src, UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.Ban or "", action, reason, details)
    UNIQUE_AC_MESSAGE(src, action, playerName, reason)

    if action == "WARN" then
        print(("^3[UNIQUE_AC]^0 Warning for ^3%s^0 | %s"):format(playerName, reason))
        return true
    end

    local fireEmoji = Emoji and Emoji.Fire or "🔥"
    if action == "BAN" then
        local banId = UNIQUE_AC_BAN(src, reason)
        if banId then
            print(("^1[UNIQUE_AC]^0 Banned ^3%s^0 | %s | Ban ID: %s"):format(playerName, reason, banId))
            DropPlayer(src, ("\n[%s UNIQUE_AC %s]\n%s\nReason: %s\nBan ID: #%s"):format(fireEmoji, fireEmoji,
                (UNIQUE_AC.Message and UNIQUE_AC.Message.Ban ~= "" and UNIQUE_AC.Message.Ban) or UNIQUE_AC_TR("ban"), reason, banId))
        else
            UNIQUE_AC_ERROR(UNIQUE_AC.ServerConfig.Name, "Ban record could not be persisted; player was kicked instead")
            DropPlayer(src, ("\n[%s UNIQUE_AC %s]\n%s\nReason: %s"):format(fireEmoji, fireEmoji,
                (UNIQUE_AC.Message and UNIQUE_AC.Message.Kick ~= "" and UNIQUE_AC.Message.Kick) or UNIQUE_AC_TR("kick"), reason))
        end
        return true
    end

    print(("^1[UNIQUE_AC]^0 Kicked ^3%s^0 | %s"):format(playerName, reason))
    DropPlayer(src, ("\n[%s UNIQUE_AC %s]\n%s\nReason: %s"):format(fireEmoji, fireEmoji,
        (UNIQUE_AC.Message and UNIQUE_AC.Message.Kick ~= "" and UNIQUE_AC.Message.Kick) or UNIQUE_AC_TR("kick"), reason))
    return true
end

function UNIQUE_AC_MESSAGE(SRC, TYPE, NAME, REASON)
    local settings = UNIQUE_AC.ChatSettings or {}
    if not settings.Enable then return end
    local src = tonumber(SRC)
    local kind = tostring(TYPE or "WARN"):upper()
    local name = tostring(NAME or "Unknown"):gsub("[%c]", ""):sub(1, 80)
    local reason = tostring(REASON or "Unknown"):gsub("[%c]", " "):sub(1, 240)
    local icon = kind == "BAN" and (Emoji and Emoji.Ban or "⛔")
        or kind == "KICK" and (Emoji and Emoji.Kick or "👢")
        or (Emoji and Emoji.Warn or "⚠️")
    local payload = {
        color = kind == "WARN" and {255, 170, 0} or {255, 70, 70},
        multiline = true,
        args = { "UNIQUE_AC", ("%s %s | %s (%s): %s"):format(icon, kind, name, tostring(src or "?"), reason) }
    }

    if kind == "WARN" and settings.PrivateWarn then
        for _, playerId in ipairs(GetPlayers()) do
            if UNIQUE_AC_GETADMINS(playerId) then TriggerClientEvent("chat:addMessage", playerId, payload) end
        end
    else
        TriggerClientEvent("chat:addMessage", -1, payload)
    end
end

local function validWebhook(url)
    return type(url) == "string" and url:match("^https?://") ~= nil and not url:find("YOUR_WEBHOOK", 1, true)
end

local function limited(value, length)
    value = tostring(value or "Not Found")
    if #value > length then return value:sub(1, length - 3) .. "..." end
    return value
end

local function getIdentitySummary(src)
    local ids = { steam = "Not Found", discord = "Not Found", license = "Not Found", live = "Not Found", xbl = "Not Found" }
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        local kind = identifier:match("^([^:]+):")
        if kind == "steam" then ids.steam = identifier
        elseif kind == "discord" then ids.discord = "<@" .. identifier:sub(9) .. ">"
        elseif kind == "license" then ids.license = identifier
        elseif kind == "live" then ids.live = identifier
        elseif kind == "xbl" then ids.xbl = identifier end
    end
    return ids
end

function UNIQUE_AC_SENDLOG(SRC, URL, TYPE, REASON, DETAILS)
    local src = tonumber(SRC)
    if not src or not GetPlayerName(src) or not validWebhook(URL) then return false end

    local kind = tostring(TYPE or "INFO"):upper()
    local colors = { BAN = 16711680, KICK = 16744192, WARN = 16763904, CONNECT = 5763719, DISCONNECT = 9807270, EXPLOSION = 16724787, QUARANTINE = 16753920, INTEGRITY = 16711680, AIMBOT = 10038562, RESOURCE = 3901635 }
    local ids = getIdentitySummary(src)
    local ped = GetPlayerPed(src)
    local coordsText = "Unavailable"
    if ped and ped ~= 0 and DoesEntityExist(ped) then
        local c = GetEntityCoords(ped)
        coordsText = ("%.2f, %.2f, %.2f"):format(c.x, c.y, c.z)
    end
    local endpoint = GetPlayerEndpoint(src) or "Not Found"
    if UNIQUE_AC.Connection and UNIQUE_AC.Connection.HideIP then endpoint = "Hidden by owner" end

    local description = table.concat({
        ("**Player:** %s (`%s`)"):format(limited(GetPlayerName(src), 120), src),
        ("**Type:** %s"):format(limited(kind, 40)),
        ("**Reason:** %s"):format(limited(REASON, 700)),
        ("**Details:** %s"):format(limited(DETAILS, 1200)),
        ("**License:** `%s`"):format(limited(ids.license, 150)),
        ("**Discord:** %s"):format(limited(ids.discord, 150)),
        ("**Steam:** `%s`"):format(limited(ids.steam, 150)),
        ("**Endpoint:** `%s`"):format(limited(endpoint, 100)),
        ("**Coords:** `%s`"):format(coordsText),
        ("**Ping:** `%sms`"):format(GetPlayerPing(src) or 0),
    }, "\n")

    UNIQUE_AC_DISCORD_SEND(URL, json.encode({
        username = "UNIQUE_AC Security",
        embeds = {{
            title = "UNIQUE_AC • " .. limited(kind, 60),
            description = description,
            color = colors[kind] or 16744448,
            footer = { text = ("UNIQUE_AC %s • %s"):format(tostring(UNIQUE_AC.Version), os.date("!%Y-%m-%d %H:%M:%S UTC")) }
        }}
    }))
    return true
end

function UNIQUE_AC_REFRESHCMD()
    SERVER_CMDS = {}
    for _, command in ipairs(GetRegisteredCommands() or {}) do
        if type(command) == "table" and type(command.name) == "string" then
            SERVER_CMDS[command.name] = true
        end
    end
    return SERVER_CMDS
end

function UNIQUE_AC_ISPLAYERLOAD(source)
    local SRC = tonumber(source)
    local PED = GetPlayerPed(SRC)
    local STATUS = false
    if SRC ~= nil then
        if DoesEntityExist(PED) then
            if SPAWNED[SRC] ~= nil then
                STATUS = true
            else
                STATUS = false
            end
        else
            STATUS = false
        end
    else
        STATUS = false
    end
    return STATUS
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for index in pairs(SPAMLIST) do
            SPAMLIST[index] = nil
        end
        Citizen.Wait(0)
    end
end)

function UNIQUE_AC_ADD_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    local src = tonumber(SRC)
    if not src then return end
    SPAMLIST[src] = SPAMLIST[src] or {}
    local key = table.concat({ tostring(ACTION), tostring(REASON), tostring(DETAILS) }, "|")
    SPAMLIST[src][key] = monotonicMs() + 10000
end

function UNIQUE_AC_IS_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    local src = tonumber(SRC)
    if not src or not SPAMLIST[src] then return false end
    local key = table.concat({ tostring(ACTION), tostring(REASON), tostring(DETAILS) }, "|")
    local expires = SPAMLIST[src][key]
    if not expires then return false end
    if monotonicMs() >= expires then
        SPAMLIST[src][key] = nil
        return false
    end
    return true
end

function UNIQUE_AC_SCREENSHOT(SRC, REASON, DETAILS, ACTION)
    local src = tonumber(SRC)
    local webhook = UNIQUE_AC.Webhooks and UNIQUE_AC.Webhooks.ScreenShot or ""
    if not src or not GetPlayerName(src) or not validWebhook(webhook) then return false end
    if GetResourceState("discord-screenshot") ~= "started" then return false end

    local colors = { WARN = 16763904, KICK = 16744192, BAN = 16711680 }
    local ids = getIdentitySummary(src)
    local options = {
        encoding = (UNIQUE_AC.ScreenShot and UNIQUE_AC.ScreenShot.Format) or "jpg",
        quality = math.max(0.1, math.min(tonumber(UNIQUE_AC.ScreenShot and UNIQUE_AC.ScreenShot.Quality) or 0.75, 1.0))
    }
    local payload = {
        username = "UNIQUE_AC Security",
        embeds = {{
            title = "UNIQUE_AC • Screenshot",
            color = colors[tostring(ACTION or "WARN"):upper()] or colors.WARN,
            description = table.concat({
                ("**Player:** %s (`%s`)"):format(limited(GetPlayerName(src), 120), src),
                ("**Reason:** %s"):format(limited(REASON, 700)),
                ("**Details:** %s"):format(limited(DETAILS, 1200)),
                ("**License:** `%s`"):format(limited(ids.license, 150)),
                ("**Discord:** %s"):format(limited(ids.discord, 150))
            }, "\n"),
            footer = { text = ("UNIQUE_AC %s • %s"):format(tostring(UNIQUE_AC.Version), os.date("!%Y-%m-%d %H:%M:%S UTC")) }
        }}
    }

    local ok, err = pcall(function()
        exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(src, webhook, options, payload)
    end)
    if not ok then
        print(("^3[UNIQUE_AC]^0 Screenshot request failed: %s"):format(tostring(err)))
        return false
    end
    return true
end

function UNIQUE_AC_SCREENSHOT_BURST(SRC, REASON, DETAILS, ACTION)
    local cfg = UNIQUE_AC.EvidenceBurst
    if not cfg or not cfg.Enable then return end
    local count = math.max(1, math.min(tonumber(cfg.ShotCount) or 4, 10))
    local interval = math.max(500, math.min(tonumber(cfg.IntervalMs) or 1500, 10000))
    for i = 1, count do
        SetTimeout((i - 1) * interval, function()
            UNIQUE_AC_SCREENSHOT(SRC, REASON, ("%s (evidence %d/%d)"):format(tostring(DETAILS or ""), i, count), ACTION)
        end)
    end
end

function UNIQUE_AC_CHANGE_TEMP_WHHITELIST(SRC, STATUS, DURATION_MS)
    local src = tonumber(SRC)
    if not src then return false end
    if STATUS == true then
        local duration = math.max(1000, math.min(tonumber(DURATION_MS) or 15000, 600000))
        TEMP_WHITELIST[src] = monotonicMs() + duration
        return true
    end
    TEMP_WHITELIST[src] = nil
    return true
end

function UNIQUE_AC_CHANGE_TEMP_WHITELIST(SRC, STATUS, DURATION_MS)
    return UNIQUE_AC_CHANGE_TEMP_WHHITELIST(SRC, STATUS, DURATION_MS)
end

exports('ExemptPlayer', function(src, ms, kinds)
    return UNIQUE_AC_CHANGE_TEMP_WHHITELIST(src, true, ms)
end)

function UNIQUE_AC_CHECK_TEMP_WHITELIST(SRC)
    local src = tonumber(SRC)
    if not src then return false end
    local expires = TEMP_WHITELIST[src]
    if not expires then return false end
    if monotonicMs() >= expires then
        TEMP_WHITELIST[src] = nil
        return false
    end
    return true
end

RegisterNetEvent("UNIQUE_AC:adminState", function(enabled, durationMs)
    local src = tonumber(source)
    if not src then return end
    if not UNIQUE_AC_GETADMINS(src) then
        UNIQUE_AC_ACTION(src, UNIQUE_AC.AdminMenu.MenuPunishment, "Anti Open Admin Menu",
            "Unauthorized admin exemption request")
        return
    end
    if enabled == true then
        uniqueacGrantActionGrace(src, durationMs, "adminMode")
    else
        UNIQUE_AC_CHANGE_TEMP_WHHITELIST(src, false, 0)
    end
end)

RegisterNetEvent("UNIQUE_AC:setPlayerBlips")
AddEventHandler("UNIQUE_AC:setPlayerBlips", function(enabled)
    local src = tonumber(source)
    if not src or not UNIQUE_AC_GETADMINS(src) then return end
    PLAYER_BLIP_SUBSCRIBERS[src] = enabled and true or nil
end)

CreateThread(function()
    while true do
        Wait(3000)
        local hasSubscribers = false
        for _ in pairs(PLAYER_BLIP_SUBSCRIBERS) do hasSubscribers = true break end
        if hasSubscribers then
            local players = {}
            for _, pid in ipairs(GetPlayers()) do
                local id = tonumber(pid)
                local ped = id and GetPlayerPed(id)
                if id and ped and ped ~= 0 and DoesEntityExist(ped) then
                    local c = GetEntityCoords(ped)
                    players[#players + 1] = { id = id, name = GetPlayerName(id) or ("ID " .. id), x = c.x, y = c.y, z = c.z }
                end
            end
            for adminSrc in pairs(PLAYER_BLIP_SUBSCRIBERS) do
                if GetPlayerName(adminSrc) then
                    TriggerClientEvent("UNIQUE_AC:updatePlayerBlips", adminSrc, players)
                else
                    PLAYER_BLIP_SUBSCRIBERS[adminSrc] = nil
                end
            end
        end
    end
end)

RegisterCommand('funban', function(source, args)
    local BAN_ID = args[1]

    if source == 0 then
        local unbaned = UNIQUE_AC:UNBAN(BAN_ID)

        if unbaned then
            print("^" .. COLORS .. "[UNIQUE_AC]^0: You unbanned ^2" .. tostring(BAN_ID) .. "^0 !")
        else
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 unban failed !^0")
        end
    else
        if UNIQUE_AC_UNBANACCESS(source) then
            local unbaned = UNIQUE_AC:UNBAN(BAN_ID)

            if unbaned then
                TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 }, "You unbanned ^2" .. tostring(BAN_ID) ..
                    "^0 !")
            else
                TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 }, "Your unbanned failed !")
            end
        else
            TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 },
                "You don't have access for unban players !")
        end
    end
end)

RegisterCommand('unban', function(source, args)
    local BAN_ID = args[1]
    if source == 0 then
        local unbaned = UNIQUE_AC:UNBAN(BAN_ID)
        if unbaned then
            print("^" .. COLORS .. "[UNIQUE_AC]^0: You unbanned ^2" .. tostring(BAN_ID) .. "^0 !")
        else
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 unban failed !^0")
        end
    elseif UNIQUE_AC_UNBANACCESS(source) then
        local unbaned = UNIQUE_AC:UNBAN(BAN_ID)
        if unbaned then
            TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 }, "You unbanned ^2" .. tostring(BAN_ID) .. "^0 !")
        else
            TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 }, "Your unban failed !")
        end
    else
        TriggerClientEvent("chatMessage", source, "[UNIQUE_AC]", { 255, 0, 0 }, "You don't have access for unban players !")
    end
end)

RegisterCommand('addadmin', function(source, args)
    local PLAYER_ID = tonumber(args[1])

    if source == 0 then
        if PLAYER_ID and GetPlayerName(PLAYER_ID) then
            local addedAdmin = UNIQUE_AC:ADDADMIN(PLAYER_ID)

            if addedAdmin then
                TRUSTED_ADMINS[PLAYER_ID] = true
                invalidatePermissionCache(PLAYER_ID)
                UNIQUE_AC_CHANGE_TEMP_WHHITELIST(PLAYER_ID, true, 120000)
                print("^" ..
                    COLORS ..
                    "[UNIQUE_AC]^0: You added ^2" .. GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to admin list^0 !")
                TriggerClientEvent("UNIQUE_AC:clientGrace", PLAYER_ID, 120000)
                TriggerClientEvent("UNIQUE_AC:allowToOpen", PLAYER_ID, true)
            else
                print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 add admin failed !^0")
            end
        else
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 This player isn't online !^0")
        end
    end
end)

RegisterCommand('addwhitelist', function(source, args)
    local PLAYER_ID = tonumber(args[1])

    if source == 0 then
        if PLAYER_ID and GetPlayerName(PLAYER_ID) then
            local addedAdmin = UNIQUE_AC:ADDWHITELIST(PLAYER_ID)

            if addedAdmin then
                invalidatePermissionCache(PLAYER_ID)
                UNIQUE_AC_CHANGE_TEMP_WHHITELIST(PLAYER_ID, true, 120000)
                TriggerClientEvent("UNIQUE_AC:clientGrace", PLAYER_ID, 120000)
                print("^" ..
                    COLORS ..
                    "[UNIQUE_AC]^0: You added ^2" .. GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to whitelist^0 !")
            else
                print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 failed to add access !^0")
            end
        else
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 This player isn't online !^0")
        end
    end
end)

RegisterCommand('uniqueachealth', function(source)
    if source ~= 0 then return end
    local h = UNIQUE_AC_GET_HEALTH()
    local hours = math.floor(h.uptimeSeconds / 3600)
    local mins = math.floor((h.uptimeSeconds % 3600) / 60)
    print(("^2[UNIQUE_AC]^0 Uptime: %dh %dm | Resources: %d | Approx. frame drift: %dms (lower is healthier, this is an estimate — FiveM doesn't expose real TPS/RAM to resources)")
        :format(hours, mins, h.resourceCount, h.avgFrameDriftMs))
end, false)

RegisterCommand('addunban', function(source, args)
    local PLAYER_ID = tonumber(args[1])

    if source == 0 then
        if PLAYER_ID and GetPlayerName(PLAYER_ID) then
            local addedAdmin = UNIQUE_AC:ADDUNBAN(PLAYER_ID)

            if addedAdmin then
                print("^" ..
                    COLORS ..
                    "[UNIQUE_AC]^0: You added ^2" ..
                    GetPlayerName(PLAYER_ID) .. "(" .. PLAYER_ID .. ")^0 to unban access^0 !")
            else
                print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 failed to add access !^0")
            end
        else
            print("^" .. COLORS .. "[UNIQUE_AC]^0: ^1 This player isn't online !^0")
        end
    end
end)

local function uniqueacResolveIdentifierArg(arg)
    local asId = tonumber(arg)
    if asId and GetPlayerName(asId) then
        return uniqueacPlayerLicense(asId) or arg
    end
    return arg
end

RegisterCommand('exportplayerdata', function(source, args)
    if source ~= 0 then return end
    local identifier = uniqueacResolveIdentifierArg(args[1])
    if not identifier or identifier == "" then
        print("Usage: exportplayerdata [license:xxxx or online ServerID]")
        return
    end

    local exportData = { identifier = identifier, exported_at = os.date("!%Y-%m-%d %H:%M:%S UTC") }
    local pending = 5

    local function finish()
        pending = pending - 1
        if pending > 0 then return end
        local fileName = "exports/player-" .. identifier:gsub("[^%w]", "_") .. ".json"
        local ok = pcall(SaveResourceFile, GetCurrentResourceName(), fileName, json.encode(exportData), -1)
        if ok then
            print(("^2[UNIQUE_AC]^0 Export saved to %s/%s"):format(GetCurrentResourceName(), fileName))
        else
            print("^1[UNIQUE_AC]^0 Export failed — SaveResourceFile isn't available on this build. Printing to console instead:")
            print(json.encode(exportData))
        end
    end

    MySQL.Async.fetchAll("SELECT * FROM uniqueac_trust WHERE identifier = @id", { ["@id"] = identifier }, function(r) exportData.trust = r; finish() end)
    MySQL.Async.fetchAll("SELECT id, note, author_name, created_at FROM uniqueac_notes WHERE target_identifier = @id", { ["@id"] = identifier }, function(r) exportData.notes = r; finish() end)
    MySQL.Async.fetchAll("SELECT reason, details, action, created_at FROM uniqueac_detections WHERE identifier = @id", { ["@id"] = identifier }, function(r) exportData.detections = r; finish() end)
    MySQL.Async.fetchAll("SELECT id, message, status, created_at FROM uniqueac_appeals WHERE identifier = @id", { ["@id"] = identifier }, function(r) exportData.appeals = r; finish() end)
    MySQL.Async.fetchAll("SELECT * FROM uniqueac_banlist WHERE LICENSE = @id", { ["@id"] = identifier }, function(r) exportData.bans = r; finish() end)
end)

RegisterCommand('deleteplayerdata', function(source, args)
    if source ~= 0 then return end
    local identifier = uniqueacResolveIdentifierArg(args[1])
    if not identifier or identifier == "" then
        print("Usage: deleteplayerdata [license:xxxx or online ServerID]")
        return
    end





    MySQL.Async.execute("DELETE FROM uniqueac_trust WHERE identifier = @id", { ["@id"] = identifier })
    MySQL.Async.execute("DELETE FROM uniqueac_notes WHERE target_identifier = @id", { ["@id"] = identifier })
    MySQL.Async.execute("DELETE FROM uniqueac_detections WHERE identifier = @id", { ["@id"] = identifier })
    MySQL.Async.execute("DELETE FROM uniqueac_appeals WHERE identifier = @id", { ["@id"] = identifier })
    MySQL.Async.execute("DELETE FROM uniqueac_admin_log WHERE target_identifier = @id", { ["@id"] = identifier })

    print(("^2[UNIQUE_AC]^0 Deleted UNIQUE_AC-held data for %s (trust, notes, detections, appeals, and admin-log entries where they were the target). Ban records were NOT deleted — use /uniqueacunban separately if that's also intended."):format(identifier))
end)

RegisterCommand((UNIQUE_AC.PlayerTransparency and UNIQUE_AC.PlayerTransparency.Command) or "mystatus", function(source)
    if not UNIQUE_AC.PlayerTransparency or not UNIQUE_AC.PlayerTransparency.Enable then return end
    local src = tonumber(source)
    if not src or src == 0 then return end
    local st = playerState(src)
    local trust = (st and st.trust) or 100

    local label, color
    if trust >= 80 then
        label, color = UNIQUE_AC_TR("status_good"), { 89, 201, 122 }
    elseif trust >= 50 then
        label, color = UNIQUE_AC_TR("status_mid"), { 245, 166, 35 }
    else
        label, color = UNIQUE_AC_TR("status_low"), { 228, 72, 58 }
    end

    uniqueacNotify(src, ("Your account standing: %d/100 — %s."):format(trust, label), color)
end, false)
