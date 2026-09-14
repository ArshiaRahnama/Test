-- users.jail از قبل روی سرور هست ولی int(11) بود (فقط 0 پیش‌فرض) و کافی برای
-- ذخیره‌ی JSON نیست. این ریسورس (unique_jail) و esx_aduty (کامند ajailoffline)
-- هر دو مستقیم روی همین ستون کار می‌کنن، پس به‌جای ساخت جدول جدا، فقط گسترشش می‌دیم.
ALTER TABLE `users` MODIFY `jail` TEXT NOT NULL DEFAULT '0';
