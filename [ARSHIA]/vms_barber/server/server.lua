local stores = {}

local chairs = {}
local playersHasBills = {}

exports('isInBarber', function(src)
    return chairs[src]
end)

if Config.Core == "ESX" then
    ESX = Config.CoreExport()

    ESX.RegisterServerCallback("vms_barber:getMoney", function(source, cb, price, moneyType, newHairFades)
        local xPlayer = SV.getPlayer(source)
        if xPlayer and price then
            local myMoney = SV.getCombinedMoney(xPlayer)
            local price = math.abs(math.floor(price))
            if myMoney >= price then
                SV.removeMoneySmart(xPlayer, price)
                if Config.UseVMSTattooshop and Config.UseHairFadeInBarber and newHairFades and next(newHairFades) then
                    TriggerClientEvent('vms_tattooshop:barberFadesChanges', source, newHairFades)
                end
                cb(true, price)
            else
                cb(false)
            end
        end
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    QBCore.Functions.CreateCallback('vms_barber:getMoney', function(source, cb, price, moneyType, newHairFades)
        local Player = SV.getPlayer(source)
        if Player and price then
            local myMoney = SV.getCombinedMoney(Player)
            local price = math.abs(math.floor(price))
            if myMoney >= price then
                SV.removeMoneySmart(Player, price)
                if Config.UseVMSTattooshop and Config.UseHairFadeInBarber and newHairFades and next(newHairFades) then
                    TriggerClientEvent('vms_tattooshop:barberFadesChanges', source, newHairFades)
                end
                cb(true, price)
            else
                cb(false)
            end
        end
    end)

    QBCore.Functions.CreateCallback('vms_barber:getCurrentSkin', function(source, cb)
        local Player = SV.getPlayer(source)
        local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {SV.getIdentifier(Player), 1})
        if result[1] then
            cb(result[1].skin)
        end
    end)
else
    Citizen.CreateThread(function()
        while true do
            print(('^8[WARNING] ^7- You missconfigure Config.Core: ^1"%s"^7, available: ^2"ESX"^7 / ^2"QB-Core"^7'):format(Config.Core))
            Citizen.Wait(7500)
        end
    end)
end

AddEventHandler('playerDropped', function(reason)
    if chairs[source] then
        TriggerClientEvent("vms_barber:cl:takeChair", -1, chairs[source].barberId, chairs[source].chairId, false)
        chairs[source] = nil
    end
end)

RegisterNetEvent("vms_barber:sv:takeChair")
AddEventHandler("vms_barber:sv:takeChair", function(barberId, chairId, toggle)
    local source = source
    chairs[source] = {
        barberId = barberId,
        chairId = chairId,
    }
    if toggle == true then
        toggle = source
    end
    TriggerClientEvent("vms_barber:cl:takeChair", -1, barberId, chairId, toggle)
end)

RegisterNetEvent("vms_barber:sendData")
AddEventHandler("vms_barber:sendData", function(data, tattoos, plBarberId)
    chairs[source].playerBarberId = plBarberId
    TriggerClientEvent("vms_barber:openBusiness", plBarberId, data, tattoos, source)
end)

RegisterNetEvent("vms_barber:getClientSkin")
AddEventHandler("vms_barber:getClientSkin", function(clientId)
    TriggerClientEvent("vms_barber:getData", clientId, source)
end)

RegisterNetEvent("vms_barber:sv:updateClientSkin")
AddEventHandler("vms_barber:sv:updateClientSkin", function(clientId, type, new)
    TriggerClientEvent("vms_barber:cl:updateClientSkin", clientId, type, new)
end)

RegisterNetEvent("vms_barber:sv:updateClientTattoos")
AddEventHandler("vms_barber:sv:updateClientTattoos", function(clientId, id)
    TriggerClientEvent("vms_barber:cl:updateClientTattoos", clientId, source, id)
end)

RegisterNetEvent("vms_barber:sv:removeClientTattoo")
AddEventHandler("vms_barber:sv:removeClientTattoo", function(clientId, id)
    TriggerClientEvent("vms_barber:cl:removeClientTattoo", clientId, source, id)
end)

