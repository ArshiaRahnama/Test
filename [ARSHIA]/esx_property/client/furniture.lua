-- ============================================================
--  esx_property PLUS — furniture placement
--  کاتالوگ خرید + جابجایی با کیبورد یا دکمه‌های NUI (طراحی از صفر)
-- ============================================================

local placedFurniture   = {}  -- [id] = handle   (آبجکت‌های اسپاون‌شده‌ی این خونه)
local placementActive   = false
local placementHandle   = nil
local placementModel    = nil
local placementScale    = 1.0
local placementId       = nil -- اگه نال باشه یعنی آیتم جدیده، وگرنه ویرایش یه آیتم موجوده
local placementProperty = nil
local cursorActive      = false

-- ---------------------------------------------------------
-- کاتالوگ خرید فرنیچر
-- ---------------------------------------------------------
function OpenFurnitureCatalogMenu(property, owner)
	local elements = {}

	for i = 1, #ConfigPlus.FurnitureCatalog, 1 do
		local item = ConfigPlus.FurnitureCatalog[i]
		table.insert(elements, {
			label = ('[%s] %s — %s$'):format(item.category, item.label, ESX.Math.GroupDigits(item.price)),
			value = i
		})
	end

	table.insert(elements, {label = '📋 مدیریت فرنیچرهای قرارگرفته', value = 'manage'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'furniture_catalog', {
		title    = property.label .. ' - فرنیچر',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'manage' then
			OpenFurnitureManageMenu(property)
		else
			TriggerServerEvent('esx_property:plus:buyFurniture', property.name, data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFurnitureManageMenu(property)
	ESX.TriggerServerCallback('esx_property:plus:getFurniture', function(rows)
		local elements = {}

		for i = 1, #rows, 1 do
			table.insert(elements, {label = ('#%s — %s'):format(rows[i].id, rows[i].model), value = rows[i]})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'furniture_manage', {
			title    = property.label .. ' - مدیریت',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'furniture_manage_actions', {
				title    = 'آیتم #' .. data.current.value.id,
				align    = 'left',
				elements = {
					{label = 'جابجا کردن', value = 'move'},
					{label = 'حذف کردن',   value = 'remove'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'move' then
					StartPlacement(property.name, data.current.value.model, data.current.value.id)
				elseif data2.current.value == 'remove' then
					local handle = placedFurniture[data.current.value.id]
					if handle and DoesEntityExist(handle) then
						DeleteEntity(handle)
					end
					TriggerServerEvent('esx_property:plus:removeFurniture', data.current.value.id)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, property.name)
end

-- ---------------------------------------------------------
-- شروع پلیسمنت (بعد از خرید موفق از سرور، یا ویرایش دستی)
-- ---------------------------------------------------------
RegisterNetEvent('esx_property:plus:startPlacement')
AddEventHandler('esx_property:plus:startPlacement', function(propertyName, model, catalogIndexOrId)
	StartPlacement(propertyName, model, nil)
end)

function StartPlacement(propertyName, model, existingId)
	if placementActive then return end

	local hash = GetHashKey(model)
	RequestModel(hash)
	local tries = 0
	while not HasModelLoaded(hash) and tries < 200 do
		Citizen.Wait(10)
		tries = tries + 1
	end

	if not HasModelLoaded(hash) then
		ESX.ShowNotification('مدل این فرنیچر لود نشد')
		return
	end

	local playerPed  = PlayerPedId()
	local pCoords    = GetEntityCoords(playerPed)
	local forward    = GetEntityForwardVector(playerPed)
	local spawnCoords = pCoords + forward * 1.5

	placementHandle   = CreateObject(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false)
	SetEntityCollision(placementHandle, false, false)
	SetEntityAlpha(placementHandle, 200, false)
	FreezeEntityPosition(placementHandle, true)

	placementActive   = true
	placementModel    = model
	placementScale    = 1.0
	placementId       = existingId
	placementProperty = propertyName
	cursorActive      = false

	SetNuiFocus(false, false)
	SendNUIMessage({action = 'show', label = model})

	Citizen.CreateThread(function()
		while placementActive do
			Citizen.Wait(0)
			HandlePlacementControls()
		end
	end)
end

-- ---------------------------------------------------------
-- توابع پایه‌ی جابجایی/چرخش/اسکیل — هم از کیبورد هم از دکمه‌های NUI صداشون می‌زنیم
-- ---------------------------------------------------------
local function MoveEntity(dx, dy, dz)
	if not DoesEntityExist(placementHandle) then return end
	local coords = GetEntityCoords(placementHandle)
	SetEntityCoords(placementHandle, coords.x + dx, coords.y + dy, coords.z + dz, false, false, false, false)
end

local function RotateEntity(deg)
	if not DoesEntityExist(placementHandle) then return end
	local heading = GetEntityHeading(placementHandle) + deg
	SetEntityHeading(placementHandle, heading)
	SetEntityRotation(placementHandle, 0.0, 0.0, heading, 2, true)
end

local function ScaleEntity(delta)
	placementScale = math.max(0.2, math.min(3.0, placementScale + delta))
	-- توجه: تغییر واقعی سایز آبجکت در GTA نیاز به SetObjectTextureVariation
	-- یا بازسازی anim scale داره؛ اینجا مقدار رو ذخیره می‌کنیم تا هنگام
	-- اسپاون دوباره (LoadFurnitureForProperty) به‌عنوان ضریب استفاده بشه.
	SendNUIMessage({action = 'update', scale = placementScale})
end

function HandlePlacementControls()
	if not placementActive or not DoesEntityExist(placementHandle) then return end

	local moveStep = 0.02
	local rotStep  = 1.5

	DisableControlAction(0, 24, true)  -- attack
	DisableControlAction(0, 25, true)  -- aim
	DisableControlAction(0, 140, true) -- melee

	-- کلید Left Alt: فعال/غیرفعال کردن ماوس برای کلیک روی دکمه‌های NUI
	if IsControlJustPressed(0, 19) then -- LMENU
		cursorActive = not cursorActive
		SetNuiFocus(cursorActive, cursorActive)
	end

	if cursorActive then return end -- وقتی روی دکمه‌هاست، کنترل بازی رو بلاک نکن

	if IsControlPressed(0, 172) then MoveEntity(0, moveStep, 0) end   -- جلو
	if IsControlPressed(0, 173) then MoveEntity(0, -moveStep, 0) end  -- عقب
	if IsControlPressed(0, 174) then MoveEntity(-moveStep, 0, 0) end  -- چپ
	if IsControlPressed(0, 175) then MoveEntity(moveStep, 0, 0) end   -- راست

	if IsControlJustPressed(0, 10) then RotateEntity(rotStep) end   -- Page Up
	if IsControlJustPressed(0, 11) then RotateEntity(-rotStep) end  -- Page Down

	if IsControlJustPressed(0, 15) then ScaleEntity(0.05) end   -- اسکرول بالا
	if IsControlJustPressed(0, 14) then ScaleEntity(-0.05) end  -- اسکرول پایین

	if IsControlJustPressed(0, 18) then ConfirmPlacement() end  -- Enter
	if IsControlJustPressed(0, 177) then CancelPlacement() end  -- Backspace
end

-- ---------------------------------------------------------
-- دکمه‌های NUI (وقتی Left Alt نگه داشته و کلیک می‌کنه)
-- ---------------------------------------------------------
RegisterNUICallback('placement_action', function(data, cb)
	if placementActive then
		local action = data.action

		if action == 'move_forward'  then MoveEntity(0, 0.05, 0)
		elseif action == 'move_backward' then MoveEntity(0, -0.05, 0)
		elseif action == 'move_left'     then MoveEntity(-0.05, 0, 0)
		elseif action == 'move_right'    then MoveEntity(0.05, 0, 0)
		elseif action == 'move_up'       then MoveEntity(0, 0, 0.02)
		elseif action == 'move_down'     then MoveEntity(0, 0, -0.02)
		elseif action == 'rotate_left'   then RotateEntity(5.0)
		elseif action == 'rotate_right'  then RotateEntity(-5.0)
		elseif action == 'scale_up'      then ScaleEntity(0.05)
		elseif action == 'scale_down'    then ScaleEntity(-0.05)
		elseif action == 'confirm'       then ConfirmPlacement()
		elseif action == 'cancel'        then CancelPlacement()
		end
	end

	cb('ok')
end)

function ConfirmPlacement()
	if not placementActive then return end

	local coords  = GetEntityCoords(placementHandle)
	local heading = GetEntityHeading(placementHandle)

	SetEntityAlpha(placementHandle, 255, false)
	FreezeEntityPosition(placementHandle, true)
	SetEntityCollision(placementHandle, true, true)

	if placementId then
		TriggerServerEvent('esx_property:plus:moveFurniture', placementId, coords.x, coords.y, coords.z, heading, placementScale)
		placedFurniture[placementId] = placementHandle
	else
		TriggerServerEvent('esx_property:plus:saveFurniture', placementProperty, placementModel, coords.x, coords.y, coords.z, heading, placementScale)
	end

	EndPlacement()
end

function CancelPlacement()
	if not placementActive then return end

	if DoesEntityExist(placementHandle) then
		DeleteEntity(placementHandle)
	end

	EndPlacement()
end

function EndPlacement()
	placementActive = false
	placementHandle = nil
	placementId     = nil
	placementProperty = nil

	if cursorActive then
		SetNuiFocus(false, false)
		cursorActive = false
	end

	SendNUIMessage({action = 'hide'})
end

-- ---------------------------------------------------------
-- لود کردن فرنیچرهای ذخیره‌شده وقتی وارد خونه میشی
-- ---------------------------------------------------------
function LoadFurnitureForProperty(propertyName)
	for id, handle in pairs(placedFurniture) do
		if DoesEntityExist(handle) then DeleteEntity(handle) end
	end
	placedFurniture = {}

	ESX.TriggerServerCallback('esx_property:plus:getFurniture', function(rows)
		for i = 1, #rows, 1 do
			local row  = rows[i]
			local hash = GetHashKey(row.model)

			RequestModel(hash)
			Citizen.CreateThread(function()
				local tries = 0
				while not HasModelLoaded(hash) and tries < 200 do
					Citizen.Wait(10)
					tries = tries + 1
				end

				if HasModelLoaded(hash) then
					local obj = CreateObject(hash, row.x, row.y, row.z, false, false, false)
					SetEntityHeading(obj, row.heading)
					SetEntityRotation(obj, 0.0, 0.0, row.heading, 2, true)
					FreezeEntityPosition(obj, true)
					SetEntityCollision(obj, true, true)
					placedFurniture[row.id] = obj
				end
			end)
		end
	end, propertyName)
end

function UnloadFurniture()
	for id, handle in pairs(placedFurniture) do
		if DoesEntityExist(handle) then DeleteEntity(handle) end
	end
	placedFurniture = {}
end
