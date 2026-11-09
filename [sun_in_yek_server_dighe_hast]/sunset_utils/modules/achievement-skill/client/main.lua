-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local skills, achievements, vehiclesDB, menuCD = {}, {}, nil, nil
CreateThread(function()
    waitForLoad()
    ESX.TriggerServerCallback('skill:getData', function(_skills, _achievements)
        skills, achievements = _skills, _achievements
    end)
end)

RegisterNetEvent('skill:updateData', function(skill, achievement)
    if skill then
        skills = skill
        exports['sun-ui']:sendMessage({
            id = 'skillUP',
            event = 'create',
        })
    end
    if achievement then
        achievements = achievement
    end
end)

function doesSkillCompleted(key)
    return skills[key] and skills[key].finished
end
exports('doesSkillCompleted', doesSkillCompleted)

exports('doesAchievementCompleted', function(key)
    return achievements[key] and achievements[key].finished
end)

function getSkillTime(k, k2)
    if skillsConfig.skills[k] and skillsConfig.skills[k].time and skillsConfig.skills[k].time[k2] then
        local ret = skillsConfig.skills[k].time[k2][skills[k] and skills[k].finished and 2 or 1]
        return type(ret) == 'number' and ret or math.random(ret[1], ret[2])
    else
        return
    end
end
exports('getSkillTime', getSkillTime)

local function playAnim()
    local animDict = "timetable@tracy@ig_8@base"
    local animName = "base"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 48, 0, false, false, false)
end

AddEventHandler('KeyDown:i', function()
    if menuCD and menuCD > GetGameTimer() then return end
    menuCD = GetGameTimer() + 15000
    local skillList, weaponSkillList, archivmentList = {},{}, {}
    for k, v in pairs(skillsConfig.skills) do
        if not v.weapon then
            table.insert(skillList, {name = v.label, percent = ESX.Math.Round(skills[k] and skills[k].completedPercent or 0, 5), color = {'#9cfcf8'}})
        else
            table.insert(weaponSkillList, {name = v.label, percent = ESX.Math.Round(skills[k] and skills[k].completedPercent or 0, 5), color = {'#9cfcf8'}})
        end
    end
    local achievementPoint = 0
    for k, v in pairs(skillsConfig.achievements) do
        local max = 0
        local count = 0
        for k2, v2 in pairs(v.tasks) do
            max += v2.max
            count += achievements[k] and achievements[k].tasks[k2] and achievements[k].tasks[k2].completed or 0
        end
        if not v.hidden or (achievements[k] and achievements[k].finished) then
            if (achievements[k] and achievements[k].finished) then
                achievementPoint += v.point
            end
            table.insert(archivmentList, {label = v.label, img = v.img, description = v.description, point = v.point, count = count, max = max, finishedDate = achievements[k]?.finishedDate or '', finished = (achievements[k] and achievements[k].finished)})
        end
    end
    table.sort(skillList, function(a, b)
        if a.percent ~= b.percent then
            return a.percent > b.percent
        end
        return a.name < b.name
    end)
    table.sort(weaponSkillList, function(a, b)
        if a.percent ~= b.percent then
            return a.percent > b.percent
        end
        return a.name < b.name
    end)
    table.sort(archivmentList, function(a, b)
        if a.finished ~= b.finished then
            return a.finished
        end
        return a.label < b.label
    end)
    local profileData = exports['sunset_quest']:getPersonalData()
    profileData.name = ESX.PlayerData.name2
    if ESX.PlayerData.job.name ~= 'nojob' then
        profileData.job = ('%s (%s) - %s (%s)'):format(ESX.PlayerData.job.label, ESX.PlayerData.job.ext and ESX.PlayerData.job.ext ~= 'police' and ESX.PlayerData.job.ext or '*', ESX.PlayerData.job.grade_label, ESX.PlayerData.job.grade)
        profileData.jobImg = ('/ui/skill/img/job/%s.png'):format(ESX.PlayerData.job.name)
        if ESX.PlayerData.job.ext and ESX.PlayerData.job.name ~= 'police' then
            profileData.jobImg = getDivisionIcon()
        end
    end

    if ESX.PlayerData.gang.name ~= 'nogang' then
        profileData.gang = ('%s - %s (%s)'):format(ESX.PlayerData.gang.name, ESX.PlayerData.gang.grade_label, ESX.PlayerData.gang.grade)
        local p = promise.new()
        ESX.TriggerServerCallback('gangs:getGangData', function(data)
            profileData.gangImg = data?.icon
            p:resolve()
        end, ESX.PlayerData.gang.name)
        Citizen.Await(p)
    end

    profileData.tc = ESX.GetPlayerData().tc .. ' | Token : '.. profileData.token
    profileData.achevePoint = achievementPoint
    profileData.img = ESX.PlayerData.profilePicture
    skillFillVehiclesDB()
    local vehicles = vehiclesDB
    local ownedModel = {}
    local p = promise.new()
    ESX.TriggerServerCallback('garage:getOwnedVehiclesJustSelf', function(vehicles)
        for k, v in pairs(vehicles) do
            ownedModel[v.vehicle.model] = true
        end
        p:resolve()
    end, 'all')
    Citizen.Await(p)
    for k, v in pairs(vehicles) do
        v.owned = ownedModel[joaat(v.model)]
    end
    table.sort(vehicles, function(a, b)
        if a.owned ~= b.owned then
            return a.owned
        end
        return a.label < b.label
    end)
    local pets = getPetsData()
    table.sort(pets, function(a, b)
        if a.owned ~= b.owned then
            return a.owned
        end
        return a.label < b.label
    end)
    playAnim()
    exports['sun-ui']:sendMessage({
        id = 'skill',
        display = true,
        focus = true,
        skills = skillList,
        weaponSkill = weaponSkillList,
        achievements = archivmentList,
        pets = pets,
        profile = profileData,
        vehicles = vehicles,
    })
end)

