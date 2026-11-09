-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local status = {}
local IsBusy = false
local IsBusy2 = false
local StopYechizi = false
local dead = 0
local disablecarryanim  = false
carry = {
	Requested = false,
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}
local cancel = false
local puted = 0
local mutespam = false
local showrequest = false
local carryStress = 0
local function disablex()
    Citizen.CreateThread(function()
        TriggerEvent('handappstate',false)
        while IsBusy do
            Wait(100)
        end
        TriggerEvent('handappstate',true)
    end)
end

local function setbusy()
    IsBusy = true
    disablex()
    SetTimeout(5000,function()
        IsBusy = false
    end)
end

local function disablex2()
    Citizen.CreateThread(function()
        TriggerEvent('handappstate',false)
        while IsBusy2 do
            Wait(100)
        end
        TriggerEvent('handappstate',true)
    end)
end

local function setbusy2()
    IsBusy2 = true
    disablex2()
    SetTimeout(3000,function()
        IsBusy2 = false
    end)
end

local function dpemote(state)
    TriggerEvent("dpemote:enable",state)
end

local function disabledrag()
	TriggerServerEvent('citizen:disabledrag', status.dragedid)
end

local function undragself()
	if status.draged then
        dpemote(true)
		disabledrag()
		TriggerServerEvent("citizen:dragdata",false)
		status.draged = nil
		Wait(500)
		ClearPedSecondaryTask(PlayerPedId())
	end
end

local function cuffthread()
	Citizen.CreateThread(function()
		local playerPed
		local targetPed
		local attached = false
		while status.cuffed do
			Citizen.Wait(500)
			playerPed = PlayerPedId()

			if status.draged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(status.dragedid))
				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					attached = true
					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					attached = false
					undragself()
					DetachEntity(playerPed, true, false)
					TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end

			elseif attached then
				attached = false
				DetachEntity(playerPed, true, false)
				TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end
		end
		TriggerServerEvent('police:unmuteme')
	end)
end


local function targetdeadcheck()
	Citizen.CreateThread(function()
	  while status.draged do
		  Citizen.Wait(0)
			targetplayer = GetPlayerFromServerId(status.dragedid)
			if IsPlayerDead(targetplayer) then
				disabledrag()
				undragself()
			end
	  end
	end)
end

local function handcuffthread()
	Citizen.CreateThread(function()
	  while status.cuffed do
		  Citizen.Wait(0)

			DisableControlAction(2, Keys['~'], true) -- HandsUP
			DisableControlAction(2, Keys['X'], true) -- HandsUP
			DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['M'], true) -- Select Weapon
			DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['E'], true)
			DisableControlAction(2, Keys['L'], true)
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			DisableControlAction(0, Keys['Q'], true)
			DisableControlAction(0, Keys['PAGEDOWN'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys['U'], true)
			DisableControlAction(0, Keys['Y'], true)
			DisableControlAction(0, Keys['Z'], true)
			DisableControlAction(0, Keys['B'], true)
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
				SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), true)
			end
			if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 1) then
			  	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end
	  end
    end)
end

local function uncuffself()
	if status.cuffed then
		dpemote(true)
		undragself()
		status.cuffed = nil
		ClearPedTasks(GetPlayerPed(-1))
		ESX.SetPlayerData('HandCuffed', 0)
		ESX.SetPlayerState('Cuffed',false)
		TriggerServerEvent("citizen:changecuffdata",false)
	end
end

