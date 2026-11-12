-- esx_menu_question (Unique UI, hardened client)
--
-- Key handling stays on this server's polling thread (essentialmode here has no
-- onKeyDown / isAnyUiOpen export). Fixes vs the previous client:
--   * menu_submit / menu_cancel / menu_change crashed when GetOpened() returned nil
--   * the key thread polled and posted to the NUI on EVERY Enter/Backspace/arrow press
--     even with no question open; it now sleeps unless a question menu is open
--   * closeMenu sent an undefined `data` variable

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	local Keys = {
		["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
		["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
		["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
		["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
		["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
		["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
		["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
		["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
		["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

	local GUI      = {}
	GUI.Time       = 0
	local MenuType = 'question'
	local Opened   = {}

	local openMenu = function(namespace, name, data)
		Opened[namespace .. '_' .. name] = true

		SetNuiFocus(true)
		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})
		SetNuiFocus(false)
	end

	local closeMenu = function(namespace, name)
		Opened[namespace .. '_' .. name] = nil

		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
		})
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		cb('OK')
		if type(data) ~= 'table' then return end

		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu ~= nil and menu.submit ~= nil then
			menu.submit(data, menu)
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
		if menu == nil then return end

		if type(data.elements) == 'table' then
			for i = 1, #data.elements, 1 do
				menu.setElement(i, 'value', data.elements[i].value)

				if data.elements[i].selected then
					menu.setElement(i, 'selected', true)
				else
					menu.setElement(i, 'selected', false)
				end
			end
		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end
	end)

	local function press(control, debounce)
		if IsControlPressed(0, Keys[control]) and GetLastInputMethod(2) and (GetGameTimer() - GUI.Time) > debounce then
			SendNUIMessage({
				action  = 'controlPressed',
				control = control
			})

			GUI.Time = GetGameTimer()
		end
	end

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)

			if next(Opened) ~= nil then
				press('ENTER', 150)
				press('BACKSPACE', 150)
				press('TOP', 200)
				press('DOWN', 200)
				press('LEFT', 150)
				press('RIGHT', 150)
			else
				Citizen.Wait(250)
			end
		end
	end)
end)
