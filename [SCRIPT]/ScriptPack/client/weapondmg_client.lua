-- ============================================================
-- weapondmg_client.lua  (سیستم دمیج اسلحه‌ی ادمین‌کانفیگ‌شدنی)
-- ============================================================
-- جایگزین حلقه‌ی استاتیک قبلی شد. مقادیر پیش‌فرض (اسلحه‌های انفجاری صفر،
-- سلاح‌های سرد کم‌دمیج و...) از سرور میان و دقیقاً همون‌هایی هستن که قبلاً
-- تو همین فایل هاردکد شده بودن، پس رفتار پیش‌فرض تغییری نکرده - فقط الان
-- یه ادمین (با دستور /weapondmg) می‌تونه از داخل بازی تنظیمشون کنه، و مقدارش
-- برای همیشه ذخیره می‌مونه (JSON سمت سرور).

RegisterNetEvent('weapondmg:loadList', function(data)
	for k, v in pairs(data) do
		SetWeaponDamageModifier(GetHashKey(k), v.damage + 0.0)
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	TriggerServerEvent('weapondmg:getList')
end)

-- ✅ فیکس شد: به‌جای exports["input"]:Keyboard (ریسورسی که نصب نیست)، از
-- lib.inputDialog خودِ ox_lib استفاده میشه (که از قبل داشتید).
RegisterNetEvent('weapondmg:openMenu', function(data)
	local elements = {}
	table.insert(elements, {
		img = '',
		text = 'Add',
		text2 = '',
		callBack = function()
			exports.icon_menu:ForceCloseMenu()
			local result = lib.inputDialog('Add', { 'Name || Hash', 'Value' })
			if result and result[1] and result[2] then
				local hash = type(result[1]) == 'string' and result[1]:upper() or result[1]
				local value = tonumber(result[2])
				if value then
					local _value = {
						damage = value, -- 1:1؛ دیگه نیازی به لیست weapons محلی برای محاسبه‌ی نسبت نبود
						value = value,
					}
					TriggerServerEvent('weapondmg:setDamage', hash, _value)
				end
			end
		end
	})
	for k, v in pairs(data) do
		table.insert(elements, {
			img = '',
			text = k .. ' = ' .. v.value,
			text2 = '',
			callBack = function()
				exports.icon_menu:ForceCloseMenu()
				local result = lib.inputDialog('Change damage - ' .. k, { 'Value' })
				if result and result[1] then
					local value = tonumber(result[1])
					if value then
						local _value = {
							damage = value,
							value = value,
						}
						TriggerServerEvent('weapondmg:setDamage', k, _value)
					end
				end
			end
		})
	end
	exports.icon_menu:OpenMenu(elements)
end)