local function dragthread()
	Citizen.CreateThread(function()
		while carry.InProgress do
			if carry.type == "beingcarried" and not disablecarryanim then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
				--if DoesEntityExist(carry.targetPed) then
					--if not IsEntityAttachedToEntity(PlayerPedId(), carry.targetPed) then
						--AttachEntityToEntity(PlayerPedId(), carry.targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 0, false, false, false, false, 2, false)
					--end
				--end

			elseif carry.type == "carrying" and not disablecarryanim then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
				if IsPedSittingInAnyVehicle(PlayerPedId()) or not DoesEntityExist(carry.targetPed) then
					carry.InProgress = false
					ClearPedSecondaryTask(PlayerPedId())
					DetachEntity(PlayerPedId(), true, false)
					TriggerServerEvent("citizen:stopcarry",carry.targetSrc)
					carry.targetSrc = 0
					status.dragingid = nil
				end
			end
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 170, true) -- Melee Attack 1	
			DisableControlAction(0, Keys["LEFTSHIFT"], true) -- Melee Attack 1	
			DisableControlAction(0, Keys["SPACE"], true) -- Jump
			SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
			if not carryStress or carryStress < GetGameTimer() then
				carryStress = GetGameTimer() + 1000
				exports['sunset_utils']:removeStress('carry_other')
			end
			Wait(0)
		end
		exports['essentialmode']:disablecontrol('f1',false)
		exports['essentialmode']:disablecontrol('f2',false)
		exports['essentialmode']:disablecontrol('m',false)
	end)
end

Citizen.CreateThread(function()
	repeat Wait(50) until ESX ~= nil

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	-- TriggerEvent('chat:addSuggestion', '/silentplayer', 'Jahat baz va baste kardan dahan farde dastband khorde', {
    -- })
	ESX.RegisterClientCallback('carry:doesInProgress', function(cb)
		cb(carry.InProgress)
	end)
end)

RegisterNetEvent('uncuff')
AddEventHandler('uncuff',function()
	exports['sun-jobs']:uncuffplayer(1, true)
end)

RegisterNetEvent('citizen:putoutvehicle')
AddEventHandler('citizen:putoutvehicle', function()
	local playerPed = PlayerPedId()
	if not (IsPedSittingInAnyVehicle(playerPed)) then
		return
	end
	if not status.put then return end
	--if not status.cuffed then
	--	return 
	--end
	status.put = false
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	Wait(1000)
	if status.cuffed then
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end

	if StopYechizi then
		TriggerEvent('animthread',true)
	end
end)

RegisterNetEvent('citizen:putoutvehicle2')
AddEventHandler('citizen:putoutvehicle2', function()
	local playerPed = PlayerPedId()
	if not (IsPedSittingInAnyVehicle(playerPed)) then
		return
	end
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 1 )
end)

RegisterNetEvent('citizen:draging')
AddEventHandler('citizen:draging', function(state)
	status.draging = state
	if status.draging then
		loadAnimDict('switch@trevor@escorted_out')
		TaskPlayAnim(GetPlayerPed(-1), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, false, false, false)
		Citizen.CreateThread(function()
			dpemote(false)
			SetTimeout(1000, function()
				ResetPedMovementClipset(PlayerPedId(), 0)
			end)
			while status.draging do
				DisablePlayerFiring(PlayerId(), true)
				Wait(0)
				DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
				DisableControlAction(2, Keys['SPACE'], true) -- Jump
				DisableControlAction(2, Keys['X'], true) -- HandsUP
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				if not IsEntityPlayingAnim(PlayerPedId(), "switch@trevor@escorted_out", "001215_02_trvs_12_escorted_out_idle_guard2", 1) then
					TaskPlayAnim(GetPlayerPed(-1), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, false, false, false)
				end
				if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
					ClearPedSecondaryTask(PlayerPedId())
					status.draging = false
					status.dragingid = nil
				end
				if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(status.dragingid))) then
					ClearPedSecondaryTask(PlayerPedId())
					status.draging = false
					status.dragingid = nil
				end

				if GetPlayerName(GetPlayerFromServerId(status.dragingid)) == "**Invalid**" or GetPlayerName(GetPlayerFromServerId(status.dragingid)) == nil then
					ClearPedSecondaryTask(PlayerPedId())
					status.draging = false
					status.dragingid = nil
				end
			end
			dpemote(true)
			DisablePlayerFiring(PlayerId(), false)
		end)
	else
		status.dragingid = nil
		StopAnimTask(GetPlayerPed(-1), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		Wait(500)
		ClearPedSecondaryTask(GetPlayerPed(-1))
	end
end)

RegisterNetEvent('citizen:drag')
AddEventHandler('citizen:drag', function(src)
	if not status.cuffed then
		return
	end
	if status.draged and status.dragedid ~= src then
		disabledrag()
	end
	status.draged = not status.draged
	if status.draged then
		status.dragedid = src
		targetdeadcheck()
	end
end)

