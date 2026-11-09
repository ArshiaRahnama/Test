-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

Config.Debug = false

function DebugPrint(...)
    if not Config.Debug then return end
    print(...)
end
Config.Core = "ESX"
Config.OpenPhone = 'F1'
Config.RepeatTimeout = 3000
Config.CallRepeats = 5

-- AirDrop contact sharing
Config.AirDrop = {
    -- How close (meters) the other player must be to receive your AirDrop.
    Range = 5.0,
    -- How long (in MILLISECONDS) a player must wait between AirDrop sends.
    -- 5 minutes by default. Set lower for testing.
    Cooldown = 5 * 60 * 1000,
}

-- Image upload center. Discord is blocked/filtered in Iran, so camera photos
-- are uploaded to our own self-hosted endpoint instead of a Discord webhook.
-- screenshot-basic POSTs the photo as multipart form field `file`; the server
-- replies with JSON: { "url": "https://<cdn>/<uuid>.png" }.
-- (Equivalent of:  curl -F "file=@photo.png" https://phone-upload.sunrp.ir/index.php )
Config.UploadUrl = 'https://phone-upload.sunrp.ir/index.php'

-- Daily Lottery (بخت آزمایی). All live state is kept IN MEMORY server-side and
-- a pre-built snapshot is served on app-open (ZERO DB queries per open — see
-- server/feature/lottery.lua), so it stays cheap even at 1600+ players.
Config.Lottery = {
    -- Price of ONE ticket. Each player may buy at most ONE per day.
    TicketPrice = 10000,
    -- Daily draw time, in the SERVER's local clock (os.date). 18 = 6 PM.
    -- Ticket sales are open from midnight until this time; the draw runs then.
    DrawHour = 0,
    DrawMinute = 15,
    -- Which account the TICKET is paid FROM: 'bank' or 'money' (cash).
    -- The PRIZE is always deposited to the winner's BANK (works while offline).
    Account = 'bank',
    -- House cut (%) skimmed off the pot before paying the winner.
    -- 0 = winner takes the WHOLE pot (participants × TicketPrice).
    HouseCutPercent = 0,
    -- Minimum participants for a draw to run. Keep at 1 so a lone buyer is
    -- never left out of pocket (with a 0% cut they simply get their stake back).
    MinParticipants = 1,
    TaxPercent = 9,
}

Config.Website = {
    Url = 'https://sunrp.ir/gallery',
    Name = 'Sun RP',
}

Config.Tweeter = {
    Job = 'taxi',
    AdminPerm = 20,
    Cost = 10000,
    RewardPerApprove = 3000,
    Account = 'bank',
    PostCooldown = 180,
    ReviewCooldown = 180,
    PendingExpire = 600,
    PendingPageSize = 15,
    FeedPageSize = 15,
    MaxPosts = 200,
    MaxContentLength = 300,
}

Config.Ads = {
    AdminPerm = 20,
    PostCooldown = 240,
    ReviewCooldown = 240,
    PendingExpire = 600,
    PendingPageSize = 15,
    FeedPageSize = 15,
}

Config.News = {
    Jobs = { 'weazel', 'taxi' },
    AdminPerm = 20,
    Cost = 25000,
    RewardPerApprove = 0,
    Account = 'bank',
    PostCooldown = 300,
    ApproveCooldown = 8 * 3600,
    PendingExpire = 24 * 3600,
    PendingPageSize = 15,
    FeedPageSize = 15,
    MaxFeed = 300,
    MaxTitleLength = 120,
    MaxContentLength = 1000,
}

Config.App = {
    Phone = {
        Name = "Phone"
    },
    Ads = {
        Name = "Ads"
    },
    Tweeter = {
        Name = "Tweeter"
    },
    Services = {
        Name = "Services"
    },
    Message = {
        Name = "Message"
    },
    Wallet = {
        Name = "Wallet"
    },
}

Config.MsgSignalZone = "No Signal"

Config.Signal = {
    IsUse = false,
    DefaultSignalZones = "FULL_SIGNAL",
    Zones = {
        ["FULL_SIGNAL"] = {
            CenterCoords = vec3(49.58, -1560.84, 29.38),
            Radius = 3,
            ChanceSignal = 1 -- MAX = 1
        },
        ["0_SIGNAL_1"] = {
            CenterCoords = vec3(47.71, -1536.74, 29.29),
            Radius = 3,
            ChanceSignal = 0.0
        },
        ["1_SIGNAL_1"] = {
            CenterCoords = vec3(42.48, -1543.57, 29.27),
            Radius = 3,
            ChanceSignal = 0.25
        },
        ["2_SIGNAL_1"] = {
            CenterCoords = vec3(37.75, -1548.99, 29.28),
            Radius = 3,
            ChanceSignal = 0.5
        },
        ["3_SIGNAL_1"] = {
            CenterCoords = vec3(43.09, -1555.95, 29.28),
            Radius = 3,
            ChanceSignal = 0.75
        }
    }
}

Config.Services = {
    goverment = {
        job = "goverment",
        name = "Goverment",
        type = "General"
    },
    police = {
        job = "police",
        name = "Police",
        type = "General"
    },
    ambulance = {
        job = "ambulance",
        name = "Ambulance",
        type = "Health"
    },
    realestate = {
        job = "realestate",
        name = "Real Estate",
        type = "Property"
    },
    taxi = {
        job = "taxi",
        name = "Taxi",
        type = "Transport"
    },
    burgershot = {
        job = "burgershot",
        name = "Burger Shot",
        type = "Food"
    },
    kfc = {
        job = "kfc",
        name = "KFC",
        type = "Food"
    },
}