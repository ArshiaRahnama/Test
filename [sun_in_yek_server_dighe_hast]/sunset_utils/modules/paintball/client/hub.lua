-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.state = PB.state or {inMatch = false, inLobby = false}
PB.MODULE = PB.MODULE or 'paintball'
PB.flags = PB.flags or {}

local registeredPoints = {}
local hubBlips = {}
local hubMenuOpen = false
local currentEntry = 0
local _attachmentHashesCache = {}
local lastMenuOpenAt = 0
local lastCooldownNotifAt = 0
local MENU_OPEN_COOLDOWN = 1500
local MENU_COOLDOWN_NOTIF_THROTTLE = 2000

local _actionCooldowns = {}
local ACTION_COOLDOWNS = {
    requestModes = 800,
    requestMaps = 800,
    requestLobbies = 1500,
    requestPerks = 800,
    requestWeapons = 800,
    requestLeaderboard = 2000,
    requestPlayerStats = 2000,
    requestAchievements = 1500,
    requestLoadouts = 1000,
    requestCosmetics = 1000,
    requestMatchHistory = 1500,
    requestEquipment = 500,
    requestAttachmentHashes = 500,
    mapVoteOptions = 1500,
    loadoutSave = 1000,
    loadoutDelete = 800,
    loadoutSetActive = 1500,
    setPerks = 500,
    setCosmetic = 500,
    setReady = 400,
    switchTeam = 600,
    startReadyCheck = 8000,
    requestAutoBalance = 3000,
    createParty = 2000,
    inviteParty = 1500,
    leaveParty = 1000,
    createLobby = 2000,
    joinLobby = 1500,
    startMatch = 3000,
    cancelLobby = 2000,
    leaveLobby = 2000,
    answerReadyCheck = 800,
    castMapVote = 1000,
}

local function actionAllowed(action)
    local cd = ACTION_COOLDOWNS[action]
    if not cd then return true end
    local now = GetGameTimer()
    local last = _actionCooldowns[action] or 0
    if now - last < cd then return false end
    _actionCooldowns[action] = now
    return true
end