RegisterNetEvent('citizen:disabledrag')
AddEventHandler('citizen:disabledrag', function()
	if status.draging then
		status.draging = false
		status.dragingid = nil
		Wait(500)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

RegisterNetEvent('citizen:doarrested')
AddEventHandler('citizen:doarrested', function()
	setbusy2()
	local ped = PlayerPedId()
	SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadAnimDict('mp_arrest_paired')
	TaskPlayAnim(ped, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, false, false, false)
	FreezeEntityPosition(ped,false)
end)

RegisterNetEvent('citizen:getarrested')
AddEventHandler('citizen:getarrested', function(playerheading, playercoords, playerlocation)
	setbusy()
    dpemote(false)
	if not status.cuffed then
		exports['sun-inventory-hud']:closeInventory()
	  status.cuffed = true
	  cuffthread()
	  handcuffthread()
	  ESX.UI.Menu.CloseAll()
	  playerPed = GetPlayerPed(-1)
	  ESX.SetPlayerData('HandCuffed', 1)
	  ESX.SetPlayerState('Cuffed',true)
	  SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	  if playerheading then
		local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
		ESX.SetEntityCoords(GetPlayerPed(-1), x, y, z)
		SetEntityHeading(GetPlayerPed(-1), playerheading)
	  end
	  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'cuff', 1.0)
	  Citizen.Wait(250)
	  loadAnimDict('mp_arrest_paired')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, false, false, false)
	  Citizen.Wait(3760)
	  loadAnimDict('mp_arresting')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
end)

RegisterNetEvent('citizen:douncuffing')
AddEventHandler('citizen:douncuffing', function()
	setbusy2()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	Citizen.Wait(250)
	loadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, false, false, false)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('citizen:getuncuffed')
AddEventHandler('citizen:getuncuffed', function(playerheading, playercoords, playerlocation)
	if status.cuffed then
      dpemote(true)
	  undragself()
	  local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	  ESX.SetEntityCoords(GetPlayerPed(-1), x, y, z)
	  SetEntityHeading(GetPlayerPed(-1), playerheading)
	  Citizen.Wait(250)
	  loadAnimDict('mp_arresting')
	  TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, false, false, false)
	  Citizen.Wait(5500)
	  status.cuffed = nil
	  Wait(1000)
	  ClearPedTasks(GetPlayerPed(-1))
	  ESX.SetPlayerData('HandCuffed', 0)
	  ESX.SetPlayerState('Cuffed',false)
	end
end)

