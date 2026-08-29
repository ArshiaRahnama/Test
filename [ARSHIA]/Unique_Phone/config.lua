Config = {}

-- EXPANSION: the in-game RP phone number (used for contacts/calls/
-- WhatsApp/Twitter within Unique_Phone) now looks like a real Iranian
-- mobile number instead of a generic "052-XXXXXXXX" placeholder — pick
-- from real Iranian mobile operator prefixes for immersion. This is
-- SEPARATE from the real phone number players type into Unique_Login for
-- SMS verification — that one must stay a real, working number and is
-- never touched here.
Config.PhoneNumberPrefixes = {
    "0911", "0912", "0913", "0914", "0915", "0916", "0917", "0918", "0919", -- Hamrah-e Avval
    "0901", "0902", "0903", "0905",                                        -- Hamrah-e Avval (newer)
    "0930", "0933", "0935", "0936", "0937", "0938", "0939",                -- Irancell
    "0920", "0921", "0922",                                                -- RighTel
}
Config.RepeatTimeout = 500
Config.CallRepeats = 120
Config.OpenPhone = 288

Config.Language = 'en'
-- No longer used: the phone camera now saves photos as base64 directly
-- (via screenshot-basic's requestScreenshot) instead of uploading to this
-- webhook, so there's nothing left to configure here for photos to work.
Config.webhooksscreenshot = "https://arshiahub.ir/changemesasdds/1324462146993520752/-m1nDasTidW9-WDKDCJGQ-dy_D5mEwyb65zE3Xk4wVVyrqKm_YmtSvqjC_NIAbWYGep6"
Config.Tokovoip = false
Config.Job = ''
Config.UseESXLicense = true
Config.UseESXBilling = true

Config.Languages = {
    ['en'] = {
        ["NO_VEHICLE"] = "Hich vasile naghliyei dar atrof nist!",
        ["NO_ONE"] = "Hich kasi dar atrof nist!",
        ["ALLFIELDS"] = "Hame field-ha bayad por shavand!",

        ["RACE_TITLE"] = "Mosabeghe",

        ["WHATSAPP_TITLE"] = "Whatsapp",
        ["WHATSAPP_NEW_MESSAGE"] = "Payame jadid az",
        ["WHATSAPP_MESSAGE_TOYOU"] = "Payame jadid darid",
        ["WHATSAPP_LOCATION_SET"] = "Moghiyat tanzim shod!",
        ["WHATSAPP_SHARED_LOCATION"] = "Moghiyat be eshterak gozashte shod",
        ["WHATSAPP_BLANK_MSG"] = "Nemitooni payam khali ersal koni!",

        ["MAIL_TITLE"] = "Email",
        ["MAIL_NEW"] = "Shoma ye email jadid daryaft kardid az: ",

        ["ADVERTISEMENT_TITLE"] = "Safahat Zard",
        ["ADVERTISEMENT_NEW"] = "Ye agahi jadid dar safahat zard montasher shod!",
        ["ADVERTISEMENT_EMPY"] = "Bayad ye payam vared konid!",

        ["TWITTER_TITLE"] = "Twitter",
        ["TWITTER_NEW"] = "Tweet jadid",
        ["TWITTER_POSTED"] = "Tweet ersal shod!",
        ["TWITTER_GETMENTIONED"] = "Shoma dar ye tweet mention shodid!",
        ["MENTION_YOURSELF"] = "Nemitooni khodet ro mention koni!",
        ["TWITTER_ENTER_MSG"] = "Bayad ye payam vared koni!",

        ["PHONE_DONT_HAVE"] = "Shoma goshi nadarid!",
        ["PHONE_TITLE"] = "Rahnama",
        ["PHONE_CALL_END"] = "Tamas payan yaft",
        ["PHONE_NOINCOMING"] = "Hich tamas voroodi nadarid!",
        ["PHONE_STARTED_ANON"] = "Ye tamas nashenas aghaz kardid!",
        ["PHONE_BUSY"] = "Shoma dar hal hazer mashghool hastid!",
        ["PHONE_PERSON_TALKING"] = "In shakhs dar hal sohbat hast!",
        ["PHONE_PERSON_UNAVAILABLE"] = "In shakhs dar dastres nist!",
        ["PHONE_YOUR_NUMBER"] = "Nemitooni be khodet zang bezani!",
        ["PHONE_MSG_YOURSELF"] = "Nemitooni be khodet payam bedi!",

        ["CONTACTS_REMOVED"] = "In mokhatab hazf shod!",
        ["CONTACTS_NEWSUGGESTED"] = "Ye mokhatab pishnahadi jadid dari!",
        ["CONTACTS_EDIT_TITLE"] = "Virayesh Mokhatab",
        ["CONTACTS_ADD_TITLE"] = "Rahnam",

        ["BANK_TITLE"] = "Bank",
        ["BANK_DONT_ENOUGH"] = "Shoma pool kafi nadarid!",
        ["BANK_NOIBAN"] = "Hich IBAN baraye in shakhs sabt nashode ast!",

        ["CRYPTO_TITLE"] = "Crypto",

        ["GPS_SET"] = "Moghiyat GPS tanzim shod: ",

        ["NUI_SYSTEM"] = "System",
        ["NUI_NOT_AVAILABLE"] = "Dar dastres nist!",
        ["NUI_MYPHONE"] = "Shomare telefon",
        ["NUI_INFO"] = "Ettela'at",

        ["SETTINGS_TITLE"] = "Tanzimat",
        ["PROFILE_SET"] = "Aks profile tanzim shod!",
        ["POFILE_DEFAULT"] = "Aks profile be halat pishfarz bazneshani shod!",
        ["BACKGROUND_SET"] = "Paszamine tanzim shod!",

        ["MEOS_TITLE"] = "MEOS",
        ["MEOS_CLEARED"] = "Hame notification-ha hazf shodand!",
        ["MEOS_GPS"] = "In payam moghiyat GPS nadarad!",
        ["MEOS_NORESULT"] = "Natijei yaft nashod!"

	},

}

Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Phone",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Whatsapp",
        tooltipPos = "top",
        style = "font-size: 2.8vh";
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Bank",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 3,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Settings",
        tooltipPos = "top",
        style = "padding-right: .08vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#575fcf",
        icon = "fas fa-warehouse",
        tooltipText = "Vehicles",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 5,
        Alerts = 0,
    },
    ["polices"] = {
        app = "polices",
        color = "#00FF95",
        icon = "fas fa-building",
        tooltipText = "Services",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 6,
        Alerts = 0,
    },

    ["gallery"] = {
        app = "gallery",
        color = "#AC1D2C",
        icon = "fas fa-images",
        tooltipText = "Gallery",

        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },
    ["camera"] = {
        app = "camera",
        color = "#AC1D2C",
        icon = "fas fa-camera",
        tooltipText = "Camera",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 8,
        Alerts = 0,
    },

    ["security"] = {
        app = "security",
        color = "#00c9a7",
        icon = "fas fa-shield-alt",
        tooltipText = "Security",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 9,
        Alerts = 0,
    },

    ["browser"] = {
        app = "browser",
        color = "#4285F4",
        icon = "fas fa-globe",
        tooltipText = "Browser",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 10,
        Alerts = 0,
    },








































































}