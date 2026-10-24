if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
-- Requests from every organisation (medic, taxi, mechanic) are also listed for
-- Government. Entries expire after 10 minutes.

GovRequests = {}
local govReqSeq = 0
local REQ_TTL = 600

-- org: 'medic' | 'taxi' | 'mechanic'. Called by each organisation's addreq handler.
function GovRequestAdd(org, name, src, reason)
    govReqSeq = govReqSeq + 1
    local p = GetEntityCoords(GetPlayerPed(src))
    GovRequests[govReqSeq] = {
        id = govReqSeq, org = org, name = name, reason = reason or '',
        coord = { x = p.x, y = p.y, z = p.z }, time = os.time(),
    }
    for _, pid in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(pid)
        if x and x.job and x.job.name == 'government' then
            TriggerClientEvent('esx:showNotification', x.source, ('Darkhast jadid az %s: %s'):format(org, name))
        end
    end
end

local function liveRequests()
    local out = {}
    for id, r in pairs(GovRequests) do
        if os.time() - r.time > REQ_TTL then
            GovRequests[id] = nil
        else
            out[#out + 1] = r
        end
    end
    table.sort(out, function(a, b) return a.id > b.id end)
    return out
end

ESX.RegisterServerCallback('GovRequests:List', function(source, cb)
UJLog('SERVER', ('GovRequests:List source=%s'):format(tostring(source)))
    local x = ESX.GetPlayerFromId(source)
    if not x or not x.job or x.job.name ~= 'government' then return cb({}) end
    cb(liveRequests())
end)
