ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

-- ============================================================================
-- گرفتن خطاهای اجراییِ کلاینت (مثل سرور، محدودیت مشابه هست: FiveM هوک
-- عمومی برای همه‌ی خطاهای F8 نمی‌ده، پس بهترین معادل عملی همون pcall دور
-- کدهای حساسه که خودمون یا هر ریسورس دیگه‌ای می‌تونه ازش استفاده کنه.
-- ============================================================================
local ClientErrorCooldown = {}

function SafeCall(context, fn, ...)
	local args = {...}
	local ok, err = pcall(function() return fn(table.unpack(args)) end)
	if not ok then
		print(('^1[CLIENT ERROR]^0 [%s] %s'):format(tostring(context), tostring(err)))

		local key = tostring(context) .. '|' .. tostring(err)
		local now = GetGameTimer()
		if not ClientErrorCooldown[key] or (now - ClientErrorCooldown[key]) > 10000 then
			ClientErrorCooldown[key] = now
			TriggerServerEvent('EventLogs:ClientError', tostring(context), tostring(err))
		end
	end
	return ok, err
end

function SafeWrap(context, fn)
	return function(...)
		SafeCall(context, fn, ...)
	end
end

Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon

	while true do
		Citizen.Wait(1)

		if IsEntityDead(PlayerPedId()) then
			Citizen.Wait(500)
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			Weapon = WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end

			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				if IsMelee(DeathCauseHash) then
					DeathReason = 'murdered'
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'torched'
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'knifed'
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'pistoled'
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'riddled'
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'rifled'
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'machine gunned'
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'pulverized'
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'sniped'
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'obliterated'
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'shredded'
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'bombed'
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'mowed over'
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'flattened'
				else
					DeathReason = 'killed'
				end
			end

			if DeathReason == 'committed suicide' or DeathReason == 'died' then
				TriggerServerEvent('DiscordBot:plascaryyerDied', GetPlayerName(PlayerId()) .. ' ' .. DeathReason .. '.', Weapon)
			else
				Wait(3000)
				print(GetEntityHealth(PlayerPedId()))
				if GetEntityHealth(PlayerPedId()) == 0 then
					DeathReason = 'Finish'
				else
					DeathReason = 'Kill'
				end

				TriggerServerEvent('DiscordBot:plascaryyerDied', DeathReason, GetPlayerServerId(Killer), GetPlayerServerId(PlayerId()), Weapon, GetEntityCoords(GetPlayerPed(Killer)), GetEntityCoords(PlayerPedId()))
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(1)
		end
	end
end)

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local weapon = args[7]
        if victim == PlayerPedId() then
            local attackerId = NetworkGetPlayerIndexFromPed(attacker)
            if attackerId ~= -1 then
                local attackerServerId = GetPlayerServerId(attackerId)
                local coords = GetEntityCoords(PlayerPedId())
				local coordsatacer = GetEntityCoords(attacker)
                TriggerServerEvent("adminsys:storeLastDamage", attackerServerId, weapon, coords, coordsatacer)
            end
        end
    end
end)