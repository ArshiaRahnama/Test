-- ============================================================
-- weapondmg_server.lua  (سیستم دمیج اسلحه‌ی ادمین‌کانفیگ‌شدنی)
-- ============================================================
-- جایگزین حلقه‌ی استاتیک قدیمی weapondmg_client.lua شد. مقادیر پیش‌فرض زیر
-- دقیقاً همون اعدادی هستن که قبلاً تو همون فایل هاردکد شده بودن - یعنی تا
-- وقتی یه ادمین از داخل بازی چیزی رو عوض نکنه، رفتار دمیج سلاح‌ها هیچ فرقی
-- نمی‌کنه. تغییرات ادمین توی یه فایل JSON داخل خودِ ریسورس ذخیره میشه (نیازی
-- به تغییر دیتابیس نبود).

local SAVE_FILE = 'weapondmg_overrides.json'

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DefaultDamage = {
	['weapon_rpg']              = { damage = 0,    value = 0 },
	['weapon_grenade']          = { damage = 0,    value = 0 },
	['weapon_stickybomb']       = { damage = 0,    value = 0 },
	['weapon_railgun']          = { damage = 0,    value = 0 },
	['weapon_hominglauncher']   = { damage = 0,    value = 0 },
	['weapon_compactlauncher']  = { damage = 0,    value = 0 },
	['weapon_rayminigun']       = { damage = 0,    value = 0 },
	['weapon_firework']         = { damage = 0,    value = 0 },
	['weapon_grenadelauncher']  = { damage = 0,    value = 0 },
	['weapon_pipebomb']         = { damage = 0,    value = 0 },
	['weapon_proxmine']         = { damage = 0,    value = 0 },
	['WEAPON_SMOKEGRENADE']     = { damage = 0,    value = 0 },
	['WEAPON_BZGAS']            = { damage = 0.25, value = 0.25 },
	['WEAPON_UNARMED']          = { damage = 0.2,  value = 0.2 },
	['weapon_dagger']           = { damage = 0.2,  value = 0.2 },
	['WEAPON_BAT']              = { damage = 0.2,  value = 0.2 },
	['weapon_bottle']           = { damage = 0.2,  value = 0.2 },
	['weapon_crowbar']          = { damage = 0.2,  value = 0.2 },
	['weapon_flashlight']       = { damage = 0.2,  value = 0.2 },
	['WEAPON_NIGHTSTICK']       = { damage = 0.1,  value = 0.1 },
	['weapon_minigun']          = { damage = 0.5,  value = 0.5 },
	['WEAPON_PUMPSHOTGUN']      = { damage = 0.4,  value = 0.4 },
	['WEAPON_PUMPSHOTGUN_MK2']  = { damage = 0.4,  value = 0.4 },
	['WEAPON_BULLPUPRIFLE']     = { damage = 1.2,  value = 1.2 },
	['WEAPON_ASSAULTSHOTGUN']   = { damage = 0.25, value = 0.25 },
	['WEAPON_BULLPUPSHOTGUN']   = { damage = 0.7,  value = 0.7 },
	['WEAPON_SAWNOFFSHOTGUN']   = { damage = 0.2,  value = 0.2 },
	['weapon_doubleaction']     = { damage = 0.55, value = 0.55 },
}

local SavedOverrides = {}

local function LoadOverrides()
	local raw = LoadResourceFile(GetCurrentResourceName(), SAVE_FILE)
	if raw then
		local ok, decoded = pcall(json.decode, raw)
		if ok and type(decoded) == 'table' then
			SavedOverrides = decoded
		end
	end
end

local function SaveOverrides()
	SaveResourceFile(GetCurrentResourceName(), SAVE_FILE, json.encode(SavedOverrides), -1)
end

local function GetMergedList()
	local merged = {}
	for k, v in pairs(DefaultDamage) do
		merged[k] = { damage = v.damage, value = v.value }
	end
	for k, v in pairs(SavedOverrides) do
		merged[k] = { damage = v.damage, value = v.value }
	end
	return merged
end

LoadOverrides()

-- برای چک "فقط تو دنیای پیش‌فرض کمبت‌مود فعال شه" که تو combat_vdm_client.lua
-- استفاده میشه. مستقل از Unique_Hud پیاده شد که ScriptPack به هیچ ریسورس
-- دیگه‌ای وابسته نباشه.
ESX.RegisterServerCallback('ScriptPack:getWorld', function(source, cb)
	cb(GetPlayerRoutingBucket(source) or 0)
end)

RegisterServerEvent('weapondmg:getList')
AddEventHandler('weapondmg:getList', function()
	TriggerClientEvent('weapondmg:loadList', source, GetMergedList())
end)

-- فقط ادمین‌هایی که ACE ‛command.weapondmg‘ رو دارن می‌تونن دمیج اسلحه رو
-- عوض کنن (دقیقاً همون الگوی permission که Unique_AdminMenu خودتون داره).
RegisterServerEvent('weapondmg:setDamage')
AddEventHandler('weapondmg:setDamage', function(key, value)
	local src = source
	if not IsPlayerAceAllowed(src, 'command.weapondmg') then
		return
	end
	if type(key) ~= 'string' or type(value) ~= 'table' or type(value.damage) ~= 'number' then
		return
	end

	SavedOverrides[key] = { damage = value.damage, value = value.value }
	SaveOverrides()

	local merged = GetMergedList()
	TriggerClientEvent('weapondmg:loadList', -1, merged)
end)

RegisterCommand('weapondmg', function(source)
	if source == 0 then return end
	if not IsPlayerAceAllowed(source, 'command.weapondmg') then
		TriggerClientEvent('esx:showNotification', source, '~r~شما دسترسی این دستور را ندارید!')
		return
	end
	TriggerClientEvent('weapondmg:openMenu', source, GetMergedList())
end, false)
