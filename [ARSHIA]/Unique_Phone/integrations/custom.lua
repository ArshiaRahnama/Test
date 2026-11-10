-- ============================================================================================
-- Unique_Phone · YOUR OWN INTEGRATIONS (this file is OPEN: edit it freely, it is never encrypted)
-- ============================================================================================
-- Use this file when your server runs a garage / bank / housing / billing / society / dispatch script that the phone does not
-- support out of the box. Fill in ONLY the categories you need; leave the others as `nil`.
--
-- How it is picked:
--   Config.Integrations.<category> = 'auto'    -> your adapter here wins over the known resources
--   Config.Integrations.<category> = 'custom'  -> only your adapter (or one registered by another resource)
--   Config.Integrations.<category> = 'builtin' -> this file is ignored for that category
-- If one of your functions throws an error, the phone prints ONE warning in the server console and uses
-- its built-in behaviour for that call, so a bug here never breaks the app.
--
-- Arguments you always get:
--   src = the player's server id
--   cid = the character identifier the phone uses (citizenid on QBCore/QBox, identifier on ESX)
-- Everything runs on the SERVER. You can call any export with exports['your_resource']:Function(...).
-- Wrap calls to other resources in pcall if they can be stopped while the phone runs.
--
-- Another resource can also register an adapter at runtime (no edit here needed):
--   exports.Unique_Phone:RegisterIntegration('garage', { list = function(src, cid) ... end })
-- Console command `phoneintegrations` shows which adapter is active for each category.
-- ============================================================================================
local Custom = {}

-- --------------------------------------------------------------------------------------------
-- GARAGE  (Garage app). Required: list. Optional: detail, track, takeOut, putBack.
-- Delivery ("Request Delivery", Config.GarageDelivery): the phone checks with `list` that the vehicle is in a garage,
-- then marks it OUT and creates it next to the player. Without takeOut it writes the framework column (ESX
-- owned_vehicles.stored = 0, QBCore/QBox player_vehicles.state = 0); give takeOut/putBack when your garage keeps
-- its "in the garage" state somewhere else (otherwise the delivery is refused rather than risking a duplicate).
-- --------------------------------------------------------------------------------------------
-- Custom.garage = {
--     -- every vehicle of the player
--     list = function(src, cid)
--         local rows = MySQL.query.await('SELECT plate, model, garage, state, fuel FROM my_vehicles WHERE owner = ?', { cid }) or {}
--         local out = {}
--         for _, r in ipairs(rows) do
--             out[#out + 1] = {
--                 plate  = r.plate,                 -- required
--                 model  = r.model,                 -- spawn name, e.g. 'sultanrs'
--                 label  = nil,                     -- optional display name ('Sultan RS')
--                 garage = r.garage,                -- garage id or name shown in the app
--                 state  = r.state,                 -- 'garage' | 'out' | 'impound' (also 1 / 0 / 2 or true / false)
--                 fuel   = r.fuel,                  -- 0-100 (optional)
--                 engine = nil, body = nil,         -- 0-1000 (optional)
--                 coords = nil,                     -- { x = , y = , z = } of the garage, for the GPS button
--             }
--         end
--         return out
--     end,
--     -- optional: engine/body/mileage for the detail screen (else the values from list are used)
--     detail = function(src, cid, plate) return { engine = 1000, body = 1000, mileage = 1200 } end,
--     -- optional: where the vehicle is when the player cannot see it ({ x, y, z } or nil)
--     track = function(src, cid, plate) return nil end,
--     -- optional (delivery): mark the vehicle as OUT of your garage. Return true ONLY when it was in the garage and is
--     -- now out (do it in one conditional UPDATE, so two requests can never both win). The phone then charges the fee
--     -- and spawns it; if that fails, putBack is called to file it back into the garage.
--     takeOut = function(src, cid, plate)
--         return (MySQL.update.await('UPDATE my_vehicles SET state = 0 WHERE owner = ? AND plate = ? AND state = 1', { cid, plate }) or 0) == 1
--     end,
--     putBack = function(src, cid, plate)
--         return (MySQL.update.await('UPDATE my_vehicles SET state = 1 WHERE owner = ? AND plate = ? AND state = 0', { cid, plate }) or 0) == 1
--     end,
-- }

