ESX          = nil
CheckVehicle = false
local PlayerHasProp = false
local drunkMuliplier = 0
local weapons = {
	[GetHashKey("WEAPON_COMBATPISTOL")] = "WEAPON_COMBATPISTOL",
	[GetHashKey("WEAPON_PISTOL")] = "WEAPON_PISTOL",
	[GetHashKey("WEAPON_PISTOL50")] = "WEAPON_PISTOL50",
	[GetHashKey("WEAPON_SNSPISTOL")] = "WEAPON_SNSPISTOL",
	[GetHashKey("WEAPON_SMG")] = "WEAPON_SMG",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "WEAPON_ASSAULTRIFLE",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "WEAPON_CARBINERIFLE",
	[GetHashKey("WEAPON_SPECIALCARBINE")] = "WEAPON_SPECIALCARBINE",
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "WEAPON_ADVANCEDRIFLE",
	[GetHashKey("WEAPON_COMBATPDW")] = "WEAPON_COMBATPDW",
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = "WEAPON_PUMPSHOTGUN",
	[GetHashKey("WEAPON_MICROSMG")] = "WEAPON_MICROSMG",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "WEAPON_HEAVYPISTOL",
	[GetHashKey("WEAPON_ASSAULTSMG")] = "WEAPON_ASSAULTSMG",
	[GetHashKey("WEAPON_BULLPUPRIFLE")] = "WEAPON_BULLPUPRIFLE",
	[GetHashKey("WEAPON_GUSENBERG")] = "WEAPON_GUSENBERG",
	[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = "WEAPON_ASSAULTRIFLE_MK2",
	[GetHashKey("WEAPON_WEAPON_MILITARYRIFLE")] = "WEAPON_MILITARYRIFLE",
}

local extendedClips = {
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "clip_extended", weapon = "WEAPON_COMBATPISTOL", item = "eclip"},
  [GetHashKey("WEAPON_PISTOL")] = { id = "clip_extended", weapon = "WEAPON_PISTOL", item = "eclip"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "clip_extended", weapon = "WEAPON_PISTOL50", item = "eclip"},
  [GetHashKey("WEAPON_SNSPISTOL")] = { id = "clip_extended", weapon = "WEAPON_SNSPISTOL", item = "eclip"},
  [GetHashKey("WEAPON_SMG")] = { id = "clip_extended", weapon = "WEAPON_SMG", item = "eclip"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "clip_extended", weapon = "WEAPON_ASSAULTRIFLE", item = "eclip"},
  [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = { id = "clip_extended", weapon = "WEAPON_ASSAULTRIFLE_MK2", item = "eclip"},
  [GetHashKey("WEAPON_MILITARYRIFLE")] = { id = "clip_extended", weapon = "WEAPON_MILITARYRIFLE", item = "eclip"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "clip_extended", weapon = "WEAPON_CARBINERIFLE", item = "eclip"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "clip_extended", weapon = "WEAPON_COMBATPDW", item = "eclip"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "clip_extended", weapon = "WEAPON_MICROSMG", item = "eclip"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "clip_extended", weapon = "WEAPON_HEAVYPISTOL", item = "eclip"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "clip_extended", weapon = "WEAPON_ASSAULTSMG", item = "eclip"},
  [GetHashKey("WEAPON_GUSENBERG")] = { id = "clip_extended", weapon = "WEAPON_GUSENBERG", item = "eclip"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "clip_extended", weapon = "WEAPON_SPECIALCARBINE", item = "eclip"},
  [GetHashKey("WEAPON_BULLPUPRIFLE")] = { id = "clip_extended", weapon = "WEAPON_BULLPUPRIFLE", item = "eclip"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "clip_extended", weapon = "WEAPON_ADVANCEDRIFLE", item = "eclip"}
}

local silencers = {
  [GetHashKey("WEAPON_PISTOL")] = { id = "suppressor", weapon = "WEAPON_PISTOL", item = "silencer"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "suppressor", weapon = "WEAPON_PISTOL50", item = "silencer"},
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "suppressor", weapon = "WEAPON_COMBATPISTOL", item = "silencer"},
  [GetHashKey("WEAPON_SMG")] = { id = "suppressor", weapon = "WEAPON_SMG", item = "silencer"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "suppressor", weapon = "WEAPON_ASSAULTRIFLE", item = "silencer"},
  [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = { id = "suppressor", weapon = "WEAPON_ASSAULTRIFLE_MK2", item = "silencer"},
  [GetHashKey("WEAPON_MILITARYRIFLE")] = { id = "suppressor", weapon = "WEAPON_MILITARYRIFLE", item = "silencer"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "suppressor", weapon = "WEAPON_CARBINERIFLE", item = "silencer"},
  [GetHashKey("WEAPON_PUMPSHOTGUN")] = { id = "suppressor", weapon = "WEAPON_PUMPSHOTGUN", item = "silencer"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "suppressor", weapon = "WEAPON_MICROSMG", item = "silencer"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "suppressor", weapon = "WEAPON_HEAVYPISTOL", item = "silencer"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "suppressor", weapon = "WEAPON_ASSAULTSMG", item = "silencer"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "suppressor", weapon = "WEAPON_SPECIALCARBINE", item = "silencer"},
  [GetHashKey("WEAPON_BULLPUPRIFLE")] = { id = "suppressor", weapon = "WEAPON_BULLPUPRIFLE", item = "silencer"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "suppressor", weapon = "WEAPON_ADVANCEDRIFLE", item = "silencer"},
}

local flashlights = {
  [GetHashKey("WEAPON_PISTOL")] = { id = "flashlight", weapon = "WEAPON_PISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_PISTOL50")] = { id = "flashlight", weapon = "WEAPON_PISTOL50", item = "flashlight"},
  [GetHashKey("WEAPON_COMBATPISTOL")] = { id = "flashlight", weapon = "WEAPON_COMBATPISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_SMG")] = { id = "flashlight", weapon = "WEAPON_SMG", item = "flashlight"},
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "flashlight", weapon = "WEAPON_ASSAULTRIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = { id = "flashlight", weapon = "WEAPON_ASSAULTRIFLE_MK2", item = "flashlight"},
  [GetHashKey("WEAPON_MILITARYRIFLE")] = { id = "flashlight", weapon = "WEAPON_MILITARYRIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "flashlight", weapon = "WEAPON_CARBINERIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "flashlight", weapon = "WEAPON_COMBATPDW", item = "flashlight"},
  [GetHashKey("WEAPON_PUMPSHOTGUN")] = { id = "flashlight", weapon = "WEAPON_PUMPSHOTGUN", item = "flashlight"},
  [GetHashKey("WEAPON_MICROSMG")] = { id = "flashlight", weapon = "WEAPON_MICROSMG", item = "flashlight"},
  [GetHashKey("WEAPON_HEAVYPISTOL")] = { id = "flashlight", weapon = "WEAPON_HEAVYPISTOL", item = "flashlight"},
  [GetHashKey("WEAPON_ASSAULTSMG")] = { id = "flashlight", weapon = "WEAPON_ASSAULTSMG", item = "flashlight"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "flashlight", weapon = "WEAPON_SPECIALCARBINE", item = "flashlight"},
  [GetHashKey("WEAPON_BULLPUPRIFLE")] = { id = "flashlight", weapon = "WEAPON_BULLPUPRIFLE", item = "flashlight"},
  [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { id = "flashlight", weapon = "WEAPON_ADVANCEDRIFLE", item = "flashlight"}
}

