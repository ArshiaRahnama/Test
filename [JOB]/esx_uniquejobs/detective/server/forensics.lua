--[[
    kq_detective — forensics extension (fingerprints, ballistics, autopsy log).

    Design notes:
      * Fingerprint match = the killer's ESX identifier, captured live at the
        moment of death. No new "fingerprint registry" table is needed — the
        ground truth already exists, we just remember it per case.
      * Ballistics = the killer's REAL weapon serial, read directly from their
        live loadout via ESX.GetWeaponFromHash + xPlayer.getWeapon(name),
        the exact same LAW-/DOJ-/GANG- serials essentialmode already issues
        (essentialmode/server/common.lua, ESX.GenerateWeaponSerial). No fake
        serial format, no separate weapon registry table.
      * Case truth (who the suspect actually is) is kept ONLY in this
        resource's memory (`cases` below), never sent to any client until an
        officer analyzes it (via Kit Azmayeshi OR the /doj Forensics Lab
        menu — see RunForensicAnalysis). It does not persist across a
        resource restart — acceptable for a same-session detective
        workflow; say if you want it durable across restarts instead and it
        can be moved into a small table.
      * Requires the `evidence_print`, `evidence_casing` and `kit_azmayeshi`
        items to exist in your `items` table — see
        sql/kq_detective_forensics.sql.
]]

local nextCaseId = 1
local cases = {}          -- [caseId] = { kind, identifier, code, serial, dojCaseId }
local officerCases = {}   -- [officerSource] = { caseId, caseId, ... } (most recent last)
local casesByDojCase = {} -- [dojCaseId] = { caseId, caseId, ... } -- powers the /doj Forensics Lab menu

