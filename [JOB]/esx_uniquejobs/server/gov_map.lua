-- Government sees every on-duty organisation member on the map (blips).
if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end

local OrgJobs = {}
for _, d in ipairs(Departments or {}) do
    if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do OrgJobs[j] = true end end
end

CreateThread(function()
    while true do
        Wait(5000)
        local list = {}
        for _, pid in ipairs(ESX.GetPlayers()) do
            local x = ESX.GetPlayerFromId(pid)
            if x and x.job and OrgJobs[x.job.name] then
                local p = GetEntityCoords(GetPlayerPed(pid))
                list[#list + 1] = {
                    id = tonumber(pid), name = GetPlayerName(pid),
                    job = x.job.name, label = x.job.label or x.job.name, grade = x.job.grade_label or '',
                    x = p.x, y = p.y, z = p.z,
                }
            end
        end
        for _, pid in ipairs(ESX.GetPlayers()) do
            local x = ESX.GetPlayerFromId(pid)
            if x and x.job and x.job.name == 'government' then
                TriggerClientEvent('gov_map:update', x.source, list)
            end
        end
    end
end)
