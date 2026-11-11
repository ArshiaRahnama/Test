-- esx_menu_list (Sunset-style UI, hardened client)
--
-- Two menu types share this resource and UI:
--   'list'  -> card grid  (esx_society / Unique_ALLGangs)
--   'list2' -> table      (Sunset's sun-list; head = {...}, rows = {{cols = {...}}})
--
-- Fixes vs the previous client: nil-menu guards (GetOpened returns nil when the menu
-- closed while the NUI event was in flight), cursor can no longer get stuck when the
-- 200 ms focus timer fires after the menu was closed, debug print() removed,
-- closeMenu no longer sends an undefined variable, cursor released on resource stop.

local ESX         = nil
local OpenedMenus = {}

local MenuTypes = {
	list  = 'cards',
	list2 = 'table',
}

local function openedCount()
	local count = 0
	for _, v in pairs(OpenedMenus) do
		if v == true then count = count + 1 end
	end
	return count
end

-- NUI only tells us namespace + name; look the menu up in every type we own
local function findMenu(data)
	if type(data) ~= 'table' then return nil end
	for menuType in pairs(MenuTypes) do
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)
		if menu ~= nil then return menu end
	end
	return nil
end

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	for menuType, mode in pairs(MenuTypes) do

		local openMenu = function(namespace, name, data)
			local key = menuType .. '_' .. namespace .. '_' .. name
			OpenedMenus[key] = true

			SendNUIMessage({
				action    = 'openMenu',
				mode      = mode,
				namespace = namespace,
				name      = name,
				data      = data,
			})

			ESX.SetTimeout(200, function()
				if OpenedMenus[key] then
					SetNuiFocus(true, true)
				end
			end)
		end

		local closeMenu = function(namespace, name)
			OpenedMenus[menuType .. '_' .. namespace .. '_' .. name] = nil

			SendNUIMessage({
				action    = 'closeMenu',
				namespace = namespace,
				name      = name,
			})

			if openedCount() == 0 then
				SetNuiFocus(false, false)
			end
		end

		ESX.UI.Menu.RegisterType(menuType, openMenu, closeMenu)
	end

	RegisterNUICallback('menu_submit', function(data, cb)
		cb('OK')
		local menu = findMenu(data)
		if menu ~= nil and menu.submit ~= nil then
			menu.submit(data, menu)
		end
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		cb('OK')
		local menu = findMenu(data)
		if menu ~= nil and menu.cancel ~= nil then
			menu.cancel(data, menu)
		end
	end)

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and openedCount() > 0 then
		SetNuiFocus(false, false)
	end
end)
