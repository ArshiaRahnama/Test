--[[
    kq_detective (now part of esx_uniquejobs) — DOJ / CAD / Records
    integration.

    This used to be a separate resource calling esx_uniquejobs through its
    exported functions (exports['esx_uniquejobs']:CreateExternalCase(...)
    etc). Now that it's merged into esx_uniquejobs itself, those same
    functions (CreateExternalCase, AddExternalNote, AddExternalSuspect,
    LogCriminalRecord, ScheduleExternalHearing, GetLatestMugshot -- defined
    in doj_cases.lua / records_manager.lua / court_docket.lua /
    mugshot_manager.lua) are plain same-resource globals, so this calls them
    directly. They're still exported too (other resources may still want
    them), this file just no longer needs to go through that layer itself.

    KQ_InsertCadNote/KQ_PushCadWanted still talk to duckcad_data/users
    directly rather than through a function -- see their comments below for
    why.
]]

local function Contains(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

-- caseId is fetched via cb the same way esx_uniquejobs' own callers do it.
function KQ_OpenDojCase(title, evidenceText, cb)
    if not Config_detective.dojIntegration.enabled then return end

    CreateExternalCase({
        title = title,
        priority = Config_detective.dojIntegration.casePriority,
        openedByName = 'kq_detective',
        openedByJob = Config_detective.dojIntegration.openedByJob,
        evidenceText = evidenceText,
    }, cb)
end

function KQ_AddDojNote(caseId, noteType, text, byName)
    if not Config_detective.dojIntegration.enabled or not caseId then return end
    AddExternalNote(caseId, noteType, text, byName)
end

function KQ_AddDojSuspect(caseId, identifier, name, byName)
    if not Config_detective.dojIntegration.enabled or not caseId then return end
    AddExternalSuspect(caseId, identifier, name, byName)
end

-- Logs a criminal_records entry (records_manager.lua) -- deliberately no
-- jailTime: this is an investigative flag ("forensics tied them to a scene"),
-- not a conviction. Sentencing stays a judge's call through the normal
-- /doj charge + court process, which is why this never sets one.
function KQ_LogCriminalRecord(identifier, recordType, reason, officerName, officerIdentifier)
    if not Config_detective.dojIntegration.enabled or not Config_detective.dojIntegration.logCriminalRecord then return end
    if not identifier then return end

    LogCriminalRecord(identifier, recordType, reason, officerName, officerIdentifier, nil)
end

-- Auto-schedules a court hearing (court_docket.lua) once a suspect is
-- identified, Config_detective.dojIntegration.hearingDelayMinutes out.
function KQ_ScheduleHearing(caseId, byName, cb)
    if not Config_detective.dojIntegration.enabled or not Config_detective.dojIntegration.scheduleHearing then return end
    if not caseId then return end

    ScheduleExternalHearing(caseId, Config_detective.dojIntegration.hearingDelayMinutes, byName, cb)
end

-- Pulls the suspect's latest booking photo (mugshot_manager.lua) so the
-- Discord reveal can show a real face instead of just a name.
function KQ_GetMugshot(identifier, cb)
    if not Config_detective.dojIntegration.enabled or not Config_detective.dojIntegration.pullMugshot then
        cb(nil)
        return
    end
    if not identifier then
        cb(nil)
        return
    end

    GetLatestMugshot(identifier, cb)
end

-- Sets the suspect's CAD WantedLevel directly.
--
-- cad/server/main.lua's own DuckMdt:UpdateCharacterStatus network event
-- checks the triggering player's job server-side (a real security fix on
-- that handler -- it used to trust the client-side permission check
-- alone). A purely internal caller like this one has no real player
-- "source" to pass that check, so firing the event wouldn't work even
-- from inside the same resource. This direct UPDATE is the exact same
-- query that handler runs internally, so the end result is identical.
function KQ_PushCadWanted(identifier)
    if not Config_detective.dojIntegration.enabled or not Config_detective.dojIntegration.pushCadStatus then return end
    if not identifier then return end

    MySQL.Async.execute('UPDATE users SET WantedLevel = @level WHERE identifier = @id', {
        ['@level'] = Config_detective.dojIntegration.cadWantedLevel,
        ['@id'] = identifier,
    })

    -- Mirrors cad/server/main.lua's own CADLog format for
    -- DuckMdt:UpdateCharacterStatus, so this shows up in the exact same
    -- admin log channel as a manually-set wanted level.
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CADLog',
        '```css\n[ Officer : kq_detective ]\n[ Action : Set Wanted Level ]\n[ Target Steam : ' .. tostring(identifier) .. ' ]\n[ New Status : ' .. tostring(Config_detective.dojIntegration.cadWantedLevel) .. ' ]\n```',
        'user', true, nil, false)
