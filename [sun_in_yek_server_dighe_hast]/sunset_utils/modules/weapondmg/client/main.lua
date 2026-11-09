-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local lasthp = 0
local lasthpDeath = 0
local sikh = false
local sikhDisable = false
local weapons = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		lasthp = GetEntityHealth(PlayerPedId())
	end
end)

Citizen.CreateThread(function()
	waitForLoad()
	for k,v in pairs(ESX.GetWeaponList()) do
		if GetWeaponDamage(v.hash) > 0 then
			weapons[v.name] = {
				hash = v.hash,
				damage = GetWeaponDamage(v.hash)
			}
		end
	end
	Wait(5000)
	ESX.TriggerServerEvent('weapondmg:getList')
	Wait(5000)
	while GetWeaponDamage(`weapon_smg_mk2`) == 25 do
		Wait(5000)
		ESX.TriggerServerEvent('weapondmg:getList')
	end
end)

RegisterNetEvent('weapondmg:loadList',function(data)
	TriggerEvent('setWeaponDamage',data)
	Wait(5000)
	TriggerEvent('setWeaponDamage',data)
	for k,v in pairs(data) do
		SetWeaponDamageModifier(tonumber(k) and tonumber(k) or GetHashKey(k), v.damage + .0)
	end
end)

RegisterNetEvent('weapondmg:openMenu',function(data)
	local elements = {}
	table.insert(elements,{
		img = '',
		text = 'Add', 
		text2 = '', 
		callBack = function()
			exports.icon_menu:ForceCloseMenu()
			local keyboard, hash, value = exports["input"]:Keyboard({
				header = "Add", 
				rows = {"Name || Hash", "Value"}
			})
			if keyboard then
				if hash and value then
					hash = type(hash) == 'string' and hash:upper() or hash
					value = tonumber(value)
					local _value = {
						damage = ESX.Math.Round(weapons[hash] and (tonumber(value) / weapons[hash].damage) or value,3),
						value = value,
					}
					ESX.TriggerServerEvent('weapondmg:setDamage',hash,_value)
				end
			end
	end})
	for k,v in pairs(data) do
		table.insert(elements,{
			img = 'nui://sun-inventory-hud/ui/img/items/' .. k .. '.png',
			text = k .. ' = ' .. v.value, 
			text2 = '', 
			callBack = function()
				exports.icon_menu:ForceCloseMenu()
				local keyboard, value = exports["input"]:Keyboard({
					header = "Change damage", 
					rows = {"Value"}
				})
				if keyboard then
					if value then
						value = tonumber(value)
						local _value = {
							damage = ESX.Math.Round(weapons[k] and (tonumber(value) / weapons[k].damage) or value,3),
							value = value,
						}
						ESX.TriggerServerEvent('weapondmg:setDamage',k,_value)
					end
				end
		end})
	end
	exports.icon_menu:OpenMenu(elements)
end)



