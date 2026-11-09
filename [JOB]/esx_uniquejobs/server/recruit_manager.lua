if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- =====================================================================
-- Recruit + division commands (/invite /edivision /removedivision) and the same actions from
-- the organisation F6 menu.  Who may use them is configured per organisation by Government
-- (F6 -> Estekhdam & Division): per RANK and per DIVISION, plus a minimum LEVEL to be hired.
-- =====================================================================

local Perm, Level, Pending, NextTok = {}, {}, {}, 0

local HOLDING = { 'meridian', 'uwucafe', 'obsidian', 'voltage', 'ember', 'anchor', 'crimson', 'flourish', 'goldcrust',
                  'static', 'nightjar', 'firebrick', 'slice', 'frostbite', 'sundae', 'koi', 'wasabi', 'carwash' }

local function N(src, text) if src then TriggerClientEvent('esx:showNotification', src, text) end end

-- "official" organisations: Law, DOJ, Organ Services and the Holding businesses.
-- A member of one of them can NOT be hired into another job until he is fired.
-- Everything else (job-center jobs) is not an official organisation: a request may replace it.
local function isOfficial(job)
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do if j == job then return true end end end
    end
    for _, j in ipairs(HOLDING) do if j == job then return true end end
    return false
end

local function isOrg(job)
    if isOfficial(job) then return true end
    return false
end

local function topGrade(job)
    local top = 0
    local jd = ESX.Jobs and ESX.Jobs[job]
    if jd and jd.grades then for g in pairs(jd.grades) do top = math.max(top, tonumber(g) or 0) end end
    return top
end

local function orgLabel(job)
    local jd = ESX.Jobs and ESX.Jobs[job]
    return (jd and jd.label) or job
end

local function getLevel(identifier)
    local r = MySQL.Sync.fetchScalar('SELECT `rank` FROM users WHERE identifier = @i', { ['@i'] = identifier })
    return tonumber(r) or 0
end

-- ----------------------------------------------------------------------- storage
MySQL.ready(function()
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `uj_org_perm` (
        `id` INT NOT NULL AUTO_INCREMENT, `job` VARCHAR(40) NOT NULL, `kind` VARCHAR(16) NOT NULL,
        `typ` VARCHAR(16) NOT NULL, `val` VARCHAR(60) NOT NULL, PRIMARY KEY (`id`))]], {}, function()
        MySQL.Async.fetchAll('SELECT job, kind, typ, val FROM uj_org_perm', {}, function(rows)
            for _, r in ipairs(rows or {}) do
                Perm[r.job] = Perm[r.job] or {}
                Perm[r.job][r.kind] = Perm[r.job][r.kind] or { grades = {}, divisions = {} }
                if r.typ == 'grade' then Perm[r.job][r.kind].grades[tonumber(r.val)] = true
                else Perm[r.job][r.kind].divisions[r.val] = true end
            end
        end)
    end)
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `uj_org_level` (
        `job` VARCHAR(40) NOT NULL, `level` INT NOT NULL DEFAULT 0, PRIMARY KEY (`job`))]], {}, function()
        MySQL.Async.fetchAll('SELECT job, level FROM uj_org_level', {}, function(rows)
            for _, r in ipairs(rows or {}) do Level[r.job] = tonumber(r.level) or 0 end
        end)
    end)
end)

-- ------------------------------------------------------------------ who may do what
local function memberDivisions(identifier, org)
    local list = {}
    local r = MySQL.Sync.fetchScalar('SELECT divisions FROM users WHERE identifier = @i', { ['@i'] = identifier })
    if r and r ~= '' then
        local ok, d = pcall(json.decode, r)
        if ok and type(d) == 'table' then
            for _, v in ipairs(d) do if v.job == org then list[v.name] = true end end
        end
    end
    return list
end

-- boss (top rank) of his organisation, OR his rank / one of his divisions has the permission
local function hasPerm(x, org, kind)
    if not x or not x.job or x.job.name ~= org then return false end
    local g = tonumber(x.job.grade) or 0
    if g >= topGrade(org) then return true end
    local p = Perm[org] and Perm[org][kind]
    if not p then return false end
    if p.grades[g] then return true end
    if next(p.divisions) then
        for name in pairs(memberDivisions(x.identifier, org)) do if p.divisions[name] then return true end end
    end
    return false
