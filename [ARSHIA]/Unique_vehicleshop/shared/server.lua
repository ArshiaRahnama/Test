------------------------------------------------------------------------------------
-- Unique_vehicleshop - نسخه اصلاح‌شده و امن‌شده بک‌اند (بر پایه‌ی Debux_vehicleshop)
-- تغییرات نسبت به نسخه‌ی اصلی:
--  1) قیمت دیگه از کلاینت گرفته نمیشه؛ سرور خودش از Config.Vehicles قیمت واقعی رو
--     پیدا می‌کنه. (نسخه اصلی به کلاینت اعتماد می‌کرد و هرکسی می‌تونست با تغییر
--     متغیر price تو کلاینت، ماشین رو مجانی یا خیلی ارزون بخره.)
--  2) شاپ خریداری‌شده (shopId) هم سمت سرور با Config.vehicleshop چک میشه، به‌جای
--     اینکه کل جدول sellectcar از کلاینت با اعتماد کامل قبول بشه.
--  3) هر فروشگاه یک Config.vehicleshop[id].minRank داره؛ اگه permission_level پلیر
--     کمتر از این رنک باشه، خرید رد میشه (برای فروشگاه‌های استاف/تست کاربرد داره).
--  4) کوئری‌های SQL پارامتری شدن (به‌جای string concat) تا از SQL Injection جلوگیری بشه.
--  5) از oxmysql (که روی سرور شما نصبه) استفاده می‌کنه، نه mysql-async.
------------------------------------------------------------------------------------

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

-- جدول قیمت واقعی و دسته‌بندی هر مدل رو یک بار می‌سازیم تا لازم نباشه هر بار کل Config.Vehicles رو پیمایش کنیم
local VehiclePriceByModel   = {}
local VehicleCategoryByModel = {}

CreateThread(function()
	for category, vehicles in pairs(Config.Vehicles) do
		for _, v in pairs(vehicles) do
			VehiclePriceByModel[v.name]    = v.price
			VehicleCategoryByModel[v.name] = category
		end
	end
end)

local function categoryAllowedForShop(shop, category)
	for _, c in ipairs(shop.categories or {}) do
		if c == category then return true end
	end
	return false
end

local function log(msg)
	print(('^3[Unique_vehicleshop]^7 %s'):format(msg))
end

RegisterNetEvent('Unique_vehicleshop:buyvehicle', function(props, modelName, shopId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer == nil then return end

	-- ۱) شاپ باید واقعاً در کانفیگ سرور وجود داشته باشه
	local shop = Config.vehicleshop[shopId]
	if not shop then
		log(('%s تلاش کرد با یک shopId نامعتبر (%s) خرید انجام بده'):format(xPlayer.identifier, tostring(shopId)))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- ۲) رنک/سطح دسترسی پلیر باید با حداقل رنک لازم برای این فروشگاه (Config.vehicleshop[id].minRank) بخونه
	local permission_level = xPlayer.permission_level or 0
	if permission_level < (shop.minRank or 0) then
		log(('%s (permission_level %s) بدون داشتن رنک کافی برای فروشگاه %s تلاش کرد خرید کنه'):format(xPlayer.identifier, tostring(permission_level), tostring(shopId)))
		TriggerClientEvent('esx:showNotification', src, Config.lang.noperm, 'error')
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- ۳) مدل ماشین باید داخل لیست قیمت‌های همین فروشگاه باشه (مثلاً نمایشگاه قایق نباید بتونه ماشین بفروشه)
	local price = VehiclePriceByModel[modelName]
	local category = VehicleCategoryByModel[modelName]
	if not price or not categoryAllowedForShop(shop, category) then
		log(('%s تلاش کرد یک مدل نامعتبر/خارج از دسته‌بندی این فروشگاه (%s) بخره'):format(xPlayer.identifier, tostring(modelName)))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- ۴) داده‌ی وسیله (رنگ/مدل و ...) باید یک جدول معتبر باشه
	if type(props) ~= 'table' or type(props.plate) ~= 'string' or props.plate == '' then
		log(('%s داده‌ی خودرو نامعتبری ارسال کرد'):format(xPlayer.identifier))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- ۵) بررسی و کسر پول کاملاً سمت سرور، با قیمت واقعی کانفیگ (نه چیزی که کلاینت فرستاده)
	if xPlayer.getMoney() < price then
		TriggerClientEvent('esx:showNotification', src, Config.lang.nomoney, 'error')
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	xPlayer.removeMoney(price)

	-- ۶) درج امن (پارامتری) در owned_vehicles - دقیقاً هم‌ساختار با جدول دیتابیس شما
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
		['@owner']   = xPlayer.identifier,
		['@plate']   = props.plate,
		['@vehicle'] = json.encode(props),
		['@type']    = shop.type or 'car',
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			TriggerClientEvent('esx:showNotification', src, Config.lang.buyvehicle, 'success')
		else
			-- اگه ثبت تو دیتابیس شکست خورد، پول رو برگردون که پلیر ضرر نکنه
			xPlayer.addMoney(price)
			TriggerClientEvent('esx:showNotification', src, 'خطا در ثبت خودرو، مبلغ بازگردانده شد', 'error')
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		end
	end)
end)
