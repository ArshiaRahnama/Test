-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()

local barberColor = '#ff4d79'
local LastSkin    = nil
local isOpen      = false

local cam, camActive = nil, false
local camHeading, camDist, camZ = 90.0, 0.95, 0.62

local SECTIONS = {
	{ key = 'hair',     label = 'Hair',    icon = 'hair',     names = {'hair_1','hair_2','hair_color_1','hair_color_2'} },
	{ key = 'beard',    label = 'Beard',   icon = 'beard',    names = {'beard_1','beard_2','beard_3','beard_4'} },
	{ key = 'eyebrows', label = 'Brows',   icon = 'eyebrows', names = {'eyebrows_1','eyebrows_2','eyebrows_3','eyebrows_4'} },
	{ key = 'makeup',   label = 'Make-up', icon = 'makeup',   names = {'makeup_1','makeup_2','makeup_3','makeup_4'} },
	{ key = 'lipstick', label = 'Lips',    icon = 'lipstick', names = {'lipstick_1','lipstick_2','lipstick_3','lipstick_4'} },
}
local COLORCTL = { hair_color_1=true, hair_color_2=true, beard_3=true, beard_4=true, eyebrows_3=true, eyebrows_4=true, makeup_3=true, makeup_4=true, lipstick_3=true, lipstick_4=true }
local RANGECTL = { beard_2=true, eyebrows_2=true, makeup_2=true, lipstick_2=true }
local CTLLABEL = {
	hair_1='Style', hair_2='Texture', hair_color_1='Color', hair_color_2='Highlight',
	beard_1='Style', beard_2='Opacity', beard_3='Color', beard_4='Highlight',
	eyebrows_1='Style', eyebrows_2='Opacity', eyebrows_3='Color', eyebrows_4='Highlight',
	makeup_1='Style', makeup_2='Opacity', makeup_3='Color', makeup_4='Highlight',
	lipstick_1='Style', lipstick_2='Opacity', lipstick_3='Color', lipstick_4='Highlight',
	ears_1='Accessory', ears_2='Texture',
}

local function ctlType(name)
	if COLORCTL[name] then return 'color' end
	if RANGECTL[name] then return 'range' end
	return 'stepper'
end

local function buildSections()
	local sections, comps, maxVals, skin = {}, nil, nil, nil
	TriggerEvent('skinchanger:getData', function(c, m) comps = c; maxVals = m end)
	TriggerEvent('skinchanger:getSkin', function(s) skin = s end)
	if not comps then return sections end

	local byName = {}
	for i = 1, #comps do byName[comps[i].name] = comps[i] end

	for _, sec in ipairs(SECTIONS) do
		local controls = {}
		for _, name in ipairs(sec.names) do
			local comp = byName[name]
			if comp then
				local val = (skin and skin[name] ~= nil) and skin[name] or comp.value or comp.min or 0
				controls[#controls + 1] = {
					name  = name,
					label = CTLLABEL[name] or comp.label or name,
					type  = ctlType(name),
					value = val,
					min   = comp.min or 0,
					max   = (maxVals and maxVals[name]) or comp.max or 0,
				}
			end
		end
		if #controls > 0 then
			sections[#sections + 1] = { key = sec.key, label = sec.label, icon = sec.icon, controls = controls }
		end
	end
	return sections
end

local hairPalette = nil
local function getHairPalette()
	if hairPalette then return hairPalette end
	local pal, n = {}, GetNumHairColors() or 0
	if n <= 0 then n = 64 end
	for i = 0, n - 1 do
		local ok, r, g, b = pcall(GetHairRgbColor, i)
		pal[#pal + 1] = (ok and r ~= nil) and { r, g, b } or { 40, 40, 40 }
	end
	hairPalette = pal
	return pal
end

local function openCam()
	local ped = PlayerPedId()
	if not DoesCamExist(cam) then cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true) end
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)
	camActive = true
	camHeading, camDist, camZ = 90.0, 0.95, 0.62
	SetEntityHeading(ped, 0.0)
