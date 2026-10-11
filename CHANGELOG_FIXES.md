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

## ۷. متن فارسی تو اینونتوری → انگلیسی

24. `[ARSHIA]/Unique_inventory/client/inventory_main.lua` — عنوان‌های `'اسلحه خانه'`, `'کمد خانه'`, `'کمد وسایل'` → `'Armory'`, `'House Storage'`, `'Job Storage'`.
25. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` — دو تا نوتیفیکیشن قفل‌آیتم (که خودم تو دور قبل اضافه کرده بودم) هم به انگلیسی برگشت.

## ۸. باگ بزرگ: آرموری سلاح/استوک هر جاب واقعاً داشت استوک پلیس رو نشون می‌داد

26. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` — `getJobArmoryWeapons` (job1) از `'esx_policejob:getArmoryWeapons'` و `getJobINV2` (job2) از `'esx_policejob:getStockItems'` استفاده می‌کردن که **هاردکد روی `society_police`** بودن، فارغ از جاب واقعی بازیکن. یعنی FBI/شریف/مارشال و... همیشه استوک پلیس رو می‌دیدن، نه استوک واقعی خودشون - دقیقاً همون چیزی که باعث میشد «خریدن/گذاشتن اسلحه تو آرموری نشون داده نشه». الان مستقیم از `society_<jobواقعی>` می‌خونن.

## ۹. باگ E/مارکر برای آرموری همه‌ی سازمان‌ها

27. هر ۹ فایل جاب (fbi/police/sheriff/marshal/cia/doa/judge/mt/cid) — `CurrentAction == 'menu_armory'` بعد از هر اکشن `nil` میشد (برخلاف `menu_boss_actions` که قبلاً خودتون فیکس کرده بودید)، یعنی باید از مارکر خارج و دوباره وارد میشدی تا E دوباره کار کنه. الان `menu_armory` هم مثل `menu_boss_actions` از ری‌ست مستثنی شد.

## ۱۰. مدیریت لباس → vms_clothestore (بدون بلک‌لیست برای باس)

28. `[ARSHIA]/vms_clothestore/config.lua` + `client/client.lua` — `Config.ManagementStore` (بدون بلک‌لیست، همه‌ی دسته‌ها فعال، قیمت ۰) + export های `OpenManagementStore()`/`IsMenuOpened()` اضافه شد.
29. `[JOB]/esx_society/client/main.lua` — هر ۴ جای «مدیریت یونیفرم باس» که esx_skin's کامل باز می‌کرد، الان `vms_clothestore` رو تو حالت مدیریتی (بدون بلک‌لیست) باز می‌کنه؛ منطق capture-و-ذخیره‌ی اسکین دست‌نخورده موند.
- بلک‌لیست شاپ‌های عمومی از قبل تو `Config.Stores[n].blockedClothes` پیاده‌سازی و enforce شده بود (فرستاده میشه به NUI به‌عنوان `disabledValues`)؛ فقط عددهای واقعی لباس‌ها رو خودتون باید تو کانفیگ پر کنید (نمونه‌ی کامنت‌شده همونجا هست) - این اعداد سلیقه‌ایه و نمی‌تونستم حدس بزنم.

## ۱۱. اسپان ماشین سازمان‌ها → وصل به سیستم یونیت

30. `[JOB]/esx_uniquejobs/client/unit_plate_helper.lua` (جدید) + ۱۳ فایل جاب (police/fbi/sheriff/marshal/cia/doa/judge/mt/cid/ambulance/taxi/mechanic/weazel) — دیگه دیالوگ «پلاک رو دستی وارد کن» نشون داده نمیشه. الان از `esx_uniquejobs:getUnitMenu` (سیستم یونیت موجود) می‌پرسه: اگه یونیت نداری میگه «اول /unit بزن»، اگه داری، پلاک خودکار از روی callsign یونیتت ساخته میشه (مثلاً یونیت `STAFF-1` → پلاک `STAFF1`).
- **کاری که انجام ندادم:** انتقال خودِ منوی لیست مدل ماشین (`ESX.UI.Menu` قدیمی) به ظاهر/UI جدید Unique_Garage. بررسی کردم - Unique_Garage فقط یه سیستم پارک‌مترِ شخصیه، هیچ UI آماده‌ای برای «انتخاب مدل ماشین سازمانی از لیست مجاز» نداره؛ ساختن این از صفر یه فیچر جدید و ریسکی‌ه که بدون تست زنده روی سرور نمی‌خواستم حدسی پیش ببرم. اگه بخوای، به‌عنوان یه کار جدا باهاش شروع می‌کنم.

