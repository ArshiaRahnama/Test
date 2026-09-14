ESX          = nil
CheckVehicle = false
local PlayerHasProp = false
local drunkMuliplier = 0

local PlayerProps = {}

Emotes = {
	["soda"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Soda", AnimationOptions =
	{
		Prop = 'prop_ecola_can',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
		EmoteLoop = false,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["coffee"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee", AnimationOptions =
	{
		Prop = 'p_amb_coffeecup_01',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteLoop = false,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["tea"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tea", AnimationOptions =
	{
		Prop = 'prop_plastic_cup_02',
		PropBone = 28422,
		PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteLoop = true,
		Drunk     = false,
		EmoteMoving = true,
	}},
	["donut"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut", AnimationOptions =
   {
       Prop = 'prop_amb_donut',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = false,
	   Drunk     = false,
       EmoteDuration = 4500
   }},
   ["whiskey"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Whiskey", AnimationOptions =
   {
       Prop = 'prop_drink_whisky',
       PropBone = 28422,
       PropPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0},
	   EmoteLoop = false,
	   Drunk     = true,
       EmoteMoving = true,
   }},
   ["sandwich"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwich", AnimationOptions =
   {
       Prop = 'prop_sandwich_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = true,
	   Drunk     = false,
       EmoteMoving = true,
   }},
   ["pizza"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "pizza", AnimationOptions =
   {
       Prop = 'prop_cs_burger_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = true,
	   Drunk     = false,
	   EmoteLoop = true
   }},
   ["sibzamini"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sibzamini", AnimationOptions =
   {
       Prop = 'prop_food_bs_chips',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
	   EmoteMoving = true,
	   Drunk     = false,
	   EmoteLoop = true
   }},
   ["sh"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Sandwitch Hamberger", AnimationOptions =
   {
       Prop = 'prop_cs_burger_01',
       PropBone = 18905,
       PropPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0},
	   EmoteMoving = true,
	   Drunk     = false,
	   EmoteLoop = true

   }},
   ["wine"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Wine", AnimationOptions =
   {
       Prop = 'prop_drink_redwine',
       PropBone = 18905,
       PropPlacement = {0.10, -0.03, 0.03, -100.0, 0.0, -10.0},
	   EmoteMoving = true,
	   Drunk     = true,
       EmoteLoop = false
   }},
   ["beer"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Beer", AnimationOptions =
   {
       Prop = 'prop_amb_beer_bottle',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	   EmoteLoop = false,
	   Drunk     = true,
       EmoteMoving = true,
   }},
   ["smoke"] = {"amb@world_human_aa_smoke@male@idle_a", "idle_b", "Smoke", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},
   ["sianor"] = {"mp_suicide", "pill", "pill", AnimationOptions =
   {
       Prop = 'prop_cs_ciggy_01',
       PropBone = 28422,
       PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
       EmoteLoop = true,
       EmoteMoving = true,
   }},

}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('esx_basicneeds:playAnim')
AddEventHandler('esx_basicneeds:playAnim', function(name)
	local name = name

	OnEmotePlay(Emotes[name])

	if name == "soda" or name == "coffee" or name == "tea" or name == "whiskey" or name == "wine" or name == "beer" then
		Citizen.Wait(10000)
		DestroyAllProps()
		ClearPedSecondaryTask(PlayerPedId())
	end
	if name == "donut" then
		Citizen.Wait(4000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "smoke" then
		Citizen.Wait(60000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "sianor" then
		Citizen.Wait(4500)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "LSD" then
		Citizen.Wait(4800)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "smoke" then
		Citizen.Wait(4800)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
		clearEffects()
	end
	if name == "noshab" then
		Citizen.Wait(4800)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "sh" then
		Citizen.Wait(30000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "sandwich" then
		Citizen.Wait(30000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "pitza" then
		Citizen.Wait(30000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
	if name == "sibzamini" then
		Citizen.Wait(30000)
		DestroyAllProps()
		ClearPedTasksImmediately(PlayerPedId())
	end
end)

RegisterNetEvent('esx_customItems:useArmor')
AddEventHandler('esx_customItems:useArmor', function()

	TriggerEvent("mythic_progbar:client:progress", {
		name = "armor_putin",
		duration = 5000,
		label = "Dar hale poshidan armor",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_03",
        }
	}, function(status)

		if not status then

			ClearPedTasksImmediately(PlayerPedId())
			ESX.TriggerServerCallback('esx_customItems:removeArmor', function(doesHave)
				if doesHave then
					TriggerEvent('skinchanger:getSkin', function(skin)
						if skin.sex == 0 then
						  TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 43,  ['bproof_2'] = 1})
						elseif skin.sex == 1 then
						  TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 37,  ['bproof_2'] = 1,})
						end
					end)
					SetPedArmour(PlayerPedId(), 50)
					ESX.ShowNotification("~h~Shoma ba movafaghiat ~g~Armor ~w~use kardid!")
				else
					ESX.ShowNotification("~h~Shoma armor nadarid!")
				end
			end)

		elseif status then
		  ClearPedTasksImmediately(PlayerPedId())
		end

	end)

end)

RegisterNetEvent('esx_customItems:useSianor')
AddEventHandler('esx_customItems:useSianor', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "Sianor",
		duration = 4500,
		label = "Dar hale Sinaor Khordan",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "",
            anim = "",
        }
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSianor', function(bool)
			if bool then
			SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, 0)
			SetEntityHealth(PlayerPedId(), 0)
			Citizen.Wait (2700)
			SetEntityHealth(PlayerPedId(), 0)
			ESX.ShowNotification("~HUD_COLOUR_RADAR_DAMAGE~Shoma ~y~<C>Sianor</C> ~HUD_COLOUR_RADAR_DAMAGE~Masraf Kardid Va Mordid!")
			end
		end)
			elseif status then
			ESX.ShowNotification("~g~~h~Shoma Sianor Masraf Nakardid")
			ClearPedTasksImmediately(PlayerPedId())
			end
	end)