local function Contains(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

local function ShortPrintCode(identifier)
    local clean = tostring(identifier):gsub('[^%w]', '')
    return ('FP-%s'):format(string.upper(clean:sub(-8)))
end

-- Small server-side locale helper (mirrors client L()) so these messages
-- respect locale/locale.lua too (now loaded server-side — see fxmanifest.lua).
function L2(key)
    if Locale and Locale[key] then
        return Locale[key]
    end
    return key
end

function SendKQDetectiveLog(title, description, color, imageUrl)
    if not Config_detective.discordWebhook or Config_detective.discordWebhook == '' or Config_detective.discordWebhook == 'WEBHOOK_LINK_HERE' then
        return
    end

    local embed = {
        title = title,
        description = description,
        color = color or 3447003,
    }

    if imageUrl and imageUrl ~= '' then
        embed.image = { url = imageUrl }
    end

    PerformHttpRequest(Config_detective.discordWebhook, function() end, 'POST', json.encode({
        username = 'KQ Detective',
        embeds = { embed }
    }), { ['Content-Type'] = 'application/json' })
end

-- Called from server.lua right when a player's death is recorded.
-- killerServerId may be nil (suicide, environment, fall damage, etc).
-- cause is the raw weapon hash from GetPedCauseOfDeath (may be a non-weapon cause).
function KQ_RollForensics(victimSrc, killerServerId, cause)
    local result = { hasPrint = false, hasCasing = false, serial = nil }

    if not Config_detective.forensics.enabled then return result end
    if not killerServerId or killerServerId <= 0 then return result end
    if not ESX then return result end

    local xKiller = ESX.GetPlayerFromId(killerServerId)
    if not xKiller then return result end

    if math.random(100) <= Config_detective.forensics.printChance then
        result.hasPrint = true
        result.printIdentifier = xKiller.identifier
    end

    if cause and cause ~= 0 then
        local weaponData = ESX.GetWeaponFromHash(cause)

        if weaponData and math.random(100) <= Config_detective.forensics.casingChance then
            local weaponInfo = xKiller.getWeapon(weaponData.name)

            if weaponInfo and weaponInfo.serial then
                result.hasCasing = true
                result.serial = weaponInfo.serial
                result.casingIdentifier = xKiller.identifier
            end
        end
    end

    return result
end

local function RegisterCase(kind, identifier, extra, dojCaseId)
    local caseId = nextCaseId
    nextCaseId = nextCaseId + 1

    cases[caseId] = {
        kind = kind,
        identifier = identifier,
        code = extra.code,
        serial = extra.serial,
        dojCaseId = dojCaseId,
    }

    if dojCaseId then
        casesByDojCase[dojCaseId] = casesByDojCase[dojCaseId] or {}
        table.insert(casesByDojCase[dojCaseId], caseId)
    end

    return caseId
end

-- Tries to find a real, judge-maintained law_codebook entry for homicide/
-- murder and auto-files it as a charge the moment a suspect is confirmed --
-- never a hardcoded/guessed code, since none ships pre-seeded (judges add
-- their own). If your codebook has no matching entry yet, this simply does
-- nothing and the charge stays a manual /doj action, same as before.
local function TryAutoFileCharge(dojCaseId, byName)
    if not dojCaseId then return end

    MySQL.Async.fetchAll(
        "SELECT code FROM law_codebook WHERE title LIKE '%Ghatl%' OR title LIKE '%Qatl%' OR title LIKE '%Homicide%' OR title LIKE '%Murder%' LIMIT 1",
        {}, function(rows)
            local law = rows[1]
            if not law then return end

            AddExternalCharge(dojCaseId, law.code, byName, function(ok)
                if ok then
                    SendKQDetectiveLog('Charge auto-filed',
                        ('Case #%s -- %s auto-filed from the codebook'):format(tostring(dojCaseId), law.code),
                        15158332)
                end
            end)
        end)
end

-- Shared by both analysis paths (the Kit Azmayeshi item AND the /doj
-- Forensics Lab menu below) -- runs the same lab-analysis pacing and fires
-- every DOJ/CAD/Records hook off the same reveal, so it behaves identically
-- no matter which one an officer used.
function RunForensicAnalysis(source, caseId, case)
    local xOfficer = ESX.GetPlayerFromId(source)
    if not xOfficer then return end

    local labDuration = Config_detective.forensics.labAnalysisMs or 5000
    TriggerClientEvent('kq_detective:runLabAnalysis', source, labDuration)

    SetTimeout(labDuration, function()
        MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @id', {
            ['@id'] = case.identifier
        }, function(rows)
            local suspectName = (rows[1] and rows[1].firstname and (rows[1].firstname .. ' ' .. rows[1].lastname)) or 'Unknown'
            local matchLabel = case.kind == 'print'
                and ('Fingerprint %s'):format(case.code)
                or ('Ballistics (serial %s)'):format(case.serial)

            TriggerClientEvent('chat:addMessage', source, {
                args = { '[Forensics]', ('%s matched to: %s'):format(matchLabel, suspectName) }
            })

            -- ================================================================
            -- Deep DOJ/CAD/Records integration -- everything below is fired
            -- off the SAME reveal, all through esx_uniquejobs' own functions
            -- (see server/dojintegration.lua for exactly what each one does
            -- and why KQ_InsertCadNote is the one direct-SQL exception).
            -- ================================================================
            KQ_AddDojNote(case.dojCaseId, 'evidence',
                ('%s match: %s'):format(matchLabel, suspectName), xOfficer.getName())
            KQ_AddDojSuspect(case.dojCaseId, case.identifier, suspectName, xOfficer.getName())
            KQ_PushCadWanted(case.identifier)
            KQ_InsertCadNote(case.identifier,
                ('Suspect in DOJ Case #%s -- %s (kq_detective)'):format(tostring(case.dojCaseId), matchLabel),
                'kq_detective')
            KQ_LogCriminalRecord(case.identifier, 'Forensics Match (Homicide)',
                ('%s -- DOJ Case #%s'):format(matchLabel, tostring(case.dojCaseId)),
                xOfficer.getName(), xOfficer.identifier)
            TryAutoFileCharge(case.dojCaseId, xOfficer.getName())

            if Config_detective.dojIntegration.scheduleHearing and case.dojCaseId then
                KQ_ScheduleHearing(case.dojCaseId, 'kq_detective', function(docketId)
                    if docketId then
                        SendKQDetectiveLog('Hearing scheduled',
                            ('Case #%s — hearing #%s scheduled (%d min out)'):format(
                                tostring(case.dojCaseId), tostring(docketId), Config_detective.dojIntegration.hearingDelayMinutes),
                            3447003)
                    end
                end)
            end

            if Config_detective.dojIntegration.broadcastToDept then
                KQ_BroadcastToDept(('🚨 Forensics match — Case #%s: %s identified via %s.'):format(
                    tostring(case.dojCaseId), suspectName, matchLabel))
            end

            KQ_GetMugshot(case.identifier, function(mugshot)
                SendKQDetectiveLog('Forensic match found',
                    ('Case #%d (%s) matched to **%s** (%s)'):format(caseId, case.kind, suspectName, case.identifier),
                    15158332,
                    mugshot and mugshot.photo_url or nil)
            end)
        end)
    end)
end

RegisterServerEvent('kq_detective:collectEvidence')
AddEventHandler('kq_detective:collectEvidence', function(victimSrc, kind)
    local officer = source
    local xOfficer = ESX.GetPlayerFromId(officer)
    if not xOfficer or not Contains(Config_detective.whitelist.jobs, xOfficer.job.name) then return end

    local info = playerDeathInfo[victimSrc]
    local f = info and info.forensics
    if not f then return end

    local caseId
    if kind == 'print' and f.hasPrint and not f.printCollected then
        f.printCollected = true
        caseId = RegisterCase('print', f.printIdentifier, { code = ShortPrintCode(f.printIdentifier) }, info.caseId)

        xOfficer.addInventoryItem(Config_detective.forensics.printItem, 1)
        TriggerClientEvent('esx:showNotification', officer, ('%s (#%d)'):format(L2('Fingerprint collected'), caseId))
        KQ_AddDojNote(info.caseId, 'evidence', ('Fingerprint collected by %s.'):format(xOfficer.getName()), xOfficer.getName())
    elseif kind == 'casing' and f.hasCasing and not f.casingCollected then
        f.casingCollected = true
        caseId = RegisterCase('casing', f.casingIdentifier, { serial = f.serial }, info.caseId)

        xOfficer.addInventoryItem(Config_detective.forensics.casingItem, 1)
        TriggerClientEvent('esx:showNotification', officer, ('%s: %s (#%d)'):format(L2('Shell casing collected'), f.serial, caseId))
        KQ_AddDojNote(info.caseId, 'evidence', ('Shell casing collected by %s (serial %s).'):format(xOfficer.getName(), f.serial), xOfficer.getName())
    else
        TriggerClientEvent('esx:showNotification', officer,
            kind == 'print' and L2('No fingerprint found here.') or L2('No shell casing found here.'))
        return
    end

    officerCases[officer] = officerCases[officer] or {}
    table.insert(officerCases[officer], caseId)

    SendKQDetectiveLog('Evidence collected',
        ('Officer **%s** collected %s — case #%d'):format(xOfficer.getName(), kind, caseId), 3447003)
end)

