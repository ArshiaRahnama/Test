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
local AdminPerks = false
local ShowID = false
local muted = false
local first = false
local time = 0
local disPlayerNames = 30
local event = nil
local ForceToVisible = false
local owned = false
local currentTags = {}
local playerDistances = {}
local playerinfo = {}
local states = {}
local activencz 	= false
local show2 = false
local Godmode = true

ShowBlips = false
states.frozen = false
states.frozenPos = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent("esx:getSharedObject",function(obj)
				ESX = obj
			end)

		Citizen.Wait(1)
		PlayerData = ESX.GetPlayerData()

		if first then
			ESX.SetPlayerData('aduty',0)
			first = false
		end

	end
end)

local function lookupify(t)
    local r = {}

    for _, v in ipairs(t) do
        r[v] = true
    end

    return r
end

local blocked_ranges = {{0x0001F601, 0x0001F64F}, {0x00002702, 0x000027B0}, {0x0001F680, 0x0001F6C0}, {0x000024C2, 0x0001F251}, {0x0001F300, 0x0001F5FF}, {0x00002194, 0x00002199}, {0x000023E9, 0x000023F3}, {0x000025FB, 0x000026FD}, {0x0001F300, 0x0001F5FF}, {0x0001F600, 0x0001F636}, {0x0001F681, 0x0001F6C5}, {0x0001F30D, 0x0001F567}, {0x0001F980, 0x0001F984}, {0x0001F910, 0x0001F918}, {0x0001F6E0, 0x0001F6E5}, {0x0001F920, 0x0001F927}, {0x0001F919, 0x0001F91E}, {0x0001F933, 0x0001F93A}, {0x0001F93C, 0x0001F93E}, {0x0001F985, 0x0001F98F}, {0x0001F940, 0x0001F94F}, {0x0001F950, 0x0001F95F}, {0x0001F928, 0x0001F92F}, {0x0001F9D0, 0x0001F9DF}, {0x0001F9E0, 0x0001F9E6}, {0x0001F992, 0x0001F997}, {0x0001F960, 0x0001F96B}, {0x0001F9B0, 0x0001F9B9}, {0x0001F97C, 0x0001F97F}, {0x0001F9F0, 0x0001F9FF}, {0x0001F9E7, 0x0001F9EF}, {0x0001F7E0, 0x0001F7EB}, {0x0001FA90, 0x0001FA95}, {0x0001F9A5, 0x0001F9AA}, {0x0001F9BA, 0x0001F9BF}, {0x0001F9C3, 0x0001F9CA}, {0x0001FA70, 0x0001FA73}}
local block_singles = lookupify{0x000000A9, 0x000000AE, 0x0000203C, 0x00002049, 0x000020E3, 0x00002122, 0x00002139, 0x000021A9, 0x000021AA, 0x0000231A, 0x0000231B, 0x000025AA, 0x000025AB, 0x000025B6, 0x000025C0, 0x00002934, 0x00002935, 0x00002B05, 0x00002B06, 0x00002B07, 0x00002B1B, 0x00002B1C, 0x00002B50, 0x00002B55, 0x00003030, 0x0000303D, 0x00003297, 0x00003299, 0x0001F004, 0x0001F0CF, 0x0001F6F3, 0x0001F6F4, 0x0001F6E9, 0x0001F6F0, 0x0001F6CE, 0x0001F6CD, 0x0001F6CF, 0x0001F6CB, 0x00023F8, 0x00023F9, 0x00023FA, 0x0000023, 0x0001F51F, 0x0001F6CC, 0x0001F9C0, 0x0001F6EB, 0x0001F6EC, 0x0001F6D0, 0x00023CF, 0x000002A, 0x0002328, 0x0001F5A4, 0x0001F471, 0x0001F64D, 0x0001F64E, 0x0001F645, 0x0001F646, 0x0001F681, 0x0001F64B, 0x0001F647, 0x0001F46E, 0x0001F575, 0x0001F582, 0x0001F477, 0x0001F473, 0x0001F930, 0x0001F486, 0x0001F487, 0x0001F6B6, 0x0001F3C3, 0x0001F57A, 0x0001F46F, 0x0001F3CC, 0x0001F3C4, 0x0001F6A3, 0x0001F3CA, 0x00026F9, 0x0001F3CB, 0x0001F6B5, 0x0001F6B5, 0x0001F468, 0x0001F469, 0x0001F990, 0x0001F991, 0x0001F6F5, 0x0001F6F4, 0x0001F6D1, 0x0001F6F6, 0x0001F6D2, 0x0002640, 0x0002642, 0x0002695, 0x0001F3F3, 0x0001F1FA, 0x0001F91F, 0x0001F932, 0x0001F931, 0x0001F9F8, 0x0001F9F7, 0x0001F3F4, 0x0001F970, 0x0001F973, 0x0001F974, 0x0001F97A, 0x0001F975, 0x0001F976, 0x0001F9B5, 0x0001F9B6, 0x0001F468, 0x0001F469, 0x0001F99D, 0x0001F999, 0x0001F99B, 0x0001F998, 0x0001F9A1, 0x0001F99A, 0x0001F99C, 0x0001F9A2, 0x0001F9A0, 0x0001F99F, 0x0001F96D, 0x0001F96C, 0x0001F96F, 0x0001F9C2, 0x0001F96E, 0x0001F99E, 0x0001F9C1, 0x0001F6F9, 0x0001F94E, 0x0001F94F, 0x0001F94D, 0x0000265F, 0x0000267E, 0x0001F3F4, 0x0001F971, 0x0001F90E, 0x0001F90D, 0x0001F90F, 0x0001F9CF, 0x0001F9CD, 0x0001F9CE, 0x0001F468, 0x0001F469, 0x0001F9D1, 0x0001F91D, 0x0001F46D, 0x0001F46B, 0x0001F46C, 0x0001F9AE, 0x0001F415, 0x0001F6D5, 0x0001F6FA, 0x0001FA82, 0x0001F93F, 0x0001FA80, 0x0001FA81, 0x0001F97B, 0x0001F9AF, 0x0001FA78, 0x0001FA79, 0x0001FA7A}


RegisterNetEvent('esx:ActiveAdminPerks')
AddEventHandler('esx:ActiveAdminPerks', function(toggle)
	ShowID = toggle
	AdminPerks = toggle
	AdminPerksFunc()
	ShowPlayerNames()
end)

