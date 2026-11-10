const root = document.getElementById('root');
const hudRoot = document.getElementById('hud-root');
const overlayRoot = document.getElementById('overlay-root');

const PB_ICON_BASE = 'imgs/icons/';

const PB_PERK_ICONS = {
    fast_run: 'soda_can_red.png',
    high_jump: 'soda_can_blue.png',
    fast_reload: 'ammo_case_open.png',
    low_recoil: 'military_case.png',
    extra_armor: 'armored_case.png',
    instant_heal: 'first_aid_kit_red.png',
    stealth: 'gas_canister.png',
    damage_boost: 'skull.png',
    dead_silence: 'leather_suitcase.png',
    extra_ammo: 'ammo_crate.png',
    fast_aim: 'sunglasses_2.png',
    slide_kick: 'soda_can_green.png',
    thermal_vision: 'sunglasses.png',
    night_vision: 'goggles.png',
};

const PB_EQUIP_ICONS = {
    WEAPON_SMOKEGRENADE: 'gas_canister.png',
    WEAPON_BZGAS: 'grenade_gas.png',
    WEAPON_GRENADE: 'grenade_round.png',
    WEAPON_MOLOTOV: 'grenade_olive.png',
    WEAPON_STICKYBOMB: 'explosives_case.png',
    WEAPON_PROXMINE: 'grenade_olive_2.png',
    WEAPON_PIPEBOMB: 'grenade_gold.png',
    WEAPON_FIREEXTINGUISHER: 'gas_canister.png',
    WEAPON_FLARE: 'grenade_green.png',
    WEAPON_FLAREGUN: 'grenade_green_2.png',
};

const PB_KILLSTREAK_ICONS = {
    care_package: 'supply_crate.png',
    carepackage: 'supply_crate.png',
    rpg: 'explosives_case.png',
    juggernaut: 'armored_case.png',
};

function pbIconImg(file, fallbackEmoji, extraClass) {
    const fb = fallbackEmoji != null ? fallbackEmoji : '★';
    if (!file) return `<span class="ic-fb ${extraClass || ''}">${fb}</span>`;
    const cls = 'pb-ic' + (extraClass ? ' ' + extraClass : '');
    return `<img class="${cls}" src="${PB_ICON_BASE}${file}" data-fb="${fb}" alt="" draggable="false" onerror="this.outerHTML='<span class=&quot;ic-fb&quot;>'+(this.dataset.fb||'')+'</span>'" />`;
}

const MODE_DESC = {
    tdm: 'تیم دث‌مچ معمولی - با respawn. تا score limit کیل بزنی تیمت برنده میشه.',
    sunset_tdm: 'سانست تیم دث‌مچ - بدون respawn. هر کی مرد می‌مونه. تیمی که کل حریف رو بکشه راند رو می‌بره.',
    ffa: 'فری فور آل - همه دشمن همن. اول کسی به ۲۵ کیل برسه برنده. اسپاون پروتکشن داره.',
    gungame: 'گان گیم - هر کیل یک سلاح بهتر. آخرش با چاقو. کیل با چاقو دشمن رو یک لول پایین میاره.',
    bombplant: 'بمب پلنت - یک تیم بمب رو پلنت میکنه، یکی دیفیوز. سی‌اس استایل. ۳۵ ثانیه تایمر بمب.',
    coop: 'کوآپ زامبی - تیم ۱ تا ۶ نفر در برابر ۲۵ موج زامبی. شاپ داره برای ارتقا اسلحه و آرمر.',
    wavedefense: 'ویو دیفنس - مشابه کوآپ ولی فقط ۱۵ موج با سختی بیشتر. باس هر ۴ موج.',
    survival: 'سرواوال اندلس - بی‌نهایت موج. سخت‌ترین حالت. تا جایی که می‌تونی دوام بیار.',
    domination: 'دامیناسیون - ۳ نقطه کپچر. هر نقطه ای که نگه دار امتیاز میده. اول به ۲۰۰ امتیاز برنده.',
    koth: 'کینگ آو د هیل - یک نقطه مرکزی. تا تو هیل باشی امتیاز میگیری. اول به ۲۰۰ برنده.',
    infection: 'اینفکشن - یک نفر زامبی شروع میشه. هر کشته به زامبی تبدیل میشه. سرواوال‌ها باید ۲۴۰ ثانیه دوام بیارن.',
    juggernaut: 'جاگرنوت - یک نفر با ۴۰۰ هلث و آرمر. بقیه باید بکشنش. کشتنش = جاگرنوت بعدی.',
    gunrotation: 'گان روتیشن - هر ۳۰ ثانیه اسلحه همه عوض میشه. باید با هر اسلحه‌ای بازی کنی.',
    escort: 'اسکورت - یک VIP باید به مقصد برسه. تیم دفاع همراهیش میکنه، تیم حمله سعی در کشتن.',
    tournament: 'تورنومنت - بست‌آو ۹ راند تیم دث‌مچ کلاسیک. آرمر کامل، رقابتی.',
    practice: 'پرکتیس آرنا - تمرین تنها. بدون امتیاز و تایم. فقط برای تمرین.',
    aimtrainer: 'ایم ترینر - تمرین دقت با هدف‌های ثابت. هد شات = ۲ امتیاز.',
};

const T = {
    play: 'بازی',
    create: 'ساخت لابی',
    perks: 'پرک‌ها',
    leaderboard: 'لیدربورد',
    profile: 'پروفایل',
    practice: 'پرکتیس',
    aim: 'ایم ترینر',
    close: 'بستن',
    closeEsc: 'بستن [ESC]',
    refresh: 'بروزرسانی',
    join: 'پیوستن',
    leave: 'خروج',
    ready: 'آماده',
    wait: 'انتظار',
    start: 'شروع مچ',
    adminSolo: 'شروع ادمین (تنها)',
    autoBalance: 'بالانس خودکار',
    readyCheck: 'چک آمادگی',
    spectate: 'تماشا',
    switchA: 'برو به آلفا',
    switchB: 'برو به براوو',
    joinMatch: 'پیوستن به مچ',
    save: 'ذخیره',
    cancel: 'انصراف',
    yes: 'بله',
    no: 'خیر',
    locked: 'قفل',
    open: 'باز',
    mode: 'مود',
    map: 'مپ',
    players: 'بازیکنان',
    rounds: 'راندها',
    armor: 'آرمر',
    headshot: 'هدشات',
    headshotOnly: 'هدشات‌اونلی',
    hardcoreMode: 'هاردکور',
    perksOn: 'پرک',
    killstreaksOn: 'کیل‌استریک',
    equipmentOn: 'اکویپمنت',
    noArmor: 'بدون آرمر',
    weapon: 'سلاح',
    fee: 'هزینه',
    lobbyName: 'نام لابی',
    password: 'رمز (اختیاری)',
    timer: 'تایمر (ثانیه)',
    headOn: 'فعال',
    headOff: 'غیرفعال',
    feeTc: 'TC',
    feeSc: 'SC',
    feeMoney: 'پول (10,000)',
    teamA: 'تیم آلفا',
    teamB: 'تیم براوو',
    spectators: 'تماشاچی‌ها',
    pageLobbyTitle: 'لیست',
    pageLobbyAccent: 'لابی‌ها',
    pageLobbySub: 'به لابی‌های فعال بپیوند',
    pageCreateTitle: 'ساخت',
    pageCreateAccent: 'لابی',
    pageCreateSub: 'مود و تنظیمات بازی رو انتخاب کن',
    pagePerksTitle: 'پرک',
    pagePerksAccent: 'لودآوت',
    pageLBTitle: 'لیدر',
    pageLBAccent: 'بورد',
    pageProfileTitle: 'پروفایل',
    pageProfileAccent: 'من',
    pagePracticeTitle: 'پرکتیس',
    pagePracticeAccent: 'آرنا',
    pageAimTitle: 'ایم',
    pageAimAccent: 'ترینر',
    soon: 'به‌زودی',
    soonDesc: 'این بخش در آینده نزدیک فعال میشه',
    noLobby: 'هیچ لابی فعالی نیست',
    noLobbyDesc: 'اول یک لابی بساز',
    noStats: 'هنوز آماری نداری',
    noStatsDesc: 'یک مچ بازی کن',
    noLeaderboardData: 'دیتایی موجود نیست',
    needModeMap: 'مود و مپ انتخاب کن',
    perkSaved: 'پرک‌ها ذخیره شد',
    perkSlotEmpty: 'اسلات پرک خالیه',
    notInMatch: 'تو در مچ نیستی',
    isSpectator: 'تو تماشاچیی',
    cooldown: 'کول‌داون: ',
    perkActive: 'پرک فعال شد: ',
    selectMode: 'اول مود انتخاب کن',
    loading: 'در حال بارگذاری...',
    section_mode: 'مود',
    section_map: 'مپ',
    rank: 'رتبه',
    identifier: 'شناسه',
    kills: 'کیل',
    deaths: 'دث',
    kd: 'K/D',
    wins: 'برد',
    games: 'بازی',
    headshots: 'هدشات',
    selectedCount: 'انتخاب شده',
    perkSaveBtn: 'ذخیره',
    backBtn: 'بازگشت',
    createBtn: 'ساخت لابی',
    party: 'پارتی',
    lobbyPasswordTitle: 'رمز لابی',
    readyCheckTitle: 'چک آمادگی',
    readyCheckPrompt: 'آیا آماده هستید؟',
    matchEnd: 'پایان مچ',
    gameOver: 'بازی تمام شد',
    inside: 'داخل',
    outside: 'خارج',
    holder: 'دارنده',
    spawnProtected: 'محافظت اسپاون',
    plant: '[E] پلنت در ',
    defuse: '[E] دیفیوز در ',
    bombCarrier: 'تو حامل بمبی!',
    sideSwapped: 'سایدها عوض شد',
    revived: 'احیا شدی',
    bought: 'خریدی: ',
    invite: 'دعوت پارتی از: ',
    teamAFull: 'تیم آلفا پر است',
    teamBFull: 'تیم براوو پر است',
};

function infoIcon(modeKey) {
    const desc = MODE_DESC[modeKey] || '';
    return `<span class="info-icon" title="">?</span><div class="tooltip">${escape(desc)}</div>`;
}

const modeTooltips = {
    tdm: 'تیم دث‌مچ معمولی — با respawn، هر تیم تا score limit کیل بزنه برنده میشه. وقتی می‌میری دوباره spawn میشی.',
    sunset_tdm: 'تیم دث‌مچ سانست — بدون respawn! تو هر راند هر کی مرد می‌مونه روی زمین. تیمی که کل اعضای حریف رو بکشه راند رو می‌بره. بست‌آو 5 راند.',
    ffa: 'هر کس برای خودش، اولین به امتیاز برسه برنده‌ست',
    gungame: 'با کشتن هر بار اسلحه بعدی، آخرین مرحله چاقو',
    bombplant: 'تیم حمله بمب می‌کاره، تیم دفاع خنثی می‌کنه',
    coop: 'تیمی علیه زامبی‌های موج‌به‌موج',
    wavedefense: 'دفاع موجی، سخت‌تر از کوآپ',
    survival: 'موج بی‌نهایت تا مرگ، رکوردگذاری',
    domination: 'سه نقطه تصرف، امتیاز با نگهداشتن',
    koth: 'یک تپه مرکزی، حضور = امتیاز',
    infection: 'بازماندگان در برابر آلوده‌ها',
    juggernaut: 'یک نفر جاگرنات با HP بالا، بقیه شکارچی',
    gunrotation: 'هر 30 ثانیه اسلحه عوض میشه',
    escort: 'تیم اسکورت VIP رو می‌بره، تیم حمله شکار می‌کنه',
    tournament: 'TDM با راندهای بیشتر، برای تورنومنت',
    practice: 'تمرین سولو، سندباکس',
    aimtrainer: 'تمرین نشانه‌گیری',
};

const state = {
    view: null,
    flags: {},
    lobby: null,
    modes: [],
    maps: {},
    perks: {enabled: false, perks: []},
    selectedPerks: [],
    activeNav: 'play',
    creating: { mode: 'sunset_tdm', map: null, name: '', password: '', rounds: 3, weapon: 'WEAPON_PISTOL', armor: 0, head: 1, timer: 180, fee: 2, perks: [], switchTeam: false, usePresetGuns: true, customWeapons: [], tab: 'mode', wepSearch: '' },
    lbMode: 'tdm',
    lbSort: 'kills',
    lbData: [],
    weapons: [],
    party: null,
    pendingJoin: null,
    hud: {
        roundIndex: 0, rounds: 0, score: {}, state: 'warmup',
        seconds: 0, mode: '', team: 0, kills: 0, deaths: 0,
        teamCounts: {}, killFeed: [], multikill: null, killstreak: null,
        spawnProtectSeconds: 0, weapon: '', bombPrompt: null, bombDefuse: null,
        objectives: null, bombSites: null, hill: null,
        coopWave: 0, coopMoney: 0, coopShop: null,
        scoreboard: [], gungameLevels: [], gungameMaxLevel: 0,
        ended: null,
    },
    attachments: {weapon: '', list: [], current: {}},
    scoreboard: {open: false, players: [], mvp: null},
};

window.addEventListener('message', function (event) {
    const msg = event.data;
    if (!msg) return;
    if (msg.type === 'initData') {
        const d = msg.data || {};
        state.view = d.view || 'lobby';
        state.flags = d.flags || state.flags;
        if (d.serverId) window.__pbServerId = d.serverId;
        if (d.playerName) state.playerName = d.playerName;
        if (d.weapon) state.attachments.weapon = d.weapon;
        if (d.list) state.attachments.list = d.list;
        if (d.current) state.attachments.current = d.current;
        if (state.view === 'lobby') {
            if (d.entryPoint) state.entryPoint = d.entryPoint;
            renderLobbyShell();
            requestAction('requestModes');
            requestAction('requestPerks');
            requestAction('requestWeapons');
            requestAction('requestEquipment');
            requestAction('requestAchievements');
            requestAction('requestPlayerStats', {mode: 'tdm'});
            if (!state.playerStatsLoaded) {
                setTimeout(() => {
                    if (!state.playerStatsLoaded) {
                        state.playerStats = state.playerStats || {kills: 0, deaths: 0, wins: 0, games: 0, headshots: 0, mvps: 0};
                        state.playerStatsLoaded = true;
                        renderProfileRail();
                    }
                }, 2500);
            }
            if (state.flags.leaderboard) requestAction('requestLeaderboard', {mode: 'tdm', sortBy: 'kills'});
        } else if (state.view === 'hud') {
            state.hud.mode = d.mode;
            state.hud.team = d.team;
            state.hud.weapon = d.weapon || '';
            state.hud.spectator = d.spectator;
            renderHUD();
            renderPerkHud({perks: d.perks || []});
        } else if (state.view === 'attachments') {
            renderAttachments();
        }
    }
    if (msg.type === 'updateData') {
        const p = msg.data || {};
        handleUpdate(p);
    }
});

function postCallback(action, data) {
    window.parent.postMessage({ type: 'nuiCallback', action: action, data: data || {} }, '*');
}
function requestAction(action, data) { postCallback(action, data || {}); }
function closeUI() { window.parent.postMessage({ type: 'closeUI' }, '*'); }

function handleUpdate(payload) {
    const t = payload.type;
    const data = payload.payload;
    if (state.view === 'lobby') return handleLobbyUpdate(t, data);
    if (state.view === 'hud') return handleHudUpdate(t, data);
    if (state.view === 'attachments') return handleAttachUpdate(t, data);
}

function handleLobbyUpdate(t, data) {
    if (t === 'modes') {
        state.modes = data || [];
        if (state.activeNav === 'create') renderCreate();
        if (state.activeNav === 'play') renderPlay();
    } else if (t === 'maps') {
        state.maps[data.mode] = data.maps;
        if (state.activeNav === 'create') paintMapGrid();
    } else if (t === 'lobbies') {
        const incoming = Array.isArray(data) ? data : [];
        const hadLobbies = state.lobbies && state.lobbies.length > 0;
        if (hadLobbies && incoming.length === 0 && state.lobbiesLastUpdate && (Date.now() - state.lobbiesLastUpdate) < 5000) {
        } else {
            state.lobbies = incoming;
            state.lobbiesLastUpdate = Date.now();
        }
        if (state.activeNav === 'play' && !state.lobby) paintLobbyList();
    } else if (t === 'perks') {
        state.perks = data || {enabled: false, perks: []};
        if (state.activeNav === 'perks') renderPerks();
    } else if (t === 'weapons') {
        state.weapons = data || [];
        if (state.activeNav === 'create') renderCreate();
    } else if (t === 'leaderboard') {
        state.lbData = (data && data.rows) || [];
        state.lbEnabled = data && data.enabled;
        if (state.activeNav === 'leaderboard') renderLeaderboard();
    } else if (t === 'playerStats') {
        if (data && data.row) {
            state.playerStats = data.row;
        } else {
            state.playerStats = state.playerStats || {kills: 0, deaths: 0, wins: 0, games: 0, headshots: 0, mvps: 0};
        }
        state.playerStatsLoaded = true;
        renderProfileRail();
        if (state.activeNav === 'profile') paintProfile();
    } else if (t === 'cosmetics') {
        state.cosmeticsData = data;
        if (state.activeNav === 'cosmetics') paintCosmetics();
    } else if (t === 'matchHistory') {
        state.matchHistoryData = data;
        if (state.activeNav === 'history') paintHistory();
    } else if (t === 'achievements') {
        state.achievementsData = data;
        if (state.activeNav === 'achievements') paintAchievements();
        if (state.activeNav === 'play') refreshPlayAchievements();
        renderProfileRail();
    } else if (t === 'achievementUnlock') {
        showAchievementUnlock(data);
        state.recentAchievement = data;
        renderProfileRail();
        requestAction('requestAchievements');
    } else if (t === 'equipment') {
        state.equipmentItems = data || [];
        if (state.activeNav === 'create' && !state.lobby) renderCreate();
    } else if (t === 'loadouts') {
        console.log('[PB-DEBUG][ui] loadouts received:', JSON.stringify(data));
        state.loadouts = data || {slots: [], active: 0, max: 5};
        if (state.activeNav === 'loadout') paintLoadouts();
    } else if (t === 'attachmentHashes') {
        state.attachmentHashes = state.attachmentHashes || {};
        state.attachmentHashes[data.weapon] = data.hashes;
        if (state.editingLoadout && state.activeNav === 'loadout') {
            const e = state.editingLoadout;
            const wm = data.weapon;
            if (e.attachments[wm]) {
                for (const grp in e.attachments[wm]) {
                    if (e.attachments[wm][grp].pending && data.hashes[grp]) {
                        const typeMap = {silencer: 1, grip: 2, scope: 3, flashlight: 4};
                        e.attachments[wm][grp] = {type: typeMap[grp] || 0, hash: data.hashes[grp]};
                    }
                }
            }
            paintLoadoutEditor();
        }
    } else if (t === 'createLobbyResult') {
        if (data.ok) requestAction('requestLobbies');
    } else if (t === 'joinLobbyResult') {
        if (data.ok) {} else { showToast(data.reason || 'پیوستن انجام نشد'); }
    } else if (t === 'lobbyState') {
        state.lobby = data;
        renderLobbyRoom();
    } else if (t === 'returnToPlay') {
        state.lobby = null;
        if (data && data.reason) showToast(data.reason);
        requestAction('requestLobbies');
        _lastNavSwitchAt = 0;
        if (state.activeNav === 'play') {
            renderPlay();
            renderSidebar();
        } else {
            setNav('play');
        }
    } else if (t === 'partyState') {
        state.party = data;
        renderSidebar();
    } else if (t === 'partyDisbanded') {
        state.party = null;
        renderSidebar();
    } else if (t === 'partyInvite') {
        showToast(T.invite + data.from);
    } else if (t === 'mapVoteOptions') {
        state.mapVoteOptions = data;
        renderMapVote();
    } else if (t === 'readyCheckRequest') {
        renderReadyCheckRequest(data);
    } else if (t === 'readyCheckUpdate') {
        renderReadyCheckUpdate(data);
    } else if (t === 'matchCountdown') {
        renderMatchCountdown(data);
    } else if (t === 'matchCountdownTick') {
        updateMatchCountdown(data.remaining);
    } else if (t === 'matchCountdownGo') {
        flashMatchCountdownGo();
    }
}

