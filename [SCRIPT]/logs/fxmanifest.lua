fx_version 'bodacious'
game 'gta5'
lua54 'yes'

description 'Discord Bot + Unique_LogPanel (ادغام‌شده) - سیستم لاگ کامل سرور + پنل مشاهده'
version '1.1.0'

server_script {
	'@oxmysql/lib/MySQL.lua',
	'shared/*.lua',
	'SERVER/Server.lua',
	'SERVER/LogPanel.lua',
}

client_script {
	'shared/*.lua',
	'CLIENT/*.lua',
}

-- ✅ ادغام شد: پنل NUI که قبلاً ریسورس جدای Unique_LogPanel بود
ui_page 'html/index.html'

files {
	'html/index.html',
}

server_export 'SendToSite'
server_export 'SafeCall'
server_export 'SafeWrap'

-- ✅ اضافه شد: برای اینکه ریسورس‌های دیگه (مینی‌گیم لاک‌پیک، سیستم دستبند پلیس)
-- بتونن مستقیم این دو تا export کلاینتی رو صدا بزنن
export 'ReportLockpick'
export 'ReportCuffEscape'

-- ✅ ادغام شد از Unique_LogPanel — قبلاً exports['Unique_LogPanel']:... بودن،
-- از الان exports['logs']:... صدا زده می‌شن (مستندات پایین همین ریپو هم آپدیت شد)
server_export 'OpenLogPanel'
server_export 'OpenAdminLogPanel'
server_export 'IsLogPanelBoss'
server_export 'IsLogPanelAdmin'

