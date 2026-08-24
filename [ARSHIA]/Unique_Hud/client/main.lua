-- ============================================================
-- Unique_Hud / client / main.lua  (status ادغام و فیکس شد)
-- ============================================================
-- فیکس‌های این نسخه نسبت به status قدیمی:
-- 1) کرش "bad argument #1 to 'gsub' (string expected, got table)": همه‌ی
--    فراخوانی‌های gsub الان از تابع کمکی SafeGsub رد میشن که اگه مقدار رشته
--    نبود (nil، table یا هرچی) به‌جای کرش کردن یه رشته‌ی خالی برمی‌گردونه.
--    همچنین job.ext که تو essentialmode شما اصلاً هیچ‌وقت مقدار نمی‌گیره
--    (همیشه nil هست) دیگه به‌عنوان رشته فرض نمیشه.
-- 2) لیبل سکه از "سکه" (فارسی) به "Coin" (انگلیسی) تغییر کرد.
-- 3) mugshot (عکس پلیر): قبلاً فقط منتظر ایونت 'skinchanger:modelLoaded' بود؛
--    اگه اون ایونت قبل از آماده شدن PlayerData فایر می‌شد یا اصلاً به هر
--    دلیلی (ریستارت ریسورس وسط بازی، تیک نخوردن اسکین‌چنجر) فایر نمی‌شد،
--    عکس هیچ‌وقت ثبت نمی‌شد. الان یه ثبت اولیه‌ی مستقل هم داریم، بعلاوه
--    تلاش مجدد خودکار اگه handle در طول زمان نامعتبر (invalid) بشه.

local AutoSaveHungerThirst = true
local AutoSaveHungerThirstTimer = 138000
local showHud = true
local factorHunger = (1000 * 100) / 2400000
local factorThirst = (1000 * 100) / 1800000
local hunger = 100
local thirst = 100
local health = 100
local armor  = 100
-- ✅ فیکس شد: عکس خیلی بزرگ و مستطیلی دیده می‌شد. الان کوچیک‌تر و مربعی‌تره
-- (اندازه‌ی یه آیکون کوچیک، هماهنگ با بقیه‌ی HUD). اگه هنوز دقیق جای درستش
-- نبود، همین ۴ عدد رو کم/زیاد کن: w/h اندازه، x/y موقعیت (۰ تا ۱، از گوشه‌ی
-- بالا-چپ صفحه).
local w = 0.028
local h = 0.05
local x = 0.855
local y = 0.045
local pname
local showpic = true
local mugshot, mugTxd = nil, nil
local PlayerData = {}

-- ✅ فیکس کرش gsub: هر جا قبلاً string.gsub(x, ...) یا x:gsub(...) مستقیم
-- صدا زده می‌شد و x می‌تونست table/nil باشه (مثلاً job.ext که تو essentialmode
-- شما هیچ‌وقت set نمیشه، یا gang.name وقتی gang کامل نیومده)، این تابع
-- جایگزینش شده.
local function SafeGsub(value, pattern, repl)
    if type(value) ~= 'string' then
        return ''
    end
    return (string.gsub(value, pattern, repl))
end

AddEventHandler('onKeyUP',function(key)
	if key == 'oem_3' then
    showpic = not showpic
		ToggleHUD()
	end
end)

ESX                             = nil

Citizen.CreateThread(function()
while ESX == nil do
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  Citizen.Wait(0)
end
end)

function updateHUD(health, armor)
  SendNUIMessage({
    update = true,
    health = health,
    armor  = armor
  })
end