function renderLobbyShell() {
    root.classList.add('show');
    document.body.style.background = 'transparent';
    root.innerHTML = `
        <div class="panel-shell">
            <div class="modal-shell">
                <div class="logo-cell">
                    <div class="logo-glyph">PB</div>
                    <div class="logo-text">
                        <div class="name">پینت‌بال</div>
                        <div class="sub eng">COMBAT ARENA</div>
                    </div>
                </div>
                <div class="topbar-cell">
                    <div class="search-bar">
                        <span class="eng">⌕</span>
                        <input id="searchBar" placeholder="جستجو..." />
                    </div>
                    <div class="topbar-right" id="topbarChips"></div>
                </div>
                <nav class="rail" id="nav"></nav>
                <main class="main-area" id="main"></main>
                <aside class="profile-rail" id="profileRail"></aside>
            </div>
        </div>
    `;
    renderSidebar();
    renderProfileRail();
    setNav('play');
}

function renderSidebar() {
    const nav = document.getElementById('nav');
    if (!nav) return;
    const items = [
        {k: 'play', label: T.play, icon: '⌂'},
        {k: 'create', label: T.create, icon: '✚'},
        {k: 'loadout', label: 'لودآوت', icon: '◈'},
        {k: 'achievements', label: 'دستاوردها', icon: '🏆'},
        {k: 'perks', label: T.perks, show: false, icon: '★'},
        {k: 'leaderboard', label: T.leaderboard, show: !!state.flags.leaderboard, icon: '☰'},
        {k: 'profile', label: T.profile, show: !!state.flags.leaderboard, icon: '⚇'},
        {k: 'history', label: 'تاریخچه', show: true, icon: '◷'},
        {k: 'practice', label: T.practice, show: !!state.flags.practiceArena, icon: '◉'},
        {k: 'aim', label: T.aim, show: !!state.flags.aimTrainer, icon: '◎'},
    ];
    const main = items.filter(i => i.show !== false);
    nav.innerHTML = `
        ${main.map(i => `
            <div class="rail-item ${state.activeNav === i.k ? 'active' : ''}" data-nav="${i.k}">
                <span class="icon">${i.icon}</span>
                <span>${i.label}</span>
            </div>
        `).join('')}
        <div class="rail-footer">
            <div class="rail-item" id="closeBtnRail">
                <span class="icon">✕</span>
                <span>${T.close}</span>
            </div>
        </div>
    `;
    nav.querySelectorAll('[data-nav]').forEach(btn => btn.addEventListener('click', () => setNav(btn.dataset.nav)));
    const closeBtn = document.getElementById('closeBtnRail');
    if (closeBtn) closeBtn.addEventListener('click', () => postCallback('escape', {}));

    const chips = document.getElementById('topbarChips');
    if (chips) {
        chips.innerHTML = `
            ${state.party ? `<div class="top-chip"><span class="dot"></span>${T.party}: ${Object.keys(state.party.members||{}).length}</div>` : ''}
            <div class="top-chip"><span class="dot"></span><span class="eng">ONLINE</span></div>
            <button class="topbar-close" id="closeBtn">×</button>
        `;
        const cb = document.getElementById('closeBtn');
        if (cb) cb.addEventListener('click', () => postCallback('escape', {}));
    }
}

function computePlayerXp() {
    const stats = getMergedStats();
    let total = 0;
    total += (stats.kills || 0) * 25;
    total += (stats.headshots || 0) * 15;
    total += (stats.wins || 0) * 200;
    total += (stats.mvps || 0) * 100;
    if (state.achievementsData && state.achievementsData.list && state.achievementsData.tierXP) {
        const tx = state.achievementsData.tierXP;
        for (const a of state.achievementsData.list) {
            if (a.unlocked) total += (tx[a.tier] || 50);
        }
    }
    return total;
}

function getMergedStats() {
    const lb = state.playerStats || {};
    const ach = (state.achievementsData && state.achievementsData.stats) || {};
    return {
        kills: Math.max(ach.kills || 0, lb.kills || 0),
        deaths: Math.max(ach.deaths || 0, lb.deaths || 0),
        wins: Math.max(ach.wins || 0, lb.wins || 0),
        games: Math.max(ach.games || 0, lb.games || 0),
        headshots: Math.max(ach.headshots || 0, lb.headshots || 0),
        mvps: Math.max(ach.mvps || 0, lb.mvps || 0),
        win_streak: ach.win_streak || 0,
        first_blood_count: ach.first_blood_count || 0,
        clutches: ach.clutches || 0,
        revenge_kills: ach.revenge_kills || 0,
    };
}

function renderProfileRail() {
    const rail = document.getElementById('profileRail');
    if (!rail) return;
    const lbReady = state.playerStatsLoaded === true;
    const achReady = state.achievementsData !== undefined && state.achievementsData !== null;
    const dataReady = lbReady || achReady;
    const stats = getMergedStats();
    const xpMax = 10000;
    const totalXp = dataReady ? computePlayerXp() : null;
    const level = totalXp !== null ? Math.floor(totalXp / xpMax) + 1 : 1;
    const xpCurrent = totalXp !== null ? totalXp % xpMax : 0;
    const xpPct = totalXp !== null ? (xpCurrent / xpMax) * 100 : 0;
    const kd = stats.deaths > 0 ? (stats.kills / stats.deaths).toFixed(2) : (stats.kills || 0).toFixed(2);
    const username = state.playerName || 'Player';
    const initials = username.charAt(0).toUpperCase();

    rail.innerHTML = `
        <div class="profile-card">
            <div class="head">
                <div class="avatar">${escape(initials)}</div>
                <div class="info">
                    <div class="name">${escape(username)}</div>
                    <div class="level eng">${dataReady ? `Level ${level} Warrior` : 'Loading...'}</div>
                </div>
            </div>
            <div class="xp-row">
                <div class="xp-label"><span>XP</span><span class="xp-value eng">${dataReady ? `${xpCurrent}/${xpMax}` : '—'}</span></div>
                <div class="xp-bar"><div class="xp-fill" style="width:${xpPct}%"></div></div>
            </div>
            <div class="status-row">
                <span class="beta-badge eng">BETA VERSION</span>
                <span class="online">آنلاین</span>
            </div>
        </div>

        <div class="rail-section">
            <div class="title eng">YOUR STATS</div>
            <div class="stat-tiles">
                <div class="stat-tile"><div class="v eng">${stats.kills || 0}</div><div class="l">کیل کل</div></div>
                <div class="stat-tile"><div class="v eng">${kd}</div><div class="l eng">K/D</div></div>
                <div class="stat-tile"><div class="v eng">${stats.wins || 0}</div><div class="l">برد</div></div>
                <div class="stat-tile"><div class="v eng">${stats.games || 0}</div><div class="l">مچ</div></div>
            </div>
        </div>

        <div class="rail-section">
            <div class="title eng">RECENT</div>
            ${state.lobbies && state.lobbies.length > 0 ? `<div class="row">
                <div class="dot-time"></div>
                <div class="msg"><span class="eng">${state.lobbies.length}</span> لابی فعال</div>
                <div class="when">الان</div>
            </div>` : ''}
            ${state.party ? `<div class="row">
                <div class="dot-time"></div>
                <div class="msg">پارتی فعاله</div>
                <div class="when">الان</div>
            </div>` : ''}
            ${state.recentAchievement ? `<div class="row">
                <div class="dot-time"></div>
                <div class="msg">🏆 ${escape(state.recentAchievement.label)}</div>
                <div class="when">جدید</div>
            </div>` : ''}
        </div>
    `;
}

let _lastNavSwitchAt = 0;
const NAV_SWITCH_COOLDOWN = 400;
function setNav(k) {
    if (k === state.activeNav) return;
    const now = Date.now();
    if (now - _lastNavSwitchAt < NAV_SWITCH_COOLDOWN) return;
    _lastNavSwitchAt = now;
    state.activeNav = k;
    renderSidebar();
    if (k === 'play') {
        if (state.lobby) renderLobbyRoom();
        else renderPlay();
    }
    else if (k === 'create') {
        if (state.lobby) renderLobbyRoom();
        else renderCreate();
    }
    else if (k === 'loadout') renderLoadouts();
    else if (k === 'achievements') renderAchievements();
    else if (k === 'perks') renderPerks();
    else if (k === 'leaderboard') renderLeaderboard();
    else if (k === 'profile') renderProfile();
    else if (k === 'history') renderHistory();
    else if (k === 'practice') renderPractice();
    else if (k === 'aim') renderAimTrainer();
}

function renderPlay() {
    const main = document.getElementById('main');
    if (!main) return;
    const publicLobbies = (state.lobbies || []).filter(l => !l.hasPassword);
    const featured = publicLobbies[0] || null;
    const heroImg = featured && featured.mapImage ? `imgs/${escape(featured.mapImage)}` : 'imgs/bg.png';
    const stats = getMergedStats();
    const totalGames = stats.games || 0;

    main.innerHTML = `
        <div class="page-head">
            <div>
                <h1>${T.pageLobbyTitle} <span class="accent">${T.pageLobbyAccent}</span></h1>
                <div class="sub">${T.pageLobbySub}</div>
            </div>
            <div class="actions">
                <button class="btn" id="refresh">${T.refresh}</button>
                <button class="btn primary" id="goCreate">${T.create}</button>
            </div>
        </div>

        <div class="hero-card" id="heroCard" style="margin-bottom:22px; aspect-ratio: 24/9;">
            <div class="hero-img" style="background-image:url('${heroImg}');"></div>
            <span class="badge">داغ‌ترین</span>
            <div class="body">
                <div class="label eng">${featured ? escape(featured.modeLabel || '') : 'PAINTBALL ARENA'}</div>
                <div class="title">${featured ? escape(featured.name) : 'پینت‌بال'}</div>
                <div class="desc">${featured ? `${escape(featured.mapLabel || '')} · ${featured.count}/${featured.max} بازیکن` : 'یک لابی برای ورود انتخاب کن یا لابی خودت رو بساز و دوستان رو دعوت کن.'}</div>
                <button class="btn primary" id="heroJoin">${featured ? T.join : T.create}</button>
            </div>
        </div>

        <div class="section-heading">
            <span>لابی‌های فعال</span>
            <span class="more" id="refreshMore">بروزرسانی →</span>
        </div>
        <div id="lobbyList" class="lobby-grid"></div>

        <div class="ach-card">
            <div class="title eng" style="display:flex;justify-content:space-between;">
                <span>ACHIEVEMENTS</span>
                <span class="more" id="achMore" style="font-size:11px;color:var(--accent);cursor:pointer;">همه ←</span>
            </div>
            <div class="ach-grid" id="playAchGrid"></div>
        </div>
    `;
    document.getElementById('refresh').addEventListener('click', () => requestAction('requestLobbies'));
    document.getElementById('goCreate').addEventListener('click', () => setNav('create'));
    const heroJoin = document.getElementById('heroJoin');
    if (heroJoin) heroJoin.addEventListener('click', () => {
        if (featured) {
            if (featured.hasPassword) promptPassword(featured.id);
            else requestAction('joinLobby', {id: featured.id, password: ''});
        } else {
            setNav('create');
        }
    });
    const refreshMore = document.getElementById('refreshMore');
    if (refreshMore) refreshMore.addEventListener('click', () => requestAction('requestLobbies'));
    const achMore = document.getElementById('achMore');
    if (achMore) achMore.addEventListener('click', () => setNav('achievements'));
    requestAction('requestLobbies');
    requestAction('requestAchievements');
    if (state.flags.leaderboard) requestAction('requestPlayerStats', {mode: 'tdm'});
    paintLobbyList();
    refreshPlayAchievements();
    if (state.lobbyAutoRefresh) clearInterval(state.lobbyAutoRefresh);
    state.lobbyAutoRefresh = setInterval(() => {
        if (state.activeNav === 'play' && !state.lobby) {
            requestAction('requestLobbies');
        }
    }, 8000);
}

function paintLobbyList() {
    const c = document.getElementById('lobbyList');
    if (!c) return;
    if (!state.lobbies || state.lobbies.length === 0) {
        c.innerHTML = `<div class="empty-state" style="grid-column:1/-1;"><h3>${T.noLobby}</h3><p>${T.noLobbyDesc}</p></div>`;
        return;
    }
    c.innerHTML = state.lobbies.map(l => {
        const badges = [];
        if (l.hardcore) badges.push(`<span class="lc-chip hardcore">${T.hardcoreMode}</span>`);
        if (l.headshotOn) badges.push(`<span class="lc-chip headshot">${T.headshot}</span>`);
        if (l.perksEnabled) badges.push(`<span class="lc-chip perks">${T.perksOn}</span>`);
        if (l.killstreaksEnabled) badges.push(`<span class="lc-chip killstreaks">${T.killstreaksOn}</span>`);
        if (l.equipmentCount && l.equipmentCount > 0) badges.push(`<span class="lc-chip equip">${T.equipmentOn} ${l.equipmentCount}</span>`);
        if (l.rounds && l.rounds > 0) badges.push(`<span class="lc-chip rounds"><span class="eng">${l.rounds}</span> ${T.rounds}</span>`);
        return `
        <div class="lobby-card" data-id="${l.id}">
            <div class="img" ${l.mapImage?`style="background-image:url('imgs/${escape(l.mapImage)}');"`:''}>
                <span class="badge-lock ${l.hasPassword?'locked':''}">${l.hasPassword ? '🔒 ' + T.locked : '● ' + T.open}</span>
                <span class="lc-mode">${escape(l.modeLabel)}</span>
                <div class="lc-info-btn" data-info-id="${l.id}" title="اطلاعات کامل لابی">i</div>
            </div>
            <div class="body">
                <div class="name">${escape(l.name)}</div>
                <div class="meta">${escape(l.mapLabel)}</div>
                ${badges.length > 0 ? `<div class="lc-chips">${badges.join('')}</div>` : ''}
            </div>
            <div class="footer">
                <div class="count"><strong>${l.count}/${l.max}</strong> ${T.players}</div>
                <button class="btn primary sm" data-join="${l.id}" data-pass="${l.hasPassword?1:0}">${T.join}</button>
            </div>
        </div>`;
    }).join('');

    c.querySelectorAll('[data-info-id]').forEach(btn => {
        btn.addEventListener('mouseenter', (ev) => {
            const id = parseInt(btn.dataset.infoId);
            const lobby = (state.lobbies || []).find(l => l.id === id);
            if (lobby) showLobbyInfoTooltip(btn, lobby);
        });
        btn.addEventListener('mouseleave', hideLobbyInfoTooltip);
        btn.addEventListener('click', (ev) => { ev.stopPropagation(); });
    });
    c.querySelectorAll('[data-join]').forEach(b => b.addEventListener('click', (ev) => {
        ev.stopPropagation();
        const id = parseInt(b.dataset.join);
        if (b.dataset.pass === '1') promptPassword(id);
        else requestAction('joinLobby', {id: id, password: ''});
    }));
    c.querySelectorAll('.lobby-card').forEach(card => {
        card.style.cursor = 'pointer';
        card.addEventListener('click', () => {
            const id = parseInt(card.dataset.id);
            const lobby = (state.lobbies || []).find(l => l.id === id);
            if (lobby) {
                if (lobby.hasPassword) promptPassword(id);
                else requestAction('joinLobby', {id: id, password: ''});
            }
        });
    });
}

function promptPassword(id) {
    const div = document.createElement('div');
    div.className = 'passwd-prompt';
    div.innerHTML = `
        <div class="passwd-box">
            <h3>${T.lobbyPasswordTitle}</h3>
            <div class="field"><input type="password" id="passInput" maxlength="20" /></div>
            <div class="actions">
                <button class="btn primary" id="passOk">${T.join}</button>
                <button class="btn ghost" id="passCancel">${T.cancel}</button>
            </div>
        </div>
    `;
    document.body.appendChild(div);
    document.getElementById('passInput').focus();
    document.getElementById('passOk').addEventListener('click', () => {
        const v = document.getElementById('passInput').value;
        document.body.removeChild(div);
        requestAction('joinLobby', {id: id, password: v});
    });
    document.getElementById('passCancel').addEventListener('click', () => document.body.removeChild(div));
}

let lastWizTab = null;
const CREATE_TABS = [
    {key: 'mode', label: 'مود'},
    {key: 'map', label: 'مپ'},
    {key: 'weapon', label: 'اسلحه'},
    {key: 'systems', label: 'سیستم‌ها و تجهیزات'},
    {key: 'settings', label: 'تنظیمات'},
];
const WEP_CLASS_LABELS = {pistol: 'پیستول', smg: 'اس‌ام‌جی', shotgun: 'شاتگان', rifle: 'رایفل', sniper: 'اسنایپر', mg: 'مسلسل', heavy: 'سنگین', melee: 'مله'};
const WEP_CLASS_ICONS = {pistol: '🔫', smg: '🔫', shotgun: '💥', rifle: '🪖', sniper: '🎯', mg: '🪖', heavy: '🚀', melee: '🗡'};

function createTabDone(key, c) {
    if (key === 'mode') return !!c.mode;
    if (key === 'map') return !!c.map;
    if (key === 'weapon') return !!c.weapon;
    return false;
}

function createTabMode() {
    return `
        <div class="wiz-head"><h3>${T.section_mode}</h3><p>نوع بازی رو انتخاب کن</p></div>
        <div class="mode-list" id="modeGrid"></div>
    `;
}

function createTabMap() {
    return `
        <div class="wiz-head"><h3>${T.section_map}</h3><p>مپ بازی رو انتخاب کن</p></div>
        <div class="map-list" id="mapGrid"></div>
    `;
}

function createTabWeapon(cfg) {
    const c = state.creating;
    if (c.mode === 'gungame') {
        const ggToggle = `<div class="toggle-row ${c.usePresetGuns !== false ? 'on' : ''}" id="ggPresetTog">
            <div class="toggle-switch"></div>
            <div class="text">
                <div class="title-t">سلاح‌های پیش‌فرض گان‌گیم</div>
                <div class="desc">روشن: از لیست کانفیگ · خاموش: خودت به ترتیب انتخاب کن</div>
            </div>
        </div>`;
        if (c.usePresetGuns === false) {
            return `
        <div class="wiz-head"><h3>سلاح‌های سفارشی گان‌گیم</h3><p>به همون ترتیبی که می‌خوای انتخاب کن (حداقل ۲ تا) — شماره‌ی روی هر سلاح ترتیبشه</p></div>
        ${ggToggle}
        <div id="ggOrder" class="gg-order"></div>
        <div class="wep-search"><span class="wep-search-ic">🔍</span><input id="wepSearch" placeholder="جستجوی اسلحه..." value="${escape(c.wepSearch || '')}" /></div>
        <div class="wep-grid" id="weaponGrid"></div>
    `;
        }
        return `<div class="wiz-head"><h3>${T.weapon}</h3></div>${ggToggle}<div class="wiz-note">گان‌گیم از لیست سلاح‌های پیش‌فرض کانفیگ استفاده می‌کنه. برای انتخاب دستی، همین بالا تیک «سلاح‌های پیش‌فرض» رو خاموش کن.</div>`;
    }
    if (cfg.weapon === false) {
        return `<div class="wiz-head"><h3>${T.weapon}</h3></div><div class="wiz-note">این مود اسلحه‌ی ثابت داره و قابل انتخاب نیست.</div>`;
    }
    return `
        <div class="wiz-head"><h3>اسلحه پیش‌فرض</h3><p>اسلحه‌ای که بازیکن‌ها باهاش شروع می‌کنن</p></div>
        <div class="wep-search"><span class="wep-search-ic">🔍</span><input id="wepSearch" placeholder="جستجوی اسلحه..." value="${escape(c.wepSearch || '')}" /></div>
        <div class="wep-grid" id="weaponGrid"></div>
    `;
}