RegisterNetEvent("esx_aduty:GodModeMenu")
AddEventHandler('esx_aduty:GodModeMenu', function(toggle3)
    Godmode = toggle3
    if toggle3 then
	    AdminPerksFunc()
    end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
	TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
	SetEntityCoords(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('esx:ncz')
AddEventHandler('esx:ncz', function(active)
	activencz = active
	if activencz then
		Citizen.CreateThread(function()
			while activencz do
				Wait(1)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['Q'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['M'], true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 19, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 24,  true)
			DisableControlAction(0, 92,  true)
			DisablePlayerFiring(player, true)
			end
		end)
	end
end)

local LastPosAdmin

RegisterNetEvent("adutyHandler")
AddEventHandler("adutyHandler",function()
	UpdatePos = false
	Citizen.CreateThread(function()

		if not IsPlayerSwitchInProgress() then
			SetEntityVisible(PlayerPedId(), false, 0)
			SwitchOutPlayer(PlayerPedId(), 32, 1)
		end
		while GetPlayerSwitchState() ~= 5 do
			Citizen.Wait(1)
		end
		LastPosAdmin = GetEntityCoords(PlayerPedId())
		TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
		SetEntityCoords(PlayerPedId(), -75.27, -819.43, 326.18 - 1)
		TriggerEvent('es_admin:freezePlayer', true)

		ESX.ShowLoadingPromt("Wait For On-Duty", 5000)
		Citizen.Wait(5000)

		SwitchInPlayer(PlayerPedId())
		SetEntityVisible(PlayerPedId(), true, 0)
		local timer = GetGameTimer()
		while GetPlayerSwitchState() ~= 12 and GetGameTimer() - timer < 1000 * 10 * 3 do
			Wait(1000)
		end
		TriggerEvent('es_admin:freezePlayer', false)
	end)
	AdminPerks = true
	ShowID = true

end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)
        PlayerData = xPlayer
        TriggerEvent('chat:addSuggestion', '/deattach', 'jahat bardashtan component haye aslahe', {
            { name="Type", help="(silencer, eclip, dclip, flashlight, grip, all)" }
        })
		TriggerEvent('chat:addSuggestion', '/reload', 'Jahat Fix Kardan Status', {})
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
	ESX.GetPlayerData().job = job
end)

RegisterNetEvent("OnDutyHandler")
AddEventHandler("OnDutyHandler",function(aa)

    ESX.SetPlayerData('aduty',1)
    TriggerServerEvent("esx_aduty:OnDutyHandler")
    if aa then
        TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), '[aa]OnDuty shod','user', true, source, false)
    else
        TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), 'OnDuty shod','user', true, source, false)
    end

	TriggerEvent("Admin_Menu:GetGodeModes", aa)
    TriggerEvent('esx_scoreboard:toggleme', false)
    TriggerEvent('togglescoreboard1', true)
    TriggerEvent('aduty', true)
    ShowBlips = false

	ShowID = true
	AdminPerks = true
end)

RegisterNetEvent("OffDutyHandler")
AddEventHandler("OffDutyHandler",function(aa)
    ESX.SetPlayerData('aduty',0)
    if aa then
        TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), '[aa]OffDuty shod','user', true, source, false)
    else
        TriggerServerEvent('DiscordBot:ToDiscord', 'duty', GetPlayerName(PlayerId()), 'OffDuty shod','user', true, source, false)
    end


    TriggerEvent('esx_scoreboard:toggleme', true)
    TriggerEvent('togglescoreboard1', false)
    TriggerEvent('aduty', false)
	ShowID = false

    ShowBlips = false
	AdminPerks = false
end)

local loaded = false
local oldPos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(PlayerPedId())
		local heading = GetEntityHeading(PlayerPedId())
		if(oldPos ~= pos)then
			TriggerServerEvent('updatePositions', pos.x, pos.y, pos.z, heading)
			oldPos = pos
		end
	end
end)

RegisterNetEvent("AdminOffDuty")
AddEventHandler("AdminOffDuty",function()
	UpdatePos = true
	Citizen.CreateThread(function()
		if not IsPlayerSwitchInProgress() then
			SetEntityVisible(PlayerPedId(), false, 0)
			SwitchOutPlayer(PlayerPedId(), 32, 1)
		end
		while GetPlayerSwitchState() ~= 5 do
			Citizen.Wait(1)
		end

		if LastPosAdmin ~= nil then
			TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
			SetEntityCoords(PlayerPedId(), LastPosAdmin.x, LastPosAdmin.y, LastPosAdmin.z - 1)
		else
			TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
			SetEntityCoords(PlayerPedId(), 215.800, -810.057, 30.727)
		end

		TriggerEvent('es_admin:freezePlayer', true)

		ESX.ShowLoadingPromt("Wait Fow Off-Duty", 5000)
		Citizen.Wait(5000)
		SwitchInPlayer(PlayerPedId())
		SetEntityVisible(PlayerPedId(), true, 0)
		local timer = GetGameTimer()
		while GetPlayerSwitchState() ~= 12 and GetGameTimer() - timer < 1000 * 10 * 3 do
			Wait(1000)
		end
		TriggerEvent('es_admin:freezePlayer', false)

	end)

end)

RegisterNetEvent("OffDutyHandlerForJail")
AddEventHandler("OffDutyHandlerForJail",function()
	ESX.SetPlayerData('aduty',0)
	SetEntityVisible(PlayerPedId(), true, 0)
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('esx_scoreboard:toggleme', true)
	TriggerEvent('togglescoreboard1', false)
	TriggerServerEvent('aduty:changeDutyStatus', source)
	TriggerEvent("aduty:tagChanger", false)
	AdminPerks = false
	ShowID = false
end)

function OffDutyHandlerForJail(target)
	ESX.SetPlayerData('aduty',0)
	SetEntityVisible(PlayerPedId(), true, 0)
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('esx_scoreboard:toggleme', true)
	TriggerEvent('togglescoreboard1', false)
	TriggerServerEvent('aduty:changeDutyStatus', source)
	TriggerEvent("aduty:tagChanger", false)
	AdminPerks = false
	ShowID = false
end

function ShowPlayerNames()
    Citizen.CreateThread(function()
        while AdminPerks and ShowID do

            local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 50.0)
            for i=1, #players, 1 do
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(players[i]), true))
                DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(players[i]) .. " | " .. GetPlayerName(players[i]), 255, 255, 255)
            end

            Citizen.Wait(1)
        end
    end)
end

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.80*scale)
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

