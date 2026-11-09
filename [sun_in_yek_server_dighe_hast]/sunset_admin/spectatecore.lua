-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
changed = false
local canAcceptList = {}
local canAcceptList2 = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    Wait(2000)
    ESX.RegisterClientCallback('report:canAccept', function(cb, src)
        cb(canAcceptList[src], canAcceptList2[src])
    end)
end)
fbi = false
local balaBala = false
InSpectatorMode	= false
TargetSpectate	= nil
spec = {}
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			    = -3.5;
local cam 				    = nil
local ShowInfos			  = false
local accelerationacceleration, acceleration2, accelerationUpdate = 0, 0
function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
    local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
    local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

    local pos = {
        x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
        y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
        z = entityPosition.z - radius * math.cos(azimuthAngleRad)
    }

    return pos
end

function spectate(serverid,ff, bala)
    if GetPlayerServerId(PlayerId()) == serverid then
        return
    end
    local p = promise.new()
    acceleration = 0
    SetTimeout(3000, function()
        canAcceptList[serverid] = true
    end)
    SetTimeout(5000, function()
        canAcceptList2[serverid] = true
    end)
    SetTimeout(60000, function()
        canAcceptList[serverid] = nil
        canAcceptList2[serverid] = nil
    end)
    ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
        if data then
            if ff then
                fbi = ff
            else
                fbi = false
            end
            balaBala = bala
            if not InSpectatorMode then
                LastPosition = GetEntityCoords(GetPlayerPed(-1))
                TriggerServerEvent('ssadmin:hidetag',true)
                Wait(250)
            else
                NetworkSetInSpectatorMode(false, 0)
                TargetSpectate = nil
                local playerPed = GetPlayerPed(-1)
                DetachEntity(playerPed, true, true)
                SetEntityCompletelyDisableCollision(playerPed, true, true)
            end
            if data.world ~= 0 then
                TriggerServerEvent('cw',data.world)
                changed = true
                Wait(300)
            end
            SetPlayerInvincible(PlayerId(), true)
            ESX.TriggerServerCallback('getplayercoords', function(coords)
                local coords = coords
                exports.suncore:SetPlayerVisible(false)
                local crds = vector3(coords.x, coords.y, coords.z - 10)
                ESX.SetEntityCoords(GetPlayerPed(-1), crds)
                local Timer = GetGameTimer()
                while not ESX.Game.PlayerExist(serverid) or (GetGameTimer() - Timer > 10000)  do
                    Wait(1)
                end
                if not ESX.Game.PlayerExist(serverid) then return end
                local pl  = GetPlayerFromServerId(serverid)
                local pl2 = GetPlayerPed(pl)
    
                local Timer = GetGameTimer()
                while not DoesEntityExist(pl2) or (GetGameTimer() - Timer > 5000) do
                    Wait(0)
                    pl2 = GetPlayerPed(pl)
                end
    
                if DoesEntityExist(pl2) then
                    NetworkSetInSpectatorMode(true, pl2)
                    InSpectatorMode = true
                    TargetSpectate = serverid
                    -- Notify server baraye spectate tracking (rank 20+ admins)
                    TriggerServerEvent('ssadmin:startSpectate', serverid)
                else
                    resetNormalCamera()
                    SetPlayerInvincible(PlayerId(), false)
                end
            end,serverid)
            p:resolve(true)
        else
            p:resolve(false)
        end
    end, serverid)
    return Citizen.Await(p)
end

function resetNormalCamera()
    local playerPed = GetPlayerPed(-1)
    InSpectatorMode = false
    spec[lastspec] = false
    TargetSpectate  = nil
    lastspec = 0
    sp = 0

    NetworkSetInSpectatorMode(false, 0)
    DetachEntity(playerPed, true, true)
    ESX.SetEntityCoords(playerPed, LastPosition)

    if not invisibility then
        exports.suncore:SetPlayerVisible(true)
    end
    SetEntityCompletelyDisableCollision(playerPed, true, true)

    SetTimeout(500, function()
        TriggerServerEvent('ssadmin:hidetag', false)
    end)
    -- Stop spectate tracking
    TriggerServerEvent('ssadmin:stopSpectate')
    if changed then
        changed = false
        TriggerServerEvent('cw',0)
        Wait(300)
    end
end

