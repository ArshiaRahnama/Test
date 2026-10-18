-------------------------------------------------------------------
-- GANG HEISTS - plan robberies claimed from Boss Menu > Robbery
-- ---------------------------------------------------------------
--   * Robbery TYPES in Config.Rob.Plans.Requirements are plan robberies.
--     The gang BOSS claims one from the Robbery menu: the plans are taken
--     out of the gang ARMORY, the first gang to claim owns that robbery
--     for Config.Heist.ClaimMinutes (7) and has to go there and start it
--     (party of the required size + E, exactly like always).
--   * Nobody else can start a claimed plan robbery. An unstarted claim
--     expires and gives back part of the plans.
--   * Party members who die are thrown out of the party.
--   * A won robbery hands the winner a TOKEN item. It only counts as a WIN
--     (and pays gang tokens) when the token is USED within 30 minutes;
--     otherwise it counts as a LOSS. Failed / cancelled / abandoned
--     robberies are losses straight away.
--   * When a robbery succeeds the police who are around it are paid.
--   * Wins / losses / tokens are kept per gang and shown in the menu.
--
-- Plugs into server.lua (HeistGate is called from robberyNeeds; success /
-- cancel / hack-fail / disconnect are caught with additive event handlers),
-- Unique_inventory (armory exports) and Unique_ALLGangs (IsGangBoss).
-------------------------------------------------------------------

if not Config.Heist or not Config.Heist.Enabled then return end

local H = Config.Heist

ESX = ESX or nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Claims    = {}  -- Claims[robname] = { gang, label, by, at, expiresAt, status = 'claimed'|'started', plan = {item, count}, tier }
local GangClaim = {}  -- GangClaim[gang] = robname
local Lock      = {}  -- Lock[gang .. '|' .. robname] = os.time() until the same gang may claim it again
local Active    = {}  -- Active[src] = { rob, gang }   (a plan robbery that has really started)
local Started   = {}  -- Started[src] = { rob }        (ANY robbery that passed the start check, for the police payout)
local Stats     = {}  -- Stats[gang] = { wins, losses, tokens }
local Pending   = {}  -- unused win tokens: { id, gang, identifier, rob, issuedAt, expiresAt }

