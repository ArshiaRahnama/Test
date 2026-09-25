-- Unique_AdminPanel | server/vdm.lua
-- Anti-VDM: when a player is killed by a vehicle that another player is driving, the SERVER
--   1. revives the victim (esx_ambulancejob:revivex) and cancels their New Life restriction
--   2. deletes the vehicle (like /dv)
--   3. sends fancy toasts to victim, driver and on-duty admins
--   4. logs it to both players' Case File and counts strikes (auto-flag on repeat offenders)
-- Detection reads the victim's cause/source of death on the server, so it works without any
-- trust in the client; the victim's client report is only a second trigger and gets re-checked.

local Cfg = VDMConfig
if not Cfg.Enabled then return end

local VEHICLE_CAUSES = {
    [GetHashKey('weapon_run_over_by_car')] = true,
    [GetHashKey('weapon_rammed_by_car')]   = true,
}

local handledUntil = {}  -- victim src -> os.clock() (dedupe between poll and client report)
local Strikes = {}       -- driver identifier -> { count, first }

local function isExemptJob(x)
    local job = x and x.job and x.job.name
    for _, j in ipairs(Cfg.ExemptJobs or {}) do
        if j == job then return true end
    end
    return false
end

local function playerFromPed(ped)
    if not ped or ped == 0 then return nil end
    for _, id in ipairs(ESX.GetPlayers()) do
        if GetPlayerPed(id) == ped then return id end
    end
end

local function vehicleLabel(veh)
    local ok, model = pcall(GetEntityModel, veh)
    if not ok or not model then return 'vehicle' end
    return tostring(model)
end

local function toast(target, variant, title, lines)
    TriggerClientEvent('vdm:cl:toast', target, { variant = variant, title = title, lines = lines, duration = Cfg.ToastDuration })
end

local function addStrike(identifier)
    local now = os.time()
    local s = Strikes[identifier]
    if not s or now - s.first > Cfg.Strikes.Window then s = { count = 0, first = now } Strikes[identifier] = s end
    s.count = s.count + 1
    return s.count
end

