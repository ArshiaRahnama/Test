--[[
    kq_detective — forensics extension (fingerprints, ballistics, autopsy).

    All the "truth" (who the killer actually was) lives server-side in
    server/forensics.lua — this file only ever asks the server whether
    evidence exists at a given ped and reports collection attempts; it
    never receives or stores a suspect's identifier itself.
]]

RegisterNetEvent('kq_detective:collectPrint')
AddEventHandler('kq_detective:collectPrint', function(data)
    if not CanInvestigate() then return end

    local serverId = GetPlayerServerIdFromPed(data.entity)
    if serverId then
        TriggerServerEvent('kq_detective:collectEvidence', serverId, 'print')
    end
end)

RegisterNetEvent('kq_detective:collectCasing')
AddEventHandler('kq_detective:collectCasing', function(data)
    if not CanInvestigate() then return end

    local serverId = GetPlayerServerIdFromPed(data.entity)
    if serverId then
        TriggerServerEvent('kq_detective:collectEvidence', serverId, 'casing')
    end
end)

-- Runs Config.autopsy.stages in sequence via mythic_progbar (same
-- 'mythic_progbar:client:progress' pattern used across esx_uniquejobs, e.g.
-- client/doa_main.lua). If every stage completes, reveals the exact shot
-- distance + precise time of death in chat, then calls onDone(). Cancelling
-- any stage skips straight to onDone() with no extra reveal.
function RunAutopsyMinigame(distance, sinceDeath, onDone)
    local stages = Config.autopsy.stages
    local index = 1

    local function NextStage()
        local stage = stages[index]

        if not stage then
            local seconds = math.floor(sinceDeath / 1000)
            TriggerEvent('chat:addMessage', {
                args = {
                    '[Autopsy]',
                    ('%s: %ds | %s: %.1fm'):format(
                        L('Exact time of death'), seconds,
                        L('Shot distance'), distance
                    )
                }
            })
            onDone()
            return
        end

        TriggerEvent('mythic_progbar:client:progress', {
            name = 'kq_detective_autopsy_' .. index,
            duration = stage.duration,
            label = stage.label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if status then
                index = index + 1
                NextStage()
            else
                onDone()
            end
        end)
    end

    NextStage()
end

--[[
    SOLO TEST COMMANDS — only registered while Config.debug = true.
    These don't touch forensics truth data (that needs a real PvP kill,
    see server/forensics.lua's 'kqtestforensics'); they just let you check
    the base Investigate/target/notepad flow and the autopsy minigame
    without needing a second player at all. Remove/disable before going live.
]]
if Config.debug then
    RegisterCommand('kqtestcorpse', function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local forward = GetEntityForwardVector(ped)
        local spawnCoords = coords + forward * 2.0

        local model = GetHashKey('a_m_m_skater_01')
        RequestModel(model)
        local attempts = 0
        while not HasModelLoaded(model) and attempts < 100 do
            Citizen.Wait(10)
            attempts = attempts + 1
        end

        if not HasModelLoaded(model) then
            TriggerEvent('chat:addMessage', { args = { '[KQ TEST]', 'Model failed to load, try again.' } })
            return
        end

        local corpse = CreatePed(4, model, spawnCoords.x, spawnCoords.y, spawnCoords.z - 1.0, 0.0, true, false)
        SetEntityHealth(corpse, 0)
        SetEntityAsMissionEntity(corpse, true, true)
        SetModelAsNoLongerNeeded(model)

        TriggerEvent('chat:addMessage', {
            args = { '[KQ TEST]', 'Dead NPC spawned in front of you. Target it within a few seconds (basic Investigate only — NPCs never carry forensics).' }
        })
    end, false)

    RegisterCommand('kqtestautopsy', function()
        TriggerEvent('chat:addMessage', { args = { '[KQ TEST]', 'Running the autopsy minigame with fake data...' } })

        RunAutopsyMinigame(14.7, 187000, function()
            TriggerEvent('chat:addMessage', { args = { '[KQ TEST]', 'Autopsy minigame finished.' } })
        end)
    end, false)
end