function createTabSystems(c) {
    const eqHtml = (state.equipmentItems && state.equipmentItems.length > 0) ? `
        <div class="wiz-subhead"><span>تجهیزات ${state.flags.equipmentComingSoon ? '<span class="soon-tag">به‌زودی</span>' : ''}</span></div>
        <div class="eq-grid ${state.flags.equipmentComingSoon ? 'coming-soon-section' : ''}" id="equipmentGrid">
            ${state.equipmentItems.map(it => {
                const on = (c.equipment || []).includes(it.key);
                const soon = state.flags.equipmentComingSoon;
                const eqIc = PB_EQUIP_ICONS[it.key];
                return `<div class="eq-pill ${on && !soon ? 'on' : ''} ${soon ? 'coming-soon' : ''}" data-eq="${it.key}" ${soon ? 'data-soon="1"' : ''}>${eqIc ? `<span class="eq-ic">${pbIconImg(eqIc, '', 'eqpill-ic')}</span>` : ''}<span class="count eng">×${it.count}</span> ${escape(it.label)}</div>`;
            }).join('')}
        </div>
    ` : '';
    return `
        <div class="wiz-head"><h3>سیستم‌ها و تجهیزات</h3><p>قابلیت‌های اضافه‌ی مچ</p></div>
        <div class="toggle-row ${c.killstreaks ? 'on' : ''} ${state.flags.killstreaksComingSoon ? 'coming-soon' : ''}" id="ksToggle" ${state.flags.killstreaksComingSoon ? 'data-soon="1"' : ''}>
            <div class="toggle-switch"></div>
            <div class="text">
                <div class="title-t">سیستم Killstreak ${state.flags.killstreaksComingSoon ? '<span class="soon-tag">به‌زودی</span>' : ''}</div>
                <div class="desc eng">3=UAV · 4=Spy · 5=Care · 7=Sentry · 9=AttackHeli · 10=Airstrike · 12=Predator · 13=AC130 · 15=Nuke</div>
            </div>
        </div>
        <div class="toggle-row ${c.perksEnabled !== false && !state.flags.perksComingSoon ? 'on' : ''} ${state.flags.perksComingSoon ? 'coming-soon' : ''}" id="perksToggle" ${state.flags.perksComingSoon ? 'data-soon="1"' : ''}>
            <div class="toggle-switch"></div>
            <div class="text">
                <div class="title-t">سیستم Perks ${state.flags.perksComingSoon ? '<span class="soon-tag">به‌زودی</span>' : ''}</div>
                <div class="desc">با Numpad 1/2/3 پرک‌ها فعال میشن - دو سریع، پرش، ریلود سریع، زره اضافه، و غیره</div>
            </div>
        </div>
        <div class="toggle-row ${c.hardcore ? 'on danger-tone' : ''} ${state.flags.hardcoreComingSoon ? 'coming-soon' : ''}" id="hcToggle" ${state.flags.hardcoreComingSoon ? 'data-soon="1"' : ''}>
            <div class="toggle-switch"></div>
            <div class="text">
                <div class="title-t">حالت هاردکور ${state.flags.hardcoreComingSoon ? '<span class="soon-tag">به‌زودی</span>' : ''}</div>
                <div class="desc">بدون HUD · بدون مینی‌مپ · دمیج واقعی · بدون اسپاون پروتکشن</div>
            </div>
        </div>
        ${eqHtml}
    `;
}

function getTimerBounds(mode) {
    if (mode === 'gungame') return { min: 180, max: 1800, default: 600 };
    return { min: 60, max: 900, default: 180 };
}

function createTabSettings(c, cfg) {
    const modeObj = state.modes.find(m => m.key === c.mode);
    const mapObj = (state.maps[c.mode] || []).find(m => m.key === c.map);
    const wepObj = (state.weapons || []).find(w => w.model === c.weapon);
    return `
        <div class="wiz-head"><h3>تنظیمات</h3><p>جزئیات نهایی لابی</p></div>
        <div class="form-grid full">
            <div class="field"><label>${T.lobbyName}</label><input id="cName" maxlength="24" value="${escape(c.name || '')}" /></div>
            <div class="field"><label>${T.password}</label><input id="cPass" maxlength="20" value="${escape(c.password || '')}" /></div>
        </div>
        <div class="form-grid" style="margin-top:10px;">
            ${cfg.rounds ? `<div class="field"><label>${T.rounds}</label><input type="number" id="cRounds" min="1" max="24" value="${c.rounds}" /></div>` : ''}
            ${cfg.timer ? `<div class="field"><label>${T.timer}</label><input type="number" id="cTimer" min="${getTimerBounds(c.mode).min}" max="${getTimerBounds(c.mode).max}" value="${c.timer}" /></div>` : ''}
            ${cfg.armor ? `<div class="field"><label>${T.armor}</label><input type="number" id="cArmor" min="0" max="100" value="${c.armor}" /></div>` : ''}
            ${cfg.headshot ? `<div class="field"><label>${T.headshot}</label><select id="cHead"><option value="1" ${c.head == 1 ? 'selected' : ''}>${T.headOn}</option><option value="0" ${c.head == 0 ? 'selected' : ''}>${T.headOff}</option></select></div>` : ''}
            ${(c.mode === 'koth' || c.mode === 'domination' || c.mode === 'gunrotation') ? `<div class="field"><label>امتیاز برنده</label><input type="number" id="cScore" min="20" max="500" value="${c.scoreToWin || 200}" /></div>` : ''}
            ${c.mode === 'tdm' ? `<div class="field"><label>کیل برای برد</label><input type="number" id="cScore" min="20" max="500" value="${c.scoreToWin || 50}" /></div>` : ''}
            ${c.mode === 'escort' ? `<div class="field"><label>جان VIP</label><input type="number" id="cVipLives" min="1" max="10" value="${c.vipLives || 3}" /></div>` : ''}
            ${(c.mode === 'coop' || c.mode === 'wavedefense') ? `<div class="field"><label>تعداد امواج</label><input type="number" id="cWaves" min="5" max="50" value="${c.waves || 25}" /></div>` : ''}
            <div class="field"><label>${T.fee}</label><select id="cFee"><option value="0" ${c.fee == 0 ? 'selected' : ''}>${T.feeTc}</option><option value="1" ${c.fee == 1 ? 'selected' : ''}>${T.feeSc}</option><option value="2" ${c.fee == 2 ? 'selected' : ''}>${T.feeMoney}</option></select></div>
        </div>
        ${c.mode === 'sunset_tdm' ? `<div class="toggle-row ${c.switchTeam ? 'on' : ''}" id="stToggle">
            <div class="toggle-switch"></div>
            <div class="text">
                <div class="title-t">تعویض اسپاون تیم‌ها</div>
                <div class="desc">هر راند که تموم شه، محل اسپاون دو تیم با هم عوض میشه</div>
            </div>
        </div>` : ''}
        <div class="wiz-summary">
            <div class="wiz-sum-item"><span>${T.mode}</span><b>${modeObj ? escape(modeObj.label) : '—'}</b></div>
            <div class="wiz-sum-item"><span>${T.map}</span><b>${mapObj ? escape(mapObj.label) : '—'}</b></div>
            <div class="wiz-sum-item"><span>${T.weapon}</span><b>${cfg.weapon === false ? 'ثابت' : (wepObj ? escape(wepObj.label) : '—')}</b></div>
        </div>
    `;
}

function renderCreate() {
    const main = document.getElementById('main');
    if (!main) return;
    if (!state.modes || state.modes.length === 0) requestAction('requestModes');
    const c = state.creating;
    if (!c.tab) c.tab = 'mode';
    if (c.mode && !state.maps[c.mode]) requestAction('requestMaps', {mode: c.mode});
    const selectedMode = state.modes.find(m => m.key === c.mode);
    const cfg = (selectedMode && selectedMode.configurable) || {weapon: true, rounds: true, timer: true, armor: true, headshot: true};
    const tab = c.tab;
    const idx = Math.max(0, CREATE_TABS.findIndex(t => t.key === tab));
    const isFirst = idx <= 0;
    const isLast = idx >= CREATE_TABS.length - 1;
    const animClass = lastWizTab === tab ? '' : 'wiz-anim';
    lastWizTab = tab;

    const tabsHtml = CREATE_TABS.map((t, i) => {
        const done = createTabDone(t.key, c);
        return `<button class="tab-btn wiz-tab ${t.key === tab ? 'active' : ''} ${done ? 'done' : ''}" data-wtab="${t.key}">
            <span class="wiz-num eng">${i + 1}</span>
            <span>${t.label}</span>
            ${done ? '<span class="wiz-tick">✓</span>' : ''}
        </button>`;
    }).join('');

    let panel = '';
    if (tab === 'mode') panel = createTabMode();
    else if (tab === 'map') panel = createTabMap();
    else if (tab === 'weapon') panel = createTabWeapon(cfg);
    else if (tab === 'systems') panel = createTabSystems(c);
    else panel = createTabSettings(c, cfg);

    main.innerHTML = `
        <div class="page-head">
            <div><h1>${T.pageCreateTitle} <span class="accent">${T.pageCreateAccent}</span></h1>
            <div class="sub">${T.pageCreateSub}</div></div>
            <div class="actions"><button class="btn" id="backCreate">${T.backBtn}</button></div>
        </div>
        <div class="wizard">
            <div class="tabs-bar wizard-tabs">${tabsHtml}</div>
            <div class="wizard-panel ${animClass}">${panel}</div>
            <div class="wizard-nav">
                <button class="btn wiz-prev" ${isFirst ? 'disabled' : ''}>‹ قبلی</button>
                <div class="wiz-progress"><span class="eng">${idx + 1}</span> / <span class="eng">${CREATE_TABS.length}</span></div>
                ${isLast ? `<button class="btn primary wiz-create">${T.createBtn}</button>` : `<button class="btn wiz-next">بعدی ›</button>`}
            </div>
        </div>
    `;
    paintModeGrid();
    paintMapGrid();
    paintWeaponGrid();
    bindCreateInputs();
    bindWizard();
}

function paintModeGrid() {
    const g = document.getElementById('modeGrid');
    if (!g) return;
    const orderedModes = state.modes.slice().sort((a, b) => {
        if (!!a.comingSoon !== !!b.comingSoon) return a.comingSoon ? 1 : -1;
        return (b.priority || 0) - (a.priority || 0);
    });
    g.innerHTML = orderedModes.map(m => {
        const tipText = modeTooltips[m.key] || '';
        const soon = m.comingSoon;
        return `
        <div class="mode-tile ${state.creating.mode===m.key?'active':''} ${soon?'coming-soon':''}" data-mode="${m.key}" ${soon?'data-soon="1"':''}>
            ${soon ? `<div class="coming-badge">به‌زودی</div>` : ''}
            ${tipText ? `<div class="tooltip" data-tip>?</div><div class="tooltip-text">${escape(tipText)}</div>` : ''}
            <h4>${escape(m.label)}</h4>
            <div class="meta">${m.teamCount === 1 ? 'سولو / FFA' : `${m.teamCount} تیم`}</div>
        </div>`;
    }).join('');
    g.querySelectorAll('[data-mode]').forEach(t => {
        t.addEventListener('click', (e) => {
            if (e.target && e.target.classList && e.target.classList.contains('info-icon')) return;
            if (t.dataset.soon === '1') {
                showToast('این مود به‌زودی منتشر میشه');
                return;
            }
            const _newMode = t.dataset.mode;
            if (state.creating.mode !== _newMode) state.creating.timer = getTimerBounds(_newMode).default;
            state.creating.mode = _newMode;
            state.creating.map = null;
            if (!state.maps[state.creating.mode]) requestAction('requestMaps', {mode: state.creating.mode});
            renderCreate();
        });
    });
}

function paintMapGrid() {
    const g = document.getElementById('mapGrid');
    if (!g) return;
    if (!state.creating.mode) { g.innerHTML = '<div style="color:var(--text-muted);font-size:12px;padding:8px 0;">' + T.selectMode + '</div>'; return; }
    const list = state.maps[state.creating.mode];
    if (!list) { g.innerHTML = '<div style="color:var(--text-muted);font-size:12px;padding:8px 0;">' + T.loading + '</div>'; return; }
    const sortedMaps = list.slice().sort((a, b) => (b.priority || 0) - (a.priority || 0));
    g.innerHTML = sortedMaps.map(m => `
        <div class="map-tile ${state.creating.map===m.key?'active':''}" data-map="${m.key}">
            <div class="img" ${m.image?`style="background-image:url('imgs/${escape(m.image)}');"`:''}>
                ${m.image?'':escape(m.label.charAt(0))}
            </div>
            <div class="label">${escape(m.label)}</div>
        </div>
    `).join('');
    g.querySelectorAll('[data-map]').forEach(t => t.addEventListener('click', () => {
        state.creating.map = t.dataset.map;
        renderCreate();
    }));
}

function bindCreateInputs() {
    const c = state.creating;
    const bind = (id, key, parser) => {
        const el = document.getElementById(id);
        if (!el) return;
        el.addEventListener('input', e => { c[key] = parser ? parser(e.target.value) : e.target.value; });
    };
    bind('cName', 'name');
    bind('cPass', 'password');

    const bindClampedInt = (id, key, min, max) => {
        const el = document.getElementById(id);
        if (!el) return;
        const validate = (rawValue) => {
            const n = parseInt(rawValue);
            const invalid = isNaN(n) || n < min || n > max;
            el.classList.toggle('invalid', invalid);
            if (invalid) {
                el.title = `مقدار باید بین ${min} و ${max} باشه`;
            } else {
                el.removeAttribute('title');
            }
            return invalid ? null : n;
        };
        el.addEventListener('input', e => {
            validate(e.target.value);
            const n = parseInt(e.target.value);
            if (!isNaN(n)) c[key] = Math.max(min, Math.min(max, n));
        });
        el.addEventListener('blur', e => {
            const n = parseInt(e.target.value);
            let final = n;
            if (isNaN(n)) final = min;
            else if (n < min) final = min;
            else if (n > max) final = max;
            e.target.value = final;
            c[key] = final;
            el.classList.remove('invalid');
            el.removeAttribute('title');
        });
        validate(el.value);
    };

    bindClampedInt('cRounds', 'rounds', 1, 24);
    const _tb = getTimerBounds(c.mode);
    bindClampedInt('cTimer', 'timer', _tb.min, _tb.max);
    bindClampedInt('cArmor', 'armor', 0, 100);
    bindClampedInt('cScore', 'scoreToWin', 20, 500);
    bindClampedInt('cVipLives', 'vipLives', 1, 10);
    bindClampedInt('cWaves', 'waves', 5, 50);
    bind('cHead', 'head', parseInt);
    bind('cFee', 'fee', parseInt);

    const back = document.getElementById('backCreate');
    if (back) back.addEventListener('click', () => setNav('play'));

    const ws = document.getElementById('wepSearch');
    if (ws) ws.addEventListener('input', e => { c.wepSearch = e.target.value; paintWeaponGrid(); });

    document.querySelectorAll('[data-eq]').forEach(b => b.addEventListener('click', () => {
        if (b.dataset.soon === '1') { showToast('تجهیزات به‌زودی فعال میشه'); return; }
        c.equipment = c.equipment || [];
        const k = b.dataset.eq;
        const idx = c.equipment.indexOf(k);
        if (idx >= 0) c.equipment.splice(idx, 1);
        else c.equipment.push(k);
        renderCreate();
    }));
    const ksTog = document.getElementById('ksToggle');
    if (ksTog) ksTog.addEventListener('click', () => {
        if (ksTog.dataset.soon === '1') { showToast('Killstreak به‌زودی فعال میشه'); return; }
        c.killstreaks = !c.killstreaks;
        renderCreate();
    });
    const perksTog = document.getElementById('perksToggle');
    if (perksTog) perksTog.addEventListener('click', () => {
        if (perksTog.dataset.soon === '1') { showToast('Perks به‌زودی فعال میشه'); return; }
        c.perksEnabled = c.perksEnabled === false;
        renderCreate();
    });
    const hcTog = document.getElementById('hcToggle');
    if (hcTog) hcTog.addEventListener('click', () => {
        if (hcTog.dataset.soon === '1') { showToast('حالت هاردکور به‌زودی فعال میشه'); return; }
        c.hardcore = !c.hardcore;
        renderCreate();
    });
    const stTog = document.getElementById('stToggle');
    if (stTog) stTog.addEventListener('click', () => {
        c.switchTeam = !c.switchTeam;
        renderCreate();
    });
    const ggTog = document.getElementById('ggPresetTog');
    if (ggTog) ggTog.addEventListener('click', () => {
        c.usePresetGuns = c.usePresetGuns === false;
        renderCreate();
    });
}

function paintGunGameGrid() {
    const c = state.creating;
    c.customWeapons = c.customWeapons || [];
    const order = document.getElementById('ggOrder');
    if (order) {
        if (!c.customWeapons.length) {
            order.innerHTML = `<div class="gg-order-empty">هنوز سلاحی انتخاب نشده — از پایین به ترتیب انتخاب کن</div>`;
        } else {
            order.innerHTML = c.customWeapons.map((model, i) => {
                const w = (state.weapons || []).find(x => x.model === model);
                const label = w ? w.label : model.replace('WEAPON_', '');
                return `<div class="gg-order-chip" data-ggremove="${model}"><span class="gg-order-num eng">${i + 1}</span><span>${escape(label)}</span><span class="gg-order-x">✕</span></div>`;
            }).join('') + `<button class="gg-order-clear" id="ggClear">پاک کردن</button>`;
        }
    }
    const g = document.getElementById('weaponGrid');
    if (!g) return;
    const q = (c.wepSearch || '').trim().toLowerCase();
    const all = state.weapons || [];
    if (!all.length) { g.innerHTML = `<div class="wep-empty">${T.loading}</div>`; return; }
    const list = all.filter(w => {
        if (!q) return true;
        const cl = WEP_CLASS_LABELS[w.class] || w.class || '';
        return (w.label || '').toLowerCase().includes(q) || (w.model || '').toLowerCase().includes(q) || cl.toLowerCase().includes(q) || (w.class || '').toLowerCase().includes(q);
    });
    if (!list.length) { g.innerHTML = `<div class="wep-empty">اسلحه‌ای پیدا نشد</div>`; return; }
    g.innerHTML = list.map(w => {
        const pos = c.customWeapons.indexOf(w.model);
        const sel = pos >= 0;
        const cls = w.class || '';
        return `<div class="wep-card ${sel ? 'active' : ''}" data-ggwep="${w.model}">
            ${sel ? `<div class="wep-check eng">${pos + 1}</div>` : ''}
            <div class="wep-img"><img src="imgs/weapons/${escape(w.key || '')}.png" onerror="this.style.display='none';this.parentNode.innerHTML='${WEP_CLASS_ICONS[cls] || '•'}';" /></div>
            <div class="wep-name">${escape(w.label)}</div>
            <div class="wep-meta"><span class="wep-class">${escape(WEP_CLASS_LABELS[cls] || cls)}</span></div>
        </div>`;
    }).join('');
    g.querySelectorAll('[data-ggwep]').forEach(el => el.addEventListener('click', () => {
        const model = el.dataset.ggwep;
        const idx = c.customWeapons.indexOf(model);
        if (idx >= 0) c.customWeapons.splice(idx, 1);
        else c.customWeapons.push(model);
        paintGunGameGrid();
    }));
    if (order) {
        order.querySelectorAll('[data-ggremove]').forEach(el => el.addEventListener('click', () => {
            const model = el.dataset.ggremove;
            const idx = c.customWeapons.indexOf(model);
            if (idx >= 0) c.customWeapons.splice(idx, 1);
            paintGunGameGrid();
        }));
        const clr = document.getElementById('ggClear');
        if (clr) clr.addEventListener('click', () => { c.customWeapons = []; paintGunGameGrid(); });
    }
}

