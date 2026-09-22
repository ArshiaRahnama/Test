-- Unique_Phone — ستون‌های جدید برای تم رنگی و کیس گوشی
-- (دقیقاً همون جدول/الگویی که `background` و `profilepicture` ازش استفاده
-- می‌کنن — یعنی جدول `users` خودِ essentialmode، نه یه جدول جدا)

ALTER TABLE `users`
  ADD COLUMN IF NOT EXISTS `phone_accentcolor` varchar(20) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `phone_case` varchar(20) DEFAULT NULL;
