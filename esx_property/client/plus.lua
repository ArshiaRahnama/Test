-- ============================================================
--  esx_property PLUS — client
--  منوی ارتقا، بازار، اقساط + رنگ‌بندی وضعیت روی نقشه
-- ============================================================

PropertyStatuses   = {} -- [name] = {owner=, for_sale=, sale_price=}  (global: main.lua هم بهش نیاز داره)
local myIdentifier = nil

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(0) end
	while ESX.GetPlayerData().identifier == nil do Citizen.Wait(200) end
	myIdentifier = ESX.GetPlayerData().identifier
end)

function RefreshPropertyStatuses()
	ESX.TriggerServerCallback('esx_property:plus:getStatuses', function(rows)
		PropertyStatuses = {}
		for i = 1, #rows, 1 do
			PropertyStatuses[rows[i].name] = rows[i]
		end

		if RecolorAllBlips then RecolorAllBlips() end
	end)
end

RegisterNetEvent('esx_property:plus:syncLevels')
AddEventHandler('esx_property:plus:syncLevels', function(propertyName, storageLevel, safeLevel)
	-- جای هوک زدن به esx_inventory برای تغییر maxWeight انبار/گاوصندوق پراپرتی
	-- مثال (بسته به اینونتوری‌ای که استفاده می‌کنی):
	-- exports['esx_inventory']:setStashWeight('property_' .. myIdentifier, ConfigPlus.StorageTiers[storageLevel].maxWeight)
end)

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(0) end
	RefreshPropertyStatuses()
end)

-- هر ۲ دقیقه یکبار وضعیت‌ها رو رفرش کن (فروش/خرید بین بازیکن‌ها realtime کامل نیست ولی نزدیکشه)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(120000)
		RefreshPropertyStatuses()
	end
end)

-- ---------------------------------------------------------
-- منوی ارتقای انبار/گاوصندوق
-- ---------------------------------------------------------
function OpenUpgradesMenu(property)
	ESX.TriggerServerCallback('esx_property:plus:getLevels', function(levels)
		if not levels then
			ESX.ShowNotification('اطلاعاتی برای این خونه پیدا نشد')
			return
		end

		local storageTier     = ConfigPlus.StorageTiers[levels.storage_level]
		local nextStorageTier = ConfigPlus.StorageTiers[levels.storage_level + 1]
		local safeTier        = ConfigPlus.SafeTiers[levels.safe_level]
		local nextSafeTier    = ConfigPlus.SafeTiers[levels.safe_level + 1]

		local elements = {}

		table.insert(elements, {
			label = nextStorageTier
				and ('📦 انبار: %s ← %s (%s$)'):format(storageTier.label, nextStorageTier.label, ESX.Math.GroupDigits(nextStorageTier.price))
				or ('📦 انبار: %s (حداکثر سطح)'):format(storageTier.label),
			value = 'storage'
		})

		table.insert(elements, {
			label = nextSafeTier
				and ('🔒 گاوصندوق: %s ← %s (%s$)'):format(safeTier.label, nextSafeTier.label, ESX.Math.GroupDigits(nextSafeTier.price))
				or ('🔒 گاوصندوق: %s (حداکثر سطح)'):format(safeTier.label),
			value = 'safe'
		})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_upgrades', {
			title    = property.label .. ' - ارتقا',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'storage' then
				if nextStorageTier then
					TriggerServerEvent('esx_property:plus:upgradeStorage', property.name)
				else
					ESX.ShowNotification('انبار در بالاترین سطحه')
				end
			elseif data.current.value == 'safe' then
				if nextSafeTier then
					TriggerServerEvent('esx_property:plus:upgradeSafe', property.name)
				else
					ESX.ShowNotification('گاوصندوق در بالاترین سطحه')
				end
			end
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end, property.name)
end