function paintWeaponGrid() {
    const c = state.creating;
    if (c.mode === 'gungame' && c.usePresetGuns === false) { paintGunGameGrid(); return; }
    const g = document.getElementById('weaponGrid');
    if (!g) return;
    const q = (c.wepSearch || '').trim().toLowerCase();
    const all = state.weapons || [];
    if (!all.length) { g.innerHTML = `<div class="wep-empty">${T.loading}</div>`; return; }
    const list = all.filter(w => {
        if (!q) return true;
        const cl = WEP_CLASS_LABELS[w.class] || w.class || '';
        return (w.label || '').toLowerCase().includes(q) || (w.model || '').toLowerCase().includes(q) || cl.toLowerCase().includes(q) || (w.class || '').toLowerCase().includes(q);
    });
    if (!list.length) { g.innerHTML = `<div class="wep-empty">اسلحه‌ای پیدا نشد</div>`; return; }
    g.innerHTML = list.map(w => {
        const sel = c.weapon === w.model;
        const cls = w.class || '';
        const dmg = (w.stats && w.stats.damage) || 0;
        return `<div class="wep-card ${sel ? 'active' : ''}" data-wep="${w.model}">
            ${sel ? '<div class="wep-check">✓</div>' : ''}
            <div class="wep-img"><img src="imgs/weapons/${escape(w.key || '')}.png" onerror="this.style.display='none';this.parentNode.innerHTML='${WEP_CLASS_ICONS[cls] || '•'}';" /></div>
            <div class="wep-name">${escape(w.label)}</div>
            <div class="wep-meta"><span class="wep-class">${escape(WEP_CLASS_LABELS[cls] || cls)}</span><span class="wep-dmg eng">DMG ${dmg}</span></div>
        </div>`;
    }).join('');
    g.querySelectorAll('[data-wep]').forEach(el => el.addEventListener('click', () => {
        c.weapon = el.dataset.wep;
        paintWeaponGrid();
    }));
}

function bindWizard() {
    const c = state.creating;
    document.querySelectorAll('[data-wtab]').forEach(b => b.addEventListener('click', () => {
        c.tab = b.dataset.wtab;
        renderCreate();
    }));
    const tabIdx = () => Math.max(0, CREATE_TABS.findIndex(t => t.key === c.tab));
    const prev = document.querySelector('.wiz-prev');
    if (prev) prev.addEventListener('click', () => { const i = tabIdx(); if (i > 0) { c.tab = CREATE_TABS[i - 1].key; renderCreate(); } });
    const next = document.querySelector('.wiz-next');
    if (next) next.addEventListener('click', () => { const i = tabIdx(); if (i < CREATE_TABS.length - 1) { c.tab = CREATE_TABS[i + 1].key; renderCreate(); } });
    const create = document.querySelector('.wiz-create');
    if (create) create.addEventListener('click', doCreateLobby);
}

function doCreateLobby() {
    const c = state.creating;
    if (!c.mode) { showToast(T.needModeMap); c.tab = 'mode'; renderCreate(); return; }
    if (!c.map) { showToast(T.needModeMap); c.tab = 'map'; renderCreate(); return; }
    if (!c.name || !c.name.trim()) { showToast('اسم لابی رو وارد کن'); c.tab = 'settings'; renderCreate(); const _ni = document.getElementById('cName'); if (_ni) _ni.focus(); return; }
    const invalidInput = document.querySelector('#main input.invalid');
    if (invalidInput) { showToast('یکی از مقادیر نامعتبره'); invalidInput.focus(); return; }
    if (c.mode === 'gungame' && c.usePresetGuns === false && (c.customWeapons || []).length < 2) { showToast('برای گان‌گیم سفارشی حداقل ۲ سلاح انتخاب کن'); c.tab = 'weapon'; renderCreate(); return; }
    requestAction('createLobby', { ...c, perks: state.selectedPerks, entryPoint: state.entryPoint || 1, equipment: c.equipment || [], killstreaks: c.killstreaks || false, hardcore: c.hardcore || false, switchTeam: c.switchTeam || false, customGuns: (c.mode === 'gungame' && c.usePresetGuns === false), gungameWeapons: c.customWeapons || [], perksEnabled: c.perksEnabled !== false, scoreToWin: c.scoreToWin, vipLives: c.vipLives, waves: c.waves });
}

function renderLobbyRoom() {
    const main = document.getElementById('main');
    if (!main || !state.lobby) return;
    const lobby = state.lobby;
    const me = lobby.players && lobby.players.find(p => p.src === window.__pbServerId);
    const teamA = (lobby.players||[]).filter(p => p.team === 1);
    const teamB = (lobby.players||[]).filter(p => p.team === 2);
    const spectators = (lobby.players||[]).filter(p => p.team === 0);
    const isFFA = lobby.teamCount === 1;
    const totalPlayers = (lobby.players||[]).length;
    const readyCount = (lobby.players||[]).filter(p => p.ready).length;
    const isHost = me && me.leader;
    const myReady = me && me.ready;

    main.innerHTML = `
        <div class="page-head">
            <div><h1>${escape(lobby.name)}</h1>
            <div class="sub">${escape(lobby.modeLabel)} · ${escape(lobby.mapLabel || lobby.map)}</div></div>
            <div class="actions">
                ${isHost ? `<button class="btn danger" id="cancelLobby">✗ کنسل لابی</button>` : `<button class="btn danger" id="leaveLobby">${T.leave}</button>`}
            </div>
        </div>

        <div class="lobby-room ${isFFA ? 'ffa' : ''}">
            ${isFFA ? `
            <div class="team-panel clickable-team" data-team="1">
                <div class="team-head">
                    <div class="team-marker"></div>
                    <div class="team-name">${T.players}</div>
                    <div class="team-count eng">${(lobby.players||[]).filter(p => p.team !== 0).length}</div>
                </div>
                <div class="team-list">${(lobby.players||[]).filter(p => p.team !== 0).map(p => playerRow(p)).join('') || '<div style="padding:10px; color:var(--text-muted); font-size:11px;">لیست خالیه</div>'}</div>
            </div>` : `
            <div class="team-panel clickable-team" data-team="1">
                <div class="team-head">
                    <div class="team-marker"></div>
                    <div class="team-name">${T.teamA}</div>
                    <div class="team-count eng">${teamA.length}</div>
                </div>
                <div class="team-list">${teamA.map(p => playerRow(p)).join('')}</div>
            </div>`}

            <div class="center-panel">
                ${lobby.mapImage ? `
                <div class="match-hero" style="background-image:url('imgs/${escape(lobby.mapImage)}');">
                    <div class="info-overlay">
                        <h2>${escape(lobby.mapLabel || lobby.map)}</h2>
                        <p>${escape(lobby.modeLabel)}</p>
                    </div>
                </div>` : ''}

                <div class="status-strip">
                    ${lobby.rounds ? `<div class="status-chip">${T.rounds}: ${lobby.rounds}</div>` : ''}
                    <div class="status-chip accent">${T.players} ${totalPlayers}/${lobby.maxPlayers}</div>
                    <div class="status-chip ${readyCount === totalPlayers && totalPlayers > 0 ? 'success' : ''}">آماده ${readyCount}/${totalPlayers}</div>
                    ${myReady ? `<div class="status-chip success">✓ شما</div>` : ''}
                    ${isHost ? `<div class="status-chip gold">◆ میزبان</div>` : ''}
                </div>

                <div class="lobby-info-anchor" id="lobbyDetailsBtn" data-info-room="1">
                    <span class="lc-info-btn-inline" title="جزییات کامل مچ">i</span>
                    <span class="lobby-info-hint">جزییات مچ</span>
                </div>


                ${spectators.length ? `<div class="spectators-row ${spectators.length > 8 ? 'large' : ''}">
                    <div class="spectators-head">
                        <span class="lbl">${T.spectators}</span>
                        <span class="count eng">${spectators.length}</span>
                    </div>
                    <div class="spectators-list">
                        ${spectators.map(p => `<span class="name" title="${escape(p.name)}">${escape(p.name)}</span>`).join('')}
                    </div>
                </div>` : ''}

                <div class="action-block">
                    <div class="label">انتخاب تیم</div>
                    <div class="row">
                        ${isFFA ? `<button class="btn" data-team="1">${T.joinMatch}</button>` : `<button class="btn" data-team="1">${T.switchA}</button>`}
                        ${isFFA ? '' : `<button class="btn" data-team="2">${T.switchB}</button>`}
                        <button class="btn" data-team="0">${T.spectate}</button>
                    </div>
                </div>

                <div class="action-block">
                    <div class="label">آماده‌سازی</div>
                    <div class="row">
                        <button class="btn ${myReady?'success':''}" id="readyBtn">${myReady ? '✓ ' + T.ready : T.ready}</button>
                        ${isHost && state.flags.readyCheck ? `<button class="btn" id="rcBtn">${T.readyCheck}</button>` : ''}
                        ${isHost && state.flags.autoBalance ? `<button class="btn" id="balanceBtn">${T.autoBalance}</button>` : ''}
                    </div>
                </div>

                ${isHost ? `
                <div class="action-block primary-tone">
                    <div class="label">شروع مچ</div>
                    <div class="row">
                        <button class="btn primary" id="startBtn">${T.start}</button>
                        ${state.flags.adminSoloStart ? `<button class="btn gold" id="adminSoloBtn">⚡ ${T.adminSolo}</button>` : ''}
                    </div>
                </div>` : `<div style="padding: 14px; text-align: center; color: var(--text-muted); font-size: 12px;">منتظر میزبان...</div>`}
            </div>

            ${isFFA ? '' : `
            <div class="team-panel bravo clickable-team" data-team="2">
                <div class="team-head">
                    <div class="team-marker"></div>
                    <div class="team-name">${T.teamB}</div>
                    <div class="team-count eng">${teamB.length}</div>
                </div>
                <div class="team-list">${teamB.map(p => playerRow(p)).join('')}</div>
            </div>`}
        </div>
    `;
    const leaveBtn = document.getElementById('leaveLobby');
    if (leaveBtn) leaveBtn.addEventListener('click', () => requestAction('leaveLobby'));
    const cancelBtn = document.getElementById('cancelLobby');
    if (cancelBtn) cancelBtn.addEventListener('click', () => {
        requestAction('cancelLobby');
    });
    const detailsBtn = document.getElementById('lobbyDetailsBtn');
    if (detailsBtn) {
        detailsBtn.addEventListener('mouseenter', () => showLobbyInfoTooltip(detailsBtn, lobby));
        detailsBtn.addEventListener('mouseleave', hideLobbyInfoTooltip);
    }
    document.querySelectorAll('[data-team]').forEach(b => b.addEventListener('click', (ev) => {
        ev.stopPropagation();
        requestAction('switchTeam', {team: parseInt(b.dataset.team)});
    }));
    document.querySelectorAll('.clickable-team').forEach(c => c.addEventListener('click', () => {
        requestAction('switchTeam', {team: parseInt(c.dataset.team)});
    }));
    const rb = document.getElementById('readyBtn');
    if (rb) rb.addEventListener('click', () => {
        const cur = (lobby.players||[]).find(p => p.src === window.__pbServerId);
        requestAction('setReady', {ready: !(cur && cur.ready)});
    });
    const sb = document.getElementById('startBtn');
    if (sb) sb.addEventListener('click', () => requestAction('startMatch', {useAdminSolo: false}));
    const adminSoloBtn = document.getElementById('adminSoloBtn');
    if (adminSoloBtn) adminSoloBtn.addEventListener('click', () => requestAction('startMatch', {useAdminSolo: true}));
    const balanceBtn = document.getElementById('balanceBtn');
    if (balanceBtn) balanceBtn.addEventListener('click', () => requestAction('requestAutoBalance'));
    const rcBtn = document.getElementById('rcBtn');
    if (rcBtn) rcBtn.addEventListener('click', () => requestAction('startReadyCheck'));
}

function playerRow(p) {
    return `<div class="player-row ${p.ready?'ready':''} ${p.leader?'leader':''}">
        <span>${escape(p.name)}</span>
        <span class="status">${p.ready?T.ready:T.wait}</span>
    </div>`;
}

function renderPerks() {
    const main = document.getElementById('main');
    if (!main) return;
    if (!state.perks.enabled) { main.innerHTML = `<div class="empty-state"><h3>پرک‌ها غیرفعال</h3></div>`; return; }
    const cap = state.perks.perksPerPlayer || 3;
    main.innerHTML = `
        <div class="page-head">
            <div><h1>${T.pagePerksTitle} <span class="accent">${T.pagePerksAccent}</span></h1>
                <div class="sub"><span class="eng">${state.selectedPerks.length}/${cap}</span> ${T.selectedCount}</div></div>
            <div class="actions"><button class="btn primary" id="savePerks">${T.perkSaveBtn}</button></div>
        </div>
        <div class="perk-grid" id="perksGrid"></div>
    `;
    const g = document.getElementById('perksGrid');
    g.innerHTML = (state.perks.perks || []).map(p => `
        <div class="perk-card ${state.selectedPerks.includes(p.key)?'selected':''} ${p.comingSoon?'coming-soon':''}" data-perk="${p.key}" ${p.comingSoon?'data-soon="1"':''}>
            <div class="perk-card-ic">${pbIconImg(PB_PERK_ICONS[p.key], '★', 'pcard-ic')}</div>
            <div class="perk-card-txt">
                <h5>${escape(p.label)}${p.comingSoon?' <span class="soon-tag">به‌زودی</span>':''}</h5>
                <p>${escape(p.description||'')}</p>
            </div>
        </div>
    `).join('');
    g.querySelectorAll('[data-perk]').forEach(c => c.addEventListener('click', () => {
        if (c.dataset.soon === '1') { showToast('این پرک به‌زودی فعال میشه'); return; }
        const k = c.dataset.perk;
        const idx = state.selectedPerks.indexOf(k);
        if (idx >= 0) state.selectedPerks.splice(idx, 1);
        else if (state.selectedPerks.length < cap) state.selectedPerks.push(k);
        renderPerks();
    }));
    document.getElementById('savePerks').addEventListener('click', () => {
        requestAction('setPerks', {perks: state.selectedPerks});
        showToast(T.perkSaved);
    });
}

function renderLeaderboard() {
    const main = document.getElementById('main');
    if (!main) return;
    if (!state.flags.leaderboard) { main.innerHTML = `<div class="empty-state"><h3>لیدربورد غیرفعال</h3></div>`; return; }
    const modes = (state.modes || []).slice();
    const sortLabel = state.lbSort === 'kills' ? T.kills : T.wins;
    main.innerHTML = `
        <div class="page-head">
            <div><h1>${T.pageLBTitle} <span class="accent">${T.pageLBAccent}</span></h1>
                <div class="sub">${T.mode}: <span class="eng">${escape(state.lbMode)}</span> · ${sortLabel}</div></div>
        </div>
        <div class="tabs-bar">
            ${modes.map(m => `<div class="tab-btn ${state.lbMode===m.key?'active':''}" data-mode="${m.key}">${escape(m.label)}</div>`).join('')}
        </div>
        <div class="tabs-bar">
            ${[['kills', T.kills],['wins', T.wins]].map(s => `<div class="tab-btn ${state.lbSort===s[0]?'active':''}" data-sort="${s[0]}">${s[1]}</div>`).join('')}
        </div>
        <div class="stats-table">
            <table>
                <thead><tr><th>${T.rank}</th><th>${T.identifier}</th><th>${T.kills}</th><th>${T.deaths}</th><th>${T.kd}</th><th>${T.wins}</th><th>${T.games}</th><th>${T.headshots}</th></tr></thead>
                <tbody>
                    ${state.lbData.length === 0 ? `<tr><td colspan="8" style="text-align:center;color:var(--text-muted);padding:40px">${T.noLeaderboardData}</td></tr>` :
                    state.lbData.map((r, i) => `
                        <tr>
                            <td class="rank eng">#${i+1}</td>
                            <td class="eng">${escape(String(r.identifier).slice(0, 16))}</td>
                            <td class="eng">${r.kills}</td>
                            <td class="eng">${r.deaths}</td>
                            <td class="ratio eng">${r.deaths > 0 ? (r.kills/r.deaths).toFixed(2) : r.kills.toFixed(2)}</td>
                            <td class="eng">${r.wins}</td>
                            <td class="eng">${r.games}</td>
                            <td class="eng">${r.headshots||0}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
    main.querySelectorAll('[data-mode]').forEach(t => t.addEventListener('click', () => {
        state.lbMode = t.dataset.mode;
        requestAction('requestLeaderboard', {mode: state.lbMode, sortBy: state.lbSort});
    }));
    main.querySelectorAll('[data-sort]').forEach(t => t.addEventListener('click', () => {
        state.lbSort = t.dataset.sort;
        requestAction('requestLeaderboard', {mode: state.lbMode, sortBy: state.lbSort});
    }));
}

function renderProfile() {
    const main = document.getElementById('main');
    if (!main) return;
    if (state.flags.leaderboard) requestAction('requestPlayerStats', {mode: 'tdm'});
    if (!state.achievementsData) requestAction('requestAchievements');
    paintProfile();
}

function paintProfile() {
    const main = document.getElementById('main');
    if (!main) return;
    const p = getMergedStats();
    const lbReady = state.playerStatsLoaded === true;
    const achReady = state.achievementsData !== undefined && state.achievementsData !== null;
    const hasAny = lbReady || achReady;
    main.innerHTML = `
        <div class="page-head"><div><h1>${T.pageProfileTitle} <span class="accent">${T.pageProfileAccent}</span></h1>
        <div class="sub">عملکرد شخصی</div></div></div>
        ${!hasAny ? `<div class="empty-state"><h3>${T.noStats}</h3><p>${T.noStatsDesc}</p></div>` :
        `<div class="profile-grid">
            <div class="profile-stat-card"><div class="lbl">${T.kills}</div><div class="val">${p.kills}</div></div>
            <div class="profile-stat-card danger"><div class="lbl">${T.deaths}</div><div class="val">${p.deaths}</div></div>
            <div class="profile-stat-card success"><div class="lbl">${T.kd}</div><div class="val">${p.deaths>0?(p.kills/p.deaths).toFixed(2):(p.kills||0).toFixed(2)}</div></div>
            <div class="profile-stat-card"><div class="lbl">${T.wins}</div><div class="val">${p.wins}</div></div>
            <div class="profile-stat-card"><div class="lbl">${T.games}</div><div class="val">${p.games}</div></div>
            <div class="profile-stat-card"><div class="lbl">${T.headshots}</div><div class="val">${p.headshots}</div></div>
        </div>`}
    `;
    renderProfileRail();
}

state.loadouts = state.loadouts || {slots: [], active: 0, max: 5};
state.editingLoadout = null;

function renderLoadouts() {
    const main = document.getElementById('main');
    if (!main) return;
    requestAction('requestLoadouts');
    if (!state.weapons || state.weapons.length === 0) requestAction('requestWeapons');
    if (!state.perks.perks) requestAction('requestPerks');
    paintLoadouts();
}

