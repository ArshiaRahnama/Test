-- Modern showroom - esx_heli client side
-- Same pattern as esx_vehicleshop/client/shop_nui.lua, trimmed down for a flat
-- (no-category) vehicle list and cash-only purchases.

print('^2[esx_heli]^7 client/showroom.lua loaded - modern showroom UI is available')

local ShowroomOpen     = false
local CurrentShop      = nil
local PreviewVehicle   = nil
local PreviewCam       = nil
local CamHeading       = 0.0
local CamDistance      = 10.0
local CamAutoRotate    = true
local TestDriveActive  = false
local TestDriveVehicle = nil
local TestDriveModel   = nil
local TestDriveTimeLeft = 0

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

	CamHeading = GetEntityHeading(vehicle) + 180.0
	PreviewCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetCamActive(PreviewCam, true)
	RenderScriptCams(true, true, 300, true, true)

	CreateThread(function()
		while PreviewCam and DoesCamExist(PreviewCam) and PreviewVehicle == vehicle and DoesEntityExist(vehicle) do
			Wait(0)
			if CamAutoRotate then CamHeading = CamHeading + 0.12 end

			local vc  = GetEntityCoords(vehicle)
			local rad = math.rad(CamHeading)
			SetCamCoord(PreviewCam, vc.x + CamDistance * math.cos(rad), vc.y + CamDistance * math.sin(rad), vc.z + 1.6)
			PointCamAtCoord(PreviewCam, vc.x, vc.y, vc.z + 0.7)
		end
	end)
end

local function SpawnPreview(model, shop)
	ESX.Game.SpawnLocalVehicle(model, shop.Inside, shop.Inside.w, function(vehicle)
		ClearPreviewVehicle()
		PreviewVehicle = vehicle
		FreezeEntityPosition(vehicle, true)
		SetEntityInvincible(vehicle, true)
		StartPreviewCamera(vehicle)
	end)
end

local function xPlayerCash() return ESX.PlayerData and ESX.PlayerData.money or 0 end
local function xPlayerBank()
	if not ESX.PlayerData or not ESX.PlayerData.accounts then return 0 end
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'bank' then return ESX.PlayerData.accounts[i].money end
	end
	return 0
end

function OpenAirShopNUI(shop)
	if ShowroomOpen then return end
	CurrentShop = shop

	ShowroomOpen = true
	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, shop.Inside.x, shop.Inside.y, shop.Inside.z)

	SetNuiFocus(true, true)
	SendNUIMessage({
		action    = 'open',
		shopTitle = 'نمایشگاه بالگرد',
		vehicles  = Config.Vehicles,
		cash      = xPlayerCash(),
		bank      = xPlayerBank(),
		config    = { testDrive = Config.TestDrive },
	})
end

function CloseAirShopNUI(resetPed)
	ShowroomOpen = false
	SetNuiFocus(false, false)
	StopPreviewCamera()
	ClearPreviewVehicle()
	SendNUIMessage({ action = 'close' })

	if resetPed ~= false and CurrentShop then
		local playerPed = PlayerPedId()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, CurrentShop.Outside.x, CurrentShop.Outside.y, CurrentShop.Outside.z)
	end
end

RegisterNUICallback('close', function(_, cb) CloseAirShopNUI(true); cb('ok') end)

RegisterNUICallback('selectVehicle', function(data, cb)
	SpawnPreview(data.model, CurrentShop)
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

RegisterNUICallback('getStats', function(data, cb)
	local hash = GetHashKey(data.model)
	RequestModel(hash)
	local tries = 0
	while not HasModelLoaded(hash) and tries < 200 do Wait(10); tries = tries + 1 end

	cb({
		topSpeed = math.floor((GetVehicleModelMaxSpeed(hash) or 0.0) * 3.6),
		seats    = GetVehicleModelNumberOfSeats(hash) or 4,
	})
end)

RegisterNUICallback('buyVehicle', function(data, cb)
	if not PreviewVehicle or not DoesEntityExist(PreviewVehicle) or not CurrentShop then
		cb({ ok = false })
		return
	end

	local model      = data.model
	local shop       = CurrentShop
	local playerPed  = PlayerPedId()

	CloseAirShopNUI(false)

	ESX.Game.SpawnVehicle(model, shop.Outside, GetEntityHeading(playerPed), function(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		local newPlate     = exports['esx_vehicleshop']:GeneratePlate()
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		SetVehicleNumberPlateText(vehicle, newPlate)

		TriggerServerEvent('esx_heli:completePurchase', vehicleProps)

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
	end)

	cb({ ok = true })
end)

RegisterNetEvent('esx_heli:purchaseSucceeded')
AddEventHandler('esx_heli:purchaseSucceeded', function(name, price)
	ESX.ShowNotification(('%s خریداری شد. ($%s)'):format(name, ESX.Math.GroupDigits(price)))
end)

RegisterNetEvent('esx_heli:purchaseFailed')
AddEventHandler('esx_heli:purchaseFailed', function(reason)
	local messages = { not_enough_money = 'پول کافی ندارید.', invalid_vehicle = 'این قایق در حال حاضر قابل خرید نیست.' }
	ESX.ShowNotification(messages[reason] or 'خرید انجام نشد.')
	TriggerEvent('esx:deleteVehicle')
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

	local messages = { time_up = 'زمان تست‌درایو تموم شد.', too_far = 'از نمایشگاه خیلی دور شدید.', manual = 'تست‌درایو پایان یافت.' }
	ESX.ShowNotification(messages[reason] or messages.manual)

	if not CurrentShop then return end

	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, CurrentShop.Inside.x, CurrentShop.Inside.y, CurrentShop.Inside.z)

	if TestDriveModel then
		SpawnPreview(TestDriveModel, CurrentShop)
		CamAutoRotate = true
	end
	TestDriveModel = nil

	ShowroomOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'reopen' })
end

RegisterNUICallback('startTestDrive', function(data, cb)
	if not Config.TestDrive.Enable or not PreviewVehicle or not DoesEntityExist(PreviewVehicle) or not CurrentShop then
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
	PreviewVehicle    = nil
	TestDriveActive   = true
	TestDriveTimeLeft = Config.TestDrive.Duration

	SetEntityInvincible(TestDriveVehicle, false)
	FreezeEntityPosition(playerPed, false)
	SetEntityVisible(playerPed, true)
	TaskWarpPedIntoVehicle(playerPed, TestDriveVehicle, -1)

	local shop = CurrentShop
	CreateThread(function()
		while TestDriveActive and TestDriveTimeLeft > 0 do
			Wait(1000)
			TestDriveTimeLeft = TestDriveTimeLeft - 1
			SendNUIMessage({ action = 'testDriveTick', timeLeft = TestDriveTimeLeft })

			if TestDriveVehicle and DoesEntityExist(TestDriveVehicle) then
				local dist = #(GetEntityCoords(TestDriveVehicle) - vector3(shop.Inside.x, shop.Inside.y, shop.Inside.z))
				if dist > Config.TestDrive.MaxDistance then
					EndTestDrive('too_far')
					return
				end
			else
				EndTestDrive('manual')
				return
			end
		end
		if TestDriveActive then EndTestDrive('time_up') end
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
