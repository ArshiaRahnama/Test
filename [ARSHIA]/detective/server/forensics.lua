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
        officer spends a Kit Azmayeshi to analyze it. It does not persist
        across a resource restart — acceptable for a same-session detective
        workflow; say if you want it durable across restarts instead and it
        can be moved into a small table.
      * Requires the `evidence_print`, `evidence_casing` and `kit_azmayeshi`
        items to exist in your `items` table — see
        sql/kq_detective_forensics.sql.
]]

local nextCaseId = 1
local cases = {}          -- [caseId] = { kind, identifier, code, serial }
local officerCases = {}   -- [officerSource] = { caseId, caseId, ... } (most recent last)

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

function SendKQDetectiveLog(title, description, color)
    if not Config.discordWebhook or Config.discordWebhook == '' or Config.discordWebhook == 'WEBHOOK_LINK_HERE' then
        return
    end

    PerformHttpRequest(Config.discordWebhook, function() end, 'POST', json.encode({
        username = 'KQ Detective',
        embeds = {
            {
                title = title,
                description = description,
                color = color or 3447003,
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

-- Called from server.lua right when a player's death is recorded.
-- killerServerId may be nil (suicide, environment, fall damage, etc).
-- cause is the raw weapon hash from GetPedCauseOfDeath (may be a non-weapon cause).
function KQ_RollForensics(victimSrc, killerServerId, cause)
    local result = { hasPrint = false, hasCasing = false, serial = nil }

    if not Config.forensics.enabled then return result end
    if not killerServerId or killerServerId <= 0 then return result end
    if not ESX then return result end

    local xKiller = ESX.GetPlayerFromId(killerServerId)
    if not xKiller then return result end

    if math.random(100) <= Config.forensics.printChance then
        result.hasPrint = true
        result.printIdentifier = xKiller.identifier
    end

    if cause and cause ~= 0 then
        local weaponData = ESX.GetWeaponFromHash(cause)

        if weaponData and math.random(100) <= Config.forensics.casingChance then
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

RegisterServerEvent('kq_detective:collectEvidence')
AddEventHandler('kq_detective:collectEvidence', function(victimSrc, kind)
    local officer = source
    local xOfficer = ESX.GetPlayerFromId(officer)
    if not xOfficer or not Contains(Config.whitelist.jobs, xOfficer.job.name) then return end

    local info = playerDeathInfo[victimSrc]
    local f = info and info.forensics
    if not f then return end

    local caseId
    if kind == 'print' and f.hasPrint and not f.printCollected then
        f.printCollected = true
        caseId = nextCaseId
        nextCaseId = nextCaseId + 1

        cases[caseId] = {
            kind = 'print',
            identifier = f.printIdentifier,
            code = ShortPrintCode(f.printIdentifier),
        }

        xOfficer.addInventoryItem(Config.forensics.printItem, 1)
        TriggerClientEvent('esx:showNotification', officer, ('%s (#%d)'):format(L2('Fingerprint collected'), caseId))
    elseif kind == 'casing' and f.hasCasing and not f.casingCollected then
        f.casingCollected = true
        caseId = nextCaseId
        nextCaseId = nextCaseId + 1

        cases[caseId] = {
            kind = 'casing',
            identifier = f.casingIdentifier,
            serial = f.serial,
        }

        xOfficer.addInventoryItem(Config.forensics.casingItem, 1)
        TriggerClientEvent('esx:showNotification', officer, ('%s: %s (#%d)'):format(L2('Shell casing collected'), f.serial, caseId))
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

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    -- Registered here (not at top level) so we never call this before ESX
    -- actually exists — RegisterUsableItem would error on a nil ESX otherwise.
    ESX.RegisterUsableItem(Config.forensics.kitItem, function(source)
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

        xOfficer.removeInventoryItem(Config.forensics.kitItem, 1)

        MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @id', {
            ['@id'] = case.identifier
        }, function(rows)
            local suspectName = (rows[1] and rows[1].firstname and (rows[1].firstname .. ' ' .. rows[1].lastname)) or 'Unknown'

            if case.kind == 'print' then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { '[Forensics]', ('%s matched to: %s'):format(case.code, suspectName) }
                })
            else
                TriggerClientEvent('chat:addMessage', source, {
                    args = { '[Forensics]', ('Serial %s traced to: %s'):format(case.serial, suspectName) }
                })
            end

            SendKQDetectiveLog('Forensic match found',
                ('Case #%d (%s) matched to **%s** (%s)'):format(caseId, case.kind, suspectName, case.identifier),
                15158332)
        end)
    end)

    --[[
        SOLO TEST COMMAND — only exists while Config.debug = true.
        Real forensics need an actual PvP kill (another player as the
        "killer"), which you don't have when testing alone. This creates a
        fake print case AND a fake casing case tied to YOUR OWN identifier,
        gives you the matching items, so you can run the full
        collect -> analyze -> reveal chain solo and confirm it points back
        at your own character. Remove/disable before going live.
    ]]
    if Config.debug then
        RegisterCommand('kqtestforensics', function(source)
            if source == 0 then return end -- console can't hold items

            local xOfficer = ESX.GetPlayerFromId(source)
            if not xOfficer then return end

            local printCaseId = nextCaseId
            nextCaseId = nextCaseId + 1
            cases[printCaseId] = {
                kind = 'print',
                identifier = xOfficer.identifier,
                code = ShortPrintCode(xOfficer.identifier),
            }

            local casingCaseId = nextCaseId
            nextCaseId = nextCaseId + 1
            cases[casingCaseId] = {
                kind = 'casing',
                identifier = xOfficer.identifier,
                serial = 'TEST-00000-0001',
            }

            officerCases[source] = officerCases[source] or {}
            table.insert(officerCases[source], printCaseId)
            table.insert(officerCases[source], casingCaseId)

            xOfficer.addInventoryItem(Config.forensics.printItem, 1)
            xOfficer.addInventoryItem(Config.forensics.casingItem, 1)
            xOfficer.addInventoryItem(Config.forensics.kitItem, 2)

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
