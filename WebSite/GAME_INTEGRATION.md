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