end

local function isGovAdminSrc(src)
    local x = ESX.GetPlayerFromId(src)
    return x and x.job and x.job.name == 'government' and (tonumber(x.job.grade) or 0) >= 2
end

-- the organisation the caller acts for (Government names it, everybody else = his own job)
local function actingOrg(x, arg)
    if x.job.name == 'government' then
        if type(arg) == 'string' and isOrg(arg) then return arg, true end
        return nil, true
    end
    return x.job.name, false
end

-- ------------------------------------------------------------------- join rules
local function checkJoin(z, org, byGov)
    local tj = z.job and z.job.name or 'nojob'
    if tj == org then
        return false, 'In fard hamin alan ozv-e in ergan ast.', 'Shoma alan ozv-e hamin ergan hastid.'
    end
    if tj ~= 'nojob' and tj ~= 'unemployed' and isOfficial(tj) then
        return false,
            ('In shakhs ozv-e ergan ~y~%s~s~ ast va emkan-e set job dar ~r~%s~s~ vojud nadarad.'):format(orgLabel(tj), orgLabel(org)),
            ('Shoma emkan-e estekhdam dar ~y~%s~s~ nadarid, be dalil-e ozv budan dar ~r~%s~s~. Dar surat-e fire shodan az an ergan mitavanid vared shavid.'):format(orgLabel(org), orgLabel(tj))
    end
    local need = Level[org] or 0
    if need > 0 and not byGov then
        local lv = getLevel(z.identifier)
        if lv < need then
            return false,
                ('Hadaghal level baraye vorud be in ergan ~y~%d~s~ ast; level in fard (~r~%d~s~) paine-tar ast. Faghat Government az bos action-e ergan mitavanad estekhdam konad.'):format(need, lv),
                ('Hadaghal level baraye vorud be ~y~%s~s~ level ~y~%d~s~ ast; level shoma (~r~%d~s~) paine-tar ast.'):format(orgLabel(org), need, lv)
        end
    end
    return true
end

-- used by esx_society (boss action "hire"): the same rules for the old menu
exports('CanHire', function(inviterSrc, targetSrc, org)
    local x, z = ESX.GetPlayerFromId(inviterSrc), ESX.GetPlayerFromId(targetSrc)
    if not x or not z then return true end
    local ok, mi, mt = checkJoin(z, org, x.job.name == 'government')
    return ok, mi, mt
end)

-- ---------------------------------------------------------------------- /invite
local function startInvite(src, targetId, orgArg)
    local x = ESX.GetPlayerFromId(src)
    targetId = tonumber(targetId)
    if not x then return end
    local org, byGov = actingOrg(x, orgArg)
    if not org then return N(src, byGov and '~r~Government: /invite [id] [esm-e job]' or '~r~Dastresi nadarid.') end
    if not byGov and not hasPerm(x, org, 'invite') then return N(src, '~r~Dastresi baraye estekhdam nadarid.') end
    local z = targetId and ESX.GetPlayerFromId(targetId)
    if not z then return N(src, '~r~ID vared shode eshtebah ast.') end
    if targetId == src then return N(src, '~r~Nemitavanid khodetan ra estekhdam konid.') end
    local a, b = GetEntityCoords(GetPlayerPed(src)), GetEntityCoords(GetPlayerPed(targetId))
    if #(a - b) > 4.0 then return N(src, '~r~Bayad daghigh nazdik-e an fard bashid.') end
    local ok, mi, mt = checkJoin(z, org, byGov)
    if not ok then N(src, mi) N(targetId, mt) return end
    NextTok = NextTok + 1
    Pending[NextTok] = { inviter = src, target = targetId, org = org, byGov = byGov, expires = os.time() + 30 }
    TriggerClientEvent('ujrec:ask', targetId, NextTok, orgLabel(org), x.name)
    N(src, ('Darkhast-e estekhdam baraye ~y~%s~s~ ersal shod.'):format(z.name))
