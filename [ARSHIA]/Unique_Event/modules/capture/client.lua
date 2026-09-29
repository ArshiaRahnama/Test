

ESX = nil
PlayerData = nil
Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent(CapConfig.getSharedObjectTrigger, function(obj) ESX = obj end)
        Citizen.Wait(5)
    end
    while not PlayerData do
        Citizen.Wait(5)
        PlayerData = ESX.GetPlayerData()
    end
    while not PlayerData.gang do
        Citizen.Wait(5)
        PlayerData = ESX.GetPlayerData()
    end
end)

function Notify(message, notifyType, title)
    local oxType = notifyType
    if oxType == 'error' then oxType = 'error'
    elseif oxType == 'success' then oxType = 'success'
    elseif oxType == 'info' then oxType = 'inform'
    else oxType = 'inform' end

    lib.notify({
        title = title or 'Unique Capture',
        description = message,
        type = oxType,
        position = 'center-right',
    })
end

RegisterNetEvent("arshiahub.ir-Capture:OxNotify")
AddEventHandler("arshiahub.ir-Capture:OxNotify", function(message, notifyType, title)
    Notify(message, notifyType, title)
end)

local ActiveTheme = CapConfig.Themes[CapConfig.ActiveTheme] or CapConfig.Themes.Default
RegisterNetEvent("arshiahub.ir-CaptureSystem:SetTheme")
AddEventHandler("arshiahub.ir-CaptureSystem:SetTheme", function(theme)
    if theme then ActiveTheme = theme end
end)
RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang',function(Gang)
    PlayerData.gang = Gang
end)

CaptureDetails = {
    CaptureHolderGang = {}
}

RegisterNetEvent("arshiahub.ir-CaptureSystem:UpdateHolderGang")
AddEventHandler("arshiahub.ir-CaptureSystem:UpdateHolderGang",function(ZonesHolderGangs)
    CaptureDetails.CaptureHolderGang = ZonesHolderGangs
end)

PlayerCaptureInf = {
    InCapture = false,
    Alive = false,
    InMenu = nil,
    OnGround = false,
    IsOnMarker = false,
    Weapon = nil,
    Armor = 0,
    Group = nil,
    ZoneCoord = nil
}

RegisterCommand(CapConfig.ReSpawnCaptureCommand,function()
    if PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then
        ReSpawn()
    end
end,false)

RegisterCommand(CapConfig.DashboardCommand, function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetDashboard', function(data)
        SetNuiFocus(true, true)
        SendNUIMessage({action = "openDashboard", data = data})
    end)
end, false)