local function clearPoints()
    for _, id in ipairs(registeredPoints) do
        if ESX.RemovePoint then ESX.RemovePoint(id) end
    end
    registeredPoints = {}
    for _, blip in ipairs(hubBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    hubBlips = {}
end

local function jobAccessOk(playerData, access)
    if access.all then return true end
    if access.jobs then
        local jobName = playerData.job and playerData.job.name
        local entry = jobName and access.jobs[jobName]
        if entry then
            if type(entry) == 'boolean' then return entry end
            local g = entry.gradeType
            local grade = playerData.job.grade
            if g == 1 and grade == entry.grade then return true end
            if g == 2 and grade <= entry.grade then return true end
            if g == 3 and grade >= entry.grade then return true end
            if g == 4 and entry.grade2 and grade >= entry.grade and grade <= entry.grade2 then return true end
        end
    end
    if access.gangs then
        local gangName = playerData.gang and playerData.gang.name
        local entry = gangName and access.gangs[gangName]
        if entry then
            if type(entry) == 'boolean' then return entry end
            local g = entry.gradeType
            local grade = playerData.gang.grade or 0
            if g == 1 and grade == entry.grade then return true end
            if g == 2 and grade <= entry.grade then return true end
            if g == 3 and grade >= entry.grade then return true end
        end
    end
    return false
end

CreateThread(function()
    waitForLoad(1500)
    clearPoints()
    for index, ep in ipairs(paintballConfig.entryPoints) do
        if ep.blip then
            local blip = AddBlipForCoord(ep.coords.x, ep.coords.y, ep.coords.z)
            SetBlipSprite(blip, ep.blip.sprite or 437)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, ep.blip.scale or 0.9)
            SetBlipColour(blip, ep.blip.color or 17)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(ep.blip.label or 'Paintball')
            EndTextCommandSetBlipName(blip)
            hubBlips[#hubBlips + 1] = blip
        end
    end
end)

local activePromptIndex = 0
local lastWalkoutCheckAt = 0
local WALKOUT_CHECK_INTERVAL = 1500
CreateThread(function()
    waitForLoad(1500)
    while true do
        local sleep = 800
        if not PB.state.inMatch then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local nearest = nil
            local nearestDist = 999.0
            for index, ep in ipairs(paintballConfig.entryPoints) do
                local d = #(playerCoords - ep.coords)
                if d < 30.0 then
                    sleep = 0
                    local mc = ep.marker
                    DrawMarker(mc.type or 1, ep.coords.x, ep.coords.y, ep.coords.z,
                        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        mc.size.x, mc.size.y, mc.size.z,
                        mc.color.r, mc.color.g, mc.color.b, mc.color.a or 100,
                        false, true, 2, false, nil, nil, false)
                    if d < 5.0 and d < nearestDist then
                        nearestDist = d
                        nearest = index
                    end
                end
            end
            if hubMenuOpen and not PB.state.starting then
                local now = GetGameTimer()
                if now - lastWalkoutCheckAt > WALKOUT_CHECK_INTERVAL then
                    lastWalkoutCheckAt = now
                    local activeEp = paintballConfig.entryPoints[currentEntry]
                    if activeEp then
                        local d = #(playerCoords - activeEp.coords)
                        local radius = (activeEp.marker and activeEp.marker.size and activeEp.marker.size.x) or 10.0
                        if d > radius then
                            SUN.CloseUI(PB.MODULE)
                            ESX.notification('warning', 'از منطقه خارج شدی — منو بسته شد')
                        end
                    end
                end
            elseif nearest then
                activePromptIndex = nearest
                ESX.showTextUI('[E] برای ورود به پینت‌بال')
                if IsControlJustPressed(1, 38) then
                    local now = GetGameTimer()
                    local elapsed = now - lastMenuOpenAt
                    if elapsed < MENU_OPEN_COOLDOWN then
                        if now - lastCooldownNotifAt > MENU_COOLDOWN_NOTIF_THROTTLE then
                            lastCooldownNotifAt = now
                            local left = math.ceil((MENU_OPEN_COOLDOWN - elapsed) / 1000)
                            ESX.notification('error', ('لطفا %d ثانیه دیگه دوباره امتحان کن'):format(left))
                        end
                    else
                        local ep = paintballConfig.entryPoints[nearest]
                        if not (ESX.isDead and ESX.isDead()) and not LocalPlayer.state.adrenaline then
                            if jobAccessOk(ESX.GetPlayerData(), ep.access) then
                                local job = ESX.PlayerData and ESX.PlayerData.job
                                local jobBlocks = job and job.name and not job.name:find('off') and job.name ~= 'nojob'
                                    and not (ESX.basicJobs and ESX.basicJobs[job.name])
                                    and not (ep.access and ep.access.jobs and ep.access.jobs[job.name])
                                    and not (ep.access and ep.access.bypassJobCheck)
                                if jobBlocks then
                                    ESX.notification('error', 'برای پینت‌بال باید off-duty باشی')
                                else
                                    lastMenuOpenAt = now
                                    lib.hideTextUI()
                                    currentEntry = nearest
                                    hubMenuOpen = true
                                    PB.state.inLobby = true
                                    PB.lastEntryCoords = ep.coords
                                    SUN.OpenUI(PB.MODULE, {
                                        view = 'lobby',
                                        flags = PB.flags,
                                        entryPoint = nearest,
                                        serverId = SUN.src,
                                        playerName = GetPlayerName(SUN.PlayerId, true),
                                    }, {type = 'panel'})
                                end
                            else
                                ESX.notification('error', 'Shoma dastresi be in paintball nadarid')
                            end
                        elseif ESX.isDead and ESX.isDead() then
                            ESX.notification('error', 'مرده‌ای — نمی‌تونی وارد بشی')
                        end
                    end
                end
            else
                if activePromptIndex > 0 then
                    activePromptIndex = 0
                    lib.hideTextUI()
                end
            end
        else
            if activePromptIndex > 0 then
                activePromptIndex = 0
                lib.hideTextUI()
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('sunset_utils:uiClosed', function(name)
    if name == PB.MODULE then
        hubMenuOpen = false
        lastMenuOpenAt = GetGameTimer()
        if not PB.state.inMatch then
            PB.state.inLobby = false
        end
        SetNuiFocus(false, false)
        lib.hideTextUI()
    end
end)

AddEventHandler('sunset_utils:uiCallback:'..PB.MODULE, function(action, data)
    if not actionAllowed(action) then return end
    if action == 'requestModes' then
        ESX.TriggerServerCallback('paintball:listModes', function(modes)
            SUN.SendUIData(PB.MODULE, {type = 'modes', payload = modes})
        end)
    elseif action == 'requestMaps' then
        ESX.TriggerServerCallback('paintball:listMaps', function(maps)
            SUN.SendUIData(PB.MODULE, {type = 'maps', payload = {mode = data.mode, maps = maps}})
        end, data.mode)
    elseif action == 'requestLobbies' then
        ESX.TriggerServerCallback('paintball:listLobbies', function(list)
            SUN.SendUIData(PB.MODULE, {type = 'lobbies', payload = list})
        end)
    elseif action == 'requestPerks' then
        ESX.TriggerServerCallback('paintball:listPerks', function(perks)
            SUN.SendUIData(PB.MODULE, {type = 'perks', payload = perks})
        end)
    elseif action == 'requestWeapons' then
        ESX.TriggerServerCallback('paintball:listWeaponCatalog', function(weapons)
            SUN.SendUIData(PB.MODULE, {type = 'weapons', payload = weapons})
        end)
    elseif action == 'requestLeaderboard' then
        if not PB.flags.leaderboard then
            SUN.SendUIData(PB.MODULE, {type = 'leaderboard', payload = {enabled = false}})
            return
        end
        ESX.TriggerServerCallback('paintball:leaderboard:top', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'leaderboard', payload = result})
        end, data.mode or 'tdm', data.sortBy or 'kills')
    elseif action == 'requestPlayerStats' then
        if not PB.flags.leaderboard then
            SUN.SendUIData(PB.MODULE, {type = 'playerStats', payload = {enabled = false, row = nil}})
            return
        end
        ESX.TriggerServerCallback('paintball:leaderboard:player', function(result)
            local payload = result
            if not payload then payload = {enabled = true, row = nil} end
            SUN.SendUIData(PB.MODULE, {type = 'playerStats', payload = payload})
        end, data.mode or 'tdm')
    elseif action == 'requestAchievements' then
        ESX.TriggerServerCallback('paintball:getAchievements', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'achievements', payload = result})
        end)
    elseif action == 'createLobby' then
        ESX.TriggerServerCallback('paintball:createLobby', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'createLobbyResult', payload = result})
            if not result.ok then
                ESX.notification('error', result.reason or 'lobby sakhte nashod')
            end
        end, data)
    elseif action == 'joinLobby' then
        ESX.TriggerServerCallback('paintball:joinLobby', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'joinLobbyResult', payload = result})
            if not result.ok then
                ESX.notification('error', result.reason or 'join nashod')
            end
        end, data.id, data.password)
    elseif action == 'leaveLobby' then
        if PB.state.starting then return end
        TriggerServerEvent('paintball:leaveLobby')
        PB.state.inLobby = false
        SUN.SendUIData(PB.MODULE, {type = 'returnToPlay', payload = {reason = 'از لابی خارج شدی'}})
    elseif action == 'cancelLobby' then
        if PB.state.starting then return end
        TriggerServerEvent('paintball:cancelLobby')
        PB.state.inLobby = false
        SUN.SendUIData(PB.MODULE, {type = 'returnToPlay', payload = {reason = 'لابی کنسل شد'}})
    elseif action == 'setReady' then
        TriggerServerEvent('paintball:setReady', data.ready)
    elseif action == 'switchTeam' then
        TriggerServerEvent('paintball:switchTeam', data.team)
    elseif action == 'startMatch' then
        TriggerServerEvent('paintball:startMatch', data and data.useAdminSolo and true or false)
    elseif action == 'setPerks' then
        TriggerServerEvent('paintball:setPerks', data.perks or {})
    elseif action == 'requestAutoBalance' then
        TriggerServerEvent('paintball:requestAutoBalance')
    elseif action == 'startReadyCheck' then
        TriggerServerEvent('paintball:startReadyCheck')
    elseif action == 'answerReadyCheck' then
        TriggerServerEvent('paintball:answerReadyCheck', data.answer)
    elseif action == 'createParty' then
        TriggerServerEvent('paintball:createParty')
    elseif action == 'inviteParty' then
        TriggerServerEvent('paintball:inviteToParty', data.target)
    elseif action == 'leaveParty' then
        TriggerServerEvent('paintball:leaveParty')
    elseif action == 'mapVoteOptions' then
        ESX.TriggerServerCallback('paintball:mapVoteOptions', function(opts)
            SUN.SendUIData(PB.MODULE, {type = 'mapVoteOptions', payload = opts})
        end, data.mode)
    elseif action == 'castMapVote' then
        TriggerServerEvent('paintball:castMapVote', data.lobbyId, data.map)
    elseif action == 'requestLoadouts' then
        ESX.TriggerServerCallback('paintball:loadout:list', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'loadouts', payload = result})
        end)
    elseif action == 'loadoutSave' then
        if paintballConfig.debug then
            print('[PB-DEBUG][hub] loadoutSave action received. slot=', data.slot, 'attachments=', json.encode(data.attachments or {}))
        end
        TriggerServerEvent('paintball:loadout:save', data.slot, data.name, data.perks, data.attachments)
    elseif action == 'loadoutDelete' then
        TriggerServerEvent('paintball:loadout:delete', data.slot)
    elseif action == 'loadoutSetActive' then
        TriggerServerEvent('paintball:loadout:setActive', data.slot)
    elseif action == 'requestCosmetics' then
        ESX.TriggerServerCallback('paintball:cosmetics:get', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'cosmetics', payload = result})
        end)
    elseif action == 'setCosmetic' then
        TriggerServerEvent('paintball:cosmetics:set', data.category, data.key)
    elseif action == 'requestMatchHistory' then
        ESX.TriggerServerCallback('paintball:matchHistory:get', function(result)
            SUN.SendUIData(PB.MODULE, {type = 'matchHistory', payload = result})
        end)
    elseif action == 'requestEquipment' then
        local items = paintballConfig.equipment and paintballConfig.equipment.enabled and paintballConfig.equipment.items or {}
        SUN.SendUIData(PB.MODULE, {type = 'equipment', payload = items})
    elseif action == 'requestAttachmentHashes' then
        local hashes = _attachmentHashesCache[data.weapon]
        if not hashes then
            hashes = {}
            local list = PaintballUtil.allowedAttachmentsForWeapon('tdm', data.weapon) or {}
            for _, e in ipairs(list) do
                if e.group ~= 'tint' then
                    hashes[e.group] = e.hash
                end
            end
            _attachmentHashesCache[data.weapon] = hashes
        end
        SUN.SendUIData(PB.MODULE, {type = 'attachmentHashes', payload = {weapon = data.weapon, hashes = hashes}})
    elseif action == 'escape' then
        if PB.state.inMatch or PB.state.starting then
            if PB.state.starting and ESX and ESX.notification then
                ESX.notification('error', 'مچ در حال شروعه — نمیتونی الان خارج شی')
            end
            return
        end
        TriggerServerEvent('paintball:leaveLobby')
        PB.state.inLobby = false
        hubMenuOpen = false
        SUN.CloseUI(PB.MODULE)
        SetNuiFocus(false, false)
        lib.hideTextUI()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        clearPoints()
    end
end)
