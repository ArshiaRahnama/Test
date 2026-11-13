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
Config.WorldTimeoutMs   = 60000  -- max wait for esx:playerLoaded + playerSpawned + the teleport to the last position.
                                 -- The server can be slow here (user load = DB queries); showing the wrong
                                 -- place is worse than a longer black screen, so this is generous.
Config.PlaceRadius      = 50.0   -- the ped must be within this many metres (x,y) of its saved last position
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

-- Black-screen timing. The screen goes black first and is only faded in when
-- EVERYTHING below is done. While black, the bottom status panel shows each step.
Config.MinBlackMs     = 8000   -- never fade in earlier than this after the screen went black
Config.RetrieveMs     = 2000   -- 'Retrieving data'
Config.PrepareMs      = 2000   -- 'Preparing for spawn'
Config.TeleportMs     = 1000   -- 'Teleporting to last location' (at least; waits for the world too)
Config.ClothesMinMs   = 3000   -- 'Wearing clothe' (at least; waits for the clothing system too)
Config.HoldBlack      = true   -- cover the screen with a black rectangle while loading (other scripts such as
                               -- spawnmanager fade the engine screen in on their own; the cover hides that).
                               -- Do NOT replace this with forced DoScreenFadeOut calls: spawnmanager waits for
                               -- IsScreenFadedIn() before firing 'playerSpawned' -> deadlock.
Config.CoverHud       = true   -- also hide the native HUD/radar while covered

-- Two loaders at the same time = two register forms, 'loading:Loaded' twice, fades and
-- freezes fighting each other. Any resource listed here is stopped automatically
-- (on start AND whenever it is restarted). The old [SCRIPT]/loading client flow is the
-- known one; add others (esx_identity, esx_multicharacter, ...) if you ever run them.
Config.StopConflicting     = true
Config.ConflictingResources = { 'loading' }

-- Prints a timeline of everything load-related this client sees (spawn events, fades,
-- freezes, skin loads, ped swaps) and counts events that fire more than once.
-- Toggle in game with the F8 console command:  uc_trace
Config.Trace = false

Config.Text = {
    loadingTitle = 'Loading character...',
    retrieving   = 'Retrieving data',
    register     = 'Register',
    preparing    = 'Preparing for spawn',
    teleporting  = 'Teleporting to last location',
    clothes      = 'Wearing clothe',
    welcome      = 'Welcome🙂',
    invalid      = 'نام یا نام خانوادگی نامعتبر است (فقط حروف انگلیسی، ۳ تا ۱۰ حرف)',
    taken        = 'این نام قبلا ثبت شده، یک نام دیگر انتخاب کنید',
    busy         = 'درخواست قبلی شما در حال بررسی است',
    error        = 'خطا در ثبت اطلاعات، دوباره تلاش کنید',
}