function paintLoadouts() {
    const main = document.getElementById('main');
    if (!main) return;
    const slots = state.loadouts.slots || [];
    const active = state.loadouts.active || 0;

    if (state.editingLoadout) {
        return paintLoadoutEditor();
    }

    main.innerHTML = `
        <div class="page-head">
            <div><h1>لود <span class="accent">آوت</span></h1>
                <div class="sub">پیش‌تنظیم پرک و اتچمنت‌ها برای آماده ورود به مچ</div></div>
            <div class="actions">
                <button class="btn" id="deactivateLoadout">غیرفعال‌سازی</button>
            </div>
        </div>
        <div class="section-heading" style="margin-top:0;"><span>اسلات‌های ذخیره شده</span></div>
        <div class="loadout-slots">
            ${slots.map((s, i) => {
                const idx = i + 1;
                const isActive = active === idx;
                const empty = s.empty;
                const perksCount = (s.perks || []).length;
                const wepsCount = Object.keys(s.attachments || {}).length;
                return `
                <div class="loadout-slot ${isActive?'active':''} ${empty?'empty':''}" data-slot="${idx}">
                    <div class="head">
                        <div class="name">${escape(s.name)}</div>
                        ${isActive ? `<span class="badge">فعال</span>` : ''}
                    </div>
                    <div class="stats">
                        <span>پرک‌ها: <span class="eng">${perksCount}</span></span>
                        <span>اسلحه: <span class="eng">${wepsCount}</span></span>
                    </div>
                    <div class="actions">
                        ${empty ? `<button class="btn primary" data-edit="${idx}">ساخت</button>` :
                        `<button class="btn ${isActive?'success':'gold'} sm" data-activate="${idx}">${isActive?'فعال':'فعال‌سازی'}</button>
                         <button class="btn sm" data-edit="${idx}">ویرایش</button>
                         <button class="btn danger sm" data-delete="${idx}">حذف</button>`}
                    </div>
                </div>
                `;
            }).join('')}
        </div>
    `;

    main.querySelectorAll('[data-edit]').forEach(b => b.addEventListener('click', () => {
        const slot = parseInt(b.dataset.edit);
        const data = slots[slot - 1] || {};
        let att = {};
        if (data.attachments && typeof data.attachments === 'object' && !Array.isArray(data.attachments)) {
            att = JSON.parse(JSON.stringify(data.attachments));
        }
        state.editingLoadout = {
            slot: slot,
            name: data.empty ? ('لودآوت ' + slot) : data.name,
            perks: (data.perks || []).slice(),
            attachments: att,
        };
        paintLoadoutEditor();
    }));
    let _loadoutActionLocked = false;
    const lockLoadoutActions = () => {
        if (_loadoutActionLocked) return false;
        _loadoutActionLocked = true;
        main.querySelectorAll('[data-activate], [data-delete], #deactivateLoadout').forEach(el => {
            el.classList.add('disabled');
            el.setAttribute('disabled', 'true');
            el.style.pointerEvents = 'none';
            el.style.opacity = '0.5';
        });
        setTimeout(() => {
            _loadoutActionLocked = false;
            requestAction('requestLoadouts');
        }, 1800);
        return true;
    };
    main.querySelectorAll('[data-activate]').forEach(b => b.addEventListener('click', () => {
        if (state.loadouts.active === parseInt(b.dataset.activate)) return;
        if (!lockLoadoutActions()) return;
        const slot = parseInt(b.dataset.activate);
        requestAction('loadoutSetActive', {slot: slot});
    }));
    main.querySelectorAll('[data-delete]').forEach(b => b.addEventListener('click', () => {
        if (!lockLoadoutActions()) return;
        const slot = parseInt(b.dataset.delete);
        requestAction('loadoutDelete', {slot: slot});
    }));
    const da = document.getElementById('deactivateLoadout');
    if (da) da.addEventListener('click', () => {
        if ((state.loadouts.active || 0) === 0) return;
        if (!lockLoadoutActions()) return;
        requestAction('loadoutSetActive', {slot: 0});
    });
}

function paintLoadoutEditor() {
    const main = document.getElementById('main');
    if (!main) return;
    const e = state.editingLoadout;
    if (!e) { paintLoadouts(); return; }
    const perks = (state.perks && state.perks.perks) || [];
    const cap = (state.perks && state.perks.perksPerPlayer) || 3;
    const weapons = state.weapons || [];
    e.selectedWeapon = e.selectedWeapon || (weapons[0] && weapons[0].model);
    const selectedW = weapons.find(w => w.model === e.selectedWeapon) || weapons[0];
    const currentAtt = selectedW ? (e.attachments[selectedW.model] || {}) : {};
    const ws = (selectedW && selectedW.stats) || {damage: 50, firerate: 50, range: 50, mobility: 50, accuracy: 50, magazine: 30};
    const classIcons = {pistol: '🔫', smg: '🔫', shotgun: '💥', rifle: '🪖', sniper: '🎯', mg: '🪖', heavy: '🚀', melee: '🗡'};
    const classLabels = {pistol: 'پیستول', smg: 'اس‌ام‌جی', shotgun: 'شاتگان', rifle: 'رایفل', sniper: 'اسنایپر', mg: 'مسلسل', heavy: 'سنگین', melee: 'مله'};
    const descMap = {
        pistol: 'پیستول کوچک با موبیلیتی بالا و دمیج متوسط. برای نبرد نزدیک عالیه.',
        smg: 'مسلسل کوچک با fire rate بالا و دقت متوسط. ایده‌آل برای فاصله نزدیک تا متوسط.',
        shotgun: 'شاتگان با دمیج بالا در فاصله نزدیک ولی range محدود.',
        rifle: 'تفنگ تهاجمی با تعادل بین دمیج، دقت و range. مناسب برای اکثر موقعیت‌ها.',
        sniper: 'اسنایپر با دمیج کشنده و range بسیار بالا ولی fire rate پایین.',
        mg: 'مسلسل سنگین با خشاب بزرگ و آتش مداوم ولی موبیلیتی پایین.',
        heavy: 'سلاح سنگین با دمیج انفجاری بسیار بالا. برای موقعیت‌های خاص.',
    };

    const groupedByClass = {};
    weapons.forEach(w => {
        const c = w.class || 'rifle';
        groupedByClass[c] = groupedByClass[c] || [];
        groupedByClass[c].push(w);
    });
    const classOrder = ['pistol', 'smg', 'shotgun', 'rifle', 'sniper', 'mg', 'heavy'];

    main.innerHTML = `
        <div class="page-head">
            <div><h1>ویرایش <span class="accent">لودآوت ${e.slot}</span></h1>
                <div class="sub">پرک‌ها و اتچمنت‌های دلخواهت رو انتخاب کن</div></div>
            <div class="actions">
                <button class="btn" id="cancelEdit">انصراف</button>
                <button class="btn primary" id="saveLoadout">ذخیره</button>
            </div>
        </div>

        <div class="form-grid full" style="margin-bottom:18px;">
            <div class="field"><label>نام لودآوت</label><input id="loName" value="${escape(e.name||'')}" maxlength="24" /></div>
        </div>

        <div class="section-heading" style="margin-top:0;"><span>پرک‌ها <span class="eng">(${e.perks.length}/${cap})</span></span></div>
        <div class="perk-grid" id="loPerks" style="margin-bottom:22px;">
            ${perks.map(p => `<div class="perk-card ${e.perks.includes(p.key)?'selected':''} ${p.comingSoon?'coming-soon':''}" data-perk="${p.key}" ${p.comingSoon?'data-soon="1"':''}>
                <div class="perk-card-ic">${pbIconImg(PB_PERK_ICONS[p.key], '★', 'pcard-ic')}</div>
                <div class="perk-card-txt">
                    <h5>${escape(p.label)}${p.comingSoon?' <span class="soon-tag">به‌زودی</span>':''}</h5>
                    <p>${escape(p.description||'')}</p>
                </div>
            </div>`).join('')}
        </div>

        <div class="section-heading" style="margin-top:0;"><span>اسلحه و اتچمنت</span></div>
        ${selectedW ? `
        <div class="loadout-shell">
            <div class="loadout-side">
                <div class="category-head">انتخاب اسلحه</div>
                <div class="weapon-list">
                    ${classOrder.filter(c => groupedByClass[c]).map(cls => `
                        <div class="weapon-class-head"><span>${classIcons[cls] || '•'}</span> <span>${escape(classLabels[cls] || cls)}</span></div>
                        ${groupedByClass[cls].map(w => `
                            <div class="weapon-row ${w.model===e.selectedWeapon?'active':''}" data-wsel="${w.model}">
                                <div class="icon-box ${cls}"><img src="imgs/weapons/${escape(w.key||'')}.png" onerror="this.style.display='none';this.parentNode.innerHTML='${classIcons[cls] || '•'}';" /></div>
                                <div class="name">${escape(w.label)}</div>
                            </div>
                        `).join('')}
                    `).join('')}
                </div>
            </div>

            <div class="loadout-main">
                <div class="weapon-title">
                    <h2>${escape(selectedW.label)}</h2>
                </div>
                <div class="weapon-preview" style="min-height:220px;">
                    <img class="weapon-render" src="imgs/weapons/${escape(selectedW.key||'')}.png" alt="${escape(selectedW.label)}" onerror="this.style.display='none';" />
                </div>
                <div class="weapon-stats-cod">
                    <div class="cod-stat"><div class="cod-label eng">DAMAGE</div><div class="cod-bar"><div class="cod-fill" style="width:${ws.damage}%"></div></div></div>
                    <div class="cod-stat"><div class="cod-label eng">FIRE RATE</div><div class="cod-bar"><div class="cod-fill" style="width:${ws.firerate}%"></div></div></div>
                    <div class="cod-stat"><div class="cod-label eng">RANGE</div><div class="cod-bar"><div class="cod-fill" style="width:${ws.range}%"></div></div></div>
                    <div class="cod-stat"><div class="cod-label eng">MOBILITY</div><div class="cod-bar"><div class="cod-fill" style="width:${ws.mobility}%"></div></div></div>
                    <div class="cod-stat"><div class="cod-label eng">ACCURACY</div><div class="cod-bar"><div class="cod-fill" style="width:${ws.accuracy||50}%"></div></div></div>
                    <div class="cod-stat"><div class="cod-label eng">MAGAZINE</div><div class="cod-bar"><div class="cod-fill" style="width:${Math.min(100,(ws.magazine||30)*2)}%"></div></div></div>
                </div>
                <div class="weapon-desc-box">${escape(descMap[selectedW.class] || 'یکی از تیربرهای قابل استفاده در پینت‌بال.')}</div>
            </div>

            <div class="loadout-right">
                ${paintWeaponAttSection(selectedW, currentAtt)}
            </div>
        </div>
        ` : `<div class="empty-state"><h3>اسلحه‌ای موجود نیست</h3></div>`}
    `;

    document.getElementById('cancelEdit').addEventListener('click', () => {
        state.editingLoadout = null;
        paintLoadouts();
    });
    document.getElementById('saveLoadout').addEventListener('click', () => {
        e.name = (document.getElementById('loName').value || ('Loadout ' + e.slot)).slice(0, 24);
        console.log('[PB-DEBUG][ui] saveLoadout clicked. slot=', e.slot, 'attachments=', JSON.stringify(e.attachments));
        requestAction('loadoutSave', {
            slot: e.slot,
            name: e.name,
            perks: e.perks,
            attachments: e.attachments,
        });
        state.editingLoadout = null;
        setTimeout(() => requestAction('requestLoadouts'), 200);
        showToast('لودآوت ' + e.slot + ' ذخیره شد');
    });

    main.querySelectorAll('[data-perk]').forEach(p => p.addEventListener('click', () => {
        if (p.dataset.soon === '1') { showToast('این پرک به‌زودی فعال میشه'); return; }
        const k = p.dataset.perk;
        const idx = e.perks.indexOf(k);
        if (idx >= 0) e.perks.splice(idx, 1);
        else if (e.perks.length < cap) e.perks.push(k);
        paintLoadoutEditor();
    }));
    main.querySelectorAll('[data-wsel]').forEach(w => w.addEventListener('click', () => {
        e.selectedWeapon = w.dataset.wsel;
        const _ls = main.querySelector('.loadout-side');
        const _lsc = _ls ? _ls.scrollTop : 0;
        const _ma = document.querySelector('.main-area');
        const _mac = _ma ? _ma.scrollTop : 0;
        paintLoadoutEditor();
        const _ls2 = main.querySelector('.loadout-side');
        if (_ls2) _ls2.scrollTop = _lsc;
        const _ma2 = document.querySelector('.main-area');
        if (_ma2) _ma2.scrollTop = _mac;
    }));
    function ensureGroupsArray(wm) {
        if (Array.isArray(e.attachments) || typeof e.attachments !== 'object' || e.attachments === null) {
            e.attachments = {};
        }
        if (!e.attachments[wm] || typeof e.attachments[wm] !== 'object' || Array.isArray(e.attachments[wm])) {
            e.attachments[wm] = {groups: []};
        }
        if (!Array.isArray(e.attachments[wm].groups)) {
            const oldGroups = [];
            const old = e.attachments[wm];
            ['silencer','grip','scope','flashlight'].forEach(g => { if (old[g]) oldGroups.push(g); });
            const tint = old.tint;
            e.attachments[wm] = {groups: oldGroups};
            if (tint !== undefined) e.attachments[wm].tint = (typeof tint === 'number') ? tint : (tint && tint.hash);
        }
    }
    main.querySelectorAll('[data-att]').forEach(b => b.addEventListener('click', () => {
        const wm = b.dataset.weapon;
        const grp = b.dataset.att;
        ensureGroupsArray(wm);
        const arr = e.attachments[wm].groups;
        const idx = arr.indexOf(grp);
        if (idx >= 0) arr.splice(idx, 1);
        else arr.push(grp);
        console.log('[PB-DEBUG][ui] att toggled. weapon=', wm, 'group=', grp, 'state[wm]=', JSON.stringify(e.attachments[wm]));
        paintLoadoutEditor();
    }));
    main.querySelectorAll('[data-tint]').forEach(b => b.addEventListener('click', () => {
        const wm = b.dataset.weapon;
        const idx = parseInt(b.dataset.tint);
        ensureGroupsArray(wm);
        const cur = e.attachments[wm].tint;
        if (cur === idx) {
            delete e.attachments[wm].tint;
        } else {
            e.attachments[wm].tint = idx;
        }
        paintLoadoutEditor();
    }));
}

function paintWeaponAttSection(w, current) {
    const allGroups = ['silencer', 'grip', 'scope', 'flashlight'];
    const groups = (w.attachments || []).filter(g => allGroups.indexOf(g) >= 0);
    const groupLabels = {silencer: 'سایلنسر', grip: 'گریپ', scope: 'اسکوپ', flashlight: 'چراغ'};
    function isGroupOn(c, g) {
        if (Array.isArray(c.groups)) return c.groups.indexOf(g) >= 0;
        return !!c[g];
    }
    function isTintActive(c, idx) {
        if (typeof c.tint === 'number') return c.tint === idx;
        if (typeof c.tint === 'object' && c.tint && c.tint.hash !== undefined) return c.tint.hash === idx;
        return false;
    }
    return `
    <div class="att-section">
        <h4 class="eng">ATTACHMENTS</h4>
        <div class="att-pills">
            ${groups.length ? groups.map(g => {
                const on = isGroupOn(current, g);
                return `<div class="att-pill ${on?'on':''}" data-weapon="${w.model}" data-att="${g}"><span>${groupLabels[g]}</span><div class="check"></div></div>`;
            }).join('') : '<div class="att-none">این اسلحه اتچمنت نداره</div>'}
        </div>
    </div>
    <div class="att-section">
        <h4 class="eng">TINT</h4>
        <div class="tint-row">
            ${tintIndices(w.model).map(i => `<div class="tint-chip ${isTintActive(current, i)?'active':''}" data-weapon="${w.model}" data-tint="${i}" style="background:${tintSwatch(w.model, i)}" title="${tintLabel(w.model, i)}"></div>`).join('')}
        </div>
    </div>`;
}

function renderCosmetics() {
    const main = document.getElementById('main');
    if (!main) return;
    requestAction('requestCosmetics');
    paintCosmetics();
}
function paintCosmetics() {
    const main = document.getElementById('main');
    if (!main) return;
    const data = state.cosmeticsData || {cosmetics: {}, catalog: {}};
    const cur = data.cosmetics || {};
    const cat = data.catalog || {};
    const sections = [
        {key: 'callingCard', catalogKey: 'callingCards', title: 'کارت'},
        {key: 'emblem', catalogKey: 'emblems', title: 'نشان'},
        {key: 'killBanner', catalogKey: 'killBanners', title: 'بنر کیل'},
        {key: 'weaponSkin', catalogKey: 'weaponSkins', title: 'اسکین اسلحه'},
    ];
    main.innerHTML = `
        <div class="page-header"><div><h1 class="page-title">کاسمتیک <span class="accent">شخصی</span></h1>
        <p class="page-sub">ظاهر خودت رو شخصی‌سازی کن</p></div></div>
        ${sections.map(s => `
            <h3 class="section-title">${s.title}</h3>
            <div class="cosmetic-grid">
                ${((cat[s.catalogKey])||[]).map(it => {
                    const sel = cur[s.key] === it.key;
                    let preview;
                    if (s.key === 'callingCard') preview = `<div class="preview" style="background:${it.color||'#7c3aed'}; color:white; font-size: 12px; font-weight:700;">CARD</div>`;
                    else if (s.key === 'emblem') preview = `<div class="preview" style="background:rgba(168,85,247,0.1); color:var(--purple-glow);">${escape(it.icon||'◆')}</div>`;
                    else if (s.key === 'killBanner') preview = `<div class="preview" style="background:rgba(255,200,80,0.1); color:var(--gold); font-size:12px; font-weight:800;">KILL</div>`;
                    else preview = `<div class="preview" style="background:${['#222','#888','#c00','#0a0','#fc0','#888','#06f','#bbb'][it.tint||0]||'#333'};"></div>`;
                    return `<div class="cosmetic-tile ${sel?'selected':''}" data-cosmetic="${s.key}" data-key="${escape(it.key)}">
                        ${preview}
                        ${escape(it.label||it.key)}
                    </div>`;
                }).join('')}
            </div>
        `).join('')}
    `;
    main.querySelectorAll('[data-cosmetic]').forEach(t => t.addEventListener('click', () => {
        const cat = t.dataset.cosmetic;
        const key = t.dataset.key;
        requestAction('setCosmetic', {category: cat, key: key});
        if (!state.cosmeticsData) state.cosmeticsData = {cosmetics:{}, catalog:{}};
        state.cosmeticsData.cosmetics[cat] = key;
        paintCosmetics();
    }));
}

function renderHistory() {
    const main = document.getElementById('main');
    if (!main) return;
    requestAction('requestMatchHistory');
    paintHistory();
}
function paintHistory() {
    const main = document.getElementById('main');
    if (!main) return;
    const hist = (state.matchHistoryData && state.matchHistoryData.history) || [];
    const enabled = state.matchHistoryData && state.matchHistoryData.enabled !== false;
    if (!enabled) { main.innerHTML = `<div class="empty-state"><h3>تاریخچه غیرفعال</h3></div>`; return; }
    main.innerHTML = `
        <div class="page-head"><div><h1>تاریخچه <span class="accent">مچ</span></h1>
        <div class="sub"><span class="eng">${hist.length}</span> مچ ذخیره شده</div></div></div>
        ${hist.length === 0 ? `<div class="empty-state"><h3>هنوز مچی بازی نکردی</h3><p>یک مچ بازی کن</p></div>` :
        `<div class="stats-table"><table>
            <thead><tr><th>نتیجه</th><th>${T.mode}</th><th>${T.map}</th><th>${T.kills}</th><th>${T.deaths}</th><th>${T.kd}</th><th>امتیاز</th><th>زمان</th></tr></thead>
            <tbody>${hist.map(h => {
                const win = h.win;
                const kd = h.deaths > 0 ? (h.kills / h.deaths).toFixed(2) : (h.kills || 0).toFixed(2);
                const date = h.timestamp ? new Date(h.timestamp * 1000).toLocaleString('fa-IR') : '-';
                return `<tr class="${win?'win':'loss'} ${h.mvp?'mvp':''}">
                    <td>${win ? '✓ برد' : '✗ باخت'}${h.mvp ? ' · MVP' : ''}</td>
                    <td>${escape(h.mode||'-')}</td>
                    <td>${escape(h.map||'-')}</td>
                    <td class="eng">${h.kills||0}</td>
                    <td class="eng">${h.deaths||0}</td>
                    <td class="ratio eng">${kd}</td>
                    <td class="eng">${h.score||0}</td>
                    <td class="eng">${date}</td>
                </tr>`;
            }).join('')}</tbody>
        </table></div>`}
    `;
}

