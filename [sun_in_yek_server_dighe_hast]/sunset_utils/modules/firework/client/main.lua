-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ExplosionsCount = 20

local Fireworks = {
    { asset = 'scr_indep_fireworks', name = 'scr_indep_firework_starburst',       addExplosion = true },
}

local AdditionnalExplosions = {
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_ring_leader_inner2'   },                        
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_ring_leader_outer'    },                        
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_ring_leader_inner'    },                        
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_spiral_leader_r'      },                    
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_repeat_leader2'       },                    
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_repeat_leader3'       },                    
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_repeat_leader'        },                    
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_spiral_leader'        },                    
    -- { asset = 'proj_xmas_firework',  name = 'scr_firework_indep_spiral_burst_rwb'          },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_flare_white'          },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_flare_green'          }, 
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_ring_green'           },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_firework_xmas_spiral_burst_rgw'           },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_flare_red'            },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_firework_indep_ring_burst_rwb'            },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_trail_smoke_red'            },                
    -- { asset = 'proj_xmas_firework',  name = 'scr_firework_xmas_ring_burst_rgw'             },            
    -- { asset = 'proj_xmas_firework',  name = 'scr_xmas_firework_burst_ring_red'             },        

    { asset = 'proj_xmas_firework',      name = 'scr_firework_xmas_repeat_burst_rgw'          }, 
    { asset = 'proj_indep_firework_v2',  name = 'scr_firework_indep_ring_burst_rwb'           }, 
    { asset = 'proj_indep_firework_v2',  name = 'scr_firework_indep_burst_rwb'                }, 
    { asset = 'proj_indep_firework_v2',  name = 'scr_firework_indep_spiral_burst_rwb'         }, 

}

RegisterNetEvent('sunset_utils:startFireworks')
AddEventHandler('sunset_utils:startFireworks', function()
	local playerPed = PlayerPedId()
	
	local count = ExplosionsCount

    local anim = 'place_firework_3_box'
    local animDict = 'anim@mp_fireworks'
    ESX.Streaming.RequestAnimDict(animDict)    
	TaskPlayAnim(playerPed, animDict, anim, -1.0, -1.0, 3000, 0, 0, false, false, false)
    Citizen.Wait(1500)   

    local playerCoords = GetEntityCoords(playerPed)
    ESX.Game.SpawnObject('ind_prop_firework_03',playerCoords,function(box)
        PlaceObjectOnGroundProperly(box)
        FreezeEntityPosition(box, true)
        
        Citizen.Wait(1000)
        ClearPedTasks(playerPed)
        Citizen.Wait(10000)
        
        local boxCoords = GetEntityCoords(box)

        repeat
            CreateFireWork(boxCoords)
            count = count - 1
            Citizen.Wait(4000)
        until(count == 0)

        -- Final 
        for i = 1, 3 do
            for j=1, 3 do 
                CreateFireWork(boxCoords)
                Citizen.Wait(300)
            end
            Citizen.Wait(1000)
        end
        
        ESX.Game.DeleteEntity(box)
    end)
end)

function CreateFireWork(coords)
    Citizen.CreateThread(function()
        local randomFirework = Fireworks[math.random(1, #Fireworks)]
        ESX.Streaming.RequestNamedPtfxAsset(randomFirework.asset)

        if math.random(1, 5) == 1 then 
            for i = 1, math.random(6) do 
                local randomHeading = math.random(1, 360)
                UseParticleFxAssetNextCall(randomFirework.asset)
                StartNetworkedParticleFxNonLoopedAtCoord(randomFirework.name, coords, 30.0, 0.0, randomHeading * 1.0, 2.0, false, false, false, false)
            end
        else 
            UseParticleFxAssetNextCall(randomFirework.asset)
            StartNetworkedParticleFxNonLoopedAtCoord(randomFirework.name, coords, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
        end
    
        Citizen.Wait(1000)
    
        -- Multiple random explosion
        if randomFirework.addExplosion and math.random(1,2) == 1 then
            for i = 1, math.random(2, 6) do
                Citizen.Wait(math.random(50, 150))
                local xOffset, yOffset, zOffset = math.random(-20, 20), math.random(-20, 20), math.random(0, 75)
                local explodeCoords = vector3(coords.x + xOffset, coords.y + yOffset, coords.z + 50.0 + zOffset)
                local randomExplosion = AdditionnalExplosions[math.random(1, #AdditionnalExplosions)]
                ESX.Streaming.RequestNamedPtfxAsset(randomExplosion.asset)
                UseParticleFxAssetNextCall(randomExplosion.asset)
                StartNetworkedParticleFxNonLoopedAtCoord(randomExplosion.name, explodeCoords, 0.0, 0.0, 0.0, math.random(10,20)/10.0, false, false, false, false)
            end
        end
    end)
end


RegisterNetEvent('firework:startFirecracker', function()
    local playerPed = PlayerPedId()
	
	local count = ExplosionsCount

    local anim = 'place_firework_3_box'
    local animDict = 'anim@mp_fireworks'
    ESX.Streaming.RequestAnimDict(animDict)    
	TaskPlayAnim(playerPed, animDict, anim, -1.0, -1.0, 3000, 0, 0, false, false, false)
    Citizen.Wait(2000)
    ESX.Game.SpawnObject('imp_prop_bomb_ball', GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0),function(bomb)
        PlaceObjectOnGroundProperly(bomb)
        FreezeEntityPosition(bomb, true)
        SetEntityCollision(bomb, false, true)
        local bombCoords = GetEntityCoords(bomb)
        Citizen.Wait(1000)
        ClearPedTasks(playerPed)
        ESX.TriggerServerEvent('firework:bombAlarm', NetworkGetNetworkIdFromEntity(bomb), ESX.getPlayersToSend(300))
        Citizen.Wait(14500)
        AddExplosion(bombCoords, 1, 1.0, false, false, 1.0, true)
        -- ESX.Game.DeleteEntity(bomb)
    end)
end)

-- RegisterCommand('susd', function(src, args)
--     local coords = vec(100.66, 2863.78, 51.49)
--     AddExplosion(coords, tonumber(args[1]), 1.0, false, false, 1.0, true)
-- end)

RegisterNetEvent('firework:bombAlarm', function(entity)
    if NetworkDoesNetworkIdExist(entity) then
        entity = NetworkGetEntityFromNetworkId(entity)
        if DoesEntityExist(entity) then
            local coords = GetEntityCoords(entity)
            exports['xsound']:PlayUrlPos('wick', './sounds/wickburning.mp3', 0.05, coords, nil, {
                distance = 50,
            })
            exports['xsound']:Distance('wick', 50)
            CreateThread(function()
                local draw = false
                local sec = 0
                repeat
                    draw = not draw
                    SetEntityDrawOutline(entity, draw)
                    sec = sec + 1
                    Wait(1000)
                until(sec >= 14)
                SetEntityDrawOutline(entity, false)
                exports['xsound']:PlayUrlPos('bomb', './sounds/bomb.mp3', 0.05, coords, nil, {
                    distance = 50,
                })
                exports['xsound']:Distance('bomb', 50)
            end)
        end
    end
end)