--[[ ===========================================================================
    Unique RP - Report System  |  تکه‌های fxmanifest.lua

    این یک fxmanifest کامل نیست. این‌ها بخش‌هایی‌ان که باید داخل
    Unique_AdminPanel/fxmanifest.lua جایگزین بخش‌های قدیمیِ ریپورت بشن.
=========================================================================== ]]


-- ############################  shared_scripts  ############################
-- خطِ قدیمی زیر رو پیدا کن:
--     'shared/report_shared_config.lua',
-- و همون‌جا بمونه (فایلش عوض شده، مسیرش نه). چیزی اضافه نمیشه.


-- ############################  client_scripts  ############################
-- این دو خط در انتهای client_scripts (دست‌نخورده):
--     'shared/report_client_config.lua',
--     'client/report_main.lua',


-- ############################  server_scripts  ############################
-- این چهار خط (دست‌نخورده، فقط محتوای فایل‌ها عوض شده):
--     'shared/report_server_config.lua',
--     'shared/report_lan.lua',
--     'server/report_function.lua',
--     'server/report_main.lua',
--
-- ⚠ ترتیب مهمه: report_function.lua حتما قبل از report_main.lua.


-- ###############################  exports  ################################
-- توی server_exports این چهارتا رو اضافه/جایگزین کن
-- (اسم‌های PNG_* هم به‌عنوان alias تو کد نگه داشته شدن، پس اگه
--  اسکریپت دیگه‌ای هنوز صداشون میزنه نمی‌شکنه):
--[[
server_exports {
    ...
    'GetReports',
    'UNIQUE_GET_ADMIN_XP',
    'UNIQUE_ADD_ADMIN_XP',
    'UNIQUE_REMOVE_ADMIN_XP',
    'UNIQUE_CLEAN_ADMIN_XP',
    ...
}
]]


-- #############################  dependencies  #############################
-- ⚠⚠ مهم‌ترین تغییر ⚠⚠
-- es_extended تو لیست dependencies نبود. همین باعث می‌شد که فایل‌های سرورِ
-- این ریسورس قبل از استارت es_extended اجرا بشن، TriggerEvent
-- ('esx:getSharedObject') به هیچ‌جا نخوره، و گلوبال ESX برای همیشه nil بمونه.
-- نتیجه‌اش دقیقا همون nil ای بود که موقع ثبت ریپورت می‌خوردی.
--[[
dependencies {
    'es_extended',      -- <<< این خط اضافه شد
    'essentialmode',
    'oxmysql',
    'Unique_Login',
}
]]


-- ################################  files  #################################
-- بخش ریپورت باید این شکلی باشه (فونت/عکس بدون تغییر):
--[[
files {
    ...
    'ui/report/*.html',
    'ui/report/css/*.css',
    'ui/report/js/*.js',
    'ui/report/font/*.*',
    'ui/report/img/*.*',
    ...
}
]]


-- #########################  html/index.html  ##############################
-- فایل پوسته‌ی NUI یک تغییر کوچیک لازم داره: کلیدِ تشخیص پنل ریپورت از
-- `_pngReport` به `_uniqueReport` عوض شده.
-- توی html/index.html این خط:
--     if (data._pngReport) {
-- رو بکن:
--     if (data._uniqueReport) {
