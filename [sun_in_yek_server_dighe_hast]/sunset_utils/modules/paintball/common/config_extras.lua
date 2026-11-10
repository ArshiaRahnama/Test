-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

paintballConfig = paintballConfig or {}
paintballConfig.gameModes = paintballConfig.gameModes or {}

paintballConfig.gameModes.domination = {
    priority = 80,
    enabled = true,
    comingSoon = true,
    label = 'Domination',
    teamCount = 2,
    teamSize = {min = 1, max = 12},
    scoreToWin = 200,
    tickEvery = 3,
    pointPerTick = 1,
    captureTime = 12,
    matchTime = 480,
    warmupTime = 5,
    respawnDelay = 4,
    spawnInvincibility = 2,
    spawnHpArmor = {hp = 200, armor = 50, maxArmor = 98},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = true, rounds = false, timer = true, armor = true, headshot = true},
}

paintballConfig.gameModes.koth = {
    priority = 75,
    enabled = true,
    comingSoon = true,
    label = 'King Of The Hill',
    teamCount = 2,
    teamSize = {min = 2, max = 12},
    scoreToWin = 200,
    tickEvery = 1,
    pointPerTick = 1,
    matchTime = 360,
    warmupTime = 5,
    respawnDelay = 4,
    spawnInvincibility = 2,
    spawnHpArmor = {hp = 200, armor = 50, maxArmor = 98},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = true, rounds = false, timer = true, armor = true, headshot = true},
}

paintballConfig.gameModes.infection = {
    priority = 70,
    enabled = true,
    comingSoon = true,
    label = 'Infection',
    teamCount = 1,
    teamSize = {min = 2, max = 16},
    survivorTime = 240,
    warmupTime = 5,
    respawnDelay = 3,
    spawnInvincibility = 2,
    spawnHpArmor = {hp = 200, armor = 100, maxArmor = 100},
    infectedSpeed = 1.35,
    infectedJump = true,
    infectedSlide = true,
    infectedHp = 200,
    infectedHealthRegen = true,
    infectedWeapon = 'WEAPON_KNIFE',
    survivorWeapon = 'WEAPON_PUMPSHOTGUN',
    survivorHp = 100,
    survivorArmor = 0,
    initialInfectedFraction = 0.15,
    allowAttachments = false,
    configurable = {weapon = false, rounds = false, timer = true, armor = false, headshot = false},
}

paintballConfig.gameModes.juggernaut = {
    priority = 65,
    enabled = true,
    comingSoon = true,
    label = 'Juggernaut',
    teamCount = 1,
    teamSize = {min = 2, max = 12},
    matchTime = 480,
    warmupTime = 5,
    respawnDelay = 3,
    spawnInvincibility = 2,
    juggernautHp = 800,
    juggernautArmor = 500,
    juggernautMaxArmor = 500,
    juggernautWeapon = 'WEAPON_COMBATMG_MK2',
    juggernautSecondary = 'WEAPON_GRENADELAUNCHER',
    juggernautSecondaryAmmo = 12,
    juggernautSpeed = 0.85,
    hunterWeapon = 'WEAPON_CARBINERIFLE',
    hunterHp = 200,
    hunterArmor = 100,
    spawnHpArmor = {hp = 200, armor = 100, maxArmor = 100},
    allowAttachments = false,
    configurable = {weapon = false, rounds = false, timer = true, armor = false, headshot = true},
}

paintballConfig.gameModes.gunrotation = {
    priority = 60,
    enabled = true,
    comingSoon = false,
    label = 'Gun Rotation',
    teamCount = 2,
    teamSize = {min = 1, max = 10},
    matchTime = 480,
    rotationInterval = 30,
    scoreToWin = 50,
    warmupTime = 5,
    respawnDelay = 3,
    spawnInvincibility = 2,
    spawnHpArmor = {hp = 200, armor = 25, maxArmor = 98},
    weapons = nil,
    allowAttachments = false,
    configurable = {weapon = false, rounds = false, timer = true, armor = true, headshot = true},
}