function skillFillVehiclesDB()
    if not vehiclesDB then
        vehiclesDB = exports['sun-garage']:getVehicleDB()
        local _vehiclesDB = {}
        for k, v in pairs(vehiclesDB) do
            v.label = v.name
            v.img = v.imgurl and json.decode(v.imgurl)[1]
            v.img2 = v.imgurl180px
            table.insert(_vehiclesDB, v)
        end
        vehiclesDB = _vehiclesDB
    end
end

function getDivisionIcon(division)
    local p = promise.new()
    ESX.TriggerServerCallback('society:getDivisionIcon', function(link)
        p:resolve(link)
    end, division)
    return Citizen.Await(p) or 'https://cdn.discordapp.com/attachments/819384704087359518/869822670211006554/profile.png'
end

local function openOtherSkillMenu(src)
    local skillList, weaponSkillList, archivmentList = {}, {}, {}
    ESX.TriggerServerCallback('skill:getOtherPlayerData', function(skills, achievements, profilePicture, timePlay)
        for k, v in pairs(skillsConfig.skills) do
            if not v.weapon then
                table.insert(skillList, {name = v.label, percent = ESX.Math.Round(skills[k] and skills[k].completedPercent or 0, 5), color = {'#9cfcf8'}})
            else
                table.insert(weaponSkillList, {name = v.label, percent = ESX.Math.Round(skills[k] and skills[k].completedPercent or 0, 5), color = {'#9cfcf8'}})
            end
        end
        local achievementPoint = 0
        for k, v in pairs(skillsConfig.achievements) do
            local max = 0
            local count = 0
            for k2, v2 in pairs(v.tasks) do
                max += v2.max
                count += achievements[k] and achievements[k].tasks[k2] and achievements[k].tasks[k2].completed or 0
            end
            if not v.hidden or (achievements[k] and achievements[k].finished) then
                if (achievements[k] and achievements[k].finished) then
                    achievementPoint += v.point
                end
                table.insert(archivmentList, {label = v.label, img = v.img, description = v.description, point = v.point, count = count, max = max, finishedDate = achievements[k]?.finishedDate or '', finished = achievements[k]?.finished})
            end
        end
        table.sort(skillList, function(a, b)
            if a.percent ~= b.percent then
                return a.percent > b.percent
            end
            return a.name < b.name
        end)
        table.sort(weaponSkillList, function(a, b)
            if a.percent ~= b.percent then
                return a.percent > b.percent
            end
            return a.name < b.name
        end)
        table.sort(archivmentList, function(a, b)
            if a.finished ~= b.finished then
                return a.finished
            end
            return a.label < b.label
        end)
        local profileData = {}
        profileData.achevePoint = achievementPoint
        profileData.img = profilePicture
        profileData.tc = ''
        profileData.name = ''
        profileData.level = ''
        profileData.maxXp = ''
        profileData.xp = ''
        profileData.timePlay = ESX.displayTime(timePlay)
        skillFillVehiclesDB()
        local vehicles = vehiclesDB
        local ownedModel = {}
        local p = promise.new()
        ESX.TriggerServerCallback('garage:getOwnedVehiclesJustSelf', function(vehicles)
            for k, v in pairs(vehicles) do
                ownedModel[v.vehicle.model] = true
            end
            p:resolve()
        end, 'all', src)
        Citizen.Await(p)
        for k, v in pairs(vehicles) do
            v.owned = ownedModel[joaat(v.model)]
        end
        table.sort(vehicles, function(a, b)
            if a.owned ~= b.owned then
                return a.owned
            end
            return a.label < b.label
        end)
        local pets = getPetsData(src)
        table.sort(pets, function(a, b)
            if a.owned ~= b.owned then
                return a.owned
            end
            return a.label < b.label
        end)
        playAnim()
        exports['sun-ui']:sendMessage({
            id = 'skill',
            display = true,
            focus = true,
            skills = skillList,
            weaponSkill = weaponSkillList,
            achievements = archivmentList,
            pets = pets,
            profile = profileData,
            vehicles = vehicles,
        })
    end, src)
end

exports('openOtherSkillMenu', openOtherSkillMenu)

-- AddEventHandler('ui:menuClosed', function(id)
--     if id == 'skill' and ESX.isEmoteMenuActive() then
--         ClearPedTasks(SUN.ped)
--     end
-- end)