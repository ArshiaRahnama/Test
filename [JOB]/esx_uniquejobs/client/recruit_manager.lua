-- =====================================================================
-- Recruit / division client: the "do you want to join?" question, the F6 section of the
-- organisations and the Government configuration menu (permissions per rank / division + level).
-- =====================================================================

-- ------------------------------------------------------ the question the target gets
RegisterNetEvent('ujrec:ask')
AddEventHandler('ujrec:ask', function(tok, orgLabel, inviterName)
    CreateThread(function()
        local answered = false
        local function reply(yes)
            if answered then return end
            answered = true
            TriggerServerEvent('ujrec:answer', tok, yes)
        end
        if lib and lib.alertDialog then
            local r = lib.alertDialog({
                header = 'Darkhast-e estekhdam',
                content = ('**%s** shoma ra be ergan **%s** da\'vat mikonad.\n\nMikhahid ozv-e in ergan shavid?'):format(inviterName, orgLabel),
                centered = true, cancel = true, labels = { confirm = 'Bale', cancel = 'Kheir' },
            })
            reply(r == 'confirm')
        else
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_ask', {
                title = ('%s: estekhdam dar %s ?'):format(inviterName, orgLabel), align = 'top-left',
                elements = { { label = 'Bale', value = 'yes' }, { label = 'Kheir', value = 'no' } },
            }, function(data, menu) menu.close() reply(data.current.value == 'yes') end,
               function(_, menu) menu.close() reply(false) end)
            SetTimeout(30000, function() if not answered then ESX.UI.Menu.CloseAll() reply(false) end end)
        end
    end)
end)

CreateThread(function()
    Wait(3000)
    TriggerEvent('chat:addSuggestion', '/invite', 'Estekhdam fard-e nazdik (Government: /invite id job)', { { name = 'id', help = 'server id' } })
    TriggerEvent('chat:addSuggestion', '/edivision', 'Dadan-e division be ozv-e ergan', { { name = 'id' }, { name = 'division' } })
    TriggerEvent('chat:addSuggestion', '/removedivision', 'Gereftan-e division az ozv-e ergan', { { name = 'id' }, { name = 'division' } })
end)

-- --------------------------------------------- F6 section (for ranks / divisions with access)
local Access = { invite = false, division = false }

local function refreshAccess()
    if not ESX then return end
    ESX.TriggerServerCallback('ujrec:mine', function(a) Access = { invite = a and a.invite or false, division = a and a.division or false } end)
end

AddEventHandler('esx:setJob', function() SetTimeout(1500, refreshAccess) end)
CreateThread(function() while ESX == nil do Wait(300) end Wait(4000) refreshAccess() while true do Wait(60000) refreshAccess() end end)

local function nearestPlayerId()
    local p, dist = ESX.Game.GetClosestPlayer()
    if p ~= -1 and dist <= 3.0 then return GetPlayerServerId(p) end
    ESX.ShowNotification('~r~Hich fardi nazdik-e shoma nist.')
    return nil
end

local function openDivisionPick(mode)
    local target = nearestPlayerId()
    if not target then return end
    ESX.TriggerServerCallback('ujrec:divisions', function(list)
        local els = {}
        for _, d in ipairs(list or {}) do els[#els + 1] = { label = d.label or d.name, value = d.name } end
        if #els == 0 then return ESX.ShowNotification('~r~In ergan division-i nadarad.') end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_division_pick', {
            title = mode == 'set' and 'Division dadan' or 'Division gereftan', align = 'top-left', elements = els,
        }, function(data, menu)
            menu.close()
            TriggerServerEvent('ujrec:division', target, data.current.value, mode)
        end, function(_, menu) menu.close() end)
    end)
end