RegisterNUICallback('closeDashboard', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('dashboardAction', function(data, cb)
    local actionMap = {
        join = CapConfig.JoinCaptureCommand,
        leave = CapConfig.LeaveCaptureCommand,
        respawn = CapConfig.ReSpawnCaptureCommand,
        seasons = CapConfig.SeasonHistoryCommand,
        standings = CapConfig.StandingsCommand,
        medals = CapConfig.ScarcityStatusCommand,
        mymedals = CapConfig.MyMedalsCommand,
        halloffame = CapConfig.HallOfFameCommand,
    }
    local commandToRun = data and data.action and actionMap[data.action]
    if commandToRun then
        ExecuteCommand(commandToRun)
    end
    cb('ok')
end)

function HandleMarkers()
    Citizen.CreateThread(function()
        local blip
        local blip2
        blip = AddBlipForRadius(PlayerCaptureInf.ZoneCoord.x,PlayerCaptureInf.ZoneCoord.y,PlayerCaptureInf.ZoneCoord.z,CapConfig.ZoneSize)
        SetBlipAlpha(blip, CapConfig.ZoneBlip.Alpha)
        SetBlipColour(blip, CapConfig.ZoneBlip.Color)

        blip2 = AddBlipForCoord(PlayerCaptureInf.ZoneCoord.x,PlayerCaptureInf.ZoneCoord.y,PlayerCaptureInf.ZoneCoord.z)
        SetBlipSprite(blip2, CapConfig.CapturePointBlip.Model)
        SetBlipScale(blip2, 0.7)
        SetBlipColour(blip2, CapConfig.CapturePointBlip.Color)
        SetBlipAsShortRange(blip2, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(PlayerCaptureInf.InCapture)
        EndTextCommandSetBlipName(blip2)

        while PlayerCaptureInf.InCapture do
            Citizen.Wait(0)
            if PlayerCaptureInf and PlayerCaptureInf.ZoneCoord and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then

                local PointColor = {Point = ActiveTheme.Point.Default, Zone = ActiveTheme.Zone.Default}
                if (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] == PlayerData.gang.name) then
                    PointColor = {Point = ActiveTheme.Point.Owned, Zone = ActiveTheme.Zone.Owned}
                end
                DrawMarker(
                    28,
                    PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    5.0, 5.0, 5.0,
                    PointColor.Point.R, PointColor.Point.G, PointColor.Point.B, PointColor.Point.Alpha,
                    false, true, 2, false, nil, nil, false
                )


                DrawMarker(
                    28,
                    PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z + 250.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    CapConfig.ZoneSize + 3.8, CapConfig.ZoneSize + 3.8, 1200.0,
                    PointColor.Zone.R, PointColor.Zone.G, PointColor.Zone.B, PointColor.Zone.Alpha,
                    false, true, 2, false, nil, nil, false
                )
            else
                RemoveBlip(blip)
                RemoveBlip(blip2)
            end
        end
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:JoinCapture")
AddEventHandler("arshiahub.ir-Capture:JoinCapture", function()
    if not PlayerCaptureInf.InCapture then
        ShowUi(true)
        GotoMenu()
    end
end)

function MenuSaver()
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while PlayerCaptureInf.InMenu and PlayerCaptureInf.InCapture do
            Citizen.Wait(300)
            if not ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), PlayerCaptureInf.InMenu) then
                if PlayerCaptureInf.InMenu == "CaptureMenu" then
                    GotoMenu()
                elseif PlayerCaptureInf.InMenu == "ZoneSelectorCaptureSystem" then
                    ZoneSelectorMenu()
                elseif PlayerCaptureInf.InMenu == "WeaponMenu" then
                    OpenWeaponGroupMenu()
                end
            end
        end
    end)

end

function GotoMenu()
    local PlayerPed = PlayerPedId()
    ESX.UI.Menu.CloseAll()
    TpRandomOutCaptureCoord()
    TriggerEvent('es_admin:freezePlayer', true)
    SetEntityVisible(PlayerPed, false, false)
    SetArmor()
    PlayerCaptureInf.InMenu = "CaptureMenu"
    PlayerCaptureInf.Alive = false
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        local elements = {}

        table.insert(elements, {label = '========== Your Current Data =========', value = nil})



        if not CapConfig.UsePersonalWeapons then
            if not PlayerCaptureInf.Weapon then PlayerCaptureInf.Weapon = {'WEAPON_CARBINERIFLE'} end
            local weaponLabels = {}
            for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
                local label = ESX.GetWeaponLabel(weapon)
                table.insert(weaponLabels, label or weapon)
            end

            local fullLabel = table.concat(weaponLabels, " | ")
            table.insert(elements, {label = '🔫 Weapon : ' .. fullLabel or "None" , value = "changeWeapon"})
        end
        table.insert(elements, {label = '⌛ Remaining Time : ' .. tostring(CaptureInfo.Time), value = nil})
        table.insert(elements, {label = '🛡️ Armor : ' .. tostring(PlayerCaptureInf.Armor), value = nil})
        table.insert(elements, {label = '========== Actions =========', value = nil})
        table.insert(elements, {label = 'Goto Capture 🏳️', value = 'gotoCapture'})
        table.insert(elements, {label = 'Leave Capture 🚪', value = 'leaveCapture'})
        MenuSaver()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureMenu',
            {
                title    = 'Capture Menu',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'gotoCapture' then
                    PlayerCaptureInf.InMenu = nil
                    ZoneSelectorMenu()
                    menu.close()
                elseif data.current.value == 'leaveCapture' then
                    ExecuteCommand(CapConfig.LeaveCaptureCommand)
                    menu.close()
                elseif data.current.value == 'changeWeapon' then
                    PlayerCaptureInf.InMenu = nil
                    OpenWeaponGroupMenu()
                    menu.close()
                end
            end,
            function(data, menu)
            end
        )
    end)
