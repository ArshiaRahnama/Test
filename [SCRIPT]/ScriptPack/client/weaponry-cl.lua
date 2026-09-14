ESX = nil
local PlayerData = {}
local Stress = { Num = 0}
local licweapon = false
Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(50)
  	end
 	while ESX.GetPlayerData().job == nil do
	Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()










end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
local WhitelistJob = {
	["police"] = 'police',
	["sheriff"] = 'sheriff',
	["mt"] = 'mt',
	["fbi"] = 'fbi',
}

local scopedWeapons =
{
    100416529,
    205991906,
    3342088282,
	177293209,
	1785463520,
	3220176749,
	453432689,
	3219281620,
	1593441988,
	584646201,
	2578377531,
	324215364,
	736523883,
	2024373456,
	4024951519,
	3220176749,
	961495388,
	2210333304,
	4208062921,
	2937143193,
	2634544996,
	2144741730,
	3686625920,
	487013001,
	1432025498,
	2017895192,
	3800352039,
	2640438543,
	911657153,
	100416529,
	205991906,
	177293209,
	856002082,
	2726580491,
	1305664598,
	2982836145,
	1752584910,
	1119849093,
	3218215474,
	2009644972,
	1627465347,
	3231910285,
	1768145561,
	3523564046,
	2132975508,
	2066285827,
	137902532,
	1746263880,
	2828843422,
	984333226,
	3342088282,
	1785463520,
	1672152130,
	1198879012,
	171789620,
	3696079510,
  	1834241177,
	3675956304,
	3249783761,
	879347409,
	4019527611,
	1649403952,
	317205821,
	125959754,
	3173288789
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do
        if ( hash == v ) then
            return true
        end
    end

    return false
end

function ManageReticle()
    local ped = GetPlayerPed( -1 )
    local _, hash = GetCurrentPedWeapon( ped, true )
        if not HashInTable( hash ) then
            ShowHudComponentThisFrame( 0 )
		end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed( -1 )
		local weapon = GetSelectedPedWeapon(ped)




		ManageReticle(true)



		if IsPedArmed(ped, 6) then
        	DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end



		DisplayAmmoThisFrame(true)




		if weapon == GetHashKey("WEAPON_STUNGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
			end
		end

		if weapon == GetHashKey("WEAPON_FLAREGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
			end
		end

		if weapon == GetHashKey("WEAPON_SNSPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
			end
		end

		if weapon == GetHashKey("WEAPON_SNSPISTOL_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end

		if weapon == GetHashKey("WEAPON_PISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end

		if weapon == GetHashKey("WEAPON_PISTOL_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end

		if weapon == GetHashKey("WEAPON_APPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if weapon == GetHashKey("WEAPON_COMBATPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end

		if weapon == GetHashKey("WEAPON_PISTOL50") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if weapon == GetHashKey("WEAPON_HEAVYPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end

		if weapon == GetHashKey("WEAPON_VINTAGEPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end

		if weapon == GetHashKey("WEAPON_MARKSMANPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end

		if weapon == GetHashKey("WEAPON_REVOLVER") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end

		if weapon == GetHashKey("WEAPON_REVOLVER_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.055)
			end
		end

		if weapon == GetHashKey("WEAPON_DOUBLEACTION") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end


		if weapon == GetHashKey("WEAPON_MICROSMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end

		if weapon == GetHashKey("WEAPON_COMBATPDW") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end

		if weapon == GetHashKey("WEAPON_SMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end

		if weapon == GetHashKey("WEAPON_SMG_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.055)
			end
		end

		if weapon == GetHashKey("WEAPON_ASSAULTSMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.050)
			end
		end

		if weapon == GetHashKey("WEAPON_MACHINEPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end

		if weapon == GetHashKey("WEAPON_MINISMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end

		if weapon == GetHashKey("WEAPON_MG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end

		if weapon == GetHashKey("WEAPON_COMBATMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end

		if weapon == GetHashKey("WEAPON_COMBATMG_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.085)
			end
		end



		if weapon == GetHashKey("WEAPON_ASSAULTRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end

		if weapon == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.075)
			end
		end

		if weapon == GetHashKey("WEAPON_CARBINERIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end

		if weapon == GetHashKey("WEAPON_CARBINERIFLE_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.065)
			end
		end

		if weapon == GetHashKey("WEAPON_ADVANCEDRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end

		if weapon == GetHashKey("WEAPON_GUSENBERG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if weapon == GetHashKey("WEAPON_SPECIALCARBINE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end

		if weapon == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.075)
			end
		end

		if weapon == GetHashKey("WEAPON_BULLPUPRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if weapon == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.065)
			end
		end

		if weapon == GetHashKey("WEAPON_COMPACTRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end



		if weapon == GetHashKey("WEAPON_PUMPSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end

		if weapon == GetHashKey("WEAPON_PUMPSHOTGUN_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.085)
			end
		end

		if weapon == GetHashKey("WEAPON_SAWNOFFSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end

		if weapon == GetHashKey("WEAPON_ASSAULTSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.12)
			end
		end

		if weapon == GetHashKey("WEAPON_BULLPUPSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end

		if weapon == GetHashKey("WEAPON_DBSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if weapon == GetHashKey("WEAPON_AUTOSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end

		if weapon == GetHashKey("WEAPON_MUSKET") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.04)
			end
		end

		if weapon == GetHashKey("WEAPON_HEAVYSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.13)
			end
		end



		if weapon == GetHashKey("WEAPON_SNIPERRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
			end
		end

		if weapon == GetHashKey("WEAPON_HEAVYSNIPER") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
			end
		end

		if weapon == GetHashKey("WEAPON_HEAVYSNIPER_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.35)
			end
		end

		if weapon == GetHashKey("WEAPON_MARKSMANRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			end
		end

		if weapon == GetHashKey("WEAPON_MARKSMANRIFLE_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			end
		end



		if weapon == GetHashKey("WEAPON_GRENADELAUNCHER") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end

		if weapon == GetHashKey("WEAPON_RPG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.9)
			end
		end

		if weapon == GetHashKey("WEAPON_HOMINGLAUNCHER") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.9)
			end
		end

		if weapon == GetHashKey("WEAPON_MINIGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.20)
			end
		end

		if weapon == GetHashKey("WEAPON_RAILGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.0)

			end
		end

		if weapon == GetHashKey("WEAPON_COMPACTLAUNCHER") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end

		if weapon == GetHashKey("WEAPON_FIREWORK") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.5)
			end
		end



		if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then
			if IsPedShooting(ped) then
				SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
			end
		end
	end
end)

local recoils = {
	[453432689] = 0.3,
	[3219281620] = 0.3,
	[1593441988] = 0.2,
	[584646201] = 0.1,
	[2578377531] = 0.6,
	[324215364] = 0.2,
	[736523883] = 0.1,
	[2024373456] = 0.1,
	[4024951519] = 0.1,
	[3220176749] = 0.2,
	[961495388] = 0.2,
	[2210333304] = 0.1,
	[4208062921] = 0.1,
	[2937143193] = 0.1,
	[2634544996] = 0.1,
	[2144741730] = 0.1,
	[3686625920] = 0.1,
	[487013001] = 0.4,
	[1432025498] = 0.4,
	[2017895192] = 0.7,
	[3800352039] = 0.4,
	[2640438543] = 0.2,
	[911657153] = 0.1,
	[100416529] = 0.5,
	[205991906] = 0.7,
	[177293209] = 0.7,
	[856002082] = 1.2,
	[2726580491] = 1.0,
	[1305664598] = 1.0,
	[2982836145] = 0.0,
	[1752584910] = 0.0,
	[1119849093] = 0.01,
	[3218215474] = 0.2,
	[2009644972] = 0.25,
	[1627465347] = 0.1,
	[3231910285] = 0.2,
	[-1768145561] = 0.25,
	[3523564046] = 0.5,
	[2132975508] = 0.2,
	[-2066285827] = 0.25,
	[137902532] = 0.4,
	[-1746263880] = 0.4,
	[2828843422] = 0.7,
	[984333226] = 0.2,
	[3342088282] = 0.3,
	[1785463520] = 0.35,
	[1672152130] = 0,
	[1198879012] = 0.9,
	[171789620] = 0.2,
	[3696079510] = 0.9,
  	[1834241177] = 2.4,
	[3675956304] = 0.3,
	[3249783761] = 0.6,
	[-879347409] = 0.65,
	[4019527611] = 0.7,
	[1649403952] = 0.3,
	[317205821] = 0.2,
	[125959754] = 0.5,
	[3173288789] = 0.1,
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedShooting(PlayerPedId()) and not IsPedDoingDriveby(PlayerPedId()) then
			local _,wep = GetCurrentPedWeapon(PlayerPedId())
			_,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				repeat
					Wait(0)
					p = GetGameplayCamRelativePitch()
					if GetFollowPedCamViewMode() ~= 4 then
						SetGameplayCamRelativePitch(p+0.1, 0.2)
					end
					tv = tv+0.1
				until tv >= recoils[wep]
			end

		end
	end
end)
RegisterCommand('gethashweapon', function(source, args)
	print(GetHashKey(GetSelectedPedWeapon(PlayerPedId())))
end)