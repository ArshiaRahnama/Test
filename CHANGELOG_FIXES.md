# Unique_inventory & سرور — Changelog کامل فیکس‌ها

## ۱. فیکس‌های اولیه (باگ‌های ساده)

1. `[ARSHIA]/Unique_inventory/client/inventory_main.lua:381` — `or` → `and` در چک زندانی‌بودن (صندوق عقب).
2. `[ARSHIA]/Unique_inventory/server/trunk_main.lua` — `store.get("black_money") or {}` + nil-check.
3. `[ARSHIA]/Unique_inventory/server/trunk_helpers.lua` — `onMySQLReady` (مرده) → `MySQL.ready(...)`.
4. `server/label_cache.lua` (جدید) — کش `GetItemLabel`/`GetWeaponLabel`.
5. `server/spam_guard.lua` (جدید) — ریت‌لیمیت واقعی سمت سرور برای Give/Drop.
6. `[BASE]/essentialmode/server/main.lua` — هندلر خالی `esx:giveInventoryItem` (دکمه‌ی Give) به منطق واقعی زیرش forward شد.

## ۲. سیستم قفل آیتم (گنگ + آرموری جاب)

7. `server/job_gang_lock.lua` (جدید) — `IsGangItemLocked`, `IsJobItemLocked`.
8. `config_joblock.lua` (جدید) — حداقل گرید per-item برای انبار جاب (job2).
9. `Parzival:getGangINV`, `getJobINV1` (سلاح آرموری - دیگه مخفی نمیشه، قفل میشه), `getJobINV2` — همه آیتم `locked` رو برمی‌گردونن.
10. **باگ بزرگ پیدا شد و فیکس شد:** `gangs:getFromInventory`/`gangs:addToInventory` هیچ listener سمت سروری نداشتن (برداشتن/گذاشتن آیتم گنگ کاملاً مرده بود) — پیاده‌سازی کامل با enforcement قفل.
11. `Unique_ALLGangs/server/Gangs.lua` — هندلر امن `Unique_ALLGangs:checkItemAccess` (بدون exports) اضافه شد، داده‌ی واقعی `Gangs[gang].grades[grade].access.itemAccess` رو به Unique_inventory وصل می‌کند.
12. `Parzival:GetJobItem`/`PutJobItem` — nil-check اضافه شد (کرش با آیتم ناشناس)، `PutJobItem` هم الان lower-case می‌کند، و قفل تو `GetJobItem` enforce میشه.
13. NUI (`nui/app.js` + `css.css`) — بج قفل 🔒 روی آیتم‌های locked، جلوگیری از شروع درگ برای گرفتنشون (هم تو `start` درگ، هم تو drop-handler اصلی به اینونتوری).

## ۳. اتصال به Unique_inventory به‌جای ریسورس‌های ناموجود

بررسی کامل نشون داد **هیچ‌کدوم از** `ox_inventory`, `qb-inventory`, `ps-inventory`, `lc-inventory`, `esx_inventory` **نصب نیستن** — فقط `Unique_inventory` هست. هر جا کدی به این‌ها اشاره می‌کرد:

14. `[JOB]/uniquecafejobs/shared/menu.lua` + `market_products.lua` — مسیر آیکون از `ox_inventory` به `Unique_inventory/html/img/items/` (که واقعاً وجود دارد، ۴۴۲ آیکون) — فقط `cupcake` مچ داشت، ۳۰ آیتم دیگه باید PNG جدید اضافه بشه.
15. `[ARSHIA]/Unique_inventory/server/trunk_helpers.lua` — export جدید `exports('GetTrunkItems', plate)` اضافه شد (مقدار ساده، نه callback - امن با exports).
16. `[JOB]/esx_uniquejobs/shared/k9_config.lua` + `server/k9/server_editable.lua` — `CFG.INVENTORY` از `'esx_inventory'` (مرده) به `'Unique_inventory'` تغییر کرد، شاخه‌ی واقعی با export بالا وصل شد. K9 الان صندوق عقب رو واقعاً چک می‌کند.
17. `esx_property/client/main.lua` + `server/main.lua` — `exports['esx_inventory']:stash(...)` (کرش تضمین‌شده، حتی pcall هم نداشت) حذف شد؛ `OpenPropertyInventoryMenu` الان از منوی واقعی و کارکننده‌ی `OpenRoomInventoryMenu` استفاده می‌کند. رویداد جدید `esx_property:adminOpenPropertyStash` برای دسترسی ادمین.
18. `Unique_AdminPanel/server/aduty_commands.lua` + `client/aduty_client.lua` — فرمان `openproperty` الان به رویداد واقعی بالا وصله؛ هندلر مرده‌ی `exports['lc-inventory']:stash(...)` حذف شد.
19. `[SCRIPT]/ScriptPack/itemshop_shared.lua` — مسیر آیکون از `esx_inventory` به `Unique_inventory/html/img/items/`.

### بررسی شد و نیاز به فیکس نداشت (false positive / از قبل درست بود)
- `ox_target` — چک `hasExport('ox_inventory.Items')` از قبل fallback درست دارد.
- `vms_housing` — **از قبل** یه آداپتور کامل و درست برای `Unique_inventory` دارد (`integration/[inventory]/Unique_inventory/`) و `DetectActiveInventory()` اول از همه چک `Unique_inventory` می‌کند. هیچ تغییری لازم نبود.
- `Unique_Garage/server/carlock_sv.lua` — فقط کامنت توضیحی بود، کد واقعی از قبل essentialmode-native بود.
- `esx_property/client/plus.lua` — فقط کد کامنت‌شده (نمونه)، غیرفعال.