end)

RegisterNetEvent('esx_customItems:useLSD')
AddEventHandler('esx_customItems:useLSD', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "LSD",
		duration = 4800,
		label = "Dar hale LSD Khordan",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "mp_suicide",
            anim = "pill",
        }
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeLSD', function(bool)
			if bool then

			ESX.ShowNotification("~HUD_COLOUR_RADAR_DAMAGE~Shoma ~y~<C>LSD</C> ~HUD_COLOUR_RADAR_DAMAGE~Masraf Kardid Va Mordid!")
			end
		end)
			elseif status then
			ESX.ShowNotification("~g~~h~Shoma LSD Masraf Nakardid")
			ClearPedTasksImmediately(PlayerPedId())
			end
	end)
end)

RegisterNetEvent('esx_customItems:useNoshab')
AddEventHandler('esx_customItems:useNoshab', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "Energy",
		duration = 4800,
		label = "Dar Hale Khordan Energyza",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "mp_player_intdrink",
            anim = "loop_bottle",
        },
		prop = {
            model = "prop_ecola_can",
        }
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeNoshab', function(bool)
			if bool then

			local health = GetEntityHealth(PlayerPedId())
			SetEntityHealth(PlayerPedId(), health + 20)

			ESX.ShowNotification("Shoma ~y~<C>Energyza</C>~s~ Masraf Kardid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Energyza Masraf Nakardid")
			ClearPedTasksImmediately(PlayerPedId())
			end
	end)
end)

RegisterNetEvent('esx_customItems:useSH')
AddEventHandler('esx_customItems:useSH', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "SH",
		duration = 30000,
		label = "Dar Hale Khordan Sandwich Hamberger",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSH', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Sandewich</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useSF')
AddEventHandler('esx_customItems:useSF', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "SF",
		duration = 30000,
		label = "Dar Hale Khordan Sandwich Felafel",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}

	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSF', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Sandewich</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useSS')
AddEventHandler('esx_customItems:useSS', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "SS",
		duration = 30000,
		label = "Dar Hale Khordan Sandwich Sosis",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}

	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSS', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Sandewich</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useSibp')
AddEventHandler('esx_customItems:useSibp', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "SP",
		duration = 30000,
		label = "Dar Hale Khordan Sib Zamini Sorkh Karde",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}

	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSibp', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Sib Zamini Sorkh Karde</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useSM')
