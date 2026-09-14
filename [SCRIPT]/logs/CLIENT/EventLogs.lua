-- ============================================================================
-- ✅ اضافه شد: Export هایی برای وصل‌شدن به ریسورس‌های دیگه
-- ============================================================================
-- لاک‌پیک‌کردن و دستبند معمولاً تو ریسورس‌های دیگه (مینی‌گیم لاک‌پیک، سیستم پلیس)
-- پیاده‌سازی می‌شن، نه اینجا. این ریسورس فقط "لاگ‌کننده"‌ست، پس به‌جای اینکه بخوایم
-- خودمون حدس بزنیم پلیر کِی داره لاک‌پیک می‌کنه، یه export ساده می‌ذاریم که هر
-- ریسورس دیگه‌ای صداش بزنه:
--
--   exports['logs']:ReportLockpick(vehicle, true)   -- بعد از موفق‌شدن مینی‌گیم
--   exports['logs']:ReportLockpick(vehicle, false)  -- بعد از شکست مینی‌گیم
--   exports['logs']:ReportCuffEscape()               -- وقتی سیستم دستبند فرارِ بدون آزادسازی رسمی رو تشخیص داد
exports('ReportLockpick', function(vehicle, success)
	if not vehicle or not DoesEntityExist(vehicle) then return end
	local plate = GetVehicleNumberPlateText(vehicle)
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	TriggerServerEvent('EventLogs:Lockpick', plate, model, success and true or false)
end)

exports('ReportCuffEscape', function()
	TriggerServerEvent('EventLogs:CuffEscape', GetEntityCoords(PlayerPedId()))
end)

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
		local jacking = IsPedJacking(ped)

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

