--[[
    ================================================================
    SECURITY GUARD — features #17, #18, #19, #22
    ================================================================
      #17 اعتبارسنجی سمت سرور قوی‌تر برای هر انتقال (ضدداپلیکیت)
      #18 rate-limit روی give/remove
      #19 آنومالی دیتکتور
      #22 تایید دو مرحله‌ای برای انتقال گران‌قیمت

    Load order matters: this file must come AFTER core.lua and BEFORE
    server/main.lua (which is where the give/remove handlers live). The
    fxmanifest glob 'server/custom/security/*.lua' sorts alphabetically,
    so core.lua < guard.lua is already correct.

    ── The actual dupe bug this fixes ──
    The existing 'lgd:giveItem' handler does:

        local x_Item = GetItem(xPlayer, name)
        if count > 0 and GetItemAmount(x_Item) >= count then
            if getWeight(xTarget, name, count) then
                RemoveItem(xPlayer, name, count)
                AddItem(xTarget, name, count)

    `getWeight()` is `player.canCarryItem()`, which is synchronous — but
    `showNotification` and the Discord webhook right after are not, and
    more importantly nothing stops TWO 'lgd:giveItem' events from the same
    client being processed back-to-back before either RemoveItem lands.
    Both read the same pre-removal count, both pass the `>= count` check,
    both AddItem to the target. That's the classic net-event dupe and it
    needs exactly one thing to fix properly: a per-player lock held across
    the whole check-and-mutate sequence. Everything else in this file is
    defence in depth around that.
]]

local Security = _G.InvSecurity
local Guard = {}
_G.InvGuard = Guard

local function enabled()
    return Config.Security and Config.Security.enabled
end

local function verbose(msg)
    if Config.Security and Config.Security.verbose then
        print('^3[esx_inventory/guard] ^7' .. msg)
    end
end

--═════════════════════════════════════════════════════════════════════════
-- Reporting
--═════════════════════════════════════════════════════════════════════════

local function webhookUrl()
    local w = Config.Security and Config.Security.webhook
    if w and w.url and w.url ~= '' then return w.url, w.color end
    if webhooks and webhooks['removeItem'] then
        return webhooks['removeItem'].webhook, webhooks['removeItem'].color
    end
    return nil
end

local function report(title, identifier, detail)
    verbose(title .. ' | ' .. tostring(identifier) .. ' | ' .. tostring(detail))

    -- Persist. This is the record a human actually reviews, and it must
    -- survive a restart — an in-memory-only flag table is useless the
    -- moment the cheater's session ends.
    MySQL.Async.execute(
        'INSERT INTO inv_security_flags (identifier, kind, detail, created_at) VALUES (@id, @kind, @detail, NOW())',
        { ['@id'] = tostring(identifier), ['@kind'] = title, ['@detail'] = tostring(detail) }
    )

    local url, color = webhookUrl()
    if url and url ~= '' and sendToDiscordWithSpecialURL then
        sendToDiscordWithSpecialURL(
            '🛡️ ' .. title,
            ('\n\n``💿``Identifier: ``%s``\n``💬``Detail: ``%s``'):format(tostring(identifier), tostring(detail)),
            color or 15105570,
            url
        )
    end
end

Guard.report = report

--═════════════════════════════════════════════════════════════════════════
-- #18 — RATE LIMIT  (sliding window, per player per action)
--═════════════════════════════════════════════════════════════════════════

local buckets = {}      -- [src] = { [action] = { timestamps... } }
local tripCounts = {}   -- [src] = { count = n, windowStart = ms }

local function now() return GetGameTimer() end

local function limitFor(action)
    local limits = Config.Security and Config.Security.rateLimits or {}
    return limits[action] or limits['default'] or { window = 10, max = 25 }
end