RegisterNetEvent('citizen:putvehicle')
AddEventHandler('citizen:putvehicle', function()
	if status.cuffed or carry.InProgress then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			local vehicle = ESX.Game.GetClosestVehicle(coords)
			local roll = GetEntityRoll(vehicle)
			if DoesEntityExist(vehicle) and not (roll > 75.0 or roll < -75.0) then
				local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
				local freeSeat = nil

					for i=maxSeats - 1, 0, -1 do
						if IsVehicleSeatFree(vehicle, i) then
							freeSeat = i
							break
						end
					end

				if freeSeat ~= nil and GetVehicleDoorLockStatus(vehicle) ~= 2 then
					if ESX.GetPlayerData().IsInjure then
						StopYechizi = true
						TriggerEvent('animthread',false)
					end
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					disabledrag()
					TriggerEvent('seatbelt:changeStatus', true)
					status.draged = false
					status.put = true
					if ESX.GetPlayerData().IsInjure then
						Citizen.CreateThread(function()
							while status.put do
								Wait(1)
								DisableControlAction(2, Keys['~'], true) -- HandsUP
								DisableControlAction(2, Keys['X'], true) -- HandsUP
								DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
								DisableControlAction(2, Keys['R'], true) -- Reload
								DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
								DisableControlAction(2, Keys['SPACE'], true) -- Jump
								DisableControlAction(2, Keys['Q'], true) -- Cover
								DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
								DisableControlAction(2, Keys['M'], true) -- Select Weapon
								DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
								DisableControlAction(2, Keys['F1'], true) -- Disable phone
								DisableControlAction(2, Keys['F2'], true) -- Inventory
								DisableControlAction(2, Keys['F3'], true) -- Animations
								DisableControlAction(2, Keys['F5'], true)
								DisableControlAction(2, Keys['F6'], true)
								DisableControlAction(2, Keys['E'], true)
								DisableControlAction(2, Keys['L'], true)
								DisableControlAction(2, Keys['P'], true) -- Disable pause screen
								DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
								DisableControlAction(2, 24, true) -- Attack
								DisableControlAction(2, 257, true) -- Attack 2
								DisableControlAction(2, 25, true) -- Aim
								DisableControlAction(2, 263, true) -- Melee Attack 1
								DisableControlAction(2, 59, true) -- Disable steering in vehicle
								DisableControlAction(0, 47, true)  -- Disable weapon
								DisableControlAction(0, 264, true) -- Disable melee
								DisableControlAction(0, 257, true) -- Disable melee
								DisableControlAction(0, 140, true) -- Disable melee
								DisableControlAction(0, 141, true) -- Disable melee
								DisableControlAction(0, 142, true) -- Disable melee
								DisableControlAction(0, 143, true) -- Disable melee
								DisableControlAction(0, 75, true)  -- Disable exit vehicle
								DisableControlAction(27, 75, true) -- Disable exit vehicle
								DisableControlAction(0, Keys['Q'], true)
								DisableControlAction(0, Keys['PAGEDOWN'], true)
								DisableControlAction(0, Keys['M'], true)
								DisableControlAction(0, Keys['U'], true)
								DisableControlAction(0, Keys['Y'], true)
								DisableControlAction(0, Keys['Z'], true)
								DisableControlAction(0, Keys['B'], true)
								if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
									SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), true)
								end
								-- if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 1) then
								-- 	  TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
								-- end
								if not DoesEntityExist(vehicle) then
									local playerPed = PlayerPedId()
									if not status.put then return end
									--if not status.cuffed then
									--	return 
									--end
									status.put = false
									-- TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
									if StopYechizi then
										TriggerEvent('animthread',true)
									end
								end
							end
						end)
					end
					Wait(3000)
					TriggerEvent("seatbelt:beband")
				end
		end
	end

	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	undragself()
	uncuffself()
end)

AddEventHandler('playerSpawned', function(spawn)
	Wait(1000)
	undragself()
	uncuffself()
end)

RegisterNetEvent("citizen:cl_stop")
AddEventHandler("citizen:cl_stop", function()
	carry.InProgress = false
	if dead ~= 0 and not StopYechizi then
		TriggerEvent('animthread',true)
	end
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
	dpemote(true)
end)

RegisterNetEvent("carry:sendtocl")
AddEventHandler("carry:sendtocl", function()
	showrequest = true
	Citizen.SetTimeout(20000,function()
		showrequest = false
	end)
	Citizen.CreateThread(function()
		while showrequest do
			Wait(1)
			ESX.ShowHelpNotification('Carry Accept : ~INPUT_MP_TEXT_CHAT_TEAM~ Decline : ~INPUT_CELLPHONE_CAMERA_FOCUS_LOCK~')
		end
	end)
end)

RegisterNetEvent("carry:decline")
AddEventHandler("carry:decline", function()
	carry.Requested = false
end)

RegisterNetEvent("carry:sync1")
AddEventHandler("carry:sync1", function(src)
	carry.InProgress = true
	carry.targetPed = GetPlayerPed(GetPlayerFromServerId(src))
	dragthread()
	carry.targetSrc = src
	status.dragingid = src
	carry.Requested = false
	ensureAnimDict(carry.personCarrying.animDict)
	carry.type = "carrying"
	dpemote(false)
	lib.progressCircle({
		duration = 1000,
		position = 'middle',
		useWhileDead = false,
		canCancel = false,
		allowRagdoll = true,
		allowFalling = true,
		disable = {
			car = true,
			move = true,
			combat = true,
		},
	})
end)

