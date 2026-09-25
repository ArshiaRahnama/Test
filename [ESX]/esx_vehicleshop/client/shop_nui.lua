-- Modern showroom - client side
-- Opens the new NUI, spawns the actual in-game vehicle the player is looking at
-- (the NUI itself has a transparent background - the "photo" is the real car),
-- orbits a camera around it, and runs test drives.

print('^2[esx_vehicleshop]^7 client/shop_nui.lua loaded - modern showroom UI is available')

local ShowroomOpen      = false
local PreviewVehicle     = nil
local PreviewCam         = nil
local CamHeading         = 0.0
local CamDistance        = 6.5
local CamAutoRotate      = true
local TestDriveActive    = false
local TestDriveVehicle   = nil
local TestDriveModel     = nil
local TestDriveTimeLeft  = 0

local function ClearPreviewVehicle()
	if PreviewVehicle and DoesEntityExist(PreviewVehicle) then
		ESX.Game.DeleteVehicle(PreviewVehicle)
	end
	PreviewVehicle = nil
end

local function StopPreviewCamera()
	if PreviewCam then
		RenderScriptCams(false, true, 300, true, true)
		DestroyCam(PreviewCam, false)
		PreviewCam = nil
	end
end

local function StartPreviewCamera(vehicle)
	StopPreviewCamera()

	local coords = GetEntityCoords(vehicle)
	CamHeading = GetEntityHeading(vehicle) + 180.0

	PreviewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetCamActive(PreviewCam, true)
	RenderScriptCams(true, true, 300, true, true)

	CreateThread(function()
		while PreviewCam and DoesCamExist(PreviewCam) and PreviewVehicle == vehicle and DoesEntityExist(vehicle) do
			Wait(0)

			if CamAutoRotate then
				CamHeading = CamHeading + 0.12
			end

			local vc  = GetEntityCoords(vehicle)
			local rad = math.rad(CamHeading)
			local camX = vc.x + CamDistance * math.cos(rad)
			local camY = vc.y + CamDistance * math.sin(rad)

			SetCamCoord(PreviewCam, camX, camY, vc.z + 1.3)
			PointCamAtCoord(PreviewCam, vc.x, vc.y, vc.z + 0.6)
		end
	end)
end

local function SpawnPreview(model)
	WaitForVehicleToLoad(model)

	local pos = Config.Zones.ShopInside.Pos
	ClearPreviewVehicle()

	ESX.Game.SpawnLocalVehicle(model, pos, Config.Zones.ShopInside.Heading, function(vehicle)
		PreviewVehicle = vehicle
		FreezeEntityPosition(vehicle, true)
		SetEntityInvincible(vehicle, true)
		SetVehicleDoorsLocked(vehicle, 2)
		SetModelAsNoLongerNeeded(model)
		StartPreviewCamera(vehicle)
	end)
end

-- ---------------------------------------------------------------------------
-- Opening / closing the showroom
-- ---------------------------------------------------------------------------

function OpenShopMenuNUI()
	if ShowroomOpen then return end

	ESX.TriggerServerCallback('esx_vehicleshop:getShowroomData', function(data)
		if not data then return end

		ShowroomOpen = true
		local playerPed = PlayerPedId()

		FreezeEntityPosition(playerPed, true)
		SetEntityVisible(playerPed, false)
		SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

		SetNuiFocus(true, true)
		SendNUIMessage({
			action        = 'open',
			categories    = data.categories,
			vehicles      = data.vehicles,
			cash          = data.cash,
			bank          = data.bank,
			ownedVehicles = data.ownedVehicles,
			config        = data.config,
			isGang        = ESX.PlayerData.gang ~= nil and ESX.PlayerData.gang.name ~= 'nogang',
		})
	end)
end

function CloseShopMenuNUI(resetPed)
	ShowroomOpen = false
	SetNuiFocus(false, false)
	StopPreviewCamera()
	ClearPreviewVehicle()
	SendNUIMessage({ action = 'close' })

	if resetPed ~= false then
		local playerPed = PlayerPedId()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
	end
end

RegisterNUICallback('close', function(_, cb)
	CloseShopMenuNUI(true)
	cb('ok')
end)

RegisterNUICallback('selectVehicle', function(data, cb)
	SpawnPreview(data.model)
	cb('ok')
end)

RegisterNUICallback('rotateCamera', function(data, cb)
	CamAutoRotate = false
	CamHeading = CamHeading + (tonumber(data.delta) or 0.0)
	cb('ok')
end)

RegisterNUICallback('toggleAutoRotate', function(data, cb)
	CamAutoRotate = data.enabled and true or false
	cb('ok')
end)

RegisterNUICallback('getQuote', function(data, cb)
	ESX.TriggerServerCallback('esx_vehicleshop:getQuote', function(quote, err)
		cb({ quote = quote, err = err })
	end, data.model, data.tradeInPlate)
end)

-- ---------------------------------------------------------------------------
-- Buying (cash or finance), reusing the same spawn/plate/own flow the original
-- script used - only the server-side money logic is new (server/shop_nui.lua).
-- ---------------------------------------------------------------------------