AddEventHandler('esx_customItems:useSM', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "SM",
		duration = 30000,
		label = "Dar Hale Khordan Sandwich Morgh",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeSM', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Sandewich</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:usePMA')
AddEventHandler('esx_customItems:usePMA', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "PMA",
		duration = 30000,
		label = "Dar Hale Khordan Pitza Makhloot",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removePMA', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Pitza Makhloot</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			DestroyAllProps()
			ClearPedTasksImmediately(PlayerPedId())

			end
	end)
end)

RegisterNetEvent('esx_customItems:usePMO')
AddEventHandler('esx_customItems:usePMO', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "PMO",
		duration = 30000,
		label = "Dar Hale Khordan Pitza Morgh",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removePMO', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Pitza Morgh</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useKABAB')
AddEventHandler('esx_customItems:useKABAB', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "KABAB",
		duration = 30000,
		label = "Dar Hale Khordan Kabab Koobide",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeKABAB', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Kabab Khordid</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useJOJE')
AddEventHandler('esx_customItems:useJOJE', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "JOJE",
		duration = 30000,
		label = "Dar Hale Khordan Joje",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeJOJE', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Joje</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useMAHIGHEZEL')
AddEventHandler('esx_customItems:useMAHIGHEZEL', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "MAHIGHEZEL",
		duration = 30000,
		label = "Dar Hale Khordan Mahi Ghezelala",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeMAHIGHEZEL', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Mahi Ghezelala</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useMAHIHAMOOR')
AddEventHandler('esx_customItems:useMAHIHAMOOR', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "MAHIHAMOOR",
		duration = 30000,
		label = "Dar Hale Khordan Mahi Hamoor",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeMAHIHAMOOR', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Mahi Ghezelala</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useMAHIGOLIP')
AddEventHandler('esx_customItems:useMAHIGOLIP', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "MAHIGOLIP",
		duration = 30000,
		label = "Dar Hale Khordan MahiGoli",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeMAHIGOLIP', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>MahiGoli</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useUNAGIEELROLL')
AddEventHandler('esx_customItems:useUNAGIEELROLL', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "UNAGIEELROLL",
		duration = 30000,
		label = "Dar Hale Khordan Unagi Eel Roll",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeUNAGIEELROLL', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Unagi Eel Roll</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useEBITENROL')
AddEventHandler('esx_customItems:useEBITENROL', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "EBITENROL",
		duration = 30000,
		label = "Dar Hale Khordan Ebi Ten Rol",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeEBITENROL', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Ebi Ten Rol</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useDOGHGAZDAR')
AddEventHandler('esx_customItems:useDOGHGAZDAR', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "DOGHGAZDAR",
		duration = 30000,
		label = "Dar Hale Khordan Doogh Gaz Dar",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeDOGHGAZDAR', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Doogh Gaz Dar</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useDOGHBEDOONGAZ')
AddEventHandler('esx_customItems:useDOGHBEDOONGAZ', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "DOGHBEDOONGAZ",
		duration = 30000,
		label = "Dar Hale Khordan Doogh Bedoon Gaz",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeDOGHBEDOONGAZ', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Doogh Bedoon Gaz</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useDELESTER')
