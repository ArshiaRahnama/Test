-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
hideLevel, SelfLevel, SavedLevel, SelfXP = false, 0, 0, 0
local currentPedKey
local eligibleQuests = {}
local weeklyQuest, dailyQuest, acceptedQuest = {}, {}, {}
local isMenuOpen = false
RegisterNetEvent('esx:changeworld',function(_world)
    ESX.PlayerData.World = _world
end)

AddEventHandler('quest:hideLevel', function(state)
    hideLevel = state
    ESX.SetPlayerState('level', hideLevel and -1 or SelfLevel)
    ESX.SetPlayerState('level2', SelfLevel)
end)

CreateThread(function()
    while not ESX do Wait(1000) end
    while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().gang == nil do
        Wait(1000)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    for k, v in pairs(config.peds) do
        for k2, v2 in pairs(v) do
            for k3, v3 in pairs(v2.coords) do
                exports['sunset_utils']:createLocalPed(4, v2.model, v3 - vec(0, 0, 1, 0), function(ped)
                    SetEntityAsMissionEntity(ped)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    local options = {}
                    table.insert(options, {
                        label = '🗣️صحبت کردن',
                        onSelect = function()
                            if ESX.GetPlayerData().World == 0 or exports['gangs']:isInGangWorld() then
                                openMenu(k)
                                ESX.registerExitPoint(5, function()
                                    close()
                                end)
                            end
                        end,
                    })
                    exports['ox_target']:addLocalEntity({ped}, options)
                    local rotation = 0.0
                    local t = 0.0

                    while DoesEntityExist(ped) do
                        local coords = GetEntityCoords(ped)
                        rotation = (rotation + 0.6) % 360
                        t = t + 0.01
                        local r = math.floor(127 + 127 * math.sin(t))
                        local g = math.floor(127 + 127 * math.sin(t + 2))
                        local b = math.floor(127 + 127 * math.sin(t + 4))

                        DrawMarker(32, coords.x, coords.y, coords.z + 1.03, 0.0, 0.0, 0.0, 0.0, 0.0, rotation, 0.3, 0.3, 0.3, r, g, b, 255, false, false, 2, false) 
                        Wait(0)
                    end
                end, function(ped)
                    exports['ox_target']:removeLocalEntity(ped)
                end)
            end
        end
    end

    for k, v in pairs(config.quests) do
        v.key = k
    end

    Wait(3000)
    ESX.TriggerServerCallback('lvl:getdata',function(lvl,xp, timePlay, _tokenLess)
        SelfLevel = lvl
        SelfXP = XP
        if SelfLevel <= 1 then
            CreateThread(function()
                while true do
                    Wait(1)
                    ESX.ShowMissionText('~r~/help~s~ jahat baz kardan help menu')
                end
            end)
        end
        ESX.SetPlayerData('SelfLevel', lvl)
    end)
    SetTimeout(10000,function()
        ESX.TriggerServerCallback('lvl:getData',function(lvl, xp, timePlay, token, token2, warn)
            local needxp = 1000000
            if config.Levels[lvl + 1] then
                needxp = config.Levels[lvl + 1].xp
            end
            xp = math.floor(xp)
            ShowMyInfo(0,needxp,xp,xp,lvl,false)
            processLevel(lvl, xp)
            if warn then
                CreateThread(function()
                    while true do
                        Wait(60000)
                        checkLevel()
                    end
                end)
            end
            while true do
                Wait(60000)
                processLevel(SelfLevel, SelfXP)
            end
        end)
    end)
    CreateThread(function()
        local unarmed = `WEAPON_UNARMED`
        local whiteList = {
            [`WEAPON_UNARMED`] = true,
            [`WEAPON_OBJECT`] = true,
            [`WEAPON_PETROLCAN`] = true,
        }
        while true do
            Wait(500)
            local weapon = GetSelectedPedWeapon(PlayerPedId())
            if not whiteList[weapon] and (config.Weapons[weapon] and (config.Weapons[weapon] > SelfLevel and SelfLevel ~= 0 and (config.gunCheckWorld[ESX.PlayerData.World] or exports['sun-robbery']:doesInRob())) or (not ESX.militaryJobs2[ESX.PlayerData.job.name] and ESX.PlayerData.gang.name == 'nogang' and SelfLevel < 10 and not inPaintball and inJob ~= 'hunter')) and ESX.GetWeaponFromHash(weapon) then
                SetCurrentPedWeapon(PlayerPedId(), unarmed, true)
                local message = 'Shoma tajrobe kafi baraye estefade az aslahe ra nadarid'
                if config.Weapons[weapon] and config.Weapons[weapon] <= SelfLevel and SelfLevel ~= 0 and (not ESX.militaryJobs2[ESX.PlayerData.job.name] and (ESX.PlayerData.gang.name == 'nogang' or ESX.PlayerData.gang.grade == 1) and SelfLevel < 10) then
                    message = 'Baraye estefade az in aslahe bayad ozv yek goruh khalafkar bashid'
                end
                ESX.Alert('Nope!',message,7000,'error')
            end
        end
    end)
    ESX.RegisterClientCallback('quest:getDataForUI', function(cb)
        cb(generateDataForUI())
    end)
    refreshConfig()
end)