-- ============================================================
-- /doj Forensics Lab menu (client/doj_menu.lua's case detail menu) -- lets
-- ANY DOJ member analyze evidence tied to that case directly from the
-- menu, immediately, with no item needed and regardless of which officer
-- originally collected it out in the field. The Kit Azmayeshi item still
-- works exactly as before for on-scene field analysis; this is the office/
-- lab channel for the same underlying evidence.
-- ============================================================
ESX.RegisterServerCallback('esx_uniquejobs:detectiveGetCaseEvidence', function(source, cb, dojCaseId)
    local list = casesByDojCase[dojCaseId] or {}
    local result = {}

    for _, caseId in ipairs(list) do
        local case = cases[caseId]
        if case then
            table.insert(result, {
                id = caseId,
                kind = case.kind,
                label = case.kind == 'print'
                    and ('Fingerprint ' .. case.code)
                    or ('Shell casing (serial ' .. case.serial .. ')'),
            })
        end
    end

    cb(result)
end)

RegisterServerEvent('esx_uniquejobs:detectiveAnalyzeCase')
AddEventHandler('esx_uniquejobs:detectiveAnalyzeCase', function(caseId)
    local source = source
    local xOfficer = ESX.GetPlayerFromId(source)
    if not xOfficer or not Contains(Config_detective.dojLawJobs, xOfficer.job.name) then return end

    local case = cases[caseId]
    if not case then
        TriggerClientEvent('esx:showNotification', source, L2('No collected evidence to analyze.'))
        return
    end

    cases[caseId] = nil
    RunForensicAnalysis(source, caseId, case)
end)

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    -- Registered here (not at top level) so we never call this before ESX
    -- actually exists — RegisterUsableItem would error on a nil ESX otherwise.
    ESX.RegisterUsableItem(Config_detective.forensics.kitItem, function(source)
        local xOfficer = ESX.GetPlayerFromId(source)
        local myCases = officerCases[source]

        if not myCases or #myCases == 0 then
            TriggerClientEvent('esx:showNotification', source, L2('No collected evidence to analyze.'))
            return
        end

        local caseId = table.remove(myCases) -- most recently collected
        local case = cases[caseId]
        cases[caseId] = nil
        if not case then return end

        xOfficer.removeInventoryItem(Config_detective.forensics.kitItem, 1)
        RunForensicAnalysis(source, caseId, case)
    end)

    --[[
        SOLO TEST COMMAND — only exists while Config_detective.debug = true.
        Real forensics need an actual PvP kill (another player as the
        "killer"), which you don't have when testing alone. This creates a
        fake print case AND a fake casing case tied to YOUR OWN identifier,
        gives you the matching items, so you can run the full
        collect -> analyze -> reveal chain solo and confirm it points back
        at your own character. Remove/disable before going live.
    ]]
    if Config_detective.debug then
        RegisterCommand('kqtestforensics', function(source)
            if source == 0 then return end -- console can't hold items

            local xOfficer = ESX.GetPlayerFromId(source)
            if not xOfficer then return end

            local printCaseId = RegisterCase('print', xOfficer.identifier, { code = ShortPrintCode(xOfficer.identifier) })
            local casingCaseId = RegisterCase('casing', xOfficer.identifier, { serial = 'TEST-00000-0001' })

            officerCases[source] = officerCases[source] or {}
            table.insert(officerCases[source], printCaseId)
            table.insert(officerCases[source], casingCaseId)

            xOfficer.addInventoryItem(Config_detective.forensics.printItem, 1)
            xOfficer.addInventoryItem(Config_detective.forensics.casingItem, 1)
            xOfficer.addInventoryItem(Config_detective.forensics.kitItem, 2)

            TriggerClientEvent('chat:addMessage', source, {
                args = {
                    '[KQ TEST]',
                    ('Fake print (#%d) + casing (#%d) added, plus 2x Kit Azmayeshi. Use the kit twice — both should trace back to YOUR name.')
                        :format(printCaseId, casingCaseId)
                }
            })
        end, false)
    end
end)