paintballConfig.gameModes.escort = {
    priority = 55,
    enabled = true,
    comingSoon = true,
    label = 'Escort',
    teamCount = 2,
    teamSize = {min = 3, max = 10},
    escortTime = 360,
    warmupTime = 5,
    respawnDelay = 5,
    spawnInvincibility = 3,
    vipLives = 3,
    vipHp = 300,
    vipArmor = 150,
    captureTime = 4,
    spawnHpArmor = {hp = 200, armor = 50, maxArmor = 98},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = true, rounds = false, timer = true, armor = true, headshot = true},
}

paintballConfig.gameModes.tournament = {
    priority = 45,
    enabled = true,
    comingSoon = true,
    label = 'Tournament',
    teamCount = 2,
    teamSize = {min = 4, max = 8},
    rounds = {min = 7, max = 13, default = 9},
    roundTime = 150,
    warmupTime = 5,
    endRoundTime = 6,
    bracketSize = 8,
    spawnHpArmor = {hp = 200, armor = 100, maxArmor = 100},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = true, rounds = true, timer = true, armor = true, headshot = true},
}

paintballConfig.gameModes.wavedefense = {
    priority = 35,
    enabled = true,
    comingSoon = true,
    label = 'Wave Defense',
    teamCount = 1,
    teamSize = {min = 1, max = 8},
    waves = 15,
    wavePrepTime = 12,
    startMoney = 600,
    respawn = false,
    downRevive = true,
    reviveTime = 6,
    spawnHpArmor = {hp = 200, armor = 100, maxArmor = 100},
    zombiesPerWave = function(wave, players)
        return math.min(6 + (wave * 5) + (players * 4), 80)
    end,
    zombieSpeed = function(wave) return math.min(0.5 + (wave * 0.05), 1.7) end,
    zombieHp = function(wave) return math.min(150 + (wave * 35), 1500) end,
    moneyPerKill = function(wave) return 50 + (wave * 6) end,
    moneyPerHeadshot = function(wave) return 90 + (wave * 9) end,
    bossEvery = 4,
    bossHpMultiplier = 8,
    zombieModels = {'u_m_y_zombie_01', 'a_m_m_acult_01'},
    bossModels = {'a_m_m_acult_01'},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = false, rounds = false, timer = false, armor = true, headshot = false},
}

paintballConfig.gameModes.survival = {
    priority = 30,
    enabled = true,
    comingSoon = true,
    label = 'Survival Endless',
    teamCount = 1,
    teamSize = {min = 1, max = 4},
    waves = 9999,
    wavePrepTime = 10,
    startMoney = 400,
    respawn = false,
    downRevive = true,
    reviveTime = 8,
    spawnHpArmor = {hp = 200, armor = 100, maxArmor = 100},
    zombiesPerWave = function(wave, players)
        return math.min(10 + (wave * 6) + (players * 4), 120)
    end,
    zombieSpeed = function(wave) return math.min(0.6 + (wave * 0.05), 2.0) end,
    zombieHp = function(wave) return math.min(140 + (wave * 30), 2500) end,
    moneyPerKill = function(wave) return 35 + (wave * 5) end,
    moneyPerHeadshot = function(wave) return 65 + (wave * 8) end,
    bossEvery = 5,
    bossHpMultiplier = 10,
    zombieModels = {'u_m_y_zombie_01', 'a_m_m_acult_01'},
    bossModels = {'a_m_m_acult_01'},
    allowAttachments = true,
    attachmentGroups = {'silencer', 'grip', 'scope', 'flashlight', 'tint'},
    configurable = {weapon = false, rounds = false, timer = false, armor = true, headshot = false},
}

