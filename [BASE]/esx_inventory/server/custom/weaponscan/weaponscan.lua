--[[
    "Scan Serial" - context-menu action on any item_weapon. Legality is
    config-driven (Config.WeaponLegality / Config.WeaponLegalDefault) and
    purely informational: it never stops anyone from carrying/using the
    weapon, it's just what a police scan would report.

    Deliberately server-authoritative: the client never learns whether a
    weapon is legal on its own, it only asks the server "is this person
    allowed to know, and if so what's the answer" - a civilian client
    can't just read Config.WeaponLegality out of a shared script and fake
    being police, because the actual legal/illegal string is only ever
    sent back if the job check on THIS event passes.
]]

local function isPoliceJob(job)
    if not job then return false end
    for _, allowed in ipairs(Config.PoliceJobs or {}) do
        if job == allowed then return true end
    end
    return false
end

RegisterNetEvent('esx_inventory:scanWeapon')
AddEventHandler('esx_inventory:scanWeapon', function(item)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil or item == nil or item.type ~= 'item_weapon' then return end

    local job = GetJob(xPlayer)
    -- GetJob can return a string (qb) or a table {name=...} (esx) depending
    -- on framework - normalize before comparing against Config.PoliceJobs.
    local jobName = type(job) == 'table' and job.name or job

    if not isPoliceJob(jobName) then
        showNotification(xPlayer, Locales[Config.Language]['scan_no_equipment'] or "You don't have the equipment to run this check.", 'error')
        return
    end

    local legal = Config.WeaponLegality[item.name]
    if legal == nil then legal = Config.WeaponLegalDefault end

    local serialTxt = item.serial and ('#' .. item.serial) or (Locales[Config.Language]['scan_no_serial'] or 'no serial')
    local statusTxt = legal and (Locales[Config.Language]['scan_legal'] or 'LEGAL') or (Locales[Config.Language]['scan_illegal'] or 'ILLEGAL')

    showNotification(xPlayer, (Locales[Config.Language]['scan_result'] or '%s (%s): %s'):format(item.label or item.name, serialTxt, statusTxt), legal and 'success' or 'error')
end)