-- ============================================================================
-- ✅ اضافه شد: ورود مشکوک به ماشین (سوارشدن به ماشینی که چند ثانیه‌ی قبل قفل بوده)
-- ============================================================================
-- محدودیت صادقانه: این thread فقط می‌فهمه ماشین «قفل بوده و الان یکی توش نشسته»،
-- نمی‌تونه دقیقاً بفهمه *چطور* باز شده (لاک‌پیک واقعی رو ریسورس دیگه با
-- exports('ReportLockpick', ...) جدا گزارش می‌ده). اینجا بیشتر یه لاگِ «این ماشینِ
-- قفل ناگهان یه‌نفر توش نشسته» هست، برای رهگیری دستیِ ادمین.
Citizen.CreateThread(function()
	local recentlyLocked = {}
	local reportedEntry = {}

	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		-- وضعیت قفل ماشین‌های اطراف رو ثبت می‌کنیم (برای پرفورمنس فقط نزدیک‌ها)
		for _, veh in ipairs(GetGamePool('CVehicle')) do
			if DoesEntityExist(veh) then
				local vCoords = GetEntityCoords(veh)
				if #(coords - vCoords) < 20.0 then
					local lockStatus = GetVehicleDoorLockStatus(veh)
					if lockStatus and lockStatus >= 2 then
						recentlyLocked[veh] = GetGameTimer()
					end
					if not DoesEntityExist(veh) then
						recentlyLocked[veh] = nil
						reportedEntry[veh] = nil
					end
				end
			end
		end

		local vehicle = GetVehiclePedIsIn(ped, false)
		if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and not reportedEntry[vehicle] then
			local lockedAt = recentlyLocked[vehicle]
			if lockedAt and (GetGameTimer() - lockedAt) < 6000 then
				reportedEntry[vehicle] = true
				local plate = GetVehicleNumberPlateText(vehicle)
				local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
				TriggerServerEvent('EventLogs:VehicleEntry', plate, model, GetEntityCoords(vehicle))
			end
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد: پنچرشدن لاستیک ماشینی که پلیر رانندگیش می‌کنه
-- ============================================================================
Citizen.CreateThread(function()
	local lastVeh = 0
	local burstState = {}

	while true do
		Citizen.Wait(250)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
			if vehicle ~= lastVeh then
				lastVeh = vehicle
				burstState = {}
			end

			for wheelIndex = 0, 7 do
				if IsVehicleTyreBurst(vehicle, wheelIndex, false) and not burstState[wheelIndex] then
					burstState[wheelIndex] = true
					local plate = GetVehicleNumberPlateText(vehicle)
					local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
					TriggerServerEvent('EventLogs:TireBurst', plate, model, wheelIndex, GetEntityCoords(vehicle))
				end
			end
		else
			lastVeh = 0
			burstState = {}
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد: سقوط شدید (بیس‌جامپ بدون چتر، پرش از بلندی و غیره)
-- ============================================================================
Citizen.CreateThread(function()
	local fallStartZ = nil
	local healthBeforeFall = nil

	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		local falling = IsPedFalling(ped)

		if falling and not fallStartZ then
			fallStartZ = GetEntityCoords(ped).z
			healthBeforeFall = GetEntityHealth(ped)
		elseif not falling and fallStartZ then
			Citizen.Wait(300) -- بذاریم دمیج سقوط واقعاً اعمال بشه
			local nowPed = PlayerPedId()
			local fallHeight = fallStartZ - GetEntityCoords(nowPed).z
			local hpLost = (healthBeforeFall or GetEntityHealth(nowPed)) - GetEntityHealth(nowPed)

			if fallHeight > 15.0 and hpLost > 20 and not IsEntityDead(nowPed) then
				TriggerServerEvent('EventLogs:HardFall', math.floor(fallHeight), hpLost, GetEntityCoords(nowPed))
			end

			fallStartZ = nil
			healthBeforeFall = nil
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد: گزارشِ بی‌تحرکیِ طولانی (AFK) — فقط لاگ، هیچ کیکی انجام نمی‌شه
-- ============================================================================
-- آستانه‌ی زمانی رو اینجا هاردکد کردیم (۱۵ دقیقه)؛ اگه می‌خوای از server.cfg
-- قابل‌تنظیم باشه، می‌تونی مثل بقیه‌ی Convar ها یکی به Config.lua اضافه کنی.
-- توجه: این هیچ‌وقت پلیر رو از سرور نمی‌ندازه بیرون؛ فقط برای اطلاع ادمین لاگ می‌شه.
local AFK_THRESHOLD_MS = 15 * 60 * 1000

Citizen.CreateThread(function()
	local lastActivityTime = GetGameTimer()
	local lastCoords = nil
	local alreadyReported = false
	local movementControls = { 30, 31, 32, 33, 34, 35, 22, 24, 25, 44, 75 }

	while true do
		Citizen.Wait(5000)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		local moved = (not lastCoords) or #(coords - lastCoords) > 1.0
		local inputDetected = false
		if not moved then
			for _, ctrl in ipairs(movementControls) do
				if IsControlPressed(0, ctrl) or IsDisabledControlPressed(0, ctrl) then
					inputDetected = true
					break
				end
			end
		end

		if moved or inputDetected then
			lastActivityTime = GetGameTimer()
			alreadyReported = false
		end
		lastCoords = coords

		if not alreadyReported and (GetGameTimer() - lastActivityTime) > AFK_THRESHOLD_MS then
			alreadyReported = true -- تا اطلاعیه‌ی تکراری برای همین دوره‌ی بی‌تحرکی نره
			local idleMinutes = math.floor((GetGameTimer() - lastActivityTime) / 60000)
			TriggerServerEvent('EventLogs:AFKKick', idleMinutes)
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد: ناهنجاری آنتی‌چیت (جابه‌جایی/سرعت غیرطبیعی - احتمال اسپیدهک/تله‌پورت‌هک)
-- ============================================================================
-- محدودیت صادقانه: این صرفاً یه هیوریستیک ساده‌ست، نه یه آنتی‌چیت واقعی. لگ سرور،
-- ری‌کانکت، یا تله‌پورت‌های رسمی خودِ اسکریپت‌ها (گاراژ، آپارتمان، اسپاون) می‌تونن
-- false-positive بدن؛ به همین خاطر فقط لاگ می‌کنه و هیچ اکشن خودکاری (کیک/بن) نمی‌زنه.
Citizen.CreateThread(function()
	local lastCoords = nil
	local lastCheckTime = GetGameTimer()

	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local now = GetGameTimer()

		if lastCoords and not IsEntityDead(ped) then
			local dist = #(coords - lastCoords)
			local seconds = (now - lastCheckTime) / 1000
			local vehicle = GetVehiclePedIsIn(ped, false)
			-- بافر بزرگ و آسون‌گیرانه برای هواپیما/ماشین سریع تا false-positive کم بشه
			local maxPossible = (vehicle ~= 0 and (140.0 * seconds)) or (12.0 * seconds)

			if dist > maxPossible and dist > 50.0 then
				local kind = (dist / math.max(seconds, 0.01) > 300) and 'Teleport' or 'Speed'
				TriggerServerEvent('EventLogs:AntiCheatAnomaly', kind, math.floor(dist), string.format('%.1f', seconds), lastCoords, coords)
			end
		end

		lastCoords = coords
		lastCheckTime = now
	end
end)

-- ============================================================================
-- ✅ اضافه شد (راند دوم): سیگنال‌های آنتی‌چیتِ مبتنی بر فلگ‌های موتور بازی
-- ============================================================================
-- این‌ها نسبت به تشخیص سرعت/تله‌پورت بالا قابل‌اعتمادتر هستن چون فلگ‌هایی مثل
-- «آسیب‌ناپذیری» یا max-health بالای پیش‌فرض تقریباً هیچ‌وقت به‌خودی‌خود توسط
-- اسکریپت‌های معمولی ESX ست نمی‌شن. با این‌حال اگه سرورت جاب/پرک خاصی داره که
-- سلامتی/زره پایه رو بالا می‌بره، حتماً Config.AntiCheatMaxHealth/MaxArmor رو
-- تو shared/Config.lua متناسبش کن تا false-positive نده.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local ped = PlayerPedId()
		if not IsEntityDead(ped) then
			local coords = GetEntityCoords(ped)

			-- ⚠️ فیکس باگ: IsPlayerInvincible رو بعضی بیلدهای سرور/آرتیفکت اصلاً ندارن
			-- (nil می‌مونه) و صداکردنش مستقیم باعث "attempt to call a nil value" و
			-- کرش کل این Thread می‌شد. الان اول وجودش رو چک می‌کنیم؛ اگه نبود، بی‌خیال
			-- این یه چک می‌شیم ولی بقیه‌ی چک‌های همین Thread (سلامتی/زره/نامرئی) ادامه پیدا می‌کنن.
			if type(IsPlayerInvincible) == 'function' then
				local ok, invincible = pcall(IsPlayerInvincible, PlayerId())
				if ok and invincible then
					TriggerServerEvent('EventLogs:AntiCheatFlag', 'GodMode', 'IsPlayerInvincible = true', coords)
				end
			end

			local maxHealth = GetEntityMaxHealth(ped)
			if maxHealth > (Config.AntiCheatMaxHealth or 200) then
				TriggerServerEvent('EventLogs:AntiCheatFlag', 'SuperHealth', 'MaxHealth = ' .. tostring(maxHealth), coords)
			end

			local armor = GetPedArmour(ped)
			if armor > (Config.AntiCheatMaxArmor or 100) then
				TriggerServerEvent('EventLogs:AntiCheatFlag', 'SuperArmor', 'Armour = ' .. tostring(armor), coords)
			end

			-- توجه: بعضی افکت‌های موقتِ کات‌سین/فید-اسکرین هم پلیر رو نامرئی می‌کنن؛
			-- برای کم‌کردن false-positive، فقط وقتی پلیر واقعاً کنترل داره (نه تو کات‌سین) چک می‌کنیم
			if not IsEntityVisible(ped) and IsPlayerControlOn(PlayerId()) and not IsScreenFadedOut() and not IsPauseMenuActive() then
				TriggerServerEvent('EventLogs:AntiCheatFlag', 'Invisible', 'IsEntityVisible = false', coords)
			end
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد (راند دوم): حمل اسلحه‌ی مسدود (طبق Config.IllegalWeapons)
-- ============================================================================
Citizen.CreateThread(function()
	local reportedWeapons = {}

	while true do
		Citizen.Wait(4000)
		local ped = PlayerPedId()

		for _, weaponName in ipairs(Config.IllegalWeapons or {}) do
			local weaponHash = GetHashKey(weaponName)
			if HasPedGotWeapon(ped, weaponHash, false) then
				if not reportedWeapons[weaponName] then
					reportedWeapons[weaponName] = true
					TriggerServerEvent('EventLogs:IllegalWeapon', weaponName, GetEntityCoords(ped))
				end
			else
				reportedWeapons[weaponName] = nil -- اگه دیگه نداردش، دفعه‌ی بعد که دوباره گرفت، دوباره گزارش بشه
			end
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد (راند دوم): استفاده از اسلحه‌ی انفجاری + شلیک داخل سیف‌زون
-- ============================================================================
-- هر دو با یه thread مشترک که وضعیت شلیک‌کردن رو پول می‌کنه (برای پرفورمنس یکی کافیه)
local ExplosiveWeapons = {
	[tostring(GetHashKey('WEAPON_GRENADE'))]          = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))]       = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_PIPEBOMB'))]         = 'Pipe Bomb',
	[tostring(GetHashKey('WEAPON_PROXMINE'))]         = 'Proximity Mine',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))]          = 'Molotov',
	[tostring(GetHashKey('WEAPON_RPG'))]              = 'RPG',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))]  = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))]   = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))]  = 'Compact Launcher',
}

