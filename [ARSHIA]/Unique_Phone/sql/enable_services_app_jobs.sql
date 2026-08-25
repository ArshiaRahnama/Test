-- Unique_Phone — فعال کردن ستون jobs.hasapp برای اپ «Services» گوشی
--
-- این ستون از قبل توی جدول jobs بود ولی برای هیچ جابی فعال نشده بود؛
-- اپ Services هم بهش وصل نبود (یه لیست قدیمی و هاردکد توی Lua داشت).
-- الان اپ مستقیم از این ستون می‌خونه، پس این کوئری رو یه بار اجرا کن.
--
-- این لیست دقیقاً همون ۱۴ جابی هست که قبلاً هاردکد بودن (برای اینکه هیچ
-- رفتاری برای جاب‌های موجود عوض نشه):
UPDATE `jobs` SET `hasapp` = 1 WHERE `name` IN (
    'ambulance', 'taxi', 'mechanic', 'weazel', 'police', 'sheriff',
    'mt', 'fbi', 'cid', 'cia', 'marshal', 'judge', 'doa', 'uwucafe'
);

-- از این به بعد، برای اضافه کردن هر جاب جدیدی به این اپ (لیست کامل
-- جاب‌های موجود رو با `SELECT name, label FROM jobs;` می‌تونی ببینی)،
-- فقط همین یه خط کافیه — دیگه نیازی به تغییر کد نیست:
--
-- UPDATE `jobs` SET `hasapp` = 1 WHERE `name` = 'اسم_جاب_جدید';
--
-- مثلاً اگه می‌خوای «government» یا «dadgostari» یا «artesh» هم توی
-- اپ Services دیده بشن:
--
-- UPDATE `jobs` SET `hasapp` = 1 WHERE `name` IN ('government', 'dadgostari', 'artesh');
