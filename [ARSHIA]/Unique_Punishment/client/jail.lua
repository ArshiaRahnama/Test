local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = nil
local sentence = {active = false, time = 0, distance = 100, type = 0, unjail = 0}
local stopThread = false
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function (gang)
	PlayerData.gang = gang
end)

AddEventHandler('playerSpawned', function(xPlayer)
    Citizen.Wait(3000)
	ESX.TriggerServerCallback("arshia_jail:retriveJail", function(psentence)
        if psentence then
            if psentence.time > 0 then
                Sentence(psentence.type, psentence.time,psentence.unjail, true)
            end
        end
    end)
end)

local function IsJobAllowed(jobname, jobgrade)
	for _, job in pairs(Config.AllowedJobs) do
		if jobname == job.name then
            if jobgrade then
                if jobgrade < job.unjailPerm then
                    return false
                end
            end
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if sentence.active then
            DrawGenericText("~r~Zamane Jail : ~w~" .. sentence.time .. " ~r~Daghighe")
            DisableControlAction(0, Keys['F3'],true)
            DisableControlAction(0, Keys[','], true)

            DisableControlAction(0, Keys['F1'], true)
            DisableControlAction(0, Keys['M'], true)
            DisableControlAction(0, Keys['R'], true)
            DisableControlAction(0, Keys['F2'], true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 27, true)

        else
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()

        while true do
            Wait(500)

            if sentence.active and not stopThread then

                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(coords, 1688.0815, 2513.3103, 45.5649, false)






                jailExemptRefresh = (jailExemptRefresh or 0)
                if GetGameTimer() - jailExemptRefresh > 3000 then
                    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 4000, { teleport = true, speed = true })
                    jailExemptRefresh = GetGameTimer()
                end

                if distance > sentence.distance then
                    DetachEntity(ped, true, true)
                    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
                    ESX.Game.Teleport(ped, vector3(1691.65,2564.72,45.56))
                    ESX.ShowNotification("Nemitoni Az Zendan Farar Koni!")
                end

            else
                Wait(2000)
            end

        end

end)

function trigtimer()
    Citizen.CreateThread(function()
        while sentence.active do
            Wait(60000)
            sentence.time = sentence.time - 1
            if sentence.time >= 0 then
                TriggerServerEvent('arshia_jail:UpdateTime',sentence.time)
                if sentence.time == 0 then
                    sentence.active = false
                    UnJail()
                end
            end
        end
    end)
end


RegisterNetEvent("arshia_jail:UnjailPlayer")
AddEventHandler("arshia_jail:UnjailPlayer", function()
    TriggerServerEvent('arshia_jail:UpdateTime',0)
    UnJail()
end)

function UnJail()
    sentence.time = 0
    sentence.distance = 0
    sentence.type = 0
    sentence.active = false
    local ped = GetPlayerPed(-1)
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    local releaseCoords = (type(sentence.unjail) == "table" or type(sentence.unjail) == "vector3") and sentence.unjail or Config.AdminJail.unjail
    ESX.Game.Teleport(ped, releaseCoords)



    TriggerEvent("resetpedHandler", "s_m_m_chemsec_01")
    ESX.ShowNotification("Shoma Azad Shodid!",'success')
end

RegisterNetEvent("arshia_jail:factionjail")
AddEventHandler("arshia_jail:factionjail", function(target)

	if not PlayerData or not PlayerData.job then
		TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Etelaate Player Hanooz Load Nashode, Chand Sanie Sabr Konid")
		return
	end
	if IsJobAllowed(PlayerData.job.name) then
        local canopen = false
        local unjail = 0
        local coords = GetEntityCoords(PlayerPedId())
        for _ , v in pairs(Config.CanJail) do
            local distance = GetDistanceBetweenCoords(coords,v.coords)
            if distance <= v.radius then
                canopen = true
                unjail = v.unjail
            end
        end
        if canopen then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_jail_reason', {
                title = 'Dalile Jail'
            }, function(data, menu)
                local reason = tostring(data.value)
                if reason == nil or reason == '' or reason == ' ' then
                    TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Lotfan Dalile Jail Ra Vared Konid")
                else
                    menu.close()
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_jail_time', {
                        title = 'Modate Jail'
                    }, function(data2, menu2)
                        local time = tonumber(data2.value)
                        if time == nil or time == 0 then
                            TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Lotfan Time Jail Ra Vared Konid")
                        else
                            menu2.close()
                            if GetPlayerName(GetPlayerFromServerId(target)) then
                                if GetPlayerName(GetPlayerFromServerId(target)) ~= "**Invalid**" then
                                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))), true) < 10.000 then
                                        TriggerServerEvent("arshia_jail:sendto", target, 'faction', time, reason, unjail)


                                    end
                                else
                                    TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Nist !")
                                end
                            else
                                TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Nist !")
                            end
                        end
                    end, function(data2,menu2)
                        menu2.close()
                    end)
                end
            end, function(data,menu)
                menu.close()
            end)

        else
            TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Shoma Dar Station Nistid")
        end
	else
		TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Shoma Shoghle Jail Kardan Ra Nadarid (police/sheriff)")
	end
