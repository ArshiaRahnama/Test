HubConfig = {}

-- کامندی که منوی هاب رو باز میکنه
HubConfig.EventCommand = 'event'
HubConfig.ESX = 'esx:getSharedObject'

-- سه رویداد. دکمه‌های منو دقیقاً همون کامندهای ماژول‌های اصلی رو صدا میزنن
-- (هیچ منطقی از warzone/gungame/capture اینجا کپی نشده).
-- permDisplay فقط ظاهریه (نمایش/مخفی‌کردن دکمه‌ی «شروع»)؛ چک واقعیِ
-- پرمیژن همیشه توی خودِ ماژول اصلی انجام میشه.
HubConfig.Events = {
    {
        id          = 'warzone',
        name        = 'وار زون',
        nameEn      = 'WARZONE',
        desc        = 'حالت بتل‌رویال تیمی. اسکواد ببند، تو زون بمون، آخرین نفر باش.',
        icon        = '🪖',
        color       = '#ff9d2f',
        colorSoft   = 'rgba(255, 157, 47, 0.16)',
        joinCmd     = 'wz',              -- WZConfig.JoinLobbeyCommend
        startCmd    = 'startwarzone',    -- WZConfig.StartCommend
        panelCmd    = 'warzone',         -- WZConfig.menuCommend
        statsCmd    = 'wzstats',         -- WZConfig.statsCommend
        permDisplay = 16,                -- WZConfig.permission
    },
    {
        id          = 'gungame',
        name        = 'گان گیم',
        nameEn      = 'GUNGAME',
        desc        = 'با هر کیل یه اسلحه‌ی جدید. اولین نفری که به آخر برسه برنده‌ست.',
        icon        = '🔫',
        color       = '#39ff6a',
        colorSoft   = 'rgba(57, 255, 106, 0.16)',
        joinCmd     = 'jgg',             -- GGConfig.JoinCommand
        startCmd    = 'gungame start',   -- GGConfig.AdminCommand
        panelCmd    = nil,
        statsCmd    = 'gungamestats',    -- GGConfig.StatsCommand
        permDisplay = 9,                 -- GGConfig.PermissionLevel
    },
    {
        id          = 'capture',
        name        = 'کپچر گنگ‌ها',
        nameEn      = 'CAPTURE',
        desc        = 'گنگ‌ها برای تصرف زون‌ها می‌جنگن. با /joinCap از پایگاه گنگت وارد شو.',
        icon        = '🚩',
        color       = '#ff5468',
        colorSoft   = 'rgba(255, 84, 104, 0.16)',
        joinCmd     = 'joinCap',         -- CapConfig.JoinCaptureCommand
        startCmd    = 'startCap',        -- CapConfig.StartCaptureCommand
        panelCmd    = 'capture',         -- CapConfig.DashboardCommand
        statsCmd    = 'captureStats',    -- CapConfig.StatsCommand
        permDisplay = 11,                -- CapConfig.CommandPerm(10) + 1
    },
}