## ۱۲. گاراژ سازمان‌ها → همون منوی Unique_Garage که برای گنگ کار می‌کرد

کشف شد: `esx_society` از قبل یه سیستم کامل مدیریت ماشین per-rank داشت (`ChangeVehiclePerm` - همون "Manage Weapons"-استایل چک‌باکس ✅/❌ که تو اسکرین‌شات‌ها دیدیم، برای ماشین) + سیستم افزودن ماشین جدید (`esx_society:addCarJob`)، ولی **هیچ‌کدوم از این‌ها به عملِ واقعیِ «گرفتن ماشین» وصل نبودن** - هر ۱۳ فایل جاب (police/fbi/sheriff/marshal/cia/doa/judge/mt/cid/ambulance/taxi/mechanic/weazel) خودشون یه سیستم جدا و قدیمی داشتن.

همچنین کشف شد: خودِ کوئری‌های `Unique_Garage` (`GetVehicles`/`IsVehOwned`/`SetVehState`) اصلاً هیچ validation گنگ-محورانه‌ای ندارن - فقط یه رشته‌ی `owner` رو چک می‌کنن. یعنی دادن اسم جاب به‌جای اسم گنگ، همون کد اثبات‌شده‌ی گنگ رو بدون هیچ تغییری تو Unique_Garage کار می‌انداخت.

31. `[JOB]/esx_society/server/main.lua` — ۳ تکه‌ی جدید:
    - `esx_society:GetJobRankVehicleAccess` (کال‌بک) - دسترسی per-rank واقعی رو برمی‌گردونه (همون دیتایی که `ChangeVehiclePerm` می‌نویسه).
    - `esx_society:takeJobVehicle(model)` (event) - چک دسترسی واقعی + پلاک از روی callsign یونیت + ثبت تو `owned_vehicles` (دقیقاً همون جدولی که Unique_Garage می‌خونه).
    - کامند `/addjobvehicle [model] [plate]` و `/removejobvehicle [plate]` (باس/ادمین) - دقیقاً همونی که خواسته شد.
32. `[ARSHIA]/Unique_Garage/client.lua` — نوع جدید `"jobfleet"` تو `OpenMenuG` (کپی دقیق از نوع `"gang"` که خودتون تأیید کردید کار می‌کنه) + دو رویداد جدید `Unique_Garage:OpenJobFleetGarage`/`StoreJobFleetVehicle`.
33. `[JOB]/esx_uniquejobs/client/job_fleet_helper.lua` (جدید) — تابع مشترک `OpenJobFleetGarage(model)` که هر ۱۳ فایل جاب صداش می‌زنن.
34. هر ۱۳ فایل جاب — دیالوگ پلاک دستی + اسپان مستقیم (فیکس دور قبل) برداشته شد و جاش `OpenJobFleetGarage(model)` نشست - همون منوی بصری Unique_Garage که برای گنگ تأیید شد، الان برای همه‌ی سازمان‌ها هم باز میشه.

**توجه مهم (تغییر رفتار):** چون الان ماشین‌ها واقعاً تو `owned_vehicles` ثبت میشن (نه اسپان یکبار-مصرف قبلی)، از این به بعد هر ماشینی که یه افسر بگیره **ذخیره/قابل‌بازیابی‌ست** (مثل ماشین گنگ) - می‌تونه با گرفتن همون مدل دوباره، همون وسیله رو از گاراژ پس بگیره، یا با `StoreJobFleetVehicle` بذارش کنار. این عمداً همون رفتاریه که خودتون برای گنگ تأیید کرده بودید.

## ۱۳. فیکس «گاراژ سازمان‌ها» بعد از گزارش خطای زنده