function OpenAdminActionMenu(player)

    ESX.TriggerServerCallback('sunset_admin:getOtherPlayerData', function(data)

            local jobLabel    = nil
            local sexLabel    = nil
            local sex         = nil
            local dobLabel    = nil
            local idLabel     = nil
            local Money		= 0
            local Bank		= 0
            local Inventory	= nil

            if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
                jobLabel = 'Job : ' .. data.job.label .. ' - ('.. data.job.grade ..') - ' .. data.job.grade_label
            else
                jobLabel = 'Job : ' .. data.job.label
            end

            if data.sex ~= nil then
                if (data.sex == 'm') or (data.sex == 'M') then
                    sex = 'Male'
                else
                    sex = 'Female'
                end
                sexLabel = 'Sex : ' .. sex
            else
                sexLabel = 'Sex : Unknown'
            end

            if data.dob ~= nil then
                dobLabel = 'DOB : ' .. data.dob
            else
                dobLabel = 'DOB : Unknown'
            end

            if data.money ~= nil then
                Money = data.money
            else
                Money = 'No Data'
            end

            if data.bank ~= nil then
                Bank = data.bank
            else
                Bank = 'No Data'
            end

            if data.name ~= nil then
                idLabel = 'Steam ID : ' .. GetPlayerName(player)
            else
                idLabel = 'Steam ID : Unknown'
            end

            local elements = {
                {label = 'World: ' .. data.world, value = nil},
                {label = 'Name: ' .. string.gsub(data.name, "_", " "), value = nil},
                {label = 'Level: '.. data.level, value = nil},
                {label = 'Flag: '.. (ESX.GetPlayerState(GetPlayerServerId(player), 'fatmaState') and 'true' or 'false'), value = nil},
                {label = 'Money: '.. ESX.Math.GroupDigits(data.money), value = nil},
                {label = 'Bank: '.. ESX.Math.GroupDigits(data.bank), value = nil},
                {label = 'TC: '.. data.tc, value = nil},
                {label = 'Gang: '.. data.gang.name .. '('.. data.gang.grade ..')', value = nil},
                {label = jobLabel,    value = nil},
                {label = idLabel,     value = nil},
            }

            table.insert(elements, {label = '--- Inventory ---', value = nil})

            for i=1, #data.inventory, 1 do
                if data.inventory[i].count > 0 then
                    table.insert(elements, {
                        label          = data.inventory[i].label .. ' x ' .. ESX.Math.GroupDigits(data.inventory[i].count),
                        value          = nil,
                        itemType       = 'item_standard',
                        amount         = data.inventory[i].count,
                    })
                end
            end

            table.insert(elements, {label = '--- Weapons ---', value = nil})

            for i=1, #data.weapons, 1 do
                table.insert(elements, {
                    label          = ESX.GetWeaponLabel(data.weapons[i].name),
                    value          = nil,
                    itemType       = 'item_weapon',
                    amount         = data.ammo,
                })
            end
            if data.licenses ~= nil then

                table.insert(elements, {label = '--- Licenses ---', value = nil})

                for i=1, #data.licenses, 1 do
                    table.insert(elements, {label = data.licenses[i].label, value = nil})
                end

            end

            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'citizen_interaction',
                {
                    title    = 'Player Control',
                    align    = 'top-left',
                    elements = elements,
                },
                function(data, menu)

                end,
                function(data, menu)
                    menu.close()
                end
            )

    end, GetPlayerServerId(player))
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if InSpectatorMode and TargetSpectate then
            local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
            -- local playerPed	  = GetPlayerPed(-1)
            local targetPed	= GetPlayerPed(targetPlayerId)
            if ESX.Game.PlayerExist(TargetSpectate) then
                exports.suncore:SetPlayerVisible(false)
                if fbi then
                    AttachEntityToEntity(GetPlayerPed(-1), targetPed, headBone, 0, 0, -30.0, 0, 0, 0, true, true, false, true, 0, false)
                else
                    AttachEntityToEntity(GetPlayerPed(-1), targetPed, headBone, 0, 0, balaBala and 100.0 or -3.0, 0, 0, 0, true, true, false, true, 0, false)
                end
                SetEntityCompletelyDisableCollision(GetPlayerPed(-1), false, true)
            else
                resetNormalCamera()
            end

            local text = {}


            if TargetSpectate then
                table.insert(text,"ID: "..TargetSpectate)
                table.insert(text,"IC Name: "..GetPlayerName(targetPlayerId, true))
                table.insert(text,"Health: ".. (GetEntityHealth(targetPed) - 100).."/".. (GetEntityMaxHealth(targetPed) - 100))
                table.insert(text,"Armor: "..GetPedArmour(targetPed))
                if IsPedInAnyVehicle(targetPed, false) then
                    local speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(targetPed, false))*3.6)
                    table.insert(text,"Vehicle Speed: ".. speed)
                    table.insert(text,"Vehicle Health: "..GetEntityHealth(GetVehiclePedIsIn(targetPed)))
                    table.insert(text,"Vehicle Engine Health: "..GetVehicleEngineHealth(GetVehiclePedIsIn(targetPed)))
                    table.insert(text,"Vehicle Acceleration: ".. acceleration2)
                    if not accelerationUpdate then
                        accelerationUpdate = true
                        SetTimeout(1000, function()
                            accelerationUpdate = nil
                        end)
                        acceleration2 = speed - acceleration
                        acceleration = speed
                    end
                end
                if NetworkIsPlayerTalking(targetPlayerId) then
                    table.insert(text,"Talking: ~g~True")
                else
                    table.insert(text,"Talking: ~r~False")
                end

                for i, theText in pairs(text) do
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.0, 0.30)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString(theText)
                    EndTextCommandDisplayText(0.03, 0.4+(i/30))
                end
                if not NetworkIsPlayerActive(targetPlayerId) then
                    spec[TargetSpectate] = false
                    InSpectatorMode = false
                    lastspec = 0
                    TargetSpectate = nil
                end

                if IsControlJustPressed(2, 73) then
                    OpenAdminActionMenu(targetPlayerId)
                elseif IsControlJustReleased(2, 243) then
                    resetNormalCamera()
                    SetPlayerInvincible(PlayerId(), false)
                end
            end
        end
    end