function openMenu(key, _questCommand)
    refreshConfig()
    currentPedKey = key
    isMenuOpen = true
    questCommand = _questCommand
    SendNUIMessage({
        app = 'sunset_quest',
        method = 'open',
        data = {
            config = generateDataForUI(),
            justView = questCommand
        }
    })
    SetNuiFocus(true, true)
end

ESX.registerCommand('quest', function()
    openMenu('all', true)
end, {help = 'Baz kardan menu quest'})


function ShowMyInfo(Beginnvl,Endnvl,xpbfr,xpaft,nvl,removes,time)
    if lvl ~= nil and lvl ~= 0 and lvl ~= SavedLevel then
        SavedLevel = lvl
        ESX.SetPlayerState('level', hideLevel and -1 or lvl)
        ESX.SetPlayerState('level2', lvl)
    end
    local animspeed = 3000
    if time then
        animspeed = 9000
    end
    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        while not HasHudScaleformLoaded(19) do
            Wait(1)
        end
    end
    BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")

    PushScaleformMovieFunctionParameterInt(116)
    PushScaleformMovieFunctionParameterInt(140)
    EndScaleformMovieMethodReturn()

    if removes then
        local corb = config.LooseBarColor
        local corc = config.LooseCircleColor
        ReplaceHudColourWithRgba(116, corb.r, corb.g, corb.b, corb.a)
        ReplaceHudColourWithRgba(140, corc.r, corc.g, corc.b, corc.a)
    else
        local corb = config.BarColor
        local corc = config.CircleColor
        ReplaceHudColourWithRgba(116, corb.r, corb.g, corb.b, corb.a)
        ReplaceHudColourWithRgba(140, corc.r, corc.g, corc.b, corc.a)
    end

    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(Beginnvl)
    PushScaleformMovieFunctionParameterInt(Endnvl)
    PushScaleformMovieFunctionParameterInt(xpbfr)
    PushScaleformMovieFunctionParameterInt(xpaft)
    PushScaleformMovieFunctionParameterInt(nvl)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()

    BeginScaleformMovieMethodHudComponent(19, "OVERRIDE_ANIMATION_SPEED")
    PushScaleformMovieFunctionParameterInt(animspeed)
    EndScaleformMovieMethodReturn()
    ReplaceHudColourWithRgba(116, 45, 110, 185, 255)
    ReplaceHudColourWithRgba(140, 0, 0, 0, 186)
end

RegisterNetEvent('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
    --refresh cat
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
    --refresh cat
end)


RegisterNetEvent('quest:onLevelUP', function(lvl, xp)
    checkLevel()
end)

RegisterNetEvent('rob:setRob', function()
    processLevel(SelfLevel, SelfXP)
end)

function checkLevel()
    ESX.TriggerServerCallback('lvl:getData',function(lvl, xp)
        processLevel(lvl, xp)
    end)
end