end
RegisterNetEvent("arshiahub.ir-CaptureSystem:SendAllTimeTop")
AddEventHandler("arshiahub.ir-CaptureSystem:SendAllTimeTop", function(TopAllTime)
    if not PlayerCaptureInf.InCapture then return end
    local msg = { action = "updateAllTime" }
    for i = 1, 5 do
        if TopAllTime[i] then
            msg["alltimeplayer" .. i] = TopAllTime[i].name
            msg["alltimescore" .. i] = TopAllTime[i].score
            local photo = TopAllTime[i].Photo
            if photo and string.sub(photo, 1, 4) == "http" then
                msg["alltimephoto" .. i] = photo
            elseif photo then
                msg["alltimephoto" .. i] = string.format(CapConfig.PlayerPhotoUrlTemplate, photo)
            else
                msg["alltimephoto" .. i] = CapConfig.DefaultPlayerPhoto
            end
        end
    end
    SendNUIMessage(msg)
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:SendDataToUi")
AddEventHandler("arshiahub.ir-CaptureSystem:SendDataToUi", function(KillData, GangsData, Time, Percent)
    if not PlayerCaptureInf.InCapture then return end
    local msg = {
        action = "updateData",
        time = Time or "00:00",
        percent = Percent or 0
    }
    for i = 1, 5 do
        if KillData[i] then
            msg["playercallback" .. i] = KillData[i].Name
            msg["pointcallback" .. i] = KillData[i].Point
            local photo = KillData[i].Photo
            if photo and string.sub(photo, 1, 4) == "http" then
                msg["playerphotocallback" .. i] = photo
            elseif photo then
                msg["playerphotocallback" .. i] = string.format(CapConfig.PlayerPhotoUrlTemplate, photo)
            else
                msg["playerphotocallback" .. i] = CapConfig.DefaultPlayerPhoto
            end
        end
    end
    for i = 1, 5 do
        if GangsData[i] then
            msg["gangcallback" .. i] = GangsData[i].Name
            msg["gangpointcallback" .. i] = GangsData[i].Points
            local logo = GangsData[i].Logo or CapConfig.DefaultGangLogo
            if string.sub(logo, 1, 4) == "http" then
                msg["ganglogocallback" .. i] = logo
            else
                msg["ganglogocallback" .. i] = string.format(CapConfig.GangLogoUrlTemplate, logo)
            end
        end
    end
    SendNUIMessage(msg)
end)
local isVisible = false
AddEventHandler("onKeyDown", function(key)
    if not PlayerCaptureInf.InCapture then return end
    if key == "g" then
        isVisible = not isVisible
        SendNUIMessage({
            action = "toggleTips",
            hide = not isVisible
        })
    end
end)

function ShowUi(show)
    SendNUIMessage({action = "changeShow", hide = not show})
end

function ZoneSelectorMenu()
    local PlayerPed = PlayerPedId()
    ESX.UI.Menu.CloseAll()
    TpRandomOutCaptureCoord()
    TriggerEvent('es_admin:freezePlayer', true)
    SetEntityVisible(PlayerPed, false, false)
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        if CaptureInfo.Zones and next(CaptureInfo.Zones) ~= nil then
            local elements = {}

            table.insert(elements, {label = '========== Zones =========', value = nil})

            for zoneName, coords in pairs(CaptureInfo.Zones) do
                table.insert(elements, {label = '📍 Zone Name : ' .. zoneName, value = zoneName})
            end

            if #elements > 2 then
                PlayerCaptureInf.InMenu = "ZoneSelectorCaptureSystem"
                MenuSaver()
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'ZoneSelectorCaptureSystem',
                    {
                        title    = 'Capture Menu',
                        align    = "top-right",
                        elements = elements
                    },
                    function(data, menu)
                        if data.current.value then
                            PlayerCaptureInf.ZoneCoord = CaptureInfo.Zones[data.current.value]
                            PlayerCaptureInf.InCapture = data.current.value
                            menu.close()
                            PlayerCaptureInf.InMenu = nil
                            SpawnInCapture()
                        end
                    end,
                    function(data, menu)
                    end
                )
            else
                PlayerCaptureInf.InMenu = nil
                for k, v in pairs(CaptureInfo.Zones) do
                    PlayerCaptureInf.ZoneCoord = v
                    PlayerCaptureInf.InCapture = k
                    SpawnInCapture()
                end
            end
        end
    end)
end

