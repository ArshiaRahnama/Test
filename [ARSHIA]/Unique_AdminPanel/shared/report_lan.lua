--[[ ===========================================================================
    Unique RP - Report System | shared/report_lan.lua
    همه‌ی متن‌های سیستم. برای تغییر زبان فقط همینجا رو دست بزن.
=========================================================================== ]]

ReportLan = {}

ReportLan.prefix            = "^3[ Unique RP | ریپورت ]^0"

-- کاربر
ReportLan.submitReport      = "ریپورت شما ثبت شد. لطفاً تا تایید ادمین صبر کنید."
ReportLan.reportLimit       = "شما یک ریپورت باز دارید. تا بسته شدنش نمی‌تونید ریپورت جدید بدید."
ReportLan.cooldown          = "خیلی سریع ریپورت می‌دی. %d ثانیه دیگه دوباره امتحان کن."
ReportLan.Acceptuser        = "ریپورت شما تایید شد. با دستور /report وارد چت با ادمین شو."
ReportLan.closed            = "ریپورت شما بسته شد. ممنون از همراهیت."
ReportLan.archived          = "ریپورت بایگانی شد."
ReportLan.UserAlertNewMessage = "یک پیام جدید از طرف ادمین در ریپورت داری."
ReportLan.tankstofeedback   = "ممنون بابت ثبت نظرت."
ReportLan.playerRevive      = "توسط ادمین ریوایو شدی."
ReportLan.playerGiveCar     = "توسط ادمین یک وسیله نقلیه دریافت کردی."
ReportLan.UserAdminTeleport = "ادمین به موقعیت تو تلپورت شد."
ReportLan.broughtToAdmin    = "توسط ادمین به موقعیتش منتقل شدی."
ReportLan.frozen            = "توسط ادمین فریز شدی."
ReportLan.unfrozen          = "فریز برداشته شد."

-- ادمین
ReportLan.newReprot         = "یک ریپورت جدید ثبت شده."
ReportLan.newReportDetailed = "ریپورت جدید #%s | %s | اولویت: %s"
ReportLan.AdminAlertNewMessage = "یک پیام جدید در ریپورت #%s داری. سریع‌تر پاسخ بده."
ReportLan.Accept            = "ریپورت #%s رو قبول کردی."
ReportLan.acceptByauthor    = "این ریپورت رو یک ادمین دیگه قبول کرده."
ReportLan.cantaccept        = "نمی‌تونی ریپورت خودت رو قبول کنی."
ReportLan.CantAfterAccep    = "این ریپورت دیگه در وضعیت انتظار نیست."
ReportLan.notYours          = "این ریپورت به تو تخصیص داده نشده."
ReportLan.deleteReport      = "ریپورت حذف شد."
ReportLan.cantdel           = "به حذف ریپورت دسترسی نداری."
ReportLan.closedByAdmin     = "ریپورت #%s رو بستی."
ReportLan.AdminRevive       = "پلیر رو ریوایو کردی."
ReportLan.AdminTeleport     = "به موقعیت پلیر تلپورت شدی."
ReportLan.AdminReturn       = "به موقعیت قبلیت برگشتی."
ReportLan.noReturnPoint     = "موقعیت قبلی‌ای برای برگشت ذخیره نشده."
ReportLan.adminGiveCar      = "وسیله نقلیه ادمین اسپاون شد."
ReportLan.adminxpAdd        = "XP ادمینی دریافت کردی. (+%d)"
ReportLan.adminxpDel        = "از XP ادمینیت کم شد. (-%d)"
ReportLan.slaWarn           = "ریپورت #%s بعد از %d دقیقه هنوز قبول نشده."

-- عمومی
ReportLan.err               = "خطای سرور. دوباره تلاش کن."
ReportLan.notAccess         = "به این بخش دسترسی نداری."
ReportLan.notOnline         = "پلیر آنلاین نیست."
ReportLan.reportnotfound    = "ریپورت پیدا نشد."
ReportLan.invalidCategory   = "موضوع انتخاب‌شده معتبر نیست."
ReportLan.titleShort        = "عنوان باید بین %d تا %d کاراکتر باشه."
ReportLan.infoShort         = "توضیحات باید بین %d تا %d کاراکتر باشه."
ReportLan.tooFast           = "خیلی سریع پیام می‌فرستی."
ReportLan.esxNotReady       = "سیستم هنوز آماده نیست. چند لحظه دیگه دوباره امتحان کن."