RegisterNetEvent("vms_barber:sv:updatedClientTattoos")
AddEventHandler("vms_barber:sv:updatedClientTattoos", function(barber, Character_Temp_Tattoos, currentTattoos)
    TriggerClientEvent("vms_barber:cl:updatedClientTattoos", barber, Character_Temp_Tattoos, currentTattoos)
end)

RegisterNetEvent("vms_barber:updatedBarberFades")
AddEventHandler("vms_barber:updatedBarberFades", function(barber, fadesData)
    local src = source
    TriggerClientEvent("vms_barber:cl:businessUpdatedFades", src, fadesData)
    TriggerClientEvent("vms_barber:cl:businessUpdatedFades", barber, fadesData, true)
end)

RegisterNetEvent("vms_barber:sv:closedCam")
AddEventHandler("vms_barber:sv:closedCam", function()
    local src = source
    if chairs[src] and chairs[src].barberId and chairs[src].playerBarberId then
        TriggerClientEvent("vms_barber:cl:closedCam", chairs[src].playerBarberId, src)
    end
end)

RegisterNetEvent("vms_barber:sv:closeCam")
AddEventHandler("vms_barber:sv:closeCam", function(clientId)
    TriggerClientEvent("vms_barber:cl:closeCam", clientId)
    chairs[clientId] = nil
end)

RegisterNetEvent("vms_barber:sv:loadPlayerSkin")
AddEventHandler("vms_barber:sv:loadPlayerSkin", function(clientId)
    TriggerClientEvent("vms_barber:cl:loadPlayerSkin", clientId)
end)

RegisterNetEvent("vms_barber:sv:buyClientReceipt")
AddEventHandler("vms_barber:sv:buyClientReceipt", function(clientId, barberId, isChangingHairStyle, values, total, taxAmount)
    local src = source
    local canContinue = true
    local xPlayer = SV.getPlayer(src)
    if isChangingHairStyle and Config.UseHairClipperRequired then
        canContinue = false
        local xItem = Config.Core == "ESX" and xPlayer.getInventoryItem(Config.HairClipperItem).count or xPlayer.Functions.GetItemByName(Config.HairClipperItem) and (xPlayer.Functions.GetItemByName(Config.HairClipperItem).amount)
        if xItem and xItem >= 1 then
            canContinue = true
        else
            TriggerClientEvent("vms_barber:notification", src, TRANSLATE("notify.dont_have_hair_clipper"), 3950, "error")
        end
    end
    if canContinue then
        TriggerClientEvent('vms_barber:notification', src, TRANSLATE('notify.you_sent_bill'), 3500, 'success')
        TriggerClientEvent('vms_barber:cl:getBillFeedback', src, 'barber', tonumber(clientId), 'wait')
        TriggerClientEvent('vms_barber:cl:getBill', tonumber(clientId), values, total)
        playersHasBills[tostring(clientId)] = {
            barberPointId = barberId,
            barberId = src,
            isChangingHairStyle = isChangingHairStyle,
            total = total,
            taxAmount = taxAmount
        }
    end
end)