function SpawnInCapture()
    ShowUi(true)
    ESX.UI.Menu.CloseAll()
    local PlayerPed = PlayerPedId()
    TriggerServerEvent("arshiahub.ir-CaptureSystem:PlayerEnterZone",PlayerCaptureInf.InCapture)

    PlayerCaptureInf.OnGround = false
    PlayerCaptureInf.InMenu = false
    PlayerCaptureInf.Alive = true

    HandleMarkers()

    if not CapConfig.UsePersonalWeapons then
        if not PlayerCaptureInf.Weapon then PlayerCaptureInf.Weapon = {'WEAPON_CARBINERIFLE'} end
        SetCanPedEquipAllWeapons(PlayerPed, false)

        for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
            GiveWeaponToPed(PlayerPed, GetHashKey(weapon), 250, false, true)
            SetCanPedSelectWeapon(PlayerPed, GetHashKey(weapon), true)
        end
    end
    GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 1, false, true)


    TriggerEvent('es_admin:freezePlayer', false)
    SetEntityVisible(PlayerPed, true, false)
    TpRandomOutCaptureCoord()


    TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	SetEntityHealth(PlayerPed, GetEntityMaxHealth(PlayerPed))
    SetPedArmour(PlayerPed, PlayerCaptureInf.Armor)



    DeathLoop()
    LandingHandel()
end

function LeaveCapture(Voluntary)
    SendNUIMessage({action = "resetUi"})
    if PlayerCaptureInf.InCapture or PlayerCaptureInf.InMenu then
        local PlayerPed = PlayerPedId()
        if Voluntary and PlayerCaptureInf.IsOnMarker and PlayerCaptureInf.InCapture then
            TriggerServerEvent("arshiahub.ir-Capture:PenalizeZoneLeave", PlayerCaptureInf.InCapture)
        end
        ESX.UI.Menu.CloseAll()
        PlayerCaptureInf.InMenu = nil
        SetEntityVisible(PlayerPed, true, false)
        Citizen.Wait(2400)
        TriggerEvent(CapConfig.ReviveTrigger)
        Citizen.Wait(2000)
        TriggerServerEvent("arshiahub.ir-Capture:LeaveCapture")
        SetCanPedEquipAllWeapons(PlayerPed, true)
        if PlayerCaptureInf.Weapon then
            for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
                RemoveWeaponFromPed(PlayerPed, weapon)
            end
        end
        PlayerCaptureInf = {
            InCapture = false,
            Alive = false,
            InMenu = nil,
            OnGround = false,
            IsOnMarker = false,
            Weapon = nil,
            Armor = 100,
            Group = nil,
            ZoneCoord = nil
        }
    end

end

function LandingHandel()
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        local ZoneX, ZoneY, ZoneZ = PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z
        while true do
            Citizen.Wait(100)
            if not PlayerCaptureInf.InCapture then break end
            local PlayerX, PlayerY, PlayerZ = table.unpack(GetEntityCoords(PlayerPed))
            if #(vector2(PlayerX, PlayerY) - vector2(ZoneX, ZoneY)) <= CapConfig.ZoneSize or PlayerZ <= CapConfig.zToAutoTeleport and not PlayerCaptureInf.OnGround then
                local newX, newY = GetRandomInCaptureCoord(ZoneX, ZoneY)
                local zCoord = GetGroundZ(newX, newY)
                if zCoord == nil then
                    Wait(150)
                    newX, newY = GetRandomInCaptureCoord(ZoneX, ZoneY)
                    zCoord = GetGroundZ(newX, newY)
                end
                if zCoord == nil then zCoord = 30.0 end
                SetEntityCoords(PlayerPed, newX, newY, zCoord, false, false, false, false)
                PlayerCaptureInf.OnGround = true
                if HasPedGotWeapon(PlayerPed, GetHashKey("GADGET_PARACHUTE"), false) then
                    RemoveWeaponFromPed(PlayerPed, GetHashKey("GADGET_PARACHUTE"))
                end
                ZoneController()
                break
            end
        end
    end)
end

function GetGroundZ(x, y)
    local zCoord = 0.0
    local found = false

    for i = 1, 100 do
        Citizen.Wait(2)
        found, zCoord = GetGroundZFor_3dCoord(x, y, 300.0, 0)
        if found and zCoord ~= 0.0 then
            return zCoord + 1.0
        end
    end

    return nil
end