end)

RegisterNetEvent('leavespect')
AddEventHandler('leavespect',function()
    resetNormalCamera()
end)

IsNoclipActive = false;
local MovingSpeed = 0;
local Scale = -1;
local FollowCamMode = false;
local speeds = {
    [0] = "Very Slow",
    [1] = "Slow",
    [2] = "Normal",
    [3] = "Fast",
    [4] = "Very Fast",
    [5] = "Extremely Fast",
    [6] = "Extremely Fast v2.0",
    [7] = "Max Speed"
}

function NoClipThread()
    local function NoClipFunc()
        if (IsNoclipActive) then
            Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
            while (not HasScaleformMovieLoaded(Scale)) do
                Wait(0)
            end
        end

        while IsNoclipActive do
            local playerPed = GetPlayerPed(-1)
            if (not IsHudHidden()) then
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(0)
                PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
                PushScaleformMovieMethodParameterString("Change Speed ("..speeds[MovingSpeed]..")")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
                PushScaleformMovieMethodParameterString("Turn Left/Right")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(2)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
                PushScaleformMovieMethodParameterString("Move")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(3)
                PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
                PushScaleformMovieMethodParameterString("Down")
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(4)
                PushScaleformMovieMethodParameterString("~INPUT_COVER~")
                PushScaleformMovieMethodParameterString("Up")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(5)
                PushScaleformMovieMethodParameterString("~INPUT_VEH_HEADLIGHT~")
                local CamModeText
                if FollowCamMode then
                    CamModeText = 'Active'
                else
                    CamModeText = 'Deactive'
                end
                PushScaleformMovieMethodParameterString("Cam Mode: "..CamModeText)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS")
                ScaleformMovieMethodAddParamInt(0)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)
            end

            local noclipEntity
            if IsPedInAnyVehicle(playerPed, true) then
                noclipEntity = GetVehiclePedIsIn(playerPed, false)
            else
                noclipEntity = playerPed
            end

            FreezeEntityPosition(noclipEntity, true);
            SetEntityInvincible(noclipEntity, true);

            DisableControlAction(0, 32)
            DisableControlAction(0, 268)
            DisableControlAction(0, 31)
            DisableControlAction(0, 269)
            DisableControlAction(0, 33)
            DisableControlAction(0, 266)
            DisableControlAction(0, 34)
            DisableControlAction(0, 30)
            DisableControlAction(0, 267)
            DisableControlAction(0, 35)
            DisableControlAction(0, 44)
            DisableControlAction(0, 20)
            DisableControlAction(0, 74)
            if (IsPedInAnyVehicle(playerPed, true)) then
                DisableControlAction(0, 85)
            end

            local yoff = 0.0;
            local zoff = 0.0;

            if (UpdateOnscreenKeyboard() ~= 0 and not IsPauseMenuActive()) then
                if (IsControlJustPressed(0, 21)) then
                    MovingSpeed = MovingSpeed+1
                    if (MovingSpeed > #speeds) then
                        MovingSpeed = 0;
                    end
                end

                if (IsDisabledControlPressed(0, 32)) then
                    yoff = 0.5
                end
                if (IsDisabledControlPressed(0, 33)) then
                    yoff = -0.5
                end
                if (IsDisabledControlPressed(0, 34)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)+3)
                end
                if (IsDisabledControlPressed(0, 35)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)-3)
                end
                if (IsDisabledControlPressed(0, 44)) then
                    zoff = 0.21
                end
                if (IsDisabledControlPressed(0, 20)) then
                    zoff = -0.21
                end
                if (IsDisabledControlJustPressed(0, 74)) then
                    FollowCamMode = not FollowCamMode
                end
                moveSpeed = MovingSpeed
                if (MovingSpeed > #speeds/2) then
                    moveSpeed = moveSpeed*1.8;
                end

                newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0, yoff*(moveSpeed + 0.3), zoff*(moveSpeed + 0.3))

                local heading = GetEntityHeading(noclipEntity)
                SetEntityVelocity(noclipEntity, 0, 0, 0)
                SetEntityRotation(noclipEntity, 0, 0, 0, 0, false)
                if FollowCamMode then
                    SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading())
                else
                    SetEntityHeading(noclipEntity, heading)
                end

                SetEntityCollision(noclipEntity, false, false)
                ESX.SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(noclipEntity, 255*0.2, 0)

                SetEveryoneIgnorePlayer(PlayerId(), true)
                SetPoliceIgnorePlayer(PlayerId(), true)

                FreezeEntityPosition(noclipEntity, false)
                SetEntityInvincible(noclipEntity, false)
                SetEntityCollision(noclipEntity, true, true)

                SetLocalPlayerVisibleLocally(true)
                ResetEntityAlpha(noclipEntity)

                SetEveryoneIgnorePlayer(PlayerId(), false)
                SetPoliceIgnorePlayer(PlayerId(), false)
            end
            Wait(0)
        end
    end
    CreateThread(NoClipFunc)