AddEventHandler('onKeyDown',function(key)
	if showrequest then
		ESX.TriggerServerCallback('medic:checksignal',function(state)
			if state then
				ESX.ShowNotification('shoma yek darkhast ems ersal kardid')
			else
				if ESX.isCuff() then return end
				if key == "l" then
					showrequest = false
					TriggerServerEvent('carry:respone',false)
				end
				if key == "y" then
					showrequest = false
					TriggerServerEvent('carry:respone',true)
				end
			end
		end,GetPlayerServerId(PlayerId()))
	end
	if cancel then
		if key == "l" then
		cancel = false
		dpemote(true)
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		carry.targetSrc = 0
		status.dragingid = nil
		TriggerServerEvent('citizen:stopcarry')
		end
	end
end)

RegisterNetEvent("carry:showcancel")
AddEventHandler("carry:showcancel", function()
	cancel = true
	exports.essentialmode:disablecontrol('b',true)
	while carry.InProgress do
		Wait(1)
		ESX.ShowHelpNotification('Cancel carry : ~INPUT_CELLPHONE_CAMERA_FOCUS_LOCK~')
	end
	exports.essentialmode:disablecontrol('b',false)
end)

RegisterNetEvent("citizen:syncTarget")
AddEventHandler("citizen:syncTarget", function(targetSrc, force)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	if ESX.GetPlayerData().IsDead == false and ESX.GetPlayerData().IsInjure == true then
		dead = 1
		TriggerEvent('animthread',false, force)
	end
	carry.InProgress = true
	carry.targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	dragthread()
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 0, false, false, false, false, 2, false)
	carry.type = "beingcarried"
	exports['essentialmode']:disablecontrol('f1',true)
	exports['essentialmode']:disablecontrol('f2',true)
	exports['essentialmode']:disablecontrol('m',true)
	dpemote(false)
end)

RegisterNetEvent("police:mutemask")
AddEventHandler("police:mutemask", function(state)
	-- if state then
	-- 	TriggerEvent('skinchanger:loadStuff',{mask_1 = 23,mask_2 = 1})
	-- else
	-- 	TriggerEvent('skinchanger:loadStuff',{mask_1 = 0,mask_2 = 0})
	-- end
	if state then
		TriggerEvent('skinchanger:loadStuff',{mask_1 = 90,mask_2 = 1})
	else
		TriggerEvent('skinchanger:loadStuff',{mask_1 = 0,mask_2 = 0})
	end
end)

AddEventHandler('carry:GetData',function(cb)
	cb(carry,status.draging)
end)

RegisterNetEvent('carry:csme',function()
	ESX.TriggerServerEvent('ss_cs:csMe',300,'Bug abuse #4')
end)

RegisterCommand('carry',function(source,args)
	if carry.Requested or carry.InProgress then
		ESX.ShowNotification('shoma yek darkhast carry ersal kardid lotfan 20 sanie sabr konid')
		return
	end
	if ESX.isDead() or ESX.isBusy() then return end
	if not ESX.checkCooldown('carry', 20000) then
		return ESX.chatMessage('shoma yek darkhast carry ersal kardid lotfan 20 sanie sabr konid', 'plarms')
	end
	if ESX.isCuff() then return end
	local target, distance = ESX.Game.GetClosestPlayer()
	target = GetPlayerServerId(target)
	if not ESX.Game.PlayerExist(target) then
		ESX.ShowNotification('fard mored nazar kenar shoma nistd')
		return
	end
	if distance > 3 then
		ESX.ShowNotification('fard bayad dar 3 metri shoma bashad')
		return
	end
	if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then return end

	-- ESX.TriggerServerCallback('medic:checksignal',function(state)
		-- if state and (ESX.GetPlayerData().job.name ~= "ambulance") then
			-- ESX.ShowNotification('fard yek darkhast ems ersal karde ast')
		-- else
			if DecorGetBool(GetPlayerPed(GetPlayerFromServerId(target)),'IsDead') then return ESX.ShowNotification('Shoma nemitavanid fard morede ra boland konid') end
			carry.Requested = true
			Citizen.SetTimeout(20000,function()
				if carry.Requested then
					carry.Requested = false
				end
			end)
			ESX.ShowNotification('darkhast carry ersal shod')
			TriggerServerEvent('carry:send',target)
		-- end
	-- end,target)
end, false)