AddEventHandler('esx_customItems:useDELESTER', function()


		TriggerEvent("mythic_progbar:client:progress", {
		name = "DELESTER",
		duration = 30000,
		label = "Dar Hale Khordan Delester",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(status)

			if not status then
			ESX.TriggerServerCallback('esx_customItems:removeDELESTER', function(bool)
			if bool then

			ESX.ShowNotification("Shoma ~y~<C>Doogh Delester</C>~s~ Khordid")
			end
		end)
			elseif status then
			ESX.ShowNotification("~r~~h~Shoma Ghaza Ra Nakhordid!")
			ClearPedTasksImmediately(PlayerPedId())
			DestroyAllProps()
			end
	end)
end)

RegisterNetEvent('esx_customItems:useBlowtorch')
AddEventHandler('esx_customItems:useBlowtorch', function()
					local inventory = ESX.GetPlayerData().inventory
				local blowtorch = 0
					for i=1, #inventory, 1 do
					  if inventory[i].name == 'blowtorch' then
						blowtorch = inventory[i].count
					  end
					end


			local vehicle = ESX.Game.GetVehicleInDirection(4)
			if DoesEntityExist(vehicle) then
				local playerPed = PlayerPedId()

				CheckVehicle = true
				checkvehicle(vehicle)

				  TriggerServerEvent('esx_customItems:remove', "blowtorch")
                  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                  SetVehicleAlarm(vehicle, true)
                  StartVehicleAlarm(vehicle)
                  SetVehicleAlarmTimeLeft(vehicle, 40000)
                  TriggerEvent("mythic_progbar:client:progress", {
                    name = "hijack_vehicle",
                    duration = 60000,
                    label = "LockPick kardan mashin",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }
				}, function(status)

                    if not status then

                      SetVehicleDoorsLocked(vehicle, 1)
                      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                      ClearPedTasksImmediately(playerPed)

					  ESX.ShowNotification("Mashin baz shod")
					  CheckVehicle = false
                    elseif status then
					  ClearPedTasksImmediately(playerPed)
					  CheckVehicle = false
					end

                end)

           else
            ESX.ShowNotification("Hich mashini nazdik shoma nist")
          end

end)

RegisterNetEvent('esx_customItems:checkVehicleDistance')
AddEventHandler('esx_customItems:checkVehicleDistance', function(vehicle)

	CheckVehicle = true
	checkvehicle(vehicle)

end)

RegisterNetEvent('esx_customItems:checkVehicleStatus')
AddEventHandler('esx_customItems:checkVehicleStatus', function(status)

	CheckVehicle = status

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

function checkvehicle(vehicle)
	Citizen.CreateThread(function()
		while CheckVehicle do
		  Citizen.Wait(2000)

		  local coords = GetEntityCoords(PlayerPedId())
		  local NearVehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  4.0,  0,  71)
			if vehicle ~= NearVehicle then
				ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
				TriggerEvent("mythic_progbar:client:cancel")
				CheckVehicle = false
			end

		end
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






  ESX                  = nil
local IsAlreadyDrunk = false
local DrunkLevel     = -1

function Drunk(level, start)

  Citizen.CreateThread(function()

    local playerPed = PlayerPedId()

    if start then
      DoScreenFadeOut(800)
      Wait(1000)
    end

    if level == 0 then

      RequestAnimSet("move_m@drunk@slightlydrunk")

      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(1)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)

    elseif level == 1 then

      RequestAnimSet("move_m@drunk@moderatedrunk")

      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(1)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

    elseif level == 2 then

      RequestAnimSet("move_m@drunk@verydrunk")

      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(1)
      end

      SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

    end

    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedIsDrunk(playerPed, true)

    if start then
      DoScreenFadeIn(800)
    end

  end)

end

function Reality()

  Citizen.CreateThread(function()

    local playerPed = PlayerPedId()

    DoScreenFadeOut(800)
    Wait(1000)

    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)

    DoScreenFadeIn(800)

  end)

end

AddEventHandler('esx_status:loaded', function(status)

  TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5',
    function(status)
      if status.val > 0 then
        return false
      else
        return false
      end
    end,
    function(status)
      status.remove(1500)
    end
  )

	Citizen.CreateThread(function()

		while true do

			Wait(1000)

			TriggerEvent('esx_status:getStatus', 'drunk', function(status)

				if status.val > 0 then

          local start = true

          if IsAlreadyDrunk then
            start = false
          end

          local level = 0

          if status.val <= 250000 then
            level = 0
          elseif status.val <= 500000 then
            level = 1
          else
            level = 2
          end

          if level ~= DrunkLevel then
            Drunk(level, start)
          end

          IsAlreadyDrunk = true
          DrunkLevel     = level
				end

				if status.val == 0 then

          if IsAlreadyDrunk then
            Reality()
          end

          IsAlreadyDrunk = false
          DrunkLevel     = -1

				end

			end)

		end

	end)

end)

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()

  local playerPed = PlayerPedId()

  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Citizen.Wait(10000)
  ClearPedSecondaryTask(playerPed)

end)

