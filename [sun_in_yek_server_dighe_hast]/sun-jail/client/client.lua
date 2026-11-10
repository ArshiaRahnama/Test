-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

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

ESX = exports['essentialmode']:getObject()
PlayerData = {}
local time = 0
local triggerTime = 0
local sentence = {active = false, time = 0, coords = {x = 0, y = 0, z = 0}, distance = 0, type = 0, ajail = false}
local stopThread, cutscene = false, false
local cam = 0
Citizen.CreateThread(function()
    while not ESX do
        Wait(1000)
    end

    while ESX.GetPlayerData() == nil do

        Wait(1000)
    end

    while ESX.GetPlayerData().job == nil do

        Wait(1000)
    end

    PlayerData = ESX.GetPlayerData()
    if PlayerData.job.name == 'justice' then
        justiceThread()
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
    if PlayerData.job.name == 'justice' then
        justiceThread()
    end
end)

AddEventHandler("loading:Loaded", function()
    ESX.TriggerServerCallback("esx_jail:retriveJail", function(psentence)
        if psentence.time > 0 then
            Sentence(psentence.type, psentence.time, psentence.coords,psentence.unjail, true)
        end
    end)
end)

RegisterNetEvent("esx_jail:unJailSelf")
AddEventHandler("esx_jail:unJailSelf", function()
    UnJail()
end)

RegisterNetEvent("esx_jail:SentencePlayer")
AddEventHandler("esx_jail:SentencePlayer", function(type, time, coords,unjail)
    if ESX.GetPlayerData().World ~= 0 then
        exports['sun-jobs']:uncuffself()
        Wait(3000)
        ESX.TriggerServerEvent('rob:exitRobbery')
        Wait(2000)
    end
    Sentence(type, time, coords,unjail)
end)

RegisterNetEvent("esx_jail:notifications")
AddEventHandler("esx_jail:notifications", function(message)
    if not ESX or not PlayerData or not PlayerData.job then return end
    if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == 'mt' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'justice' or PlayerData.job.name == 'detective' then
        TriggerEvent('chat:addMessage', {color = {0, 95, 254}, multiline = true ,args = {"[DISPATCH]", message}}, 'dispatch')
    end
end)

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
                local distance = GetDistanceBetweenCoords(coords, sentence.coords.x, sentence.coords.y, sentence.coords.y, false)

                if distance > sentence.distance then
                    DetachEntity(ped, true, true)
                    ESX.Game.Teleport(ped, sentence.coords)
                    ESX.ShowNotification("~r~~h~Nemitoni Az Zendan Farar Koni!")
                end

            else
                Wait(2000)
            end

        end

end)

Citizen.CreateThread(function()

        while true do
            Wait(1000)

            if sentence.active then
                if triggerTime == 0 then
                    if GetGameTimer() - time > 60000 then
                        time = GetGameTimer()

                        sentence.time = sentence.time - 1

                        ESX.TriggerServerEvent('esx_jail:UpdateTime')
                        if sentence.time == 0 then
                            sentence.active = false
                        end

                    end
                end
            end

        end

end)

function tTime()
    triggerTime = triggerTime - 1
    if triggerTime > 0 then
        SetTimeout(1000, tTime)
    end
end

function Sentence(type, time, coords,unjail, join)
    exports['sun-jobs']:uncuffself()
    local ped = GetPlayerPed(-1)
    RemoveWeapons(ped)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.3)
    ESX.SetPlayerData('jailed', 1)

    sentence.time = time
    sentence.type = type
    sentence.ajail = false
    sentence.distance = 3.0
    sentence.coords = coords
    sentence.unjail = unjail
    if type == "admin" then
        local place = Config.Admin
        sentence.coords = place.coords
        sentence.distance = place.distance
        sentence.ajail = true
        sentence.unjail = Config.Unjails.admin
        ESX.Game.Teleport(ped, place.coords)
        SetEntityHeading(ped, place.heading)
    elseif sentence.coords.x == 1691 then
        sentence.distance = 150.0
        if not join then
            TriggerServerEvent('jail:changeWorld')
            playCutscene()
            Wait(5000)
            SetTimeout(15000, function()
                TriggerServerEvent('core:backToRealWorld')
            end)
        end
    end
    changeClothes()
    triggerTime = 61
    tTime()

    sentence.active = true