local grips = {
  [GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "grip", weapon = "WEAPON_ASSAULTRIFLE", item = "grip"},
  [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = { id = "grip", weapon = "WEAPON_ASSAULTRIFLE_MK2", item = "grip"},
  [GetHashKey("WEAPON_MILITARYRIFLE")] = { id = "grip", weapon = "WEAPON_MILITARYRIFLE", item = "grip"},
  [GetHashKey("WEAPON_CARBINERIFLE")] = { id = "grip", weapon = "WEAPON_CARBINERIFLE", item = "grip"},
  [GetHashKey("WEAPON_COMBATPDW")] = { id = "grip", weapon = "WEAPON_COMBATPDW", item = "grip"},
  [GetHashKey("WEAPON_BULLPUPRIFLE")] = { id = "grip", weapon = "WEAPON_BULLPUPRIFLE", item = "grip"},
  [GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "grip", weapon = "WEAPON_SPECIALCARBINE", item = "grip"}
}

local drumMagazines = {
	[GetHashKey("WEAPON_SMG")] = { id = "clip_drum", weapon = "WEAPON_SMG", item = "dclip"},
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = { id = "clip_drum", weapon = "WEAPON_ASSAULTRIFLE", item = "dclip"},
	[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = { id = "clip_drum", weapon = "WEAPON_ASSAULTRIFLE_MK2", item = "dclip"},
	[GetHashKey("WEAPON_MILITARYRIFLE")] = { id = "clip_drum", weapon = "WEAPON_MILITARYRIFLE", item = "dclip"},
	[GetHashKey("WEAPON_CARBINERIFLE")] = { id = "clip_box", weapon = "WEAPON_CARBINERIFLE", item = "dclip"},
	[GetHashKey("WEAPON_COMBATPDW")] = { id = "clip_drum", weapon = "WEAPON_COMBATPDW", item = "dclip"},
	[GetHashKey("WEAPON_SPECIALCARBINE")] = { id = "clip_drum", weapon = "WEAPON_SPECIALCARBINE", item = "dclip"}
}

local PlayerProps = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('esx_components:useClipcli')
AddEventHandler('esx_components:useClipcli', function()

		local ped = PlayerPedId()
		if IsPedArmed(ped, 5) then
			hash= GetSelectedPedWeapon(ped)

			if GetSelectedPedWeapon(ped)~=nil then
			TriggerServerEvent('esx_components:remove', "clip")
			AddAmmoToPed(PlayerPedId(), GetSelectedPedWeapon(ped), 25)
			ESX.ShowNotification("Shoma ba movafaghiat az kheshab estefade kardid")
			else
			ESX.ShowNotification("hash aslahe mored nazar namaloom ast")
			end

		else
			ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
		end

end)

RegisterNetEvent('esx_components:useTint')
AddEventHandler('esx_components:useTint', function(info)
	local ped = PlayerPedId()

	if IsPedArmed(PlayerPedId(), 4) then

		local currentweapon = GetSelectedPedWeapon(PlayerPedId())
		  SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), info.color)
		  TriggerServerEvent('esx_components:remove', info.name)
		  ESX.ShowNotification("~h~Shoma ba movafaghiat 1x ~g~" .. info.label .. " ~w~use kardid!")

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end)

