
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


local IsAnimated = false

RegisterNetEvent('AH_uwucafejob:onDrinkabporteghal')
AddEventHandler('AH_uwucafejob:onDrinkabporteghal', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_drink_whisky' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            bubbletetotfarangi

RegisterNetEvent('AH_uwucafejob:onDrinkbubbletetotfarangi')
AddEventHandler('AH_uwucafejob:onDrinkbubbletetotfarangi', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)


---------            boba_milk_tea_caramel

RegisterNetEvent('AH_uwucafejob:onDrinkboba_milk_tea_caramel')
AddEventHandler('AH_uwucafejob:onDrinkboba_milk_tea_caramel', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            boba_milk_tea_matcha

RegisterNetEvent('AH_uwucafejob:onDrinkboba_milk_tea_matcha')
AddEventHandler('AH_uwucafejob:onDrinkboba_milk_tea_matcha', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            bobal_tea_matcha

RegisterNetEvent('AH_uwucafejob:onDrinkbobal_tea_matchaa')
AddEventHandler('AH_uwucafejob:onDrinkbobal_tea_matchaa', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            bobal_tea_tamshak

RegisterNetEvent('AH_uwucafejob:onDrinkbobal_tea_tamshak')
AddEventHandler('AH_uwucafejob:onDrinkbobal_tea_tamshak', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            ice_coffee_matcha

RegisterNetEvent('AH_uwucafejob:onDrinkice_coffee_matcha')
AddEventHandler('AH_uwucafejob:onDrinkice_coffee_matcha', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)


---------            bastani

RegisterNetEvent('AH_uwucafejob:onDrinkbastani')
AddEventHandler('AH_uwucafejob:onDrinkbastani', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)



---------    chaee

RegisterNetEvent('AH_uwucafejob:onDrinkchaee')
AddEventHandler('AH_uwucafejob:onDrinkchaee', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_drink_whisky' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------    ghahve

RegisterNetEvent('AH_uwucafejob:onDrinkghahve')
AddEventHandler('AH_uwucafejob:onDrinkghahve', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'p_amb_coffeecup_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

--------------- hot_chocolate

RegisterNetEvent('AH_uwucafejob:onDrinkhot_chocolate')
AddEventHandler('AH_uwucafejob:onDrinkhot_chocolate', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'p_amb_coffeecup_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

----------------   latte
RegisterNetEvent('AH_uwucafejob:onDrinklatte')
AddEventHandler('AH_uwucafejob:onDrinklatte', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'p_amb_coffeecup_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

-------------- milkshake
RegisterNetEvent('AH_uwucafejob:onDrinkmilkshake')
AddEventHandler('AH_uwucafejob:onDrinkmilkshake', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'p_amb_coffeecup_01'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

-------------- milk_shake_shokolati
RegisterNetEvent('AH_uwucafejob:onDrinkmilk_shake_shokolati')
AddEventHandler('AH_uwucafejob:onDrinkmilk_shake_shokolati', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'p_amb_coffeecup_01'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

-------            suop

RegisterNetEvent('AH_uwucafejob:onDrinksuop')
AddEventHandler('AH_uwucafejob:onDrinksuop', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_ecola_can'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)


            ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()

                TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)


                Citizen.Wait(15000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            cake_limoii

RegisterNetEvent('AH_uwucafejob:onEatcake_limoii')
AddEventHandler('AH_uwucafejob:onEatcake_limoii', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'bzzz_icecream_lemon' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.01, 85.0, 70.0, -203.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 1500 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            cupcake_shokolati

RegisterNetEvent('AH_uwucafejob:onEatcupcake_shokolati')
AddEventHandler('AH_uwucafejob:onEatcupcake_shokolati', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'bzzz_icecream_chocolate' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.01, 85.0, 70.0, -203.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 1500 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            mufchocolate

RegisterNetEvent('AH_uwucafejob:onEatmufchocolate')
AddEventHandler('AH_uwucafejob:onEatmufchocolate', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'bzzz_icecream_chocolate' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.01, 85.0, 70.0, -203.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 1500 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            muffin_tamshak

RegisterNetEvent('AH_uwucafejob:onEatmuffin_tamshak')
AddEventHandler('AH_uwucafejob:onEatmuffin_tamshak', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'bzzz_icecream_cherry' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.14, 0.03, 0.01, 85.0, 70.0, -203.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 1500 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------            cakebastani


RegisterNetEvent('AH_uwucafejob:onEatcakebastani')
AddEventHandler('AH_uwucafejob:onEatcakebastani', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 1500 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  cakebastanivanili

RegisterNetEvent('AH_uwucafejob:onEatcakebastanivanili')
AddEventHandler('AH_uwucafejob:onEatcakebastanivanili', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  caketotfarangi

RegisterNetEvent('AH_uwucafejob:onEatcaketotfarangi')
AddEventHandler('AH_uwucafejob:onEatcaketotfarangi', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  nodel
RegisterNetEvent('AH_uwucafejob:onEatnodel')
AddEventHandler('AH_uwucafejob:onEatnodel', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  vafel_nutella
RegisterNetEvent('AH_uwucafejob:onEatvafel_nutella')
AddEventHandler('AH_uwucafejob:onEatvafel_nutella', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  tiramisuye_toot_farangi
RegisterNetEvent('AH_uwucafejob:onEattiramisuye_toot_farangi')
AddEventHandler('AH_uwucafejob:onEattiramisuye_toot_farangi', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  pankik_oreo
RegisterNetEvent('AH_uwucafejob:onEatpankik_oreo')
AddEventHandler('AH_uwucafejob:onEatpankik_oreo', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  pankik_nutella

RegisterNetEvent('AH_uwucafejob:onEatpankik_nutella')
AddEventHandler('AH_uwucafejob:onEatpankik_nutella', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  pankik

RegisterNetEvent('AH_uwucafejob:onEatpankik')
AddEventHandler('AH_uwucafejob:onEatpankik', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_sandwich_01' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

---------------  cupcake

RegisterNetEvent('AH_uwucafejob:onEatcupcake')
AddEventHandler('AH_uwucafejob:onEatcupcake', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'bzzz_icecream_cherry' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)



----------- shokolat 

RegisterNetEvent('AH_uwucafejob:onEatshokolat')
AddEventHandler('AH_uwucafejob:onEatshokolat', function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_choc_ego' 
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 60309)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()

                
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_inteat@burger', 1.0, -1.0, -1, 50, 1, true, true, true)

                
                local totalDuration = 10000
                local interval = 5000 
                local startTime = GetGameTimer()

                while GetGameTimer() - startTime < totalDuration do
                    Citizen.Wait(interval) 

                    TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0, -1.0, -1, 50, 1, true, true, true)
                end

                Citizen.Wait(totalDuration)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)