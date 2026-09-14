-- ============================================================
-- combat_vdm_client.lua  (اسکریپت ضد VDM / کمبت‌مود / کاهش دمیج کاربر)
-- ============================================================
-- فیکس‌های اعمال‌شده نسبت به نسخه‌ی آپلودی:
-- 1) ESX.SetEntityHealth وجود نداشت → با نیتیو SetEntityHealth جایگزین شد.
-- 2) ESX.GetDistance وجود نداشت → با فاصله‌ی برداری (#) جایگزین شد.
-- 3) ESX.GetCoordsString وجود نداشت → یه تابع کمکی محلی نوشته شد.
-- 4) SUN.World (متعلق به خودِ Sunset) وجود نداشت → با world واقعی بازیکن
--    (از routing bucket، مثل چیزی که تو sun-streetlabel ساختیم) جایگزین شد.
-- 5) exports['sunset_utils']:addStress حذف شد (ریسورسش رو ندارید؛ منطق
--    combatTime خودش این حالت رو به‌درستی مدیریت می‌کنه).
-- 6) TriggerServerEvent('DiscordBot:ToDiscord', ...) با امضای واقعی هندلر
--    شما (۷ پارامتر: webhook, name, message, image, external, source, tts)
--    هماهنگ شد - قبلش چون Image پاس داده نمی‌شد، سمت سرور با خطای
--    "attempt to index a nil value" کرش می‌کرد.
-- 7) exports["input"]:Keyboard (منوی تنظیم دمیج اسلحه) به فایل جدای
--    weapondmg_client.lua منتقل شد و اونجا با lib.inputDialog جایگزین شد.
--
-- ⚠️ نکته‌ی مهم: ایونت 'medic:revive' که موقع مرگ با ماشین صدا زده میشه،
-- هیچ‌جای سرورتون listener نداره (حتی رو خودِ نسخه‌ی اصلی Sunset هم همینطور
-- بود). یعنی این خط عملاً هیچ کاری نمی‌کنه. جون بازیکن با SetEntityHealth
-- برمی‌گرده، ولی اگه essentialmode یا esx_uniquejobs/ambulance_job شما یه
-- state داخلی جدا برای "مرده/زنده" نگه می‌داره، ممکنه اون state درست
-- sync نشه. اگه بعد از تست متوجه شدید بازیکن با اینکه HP داره ولی هنوز رفتار
-- "مرده" داره، بگید تا دقیق پیداش کنم و درستش کنم.

local lasthp = 0
local lasthpDeath = 0
local sikh = false
local sikhDisable = false

local playerWorld = 0

local function GetCoordsString()
	local coords = GetEntityCoords(PlayerPedId())
	return string.format('X: %.2f, Y: %.2f, Z: %.2f', coords.x, coords.y, coords.z)
end

local function GetDistanceBetween(a, b)
	return #(a - b)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		lasthp = GetEntityHealth(PlayerPedId())
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while true do
		ESX.TriggerServerCallback('ScriptPack:getWorld', function(w)
			playerWorld = w or 0
		end)
		Citizen.Wait(2000)
	end
end)