end

-- Adds a duckcad_data note to a citizen's CAD profile -- the same table
-- DuckMdt:SaveNewData (cad/server/main.lua) inserts into from the MDT's own
-- "add note" button. Kept as a direct insert rather than a shared function:
-- it's a single narrow (steam, reason, author) table with no other logic
-- attached, already effectively public via that existing handler.
function KQ_InsertCadNote(identifier, reason, author)
    if not Config_detective.dojIntegration.enabled or not identifier then return end

    MySQL.Async.execute('INSERT INTO duckcad_data (steam, reason, author) VALUES (@steam, @reason, @author)', {
        ['@steam'] = identifier,
        ['@reason'] = reason,
        ['@author'] = author or 'kq_detective',
    })
end

-- Department-wide chat bulletin -- every online Config_detective.dojLawJobs
-- member, not just the officer who ran the analysis. Used for the "big
-- reveal" moment so it feels like a department-wide event, not a private DM.
function KQ_BroadcastToDept(message)
    if not ESX then return end

    for _, playerId in ipairs(GetPlayers()) do
        local id = tonumber(playerId)
        local xTarget = ESX.GetPlayerFromId(id)

        if xTarget and Contains(Config_detective.dojLawJobs, xTarget.job.name) then
            TriggerClientEvent('chat:addMessage', id, {
                args = { '[DOJ Bulletin]', message }
            })
        end
    end
end

-- Opens the case the moment a real player murder is recorded (killer
-- identified). Second handler on the same event server/server.lua
-- registers -- FiveM runs every handler bound to an event, so server.lua
-- needed no changes. Stores the resulting caseId back onto
-- playerDeathInfo[src] so later forensics events (collection, Kit
-- Azmayeshi reveal, bleedout) can attach to the same case.
AddEventHandler('kq_detective:savePlayerInfo', function(killerNetId, cause)
    if not Config_detective.dojIntegration.enabled then return end

    local src = source
    local info = playerDeathInfo[src]
    if not info then return end -- shouldn't happen, server.lua's handler runs first

    -- Only real player-vs-player murders get an auto-case; environmental/
    -- self/NPC deaths (no resolved killer server id) don't.
    if not info.killerServerId or info.killerServerId <= 0 then return end

    local f = info.forensics or {}
    local evidenceLines = {}
    if f.hasPrint then
        table.insert(evidenceLines, 'A fingerprint was left at the scene.')
    end
    if f.hasCasing then
        table.insert(evidenceLines, ('A shell casing (serial %s) was left at the scene.'):format(f.serial))
    end
    if #evidenceLines == 0 then
        table.insert(evidenceLines, 'No physical evidence was left at the scene.')
    end

    KQ_OpenDojCase(
        ('Homicide investigation (victim #%d)'):format(src),
        table.concat(evidenceLines, ' '),
        function(caseId)
            if caseId and playerDeathInfo[src] then
                playerDeathInfo[src].caseId = caseId
            end
        end
    )

    -- Immediate real-time dispatch -- the case entry above is for the
    -- paperwork; this is the "get there now" alert, same styling as
    -- server/rob_manager.lua's own robAlert (colored [ Dispatch ] chat
    -- line) plus a live red map blip, sent to every online Config_detective.dojLawJobs
    -- member right as the shooting happens rather than waiting for bleedout.
    if info.coords then
        for _, playerId in ipairs(GetPlayers()) do
            local id = tonumber(playerId)
            local xTarget = ESX.GetPlayerFromId(id)

            if xTarget and Contains(Config_detective.dojLawJobs, xTarget.job.name) then
                TriggerClientEvent('chat:addMessage', id, {
                    color = { 255, 60, 60 },
                    multiline = true,
                    args = { '[ Dispatch ]', 'Gozaresh-e Tiraandazi -- Ghorbani Dar Mokhtasat Neshan Dade Shode Rooye Naghshe' },
                })
                TriggerClientEvent('kq_detective:activeSceneBlip', id, info.coords)
            end
        end
    end
end)
