-- Per-rank options (/cad, /law, /acceptrob, /dep). The cache holds the options switched OFF
-- for the player's own rank. UJCan(option) is the single check every command calls.
local denied = {}

local function refresh()
    if not ESX or not ESX.TriggerServerCallback then return end
    ESX.TriggerServerCallback('OrgOptions:Mine', function(list) denied = list or {} end)
end

CreateThread(function()
    while ESX == nil do Wait(200) end
    Wait(1500)
    refresh()
end)
AddEventHandler('esx:setJob', function() SetTimeout(500, refresh) end)
RegisterNetEvent('org_options:changed')
AddEventHandler('org_options:changed', function() refresh() end)

-- a clear, good-looking "no access" message
local function noAccess(label)
    local ok = pcall(function()
        lib.notify({
            title = 'Dastresi kafi nadarid',
            description = ('Rank-e shoma be %s dastresi nadarad. Az boss-e ergan bekhahid.'):format(label),
            type = 'error', position = 'center-right', duration = 6000,
        })
    end)
    if not ok and ESX and ESX.ShowNotification then
        ESX.ShowNotification(('~r~Dastresi kafi nadarid~s~ - %s'):format(label))
    end
end

function UJCan(option)
    local jd = UJLiveJobData and UJLiveJobData() or nil
    if jd and jd.name == 'government' then return true end
    if denied[option] then
        local label = option
        for _, o in ipairs(OrgOptionList or {}) do if o.id == option then label = o.label end end
        noAccess(label)
        return false
    end
    return true
end

-- Boss menu: Modiriat Job -> Modiriat Option ha  (rank -> option on/off)
function OpenOrgOptionsMenu(job)
    if not job then return end
    ESX.TriggerServerCallback('OrgOptions:List', function(ranks)
        if not ranks or #ranks == 0 then return ESX.ShowNotification('~r~Dastresi kafi nadarid ya rank peyda nashod.') end
        local els = {}
        for _, r in ipairs(ranks) do
            table.insert(els, { label = ('%s (rank %d)'):format(r.label or ('rank ' .. r.grade), r.grade), value = r.grade, info = r })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_opt_ranks_' .. job, {
            title = 'Option ha - ' .. job, align = 'top-left', elements = els,
        }, function(d, m)
            local r = d.current.info
            local oe = {}
            for _, o in ipairs(r.options) do
                table.insert(oe, { label = ('%s : %s'):format(o.label, o.enabled and '~g~ROSHAN~s~' or '~r~KHAMOOSH~s~'), value = o.id, enabled = o.enabled })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_opt_list_' .. job, {
                title = r.label or ('rank ' .. r.grade), align = 'top-left', elements = oe,
            }, function(d2, m2)
                TriggerServerEvent('org_options:set', job, r.grade, d2.current.value, not d2.current.enabled)
                m2.close()
                SetTimeout(400, function() OpenOrgOptionsMenu(job) end)
            end, function(_, m2) m2.close() end)
        end, function(_, m) m.close() end)
    end, job)
end

RegisterNetEvent('org_options:open')
AddEventHandler('org_options:open', function(society)
    OpenOrgOptionsMenu(society)
end)