RegisterNetEvent('vms_barber:sv:payBill', function(type, paymentMethod, newHairFades)
    local src = source
    local xPlayer = SV.getPlayer(src)
    if not playersHasBills[tostring(src)] then
        return
    end

    local barberId = playersHasBills[tostring(src)].barberId
    local price = playersHasBills[tostring(src)].total

    if type == 'cancel' then
        TriggerClientEvent('vms_barber:cl:getBillFeedback', src, 'customer')
        TriggerClientEvent('vms_barber:cl:getBillFeedback', barberId, 'barber', src, type)
        playersHasBills[tostring(src)] = nil
        return
    end

    if xPlayer and price then
        local myMoney = SV.getCombinedMoney(xPlayer)
        local price = math.abs(math.floor(price))
        if myMoney >= price then
            SV.removeMoneySmart(xPlayer, price)
            
            local storeIdForBill = playersHasBills[tostring(src)].barberPointId
            stores[storeIdForBill].data['totalCustomers'] = (stores[storeIdForBill].data['totalCustomers'] or 0) + 1

            if Config.BillMoneyToSocietyPercent and playersHasBills[tostring(src)].barberPointId then
                local companyEarned = math.floor((price * Config.BillMoneyToSocietyPercent) / 100)
                addCompanyMoney(playersHasBills[tostring(src)].barberPointId, companyEarned, true)
            end

            if Config.UseVMSCityHall and Config.UseCityHallTaxes then
                exports[Config.VMSCityHallResource]:addCompanyFlatTaxAmount(Config.Barbers[playersHasBills[tostring(src)].barberPointId].ownerJob, playersHasBills[tostring(src)].taxAmount)
            end
            
            if Config.UseVMSTattooshop and Config.UseHairFadeInBarber and newHairFades and next(newHairFades) then
                TriggerClientEvent('vms_tattooshop:barberFadesChanges', src, newHairFades, barberId)
            end

            if Config.BillMoneyToBarberPercent then
                local xBarber = SV.getPlayer(barberId)
                SV.addMoney(xBarber, paymentMethod, math.floor((price * Config.BillMoneyToBarberPercent)/100))
            end

            TriggerClientEvent("vms_barber:cl:animation", barberId, playersHasBills[tostring(src)].isChangingHairStyle)
            TriggerClientEvent("vms_barber:cl:buyClient", src)
            
            playersHasBills[tostring(src)] = nil
        else
            TriggerClientEvent('vms_barber:notification', src, TRANSLATE('notify.nomoney'), 3500, 'error')
        end
    end
end)



getCompanyMoney = function(storeId)
    if Config.UseBuildInCompanyBalance then
        return stores[storeId].data['balance']
    else
        SV.getSocietyMoney(Config.Barbers[storeId].society_name, function(money)
            return money
        end)
    end
end
exports('getCompanyMoney', getCompanyMoney)

addCompanyMoney = function(storeId, amount, addToTotalEarned)
    if Config.UseBuildInCompanyBalance then
        stores[storeId].data['balance'] = stores[storeId].data['balance'] + amount
        if addToTotalEarned then
            stores[storeId].data['totalEarned'] = (stores[storeId].data['totalEarned'] or 0) + amount
        end
        MySQL.Async.execute('UPDATE vms_business SET data = @data WHERE id = @id', {['@data'] = json.encode(stores[storeId].data), ['@id'] = storeId})
        TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {
            {sub = "balance", value = stores[storeId].data['balance']},
            {sub = "totalCustomers", value = stores[storeId].data['totalCustomers']},
            addToTotalEarned and {sub = "totalEarned", value = stores[storeId].data['totalEarned']},
        })        
    else
        if Config.Barbers[storeId].society_name then
            SV.addSocietyMoney(Config.Barbers[storeId].society_name, amount)
        end
    end
end
exports('addCompanyMoney', addCompanyMoney)

removeCompanyMoney = function(storeId, amount)
    if Config.UseBuildInCompanyBalance then
        stores[storeId].data['balance'] = stores[storeId].data['balance'] - tonumber(amount)
        MySQL.Async.execute('UPDATE vms_business SET data = @data WHERE id = @id', {['@data'] = json.encode(stores[storeId].data), ['@id'] = storeId})
        TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "balance", value = stores[storeId].data['balance']})
    else
        SV.removeSocietyMoney(Config.Barbers[storeId].society_name, tonumber(amount))
    end
end
exports('removeCompanyMoney', removeCompanyMoney)