function AdminPerksFunc()
    Citizen.CreateThread( function()
        while AdminPerks and Godmode do
            Citizen.Wait(1000)
			ResetPlayerStamina(PlayerId())
			SetEntityInvincible(PlayerPedId(), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(PlayerPedId(), false)
			ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(PlayerPedId(), false)
        end
		SetEntityInvincible(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), false)
		SetPedCanRagdoll(PlayerPedId(), true)
		ClearPedLastWeaponDamage(PlayerPedId())
		SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
    end)
end

RegisterNetEvent("resetpedHandler")
AddEventHandler("resetpedHandler",function(skin)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0


        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)

                Citizen.CreateThread(function()
                    Citizen.Wait(250)

                end)

            end)

        end)

    end)

end)

RegisterNetEvent("aduty:pedHandler")
AddEventHandler("aduty:pedHandler",function(PlayerID, skin)
   local player2 = GetPlayerFromServerId(PlayerID)
    print("this is just a debug")
    Citizen.CreateThread(function()
    local model = GetHashKey(skin)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end
    SetPlayerModel(player2, model)
    end)
end)

RegisterNetEvent('esx_aduty:teleportUser')
AddEventHandler('esx_aduty:teleportUser', function(x, y, z)
	TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
	SetEntityCoords(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('esx_aduty:freezePlayer')
AddEventHandler("esx_aduty:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent("armorHandler")
AddEventHandler("armorHandler",function(armor)

    local ped = PlayerPedId()
    SetPedArmour(ped, armor)

end)



RegisterNetEvent("aduty:vehiclelicenseHandler")
AddEventHandler("aduty:vehiclelicenseHandler", function(licenseplate)

    local player = PlayerPedId()
    if IsPedSittingInAnyVehicle(player) then

        local vehicle = GetVehiclePedIsIn(player, false)
        local oplate = GetVehicleNumberPlateText(vehicle)
        local vehicleModel = GetEntityModel(vehicle)
        local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
        local oldplate = string.gsub(oplate, " ", "")

        TriggerServerEvent('CarLock:ToggleKey', false, oldplate)
        Wait(250)
        SetVehicleNumberPlateText(vehicle, licenseplate)
        lib.notify({ position = 'center-right', title = '', description = 'شماره پلاک به: ' .. licenseplate .. ' تغییر کرد', type = 'success', duration = 3000 })

        TriggerServerEvent('esx:CreateItem', "CarKey|" .. string.upper(licenseplate), vehicleLabel .. " | " .. string.upper(licenseplate), 1, 0, 0)

        Wait(500)
        TriggerServerEvent('CarLock:ToggleKey', true, licenseplate)

    else
        lib.notify({ position = 'center-right', title = '', description = 'شما برای استفاده از این دستور باید داخل ماشین باشید', type = 'error', duration = 3000 })
    end

end)

RegisterNetEvent("aduty:setMuteStatus")
AddEventHandler("aduty:setMuteStatus", function(status)

  muted = status
  MutePlayer()

end)

RegisterNetEvent("aduty:forceStatus")
AddEventHandler("aduty:forceStatus", function(status)

  ForceToVisible = status
  print(ForceToVisible)
  visibility()

end)

RegisterNetEvent("aduty:refuel")
AddEventHandler("aduty:refuel", function()

   local ped = PlayerPedId()

   if IsPedInAnyVehicle(ped) then

        local vehicle = GetVehiclePedIsIn(ped)
        SetVehicleFuelLevel(vehicle, 100.0)

   else

      TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye estefade az in command bayad dakhel mashin bashid!")

   end

end)

RegisterNetEvent("aduty:vanish")
AddEventHandler("aduty:vanish", function()

   vanish = not vanish
   local ped = PlayerPedId()
	local entity = PlayerPedId()

    if vanish then
    local id = PlayerId()

    TriggerServerEvent('esx_idoverhead:changeLabelHideStatus', id, true)

	SetEntityVisible(entity, false)
    lib.notify({ position = 'center-right', title = '', description = 'کاراکتر شما با موفقیت غیب شد', type = 'info', duration = 3000 })
    else
    local id = PlayerId()

    TriggerServerEvent('esx_idoverhead:changeLabelHideStatus', id, false)

	SetEntityVisible(entity, true)
    lib.notify({ position = 'center-right', title = '', description = 'کاراکتر شما با موفقیت ظاهر شد', type = 'success', duration = 3000 })
    end

end)

CreateThread(function()
  while true do
    Wait(1)

    SetEntityLocallyInvisible(entity)
  end
end)

RegisterNetEvent("aduty:visibleForce")
AddEventHandler("aduty:visibleForce", function()



end)

RegisterNetEvent('aduty:tag')
AddEventHandler('aduty:tag',function(own)
    owned = own
end)

RegisterNetEvent('aduty:setEventCoords')
AddEventHandler('aduty:setEventCoords', function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

        if isAdmin then
            local coords = GetEntityCoords(PlayerPedId())
            if coords ~= nil then
                TriggerServerEvent('aduty:setEventCoords', coords)
            else
                print("Theere was a problem with getting coords")
            end
        end

    end)
end)

RegisterNetEvent('aduty:tpEvent')
AddEventHandler('aduty:tpEvent', function()
    ESX.TriggerServerCallback('esx_aduty:getEventCoords', function(coords)

        if coords ~= "nothing" then
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                Citizen.Wait(1)
            end

            TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
            SetEntityCoords(PlayerPedId(), coords)
        else
            print("problem with getting coords")
        end

    end)
end)

RegisterNetEvent('aduty:setEventCoords')
AddEventHandler('aduty:setEventCoords', function()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            local coords = GetEntityCoords(PlayerPedId())
            if coords ~= nil then
                TriggerServerEvent('aduty:setEventCoords', coords)
            else
                print("Theere was a problem with getting coords")
            end
        end

    end)
end)

RegisterNetEvent('aduty:tagChanger')
AddEventHandler('aduty:tagChanger',function(add)


    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(perm)

        local id = PlayerId()
        local label
        if perm >= 1 and perm < 2 then
            label = { display = "~g~[Helper]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 2 and perm < 3 then
            label = { display = "~g~[Head HELPER]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 3 and perm < 4 then
            label = { display = "~o~[Supporter]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 4 and perm < 5 then
            label = { display = "~b~[Admin]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 5 and perm < 6 then
            label = { display = "~p~[Head Admin]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 6 and perm < 7 then
            label = { display = "~y~[Supervisor]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 7 and perm < 8 then
            label = { display = "~b~[Administrator]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 8 and perm < 9 then
            label = { display = "~p~[Admin Manager]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 9 and perm < 10 then
            label = { display = "~r~[Manager]~w~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 10 and perm < 11 then
            label = { display = "~w~[Game Master]~y~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 11 and perm < 12 then
            label = { display = "~y~[~u~Developer~r~]~y~ ", height = 1.2, toggle = false, badge = false}
        elseif perm >= 20 and perm < 21 then
            label = { display = "~b~", height = 1.2, toggle = false, badge = false}
        elseif perm >= 12 then
            label = { display = "", height = 1.2, toggle = false, badge = false}
        end

        if add then
            TriggerServerEvent('esx_idoverhead:modifyLabel', id, label)
        else
            TriggerServerEvent('esx_idoverhead:removeLabel', id, add)
        end


    end)


end)

RegisterNetEvent('aduty:returnStatus')
AddEventHandler('aduty:returnStatus', function()
    TriggerServerEvent('aduty:statusHandler', owned)
end)

function TimeForRes()
    TriggerServerEvent('\101\115\120\95\97\100\117\116\121\58\65\100\100\82\101\115')
    SetTimeout(60000 * 30, TimeForRes)
end

Citizen.CreateThread(function()
    Wait(5000)
    SetTimeout(60000 * 30, TimeForRes)
end)

RegisterNetEvent('aduty:set_tags')
AddEventHandler('aduty:set_tags', function (admins)
    currentTags = admins
end)

RegisterNetEvent('aduty:flip')
AddEventHandler('aduty:flip', function (target)
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        SetVehicleOnGroundProperly(vehicle)
    else
        local vehicle = ESX.Game.GetVehicleInDirection(4)
        if vehicle ~= 0 then
            NetworkRequestControlOfEntity(vehicle)
            while not NetworkHasControlOfEntity(vehicle) do
                Citizen.Wait(100)
            end
            SetVehicleOnGroundProperly(vehicle)
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
        end
    end
end)

RegisterNetEvent('esx_aduty:ExecuteCommand')
AddEventHandler('esx_aduty:ExecuteCommand', function(args)
    ExecuteCommand(args)
end)

RegisterCommand('glist',function(source)
    ESX.TriggerServerCallback('GetGangMembers', function(a, info, cc, ngang)
        if a then
            TriggerEvent('chat:addMessage', {
                color = { 255, 255, 255},
                multiline = true,
                args = {'[ '..ngang..' ]'..' '..':'..' '..'('..cc..')'}
            })

            for i=1, #info, 1 do
                label = info[i].name..' '.. "("..info[i].source..")"
                TriggerEvent('chat:addMessage', {
                    color = { 0, 255, 0},
                    multiline = true,
                    args = {label}
                })
            end

        else
            lib.notify({ position = 'center-right', title = '', description = 'شما در گنگی حضور ندارید.', type = 'error', duration = 3000 })
        end
    end)
end)

RegisterCommand("armorrange", function(x, y)
    ESX.TriggerServerCallback("esx_aduty:getAdminPerm",function(z)
        if z >= 5 then
            if not tonumber(y[1]) and not tonumber(y[2]) then
                return
            end
            local A = ESX.Game.GetPlayers()
            local B = GetEntityCoords(PlayerPedId())
            for C = 1, #A, 1 do
                local D = GetPlayerPed(A[C])
                local E = GetEntityCoords(D)
                local F = GetDistanceBetweenCoords(E, B.x, B.y, B.z, true)
                if F <= tonumber(y[1]) + 10 then
                    Citizen.Wait(100)
                    ExecuteCommand("setarmor " .. GetPlayerServerId(A[C]) .. " " .. tonumber(y[2]))
                end
            end
        else
            TriggerEvent("esx:showNotification","~h~~b~Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid!")
        end
        end
    )end,false
)

RegisterCommand('goto', function(source, args)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local id = args[1]
			local Target = GetPlayerFromServerId(tonumber(id))
            if not args[1] then
				return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Lotfan Id Player Ra Vared Konid!"}})
			end

			if not tonumber(id) or GetPlayerName(Target) == "**Invalid**" then
				return TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Id Vared Shode Dar Server Vojood Nadarad!"}})
			end

			local player = GetPlayerFromServerId(Target)
			if not IsPedInAnyVehicle(GetPlayerPed(Target), false) then
                ExecuteCommand('-////goto223322 '..id)






            else

				local admin = GetPlayerFromServerId(source)
				local veh = GetVehiclePedIsIn(GetPlayerPed(Target), false)

				if IsVehicleSeatFree(veh, 0) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 0)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 1) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 1)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 2) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 2)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 3) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 3)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 4) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 4)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 5) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 5)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				elseif IsVehicleSeatFree(veh, 6) then
					SetPedIntoVehicle(GetPlayerPed(admin), veh, 6)
					TriggerEvent("Unique_Scripts_HuD:chageStatus", true)
				else
                    ExecuteCommand('-////goto223322 '..id)
					TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "Mashin Sandali Khali Baraye Shoma Nadarad!"}})
				end
            end

		end
	end)
