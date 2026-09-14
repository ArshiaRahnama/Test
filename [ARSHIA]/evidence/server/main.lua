ESX = nil

local shots = {}
local blood = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

ESX.RegisterServerCallback(
    "evidence:getData",
    function(source, cb)
        cb({shots = shots, blood = blood, time = os.time()})
    end
)

ESX.RegisterServerCallback(
    "evidence:getStorageData",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM `evidence_storage` ORDER BY `id` DESC",
            {},
            function(reports)
                cb(reports)
            end
        )
    end
)

RegisterServerEvent("evidence:deleteEvidenceFromStorage")
AddEventHandler(
    "evidence:deleteEvidenceFromStorage",
    function(id)
        MySQL.Sync.execute(
            "DELETE FROM `evidence_storage` WHERE id = @id",
            {
                ["@id"] = id
            }
        )
    end
)

-- UPDATE V3: was a fire-and-forget event; now a callback that inserts the row AND
-- hands back its real case number, officer name and timestamp (all from the DB, not
-- guessed client-side) so the report screen can show accurate case-file metadata
-- the instant it's filed.
ESX.RegisterServerCallback(
    "evidence:submitReport",
    function(source, cb, evidence)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        -- xPlayer.getName() (essentialmode/server/classes/player.lua) is this server's
        -- reliable in-game display name; there's no live firstname/lastname field on
        -- the player object to pull from instead.
        local officerName = (xPlayer and xPlayer.getName()) or ('Officer #' .. src)

        MySQL.Async.insert(
            "INSERT INTO `evidence_storage`(`data`, `analyzed_by`, `created_at`) VALUES (@evidence, @officer, NOW())",
            {
                ["@evidence"] = evidence,
                ["@officer"] = officerName
            },
            function(insertId)
                MySQL.Async.fetchAll(
                    "SELECT `id`, `analyzed_by`, `created_at` FROM `evidence_storage` WHERE `id` = @id",
                    {["@id"] = insertId},
                    function(rows)
                        cb(rows[1])
                    end
                )
            end
        )
    end
)

RegisterServerEvent("evidence:removeEverything")
AddEventHandler(
    "evidence:removeEverything",
    function()
        for k, v in pairs(blood) do
            if v.interior == 0 then
                blood[k] = nil
            end
        end
        for k, v in pairs(shots) do
            if v.interior == 0 then
                shots[k] = nil
            end
        end
    end
)

RegisterServerEvent("evidence:removeBlood")
AddEventHandler(
    "evidence:removeBlood",
    function(identifier)
        blood[identifier] = nil
    end
)

RegisterServerEvent("evidence:removeShot")
AddEventHandler(
    "evidence:removeShot",
    function(identifier)
        shots[identifier] = nil
    end
)

RegisterServerEvent("evidence:LastInCar")
AddEventHandler(
    "evidence:LastInCar",
    function(id)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(id)
        local xPlayer = ESX.GetPlayerFromId(NetworkGetEntityOwner(entity))
       
        if xPlayer ~= nil then
            if NetworkGetEntityOwner(entity) ~= src then
                MySQL.Async.fetchAll(
                    "SELECT " ..
                        Config.EvidenceReportInformationFingerprint .. " FROM `users` WHERE identifier = @owner LIMIT 1",
                    {
                        ["@owner"] = xPlayer.identifier
                    },
                    function(reportInfo)
                        TriggerClientEvent("evidence:addFingerPrint", src, reportInfo[1])
                    end
                )
            else
                TriggerClientEvent("evidence:SendTextMessage", src, Config.Text["no_fingerprints_found"])
            end
        else
            TriggerClientEvent("evidence:SendTextMessage", src, Config.Text["no_fingerprints_found"])
        end
    end
)

RegisterServerEvent("evidence:saveBlood")
AddEventHandler(
    "evidence:saveBlood",
    function(coords, interior)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        MySQL.Async.fetchAll(
            "SELECT " .. Config.EvidenceReportInformationBlood .. " FROM `users` WHERE identifier = @owner LIMIT 1",
            {
                ["@owner"] = xPlayer.identifier
            },
            function(reportInfo)
                local time = os.time()
                blood[time] = {coords = coords, reportInfo = reportInfo[1], interior = interior}
            end
        )
    end
)

-- UPDATE V3: server-side export so other resources (shooting range, training academy,
-- admin tools, etc.) can toggle whether a specific player's shots leave evidence.
-- Example: exports['evidence']:SetIgnoreBullets(source, true)
exports(
    "SetIgnoreBullets",
    function(target, value)
        TriggerClientEvent("evidence:unmarkedBullets", target, value)
    end
)

ESX.RegisterUsableItem(
    "uvlight",
    function(playerId)
        TriggerClientEvent("evidence:checkForFingerprints", playerId)
    end
)

RegisterServerEvent("evidence:saveShot")
AddEventHandler(
    "evidence:saveShot",
    function(coords, bullet, interior)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        MySQL.Async.fetchAll(
            "SELECT " .. Config.EvidenceReportInformationBullet .. " FROM `users` WHERE identifier = @owner LIMIT 1",
            {
                ["@owner"] = xPlayer.identifier
            },
            function(reportInfo)
                local time = os.time()
                shots[time] = {coords = coords, bullet = bullet, reportInfo = reportInfo[1], interior = interior}
            end
        )
    end
)

--[[
    UPDATE V4 — /evidencetest
    Lets you test the whole flow alone: sets your job to fbi grade 6 (so you pass
    Config.JobRequired/JobGradeRequired), gives you a uvlight, then tells the client
    to drop a blood + bullet-shell pair right at your feet. Gated behind Config.Debug
    the same way esx_uniquejobs/detective gates its own kqtest* commands — set
    Config.Debug = false (or delete this block) before going live.
]]
if Config.Debug then
    RegisterCommand(
        "evidencetest",
        function(source)
            if source == 0 then
                return
            end -- console has no job/inventory to give

            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then
                return
            end

            xPlayer.setJob("fbi", 6)
            xPlayer.addInventoryItem("uvlight", 1)

            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {
                        "[EVIDENCE TEST]",
                        "Job set to FBI (grade 6) and gave you a UV Light. Spawning a blood + bullet-shell pair at your feet..."
                    }
                }
            )

            TriggerClientEvent("evidence:spawnTestEvidence", source)
        end,
        false
    )
end