paintballConfig.perkSystem = {
    enabled = true,
    comingSoon = false,
    perksPerPlayer = 3,
    perkDuration = 18,
    perkCooldown = 30,
    activationDelay = 5,   -- seconds after a round goes live before perks can be used
    -- default keys for activating perk slots 1/2/3 (FiveM key names; players can also
    -- rebind them in Settings > Key Bindings > FiveM). change these to set the server default.
    keybinds = {'NUMPAD1', 'NUMPAD2', 'NUMPAD3'},
    perks = {
        {key = 'fast_run', label = 'بوست دو', description = 'سرعت دویدن +۲۵٪', type = 'movement', value = 1.25, comingSoon = false},
        {key = 'high_jump', label = 'پرش بلند', description = 'پرش بلندتر', type = 'jump', value = 1.5, comingSoon = false},
        {key = 'fast_reload', label = 'ریلود سریع', description = 'ریلود فوری', type = 'reload', value = 0.5, comingSoon = true},
        {key = 'low_recoil', label = 'دقت بالا', description = 'ریکویل کمتر', type = 'recoil', value = 0.5, comingSoon = false},
        {key = 'extra_armor', label = 'جلیقه', description = '+۵۰ آرمر', type = 'armor', value = 50, comingSoon = false},
        {key = 'instant_heal', label = 'مدیک', description = 'احیا ۵۰ هلث', type = 'heal', value = 50, comingSoon = false},
        {key = 'stealth', label = 'گوست', description = 'مخفی از رادار', type = 'stealth', value = 1, comingSoon = false},
        {key = 'damage_boost', label = 'بِرسرکر', description = 'دمیج +۲۵٪', type = 'damage', value = 1.25, comingSoon = false},
        {key = 'dead_silence', label = 'سکوت کامل', description = 'صدای پای بی‌صدا', type = 'silent', value = 1, comingSoon = false},
        {key = 'extra_ammo', label = 'اسکوینجر', description = 'تیر فول', type = 'ammo', value = 100, comingSoon = false},
        {key = 'fast_aim', label = 'دست استدی', description = 'ایم‌دان سریع‌تر', type = 'aim', value = 1.4, comingSoon = false},
        {key = 'slide_kick', label = 'اسلاید', description = 'اسلاید فوروارد + بی‌آسیب', type = 'slide', value = 1.3, comingSoon = false},
        {key = 'thermal_vision', label = 'دید حرارتی', description = 'دید حرارتی از داخل دود', type = 'thermal', value = 1, comingSoon = false},
        {key = 'night_vision', label = 'دید در شب', description = 'نایت ویژن — دید کامل در تاریکی', type = 'nightvision', value = 1, comingSoon = false},
    },
}