RegisterNUICallback('buyVehicle', function(data, cb)
	if not PreviewVehicle or not DoesEntityExist(PreviewVehicle) then
		cb({ ok = false })
		return
	end

	local model = data.model
	local playerPed = PlayerPedId()

	CloseShopMenuNUI(false)

	ESX.Game.SpawnVehicle(model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		local newPlate     = GeneratePlate()
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		SetVehicleNumberPlateText(vehicle, newPlate)

		TriggerServerEvent('esx_vehicleshop:completePurchase', vehicleProps, data.paymentMethod, data.tradeInPlate, data.buyForGang)

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
	end)

	cb({ ok = true })
end)

RegisterNetEvent('esx_vehicleshop:purchaseSucceeded')
AddEventHandler('esx_vehicleshop:purchaseSucceeded', function(quote, method)
	if method == 'finance' then
		ESX.ShowNotification(('ماشین %s خریداری شد (اقساطی). بقیه پول هر %s ساعت یک‌بار از حسابتون کسر می‌شه.'):format(quote.name, Config.Financing.PaymentIntervalHours))
	else
		ESX.ShowNotification(('ماشین %s خریداری شد. به سلامت برونید!'):format(quote.name))
	end
end)

RegisterNetEvent('esx_vehicleshop:purchaseFailed')
AddEventHandler('esx_vehicleshop:purchaseFailed', function(reason)
	local messages = {
		not_enough_money = 'پول کافی ندارید.',
		invalid_vehicle  = 'این ماشین در حال حاضر قابل خرید نیست.',
		no_gang          = 'شما عضو هیچ گروهی نیستید.',
	}
	ESX.ShowNotification(messages[reason] or 'خرید انجام نشد.')
end)

-- ---------------------------------------------------------------------------
-- Test drive
-- ---------------------------------------------------------------------------

local function EndTestDrive(reason)
	if not TestDriveActive then return end
	TestDriveActive = false

	local playerPed = PlayerPedId()

	if TestDriveVehicle and DoesEntityExist(TestDriveVehicle) then
		if IsPedInAnyVehicle(playerPed, false) then
			TaskLeaveVehicle(playerPed, TestDriveVehicle, 16)
			Wait(800)
		end
		ESX.Game.DeleteVehicle(TestDriveVehicle)
	end
	TestDriveVehicle = nil

	SendNUIMessage({ action = 'testDriveEnded' })

	local messages = {
		time_up  = 'زمان تست‌درایو تموم شد.',
		too_far  = 'از نمایشگاه خیلی دور شدید، تست‌درایو لغو شد.',
		manual   = 'تست‌درایو پایان یافت.',
	}
	ESX.ShowNotification(messages[reason] or messages.manual)

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

	if TestDriveModel then
		SpawnPreview(TestDriveModel)
		CamAutoRotate = true
	end
	TestDriveModel = nil

	ShowroomOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'reopen' })
end

RegisterNUICallback('startTestDrive', function(data, cb)
	if not Config.TestDrive.Enable or not PreviewVehicle or not DoesEntityExist(PreviewVehicle) then
		cb({ ok = false })
		return
	end

	local playerPed = PlayerPedId()

	StopPreviewCamera()
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'close' })
	ShowroomOpen = false

	TestDriveVehicle  = PreviewVehicle
	TestDriveModel    = data.model
	PreviewVehicle    = nil -- ownership moves from "preview" to "test drive" so CloseShopMenuNUI won't delete it
	TestDriveActive   = true
	TestDriveTimeLeft = Config.TestDrive.Duration

	SetEntityInvincible(TestDriveVehicle, false)
	FreezeEntityPosition(TestDriveVehicle, false)
	SetVehicleDoorsLocked(TestDriveVehicle, 1)
	FreezeEntityPosition(playerPed, false)
	SetEntityVisible(playerPed, true)
	TaskWarpPedIntoVehicle(playerPed, TestDriveVehicle, -1)

	CreateThread(function()
		while TestDriveActive and TestDriveTimeLeft > 0 do
			Wait(1000)
			TestDriveTimeLeft = TestDriveTimeLeft - 1
			SendNUIMessage({ action = 'testDriveTick', timeLeft = TestDriveTimeLeft })

			if TestDriveVehicle and DoesEntityExist(TestDriveVehicle) then
				local dist = #(GetEntityCoords(TestDriveVehicle) - vector3(Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z))
				if dist > Config.TestDrive.MaxDistance then
					EndTestDrive('too_far')
					return
				end
			else
				EndTestDrive('manual')
				return
			end
		end

		if TestDriveActive then
			EndTestDrive('time_up')
		end
	end)

	cb({ ok = true })
end)

CreateThread(function()
	while true do
		Wait(0)
		if TestDriveActive and IsControlJustReleased(0, Config.TestDrive.EndKey) then
			EndTestDrive('manual')
		end
	end
end)

-- ---------------------------------------------------------------------------
-- Live vehicle stats for the panel (top speed / acceleration / braking / seats)
-- ---------------------------------------------------------------------------

RegisterNUICallback('getStats', function(data, cb)
	local hash = GetHashKey(data.model)
	WaitForVehicleToLoad(hash)

	cb({
		topSpeed     = math.floor((GetVehicleModelMaxSpeed(hash) or 0.0) * 3.6), -- m/s -> km/h
		acceleration = math.floor((GetVehicleModelAcceleration(hash) or 0.0) * 100),
		braking      = math.floor((GetVehicleModelMaxBraking(hash) or 0.0) * 100),
		traction     = math.floor((GetVehicleModelMaxTraction(hash) or 0.0) * 100),
		seats        = GetVehicleModelNumberOfSeats(hash) or 2,
	})
end)
