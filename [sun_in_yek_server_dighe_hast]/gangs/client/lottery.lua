-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('getLotteryData', function(data, cb)
    local lotteryType = data.lotteryType

    if not lotteryType then
        SendNUIMessage({
            type = 'lotteryData',
            lotteryConfig = exports['sun-robbery']:getLotteryConfig(),
        })
        cb('ok')
        return
    end

    ESX.TriggerServerCallback('rob:getLotteryData', function(planCount, ticketLottery, nextLotteryTime, lotteryWinner, gangPoint, ts)
        local data = {
            type = 'lotteryData',
            lotteryActive = ticketLottery.canBuy and true or false,
            planCount = planCount,
            gangPoint = gangPoint,
        }
        data.lastWinner =  ''
        if lotteryWinner and lotteryWinner.name then
            -- data.lastWinner = ('%s(%s)'):format(lotteryWinner.name, lotteryWinner.count)
            data.lastWinner = ('%s'):format(lotteryWinner.name)
        end
        data.lotteryRobberies = exports['sun-robbery']:getLotteryRobbery(tonumber(lotteryType))

        if ticketLottery.canBuy then
            data.secondToFinish = ticketLottery.endTime - ts
            data.canPutPlan = (ticketLottery.endTime - ts) > 5

            local registeredList = {}
            for k, v in pairs(ticketLottery.list) do
                table.insert(registeredList, {name = k})
                if k == ESX.PlayerData.gang.name then
                    data.placedPlan = v.count or 0
                end
            end
            data.lotteryRegisteredList = registeredList
        else
            data.secondToStart = nextLotteryTime - ts
            data.lotteryRegisteredList = {}
        end

        if not data.placedPlan then
            data.placedPlan = 0
        end

		SendNUIMessage(data)
	end, tonumber(lotteryType))

    cb('ok')
end)


RegisterNUICallback('addPlanToLottery', function(data, cb)
    local amount = data.amount
    local lotteryType = data.lotteryType

    ESX.TriggerServerEvent('rob:registerLottery', tonumber(lotteryType), tonumber(amount))

    cb('ok')
end)