end)

RegisterCommand('mcar', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 3 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if not args[1] then

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat model mashin chizi vared nakardid!"}
                        })

                        return
                    end

                    if not args[2] then

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "Shoma dar ghesmat turbo chizi vared nakardid!"}
                        })

                        return
                    end

                    local turbo = args[2]
                    local model = args[1]
                    local colors = {a = 0, b = 0, c = 0}

                    if args[3] then

                        colors.a = tonumber(args[3])

                    end

                    if args[4] then

                        colors.b = tonumber(args[4])

                    end

                    if args[5] then

                        colors.c = tonumber(args[5])

                    end

                    if turbo == "true" then

                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)

                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(PlayerPedId()), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, true, colors)
                            SetVehicleFuelLevel(vehicle, 100.0)

                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 ba ^3turbo ^0spawn shod!"}
                                })

                        end)

                    elseif turbo == "false" then

                        local playerPed = PlayerPedId()
                        local coords    = GetEntityCoords(playerPed)

                        ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(PlayerPedId()), function(vehicle)
                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                            SetVehicleMaxMods(vehicle, false, colors)
                                local carModel = GetEntityModel(vehicle)
                                local carName = GetDisplayNameFromVehicleModel(vehicle)

                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^2 " .. model .. "^0 spawn shod!"}
                                })

                        end)

                    else

                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "^2 Shoma dar ghesmat turbo statement eshtebahi vared kardid!"}
                        })

                    end

                else

                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})

                end

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

        end)
end, false)