local threadNewBie
function processLevel(lvl, xp)
    if lvl ~= nil and lvl ~= 0 and lvl ~= SavedLevel then
        SavedLevel = lvl
        ESX.SetPlayerState('level', hideLevel and -1 or lvl)
        ESX.SetPlayerState('level2', lvl)
    end
    SelfLevel = lvl
    SelfXP = xp
    ESX.SetPlayerData('SelfLevel', lvl)
    local ped = PlayerPedId()
    if GetPedConfigFlag(ped, 2, true) == 1 and not exports['sun-robbery']:doesInRob() then
        SetPedMaxHealth(ped, 200)
        if GetEntityHealth(ped) > 200 then
            ESX.SetEntityHealth(ped, GetEntityMaxHealth(ped))
        end
    else
        if config.levelhp[lvl] then
            SetPedMaxHealth(ped, 100 + config.levelhp[lvl])
            if GetEntityHealth(ped) == 200 and ESX.PlayerData.World == 0 then
                ESX.SetEntityHealth(ped, GetEntityMaxHealth(ped))
            end
        end
    end
    if config.levelarmor[lvl] then
        SetPlayerMaxArmour(PlayerId(), config.levelarmor[lvl])
        ESX.SetPlayerData('MaxArmour', config.levelarmor[lvl])
    end
    if lvl == 1 and not threadNewBie then
        threadNewBie = true
        while true do
            Wait(1)
            if SelfLevel == 1 then
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Right click
                DisableControlAction(0, 47, true)  -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, 170, true) -- Melee Attack 1
            else
                threadNewBie = false
                break
            end
        end
    end
end

inJob = nil
RegisterNetEvent('esx:inJob', function(name)
    inJob = name
end)

inPaintball = false
AddEventHandler('inPaintball', function(_inPaintball)
    inPaintball = _inPaintball
end)

