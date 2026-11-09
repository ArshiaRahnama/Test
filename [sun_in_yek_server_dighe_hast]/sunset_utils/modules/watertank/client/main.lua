-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local cachedData = {}
local cd = false
local function drinkWater()
    local timeStarted = GetGameTimer()
    ESX.Streaming.RequestModel(GetHashKey("prop_cs_shot_glass"))
    ESX.Game.SpawnObject("prop_cs_shot_glass", {
        GetEntityCoords(PlayerPedId())
    }, function(obj)
        AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, 0.028, 0.018, -95.0, 20.0, -40.0, true, true, false, true, 1, true)
        while not HasAnimDictLoaded("mp_player_intdrink") do
            Citizen.Wait(0)
            RequestAnimDict("mp_player_intdrink")
        end
        cachedData["drinking"] = true
        Citizen.CreateThread(function()
            while GetGameTimer() - timeStarted < 10000 do
                Citizen.Wait(1000)
                if not IsEntityPlayingAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 3) then
                    TaskPlayAnim(PlayerPedId(), "mp_player_intdrink", "loop_bottle", 1.0, -1.0, 2000, 49, 0, 0, 0, 0)
                end
                TriggerEvent("esx_status:add", "thirst", 5000)
            end
            cachedData["drinking"] = false
            DeleteEntity(obj)
        end)
        RemoveAnimDict("mp_player_intdrink")
        SetModelAsNoLongerNeeded(GetHashKey("prop_cs_shot_glass"))
    end)
end

Citizen.CreateThread(function()
    waitForLoad()
    exports['ox_target']:addModel({-742198632}, {
        {
            label = "🌊آب خوردن",
            onSelect = function(entity)
                if not cd or cd < GetGameTimer() then
                    cd = GetGameTimer() + 10000
                    drinkWater()
                end
            end,
        },
    })
end)