function GetRandomInCaptureCoord(baseX, baseY)
    local angle = math.random() * 2 * math.pi
    local distance = math.random(CapConfig.ZoneSize - 30, CapConfig.ZoneSize - 10)
    local offsetX = math.cos(angle) * distance
    local offsetY = math.sin(angle) * distance
    return baseX + offsetX, baseY + offsetY
end

function TpRandomOutCaptureCoord()
    local PlayerPed = PlayerPedId()
    if not PlayerCaptureInf.ZoneCoord or not PlayerCaptureInf.InCapture then
        SetEntityCoords(PlayerPed, 670.52, 844.99, 371.47)
        SetEntityHeading(PlayerPed, 351.5)
        SetGameplayCamRelativeHeading(0.0)
        return
    end
    local angle = math.random() * 2 * math.pi
    local radius = math.random(CapConfig.ParchuteSpawnDistance.min + CapConfig.ZoneSize, CapConfig.ParchuteSpawnDistance.max + CapConfig.ZoneSize)
    local X = PlayerCaptureInf.ZoneCoord.x + math.cos(angle) * radius
    local Y = PlayerCaptureInf.ZoneCoord.y + math.sin(angle) * radius
    local heading = math.deg(math.atan2(PlayerCaptureInf.ZoneCoord.y - Y, PlayerCaptureInf.ZoneCoord.x - X))
    SetEntityCoords(PlayerPed, X, Y, CapConfig.ParchuteSpawnHeight, false, false, false, false)
    SetEntityHeading(PlayerPed, heading - 90.0)
    SetGameplayCamRelativeHeading(0.0)
end

function ReSpawn()
    if PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then

        TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", nil, false)


        PlayerCaptureInf.Capture = nil

        PlayerCaptureInf.Alive = false
        PlayerCaptureInf.OnGround = false
        SetEntityVisible(PlayerPedId(), false, false)
        Citizen.Wait(2400)
        TriggerEvent(CapConfig.ReviveTrigger)
        Citizen.Wait(2000)
        ZoneSelectorMenu()
    end
end
function DeathLoop()
    Citizen.CreateThread(function()
        while PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive do
            Citizen.Wait(0)
            if IsEntityDead(PlayerPedId()) then
                Citizen.Wait(500)
                local PedKiller = GetPedSourceOfDeath(PlayerPedId())
                local Killer
                if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                    Killer = NetworkGetPlayerIndexFromPed(PedKiller)
                end

                if Killer ~= nil then
                    if Killer ~= PlayerId() then
                        TriggerServerEvent('arshiahub.ir-Capture:KillerPoint',GetPlayerServerId(Killer))
                    end
                    TriggerServerEvent("arshiahub.ir-CaptureSystem:SendKillLog", GetPlayerServerId(Killer), PlayerCaptureInf.InCapture)
                end
                ReSpawn()
            end
        end
    end)
end

RegisterNetEvent("arshiahub.ir-CaptureSystem:ShowKillLog")
AddEventHandler("arshiahub.ir-CaptureSystem:ShowKillLog", function(DamagedID, KillerID, DamagedGang, KillerGang, DamagedName, KillerName, ZoneName, KillTime, KillerRank, DamagedRank)
    if not PlayerCaptureInf.InCapture then return end
    if CapConfig.SplitZonesKillLog and ZoneName ~= PlayerCaptureInf.InCapture then return end

    local SelfID = GetPlayerServerId(PlayerId())
    local DamagedTag,KillerTag

    if DamagedGang == PlayerData.gang.name then
        DamagedTag = "team"
    else
        DamagedTag = "enemy"
    end
    if KillerGang == PlayerData.gang.name then
        KillerTag = "team"
    else
        KillerTag = "enemy"
    end
    SendNUIMessage({
        action = "newKill",
        killer = KillerName,
        damaged = DamagedName,
        team1 = KillerTag,
        team2 = DamagedTag,
        killerRank = KillerRank,
        damagedRank = DamagedRank,
    })

    TriggerEvent('chat:addMessage', {
        args = {
            "^1[Capture Kill]",
            "^3" .. KillTime .. " ^7| ^2" .. KillerName .. " ^6[" .. tostring(KillerRank) .. "]^7 (^5" .. KillerGang .. "^7) ^0killed ^1" .. DamagedName .. " ^6[" .. tostring(DamagedRank) .. "]^7 (^5" .. DamagedGang .. "^7) ^0in zone ^6" .. tostring(ZoneName)
        }
    })
end)