end

function RemoveWeapons(ped)
    ESX.SetPedArmour(ped, 0)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
end

function UnJail()
    if exports['sunset_utils']:stopGym() then
        Wait(10000)
    end
    sentence.time = 0
    sentence.coords = {x = 0, y = 0, z = 0}
    sentence.distance = 0
    ESX.SetPlayerData('jailed', 0)
    sentence.type = 0
    sentence.ajail = false
    sentence.active = false
    local ped = GetPlayerPed(-1)
    ESX.Game.Teleport(ped, sentence.unjail)
    exports['sunset_clothe']:removeStuffJob()
    Wait(1000)
    exports['sunset_clothe']:loadUsed()
    ESX.ShowNotification("~g~~h~Shoma Azad Shodid!")
    TriggerServerEvent('cs:checkIfSentenced')
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

local jailColor    = GetResourceKvpString('sun_jail_color') or '#e0463b'
local jailMenuOpen = false
local currentJail  = nil


AddEventHandler('sun_menu:settings', function(s)
    if type(s) == 'table' and s.jail and s.jail.color then
        jailColor = s.jail.color
        SetResourceKvp('sun_jail_color', jailColor)
        if jailMenuOpen then SendNUIMessage({ action = 'setColor', color = jailColor }) end
    end
end)

local function openJailNui(job, jobData, targetSrc, unjail, robbery, maxTime)
    currentJail  = { unjail = unjail, maxTime = maxTime or jobData.maxTime or 60, targetSrc = targetSrc, robbery = robbery }
    jailMenuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', job = job or 'police', color = jailColor, list = jobData.list })
end

local function confirmBlackListThenOpen(job, jobData, src, unjail, robbery, maxTime)
    ESX.TriggerServerCallback('jail:hasBlackList', function(hasBlackList)
        if hasBlackList then
            local alert = lib.alertDialog({
                header = 'Jail',
                content = 'Shakhs item gheyre mojaz darad  \nAya mikhahid jail konid?',
                centered = true,
                cancel = true,
                labels = {confirm = 'Bale', cancel = 'Kheyr'}
            })
            if alert ~= 'confirm' then return end
        end
        openJailNui(job, jobData, src, unjail, robbery, maxTime)
    end, src)
end

RegisterNetEvent('esx_jail:openmenu')
AddEventHandler('esx_jail:openmenu',function()
    local pd  = ESX.GetPlayerData and ESX.GetPlayerData()
    local job = pd and pd.job and pd.job.name
    local jobData = Config.suggestionjail and (Config.suggestionjail[job] or Config.suggestionjail['default'])
    if not jobData then
        return ESX.ShowNotification('Hich jail-e pishnahadi tarif nashode', 'job')
    end

    if exports['sun-robbery']:doesInRob() then
        ESX.selectPlayerMenu(function(src)
            ESX.UI.Menu.CloseAll()
            confirmBlackListThenOpen(job, jobData, src, nil, true, 60)
        end, 5, function(src)
            return Player(src).state.Cuffed
        end)
        return
    end

    local canopen = false
    local unjail = 0
    local coords = GetEntityCoords(PlayerPedId())
    for k , v in pairs(Config.CanJail) do
        local distance = GetDistanceBetweenCoords(coords,v.coords)
        if distance <= v.radius then
            canopen = true
            unjail = v.unjail
        end
    end
    if not canopen then
        return ESX.ShowNotification('Shoma nemitavanid dar in makan kasi ro jail konid', 'job')
    end
    ESX.selectPlayerMenu(function(src)
        ESX.UI.Menu.CloseAll()
        confirmBlackListThenOpen(job, jobData, src, unjail, false)
    end, 5)
end)

