-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- =========================================================
-- Sun Dispatch — Config (module of sunset_utils)
-- Hame chiz inja customizable hast.
-- =========================================================

ConfigDispatch = {}

-- ---------------------------------------------------------
-- Permission level (mosabeh sunset_admin)
-- ---------------------------------------------------------
ConfigDispatch.Perm = {
    Admin   = 1,    -- min perm baraye join queue / accept offer / pick lost
    Manager = 20,   -- min perm baraye didane owner-id daron Unaccepted (پیگیری)
    QueueStats = 20,
}

-- ---------------------------------------------------------
-- Offer (popup ke be nafar avval saf neshoon dade misheh)
-- ---------------------------------------------------------
-- forsate accept/decline (ثانیه). agar timeout shod -> ticket be Lost.
ConfigDispatch.OfferDecisionWindow = 30

-- ---------------------------------------------------------
-- Anti-spam re-join saf
-- ---------------------------------------------------------
-- ba'd az khoroj az saf (manual / decline / timeout) admin chand saniye
-- baayad sabr kone taa dobare betone vared saf beshe (anti-spam).
ConfigDispatch.RejoinCooldown = 30   -- second

-- ---------------------------------------------------------
-- Buckets (lost / unaccepted)
-- ---------------------------------------------------------
ConfigDispatch.MaxLost          = 50
ConfigDispatch.MaxUnaccepted    = 50
ConfigDispatch.MaxPickedHistory = 200

-- ---------------------------------------------------------
-- Bridge eventha — agar dar sunset_admin avaz shodan inja edit
-- ---------------------------------------------------------
ConfigDispatch.Bridge = {
    NewReport      = 'sundispatch:externalNewReport',
    ReportAccepted = 'sundl:reportAccepted',
    ReportClosed   = 'sundl:reportClosed',
}

-- ---------------------------------------------------------
-- Texts (FA)
-- ---------------------------------------------------------
ConfigDispatch.Text = {
    JoinedQueue    = 'Vared saf shodi. Mojeyat: %d',
    JoinedQueues   = 'Vared saf-haye entekhabi shodi.',
    LeftQueue      = 'Az saf khareg shodi.',
    AlreadyInQueue = 'To hamin alan toye safi.',
    NoPermission   = 'Dastresi nadari.',
    Busy           = 'Aval ke be report fe\'li reach kardi (/cr) baad mitooni dobare vared saf shi.',
    Cooldown       = 'Bayad %d saniye sabr koni baraye dobare vared shodan be saf.',
    Spam           = 'Spam nakon! Sabr kon, hanooz nobate to nashode.',
    PickedHint     = 'Baraye pasokh: /ar %s',
}

-- ---------------------------------------------------------
-- Anti-spam: حداقل فاصله بین تلاش‌های ناموفق join (ms)
-- اگه کاربر سریع‌تر از این retry بزنه، خطای 'spam' دریافت می‌کنه
-- ---------------------------------------------------------
ConfigDispatch.JoinFailThrottleMs = 1500

-- ---------------------------------------------------------
-- اگه ادمین با /ar یه ریپورت غیر-آفر (active/lost) رو قبول کنه:
--   * اگه position فعلیش <= این عدد بود، از صف میاد بیرون.
--   * اگه position بزرگ‌تر بود، تو صف باقی می‌مونه.
-- (آفر/popup همیشه باعث خروج صف می‌شه چون نفر اوله)
-- ---------------------------------------------------------
ConfigDispatch.AutoLeaveOnAcceptMaxPos = 4

ConfigDispatch.Debug = false
