--[[
    kq_detective — body cleanup payout.

    Same reward convention as Config_ambulance.reviveReward in
    ambulance_main.lua: straight xPlayer.addMoney(...) plus an
    esx_society:logAction entry, so it shows up wherever your existing
    job activity logs already go (no new admin panel needed).

    The client can't be trusted to say "I really collected a valid corpse",
    so this only checks job + a per-officer cooldown against reward farming.
]]

local lastCollected = {}

local function Contains(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

RegisterServerEvent('kq_detective:bodyCollected')
AddEventHandler('kq_detective:bodyCollected', function()
    local src = source
    if not ESX then return end

    local xOfficer = ESX.GetPlayerFromId(src)
    if not xOfficer or not Contains(Config_detective.cleanup.jobs, xOfficer.job.name) then return end

    local now = GetGameTimer()
    if lastCollected[src] and (now - lastCollected[src]) < Config_detective.cleanup.cooldownMs then
        return
    end
    lastCollected[src] = now

    xOfficer.addMoney(Config_detective.cleanup.reward)

    TriggerEvent('esx_society:logAction', 'doa', 'Body Collected', {
        { ["name"] = "Officer", ["value"] = xOfficer.getName(), ["inline"] = false },
        { ["name"] = "Reward", ["value"] = '$' .. Config_detective.cleanup.reward, ["inline"] = false },
    })

    if SendKQDetectiveLog then
        SendKQDetectiveLog('Body collected',
            ('**%s** collected a body (+$%d)'):format(xOfficer.getName(), Config_detective.cleanup.reward), 3066993)
    end
end)

AddEventHandler('playerDropped', function()
    lastCollected[source] = nil
end)