local combatTime = 0
local damageList = {}
AddEventHandler('gameEventTriggered', function (name, data)
	if not ESX then return end
	if name == 'CEventNetworkEntityDamage' then
		local hash = data[7]
		local victim = data[1]
		local attacker = data[2]
		local ped = PlayerPedId()

		if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
            if ped == attacker then
                if ped ~= victim then
                    local _, boneIndex = GetPedLastDamageBone(victim)
                    if boneIndex and (boneIndex == 31086 or boneIndex == 39317) then
                        exports['xsound']:PlayUrl('headshot', './sounds/headshot.mp3', 0.1)
                    else
                        exports['xsound']:PlayUrl('hit', './sounds/hit3.ogg', 0.1)
                    end
                end
            elseif ped == victim then
                local _, boneIndex = GetPedLastDamageBone(ped)
                if boneIndex and (boneIndex == 31086 or boneIndex == 39317) then
                    exports['xsound']:PlayUrl('headshot2', './sounds/headshot2.mp3', 0.2)
                end
            end
        end

		if hash == -1569615261 and data[1] == ped then
			local hp = GetEntityHealth(ped)
			if globalInBox then
				ESX.SetEntityHealth(ped, hp - 5)
			else
				if hp < 130 then
					SetPedToRagdoll(ped, 10000, 10000, 0, 0, 0, 0)
					ESX.SetEntityHealth(ped,120)
				else
					ESX.SetEntityHealth(ped,hp - 15)
				end
			end
		end
		if (hash == `WEAPON_NIGHTSTICK` or hash == `WEAPON_BAT`) and data[1] == ped then
			local hp = GetEntityHealth(ped)
			if hp < 125 then
				SetPedToRagdoll(ped, 10000, 10000, 0, 0, 0, 0)
				ESX.SetEntityHealth(ped,115)
			else
				ESX.SetEntityHealth(ped,hp - 20)
			end
		end
		if hash == -1553120962 then
			if attacker == ped and GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
				local vehicle = GetVehiclePedIsIn(attacker)
				local plate = GetVehicleNumberPlateText(vehicle)
				if plate then
					local coords = ESX.GetCoordsString()
					local attackerid = NetworkGetPlayerIndexFromPed(attacker)
					local serverid = GetPlayerServerId(attackerid)
					local victimid = NetworkGetPlayerIndexFromPed(victim)
					local vehname = 'Not found'
					if DoesEntityExist(vehicle) then 
						vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
					end
					TriggerServerEvent('DiscordBot:ToDiscord','vdm','VDM','```css\nTarget : '.. GetPlayerServerId(victimid) .. ' Target name : '..  GetPlayerName(victimid) ..'\nAttacker : '.. serverid .. ' Attacker name : '.. GetPlayerName(attackerid) .. '\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```')
				end
			elseif victim == ped and attacker ~= ped then
				if GetVehiclePedIsIn(attacker,true) == GetVehiclePedIsIn(ped,true) then
					return
				end
				if not sikh and not sikhDisable then
					sikh = true
					lasthpDeath = lasthp
					Citizen.Wait(4000)
					if not sikhDisable then
						ESX.SetEntityHealth(ped,lasthpDeath)
					end
					sikh = false
				end
			end
		end
		if data[2] == ped and GetEntityType(data[1]) == 2 and GetVehiclePedIsIn(ped) ~= data[1] then
			local vehicle = data[1]
			local vehname = 'Not found'
			local plate = GetVehicleNumberPlateText(vehicle)
			if DoesEntityExist(vehicle) then 
				vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			end
			TriggerServerEvent('DiscordBot:ToDiscord','tirelog','Panchar kard','```css\nID : '.. GetPlayerServerId(PlayerId()) .. ' Name : '..  GetPlayerName(PlayerId()) ..'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\nVehicle : '.. GetEntityCoords(vehicle) ..'\nPlayer : '.. GetEntityCoords(PlayerPedId()) ..'\nType : '.. data[13] ..' \n```')
		end

		if GetEntityType(attacker) == 1 then
			local weapon = ESX.GetWeaponName(GetSelectedPedWeapon(attacker))
			if weapon ~= 'weapon_unarmed' and weapon ~= 'no_name' and not IsPedInAnyVehicle(attacker) then
				local coords = GetEntityCoords(ped)
				local attackerCoords = GetEntityCoords(attacker)
				local victimCoords = GetEntityCoords(victim)
				if SUN.World == 0 and (ESX.GetDistance(coords,attackerCoords) < 80 or ESX.GetDistance(coords,victimCoords) < 80) then
					TriggerEvent('sscombat:toggle',true,3 * 60 * 1000)
					exports['sunset_utils']:addStress('combatmode_refresh')
					if combatTime == 0 then
						combatTime = 3 * 60
						Citizen.CreateThread(function()
							ESX.SetPlayerState('combat',true)
							while combatTime > 0 do
								--exports['TextUI']:Open('Combat time<br>'.. combatTime .. 's', 'lightred', 'left')
								combatTime = combatTime - 1
								Citizen.Wait(1000)
							end
							--exports['TextUI']:Close()
							ESX.SetPlayerState('combat',false)
						end)
					else
						combatTime = 3 * 60
					end
				end
			end
		end
		if victim == ped and GetEntityType(attacker) == 1 then
			local reason = 'none'
			local weapon = ESX.GetWeaponFromHash(hash)
			if weapon then
				reason = weapon.label
			else
				reason = hash
			end
			local attackerCoords, coords = GetEntityCoords(attacker), GetEntityCoords(ped)
			reason = ('%s | %s - %s'):format(reason, ESX.vec3ToString1(coords), ESX.vec3ToString1(attackerCoords))
			local player = NetworkGetPlayerIndexFromPed(attacker)
			table.insert(damageList, {attacker = GetPlayerServerId(player), reason = reason, player = player})
			if #damageList > 15 then
				table.remove(damageList, 1)
			end
			-- if #(coords - attackerCoords) > 150 then
			-- 	ESX.TriggerServerEvent('suncore:lokomotiveAzam',  GetPlayerServerId(NetworkGetPlayerIndexFromPed(attacker)), #(coords - attackerCoords), weapon)
			-- end
		end
	end
end)

AddEventHandler('enterVehicle', function(vehicle, bDriver)
	if bDriver then
		local vehicle = vehicle
		local plate = GetVehicleNumberPlateText(vehicle)
		if plate then
			local coords = ESX.GetCoordsString()
			local vehname = 'Not found'
			if DoesEntityExist(vehicle) then 
				vehname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			end
			TriggerServerEvent('DiscordBot:ToDiscord','entervehicle','ENTER','```css\nID : '.. ESX.src .. ' name : '..  GetPlayerName(PlayerId()) ..'\nPlate : '.. plate ..'\nVehicle name : '.. vehname ..'\n'..coords..'\n```')
		end
	end
end)

RegisterNetEvent('damageLogSend', function(admin)
	TriggerServerEvent('damageLogSendSV', admin, damageList)
end)

local decorlist = {
	"PD",
	"SF",
	"MT",
	"MD",
}

AddEventHandler('esx:onPlayerDeath',function(data)
	local injure = ESX.GetPlayerData().IsInjure
	if data.deathCause == -1553120962 and data.killedByPlayer and GetPlayerFromServerId(data.killerServerId) ~= PlayerId() then
		if data.killedByPlayer then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(data.killerServerId)))
			if DoesEntityExist(vehicle) then
				local vehicleType = GetVehicleType(vehicle)
				if vehicle == GetVehiclePedIsIn(PlayerPedId(),true) or (vehicleType == 'heli' or vehicleType == 'plane') then
					return
				end
			end
			if DoesEntityExist(vehicle) then
				local job = exports['esx_vehiclecontrol']:getVehicleJob(vehicle)
				if not job or not ESX.tableFind(decorlist, job) then
					ESX.Game.DeleteVehicle(vehicle)
					TriggerServerEvent('damage:deleteWarn', data.killerServerId)
				end
			end
		end
		if not injure then
			sikhDisable = true
			Citizen.Wait(4000)
			TriggerEvent('medic:revive', true)
			Citizen.Wait(3000)
			ESX.SetEntityHealth(PlayerPedId(),lasthpDeath)
			Citizen.Wait(2000)
			sikhDisable = false
		else
			sikhDisable = true
			Citizen.Wait(4000)
			TriggerEvent('medic:revive', true)
			Citizen.Wait(3000)
			ESX.SetEntityHealth(PlayerPedId(),0)
			Citizen.Wait(2000)
			sikhDisable = false
		end
	end
end)

exports('getLastDamageId', function()
	if damageList[1] then
		return damageList[#damageList].player
	end
end)