paintballConfig.killstreaks = {
    enabled = true,
    comingSoon = true,
    requireLobbyToggle = true,
    rewards = {
        [3] = {key = 'uav', label = 'UAV', description = 'دشمن‌ها روی رادار', duration = 30},
        [4] = {key = 'spy_plane', label = 'Spy Plane', description = 'مینی‌مپ دشمن رو خراب می‌کنه', duration = 30},
        [5] = {key = 'care_package', label = 'Care Package', description = 'صندوقه ammo + armor'},
        [7] = {key = 'sentry_gun', label = 'Sentry Gun', description = 'سنتری دفاع می‌کنه'},
        [9] = {key = 'attack_heli', label = 'Attack Heli', description = 'هلیکوپتر جنگی شکار دشمن', duration = 60},
        [10] = {key = 'air_strike', label = 'Air Strike', description = 'حمله هوایی'},
        [12] = {key = 'predator', label = 'Predator Drone', description = 'پهپاد انتحاری — اوپراتور تو هستی', duration = 30},
        [13] = {key = 'ac130', label = 'AC-130', description = 'هواپیمای جنگنده — تو خلبان توپچی', duration = 60},
        [15] = {key = 'tactical_nuke', label = 'Tactical Nuke', description = 'بردن مچ', endsMatch = true},
    },
    uav = {
        helicopterModel = 'buzzard2',
        height = 80.0,
        radius = 200.0,
        speed = 30.0,
        hp = 1500,
        markEnemiesInterval = 2000,
        flyAwayDistance = 600.0,
        flyAwayDuration = 12000,
    },
    airstrike = {
        jetModel = 'strikeforce',
        jetCount = 3,
        jetSpacing = 25.0,
        markerDuration = 60,
        delaySec = 15,
        explosionType = 2,
        explosionCount = 14,
        radius = 12.0,
        warningSound = true,
        flightAltitude = 350.0,
        flightSpeed = 80.0,
        approachDistance = 800.0,
    },
    carePackage = {
        crateModel = 'ch_prop_box_ammo01b',
        crateModelFallbacks = {'prop_box_ammo07a', 'prop_box_ammo04a', 'prop_mil_crate_01'},
        flareModel = 'prop_flare_01a',
        flareDuration = 30000,
        lootDistance = 3.0,
        heliModel = 'buzzard2',
        heliSpawnDistance = 250.0,
        heliAltitude = 75.0,
        heliApproachSpeed = 35.0,
        parachuteModel = 'p_parachute1_s',
        dropFallSpeed = 1.8,
        loot = {
            {key = 'rpg', label = 'RPG Kit', chance = 50},
            {key = 'juggernaut', label = 'Juggernaut Kit', chance = 50},
        },
        rpgKit = {weapon = 'WEAPON_RPG', ammo = 5, secondary = 'WEAPON_COMBATPDW', secondaryAmmo = 250},
        juggernautKit = {
            duration = 30,
            health = 400,
            armor = 250,
            outfit = {
                male = {
                    ['mask_1'] = 122, ['mask_2'] = 0,
                    ['torso_1'] = 314, ['torso_2'] = 0,
                    ['arms'] = 19, ['arms_2'] = 0,
                    ['pants_1'] = 121, ['pants_2'] = 0,
                    ['shoes_1'] = 24, ['shoes_2'] = 0,
                    ['helmet_1'] = 79, ['helmet_2'] = 0,
                    ['bproof_1'] = 8, ['bproof_2'] = 0,
                },
                female = {
                    ['mask_1'] = 122, ['mask_2'] = 0,
                    ['torso_1'] = 327, ['torso_2'] = 0,
                    ['arms'] = 14, ['arms_2'] = 0,
                    ['pants_1'] = 122, ['pants_2'] = 0,
                    ['shoes_1'] = 27, ['shoes_2'] = 0,
                    ['helmet_1'] = 80, ['helmet_2'] = 0,
                    ['bproof_1'] = 8, ['bproof_2'] = 0,
                },
            },
            weapon = 'WEAPON_COMBATMG',
            weaponAmmo = 500,
        },
    },
    sentry = {
        sentryModel = 's_m_y_armymech_01',
        weapon = 'WEAPON_COMBATMG',
        accuracy = 90,
        hp = 2500,
        durationSec = 30,
        spawnForwardOffset = 2.0,
    },
    spyPlane = {
        helicopterModel = 'frogger',
        height = 100.0,
        radius = 250.0,
        speed = 30.0,
        durationSec = 30,
        scrambleStrength = 1.0,
    },
    attackHeli = {
        helicopterModel = 'valkyrie2',
        height = 50.0,
        radius = 120.0,
        speed = 25.0,
        durationSec = 60,
        pilotAccuracy = 80,
        gunnerAccuracy = 95,
        engageDistance = 250.0,
    },
    predator = {
        droneModel = 'shahed136',
        spawnDistance = 400.0,
        spawnAltitude = 150.0,
        explosionType = 4,
        explosionRadius = 18.0,
        explosionDamage = 350,
        durationSec = 30,
        autoExplodeOnCrash = true,
        damageRadius = 22.0,
        cameraOffset = vec3(0.0, -8.0, 3.5),
        hudOverlay = true,
    },
    ac130 = {
        planeModel = 'bombushka',
        height = 250.0,
        radius = 220.0,
        speed = 22.0,
        durationSec = 60,
        gunnerSeat = -2,
        weapon = 'WEAPON_VEHICLE_ROCKET',
    },
    nuke = {
        warningSec = 30,
        explosionType = 21,
        screenFlashIntensity = 0.7,
        cameraShakeAmplitude = 1.5,
    },
}