RegisterCommand('put',function(source,args)
	if carry.InProgress and carry.type == "carrying" then
		ESX.TriggerServerCallback('medic:checksignal',function(state)
			if state and (ESX.GetPlayerData().job.name ~= "ambulance") then
				ESX.ShowNotification('fard yek darkhast ems ersal karde ast')
			else
				local coords = GetEntityCoords(PlayerPedId())
				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					local vehicle = ESX.Game.GetClosestVehicle(coords)
					if GetVehicleDoorLockStatus(vehicle) ~= 2 then
						TriggerServerEvent('citizen:putvehicle', carry.targetSrc)
						Wait(300)
						ClearPedSecondaryTask(PlayerPedId())
						carry.InProgress = false
						ClearPedSecondaryTask(PlayerPedId())
						DetachEntity(PlayerPedId(), true, false)
						TriggerServerEvent("citizen:stopcarry")
						puted = carry.targetSrc
						carry.targetSrc = 0
						dpemote(true)
					else
						ESX.chatMessage('In mashin ghofl ast', 'plarms')
					end
				else
					ESX.chatMessage('Mashini dar kenar shoma nist', 'plarms')
				end
			end
		end,carry.targetSrc)
	elseif ESX.Game.PlayerExist(puted) and IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(puted)), false) then
		if GetVehicleDoorLockStatus(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(puted)), false)) ~= 2  then
			TriggerServerEvent('citizen:putoutvehicle', puted)
			puted = 0
		else
			ESX.ShowNotification('Dar mashin ghofl ast!')
		end
	else
		ESX.ShowNotification('shoma kasi ra carry nemikonid')
	end
end, false)

-- RegisterCommand('silentplayer',function()
-- 	if mutespam then return ESX.ShowNotification('Spam nakonid') end
-- 	mutespam = true
-- 	Citizen.SetTimeout(5000,function()
-- 		mutespam = false
-- 	end)
-- 	if ESX.GetPlayerData().gang.name ~= 'nogang' then
-- 		local players = ESX.Game.GetPlayersToSend(5)
-- 		local player = 0
-- 		for k , v in pairs(players) do
-- 			if ESX.GetPlayerState(v,'Cuffed') then
-- 				player = v
-- 				break
-- 			end
-- 		end
-- 		if player == 0 then
-- 			ESX.Alert('Error','Kasi dar kenar shoma nist',5000,'error')
-- 		else
-- 			TriggerServerEvent('police:togglemute',player)
-- 		end
-- 	end
-- end, false)