35. `[JOB]/esx_society/server/main.lua` — پیام عمومی «Could not reach the vehicle fleet - try again» حتی وقتی سرور قبلاً دلیل دقیق رد شدن (عدم دسترسی رتبه / نداشتن یونیت) رو نشون داده بود هم ظاهر می‌شد، چون کلاینت فقط منتظر موفقیت بود و در غیر این صورت کور کور تا ۵ ثانیه صبر می‌کرد. الان هر مسیر رد شدن هم `esx_society:jobVehicleFailed` رو فایر می‌کنه.
36. `[JOB]/esx_uniquejobs/client/job_fleet_helper.lua` — به سیگنال جدید بالا هم گوش می‌ده و فوراً متوقف می‌شه؛ پیام عمومی فقط برای یه timeout واقعی (نه یه رد شدن مشخص) نشون داده می‌شه.

## ۱۴. باگ واقعی: برداشتن اسلحه از آرموری هیچ‌وقت از استوک کم نمی‌شد

37. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` (`Parzival:GetJobWeapon`) — این رویداد اسلحه رو به بازیکن می‌داد ولی **هیچ‌وقت از لیست weapons واقعی `society_<job>` کم نمی‌کرد** - یعنی استوک آرموری عملاً بی‌نهایت بود و هیچ‌وقت عوض نمی‌شد (دقیقاً همون چیزی که باعث می‌شد «برداشتن/گذاشتن گان لود نشه» به نظر بیاد). الان مثل `PutJobWeapon` با همون `store`، تعداد رو کم می‌کنه و اگه صفر شد، کامل از لیست حذفش می‌کنه.
38. همون فایل (`getJobArmoryWeapons`/`getJobINV1`) — عدد نمایش‌داده‌شده‌ی هر اسلحه تو UI همیشه هاردکد `1` بود (حتی موجودی واقعی بیشتر/کمتر). الان عدد واقعی از استوک نشون داده می‌شه.

## ۱۵. باگ ریشه‌ای: چرا چست آرموری خالی نشون می‌داد (و گاراژ سازمان ممکن بود هنگ کنه)

39. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` (`getJobArmoryWeapons`) — داخلش `TriggerEvent('esx_society:getWeapons', ...)` صدا زده می‌شد. این اسم با `ESX.RegisterServerCallback` ثبت شده نه `AddEventHandler`، پس هیچ listenerی نداشت و کل حلقه‌ی ساخت لیست (که داخل اون callback بود) هیچ‌وقت اجرا نمی‌شد → لیست همیشه خالی، حتی با استوک واقعی (همون چیزی که تو منوی Buy Guns با x15/x4 می‌دیدید). الان استوک واقعی مستقیم و همزمان خونده می‌شه. **تغییر رفتار:** قفل per-grade سلاح‌ها فعلاً fail-open (همه unlocked) تا وقتی esx_society یه event امن cross-resource براش بسازه.
40. `[JOB]/esx_society/server/main.lua` + `[ARSHIA]/Unique_Garage/client.lua` — همین ریشه روی `esx_society:GetJobRankVehicleAccess` (که خودم دور قبل با `ESX.RegisterServerCallback` ساخته بودم) هم بود؛ منوی jobfleet ممکن بود برای همیشه منتظر جواب بمونه. با یه جفت رویداد ساده‌ی request/reply (`requestJobRankVehicleAccess` / `jobRankVehicleAccessResult`) و timeout ۳ ثانیه‌ای (در صورت نرسیدن جواب، همه‌چیز unlocked نشون داده می‌شه) جایگزین شد.

## ۱۶. رویدادهای بیرون‌داده‌شده + برگشت قفل رتبه‌ی سلاح