local function process(victim, killer, veh, via)
    if not victim or not killer or victim == killer then return end
    if RulesLimited(victim, 'vdm_handled', 10) then return end

    local vId, vX = RulesIdentifier(victim)
    local kId, kX = RulesIdentifier(killer)
    if not vId or not kId then return end
    if isExemptJob(kX) then return end
    if Cfg.OnlyMainWorld and (GetPlayerRoutingBucket(victim) ~= 0 or GetPlayerRoutingBucket(killer) ~= 0) then return end

    -- geometry re-check: the driver must be in that vehicle's driver seat, close to the victim
    local kPed = GetPlayerPed(killer)
    local vehicle = veh
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then vehicle = GetVehiclePedIsIn(kPed, false) end
    if not vehicle or vehicle == 0 then return end
    local vc, kc = RulesCoords(victim), GetEntityCoords(vehicle)
    if not vc or #(vector3(vc.x, vc.y, vc.z) - kc) > Cfg.MaxDistance then return end

    local vName, kName = GetPlayerName(victim) or '?', GetPlayerName(killer) or '?'
    local strikes = addStrike(kId)
    local details = ('%s killed %s with a vehicle (%s, strike %d)'):format(kName, vName, via, strikes)

    -- 1. revive the victim (and make sure they don't get a New Life / revive handicap)
    if Cfg.ClearNewLife then RulesSkipNLR[vId] = os.time() + 25 end
    SetTimeout(Cfg.ReviveDelay, function()
        if not GetPlayerName(victim) then return end
        TriggerClientEvent('vdm:cl:revived', victim, Cfg.ProtectSeconds)      -- first: sets the client-side skip windows
        TriggerClientEvent('esx_ambulancejob:revivex', victim)                -- your normal revive
        if Cfg.ClearNewLife then
            SetTimeout(1000, function()
                if GetPlayerName(victim) and ClearNewLife then ClearNewLife(victim, true) end
            end)
        end
    end)
    if ExemptFromAntiCheat then pcall(ExemptFromAntiCheat, victim, 8000) end -- revive + brief invincibility

    -- 2. delete the vehicle (server-side first: no client-side entity-delete for the anti-cheat to flag)
    if Cfg.DeleteVehicle then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        SetTimeout(700, function()
            if DoesEntityExist(vehicle) then pcall(DeleteEntity, vehicle) end
            SetTimeout(1500, function()
                if DoesEntityExist(vehicle) and GetPlayerName(killer) then
                    if ExemptFromAntiCheat then pcall(ExemptFromAntiCheat, killer, 6000) end
                    TriggerClientEvent('vdm:cl:removeVehicle', killer, netId) -- fallback if the server delete didn't stick
                end
            end)
        end)
    end

    -- 3. toasts
    toast(victim, 'victim', 'احیا شدی ✔', {
        ('%s با ماشین تو رو زیر گرفت (VDM)'):format(kName),
        'ماشینش حذف شد و نیو لایف برات ثبت نمی‌شه.',
    })
    toast(killer, 'driver', ('VDM شناسایی شد - اخطار %d'):format(strikes), {
        ('تو %s رو با ماشین زیر گرفتی.'):format(vName),
        'ماشینت حذف شد. تکرار = مجازات.',
    })
    if Cfg.Strikes.AlertAdmins then
        RulesEachAdmin(function(id)
            TriggerClientEvent('chat:addMessage', id, { args = { '^1[VDM]', ('[%s] %s ← زیر گرفت ← [%s] %s (اخطار #%d)'):format(killer, kName, victim, vName, strikes) } })
            toast(id, 'admin', 'VDM', { ('[%s] %s → [%s] %s'):format(killer, kName, victim, vName), ('strike #%d - victim revived, vehicle removed'):format(strikes) })
        end)
    end

    -- 4. audit + repeat offenders
    RulesLog('vdm_kill', details, kId, kName)
    RulesLog('vdm_victim', ('%s was run over by %s (revived, no New Life)'):format(vName, kName), vId, vName)
    if Cfg.Strikes.FlagAt > 0 and strikes >= Cfg.Strikes.FlagAt then
        RulesFlag(kId, ('VDM x%d within %d min'):format(strikes, math.floor(Cfg.Strikes.Window / 60)))
    end
end

-- ------------------------------------------------------------------ poll ---
if Cfg.ServerPoll then
    local wasDead = {}
    AddEventHandler('playerDropped', function() wasDead[source] = nil end)

    CreateThread(function()
        while true do
            Wait(Cfg.PollInterval)
            for _, id in ipairs(ESX.GetPlayers()) do
                local ped = GetPlayerPed(id)
                local dead = ped and ped ~= 0 and GetEntityHealth(ped) <= 0
                if dead and not wasDead[id] then
                    local okC, cause = pcall(GetPedCauseOfDeath, ped)
                    if okC and VEHICLE_CAUSES[cause] then
                        local okS, src = pcall(GetPedSourceOfDeath, ped)
                        local killer, veh
                        if okS and src and src ~= 0 then
                            local t = GetEntityType(src)
                            if t == 2 then
                                veh = src
                                killer = playerFromPed(GetPedInVehicleSeat(src, -1))
                            elseif t == 1 then
                                killer = playerFromPed(src)
                                veh = GetVehiclePedIsIn(src, false)
                            end
                        end
                        process(id, killer, veh, 'server')
                    end
                end
                wasDead[id] = dead
            end
        end
    end)
end

-- ----------------------------------------------------------- client report ---
RegisterNetEvent('vdm:sv:report', function(killerId, cause)
    local victim = source
    if not Cfg.ClientReport or RulesLimited(victim, 'vdm_report', 5) then return end
    killerId = tonumber(killerId)
    if not killerId or not GetPlayerName(killerId) then return end
    SetTimeout(800, function() -- give the server a moment to see the death itself
        if not GetPlayerName(victim) then return end
        local vPed = GetPlayerPed(victim)
        if not vPed or vPed == 0 or GetEntityHealth(vPed) > 0 then return end
        local okC, sCause = pcall(GetPedCauseOfDeath, vPed)
        local causeOk = (okC and VEHICLE_CAUSES[sCause]) or ((not okC or sCause == 0) and VEHICLE_CAUSES[tonumber(cause) or 0])
        if not causeOk then return end
        process(victim, killerId, nil, 'client-report')
    end)
end)
