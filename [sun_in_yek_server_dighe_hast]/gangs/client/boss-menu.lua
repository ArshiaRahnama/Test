-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

isMenuOpen = false
local lastGangData = {}
function getGangData()
    local gangData = nil
	Citizen.Await(promise.new(function (p)
		ESX.TriggerServerCallback('gangs:getFullGangData', function(data)
			gangData = data
			p:resolve()
		end)
	end))
    lastGangData = gangData
    return gangData
end
function openGangAction()
    SetNuiFocus(true, true)

    local gangData = getGangData()
    local lotteryConfig, lotteryConfig2 = exports['sun-robbery']:getLotteryConfig(), {}
    for k, v in pairs(lotteryConfig) do
        lotteryConfig2[tostring(k)] = v
    end
    SendNUIMessage({
        type = 'showMenu',
        treasuryBalance = gangData.money,
        tokenBalance = gangData.token,
        canWithdraw = ESX.doesHaveGangPerm('withdrawMoney'),
        totalMembers = gangData.memberCount,
        maxMembers = gangData.slot,
        onlineMembers = gangData.onlineMembers,
        daysRemaining = gangData.endTime,
        resignationCount = ESX.tableLength(gangData.fireList),
        canManageMember = ESX.doesHaveGangPerm('employeeManagement'),
        canManageSetting = ESX.doesHaveGangPerm('bossAction'),
        canLottery = not ESX.jobsGang[ESX.PlayerData.gang.name] and ESX.doesHaveGangPerm('ghoreKeshi'),
        lotteryConfig = lotteryConfig2,
        washMoney = gangData.washMoney,
    })
    isMenuOpen = true
end

RegisterNUICallback('resignationList', function(data, cb)
    local resData = lastGangData.fireList
    for k, v in pairs(resData) do
        v.time = ESX.displayTime(tonumber(v.time))
    end
    SendNUIMessage({
        type = 'resignationRequests',
        requests = resData
    })
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
end)

