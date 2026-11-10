-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local threadActive, adminsList = false, {}

local function adminTagThread()
    if not threadActive then
        threadActive = true
        CreateThread(function()
            while threadActive do
                local coords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(adminsList) do
                    v.distance = #(coords - GetEntityCoords(v.ped))
                end
                Wait(3000)
            end
        end)
        CreateThread(function()
            RequestStreamedTextureDict('adminSprite')
            while threadActive do
                local ratio = GetAspectRatio(true)
                local finalRenderedCamCoords,finalRenderedCamFov = GetFinalRenderedCamCoord(), GetFinalRenderedCamFov()
                for k, v in pairs(adminsList) do
                    if v.distance and v.distance < 80.0 and IsEntityVisible(v.ped) and DoesEntityExist(v.ped) then
                        local coords = GetEntityCoords(v.ped)
                        local scale = (1.0/#(finalRenderedCamCoords - coords)) * (1.0/finalRenderedCamFov) * 10.0
                        DrawText3D(coords.x, coords.y, coords.z+1.1, v.name, 255, 215, 0)
                        SetDrawOrigin(coords.x, coords.y, coords.z + 1.3)
                        DrawSprite('adminSprite', 'canny', 0.0, 0.0, scale, scale * ratio, 0.0, 255, 255, 255, 255)
                        ClearDrawOrigin()
                    end
                end
                Wait(0)
            end
        end)
    end
end

AddStateBagChangeHandler('adminTag', nil, function(bagName, key, value)
    if not bagName:match('player:') then return end
    local player = tonumber(bagName:gsub('player:', ''), 10)
    if value then
        local playerId = GetPlayerFromServerId(player)
        if player == ESX.src and ESX.GetPlayerData().permission_level == 0 then
            ESX.alarm('Enabled admin tag without perm', 20)
        end
        local ped = ESX.getPlayerPed(playerId)
        adminsList[player] = {
            ped = ped,
            playerId = playerId,
            name = GetPlayerName(playerId, true),
        }
        if not threadActive then
            adminTagThread()
        end
    else
        adminsList[player] = nil
        if ESX.TableLength(adminsList) == 0 then
            threadActive = false
        end
    end
end)

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('onPlayerDropped', function(player)
    if adminsList[player] then
        adminsList[player] = nil
        if ESX.TableLength(adminsList) == 0 then
            threadActive = false
        end
    end
end)