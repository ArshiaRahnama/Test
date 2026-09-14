Config_Server = {}


Config_Server.license = "PNG_PGg@TVt$SfZpnqkY1731157838586"

------------------------------XP Setting----------------------------------
Config_Server.ActiveFeedBack = true                  -- if True set XPFeedBack if flase set XpAfterClose
Config_Server.XPFeedBack = { 0, 10, 20, 30, 40, 50 } -- only 6 number
Config_Server.XpAfterClose = 0

------------------------------Base Setting----------------------------------
-- توجه: revive دیگه از این کانفیگ استفاده نمیکنه (server/main.lua خودش
-- یه revive مستقل داره که وابسته به هیچ جابی نیست - چون esx_ambulancejob:revivex
-- فقط برای کسی که جاب ambulance داره کار میکنه، نه برای ادمین).
-- spect هم مستقیم به رویداد واقعی تو Unique_AdminPanel وصل شده: esx_spectate:spectatexxxx
Config_Server.NamePermInDB = 'permission_level'
Config_Server.PlayerNameInDB = 'playerName'
Config_Server.afterRestartCleanAllReport = true -- recommend -> true
Config_Server.SteamAPIKey = "" -- اختیاری: کلید Steam Web API خودت رو اینجا بذار تا آواتار ادمین/کاربر نمایش داده بشه، وگرنه عکس پیش‌فرض استفاده میشه
------------------------------Alert Setting----------------------------------
Config_Server.alertToNewMessage = "chat"        -- chat , notif , png_notif or ""
Config_Server.alertToNewReport = "chat"         -- chat , notif , png_notif or ""
------------------------------Command----------------------------------
Config_Server.CommandNameAddXP = 'addxp'
Config_Server.CommandNameDelXP = 'delxp'
Config_Server.CommandNameCleanXP = 'cleanxp'
Config_Server.CommandNameShowXP = 'showxp'