RegisterCommand('livery', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 3 then

            if not args[1] then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat livery chizi vared nakardid"}})
                return
            end

            if not tonumber(args[1]) then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat livery faghat mitavanid adad vared konid"}})
                return
            end
            local livery = tonumber(args[1])

            local ped = PlayerPedId()
            if IsPedSittingInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                SetVehicleLivery(vehicle, livery)
            else
                local vehicle = ESX.Game.GetVehicleInDirection(4)
                if vehicle ~= 0 then
                    NetworkRequestControlOfEntity(vehicle)
                    while not NetworkHasControlOfEntity(vehicle) do
                        Citizen.Wait(100)
                    end
                    SetVehicleLivery(vehicle, livery)
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
                end
            end

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi nadarid!"}})

        end

        end)
end, false)

RegisterCommand('alock', function(source)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 3 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if IsPedSittingInAnyVehicle(PlayerPedId()) then

                        local vehicle = GetVehiclePedIsIn(PlayerPedId())
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)
                        local lock = GetVehicleDoorLockStatus(vehicle)

                        if lock == 1 or lock == 0 then
                            SetVehicleDoorShut(vehicle, 0, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            SetVehicleDoorsLocked(vehicle, 2)
                            PlayVehicleDoorCloseSound(vehicle, 1)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                            lib.notify({ position = 'center-right', title = '', description = 'شما ' .. vehicleLabel .. ' را قفل کردید.', type = 'info', duration = 3000 })
                        elseif lock == 2 then
                            SetVehicleDoorsLocked(vehicle, 1)
                            PlayVehicleDoorOpenSound(vehicle, 0)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                            lib.notify({ position = 'center-right', title = '', description = 'شما ' .. vehicleLabel .. ' را باز کردید.', type = 'success', duration = 3000 })
                        end

                    else

                        local vehicle = ESX.Game.GetVehicleInDirection(4)
                        local lock = GetVehicleDoorLockStatus(vehicle)

                        if vehicle ~= 0 then

                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                            vehicleLabel = GetLabelText(vehicleLabel)

                            if lock == 1 or lock == 0 then
                                SetVehicleDoorShut(vehicle, 0, false)
                                SetVehicleDoorShut(vehicle, 1, false)
                                SetVehicleDoorShut(vehicle, 2, false)
                                SetVehicleDoorShut(vehicle, 3, false)
                                SetVehicleDoorsLocked(vehicle, 2)
                                PlayVehicleDoorCloseSound(vehicle, 1)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                            lib.notify({ position = 'center-right', title = '', description = 'شما ' .. vehicleLabel .. ' را قفل کردید.', type = 'info', duration = 3000 })
                            elseif lock == 2 then
                                SetVehicleDoorsLocked(vehicle, 1)
                                PlayVehicleDoorOpenSound(vehicle, 0)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                                TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                                lib.notify({ position = 'center-right', title = '', description = 'شما ' .. vehicleLabel .. ' را باز کردید.', type = 'success', duration = 3000 })
                            end

                        else

                            lib.notify({ position = 'center-right', title = '', description = 'هیچ ماشینی نزدیک شما نیست!', type = 'error', duration = 3000 })

                        end

                    end

                else

                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})

                end

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterCommand('getin', function(source)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 3 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    local vehicle = ESX.Game.GetVehicleInDirection(4)
                    if vehicle ~= 0 then

                      if DoesEntityExist(vehicle) then
                          if IsVehicleSeatFree(vehicle, -1) then
                              SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                          else
                            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Mashin ranande darad!"}})
                          end
                      end

                    else

                        lib.notify({ position = 'center-right', title = '', description = 'هیچ ماشینی نزدیک شما نیست!', type = 'error', duration = 3000 })

                    end

                else

                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}})

                end

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}})

        end

    end)
end, false)

RegisterCommand('creategang', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if args[1] and tonumber(args[2]) then
                    TriggerServerEvent('gangs:registerGang', args[1], args[2])
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Parameter haye vared shode sahih nist!"}})
                end

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterCommand('savegangs', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                TriggerServerEvent('gangs:saveGangs')

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterCommand('changegangdata', function(source, args)
	local source = _source
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                ESX.TriggerServerCallback('esx_aduty:doesGangExist', function(GangExist)

                    local playerPos = GetEntityCoords(PlayerPedId())
                    if GangExist then

                        if args[2] == 'blip' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z + 0.5 }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'armory' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'locker' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'boss' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'veh' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'vehdel' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'vehspawn' then
                            local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(PlayerPedId()) }
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'heli' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'helidel' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'helispawn' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(PlayerPedId()) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'boat' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'boatdel' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
						elseif args[2] == 'boatspawn' then
							local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(PlayerPedId()) }
							TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
                        elseif args[2] == 'search' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
						elseif args[2] == 'lockpick' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
						elseif args[2] == 'gps' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
						elseif args[2] == 'log' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
						elseif args[2] == 'vip' then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
						elseif args[2] == 'slot' then
							if tonumber(args[3]) then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
							else
                                lib.notify({ position = 'center-right', title = '', description = 'شما در قسمت تعداد اسلات فقط می‌توانید عدد وارد کنید!', type = 'error', duration = 3000 })
                            end
						elseif args[2] == 'bulletproof' then
							if tonumber(args[3]) then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
							else
                                lib.notify({ position = 'center-right', title = '', description = 'شما می‌توانید عدد بین (0-100) را وارد کنید!', type = 'info', duration = 3000 })
                            end

						elseif args[2] == 'helimodel' then
							if args[3] then
								TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
							else
								lib.notify({ position = 'center-right', title = '', description = 'نوع هلیکوپتر را وارد کنید!', type = 'error', duration = 3000 })
							end
						elseif args[2] == 'price' then
							if tonumber(args[3]) then
                            TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
							else
                                lib.notify({ position = 'center-right', title = '', description = 'شما فقط می‌توانید عدد وارد کنید!', type = 'error', duration = 3000 })
                            end
                        elseif args[2] == 'expire' then
                            if tonumber(args[3]) then
                                TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
                            else
                                lib.notify({ position = 'center-right', title = '', description = 'شما در قسمت روز فقط می‌توانید عدد وارد کنید!', type = 'error', duration = 3000 })
                            end
						else
							lib.notify({ position = 'center-right', title = '', description = 'گزینه وارد شده اشتباه است!', type = 'error', duration = 3000 })
						end
                    else
                        lib.notify({ position = 'center-right', title = '', description = 'گنگ وارد شده اشتباه است!', type = 'error', duration = 3000 })
                    end

                end, args[1], 6)

            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}})

        end

    end)
end, false)