-- --------------------------------------------------------------------------------------------
-- BANK  (Wallet app). All functions optional; give the ones your bank has.
-- --------------------------------------------------------------------------------------------
-- Custom.bank = {
--     -- balance shown in the Wallet (nil = the framework bank money)
--     balance = function(src, cid) return exports['my_bank']:GetBalance(cid) end,
--     -- account data: iban/account number, savings, frozen, noAccount (true = "open an account at the bank")
--     info = function(src, cid) return { iban = 'MB123456', savings = 0, frozen = false } end,
--     -- statement rows, newest first: amount is SIGNED (negative = money out), created in ms or seconds
--     history = function(src, cid)
--         return { { id = 1, description = 'Salary', amount = 1500, created = os.time() } }
--     end,
--     -- the bank moves the money itself. Return true, or false + 'funds' | 'target' | 'frozen' | 'amount'.
--     -- Return nil to let the phone move the framework bank money (then `record` is called for both sides).
--     transfer = function(src, cid, toCid, amount, note, toNumber)
--         return nil
--     end,
--     -- the phone moved framework money: store the movement in your bank's statement. Return true when stored
--     -- (with `history` too, the phone then does not keep its own copy, so nothing shows twice)
--     record = function(cid, description, amount, src) return false end,
-- }

-- --------------------------------------------------------------------------------------------
-- HOUSING  (Home app). Required: list. Optional: lock, giveKey, removeKey.
-- --------------------------------------------------------------------------------------------
-- Custom.housing = {
--     -- houses the player OWNS or has a KEY to
--     list = function(src, cid)
--         return {
--             {
--                 id = 'house_12',                         -- required, unique, used by lock/giveKey/removeKey
--                 label = '12 Grove Street',
--                 owner = true,                            -- true = the player owns it
--                 ownerCid = nil,                          -- for keyed houses: the owner's cid (name is looked up)
--                 coords = { x = 0.0, y = 0.0, z = 0.0 },  -- door, for the GPS button
--                 garage = nil,                            -- { x, y, z } of the house garage (optional)
--                 locked = true,                           -- nil = the phone remembers what it last set
--                 tier = 1,                                -- 1 apartment, 3 house, 5 mansion (only the icon text)
--                 keyholders = { { cid = 'ABC123' } },     -- only for owned houses (names/numbers are filled in)
--             },
--         }
--     end,
--     -- lock or unlock (locked = true/false). Return true, or false + 'nokey'
--     lock = function(src, cid, houseId, locked) return true end,
--     -- give a key to an ONLINE player (targetSrc) / remove a key (targetCid). Return true or false + reason
--     giveKey = function(src, cid, houseId, targetSrc, targetCid) return false end,
--     removeKey = function(src, cid, houseId, targetCid) return false end,
-- }

-- --------------------------------------------------------------------------------------------
-- BILLING  (Bills app). Required: list. Optional: pay, create, sent, refuse, cancel.
-- The phone's own bills always stay in the app; yours are shown next to them.
-- --------------------------------------------------------------------------------------------
-- Custom.billing = {
--     -- bills the player RECEIVED (pending and history)
--     list = function(src, cid)
--         return { { id = 7, sender_name = 'LSPD', society = 'police', amount = 250, reason = 'Speeding',
--                    status = 'pending', created = os.time() } }   -- status: pending | paid | refused | cancelled
--     end,
--     -- pay bill `billId` (your own id). Return true, or false + 'funds' | 'invalid'
--     pay = function(src, cid, billId) return false, 'invalid' end,
--     -- a player issued a bill in the app (already validated: amount, cap, society rank, cooldown).
--     -- Return true, false + reason, or nil to keep it as a phone bill. opts = { society, senderName, toSrc }
--     create = function(src, cid, toCid, amount, reason, opts) return nil end,
--     -- bills the player SENT: { id, toCid, amount, reason, status, created }
--     sent = function(src, cid) return {} end,
--     refuse = function(src, cid, billId) return false end,
--     cancel = function(src, cid, billId) return false end,
-- }