local function hideMenu()
    SendNUIMessage({
        type = 'hideMenu',
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('deposit', function(data, cb)
    if not ESX.checkCooldown('dep', 5000) then return end
    local amount = ESX.Math.Round(data.amount)
    ESX.TriggerServerEvent('gangs:depositMoney', amount)
    Wait(1000)
    local gangData = getGangData()
    SendNUIMessage({
        treasuryBalance = gangData.money
    })

    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    if not ESX.checkCooldown('dep', 5000) then return end
    local amount = ESX.Math.Round(data.amount)

    if ESX.doesHaveGangPerm('withdrawMoney') then
        ESX.TriggerServerEvent('gangs:withdrawMoney', amount)
        Wait(1000)
        local gangData = getGangData()
        SendNUIMessage({
            treasuryBalance = gangData.money
        })
    end
    cb('ok')
end)


RegisterNUICallback('tokenDeposit', function(data, cb)
    if not ESX.checkCooldown('dep', 5000) then return end
    local amount = ESX.Math.Round(data.amount)

    ESX.TriggerServerEvent('gang:addToken', amount)

    Wait(3000)
    local gangData = getGangData()
    SendNUIMessage({
        tokenBalance = gangData.token
    })


    cb('ok')
end)

RegisterNUICallback('getRankNames', function(data, cb)
    local ranks = {}
    for k, v in pairs(lastGangData.grades) do
        ranks[tostring(v.grade)] = v.label
    end
    SendNUIMessage({
        type = 'rankNamesResponse',
        rankNames = ranks
    })
    cb('ok')
end)

local function updateMemberList()
    local access, fireAccess = ESX.doesHaveGangPerm('employeeManagement'), ESX.doesHaveGangPerm('fireEmployee')
    ESX.TriggerServerCallback('gangs:getEmployees', function(result)
        local list = {}
        for k, v in pairs(result) do
            table.insert(list, {
                profileUrl = v.profilePicture,
                name = v.name,
                identifier = v.identifier,
                rank = v.gang.grade,
                canFire = fireAccess and v.gang.grade < ESX.PlayerData.gang.grade,
                canEdit = access and v.gang.grade < ESX.PlayerData.gang.grade,
                canEditMax = ESX.PlayerData.gang.grade - 1
            })
        end
        SendNUIMessage({
            type = 'membersList',
            members = list
        })
    end)
end
RegisterNUICallback('getMembersList', function(data, cb)
    updateMemberList()
    cb('ok')
end)

RegisterNUICallback('fireMember', function(data, cb)
    local member = data.memberData
    ESX.TriggerServerCallback('gangs:setGang', function()
        updateMemberList()
    end, member.identifier, 'fire')
    cb('ok')
end)

RegisterNUICallback('hireMember', function(data, cb)
    hideMenu()
    ESX.selectPlayerMenu(function(src)
        ESX.TriggerServerCallback('gangs:setGang', function()
			openGangAction()
		end, src, 'hire')
    end, 20)
end)

RegisterNUICallback('updateMemberRank', function(data, cb)
    local member = data.memberData
    local newRankLevel = data.newRank
    SendNUIMessage({
        type = 'memberRankUpdated',
        memberIdentifier = member.identifier,
        newRank = newRankLevel
    })
    ESX.TriggerServerCallback('gangs:setGang', function()
        updateMemberList()
    end, member.identifier, 'promote', newRankLevel)
    cb('ok')
end)

RegisterNUICallback('getSalaryData', function(data, cb)
    local list = {}
    for k, v in pairs(lastGangData.grades) do
        list[tostring(v.grade)] = v.salary
    end

    SendNUIMessage({
        type = 'salaryDataResponse',
        salaries = list
    })
    cb('ok')
end)

RegisterNUICallback('updateSalary', function(data, cb)
    local rankLevel = data.rankLevel
    local newSalary = data.newSalary
    ESX.TriggerServerCallback('gangs:setGangSalary', function()

    end, tonumber(rankLevel), tonumber(newSalary))
    cb('ok')
end)


RegisterNUICallback('getLogsList', function(data, cb)
    print("Logs list requested")

    local logsList = {
        {
            name = 'Poul',
            index = 'money'
        },
        {
            name = 'Mashin',
            index = 'vehicle'
        },
        {
            name = 'Token XP',
            index = 'tokenxp'
        },
        {
            name = 'Boss action',
            index = 'boss'
        },
        {
            name = 'Craft',
            index = 'craft',
        },
        {
            name = 'Customshop',
            index = 'customshop',
        }
    }

    local lockerCount = exports['gangprop']:getLockerCount()

    for k = 1, lockerCount do
        table.insert(logsList, {
            name = 'Locker #'.. k,
            index = 'locker'.. k
        })
    end


    SendNUIMessage({
        type = 'logsListResponse',
        logs = logsList
    })

    cb('ok')
end)

RegisterNUICallback('getLogRankAccess', function(data, cb)
    local logIndex = data.logIndex

    local ranks = {}
    ESX.TriggerServerCallback('gang:getLogPermission', function(result)
        print(ESX.dump(result))
        for k, v in pairs(result) do
            table.insert(ranks, {
                rankId = tonumber(k), state = true
            })
        end

            SendNUIMessage({
                type = 'logRankAccessResponse',
                ranks = ranks
            })
    end, logIndex)

    cb('ok')
end)

RegisterNUICallback('setLogRankAccess', function(data, cb)
    local logIndex = data.logIndex
    local ranks = data.ranks
    local rankList = {}
    for k, v in pairs(ranks) do
        if v.state then
            rankList[tostring(k)] = true
        end
    end


    TriggerServerEvent('gang:updateLogPermission', logIndex, rankList)

    -- Here you would save to your database

    cb('ok')
end)

RegisterNUICallback('updateWebhook', function(data, cb)
    local webhookKey = data.key
    local webhookUrl = data.url
    local webhookLocation = data.location

    if webhookKey == 'locker' and not webhookLocation then
        webhookLocation = 1
    end
    ESX.TriggerServerEvent('gangs:sethook',webhookKey, webhookUrl, tonumber(webhookLocation))

    cb('ok')
end)


RegisterNUICallback('toggleWashMoney', function(data, cb)
    ESX.TriggerServerEvent('gangs:togglewashmoney')
end)


RegisterNUICallback('getVehiclesList', function(data, cb)
    local list = {}
    ESX.TriggerServerCallback('gangprop:getVehicles', function(ownedCars)
        for k ,v in pairs(ownedCars) do
            if v.gang == ESX.PlayerData.gang.name:lower() then
                local data = exports['sun-garage']:getSpecificVehicle(v.vehicle.model)
                table.insert(list, {
                    label = ESX.GetVehicleLabelFromHash(v.vehicle.model),
                    plate = v.plate,
                    imageUrl = data and data.imgurl180px
                })
            end
        end

        SendNUIMessage({
            type = 'vehiclesListResponse',
            vehicles = list
        })
    end, 'all')
    cb('ok')
end)

RegisterNuiCallback('getLockersCount', function(data, cb)
    SendNUIMessage({
        type = 'lockersCountResponse',
        totalLockers = exports['gangprop']:getLockerCount()
    })
    cb('ok')
end)

RegisterNUICallback('getLockerPermissions', function(data, cb)

    ESX.TriggerServerCallback('gangs:getgradearmory', function(perm, lockerLimit)
        local list = {}
		local options = {}
		local inventory = exports['gangprop']:getGangInventory(1, true)
		local temp = {}
		table.insert(options, {label = 'Submit👌', args = {type = 'submit'}})
		table.insert(list, {label = '⭐Access to all weapons⭐', key = 'allweapon', state = perm['allweapon'] or false, weapon = true, clothe = false})
        table.insert(list, {label = '⭐Change slot⭐', key = 'changeSlot', state = perm['changeSlot'] or false, weapon = true, clothe = false})
        table.insert(list, {label = '⭐Access to all items⭐', key = 'allitem', state = perm['allitem'] or false, weapon = false, clothe = false})
		for k , v in ipairs(inventory.weapons) do
			if not temp[v.name] then
				temp[v.name] = true
                table.insert(list, {label = ESX.GetWeaponLabel(v.name), key = v.name, state = perm[v.name] or false, weapon = true, clothe = false, limit = lockerLimit[v.name] or 0})
			end
		end

		table.insert(options, {label = '--- Items ---', close = false})
		for k , v in ipairs(inventory.items) do
			if not exports['sunset_clothe']:getClotheData(v.name) then
                table.insert(list, {label = (ESX.getItem(v.name) and ESX.getItem(v.name).label or v.name), key = v.name, state = perm[v.name] or false, weapon = false, clothe = false, limit = lockerLimit[v.name] or 0})
			end
		end

        for k , v in ipairs(inventory.items) do
			if exports['sunset_clothe']:getClotheData(v.name) then
				table.insert(list, {label = (ESX.getItem(v.name) and ESX.getItem(v.name).label or v.name), key = v.name, state = perm[v.name] or false, weapon = false, clothe = true, limit = lockerLimit[v.name] or 0})
			end
		end

        SendNUIMessage({
            type = 'lockerPermissions',
            permissions = list
        })
	end, data.rankId, data.lockerNumber)

    cb('ok')
end)

RegisterNUICallback('setLockerPermissions', function(data, cb)
    local list = {}
    local limitList = {}
    for k, v in ipairs(data.permissions) do
        if v.state then
            list[v.key] = true
            limitList[v.key] = v.limit or 0
        end
    end
    TriggerServerEvent('gangs:setgunstate', data.rankId, list, data.lockerNumber, limitList)
    cb('ok')
end)

RegisterNuiCallback('getVehiclePermissions', function(data, cb)
    local list = {}
    local grade = data.rankId
    ESX.TriggerServerCallback('gangprop:getVehicles', function(ownedCars, permissionList)
        for k, v in pairs(ownedCars) do
			local hash = v.vehicle.model
			local vehicleName  = ESX.GetVehicleLabelFromHash(hash)
			local plate = v.plate
			local state = permissionList[plate]
            local category = (v.type == 'car') and 1 or (v.type == 'heli' or v.type == 'aircraft') and 2 or 3
            table.insert(list, {label = vehicleName, plate = plate, key = plate, state = state, category = category})
		end

        SendNUIMessage({
            type = 'vehiclePermissions',
            vehicles = list
        })
    end, 'all', grade)
    cb('ok')
end)

RegisterNUICallback('setVehiclePermissions', function(data, cb)
    local list = {}
    for k, v in ipairs(data.vehicles) do
        if v.state then
            list[v.key] = true
        end
    end
    -- TriggerServerEvent('gangs:setgunstate', data.rankId, list, data.lockerNumber)
    ESX.TriggerServerEvent('gangs:updateVehiclePermission', list, data.rankId)
    cb('ok')
end)

RegisterNuiCallback('getCraftPermissions', function(data, cb)
    local list = {}
    local grade = data.rankId
    local permission = lastGangData.craftPermission[tostring(grade)] or {}
    table.insert(list, {label = '⭐Access to all level⭐', key = 'all', state = permission['all']})
    table.insert(list, {label = '⭐Craft with gang inventory⭐', key = 'craftwithinventory', state = permission['craftwithinventory'], inventoryId = permission['craftwithinventory']})
    for i = 1, lastGangData.level do
        local state = permission and (permission[tostring(i)])
        table.insert(list, {label = 'Level #'.. i ..'', key = tostring(i), state = state})
    end
    SendNUIMessage({
        type = 'craftPermissions',
        crafts = list
    })
    cb('ok')
end)


RegisterNUICallback('setCraftPermissions', function(data, cb)
    local list = {}
    TriggerServerEvent('gangs:updateCraftPermission', data.rankId, data.crafts)
    Wait(2000)
    getGangData()
    cb('ok')
end)

RegisterNUICallback('addRank', function(data, cb)
    ESX.TriggerServerEvent('gang:addGrade')
    Wait(5000)
    updateGradeList()
end)

function updateGradeList()
    getGangData()
    local ranks = {}
    for k, v in pairs(lastGangData.grades) do
        ranks[tostring(v.grade)] = v.label
    end
    SendNUIMessage({
        type = 'rankNamesResponse',
        rankNames = ranks
    })
end

RegisterNUICallback('updateRankName', function(data, cb)
    local grade = tonumber(data.rankId)
    local newName = data.newName
    ESX.TriggerServerCallback('gangs:renameGrade', function(refresh)
        updateGradeList()
    end, tonumber(grade), newName)

    cb('ok')
end)

RegisterNUICallback('deleteRank', function(data, cb)
    local grade = tonumber(data.rankId)
    print(grade)
    ESX.TriggerServerEvent('gang:deleteGrade', grade)
    Wait(3000)
    updateGradeList()
    Wait(1000)
    cb('ok')
end)

RegisterNUICallback('getRankPermissions', function(data, cb)
    local grade = tonumber(data.rankId)
    local list = {}
    table.insert(list, {label = 'مخفی کردن آیتم های غیرقابل دسترسی', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'hideLocker') and true or false,key = 'hideLocker'})
    table.insert(list, {label = 'شرکت در قرعه کشی', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'ghoreKeshi') and true or false,key = 'ghoreKeshi'})
    table.insert(list, {label = 'گذاشتن ماشین در گنگ', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'putVehicle') and true or false,key = 'putVehicle'})
    table.insert(list, {label = 'دسترسی به باس اکشن', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'bossAction') and true or false,key = 'bossAction'})
    table.insert(list, {label = 'دسترسی به مدیریت اعضا', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'employeeManagement') and true or false,key = 'employeeManagement'})
    table.insert(list, {label = 'اخراج عضو', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'fireEmployee') and true or false,key = 'fireEmployee'})
    table.insert(list, {label = 'برداشت پول', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'withdrawMoney') and true or false,key = 'withdrawMoney'})
    table.insert(list, {label = 'برداشت از کوره', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'furnaceWithdraw') and true or false,key = 'furnaceWithdraw'})
    table.insert(list, {label = 'دسترسی به چنج ورلد', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'changeWorld') and true or false,key = 'changeWorld'})
    table.insert(list, {label = 'استفاده از جلیقه ضد گلوله(وست)', state = doesGradeHavePerm(lastGangData.gangPerms, grade, 'useVest') and true or false,key = 'useVest'})

    SendNUIMessage({
        type = 'rankPermissionsResponse',
        permissions = list
    })

    cb('ok')
end)

RegisterNUICallback('updateRankPermissions', function(data, cb)
    local grade = tonumber(data.rankId)
    local permissions = data.permissions

    local list = {}

    for k, v in pairs(permissions) do
        if v.state then
            list[v.key] = true
        end
    end

    ESX.TriggerServerEvent('gang:toggleVar', tostring(grade), list)
    Wait(1000)
    updateGradeList()
    Wait(1000)
    SendNUIMessage({
        type = 'rankPermissionsUpdated',
        rankId = grade,
        success = true
    })
    cb('ok')
end)

RegisterNUICallback('deleteVehicle', function(data, cb)
    local vehicle = data.vehicle
    ESX.TriggerServerEvent('garage:setGangVehicle', vehicle.plate, false, true)
    cb('ok')
end)