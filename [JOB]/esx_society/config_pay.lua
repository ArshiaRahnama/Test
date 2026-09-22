-- ============================================================
--  Society Pay  (bakhshi az esx_society)
--  /pay  : pardakht be ordan-haye DOJ va Law Enforcement
--  Boss Action -> "Vaariz-haye Daryafti" : didan-e vaariz-ha + gozaresh
-- ============================================================
Config.Pay = {}
local P = Config.Pay

-- ---------- command-ha ----------
P.Command        = 'pay'      -- wizard-e pardakht
P.HistoryCommand = 'paylog'   -- pardakht-haye khodam (nil = gheyr-e faal)

-- ---------- omoomi ----------
P.Cooldown        = 3000      -- ms; faseleh-ye hadaghal beyn do pardakht-e yek bazikon
P.NoteMaxLength   = 120
P.NotifyOrg       = true      -- aza-ye online-e ordan bad az har pardakht notification migiran
P.NotifyDuration  = 7000
P.DiscordCategory = 'transfer'-- yeki az category-haye resource-e logs
P.Sounds          = true      -- seda-ye kootah-e movafaghiat dar panel
P.AutoRefresh     = 20000     -- ms; bazrasi-ye khodkar-e vaariz-haye jadid dar panel-e Boss (0 = khamoosh)
P.PageSize        = 20
P.ReportDays      = { 7, 14, 30 }

-- logo-ye ordan-ha az resource-e Unique_LevelQuest (agar file nabood, harf-haye avval neshoon dade mishe)
P.LogoPath = 'nui://Unique_LevelQuest/html/img/job/%s.png'

-- ---------- Boss Action ----------
-- faghat Boss-e ordan-haye P.Departments (DOJ va LAW) dokme ro mibinan
P.BossGrades = { 'boss' }

-- ---------- noe-haye pardakht ----------
--  bank -> be hesab-e society-e department variz mishe
--  coin -> faghat az bazikon kam mishe va tu log/panel ghayd mishe
--  quick = dokme-haye entekhab-e sari-e mablagh
P.Types = {
    bank = { label = 'Bank', min = 10000, max = 1000000000, quick = { 10000, 50000, 100000, 500000 } },
    coin = { label = 'Coin', min = 1,     max = 1000000,    quick = { 1, 5, 10, 50 } },
}

-- sagf-e pardakht dar har 24 saat baraye har bazikon (nil = bedoon-e mahdoodiat)
P.DailyLimit = {
    bank = nil,      -- mesal: 5000000
    coin = nil,      -- mesal: 200
}

-- ---------- babat-e pardakht (needsNote = true -> tozih ejbari ast) ----------
P.Purposes = {
    { key = 'fine',     label = 'جریمه' },
    { key = 'bail',     label = 'وثیقه / کفالت' },
    { key = 'fee',      label = 'عوارض / هزینه خدمات' },
    { key = 'donation', label = 'کمک مالی' },
    { key = 'other',    label = 'سایر', needsNote = true },
}

-- ---------- faghat DOJ va LAW ----------
--  account = esx_addonaccount ke pool-e Bank behesh variz mishe
--  types   = noe-haye ghabul-shode ({ 'bank' } yani faghat bank)
--  limits  = (ekhtiari) avaz kardan-e min/max:  limits = { bank = { min = 50000 } }
--  orgs[].job  = esm-e job dar esx     orgs[].logo = esm-e file dar P.LogoPath (ekhtiari)
P.Departments = {
    {
        id = 'doj', label = 'Department Of Justice', emoji = '⚖️', color = '#3b6fe0',
        account = 'society_doj', types = { 'bank', 'coin' },
        orgs = {
            { job = 'cid',     label = 'CID',     logo = 'CID' },
            { job = 'cia',     label = 'CIA' },
            { job = 'marshal', label = 'Marshal' },
            { job = 'fbi',     label = 'FBI',     logo = 'fbi' },
            { job = 'judge',   label = 'Judge' },
            { job = 'doa',     label = 'DOA',     logo = 'DOA' },
        },
    },
    {
        id = 'law', label = 'Law Enforcement', emoji = '🛡️', color = '#c9a35d',
        account = 'society_law', types = { 'bank', 'coin' },
        orgs = {
            { job = 'police',  label = 'Police',  logo = 'police' },
            { job = 'sheriff', label = 'Sheriff', logo = 'sheriff' },
            { job = 'mt',      label = 'MT',      logo = 'mt' },
        },
    },
}

-- ---------- payam-ha ----------
P.Locale = {
    err_min      = 'حداقل مقدار %s است.',
    err_max      = 'حداکثر مقدار %s است.',
    err_funds    = 'موجودی شما کافی نیست.',
    err_invalid  = 'مقدار واردشده معتبر نیست.',
    err_note     = 'برای بابت «سایر» باید توضیح بنویسید.',
    err_daily    = 'سقف پرداخت ۲۴ ساعته پر شده است. باقی‌مانده: %s',
    err_cooldown = 'چند ثانیه صبر کنید و دوباره تلاش کنید.',
    err_generic  = 'خطایی رخ داد. دوباره تلاش کنید.',
    err_not_gov  = 'این بخش فقط برای ارگان‌های DOJ و Law Enforcement است.',
    err_not_boss = 'فقط باس ارگان به این بخش دسترسی دارد.',

    org_notify_title = 'واریز جدید',
    org_notify_desc  = '%s مبلغ %s %s پرداخت کرد (%s)',
}
