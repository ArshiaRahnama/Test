--[[
    K9 menu - built entirely on ox_lib's context menu (lib.registerContext / lib.showContext).
    menuv support has been fully removed; this is the only menu system now.

    Removed at your request (unused/filler features, underlying functions in
    client.lua were left untouched in case you want them back later):
      - Play (Ball / Fetch)
      - House (Place House / Go Into House)
]]

local lang, animations, dogs = CFG.LANG, CFG.DOG_ANIMATIONS, CFG.DOGS

-- one accent color per section instead of a single flat color everywhere
local COLORS = {
    core        = CFG.MENU.color or '#7A0BC0', -- spawn / follow / vehicle / reselect
    search      = '#F59E0B',
    track       = '#06B6D4',
    care        = '#22C55E',
    other       = '#EC4899',
    anim        = '#3B82F6',
    camera      = '#EAB308',
    appearance  = '#A855F7',
}

-------------------------------------------------------------------
-- shared helpers
-------------------------------------------------------------------

-- plays a CFG.DOG_ANIMATIONS entry on the dog (shared by the "Other > Animations"
-- submenu and the standalone /k9animations menu, instead of two copies of this logic)
local function playDogAnimation(animData)
    if action.feeding or action.searching or action.following or action.fetching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end
    if IsPedInAnyVehicle(dog_ent) then return end

    if animData.dict == "creatures@rottweiler@getup" then
        if IsEntityPlayingAnim(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 3) then
            if not DOG_FOLLOWS_ORDER() then return end
            PlayAnimation(dog_ent, animData.dict, animData.anim, animData.flags)
        end
    elseif animData.anim == "beg_enter" then
        if not DOG_FOLLOWS_ORDER() then return end
        PlayAnimation(dog_ent, animData.dict, animData.anim, animData.flags)
        Wait(500)
        PlayAnimation(dog_ent, animData.dict, "beg_loop", 1)
    elseif animData.anim == "paw_right_enter" then
        if not DOG_FOLLOWS_ORDER() then return end
        PlayAnimation(dog_ent, animData.dict, animData.anim, animData.flags)
        Wait(500)
        PlayAnimation(dog_ent, animData.dict, "paw_right_loop", 1)
    elseif animData.anim == "petting_chop" then
        if #(GetEntityCoords(cache.ped) - GetEntityCoords(dog_ent)) < 1.25 then
            SetEntityHeadingLookAt(cache.ped, dog_ent)
            SetEntityHeadingLookAt(dog_ent, cache.ped)

            PlayAnimation(cache.ped, animData.dict, "petting_franklin", 2)
            PlayAnimation(dog_ent, animData.dict, "petting_chop", 2)
            Wait(4000)
            ClearPedTasks(cache.ped)
            ClearPedTasks(dog_ent)
        else
            Notify(lang.dog_not_close .. '!', "error", 3000)
        end
    elseif animData.anim == 'sit_enter' then
        if IsEntityPlayingAnim(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 3) then
            PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_exit", 2)
        else
            PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 2)
        end
    elseif animData.anim == 'sleep_in_kennel' then
        if IsEntityPlayingAnim(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 3) then
            PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "exit_kennel", 2)
        else
            PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
        end
    else
        if not DOG_FOLLOWS_ORDER() then return end
        PlayAnimation(dog_ent, animData.dict, animData.anim, animData.flags)
    end
end

-------------------------------------------------------------------
-- register dog
-------------------------------------------------------------------

local function buildRegisterMenu()
    local options = {}
    for name, spawnName in pairs(dogs) do
        options[#options + 1] = {
            title = name,
            description = lang.breed,
            icon = 'dog',
            iconColor = COLORS.core,
            onSelect = function()
                REGISTER_K9(name, spawnName)
            end
        }
    end

    lib.registerContext({
        id = 'k9_register',
        title = lang.register_header,
        options = options
    })
end

