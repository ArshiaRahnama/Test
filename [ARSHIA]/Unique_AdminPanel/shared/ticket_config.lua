--[[ ===========================================================================
    Unique RP - Ticket System | shared/ticket_config.lua
    arshiahub.ir

    Loaded on both client and server (see fxmanifest.lua shared_scripts),
    same as shared/ac_config.lua and shared/report_shared_config.lua - one
    source of truth for category/priority labels so the NUI, the client and
    the server never disagree on what an id like 'bug' or priority 2 means.
=========================================================================== ]]

Ticket_Config = {}

-- --------------------------------------------------------------- دستورات ---
Ticket_Config.CommandForUser  = 'ticket'    -- /ticket  -> باز کردن تیکت‌های خودم
Ticket_Config.CommandForAdmin = 'atickets'  -- /atickets -> پنل مدیریت تیکت‌ها

Ticket_Config.KeyForUser  = ''   -- مثلا 'F8'
Ticket_Config.KeyForAdmin = ''

-- --------------------------------------------------------------- دسترسی ---
-- همون آستانه‌ای که server/main.lua برای IsOnDutyAdmin استفاده میکنه، اینجا
-- هم تکرار شده (shared، نه require از server/main.lua) چون کلاینت هم برای
-- تصمیمِ نمایشِ نسخه‌ی ادمینِ منو بهش نیاز داره.
Ticket_Config.MinPermissionLevel = 1

-- ------------------------------------------------------------- دسته‌ها ---
Ticket_Config.Categories = {
    { id = 'report',  label = 'گزارش بازیکن',  icon = '🚩' },
    { id = 'bug',      label = 'باگ سرور',      icon = '🐛' },
    { id = 'payment',  label = 'مالی / خرید',   icon = '💳' },
    { id = 'appeal',   label = 'اعتراض به مجازات', icon = '⚖️' },
    { id = 'question', label = 'سوال عمومی',    icon = '❓' },
    { id = 'other',    label = 'سایر',          icon = '📁' },
}

Ticket_Config.Priorities = {
    { id = 1, label = 'پایین',  color = '#4ade80' },
    { id = 2, label = 'متوسط', color = '#facc15' },
    { id = 3, label = 'بالا',   color = '#f87171' },
}

Ticket_Config.Statuses = {
    { id = 'open',        label = 'باز',        color = '#38bdf8' },
    { id = 'in_progress',  label = 'در حال بررسی', color = '#facc15' },
    { id = 'closed',       label = 'بسته‌شده',    color = '#6b7280' },
}

-- Discord webhook convar (خالی = غیرفعال). مثل Config.DiscordWebhook تو
-- server/main.lua، از GetConvar میاد نه هاردکد، تا سکرت داخل کد نباشه.
Ticket_Config.DiscordWebhookConvar = 'unique_ticket_webhook'

Ticket_Config.MessageMax = 1000
Ticket_Config.TitleMax   = 120