local combatTime = 0
AddEventHandler('gameEventTriggered', function (name, data)
	if name == 'CEventNetworkEntityDamage' then
		local hash = data[7]
		local victim = data[1]
		local attacker = data[2]
		if hash == -1569615261 and data[1] == PlayerPedId() then
			local hp = GetEntityHealth(PlayerPedId())
			if hp < 130 then
				SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
				SetEntityHealth(PlayerPedId(), 120)
			else
				SetEntityHealth(PlayerPedId(), hp - 15)
			end
		end
		if (hash == `WEAPON_NIGHTSTICK` or hash == `WEAPON_BAT`) and data[1] == PlayerPedId() then
			local hp = GetEntityHealth(PlayerPedId())
			if hp < 125 then
				SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
				SetEntityHealth(PlayerPedId(), 115)
			else
				SetEntityHealth(PlayerPedId(), hp - 20)
			end
		end
		if hash == -1553120962 then
			if attacker == PlayerPedId() and GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
				local vehicle = GetVehiclePedIsIn(attacker)
				local plate = GetVehicleNumberPlateText(vehicle)
				if plate then
					local coords = GetCoordsString()
					local attackerid = NetworkGetPlayerIndexFromPed(attacker)
					local serverid = GetPlayerServerId(attackerid)
					local victimid = NetworkGetPlayerIndexFromPed(victim)
					local vehname = 'Not found'
					if DoesEntityExist(vehicle) then
						vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
					end
					TriggerServerEvent('DiscordBot:ToDiscord', 'vdm', 'VDM',
						'```css\nTarget : '.. GetPlayerServerId(victimid) .. ' Target name : '..  GetPlayerName(victimid) ..
						'\nAttacker : '.. serverid .. ' Attacker name : '.. GetPlayerName(attackerid) ..
						'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```',
						'system', true, GetPlayerServerId(attackerid), false)
				end
			elseif victim == PlayerPedId() and attacker ~= PlayerPedId() then
				if GetVehiclePedIsIn(attacker,true) == GetVehiclePedIsIn(PlayerPedId(),true) then
					return
				end
				if not sikh and not sikhDisable then
					sikh = true
					lasthpDeath = lasthp
					Citizen.Wait(4000)
					if not sikhDisable then
						SetEntityHealth(PlayerPedId(), lasthpDeath)
					end
					sikh = false
				end
			end
		end
		if data[2] == PlayerPedId() and GetEntityType(data[1]) == 2 and GetVehiclePedIsIn(PlayerPedId()) ~= data[1] then
			local vehicle = data[1]
			local vehname = 'Not found'
			local plate = GetVehicleNumberPlateText(vehicle)
			if DoesEntityExist(vehicle) then
				vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			end
			TriggerServerEvent('DiscordBot:ToDiscord', 'tirelog', 'Panchar kard',
				'```css\nID : '.. GetPlayerServerId(PlayerId()) .. ' Name : '..  GetPlayerName(PlayerId()) ..
				'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\nVehicle : '.. GetEntityCoords(vehicle) ..
				'\nPlayer : '.. GetEntityCoords(PlayerPedId()) ..'\nType : '.. tostring(data[13]) ..' \n```',
				'system', true, GetPlayerServerId(PlayerId()), false)
		end

		if GetEntityType(attacker) == 1 then
			local weapon = ESX.GetWeaponName(GetSelectedPedWeapon(attacker))
			if weapon ~= 'weapon_unarmed' and weapon ~= 'no_name' and not IsPedInAnyVehicle(attacker) then
				local coords = GetEntityCoords(PlayerPedId())
				local attackerCoords = GetEntityCoords(attacker)
				local victimCoords = GetEntityCoords(victim)
				if playerWorld == 0 and (GetDistanceBetween(coords,attackerCoords) < 80 or GetDistanceBetween(coords,victimCoords) < 80) then
					TriggerEvent('sscombat:toggle',true,3 * 60 * 1000)
					if combatTime == 0 then
						combatTime = 3 * 60
						Citizen.CreateThread(function()
							ESX.SetPlayerState('combat',true)
							while combatTime > 0 do
								combatTime = combatTime - 1
								Citizen.Wait(1000)
							end
							ESX.SetPlayerState('combat',false)
						end)
					else
						combatTime = 3 * 60
					end
				end
			end
		end
	elseif name == 'CEventNetworkPlayerEnteredVehicle' then
		Wait(500)
		if data[1] == PlayerId() then
			local vehicle = data[2]
			local plate = GetVehicleNumberPlateText(vehicle)
			if plate and GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then
				local coords = GetCoordsString()
				local vehname = 'Not found'
				if DoesEntityExist(vehicle) then
					vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				end
				TriggerServerEvent('DiscordBot:ToDiscord', 'entervehicle', 'ENTER',
					'```css\nID : '.. GetPlayerServerId(PlayerId()) .. ' name : '..  GetPlayerName(PlayerId()) ..
					'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```',
					'system', true, GetPlayerServerId(PlayerId()), false)
			end
		end
	end
end)


AddEventHandler('esx:onPlayerDeath',function(data)
	local injure = ESX.GetPlayerData().IsInjure
	if data.deathCause == -1553120962 and data.killedByPlayer and GetPlayerFromServerId(data.killerServerId) ~= PlayerId() then
		if data.killedByPlayer then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(data.killerServerId)))
			if DoesEntityExist(vehicle) then
				if vehicle == GetVehiclePedIsIn(PlayerPedId(),true) then
					return
				end
			end
			if DoesEntityExist(vehicle) then
				ESX.Game.DeleteVehicle(vehicle)
			end
		end
		if not injure then
			sikhDisable = true
			Citizen.Wait(4000)
			-- TriggerEvent('medic:revive', true) -- ⚠️ حذف شد چون هیچ listener نداشت (نگاه کن به توضیح بالای فایل)
			Citizen.Wait(3000)
			SetEntityHealth(PlayerPedId(), lasthpDeath)
			Citizen.Wait(2000)
			sikhDisable = false
		else
			sikhDisable = true
			Citizen.Wait(4000)
			-- TriggerEvent('medic:revive', true) -- ⚠️ حذف شد چون هیچ listener نداشت
			Citizen.Wait(3000)
			SetEntityHealth(PlayerPedId(), 0)
			Citizen.Wait(2000)
			sikhDisable = false
		end
	end
end)