Citizen.CreateThread(function()
	local explosiveCooldownUntil = 0
	local safezoneCooldownUntil = {}

	while true do
		Citizen.Wait(150)
		local ped = PlayerPedId()

		if IsPedShooting(ped) then
			local coords = GetEntityCoords(ped)
			local _, weaponHash = GetCurrentPedWeapon(ped, true)
			local weaponKey = tostring(weaponHash)

			-- استفاده از سلاح انفجاری (با کول‌داون ۵ ثانیه‌ای تا اسپم نده)
			if ExplosiveWeapons[weaponKey] and GetGameTimer() > explosiveCooldownUntil then
				explosiveCooldownUntil = GetGameTimer() + 5000
				TriggerServerEvent('EventLogs:ExplosiveUsed', ExplosiveWeapons[weaponKey], coords)
			end

			-- شلیک داخل سیف‌زون (هر زون کول‌داون جدای خودش رو داره)
			for _, zone in ipairs(Config.SafeZones or {}) do
				local zoneCoords = vector3(zone.x, zone.y, zone.z)
				if #(coords - zoneCoords) < (zone.radius or 50.0) then
					local until_ = safezoneCooldownUntil[zone.name] or 0
					if GetGameTimer() > until_ then
						safezoneCooldownUntil[zone.name] = GetGameTimer() + 5000
						TriggerServerEvent('EventLogs:SafezoneShot', zone.name, coords)
					end
				end
			end
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد (راند سوم): رانندگی خطرناک روی پیاده‌رو نزدیک NPC/پلیر پیاده
-- ============================================================================
-- محدودیت صادقانه: IsPointOnRoad همیشه ۱۰۰٪ دقیق نیست (بعضی میدون‌ها/پارکینگ‌ها رو
-- "روی جاده" حساب نمی‌کنه)، پس این یه هیوریستیکه نه تشخیص قطعی؛ برای همینم فقط لاگه.
Citizen.CreateThread(function()
	local cooldownUntil = 0

	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and GetGameTimer() > cooldownUntil then
			local speedKmh = GetEntitySpeed(vehicle) * 3.6
			if speedKmh > (Config.SidewalkDangerSpeedKmh or 50.0) then
				local coords = GetEntityCoords(vehicle)
				local onRoad = IsPointOnRoad(coords.x, coords.y, coords.z, vehicle)

				if not onRoad then
					local nearbyPedCount = 0
					for _, otherPed in ipairs(GetGamePool('CPed')) do
						if otherPed ~= ped and DoesEntityExist(otherPed) and not IsEntityDead(otherPed) and not IsPedInAnyVehicle(otherPed, false) then
							if #(coords - GetEntityCoords(otherPed)) < 8.0 then
								nearbyPedCount = nearbyPedCount + 1
							end
						end
					end

					if nearbyPedCount >= (Config.SidewalkDangerMinPeds or 2) then
						cooldownUntil = GetGameTimer() + 6000
						local plate = GetVehicleNumberPlateText(vehicle)
						local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
						TriggerServerEvent('EventLogs:SidewalkDanger', plate, model, math.floor(speedKmh), nearbyPedCount, coords)
					end
				end
			end
		end
	end
end)

-- ============================================================================
-- ✅ اضافه شد (راند سوم): پینگ دوره‌ای موقعیت برای تشخیص New Life Rule
-- ============================================================================
-- سبک و کم‌هزینه (هر ۲۰ ثانیه یه بار)؛ سرور خودش تصمیم می‌گیره که آیا این نزدیکیِ
-- محل مرگِ قبلیِ همین پلیر تو بازه‌ی زمانی مجازه یا نه.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		TriggerServerEvent('EventLogs:PositionPing', GetEntityCoords(PlayerPedId()))
	end
end)
