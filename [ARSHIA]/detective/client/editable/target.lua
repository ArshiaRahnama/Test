function AddPedToTargetting(ped)
    if not (Config.target.enabled and Config.target.system) then return end

    local system = Config.target.system
    local options = {
        {
            type = "client",
            event = "kq_detective:investigate",
            icon = "fas fa-user-injured",
            label = L('Investigate'),
            canInteract = function(entity)
                return IsEntityDead(entity)
            end,
        },
    }

    -- Forensic evidence only ever exists on murdered PLAYERS (see server/forensics.lua) —
    -- NPCs never generate a fingerprint or shell casing record, so these options are
    -- restricted to player peds. Whether evidence actually exists is still checked
    -- server-side; if the roll didn't produce anything the officer just gets a
    -- "nothing found" notification instead of an item.
    if Config.forensics.enabled then
        table.insert(options, {
            type = "client",
            event = "kq_detective:collectPrint",
            icon = "fas fa-fingerprint",
            label = L('Collect fingerprint'),
            canInteract = function(entity)
                return IsPedAPlayer(entity) and IsEntityDead(entity)
            end,
        })
        table.insert(options, {
            type = "client",
            event = "kq_detective:collectCasing",
            icon = "fas fa-crosshairs",
            label = L('Collect shell casing'),
            canInteract = function(entity)
                return IsPedAPlayer(entity) and IsEntityDead(entity)
            end,
        })
    end

    -- NPC-only (see config.lua's Config.cleanup comment for why).
    if Config.cleanup.enabled then
        table.insert(options, {
            type = "client",
            event = "kq_detective:collectBody",
            icon = "fas fa-truck-medical",
            label = L('Collect body'),
            canInteract = function(entity)
                return IsEntityDead(entity) and not IsPedAPlayer(entity) and Contains(Config.cleanup.jobs, playerJob)
            end,
        })
    end

    exports[system]:AddTargetEntity(ped, {
        options = options,
        distance = 1.75
    })
end