exports("cuffplayer", function(type)
	if IsBusy2 then return end
	ESX.selectPlayerMenu(function(target)
		if target then
			local player = GetPlayerFromServerId(target)
			if type ~= 2 or IsEntityPlayingAnim(GetPlayerPed(player), "missfra1mcs_2_crew_react","handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(player), "missminuteman_1ig_2","handsup_base", 3) then
				ESX.TriggerServerCallback('esx:checkemsstatus', function(data,data2)
					if (data or data2) and not ESX.GetPlayerState(target, 'adrenaline') then
						ESX.ShowNotification('Fard mored nazar injure ast!')
					else
						ESX.TriggerServerCallback('citizen:cuffstatus', function(status,typee,admin)
							if admin then
								--ESX.ShowNotification('Fard mored nazar admin ast!')
							elseif status then
								ESX.ShowNotification('Fard mored nazar cuff ast!')
							else
								local ped = PlayerPedId()
								local targetped = GetPlayerPed(GetPlayerFromServerId(target))
								if GetVehiclePedIsIn(targetped,false) == 0 then
									local coords = GetEntityCoords(ped)
									local targetcoords = GetEntityCoords(targetped)
									local head = GetEntityHeading(ped)
									local location = GetEntityForwardVector(ped)
									if #(coords - targetcoords)  < 5.0 then
										setbusy2()
										FreezeEntityPosition(ped,true)
										TriggerServerEvent('citizen:handcuff', target, type,head, coords, location)
										TriggerServerEvent('3dme:shareDisplay2', 'dast fard ro dast band mizane', true)
									else
										ESX.ShowNotification('Fard az shoma dour ast!')
									end
								else
									ESX.ShowNotification('Fard mored nazar savar mashin ast!')
								end
							end
						end, target)
					end
				end, target)
			else
				ESX.ShowNotification('Baraye cuff kardan dastaye fard bayad bala bashad!')
			end
		end
	end, 5)
end)

exports("uncuffplayer", function(type, kingKey)
	if IsBusy2 then return end
	ESX.selectPlayerMenu(function(target)
		if target then
			ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss,typee,admin)
					if statuss then
						if admin then
							ESX.ShowNotification('Fard mored nazar admin ast!')
						elseif type ~= typee and type ~= 1 then
							ESX.ShowNotification('Shoma kelid in dast band ra nadarid!')
						else
							local ped = PlayerPedId()
							local targetped = GetPlayerPed(GetPlayerFromServerId(target))
							if GetVehiclePedIsIn(targetped,false) == 0 then
								local coords = GetEntityCoords(ped)
								local targetcoords = GetEntityCoords(targetped)
								local head = GetEntityHeading(ped)
								local location = GetEntityForwardVector(ped)
								if #(coords - targetcoords)  < 5.0 then
									if kingKey then
										TriggerServerEvent('deleteitem', 'kingkey')
									end
									setbusy2()
									if status.draging then
										status.draging = false
										status.dragingid = nil
										Wait(300)
										ClearPedSecondaryTask(PlayerPedId())
									end
									ESX.TriggerServerEvent('citizen:uncuff', target, type,head, coords, location)
									TriggerServerEvent('3dme:shareDisplay2', 'dast fard ro baz mikone', true)
								else
									ESX.ShowNotification('Fard az shoma dour ast!')
								end
							else
								ESX.ShowNotification('Fard mored nazar savar mashin ast!')
							end
						end
					else
						--ESX.ShowNotification('Dast player baz ast!')
					end
			end, target)
		end
	end, 5)
end)

exports("dragplayer", function(target)
	if IsBusy2 then return end
	if status.dragingid then
		TriggerServerEvent('citizen:drag', status.dragingid)
		status.dragingid = nil
	else
		ESX.selectPlayerMenu(function(target)
			if not ESX.Game.PlayerExist(target) then return end
			ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss,type,admin,drag)
				if statuss then
					if admin then
						--ESX.ShowNotification('Fard mored nazar admin ast!')
					elseif drag then
						if target == status.dragingid then
							TriggerServerEvent('citizen:drag', target)
							status.dragingid = nil
						else
							ESX.ShowNotification('Fard mored nazar drag ast')
						end
					else
						local ped = PlayerPedId()
						local targetped = GetPlayerPed(GetPlayerFromServerId(target))
						if GetVehiclePedIsIn(targetped,false) == 0 then
							local coords = GetEntityCoords(ped)
							local targetcoords = GetEntityCoords(targetped)
							if #(coords - targetcoords)  < 5.0 then
								setbusy2()
								TriggerServerEvent('citizen:drag', target)
								status.dragingid = target
							else
								ESX.ShowNotification('Fard az shoma dour ast!')
							end
						else
							ESX.ShowNotification('Fard mored nazar savar mashin ast!')
						end
					end
				else
					--ESX.ShowNotification('Dast player baz ast!')
				end
			end, target)
		end, 5)
	end
end)

