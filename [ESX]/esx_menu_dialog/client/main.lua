-- esx_menu_dialog (Unique UI, hardened client)
--
-- Fixes in this client:
--   * menu_submit/menu_cancel/menu_change crashed when GetOpened() returned nil
--     (menu closed while the NUI event was in flight) -> guarded
--   * the 200 ms "give focus" timer could fire AFTER the menu was closed and leave
--     the cursor stuck on screen -> only focuses if the menu is still open
--   * closeMenu sent an undefined `data` variable, `round` was a late global
--   * cursor stuck if the resource is restarted while a dialog is open

local ESX         = nil
local MenuType    = 'dialog'
local OpenedMenus = {}

local function round(x)
	return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

local function openedCount()
	local count = 0
	for _, v in pairs(OpenedMenus) do
		if v == true then count = count + 1 end
	end
	return count
end

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	local openMenu = function(namespace, name, data)
		local key = namespace .. '_' .. name
		OpenedMenus[key] = true

		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})

		Citizen.SetTimeout(200, function()
			if OpenedMenus[key] then
				SetNuiFocus(true, true)
			end
		end)
	end

	local closeMenu = function(namespace, name)
		OpenedMenus[namespace .. '_' .. name] = nil

		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
		})

		if openedCount() == 0 then
			SetNuiFocus(false, false)
		end
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		cb('OK')
		if type(data) ~= 'table' then return end

		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu == nil or menu.submit == nil then return end

		local post = true

		-- Is the submitted data a number?
		if tonumber(data.value) ~= nil then
			data.value = round(tonumber(data.value))

			-- Don't post if the value is negative or if it's 0
			if data.value <= 0 then
				post = false
			end
		end

		if post then
			menu.submit(data, menu)
		else
			ESX.ShowNotification('That input is invalid!')
		end
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		cb('OK')
		if type(data) ~= 'table' then return end

		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu ~= nil and menu.cancel ~= nil then
			menu.cancel(data, menu)
		end
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		cb('OK')
		if type(data) ~= 'table' then return end

		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu ~= nil and menu.change ~= nil then
			menu.change(data, menu)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)

			if openedCount() > 0 then
				DisableControlAction(0, 1,   true) -- LookLeftRight
				DisableControlAction(0, 2,   true) -- LookUpDown
				DisableControlAction(0, 142, true) -- MeleeAttackAlternate
				DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
				DisableControlAction(0, 12,  true) -- WeaponWheelUpDown
				DisableControlAction(0, 14,  true) -- WeaponWheelNext
				DisableControlAction(0, 15,  true) -- WeaponWheelPrev
				DisableControlAction(0, 16,  true) -- SelectNextWeapon
				DisableControlAction(0, 17,  true) -- SelectPrevWeapon
			else
				Citizen.Wait(250) -- was 1000: controls stayed enabled up to 1 s after a dialog opened
			end
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and openedCount() > 0 then
		SetNuiFocus(false, false)
	end
end)