-------------------------------------------------------------------
-- DB
-------------------------------------------------------------------
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_heist_stats` (
          `gang` varchar(254) NOT NULL,
          `wins` int(11) NOT NULL DEFAULT 0,
          `losses` int(11) NOT NULL DEFAULT 0,
          `tokens` int(11) NOT NULL DEFAULT 0,
          `points` int(11) NOT NULL DEFAULT 0,
          PRIMARY KEY (`gang`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;
    ]])
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_heist_tokens` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `gang` varchar(254) NOT NULL,
          `identifier` varchar(100) NOT NULL,
          `rob` varchar(100) NOT NULL,
          `issued_at` int(255) NOT NULL DEFAULT 0,
          `expires_at` int(255) NOT NULL DEFAULT 0,
          `status` varchar(16) NOT NULL DEFAULT 'pending',
          PRIMARY KEY (`id`),
          KEY `idx_status` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;
    ]])
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_heist_log` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `gang` varchar(254) NOT NULL,
          `rob` varchar(100) NOT NULL,
          `outcome` varchar(24) NOT NULL,
          `player` varchar(100) DEFAULT NULL,
          `at` int(255) NOT NULL DEFAULT 0,
          PRIMARY KEY (`id`),
          KEY `idx_gang` (`gang`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;
    ]], {}, function()
        -- tables created by an earlier version of this script have no `points` column yet
        MySQL.Async.fetchAll("SHOW COLUMNS FROM gang_heist_stats LIKE 'points'", {}, function(cols)
            local function load()
                MySQL.Async.fetchAll('SELECT * FROM gang_heist_stats', {}, function(rows)
                    for _, r in ipairs(rows or {}) do
                        Stats[r.gang] = { wins = r.wins or 0, losses = r.losses or 0, tokens = r.tokens or 0, points = r.points or 0 }
                    end
                end)
            end
            if not cols or #cols == 0 then
                MySQL.Async.execute('ALTER TABLE gang_heist_stats ADD COLUMN `points` int(11) NOT NULL DEFAULT 0', {}, load)
            else
                load()
            end
        end)
        MySQL.Async.fetchAll("SELECT * FROM gang_heist_tokens WHERE status = 'pending'", {}, function(rows)
            for _, r in ipairs(rows or {}) do
                Pending[#Pending + 1] = { id = r.id, gang = r.gang, identifier = r.identifier, rob = r.rob, issuedAt = r.issued_at, expiresAt = r.expires_at }
            end
        end)
    end)
end)

local function StatsOf(gang)
    local s = Stats[gang]
    if not s then
        -- first time we see this gang: it starts with a few points so it can request a robbery right away
        s = { wins = 0, losses = 0, tokens = 0, points = (H.Points and H.Points.Start) or 0 }
        Stats[gang] = s
    end
    return s
end

local function SaveStats(gang)
    local s = StatsOf(gang)
    MySQL.Async.execute([[
        INSERT INTO gang_heist_stats (gang, wins, losses, tokens, points) VALUES (@g, @w, @l, @t, @p)
        ON DUPLICATE KEY UPDATE wins = @w, losses = @l, tokens = @t, points = @p
    ]], { ['@g'] = gang, ['@w'] = s.wins, ['@l'] = s.losses, ['@t'] = s.tokens, ['@p'] = s.points or 0 })
end

local function LogHeist(gang, rob, outcome, player)
    MySQL.Async.execute('INSERT INTO gang_heist_log (gang, rob, outcome, player, at) VALUES (@g, @r, @o, @p, @t)',
        { ['@g'] = gang, ['@r'] = rob, ['@o'] = outcome, ['@p'] = player, ['@t'] = os.time() })
end

-------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------
local function Notify(src, text, kind) TriggerClientEvent('esx:showNotification', src, text, kind or 'info') end

local function Chat(src, text)
    TriggerClientEvent('chat:addMessage', src, { color = { 170, 110, 255 }, multiline = true, args = { 'ROBBERY', text } })
end

local function GangOf(xPlayer)
    if not xPlayer or not xPlayer.gang or not xPlayer.gang.name or xPlayer.gang.name == 'nogang' then return nil end
    return xPlayer.gang.name
end

local function GangLabelOf(xPlayer)
    return (xPlayer and xPlayer.gang and (xPlayer.gang.label or xPlayer.gang.name)) or 'gang'
end

local function TellGang(gang, text, kind)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if GangOf(x) == gang then
            Notify(playerId, text, kind)
            Chat(playerId, text)
        end
    end
end

local function SendToGang(gang, event, ...)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if GangOf(x) == gang then TriggerClientEvent(event, playerId, ...) end
    end
end

local function IsBoss(src)
    local ok, res = pcall(function() return exports['Unique_ALLGangs']:IsGangBoss(src) end)
    return ok and res and true or false
end

local function ArmoryCount(gang, item)
    local ok, n = pcall(function() return exports['Unique_inventory']:GetGangArmoryItemCount(gang, item) end)
    return ok and tonumber(n) or 0
end
local function ArmoryRemove(gang, item, count)
    local ok, res = pcall(function() return exports['Unique_inventory']:RemoveGangArmoryItem(gang, item, count) end)
    return ok and res and true or false
end
local function ArmoryAdd(gang, item, count)
    if count <= 0 then return true end
    local ok, res = pcall(function() return exports['Unique_inventory']:AddGangArmoryItem(gang, item, count) end)
    return ok and res and true or false
end

-- plan requirement of a robbery (nil = a normal robbery that needs no plan)
local function PlanOf(robname)
    local rob = Config.Rob.Robs[robname]
    if not rob then return nil end
    local req = Config.Rob.Plans.Requirements[rob.type]
    local item = req and Config.Rob.Plans.Items[req.tier]
    if not req or not item or (tonumber(req.count) or 0) <= 0 then return nil end
    return { tier = req.tier, item = item, count = req.count }
end

local function CopsOnline()
    local n = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.job and IsPoliceJob(x.job.name) then n = n + 1 end
    end
    return n
end

-- seconds until this robbery can be started again (location cooldown + the
-- whole-type "another one is in progress" window), 0 when free
local function CooldownLeft(robname)
    local rob = Config.Rob.Robs[robname]
    local rt = Config.Rob.RobTypes[rob.type]
    local now = os.time()
    local left = 0
    if rob.lastRobbed ~= 0 and (now - rob.lastRobbed) < rt.cooldown then left = math.max(left, rt.cooldown - (now - rob.lastRobbed)) end
    if (now - rt.lastRobbed) < rt.successtime then left = math.max(left, rt.successtime - (now - rt.lastRobbed)) end
    return left
end

local function ReleaseClaim(robname)
    local c = Claims[robname]
    if not c then return end
    if GangClaim[c.gang] == robname then GangClaim[c.gang] = nil end
    Claims[robname] = nil
    SendToGang(c.gang, 'Heist:ClaimEnded', robname)
end

-------------------------------------------------------------------
-- Lottery rounds ("Robbery A" ...): WAITING -> OPEN, then the next round
-------------------------------------------------------------------
local StartTime = os.time()
local PlanKeys = nil   -- sorted keys of all plan robberies (built lazily)

local function GetPlanKeys()
    if PlanKeys then return PlanKeys end
    PlanKeys = {}
    for name in pairs(Config.Rob.Robs) do
        if PlanOf(name) then PlanKeys[#PlanKeys + 1] = name end
    end
    table.sort(PlanKeys)
    return PlanKeys
end

local function CostOf(robname)
    local L = H.Lottery
    if not L or not L.Enabled then return 0 end
    local rob = Config.Rob.Robs[robname]
    return (L.Cost and L.Cost[rob.type]) or L.DefaultCost or 0
end

-- offset 0 = the round running now, 1 = the one after it
local function RoundInfo(offset)
    local L = H.Lottery
    local cycle = ((L.WaitMinutes or 5) + (L.OpenMinutes or 15)) * 60
    local now = os.time()
    local current = math.floor((now - StartTime) / cycle)
    local idx = current + (offset or 0)
    local waitStart = StartTime + idx * cycle
    local openAt = waitStart + (L.WaitMinutes or 5) * 60
    local endAt = openAt + (L.OpenMinutes or 15) * 60
    local phase, left
    if now < openAt then phase, left = 'waiting', openAt - now
    else phase, left = 'open', endAt - now end

    local names = L.Names or { 'A' }
    local keys = GetPlanKeys()
    local items = {}
    local per = math.min(L.PerRound or 3, #keys)
    for j = 0, per - 1 do items[#items + 1] = keys[(idx * per + j) % #keys + 1] end
    return { index = idx, name = names[idx % #names + 1], phase = phase, secondsLeft = left, items = items, opensAt = openAt, endsAt = endAt }
end

local function InCurrentRound(robname)
    local r = RoundInfo(0)
    for _, k in ipairs(r.items) do if k == robname then return true, r end end
    return false, r
end

-------------------------------------------------------------------
-- LOTTERY TICKETS: during OPEN a boss adds a ticket to a robbery of the
-- round. A ticket costs the plans + CostOf points. When the round closes
-- (the next round starts WAITING) one gang is drawn, weighted by tickets.
-------------------------------------------------------------------
local Pools = {}        -- Pools[robname] = { round = idx, total = n, entries = { [gang] = { tickets = n, label = '' } } }
local LastDrawn = RoundInfo(0).index - 1

local function RefundTickets(gang, plan, cost, tickets)
    if tickets <= 0 then return end
    ArmoryAdd(gang, plan.item, plan.count * tickets)
    StatsOf(gang).points = (StatsOf(gang).points or 0) + cost * tickets
    SaveStats(gang)
end

local function SortedKeys(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys)
    return keys
end

local function ChatAll(text)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        TriggerClientEvent('chat:addMessage', playerId, { color = { 170, 110, 255 }, multiline = true, args = { 'QURA-KESHI', text } })
    end
end

-- chance weight of a gang with n tickets (square root: diminishing returns)
local function TicketWeight(n)
    return math.sqrt(math.max(0, tonumber(n) or 0))
end

-- COMEBACK (pity): every draw the gang loses with tickets in it adds one step;
-- each step adds Lottery.PityBonus to its weight, up to Lottery.PityMaxSteps.
-- A win resets it. Memory only (a restart clears it).
local Pity = {}
local function PityBonus(gang)
    local L = H.Lottery or {}
    local steps = math.min(Pity[gang] or 0, tonumber(L.PityMaxSteps) or 3)
    return 1 + steps * (tonumber(L.PityBonus) or 0.5)
end
local function EntryWeight(gang, tickets)
    return TicketWeight(tickets) * PityBonus(gang)
end

-- consolation points for a losing gang (capped per draw and per day)
local DayConsolation = {}   -- DayConsolation[gang] = { day = 'YYYY-MM-DD', points = n }
local function ConsolationFor(gang, cost, tickets)
    local P = H.Points or {}
    local rate = tonumber(P.Consolation) or 0
    if rate <= 0 or tickets <= 0 then return 0 end
    local bonus = math.floor(cost * tickets * rate)
    bonus = math.min(bonus, tonumber(P.ConsolationMax) or bonus)
    local today = os.date('%Y-%m-%d')
    local rec = DayConsolation[gang]
    if not rec or rec.day ~= today then rec = { day = today, points = 0 } DayConsolation[gang] = rec end
    local left = (tonumber(P.ConsolationDailyMax) or math.huge) - rec.points
    bonus = math.max(0, math.min(bonus, left))
    rec.points = rec.points + bonus
    return bonus
end

local function DrawRobbery(robname, pool)
    local plan = PlanOf(robname)
    local rob = Config.Rob.Robs[robname]
    local cost = CostOf(robname)
    if not plan or not rob then return end
    local roundName = RoundInfo(0).name

    -- a gang with a claim already, or a robbery that became busy: nobody wins this one
    local eligible = {}
    local blocked = Claims[robname] or rob.someonerobbing or CooldownLeft(robname) > 0
    for _, gang in ipairs(SortedKeys(pool.entries)) do
        if not blocked and not GangClaim[gang] then eligible[#eligible + 1] = gang end
    end

    local winner
    if #eligible > 0 then
        local total = 0
        for _, gang in ipairs(eligible) do total = total + EntryWeight(gang, pool.entries[gang].tickets) end
        local pick = math.random() * total
        winner = eligible[#eligible]
        for _, gang in ipairs(eligible) do
            pick = pick - EntryWeight(gang, pool.entries[gang].tickets)
            if pick <= 0 then winner = gang break end
        end
    end

    for _, gang in ipairs(SortedKeys(pool.entries)) do
        local e = pool.entries[gang]
        if gang ~= winner then
            RefundTickets(gang, plan, cost, e.tickets)
            local bonus = ConsolationFor(gang, cost, e.tickets)
            if bonus > 0 then
                StatsOf(gang).points = (StatsOf(gang).points or 0) + bonus
                SaveStats(gang)
            end
            TellGang(gang, ('Ghore\'e-keshi %s - "%s": gang-e shoma barande nashod. Pilan va point-ha bargashtand%s.'):format(roundName, rob.nameofrob, bonus > 0 and (' + %d point tasalli'):format(bonus) or ''), 'info')
        end
    end

    if not winner then
        ChatAll(('Ghore\'e-keshi %s - "%s": hich gangi bord nakard (kasi nabood ya robbery dar dastres nabood).'):format(roundName, rob.nameofrob))
        return
    end

    -- comeback bookkeeping: losers with tickets gain a step, the winner starts over
    for _, gang in ipairs(SortedKeys(pool.entries)) do
        if gang ~= winner and pool.entries[gang].tickets > 0 then
            Pity[gang] = math.min((Pity[gang] or 0) + 1, tonumber((H.Lottery or {}).PityMaxSteps) or 3)
        end
    end
    Pity[winner] = 0

    local now = os.time()
    local tickets = pool.entries[winner].tickets
    Claims[robname] = {
        gang = winner, label = pool.entries[winner].label, by = nil, at = now,
        expiresAt = now + (H.ClaimMinutes or 7) * 60, status = 'claimed',
        plan = { item = plan.item, count = plan.count * tickets, tier = plan.tier },
        cost = cost * tickets,
    }
    GangClaim[winner] = robname
    local mins = H.ClaimMinutes or 7
    TellGang(winner, ('Bordid! Ghore\'e-keshi %s - robbery "%s" baraye gang-e shoma shod. %d daghighe vaght darid beran va ba party-e kamel shoroo konid.'):format(roundName, rob.nameofrob, mins), 'success')
    SendToGang(winner, 'Heist:ClaimStarted', { rob = robname, name = rob.nameofrob, x = rob.position.x, y = rob.position.y, z = rob.position.z, seconds = mins * 60 })
    ChatAll(('Ghore\'e-keshi %s: gang "%s" robbery "%s" ro bord!'):format(roundName, pool.entries[winner].label, rob.nameofrob))
end

function AddTicket(src, robname)
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if not gang then return false, 'Shoma dar gang nistid' end
    if not IsBoss(src) then return false, 'Faghat boss mitoone pilan ezafe kone' end
    if GetPlayerRoutingBucket(src) ~= 0 then return false, 'Shoma dar worlde asli nistid' end
    local L = H.Lottery
    if not (L and L.Enabled) then return false, 'Ghore\'e-keshi faal nist' end
    local plan = PlanOf(robname)
    if not plan then return false, 'In robbery plan nadare' end

    local round = RoundInfo(0)
    if round.phase ~= 'open' then
        return false, ('Ghore\'e-keshi %s hanooz baz nashode (%d saniye)'):format(round.name, round.secondsLeft)
    end
    local inRound = false
    for _, k in ipairs(round.items) do if k == robname then inRound = true end end
    if not inRound then return false, ('In robbery dar ghore\'e-keshi %s nist'):format(round.name) end

    local rob = Config.Rob.Robs[robname]
    if Claims[robname] or rob.someonerobbing then return false, 'In robbery alan gerefte shode' end
    if CooldownLeft(robname) > 0 then return false, 'In robbery dar cooldown ast' end
    if GangClaim[gang] then return false, 'Gang-e shoma ghablan yek robbery darad' end
    local lock = Lock[gang .. '|' .. robname]
    if lock and lock > os.time() then return false, 'Gang-e shoma tazeh ye robbery-ye in ro ta ghabl pas dade' end

    local cost = CostOf(robname)
    if (StatsOf(gang).points or 0) < cost then
        return false, ('Point-e kafi nadarid (niaz: %d - shoma: %d)'):format(cost, StatsOf(gang).points or 0)
    end
    if ArmoryCount(gang, plan.item) < plan.count then
        return false, ('Plan-e kafi dar armory nist (niaz: %d x %s)'):format(plan.count, plan.item)
    end
    do
        local pc = Pools[robname]
        local have = (pc and pc.round == round.index and pc.entries[gang] and pc.entries[gang].tickets) or 0
        if have >= (tonumber(L.MaxTicketsPerGang) or 5) then
            return false, ('Gang-e shoma be saghf-e %d ticket baraye in robbery reside'):format(L.MaxTicketsPerGang or 5)
        end
    end
    if not ArmoryRemove(gang, plan.item, plan.count) then return false, 'Bardashtan-e plan az armory ba moshkel movajeh shod' end
    StatsOf(gang).points = StatsOf(gang).points - cost
    SaveStats(gang)
    LogHeist(gang, robname, 'ticket:-' .. cost, xPlayer.identifier)

    local pool = Pools[robname]
    if not pool or pool.round ~= round.index then
        pool = { round = round.index, total = 0, entries = {} }
        Pools[robname] = pool
    end
    pool.entries[gang] = pool.entries[gang] or { tickets = 0, label = GangLabelOf(xPlayer) }
    local maxT = tonumber(L.MaxTicketsPerGang) or 5
    if pool.entries[gang].tickets >= maxT then
        return false, ('Gang-e shoma be saghf-e %d ticket baraye in robbery reside'):format(maxT)
    end
    pool.entries[gang].tickets = pool.entries[gang].tickets + 1
    pool.total = pool.total + 1
    TellGang(gang, ('Pilan "%s" be ghore\'e-keshi ezafe shod (ticket-haye gang: %d). -%d point, -%d x %s.'):format(rob.nameofrob, pool.entries[gang].tickets, cost, plan.count, plan.item), 'success')
    return true, 'Pilan be ghore\'e-keshi ezafe shod'
end

-- the round before the running one closes when the running one starts WAITING
CreateThread(function()
    while true do
        Wait(5000)
        local L = H.Lottery
        if L and L.Enabled then
            local r = RoundInfo(0)
            if r.phase == 'waiting' and LastDrawn < r.index - 1 then
                local done = r.index - 1
                LastDrawn = done
                for robname, pool in pairs(Pools) do
                    if pool.round == done then
                        Pools[robname] = nil
                        DrawRobbery(robname, pool)
                    end
                end
            end
        end
    end
end)

-------------------------------------------------------------------
-- Claiming
-------------------------------------------------------------------
local function DoClaim(src, robname)
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if not gang then return false, 'Shoma dar gang nistid' end
    if not IsBoss(src) then return false, 'Faghat boss mitoone robbery dar khast bede' end
    if GetPlayerRoutingBucket(src) ~= 0 then return false, 'Shoma dar worlde asli nistid' end

    local plan = PlanOf(robname)
    if not plan then return false, 'In robbery ba plan nistesh - az khodesh shoroo konid' end
    local rob = Config.Rob.Robs[robname]
    local rt = Config.Rob.RobTypes[rob.type]
    local now = os.time()

    if GangClaim[gang] then
        local mine = Claims[GangClaim[gang]]
        return false, ('Gang-e shoma ghablan "%s" ro dar khast karde - aval oon ra shoroo ya laghv konid'):format(mine and Config.Rob.Robs[GangClaim[gang]].nameofrob or '?')
    end
    local other = Claims[robname]
    if other then return false, ('In robbery ghablan tavasot-e gang-e "%s" gerefte shode'):format(other.label) end
    if rob.someonerobbing then return false, 'In robbery alan dar jaryan ast' end
    local cd = CooldownLeft(robname)
    if cd > 0 then return false, ('In robbery dar cooldown ast (%d daghighe)'):format(math.ceil(cd / 60)) end
    local lock = Lock[gang .. '|' .. robname]
    if lock and lock > now then return false, ('Shoma ta %d daghighe digar nemitoonid dobare in robbery ro bokhahid'):format(math.ceil((lock - now) / 60)) end
    if H.CountersRequirePolice and CopsOnline() < (rt.copsrequired or 0) then
        return false, ('Hadaghal %d police bayad online bashand'):format(rt.copsrequired)
    end
    local L = H.Lottery
    local cost = 0
    if L and L.Enabled then
        return false, 'Dar halat-e ghore\'e-keshi, pilan be ghore\'e-keshi ezafe konid'
    end
    if false then
        local inRound, round = InCurrentRound(robname)
        if round.phase ~= 'open' then
            return false, ('Ghore\'e-keshi %s hanooz baz nashode (%d saniye)'):format(round.name, round.secondsLeft)
        end
        if not inRound then return false, ('In robbery dar ghore\'e-kesh-e %s nist'):format(round.name) end
        cost = CostOf(robname)
        if (StatsOf(gang).points or 0) < cost then
            return false, ('Point-e kafi nadarid (niaz: %d - shoma: %d)'):format(cost, StatsOf(gang).points or 0)
        end
    end
    if ArmoryCount(gang, plan.item) < plan.count then
        return false, ('Plan-e kafi dar armory nist (niaz: %d x %s)'):format(plan.count, plan.item)
    end
    if not ArmoryRemove(gang, plan.item, plan.count) then return false, 'Bardashtan-e plan az armory ba moshkel movajeh shod' end
    if cost > 0 then
        StatsOf(gang).points = StatsOf(gang).points - cost
        SaveStats(gang)
        LogHeist(gang, robname, 'points:-' .. cost, xPlayer.identifier)
    end

    Claims[robname] = {
        gang = gang, label = GangLabelOf(xPlayer), by = src, at = now,
        expiresAt = now + (H.ClaimMinutes or 7) * 60, status = 'claimed', plan = plan, cost = cost,
    }
    GangClaim[gang] = robname
    local mins = H.ClaimMinutes or 7
    TellGang(gang, ('Robbery "%s" baraye gang-e shoma reserve shod! %d x plan az armory%s kam shod. %d daghighe vaght darid beran va ba party-e kamel ba E shoroo konid.'):format(rob.nameofrob, plan.count, cost > 0 and (' va %d point'):format(cost) or '', mins), 'success')
    SendToGang(gang, 'Heist:ClaimStarted', { rob = robname, name = rob.nameofrob, x = rob.position.x, y = rob.position.y, z = rob.position.z, seconds = mins * 60 })
    return true, ('Robbery reserve shod - %d daghighe vaght darid'):format(mins)
end

local function GiveBackPlans(c, fraction)
    local n = math.floor((c.plan.count or 0) * (fraction or 0))
    if n > 0 then ArmoryAdd(c.gang, c.plan.item, n) end
    local pts = math.floor((c.cost or 0) * (fraction or 0))
    if pts > 0 then
        StatsOf(c.gang).points = (StatsOf(c.gang).points or 0) + pts
        SaveStats(c.gang)
    end
    return n, pts
end

local function DoCancelClaim(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if not gang then return false, 'Shoma dar gang nistid' end
    if not IsBoss(src) then return false, 'Faghat boss' end
    local robname = GangClaim[gang]
    local c = robname and Claims[robname]
    if not c then return false, 'Robbery-ye reserve shode-i nadarid' end
    if c.status ~= 'claimed' then return false, 'Robbery shoroo shode - nemishe laghv kard' end
    local back, pts = GiveBackPlans(c, H.RefundOnCancel)
    Lock[gang .. '|' .. robname] = os.time() + (H.ReclaimLockMinutes or 15) * 60
    ReleaseClaim(robname)
    TellGang(gang, ('Robbery "%s" laghv shod (%d plan be armory va %d point bargasht).'):format(Config.Rob.Robs[robname].nameofrob, back, pts or 0), 'info')
    return true, 'Laghv shod'
end

-------------------------------------------------------------------
-- The gate in robberyNeeds
-------------------------------------------------------------------
-- alliance check through Unique_ALLGangs (pcall: the resource may not be running)
function GangsAllied(a, b)
    if not a or not b or a == b then return a == b end
    local ok, res = pcall(function() return exports['Unique_ALLGangs']:AreGangsAllied(a, b) end)
    return ok and res == true
end

function HeistGate(src, robname)
    if not PlanOf(robname) then return true end -- normal robbery (Shop ...): untouched
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    local c = Claims[robname]
    if not gang then return false, 'In robbery faghat baraye gang-ha ast' end
    if not c then
        return false, 'Baraye in robbery bayad boss-e gang az Boss Menu > Robbery darkhast bede'
    end
    if c.gang ~= gang then return false, ('In robbery tavasot-e gang-e "%s" gerefte shode'):format(c.label) end
    if c.status ~= 'claimed' then return false, 'In robbery ghablan shoroo shode' end
    if os.time() >= c.expiresAt then return false, 'Mohlat-e shoroo tamoom shode' end

    if H.RequirePartyFromGang then
        local rt = Config.Rob.RobTypes[Config.Rob.Robs[robname].type]
        local need = rt.teammatesrequired or 0
        if need > 0 then
            local inTeam, team = IsInTeam(src)
            if not inTeam then return false, 'Baraye Starte In Robbery Shoma Bayad Dar Team Bashid! /party' end
            -- Everyone in the party must be from the claiming gang OR one of its ALLIES.
            -- Allied members count together for the required number.
            local okPart = 0
            local stranger = false
            for mateId in pairs(team) do
                local x = ESX.GetPlayerFromId(tonumber(mateId))
                local g = GangOf(x)
                if g and (g == gang or GangsAllied(gang, g)) then okPart = okPart + 1 else stranger = true end
            end
            if stranger then
                return false, 'Hame-ye aza-ye party bayad az gang-e shoma ya gang-haye motahed bashand (gharibe nabashe)'
            end
            if okPart < need then
                return false, ('Hadaghal %d nafar az gang-e shoma (ya motahedin) bayad dar party bashand (alan: %d)'):format(need, okPart)
            end
        end
    end
    return true
end

-- robberyNeeds just let the player through (RobsInProgress was set by the original handler)
AddEventHandler('Morphy_RobSystem:robberyNeeds', function(robname)
    local src = source
    if not Config.Rob.Robs[robname] or RobsInProgress[src] ~= robname then return end
    Started[src] = { rob = robname, at = os.time() }
    local c = Claims[robname]
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if c and gang and c.gang == gang and c.status == 'claimed' then
        c.status = 'started'
        c.startedBy = src
        Active[src] = { rob = robname, gang = gang }
        SendToGang(gang, 'Heist:ClaimEnded', robname)
        TellGang(gang, ('Robbery "%s" shoroo shod! Movafagh bashid.'):format(Config.Rob.Robs[robname].nameofrob), 'success')
    end
end)

-------------------------------------------------------------------
-- Outcomes
-------------------------------------------------------------------
local function AddPending(gang, identifier, robname)
    local now = os.time()
    local row = { id = nil, gang = gang, identifier = identifier, rob = robname, issuedAt = now, expiresAt = now + (H.Token.UseMinutes or 30) * 60 }
    Pending[#Pending + 1] = row
    MySQL.Async.insert('INSERT INTO gang_heist_tokens (gang, identifier, rob, issued_at, expires_at, status) VALUES (@g, @i, @r, @a, @e, \'pending\')',
        { ['@g'] = gang, ['@i'] = identifier, ['@r'] = robname, ['@a'] = row.issuedAt, ['@e'] = row.expiresAt }, function(id) row.id = id end)
    return row
end

local function SetTokenStatus(row, status)
    if row.id then MySQL.Async.execute('UPDATE gang_heist_tokens SET status = @s WHERE id = @id', { ['@s'] = status, ['@id'] = row.id }) end
end

local function RecordLoss(gang, robname, why, player)
    StatsOf(gang).losses = StatsOf(gang).losses + 1
    SaveStats(gang)
    LogHeist(gang, robname, 'loss:' .. why, player)
end

local function RewardPolice(robname)
    local P = H.Police
    if not P or not P.Enabled then return end
    local rob = Config.Rob.Robs[robname]
    local typ = rob.type
    local allowed = false
    for _, t in ipairs(P.Types or {}) do if t == typ then allowed = true end end
    if not allowed then return end

    local max = (P.MaxPaid and P.MaxPaid[typ]) or Config.Rob.RobTypes[typ].copsrequired or 0
    local anchor = (P.Anchor and P.Anchor[typ]) or rob.position
    if max <= 0 or (P.Pay or 0) <= 0 then return end

    local near = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.job and IsPoliceJob(x.job.name) then
            local ped = GetPlayerPed(playerId)
            if ped and ped ~= 0 then
                local c = GetEntityCoords(ped)
                local d = math.sqrt((c.x - anchor.x) ^ 2 + (c.y - anchor.y) ^ 2 + (c.z - anchor.z) ^ 2)
                if d <= (P.Radius or 200.0) then near[#near + 1] = { id = playerId, d = d, x = x } end
            end
        end
    end
    table.sort(near, function(a, b) return a.d < b.d end)
    for i = 1, math.min(max, #near) do
        local x = near[i].x
        if P.Account == 'money' then x.addMoney(P.Pay) else x.addAccountMoney(P.Account or 'bank', P.Pay) end
        Notify(near[i].id, ('Jayeze-ye hozoor dar robbery "%s": $%s'):format(rob.nameofrob, P.Pay), 'success')
    end
end

local function OnSuccess(src, robname)
    local st = Started[src]
    if not st or st.rob ~= robname then return end -- not a robbery that really started here
    -- The original success handler stamps lastRobbed when (and only when) it accepted the
    -- event. A forged client event that server.lua rejected leaves it untouched, so it can't
    -- make us hand out police pay or a token.
    if (Config.Rob.Robs[robname].lastRobbed or 0) < st.at then return end
    Started[src] = nil
    RewardPolice(robname)

    local act = Active[src]
    if act and act.rob == robname then
        Active[src] = nil
        local xPlayer = ESX.GetPlayerFromId(src)
        ReleaseClaim(robname)
        if xPlayer then
            xPlayer.addInventoryItem(H.Token.Item, 1)
            AddPending(act.gang, xPlayer.identifier, robname)
            Notify(src, ('Robbery vin shod! Token ra dar %d daghighe baraye gang estefade konid, vagarna LOSS hesab mishe.'):format(H.Token.UseMinutes or 30), 'success')
            TellGang(act.gang, ('Robbery "%s" ba movafaghiat anjam shod! Token be %s dade shod - ta %d daghighe baraye gang estefade beshe (vagarna loss).'):format(Config.Rob.Robs[robname].nameofrob, xPlayer.name, H.Token.UseMinutes or 30), 'success')
        end
    end
end

local function OnLoss(src, robname, why)
    local st = Started[src]
    if st and st.rob == robname then Started[src] = nil end
    local act = Active[src]
    if not act or act.rob ~= robname then return end
    Active[src] = nil
    ReleaseClaim(robname)
    local xPlayer = ESX.GetPlayerFromId(src)
    RecordLoss(act.gang, robname, why, xPlayer and xPlayer.identifier or nil)
    TellGang(act.gang, ('Robbery "%s" shekast khord (%s) - yek LOSS sabt shod.'):format(Config.Rob.Robs[robname].nameofrob, why), 'error')
end

AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname) OnSuccess(source, robname) end)
AddEventHandler('Morphy_RobSystem:robberyCancel',  function(robname) OnLoss(source, robname, 'laghv') end)
AddEventHandler('Morphy_RobSystem:robberyHackFail', function(robname) OnLoss(source, robname, 'hack') end)
AddEventHandler('playerDropped', function()
    local src = source
    local act = Active[src]
    if act then OnLoss(src, act.rob, 'ghat-e ertebat') end
    Started[src] = nil
end)

-- Robberies that end without any event (Oil Rig FailHeist / admin reset): the robber's
-- RobsInProgress entry just disappears. Count those as losses within a few seconds.
CreateThread(function()
    while true do
        Wait(5000)
        for src, act in pairs(Active) do
            if RobsInProgress[src] ~= act.rob then OnLoss(src, act.rob, 'ba payan ya khata') end
        end
        -- forget "started" markers of robberies that ended silently
        local now = os.time()
        for src, st in pairs(Started) do
            if RobsInProgress[src] ~= st.rob and now - st.at > 10 then Started[src] = nil end
        end
    end
end)

-------------------------------------------------------------------
-- Expiry: unstarted claims, unused tokens
-------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(5000)
        local now = os.time()
        for robname, c in pairs(Claims) do
            if c.status == 'claimed' and now >= c.expiresAt then
                local back, pts = GiveBackPlans(c, H.RefundOnExpire)
                Lock[c.gang .. '|' .. robname] = now + (H.ReclaimLockMinutes or 15) * 60
                ReleaseClaim(robname)
                TellGang(c.gang, ('Mohlat-e shoroo-ye robbery "%s" tamoom shod (%d plan be armory va %d point bargasht).'):format(Config.Rob.Robs[robname].nameofrob, back, pts or 0), 'error')
            end
        end
        for i = #Pending, 1, -1 do
            local row = Pending[i]
            if now >= row.expiresAt then
                table.remove(Pending, i)
                SetTokenStatus(row, 'expired')
                RecordLoss(row.gang, row.rob, 'token-estefade-nashod', row.identifier)
                -- the unused token stops working: take it back if its owner is still holding it
                local x = ESX.GetPlayerFromIdentifier and ESX.GetPlayerFromIdentifier(row.identifier)
                if x then
                    local item = x.getInventoryItem(H.Token.Item)
                    if item and item.count > 0 then x.removeInventoryItem(H.Token.Item, 1) end
                    Notify(x.source, 'Mohlat-e estefade az token tamoom shod - LOSS sabt shod.', 'error')
                end
                TellGang(row.gang, ('Token-e robbery "%s" dar mohlat estefade nashod - LOSS sabt shod.'):format(Config.Rob.Robs[row.rob] and Config.Rob.Robs[row.rob].nameofrob or row.rob), 'error')
            end
        end
    end
end)

-------------------------------------------------------------------
-- Using the token
-------------------------------------------------------------------
ESX.RegisterUsableItem(H.Token.Item, function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if not gang then return Notify(src, 'Shoma dar gang nistid', 'error') end
    local now = os.time()
    local pick, pickIdx
    for i, row in ipairs(Pending) do
        if row.gang == gang and row.expiresAt > now and (not pick or row.issuedAt < pick.issuedAt) then pick, pickIdx = row, i end
    end
    if not pick then return Notify(src, 'In token baraye gang-e shoma nist ya mohlatesh tamoom shode', 'error') end

    xPlayer.removeInventoryItem(H.Token.Item, 1)
    table.remove(Pending, pickIdx)
    SetTokenStatus(pick, 'used')
    local s = StatsOf(gang)
    s.wins = s.wins + 1
    s.tokens = s.tokens + (H.Token.GangTokens or 1)
    local winPts = (H.Points and H.Points.RobberyWin) or 0
    s.points = (s.points or 0) + winPts
    SaveStats(gang)
    LogHeist(gang, pick.rob, 'win', xPlayer.identifier)
    if H.Token.OnCredit then pcall(H.Token.OnCredit, gang, H.Token.GangTokens or 1, xPlayer) end -- hook for your own gang panel
    -- one item, all rewards: the XP of this robbery's card goes to the gang too
    local cardName = H.Token.XPByRobType and H.Token.XPByRobType[(Config.Rob.Robs[pick.rob] or {}).type]
    local xpGranted = 0
    if cardName and H.Token.GiveXP ~= false then
        local okX, got = pcall(function() return exports['Unique_ALLGangs']:AddGangXPFromCard(gang, cardName, 'Robbery token by ' .. xPlayer.name) end)
        if okX and tonumber(got) then xpGranted = tonumber(got) end
    end
    TellGang(gang, ('%s token ra estefade kard: robbery \"%s\" WIN sabt shod (+%d token, +%d point, +%d XP baraye gang).'):format(xPlayer.name, Config.Rob.Robs[pick.rob] and Config.Rob.Robs[pick.rob].nameofrob or pick.rob, H.Token.GangTokens or 1, winPts, xpGranted), 'success')
end)

-------------------------------------------------------------------
-- LEGACY XP CARDS: robberies no longer give them (the rob_token does it
-- all). Cards already in inventories still work: using one adds its XP to
-- the gang, no win. Values: Unique_ALLGangs Config.GangXP.Cards.
-------------------------------------------------------------------
for cardName in pairs(H.Token.LegacyCards or {}) do
    ESX.RegisterUsableItem(cardName, function(source)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local gang = GangOf(xPlayer)
        if not gang then return Notify(src, 'Shoma dar gang nistid - card faghat baraye gang ast', 'error') end
        local item = xPlayer.getInventoryItem(cardName)
        if not item or item.count < 1 then return end
        local ok, granted = pcall(function() return exports['Unique_ALLGangs']:AddGangXPFromCard(gang, cardName, 'XP Card by ' .. xPlayer.name) end)
        if not ok or not granted or granted <= 0 then
            return Notify(src, 'Gang XP dar dastres nist - card masraf nashod', 'error')
        end
        xPlayer.removeInventoryItem(cardName, 1)
        TellGang(gang, ('%s card-e %s ra estefade kard: +%d XP baraye gang.'):format(xPlayer.name, cardName, granted), 'success')
    end)
end

-------------------------------------------------------------------
-- Party: members who die are thrown out of the party
-------------------------------------------------------------------
AddEventHandler('esx:onPlayerDeath', function()
    if not H.KickDeadFromParty then return end
    local src = source
    local ok, removed = pcall(function() return exports[GetCurrentResourceName()]:RemoveFromTeam(src) end)
    if ok and removed then Notify(src, 'Shoma mordid va az party kharej shodid.', 'error') end
end)

-------------------------------------------------------------------
-- Menu data (NUI) + actions
-------------------------------------------------------------------
-- One robbery as the menu shows it (used by both the overview list and the lottery round).
local function RobEntry(name, gang, plans, isBoss, mine, now)
    local rob = Config.Rob.Robs[name]
    local plan = PlanOf(name)
    local rt = Config.Rob.RobTypes[rob.type]
    local entry = {
        key = name, name = rob.nameofrob, type = rob.type,
        tier = plan.tier, tierLabel = Config.Rob.Plans.Labels[plan.tier], planCount = plan.count, have = plans[plan.tier] or 0,
        cops = rt.copsrequired or 0, team = rt.teammatesrequired or 0,
        cost = CostOf(name), status = 'free',
    }
    local rw = rt.reward and (rt.reward.blackmoney or rt.reward.cash)
    if type(rw) == 'table' and rw.min then entry.reward = { min = rw.min, max = rw.max } end

    local c = Claims[name]
    local cd = CooldownLeft(name)
    local lock = Lock[gang .. '|' .. name]
    if rob.someonerobbing or (c and c.status == 'started') then
        entry.status = 'inprogress'
        entry.byLabel = c and c.label or nil
    elseif c then
        entry.status = (c.gang == gang) and 'mine' or 'claimed'
        entry.byLabel = c.label
        entry.secondsLeft = math.max(0, c.expiresAt - now)
    elseif cd > 0 then
        entry.status = 'cooldown'
        entry.secondsLeft = cd
    elseif lock and lock > now then
        entry.status = 'locked'
        entry.secondsLeft = lock - now
    end
    return entry
end

local function BuildMenu(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local gang = GangOf(xPlayer)
    if not gang then return { hasGang = false } end

    local plans, totalPlans = {}, 0
    for tier, item in pairs(Config.Rob.Plans.Items) do
        plans[tier] = ArmoryCount(gang, item)
        totalPlans = totalPlans + plans[tier]
    end

    local s = StatsOf(gang)
    local now = os.time()
    local isBoss = IsBoss(src)
    local pending = {}
    for _, row in ipairs(Pending) do
        if row.gang == gang then
            pending[#pending + 1] = { rob = Config.Rob.Robs[row.rob] and Config.Rob.Robs[row.rob].nameofrob or row.rob, secondsLeft = math.max(0, row.expiresAt - now) }
        end
    end

    local mineName = GangClaim[gang]
    local mine = mineName and Claims[mineName]
    local L = H.Lottery or {}
    local out = {
        hasGang = true, gang = gang, label = GangLabelOf(xPlayer), isBoss = isBoss,
        plans = plans, totalPlans = totalPlans, planLabels = Config.Rob.Plans.Labels, points = s.points or 0,
        stats = { wins = s.wins, losses = s.losses, tokens = s.tokens, points = s.points or 0, pending = pending },
        claimMinutes = H.ClaimMinutes or 7, tokenMinutes = H.Token.UseMinutes or 30,
        copsOnline = CopsOnline(),
        claim = mine and { rob = mineName, name = Config.Rob.Robs[mineName].nameofrob, status = mine.status, secondsLeft = math.max(0, mine.expiresAt - now) } or nil,
        robberies = {},
        lottery = { enabled = L.Enabled and true or false },
    }

    local function canClaim(entry, phaseOpen)
        return isBoss and entry.status == 'free' and not mine and entry.have >= entry.planCount
            and (out.points >= entry.cost) and phaseOpen
    end

    local function canTicket(entry, phaseOpen)
        return isBoss and entry.status == 'free' and not mine and not GangClaim[gang]
            and entry.have >= entry.planCount and (out.points >= entry.cost) and phaseOpen
    end

    -- overview of every plan robbery
    for _, name in ipairs(GetPlanKeys()) do
        local entry = RobEntry(name, gang, plans, isBoss, mine, now)
        -- with the lottery on, requests are made from the lottery tab only
        entry.canClaim = (not L.Enabled) and canClaim(entry, true) or false
        out.robberies[#out.robberies + 1] = entry
    end
    table.sort(out.robberies, function(a, b)
        if a.planCount ~= b.planCount then return a.planCount > b.planCount end
        return a.name < b.name
    end)

    -- the lottery board: the round running now + a preview of the next one
    if L.Enabled then
        local function roundView(offset)
            local r = RoundInfo(offset)
            local view = { name = r.name, phase = (offset == 1) and 'waiting' or r.phase, secondsLeft = r.secondsLeft, items = {} }
            if offset == 1 then view.secondsLeft = r.opensAt - now end
            for _, key in ipairs(r.items) do
                local entry = RobEntry(key, gang, plans, isBoss, mine, now)
                entry.canClaim = (offset == 0) and canTicket(entry, r.phase == 'open') or false
                local pool = Pools[key]
                local mineT = (offset == 0 and pool and pool.round == r.index and pool.entries[gang]) or nil
                entry.myTickets = mineT and mineT.tickets or 0
                entry.myChance = 0
                if mineT and mineT.tickets > 0 then
                    local sum = 0
                    for gk, e in pairs(pool.entries) do sum = sum + EntryWeight(gk, e.tickets) end
                    entry.myChance = sum > 0 and math.floor(100 * EntryWeight(gang, mineT.tickets) / sum + 0.5) or 0
                end
                entry.entrants = (offset == 0 and pool and pool.round == r.index) and (function() local n = 0 for _ in pairs(pool.entries) do n = n + 1 end return n end)() or 0
                view.items[#view.items + 1] = entry
            end
            return view
        end
        out.lottery.current = roundView(0)
        out.lottery.next = roundView(1)
    end
    return out
end

ESX.RegisterServerCallback('Heist:GetData', function(source, cb) cb(BuildMenu(source)) end)
ESX.RegisterServerCallback('Heist:Claim', function(source, cb, robname)
    if type(robname) ~= 'string' then return cb(false, 'namoo`tabar') end
    local ok, msg = DoClaim(source, robname)
    cb(ok, msg)