RegisterNetEvent("vms_barber:sendAnnouncement", function(storeId, text)
    local src = source
    
    local xPlayer = SV.getPlayer(src)
    if not SV.isPlayerManager(xPlayer, Config.Barbers[storeId].ownerJob, storeId) and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
        return
    end
    local myCharacterName = SV.getCharacterName(xPlayer)
    local announceId = #stores[storeId].announcements + 1
    stores[storeId].announcements[announceId] = {
        name = myCharacterName,
        message = text,
    }

    SV.Webhook('ANNOUNCEMENT', SV.WebhookText['TITLE.ANNOUNCEMENT'], SV.WebhookText['DESCRIPTION.ANNOUNCEMENT']:format(
        myCharacterName, src, storeId, text
    ), 16777215, SV.getIdentifier(xPlayer))
    
    MySQL.Async.execute('UPDATE vms_business SET announcements = @announcements WHERE id = @id', {
        ['@announcements'] = json.encode(stores[storeId].announcements), 
        ['@id'] = storeId
    })

    TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "announcements", value = stores[storeId].announcements})
end)
sendAnnouncement = function(src, storeId, text, type)
    local announceId = #stores[storeId].announcements + 1
    stores[storeId].announcements[announceId] = {
        name = type == "cityhall" and TRANSLATE('announcement.cityhall') or "unknown",
        message = text,
        type = type
    }
    TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "announcements", value = stores[storeId].announcements})
end
exports('sendAnnouncement', sendAnnouncement)

RegisterNetEvent("vms_barber:hireAnEmployee", function(storeId, playerId)
    local src = source
    if not stores[storeId] then return end
    local myPed = GetPlayerPed(src)
    local myCoords = GetEntityCoords(myPed)
    local employeePed = GetPlayerPed(playerId)
    local employeeCoords = GetEntityCoords(employeePed)
    local distance = #(myCoords - employeeCoords)
    if distance > 6.0 then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_too_far_away'), 4000, 'error')
        return
    end
    local xPlayer = SV.getPlayer(src)
    if not SV.isPlayerManager(xPlayer, Config.Barbers[storeId].ownerJob, storeId) and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
        return
    end
    local xEmployee = SV.getPlayer(playerId)
    if SV.isPlayerEmployee(xEmployee, Config.Barbers[storeId].ownerJob) then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_already_employed'), 4000, 'info')
        return
    end
    if Config.RequiredJobToBeHired and SV.getPlayerJob(xEmployee) ~= Config.RequiredJobToBeHired then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:must_be_unemployed'), 4000, 'info')
        return
    end
    local myCharacterName = SV.getCharacterName(xPlayer)
    local xIdentifier = SV.getIdentifier(xPlayer)
    SV.setPlayerJob(src, xEmployee, Config.Barbers[storeId].ownerJob, 0)

    SV.Webhook('EMPLOYEE_HIRE', SV.WebhookText['TITLE.EMPLOYEE_HIRE'], SV.WebhookText['DESCRIPTION.EMPLOYEE_HIRE']:format(
        myCharacterName, src, SV.getCharacterName(xEmployee), SV.getIdentifier(xEmployee), storeId
    ), 2287650, xIdentifier)
    
    TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:you_employee_hired'), 5500, 'success')
    TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "employees"})
end)

RegisterNetEvent("vms_barber:bonusEmployee", function(storeId, playerIdentifier, bonus)
    local src = source
    if not stores[storeId] then return end
    local xPlayer = SV.getPlayer(src)
    if not SV.isPlayerManager(xPlayer, Config.Barbers[storeId].ownerJob, storeId) and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
        return
    end
    local xIdentifier = SV.getIdentifier(xPlayer)
    local storeBalance = getCompanyMoney(storeId)
    
    if tonumber(storeBalance) < tonumber(bonus) then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.balance:store_dont_have_that_money'), 4500, 'error')
        return
    end
    local xEmployee = SV.getPlayerByIdentifier(playerIdentifier)
    if xEmployee then
        local myCharacterName = SV.getCharacterName(xPlayer)
        removeCompanyMoney(storeId, tonumber(bonus))
        SV.addMoney(xEmployee, 'bank', tonumber(bonus))
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:awarded_bonus', bonus), 4500, 'success')
        TriggerClientEvent("vms_barber:notification", xEmployee.source or xEmployee.PlayerData.source, TRANSLATE('notify.employees:received_bonus', bonus), 4500, 'success')
        if Config.UseBuildInCompanyBalance then
            TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "balance", value = stores[storeId].data.balance})
        else
            SV.getSocietyMoney(Config.Barbers[storeId].society_name, function(money)
                TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "balance", value = money})
            end)
        end
        SV.Webhook('EMPLOYEE_BONUS', SV.WebhookText['TITLE.EMPLOYEE_BONUS'], SV.WebhookText['DESCRIPTION.EMPLOYEE_BONUS']:format(
            myCharacterName, src, playerIdentifier, bonus, storeId
        ), 2287650, xIdentifier)
    else
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_offline'), 4500, 'error')
    end