RegisterNUICallback('jailPick', function(data, cb)
    jailMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
    TriggerEvent('KeyDown:f6')
    local j = currentJail
    if not j then return end
    local reason = data.reason
    local time = tonumber(data.time)
    if reason == nil or reason == '' or time == nil or time <= 0 then
        return ESX.ShowNotification('Etelaate jail namoatabar ast', 'job')
    end
    if time > j.maxTime then
        return ESX.ShowNotification(('Zaman bayad kamtar az %s daghighe bashad'):format(j.maxTime), 'job')
    end
    local maxDistance = j.robbery and 10.0 or 20.0
    local tgt    = GetPlayerFromServerId(j.targetSrc)
    local tgtPed = tgt ~= -1 and GetPlayerPed(tgt) or 0
    if tgtPed == 0 or not DoesEntityExist(tgtPed) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(tgtPed)) > maxDistance then
        return ESX.ShowNotification(('Fard kheyli dur ast (bishtar az %s metr)'):format(math.floor(maxDistance)), 'job')
    end
    TriggerServerEvent("esx_jail:sendto", j.targetSrc, time, reason, j.unjail, j.robbery)
end)

RegisterNUICallback('jailClose', function(data, cb)
    jailMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

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

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3, namies, player, network)
	local Player = nil
	if player ~= nil then
		Player = player
	else
		Player = PlayerPedId()
	end
	local x,y,z = table.unpack(GetEntityCoords(Player))
	ESX.requestModel(prop1)
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

