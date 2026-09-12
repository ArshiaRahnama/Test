--[[
    kq_detective — DOJ case integration.

    Talks to esx_uniquejobs ONLY through its own external-export API
    (server/doj_cases.lua). Nothing here reads or writes DOJ's tables
    directly. Requires the small doj_cases.lua patch delivered alongside
    this resource (adds AddExternalNote / AddExternalSuspect, matching
    the shape of the CreateExternalCase / AddExternalCharge exports that
    already exist there).

    Every export call is wrapped in pcall: if esx_uniquejobs isn't running
    for any reason, kq_detective's own features (investigate, forensics,
    cleanup) keep working exactly as before -- DOJ integration just quietly
    does nothing instead of erroring out.
]]

local function safeExport(fn)
    local ok, err = pcall(fn)
    if not ok and Config.debug then
        print(('[kq_detective] DOJ export call failed: %s'):format(tostring(err)))
    end
end

-- caseId is fetched via cb the same way esx_uniquejobs' own callers do it --
-- these are all fire-and-forget from kq_detective's side, since nothing
-- here needs to block on the result except storing the caseId once it's back.
function KQ_OpenDojCase(title, evidenceText, cb)
    if not Config.dojIntegration.enabled then return end

    safeExport(function()
        exports['esx_uniquejobs']:CreateExternalCase({
            title = title,
            priority = Config.dojIntegration.casePriority,
            openedByName = 'kq_detective',
            openedByJob = Config.dojIntegration.openedByJob,
            evidenceText = evidenceText,
        }, cb)
    end)
end

function KQ_AddDojNote(caseId, noteType, text, byName)
    if not Config.dojIntegration.enabled or not caseId then return end

    safeExport(function()
        exports['esx_uniquejobs']:AddExternalNote(caseId, noteType, text, byName)
    end)
end

function KQ_AddDojSuspect(caseId, identifier, name, byName)
    if not Config.dojIntegration.enabled or not caseId then return end

    safeExport(function()
        exports['esx_uniquejobs']:AddExternalSuspect(caseId, identifier, name, byName)
    end)
end

-- Mirrors cad/server/crimescene.lua's PushCadCitizenStatus -- a plain
-- TriggerEvent, which is a harmless no-op if Unique_Cad/DuckMdt isn't
-- installed (nothing is listening for the event name).
function KQ_PushCadWanted(identifier)
    if not Config.dojIntegration.enabled or not Config.dojIntegration.pushCadStatus then return end
    if not identifier then return end

    TriggerEvent('DuckMdt:UpdateCharacterStatus', Config.dojIntegration.cadWantedLevel, identifier)
end

-- Opens the case the moment a real player murder is recorded (killer
-- identified). Second handler on the same event server.lua registers --
-- FiveM runs every handler bound to an event, so server.lua needed no
-- changes. Stores the resulting caseId back onto playerDeathInfo[src] so
-- later forensics events (collection, Kit Azmayeshi reveal, bleedout) can
-- attach to the same case.
AddEventHandler('kq_detective:savePlayerInfo', function(killerNetId, cause)
    if not Config.dojIntegration.enabled then return end

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
end)