exports("putinvehicle", function()
	if IsBusy2 then return end
	target = status.dragingid
	targetplayer = GetPlayerFromServerId(target)
	if GetVehiclePedIsIn(GetPlayerPed(targetplayer), false) ~= 0 then ESX.ShowNotification('Fard mored nazar savar mashin ast!') end
		ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss,type,admin,drag,cry)
				if target or cry then
				if statuss or cry then
					if admin then
						--ESX.ShowNotification('Fard mored nazar admin ast!')
					elseif drag or cry then
						local coords = GetEntityCoords(PlayerPedId())
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
							local vehicle = ESX.Game.GetClosestVehicle(coords)
							if GetVehicleDoorLockStatus(vehicle) ~= 2 then
								TriggerServerEvent('citizen:putvehicle', target)
								status.draging = false
								status.dragingid = nil
								Wait(300)
								ClearPedSecondaryTask(PlayerPedId())
								if cry then
									carry.InProgress = false
									ClearPedSecondaryTask(PlayerPedId())
									DetachEntity(PlayerPedId(), true, false)
									TriggerServerEvent("citizen:stopcarry",carry.targetSrc)
									carry.targetSrc = 0
									status.dragingid = nil
								end
							else
								ESX.chatMessage('In mashin ghofl ast', 'plarms')
							end
						else
							ESX.chatMessage('Mashini dar kenar shoma nist', 'plarms')
						end
					else
						--ESX.ShowNotification('Fard mored nazar drag nist')
					end
				end
				end
		end, target)
end)

exports("putoutvehicle", function(target)
	if IsBusy2 then return end
	ESX.selectPlayerMenu(function(target)
		if not ESX.Game.PlayerExist(target) then return end
		targetplayer = GetPlayerFromServerId(target)
		if not IsPedSittingInAnyVehicle(GetPlayerPed(targetplayer)) then return end
		ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss, type, admin, drag)
			if admin then
				--ESX.ShowNotification('Fard mored nazar admin ast!')
			--elseif drag then
			else
				if GetVehicleDoorLockStatus(GetVehiclePedIsIn((GetPlayerPed(targetplayer)), false)) ~= 2  then
					TriggerServerEvent('citizen:putoutvehicle', target)
				else
					ESX.ShowNotification('Dar mashin ghofl ast!')
				end
			--else
			--	ESX.ShowNotification('Fard mored nazar drag nist')
			end
		end, target)
	end, 5, function(target)
		return IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), false)
	end)
end)

exports("togglecarry", function(id)
	local targetped = GetPlayerPed(GetPlayerFromServerId(id))
	if GetVehiclePedIsIn(targetped, false) ~= 0 then return end
	if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then return end
	if not carry.InProgress then
		carry.InProgress = true
		carry.targetPed = GetPlayerPed(GetPlayerFromServerId(id))
		dragthread()
		carry.targetSrc = id
		status.dragingid = id
		TriggerServerEvent("citizen:sync",id)
		ensureAnimDict(carry.personCarrying.animDict)
		carry.type = "carrying"
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("citizen:stopcarry",carry.targetSrc)
		carry.targetSrc = 0
		status.dragingid = nil
	end
end)

exports('carry',function(target)
	if carry.Requested or carry.InProgress then
		ESX.ShowNotification('shoma yek darkhast carry ersal kardid lotfan 20 sanie sabr konid')
		return
	end
	if not ESX.checkCooldown('carry', 20000) then
		return ESX.chatMessage('shoma yek darkhast carry ersal kardid lotfan 20 sanie sabr konid', 'plarms')
	end
	if ESX.isBusy() then return end
	local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(targetID))))
	if not ESX.Game.PlayerExist(target) then
		ESX.ShowNotification('fard mored nazar kenar shoma nistd')
		return
	end
	if distance > 3 then
		ESX.ShowNotification('fard bayad dar 3 metri shoma bashad')
		return
	end
	if ESX.isCuff() then return end
	if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then return end
	ESX.TriggerServerCallback('medic:checksignal',function(state)
		if state and (ESX.GetPlayerData().job.name ~= "ambulance") then
			ESX.ShowNotification('fard yek darkhast ems ersal karde ast')
		else
			if DecorGetBool(GetPlayerPed(GetPlayerFromServerId(target)),'IsDead') then return ESX.ShowNotification('Shoma nemitavanid fard morede ra boland konid') end
			carry.Requested = true
			Citizen.SetTimeout(20000,function()
				if carry.Requested then
					carry.Requested = false
				end
			end)
			ESX.ShowNotification('darkhast carry ersal shod')
			TriggerServerEvent('carry:send',target)
		end
	end,target)
end)

exports('uncuffself', uncuffself)