function renderAchievements() {
    const main = document.getElementById('main');
    if (!main) return;
    if (!state.achievementsData) requestAction('requestAchievements');
    paintAchievements();
}

function paintAchievements() {
    const main = document.getElementById('main');
    if (!main) return;
    const data = state.achievementsData;
    if (!data || !data.enabled) {
        main.innerHTML = `<div class="empty-state"><h3>سیستم دستاورد غیرفعال</h3><p>توسط ادمین فعال خواهد شد</p></div>`;
        return;
    }
    const list = data.list || [];
    const categories = data.categories || [];
    const tierColors = data.tierColors || {};
    const tierLabels = data.tierLabels || {};
    const tierXP = data.tierXP || {};

    state.achFilter = state.achFilter || {category: 'all', tier: 'all', status: 'all'};
    const filter = state.achFilter;
    const filtered = list.filter(a => {
        if (filter.category !== 'all' && a.category !== filter.category) return false;
        if (filter.tier !== 'all' && a.tier !== filter.tier) return false;
        if (filter.status === 'unlocked' && !a.unlocked) return false;
        if (filter.status === 'locked' && a.unlocked) return false;
        return true;
    });

    const totalUnlocked = list.filter(a => a.unlocked).length;
    const totalCount = list.length;
    const completion = totalCount > 0 ? Math.floor((totalUnlocked / totalCount) * 100) : 0;
    let totalXP = 0;
    list.forEach(a => { if (a.unlocked) totalXP += (tierXP[a.tier] || 50); });

    const tiers = ['bronze', 'silver', 'gold', 'platinum'];
    const tierCounts = {};
    tiers.forEach(t => {
        tierCounts[t] = {total: 0, unlocked: 0};
    });
    list.forEach(a => {
        if (tierCounts[a.tier]) {
            tierCounts[a.tier].total++;
            if (a.unlocked) tierCounts[a.tier].unlocked++;
        }
    });

    main.innerHTML = `
        <div class="page-head">
            <div><h1>دستا<span class="accent">وردها</span></h1>
                <div class="ach-summary-stats">
                    <div class="ach-stat-chip"><span class="value eng">${totalUnlocked}/${totalCount}</span><span class="label">دستاورد</span></div>
                    <div class="ach-stat-chip"><span class="value eng">${completion}%</span><span class="label">تکمیل</span></div>
                    <div class="ach-stat-chip"><span class="value eng">${totalXP} XP</span><span class="label">امتیاز</span></div>
                </div>
            </div>
        </div>

        <div class="ach-progress-bar">
            <div class="ach-progress-fill" style="width:${completion}%"></div>
        </div>

        <div class="ach-tier-summary">
            ${tiers.map(t => `
                <div class="ach-tier-card" style="border-color:${tierColors[t] || '#fbbf24'}">
                    <div class="tier-icon" style="color:${tierColors[t] || '#fbbf24'}">●</div>
                    <div class="tier-info">
                        <div class="tier-label">${escape(tierLabels[t] || t)}</div>
                        <div class="tier-count eng">${tierCounts[t].unlocked}/${tierCounts[t].total}</div>
                    </div>
                </div>
            `).join('')}
        </div>

        <div class="ach-filters">
            <div class="ach-filter-group">
                <div class="ach-filter-label">دسته</div>
                <div class="tabs-bar">
                    <div class="tab-btn ${filter.category==='all'?'active':''}" data-cat="all"><span class="tab-label">همه</span></div>
                    ${categories.map(c => `<div class="tab-btn with-icon ${filter.category===c.key?'active':''}" data-cat="${c.key}"><span class="tab-icon">${c.icon}</span><span class="tab-label">${escape(c.label)}</span></div>`).join('')}
                </div>
            </div>
            <div class="ach-filter-group">
                <div class="ach-filter-label">رتبه</div>
                <div class="tabs-bar">
                    <div class="tab-btn ${filter.tier==='all'?'active':''}" data-tier="all"><span class="tab-label">همه</span></div>
                    ${tiers.map(t => `<div class="tab-btn ${filter.tier===t?'active':''}" data-tier="${t}" style="${filter.tier===t?`color:${tierColors[t]};border-color:${tierColors[t]};`:''}"><span class="tab-label">${escape(tierLabels[t]||t)}</span></div>`).join('')}
                </div>
            </div>
            <div class="ach-filter-group">
                <div class="ach-filter-label">وضعیت</div>
                <div class="tabs-bar">
                    <div class="tab-btn ${filter.status==='all'?'active':''}" data-status="all"><span class="tab-label">همه</span></div>
                    <div class="tab-btn ${filter.status==='unlocked'?'active':''}" data-status="unlocked"><span class="tab-label">فتح شده</span></div>
                    <div class="tab-btn ${filter.status==='locked'?'active':''}" data-status="locked"><span class="tab-label">قفل</span></div>
                </div>
            </div>
        </div>

        <div class="ach-sections">
            ${(() => {
                if (filtered.length === 0) {
                    return `<div class="empty-state"><h3>هیچ دستاوردی پیدا نشد</h3><p>فیلتر رو تغییر بده</p></div>`;
                }
                const renderCard = (a) => {
                    const tierColor = tierColors[a.tier] || '#fbbf24';
                    const xp = tierXP[a.tier] || 50;
                    let progressHtml = '';
                    if (!a.unlocked && a.progress !== null && a.progress !== undefined && a.target) {
                        const pct = Math.min(100, (a.progress / a.target) * 100);
                        progressHtml = `<div class="ach-progress">
                            <div class="ach-progress-track"><div class="ach-progress-fill-row" style="width:${pct}%;background:${tierColor}"></div></div>
                            <div class="ach-progress-text eng">${a.progress}/${a.target}</div>
                        </div>`;
                    }
                    return `
                    <div class="ach-item ${a.unlocked?'unlocked':'locked'}" style="--tier-color:${tierColor};">
                        <div class="ach-icon-frame">
                            <div class="ach-icon-bg"></div>
                            <div class="ach-icon">${a.icon || '🏆'}</div>
                            <div class="ach-tier-badge eng">${escape(tierLabels[a.tier]||a.tier)}</div>
                        </div>
                        <div class="ach-label">${escape(a.label)}</div>
                        <div class="ach-desc">${escape(a.description||'')}</div>
                        ${progressHtml}
                        <div class="ach-meta">
                            <span class="ach-xp eng">+${xp} XP</span>
                            ${a.unlocked ? `<span class="ach-date">${a.unlockedAt ? new Date(a.unlockedAt*1000).toLocaleDateString('fa-IR') : ''}</span>` : `<span class="ach-locked">قفل</span>`}
                        </div>
                    </div>`;
                };
                if (filter.tier !== 'all') {
                    return `<div class="ach-list">${filtered.map(renderCard).join('')}</div>`;
                }
                const grouped = {};
                tiers.forEach(t => { grouped[t] = []; });
                filtered.forEach(a => {
                    if (grouped[a.tier]) grouped[a.tier].push(a);
                });
                return tiers.map(t => {
                    if (grouped[t].length === 0) return '';
                    const tcolor = tierColors[t] || '#fbbf24';
                    const tlabel = tierLabels[t] || t;
                    return `
                    <div class="ach-tier-section" style="--tier-color:${tcolor};">
                        <div class="ach-section-head">
                            <span class="ach-section-dot"></span>
                            <span class="ach-section-title">${escape(tlabel)}</span>
                            <span class="ach-section-count eng">${grouped[t].filter(x => x.unlocked).length}/${grouped[t].length}</span>
                            <span class="ach-section-rule"></span>
                        </div>
                        <div class="ach-list">${grouped[t].map(renderCard).join('')}</div>
                    </div>`;
                }).join('');
            })()}
        </div>
    `;

    main.querySelectorAll('[data-cat]').forEach(b => b.addEventListener('click', () => {
        state.achFilter.category = b.dataset.cat;
        paintAchievements();
    }));
    main.querySelectorAll('[data-tier]').forEach(b => b.addEventListener('click', () => {
        state.achFilter.tier = b.dataset.tier;
        paintAchievements();
    }));
    main.querySelectorAll('[data-status]').forEach(b => b.addEventListener('click', () => {
        state.achFilter.status = b.dataset.status;
        paintAchievements();
    }));
}

function refreshPlayAchievements() {
    const grid = document.querySelector('.ach-grid');
    if (!grid) return;
    const data = state.achievementsData;
    if (!data || !data.list) return;
    const cap = 8;
    const sorted = data.list.slice().sort((a, b) => {
        if (a.unlocked && !b.unlocked) return -1;
        if (!a.unlocked && b.unlocked) return 1;
        return 0;
    }).slice(0, cap);
    const tierColors = data.tierColors || {};
    grid.innerHTML = sorted.map(a => {
        const tierColor = tierColors[a.tier] || '#fbbf24';
        return `<div class="ach-badge ${a.unlocked?'gold':''}" style="${a.unlocked?`color:${tierColor};border-color:${tierColor};`:''}" title="${escape(a.label)}">
            ${a.icon || '🏆'}<div class="label">${escape(a.label)}</div>
        </div>`;
    }).join('');
}

function showRoleBanner(data) {
    if (!data || !data.title) return;
    let el = document.getElementById('roleBanner');
    if (el) el.remove();
    const color = data.color || 'success';
    const icon = data.icon || roleIconFromColor(color);
    const duration = (data.duration && typeof data.duration === 'number') ? data.duration : 9000;
    el = document.createElement('div');
    el.id = 'roleBanner';
    el.className = 'role-banner ' + color;
    el.innerHTML = `
        <div class="role-glow"></div>
        <div class="role-frame">
            <div class="role-icon">${icon}</div>
            <div class="role-label eng">YOUR ROLE</div>
            <div class="role-title">${escape(data.title)}</div>
            <div class="role-divider"></div>
            <div class="role-sub">${escape(data.sub || '')}</div>
        </div>
    `;
    document.body.appendChild(el);
    requestAnimationFrame(() => el.classList.add('show'));
    setTimeout(() => {
        if (!el || !el.parentNode) return;
        el.classList.add('exit');
        el.classList.remove('show');
        setTimeout(() => { if (el && el.parentNode) el.remove(); }, 800);
    }, duration);
}

function roleIconFromColor(c) {
    if (c === 'error') return '⚔';
    if (c === 'warning') return '◆';
    if (c === 'info') return '◇';
    return '◈';
}

let achToastTimer = null;
function showAchievementUnlock(ach) {
    let el = document.getElementById('achToast');
    if (el) el.remove();
    el = document.createElement('div');
    el.id = 'achToast';
    el.className = 'ach-toast';
    const tierColors = (state.achievementsData && state.achievementsData.tierColors) || {};
    const tierColor = tierColors[ach.tier] || '#fbbf24';
    el.innerHTML = `
        <div class="ach-toast-icon" style="background:${tierColor}30;color:${tierColor};border-color:${tierColor}">${ach.icon || '🏆'}</div>
        <div class="ach-toast-body">
            <div class="ach-toast-head eng">ACHIEVEMENT UNLOCKED</div>
            <div class="ach-toast-label">${escape(ach.label)}</div>
            <div class="ach-toast-desc">${escape(ach.description||'')}</div>
            <div class="ach-toast-xp eng">+${ach.xp||50} XP</div>
        </div>
    `;
    document.body.appendChild(el);
    requestAnimationFrame(() => el.classList.add('show'));
    if (achToastTimer) clearTimeout(achToastTimer);
    achToastTimer = setTimeout(() => {
        el.classList.remove('show');
        setTimeout(() => { if (el) el.remove(); }, 600);
    }, 5500);
}

function renderPractice() {
    const main = document.getElementById('main');
    main.innerHTML = `
        <div class="page-header"><div><h1 class="page-title">${T.pagePracticeTitle} <span class="accent">${T.pagePracticeAccent}</span></h1>
        <p class="page-sub">حالت تمرین انفرادی</p></div></div>
        <div class="empty-state"><h3>${T.soon}</h3><p>${T.soonDesc}</p></div>
    `;
}
function renderAimTrainer() {
    const main = document.getElementById('main');
    main.innerHTML = `
        <div class="page-header"><div><h1 class="page-title">${T.pageAimTitle} <span class="accent">${T.pageAimAccent}</span></h1></div></div>
        <div class="empty-state"><h3>${T.soon}</h3><p>${T.soonDesc}</p></div>
    `;
}

function renderMapVote() {
    if (!state.mapVoteOptions || !state.mapVoteOptions.enabled) return;
    showToast(`رای‌گیری مپ شروع شد: ${state.mapVoteOptions.options.length} گزینه`);
}

function renderReadyCheckRequest(d) {
    const div = document.createElement('div');
    div.className = 'passwd-prompt';
    div.innerHTML = `
        <div class="passwd-box">
            <h3>${T.readyCheckTitle}</h3>
            <p style="margin-bottom: 12px; color: var(--grey);">${T.readyCheckPrompt} (${d.timeout}s)</p>
            <div class="actions">
                <button class="btn success" id="rcYes">${T.yes}</button>
                <button class="btn danger" id="rcNo">${T.no}</button>
            </div>
        </div>
    `;
    document.body.appendChild(div);
    document.getElementById('rcYes').addEventListener('click', () => {
        requestAction('answerReadyCheck', {answer: true});
        document.body.removeChild(div);
    });
    document.getElementById('rcNo').addEventListener('click', () => {
        requestAction('answerReadyCheck', {answer: false});
        document.body.removeChild(div);
    });
}

function renderReadyCheckUpdate(d) {
    const ans = d.answers || {};
    const yes = Object.values(ans).filter(v => v).length;
    const total = d.total || Object.keys(ans).length;
    showToast(`${T.readyCheckTitle}: ${yes}/${total}`);
}

function renderMatchCountdown(d) {
    const old = document.getElementById('matchCountdownOverlay');
    if (old) old.remove();
    const overlay = document.createElement('div');
    overlay.id = 'matchCountdownOverlay';
    overlay.className = 'match-countdown';
    overlay.innerHTML = `
        <div class="mc-backdrop"></div>
        <div class="mc-content">
            <div class="mc-label eng">MATCH STARTING IN</div>
            <div class="mc-number eng" id="mcNumber">${d.seconds || 5}</div>
            <div class="mc-mode">${escape(d.modeLabel || '')}</div>
            <div class="mc-progress"><div class="mc-progress-fill" id="mcProgressFill"></div></div>
        </div>
    `;
    document.body.appendChild(overlay);
    requestAnimationFrame(() => overlay.classList.add('show'));
    const total = Math.max(1, d.seconds || 5);
    const fill = document.getElementById('mcProgressFill');
    if (fill) {
        fill.style.transition = `width ${total}s linear`;
        requestAnimationFrame(() => { fill.style.width = '100%'; });
    }
}

function updateMatchCountdown(remaining) {
    const num = document.getElementById('mcNumber');
    if (!num) return;
    num.textContent = remaining;
    num.classList.remove('pulse');
    void num.offsetWidth;
    num.classList.add('pulse');
    if (remaining <= 3) {
        num.classList.add('urgent');
    }
}

function flashMatchCountdownGo() {
    const overlay = document.getElementById('matchCountdownOverlay');
    if (!overlay) return;
    const num = document.getElementById('mcNumber');
    if (num) {
        num.textContent = 'GO!';
        num.classList.add('go');
    }
    setTimeout(() => {
        overlay.classList.add('hide');
        setTimeout(() => overlay.remove(), 500);
    }, 700);
}

function handleHudUpdate(t, data) {
    if (t === 'roundUpdate') { Object.assign(state.hud, data); renderHUD(); }
    else if (t === 'timer') { state.hud.seconds = data.seconds; renderTime(); }
    else if (t === 'teamCounts') {
        if (data && data.counts) {
            state.hud.teamCounts = data.counts;
            if (data.startSize) state.hud.teamStartSize = data.startSize;
            state.hud.teamKills = data.kills || {};
        } else {
            state.hud.teamCounts = data;
        }
        renderTeamCounts();
    }
    else if (t === 'killFeed') { pushKillFeed(data); }
    else if (t === 'spawnProtection') { state.hud.spawnProtectSeconds = data.seconds; renderSpawnShield(); }
    else if (t === 'multikill') { showMultikill(data); }
    else if (t === 'killstreak') { showKillstreak(data); }
    else if (t === 'killstreakUpdate') {  }
    else if (t === 'hitmarker') { flashHitmarker(data && data.kill); }
    else if (t === 'matchEnd') { showMatchEnd(data); }
    else if (t === 'weaponSwap') { state.hud.weapon = data.weapon; renderWeaponCard(); }
    else if (t === 'bombPromptPlant') { state.hud.bombPrompt = data; renderBombPrompt(); }
    else if (t === 'bombPromptDefuse') { state.hud.bombDefuse = data; renderBombPrompt(); }
    else if (t === 'bombCarrier') { showToast('shoma carrier hastid'); }
    else if (t === 'domState') { state.hud.domState = data; renderObjectives(); }
    else if (t === 'domCapturing') { state.hud.domCapturing = data; renderDomCapture(); }
    else if (t === 'domTick') { state.hud.score = data; renderTeamCounts(); }
    else if (t === 'kothTick') { state.hud.score = data.score; state.hud.kothHolder = data.holder; renderObjectives(); }
    else if (t === 'kothInside') { state.hud.kothInside = data.inside; renderObjectives(); }
    else if (t === 'coopWave') { state.hud.coopWave = data.wave; state.hud.coopWaveData = data; renderCoop(); }
    else if (t === 'coopWaveEnd') { renderCoop(); }
    else if (t === 'coopState') { state.hud.coopMoney = data.money; state.hud.coopWave = data.wave; state.hud.coopState = data; renderCoop(); }
    else if (t === 'coopShopNearby') { state.hud.coopShop = data; renderCoopShop(); }
    else if (t === 'scoreboard') { state.hud.scoreboard = data; }
    else if (t === 'gungameLevels') { state.hud.gungameLevels = data; }
    else if (t === 'perkApply') { showPerkProgress(data); }
    else if (t === 'assistGranted') { showToast('Assist!'); }
    else if (t === 'showScoreboard') { toggleScoreboard(data); }
    else if (t === 'killstreakBanner') { showKillstreakBanner(data); }
    else if (t === 'perkHud') { renderPerkHud(data); }
    else if (t === 'spectateInfo') { renderSpectateInfo(data); }
    else if (t === 'perkActivate') { animatePerkSlot(data); }
    else if (t === 'killstreakProgress') { showKillstreakTracker(data); }
    else if (t === 'preMatchTour') {
        if (data && data.active) showMapTour(data); else hideMapTour();
    }
    else if (t === 'matchOutro') {
        if (data && data.active) showMatchOutro(data); else hideMatchOutro();
    }
    else if (t === 'predatorHud') {
        if (data && data.active) showPredatorHud(data); else hidePredatorHud();
    }
    else if (t === 'nukeWarning') { startNukeOverlay(data); }
    else if (t === 'nukeTick') { updateNukeOverlay(data); }
    else if (t === 'nukeBoom') { stopNukeOverlay(); }
    else if (t === 'achievementUnlock') { showAchievementUnlock(data); }
    else if (t === 'roleBanner') { showRoleBanner(data); }
    else if (t === 'hardcore') {
        if (data && data.enabled) {
            hudRoot.classList.add('hardcore');
        } else {
            hudRoot.classList.remove('hardcore');
        }
    }
    else if (t === 'spawnUpdate') {
        if (data.mode) state.hud.mode = data.mode;
        if (data.team !== undefined) state.hud.team = data.team;
        if (data.weapon) state.hud.weapon = data.weapon;
        renderTime();
        renderWeaponCard();
    }
}