RegisterNetEvent("dvrange:client")
AddEventHandler("dvrange:client", function(range)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehiclesDeleted = 0

    for vehicle in EnumerateVehicles() do
        local vehicleCoords = GetEntityCoords(vehicle)

        if #(playerCoords - vehicleCoords) <= range then
            NetworkRequestControlOfEntity(vehicle)
            ESX.Game.DeleteVehicle(vehicle)
            vehiclesDeleted = vehiclesDeleted + 1
        end
    end

    if vehiclesDeleted > 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {0, 255, 0}, " ^0Tedad ^2" .. vehiclesDeleted .. " ^0mashin hazf shod!")
    else
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, " ^0Hich mashini dar range mored nazar nist!")
    end
end)

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

RegisterNetEvent("esx_aduty:dobject")
AddEventHandler("esx_aduty:dobject",function(model)

    Citizen.CreateThread(function()

        local ped = PlayerPedId()
        local model = model

        local handle, object = FindFirstObject()
        local finished = false
        repeat
        Citizen.Wait(1)

        if GetEntityModel(object) == model then
            DeleteObjects(object)
        end

        finished, object = FindNextObject(handle)

        until not finished
        EndFindObject(handle)

    end)

end)

function DeleteObjects(object)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end

        if IsEntityAttached(object) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)

    end
end

Citizen.CreateThread(function()

	while true do
        Wait(100)

            if (IsControlPressed(1, 21) and IsControlPressed(1, 38)) then

                if time == 0 then

                    time = 3

                    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)

                        if isAdmin then

                            if ESX.GetPlayerData()["aduty"] == 1 then

                                local playerPed = PlayerPedId()
                                local WaypointHandle = GetFirstBlipInfoId(8)

                                if DoesBlipExist(WaypointHandle) then
                                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(1)
                end
                Citizen.CreateThread(function()
	            Citizen.Wait(1000)

	            end)
                lib.notify({ position = 'center-right', title = '', description = 'شما تلپورت شدید.', type = 'success', duration = 3000 })

                                else
                                    lib.notify({ position = 'center-right', title = '', description = 'مаркری برای تلپورت شدن وجود ندارد!', type = 'error', duration = 3000 })
                                end

                            else

                                TriggerEvent('chat:addMessage', {
                                    color = { 255, 0, 0},
                                    multiline = true,
                                    args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0be marker roye map teleport konid!"}
                                })

                            end

                            end

                        end)

             end

        end

        while time > 0 do

            Citizen.Wait(1000)

            time = time -1

        end


    end

end)