paintballConfig.spotting = {
    enabled = true,
    duration = 12,
    cooldown = 1.5,
    maxDistance = 400.0,
    removeRadius = 5.0,
    maxMarksPerPlayer = 3,
    color = {r = 255, g = 200, b = 80},
    arrowSize = 0.9,
    groundCircleSize = 1.2,
    drawDistance = 250.0,
    alpha = 200,
    blipSprite = 162,
    blipColour = 5,
    blipScale = 1.1,
    soundEnabled = true,
    soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET',
    soundName = 'WAYPOINT_SET',
}

paintballConfig.preMatchTour = {
    enabled = true,
    duration = 10,
    cameraHeight = 80.0,
    cameraDistance = 60.0,
}

paintballConfig.preMatchCountdown = {
    enabled = true,
    seconds = 7,
    tickSound = true,
    tickSoundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET',
    tickSoundName = 'TIMER_STOP',
    goSoundName = 'CHALLENGE_UNLOCKED',
    goSoundSet = 'HUD_AWARDS',
}

paintballConfig.coopDifficulty = {
    enabled = true,
    default = 'normal',
    levels = {
        easy = {
            hpMultiplier = 0.6,
            countMultiplier = 0.7,
            speedMultiplier = 0.7,
            moneyMultiplier = 1.4,
            label = 'آسان',
        },
        normal = {
            hpMultiplier = 1.0,
            countMultiplier = 1.0,
            speedMultiplier = 1.0,
            moneyMultiplier = 1.0,
            label = 'عادی',
        },
        hard = {
            hpMultiplier = 1.5,
            countMultiplier = 1.3,
            speedMultiplier = 1.15,
            moneyMultiplier = 0.85,
            label = 'سخت',
        },
        insane = {
            hpMultiplier = 2.5,
            countMultiplier = 1.8,
            speedMultiplier = 1.35,
            moneyMultiplier = 0.7,
            label = 'دیوانه',
        },
    },
}

paintballConfig.killstreakTracker = {
    enabled = true,
}

paintballConfig.matchOutro = {
    enabled = true,
    duration = 8,
    cameraOffset = vec3(0.0, -6.0, 3.0),
}

paintballConfig.cosmetics = {
    enabled = true,
    callingCards = {
        {key = 'default', label = 'پیش‌فرض', color = '#7c3aed'},
        {key = 'gold', label = 'طلایی', color = '#ffc850'},
        {key = 'red_skull', label = 'جمجمه قرمز', color = '#ff4060'},
        {key = 'blue_wings', label = 'بال آبی', color = '#5cb6ff'},
        {key = 'phoenix', label = 'ققنوس', color = '#ff6e00'},
        {key = 'ghost', label = 'روح', color = '#9ca3af'},
        {key = 'venom', label = 'سم', color = '#4eda94'},
        {key = 'crown', label = 'تاج', color = '#e7c349'},
    },
    emblems = {
        {key = 'default', label = 'پیش‌فرض', icon = '◆'},
        {key = 'star', label = 'ستاره', icon = '★'},
        {key = 'skull', label = 'جمجمه', icon = '☠'},
        {key = 'lightning', label = 'صاعقه', icon = '⚡'},
        {key = 'fire', label = 'آتش', icon = '🔥'},
        {key = 'crown', label = 'تاج', icon = '♛'},
        {key = 'sword', label = 'شمشیر', icon = '⚔'},
        {key = 'target', label = 'هدف', icon = '◎'},
    },
    killBanners = {
        {key = 'default', label = 'ساده', anim = 'fade'},
        {key = 'slam', label = 'ضربه', anim = 'slam'},
        {key = 'glitch', label = 'گلیچ', anim = 'glitch'},
        {key = 'pulse', label = 'پالس', anim = 'pulse'},
        {key = 'flash', label = 'فلش', anim = 'flash'},
    },
    weaponSkins = {
        {key = 'default', label = 'پیش‌فرض', tint = 0},
        {key = 'classic', label = 'کلاسیک', tint = 1},
        {key = 'gold', label = 'طلایی', tint = 4},
        {key = 'gray', label = 'خاکستری', tint = 5},
        {key = 'platinum', label = 'پلاتین', tint = 7},
    },
}

