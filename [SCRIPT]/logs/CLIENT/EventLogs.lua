-- ============================================================================
-- انفجار ماشین (نه از تصادف؛ آتیش‌گرفتن/بمب/راکت و غیره)
-- ============================================================================
Citizen.CreateThread(function()
	local reportedExplosions = {}
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		-- فقط ماشین‌های نزدیک به خودمون رو چک می‌کنیم (برای پرفورمنس)
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 40.0, 0, 71)
		if vehicle ~= 0 and DoesEntityExist(vehicle) and not reportedExplosions[vehicle] then
			if IsEntityDead(vehicle) or GetVehicleEngineHealth(vehicle) <= 0 then
				-- بررسی می‌کنیم که آیا واقعاً "منفجر" شده (نه فقط خاموش/داغون با برخورد معمولی)
				if HasEntityBeenDamagedByAnyVehicle(vehicle) == false and IsEntityOnFire(vehicle) then
					reportedExplosions[vehicle] = true
					local plate = GetVehicleNumberPlateText(vehicle)
					local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
					local vCoords = GetEntityCoords(vehicle)
					TriggerServerEvent('EventLogs:VehicleExploded', plate, model, vCoords)
				end
			end
		end
	end
end)

local BoneNames = {
	[31086] = 'سر', [39317] = 'گردن',
	[24818] = 'قفسه سینه', [24817] = 'شکم',
	[45509] = 'بازوی چپ', [40269] = 'بازوی راست',
	[36864] = 'دست چپ', [57005] = 'دست راست',
	[68643] = 'پای چپ', [58271] = 'پای راست',
	[14201] = 'پای چپ (زانو)', [16335] = 'پای راست (زانو)',
}

AddEventHandler('gameEventTriggered', function(name, args)
	if name ~= 'CEventNetworkEntityDamage' then return end

	local victim = args[1]
	local attacker = args[2]
	local weaponDamage = args[4]
	local weapon = args[7]

	if victim ~= PlayerPedId() then return end
	if not weaponDamage then return end
	if not IsEntityAPed(attacker) then return end
	if IsPedInAnyVehicle(attacker, false) then return end -- زیرگرفتن جداگونه توسط combat_vdm پوشش داده میشه

	local attackerId = NetworkGetPlayerIndexFromPed(attacker)
	if attackerId == -1 or attackerId == PlayerId() then return end

	Citizen.CreateThread(function()
		Citizen.Wait(400)
		if IsEntityDead(PlayerPedId()) then return end -- مرد؟ لاگ کشتن جداگونه پوششش می‌ده

		local boneId = GetPedLastDamageBone(PlayerPedId())
		local boneName = BoneNames[boneId] or ('bone:' .. tostring(boneId))
		local attackerServerId = GetPlayerServerId(attackerId)
		local weaponName = (WeaponNames and WeaponNames[tostring(weapon)]) or tostring(weapon)

		TriggerServerEvent('EventLogs:NonLethalShot', attackerServerId, boneName, weaponName)
	end)
end)

-- ============================================================================
-- دزدیدن ماشین (jack کردن راننده)
-- ============================================================================
Citizen.CreateThread(function()
	local wasJacking = false

	while true do
		Citizen.Wait(150)
		local ped = PlayerPedId()
		local jacking = IsPedJackingVehicle(ped)

		if jacking and not wasJacking then
			local vehicle = GetVehiclePedIsTryingToEnter(ped)
			if vehicle ~= 0 then
				local driver = GetPedInVehicleSeat(vehicle, -1)
				if IsEntityAPed(driver) and IsPedAPlayer(driver) and driver ~= ped then
					local driverIndex = NetworkGetPlayerIndexFromPed(driver)
					if driverIndex ~= -1 then
						local plate = GetVehicleNumberPlateText(vehicle)
						local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
						TriggerServerEvent('EventLogs:CarJacked', GetPlayerServerId(driverIndex), plate, model)
					end
				end
			end
		end
		wasJacking = jacking
	end
end)

-- ============================================================================
-- تصادف شدید ماشین (افت ناگهانی سرعت)
-- ============================================================================
Citizen.CreateThread(function()
	local lastSpeed = 0
	local lastVeh = 0
	local cooldownUntil = 0

	while true do
		Citizen.Wait(200)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
			local speed = GetEntitySpeed(vehicle)

			if vehicle ~= lastVeh then
				lastSpeed = speed
				lastVeh = vehicle
			end

			if GetGameTimer() > cooldownUntil and lastSpeed > 13.9 and (lastSpeed - speed) > (lastSpeed * 0.6) then
				local plate = GetVehicleNumberPlateText(vehicle)
				local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
				local coords = GetEntityCoords(vehicle)
				local impactKmh = math.floor(lastSpeed * 3.6)

				TriggerServerEvent('EventLogs:VehicleCrash', plate, model, coords, impactKmh)
				cooldownUntil = GetGameTimer() + 4000
			end

			lastSpeed = speed
		else
			lastVeh = 0
			lastSpeed = 0
		end
	end
end)
