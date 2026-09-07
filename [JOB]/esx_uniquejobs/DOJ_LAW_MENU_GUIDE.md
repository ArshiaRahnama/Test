# راهنمای کامل منوی `/doj` و `/law` (به ترتیب دقیق نمایش)

## `/doj` -- marshal / judge / cia / cid / fbi / doa

هر بار که `/doj` می‌زنید، این گزینه‌ها رو دقیقاً به همین ترتیب می‌بینید:

1. **DOJ Operations** -- فقط یک خط اطلاعاتی (غیرقابل‌کلیک) که شغل فعلی‌تون رو نشون می‌ده.
2. **Sabeghe-ye Kayfari (Background Check)** -- با وارد کردن ID یا اسم، کل سابقه‌ی
   دستگیری/اتهام/جریمه‌ی پرداخت‌نشده‌ی اون شخص رو می‌کشه (`criminal_records`).
3. **Jostoju-ye Shomare Telephone** -- با وارد کردن یک شماره‌ی ۱۰ رقمی، صاحبش رو پیدا
   می‌کنه.
4. **Parvande-ha (Cases)** -- سیستم اصلی پرونده‌سازی (`dept_cases`):
   - **Parvande-ye Jadid** -- ساخت پرونده‌ی جدید با عنوان.
   - **Jostoju Bar Asas-e Mozanne** -- پیدا کردن پرونده‌ها بر اساس اسم مظنون.
   - **Filter Bar Asas-e Vaziat** -- فیلتر بر اساس Open/Closed/... .
   - با انتخاب هر پرونده، وارد جزئیاتش می‌شید:
     - Massol Shodan (پذیرفتن مسئولیت پرونده)
     - Taghire Ahamiyat (کم/متوسط/زیاد)
     - تغییر وضعیت (Open/Cold/Referred/Closed)
     - Sabt-e Yaddasht/Madrak (یادداشت یا مدرک)
     - Ezafe Kardan-e Etteham (از روی Ghanoon-name)
     - Erja-e Parvande Be Departmani Digar
     - **Timeline-e Parvande** -- کل تاریخچه‌ی یکجا (فیچر جدید)
     - **Zamanbandi Jalase-ye Dadgah** -- اضافه به تقویم دادگاه (فیچر جدید)
     - **Zanjire-ye Negahdari-ye Madarek** -- زنجیره‌ی تحویل مدارک (فیچر جدید)
5. **Ghanoon-name (Codebook)** -- مرور قوانین دسته‌بندی‌شده؛ فقط **judge** می‌تونه
   ویرایش/حذف/اضافه کنه، بقیه فقط می‌بینن.
6. **Afsaran-e Online DOJ** -- لیست هم‌تیمی‌های DOJ که الان آنلاینن.
7. **Baz Kardan CAD (MDT)** *(جدید)* -- میان‌بر مستقیم به پنل `/cad`.
8. **Taghvim-e Dadgah (Court Docket)** *(جدید)* -- لیست جلسات دادگاه؛ فقط **judge**
   می‌تونه حکم نهایی (Guilty/Not Guilty/Plea Deal) ثبت کنه -- که خودکار پرونده رو
   می‌بنده.
9. **Dashboard-e Amari** *(جدید)* -- جرایم پرتکرار، روند بازداشت ۱۴ روز اخیر،
   فعال‌ترین افسران (نمودار میله‌ای متنی).
10. **Barresi Amalkard Afsar** *(جدید)* -- پروفایل یک افسر: تعداد دستگیری/اتهام،
    رتبه، سابقه‌ی IA.
11. **Hokm-ha (Warrants)** -- *فقط marshal/judge* -- درخواست/بررسی حکم بازداشت.
12. **Amaliyat-e Vizhe (FBI/CIA)** -- *فقط fbi/cia* -- نظارت، اتاق بازجویی، شنود،
    ترکر.
13. **Sabt-e Madrak Dar Parvande** -- *فقط cid* -- میان‌بر مستقیم برای اضافه کردن
    مدرک به یک پرونده‌ی باز.
14. **Sabt-e Zabti / Sabeghe-ye Zabti-ha / Modiriyat-e Khabarchin** -- *فقط doa* --
    ثبت اموال ضبط‌شده، سابقه‌ی ضبطیات، مدیریت خبرچین‌ها.

## `/law` -- police / sheriff / mt

1. **Jostoju Dar Ghanoon-name** -- جستجوی سریع در قوانین بر اساس کد یا عنوان.
2. **دسته‌بندی‌های قانون** (فقط دسته‌هایی که حداقل یک قانون دارن نشون داده می‌شن):
   Ranandegi (رانندگی) / Amval (اموال) / Khoshoonat (خشونت) / Mavad-e Mokhader
   (مواد مخدر) / Salah (سلاح) / Sayer (سایر) -- هرکدوم رو باز کنید، لیست قوانین
   اون دسته با مبلغ جریمه/زندان میاد؛ با انتخاب یک قانون و دادن ID بازیکن، جریمه
   خودکار صادر می‌شه.
3. **Baz Kardan CAD (MDT)** *(جدید)* -- میان‌بر مستقیم به پنل `/cad`.
4. **Sabt-e Tavaghof (Traffic Stop)** *(جدید)*:
   - **Sabt-e Tavaghof-e Jadid** -- دلیل تعقیب + پلاک (اختیاری، خودکار BOLO چک
     می‌شه) + نتیجه (اخطار/جریمه/بازرسی/ارجاع به دستگیری) + توضیحات.
   - **Barresi Pelak (BOLO)** -- چک سریع یک پلاک بدون ثبت تعقیب.
   - **BOLO-haye Active** -- فهرست کامل BOLO های فعلی سرور (از CAD).
   - **Tarikhche-ye Tavaghof-ha** -- سابقه‌ی تعقیب‌های ثبت‌شده.
5. **Mugshot** *(جدید)*:
   - عکس فعلی شهروند (اگه باشه) + گزینه‌ی گرفتن/جایگزینی عکس جدید.
   - **Rap Sheet-e Kamel** -- کارت شناسایی کامل: مشخصات ظاهری، آخرین مکان
     شناخته‌شده، کل سابقه‌ی کیفری از **هر دو** سیستم (dept_cases + CAD)، و یک
     نسخه‌ی متنی/Markdown قابل‌کپی (شبیه چاپ).

هر آیتمی که «(جدید)» نداره، از قبل توی ریسورس اصلی شما بوده و دست نخورده.
