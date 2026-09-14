ESX = nil
AdminPlayers = {}
tempOown = false

local Table = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterCommand(
    "carp",
    function(source, args)
        local playerperm = ESX.GetPlayerFromId(source).permission_level
        if playerperm >= 5 then
            if args[1] ~= nil then
                exports.oxmysql:scalar(
                    "SELECT vehicle FROM owned_vehicles WHERE plate = @plate",
                    {["plate"] = args[1]},
                    function(data)
                        if not data then
                            TriggerEvent("esx:showNotification", "~r~Mashini Ba In Plak Peyda Nashod!")
                            return
                        end
                        local vehicle = json.decode(data)
                        TriggerClientEvent("Mid_Admin:SpawnVehicle", source, vehicle, args[1])
                        print(vehicle)
                    end
                )
            end
        else
            TriggerEvent("esx:showNotification", "~h~~b~Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid!")
        end
    end,
    false
)