local CapturingThreadActive = false
local CancelLocalTimer = false

RegisterNetEvent("arshiahub.ir-Capture:CancelLocalZoneTimer")
AddEventHandler("arshiahub.ir-Capture:CancelLocalZoneTimer", function()
    CancelLocalTimer = true
end)

function StartCaptureZoneTimer()
    if CapturingThreadActive then return end
    CapturingThreadActive = true
    CancelLocalTimer = false
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        local TimeInZone = 0
        local HalfwayWarningSent = false
        if CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] == PlayerData.gang.name then
            CapturingThreadActive = false
            return
        end
        TriggerServerEvent("arshiahub.ir-CaptureSystem:ShowMessageToAll","Gang ~r~[~w~"..PlayerData.gang.name.."~r~]~w~ Dar Hale Capture Kardan Ast | Zone : ~g~[~r~"..PlayerCaptureInf.InCapture.."~g~]",5)
        Citizen.CreateThread(function()
            local Off = false
            SetTimeout((CapConfig.TimeToCaptureZone + 2) * 1000 , function()
                Off = true
            end)
            while not Off and not CancelLocalTimer and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.IsOnMarker and (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] ~= PlayerData.gang.name) do
                Citizen.Wait(0)
                Draw3DText(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z + 1.0, "⏱️ " .. TimeInZone .. " / " .. CapConfig.TimeToCaptureZone)
            end
        end)
        while not CancelLocalTimer and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.IsOnMarker and (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] ~= PlayerData.gang.name) do
            Citizen.Wait(1000)
            local Distance = #(GetEntityCoords(PlayerPed) - vector3(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z))
            if Distance <= 5.0 then
                if PlayerCaptureInf.IsOnMarker then
                    TimeInZone = TimeInZone + 1

                    if not HalfwayWarningSent and TimeInZone >= math.floor(CapConfig.TimeToCaptureZone / 2) then
                        HalfwayWarningSent = true
                        TriggerServerEvent("arshiahub.ir-Capture:ZoneUnderAttack", PlayerCaptureInf.InCapture, PlayerData.gang.name)
                    end

                    if TimeInZone >= CapConfig.TimeToCaptureZone then
                        TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerWaitPassed")
                        CapturingThreadActive = false
                        return
                    end
                end
            end
        end
        CapturingThreadActive = false
    end)
end

function ZoneController()
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        Citizen.Wait(1000)
        while PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.ZoneCoord do
            local Distance = #(GetEntityCoords(PlayerPed) - vector3(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z))

            if Distance >= CapConfig.ZoneSize and PlayerCaptureInf.OnGround then
                local Hp = GetEntityHealth(PlayerPed)
                SetEntityHealth(PlayerPed, Hp - CapConfig.OutOfZoneDamage)
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.1)
            end

            if Distance <= 5 then

                if not PlayerCaptureInf.IsOnMarker then
                    PlayerCaptureInf.IsOnMarker = true
                    TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", PlayerCaptureInf.InCapture, true)
                    StartCaptureZoneTimer()
                end
            else
                if PlayerCaptureInf.IsOnMarker then
                    PlayerCaptureInf.IsOnMarker = false
                    TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", nil, false)
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:LeaveCapture")
AddEventHandler("arshiahub.ir-Capture:LeaveCapture", function(Voluntary)
    LeaveCapture(Voluntary)
end)

RegisterNetEvent("arshiahub.ir-Capture:OpenAdminMenu")
AddEventHandler("arshiahub.ir-Capture:OpenAdminMenu", function()
    GotoAdminMenu()
end)

