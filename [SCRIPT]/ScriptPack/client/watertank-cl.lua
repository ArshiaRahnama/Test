Water = {}
Water.WaterPrice = 2
Water.TankModel = -742198632
Water.DrinkingTime = 10000
ESX = nil
cachedData = {}

Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent("esx:getSharedObject", function(library)
            ESX = library
        end)
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
    ESX.PlayerData = playerData
end)

PurchaseDrink = function()
    Drink()
end

Drink = function()
    local timeStarted = GetGameTimer()
    WaitForModel(GetHashKey("prop_cs_shot_glass"))
    ESX.Game.SpawnObject("prop_cs_shot_glass", {
        GetEntityCoords(PlayerPedId())
    }, function(obj)
        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
        while not HasAnimDictLoaded("mp_player_intdrink") do
            Citizen.Wait(1)
            RequestAnimDict("mp_player_intdrink")
        end
        cachedData["drinking"] = true
        Citizen.CreateThread(function()
            while GetGameTimer() - timeStarted < Water.DrinkingTime do
                Citizen.Wait(100)
                if not IsEntityPlayingAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 3) then
                    TaskPlayAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
                end
                TriggerEvent("esx_status:add", "thirst", 1000)
            end
            cachedData["drinking"] = false
            DeleteEntity(obj)
        end)
        RemoveAnimDict("mp_player_intdrink")
        SetModelAsNoLongerNeeded(GetHashKey("prop_cs_shot_glass"))
    end)
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return ESX.ShowNotification("This model does not exist in-game.")
    end
    if not HasModelLoaded(model) then
        RequestModel(model)
    end
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
end

CreateThread(function()
    exports.ox_target:addModel(Water.TankModel, {
        {
            label = "Drink Water",
            icon = "fas fa-glass-water",
            distance = 1.5,
            onSelect = function()
                PurchaseDrink()
            end
        }
    })
end)