Config = {}

Config.selfBlip = true
Config.useRflxMulti = false
Config.useBaseEvents = false
Config.prints = false

Config.font = {
    useCustom = false,
    name = 'Russo One',
}
Config.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'OnDuty',
    offDutyText = 'OffDuty',
}
Config.blipGroup = {
    renameGroup = false,
    groupName = '~b~Other units'
}

Config.bigmapTags = false
Config.blipCone = true

Config.useCharacterName = true
Config.usePrefix = false
Config.namePrefix = {
}

local DOJ_JOBS   = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' }
local LE_JOBS     = { 'police', 'sheriff', 'mt' }
local ORGAN_JOBS  = { 'taxi', 'mechanic', 'ambulance', 'weazel' }

local function toSet(list)
    local set = {}
    for _, v in ipairs(list) do set[v] = true end
    return set
end

local DOJ_SET, LE_SET, ORGAN_SET = toSet(DOJ_JOBS), toSet(LE_JOBS), toSet(ORGAN_JOBS)

local ALL_JOBS = {}
for _, j in ipairs(DOJ_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
for _, j in ipairs(LE_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
for _, j in ipairs(ORGAN_JOBS) do ALL_JOBS[#ALL_JOBS + 1] = j end
local ALL_SET = toSet(ALL_JOBS)

local JOB_BLIPS = {

    cid     = { pedSprite = 60,  vehSprite = 56,  color = 18 },
    cia     = { pedSprite = 60,  vehSprite = 56,  color = 0  },
    fbi     = { pedSprite = 484, vehSprite = 56,  color = 40 },
    marshal = { pedSprite = 60,  vehSprite = 56,  color = 8  },
    judge   = { pedSprite = 60,  vehSprite = 56,  color = 9  },
    doa     = { pedSprite = 60,  vehSprite = 56,  color = 2  },

    police  = { pedSprite = 60,  vehSprite = 56,  color = 29 },
    sheriff = { pedSprite = 58,  vehSprite = 56,  color = 28 },
    mt      = { pedSprite = 480, vehSprite = 225, color = 40 },

    taxi      = { pedSprite = 198, vehSprite = 198, color = 46 },
    mechanic  = { pedSprite = 402, vehSprite = 225, color = 56 },
    ambulance = { pedSprite = 1,   vehSprite = 225, color = 1  },
    weazel    = { pedSprite = 402, vehSprite = 225, color = 31 },
}

Config.emergencyJobs = {}

for _, job in ipairs(ALL_JOBS) do
    local canSee

    if DOJ_SET[job] then
        canSee = toSet(ALL_JOBS)
    elseif LE_SET[job] then
        canSee = toSet(LE_JOBS)
        canSee['ambulance'] = true
    else
        canSee = { [job] = true }
    end

    local b = JOB_BLIPS[job]
    Config.emergencyJobs[job] = {
        ignoreDuty = true,
        blip = {
            sprite = b.pedSprite,
            color = b.color,
            flashColors = { 59, b.color },
        },
        vehBlip = {
            ['default'] = { sprite = b.vehSprite, color = b.color },
        },
        canSee = canSee,
    }
end