end

RegisterNetEvent('ujrec:answer')
AddEventHandler('ujrec:answer', function(tok, yes)
    local src = source
    local p = Pending[tok]
    if not p or p.target ~= src or os.time() > p.expires then return end
    Pending[tok] = nil
    local z, x = ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(p.inviter)
    if not z then return end
    if not yes then
        if x then N(p.inviter, ('~r~%s~s~ darkhast-e estekhdam ra rad kard.'):format(z.name)) end
        return
    end
    local ok, mi, mt = checkJoin(z, p.org, p.byGov)   -- the rules are checked again at the moment of accepting
    if not ok then N(src, mt) if x then N(p.inviter, mi) end return end
    z.setJob(p.org, 0)
    N(src, ('Shoma be ~g~%s~s~ estekhdam shodid.'):format(orgLabel(p.org)))
    if x then N(p.inviter, ('~g~%s~s~ be ergan ezafe shod.'):format(z.name)) end
    print(('[UJ][RECRUIT] %s invited %s into %s'):format(x and x.identifier or '?', z.identifier, p.org))
end)

RegisterCommand('invite', function(src, args) if src > 0 then startInvite(src, args[1], args[2]) end end, false)
RegisterNetEvent('ujrec:invite')
AddEventHandler('ujrec:invite', function(targetId, org) startInvite(source, targetId, org) end)

