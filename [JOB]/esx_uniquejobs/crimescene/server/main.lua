--[[
    Crime Scene Investigation -- merged into esx_uniquejobs alongside cad/.
    Originally the standalone Unique_CrimeScene resource; the panel UI now
    lives entirely inside the CAD tablet (cad/html + the CS_* bridge in
    cad/client/main.lua, opened with /cad). This file only owns the actual
    logic/DB/permission checks -- it doesn't know or care that CAD is what's
    calling it, same as before.

    Hooks off Unique_AllRobs' 'Morphy_RobSystem:robberySuccess' event
    WITHOUT modifying that resource at all - it's just an extra
    AddEventHandler on an event that already fires. Unique_AllRobs doesn't
    need to know this exists.

    Flow:
      1. Robbery succeeds -> a crime scene with a few evidence points
         spawns around where the robber finished, UNSECURED.
      2. Law Enforcement (Config_cs.LawEnforcementJobs: police/sheriff/mt) is
         first on scene and secures it. Until they do, evidence DOJ
         collects has a chance of coming back contaminated (weaker).
      3. DOJ members (Config_cs.DOJJobs) walk up to evidence points and
         collect them. Each point rolls into a hint / vehicle plate /
         strong lead (partial real suspect identifier).
      4. DOJ members can add free-text notes, issue a BOLO on a found
         plate (Law Enforcement gets it and can check plates from the
         BOLO tab in /cad against it), and refer the case to Judge, CIA
         or FBI (Config_cs.ReferralJobs) who prosecute/investigate further
         and close the case.
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ActiveScenes = {} -- [caseId] = { robname, family, coords, plate, secured, suspectIdentifier, suspectName, points = { [pointId] = {coords, collected} }, createdAt }
local ActiveBOLOs = {} -- [plate] = { caseId, issuedBy, issuedAt }
local NextPointId = 0

-- ============================================================
-- Helpers
-- ============================================================

local function IsDOJJob(job)
    for i = 1, #Config_cs.DOJJobs do
        if Config_cs.DOJJobs[i] == job then return true end
    end
    return false
end

local function IsLawEnforcementJob(job)
    for i = 1, #Config_cs.LawEnforcementJobs do
        if Config_cs.LawEnforcementJobs[i] == job then return true end
    end
    return false
end

local function IsReferralJob(job)
    for i = 1, #Config_cs.ReferralJobs do
        if Config_cs.ReferralJobs[i] == job then return true end
    end
    return false
end

-- Gangs are now their own system in essentialmode (xPlayer.gang.name),
-- separate from jobs -- "nogang" is the default when someone isn't in one.
local function GetGangName(xTarget)
    if not xTarget or not xTarget.gang or not xTarget.gang.name or xTarget.gang.name == 'nogang' then
        return nil
    end
    return xTarget.gang.name
end

local function BroadcastToGang(gangName, event, ...)
    if not gangName then return end
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and xPlayer.gang and xPlayer.gang.name == gangName then
            TriggerClientEvent(event, xPlayers[i], ...)
        end
    end
end

local function NotifyGang(gangName, msg, msgType)
    if not gangName then return end
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and xPlayer.gang and xPlayer.gang.name == gangName then
            TriggerClientEvent('esx:showNotification', xPlayers[i], msg, msgType)
        end
    end
end

-- Shop_3 -> Shop, Palateo_Bank -> Palateo_Bank, Jaw_Shahr -> Jaw
local function GuessRobFamily(robname)
    if robname:find('^Jaw') then return 'Jaw' end
    local base = robname:gsub('_%d+$', '')
    return base
end

local function BroadcastToJobs(jobs, event, ...)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            for j = 1, #jobs do
                if xPlayer.job.name == jobs[j] then
                    TriggerClientEvent(event, xPlayers[i], ...)
                    break
                end
            end
        end
    end
end

local function NotifyJobs(jobs, msg, msgType)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            for j = 1, #jobs do
                if xPlayer.job.name == jobs[j] then
                    TriggerClientEvent('esx:showNotification', xPlayers[i], msg, msgType)
                    break
                end
            end
        end
    end
end

local function ClearBOLOsForCase(caseId)
    for plate, info in pairs(ActiveBOLOs) do
        if info.caseId == caseId then
            ActiveBOLOs[plate] = nil
        end
    end
end

-- ============================================================
-- Unique_Cad (DuckMdt) integration helpers
-- ============================================================
-- These just TriggerEvent the same events Unique_Cad's own NUI calls
-- server-side. If Unique_Cad isn't installed, nothing is listening for
-- these event names and the call is a harmless no-op.

local function PushCadVehicleStatus(plate, level)
    if not Config_cs.CadIntegration or not plate then return end
    TriggerEvent('DuckMdt:UpdateCarStatus', level, plate)
end

local function PushCadCitizenStatus(identifier, level)
    if not Config_cs.CadIntegration or not identifier then return end
    TriggerEvent('DuckMdt:UpdateCharacterStatus', level, identifier)
end

-- Unique_Cad's incident log (`duckcad_data`) is keyed by a real identifier,
-- so this only ever gets called once we actually have one (e.g. an officer
-- linked a booking to a specific online player).
local function PushCadIncidentNote(identifier, authorName, note)
    if not Config_cs.CadIntegration or not identifier then return end
    MySQL.Async.execute(
        'INSERT INTO duckcad_data (secondryid, steam, reason, author) VALUES (0, @steam, @reason, @author)',
        { ['@steam'] = identifier, ['@reason'] = note, ['@author'] = authorName }
    )
end

local function FindNearbyVehiclePlate(coords)
    local vehicles = GetAllVehicles()
    for i = 1, #vehicles do
        local v = vehicles[i]
        local vCoords = GetEntityCoords(v)
        if #(vCoords - coords) <= Config_cs.NearbyVehicleRadius then
            return GetVehicleNumberPlateText(v)
        end
    end
    return nil
end

-- Shared by both first-time scene creation and cold-case reopening so the
-- point-scattering math only lives in one place.
local function GenerateEvidencePoints(coords, family)
    local evidenceCount = Config_cs.EvidenceCountByFamily[family] or Config_cs.EvidenceCountByFamily.default
    local points = {}
    local pointsForClient = {}
    for i = 1, evidenceCount do
        local angle = math.random(0, 359)
        local dist = math.random(2, math.floor(Config_cs.SceneRadius))
        local rad = math.rad(angle)
        local px = coords.x + math.cos(rad) * dist
        local py = coords.y + math.sin(rad) * dist
        local pCoords = vector3(px, py, coords.z)

        NextPointId = NextPointId + 1
        local pointId = NextPointId
        points[pointId] = { coords = pCoords, collected = false }
        pointsForClient[#pointsForClient + 1] = { id = pointId, coords = pCoords }
    end
    return points, pointsForClient
end

-- ============================================================
-- Crime scene creation
-- ============================================================

local LastSceneCreatedAt = {} -- [source] = os.time()

AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname, robberyCode)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    -- Unique_AllRobs' own robberySuccess handler now validates robname
    -- against that player's actual RobsInProgress entry before paying out
    -- a reward -- but that table is local to that resource, so this
    -- listener (a separate AddEventHandler on the same event name) has no
    -- way to see it and still fires on a spoofed TriggerServerEvent. No
    -- money is at stake here, but without a guard someone could still
    -- spam fake crime scenes/evidence points. Simple per-player cooldown
    -- as a cheap mitigation until/unless a shared validation hook exists.
    local now = os.time()
    if LastSceneCreatedAt[_source] and (now - LastSceneCreatedAt[_source]) < Config_cs.MinSecondsBetweenScenes then
        return
    end
    LastSceneCreatedAt[_source] = now

    local ped = GetPlayerPed(_source)
    if not ped or ped == 0 then return end
    local coords = GetEntityCoords(ped)

    local family = GuessRobFamily(robname)
    local plate = FindNearbyVehiclePlate(coords)

    -- Multi-suspect: if the finisher is in a Team (Unique_AllRobs' merged
    -- PartySystem/TeamSystem), everyone else on it gets attached to the
    -- case as an accomplice. Guarded with pcall so a missing/renamed team
    -- resource never breaks case creation -- it just falls back to a
    -- single-suspect case, same as before this feature existed.
    local accompliceList = {}
    if Config_cs.MultiSuspect.enabled then
        local ok, inTeam, playerTeam = pcall(function()
            return exports[Config_cs.MultiSuspect.teamResource]:IsInTeam(_source)
        end)
        if ok and inTeam and type(playerTeam) == 'table' then
            for mateId, _ in pairs(playerTeam) do
                if mateId ~= _source then
                    local xMate = ESX.GetPlayerFromId(mateId)
                    if xMate then
                        accompliceList[#accompliceList + 1] = { identifier = xMate.identifier, name = xMate.name }
                    end
                end
            end
        end
    end

    MySQL.Async.insert(
        'INSERT INTO doj_cases (rob_name, rob_family, status, suspect_identifier, suspect_name, coords_x, coords_y, coords_z) VALUES (@rob_name, @rob_family, @status, @suspect_identifier, @suspect_name, @x, @y, @z)',
        {
            ['@rob_name']            = robname,
            ['@rob_family']          = family,
            ['@status']              = 'open',
            ['@suspect_identifier']  = xPlayer.identifier,
            ['@suspect_name']        = xPlayer.name,
            ['@x']                   = coords.x,
            ['@y']                   = coords.y,
            ['@z']                   = coords.z,
        },
        function(caseId)
            if not caseId or caseId == 0 then return end

            MySQL.Async.execute(
                'INSERT INTO doj_case_suspects (case_id, suspect_identifier, suspect_name, role) VALUES (@case_id, @identifier, @name, @role)',
                { ['@case_id'] = caseId, ['@identifier'] = xPlayer.identifier, ['@name'] = xPlayer.name, ['@role'] = 'primary' }
            )
            for _, mate in ipairs(accompliceList) do
                MySQL.Async.execute(
                    'INSERT INTO doj_case_suspects (case_id, suspect_identifier, suspect_name, role) VALUES (@case_id, @identifier, @name, @role)',
                    { ['@case_id'] = caseId, ['@identifier'] = mate.identifier, ['@name'] = mate.name, ['@role'] = 'accomplice' }
                )
            end

            local points, pointsForClient = GenerateEvidencePoints(coords, family)

            ActiveScenes[caseId] = {
                robname            = robname,
                family             = family,
                coords             = coords,
                plate              = plate,
                secured            = false,
                suspectIdentifier  = xPlayer.identifier,
                suspectName        = xPlayer.name,
                accomplices        = accompliceList,
                points             = points,
                createdAt          = os.time(),
            }

            BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:sceneCreated', caseId, coords, pointsForClient, false)
            BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:sceneCreated', caseId, coords, pointsForClient, false)
            NotifyJobs(Config_cs.DOJJobs, 'Yek Sahne Jorm Jadid Sabt Shod. Baraye Didan /cad Bezanid.', 'info')
            NotifyJobs(Config_cs.LawEnforcementJobs, 'Yek Sahne Jorm Niaz Be Emn Sazi Darad.', 'info')

            SetTimeout(Config_cs.SceneLifetimeMinutes * 60000, function()
                if ActiveScenes[caseId] then
                    ActiveScenes[caseId] = nil
                    BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:sceneExpired', caseId)
                    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:sceneExpired', caseId)
                    ClearBOLOsForCase(caseId)
                    MySQL.Async.execute(
                        "UPDATE doj_cases SET status = @newstatus WHERE id = @id AND status = @openstatus",
                        { ['@newstatus'] = 'cold', ['@id'] = caseId, ['@openstatus'] = 'open' }
                    )
                end
            end)
        end
    )
end)

-- ============================================================
-- Scene lockdown (Law Enforcement secures the scene first)
-- ============================================================

RegisterServerEvent('CrimeScene:secureScene')
AddEventHandler('CrimeScene:secureScene', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsLawEnforcementJob(xPlayer.job.name) then return end

    local scene = ActiveScenes[caseId]
    if not scene or scene.secured then return end

    local ped = GetPlayerPed(_source)
    local pCoords = GetEntityCoords(ped)
    if #(pCoords - scene.coords) > Config_cs.SceneLockdown.radius then
        TriggerClientEvent('esx:showNotification', _source, 'Shoma Be Markaze Sahne Nazdik Nistid', 'error')
        return
    end

    scene.secured = true

    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:sceneSecured', caseId)
    BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:sceneSecured', caseId)
    NotifyJobs(Config_cs.DOJJobs, xPlayer.name .. ' Sahne Ra Emn Kard. Madarek Alan Kamele Ghabele Etemad Hastand.', 'success')
    NotifyJobs(Config_cs.LawEnforcementJobs, xPlayer.name .. ' Sahne Ra Emn Kard.', 'success')

    TriggerEvent(
        'DiscordBot:ToDiscord', 'rob', "Crime Scene",
        "```css\n[Case] : " .. caseId .. "\n[Secured By] : " .. xPlayer.name .. "\n```",
        'user', _source, true, false
    )
end)

-- ============================================================
-- Evidence collection
-- ============================================================

RegisterServerEvent('CrimeScene:collectEvidence')
AddEventHandler('CrimeScene:collectEvidence', function(caseId, pointId, skillCheckPassed)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    local scene = ActiveScenes[caseId]
    if not scene then
        TriggerClientEvent('esx:showNotification', _source, 'In Sahne Digar Motabar Nist Ya Sard Shode', 'error')
        return
    end

    local point = scene.points[pointId]
    if not point or point.collected then return end

    local ped = GetPlayerPed(_source)
    local pCoords = GetEntityCoords(ped)
    if #(pCoords - point.coords) > Config_cs.CollectDistance then
        TriggerClientEvent('esx:showNotification', _source, 'Shoma Be In Noghte Nazdik Nistid', 'error')
        return
    end

    point.collected = true

    local roll = math.random()
    local evType, content, hintId, evPlate

    if roll < Config_cs.StrongLeadChance then
        evType = 'strong_lead'
    elseif scene.plate and roll < (Config_cs.StrongLeadChance + Config_cs.VehicleLeadChance) then
        evType = 'vehicle'
    else
        evType = 'hint'
    end

    -- Failing the skillcheck downgrades the roll: a strong lead or vehicle
    -- description turns into a smudged/useless plain hint instead. Evidence
    -- is never lost entirely -- it just becomes weaker.
    if not skillCheckPassed and evType ~= 'hint' then
        evType = 'hint'
    end

    -- Scene wasn't secured by Law Enforcement yet: chance the evidence got
    -- contaminated/trampled before DOJ got a clean read on it.
    if not scene.secured and evType ~= 'hint' and math.random() < Config_cs.UnsecuredContaminationChance then
        evType = 'hint'
    end

    if evType == 'strong_lead' then
        hintId = scene.suspectIdentifier and scene.suspectIdentifier:sub(-6) or '??????'
        content = 'Sarnakh Ghavi: Yek Fard Ba Code Shenasaei Payan Be ^3' .. hintId .. '^0 Peida Shod'
    elseif evType == 'vehicle' then
        evPlate = scene.plate
        content = 'Pelake Khodroye Mashkook: ^3' .. scene.plate .. '^0'
    else
        content = Config_cs.SuspectHints[math.random(1, #Config_cs.SuspectHints)]
    end

    MySQL.Async.insert(
        'INSERT INTO doj_case_evidence (case_id, type, content, suspect_hint_id, plate, found_by, found_by_name) VALUES (@case_id, @type, @content, @hint_id, @plate, @found_by, @found_by_name)',
        {
            ['@case_id']       = caseId,
            ['@type']          = evType,
            ['@content']       = content,
            ['@hint_id']       = hintId,
            ['@plate']         = evPlate,
            ['@found_by']      = xPlayer.identifier,
            ['@found_by_name'] = xPlayer.name,
        }
    )

    TriggerClientEvent('CrimeScene:evidenceCollected', _source, caseId, pointId, evType, content, skillCheckPassed)
    BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:pointRemoved', caseId, pointId)

    TriggerEvent(
        'DiscordBot:ToDiscord', 'rob', "Crime Scene",
        "```css\n[Case] : " .. caseId ..
        "\n[Officer] : " .. xPlayer.name ..
        "\n[Type] : " .. evType ..
        "\n[Content] : " .. content .. "\n```",
        'user', _source, true, false
    )
end)

-- ============================================================
-- Case notes / expanding a case
-- ============================================================

RegisterServerEvent('CrimeScene:addNote')
AddEventHandler('CrimeScene:addNote', function(caseId, note)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end
    if not note or note == '' then return end

    MySQL.Async.execute(
        'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
        {
            ['@case_id']    = caseId,
            ['@author']     = xPlayer.identifier,
            ['@author_name'] = xPlayer.name,
            ['@note']       = note,
        }
    )

    TriggerClientEvent('esx:showNotification', _source, 'Yaddasht Be Parvande Ezafe Shod', 'success')
    TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
end)

-- ============================================================
-- Warrants -- DOJ requests, only Judge decides. Approval is required
-- before a case's booking can be linked back to it (Config below).
-- ============================================================

RegisterServerEvent('CrimeScene:requestWarrant')
AddEventHandler('CrimeScene:requestWarrant', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.execute(
        "UPDATE doj_cases SET warrant_status = 'requested', warrant_requested_by = @by WHERE id = @id AND warrant_status IN ('none','denied')",
        { ['@by'] = xPlayer.name, ['@id'] = caseId },
        function(rowsChanged)
            if not rowsChanged or rowsChanged == 0 then
                TriggerClientEvent('esx:showNotification', _source, 'In Parvande Hokme Darkhast Shode Ya Tayid Shode Darad', 'error')
                return
            end
            NotifyJobs({ 'judge' }, xPlayer.name .. ' Darkhaste Hokm Baraye Parvande #' .. caseId .. ' Dad. /cad Bezanid.', 'info')
            TriggerClientEvent('esx:showNotification', _source, 'Darkhaste Hokm Ersal Shod', 'success')
            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
        end
    )
end)

RegisterServerEvent('CrimeScene:decideWarrant')
AddEventHandler('CrimeScene:decideWarrant', function(caseId, approved)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or xPlayer.job.name ~= 'judge' then return end

    local newStatus = approved and 'approved' or 'denied'

    MySQL.Async.execute(
        "UPDATE doj_cases SET warrant_status = @status, warrant_decided_by = @by WHERE id = @id AND warrant_status = 'requested'",
        { ['@status'] = newStatus, ['@by'] = xPlayer.name, ['@id'] = caseId },
        function(rowsChanged)
            if not rowsChanged or rowsChanged == 0 then return end

            MySQL.Async.execute(
                'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
                {
                    ['@case_id']     = caseId,
                    ['@author']      = 'SYSTEM',
                    ['@author_name'] = 'Judge',
                    ['@note']        = 'Hokme Bazdasht ' .. (approved and 'TAYID' or 'RAD') .. ' Shod Tavasote ' .. xPlayer.name,
                }
            )

            NotifyJobs(Config_cs.DOJJobs, 'Hokme Parvande #' .. caseId .. ' ' .. (approved and 'Tayid' or 'Rad') .. ' Shod.', approved and 'success' or 'error')
            BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:refreshCase', caseId)
        end
    )
end)

-- ============================================================
-- Referral (CID/DOJ field jobs -> Judge/CIA/FBI)
-- ============================================================

RegisterServerEvent('CrimeScene:referCase')
AddEventHandler('CrimeScene:referCase', function(caseId, targetJob)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end
    if not IsReferralJob(targetJob) then return end

    MySQL.Async.execute(
        'UPDATE doj_cases SET status = @newstatus WHERE id = @id',
        { ['@newstatus'] = 'referred_' .. targetJob, ['@id'] = caseId },
        function(rowsChanged)
            if not rowsChanged or rowsChanged == 0 then return end

            NotifyJobs(
                { targetJob },
                'Yek Parvande Jadid Baraye Vahede Shoma Ersal Shod. /cad Bezanid.',
                'info'
            )
            TriggerClientEvent('esx:showNotification', _source, 'Parvande Ba Movafaghiat Ersal Shod', 'success')
            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
            TriggerEvent(
                'DiscordBot:ToDiscord', 'rob', "Crime Scene",
                "```css\n[Case] : " .. caseId ..
                "\n[Referred By] : " .. xPlayer.name ..
                "\n[Referred To] : " .. targetJob .. "\n```",
                'user', _source, true, false
            )
        end
    )
end)

-- ============================================================
-- Closing a case (Judge/CIA/FBI only)
-- ============================================================

RegisterServerEvent('CrimeScene:closeCase')
AddEventHandler('CrimeScene:closeCase', function(caseId, verdict)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsReferralJob(xPlayer.job.name) then return end

    MySQL.Async.execute(
        'UPDATE doj_cases SET status = @newstatus, closed_by_name = @closedBy WHERE id = @id',
        { ['@newstatus'] = 'closed', ['@closedBy'] = xPlayer.name, ['@id'] = caseId }
    )
    ClearBOLOsForCase(caseId)
    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:boloListUpdated')

    -- Case resolved: clear any wanted flags this investigation put on
    -- every suspect (primary + accomplices) / their vehicles in
    -- Unique_Cad's MDT.
    MySQL.Async.fetchAll('SELECT suspect_identifier FROM doj_case_suspects WHERE case_id = @id AND suspect_identifier IS NOT NULL', { ['@id'] = caseId }, function(suspectRows)
        if not suspectRows then return end
        for i = 1, #suspectRows do
            PushCadCitizenStatus(suspectRows[i].suspect_identifier, Config_cs.CadWantedLevels.standard)
        end
    end)
    MySQL.Async.fetchAll("SELECT DISTINCT plate FROM doj_case_evidence WHERE case_id = @id AND plate IS NOT NULL", { ['@id'] = caseId }, function(plateRows)
        if not plateRows then return end
        for i = 1, #plateRows do
            PushCadVehicleStatus(plateRows[i].plate, Config_cs.CadWantedLevels.standard)
        end
    end)

    if verdict and verdict ~= '' then
        MySQL.Async.execute(
            'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
            {
                ['@case_id']     = caseId,
                ['@author']      = xPlayer.identifier,
                ['@author_name'] = xPlayer.name,
                ['@note']        = '[HOKM] ' .. verdict,
            }
        )
    end

    TriggerClientEvent('esx:showNotification', _source, 'Parvande Baste Shod', 'success')
    TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
end)

-- ============================================================
-- BOLOs -- DOJ issues them off a case's vehicle plate, Law
-- Enforcement (police/sheriff/mt) acts on them from the BOLO tab in /cad
-- ============================================================

RegisterServerEvent('CrimeScene:issueBOLO')
AddEventHandler('CrimeScene:issueBOLO', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.fetchAll(
        "SELECT plate FROM doj_case_evidence WHERE case_id = @id AND type = 'vehicle' AND plate IS NOT NULL ORDER BY created_at DESC LIMIT 1",
        { ['@id'] = caseId },
        function(rows)
            if not rows or not rows[1] or not rows[1].plate then
                TriggerClientEvent('esx:showNotification', _source, 'In Parvande Hich Pelaki Sabt Nashode', 'error')
                return
            end

            local plate = rows[1].plate
            ActiveBOLOs[plate] = { caseId = caseId, issuedBy = xPlayer.name, issuedAt = os.time() }
            PushCadVehicleStatus(plate, Config_cs.CadWantedLevels.wanted)

            BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:newBOLO', plate, caseId)
            BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:boloListUpdated')
            NotifyJobs(Config_cs.LawEnforcementJobs, 'BOLO Jadid: Pelake ^1' .. plate .. '^0 - Az Panel Check Konid', 'error')
            TriggerClientEvent('esx:showNotification', _source, 'BOLO Baraye Pelake ' .. plate .. ' Sadar Shod', 'success')

            SetTimeout(Config_cs.BOLOLifetimeMinutes * 60000, function()
                if ActiveBOLOs[plate] and ActiveBOLOs[plate].caseId == caseId then
                    ActiveBOLOs[plate] = nil
                    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:boloListUpdated')
                end
            end)

            TriggerEvent(
                'DiscordBot:ToDiscord', 'rob', "Crime Scene",
                "```css\n[Case] : " .. caseId .. "\n[BOLO Issued By] : " .. xPlayer.name .. "\n[Plate] : " .. plate .. "\n```",
                'user', _source, true, false
            )
        end
    )
end)

RegisterServerEvent('CrimeScene:checkPlate')
AddEventHandler('CrimeScene:checkPlate', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsLawEnforcementJob(xPlayer.job.name) then return end
    if not plate then return end

    plate = plate:gsub('^%s+', ''):gsub('%s+$', '')
    local bolo = ActiveBOLOs[plate]

    if not bolo then
        TriggerClientEvent('CrimeScene:plateCheckResult', _source, false, plate, nil)
        return
    end

    TriggerClientEvent('CrimeScene:plateCheckResult', _source, true, plate, bolo.caseId)

    MySQL.Async.execute(
        'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
        {
            ['@case_id']     = bolo.caseId,
            ['@author']      = 'SYSTEM',
            ['@author_name'] = 'Law Enforcement',
            ['@note']        = xPlayer.name .. ' Khodroye BOLO (Pelake ' .. plate .. ') Ra Peida Kard',
        }
    )

    -- solved: this BOLO doesn't need to be checked for anymore, take it off
    -- the board for everyone
    ActiveBOLOs[plate] = nil
    PushCadVehicleStatus(plate, Config_cs.CadWantedLevels.standard)
    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:boloListUpdated')

    TriggerEvent(
        'DiscordBot:ToDiscord', 'rob', "Crime Scene",
        "```css\n[Case] : " .. bolo.caseId .. "\n[BOLO Hit By] : " .. xPlayer.name .. "\n[Plate] : " .. plate .. "\n```",
        'user', _source, true, false
    )
end)

ESX.RegisterServerCallback('CrimeScene:getActiveBOLOs', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsLawEnforcementJob(xPlayer.job.name) then
        cb({})
        return
    end

    local list = {}
    for plate, info in pairs(ActiveBOLOs) do
        list[#list + 1] = { plate = plate, caseId = info.caseId, issuedBy = info.issuedBy, issuedAt = info.issuedAt }
    end
    table.sort(list, function(a, b) return a.issuedAt > b.issuedAt end)
    cb(list)
end)

-- ============================================================
-- Booking -- Law Enforcement logs an arrest (charges, fine, jail time).
-- Linking it to a case requires an approved warrant on that case; a
-- caught-red-handed arrest (no case) never needs one.
-- ============================================================

RegisterServerEvent('CrimeScene:createBooking')
AddEventHandler('CrimeScene:createBooking', function(caseId, suspectName, charges, fine, jailMinutes, targetServerId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsLawEnforcementJob(xPlayer.job.name) then return end

    if not suspectName or suspectName == '' or not charges or charges == '' then
        TriggerClientEvent('esx:showNotification', _source, 'Esme Mozan Va Ettehamat Alzami Ast', 'error')
        return
    end

    fine = tonumber(fine) or 0
    jailMinutes = tonumber(jailMinutes) or 0

    -- If the officer gave an in-game player id, resolve them so the booking
    -- links to a real identifier -- this is what lets it sync into
    -- Unique_Cad's MDT (wanted flag + incident log), not just our own tab.
    local targetIdentifier, targetName, targetGangName = nil, nil, nil
    targetServerId = tonumber(targetServerId)
    if targetServerId then
        local xTarget = ESX.GetPlayerFromId(targetServerId)
        if xTarget then
            targetIdentifier = xTarget.identifier
            targetName = xTarget.name
            targetGangName = GetGangName(xTarget)
            suspectName = targetName -- trust the real character name over free-typed text
        end
    end

    local function insertBooking()
        MySQL.Async.insert(
            'INSERT INTO doj_criminal_records (case_id, suspect_identifier, suspect_name, charges, fine, jail_minutes, booked_by, booked_by_name) VALUES (@case_id, @suspect_identifier, @suspect_name, @charges, @fine, @jail_minutes, @booked_by, @booked_by_name)',
            {
                ['@case_id']            = caseId,
                ['@suspect_identifier'] = targetIdentifier,
                ['@suspect_name']       = suspectName,
                ['@charges']            = charges,
                ['@fine']               = fine,
                ['@jail_minutes']       = jailMinutes,
                ['@booked_by']          = xPlayer.identifier,
                ['@booked_by_name']     = xPlayer.name,
            },
            function(recordId)
                if not recordId or recordId == 0 then return end
                TriggerClientEvent('esx:showNotification', _source, 'Bazdasht Sabt Shod', 'success')
                BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:recordsUpdated')
                BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:recordsUpdated')

                if targetIdentifier then
                    PushCadCitizenStatus(targetIdentifier, Config_cs.CadWantedLevels.arrested)
                    PushCadIncidentNote(
                        targetIdentifier, xPlayer.name,
                        'Bazdasht: ' .. charges .. ' | Jarime: $' .. fine .. ' | Zendan: ' .. jailMinutes .. ' daghighe'
                        .. (caseId and caseId ~= 0 and (' | Parvande #' .. caseId) or '')
                    )

                    if Config_cs.PrisonBreak.enabled and jailMinutes >= Config_cs.PrisonBreak.minJailMinutesToTrigger then
                        CS_StartPrisonerTransport(_source, targetIdentifier, suspectName, targetGangName, recordId)
                    end
                end

                TriggerEvent(
                    'DiscordBot:ToDiscord', 'rob', "Crime Scene",
                    "```css\n[Booking] : " .. suspectName ..
                    "\n[Charges] : " .. charges ..
                    "\n[Fine] : " .. fine ..
                    "\n[Jail] : " .. jailMinutes .. " min" ..
                    "\n[Officer] : " .. xPlayer.name .. "\n```",
                    'user', _source, true, false
                )
            end
        )
    end

    if not caseId or caseId == 0 then
        insertBooking()
        return
    end

    MySQL.Async.fetchAll('SELECT warrant_status FROM doj_cases WHERE id = @id', { ['@id'] = caseId }, function(rows)
        if not rows or not rows[1] or rows[1].warrant_status ~= 'approved' then
            TriggerClientEvent('esx:showNotification', _source, 'In Parvande Hokme Tayid Shode Nadarad', 'error')
            return
        end
        insertBooking()
    end)
end)

-- ============================================================
-- Criminal records -- shared "rap sheet" view for DOJ + Law Enforcement
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getRecords', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not (IsDOJJob(xPlayer.job.name) or IsLawEnforcementJob(xPlayer.job.name)) then
        cb({})
        return
    end

    MySQL.Async.fetchAll(
        'SELECT * FROM doj_criminal_records ORDER BY created_at DESC LIMIT 40',
        {},
        function(result) cb(result or {}) end
    )
end)

-- ============================================================
-- Leaderboard -- top investigators (DOJ) and top officers (Law)
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getLeaderboard', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not (IsDOJJob(xPlayer.job.name) or IsLawEnforcementJob(xPlayer.job.name)) then
        cb({ investigators = {}, officers = {} })
        return
    end

    MySQL.Async.fetchAll([[
        SELECT found_by_name AS name, COUNT(*) as score
        FROM doj_case_evidence
        WHERE found_by_name IS NOT NULL
        GROUP BY found_by_name
        ORDER BY score DESC
        LIMIT 10
    ]], {}, function(investigators)
        MySQL.Async.fetchAll([[
            SELECT booked_by_name AS name, COUNT(*) as score
            FROM doj_criminal_records
            WHERE booked_by_name IS NOT NULL
            GROUP BY booked_by_name
            ORDER BY score DESC
            LIMIT 10
        ]], {}, function(officers)
            cb({ investigators = investigators or {}, officers = officers or {} })
        end)
    end)
end)

-- ============================================================
-- Fingerprint database match
-- ============================================================
-- Cross-references the strong_lead codes found in THIS case against every
-- strong_lead ever collected server-wide. If the same code shows up at
-- least Config_cs.FingerprintMatchThreshold times, it's treated as a
-- confirmed match and the real current suspect name behind that case is
-- revealed as a note. This is the only place a real name ever gets
-- exposed, and only after real repeat investigative work.
RegisterServerEvent('CrimeScene:runFingerprintMatch')
AddEventHandler('CrimeScene:runFingerprintMatch', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.fetchAll(
        'SELECT DISTINCT suspect_hint_id FROM doj_case_evidence WHERE case_id = @id AND type = @type AND suspect_hint_id IS NOT NULL',
        { ['@id'] = caseId, ['@type'] = 'strong_lead' },
        function(hints)
            if not hints or #hints == 0 then
                TriggerClientEvent('esx:showNotification', _source, 'In Parvande Hich Sarnakhe Ghavi Nadarad', 'error')
                return
            end

            local hintId = hints[1].suspect_hint_id

            MySQL.Async.fetchAll(
                'SELECT COUNT(*) as hits FROM doj_case_evidence WHERE suspect_hint_id = @hint_id',
                { ['@hint_id'] = hintId },
                function(countRows)
                    local hits = countRows and countRows[1] and countRows[1].hits or 0

                    if hits < Config_cs.FingerprintMatchThreshold then
                        TriggerClientEvent('esx:showNotification', _source, 'Data Kafi Nist (' .. hits .. '/' .. Config_cs.FingerprintMatchThreshold .. '). Edame Bede Tahghigh.', 'error')
                        return
                    end

                    MySQL.Async.fetchAll(
                        'SELECT c.suspect_name, c.suspect_identifier FROM doj_cases c JOIN doj_case_evidence e ON e.case_id = c.id WHERE e.suspect_hint_id = @hint_id ORDER BY e.created_at DESC LIMIT 1',
                        { ['@hint_id'] = hintId },
                        function(matchRows)
                            local suspectName = matchRows and matchRows[1] and matchRows[1].suspect_name or 'Nashenakhte'
                            local suspectIdentifier = matchRows and matchRows[1] and matchRows[1].suspect_identifier or nil

                            MySQL.Async.execute(
                                'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
                                {
                                    ['@case_id']     = caseId,
                                    ['@author']      = 'SYSTEM',
                                    ['@author_name'] = 'Fingerprint DB',
                                    ['@note']        = 'MATCH PEIDA SHOD (' .. hits .. ' Sarnakh Motabegh): Fard Mashkook Ehtemalan ^2' .. suspectName .. '^0 Ast',
                                }
                            )

                            PushCadCitizenStatus(suspectIdentifier, Config_cs.CadWantedLevels.wanted)

                            TriggerClientEvent('esx:showNotification', _source, 'Match Peida Shod! Parvande Update Shod.', 'success')
                            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
                        end
                    )
                end
            )
        end
    )
end)

-- ============================================================
-- Wanted board -- repeat partial-code offenders across all cases
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getWantedBoard', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb({})
        return
    end

    MySQL.Async.fetchAll([[
        SELECT suspect_hint_id, COUNT(*) as hits, MAX(created_at) as last_seen
        FROM doj_case_evidence
        WHERE type = 'strong_lead' AND suspect_hint_id IS NOT NULL
        GROUP BY suspect_hint_id
        ORDER BY hits DESC
        LIMIT 15
    ]], {}, function(result)
        cb(result or {})
    end)
end)

-- ============================================================
-- Callbacks for the /cad panel
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getCases', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb({})
        return
    end

    if IsReferralJob(xPlayer.job.name) then
        MySQL.Async.fetchAll(
            "SELECT * FROM doj_cases WHERE archived_at IS NULL AND status IN ('open','cold', @refstatus) ORDER BY created_at DESC LIMIT 50",
            { ['@refstatus'] = 'referred_' .. xPlayer.job.name },
            function(result) cb(result or {}) end
        )
    else
        MySQL.Async.fetchAll(
            "SELECT * FROM doj_cases WHERE archived_at IS NULL AND status IN ('open','cold') ORDER BY created_at DESC LIMIT 50",
            {},
            function(result) cb(result or {}) end
        )
    end
end)

-- ============================================================
-- Cold case list / reopen / archive
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getColdCases', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb({})
        return
    end

    MySQL.Async.fetchAll(
        "SELECT * FROM doj_cases WHERE status = 'cold' ORDER BY (archived_at IS NULL) DESC, updated_at DESC LIMIT 50",
        {},
        function(result) cb(result or {}) end
    )
end)

-- Puts a cold case back to 'open' and, if the original scene coords are
-- still known, spawns a fresh set of evidence points there too -- so
-- reopening is a real second chance to investigate, not just a status flip.
RegisterServerEvent('CrimeScene:reopenCase')
AddEventHandler('CrimeScene:reopenCase', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.fetchAll('SELECT * FROM doj_cases WHERE id = @id AND status = @status', { ['@id'] = caseId, ['@status'] = 'cold' }, function(rows)
        local caseRow = rows and rows[1]
        if not caseRow then
            TriggerClientEvent('esx:showNotification', _source, 'In Parvande Sard Nist Ya Peida Nashod', 'error')
            return
        end

        MySQL.Async.execute(
            "UPDATE doj_cases SET status = 'open', archived_at = NULL WHERE id = @id",
            { ['@id'] = caseId }
        )
        MySQL.Async.execute(
            'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
            { ['@case_id'] = caseId, ['@author'] = 'SYSTEM', ['@author_name'] = xPlayer.name, ['@note'] = 'Parvande Dobare Baz Shod' }
        )

        if caseRow.coords_x and not ActiveScenes[caseId] then
            local coords = vector3(caseRow.coords_x, caseRow.coords_y, caseRow.coords_z)
            local points, pointsForClient = GenerateEvidencePoints(coords, caseRow.rob_family)

            ActiveScenes[caseId] = {
                robname            = caseRow.rob_name,
                family             = caseRow.rob_family,
                coords             = coords,
                plate              = nil,
                secured            = true, -- already investigated once, no need to re-secure
                suspectIdentifier  = caseRow.suspect_identifier,
                suspectName        = caseRow.suspect_name,
                accomplices        = {},
                points             = points,
                createdAt          = os.time(),
            }

            BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:sceneCreated', caseId, coords, pointsForClient, true)
            NotifyJobs(Config_cs.DOJJobs, 'Parvande #' .. caseId .. ' Dobare Baz Shod, Madarek Jadid Dar Sahne.', 'info')

            SetTimeout(Config_cs.SceneLifetimeMinutes * 60000, function()
                if ActiveScenes[caseId] then
                    ActiveScenes[caseId] = nil
                    BroadcastToJobs(Config_cs.DOJJobs, 'CrimeScene:sceneExpired', caseId)
                    MySQL.Async.execute(
                        "UPDATE doj_cases SET status = @newstatus WHERE id = @id AND status = @openstatus",
                        { ['@newstatus'] = 'cold', ['@id'] = caseId, ['@openstatus'] = 'open' }
                    )
                end
            end)
        end

        TriggerClientEvent('esx:showNotification', _source, 'Parvande Baz Shod', 'success')
        TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
    end)
end)

RegisterServerEvent('CrimeScene:archiveCase')
AddEventHandler('CrimeScene:archiveCase', function(caseId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then return end

    MySQL.Async.execute(
        "UPDATE doj_cases SET archived_at = NOW() WHERE id = @id AND status = 'cold' AND archived_at IS NULL",
        { ['@id'] = caseId },
        function(rowsChanged)
            if not rowsChanged or rowsChanged == 0 then
                TriggerClientEvent('esx:showNotification', _source, 'In Parvande Ghabele Archive Nist', 'error')
                return
            end
            MySQL.Async.execute(
                'INSERT INTO doj_case_notes (case_id, author, author_name, note) VALUES (@case_id, @author, @author_name, @note)',
                { ['@case_id'] = caseId, ['@author'] = 'SYSTEM', ['@author_name'] = xPlayer.name, ['@note'] = 'Parvande Archive Shod' }
            )
            TriggerClientEvent('esx:showNotification', _source, 'Parvande Archive Shod', 'success')
            TriggerClientEvent('CrimeScene:refreshCase', _source, caseId)
        end
    )
end)

-- Auto-archive cold cases nobody's touched in a while.
CreateThread(function()
    while true do
        Wait(Config_cs.ColdCaseSweepIntervalMinutes * 60000)
        MySQL.Async.execute(
            "UPDATE doj_cases SET archived_at = NOW() WHERE status = 'cold' AND archived_at IS NULL AND updated_at < DATE_SUB(NOW(), INTERVAL @days DAY)",
            { ['@days'] = Config_cs.ColdCaseAutoArchiveDays }
        )
    end
end)

-- ============================================================
-- Case detail
-- ============================================================

ESX.RegisterServerCallback('CrimeScene:getCaseDetail', function(source, cb, caseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsDOJJob(xPlayer.job.name) then
        cb(nil)
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM doj_cases WHERE id = @id', { ['@id'] = caseId }, function(caseRows)
        if not caseRows or not caseRows[1] then
            cb(nil)
            return
        end

        MySQL.Async.fetchAll('SELECT * FROM doj_case_evidence WHERE case_id = @id ORDER BY created_at ASC', { ['@id'] = caseId }, function(evidence)
            MySQL.Async.fetchAll('SELECT * FROM doj_case_notes WHERE case_id = @id ORDER BY created_at ASC', { ['@id'] = caseId }, function(notes)
                MySQL.Async.fetchAll('SELECT suspect_name, role FROM doj_case_suspects WHERE case_id = @id ORDER BY role DESC, created_at ASC', { ['@id'] = caseId }, function(suspects)
                    cb({ case = caseRows[1], evidence = evidence or {}, notes = notes or {}, suspects = suspects or {} })
                end)
            end)
        end)
    end)
end)

-- ============================================================
-- Prisoner Transport / Prison Break
-- ============================================================
-- Triggered from createBooking above when a booking has real jail time and
-- is linked to a real online player. The escorting officer's client spawns
-- a physical van + prisoner ped and has to drive it to the prison; the
-- suspect's gang (if any, per GuessGangJob) gets a real window to fight
-- their way to a disabled van and free them with /freeprisoner.
-- Global (not local) on purpose: it's called from createBooking's callback
-- above, which runs after this whole file has already loaded, so a plain
-- global lookup at call time is safe -- same pattern this file already
-- uses for GetPlayers()-style helpers.

local ActiveTransports = {} -- [transportId] = { officerSource, suspectIdentifier, suspectName, gangName, recordId, status, lastCoords, lastEngineHealth }
local NextTransportId = 0

function CS_FinishTransport(transportId, outcome)
    local t = ActiveTransports[transportId]
    if not t or t.status ~= 'enroute' then return end
    t.status = outcome

    TriggerClientEvent('CrimeScene:transportEnded', -1, transportId, outcome)

    if outcome == 'delivered' then
        PushCadCitizenStatus(t.suspectIdentifier, Config_cs.CadWantedLevels.in_prison)
        NotifyJobs(Config_cs.LawEnforcementJobs, 'Zendani ^2' .. t.suspectName .. '^0 Ba Movafaghiat Be Zendan Resid.', 'success')
        MySQL.Async.execute(
            'INSERT INTO doj_case_notes (case_id, author, author_name, note) SELECT case_id, "SYSTEM", "Prisoner Transport", @note FROM doj_criminal_records WHERE id = @id AND case_id IS NOT NULL',
            { ['@id'] = t.recordId, ['@note'] = 'Enteghal Movafagh - Zendani Be Zendan Resid' }
        )
    elseif outcome == 'rescued' then
        PushCadCitizenStatus(t.suspectIdentifier, Config_cs.CadWantedLevels.wanted)
        NotifyJobs(Config_cs.LawEnforcementJobs, 'Zendani ^1' .. t.suspectName .. '^0 Tavasote Hamdastanash Azad Shod!', 'error')
        if t.gangName then
            NotifyGang(t.gangName, 'Hamdastetun ^2' .. t.suspectName .. '^0 Azad Shod!', 'success')
        end
        MySQL.Async.execute('UPDATE doj_criminal_records SET jail_minutes = 0 WHERE id = @id', { ['@id'] = t.recordId })
        MySQL.Async.execute(
            'INSERT INTO doj_case_notes (case_id, author, author_name, note) SELECT case_id, "SYSTEM", "Prisoner Transport", @note FROM doj_criminal_records WHERE id = @id AND case_id IS NOT NULL',
            { ['@id'] = t.recordId, ['@note'] = 'FARAR: Zendani Hangame Enteghal Tavasote Hamdastan Azad Shod' }
        )
    end

    SetTimeout(60000, function() ActiveTransports[transportId] = nil end)
end

function CS_StartPrisonerTransport(officerSource, suspectIdentifier, suspectName, gangName, recordId)
    local officerPed = GetPlayerPed(officerSource)
    if not officerPed or officerPed == 0 then return end

    NextTransportId = NextTransportId + 1
    local transportId = NextTransportId
    local startCoords = GetEntityCoords(officerPed)

    ActiveTransports[transportId] = {
        officerSource     = officerSource,
        suspectIdentifier = suspectIdentifier,
        suspectName       = suspectName,
        gangName          = gangName,
        recordId          = recordId,
        status            = 'enroute',
        lastCoords        = startCoords,
        lastEngineHealth  = 1000.0,
    }

    TriggerClientEvent('CrimeScene:startPrisonTransport', officerSource, transportId, startCoords, Config_cs.PrisonBreak.prisonCoords, suspectName)
    BroadcastToJobs(Config_cs.LawEnforcementJobs, 'CrimeScene:transportAlert', transportId, startCoords, Config_cs.PrisonBreak.prisonCoords, suspectName)
    NotifyJobs(Config_cs.LawEnforcementJobs, 'Enteghale Zendani ^2' .. suspectName .. '^0 Shoro Shod - Eskort Konid!', 'info')

    if gangName then
        BroadcastToGang(gangName, 'CrimeScene:transportAlert', transportId, startCoords, Config_cs.PrisonBreak.prisonCoords, suspectName)
        NotifyGang(gangName, 'Hamdaste Shoma ^1' .. suspectName .. '^0 Dare Montaghel Mishe Zendan! Vaghte Nejat Kame!', 'error')
    end

    SetTimeout(Config_cs.PrisonBreak.windowSeconds * 1000, function()
        CS_FinishTransport(transportId, 'delivered')
    end)
end

-- Officer's client reports the van's position/health every few seconds so
-- the server has something to validate /freeprisoner against without
-- needing a direct entity reference (entities aren't shared across the
-- client/server boundary the same way).
RegisterServerEvent('CrimeScene:transportTick')
AddEventHandler('CrimeScene:transportTick', function(transportId, coords, engineHealth)
    local _source = source
    local t = ActiveTransports[transportId]
    if not t or t.officerSource ~= _source or t.status ~= 'enroute' then return end
    t.lastCoords = coords
    t.lastEngineHealth = engineHealth
end)

RegisterServerEvent('CrimeScene:reportTransportArrived')
AddEventHandler('CrimeScene:reportTransportArrived', function(transportId)
    local _source = source
    local t = ActiveTransports[transportId]
    if not t or t.officerSource ~= _source then return end
    CS_FinishTransport(transportId, 'delivered')
end)

RegisterCommand('freeprisoner', function(source, args)
    local transportId = tonumber(args[1])
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not transportId then return end

    local t = ActiveTransports[transportId]
    if not t or t.status ~= 'enroute' then
        TriggerClientEvent('esx:showNotification', source, 'In Enteghal Digar Faal Nist', 'error')
        return
    end

    if not t.gangName or not xPlayer.gang or xPlayer.gang.name ~= t.gangName then
        TriggerClientEvent('esx:showNotification', source, 'Shoma Dastresi Nadarid', 'error')
        return
    end

    if t.lastEngineHealth > Config_cs.PrisonBreak.engineHealthDisabledThreshold then
        TriggerClientEvent('esx:showNotification', source, 'Avval Bayad Van Ra Az Kar Bendazid', 'error')
        return
    end

    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    if #(pCoords - t.lastCoords) > Config_cs.PrisonBreak.freeDistance then
        TriggerClientEvent('esx:showNotification', source, 'Shoma Be Van Nazdik Nistid', 'error')
        return
    end

    CS_FinishTransport(transportId, 'rescued')
end, false)

-- Safety net: if the escorting officer disconnects mid-transport, don't
-- leave it stuck forever -- give benefit of the doubt and close it out.
AddEventHandler('esx:playerDropped', function(playerId)
    for transportId, t in pairs(ActiveTransports) do
        if t.officerSource == playerId and t.status == 'enroute' then
            CS_FinishTransport(transportId, 'delivered')
        end
    end
end)

-- ============================================================
-- Internal Affairs -- CIA/FBI/Judge review misconduct reports filed by
-- anyone in DOJ or Law Enforcement who witnessed something.
-- ============================================================

local function IsIAReporterJob(job)
    for i = 1, #Config_cs.IAReporterJobs do
        if Config_cs.IAReporterJobs[i] == job then return true end
    end
    return false
end

local function IsIAReviewerJob(job)
    for i = 1, #Config_cs.IAReviewerJobs do
        if Config_cs.IAReviewerJobs[i] == job then return true end
    end
    return false
end

-- Recent booking activity, as a browsable "what has this officer been
-- doing" feed reviewers can check before deciding whether to file/pursue
-- a report -- this is what "review sensitive actions" means in practice,
-- since there's no separate use-of-force logging system to hook into.
ESX.RegisterServerCallback('CrimeScene:getOfficerActivity', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsIAReviewerJob(xPlayer.job.name) then
        cb({})
        return
    end

    MySQL.Async.fetchAll(
        'SELECT suspect_name, charges, fine, jail_minutes, booked_by_name, created_at FROM doj_criminal_records ORDER BY created_at DESC LIMIT 30',
        {},
        function(result) cb(result or {}) end
    )
end)

RegisterServerEvent('CrimeScene:fileIAReport')
AddEventHandler('CrimeScene:fileIAReport', function(targetName, targetJob, category, description)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsIAReporterJob(xPlayer.job.name) then return end

    if not targetName or targetName == '' or not description or description == '' then
        TriggerClientEvent('esx:showNotification', _source, 'Esme Fard Va Tozihat Alzami Ast', 'error')
        return
    end

    local validCategory = false
    for i = 1, #Config_cs.IACategories do
        if Config_cs.IACategories[i] == category then validCategory = true break end
    end
    if not validCategory then category = 'other' end

    MySQL.Async.insert(
        'INSERT INTO doj_ia_reports (target_name, target_job, category, description, filed_by, filed_by_name) VALUES (@target_name, @target_job, @category, @description, @filed_by, @filed_by_name)',
        {
            ['@target_name']    = targetName,
            ['@target_job']     = targetJob,
            ['@category']       = category,
            ['@description']    = description,
            ['@filed_by']       = xPlayer.identifier,
            ['@filed_by_name']  = xPlayer.name,
        },
        function(reportId)
            if not reportId or reportId == 0 then return end
            TriggerClientEvent('esx:showNotification', _source, 'Gozaresh Sabt Shod', 'success')
            NotifyJobs(Config_cs.IAReviewerJobs, 'Gozareshe Jadide Bazrasi Dakheli Sabt Shod.', 'info')
        end
    )
end)

ESX.RegisterServerCallback('CrimeScene:getIAReports', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsIAReviewerJob(xPlayer.job.name) then
        cb({})
        return
    end

    MySQL.Async.fetchAll(
        "SELECT * FROM doj_ia_reports ORDER BY status = 'open' DESC, created_at DESC LIMIT 50",
        {},
        function(result) cb(result or {}) end
    )
end)

RegisterServerEvent('CrimeScene:closeIAReport')
AddEventHandler('CrimeScene:closeIAReport', function(reportId, outcome, verdict)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or not IsIAReviewerJob(xPlayer.job.name) then return end
    if outcome ~= 'cleared' and outcome ~= 'disciplined' then return end

    MySQL.Async.fetchAll('SELECT filed_by FROM doj_ia_reports WHERE id = @id AND status = @status', { ['@id'] = reportId, ['@status'] = 'open' }, function(rows)
        local reportRow = rows and rows[1]
        if not reportRow then
            TriggerClientEvent('esx:showNotification', _source, 'In Gozaresh Peida Nashod Ya Ghablan Baste Shode', 'error')
            return
        end
        if reportRow.filed_by == xPlayer.identifier then
            TriggerClientEvent('esx:showNotification', _source, 'Gozareshe Khodetun Ra Nemitoonid Barresi Konid', 'error')
            return
        end

        MySQL.Async.execute(
            'UPDATE doj_ia_reports SET status = @status, verdict = @verdict, reviewed_by_name = @reviewer WHERE id = @id',
            { ['@status'] = outcome, ['@verdict'] = verdict, ['@reviewer'] = xPlayer.name, ['@id'] = reportId }
        )
        TriggerClientEvent('esx:showNotification', _source, 'Gozaresh Baste Shod', 'success')
    end)
end)