function GotoAdminMenu()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        ESX.UI.Menu.CloseAll()

        local elements = {
            {label = '========== Your Current Time =========', value = nil},
            {label = '🕒 Capture Time : ' .. tostring(CaptureInfo.Time), value = "changeTime"},
            {label = '========== Your Current Zones =========', value = nil},
        }

        if CaptureInfo.Zones and next(CaptureInfo.Zones) ~= nil then
            for zoneName, _ in pairs(CaptureInfo.Zones) do
                table.insert(elements, {label = '📍 Zone Name : ' .. zoneName, value = zoneName})
            end
        else
            table.insert(elements, {label = '📍 No Zones', value = nil})
        end

        local actions = {
            {label = '========== Actions =========', value = nil},
            {label = 'Add Zone 📍', value = 'addZone'},
            {label = 'Start Capture 🚪', value = 'startCap'},
            {label = 'Start Announce !', value = 'announce'},
        }

        for _, v in pairs(actions) do
            table.insert(elements, v)
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureAdminMenu',
            {
                title    = 'Capture Admin Menu',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'changeTime' then
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'CaptureTime',
                        { title = 'Change Capture Time' },
                        function(data2, menu2)
                            local time = tonumber(data2.value)
                            if time and time > 0 then
                                CaptureInfo.Time = time
                                TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                                GotoAdminMenu()
                            end
                            menu2.close()
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )

                elseif data.current.value == 'addZone' then
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'CaptureZoneName',
                        { title = 'Zone Name' },
                        function(data2, menu2)
                            if data2.value then
                                local coords = GetEntityCoords(PlayerPedId())
                                if type(CaptureInfo.Zones) ~= "table" then CaptureInfo.Zones = {} end
                                CaptureInfo.Zones[data2.value] = {x = coords.x, y = coords.y, z = coords.z}
                                TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                                GotoAdminMenu()
                            end
                            menu2.close()
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )

                elseif data.current.value == 'startCap' then
                    ExecuteCommand(CapConfig.StartCaptureCommand)
                    menu.close()
                elseif CaptureInfo.Zones[data.current.value] then
                    CaptureInfo.Zones[data.current.value] = nil
                    TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                    GotoAdminMenu()
                elseif data.current.value == 'announce' then
                    ExecuteCommand("announce Capture Start Shod ! /"..CapConfig.JoinCaptureCommand.." Baraye Join Shodan !")
                    menu.close()
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:OpenStatsMenu")
AddEventHandler("arshiahub.ir-Capture:OpenStatsMenu", function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetMyStats', function(Mine, TopAllTime, MyZones)
        ESX.UI.Menu.CloseAll()
        local elements = {}

        local kills = Mine and Mine.kills or 0
        local deaths = Mine and Mine.deaths or 0
        local top5 = Mine and Mine.top5_count or 0
        local kd = deaths > 0 and string.format("%.2f", kills / deaths) or tostring(kills)

        table.insert(elements, {label = '========== 📊 My Stats ==========', value = nil})
        table.insert(elements, {label = 'Kills: '..kills, value = nil})
        table.insert(elements, {label = 'Deaths: '..deaths, value = nil})
        table.insert(elements, {label = 'K/D Ratio: '..kd, value = nil})
        table.insert(elements, {label = 'Times In Top 5: '..top5, value = nil})

        table.insert(elements, {label = '========== 📍 My Best Zones ==========', value = nil})
        if MyZones and #MyZones > 0 then
            for i, row in ipairs(MyZones) do
                table.insert(elements, {label = '#'..i..' '..tostring(row.zone_name)..' - '..tostring(row.points)..' pts', value = nil})
            end
        else
            table.insert(elements, {label = 'No Data Yet', value = nil})
        end

        table.insert(elements, {label = '========== 🏆 All-Time Top Killers ==========', value = nil})

        if TopAllTime and #TopAllTime > 0 then
            for i, row in ipairs(TopAllTime) do
                table.insert(elements, {label = '#'..i..' '..tostring(row.name)..' - '..tostring(row.kills)..' kills', value = nil})
            end
        else
            table.insert(elements, {label = 'No Data Yet', value = nil})
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureStatsMenu',
            {
                title    = 'Capture Stats',
                align    = "top-right",
                elements = elements
            },
            function(data, menu) end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

RegisterNetEvent("arshiahub.ir-Capture:OpenHistoryMenu")
AddEventHandler("arshiahub.ir-Capture:OpenHistoryMenu", function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetHistory', function(History)
        ESX.UI.Menu.CloseAll()
        local elements = {}

        if not History or #History == 0 then
            table.insert(elements, {label = 'No Rounds Recorded Yet', value = nil})
        else
            for _, round in ipairs(History) do
                local label = string.format('📅 %s | 🏆 %s (%d pts) | 🔫 %s (%d kills)',
                    tostring(round.round_date),
                    tostring(round.winner_gang or 'N/A'),
                    round.winner_points or 0,
                    tostring(round.top_killer_name or 'N/A'),
                    round.top_killer_kills or 0
                )
                table.insert(elements, {label = label, value = round})
            end
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureHistoryMenu',
            {
                title    = 'Capture History',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value then
                    OpenHistoryRoundDetail(data.current.value)
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

function OpenHistoryRoundDetail(round)
    local elements = {}
    table.insert(elements, {label = '========== 🥇 Top Gangs ==========', value = nil})

    local ok, gangs = pcall(json.decode, round.top_gangs_json or '[]')
    if ok and gangs then
        for i, gang in ipairs(gangs) do
            table.insert(elements, {label = '#'..i..' '..tostring(gang.Name)..' - '..tostring(gang.Points)..' pts', value = nil})
        end
    end

    table.insert(elements, {label = '========== 🏆 Top Killers ==========', value = nil})
    local ok2, killers = pcall(json.decode, round.top_killers_json or '[]')
    if ok2 and killers then
        for i, killer in ipairs(killers) do
            table.insert(elements, {label = '#'..i..' '..tostring(killer.Name)..' - '..tostring(killer.Point)..' kills', value = nil})
        end
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'CaptureHistoryDetail',
        {
            title    = tostring(round.round_date),
            align    = "top-right",
            elements = elements
        },
        function(data, menu) end,
        function(data, menu)
            menu.close()
        end
    )
end

function SetArmor()
    if CapConfig.UseGroupForArmor then
        if CapConfig.Armor[PlayerData.group] then
            PlayerCaptureInf.Armor = CapConfig.Armor[PlayerData.group]
        else
            PlayerCaptureInf.Armor = CapConfig.DefaultArmor
        end
    else
        PlayerCaptureInf.Armor = CapConfig.DefaultArmor
    end

end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.7, 0.7)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("arshiahub.ir-CaptureSystem:TpPlayer")
AddEventHandler("arshiahub.ir-CaptureSystem:TpPlayer",function(x,y,z)
    local player = GetPlayerPed(-1)
    SetEntityCoords(player, x, y, z, false, false, false, true)
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:ShowMessage")
AddEventHandler("arshiahub.ir-CaptureSystem:ShowMessage",function(text,time)
    if PlayerCaptureInf.InCapture then
        Citizen.CreateThread(function()
            local TimeOut = true
            AddEventHandler("arshiahub.ir-CaptureSystem:ShowMessage",function(text,time)
                TimeOut = false
            end)
            SetTimeout((time) * 1000 , function()
                TimeOut = false
            end)
            while TimeOut do
                Citizen.Wait(0)
                DrawTextBottom(text)
            end
        end)
    end
end)
function DrawTextBottom(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.7, 0.7)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.35, 0.93)
end

function OpenWeaponGroupMenu()
    local elements = {}
    ESX.UI.Menu.CloseAll()
    local playerGroup = PlayerData.group
    for i, weaponGroup in ipairs(CapConfig.Weapons) do
        local hasAccess = false

        if not weaponGroup.access then
            hasAccess = true
        elseif weaponGroup.access == playerGroup or (weaponGroup.access == "vip+" and (playerGroup == "vip+" or playerGroup == "admin")) then
            hasAccess = true
        end

        local weaponLabels = {}
        for _, weapon in ipairs(weaponGroup.Names) do
            local label = ESX.GetWeaponLabel(weapon)
            table.insert(weaponLabels, label or weapon)
        end

        local fullLabel = table.concat(weaponLabels, " | ")
        if not hasAccess then
            fullLabel = "[LOCKED("..weaponGroup.access..")] " .. fullLabel
        end

        table.insert(elements, {
            label = fullLabel,
            groupIndex = i,
            access = hasAccess,
            group = weaponGroup.access,
        })
    end
    PlayerCaptureInf.InMenu = "WeaponMenu"
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'WeaponMenu', {
        title    = "Weapon Menu",
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.access then
            PlayerCaptureInf.Weapon = CapConfig.Weapons[data.current.groupIndex].Names
            PlayerCaptureInf.InMenu = nil
            GotoMenu()
        else
            Notify("You Dont Have Access To "..data.current.group.." Group Weapons", 'error')
        end
    end, function(data, menu)
        PlayerCaptureInf.InMenu = nil
        GotoMenu()
    end)
end

RegisterNetEvent('arshiahub.ir-CaptureSystem:ReceiveGroup')
AddEventHandler('arshiahub.ir-CaptureSystem:ReceiveGroup',function(group)
    PlayerCaptureInf.Group = group
end)