-- --------------------------------------------------------------------------------------------
-- SOCIETY  (company / job accounts: bills issued on behalf of a company, job apps billing, police fines,
-- Eats restaurant payouts). All three functions required. `job` is the job name ('police', 'mechanic', ...).
-- Return false (or nil) from add/remove when the money did NOT move; never move it twice.
-- --------------------------------------------------------------------------------------------
-- Custom.society = {
--     balance = function(job) return exports['my_bank']:GetSocietyBalance(job) end,
--     add     = function(job, amount, reason) return exports['my_bank']:AddSocietyMoney(job, amount, reason) == true end,
--     remove  = function(job, amount, reason) return exports['my_bank']:RemoveSocietyMoney(job, amount, reason) == true end,
-- }

-- --------------------------------------------------------------------------------------------
-- DISPATCH  (a request in the Services app to a job listed in Config.Integrations.dispatchJobs ALSO becomes
-- an alert in your dispatch / MDT). Required: alert.
--   data = { id, service, label, job, jobs = { 'police', 'sheriff' }, caller, phone, cid, message,
--            coords = { x, y, z }, street?, code }
-- Return true when your dispatch took the alert. With Config.Integrations.dispatchOnly = true the phones are only
-- notified when this returns false (or errors).
-- --------------------------------------------------------------------------------------------
-- Custom.dispatch = {
--     alert = function(src, data)
--         TriggerEvent('my_dispatch:server:newCall', {
--             title = data.label, message = data.message, caller = data.caller, phone = data.phone,
--             coords = data.coords, jobs = data.jobs, code = data.code,
--         })
--         return true
--     end,
-- }

-- --------------------------------------------------------------------------------------------
-- NUMBER  (1.1.8: your server already has phone numbers for its characters - another phone script, a SIM database,
-- a column of your own). Required: assign. Called ONCE, when a character sets the phone up for the first time.
-- Return the number as text in your Config.NumberFormat (e.g. '555-0123'), or nil to let the phone choose (it then takes
-- the framework's charinfo phone, else a random number). A number already used by another phone account is refused and the
-- phone falls back to its own choice (one warning in the console). To change a number LATER use
-- exports['Unique_Phone']:SetNumber(citizenid, '555-0123', 'my_system'), and listen to the server events
-- 'apex_phone:accountCreated' (cid, number, src) and 'apex_phone:numberChanged' (cid, old, new, by) to keep your side in sync.
-- --------------------------------------------------------------------------------------------
-- Custom.number = {
--     assign = function(cid, src)
--         return MySQL.scalar.await('SELECT phone FROM my_phone_numbers WHERE owner = ? LIMIT 1', { cid })
--     end,
-- }

-- ============================================================================================
-- UNIQUE RP (essentialmode)  ·  ACTIVE ADAPTERS  ·  bank + number
-- ============================================================================================
-- Mirrors the logic of the server's own bank (new_banking) and of the two phones it replaces
-- (Unique_Phone, lb-phone):
--   * balance / cash  = xPlayer.bank / xPlayer.money  (users.bank / users.money)
--   * IBAN            = users.iban  (new_banking: 'IR' + 19 digits; old Unique_Phone: 7 digits; both are kept as they are)
--   * statement       = new_banking_transactions  (deposit | withdraw | transfer_in | transfer_out), the SAME table the
--                       ATM / new_banking panel writes, so ATM operations and phone transfers show up in both places
--   * phone number    = users.phone (old Unique_Phone) -> else phone_phones.phone_number (old lb-phone) -> else the phone picks one
-- ============================================================================================
local function dbOne(sql, params)
    local ok, r = pcall(function() return MySQL.single.await(sql, params) end)
    return ok and r or nil
end

local function dbScalar(sql, params)
    local ok, r = pcall(function() return MySQL.scalar.await(sql, params) end)
    return ok and r or nil
end

local function dbRows(sql, params)
    local ok, r = pcall(function() return MySQL.query.await(sql, params) end)
    return (ok and type(r) == 'table') and r or {}
end

-- same schema new_banking creates (CREATE IF NOT EXISTS: harmless when it already exists)
CreateThread(function()
    pcall(function()
        MySQL.query.await([[CREATE TABLE IF NOT EXISTS new_banking_transactions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(64) NOT NULL,
            type VARCHAR(20) NOT NULL,
            amount INT NOT NULL,
            counterparty VARCHAR(64) NULL,
            counterparty_id INT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_identifier (identifier)
        )]])
    end)
end)

