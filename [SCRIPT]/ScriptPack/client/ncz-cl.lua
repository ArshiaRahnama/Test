ESX = nil
local hasDysLicense = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	-- DYS permit check (see license_config.lua's 'dys' entry, bought at the
	-- Gun Shop - server/shop-sv.lua's gunshop_item:buy_permit). Fetched once
	-- here and kept in sync via license:update, which fires whenever the
	-- local player's own licenses change (bought, or added/revoked by
	-- staff) - see server/licensemenu-sv.lua.
	ESX.TriggerServerCallback('license:getData', function(_licenses)
		hasDysLicense = _licenses['dys'] ~= nil and not _licenses['dys'].expired
	end)
end)

RegisterNetEvent('license:update', function(_licenses)
	hasDysLicense = _licenses['dys'] ~= nil and not _licenses['dys'].expired
end)

-- Any suppressor component across the common weapon families (pistol and
-- rifle/SMG variants both exist in GTA V). HasPedGotWeaponComponent just
-- returns false for a component that doesn't fit the currently equipped
-- weapon, so checking all 4 against whatever's equipped is safe.
local SUPPRESSOR_COMPONENTS = {
	GetHashKey('COMPONENT_AT_PI_SUPP'),
	GetHashKey('COMPONENT_AT_PI_SUPP_02'),
	GetHashKey('COMPONENT_AT_AR_SUPP'),
	GetHashKey('COMPONENT_AT_AR_SUPP_02'),
}

local function HasSuppressorEquipped(ped, weaponHash)
	for i = 1, #SUPPRESSOR_COMPONENTS do
		if HasPedGotWeaponComponent(ped, weaponHash, SUPPRESSOR_COMPONENTS[i]) then
			return true
		end
	end
	return false
end

local blip = nil
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local zone = {
	["Police"] = {x=445.90,y=-981.98,z=30.69,radius = 60.0, color = 1},
	["PoliceVienwood"] = {x = 622.2464, y = -2.20517, z = 82.778,radius = 60.0, color = 1},
	["Paintball"] = {x=-1616.26,y=5119.084,z=52.651,radius = 100.0, color = 1},
	["ParkingMarkazi"] = {x=240.20,y=-790.68,z=30.57,radius = 70.0, color = 1},
	["ParkingMarkazi2"] = {x = 209.5102, y = -856.532, z = 30.422,radius = 70.0, color = 1},
	["Medic"] = {x = 290.7337, y = -588.029, z = 43.188,radius = 60.0, color = 1},
	["Sheriff1"] = {x=-471.02,y =5993.68,z =31.34,radius = 60.0, color = 1},
	["Mechanic"] = {x = -373.6, y = -121.83, z = 38.69,radius = 65.0, color = 1},
	["UWUCafe"] = {x = -579.787, y = -1061.68, z = 22.347,radius = 65.0, color = 1},
	["Sheriff2"] = {x = 1852.569, y = 3685.489, z = 34.286,radius = 50.0, color = 1},
}

local zoneMap = {
	["Base"] = {x = -115.583 , y = -919.272, z = 29.339, radius = 1500.0, color = 11},

}

local coords = {label = false,x=nil,y=nil,z=nil,radius=nil,name=nil}
local notifiedNoSuppressor = false
local notifiedNoDys = false
local inBaseZone = false
local hudShown = false

local WhitelistJobs = {
	 ["police"] = 'police',
	 ["sheriff"] = 'sheriff',
	 ["fbi"] = 'fbi',
	 ["mt"] = 'mt',
}

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )

	return result
end

function GetOnlineActive(Entity)
	for _, id in ipairs(GetActivePlayers()) do
		if(Vdist(GetEntityCoords(GetPlayerPed(id)),coords.x,coords.y,coords.z) <= coords.radius) then
			SetEntityNoCollisionEntity(GetPlayerPed(id),Entity,true)
		end
	end
end

-- Shows/hides the "You Are In NCZ" NUI badge. This used to be a separate
-- ncz_hud resource with its own export, but ScriptPack can only have ONE
-- ui_page (html/index.html), so it's now one more iframe inside that
-- existing shell (see html/index.html and html/ncz_hud/) - same pattern
-- already used here for headbag/babicz/changwinwood/synsit. That means this
-- is just a normal SendNUIMessage now, no export/cross-resource call needed.
local function UpdateHudVisibility()
	local shouldShow = coords.label or inBaseZone
	if shouldShow and not hudShown then
		hudShown = true
		SendNUIMessage({ action = 'enable' })
	elseif not shouldShow and hudShown then
		hudShown = false
		SendNUIMessage({ action = 'disable' })
	end
end