end

local function closeCam()
	camActive = false
	if cam then SetCamActive(cam, false) end
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

CreateThread(function()
	while true do
		if camActive and cam then
			local ped = PlayerPedId()
			local c   = GetEntityCoords(ped)
			local a   = camHeading * math.pi / 180.0
			SetCamCoord(cam, c.x + camDist * math.cos(a), c.y + camDist * math.sin(a), c.z + camZ)
			PointCamAtCoord(cam, c.x, c.y, c.z + camZ)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 1, true)
			DisableControlAction(0, 2, true)
			Wait(0)
		else
			Wait(300)
		end
	end
end)

function OpenShopMenu()
	if isOpen then return end
	TriggerEvent('skinchanger:getSkin', function(skin) LastSkin = ESX.CopyTable2(skin) end)
	local sections = buildSections()
	if #sections == 0 then return end
	isOpen = true
	openCam()
	SetNuiFocus(true, true)
	SendNUIMessage({ action = 'open', acc = barberColor, price = Config.Price, sections = sections, palette = getHairPalette() })
end

local function finishClose()
	isOpen = false
	SetNuiFocus(false, false)
	closeCam()
	SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('change', function(data, cb)
	TriggerEvent('skinchanger:change', data.name, data.value)
	if data.name == 'hair_1' then
		TriggerEvent('skinchanger:change', 'hair_2', 0)
		local maxTex = GetNumberOfPedTextureVariations(PlayerPedId(), 2, data.value) - 1
		if maxTex < 0 then maxTex = 0 end
		SendNUIMessage({ action = 'updateControl', name = 'hair_2', value = 0, max = maxTex })
	end
	cb('ok')
end)

RegisterNUICallback('section', function(data, cb)
	cb('ok')
end)

RegisterNUICallback('camera', function(data, cb)
	local d = data.dir
	if d == 'rotate-left' then camHeading = camHeading - 14.0
	elseif d == 'rotate-right' then camHeading = camHeading + 14.0
	elseif d == 'zoom-in' then camDist = math.max(0.55, camDist - 0.12)
	elseif d == 'zoom-out' then camDist = math.min(1.7, camDist + 0.12) end
	cb('ok')
end)

RegisterNUICallback('cancel', function(data, cb)
	if LastSkin then TriggerEvent('skinchanger:loadSkin', LastSkin) end
	finishClose()
	cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
	ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
		if hasEnoughMoney then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerServerEvent('esx_skin:save', skin)
			end)
			TriggerServerEvent('esx_barbershop:pay')
			ESX.ShowNotification('~g~Taghirat zabt shod')
		else
			if LastSkin then TriggerEvent('skinchanger:loadSkin', LastSkin) end
			ESX.ShowNotification(_U('not_enough_money'))
		end
		finishClose()
	end)
	cb('ok')
end)

AddEventHandler('sun_menu:settings', function(s)
	if type(s) == 'table' and s.barber and s.barber.color then
		barberColor = s.barber.color
		if isOpen then SendNUIMessage({ action = 'setColor', acc = barberColor }) end
	end
end)

-- Create Blips + interaction
Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1000)
	end
	for i = 1, #Config.Shops, 1 do

		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 50)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('barber_blip'))
		EndTextCommandSetBlipName(blip)

		ESX.RegisterPoint(vector3(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z), 2, {
			Color = {R = 255, G = 102, B = 204, A = 255},
			DrawDistance = 5,
			Radius = 0.5,
			Type = 0,
			world = 0,
		}, {
			Notification = nil,
			DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu',
			DrawTextRadius = 4,
			DrawTextCoords = vector3(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z + 1),
			Key = 'e',
			CB = function()
				OpenShopMenu()
			end,
		}, {
			In  = nil,
			Out = function()
				if isOpen then
					if LastSkin then TriggerEvent('skinchanger:loadSkin', LastSkin) end
					finishClose()
				end
			end
		})
	end
end)