RegisterNetEvent("aduty:addSuggestions")
AddEventHandler("aduty:addSuggestions",function()

        TriggerEvent('chat:addSuggestion', '/aduty', 'Jahat on/off duty shodan admini', {
        })

        TriggerEvent('chat:addSuggestion', '/changeped', 'Jahat avaz kardan ped', {
            { name="EsmPed", help="Esm ped mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/resetped', 'Jahat reset kardan ped be halat admini', {
        })

        TriggerEvent('chat:addSuggestion', '/w', 'Jahat ferestadan whisper admini', {
			{ name="ID", help="ID player mored nazar" },
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/livery', 'Jahat avaz kardan livery mashin', {
            { name="ID", help="ID livery mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/alock', 'Jahat baz ya baste kardan dare mashini ke darid be an negah mikonid', {
        })

        TriggerEvent('chat:addSuggestion', '/getin', 'Jahat raftan be dakhel mashin', {
        })

        TriggerEvent('chat:addSuggestion', '/setarmor', 'Jahat avaz kardan armor player', {
            { name="ID", help="ID player mored nazar" },
            { name="Armor", help="Meghdar armor beyn 0-100" }
        })

        TriggerEvent('chat:addSuggestion', '/fineoffline', 'Jarime kardan player be sorat offline', {
            { name="Esm", help="Esm daghigh player ba horof bozorg va kochik" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })

        TriggerEvent('chat:addSuggestion', '/goto', 'Teleport to a user', {
            { name="ID", help="Id Player" },
        })

        TriggerEvent('chat:addSuggestion', '/megaphone', 'Faal/GherFaal Kardan Megaphone Ba ID', {
            { name="ID", help="Id Fard Mored Nazar" },
        })

        TriggerEvent('chat:addSuggestion', '/addxpgang', 'Add Xp By Gang Name', {
            { name = "Gang Name", help = "Esm Gang Hasas Be Bozorg o Kochik Bodna Horof" },
	        { name = "Xp", help = "Tedad Xp Be Adad"},
        })

        TriggerEvent('chat:addSuggestion', '/changegangdata', 'Taqir dadan option haye gang', {
            { name="GangName", help="Esme Gang" },
	        { name="Option", help="Entekhabe option:(blip, armory, locker, boss, veh, vehdel, vehspawn, boat, boatdel, boatdel, expire, search, bulletproof, gps, log, slot, lockpick, heli, helidel, helispawn, helimodel, vip, price)" },
        })

        TriggerEvent('chat:addSuggestion', '/savegangs', 'Zakhire kardan gang haye movaghat dar ram', {
        })

        TriggerEvent('chat:addSuggestion', '/fine', 'Jarime kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar jarime" },
            { name="Dalil", help="Dalil jarime" }
        })

        TriggerEvent('chat:addSuggestion', '/ajailoffline', 'Admin jail kardan player be sorat offline', {
            { name="Esm", help="Esm daghigh player ba horof bozorg va kochik" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/ajail', 'Admin jail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/aunjail', 'Admin unjail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/money', 'Taghir dadan pol player', {
            { name="ID", help="ID player mored nazar" },
            { name="NoePool", help="Noe pool ebarat ast az cash/bank/black" },
            { name="Meghdar", help="Meghdar pool mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/plate', 'Avaz kardan shomare pelak mashin', {
            { name="Pelak", help="Pelak mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/ac', 'Ferestadan adminchat', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/kick', 'Kick kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil kick shodan" }
        })

        TriggerEvent('chat:addSuggestion', '/mute', 'Jahat mute kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil mute shodan player" }
        })

        TriggerEvent('chat:addSuggestion', '/unmute', 'Jahat unmute kardan player', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/toggleid', 'Jahat toggle kardan halat didan ID playerha', {
        })

        TriggerEvent('chat:addSuggestion', '/resetaccount', 'Jahat reset kardan account player', {
            { name="ESM", help="Esm player mored nazar" },
            { name="Dalil", help="Dalil reset kardan account" }
        })

        TriggerEvent('chat:addSuggestion', '/disband', 'Jahat disband kardan family', {
            { name="ESM", help="Esm family mored nazar" },
            { name="Dalil", help="Dalil disband kardan gang" }
        })

        TriggerEvent('chat:addSuggestion', '/ban', 'Ban kardan player ba ID', {
            { name="ID", help="ID player mored nazar" },
            { name="ZAMAN", help="Zaman ra be roz vared konid (0 = permanent ban)" },
            { name="DALIL", help="Dalil ban shodan player ra vared konid" },
        })

		TriggerEvent('chat:addSuggestion', '/mcar', 'Spawn Car For Turbo', {
            { name="Car", help="Esm Mashin" },
            { name="Turbo", help="true or false" },
        })

        TriggerEvent('chat:addSuggestion', '/banoffline', 'Ban kardan player ba SteamHex', {
            { name="name", help="SteamHex Fard" },
            { name="ZAMAN", help="Zaman ra be roz vared konid (0 = permanent ban)" },
            { name="DALIL", help="Dalil ban shodan player ra vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/unban', 'Unban kardan player ba esm IC', {
            { name="name", help="Esm IC player mored nazar" },
        })

        TriggerEvent('chat:addSuggestion', '/charmenu', 'Reload player skin', {
            { name="Player", help="Player ID" },
        })

        TriggerEvent('chat:addSuggestion', '/vanish', 'baraye avaz kardan vaziat dide shodan', {
        })



        TriggerEvent('chat:addSuggestion', '/owntoggle', 'toggle kardan tag admini baraye khod', {
        })

        TriggerEvent('chat:addSuggestion', '/creategang', 'Sakhtan Gang, Hasas be Horofe bozorg va Kochak', {
            { name="GangName", help="Esme Gang" },
            { name="Expire", help="Tedad Roz etebare Gang ra Vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/savegangs', 'Zakhire Kardane Gang\'e Sakhte Shode', {})

        TriggerEvent('chat:addSuggestion', '/spec', 'Jahat spect kardan player mored nazar', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/givecoin', 'ezafe kardan coin', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar coin" },
        })

        TriggerEvent('chat:addSuggestion', '/removecoin', 'kam kardan coin', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar coin" },
        })

        TriggerEvent('chat:addSuggestion', '/addxpuser', 'Ezafe Kardan XP', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar XP" },
        })

        TriggerEvent('chat:addSuggestion', '/removexpuser', 'Kam Kardan XP', {
            { name="ID", help="ID player mored nazar" },
            { name="Meghdar", help="Meghdar XP" },
        })

		TriggerEvent('chat:addSuggestion', '/csp', 'Kharej Shodan Az Spect', {
        })

        TriggerEvent('chat:addSuggestion', '/togglenotify', 'Jahat toggle kardan notification haye anticheat', {
        })

        TriggerEvent('chat:addSuggestion', '/toggletag', 'Off Va On Kardan Badge Admini', {
        })
end)

RegisterNetEvent("aduty:removeSuggestions")
AddEventHandler("aduty:removeSuggestions",function()

        TriggerEvent('chat:removeSuggestion', '/aduty')

        TriggerEvent('chat:removeSuggestion', '/livery')

        TriggerEvent('chat:removeSuggestion', '/changeped')

        TriggerEvent('chat:removeSuggestion', '/resetped')

        TriggerEvent('chat:removeSuggestion', '/w')

        TriggerEvent('chat:removeSuggestion', '/setarmor')

        TriggerEvent('chat:removeSuggestion', '/fineoffline')

        TriggerEvent('chat:removeSuggestion', '/fine')

        TriggerEvent('chat:removeSuggestion', '/ajailoffline')

        TriggerEvent('chat:removeSuggestion', '/ajail')

        TriggerEvent('chat:removeSuggestion', '/aunjail')

        TriggerEvent('chat:removeSuggestion', '/money')

        TriggerEvent('chat:removeSuggestion', '/plate')

        TriggerEvent('chat:removeSuggestion', '/a')

        TriggerEvent('chat:removeSuggestion', '/kick')

        TriggerEvent('chat:removeSuggestion', '/mute')

        TriggerEvent('chat:removeSuggestion', '/unmute')

        TriggerEvent('chat:removeSuggestion', '/toggleid')

        TriggerEvent('chat:removeSuggestion', '/resetaccount')

        TriggerEvent('chat:removeSuggestion', '/disband')

        TriggerEvent('chat:removeSuggestion', '/vanish')

        TriggerEvent('chat:removeSuggestion', '/dv2')

        TriggerEvent('chat:removeSuggestion', '/charmenu')

        TriggerEvent('chat:removeSuggestion', '/savegangs')

        TriggerEvent('chat:removeSuggestion', '/alock')

        TriggerEvent('chat:removeSuggestion', '/getin')

        TriggerEvent('chat:removeSuggestion', '/owntoggle')

        TriggerEvent('chat:removeSuggestion', '/changegangdata')

        TriggerEvent('chat:removeSuggestion', '/savegangs')

        TriggerEvent('chat:removeSuggestion', '/creategang')

        TriggerEvent('chat:removeSuggestion', '/spectate')

        TriggerEvent('chat:removeSuggestion', '/togglenotify')

        TriggerEvent('chat:removeSuggestion', '/ban')

        TriggerEvent('chat:removeSuggestion', '/banoffline')

        TriggerEvent('chat:removeSuggestion', '/csp')

        TriggerEvent('chat:removeSuggestion', '/sp')

        TriggerEvent('chat:removeSuggestion', '/mcar')

        TriggerEvent('chat:removeSuggestion', '/unban')
        TriggerEvent('chat:removeSuggestion', '/toggletag')

end)

function MutePlayer()

    Citizen.CreateThread(function()

		while muted do

			DisableControlAction(0, Keys['N'], true)

            Citizen.Wait(1)

		end

	end)

end

function SetVehicleMaxMods(vehicle, turbo, colors)

        local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   4,
            modTurbo        =   turbo,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c
        }

    ESX.Game.SetVehicleProperties(vehicle, props)

end

local time = 0
RegisterCommand('w', function(source, args)

    if not args[1] then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID chizi vared nakardid!")
        return
    end

    if not tonumber(args[1]) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mojaz be vared kardan adad hastid!")
        return
    end

    if not args[2] then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye whisper kardan hadeaghal bayad yek kalame bayad type konid!")
        return
    end

    local target = tonumber(args[1])
    local message = table.concat(args, " ", 2)

    if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid be khodetan whisper dahid!")
        return
    end

    if GetPlayerName(GetPlayerFromServerId(target)) == "**Invalid**" then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

    if GetDistanceBetweenCoords(coords, tcoords, true) > 2 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Fasele shoma az player mored nazar ziad ast")
        return
    end

    TriggerEvent("chatMessage", "[Whisper]", {255, 197, 0}, message)
    TriggerServerEvent('aduty:sendMessage', target, message)

    if GetGameTimer() - time > 5000 then
        time = GetGameTimer()

		TriggerServerEvent('3dme:shareDisplay', "Shoro mikone be dare goshi sohbat kardan", false)

    end

end, false)

RegisterCommand('sl', function(source, args)

    if not args[1] then
        TriggerServerEvent('aduty:showlicense', GetPlayerServerId(PlayerId()))
        return
    end

    if not tonumber(args[1]) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID faghat mojaz be vared kardan adad hastid!")
        return
    end

    local target = tonumber(args[1])

    if GetPlayerName(PlayerId()) == GetPlayerName(GetPlayerFromServerId(target)) then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid be khodetan license neshan dahid!")
        return
    end

    if GetPlayerName(GetPlayerFromServerId(target)) == "**Invalid**" then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast")
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))

    if GetDistanceBetweenCoords(coords, tcoords, true) > 2 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Fasele shoma az player mored nazar ziad ast")
        return
    end

    TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "Shoma ba movafaghiat license khod ra be ^2" .. target .. "^0 neshan dadid!")
    TriggerServerEvent('aduty:showlicense', target)