function playCutscene()
    LocalPlayer.state:set('camera', true, false)
    stopThread = true
    cutscene = true
    CreateThread(function()
        exports['essentialmode']:disableallControl(true)
        exports['suncore']:SetPlayerVisible(false)
        while cutscene do
            Wait(0)
            DisableAllControlActions(0)
            SetPlayerVisibleLocally(PlayerId(), true)
        end
        exports['essentialmode']:disableallControl(false)
        exports['suncore']:SetPlayerVisible(true)
    end)
	local ped = PlayerPedId()
    DoScreenFadeOut(1000)
    RequestAnimDict('mp_character_creation@customise@male_a')
    Wait(3000)
    ESX.SetEntityCoords(ped, Config.cutscene.cuff)
    Wait(500)
    ESX.SetEntityCoords(ped, Config.cutscene.cuff)
    ESX.requestModel(Config.cutscene.guardModel)
    ESX.requestModel(Config.cutscene.clotheModel)
    ESX.Streaming.RequestAnimDict('mp_arresting')
    ESX.Streaming.RequestAnimDict('switch@trevor@escorted_out')
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
    SetEnableHandcuffs(ped, true)
    DisablePlayerFiring(ped, true)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    SetPedCanPlayGestureAnims(ped, false)
    FreezeEntityPosition(ped, true)
    local byped = ESX.Game.SpawnLocalPed(5, Config.cutscene.guardModel, Config.cutscene.guardCoords.xyz, Config.cutscene.guardCoords.w)
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
    ESX.Streaming.RequestAnimDict('clothingtie')
    TaskGoStraightToCoord(byped, Config.cutscene.stopNLook.xyz, 1.0, 1500, 85.28, 0)
    Wait(2000)
    ESX.Streaming.RequestAnimDict('mp_prison_break')
    TaskGoStraightToCoord(byped, Config.cutscene.computerCoords.xyz, 1.0, 2000, Config.cutscene.computerCoords.w, 0)
    Wait(2000)
    TaskPlayAnim(byped, "mp_prison_break", "hack_loop", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    ESX.Streaming.RequestAnimDict('anim@heists@prison_heistig1_p1_guard_checks_bus')
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

    ESX.Streaming.RequestAnimDict('mp_character_creation@customise@male_a')

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
    ESX.Game.Teleport(ped, Config.cutscene.spawnCoords2, function()
        local swat = ESX.Game.SpawnLocalPed(1, 's_m_y_swat_01', Config.cutscene.police2Coords.xyz, Config.cutscene.police2Coords.w)
        SetBlockingOfNonTemporaryEvents(swat, true)
        SetEntityHeading(swat, Config.cutscene.police2Coords.w)
        ESX.Game.SpawnLocalVehicle('riot', Config.cutscene.riotCoords.xyz, Config.cutscene.riotCoords.w, function(vehicle)
            local driver = ESX.Game.SpawnLocalPed(1, 's_m_y_swat_01', Config.cutscene.police2Coords.xyz, Config.cutscene.police2Coords.w)
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
            Wait(1000)
            DoScreenFadeIn(500)
            LocalPlayer.state:set('camera', false, false)
        end)
    end)
end


function playHeliAnimation(k)
    local config = Config.justice[k].animation
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(cam, config.camCoords.x, config.camCoords.y, config.camCoords.z)
    PointCamAtCoord(cam, config.pointAt.x, config.pointAt.y, config.pointAt.z)

    RenderScriptCams(true, false, 0, true, true)

    ESX.Game.SpawnLocalVehicle('polmav', config.pointAt, 30, function(vehicle)
        ESX.Streaming.RequestModel('s_m_m_pilot_02')
        local pilot = CreatePedInsideVehicle(vehicle, 1, `s_m_m_pilot_02`, -1, false, true)
        SetBlockingOfNonTemporaryEvents(pilot, true)
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        local byPed = ESX.Game.SpawnLocalPed(5, 'csb_cop', config.ped2.xyz, config.ped2.w)
        local ped2 = ClonePed(PlayerPedId(), false, true, true)
        SetBlockingOfNonTemporaryEvents(byPed, true)
        SetBlockingOfNonTemporaryEvents(ped2, true)
        ESX.SetEntityCoords(ped2, config.ped1.xyz)
        SetEntityHeading(ped2, config.ped1.w)
        Wait(1000)
        TaskGoToEntity(byPed, vehicle, 20000, 0.5, 1.0, 1073741824, 0)
        TaskGoToEntity(ped2, vehicle, 20000, 0.5, 1.0, 1073741824, 0)
        Wait(9000)
        TaskEnterVehicle(byPed, vehicle, 9000, 2, 1.0, 1)
        TaskEnterVehicle(ped2, vehicle, 3000, 1, 1.0, 1)
        Wait(8000)
        TaskHeliMission(pilot, vehicle, 0, 0, 100.0, 100.0, 200.0, 4, 100.0, -1.0, -1.0, 0, 0, 5.0, 4096)
        local thread = true
        SetTimeout(10000, function()
            thread = false
        end)
        while thread do
            local coords = GetEntityCoords(vehicle)
            PointCamAtCoord(cam, coords.x, coords.y, coords.z)
            Wait(0)
        end
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        ESX.fadeScreen(2000, function()
            ESX.Game.DeleteEntity(vehicle)
            ESX.Game.DeleteEntity(byPed)
            ESX.Game.DeleteEntity(ped2)
            ESX.Game.DeleteEntity(pilot)
        end)
    end)
end

local bJusticeThread = false
function justiceThread()
    if not bJusticeThread then
        bJusticeThread = true
        CreateThread(function()
            local duty = false
            while bJusticeThread do
                if PlayerData.job.name == 'justice' then
                    local near = false
                    local coords = GetEntityCoords(PlayerPedId())
                    for k, v in pairs(Config.justice) do
                        if #(v.range.xyz - coords) < v.range.w then
                            if not duty then
                                duty = true
                                TriggerServerEvent('jail:setDuty', true, k)
                            end
                            near = true
                        end
                    end
                    if not near then
                        duty = false
                        TriggerServerEvent('jail:setDuty', false)
                    end
                elseif duty then
                    duty = false
                    TriggerServerEvent('jail:setDuty', false)
                end
                Wait(15000)
            end
        end)
    end
end

RegisterNetEvent('jail:sendToJustice', function(station)
    exports['sun-jobs']:uncuffself()
    Wait(3000)
    if ESX.GetPlayerData().World ~= 0 then
        ESX.TriggerServerEvent('rob:exitRobbery')
    end
    ESX.fadeScreen(2000, function()
        ESX.Game.Teleport(PlayerPedId(), Config.justice[station].jail)
        playHeliAnimation(station)
    end)
end)

exports('getJailTime', function()
    return sentence and sentence.time
end)