function renderHUD() {
    hudRoot.classList.add('show');
    hudRoot.innerHTML = `
        <div class="hud-shell">
            <div class="hud-top" id="hudTop"></div>
            <div class="objective-bar" id="objBar"></div>
            <div class="killfeed" id="kf"></div>
            <div class="hitmarker" id="hm"></div>
            <div class="bottom-strip" id="bs"></div>
            <div id="bombPrompt"></div>
            <div id="spawnShield"></div>
            <div id="multikillBanner"></div>
            <div id="ksToast"></div>
            <div id="centerOverlay"></div>
            <div id="coopShop"></div>
        </div>
    `;
    startTimerTick();
    renderTime();
    renderTeamCounts();
    renderWeaponCard();
    renderObjectives();
    renderCoop();
}

let timerInterval = null;
function startTimerTick() {
    if (timerInterval) clearInterval(timerInterval);
    timerInterval = setInterval(() => {
        if (state.view !== 'hud') return;
        if (typeof state.hud.seconds === 'number' && state.hud.seconds > 0) {
            state.hud.seconds = Math.max(0, state.hud.seconds - 1);
            renderTime();
        }
    }, 1000);
}
function stopTimerTick() {
    if (timerInterval) { clearInterval(timerInterval); timerInterval = null; }
}

function getTeamValue(obj, teamNum) {
    if (obj == null) return 0;
    if (Array.isArray(obj)) {
        return obj[teamNum - 1] || 0;
    }
    return obj[teamNum] || obj[String(teamNum)] || 0;
}

function renderTime() {
    const top = document.getElementById('hudTop');
    if (!top) return;
    const seconds = state.hud.seconds || 0;
    const min = Math.floor(seconds/60).toString().padStart(2, '0');
    const sec = (seconds%60).toString().padStart(2, '0');
    const warn = seconds > 0 && seconds <= 15;
    const teamModes = {tdm:1, sunset_tdm:1, bombplant:1, domination:1, koth:1, gunrotation:1, escort:1, tournament:1, infection:1, juggernaut:1};
    const isTeams = !!teamModes[state.hud.mode];
    const counts = state.hud.teamCounts || {};
    const score = state.hud.score || {};
    const startSize = state.hud.teamStartSize || {};
    const a1 = getTeamValue(counts, 1);
    const a2 = getTeamValue(counts, 2);
    const s1 = getTeamValue(startSize, 1);
    const s2 = getTeamValue(startSize, 2);
    const sc1 = getTeamValue(score, 1);
    const sc2 = getTeamValue(score, 2);
    const d1 = Math.max(0, s1 - a1);
    const d2 = Math.max(0, s2 - a2);
    const showDead = s1 > 0 || s2 > 0;
    const killBased = state.hud.mode === 'tdm';
    const tk = state.hud.teamKills || {};
    const num1 = killBased ? getTeamValue(tk, 1) : sc1;
    const num2 = killBased ? getTeamValue(tk, 2) : sc2;
    const stateLabel = {warmup: 'گرم‌کردن', live: 'مچ', roundEnd: 'پایان راند', planted: 'بمب کاشته', defusing: 'دیفیوز', ended: 'پایان'}[state.hud.state] || '';
    const roundText = (state.hud.roundIndex && !killBased) ? `${state.hud.roundIndex}/${state.hud.rounds || ''}` : '';
    const statPairsA = killBased ? `<span class="stat-pair"><span class="lbl">کیل</span><span class="alive-num eng">${num1}</span></span>` : `
        <span class="stat-pair"><span class="lbl">زنده</span><span class="alive-num eng">${a1}</span></span>
        ${showDead ? `<span class="stat-pair"><span class="lbl">مرده</span><span class="dead-num eng">${d1}</span></span>` : ''}
    `;
    const statPairsB = killBased ? `<span class="stat-pair"><span class="lbl">کیل</span><span class="alive-num eng">${num2}</span></span>` : `
        <span class="stat-pair"><span class="lbl">زنده</span><span class="alive-num eng">${a2}</span></span>
        ${showDead ? `<span class="stat-pair"><span class="lbl">مرده</span><span class="dead-num eng">${d2}</span></span>` : ''}
    `;
    const winner = state.hud.winner;
    const aWon = state.hud.state === 'roundEnd' && winner === 1;
    const bWon = state.hud.state === 'roundEnd' && winner === 2;
    const drawRound = state.hud.state === 'roundEnd' && winner === 0;
    top.innerHTML = `
        ${isTeams ? `<div class="team-score a ${aWon ? 'winner' : ''}">
            <div class="num eng">${num1}</div>
            <div class="info">
                <span class="meta eng">ALPHA${aWon ? ' ◆' : ''}</span>
                <span class="alive">${statPairsA}</span>
            </div>
        </div>` : ''}
        <div class="hud-time ${warn?'warning':''}">
            <div class="round">${roundText ? '<span class="eng">' + roundText + '</span> · ' : ''}${stateLabel}${drawRound ? ' · مساوی' : ''}</div>
            <div class="clock eng">${min}:${sec}</div>
        </div>
        ${isTeams ? `<div class="team-score b ${bWon ? 'winner' : ''}">
            <div class="info">
                <span class="meta eng">${bWon ? '◆ ' : ''}BRAVO</span>
                <span class="alive">${statPairsB}</span>
            </div>
            <div class="num eng">${num2}</div>
        </div>` : ''}
    `;
}

function renderTeamCounts() { renderTime(); }

function renderWeaponCard() {
    const bs = document.getElementById('bs');
    if (!bs) return;
    bs.innerHTML = `
        ${state.hud.weapon ? `<div class="weapon-card eng">${escape((state.hud.weapon||'').replace('WEAPON_',''))}</div>` : ''}
        ${state.hud.coopWave ? `<div class="coop-info"><div class="col"><div class="lbl">موج</div><div class="val eng">${state.hud.coopWave}</div></div><div class="col"><div class="lbl">پول</div><div class="val eng">${state.hud.coopMoney||0}</div></div></div>` : ''}
    `;
}

function pushKillFeed(info) {
    const feed = document.getElementById('kf');
    if (!feed) return;
    const row = document.createElement('div');
    row.className = 'kf-row';
    row.innerHTML = `<span class="killer">${escape(info.killer||'?')}</span> → <span class="victim">${escape(info.victim||'?')}</span>${info.headshot?' <span class="hs eng">HS</span>':''}`;
    feed.appendChild(row);
    if (feed.children.length > 6) feed.removeChild(feed.firstChild);
    requestAnimationFrame(() => row.classList.add('show'));
    setTimeout(() => row.classList.add('fade'), 6500);
    setTimeout(() => row.remove(), 7000);
}

function flashHitmarker(isKill) {
    const hm = document.getElementById('hm');
    if (!hm) return;
    hm.classList.add('show');
    if (isKill) hm.classList.add('kill');
    setTimeout(() => {
        hm.classList.remove('show');
        hm.classList.remove('kill');
    }, 350);
}

function showMultikill(d) {
    const c = document.getElementById('multikillBanner');
    if (!c) return;
    c.innerHTML = `<div class="multikill-banner">${escape(d.label)}</div>`;
    setTimeout(() => { c.innerHTML = ''; }, 2500);
}
function showKillstreak(d) {
    const c = document.getElementById('ksToast');
    if (!c) return;
    c.innerHTML = `<div class="killstreak-toast">${d.streak}× ${escape(d.reward.label)}</div>`;
    setTimeout(() => { c.innerHTML = ''; }, 4000);
}
function renderSpawnShield() {
    const c = document.getElementById('spawnShield');
    if (!c) return;
    if (state.hud.spawnProtectSeconds > 0) {
        c.innerHTML = `<div class="spawn-shield eng">SPAWN PROTECTED</div>`;
        setTimeout(() => { if (state.hud.spawnProtectSeconds <= 0) c.innerHTML = ''; }, state.hud.spawnProtectSeconds * 1000);
    } else { c.innerHTML = ''; }
}
function renderBombPrompt() {
    const c = document.getElementById('bombPrompt');
    if (!c) return;
    if (state.hud.bombPrompt && state.hud.bombPrompt.site) c.innerHTML = `<div class="bomb-prompt">${T.plant}${state.hud.bombPrompt.site}</div>`;
    else if (state.hud.bombDefuse && state.hud.bombDefuse.site) c.innerHTML = `<div class="bomb-prompt">${T.defuse}${state.hud.bombDefuse.site}</div>`;
    else c.innerHTML = '';
}

function renderObjectives() {
    const c = document.getElementById('objBar');
    if (!c) return;
    if (state.hud.mode === 'domination' && state.hud.domState) {
        const pts = (state.hud.domState.points||[]);
        c.innerHTML = pts.map(p => `<div class="point ${p.owner===1?'team-a':p.owner===2?'team-b':''}">${escape(p.label||'?')}</div>`).join('');
    } else if (state.hud.mode === 'koth') {
        c.innerHTML = `<div class="koth-status">${state.hud.kothInside?T.inside:T.outside} هیل · ${T.holder}: ${state.hud.kothHolder||'-'}</div>`;
    } else { c.innerHTML = ''; }
}

let domCapAnchor = {p: -1, at: 0};
function renderDomCapture() {
    const d = state.hud.domCapturing;
    let el = document.getElementById('domCapture');
    if (!d || d.point == null) { if (el) el.remove(); domCapAnchor.p = -1; return; }
    if (!el) {
        el = document.createElement('div');
        el.id = 'domCapture';
        el.innerHTML = '<div class="dc-top"><span class="dc-zone eng"></span><span class="dc-title"></span></div><div class="dc-track"><div class="dc-fill"></div></div><div class="dc-time eng"></div>';
        (document.getElementById('hudRoot') || document.body).appendChild(el);
    }
    const total = d.captureTime || 12;
    const cap = d.captureTeam || 0;
    const owned = (d.owner || 0) > 0;
    const contested = !!d.contested;
    let prog = d.captureProgress || 0;
    if (cap > 0 && prog < total) {
        if (prog !== domCapAnchor.p) { domCapAnchor = {p: prog, at: Date.now()}; }
        prog = Math.min(total, prog + (Date.now() - domCapAnchor.at) / 1000);
    } else {
        domCapAnchor.p = -1;
    }
    let title, cls, pct, showTime;
    if (contested) { title = 'منطقه درگیره'; cls = 'contested'; pct = ((d.captureProgress || 0) / total) * 100; showTime = false; }
    else if (cap > 0) { const mine = cap === d.myTeam; title = mine ? 'در حال تصرف' : 'در حال از دست رفتن'; cls = cap === 1 ? 'team-a' : 'team-b'; pct = (prog / total) * 100; showTime = true; }
    else if (owned) { title = d.owner === d.myTeam ? 'منطقه‌ی شما' : 'منطقه‌ی حریف'; cls = d.owner === 1 ? 'team-a' : 'team-b'; pct = 100; showTime = false; }
    else { title = 'منطقه‌ی خنثی'; cls = 'neutral'; pct = 0; showTime = false; }
    pct = Math.max(0, Math.min(100, pct));
    el.className = 'dom-capture ' + cls + (contested ? ' pulse' : '');
    el.querySelector('.dc-zone').textContent = d.label || '';
    el.querySelector('.dc-title').textContent = title;
    el.querySelector('.dc-fill').style.width = pct + '%';
    const timeEl = el.querySelector('.dc-time');
    if (showTime) { timeEl.style.display = ''; timeEl.textContent = Math.max(0, Math.ceil(total - prog)) + 's'; }
    else { timeEl.style.display = 'none'; }
}

function renderCoop() {
    renderWeaponCard();
}

function renderCoopShop() {
    const c = document.getElementById('coopShop');
    if (!c) return;
    if (!state.hud.coopShop || !state.hud.coopShop.items) { c.innerHTML = ''; return; }
    const items = (state.hud.coopShop.items.items || []);
    c.innerHTML = `
        <div style="position:absolute; left:50%; bottom:80px; transform:translateX(-50%); background:rgba(10,20,36,0.96); border:1px solid var(--orange); padding:14px; border-radius:10px; min-width:340px; pointer-events:auto;">
            <h3 style="color:var(--orange); margin-bottom:10px; text-transform:uppercase; letter-spacing:1.4px;">${escape(state.hud.coopShop.items.label||'Shop')}</h3>
            ${items.map((it, idx) => `<div style="display:flex;justify-content:space-between;padding:6px 8px;border-radius:4px;background:rgba(255,255,255,0.03);margin-bottom:4px;cursor:pointer;" data-buy="${idx+1}"><span>${escape(it.label)}</span><span style="color:var(--orange)">$${it.cost}</span></div>`).join('')}
        </div>
    `;
    c.querySelectorAll('[data-buy]').forEach(b => b.addEventListener('click', () => {
        window.parent.postMessage({type: 'nuiCallback', action: 'coopBuy', data: {shopIndex: state.hud.coopShop.shopIndex, itemIndex: parseInt(b.dataset.buy)}}, '*');
    }));
}

let predatorTimer = null;
function showPredatorHud(data) {
    hidePredatorHud();
    const el = document.createElement('div');
    el.id = 'predatorHud';
    el.className = 'predator-hud';
    el.innerHTML = `
        <div class="corner tl"></div>
        <div class="corner tr"></div>
        <div class="corner bl"></div>
        <div class="corner br"></div>
        <div class="center-cross"></div>
        <div class="info-top">
            <div class="title">[ PREDATOR DRONE ]</div>
            <div class="sub">SHAHED-136 · KAMIKAZE MODE</div>
        </div>
        <div class="rec-text">REC</div>
        <div class="blink"></div>
        <div class="countdown" id="predatorCountdown">--</div>
        <div class="info-left">
            <div class="row"><span class="label">SYS</span><span class="value">ARMED</span></div>
            <div class="row"><span class="label">CAM</span><span class="value">EO/IR</span></div>
            <div class="row"><span class="label">PAYLOAD</span><span class="value">HE-FRAG</span></div>
            <div class="row"><span class="label">LINK</span><span class="value">SECURE</span></div>
        </div>
        <div class="info-right">
            <div>SAT-LINK ACTIVE</div>
            <div>OPERATOR-1</div>
            <div>ENCRYPTED</div>
        </div>
    `;
    document.body.appendChild(el);
    if (predatorTimer) clearInterval(predatorTimer);
    const duration = (data.duration || 30) * 1000;
    const endAt = Date.now() + duration;
    predatorTimer = setInterval(() => {
        const rem = Math.max(0, Math.ceil((endAt - Date.now()) / 1000));
        const c = document.getElementById('predatorCountdown');
        if (c) c.textContent = rem + 's';
        if (rem <= 0) { clearInterval(predatorTimer); predatorTimer = null; }
    }, 200);
}
function hidePredatorHud() {
    const el = document.getElementById('predatorHud');
    if (el) el.remove();
    if (predatorTimer) { clearInterval(predatorTimer); predatorTimer = null; }
}

function renderSpectateInfo(d) {
    let el = document.getElementById('spectateInfo');
    if (!d || !d.active) { if (el) el.remove(); return; }
    if (!el) {
        el = document.createElement('div');
        el.id = 'spectateInfo';
        el.className = 'spectate-info';
        document.body.appendChild(el);
    }
    const hpPct = Math.max(0, Math.min(100, (d.hpFrac || 0) * 100));
    const arPct = Math.max(0, Math.min(100, d.armor || 0));
    el.innerHTML = `
        <div class="si-head">در حال تماشای</div>
        <div class="si-name">${escape(d.name || '—')}</div>
        <div class="si-weapon eng">${escape(d.weapon || '')}</div>
        <div class="si-bars">
            <div class="si-bar"><span class="si-lbl hp">HP</span><div class="si-track"><div class="si-fill hp" style="width:${hpPct}%"></div></div></div>
            <div class="si-bar"><span class="si-lbl ar">AR</span><div class="si-track"><div class="si-fill ar" style="width:${arPct}%"></div></div></div>
        </div>
        <div class="si-hint">◄ ► تغییر بازیکن</div>
    `;
}

function renderPerkHud(data) {
    let el = document.getElementById('perkHud');
    const perks = (data && data.perks) || [];
    if (perks.length === 0) {
        if (el) { el.innerHTML = ''; el.style.display = 'none'; }
        return;
    }
    if (!el) {
        el = document.createElement('div');
        el.id = 'perkHud';
        el.className = 'perk-hud';
        document.body.appendChild(el);
    }
    el.style.display = '';
    let html = '';
    for (let i = 1; i <= 3; i++) {
        const pk = perks[i - 1];
        if (pk) {
            const label = perkLabelFromKey(pk);
            const icon = pbIconImg(PB_PERK_ICONS[pk], perkIconFromKey(pk), 'perk-ic');
            html += `<div class="slot" id="perkSlot${i}" data-key="${escape(pk)}">
                <div class="progress-fill"></div>
                <span class="key-hint eng">num${i}</span>
                <span class="icon">${icon}</span>
                <span class="name">${escape(label)}</span>
            </div>`;
        } else {
            html += `<div class="slot empty" id="perkSlot${i}">
                <div class="progress-fill"></div>
                <span class="key-hint eng">num${i}</span>
                <span class="icon">·</span>
                <span class="name">خالی</span>
            </div>`;
        }
    }
    el.innerHTML = html;
}

function removePerkHud() {
    const el = document.getElementById('perkHud');
    if (el) el.remove();
}

function perkLabelFromKey(key) {
    const map = {
        fast_run: 'دو', high_jump: 'پرش', fast_reload: 'ریلود', low_recoil: 'ریکویل',
        extra_armor: 'زره', instant_heal: 'هیل', stealth: 'استلث', damage_boost: 'دمیج',
        dead_silence: 'صدا', extra_ammo: 'مهمات', fast_aim: 'ایم', slide_kick: 'اسلاید',
        thermal_vision: 'حرارتی', night_vision: 'شب'
    };
    return map[key] || key;
}

function perkIconFromKey(key) {
    const map = {
        fast_run: '🏃', high_jump: '🦘', fast_reload: '🔄', low_recoil: '⚙',
        extra_armor: '🛡', instant_heal: '❤', stealth: '👤', damage_boost: '💥',
        dead_silence: '🤫', extra_ammo: '🎒', fast_aim: '👁', slide_kick: '🦵',
        thermal_vision: '🔥', night_vision: '🌙'
    };
    return map[key] || '★';
}

