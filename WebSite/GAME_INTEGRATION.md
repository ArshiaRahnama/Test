# اتصال سایت به سرور بازی

در `lib.php` مقدار `'api_key'` رو با یه رشته‌ی تصادفی **حداقل ۲۴ کاراکتری** پر کن (مثلاً خروجی `openssl rand -hex 24`).
تا وقتی خالیه، `api.php` همه‌ی درخواست‌ها رو رد می‌کنه.

## ۱) دستور `/getcode` (ورود با کد یکبارمصرف)
کد ۶ رقمی ۳ دقیقه اعتبار داره و فقط یک‌بار قابل استفاده است.

```lua
-- server.lua (نمونه برای FiveM/ESX؛ با فریم‌ورک خودت تطبیق بده)
local SITE, KEY = 'https://example.com', 'API_KEY_HERE'

RegisterCommand('getcode', function(src)
  local license = GetPlayerIdentifierByType(src, 'license') -- همونی که در login_users.device_license ذخیره می‌کنی
  PerformHttpRequest(SITE .. '/api.php?a=issue_code', function(status, body)
    local r = json.decode(body or '{}')
    if r and r.ok then TriggerClientEvent('chat:addMessage', src, { args = { 'سایت', ('کد ورود شما: %s (۳ دقیقه اعتبار)'):format(r.code) } })
    else TriggerClientEvent('chat:addMessage', src, { args = { 'سایت', 'حسابی پیدا نشد.' } }) end
  end, 'POST', 'identifier=' .. license, { ['X-Api-Key'] = KEY, ['Content-Type'] = 'application/x-www-form-urlencoded' })
end, false)
```

## ۲) تحویل خریدهای فروشگاه
هر خرید در `web_orders` با وضعیت `pending` ثبت می‌شه. یک تایمر در سرور بازی بذار:

```lua
CreateThread(function()
  while true do
    Wait(30000)
    PerformHttpRequest(SITE .. '/api.php?a=pending', function(_, body)
      local r = json.decode(body or '{}')
      for _, o in ipairs(r.orders or {}) do
        -- o.identifier = لایسنس بازیکن، o.item_code = کد آیتم (مثلاً اسپاون ماشین)
        local ok = DeliverItem(o.identifier, o.item_code)   -- تابع تحویل مخصوص سرور خودت
        if ok then PerformHttpRequest(SITE .. '/api.php?a=delivered', function() end, 'POST', 'id=' .. o.id, { ['X-Api-Key'] = KEY, ['Content-Type'] = 'application/x-www-form-urlencoded' }) end
      end
    end, 'GET', '', { ['X-Api-Key'] = KEY })
  end
end)
```

## ۳) درگاه پرداخت تومانی
در `inc/dash_ext.php` تابع `gateway_start($topupId, $amount)` رو با درگاه خودت پر کن (باید URL پرداخت رو برگردونه).
بعد از تایید پرداخت، `wallet_add($userId, 'toman', $amount, 'topup', '...')` رو صدا بزن. تا اون موقع، شارژها در
«مدیریت فروشگاه» به‌صورت دستی تایید می‌شن.

## نکته‌ها
- نام ستون تایم‌کوین در جدول `users` در `inc/ext.php` (`EXT['tc_column']`) تنظیم می‌شه؛ پیش‌فرض `timecoin`.
- پرداخت با پول بازی/TC و تبدیل‌ها فقط وقتی بازیکن آفلاینه انجام می‌شه تا سرور بازی موقع ذخیره بازنویسیش نکنه.
- برای ثبت پانیشمنت از «لاگ‌های سرور» در داشبورد ادمین استفاده کن؛ سوابق در `web_punish` ذخیره می‌شه.
