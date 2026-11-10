-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local startCoords = {}
local tripState = false
local lastPassenger = 0
function startMeter()
    if tripState then
        ESX.TriggerServerEvent('taxi:endTrip')
    else
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local maxSeat = GetVehicleMaxNumberOfPassengers(vehicle)
            local passengersList = {}
            for i=maxSeat - 1, 0, -1 do
                local ped = GetPedInVehicleSeat(vehicle, i)
                if ped ~= 0 then
                    local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                    if serverId ~= ESX.src then
                        table.insert(passengersList, {label = serverId, value = serverId})
                    end
                end
            end
            if #passengersList > 0 then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kodum',
                {
                    title 	 = 'Safar be nam kodam fard sabt shavad?',
                    align    = 'top-left',
                    elements = passengersList
                }, function(data, menu)
                    menu.close()
                    if not ESX.isVehicleDriver() then return ESX.Alert('','Shoma ranande mashin nisid!', 5000, 'error') end
                    ESX.TriggerServerEvent('taxi:startTrip', data.current.value)
                    lastPassenger = data.current.value
                end, function(data, menu)
                    menu.close()
                end)
            else
                ESX.Alert('','Kasi baraye shorue safar dar mashin nist!', 5000, 'error')
            end
        else
            ESX.Alert('','Shoma batad savar mashin bashid!', 5000, 'error')
        end
    end
end

RegisterNetEvent('taxi:startTrip', function(travelCoords, taxi, startPrice)
    if not tripState then
        tripState = true
        startCoords = travelCoords
        CreateThread(function()
            while tripState do
                Wait(1000)
                local coords =  GetEntityCoords(PlayerPedId())
                local distance = CalculateTravelDistanceBetweenPoints(startCoords.x, startCoords.y, startCoords.z, coords.x, coords.y, coords.z) * 0.621
                local price = ESX.Math.Round((distance / 1000) * Shared.taxi.tripPrice + (not startPrice and Shared.taxi.tripStartPrice or 0))
                if distance > 10000 then
                    distance = (ESX.GetDistance(startCoords, coords) * 0.621)
                    price = ESX.Math.Round((distance / 1000) * Shared.taxi.tripPriceMethod2 + (not startPrice and Shared.taxi.tripStartPrice or 0))
                end
                SendNUIMessage({type = 'update_meter', data = {
                    visible = IsPedInAnyVehicle(PlayerPedId(), false),
                    distance = ESX.Math.Round(distance / 1000, 2) .. 'mi' ,
                    price = '$' .. price,
                    priceLabel = '1mi  $'.. ESX.Math.Round(Shared.taxi.tripPrice/1000) ..'K',
                }})
                if taxi then
                    ESX.TriggerServerEvent('taxi:updateTripPrice', price, distance)
                    if not ESX.Game.DoesPlayerExist(lastPassenger) or ESX.GetDistance(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(lastPassenger))), coords) > 100 then
                        ESX.TriggerServerEvent('taxi:endTrip')
                        Wait(5000)
                    end
                end
            end
            SendNUIMessage({type = 'update_meter', data = {
                visible = false,
                distance = 0 ,
                price = 0,
                priceLabel = '1mi  $'.. ESX.Math.Round(Shared.taxi.tripPrice/1000) ..'K',
            }})
        end)
    end
end)

RegisterNetEvent('taxi:stopTrip', function()
    tripState = false
    startCoords = {}
    Wait(2000)
    SendNUIMessage({type = 'update_meter', data = {
        visible = false,
        distance = 0 ,
        price = 0,
        priceLabel = '1mi  $'.. ESX.Math.Round(Shared.taxi.tripPrice/1000) ..'K',
    }})
end)

RegisterNetEvent('taxi:fine', function(target, price)
    ESX.TriggerServerEvent('esx_billing:send2Bill', target , '', 'Taxi #2', price, true)
end)

function getTaxiTripState()
    return tripState
end