end)

RegisterNetEvent("vms_barber:changeGradeEmployee", function(storeId, playerIdentifier, grade)
    local src = source
    if not stores[storeId] then return end
    local xPlayer = SV.getPlayer(src)
    local xIdentifier = SV.getIdentifier(xPlayer)
    if xIdentifier == playerIdentifier then
        return
    end
    local xEmployee = SV.getPlayerByIdentifier(playerIdentifier)
    if xEmployee then
        if not SV.isPlayerEmployee(xEmployee, Config.Barbers[storeId].ownerJob) then
            TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_not_employed'), 4500, 'error')
            return
        end
        if grade.needToBeBoss and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
            TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.you_are_not_owner'), 4500, 'error')
            return
        end
        if not grade.needToBeBoss and not SV.isPlayerManager(xPlayer, Config.Barbers[storeId].ownerJob, storeId) and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
            return
        end
        SV.setPlayerJob(src, xEmployee, Config.Barbers[storeId].ownerJob, grade.grade)

        local myCharacterName = SV.getCharacterName(xPlayer)
        SV.Webhook('EMPLOYEE_CHANGE_GRADE', SV.WebhookText['TITLE.EMPLOYEE_CHANGE_GRADE'], SV.WebhookText['DESCRIPTION.EMPLOYEE_CHANGE_GRADE']:format(
            myCharacterName, src, playerIdentifier, grade, storeId
        ), 5688406, xIdentifier)
    else
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_offline'), 4500, 'error')
    end
    TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "employees"})
end)

RegisterNetEvent("vms_barber:fireEmployee", function(storeId, playerIdentifier)
    local src = source
    if not stores[storeId] then return end
    local xPlayer = SV.getPlayer(src)
    if not SV.isPlayerManager(xPlayer, Config.Barbers[storeId].ownerJob, storeId) and not SV.isPlayerBoss(xPlayer, Config.Barbers[storeId].ownerJob, storeId) then
        return
    end
    local xIdentifier = SV.getIdentifier(xPlayer)
    local xEmployee = SV.getPlayerByIdentifier(playerIdentifier)
    if xEmployee then
        if not SV.isPlayerEmployee(xEmployee, Config.Barbers[storeId].ownerJob) then
            TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.employees:player_is_not_employed'), 4500, 'error')
            return
        end
        SV.setPlayerJob(src, xEmployee)
    else
        SV.setPlayerJob(src, playerIdentifier, nil, nil, true)
    end
    local myCharacterName = SV.getCharacterName(xPlayer)
    SV.Webhook('EMPLOYEE_FIRE', SV.WebhookText['TITLE.EMPLOYEE_FIRE'], SV.WebhookText['DESCRIPTION.EMPLOYEE_FIRE']:format(
        myCharacterName, src, playerIdentifier, storeId
    ), 10887971, xIdentifier)
    TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "employees"})
end)