end)
ESX.RegisterServerCallback('Heist:AddTicket', function(source, cb, robname)
    if type(robname) ~= 'string' then return cb(false, 'namoo`tabar') end
    local ok, msg = AddTicket(source, robname)
    cb(ok, msg)
end)
ESX.RegisterServerCallback('Heist:CancelClaim', function(source, cb)
    local ok, msg = DoCancelClaim(source)
    cb(ok, msg)
end)

-- read-only exports for other resources (e.g. a gang panel)
exports('GetGangHeistStats', function(gang) local s = StatsOf(gang) return { wins = s.wins, losses = s.losses, tokens = s.tokens } end)
exports('AddGangHeistTokens', function(gang, n)
    n = math.floor(tonumber(n) or 0)
    if n == 0 then return false end
    local s = StatsOf(gang)
    s.tokens = math.max(0, s.tokens + n)
    SaveStats(gang)
    return true
end)

-- Gang POINTS (spent on requests in the lottery, earned by playing).
--   exports['Unique_AllRobs']:GetGangHeistPoints(gang)
--   exports['Unique_AllRobs']:AddGangHeistPoints(gang, n [, reason])   (n may be negative)
exports('GetGangHeistPoints', function(gang) return StatsOf(gang).points or 0 end)
exports('AddGangHeistPoints', function(gang, n, reason)
    n = math.floor(tonumber(n) or 0)
    if n == 0 or type(gang) ~= 'string' or gang == '' or gang == 'nogang' then return false end
    local st = StatsOf(gang)
    st.points = math.max(0, (st.points or 0) + n)
    SaveStats(gang)
    LogHeist(gang, '-', ('points:%+d:%s'):format(n, tostring(reason or '')), nil)
    if n > 0 then TellGang(gang, ('+%d point baraye gang (%s)'):format(n, tostring(reason or 'jayeze')), 'success') end
    return true
end)

-- Clears the lottery comeback counters (admin / tests). Memory only anyway.
exports('ResetLotteryPity', function() for k in pairs(Pity) do Pity[k] = nil end for k in pairs(DayConsolation) do DayConsolation[k] = nil end return true end)