function OPEN_REGISTRATION()
    if dogAmount >= CFG.SETTINGS.MAX_DOGS then
        Notify(string.format(lang.max_limit, CFG.SETTINGS.MAX_DOGS), "error", 5000)
        return
    end
    lib.showContext('k9_register')
end

-------------------------------------------------------------------
-- reselect (dynamic list of the player's registered dogs)
-------------------------------------------------------------------

local function openSelection()
    local result = lib.callback.await('sh-k9:CB:GET_DOGS', false)
    if not result or not next(result) then
        OPEN_REGISTRATION()
        return
    end

    dogAmount = #result

    local options = {}
    for _, v in pairs(result) do
        options[#options + 1] = {
            title = v.dogName,
            description = v.dogBreed,
            icon = 'dog',
            iconColor = COLORS.core,
            arrow = true,
            onSelect = function()
                data = v
                dog_id = v.id
                OPEN_K9_MENU()
            end
        }
    end

    lib.registerContext({
        id = 'k9_reselect',
        title = lang.select_dog,
        options = options
    })

    lib.showContext('k9_reselect')
end

-------------------------------------------------------------------
-- appearance (dynamic list of components on the current dog)
-------------------------------------------------------------------

local function saveAppearance()
    local appearance = GET_CURRENT_APPEARANCE()
    if appearance then data.appearance = appearance end
    TriggerServerEvent('sh-k9:sv:SaveDog', data, dog_id, appearance)
end

local function openAppearanceEditor()
    local components = GET_AVAILABLE_APPEARANCE()
    if not components then return end

    local options = {}
    for _, v in pairs(components) do
        options[#options + 1] = {
            title = ('Component %s'):format(v.componentId),
            description = ('Drawable %s \226\128\162 %s textures'):format(v.drawableId, v.totalTextures),
            icon = 'shirt',
            iconColor = COLORS.appearance,
            onSelect = function()
                local textures = (v.totalTextures ~= 0 and math.random(1, v.totalTextures) - 1) or v.totalTextures - 1
                local palette = math.random(1, 3)
                local curTexture = GetPedTextureVariation(dog_ent, v.componentId)

                if textures == curTexture then
                    textures = (v.totalTextures ~= 0 and math.random(1, v.totalTextures) - 1) or v.totalTextures - 1
                end

                SetPedComponentVariation(dog_ent, v.componentId, v.drawableId, textures, palette)
            end
        }
    end

    lib.registerContext({
        id = 'k9_appearance',
        title = lang.change_appearance,
        menu = 'k9_appearance_menu',
        onBack = saveAppearance,
        onExit = saveAppearance,
        options = options
    })

    lib.showContext('k9_appearance')
end

-------------------------------------------------------------------
-- animations (shared between /k9animations and Other > Animations)
-------------------------------------------------------------------

local function buildAnimationsMenu(parentMenu)
    local options = {}
    for _, v in ipairs(animations) do
        options[#options + 1] = {
            title = v.name,
            icon = 'video',
            iconColor = COLORS.anim,
            onSelect = function() playDogAnimation(v) end
        }
    end

    lib.registerContext({
        id = 'k9_animations',
        title = lang.animations,
        menu = parentMenu,
        options = options
    })
end

function OPEN_ANIMATIONS()
    if not data or not next(data) then
        openSelection()
        return
    end
    lib.showContext('k9_animations')
end

-------------------------------------------------------------------
-- static submenus
-------------------------------------------------------------------

local function buildSearchMenu()
    lib.registerContext({
        id = 'k9_search',
        title = lang.search_desc,
        menu = 'k9_main',
        options = {
            {
                title = lang.search_ped,
                description = 'Sniff nearby players for hidden items',
                icon = 'user-secret',
                iconColor = COLORS.search,
                onSelect = SEARCH_PLAYER
            },
            {
                title = lang.search_veh,
                description = 'Sniff the trunk of the nearest vehicle',
                icon = 'car-side',
                iconColor = COLORS.search,
                onSelect = SEARCH_VEHICLE
            }
        }
    })
end

local function buildTrackMenu()
    lib.registerContext({
        id = 'k9_track',
        title = lang.track,
        menu = 'k9_main',
        options = {
            {
                title = lang.track_player,
                description = 'Track a specific player by ID',
                icon = 'crosshairs',
                iconColor = COLORS.track,
                onSelect = TRACKING_PLAYER
            },
            {
                title = lang.find_tracks,
                description = 'Sniff out the nearest scent trail',
                icon = 'shoe-prints',
                iconColor = COLORS.track,
                onSelect = TRACKING_ALL
            }
        }
    })
end

local function buildCareMenu()
    lib.registerContext({
        id = 'k9_care',
        title = lang.heal_desc,
        menu = 'k9_main',
        options = {
            {
                title = lang.heal_dog,
                description = 'Patch your dog up with a bandage',
                icon = 'band-aid',
                iconColor = COLORS.care,
                onSelect = function() HEAL_OR_ARMOR('heal') end
            },
            {
                title = lang.armor_dog,
                description = 'Suit your dog up with armor',
                icon = 'shield-alt',
                iconColor = COLORS.care,
                onSelect = function() HEAL_OR_ARMOR('armor') end
            }
        }
    })
end

local function buildAppearanceMenu()
    lib.registerContext({
        id = 'k9_appearance_menu',
        title = lang.appearance,
        menu = 'k9_other',
        options = {
            {
                title = lang.dog_style,
                description = 'Roll a random look for your dog',
                icon = 'dice',
                iconColor = COLORS.appearance,
                onSelect = SET_RANDOM_COMPONENTS
            },
            {
                title = lang.change_appearance,
                description = 'Fine-tune each component yourself',
                icon = 'shirt',
                iconColor = COLORS.appearance,
                arrow = true,
                onSelect = openAppearanceEditor
            }
        }
    })
end

local function buildCameraMenu()
    if CFG.SETTINGS.CAMERA.disable then return end

    lib.registerContext({
        id = 'k9_camera',
        title = lang.camera_desc,
        menu = 'k9_other',
        options = {
            {
                title = lang.mount_camera,
                icon = 'camera',
                iconColor = COLORS.camera,
                onSelect = MOUNT_CAMERA
            },
            {
                title = lang.open_camera,
                icon = 'eye',
                iconColor = COLORS.camera,
                onSelect = DOG_CAMERA
            }
        }
    })
end

local function buildOtherMenu()
    local options = {
        {
            title = lang.check_dog,
            description = lang.check_desc,
            icon = 'heartbeat',
            iconColor = COLORS.other,
            onSelect = CHECK_DOG
        },
        {
            title = lang.carry,
            description = lang.carry_desc,
            icon = 'hand-holding-heart',
            iconColor = COLORS.other,
            onSelect = CARRY_DOG
        },
        {
            title = lang.feed_dog,
            description = lang.feed_desc,
            icon = 'bone',
            iconColor = COLORS.other,
            onSelect = FEED
        },
        {
            title = lang.appearance,
            icon = 'shirt',
            iconColor = COLORS.appearance,
            arrow = true,
            menu = 'k9_appearance_menu'
        },
        {
            title = lang.animations,
            description = lang.anim_desc,
            icon = 'video',
            iconColor = COLORS.anim,
            arrow = true,
            menu = 'k9_animations'
        }
    }

    if not CFG.SETTINGS.CAMERA.disable then
        options[#options + 1] = {
            title = lang.camera_desc,
            icon = 'camera',
            iconColor = COLORS.camera,
            arrow = true,
            menu = 'k9_camera'
        }
    end

    lib.registerContext({
        id = 'k9_other',
        title = lang.other,
        menu = 'k9_main',
        options = options
    })
end

-------------------------------------------------------------------
-- main menu (rebuilt every time it's opened so the header always
-- shows the dog's *current* health / hunger / thirst / level)
-------------------------------------------------------------------

local function statusHeader()
    if not dog_ent or not DoesEntityExist(dog_ent) then
        return {
            title = data.dogName,
            description = data.dogBreed,
            icon = 'dog',
            iconColor = COLORS.core,
            disabled = true
        }
    end

    local lvlText = ''
    if not CFG.LVL_SYSTEM.DISABLE then
        lvlText = (' \226\128\162 Lvl %d/%d'):format(data.stats.lvl or 1, #CFG.LVL_SYSTEM.LVLS)
    end

    return {
        title = data.dogName,
        description = ('%s%s'):format(data.dogBreed, lvlText),
        icon = 'dog',
        iconColor = COLORS.core,
        progress = math.floor(((data.stats.hunger or 100) + (data.stats.thirst or 100)) / 2),
        metadata = {
            ('Health: %s'):format(GetEntityHealth(dog_ent)),
            ('Armor: %s'):format(GetPedArmour(dog_ent)),
            ('Hunger: %s%%'):format(round(data.stats.hunger or 0, 0)),
            ('Thirst: %s%%'):format(round(data.stats.thirst or 0, 0)),
        },
        disabled = true
    }
end

local function buildMainMenu()
    lib.registerContext({
        id = 'k9_main',
        title = lang.k9_menu,
        options = {
            statusHeader(),
            {
                title = lang.spawn,
                description = lang.spawn_desc,
                icon = 'paw',
                iconColor = COLORS.core,
                onSelect = function() SPAWN_K9(data.dogHash) end
            },
            {
                title = ('%s | %s'):format(lang.follow, lang.stop),
                description = lang.follow_desc,
                icon = 'walking',
                iconColor = COLORS.core,
                onSelect = FOLLOW
            },
            {
                title = ('%s | %s'):format(lang.get_in, lang.get_out),
                description = lang.get_desc,
                icon = 'car',
                iconColor = COLORS.core,
                onSelect = TOGGLE_VEHICLE
            },
            {
                title = lang.search_desc,
                icon = 'search',
                iconColor = COLORS.search,
                arrow = true,
                menu = 'k9_search'
            },
            {
                title = lang.track,
                icon = 'route',
                iconColor = COLORS.track,
                arrow = true,
                menu = 'k9_track'
            },
            {
                title = lang.heal_desc,
                icon = 'briefcase-medical',
                iconColor = COLORS.care,
                arrow = true,
                menu = 'k9_care'
            },
            {
                title = lang.other,
                description = lang.other_desc,
                icon = 'ellipsis-h',
                iconColor = COLORS.other,
                arrow = true,
                menu = 'k9_other'
            },
            {
                title = lang.reselect,
                description = lang.reselect_desc,
                icon = 'users',
                iconColor = COLORS.core,
                onSelect = function()
                    lib.hideContext(false)

                    data.stats.thirst = round(data.stats.thirst, 1)
                    data.stats.hunger = round(data.stats.hunger, 1)

                    local appearance = GET_CURRENT_APPEARANCE()
                    if dog_ent then SPAWN_K9(data.dogHash) end
                    if appearance then data.appearance = appearance end

                    TriggerServerEvent('sh-k9:sv:SaveDog', data, dog_id, appearance)
                    data, dog_id = nil, nil
                    Wait(500) -- saving delay
                    openSelection()
                end
            }
        }
    })
end

function OPEN_K9_MENU()
    if not data or not next(data) then
        openSelection()
        return
    end

    buildMainMenu() -- rebuild so the header reflects live stats
    lib.showContext('k9_main')
end

-------------------------------------------------------------------
-- build everything that doesn't need to be rebuilt on every open
-------------------------------------------------------------------

buildRegisterMenu()
buildSearchMenu()
buildTrackMenu()
buildCareMenu()
buildAppearanceMenu()
buildCameraMenu()
buildAnimationsMenu('k9_other')
buildOtherMenu()