withdrawManagement = function(storeId, amount)
    local src = source
    local xPlayer = SV.getPlayer(src)
    if amount > getCompanyMoney(storeId) then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.balance:store_dont_have_that_money'), 5500, 'error')
        return
    end
    TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.balance:withdraw', amount), 6500, 'success')
    SV.addMoney(xPlayer, 'cash', amount)
    removeCompanyMoney(storeId, amount)
    local myCharacterName = SV.getCharacterName(xPlayer)
    SV.Webhook('WITHDRAW', SV.WebhookText['TITLE.WITHDRAW'], SV.WebhookText['DESCRIPTION.WITHDRAW']:format(
        myCharacterName, src, amount, storeId
    ), 5766999, SV.getIdentifier(xPlayer))

    -- MySQL.Async.execute('UPDATE vms_business SET data = @data WHERE id = @id', {['@data'] = json.encode(stores[storeId].data), ['@id'] = storeId})
    -- TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "balance", value = stores[storeId].data['balance']})
end
RegisterNetEvent("vms_barber:withdraw", withdrawManagement)

depositManagement = function(storeId, amount)
    local src = source
    local xPlayer = SV.getPlayer(src)
    if amount > SV.getMoney(xPlayer, 'cash')  then
        TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.balance:you_dont_have_that_money'), 5500, 'error')
        return
    end
    TriggerClientEvent("vms_barber:notification", src, TRANSLATE('notify.balance:deposit', amount), 6500, 'success')
    SV.removeMoney(xPlayer, 'cash', amount)
    addCompanyMoney(storeId, amount)
    local myCharacterName = SV.getCharacterName(xPlayer)
    SV.Webhook('DEPOSIT', SV.WebhookText['TITLE.DEPOSIT'], SV.WebhookText['DESCRIPTION.DEPOSIT']:format(
        myCharacterName, src, amount, storeId
    ), 1146129, SV.getIdentifier(xPlayer))
    
    -- MySQL.Async.execute('UPDATE vms_business SET data = @data WHERE id = @id', {['@data'] = json.encode(stores[storeId].data), ['@id'] = storeId})
    -- TriggerClientEvent("vms_barber:updateBusiness", -1, storeId, nil, {sub = "balance", value = stores[storeId].data['balance']})
end
RegisterNetEvent("vms_barber:deposit", depositManagement)


RegisterNetEvent("vms_barber:fetchData", function()
    local src = source
    TriggerClientEvent("vms_barber:fetchedData", src, stores)
end)


MySQL.ready(function()
    if Config.AutoExecuteQuery then
        MySQL.Async.execute([[
            CREATE TABLE IF NOT EXISTS `vms_business` (
                `id` varchar(50) NOT NULL DEFAULT '',
                `type` varchar(50) NOT NULL DEFAULT '',
                `owner` mediumtext DEFAULT NULL,
                `employees` longtext DEFAULT '{}',
                `stock` longtext DEFAULT '{}',
                `data` longtext DEFAULT '{}',
                `announcements` longtext DEFAULT '{}',
                `orders` longtext DEFAULT '{}',
                `history` longtext DEFAULT '{}'
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])
    end
    
    for k, v in pairs(Config.Barbers) do
        MySQL.Async.fetchAll('SELECT * FROM vms_business WHERE id = @id AND type = @type', {
            ['@id'] = k,
            ['@type'] = 'barber'
        }, function(result)
            if result and result[1] then
                stores[k] = {
                    type = result[1].type,
                    data = json.decode(result[1].data),
                    announcements = json.decode(result[1].announcements),
                }
            else
                MySQL.Async.execute('INSERT INTO vms_business (`id`, `type`, `owner`, `employees`, `stock`, `data`, `announcements`, `orders`) VALUES (@id, @type, @owner, @employees, @stock, @data, @announcements, @orders)', {
                    ['@id'] = k, 
                    ['@type'] = 'barber', 
                    ['@owner'] = nil, 
                    ['@employees'] = json.encode({}), 
                    ['@stock'] = json.encode({}), 
                    ['@data'] = json.encode({
                        balance = 0,
                        totalCustomers = 0,
                        totalEarned = 0,
                    }),
                    ['@announcements'] = json.encode({}), 
                    ['@orders'] = json.encode({}), 
                })
                stores[k] = {
                    type = 'barber',
                    stock = {},
                    data = {
                        balance = 0,
                        totalCustomers = 0,
                        totalEarned = 0,
                    },
                    announcements = {},
                }
            end
        end)
    end
end)