-- ---------------------------------------------------------
-- منوی بازار (فروش به بازیکن دیگه)
-- ---------------------------------------------------------
function OpenSellMenu(property)
	local status  = PropertyStatuses[property.name]
	local forSale = status and status.for_sale == 1

	local elements = {}

	if forSale then
		table.insert(elements, {label = ('لغو آگهی فروش (فعلاً: %s$)'):format(ESX.Math.GroupDigits(status.sale_price)), value = 'unlist'})
	else
		table.insert(elements, {label = 'گذاشتن برای فروش', value = 'list'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_sell', {
		title    = property.label .. ' - فروش',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'list' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'property_sell_price', {
				title = 'قیمت فروش رو وارد کن ($)'
			}, function(data2, menu2)
				local price = tonumber(data2.value)
				menu2.close()

				if price and price > 0 then
					TriggerServerEvent('esx_property:plus:listForSale', property.name, price)
					ESX.SetTimeout(500, RefreshPropertyStatuses)
				else
					ESX.ShowNotification('قیمت نامعتبره')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'unlist' then
			TriggerServerEvent('esx_property:plus:unlistForSale', property.name)
			ESX.SetTimeout(500, RefreshPropertyStatuses)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- ---------------------------------------------------------
-- خرید یه خونه‌ای که یه بازیکن دیگه گذاشته برای فروش
-- ---------------------------------------------------------
function BuyListedProperty(property)
	local status = PropertyStatuses[property.name]
	if not status or status.for_sale ~= 1 then
		ESX.ShowNotification('این خونه دیگه برای فروش نیست')
		return
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_buy_confirm', {
		title    = ('خرید به قیمت %s$ ؟'):format(ESX.Math.GroupDigits(status.sale_price)),
		align    = 'left',
		elements = {
			{label = 'بله، بخر', value = 'yes'},
			{label = 'انصراف',   value = 'no'}
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'yes' then
			TriggerServerEvent('esx_property:plus:buyFromPlayer', property.name)
			ESX.SetTimeout(500, RefreshPropertyStatuses)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- ---------------------------------------------------------
-- خرید اقساطی (رهن)
-- ---------------------------------------------------------
function BuyPropertyMortgage(property)
	local down = math.floor(property.price * (ConfigPlus.Mortgage.downPaymentPercent / 100))

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_mortgage_confirm', {
		title    = ('پیش‌پرداخت %s$ + قسط روزانه'):format(ESX.Math.GroupDigits(down)),
		align    = 'left',
		elements = {
			{label = 'بله، رهن کن', value = 'yes'},
			{label = 'انصراف',      value = 'no'}
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'yes' then
			TriggerServerEvent('esx_property:plus:buyMortgage', property.name, property.storage_data)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- ---------------------------------------------------------
-- رنگ بلیپ/مارکر بر اساس وضعیت + تکست سه‌بعدی
-- (این ترد کنار ترد اصلی esx_property کار می‌کنه، جایگزینش نمی‌کنه)
-- ---------------------------------------------------------
local function GetPropertyStatusInfo(property)
	local status = PropertyStatuses[property.name]

	if status then
		if status.owner == myIdentifier then
			return 'owned_you', property.label
		elseif status.for_sale == 1 then
			return 'for_sale', ('%s\n💰 %s$'):format(property.label, ESX.Math.GroupDigits(status.sale_price))
		else
			return 'owned_oth', property.label
		end
	end

	return 'available', ('%s\n💵 %s$'):format(property.label, property.price and ESX.Math.GroupDigits(property.price) or '?')
end

local function DrawText3D(x, y, z, text)
	local onScreen, sx, sy = World3dToScreen2d(x, y, z)
	local camCoords        = GetGameplayCamCoords()
	local distance         = GetDistanceBetweenCoords(camCoords.x, camCoords.y, camCoords.z, x, y, z, true)
	local scale             = (1 / distance) * 2
	local fov                = (1 / GetGameplayCamFov()) * 100
	scale                    = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.35 * scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(sx, sy)
	end
end

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(0) end

	while true do
		Citizen.Wait(0)
		local coords     = GetEntityCoords(PlayerPedId())
		local nearAny    = false

		for i = 1, #Config.Properties, 1 do
			local property = Config.Properties[i]

			if property.entering then
				local dist = GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true)

				if dist < 12.0 then
					nearAny = true
					local _, text = GetPropertyStatusInfo(property)
					DrawText3D(property.entering.x, property.entering.y, property.entering.z + 1.1, text)
				end
			end
		end

		if not nearAny then
			Citizen.Wait(400)
		end
	end
end)

-- بازنویسی بلیپ‌ها با رنگ وضعیت (اجرا میشه بعد از هر رفرش وضعیت)
function RecolorAllBlips()
	for i = 1, #Config.Properties, 1 do
		local property = Config.Properties[i]
		local blip      = Blips and Blips[property.name]

		if blip and DoesBlipExist(blip) then
			local statusKey = GetPropertyStatusInfo(property)
			local color      = ConfigPlus.StatusColors[statusKey]

			if color then
				-- بلیپ‌های GTA فقط پالت رنگی ثابت دارن، نزدیک‌ترین رنگ رو انتخاب می‌کنیم
				if statusKey == 'owned_you' then
					SetBlipColour(blip, 3)   -- آبی
				elseif statusKey == 'for_sale' then
					SetBlipColour(blip, 27)  -- بنفش
				elseif statusKey == 'owned_oth' then
					SetBlipColour(blip, 4)   -- خاکستری
				else
					SetBlipColour(blip, 2)   -- سبز
				end
			end
		end
	end
end