const perkAnimTimers = {};
function animatePerkSlot(data) {
    const slotNum = data.slot || 1;
    const slot = document.getElementById('perkSlot' + slotNum);
    if (!slot) return;
    const durationMs = (data.duration || 18) * 1000;
    const cooldownMs = (data.cooldown || 30) * 1000;

    if (perkAnimTimers[slotNum] && perkAnimTimers[slotNum].tick) {
        clearInterval(perkAnimTimers[slotNum].tick);
    }

    const fill = slot.querySelector('.progress-fill');
    slot.classList.remove('cooldown', 'empty');
    slot.classList.add('active');
    if (fill) {
        fill.style.transition = 'height 0.15s linear';
        fill.style.height = '100%';
    }

    const startedAt = Date.now();
    const activeUntil = startedAt + durationMs;
    const cooldownUntil = activeUntil + cooldownMs;
    let phase = 'active';

    const tick = setInterval(() => {
        const now = Date.now();
        if (phase === 'active') {
            const remaining = Math.max(0, activeUntil - now);
            const pct = (remaining / durationMs) * 100;
            if (fill) fill.style.height = pct + '%';
            if (now >= activeUntil) {
                phase = 'cooldown';
                slot.classList.remove('active');
                slot.classList.add('cooldown');
                if (fill) fill.style.height = '100%';
            }
        } else if (phase === 'cooldown') {
            const remaining = Math.max(0, cooldownUntil - now);
            const pct = (remaining / cooldownMs) * 100;
            if (fill) fill.style.height = pct + '%';
            if (now >= cooldownUntil) {
                phase = 'ready';
                slot.classList.remove('cooldown');
                if (fill) fill.style.height = '0%';
                clearInterval(tick);
                if (perkAnimTimers[slotNum]) perkAnimTimers[slotNum].tick = null;
            }
        }
    }, 100);

    perkAnimTimers[slotNum] = {tick, activeUntil, cooldownUntil};
}

let ksTrackerTimer = null;
function showKillstreakTracker(d) {
    let el = document.getElementById('ksTracker');
    if (!d || !d.nextAt) { if (el) el.remove(); return; }
    if (!el) {
        el = document.createElement('div');
        el.id = 'ksTracker';
        el.className = 'ks-tracker';
        document.body.appendChild(el);
    }
    const pct = Math.min(100, (d.current / d.nextAt) * 100);
    el.innerHTML = `
        <div class="label">Killstreak بعدی</div>
        <div class="next">${escape(d.nextLabel || '-')}</div>
        <div class="progress">${d.current} / ${d.nextAt}</div>
        <div class="bar-track"><div class="bar-fill" style="width:${pct}%"></div></div>
    `;
    if (ksTrackerTimer) clearTimeout(ksTrackerTimer);
    ksTrackerTimer = setTimeout(() => { if (el) el.remove(); }, 8000);
}

function showMapTour(d) {
    hideMapTour();
    const el = document.createElement('div');
    el.id = 'tourOverlay';
    el.className = 'tour-overlay';
    el.innerHTML = `<div><div class="title">MAP OVERVIEW</div><div class="countdown" id="tourCount">${d.duration}s</div></div>`;
    document.body.appendChild(el);
    let remaining = d.duration;
    const iv = setInterval(() => {
        remaining--;
        const c = document.getElementById('tourCount');
        if (c) c.textContent = remaining + 's';
        if (remaining <= 0) { clearInterval(iv); hideMapTour(); }
    }, 1000);
}
function hideMapTour() {
    const el = document.getElementById('tourOverlay');
    if (el) el.remove();
}

function showMatchOutro(d) {}
function hideMatchOutro() {
    const el = document.getElementById('outroOverlay');
    if (el) el.remove();
}

function showKillstreakBanner(d) {
    const c = document.getElementById('ksToast');
    if (!c) return;
    c.innerHTML = `<div class="killstreak-toast">${escape((d && d.label) || '')}</div>`;
    setTimeout(() => { if (c) c.innerHTML = ''; }, ((d && d.duration) || 3) * 1000);
}

let nukeOverlay = null;
function startNukeOverlay(data) {
    if (nukeOverlay) nukeOverlay.remove();
    nukeOverlay = document.createElement('div');
    nukeOverlay.className = 'nuke-overlay';
    nukeOverlay.innerHTML = `
        <div class="alert-text">⚠ TACTICAL NUKE ⚠</div>
        <div class="alert-counter" id="nukeCounter">${Math.ceil((data && data.seconds) || 30)}</div>
        <div class="alert-warning">به یه پناهگاه برو!</div>
    `;
    document.body.appendChild(nukeOverlay);
}
function updateNukeOverlay(data) {
    if (!nukeOverlay) return;
    const intensity = (data && data.intensity) || 0;
    const remaining = (data && data.remaining) || 0;
    nukeOverlay.style.background = `rgba(255, 0, 0, ${0.05 + intensity * 0.3})`;
    if (intensity > 0.3) nukeOverlay.classList.add('active');
    const counter = document.getElementById('nukeCounter');
    if (counter) counter.textContent = Math.max(0, Math.ceil(remaining));
}
function stopNukeOverlay() {
    if (nukeOverlay) {
        nukeOverlay.style.background = 'rgba(255, 255, 255, 1)';
        setTimeout(() => { if (nukeOverlay) { nukeOverlay.remove(); nukeOverlay = null; } }, 1500);
    }
}

function toggleScoreboard(show) {
    const id = 'liveScoreboard';
    let el = document.getElementById(id);
    if (!show) {
        if (el) el.remove();
        return;
    }
    if (!el) {
        el = document.createElement('div');
        el.id = id;
        el.className = 'scoreboard-shell';
        document.body.appendChild(el);
    }
    const players = (state.hud.scoreboard || []).slice().sort((a, b) => (b.score||b.kills||0) - (a.score||a.kills||0));
    const score = state.hud.score || {};
    const isTeams = score[1] !== undefined || score[2] !== undefined;
    const team1Players = players.filter(p => p.team === 1);
    const team2Players = players.filter(p => p.team === 2);
    const ffaPlayers = players.filter(p => !p.team || p.team === 0);
    const modeLabel = state.hud.mode || '';
    const myId = window.__pbServerId;

    const renderRow = (p, i) => {
        const kd = (p.deaths||0)>0?(p.kills/p.deaths).toFixed(2):(p.kills||0).toFixed(2);
        const isMe = p.src === myId;
        return `<tr class="${p.team===1?'team-1':p.team===2?'team-2':''} ${isMe?'me':''}">
            <td class="eng">${i+1}</td>
            <td class="name-cell">${escape(p.name || ('Player '+(p.src||'?')))}</td>
            <td class="eng">${p.kills||0}</td>
            <td class="eng">${p.deaths||0}</td>
            <td class="eng ratio">${kd}</td>
            <td class="eng score">${p.score||p.kills||0}</td>
        </tr>`;
    };
    const renderTable = (rows, teamClass) => `
        <div class="sb-table ${teamClass||''}">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>${T.identifier || 'بازیکن'}</th>
                        <th>${T.kills || 'K'}</th>
                        <th>${T.deaths || 'D'}</th>
                        <th>${T.kd || 'K/D'}</th>
                        <th>امتیاز</th>
                    </tr>
                </thead>
                <tbody>
                    ${rows.length === 0 ? `<tr><td colspan="6" class="sb-empty">خالی</td></tr>` : rows.map(renderRow).join('')}
                </tbody>
            </table>
        </div>
    `;

    el.innerHTML = `
        <div class="scoreboard">
            <div class="sb-header">
                <div class="sb-title">SCOREBOARD</div>
                <div class="sb-mode">${escape(modeLabel)}${state.hud.rounds ? ` · راند <span class="eng">${state.hud.roundIndex||0}/${state.hud.rounds}</span>` : ''}</div>
            </div>
            ${isTeams ? `
                <div class="sb-teams-summary">
                    <div class="sb-team-tag team-alpha"><span class="lbl">ALPHA</span><span class="num eng">${score[1]||0}</span></div>
                    <div class="sb-vs">vs</div>
                    <div class="sb-team-tag team-bravo"><span class="num eng">${score[2]||0}</span><span class="lbl">BRAVO</span></div>
                </div>
            ` : ''}
            <div class="sb-body">
                ${isTeams ? `
                    ${renderTable(team1Players, 'team-1-table')}
                    ${renderTable(team2Players, 'team-2-table')}
                ` : renderTable(ffaPlayers.length ? ffaPlayers : players, '')}
            </div>
        </div>
    `;
}

function showPerkProgress(data) {
    if (!data || !data.perk) return;
}

function showMatchEnd(d) {
    stopTimerTick();
    removePerkHud();
    const winner = d && d.winner;
    const summary = (d && d.summary) || {};
    const players = (summary.players || []).slice().sort((a, b) => (b.kills - b.deaths) - (a.kills - a.deaths));
    const mvp = summary.mvp;
    const myId = window.__pbServerId;
    let winLabel = T.gameOver;
    if (typeof winner === 'number') {
        winLabel = winner === 1 ? `پیروزی تیم آلفا` : (winner === 2 ? `پیروزی تیم براوو` : T.matchEnd);
    } else if (winner === myId) winLabel = `پیروزی شما!`;
    else if (winner === 'win') winLabel = `پیروزی!`;
    else if (winner === 'lose') winLabel = `شکست`;

    const mvpRow = mvp && (summary.players || []).find(p => p.src === mvp);

    let container = document.getElementById('matchEndOverlay');
    if (!container) {
        container = document.createElement('div');
        container.id = 'matchEndOverlay';
        container.className = 'match-end-shell';
        document.body.appendChild(container);
    }
    container.innerHTML = `
        <div class="match-end-card">
            <div class="match-end-head">
                <div class="title eng">${T.matchEnd}</div>
                <div class="winner">${winLabel}</div>
                <div class="sub">${escape(d && d.mode || '')}${summary.reason ? ' · ' + escape(summary.reason) : ''}</div>
            </div>
            <div class="match-end-body">
                ${mvpRow ? `
                    <div class="mvp-card">
                        <div class="badge eng">MVP</div>
                        <div class="info">
                            <div class="name">${escape(mvpRow.name || ('Player '+mvp))}</div>
                            <div class="stats">${T.kills}: <span class="eng">${mvpRow.kills}</span> · ${T.deaths}: <span class="eng">${mvpRow.deaths}</span> · ${T.headshots}: <span class="eng">${mvpRow.headshots||0}</span></div>
                        </div>
                    </div>
                ` : ''}
                <div class="mp-table">
                    <table>
                        <thead><tr><th>#</th><th>${T.identifier}</th><th>تیم</th><th>${T.kills}</th><th>${T.deaths}</th><th>${T.kd}</th><th>${T.headshots}</th></tr></thead>
                        <tbody>
                            ${players.map((p, i) => `
                                <tr class="${p.team===1?'team-1':p.team===2?'team-2':''} ${p.src===mvp?'mvp':''}">
                                    <td class="eng">${i+1}</td>
                                    <td>${escape(p.name || ('Player '+p.src))}</td>
                                    <td>${p.team===1?'آلفا':p.team===2?'براوو':'تماشاچی'}</td>
                                    <td class="eng">${p.kills}</td>
                                    <td class="eng">${p.deaths}</td>
                                    <td class="eng">${p.deaths>0?(p.kills/p.deaths).toFixed(2):p.kills.toFixed(2)}</td>
                                    <td class="eng">${p.headshots||0}</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `;
    setTimeout(() => {
        if (document.getElementById('matchEndOverlay')) {
            document.getElementById('matchEndOverlay').remove();
            hudRoot.classList.remove('show');
            hudRoot.innerHTML = '';
        }
    }, 12000);
}

function handleAttachUpdate(t, data) {
    if (t === 'attachments') {
        state.attachments = {weapon: data.weapon, list: data.list, current: data.current};
        renderAttachments();
    } else if (t === 'attachmentsApplied') {
        state.attachments.current = data.attachments || {};
        renderAttachments();
    }
}

function renderAttachments() {
    overlayRoot.classList.add('show');
    const a = state.attachments;
    overlayRoot.innerHTML = `
        <div class="attach-shell">
            <div class="attach-header">
                <h3>اتچمنت‌ها</h3>
                <button class="btn ghost small" id="closeAttach">[B] بستن</button>
            </div>
            <div style="font-size:12px; color: var(--grey-2); font-weight:700; direction:ltr;">${escape(a.weapon||'بدون اسلحه')}</div>
            <div class="attach-list">
                ${(a.list||[]).filter(x => x.group !== 'tint').map(x => {
                    const on = a.current && a.current[x.group];
                    return `<div class="attach-row ${on?'on':''}" data-group="${x.group}">
                        <div><div class="label">${escape(x.label)}</div><div class="group">${escape(x.group)}</div></div>
                        <div class="toggle"></div>
                    </div>`;
                }).join('')}
                ${(a.list||[]).find(x => x.group === 'tint') ? `<div class="tint-row">
                    ${tintIndices(a.weapon).map(i => `<div class="tint-chip ${a.current && a.current.tint && a.current.tint.hash===i?'active':''}" data-tint="${i}" style="background:${tintSwatch(a.weapon, i)}" title="${tintLabel(a.weapon, i)}"></div>`).join('')}
                </div>` : ''}
            </div>
        </div>
    `;
    document.getElementById('closeAttach').addEventListener('click', () => {
        postCallback('close', {});
    });
    overlayRoot.querySelectorAll('[data-group]').forEach(r => r.addEventListener('click', () => {
        const g = r.dataset.group;
        const on = !(state.attachments.current && state.attachments.current[g]);
        requestAction('toggleAttachment', {weapon: state.attachments.weapon, group: g, enable: on});
    }));
    overlayRoot.querySelectorAll('[data-tint]').forEach(c => c.addEventListener('click', () => {
        requestAction('setTint', {weapon: state.attachments.weapon, tintIndex: parseInt(c.dataset.tint)});
    }));
}

function tintColor(i) {
    return [
        '#1c1c1e',
        '#3a6b34',
        '#d4af37',
        '#ff5fb0',
        '#5c5a3e',
        '#1e3a5f',
        '#ff6f00',
        '#c0c0c0'
    ][i] || '#1c1c1e';
}

function tintName(i) {
    return [
        'استاندارد',
        'سبز',
        'طلایی',
        'صورتی',
        'ارتشی',
        'پلیس',
        'نارنجی',
        'پلاتین'
    ][i] || 'استاندارد';
}

const TINT_MK2_COLORS = ['#1c1c1e', '#6b6b6b', '#9a9a8c', '#e8e8e8', '#d8c89a', '#3a6b34', '#1e3a5f', '#6b5535', '#4a3520', '#c0392b', '#2471a3', '#d4ac0d', '#e67e22', '#ff5fb0', '#8e44ad', '#ff6f00', '#5fa84a', '#e74c3c', '#2ecc71', '#17c0c0', '#f1c40f', '#d64545', '#4a7fd6', '#d4af37', '#c0c0c0', '#b0a8c0', '#9b59b6', '#a93226', '#1e8449', '#2e5f9e', '#aee0e0', '#d35400'];
const TINT_MK2_NAMES = ['Default', 'Gray', 'Two-Tone', 'White', 'Beige', 'Green', 'Blue', 'Earth', 'Brown / Black', 'Red Contrast', 'Blue Contrast', 'Yellow Contrast', 'Orange Contrast', 'Bold Pink', 'Bold Purple / Yellow', 'Bold Orange', 'Bold Green / Purple', 'Bold Red', 'Bold Green', 'Bold Cyan', 'Bold Yellow', 'Bold Red / White', 'Bold Blue / White', 'Metallic Gold', 'Metallic Platinum', 'Metallic Gray / Lilac', 'Metallic Purple / Lime', 'Metallic Red', 'Metallic Green', 'Metallic Blue', 'Metallic White / Aqua', 'Metallic Red / Yellow'];
function isMk2Weapon(model) { return !!model && /_MK2$/i.test(model); }
function tintIndices(model) { return isMk2Weapon(model) ? Array.from({length: 32}, (_, i) => i) : [0, 1, 2, 3, 4, 5, 6, 7]; }
function tintSwatch(model, i) { return isMk2Weapon(model) ? (TINT_MK2_COLORS[i] || '#1c1c1e') : tintColor(i); }
function tintLabel(model, i) { return isMk2Weapon(model) ? (TINT_MK2_NAMES[i] || 'Tint') : tintName(i); }

function showLobbyInfoTooltip(anchor, lobby) {
    hideLobbyInfoTooltip();
    const tip = document.createElement('div');
    tip.id = 'lobbyInfoTip';
    tip.className = 'lobby-info-tip';

    const rows = [];
    const row = (label, value, opts) => {
        opts = opts || {};
        const cls = opts.cls || '';
        rows.push(`<div class="tip-row"><span class="tip-label">${label}</span><span class="tip-value ${cls}">${value}</span></div>`);
    };
    const yesNo = (b) => b
        ? `<span class="tip-bool on">فعال</span>`
        : `<span class="tip-bool off">غیرفعال</span>`;

    row('گیم‌مود', escape(lobby.modeLabel || lobby.mode || '-'));
    row('مپ', escape(lobby.mapLabel || lobby.map || '-'));
    row('بازیکن‌ها', `<span class="eng">${lobby.count||0}/${lobby.max||0}</span>`);
    const wLabel = lobby.weaponLabel || (lobby.weapon ? String(lobby.weapon).replace('WEAPON_', '') : '');
    row('سلاح', wLabel && wLabel !== '' ? escape(wLabel) : 'لودآوت پلیر');
    const hasRounds = lobby.rounds && lobby.rounds > 0;
    if (hasRounds) {
        row('راند', `<span class="eng">${lobby.rounds}</span>`);
    }
    if (lobby.timer && lobby.timer > 0) {
        const mins = Math.floor(lobby.timer / 60);
        const secs = lobby.timer % 60;
        row(hasRounds ? 'زمان راند' : 'زمان مچ', `<span class="eng">${mins}:${String(secs).padStart(2,'0')}</span>`);
    }
    if (lobby.armor !== undefined) {
        row('آرمور', `<span class="eng">${lobby.armor}</span>`);
    }
    row('هدشات', yesNo(lobby.headshotOn));
    row('هاردکور', yesNo(lobby.hardcore));
    row('پرک‌ها', yesNo(lobby.perksEnabled));
    row('کیل‌استریک', yesNo(lobby.killstreaksEnabled));
    if (lobby.mode === 'sunset_tdm') row('تعویض اسپاون', yesNo(lobby.switchTeam));
    row('پسوورد', yesNo(lobby.hasPassword));

    if (lobby.equipment && lobby.equipment.length > 0) {
        const items = lobby.equipment.map(e => `<span class="tip-eq">${escape(e)}</span>`).join('');
        rows.push(`<div class="tip-row column"><span class="tip-label">تجهیزات</span><div class="tip-eq-list">${items}</div></div>`);
    } else {
        row('تجهیزات', `<span class="tip-bool off">بدون</span>`);
    }

    tip.innerHTML = `
        <div class="tip-head">
            <span class="tip-title">${escape(lobby.name || 'Lobby')}</span>
            <span class="tip-id eng">#${lobby.id}</span>
        </div>
        <div class="tip-body">${rows.join('')}</div>
    `;
    document.body.appendChild(tip);

    const rect = anchor.getBoundingClientRect();
    const tipRect = tip.getBoundingClientRect();
    let top = rect.bottom + 8;
    let left = rect.left + (rect.width / 2) - (tipRect.width / 2);
    if (left < 8) left = 8;
    if (left + tipRect.width > window.innerWidth - 8) left = window.innerWidth - tipRect.width - 8;
    if (top + tipRect.height > window.innerHeight - 8) top = rect.top - tipRect.height - 8;
    tip.style.top = `${top}px`;
    tip.style.left = `${left}px`;
    requestAnimationFrame(() => tip.classList.add('show'));
}

function hideLobbyInfoTooltip() {
    const old = document.getElementById('lobbyInfoTip');
    if (old) old.remove();
}

function escape(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}
function showToast(msg) {
    const t = document.createElement('div');
    t.className = 'toast';
    t.textContent = msg;
    document.body.appendChild(t);
    setTimeout(() => t.remove(), 2500);
}

document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        if (state.view === 'attachments') {
            postCallback('close', {});
        } else if (state.view === 'lobby') {
            postCallback('escape', {});
        }
    }
    if (state.view === 'attachments' && (e.key === 'b' || e.key === 'B')) {
        postCallback('close', {});
    }
    if (e.key === 'Tab') {
        e.preventDefault();
    }
});
