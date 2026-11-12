Config = {}

-- Name rules (English letters only, max 10).
Config.Name = { Min = 3, Max = 10 }

-- Default date of birth stored at registration. essentialmode treats a player as "new" when
-- playerName OR dateofbirth is empty, so BOTH must be written at register time.
Config.DefaultDateOfBirth = '01/01/2000'

-- If essentialmode's `registerForm` event has not arrived after this long, the
-- client asks the server directly (and keeps asking).
Config.StateFallbackMs = 15000
Config.StateRetryMs    = 10000

-- Spawn gate: every wait has a
-- timeout so a missing event can never leave a player on a black screen.
Config.SettleMs         = 2500   -- minimum settle time after esx:playerLoaded
Config.WorldTimeoutMs   = 20000  -- max wait for esx:playerLoaded
Config.CollisionTimeout = 5000   -- max wait for ground collision
Config.WaitForClothes   = true   -- wait for the clothing/skin system before fade-in
Config.ClothesTimeoutMs = 8000
-- Any of these client events counts as "clothes are on". Your new clothing
-- system can just TriggerEvent('unique_character:clothesReady') when done.
Config.ClothesEvents = {
    'unique_character:clothesReady',
    'skinchanger:modelLoaded',
}

Config.FadeInMs  = 3000
Config.FadeOutMs = 50

-- Old ReadToPlay() kept un-freezing the ped for ~15 s because other scripts
-- (essentialmode playerSpawned) freeze it late. Same window, one loop.
Config.UnfreezeWindowSec = 15

Config.Text = {
    loadingTitle = 'Loading character...',
    retrieving   = 'Retrieving data',
    register     = 'Register',
    preparing    = 'Preparing for spawn',
    clothes      = 'Wearing clothes',
    welcome      = 'Welcome',
    invalid      = 'نام یا نام خانوادگی نامعتبر است (فقط حروف انگلیسی، ۳ تا ۱۰ حرف)',
    taken        = 'این نام قبلا ثبت شده، یک نام دیگر انتخاب کنید',
    busy         = 'درخواست قبلی شما در حال بررسی است',
    error        = 'خطا در ثبت اطلاعات، دوباره تلاش کنید',
}