-- new_banking style IBAN ('IR' + 19 digits), unique in users.iban
local function newIban()
    for _ = 1, 25 do
        local d = { tostring(math.random(1, 9)) }
        for _ = 1, 18 do d[#d + 1] = tostring(math.random(0, 9)) end
        local iban = 'IR' .. table.concat(d)
        if not dbScalar('SELECT 1 FROM users WHERE iban = ? LIMIT 1', { iban }) then return iban end
    end
    return nil
end

-- IBAN of a character; creates one (like new_banking's `bank:balance`) when it has none or has '0'.
-- Returns nil when the character does not exist.
local function ibanOf(cid)
    local row = dbOne('SELECT iban FROM users WHERE identifier = ? LIMIT 1', { cid })
    if not row then return nil end
    local iban = row.iban
    if iban == nil or iban == '' or iban == '0' then
        local fresh = newIban()
        if fresh then
            pcall(function()
                MySQL.update.await("UPDATE users SET iban = ? WHERE identifier = ? AND (iban IS NULL OR iban = '' OR iban = '0')", { fresh, cid })
            end)
            iban = dbScalar('SELECT iban FROM users WHERE identifier = ? LIMIT 1', { cid }) or fresh   -- another request may have won
        end
    end
    return iban
end

local HISTORY_SIGN = { deposit = 1, transfer_in = 1, withdraw = -1, transfer_out = -1 }

-- The phone calls `record` once per side of a transfer (sender: negative amount, receiver: positive). Other scripts
-- (Unique_AdminPanel collusion detection) need BOTH sides at once, so the two calls are paired here (same amount,
-- opposite sign, different characters, within 3 s) and announced with ONE local server event:
--     AddEventHandler('apex_phone:bankTransfer', function(fromIdentifier, toIdentifier, amount) ... end)
local PAIR_WINDOW_MS = 3000
local pendingOut, pendingIn = {}, {}

local function prune(list, now)
    for i = #list, 1, -1 do
        if now - list[i].t > PAIR_WINDOW_MS then table.remove(list, i) end
    end
end

local function pairTransfer(cid, amount)
    local now = GetGameTimer()
    local outgoing = amount < 0
    local mine, other = outgoing and pendingOut or pendingIn, outgoing and pendingIn or pendingOut
    prune(mine, now); prune(other, now)
    for i = 1, #other do
        local o = other[i]
        if o.cid ~= cid and o.amount == math.abs(amount) then
            table.remove(other, i)
            local from, to = outgoing and cid or o.cid, outgoing and o.cid or cid
            TriggerEvent('apex_phone:bankTransfer', from, to, math.abs(amount))
            return
        end
    end
    mine[#mine + 1] = { cid = cid, amount = math.abs(amount), t = now }
end

Custom.bank = {
    -- balance shown in the Wallet: the live bank money of the character (online), else straight from the database
    balance = function(src, cid)
        local p = (cid and FW.GetPlayerByCid(cid)) or FW.GetPlayer(src)
        if p then return p.GetMoney('bank') end
        local v = dbScalar('SELECT bank FROM users WHERE identifier = ? LIMIT 1', { cid })
        return tonumber(v) or 0
    end,

    info = function(src, cid)
        local iban = ibanOf(cid)
        if not iban then return { noAccount = true } end
        return { iban = iban, savings = 0, frozen = false }
    end,

    -- statement rows, newest first (signed amount, created in seconds)
    history = function(src, cid)
        local rows = dbRows('SELECT id, type, amount, counterparty, UNIX_TIMESTAMP(created_at) AS created FROM new_banking_transactions WHERE identifier = ? ORDER BY id DESC LIMIT 40', { cid })
        local out = {}
        for _, r in ipairs(rows) do
            local sign = HISTORY_SIGN[r.type] or 0
            local who = (r.counterparty and r.counterparty ~= '') and (' ' .. r.counterparty) or ''
            local label = ({ deposit = 'Deposit', withdraw = 'Withdrawal', transfer_in = 'Transfer from', transfer_out = 'Transfer to' })[r.type] or tostring(r.type)
            if r.type == 'deposit' or r.type == 'withdraw' then who = '' end
            out[#out + 1] = {
                id = r.id, description = label .. who,
                amount = sign * (tonumber(r.amount) or 0), created = tonumber(r.created) or os.time(),
            }
        end
        return out
    end,

    -- no `transfer` on purpose: the phone moves the framework bank money itself (online: xPlayer.addBank/removeBank,
    -- offline: users.bank, see FW.AddMoneyOffline) and then calls `record` for both sides.

    -- a phone transfer happened: write it into new_banking's statement table
    record = function(cid, description, amount, src)
        amount = math.floor(tonumber(amount) or 0)
        if not cid or amount == 0 then return false end
        local who = tostring(description or '')
        who = (who:gsub('^[Tt]ransfer%S*%s+%S+%s+', ''))   -- "Transfer to Ana" -> "Ana" (the panel adds its own "to / from")
        who = who:sub(1, 64)
        local kind = amount > 0 and 'transfer_in' or 'transfer_out'
        local ok = pcall(function()
            MySQL.insert.await('INSERT INTO new_banking_transactions (identifier, type, amount, counterparty, counterparty_id) VALUES (?, ?, ?, ?, NULL)',
                { cid, kind, math.abs(amount), who })
        end)
        if ok then pcall(pairTransfer, cid, amount) end
        -- same admin log sink new_banking uses (resource `logs` -> Unique_LogPanel), only for money leaving a player
        if ok and amount < 0 and tonumber(src) and GetResourceState('logs') == 'started' then
            pcall(function()
                exports['logs']:SendToSite('bank', 'Phone Transfer',
                    ('**Player:** %s [%s]\n**To:** %s\n**Amount:** $%s'):format(GetPlayerName(src) or '?', src, who, math.abs(amount)), src)
            end)
        end
        return ok
    end,
}

-- Phone numbers (Unique RP): ALWAYS 11 digits starting with 0911 / 0912 (Config.UniqueNumberPrefixes).
-- 1) the character already has such a number (users.phone / users.phone_number)  -> keep it
-- 2) otherwise a NEW unique one is generated (the old Unique_Phone / lb-phone number does not match the format)
local function prefixes()
    local p = Config.UniqueNumberPrefixes
    if type(p) == 'table' and #p > 0 then return p end
    return { '0911', '0912' }
end

local function validNumber(n)
    n = tostring(n or '')
    if #n ~= 11 then return false end
    for _, p in ipairs(prefixes()) do if n:sub(1, #p) == p then return true end end
    return false
end

local function numberTaken(n)
    if dbScalar('SELECT 1 FROM apex_phone_accounts WHERE phone = ? LIMIT 1', { n }) then return true end
    if dbScalar('SELECT 1 FROM apex_phone_lines WHERE number = ? LIMIT 1', { n }) then return true end
    if dbScalar('SELECT 1 FROM apex_phone_sims WHERE number = ? LIMIT 1', { n }) then return true end
    if dbScalar('SELECT 1 FROM users WHERE phone = ? OR phone_number = ? LIMIT 1', { n, n }) then return true end
    return false
end

local function newNumber()
    local pre = prefixes()
    for _ = 1, 80 do
        local n = pre[math.random(#pre)] .. string.format('%07d', math.random(0, 9999999))
        if not numberTaken(n) then return n end
    end
    return nil   -- the phone falls back to its own generator (also 0911 / 0912)
end

Custom.number = {
    assign = function(cid, src)
        local row = dbOne('SELECT phone, phone_number FROM users WHERE identifier = ? LIMIT 1', { cid })
        if row then
            if validNumber(row.phone) then return row.phone end
            if validNumber(row.phone_number) then return row.phone_number end
        end
        return newNumber()
    end,
}

-- ============================================================================================
-- SERVICES APP = the server's organizations
-- ============================================================================================
-- Source: the `jobs` table (jobs.hasapp = 1) + the server's own department grouping (esx_uniquejobs shared/departments.lua):
--     doj  = cid, cia, marshal, fbi, judge, doa          -> ONE tile "DOJ"    (the request goes to ALL of them)
--     le   = police, sheriff, mt                         -> ONE tile "Police" (the request goes to ALL of them)
--     organ services (ambulance, mechanic, taxi, weazel) -> one tile each
-- Only players ON DUTY receive a request (the off-duty jobs are called offpolice, offfbi ...). Whitelisted jobs without hasapp
-- (burgershot, cafe, ...) are listed under "Businesses".
-- Add an organization:   UPDATE jobs SET hasapp = 1 WHERE name = 'yourjob';   (picked up within 10 minutes, or restart the phone)
local GROUPED = {
    le  = { label = 'Police', icon = 'lock',      color = '#5E5CE6' },
    doj = { label = 'DOJ',    icon = 'briefcase', color = '#0A84FF' },
}
local FALLBACK_DEPTS = {
    doj = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' },
    le  = { 'police', 'sheriff', 'mt' },
}
local SERVICE_STYLE = {
    ambulance = { icon = 'heart', color = '#FF453A', label = 'EMS' },
    mechanic  = { icon = 'gear',  color = '#FF9F0A' },
    taxi      = { icon = 'car',   color = '#FFD60A' },
    weazel    = { icon = 'pin',   color = '#BF5AF2' },
}
local SERVICE_ORDER = { 'le', 'doj', 'ambulance', 'mechanic', 'taxi', 'weazel' }
local SERVICE_HIDE  = { staff = true, nojob = true, unemployed = true, government = true }

-- department of a job: asks esx_uniquejobs (the real definition), falls back to the list above
local function departmentOf(job)
    if GetResourceState('esx_uniquejobs') == 'started' then
        local ok, d = pcall(function() return exports['esx_uniquejobs']:GetDepartmentForJob(job) end)
        if ok and type(d) == 'table' and d.id and type(d.jobs) == 'table' and #d.jobs > 0 then return d.id, d.jobs end
    end
    for id, jobs in pairs(FALLBACK_DEPTS) do
        for _, j in ipairs(jobs) do if j == job then return id, jobs end end
    end
    return nil
end

local function truthy(v) return v == true or v == 1 or v == '1' or tonumber(v) == 1 end   -- oxmysql may return TINYINT(1) as a boolean

local function refreshServices()
    local rows = dbRows("SELECT name, label, hasapp, whitelisted FROM jobs WHERE name NOT LIKE 'off%' AND (hasapp = 1 OR whitelisted = 1)", {})
    if #rows == 0 then return false end

    local services, business, groupAdded = {}, {}, {}
    for _, r in ipairs(rows) do
        local name = tostring(r.name or '')
        if name ~= '' and not SERVICE_HIDE[name] then
            if truthy(r.hasapp) then
                local deptId, deptJobs = departmentOf(name)
                local g = deptId and GROUPED[deptId]
                if g then
                    if not groupAdded[deptId] then
                        groupAdded[deptId] = true
                        local jobs = {}
                        for _, j in ipairs(deptJobs) do if not SERVICE_HIDE[j] then jobs[#jobs + 1] = j end end
                        services[#services + 1] = { id = deptId, label = g.label, job = jobs[1], jobs = jobs, icon = g.icon, color = g.color }
                    end
                else
                    local st = SERVICE_STYLE[name] or {}
                    local label = st.label or ((r.label and r.label ~= '') and r.label or name)
                    services[#services + 1] = { id = name, label = label, job = name, icon = st.icon or 'briefcase', color = st.color or '#8E8E93' }
                end
            else
                local label = (r.label and r.label ~= '') and r.label or name
                business[#business + 1] = { id = name, label = label, job = name, icon = 'bag', color = '#FF375F', business = true }
            end
        end
    end

    local rank = {}
    for i, n in ipairs(SERVICE_ORDER) do rank[n] = i end
    table.sort(services, function(a, b)
        local ra, rb = rank[a.id] or 1000, rank[b.id] or 1000
        if ra ~= rb then return ra < rb end
        return a.id < b.id
    end)
    table.sort(business, function(a, b) return a.id < b.id end)

    if #services == 0 and #business == 0 then return false end
    local list = {}
    for _, v in ipairs(services) do list[#list + 1] = v end
    for _, v in ipairs(business) do list[#list + 1] = v end
    Config.Services = list      -- server/services.lua reads Config.Services on every request
    return true
end

CreateThread(function()
    Wait(4000)                                   -- oxmysql / the framework are up
    pcall(refreshServices)
    while true do
        Wait(10 * 60 * 1000)
        pcall(refreshServices)
    end
end)

-- ============================================================================================
-- MARKETPLACE = the server's markets
-- ============================================================================================
-- Everybody can still post their own listing in the app (that part is untouched). On top of that the app MIRRORS the server's markets
-- (read-only, refreshed every 5 minutes; they are bought in person, the phone refuses to "buy" them):
--   * auctionhouse2  - the Auction House: gun shops (job = 'gunshop_<id>'), listed by the gang that leases the shop
--   * market         - the general player market
--   * uwumarket      - the business (cafe) market
-- A mirrored listing has owner = 'system:...', so no player can edit or delete it.
local MARKET_SOURCES_ON = true

local function weaponTitle(name)
    local n = tostring(name or '')
    if n:sub(1, 7):upper() == 'WEAPON_' then
        n = n:sub(8):lower():gsub('_', ' ')
        n = n:gsub('(%a)([%w]*)', function(a, b) return a:upper() .. b end)
        return n
    end
    return nil
end

local function syncMarketplace()
    -- item labels (items.label); weapons are not items, they get a readable name
    local labels = {}
    for _, r in ipairs(dbRows('SELECT name, label FROM items', {})) do labels[r.name] = r.label end
    local function titleOf(item) return labels[item] or weaponTitle(item) or tostring(item) end

    local jobLabel = {}
    for _, r in ipairs(dbRows('SELECT name, label FROM jobs', {})) do jobLabel[r.name] = r.label end

    local gunOwner = {}
    for _, r in ipairs(dbRows('SELECT id, owner_label FROM gunshop_shops', {})) do gunOwner[tostring(r.id)] = r.owner_label end

    local want, n = {}, 0
    local function add(owner, seller, title, desc, price, qty)
        price = math.floor(tonumber(price) or 0)
        if price <= 0 or #owner > 64 then return end
        n = n + 1
        want[owner] = { seller = tostring(seller or ''):sub(1, 64), title = tostring(title):sub(1, 80),
            desc = desc .. ((tonumber(qty) or 0) > 1 and (' · x' .. math.floor(tonumber(qty))) or ''), price = price }
    end

    -- Auction House (gun shops and every other shop key)
    for _, r in ipairs(dbRows('SELECT job, item, SUM(amount) AS amount, MIN(price) AS price FROM auctionhouse2 WHERE amount > 0 GROUP BY job, item', {})) do
        local job = tostring(r.job or '')
        local gid = job:match('^gunshop_(%d+)$')
        local shop = gid and ('Gun Shop ' .. gid) or (jobLabel[job] or job)
        local lessee = gid and gunOwner[gid]
        local seller = (lessee and lessee ~= '') and (shop .. ' · ' .. lessee) or shop
        add('system:ah:' .. job .. ':' .. tostring(r.item), seller, titleOf(r.item),
            'On sale at ' .. seller .. ' (Auction House). Buy it in person at the shop.', r.price, r.amount)
    end
    -- general market + business market: rows are (name, amount, price, owner = seller name)
    for _, src in ipairs({ { 'market', 'mk', 'Market' }, { 'uwumarket', 'uwu', 'Business Market' } }) do
        for _, r in ipairs(dbRows('SELECT id, name, amount, price, owner FROM `' .. src[1] .. '` WHERE amount > 0', {})) do
            local seller = (r.owner and r.owner ~= '') and tostring(r.owner):gsub('_', ' ') or src[3]
            add('system:' .. src[2] .. ':' .. tostring(r.id), seller, titleOf(r.name),
                'On sale in the ' .. src[3] .. '. Buy it in person.', r.price, r.amount)
        end
    end

    -- diff against what is already mirrored
    local have = {}
    for _, r in ipairs(dbRows("SELECT id, owner FROM apex_phone_market WHERE owner LIKE 'system:%'", {})) do have[r.owner] = r.id end
    local now = os.time()
    for owner, w in pairs(want) do
        if have[owner] then
            pcall(function()
                MySQL.update.await("UPDATE apex_phone_market SET seller_name = ?, title = ?, description = ?, price = ?, sold = 0, kind = 'shop' WHERE id = ?",
                    { w.seller, w.title, w.desc, w.price, have[owner] })
            end)
        else
            pcall(function()
                MySQL.insert.await("INSERT INTO apex_phone_market (owner, seller_name, title, description, price, category, sold, created, kind) VALUES (?, ?, ?, ?, ?, 'Outros', 0, ?, 'shop')",
                    { owner, w.seller, w.title, w.desc, w.price, now })
            end)
        end
    end
    for owner, id in pairs(have) do
        if not want[owner] then
            pcall(function() MySQL.update.await('DELETE FROM apex_phone_market WHERE id = ?', { id }) end)
        end
    end
    return n
end

if MARKET_SOURCES_ON then
    CreateThread(function()
        Wait(8000)
        pcall(syncMarketplace)
        while true do
            Wait(5 * 60 * 1000)
            pcall(syncMarketplace)
        end
    end)
end

-- ============================================================================================
-- RADIO: pma-voice shows the CHARACTER name (not the Steam / FiveM name) for everybody on a frequency
-- ============================================================================================
local function characterName(src)
    local p = FW.GetPlayer(src)
    if p then
        local full = ((p.firstname or '') .. ' ' .. (p.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
        if full ~= '' then return full end
    end
    return GetPlayerName(src) or tostring(src)
end

CreateThread(function()
    for _ = 1, 60 do                                   -- wait for pma-voice (up to ~2 minutes)
        if GetResourceState('pma-voice') == 'started' then
            local ok = pcall(function()
                exports['pma-voice']:overrideRadioNameGetter(GetCurrentResourceName(), characterName)
            end)
            if ok then return end
        end
        Wait(2000)
    end
end)

CustomIntegrations = Custom
