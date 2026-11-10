-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()

local adminCache = { candidates = {}, title = '' }
local hasActiveElection = false
local nuiOpen = false

RegisterNetEvent('sunset_vote:statusUpdate', function(status)
    hasActiveElection = status
end)

local function OpenNUI(action, payload)
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = action,
        payload = payload or {},
    })
end

local function CloseNUI()
    nuiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(_, cb)
    CloseNUI()
    cb('ok')
end)

RegisterNUICallback('cacheCandidates', function(data, cb)
    if data then
        adminCache.candidates = data.candidates or {}
        adminCache.title = data.title or ''
    end
    cb('ok')
end)

RegisterCommand('vat', function()
    ESX.TriggerServerCallback('sunset_vote:getData', function(result)
        if not result then return end
        if not result.active then
            return ESX.notification('error', VoteConfig.Notify.noElection)
        end
        local electionList = result.elections or {}
        if #electionList == 0 then
            return ESX.notification('error', VoteConfig.Notify.noElection)
        end
        OpenNUI('openVotePanel', { elections = electionList })
    end)
end, false)

RegisterNUICallback('submitVote', function(data, cb)
    if data and data.electionId and data.code then
        ESX.TriggerServerEvent('sunset_vote:submitVote', {
            electionId = data.electionId,
            code = tostring(data.code),
        })
    end
    cb('ok')
end)

RegisterNUICallback('closeAfterVote', function(_, cb)
    CloseNUI()
    cb('ok')
end)

RegisterNetEvent('sunset_vote:openAdminMenu', function()
    if ESX.GetPlayerData().permission_level < VoteConfig.AdminPermissionLevel then return end
    OpenNUI('openAdminPanel', { cachedCandidates = adminCache })
end)

RegisterNetEvent('sunset_vote:showStats', function(allElections)
    OpenNUI('openStatsPanel', { elections = allElections or {} })
end)

RegisterNUICallback('getGangList', function(_, cb)
    ESX.TriggerServerCallback('sunset_vote:getGangList', function(gangList)
        cb(gangList or {})
    end)
end)

RegisterNUICallback('getJobList', function(_, cb)
    ESX.TriggerServerCallback('sunset_vote:getJobList', function(jobList)
        cb(jobList or {})
    end)
end)

RegisterNUICallback('createElection', function(data, cb)
    if not data or not data.candidates or not data.startTimestamp or not data.endTimestamp then
        cb('error')
        return
    end
    adminCache = { candidates = {}, title = '' }
    ESX.TriggerServerEvent('sunset_vote:createElection', {
        title = data.title or '',
        candidates = data.candidates,
        startTimestamp = tonumber(data.startTimestamp),
        endTimestamp = tonumber(data.endTimestamp),
    })
    CloseNUI()
    cb('ok')
end)

RegisterNUICallback('toggleElection', function(data, cb)
    local electionId = data and data.electionId or nil
    if electionId then
        ESX.TriggerServerEvent('sunset_vote:toggleElection', electionId)
    end
    CloseNUI()
    cb('ok')
end)

RegisterNUICallback('wipeElection', function(data, cb)
    local electionId = data and data.electionId or nil
    if electionId then
        ESX.TriggerServerEvent('sunset_vote:wipeElection', electionId)
    end
    CloseNUI()
    cb('ok')
end)

RegisterNUICallback('editElectionTime', function(data, cb)
    if data and data.electionId and data.startTimestamp and data.endTimestamp then
        ESX.TriggerServerEvent('sunset_vote:editElectionTime', {
            electionId = data.electionId,
            startTimestamp = tonumber(data.startTimestamp),
            endTimestamp = tonumber(data.endTimestamp),
        })
    end
    CloseNUI()
    cb('ok')
end)

RegisterNUICallback('sendElectionLog', function(data, cb)
    local electionId = data and data.electionId or nil
    if electionId then
        ESX.TriggerServerEvent('sunset_vote:sendElectionLog', electionId)
    end
    cb('ok')
end)

RegisterNetEvent('sunset_vote:openQuestSurvey', function(electionId)
    if not electionId then return end
    ESX.TriggerServerCallback('sunset_vote:getData', function(result)
        if not result or not result.active then
            return ESX.notification('error', VoteConfig.Notify.noElection)
        end
        local targetElection
        for _, el in ipairs(result.elections or {}) do
            if el.id == electionId then
                targetElection = el
                break
            end
        end
        if not targetElection then
            return ESX.notification('error', VoteConfig.Notify.noElection)
        end
        if targetElection.voted then
            return ESX.notification('error', VoteConfig.Notify.alreadyVoted)
        end
        OpenNUI('openVotePanel', { elections = { targetElection } })
    end)
end)

AddEventHandler('sunset_vote:questOpenSurvey', function()
    ESX.TriggerServerCallback('sunset_vote:getData', function(result)
        if not result or not result.active then
            return ESX.notification('error', VoteConfig.Notify.noElection)
        end
        local electionList = result.elections or {}
        local unvotedElections = {}
        for _, el in ipairs(electionList) do
            if not el.voted then
                table.insert(unvotedElections, el)
            end
        end
        if #unvotedElections == 0 then
            return ESX.notification('error', VoteConfig.Notify.alreadyVoted)
        end
        OpenNUI('openVotePanel', { elections = unvotedElections })
    end)
end)