local function openRecruitMenu()
    local els = {}
    if Access.invite then els[#els + 1] = { label = 'Estekhdam fard-e nazdik (/invite)', value = 'invite' } end
    if Access.division then
        els[#els + 1] = { label = 'Dadan-e division (/edivision)', value = 'div_set' }
        els[#els + 1] = { label = 'Gereftan-e division (/removedivision)', value = 'div_remove' }
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_menu', {
        title = 'Estekhdam / Division', align = 'top-left', elements = els,
    }, function(data, menu)
        local v = data.current.value
        menu.close()
        if v == 'invite' then
            local t = nearestPlayerId()
            if t then TriggerServerEvent('ujrec:invite', t) end
        elseif v == 'div_set' then openDivisionPick('set')
        elseif v == 'div_remove' then openDivisionPick('remove') end
    end, function(_, menu) menu.close() end)
end

-- every organisation F6 menu (<job>_actions) gets the section when the player has the access
CreateThread(function()
    while ESX == nil or not ESX.UI or not ESX.UI.Menu do Wait(200) end
    Wait(1500)
    local orig = ESX.UI.Menu.Open
    ESX.UI.Menu.Open = function(ns, res, name, data, submit, cancel, change, close)
        if ns == 'default' and res == GetCurrentResourceName() and type(name) == 'string' and name:match('_actions$')
           and type(data) == 'table' and type(data.elements) == 'table' and (Access.invite or Access.division) then
            local has = false
            for _, e in ipairs(data.elements) do if e.value == '__ujrec' then has = true end end
            if not has then
                data.elements[#data.elements + 1] = { label = 'Dastresi: Estekhdam / Division', value = '__ujrec' }
                local origSubmit = submit
                submit = function(d, m)
                    if d.current and d.current.value == '__ujrec' then m.close() return openRecruitMenu() end
                    if origSubmit then return origSubmit(d, m) end
                end
            end
        end
        return orig(ns, res, name, data, submit, cancel, change, close)
    end
end)

-- --------------------------------------------------------- Government configuration menu
local GovOrgs = function()
    local out = {}
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do out[#out + 1] = { job = j, dept = d.label } end end
    end
    return out
end

local openGovRecruitOrg

local function openPermList(job, kind, typ)
    ESX.TriggerServerCallback('ujrec:getCfg', function(cfg)
        if not cfg then return ESX.ShowNotification('~r~Dastresi nadarid.') end
        local els = {}
        local p = (cfg.perms and cfg.perms[kind]) or { grades = {}, divisions = {} }
        if typ == 'grade' then
            for _, r in ipairs(cfg.ranks) do
                local on = p.grades and (p.grades[r.grade] or p.grades[tostring(r.grade)])
                els[#els + 1] = { label = ('%s <span style="float:right;color:%s">%s</span>'):format(r.label, on and '#4ade80' or '#f87171', on and 'ON' or 'OFF'), value = r.grade, on = on and true or false }
            end
        else
            for _, d in ipairs(cfg.divisions) do
                local on = p.divisions and p.divisions[d.name]
                els[#els + 1] = { label = ('%s <span style="float:right;color:%s">%s</span>'):format(d.label or d.name, on and '#4ade80' or '#f87171', on and 'ON' or 'OFF'), value = d.name, on = on and true or false }
            end
        end
        if #els == 0 then return ESX.ShowNotification('~y~Mored-i vojud nadarad.') end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_perm', {
            title = ('%s: %s / %s'):format(job, kind == 'invite' and 'Estekhdam' or 'Division', typ == 'grade' and 'Rank ha' or 'Division ha'),
            align = 'top-left', elements = els,
        }, function(data, menu)
            menu.close()
            TriggerServerEvent('ujrec:setPerm', job, kind, typ, data.current.value, not data.current.on)
            SetTimeout(500, function() openPermList(job, kind, typ) end)
        end, function(_, menu) menu.close() openGovRecruitOrg(job) end)
    end, job)
end

openGovRecruitOrg = function(job)
    ESX.TriggerServerCallback('ujrec:getCfg', function(cfg)
        if not cfg then return ESX.ShowNotification('~r~Dastresi nadarid.') end
        local els = {
            { label = ('Hadaghal level estekhdam: <b>%d</b>'):format(cfg.minLevel or 0), value = 'level' },
            { label = 'Estekhdam (/invite): rank ha', value = 'invite_grade' },
            { label = 'Estekhdam (/invite): division ha', value = 'invite_division' },
            { label = 'Division (/edivision): rank ha', value = 'division_grade' },
            { label = 'Division (/edivision): division ha', value = 'division_division' },
        }
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_org', {
            title = ('Estekhdam / Division - %s'):format(job), align = 'top-left', elements = els,
        }, function(data, menu)
            local v = data.current.value
            menu.close()
            if v == 'level' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ujrec_level', { title = 'Hadaghal level (0 = bedun-e mahdudiat)' }, function(d, m)
                    m.close()
                    TriggerServerEvent('ujrec:setLevel', job, tonumber(d.value) or 0)
                    SetTimeout(500, function() openGovRecruitOrg(job) end)
                end, function(_, m) m.close() openGovRecruitOrg(job) end)
            else
                local kind, typ = v:match('^(%a+)_(%a+)$')
                openPermList(job, kind, typ)
            end
        end, function(_, menu) menu.close() end)
    end, job)
end

function OpenGovRecruitMenu()
    local els = {}
    for _, o in ipairs(GovOrgs()) do els[#els + 1] = { label = ('%s  <span style="opacity:.6">(%s)</span>'):format(o.job, o.dept), value = o.job } end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ujrec_orgs', {
        title = 'Estekhdam / Division: entekhab-e ergan', align = 'top-left', elements = els,
    }, function(data, menu) menu.close() openGovRecruitOrg(data.current.value) end, function(_, menu) menu.close() end)
end