end, false)

RegisterCommand('neon', function(source, args)
    local player = PlayerPedId()
    if (IsPedSittingInAnyVehicle(player)) then
        local car = GetVehiclePedIsIn(player, false)
        if car then
            if GetPedInVehicleSeat(car, -1) == player then
                local veh = GetVehiclePedIsUsing(player)

                if args[1] == "on" then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                    SetVehicleNeonLightEnabled(veh, 1, true)
                    SetVehicleNeonLightEnabled(veh, 2, true)
                    SetVehicleNeonLightEnabled(veh, 3, true)
                    lib.notify({ position = 'center-right', title = '', description = 'نئون‌های ماشین روشن شدند!', type = 'success', duration = 3000 })
                elseif args[1] == "off" then
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                    lib.notify({ position = 'center-right', title = '', description = 'نئون‌های ماشین خاموش شدند!', type = 'success', duration = 3000 })
                else
                    lib.notify({ position = 'center-right', title = '', description = 'در قسمت استیتمنت نئون چیزی وارد نکردید!', type = 'error', duration = 3000 })
                end

            else
                lib.notify({ position = 'center-right', title = '', description = 'فقط راننده می‌تواند از این دستور استفاده کند!', type = 'error', duration = 3000 })
            end

        end
     else
        lib.notify({ position = 'center-right', title = '', description = 'شما برای استفاده از این دستور باید داخل ماشین باشید!', type = 'error', duration = 3000 })
     end
end, false)

function HDraw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    rgb = RGBRainbow(2)
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(rgb.r, rgb.g, rgb.b, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function HDraw3DText_2(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    rgb = RGBRainbow(2)
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(rgb.r, rgb.g, rgb.b, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function RGBRainbow(frequency)
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return result
end

local commands = false

RegisterCommand('esp',function(source,args)
    if commands then
        commands = false
    else
        commands = true
    end

    if ESX.GetPlayerData().perm >= 1 then
        show2 = true
        if commands then
            while show2 and AdminPerks and commands do
                Wait(1)
                DoESP()
                ShowID = false
            end
        else
            Wait(20)
            ShowID = true
            show2 = false
            ShowPlayerNames()
        end
    end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local invehicle = IsPedInAnyVehicle(ped, false)

    if invehicle then
        for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
            if GetPedInVehicleSeat(vehicle, i) == ped then return i end
        end
    end

    return -2
end

function DoESP()
    local spot = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)

    for id, src in pairs (GetActivePlayers()) do
        src = tonumber(src)
        local ped = GetPlayerPed(src)

        if DoesEntityExist(ped) and ped ~= PlayerPedId() then
            local _id = GetPlayerServerId(src)
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
            local dist = GetDistanceBetweenCoords(spot.x, spot.y, spot.z, coords.x, coords.y, coords.z)
            local seat = tonumber(GetPedVehicleSeat(ped))
            local distmath = tonumber(dist) or 0
            local DistaN = math.floor(distmath)
            if seat ~= -2 then
                seat = seat + 0.25
            end

            if dist <= 300.0 then
                local pos_z = coords.z + 1.2

                if seat ~= -2 then
                    pos_z = pos_z + seat
                end

                local _on_screen, _, _ = GetScreenCoordFromWorldCoord(coords.x, coords.y, pos_z)

                if _on_screen then

                    if NetworkIsPlayerTalking(src) then
                        Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. CleanName(GetPlayerName(src), true).." ["..DistaN.."]", 255, 205, 0)
                    else
                        Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. CleanName(GetPlayerName(src), true).." ["..DistaN.."]", 255, 255, 255)
                    end
                end
            end
        end
    end
end

function Draw3DText(x, y, z, text, r, g, b)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.25)
    SetTextColour(r, g, b, 255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(1)
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function CleanName(str, is_esp)
    str = str:gsub("~", "")
    str = RemoveEmojis(str)

    if #str >= 25 and not is_esp then
        str = str:sub(1, 25) .. "..."
    end

    return str
end

function RemoveEmojis(str)
    local new = ""

    for _, codepoint in utf8.codes(str) do
        local safe = true

        if block_singles[codepoint] then
            safe = false
        else
            for _, range in ipairs(blocked_ranges) do
                if range[1] <= codepoint and codepoint <= range[2] then
                    safe = false
                    break
                end
            end
        end

        if safe then
            new = new .. utf8.char(codepoint)
        end
    end

    return new
end

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
				Wait(1)
			end
		end

		while IsNoclipActive do
			local playerPed = PlayerPedId()
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
                PushScaleformMovieMethodParameterString("~INPUT_PICKUP~")
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
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
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
                if (IsDisabledControlPressed(0, 38)) then
                    zoff = -0.21
                end
				if (IsDisabledControlJustPressed(0, 74)) then
					FollowCamMode = not FollowCamMode
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
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
                TriggerServerEvent('esx_aduty:AntiCheatExempt', 5000, { teleport = true, speed = true, noclip = true })
                SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

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
            Wait(1)
		end
	end
	CreateThread(NoClipFunc)
end

RegisterNetEvent("esx_aduty:NoclipsTogle")
AddEventHandler("esx_aduty:NoclipsTogle", function()
	IsNoclipActive = not IsNoclipActive
	if IsNoclipActive then
		NoClipThread()
	end
end)