-- ------------------------------------------------------------ /edivision /removedivision
local function divisionAction(src, targetId, divName, mode, orgArg)
    local x = ESX.GetPlayerFromId(src)
    targetId = tonumber(targetId)
    if not x then return end
    local org, byGov = actingOrg(x, orgArg)
    if not org then return N(src, '~r~Government: /edivision [id] [esm-e division] [esm-e job]') end
    if not byGov and not hasPerm(x, org, 'division') then return N(src, '~r~Dastresi baraye division nadarid.') end
    local z = targetId and ESX.GetPlayerFromId(targetId)
    if not z then return N(src, '~r~ID vared shode eshtebah ast.') end
    if not z.job or z.job.name ~= org then return N(src, '~r~In fard ozv-e in ergan nist.') end
    if type(divName) ~= 'string' or divName == '' then return N(src, '~r~Esm-e division ra vared konid.') end
    local div = MySQL.Sync.fetchAll('SELECT name, label FROM divisions WHERE owner = @o AND (name = @n OR label = @n) LIMIT 1',
        { ['@o'] = org, ['@n'] = divName })[1]
    if not div then return N(src, '~r~Chenin division-i dar in ergan nist.') end
    -- a member of a division may hand out only the divisions he is allowed to (rank/division permission above)
    local raw = MySQL.Sync.fetchScalar('SELECT divisions FROM users WHERE identifier = @i', { ['@i'] = z.identifier })
    local list = {}
    if raw and raw ~= '' then local ok, d = pcall(json.decode, raw) if ok and type(d) == 'table' then list = d end end
    local has, idx = false, nil
    for i, v in ipairs(list) do if v.job == org and v.name == div.name then has, idx = true, i end end
    if mode == 'set' then
        if has then return N(src, '~y~In fard ghablan hamin division ra darad.') end
        list[#list + 1] = { job = org, name = div.name, label = div.label, status = false }
        N(targetId, ('Shoma division ( ~g~%s~s~ ) ra daryaft kardid.'):format(div.label))
        N(src, ('Division ~g~%s~s~ be ~y~%s~s~ dade shod.'):format(div.label, z.name))
    else
        if not has then return N(src, '~y~In fard in division ra nadarad.') end
        table.remove(list, idx)
        N(targetId, ('Division shoma ( ~r~%s~s~ ) hazf shod.'):format(div.label))
        N(src, ('Division ~r~%s~s~ az ~y~%s~s~ gerefte shod.'):format(div.label, z.name))
    end
    MySQL.Sync.execute('UPDATE users SET divisions = @d WHERE identifier = @i', { ['@d'] = json.encode(list), ['@i'] = z.identifier })
    print(('[UJ][DIVISION] %s %s %s on %s (%s)'):format(x.identifier, mode, div.name, z.identifier, org))
end

RegisterCommand('edivision', function(src, args) if src > 0 then divisionAction(src, args[1], args[2], 'set', args[3]) end end, false)
RegisterCommand('removedivision', function(src, args) if src > 0 then divisionAction(src, args[1], args[2], 'remove', args[3]) end end, false)
RegisterNetEvent('ujrec:division')
AddEventHandler('ujrec:division', function(targetId, divName, mode) divisionAction(source, targetId, divName, mode == 'remove' and 'remove' or 'set', nil) end)

-- --------------------------------------------------- what the player may do (F6 section)
ESX.RegisterServerCallback('ujrec:mine', function(source, cb)
    local x = ESX.GetPlayerFromId(source)
    if not x or not x.job then return cb({}) end
    local org = x.job.name
    cb({ org = org, invite = hasPerm(x, org, 'invite'), division = hasPerm(x, org, 'division') })
end)

ESX.RegisterServerCallback('ujrec:divisions', function(source, cb, org)
    local x = ESX.GetPlayerFromId(source)
    if not x then return cb({}) end
    if x.job.name ~= 'government' then org = x.job.name end
    cb(MySQL.Sync.fetchAll('SELECT name, label FROM divisions WHERE owner = @o', { ['@o'] = org }) or {})
end)

-- ---------------------------------------- Government: configure it (F6 -> Estekhdam & Division)
ESX.RegisterServerCallback('ujrec:getCfg', function(source, cb, job)
    if not isGovAdminSrc(source) or not isOrg(job) then return cb(nil) end
    local ranks = {}
    local jd = ESX.Jobs and ESX.Jobs[job]
    if jd and jd.grades then
        for g, v in pairs(jd.grades) do ranks[#ranks + 1] = { grade = tonumber(g), label = v.label } end
        table.sort(ranks, function(a, b) return a.grade < b.grade end)
    end
    local divs = MySQL.Sync.fetchAll('SELECT name, label FROM divisions WHERE owner = @o', { ['@o'] = job }) or {}
    cb({ ranks = ranks, divisions = divs, perms = Perm[job] or {}, minLevel = Level[job] or 0 })
end)

RegisterNetEvent('ujrec:setPerm')
AddEventHandler('ujrec:setPerm', function(job, kind, typ, val, enabled)
    if not isGovAdminSrc(source) or not isOrg(job) then return end
    if kind ~= 'invite' and kind ~= 'division' then return end
    if typ ~= 'grade' and typ ~= 'division' then return end
    val = tostring(val or '')
    if val == '' or #val > 60 then return end
    Perm[job] = Perm[job] or {}
    Perm[job][kind] = Perm[job][kind] or { grades = {}, divisions = {} }
    local p = Perm[job][kind]
    MySQL.Sync.execute('DELETE FROM uj_org_perm WHERE job = @j AND kind = @k AND typ = @t AND val = @v', { ['@j'] = job, ['@k'] = kind, ['@t'] = typ, ['@v'] = val })
    if enabled then
        MySQL.Sync.execute('INSERT INTO uj_org_perm (job, kind, typ, val) VALUES (@j, @k, @t, @v)', { ['@j'] = job, ['@k'] = kind, ['@t'] = typ, ['@v'] = val })
    end
    if typ == 'grade' then p.grades[tonumber(val)] = enabled and true or nil
    else p.divisions[val] = enabled and true or nil end
end)

RegisterNetEvent('ujrec:setLevel')
AddEventHandler('ujrec:setLevel', function(job, level)
    if not isGovAdminSrc(source) or not isOrg(job) then return end
    level = math.max(0, math.min(999, math.floor(tonumber(level) or 0)))
    Level[job] = level
    MySQL.Sync.execute('INSERT INTO uj_org_level (job, level) VALUES (@j, @l) ON DUPLICATE KEY UPDATE level = @l', { ['@j'] = job, ['@l'] = level })
    N(source, ('Hadaghal level estekhdam ~y~%s~s~ = ~g~%d~s~'):format(orgLabel(job), level))
end)