## ۴. آرموری جاب‌ها → منوی واقعی Unique_inventory (نه منوی قدیمی ESX)

کشف شد: جاب‌های fbi/police/sheriff/marshal/cia/doa/judge/mt/cid هر کدوم آرموری خودشون رو با منوی قدیمی `ESX.UI.Menu.Open('default', ...)` باز می‌کردن (کاملاً جدا از سیستم اینونتوری) — دقیقاً همونی که تو اسکرین‌شات‌ها دیدیم. خوشبختانه هر دو سیستم از **همون دیتای مشترک** (`society_<jobname>` تو esx_addoninventory/esx_datastore) استفاده می‌کردن، پس انتقال بدون از دست رفتن دیتا انجام شد:

20. هر ۹ فایل (`fbi_main.lua`, `police_main.lua`, `sheriff_main.lua`, `marshal_main.lua`, `cia_main.lua`, `doa_main.lua`, `judge_main.lua`, `mt_main.lua`, `cid_main.lua`) — دکمه‌ی آرموری الان `esx_inventoryhud:OpenJobInventory1` (سلاح) / `OpenJobInventory2` (استوک) رو صدا می‌زنه؛ منوی واقعی Unique_inventory با بج قفل باز میشه. `buy_weapons`/`buy_items` (خرید جدید، فیچر جداست) دست‌نخورده موند.

## ۵. دسترسی ناقص باس‌منو با رتبه‌ی آخر (گزارش‌شده: FBI رتبه ۷)

21. `[JOB]/esx_society/client/main.lua` — همه‌ی بخش‌های باس‌منو (پول سوسایتی، برداشت، مدیریت کارمند، مدیریت جاب) فقط با `grade >= 10` (یا `>= 16` برای police/sheriff/mt) باز می‌شدن. جاب‌هایی مثل FBI که بالاترین رتبه‌شون عددی زیر این حدّه (مثلاً ۷)، باسِ واقعی‌شون (`grade_name == 'boss'`) هیچ‌وقت این شرط‌ها رو پاس نمی‌کرد. الان `or isBoss` به همه‌شون اضافه شد — باس واقعی هر جابی، صرف‌نظر از رتبه‌ی عددی، دسترسی کامل داره.

## ۶. کرش زنده‌ی گزارش‌شده بعد از دیپلوی: `No such export stash in resource esx_inventory`

22. `[ARSHIA]/Unique_ALLGangs/client/main.lua` + `server/Gangs.lua` — سیستم قدیمی آرموری گنگ (`For5MGangs:openArmoryStash`) همچنان `exports['esx_inventory']:stash(...)` رو صدا می‌زد (کرش تضمین‌شده، چون esx_inventory نصب نیست). الان `For5M:OpenInventory` مستقیم `esx_inventoryhud:OpenGangInventory` (منوی واقعی Unique_inventory) رو باز می‌کنه. **تغییر رفتار:** سیستم قدیم هر آرموری فیزیکی گنگ رو جدا ذخیره می‌کرد (`gang_armory_1_1`, `gang_armory_1_2`, ...)؛ چون این سیستم اصلاً باز نمی‌شد (همیشه کرش)، الان همه‌ی آرموری‌های یه گنگ یه اینونتوری مشترک نشون می‌دن (یکسان با چیزی که از قبل تو منوی اصلی اینونتوری گنگ بود).
23. همون فایل — `registerStashAccessCheck` هم همیشه سعی می‌کرد به `exports['esx_inventory']` وصل بشه و هر بار fail می‌شد و لاگ اسپم می‌کرد (`FAILED to register access check ... will keep retrying`). چون enforcement واقعی الان از طریق `Unique_ALLGangs:checkItemAccess` انجام میشه (بخش ۲)، این تابع و تایمر ۳ ثانیه‌ایش رو بی‌اثر کردم (دیگه تلاش/لاگ اسپم نداره).

## هنوز باقی‌مانده (عمداً دست‌نخورده، نیاز به تست زنده روی سرور دارند)

- **`esx_inventoryhud:moveItem`** (درگ‌اند‌دراپ بین اسلات‌ها) — سمت سرور listener ندارد. essentialmode یه لایه‌ی کامل persist-شده (`slots.lua`) دارد ولی شماره‌ی اسلات NUI (ایندکس آرِی) با شماره‌ی اسلات پرسیستنت essentialmode (۱..۵۰+بک‌پک) یکی نیست — وصل‌کردن مستقیم خطرناکه، نیاز به تغییر `requestItens` (سمت سرور) + رندر NUI هم‌زمان دارد.
- NUI callback های orphan دیگه: `moverItemChest`, `moverItemHouse`, `moverItemTrunckChest`, `buyItem`, `colocarItemInventory`, `retirarItemChest`, `venderItem`.
- آیکون‌های گمشده: ۳۰ آیتم کافه + بخشی از آیتم‌های `itemseller_config.lua` (مرغ/گوشت/حیوانات) هنوز PNG ندارن.