-- If a DYS holder kills another player, their permit is revoked immediately
-- (this is a client-side detection triggering a server-side delete - the
-- server event only ever deletes the CALLER's own 'dys' row, so there's
-- nothing to gain by forging it). args layout for CEventNetworkEntityDamage:
-- args[1] victim, args[2] attacker, args[4] isDead (1/0).
AddEventHandler('gameEventTriggered', function(name, args)
	if name ~= 'CEventNetworkEntityDamage' then return end
	if not hasDysLicense then return end

	local victim, attacker, isDead = args[1], args[2], args[4] == 1
	local playerPed = PlayerPedId()

	if isDead and attacker == playerPed and victim ~= playerPed and IsPedAPlayer(victim) then
		hasDysLicense = false
		TriggerServerEvent('license:dysKillRevoke')
		ESX.ShowNotification('~r~Mojaveze DYS shoma be dalile estefade baraye ghatl ~y~laghv~r~ shod!')
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local pedid = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local isWhitelisted = WhitelistJobs[PlayerData.job.name] ~= nil

		-------------------------------------------------------
		-- Small named NCZ zones (`zone` table) - UNCHANGED from your
		-- original: absolute no-fire for anyone not in WhitelistJobs. The
		-- DYS permit does NOT apply here, on purpose - it only applies to
		-- the big zoneMap.Base circle below.
		-------------------------------------------------------
		if not coords.label then
			for i, v in pairs(zone) do
				if Vdist(x, y, z, v.x, v.y, v.z) <= v.radius then
					coords.label = true
					coords.x, coords.y, coords.z, coords.radius, coords.name = v.x, v.y, v.z, v.radius, i

					if not isWhitelisted then
						ClearPlayerWantedLevel(PlayerId())
						SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
						DisablePlayerFiring(PlayerId(), true)
						TriggerServerEvent('EventLogs:NCZEnter', i)
					end

					SetPlayerInvincible(PlayerId(), true)
				end
			end
		end

		if coords.label then
			local currentWeapon = GetSelectedPedWeapon(playerPed)

			if not isWhitelisted then
				DisablePlayerFiring(PlayerId(), true)
				SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 25, true)

			else

				if currentWeapon == GetHashKey("WEAPON_STUNGUN") then
					DisablePlayerFiring(PlayerId(), false)
					EnableControlAction(0, 24, true)
				else
					DisablePlayerFiring(PlayerId(), true)
				end
			end

			if not (isWhitelisted and currentWeapon == GetHashKey("WEAPON_STUNGUN")) then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 106, true)
			end

			if Vdist(x, y, z, coords.x, coords.y, coords.z) >= coords.radius then
				coords.label = false
				coords.x, coords.y, coords.z, coords.radius, coords.name = nil, nil, nil, nil, nil
				NetworkSetFriendlyFireOption(true)
				DisableControlAction(2, 37, false)
				DisablePlayerFiring(PlayerId(), false)
				EnableControlAction(0, 24, true)
				DisableControlAction(0, 106, false)
				SetPlayerInvincible(PlayerId(), false)
				SetEntityAlpha(pedid, 255, false)
			end
		end

		-------------------------------------------------------
		-- Big circle (zoneMap.Base) - THIS is where the DYS permit
		-- matters. Reads zoneMap.Base.radius directly, so changing that
		-- number is all it takes to resize this zone. Skipped entirely
		-- while inside a small named zone above, since that one already
		-- has full, absolute control over firing.
		-------------------------------------------------------
		if not coords.label then
			local base = zoneMap.Base
			local inBaseNow = base and Vdist(x, y, z, base.x, base.y, base.z) <= base.radius

			if inBaseNow then
				if not inBaseZone then
					inBaseZone = true
					notifiedNoSuppressor = false
					notifiedNoDys = false
				end

				if not isWhitelisted then
					local currentWeapon = GetSelectedPedWeapon(playerPed)
					local hasDysAccess = hasDysLicense and HasSuppressorEquipped(playerPed, currentWeapon)

					if hasDysAccess then
						DisablePlayerFiring(PlayerId(), false)
					else
						DisablePlayerFiring(PlayerId(), true)
						DisableControlAction(0, 24, true)  -- Attack
						DisableControlAction(0, 257, true) -- Attack2

						if hasDysLicense then
							if not notifiedNoSuppressor then
								ESX.ShowNotification('~r~Baraye tirandazi dar in mantaghe bayad ~y~Silencer~r~ ru aslahetun dashte bashid')
								notifiedNoSuppressor = true
							end
						else
							if not notifiedNoDys then
								ESX.ShowNotification('~r~Shoma mojavez ~y~DYS~r~ nadarid')
								notifiedNoDys = true
							end
						end
					end
				end
			else
				if inBaseZone then
					inBaseZone = false
					notifiedNoSuppressor = false
					notifiedNoDys = false
					DisablePlayerFiring(PlayerId(), false)
				end
			end
		end

		UpdateHudVisibility()
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1)
	for k,v in pairs(zoneMap) do
		blip = AddBlipForRadius(v.x,v.y,v.z, v.radius)
		SetBlipSprite(blip, 9)
		SetBlipAlpha(blip, 90)
		SetBlipColour(blip, v.color)
	end
end)

local blips = {



}

Citizen.CreateThread(function()
  for _, info in pairs(blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.7)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end
end)