RegisterNetEvent('lvl:showinfo',function(Beginnvl,Endnvl,xpbfr,xpaft,nvl,removes,time)
    PlaySoundFrontend(-1, "Friend_Deliver", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", true)
    if nvl and nvl ~= 0 then
        processLevel(nvl, xpaft)
    else
        checkLevel()
    end
    ShowMyInfo(Beginnvl,Endnvl,xpbfr,xpaft,nvl,removes,time)
end)

function refreshConfig()
    while SelfLevel == 0 do Wait(1000)  end
    eligibleQuests = {}
    local ganglevel = exports['gangprop']:getGangLevel()
    local permissionLevel = ESX.GetPlayerData().permission_level
    local ts = exports['sunset_utils']:GetServerOSTime()
    ESX.TriggerServerCallback('quest:getList2', function(questTime)
        for k, v in pairs(config.quests) do
            if questTime[k] then
                v.startTS = questTime[k].startTS
                v.endTS = questTime[k].endTS
            end
            if not v.disabled and (not v.endTS or (v.startTS < ts and v.endTS > ts)) then
                local access, access2 = false, true
                if v.access['all'] then
                    access = true
                end

                if v.access['admin'] ~= nil then
                    if v.access['admin'] and permissionLevel > 0 then
                        access = true
                    else
                        access2 = false
                    end
                end

                if v.access["selflevel"] and v.access["selfleveltype"] then
                    local levelif = false
                    if v.access["selfleveltype"] == 1 then
                        if SelfLevel == v.access["selflevel"] then
                            levelif = true
                        end
                    end
                    if v.access["selfleveltype"] == 2 then
                        if SelfLevel <= v.access["selflevel"] then
                            levelif = true
                        end
                    end
                    if v.access["selfleveltype"] == 3 then
                        if SelfLevel >= v.access["selflevel"] then
                            levelif = true
                        end
                    end
                    if v.access["selfleveltype"] == 4 and v.access["selflevel2"] then
                        if SelfLevel >= v.access["selflevel"] and SelfLevel <= v.access["selflevel2"] then
                            levelif = true
                        end
                    end
                    if levelif then
                        access = true
                    else
                        access = false
                    end
                end

                if v.access["gang"] == true and ESX.PlayerData.gang.name ~= "nogang" then
                    access = true
                elseif v.access["gang"] == false and ESX.PlayerData.gang.name ~= "nogang" then
                    access2 = false
                end

                if v.access["gang"] then
                    if ESX.PlayerData.gang.name ~= 'nogang' then
                        if v.access["ganglevel"] and v.access["gangleveltype"] then
                            local gangif = false
                            if v.access["gangleveltype"] == 1 then
                                if ganglevel == v.access["ganglevel"] then
                                    gangif = true
                                end
                            end
                            if v.access["gangleveltype"] == 2 then
                                if ganglevel <= v.access["ganglevel"] then
                                    gangif = true
                                end
                            end
                            if v.access["gangleveltype"] == 3 then
                                if ganglevel >= v.access["ganglevel"] then
                                    gangif = true
                                end
                            end
                            if v.access["gangleveltype"] == 4 and v.access["ganglevel2"] then
                                if ganglevel >= v.access["ganglevel"] and ganglevel <= v.access["ganglevel2"] then
                                    gangif = true
                                end
                            end
                            if gangif then
                                access = true
                            elseif v.access["gang"] then
                                access = false
                            end
                        else
                            access = true
                        end
                    end
                end

                local job = ESX.PlayerData.job.name
                if v.access[job:gsub("off","")] == true then
                    if v.access["jobgrade"] and v.access["jobgradetype"] then
                        local jobif = false
                        if v.access["jobgradetype"] == 1 then
                            if ESX.PlayerData.job.grade == v.access["jobgrade"] then
                                jobif = true
                            end
                        end
                        if v.access["jobgradetype"] == 2 then
                            if ESX.PlayerData.job.grade <= v.access["jobgrade"] then
                                jobif = true
                            end
                        end
                        if v.access["jobgradetype"] == 3 then
                            if ESX.PlayerData.job.grade >= v.access["jobgrade"] then
                                jobif = true
                            end
                        end
                        if v.access["jobgradetype"] == 4 and v.access["jobgrade2"] then
                            if ESX.PlayerData.job.grade >= v.access["jobgrade"] and ESX.PlayerData.job.grade <= v.access["jobgrade2"] then
                                jobif = true
                            end
                        end
                        if jobif then
                            access = true
                        end
                    else
                        access = true
                    end
                elseif v.access[job:gsub("off","")] == false then
                    access = false
                    access2 = false
                end
                if v.access[ESX.PlayerData.gang.name] == true then
                    access = true
                elseif v.access[ESX.PlayerData.gang.name] == false then
                    access = false
                    access2 = false
                end

                if ESX.PlayerData.gang.name == 'Admins' and not v.access[ESX.PlayerData.gang.name] then
                    access2 = false
                end

                if (access and access2) or acceptedQuest[k] then
                    eligibleQuests[k] = true
                end
            end
        end
        local p = promise.new()
        ESX.TriggerServerCallback('quest:getSuggestedQuest', function(...)
            dailyQuest, weeklyQuest, acceptedQuest = ...
            p:resolve()
        end, eligibleQuests)
        Citizen.Await(p)
        if isMenuOpen then
            SendNUIMessage({
                app = 'sunset_quest',
                method = 'update',
                data = {
                    config = generateDataForUI()
                }
            })
        end
    end)
end

function generateDataForUI()
    local data = {
        category = config.category,
        quests = {}
    }
    local dailyAccept = false
    local weeklyAccept = false
    local ts = exports['sunset_utils']:GetServerOSTime()

    for k, v in pairs(config.quests) do
        if eligibleQuests[k] then
            local status = 1
            if acceptedQuest[k] then
                if acceptedQuest[k].finish and acceptedQuest[k].getReward then
                    status = 2
                elseif acceptedQuest[k].finish then
                    status = 5
                else
                    status = 3
                end
            end

            if v.category == 'daily' and (status == 5 or status == 3) then
                dailyAccept = true
            end

            if v.subCategory == 'weekly' and acceptedQuest[k] then
                weeklyAccept = true
            end
        end
    end

    for k, v in pairs(config.quests) do
        local access = false
        if eligibleQuests[k] and (ESX.TableContainsValue(v.peds, 'all') or ESX.TableContainsValue(v.peds, currentPedKey) or questCommand) then
            if (v.category == 'daily' or v.subCategory == 'weekly') then
                if v.category == 'daily' and dailyQuest.chance and dailyQuest.chance[v.subCategory] and dailyQuest.chance[v.subCategory].key == k then
                    access = true
                end
                if v.subCategory == 'weekly' and weeklyQuest.chance then
                    for k2, v2 in pairs(weeklyQuest.chance) do
                        if v2.key == k then
                            access = true
                        end
                    end
                end
            else
                access = true
            end

            if v.isPrime and not ESX.isPrime() then
                access = false
            end

            if access then
                local show = true
                -- local categoryFound = true
                -- for k2, v2 in pairs(data.category) do
                --     if v2.key == v.category then
                --         categoryFound = false
                --     end
                -- end
                -- if not categoryFound then
                --     for k2, v2 in pairs(config.category) do

                --     end
                -- end
                local status = 1
                local copyConfig = ESX.CopyTable(v)
                if acceptedQuest[k] then
                    if acceptedQuest[k].finish and acceptedQuest[k].getReward then
                        status = 2
                    elseif acceptedQuest[k].finish then
                        status = 5
                    else
                        status = 3
                    end
                    copyConfig = acceptedQuest[k]
                end

                if v.category == 'daily' and dailyAccept and status == 1 then
                    status = 4
                    copyConfig.statusReason = 'یک کوئست روزانه در حال انجام دارید'
                end

                if v.subCategory == 'weekly' and weeklyAccept and status == 1 then
                    show = false
                end

                if v.disableReason then
                    status = 4
                    copyConfig.statusReason = v.disableReason
                end

                if questCommand then
                    -- status = 4
                    -- copyConfig.statusReason = v.disableReason2 or 'برای قبول این ماموریت باید به بات های کوئست مراجعه کنید'
                end

                copyConfig.status = status

                if copyConfig.rewards.static then
                    copyConfig.rewards.static = setImage(copyConfig.rewards.static)
                end
                if copyConfig.rewards.dynamic then
                    for k, v in pairs(copyConfig.rewards.dynamic) do
                        v = setImage(v)
                    end
                end

                for k, v in pairs(copyConfig.tasks) do
                    if not v.complete then
                        v.complete = 0
                    end
                end

                if copyConfig.endTS then
                    copyConfig.endTime = ESX.displayTime(copyConfig.endTS - ts)
                end

                if show then
                    data.quests[k] = copyConfig
                end
            end
        end
    end
    return data
end

function setImage(data)
    for k, v in pairs(data) do
        if not v.img then
            local name = v.name == 'money' and 'cash' or v.name
            if name == 'point_give' then
                name = 'point'
            elseif name == 'plan_give' then
                name = 'plan'
            end
            v.img = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(name)
        end
    end
    return data
end

RegisterNUICallback('accept', function(data, cb)
    local id = data.quest.key
    ESX.TriggerServerEvent('quest:accept', id)
    local questConfig = config.quests[id]
    if questConfig and questConfig.openEvent then
        close()
        TriggerEvent(questConfig.openEvent, questConfig.openEventArgs)
    end
    cb()
end)

RegisterNetEvent('quest:refresh', function()
    refreshConfig()
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    isMenuOpen = false
    cb()
end)

function close()
    SendNUIMessage({
        app = 'sunset_quest',
        method = 'close',
        data = true
    })
    SetNuiFocus(false, false)
    isMenuOpen = false
end


RegisterNUICallback("getItem", function(data, cb)
    local questId, taskId, itemName = data.quest.key, data.task.key, data.task.key

    if data.task.key:find('WEAPON') then
        local loadout = ESX.GetPlayerData().loadout
        local options = {}
        for k, v in pairs(loadout) do
            if v.name == itemName and not v.metadata.expireTS then
                table.insert(options, {
                    label = ('%s - %s'):format(ESX.getItemLabel(itemName), v.metadata.serial),
                    args = v.metadata.serial
                })
            end
        end
        if #options == 0 then
           ESX.notification('error', 'In item ra nadarid')
        else
            lib.registerMenu({
                id = 'quest_1',
                title = 'Tahvil aslahe',
                options = options,
                position = ''
            }, function(selected, scrollIndex, args)
                if args then
                    ESX.TriggerServerEvent('quest:give', questId, taskId, 1, args)
                end
            end)
            lib.showMenu('quest_1')
        end
    else
        if ESX.getItemCount(itemName) < 1 then
            ESX.notification('error', 'In item ra nadarid')
        else
            local input = lib.inputDialog(('Che tedad az %s ra mikhahid bedahid'):format(ESX.getItemLabel(itemName)), {
                {type = 'number', label = 'Tedad', icon = 'hashtag', max = ESX.getItemCount(itemName)},
            })
            if input and tonumber(input[1]) then
                --give
                ESX.TriggerServerEvent('quest:give', questId, taskId, tonumber(input[1]))
            end
        end
    end
    cb("ok")
end)

RegisterNUICallback('getRewards', function(data, cb)
    ESX.TriggerServerEvent('quest:getReward', data.quest.key, data.selectedRewards)
    cb("ok")
end)

RegisterNUICallback('showHelp', function(data, cb)
    local id = data.taskId
    exports['sun-helpmenu']:open2(id)
    cb('ok')
end)

RegisterNUICallback('notif', function(data, cb)
    ESX.notification('warning', data.message)
end)


RegisterNetEvent('quest:openCommand', function(data)
    questCommand = true
    SendNUIMessage({
        app = 'sunset_quest',
        method = 'open',
        data = {
            config = data,
            justView = questCommand
        }
    })
    SetNuiFocus(true, true)
end)