--[[
    license_config.lua
    License / permit type definitions (driving, hunting, weapons, marriage, etc.)
    Loaded on both client and server (added to fxmanifest.lua in both lists).

    Job names matched to your server's actual job groups (from
    notejobserver.txt):
      Law Enforcement        -> police, sheriff, mt
      Department Of Justice  -> cid, cia, marshal, fbi, judge, doa
      Organ Services         -> taxi, mechanic, medic, weazel

    Mapping decisions made (no "detective" or "ambulance"/"justice" job exists
    on your server, so these had to be re-pointed):
      - old 'detective' -> 'mt'    (the third Law Enforcement job)
      - old 'ambulance' -> 'medic' (Organ Services' medical job)
      - old 'justice'   -> 'judge' (marriage/custody/ceremony are court
        functions)

    Latest changes:
      - 'firstaid' license type removed entirely.
      - Every Department Of Justice job (cid, cia, marshal, fbi, doa, judge)
        now has full add/view/remove access on every remaining license type
        EXCEPT 'salamateravan', which keeps 'medic'-only add/remove (per your
        instruction that everything but that one gets full DOJ access).
]]

licenseConfig = {

    licenses = {
        ['drive_1'] = { -- GovahiName Mashin
            label = 'GovahiName Mashin',
            timing = { permanent = true, time = {1, 30} },
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_2'] = { -- GovahiName Motor
            label = 'GovahiName Motor',
            timing = { permanent = true, time = {1, 30} },
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_3'] = { -- GovahiName Kamiun
            label = 'GovahiName Kamiun',
            timing = { permanent = true, time = {1, 30} },
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_4'] = { -- Ayin Name Ranandegi
            label = 'Ayin Name Ranandegi',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_5'] = { -- Govahi Name khalabani
            label = 'GovahiName khalabani',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['taxi'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_6'] = { -- Govahi Name Ghayegh
            label = 'GovahiName Ghayegh',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['taxi'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['drive_7'] = { -- Govahi Name Heli
            label = 'GovahiName Heli',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['taxi'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['hunt_l1'] = { -- Mojaveze Shekar
            label = 'Mojaveze Shekar',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['stepson_1'] = { -- Sanade Farzand Khandegi
            label = 'Sanade Farzand Khandegi',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            viewAccess   = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            removeAccess = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true }
        },

        ['marriage_1'] = { -- Sanade Ezdevaj
            label = 'Sanade Ezdevaj',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            viewAccess   = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            removeAccess = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true }
        },

        ['ceremony_1'] = { -- Bargozari Marasem
            label = 'Bargozari Marasem',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            viewAccess   = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true },
            removeAccess = { ['judge'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true }
        },

        ['mojavezgun_1'] = { -- Mojaveze hamle aslahe
            label = 'Mojaveze hamle aslahe',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },

        ['salamateravan'] = { -- Govahi Salamate Ravan
            label = 'Govahi Salamate Ravan',
            timing = { permanent = true, time = {1, 30} },
            description = true,
            addAccess    = { ['medic'] = true },
            viewAccess   = { ['medic'] = true, ['police'] = true, ['sheriff'] = true, ['judge'] = true, ['taxi'] = true, ['mechanic'] = true, ['mt'] = true, ['fbi'] = true },
            removeAccess = { ['medic'] = true }
        },

        ['mojavezvest_1'] = { -- Mojaveze vest
            label = 'Mojaveze pooshidane vest',
            timing = { permanent = false, time = {1, 30} },
            description = true,
            addAccess    = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            viewAccess   = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true },
            removeAccess = { ['police'] = true, ['sheriff'] = true, ['mt'] = true, ['cid'] = true, ['cia'] = true, ['marshal'] = true, ['fbi'] = true, ['doa'] = true, ['judge'] = true }
        },
    }
}