paintballConfig.matchHistory = {
    enabled = true,
    maxStored = 25,
}

paintballConfig.hardcoreMode = {
    enabled = true,
    comingSoon = true,
    hideHud = true,
    hideMinimap = true,
    hideKillfeed = true,
    hideHitmarker = true,
    hideHealth = true,
    hideTeammateBlips = true,
    hideTeammateNames = true,
    damageMultiplier = 2.5,
    armorMultiplier = 0.5,
    spawnHp = 100,
    spawnArmor = 0,
    disableSpawnProtection = true,
    disableKillstreaksUI = true,
    label = 'حالت هاردکور',
    description = 'بدون HUD، بدون مینی‌مپ، دمیج واقعی — حتی یارها رو نمی‌بینی',
}

paintballConfig.equipment = {
    enabled = true,
    comingSoon = true,
    items = {
        {key = 'WEAPON_SMOKEGRENADE', label = 'نارنجک دودی', count = 2},
        {key = 'WEAPON_FLARE', label = 'فلر', count = 3},
        {key = 'WEAPON_GRENADE', label = 'نارنجک', count = 2},
        {key = 'WEAPON_MOLOTOV', label = 'مولوتوف', count = 2},
        {key = 'WEAPON_STICKYBOMB', label = 'بمب چسبان', count = 2},
        {key = 'WEAPON_PROXMINE', label = 'مین', count = 2},
        {key = 'WEAPON_BZGAS', label = 'گاز BZ', count = 2},
        {key = 'WEAPON_PIPEBOMB', label = 'پایپ بمب', count = 1},
        {key = 'WEAPON_FIREEXTINGUISHER', label = 'کپسول آتش‌نشانی', count = 1},
        {key = 'WEAPON_FLAREGUN', label = 'تفنگ فلر', count = 6},
    },
}

paintballConfig.spawnProtection = {
    enabled = true,
    invincibleSeconds = 2,
    cancelOnFire = true,
    cancelOnMove = false,
    visualEffect = true,
}

paintballConfig.multikillWindow = 3.5
paintballConfig.multikillLabels = {
    [2] = 'Double Kill',
    [3] = 'Triple Kill',
    [4] = 'Quad Kill',
    [5] = 'Penta Kill',
    [6] = 'Mega Kill',
    [7] = 'Ultra Kill',
    [8] = 'Godlike',
}

paintballConfig.assist = {
    enabled = true,
    timeWindow = 6,
    minDamage = 25,
}

paintballConfig.autoBalance = {
    enabled = true,
    triggerDifference = 2,
}

paintballConfig.mapVoting = {
    enabled = true,
    votingTime = 12,
    optionsPerVote = 3,
}

paintballConfig.readyCheck = {
    enabled = true,
    timeout = 30,
}

paintballConfig.adminSoloStart = {
    enabled = true,
    permissionLevel = 20,
    skipFee = true,
    skipMinPlayers = true,
    skipReadyCheck = true,
    label = 'Admin Solo Start',
}

paintballConfig.debug = false

paintballConfig.party = {
    enabled = true,
    maxSize = 6,
}

paintballConfig.ranked = {
    enabled = false,
    placementMatches = 5,
    seasonId = 1,
    mmrK = 24,
    mmrFloor = 0,
    mmrCeiling = 5000,
    promotionThresholds = {
        bronze = 0,
        silver = 1000,
        gold = 1750,
        platinum = 2500,
        diamond = 3300,
        elite = 4200,
    },
}

paintballConfig.xpSystem = {
    enabled = false,
    perKill = 25,
    perAssist = 10,
    perWin = 100,
    perObjective = 50,
    perMVP = 75,
    perMatch = 30,
    levels = {
        levelCap = 200,
        baseXP = 1000,
        growth = 1.08,
    },
}

