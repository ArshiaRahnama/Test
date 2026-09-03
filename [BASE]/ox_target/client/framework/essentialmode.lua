-- essentialmode framework adapter (this server runs essentialmode, not
-- es_extended/ox_core/qbx_core/ND_Core -- none of the bundled framework
-- adapters in this folder ever matched, so utils.hasPlayerGotGroup()
-- was permanently stuck on its stub (always returning true, see
-- client/utils.lua) and job/gang-restricted target options never
-- actually filtered by group. This fills that in properly.
--
-- Uses the same retry-based esx:getSharedObject event lookup as every
-- other client script across this server (essentialmode/client/main.lua
-- and ~150 other files) instead of an export call, since a single
-- export call at load time can race essentialmode's own startup.
local ESX
while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
end

local utils = require 'client.utils'
-- essentialmode tracks 'job' and 'gang' (not 'job'/'job2' like
-- es_extended) -- see essentialmode/server/classes/player.lua.
local groups = { 'job', 'gang' }
local playerGroups = {}

local function setPlayerData(playerData)
    table.wipe(playerGroups)

    for i = 1, #groups do
        local group = groups[i]
        local data = playerData[group]

        if data then
            playerGroups[group] = data
        end
    end
end

if ESX.PlayerLoaded then
    setPlayerData(ESX.PlayerData)
end

RegisterNetEvent('esx:playerLoaded', function(data)
    if source == '' then return end
    setPlayerData(data)
end)

RegisterNetEvent('esx:setJob', function(job)
    if source == '' then return end
    playerGroups.job = job
end)

-- Fired by Unique_ALLGangs (Config.DefaultEvents['setGang'], see its
-- Config.lua) whenever the player's gang or gang grade changes --
-- essentialmode itself has no client-side gang sync event of its own,
-- only a static ESX.PlayerData.gang set once at login.
RegisterNetEvent('esx:setGang', function(gang)
    if source == '' then return end
    playerGroups.gang = gang
end)

---@diagnostic disable-next-line: duplicate-set-field
function utils.hasPlayerGotGroup(filter)
    local _type = type(filter)
    for i = 1, #groups do
        local group = groups[i]
        local data = playerGroups[group]

        if not data then goto continue end

        if _type == 'string' then
            if filter == data.name then
                return true
            end
        elseif _type == 'table' then
            local tabletype = table.type(filter)

            if tabletype == 'hash' then
                for name, grade in pairs(filter) do
                    if data.name == name and grade <= data.grade then
                        return true
                    end
                end
            elseif tabletype == 'array' then
                for j = 1, #filter do
                    if data.name == filter[j] then
                        return true
                    end
                end
            end
        end

        ::continue::
    end

    return false
end