41. `[JOB]/esx_society/server/main.lua` — `AddEventHandler('esx_society:getWeapons', function(src, rank, job, cb))` اضافه شد؛ نسخه‌ی event عمومی و cross-resource-safe همون کال‌بک `ESX.RegisterServerCallback` (همون دیتا: `Jobs[job].grades[rank].weapons`).
42. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` — `getJobArmoryWeapons` دوباره قفل per-grade سلاح رو از همین event می‌گیره. لیست استوک بیرون از callback ساخته می‌شه، پس اگه esx_society جواب نده یا رتبه تنظیم نشده باشه، همه unlocked می‌مونن (لیست دیگه هیچ‌وقت خالی نمی‌شه).

## ۱۷. فیکس بعد از لاگ کنسول: «Could not reach the vehicle fleet» + جاب استورج خالی

43. `[JOB]/esx_uniquejobs/client/job_fleet_helper.lua` + `[ARSHIA]/Unique_Garage/client.lua` — **ریشه‌ی واقعی خطای ناوگان:** لاگ کنسول نشون داد `event esx_society:jobVehicleReady/jobVehicleFailed was not safe for net`. این رویدادها از سرور با `TriggerClientEvent` می‌اومدن ولی سمت کلاینت `RegisterNetEvent` نشده بودن، پس FiveM دورشون می‌ریخت و همیشه timeout می‌شد. الان (و برای `esx_society:jobRankVehicleAccessResult` تو Unique_Garage) ثبت شدن. (فیکس‌های قبلی این بخش جلوی این رو نمی‌گرفتن.)
44. `[ESX]/esx_menu_default/client/main.lua` — خطای `attempt to index a nil value (local 'menu')` تو `menu_cancel`/`menu_submit`/`menu_change` وقتی اسکریپت خودش منو رو بسته بود؛ الان nil-safe.
45. `[ARSHIA]/Unique_inventory/server/inventory_main.lua` — `getJobINV2` (Job Storage) با خوندن دفاعی همه‌ی فیلدها (count رشته‌ای/nil، label نبودن) بازنویسی شد و وزن (`peso`) هم می‌فرسته؛ `getJobINV1` هم وزن سلاح می‌فرسته (قبلاً تو توضیحات «NaN kg» می‌شد). اگه استورج واقعاً خالی باشه، سرور تو کنسول می‌نویسه `Job Storage for society_<job> is empty (... found / NOT FOUND ...)` تا معلوم بشه دیتا نیست یا اینونتوری پیدا نشده.

## هنوز باقی‌مانده (عمداً دست‌نخورده، نیاز به تست زنده روی سرور دارند)

- **`esx_inventoryhud:moveItem`** (درگ‌اند‌دراپ بین اسلات‌ها) — سمت سرور listener ندارد. essentialmode یه لایه‌ی کامل persist-شده (`slots.lua`) دارد ولی شماره‌ی اسلات NUI (ایندکس آرِی) با شماره‌ی اسلات پرسیستنت essentialmode (۱..۵۰+بک‌پک) یکی نیست — وصل‌کردن مستقیم خطرناکه، نیاز به تغییر `requestItens` (سمت سرور) + رندر NUI هم‌زمان دارد.
- NUI callback های orphan دیگه: `moverItemChest`, `moverItemHouse`, `moverItemTrunckChest`, `buyItem`, `colocarItemInventory`, `retirarItemChest`, `venderItem`.
- آیکون‌های گمشده: ۳۰ آیتم کافه + بخشی از آیتم‌های `itemseller_config.lua` (مرغ/گوشت/حیوانات) هنوز PNG ندارن.

## ۱۸. آخرین اصلاحات (گاراژ مستقیم جاب‌ها، قفل پیش‌فرض اسلحه، ارموری گنگ)
46. **ارموری گنگ‌ها**: فایل جدید `Unique_inventory/server/gang_store.lua` (`EnsureGangStores`) — اگر `gang_<name>` در `addon_inventory`/`datastore` نبود خودکار ساخته می‌شود؛ دیگر `inventory/store nil` کرش نمی‌دهد.
47. **قفل اسلحه ارموری جاب**: حالا پیش‌فرض «بسته» است؛ فقط اسلحه‌ای که در Boss Action برای آن رنک `status=true` شده باز می‌شود (رنک ۱ با لیست خالی = همه قفل).
48. **ماشین جاب‌ها**: با E روی مارکر ماشین، مستقیم منوی Unique_Garage (ماشین‌های مجاز همان رنک) باز می‌شود (`esx_society:requestJobFleetStatus`). اگر جاب هنوز ماشینی ثبت‌شده ندارد (`/addjobvehicle`)، منوی قدیمی فقط به‌عنوان fallback باز می‌شود.
49. **مکانیک و هلیکوپتر**: مارکر ماشین مکانیک همان `OpenheliSpawnerMenu_mechanic` است؛ حالا مستقیم Unique_Garage (نوع `heli`) را باز می‌کند. منوی هلی بقیه جاب‌ها هم همین‌طور. `takeJobVehicle`/`requestJobFleetStatus` پارامتر `vehType` (car/heli/boat) دارند.
50. **یونیت اجباری برای ارگان‌های نظامی (DOJ + LAW)**: با E روی مارکر ماشین، اگر بازیکن در یونیت نباشد هیچ منویی باز نمی‌شود و پیام «You must join a unit first (/unit)» می‌آید؛ پلاک = callsign یونیت. ارگان‌های سرویس (taxi/mechanic/ambulance/weazel) نیازی به یونیت ندارند و پلاک را خودشان وارد می‌کنند (منوی لیست → دیالوگ پلاک → Unique_Garage).
51. **مدیریت گان/آیتم از باس اکشن**:
    - گنگ: `FMGangs:GetArmoryStashItemNames` حالا محتوای واقعی چست گنگ (آیتم‌ها + اسلحه‌ها از `gang_<name>`) را لیست می‌کند، نه جدول قدیمی `stashs` (که خالی بود). `checkItemAccess` به حروف بزرگ/کوچک حساس نیست (WEAPON_X).
    - جاب: «Manage Inventory» در باس اکشن حالا واقعاً روی Job Storage اعمال می‌شود (event جدید `esx_society:getItems`). تیک‌نخورده = قفل؛ رنک boss همیشه باز.
52. **تیک اسلحه/آیتم در باس اکشن برمی‌گشت (قفل اعمال نمی‌شد)**: `isPlayerBoss` در esx_society فقط `grade_name == 'boss'` را قبول می‌کرد؛ رنک آخر (مثل FBI رنک ۷ «General») منو را باز می‌کرد ولی سرور ذخیره را بی‌صدا رد می‌کرد و منو دوباره تیک‌های قدیمی را نشان می‌داد. حالا بالاترین رنک جاب هم باس حساب می‌شود (Weapons / Inventory / Vehicles).
53. **UI**: آیتم بدون count/peso دیگر `undefinedx` و `0.0kg` نشان نمی‌دهد (پیش‌فرض ۱ و وزن پیش‌فرض).
54. **Manage Weapons/Inventory/Vehicles — ضربدر یکی، تیک دیگری عوض می‌شد**: سرور حالا از روی داده‌ی ذخیره‌شده‌ی همان رنک شروع می‌کند و فقط ردیف کلیک‌شده را (بدون حساسیت به حروف) عوض می‌کند؛ ردیف‌های ارسالی کلاینت فقط برای شناخت لیست‌اند (`buildPermTable`).
55. **قفل ارموری جاب**: لیست مجاز مستقیم از `job_grades.weapons/items` (دیتابیس) خوانده می‌شود (`GetJobGradePerm`)، نه از event خارجی؛ پس دیگر هیچ‌وقت «fail-open» نمی‌شود. همه سلاح/آیتم‌ها برای همه نمایش داده می‌شوند؛ تیک‌نخورده = آیکن قفل + برداشتن رد می‌شود (سمت سرور هم چک می‌شود).

## ۱۹. لاگ دیباگ (برای پیدا کردن مشکل قفل/باس اکشن)
همه خطوط با پیشوند `[LOCKDBG]` چاپ می‌شوند. برای خاموش‌کردن: `Config.DebugLock = false` (config_joblock.lua) و `local LOCKDBG = false` (esx_society/server/main.lua).
- `[LOCKDBG]` (Unique_inventory): ARMORY open/تک‌تک سلاح‌ها، JOBPERM (خام job_grades)، JOBITEM، GANG، TAKE ...، و سمت کلاینت چیزی که NUI گرفته.
- `[LOCKDBG][society]`: isPlayerBoss، SAVE weapons/items/vehicles (قبل/بعد)، MENU read، EVENT getWeapons، FLEETSTATUS، TAKEVEHICLE.
- `[LOCKDBG][gangs]`: EditItemAccess، checkItemAccess، GetArmoryStashItemNames.
- `[LOCKDBG][fleet]` (کلاینت F8): پاسخ وضعیت ماشین.
هنگام استارت سرور هر ریسورس خط «build 2026-10-10-DEBUG» چاپ می‌کند تا معلوم شود فایل جدید لود شده.
56. **باگ پیدا‌شده با لاگ**: `attempt to call a nil value (global 'buildPermTable')` در esx_society/server/main.lua — تابع کمکی بعد از callback آیتم‌ها تعریف شده بود، پس Manage Inventory (آیتم‌ها) هیچ‌وقت ذخیره نمی‌شد. تابع به بالای فایل منتقل شد. (Manage Weapons درست کار می‌کرد.)
57. **قفل آیتم Job Storage برای باس**: استثنای `grade_name == 'boss'` حذف شد؛ آیتم‌ها مثل سلاح‌ها برای همه رنک‌ها (حتی باس) طبق تیک‌ها قفل/باز می‌شوند.

58. Armory + Job Storage merged into ONE chest ("Armory & Storage"): new callback `Parzival:getJobINVAll` (weapons + items together, each with its own lock badge); `OpenJobInventory1/2` both open it; put/take route by type (weapon -> Put/GetJobWeapon, item -> Put/GetJobItem). E-menu in all 9 armory jobs shows a single entry (non-boss opens the chest directly; boss still sees Buy weapons/items).

59. Armory & Storage diagnostics: always-on console lines `ARMORY&STORAGE src -> N weapons + M items`, `PUT job item ...`, `TAKE job item ... stock=`; deposit now notifies when the player lacks the amount / society has no entry.

60. ROOT CAUSE of "items don't show in Armory & Storage": IsJobItemLocked (MySQL.Sync, yields) was called INSIDE the esx_addoninventory callback, so TriggerEvent returned early and the item list was sent empty (it only worked for boss rank before because of the exemption removed in #57). Stock is now snapshotted first, locks computed after.

61. Debug console logging switched OFF (Config.DebugLock=false, esx_society LOCKDBG=false, gangs GDEBUG=false, fleet helper silent, boot banners removed). Pocket Space grid (#box-menu-item) moved down 3vw (top 11.7vw, height 30vw).

62. Pocket Space ring block (.box-peso) moved down 4.6vw (closer to the divider between the two rings).
63. Pocket Space ring block moved a bit lower (top 10.4vw).
64. Description / Serial Number block (.descricao-menu) moved down 3.8vw so it no longer overlaps the item grid.
65. Search box for the second inventory (armory/storage/gang chest/trunk): #barra-pesquisa-chest + pesquisarChest(); title line (.line-chest) shortened to 17vw so it no longer runs under the Pocket Space side.
66. Chest search moved under the 'Armory & Storage' title, header line removed. Console spam removed (inventory 2 loaded / MyData / slm prints). Admin panel: 'convert to ticket' now works for archived/closed reports (DB fallback); native JS confirm() replaced by an in-panel dialog (uiConfirm).
67. Chest search redesigned (centred glass pill with magnifier icon, header row). Last native confirm() (Admin panel 'Clear security hold') replaced by in-UI dialog - no native JS dialogs remain anywhere in the project.

68. Gangs now work exactly like the job armories: one chest "Gang Armory & Storage" (weapons + items, search, lock badges); gang boss menu -> rank -> Access Type has separate "Weapon Access" and "Item Access" lists with ✔ ALLOWED / ❌ LOCKED toggles (no "select armory" step any more - it blocked managing when no armory prop existed); weapons are stocked/taken one at a time like the job armory (count -1 / +1 instead of removing the whole entry / adding 250); weapon counts shown correctly; zero-count entries hidden; General Access flags putitem / takeitem are now enforced server-side (Unique_ALLGangs:checkGangFlag). Gang item locks have no boss exemption.

69. Gangs with SEVERAL armories: each armory (E marker) opens its OWN chest and has its OWN per-rank weapon/item access. First armory = legacy chest `gang_<name>` + legacy `access.itemAccess` (never-toggled = allowed, nothing changes for existing gangs); every additional armory = chest `gang_<name>_<key>` + `access.armoryAccess[key]` where everything is LOCKED until the boss opens it (boss action -> rank -> Weapon Access / Item Access -> pick the armory -> tick). Armory picker is skipped when the gang only has one. Server validates the armory key; take/put/list all resolve the right chest and lock table.
70. Gang chest title shows the armory number when the gang has several armories ("Gang Armory & Storage - Armory 2"): Parzival:getGangArmoryTitle + Unique_ALLGangs:getArmoryNumber; search box moved to x=43.6vw to leave room for the longer title.