paintballConfig.missions = {
    enabled = false,
    daily = {
        {key = 'daily_kills', label = '20 kill bezan', target = 20, reward = 200},
        {key = 'daily_wins', label = '3 match bebar', target = 3, reward = 300},
        {key = 'daily_headshots', label = '10 headshot bezan', target = 10, reward = 250},
    },
    weekly = {
        {key = 'weekly_matches', label = '20 match bazi kon', target = 20, reward = 1500},
        {key = 'weekly_kills', label = '150 kill bezan', target = 150, reward = 2000},
    },
}

paintballConfig.tournaments = {
    enabled = false,
    bracketSize = 8,
    bestOf = 3,
    autoSeed = true,
    rewardPool = 50000,
}

paintballConfig.practiceArena = {
    enabled = true,
    comingSoon = true,
    map = 'rocky',
    weapon = 'WEAPON_PISTOL',
}

paintballConfig.aimTrainer = {
    enabled = true,
    comingSoon = true,
    map = 'rocky',
    targetCount = 20,
    targetLifetime = 4,
    targetRespawn = 1,
}

paintballConfig.ui = {
    primaryColor = '#ff6e00',
    primaryDeep = '#cc4f00',
    accentNavy = '#0a1424',
    accentDark = '#1a1a1a',
    glow = '#ff8a3c',
    showHitmarker = true,
    showDamageNumbers = true,
    showMultikillBanner = true,
    enableKillFeedAvatar = false,
    enableMinimapHints = true,
}

paintballConfig.performance = {
    serverTickInterval = 250,
    clientHudUpdateInterval = 200,
    matchSnapshotInterval = 1000,
    enableScoreboardLazyLoad = true,
}

paintballConfig.maps = paintballConfig.maps or {}
if paintballConfig.maps.bank then
    paintballConfig.maps.bank.dominationPoints = {
        {label = 'A', coords = vec3(246.29, 221.8, 106.29)},
        {label = 'B', coords = vec3(249.06, 217.72, 106.29)},
        {label = 'C', coords = vec3(235.15, 173.08, 105.16)},
    }
    paintballConfig.maps.bank.kothHill = {coords = vec3(249.06, 217.72, 106.29), radius = 6.0}
    paintballConfig.maps.bank.escortRoute = {
        vec3(246.29, 221.8, 106.29),
        vec3(249.06, 217.72, 106.29),
        vec3(235.15, 173.08, 105.16),
    }
end
if paintballConfig.maps.dust1 then
    paintballConfig.maps.dust1.dominationPoints = {
        {label = 'A', coords = vec3(2908.38, 1299.11, 7.08)},
        {label = 'B', coords = vec3(2943.84, 1355.08, 59.69)},
        {label = 'C', coords = vec3(2994.03, 1377.18, 4.91)},
    }
    paintballConfig.maps.dust1.kothHill = {coords = vec3(2943.84, 1355.08, 59.69), radius = 8.0}
    paintballConfig.maps.dust1.escortRoute = {
        vec3(2908.38, 1299.11, 7.08),
        vec3(2943.84, 1355.08, 59.69),
        vec3(2994.03, 1377.18, 4.91),
    }
end
if paintballConfig.maps.dust2 then
    paintballConfig.maps.dust2.dominationPoints = {
        {label = 'A', coords = vec3(2911.96, 1269.02, 3.59)},
        {label = 'B', coords = vec3(2886.87, 1243.4, 76.8)},
        {label = 'C', coords = vec3(2862.9, 1203.69, 9.99)},
    }
    paintballConfig.maps.dust2.kothHill = {coords = vec3(2886.87, 1243.4, 76.8), radius = 8.0}
end
if paintballConfig.maps.army then
    paintballConfig.maps.army.dominationPoints = {
        {label = 'A', coords = vec3(-1983.68, 3292.82, 32.92)},
        {label = 'B', coords = vec3(-1960.52, 3325.8, 32.96)},
        {label = 'C', coords = vec3(-1922.25, 3351.74, 32.9)},
    }
    paintballConfig.maps.army.kothHill = {coords = vec3(-1960.52, 3325.8, 32.96), radius = 7.0}
end
