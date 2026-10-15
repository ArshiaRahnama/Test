-- ============================================================
--  esx_property PLUS — config
--  آپشن‌های جدید: ارتقای انبار/گاوصندوق، فرنیچر، بازار، اقساط
-- ============================================================

ConfigPlus = {}

-- سطوح ارتقای انبار (property_inventory) — قیمت و حداکثر وزن
ConfigPlus.StorageTiers = {
	[1] = {price = 0,       maxWeight = 40000,  label = 'پایه'},
	[2] = {price = 250000,  maxWeight = 80000,  label = 'برنزی'},
	[3] = {price = 750000,  maxWeight = 150000, label = 'نقره‌ای'},
	[4] = {price = 2000000, maxWeight = 300000, label = 'طلایی'},
}

-- سطوح ارتقای گاوصندوق (اسلحه/آیتم‌های باارزش)
ConfigPlus.SafeTiers = {
	[1] = {price = 0,       maxWeight = 10000,  label = 'پایه'},
	[2] = {price = 500000,  maxWeight = 25000,  label = 'تقویت‌شده'},
	[3] = {price = 1500000, maxWeight = 50000,  label = 'ضدسرقت'},
}

-- کاتالوگ فرنیچر قابل‌قرار دادن داخل خونه
-- هر آیتم: مدل (prop hash name)، قیمت، دسته‌بندی، برچسب فارسی
ConfigPlus.FurnitureCatalog = {
	{category = 'نشیمن',  model = 'prop_sofa_01', label = 'مبل کلاسیک',   price = 15000},
	{category = 'نشیمن',  model = 'prop_chair_01', label = 'صندلی چوبی',  price = 5000},
	{category = 'میز',    model = 'prop_table_03', label = 'میز چوبی',    price = 8000},
	{category = 'دکوری',  model = 'prop_plant_01a', label = 'گلدان',      price = 3000},
	{category = 'دکوری',  model = 'prop_tv_flat_01', label = 'تلویزیون', price = 20000},
	{category = 'نورپردازی', model = 'prop_light_lamp_01', label = 'آباژور', price = 4000},
	-- هر آیتم دلخواه دیگه رو همینجا اضافه کن
}

-- حداکثر آیتم فرنیچر مجاز در هر خونه (پرفورمنس)
ConfigPlus.MaxFurniturePerProperty = 60

-- بازار بین بازیکن‌ها
ConfigPlus.Market = {
	enabled       = true,
	feePercent    = 5, -- کارمزدی که سرور از فروش می‌گیره (٪)
}

-- اقساط / رهن
ConfigPlus.Mortgage = {
	enabled            = true,
	downPaymentPercent = 20,  -- درصد پیش‌پرداخت
	installmentDays    = 30,  -- تعداد روز قسط
	interestPercent    = 8,   -- سود کل روی مبلغ باقی‌مانده
}

-- رنگ مارکر/بلیپ بر اساس وضعیت ملک
ConfigPlus.StatusColors = {
	available = {r = 46,  g = 204, b = 113}, -- سبز: قابل خرید
	owned_you = {r = 52,  g = 152, b = 219}, -- آبی: مال خودت
	for_sale  = {r = 155, g = 89,  b = 182}, -- بنفش: بازیکن دیگه گذاشته برای فروش
	owned_oth = {r = 149, g = 165, b = 166}, -- خاکستری: مال یه بازیکن دیگه‌ست
}
