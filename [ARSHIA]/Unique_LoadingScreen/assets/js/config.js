/* ==========================================================
   Unique RP - Loading Screen config. Edit ONLY this file.
   ========================================================== */
window.UNIQUE_CONFIG = {
  serverName: "Unique RP",
  // Live stats (players.json / info.json). Leave "" to hide the chip.
  statsHost: "185.132.178.182:30120",
  statsRefreshMs: 15000,
  links: {
    website: "https://arshiahub.ir",
    discord: "",      // e.g. "https://discord.gg/XXXX"  (empty = hidden)
    teamspeak: "",    // e.g. "ts3server://your.ts.address" (empty = hidden)
  },
  showcaseMs: 5500,
  tipsMs: 8000,
  stuckAfterMs: 60000,
  i18n: {
    fa: {
      tagline: "تجربه‌ی رول‌پلی فارسی • بدون نیاز به استیم",
      tips: "نکته", rules: "قوانین", news: "اطلاعیه", online: "آنلاین",
      music: "در حال پخش", track: "Unique Ambient", website: "وب‌سایت",
      feat: "امکانات سرور", lowperf: "حالت سبک", stuck: "لودینگ طولانی شد؟ F8 بزن و دوباره connect کن.",
      rulesText: "استفاده از RDM و VDM ممنوعه. به بقیه احترام بذار و توی کاراکتر بمون.",
      newsText: "سیستم Level/XP و Daily Quest فعاله — از منوی تعاملی چک کن 🚀",
      tipList: [
        "منوی ایونت‌ها (Capture, GunGame, WarZone) با دستور \u2066/uevent\u2069 باز میشه.",
        "کلید M یا Space صدای لودینگ رو قطع/وصل می‌کنه.",
        "رمز و کد پیامکی رو به هیچ‌کس نده؛ استاف هیچ‌وقت نمی‌پرسه.",
        "باگ یا تخلف دیدی؟ از سیستم Report داخل بازی گزارش بده.",
        "هر روز Daily Quest ها رو انجام بده تا سریع‌تر لول بگیری.",
      ],
      features: [
        ["Level و Daily Quest", "با هر فعالیت XP بگیر، لول آپ کن و ماموریت‌های روزانه رو کامل کن."],
        ["ایونت‌ها", "Capture، GunGame و WarZone در یک منو با \u2066/uevent\u2069 و لیدربورد."],
        ["گنگ‌ها", "سیستم کامل گنگ با پنل بوس، مدیریت اعضا و درگیری‌ها."],
        ["سرقت‌ها و دارک‌فون", "سرقت‌های مختلف، Oil Rig و پارتی‌سیستم، هماهنگ با پلیس و دیسپچ."],
        ["شغل‌ها", "۱۳ شغل در قالب DOJ، Law Enforcement و Organ Services."],
        ["کافه‌ها و بازارچه", "کرفت در کافه‌ها و بازار بازیکن‌ها برای خرید و فروش."],
        ["خودرو", "گاراژ و اجاره‌ی ماشین با منوی ساده."],
      ],
      stages: {
        CONNECTING: ["در حال اتصال به سرور...", ["برقراری نشست امن...", "دریافت توکن سرور...", "همگام‌سازی بسته‌ها..."]],
        DOWNLOADING: ["دانلود فایل‌ها...", ["دریافت تکسچرها...", "بارگذاری مدل‌ها...", "بررسی فایل‌های دانلودشده..."]],
        STREAMING: ["بارگذاری دنیای بازی...", ["پردازش موجودیت‌ها...", "همگام‌سازی ماشین‌ها و اینتریورها...", "بهینه‌سازی سکتورهای شهر..."]],
        FINALIZING: ["نهایی‌سازی...", ["آماده‌سازی محل اسپاون...", "آخرین همگام‌سازی...", "تقریباً تموم شد..."]],
        READY: ["آماده‌ای! به Unique RP خوش اومدی.", ["به شهر خوش اومدی.", "نشست آماده‌ست."]],
      },
    },
    en: {
      tagline: "Persian RolePlay • No Steam Required",
      tips: "Tip", rules: "Rules", news: "Announcement", online: "Online",
      music: "Now Playing", track: "Unique Ambient", website: "Website",
      feat: "Server Features", lowperf: "Lite mode", stuck: "Taking long? Press F8 and reconnect.",
      rulesText: "No RDM / VDM. Respect others and stay in character.",
      newsText: "Level/XP and Daily Quests are live - check the interaction menu 🚀",
      tipList: [
        "Use /uevent to open the events hub (Capture, GunGame, WarZone).",
        "Press M or Space to mute/unmute the loading music.",
        "Never share your password or SMS code - staff will never ask.",
        "Saw a bug or a rule break? Use the in-game Report system.",
        "Finish Daily Quests every day to level up faster.",
      ],
      features: [
        ["Level & Daily Quests", "Earn XP from everything you do, level up and finish daily missions."],
        ["Events", "Capture, GunGame and WarZone in one menu via /uevent, with leaderboards."],
        ["Gangs", "Full gang system with boss panel, member management and turf wars."],
        ["Robberies & DarkPhone", "Multiple heists, Oil Rig and party system, wired into police dispatch."],
        ["Jobs", "13 jobs across DOJ, Law Enforcement and Organ Services."],
        ["Cafes & Marketplace", "Craft in cafes and trade in the player-driven market."],
        ["Vehicles", "Garage and vehicle rental with a clean menu."],
      ],
      stages: {
        CONNECTING: ["Connecting to server...", ["Establishing secure session...", "Requesting server token...", "Syncing handshake packets..."]],
        DOWNLOADING: ["Downloading assets...", ["Fetching textures...", "Loading models...", "Verifying downloaded resources..."]],
        STREAMING: ["Streaming world data...", ["Processing dynamic entities...", "Syncing vehicles and interiors...", "Optimizing city sectors..."]],
        FINALIZING: ["Finalizing environment...", ["Preparing spawn location...", "Last synchronization pass...", "Almost there..."]],
        READY: ["Ready. Welcome to Unique RP.", ["Welcome to the city.", "Session ready."]],
      },
    },
  },
};

(function () {
  const C = window.UNIQUE_CONFIG;
  let lang = "fa";
  try { lang = localStorage.getItem("unique_ls_lang") || "fa"; } catch (e) {}
  if (!C.i18n[lang]) lang = "fa";
  window.UNIQUE = {
    get lang() { return lang; },
    setLang(l) {
      if (!C.i18n[l]) return;
      lang = l;
      try { localStorage.setItem("unique_ls_lang", l); } catch (e) {}
      document.documentElement.lang = l;
      (window.UNIQUE.onLang || []).forEach((fn) => fn(l));
    },
    dict() { return C.i18n[lang]; },
    stage(name) {
      const s = C.i18n[lang].stages[name] || C.i18n[lang].stages.CONNECTING;
      return { label: s[0], hints: s[1] };
    },
    onLang: [],
  };
  document.documentElement.lang = lang;
})();