end)

TriggerEvent('chat:addSuggestion', '/unjail', 'Unjail Kardane Player',{{name = "ID", help = "Player Id"}})

TriggerEvent('chat:addSuggestion', '/jail', 'Baz Kardane Menu Jail', {{name = "ID", help = "Player Id"}})
RegisterCommand('jail', function(source, args)
    local target = tonumber(args[1])
    if not target then
        ESX.ShowNotification('~r~/jail [id]')
        return
    end
    TriggerEvent('arshia_jail:factionjail', target)
end, false)

RegisterCommand('unjail', function(source, args)
	local target = tonumber(args[1])
	if IsJobAllowed(PlayerData.job.name, PlayerData.job.grade) then

        ESX.TriggerServerCallback("arshia_jail:retriveJail", function(psentence)
            if psentence then
                if psentence.time > 0 then
                    if psentence.type == 'faction' then
                        TriggerServerEvent('arshia_jail:UnjailPlayer', target)
                    else
                        TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Fard Dar jaile Police Nist.")
                    end
                else
                    TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
                end
            else
                TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
            end
        end, target)

    else
        TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Shoma Dastresi Ndarid !")
    end
end, false)

RegisterNetEvent("arshia_jail:SentencePlayer")
AddEventHandler("arshia_jail:SentencePlayer", function(type, time,unjail,join)
    Sentence(type, time, unjail,join)
end)

RegisterNetEvent("arshia_jail:JailPlayer")
AddEventHandler("arshia_jail:JailPlayer", function(target, type, time,reason,unjail)
    TriggerServerEvent("arshia_jail:sendto", target, type, time, reason, unjail)
end)

function Sentence(type, time, unjail, join)
    local ped = GetPlayerPed(-1)
    RemoveWeapons(ped)

    sentence.time = time
    sentence.type = type
    sentence.unjail = unjail
    sentence.distance = 100.0
    if type == "faction" then
        if not join then
            playCutscene()
        else
            SendJail()
        end
    else
        SendJail()
    end
    changeClothes()
    sentence.active = true
end

function RemoveWeapons(ped)
    SetPedArmour(ped, 0)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3, namies, player, network)
	local Player = nil
	if player ~= nil then
		Player = player
	else
		Player = PlayerPedId()
	end
	local x,y,z = table.unpack(GetEntityCoords(Player))
	RequestModel(prop1)
    local prop
	if network then
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(prop1)
	else
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  false,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(prop1)
	end
    return prop
end

function createCam(coords, rotation)
    if cam ~= 0 then
        DestroyCam(cam, 0)
        cam = 0
    end

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, coords)
    SetCamRot(cam, rotation, 2)
    RenderScriptCams(true, false, 0, true, true)
    Wait(250)
end