RegisterNetEvent('esx_components:useExtendedMagazine')
AddEventHandler('esx_components:useExtendedMagazine', function()
	local ped = PlayerPedId()

	if IsPedArmed(PlayerPedId(), 4) then

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		if extendedClips[GetSelectedPedWeapon(PlayerPedId())] then
			TriggerServerEvent('esx_components:addComponent', extendedClips[GetSelectedPedWeapon(PlayerPedId())])
		else
			ESX.ShowNotification("In aslahe extended magazine ra support nemikonad!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_components:useDrumMagazine')
AddEventHandler('esx_components:useDrumMagazine', function()
	local ped = PlayerPedId()

	if IsPedArmed(ped, 5) then

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		if drumMagazines[weapon] then
			TriggerServerEvent('esx_components:addComponent', drumMagazines[weapon])
		else
			ESX.ShowNotification("In aslahe Drum magazine ra support nemikonad!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end)

RegisterNetEvent('esx_components:useSilencer')
AddEventHandler('esx_components:useSilencer', function()
	local ped = PlayerPedId()

	if IsPedArmed(ped, 5) then

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		if silencers[weapon] then
			TriggerServerEvent('esx_components:addComponent', silencers[weapon])
		else
			ESX.ShowNotification("In aslahe silencer ra support nemikonad!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_components:useFlashlight')
AddEventHandler('esx_components:useFlashlight', function()
	local ped = PlayerPedId()

	if IsPedArmed(ped, 5) then

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		if flashlights[weapon] then
			TriggerServerEvent('esx_components:addComponent', flashlights[weapon])
		else
			ESX.ShowNotification("In aslahe flashlight ra support nemikonad!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterNetEvent('esx_components:useGrip')
AddEventHandler('esx_components:useGrip', function()
	local ped = PlayerPedId()

	if IsPedArmed(ped, 5) then

		local weapon = GetSelectedPedWeapon(PlayerPedId())
		if grips[weapon] then
			TriggerServerEvent('esx_components:addComponent', grips[weapon])
		else
			ESX.ShowNotification("In aslahe grip ra support nemikonad!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end
end)

RegisterCommand('deattach', function(source, args)
	local ped = PlayerPedId()

	if IsPedArmed(ped, 5) then

		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar argument aval chizi vared nakardid!")
			return
		end

		local input = string.lower(args[1])
		local weapon = GetSelectedPedWeapon(PlayerPedId())

		if input == "silencer" then
			if silencers[weapon] then
				TriggerServerEvent('esx_components:removeComponent', silencers[weapon], false)
			else
				ESX.ShowNotification("In aslahe silencer ra support nemikonad!")
			end
		elseif input == "eclip" then
			if extendedClips[weapon] then
				TriggerServerEvent('esx_components:removeComponent', extendedClips[weapon], false)
			else
				ESX.ShowNotification("In aslahe extended magazine ra support nemikonad!")
			end
		elseif input == "dclip" then
			if drumMagazines[weapon] then
				TriggerServerEvent('esx_components:removeComponent', drumMagazines[weapon], false)
			else
				ESX.ShowNotification("In aslahe Drum magazine ra support nemikonad!")
			end
		elseif input == "flashlight" then
			if flashlights[weapon] then
				TriggerServerEvent('esx_components:removeComponent', flashlights[weapon], false)
			else
				ESX.ShowNotification("In aslahe flashlight ra support nemikonad!")
			end
		elseif input == "grip" then
			if grips[weapon] then
				TriggerServerEvent('esx_components:removeComponent', grips[weapon], false)
			else
				ESX.ShowNotification("In aslahe grip ra support nemikonad!")
			end
		elseif input == "all" then
			TriggerServerEvent('esx_components:removeComponent', weapons[weapon], true)
		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Argument vared shode eshtebah ast!")
		end

	else
		ESX.ShowNotification("Shoma aslaheyi dar dast nadarid")
	end

end, false)

RegisterNetEvent('esx_components:useYusuf')
AddEventHandler('esx_components:useYusuf', function()
					local inventory = ESX.GetPlayerData().inventory
				local yusuf = 0
					for i=1, #inventory, 1 do
					  if inventory[i].name == 'yusuf' then
						yusuf = inventory[i].count
					  end
					end

			local ped = PlayerPedId()
			local currentWeaponHash = GetSelectedPedWeapon(ped)

					if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_SNSPISTOL") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_SNSPISTOL"), GetHashKey("COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPRIFLE") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), GetHashKey("COMPONENT_BULLPUPRIFLE_VARMOD_LOW"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
						GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"))
						TriggerServerEvent('esx_components:remove', "yusuf")
						ESX.ShowNotification("Shoma yek skin talaee estefade kardid")

					else
						ESX.ShowNotification("Aslahe mored nazar ghabeliat estefade kardan az skin talaee ra nadarad")
					end
end)

function addDrunk()
	drunkMuliplier = drunkMuliplier + 1
	if drunkMuliplier == 5 then
		overdose()
		drunkMuliplier = 0
	end
end

function overdose()

	local playerPed = PlayerPedId()

	RequestAnimSet("move_injured_generic")
	while not HasAnimSetLoaded("move_injured_generic") do
	Citizen.Wait(1)
	end

	ClearPedTasksImmediately(playerPed)
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(playerPed, true)
	SetPedMovementClipset(playerPed, "move_injured_generic", true)
	SetPedIsDrunk(playerPed, true)
	Citizen.Wait(30000)
	clearEffects()

end

function clearEffects()
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)

	  end)
end

function OnEmotePlay(EmoteName)
	if not DoesEntityExist(PlayerPedId()) then
	  return false
	end

	  if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	  end

	ChosenDict,ChosenAnimation,ename = table.unpack(EmoteName)
	AnimationDuration = -1

	if PlayerHasProp then
	  DestroyAllProps()
	end

	if ChosenDict == "Expression" then
	  SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
	  return
	end

	if ChosenDict == "MaleScenario" or "Scenario" then
	  CheckGender()
	  if ChosenDict == "MaleScenario" then
		if PlayerGender == "male" then
		  ClearPedTasks(PlayerPedId())
		  TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
		  IsInAnimation = true
		else
		  EmoteChatMessage("This emote is male only, sorry!")
		end return
	  elseif ChosenDict == "ScenarioObject" then
		BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
		ClearPedTasks(PlayerPedId())
		TaskStartScenarioAtPosition(PlayerPedId(), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
		IsInAnimation = true
		return
	  elseif ChosenDict == "Scenario" then
		ClearPedTasks(PlayerPedId())
		TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
		IsInAnimation = true
	  return end
	end

	  LoadAnim(ChosenDict)
	  if EmoteName.AnimationOptions.Drunk == true then
		addDrunk()
	  end

	  if EmoteName.AnimationOptions then
		if EmoteName.AnimationOptions.EmoteLoop then
		  MovementType = 1
		if EmoteName.AnimationOptions.EmoteMoving then
		  MovementType = 51
		end
	elseif EmoteName.AnimationOptions.EmoteMoving then
	  MovementType = 51
	end
	else
	  MovementType = 0
	end

	if EmoteName.AnimationOptions then
	  if EmoteName.AnimationOptions.EmoteDuration == nil then
		EmoteName.AnimationOptions.EmoteDuration = -1
	  else
		AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
	  end

	  if EmoteName.AnimationOptions.Prop then
		PropName = EmoteName.AnimationOptions.Prop
		PropBone = EmoteName.AnimationOptions.PropBone
		PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
		if EmoteName.AnimationOptions.SecondProp then
		  SecondPropName = EmoteName.AnimationOptions.SecondProp
		  SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
		  SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
		  SecondPropEmote = true
		else
		  SecondPropEmote = false
		end

		AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
		if SecondPropEmote then
		  AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
		end
	  end
	end

	TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
	IsInAnimation = true
	MostRecentDict = ChosenDict
	MostRecentAnimation = ChosenAnimation
	return true
  end

  CheckGender = function()
	local hashSkinMale = GetHashKey("mp_m_freemode_01")
	local hashSkinFemale = GetHashKey("mp_f_freemode_01")

	if GetEntityModel(PlayerPedId()) == hashSkinMale then
	  PlayerGender = "male"
	elseif GetEntityModel(PlayerPedId()) == hashSkinFemale then
	  PlayerGender = "female"
	end
  end

  LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Citizen.Wait(1)
	end
  end

  LoadPropDict = function(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
	  Citizen.Wait(1)
	end
  end

  AddPropToPlayer = function(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
	local Player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(Player))

	if not HasModelLoaded(prop1) then
	  LoadPropDict(prop1)
	end

	prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
	table.insert(PlayerProps, prop)
	PlayerHasProp = true
  end

  DestroyAllProps = function()
	for _,v in pairs(PlayerProps) do
	  DeleteEntity(v)
	end
	PlayerHasProp = false
  end