end

function noclipt()
    IsNoclipActive = not IsNoclipActive
    if IsNoclipActive then
        NoClipThread()
    end
end

function teleportToPlayer(serverId)
    local targetId = GetPlayerFromServerId(serverId)
    local playerPed = GetPlayerPed(-1)
    local targetPed = GetPlayerPed(targetId)

    NetworkSetInSpectatorMode(false, playerPed) -- turn off spectator mode just in case
    DetachEntity(playerPed, true, true)
    SetEntityCompletelyDisableCollision(playerPed, true, true)
    if not invisibility and not invisibility2 then
        SetEntityVisible(playerPed, true)
    end
    if PlayerId() == targetId then
        drawNotification("~r~This player is you!")
    elseif not NetworkIsPlayerActive(targetId) then
        drawNotification("~r~This player is not in game.")
    else
        local targetCoords = GetEntityCoords(targetPed)
        local targetVeh = GetVehiclePedIsIn(targetPed, False)
        local seat = -1

        drawNotification("~g~Teleporting to " .. GetPlayerName(targetId) .. " (Player " .. serverId .. ").")
        local freeSeat = nil
        if targetVeh then
            local maxSeats = GetVehicleMaxNumberOfPassengers(targetVeh)
            for i=maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(targetVeh, i) then
                    freeSeat = i
                    break
                end
            end
        end
        if freeSeat == nil then
            ESX.SetEntityCoords(playerPed, targetCoords, 1, 0, 0, 1)
        else
            TaskWarpPedIntoVehicle(playerPed, targetVeh, freeSeat)
        end
    end
end


function drawNotification(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