--- Returns true if the action is ALLOWED, false if it should be dropped.
function Guard.rateLimit(src, action)
    if not enabled() then return true end

    local limit = limitFor(action)
    local windowMs = (limit.window or 10) * 1000
    local cutoff = now() - windowMs

    buckets[src] = buckets[src] or {}
    local bucket = buckets[src][action]
    if not bucket then
        bucket = {}
        buckets[src][action] = bucket
    end

    -- Drop timestamps that have aged out of the window. Walk from the
    -- front; the list is naturally ordered because we only ever append.
    local keep = 1
    for i = 1, #bucket do
        if bucket[i] > cutoff then
            keep = i
            break
        end
        keep = i + 1
    end
    if keep > 1 then
        for i = 1, #bucket - keep + 1 do
            bucket[i] = bucket[i + keep - 1]
        end
        for i = #bucket - keep + 2, #bucket do
            bucket[i] = nil
        end
    end

    if #bucket >= (limit.max or 25) then
        Guard.onLimitTripped(src, action)
        return false
    end

    bucket[#bucket + 1] = now()
    return true
end

function Guard.onLimitTripped(src, action)
    local xPlayer = GetPlayerFromId(src)
    local identifier = xPlayer and GetPlayerLicense(xPlayer) or ('src:' .. tostring(src))

    verbose(('rate limit tripped: %s action=%s'):format(identifier, action))

    if (Config.Security.onRateLimit or 'ignore') == 'notify' and xPlayer then
        showNotification(xPlayer, Locales[Config.Language]['rate_limited']
            or 'You are doing that too quickly.', 'error')
    end

    -- Escalation: tripping limits repeatedly isn't clumsy play, it's a
    -- script that doesn't know it's being throttled.
    local esc = Config.Security.rateLimitEscalation or { count = 5, repeatWindow = 60 }
    local t = tripCounts[src]
    if not t or (now() - t.windowStart) > (esc.repeatWindow * 1000) then
        tripCounts[src] = { count = 1, windowStart = now() }
    else
        t.count = t.count + 1
        if t.count == esc.count then
            Guard.addAnomalyScore(src, 50, ('repeatedly hit rate limits (%s)'):format(action))
        end
    end
end

--═════════════════════════════════════════════════════════════════════════
-- #19 — ANOMALY DETECTOR
--
-- Rolling score per identifier. Decays linearly over decayWindow so a
-- player who tripped one rule an hour ago isn't permanently closer to a
-- flag than someone who just joined.
--═════════════════════════════════════════════════════════════════════════

local scores = {}       -- [identifier] = { value = n, lastUpdate = ms }
local giveLog = {}      -- [identifier] = { {to=, item=, count=, at=}, ... }
local receiveLog = {}   -- [identifier] = { {from=, at=}, ... }
local lastTransferAt = {} -- [identifier] = ms

local function isWhitelisted(identifier)
    return Config.Security.anomalyWhitelist
       and Config.Security.anomalyWhitelist[identifier] == true
end

local function decayedScore(identifier)
    local s = scores[identifier]
    if not s then return 0 end

    local cfg = Config.Security.anomaly or {}
    local windowMs = (cfg.decayWindow or 300) * 1000
    local elapsed = now() - s.lastUpdate

    if elapsed >= windowMs then
        scores[identifier] = nil
        return 0
    end

    return s.value * (1 - (elapsed / windowMs))
end

function Guard.addAnomalyScore(src, amount, reason)
    if not enabled() then return end
    local cfg = Config.Security.anomaly or {}
    if not cfg.enabled then return end

    local xPlayer = GetPlayerFromId(src)
    if not xPlayer then return end
    local identifier = GetPlayerLicense(xPlayer)
    if isWhitelisted(identifier) then return end

    local current = decayedScore(identifier)
    local newValue = current + amount
    scores[identifier] = { value = newValue, lastUpdate = now() }

    verbose(('anomaly +%d (%s) => %.0f  [%s]'):format(amount, reason, newValue, identifier))

    if newValue >= (cfg.threshold or 100) then
        scores[identifier] = nil -- reset so one player doesn't spam the webhook
        report('Anomaly threshold reached', identifier,
            ('score %.0f — last trigger: %s'):format(newValue, reason))
    end
end

local function pruneLog(log, windowMs)
    local cutoff = now() - windowMs
    local out = {}
    for i = 1, #log do
        if log[i].at > cutoff then out[#out + 1] = log[i] end
    end
    return out
end

--- Called on every successful transfer. `kind` is 'item' | 'money' | 'weapon'.
function Guard.observeTransfer(src, targetSrc, kind, name, count)
    if not enabled() then return end
    local cfg = Config.Security.anomaly
    if not cfg or not cfg.enabled then return end

    local xPlayer = GetPlayerFromId(src)
    local xTarget = GetPlayerFromId(targetSrc)
    if not xPlayer then return end

    local identifier = GetPlayerLicense(xPlayer)
    if isWhitelisted(identifier) then return end
    local targetId = xTarget and GetPlayerLicense(xTarget) or 'unknown'
    local rules = cfg.rules or {}

    -- ── inhuman speed ────────────────────────────────────────────────
    local r = rules.inhumanSpeed
    if r then
        local last = lastTransferAt[identifier]
        if last and (now() - last) < (r.minIntervalMs or 120) then
            Guard.addAnomalyScore(src, r.score or 45,
                ('two transfers %dms apart'):format(now() - last))
        end
        lastTransferAt[identifier] = now()
    end

    -- ── huge stack / huge money ──────────────────────────────────────
    if kind == 'money' then
        r = rules.hugeMoney
        if r and count >= (r.amount or 5000000) then
            Guard.addAnomalyScore(src, r.score or 35,
                ('transferred %s of %s'):format(count, name))
        end
    else
        r = rules.hugeStack
        if r and count >= (r.amount or 500) then
            Guard.addAnomalyScore(src, r.score or 40,
                ('transferred %sx %s in one action'):format(count, name))
        end
    end

    -- ── repeated give (same item, same target) ───────────────────────
    r = rules.repeatedGive
    if r then
        local log = pruneLog(giveLog[identifier] or {}, (r.window or 60) * 1000)
        log[#log + 1] = { to = targetId, item = name, count = count, at = now() }
        giveLog[identifier] = log

        local matches = 0
        for i = 1, #log do
            if log[i].to == targetId and log[i].item == name then
                matches = matches + 1
            end
        end
        if matches >= (r.count or 6) then
            Guard.addAnomalyScore(src, r.score or 25,
                ('%d gives of %s to the same player in %ds'):format(matches, name, r.window or 60))
        end
    end

    -- ── many sources (mule detection, scored against the RECEIVER) ───
    r = rules.manySources
    if r and xTarget then
        local log = pruneLog(receiveLog[targetId] or {}, (r.window or 120) * 1000)
        log[#log + 1] = { from = identifier, at = now() }
        receiveLog[targetId] = log

        local seen, distinct = {}, 0
        for i = 1, #log do
            if not seen[log[i].from] then
                seen[log[i].from] = true
                distinct = distinct + 1
            end
        end
        if distinct >= (r.count or 8) then
            Guard.addAnomalyScore(targetSrc, r.score or 30,
                ('received from %d different players in %ds'):format(distinct, r.window or 120))
        end
    end
end

--- Weight-based dupe signature: used weight went UP across a removal.
function Guard.checkWeightDelta(src, before, after, expectedDirection)
    if not enabled() then return end
    local rules = (Config.Security.anomaly or {}).rules or {}
    local r = rules.weightMismatch
    if not r then return end

    if expectedDirection == 'down' and after > before + 0.001 then
        Guard.addAnomalyScore(src, r.score or 60,
            ('weight rose %.2f->%.2f across a removal'):format(before, after))
    end
end

--═════════════════════════════════════════════════════════════════════════
-- #17 — ANTI-DUPE TRANSFER VALIDATION
--═════════════════════════════════════════════════════════════════════════

local locks = {} -- [src] = true while a transfer is in flight

--- Run `fn` holding this player's transfer lock. Returns whatever fn
--- returns, or nil if the lock was already held (i.e. a second concurrent
--- transfer request — exactly the dupe case).
function Guard.withLock(src, fn)
    if not enabled() or not (Config.Security.transfer or {}).lockPerPlayer then
        return fn()
    end

    if locks[src] then
        verbose(('concurrent transfer rejected for src=%s'):format(src))
        Guard.addAnomalyScore(src, 20, 'concurrent transfer attempt')
        return nil
    end

    locks[src] = true
    local ok, result = pcall(fn)
    locks[src] = nil

    if not ok then
        -- Never let an error leave the lock stuck (that would soft-lock the
        -- player out of all future transfers until reconnect).
        print('^1[esx_inventory/guard] transfer handler errored: ' .. tostring(result) .. '^7')
        return nil
    end
    return result
end

local function pedDistance(a, b)
    local pa, pb = GetPlayerPed(a), GetPlayerPed(b)
    if not pa or not pb or pa == 0 or pb == 0 then return nil end
    local ca, cb = GetEntityCoords(pa), GetEntityCoords(pb)
    return #(ca - cb)
end

--- Full pre-flight validation shared by every transfer path.
--- Returns ok:boolean, reason:string|nil
function Guard.validateTransfer(src, targetSrc, kind, name, count)
    if not enabled() then return true end

    local cfg = Config.Security.transfer or {}

    -- basic shape
    if type(name) ~= 'string' or name == '' then
        return false, 'bad item name'
    end
    if kind ~= 'weapon' then
        count = tonumber(count)
        if not count or count <= 0 or count ~= math.floor(count) then
            return false, 'bad count'
        end
        -- A count this large is always forged; it also protects the
        -- arithmetic below from overflow weirdness.
        if count > 1000000 then
            return false, 'absurd count'
        end
    end

    -- self transfer
    if cfg.blockSelfTransfer and src == targetSrc then
        Guard.addAnomalyScore(src, 30, 'attempted transfer to self')
        return false, 'self transfer'
    end

    local xPlayer, xTarget = GetPlayerFromId(src), GetPlayerFromId(targetSrc)
    if not xPlayer then return false, 'invalid source' end
    if not xTarget then return false, 'invalid target' end

    -- distance
    local maxDist = cfg.maxDistance or 5.0
    if maxDist > 0 then
        local d = pedDistance(src, targetSrc)
        if d == nil then
            return false, 'could not resolve peds'
        end
        if d > maxDist then
            Guard.addAnomalyScore(src, 25, ('transfer at %.1fm (max %.1f)'):format(d, maxDist))
            return false, 'too far'
        end
    end

    return true
end

--- Post-removal verification: confirm the giver actually lost exactly
--- `count`, and roll back if not.
function Guard.verifyRemoval(src, name, expectedBefore, count)
    if not enabled() or not (Config.Security.transfer or {}).verifyDelta then
        return true
    end

    local xPlayer = GetPlayerFromId(src)
    if not xPlayer then return false end

    local item = GetItem(xPlayer, name)
    local after = item and GetItemAmount(item) or 0
    local expectedAfter = expectedBefore - count

    if after ~= expectedAfter then
        report('Transfer delta mismatch', GetPlayerLicense(xPlayer),
            ('%s: expected %d after removing %d from %d, got %d')
            :format(name, expectedAfter, count, expectedBefore, after))
        Guard.addAnomalyScore(src, 60, 'inventory delta mismatch')
        return false
    end

    return true
end

--═════════════════════════════════════════════════════════════════════════
-- #22 — TWO-STEP CONFIRMATION
--═════════════════════════════════════════════════════════════════════════

local pending = {}   -- [token] = { from, to, kind, name, count, label, expiresAt, fromOk, toOk, execute }
local tokenSeq = 0

local function newToken()
    tokenSeq = tokenSeq + 1
    return ('cf%d_%d'):format(os.time(), tokenSeq)
end

--- Does this transfer need confirmation?
function Guard.needsConfirmation(kind, name, count)
    local cfg = Config.Security.confirm
    if not cfg or not cfg.enabled then return false end

    if cfg.highValueItems and cfg.highValueItems[name] then
        return true
    end

    if kind == 'money' then
        return (tonumber(count) or 0) >= (cfg.valueThreshold or 250000)
    end

    if kind == 'weapon' and cfg.illegalWeaponsAlwaysConfirm then
        local legal = Config.WeaponLegality and Config.WeaponLegality[name]
        if legal == nil then legal = Config.WeaponLegalDefault end
        if legal == false then return true end
    end

    return false
end

--- Stage a transfer. `execute` is the closure that actually moves the
--- goods; it only ever runs once both sides have confirmed.
function Guard.stageConfirmation(src, targetSrc, kind, name, count, label, execute)
    local cfg = Config.Security.confirm
    local token = newToken()

    pending[token] = {
        from = src, to = targetSrc,
        kind = kind, name = name, count = count, label = label or name,
        expiresAt = os.time() + (cfg.timeout or 30),
        fromOk = false, toOk = false,
        execute = execute,
    }

    local summary = (kind == 'money')
        and ('%s %s'):format(count, Config.AccountName and Config.AccountName[name] or name)
        or  ('%sx %s'):format(count, label or name)

    TriggerClientEvent('esx_inventory:confirmTransfer', src, {
        token = token, role = 'sender', summary = summary,
        timeout = cfg.timeout or 30,
        target = GetPlayerName(targetSrc),
    })

    if cfg.requireReceiverConfirm then
        TriggerClientEvent('esx_inventory:confirmTransfer', targetSrc, {
            token = token, role = 'receiver', summary = summary,
            timeout = cfg.timeout or 30,
            target = GetPlayerName(src),
        })
    end

    SetTimeout((cfg.timeout or 30) * 1000 + 500, function()
        local p = pending[token]
        if p then
            pending[token] = nil
            local xFrom = GetPlayerFromId(p.from)
            if xFrom then
                showNotification(xFrom, Locales[Config.Language]['confirm_expired']
                    or 'Transfer expired — not confirmed in time.', 'error')
            end
        end
    end)

    return token
end

RegisterNetEvent('esx_inventory:respondConfirmTransfer')
AddEventHandler('esx_inventory:respondConfirmTransfer', function(token, accepted)
    local src = source
    if type(token) ~= 'string' then return end

    local p = pending[token]
    if not p then return end

    -- Only the two parties may answer, and each only for their own side.
    -- Without this check any client could confirm any pending transfer by
    -- guessing a token.
    if src ~= p.from and src ~= p.to then
        Guard.addAnomalyScore(src, 40, 'responded to a transfer it is not party to')
        return
    end

    if os.time() > p.expiresAt then
        pending[token] = nil
        return
    end

    if not accepted then
        pending[token] = nil
        for _, s in ipairs({ p.from, p.to }) do
            local x = GetPlayerFromId(s)
            if x then
                showNotification(x, Locales[Config.Language]['confirm_declined']
                    or 'Transfer declined.', 'error')
            end
        end
        return
    end

    if src == p.from then p.fromOk = true end
    if src == p.to   then p.toOk = true end

    local cfg = Config.Security.confirm
    local ready = p.fromOk and (not cfg.requireReceiverConfirm or p.toOk)
    if not ready then return end

    pending[token] = nil

    -- Re-validate from scratch: everything could have changed in the 30s
    -- the prompt was on screen (items spent, players walked apart, one of
    -- them disconnected). Confirming is not a licence to skip the checks.
    local ok, reason = Guard.validateTransfer(p.from, p.to, p.kind, p.name, p.count)
    if not ok then
        local xFrom = GetPlayerFromId(p.from)
        if xFrom then
            showNotification(xFrom, Locales[Config.Language]['confirm_revalidate_failed']
                or 'Transfer conditions are no longer met.', 'error')
        end
        verbose('confirmed transfer failed re-validation: ' .. tostring(reason))
        return
    end

    Guard.withLock(p.from, function()
        p.execute()
    end)

    report('High-value transfer confirmed',
        (function()
            local x = GetPlayerFromId(p.from)
            return x and GetPlayerLicense(x) or tostring(p.from)
        end)(),
        ('%s %sx %s -> %s'):format(p.kind, p.count, p.name, GetPlayerName(p.to) or p.to))
end)

--═════════════════════════════════════════════════════════════════════════
-- Cleanup
--═════════════════════════════════════════════════════════════════════════

AddEventHandler('playerDropped', function()
    local src = source
    buckets[src] = nil
    tripCounts[src] = nil
    locks[src] = nil

    for token, p in pairs(pending) do
        if p.from == src or p.to == src then
            pending[token] = nil
        end
    end
end)

-- Periodic prune of the anomaly bookkeeping so a long-uptime server
-- doesn't grow these tables without bound.
CreateThread(function()
    while true do
        Wait(5 * 60000)
        for id in pairs(scores) do
            if decayedScore(id) <= 0 then scores[id] = nil end
        end
        for id, log in pairs(giveLog) do
            local pruned = pruneLog(log, 300000)
            giveLog[id] = #pruned > 0 and pruned or nil
        end
        for id, log in pairs(receiveLog) do
            local pruned = pruneLog(log, 300000)
            receiveLog[id] = #pruned > 0 and pruned or nil
        end
        local cutoff = now() - 300000
        for id, at in pairs(lastTransferAt) do
            if at < cutoff then lastTransferAt[id] = nil end
        end
    end
end)

exports('guardRateLimit',   function(src, action) return Guard.rateLimit(src, action) end)
exports('guardFlag',        function(src, score, reason) return Guard.addAnomalyScore(src, score, reason) end)
exports('guardValidate',    function(...) return Guard.validateTransfer(...) end)

return Guard