function changeClothes()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            local clothesSkin = {
                ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0,
                ['mask_1'] = 0,   ['mask_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['bags_1'] = -1,  ['bags_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['chain_1'] = 0,    ['chain_2'] = 0,
                ['torso_1'] = 5, ['torso_2'] = 0,
                ['arms'] = 5,
                ['pants_1'] = 9, ['pants_2'] = 4,
                ['shoes_1'] = 42, ['shoes_2'] = 2,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        elseif skin.sex == 1 then
            local clothesSkin = {
                ['tshirt_1'] = 14, ['tshirt_2'] = 0,
                ['bproof_1'] = 0,  ['bproof_2'] = 0,
                ['mask_1'] = 0,   ['mask_2'] = 0,
                ['helmet_1'] = -1,  ['helmet_2'] = 0,
                ['bags_1'] = -1,  ['bags_2'] = 0,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['chain_1'] = 0,    ['chain_2'] = 0,
                ['torso_1'] = 141, ['torso_2'] = 2,
                ['arms'] = 0,
                ['pants_1'] = 66, ['pants_2'] = 10,
                ['shoes_1'] = 16, ['shoes_2'] = 2,
            }
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end
    end)
end

function DrawGenericText(text)
    SetTextFont(0)
    SetTextScale(0.378, 0.378)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(5.0, 35, 41, 37, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.40, 0.00)
end

function playCutscene()
    stopThread = true
    cutscene = true
    CreateThread(function()
        SetEntityVisible(PlayerPedId(), false, false)
        TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true, invisibility = true })
        local exemptRefresh = GetGameTimer()
        while cutscene do
            Wait(0)
            DisableAllControlActions(0)
            SetPlayerVisibleLocally(PlayerId(), true)
            if GetGameTimer() - exemptRefresh > 3000 then
                TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 4000, { teleport = true, speed = true, invisibility = true })
                exemptRefresh = GetGameTimer()
            end
        end
        SetEntityVisible(PlayerPedId(), true, false)
    end)
	local ped = PlayerPedId()
    DoScreenFadeOut(1000)
    RequestAnimDict('mp_character_creation@customise@male_a')
    Wait(3000)
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    SetEntityCoords(ped, Config.cutscene.cuff)
    Wait(500)
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    SetEntityCoords(ped, Config.cutscene.cuff)
    RequestModel(Config.cutscene.guardModel)
    while not HasModelLoaded(Config.cutscene.guardModel) do
        Wait(0)
    end
    RequestModel(Config.cutscene.clotheModel)
    RequestAnimDict('mp_arresting')
    RequestAnimDict('switch@trevor@escorted_out')
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(ped, true)
    DisablePlayerFiring(ped, true)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    SetPedCanPlayGestureAnims(ped, false)
    FreezeEntityPosition(ped, true)
    local byped = CreatePed(4, Config.cutscene.guardModel, Config.cutscene.guardCoords.x, Config.cutscene.guardCoords.y, Config.cutscene.guardCoords.z, Config.cutscene.guardCoords.w,false)
    PlaceObjectOnGroundProperly(byped)
    SetEntityAsMissionEntity(byped)
    SetPedDropsWeaponsWhenDead(byped, false)
    SetPedAsEnemy(byped, false)
    SetEntityInvincible(byped, true)
    Wait(500)
    AttachEntityToEntity(ped, byped, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(byped, 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

    createCam(Config.cutscene.camCoords, Config.cutscene.camRot)
    DoScreenFadeIn(500)

    TaskGoStraightToCoord(byped, Config.cutscene.stopTurn.xyz, 1.0, 2500, Config.cutscene.stopTurn.w, 0)
    Wait(2500)
    TaskGoStraightToCoord(byped, Config.cutscene.enterCoords, 1.0, 2000, 160.0, 0)
    Wait(2000)
    TaskGoStraightToCoord(byped, Config.cutscene.clotheCoords2.xyz, 1.0, 3000, Config.cutscene.clotheCoords2.w, 0)
    Wait(3000)
    DetachEntity(ped, true, false)
    ClearPedSecondaryTask(ped)
    ClearPedSecondaryTask(byped)
    SetEnableHandcuffs(ped, false)
    DisablePlayerFiring(ped, false)
    SetPedCanPlayGestureAnims(ped, true)
    FreezeEntityPosition(ped, false)
    RequestAnimDict('clothingtie')
    TaskGoStraightToCoord(byped, Config.cutscene.stopNLook.xyz, 1.0, 1500, 85.28, 0)
    Wait(2000)
    RequestAnimDict('mp_prison_break')
    TaskGoStraightToCoord(byped, Config.cutscene.computerCoords.xyz, 1.0, 2000, Config.cutscene.computerCoords.w, 0)
    Wait(2000)
    TaskPlayAnim(byped, "mp_prison_break", "hack_loop", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    RequestAnimDict('anim@heists@prison_heistig1_p1_guard_checks_bus')
    Wait(2000)
    ClearPedTasksImmediately(ped)
    changeClothes()
    Wait(100)
    local _prop =  AddPropToPlayer('prop_police_id_board', 58868, 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, 'enter', nil, false)

    TaskPlayAnim(byped, 'gestures@f@standing@casual', 'gesture_point', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    RemoveAnimDict('gestures@f@standing@casual')
    Wait(200)
    TaskGoStraightToCoord(ped, Config.cutscene.enterCoords, 1.0, 4000, Config.cutscene.enterHeadings.Front, 0)
    Wait(2000)
    ClearPedTasksImmediately(byped)
    TaskGoStraightToCoord(byped, Config.cutscene.computerCoords.xyz, 1.0, 2500, Config.cutscene.computerCoords.w, 0)
    Wait(2500)
    TaskPlayAnim(byped, "mp_prison_break", "hack_loop", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    RemoveAnimDict('anim@heists@prison_heistig1_p1_guard_checks_bus')
    RemoveAnimDict('mp_prison_break')

    RequestAnimDict('mp_character_creation@customise@male_a')

    TaskPlayAnim(ped, "mp_character_creation@customise@male_a", "loop", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    FreezeEntityPosition(ped, true)

    Wait(5500)
    FreezeEntityPosition(ped, false)
    TaskAchieveHeading(ped, Config.cutscene.enterHeadings.Side, 3000)
    Wait(3000)
    TaskPlayAnim(ped, "mp_character_creation@customise@male_a", "loop", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    Wait(6000)
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)
    RemoveAnimDict('mp_character_creation@customise@male_a')
    DeleteEntity(_prop)

    ClearPedTasksImmediately(byped)
    TaskGoStraightToCoord(byped, Config.cutscene.stopNLook.xyz, 1.0, 2000, Config.cutscene.stopNLook.w, 0)
    Wait(2000)
    TaskGoStraightToCoord(byped, Config.cutscene.grabCoords.xyz, 1.0, 5500, Config.cutscene.grabCoords.w, 0)
    TaskAchieveHeading(ped, 24.44, 5500)
    Wait(6000)
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    RemoveAnimDict('mp_arresting')
    SetEnableHandcuffs(ped, true)
    DisablePlayerFiring(ped, true)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    SetPedCanPlayGestureAnims(ped, false)
    FreezeEntityPosition(ped, true)
    Wait(500)
    AttachEntityToEntity(ped, byped, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    TaskPlayAnim(byped, 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Wait(500)
    TaskAchieveHeading(byped, 258.46, 1500)
    Wait(1500)
    TaskGoStraightToCoord(byped, Config.cutscene.walkCoords, 1.0, 5500, 100, 0)
    Wait(5500)
    DetachEntity(ped, true, false)
    ClearPedSecondaryTask(ped)
    ClearPedSecondaryTask(byped)
    SetEnableHandcuffs(ped, false)
    DisablePlayerFiring(ped, false)
    SetPedCanPlayGestureAnims(ped, true)
    FreezeEntityPosition(ped, false)

    DeleteEntity(byped)
    DoScreenFadeOut(1000)
    Wait(1000)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)

    createCam(Config.cutscene.camCoords2, Config.cutscene.camRot2)
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    ESX.Game.Teleport(ped, Config.cutscene.spawnCoords2, function()
        RequestModel('s_m_y_swat_01')
        while not HasModelLoaded('s_m_y_swat_01') do
            Wait(0)
        end
        local swat = CreatePed(4, 's_m_y_swat_01', Config.cutscene.police2Coords.x, Config.cutscene.police2Coords.y, Config.cutscene.police2Coords.z, Config.cutscene.police2Coords.w,false)
        SetBlockingOfNonTemporaryEvents(swat, true)
        SetEntityHeading(swat, Config.cutscene.police2Coords.w)





        ESX.Game.SpawnLocalVehicle('riot', Config.cutscene.riotCoords.xyz, Config.cutscene.riotCoords.w, function(vehicle)
            local driver = CreatePed(1, 's_m_y_swat_01', Config.cutscene.police2Coords.x, Config.cutscene.police2Coords.y, Config.cutscene.police2Coords.z, Config.cutscene.police2Coords.w,false)
            TaskWarpPedIntoVehicle(driver, vehicle, -1)
            SetBlockingOfNonTemporaryEvents(driver, true)
            SetPedRandomComponentVariation(driver, false)
            SetPedKeepTask(driver, true)
            SetVehicleEngineOn(vehicle, true, false, false)


            Wait(1000)



            TaskEnterVehicle(ped, vehicle, 15000, 2, 1.0, 1, 0)
            TaskEnterVehicle(swat, vehicle, 15000, 6, 1.0, 1, 0)
            DoScreenFadeIn(500)
            SetTimeout(5000, function()
                createCam(Config.cutscene.camCoords3, Config.cutscene.camRot3)
            end)

            Wait(15000)
            TaskVehicleDriveWander(driver, vehicle, GetVehicleModelMaxSpeed(GetEntityModel(vehicle)), 447)
            Wait(5000)
            DoScreenFadeOut(500)
            Wait(1000)
            DeleteEntity(driver)
            DeleteEntity(vehicle)
            DeleteEntity(swat)
            DeleteEntity(driver)
            DetachEntity(ped, true, false)
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(cam, false)
            SetFocusEntity(GetPlayerPed(PlayerId()))
            stopThread = false
            cutscene = false
            Citizen.CreateThread(function()
                SendJail()
            end)
            Wait(1000)
            DoScreenFadeIn(500)
        end)
    end)
end

function SendJail()
    local ped = PlayerPedId()
    TriggerServerEvent('Unique_Punishment:AntiCheatExempt', 5000, { teleport = true, speed = true })
    ESX.Game.Teleport(ped, vector3(1691.65,2564.72,45.56))
    trigtimer()
end