function MakeDigit(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return ('$' .. left..(num:reverse():gsub('(%d%d%d)','%1' .. ','):reverse())..right)
end

function ToggleHUD()
	ESX.ShowNotification('تغییر وضعیت انجام شد')
	SendNUIMessage({
    toggle = true
  })
ReloadAllData()
end

-- تابع نمایش job که برای هر دو مسیر (ReloadAllData و esx:playerLoaded/esx:setJob)
-- استفاده میشه، تا منطق job.ext یه‌بار نوشته بشه نه سه‌بار جدا با ریسک ناهماهنگی.
local function SendJobMessage(job)
    if not job or not job.name then return end
    local jobNameLower = string.lower(job.name)

    if jobNameLower ~= 'nojob' and jobNameLower ~= 'police' and jobNameLower ~= 'sheriff' then
        SendNUIMessage({action = "job", value = (job.label or job.name) .. " | " .. (job.grade_label or ""), icon = job.name})
    elseif (job.name == 'police' or job.name == 'sheriff') and type(job.ext) == 'string' then
        -- job.ext وقتی رشته‌ی واقعی باشه (مثلاً 'swat')
        SendNUIMessage({action = "job", value = SafeGsub(job.ext, "^%l", string.upper) .. " | " .. (job.grade_label or ""), icon = job.ext})
    elseif jobNameLower == 'police' or jobNameLower == 'sheriff' then
        -- پلیس/شریف عادی بدون ext (حالت معمول تو essentialmode شما، چون
        -- job.ext هیچ‌وقت واقعاً ست نمیشه)
        SendNUIMessage({action = "job", value = (job.label or job.name) .. " | " .. (job.grade_label or ""), icon = job.name})
    else
        SendNUIMessage({action = "job", value = 'hide', icon = job.name})
    end
end

local function SendGangMessage(gang)
    if gang and gang.name and gang.name ~= 'nogang' then
        SendNUIMessage({action = "gang", value = SafeGsub(gang.name, "_", " ") .. " | " .. (gang.grade_label or "")})
        ESX.TriggerServerCallback('gangs:getGangData', function(data)
            if data then
                SendNUIMessage({action = "gangimg", value = data.icon})
            end
        end, gang.name)
    else
        SendNUIMessage({action = "gang", value = 'hide'})
    end
end

function ReloadAllData()
 local job = ESX.GetPlayerData().job
 local gang = ESX.GetPlayerData().gang
 ESX.TriggerServerCallback('reloaddata',function(data)
 if not data then return end
 TriggerEvent('showStatus')
 pname = data.name
 SendNUIMessage({action = "playerName", value = SafeGsub(data.name , "_"," ")})
 -- ✅ "سکه" -> "Coin"
 SendNUIMessage({action = "tc", valuetc = tostring(data.coin or 0) .. " Coin",valuetctime = 0})
 SendNUIMessage({action = "playerId", value = GetPlayerServerId(PlayerId()) })
 SendNUIMessage({action = "cash", value = MakeDigit(data.money)})
 SendJobMessage(job)
 SendGangMessage(gang)
 end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  Wait(5000)
  PlayerData = xPlayer
  local job = xPlayer.job
  local gang = xPlayer.gang
  SendGangMessage(gang)
  SendJobMessage(job)
  SendNUIMessage({action = "playerName", value = SafeGsub(xPlayer.name , "_"," ")})
  pname = xPlayer.name
  SendNUIMessage({action = "cash", value = MakeDigit(xPlayer.money)})
	SendNUIMessage({action = "playerId", value = GetPlayerServerId(PlayerId()) })
  Wait(1000)
  ReloadAllData()

  -- ✅ فیکس mugshot: یه تلاش اولیه‌ی مستقل هم اینجا انجام میشه، به‌جای اینکه
  -- فقط منتظر ایونت 'skinchanger:modelLoaded' بمونیم (که ممکنه قبل از این
  -- لحظه فایر شده باشه و از دستمون در رفته باشه).
  TryRegisterMugshot()
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
  SendNUIMessage({action = "cash", value = MakeDigit(money)})
end)

RegisterNetEvent('Coin-System:PlayerCoin')
AddEventHandler('Coin-System:PlayerCoin', function(coinAmount)
  SendNUIMessage({action = "tc", valuetc = tostring(coinAmount or 0) .. " Coin", valuetctime = 0})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendJobMessage(job)
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
  SendGangMessage(gang)
end)

RegisterCommand('reload',function()
	ReloadAllData()
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

AddEventHandler('Status:radio', function(data)
  SendNUIMessage(data)
end)


local previousArmor = 0
local previousHealth = 0
RegisterNetEvent('showStatus')
AddEventHandler('showStatus', function()
	Wait(1000)

  local wait = 1000
  Citizen.CreateThread(function()
    local showed = false
    while true do

      local pause = IsPauseMenuActive()

      if showed ~= showHud and not pause then
        SendNUIMessage({
          display = showHud
        })
        showed = showHud
		wait = 1000
      end
      if pause and showed then
        SendNUIMessage({
          display = false
        })
        showed = false
		wait = 5000
      end

      if showHud and showed then
        local ped = PlayerPedId()
        local pedhealth = GetEntityHealth(ped)
        if pedhealth < 100 then
          health = 0
        else
          health = pedhealth - 100
        end

        local armor = GetPedArmour(ped)
		if armor == 98 then
		armor = 100
		end
        if health ~= previousHealth or armor ~= previousArmor then
          previousHealth = health
          previousArmor = armor
          updateHUD(health, armor)
        end

      end
      Citizen.Wait(wait)
    end
end)
end)

-- ✅ فیکس mugshot: تابع مستقل ثبت عکس، هم موقع playerLoaded هم موقع تعویض
-- اسکین صدا زده میشه؛ اگه handle قبلی معتبر نبود دوباره تلاش می‌کنه.
-- ✅ فیکس شد: شرط HasPedHeadBlendFinished حذف شد - برای بعضی مدل‌های
-- کاراکتر ممکنه هیچ‌وقت true نشه و باعث بشه عکس برای همیشه ثبت نشه. خودِ
-- ESX.Game.GetPedMugshot داخلش صبر می‌کنه تا headshot واقعاً آماده بشه
-- (IsPedheadshotReady)، پس نیازی به این شرط اضافه نبود.
function TryRegisterMugshot()
    Citizen.CreateThread(function()
        while not PlayerData.name do
            Wait(100)
        end

        local attempts = 0
        while attempts < 20 do
            mugshot, mugTxd = ESX.Game.GetPedMugshot(PlayerPedId())
            if IsPedheadshotValid(mugshot) then
                return
            end
            attempts = attempts + 1
            Wait(500)
        end
    end)
end

AddEventHandler('skinchanger:modelLoaded', function()
  while not PlayerData.name do
		Wait(100)
	end
  Wait(5000)

	mugshot, mugTxd = ESX.Game.GetPedMugshot(PlayerPedId())
end)

-- ✅ اگه به هر دلیلی handle قبلاً معتبر بود و بعداً نامعتبر شد (رفتار شناخته‌شده‌ی
-- خودِ FiveM با RegisterPedheadshot)، هر ۱۰ ثانیه یه چک می‌کنیم و در صورت نیاز
-- دوباره ثبتش می‌کنیم، به‌جای اینکه عکس برای همیشه گم بشه.
CreateThread(function()
  while not PlayerData.name do
      Wait(100)
  end

  while true do
    Wait(10000)
    if showHud and showpic and mugshot ~= nil and not IsPedheadshotValid(mugshot) then
        mugshot, mugTxd = ESX.Game.GetPedMugshot(PlayerPedId())
    end
  end
end)

CreateThread(function()
  while not PlayerData.name do
      Wait(100)
  end

  while true do
  Wait(1)

  if not mugshot or not IsPedheadshotValid(mugshot) or not showHud or not showpic then
    goto skin_mugshot
  end

  DrawSprite(mugTxd, mugTxd, x, y, w, h, 0, 255, 255, 255, 10000);
  ::skin_mugshot::
  end
end)

RegisterCommand("togglehud", function(source, args)
  showHud = not showHud
end)

RegisterNUICallback('setmugpos', function(data)
  w = data.w
  h = data.h
  x = data.x + (data.w/2)
  y = data.y + (data.h/2)
end)

function updateIndicators(type, data)
  local newData = convertData(type, data)
  SendNUIMessage({action = "indicator", value = newData})
end
exports("updateIndicators", updateIndicators)

function convertData(type, data)
    local newData = {}
    for id,talking in pairs(data) do
      if talking then
        table.insert(newData, {id = id, type = type})
      end
    end

    return newData
end
