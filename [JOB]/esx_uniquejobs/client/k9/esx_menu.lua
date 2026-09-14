--[[
    K9 menu - rebuilt on esx_menu_default (ESX.UI.Menu), matching the exact
    same menu system every other department in this resource already uses
    (police_main.lua, sheriff_main.lua, etc.), instead of ox_lib's context
    menu. Same features as before, just a different menu wrapper - every
    option still calls the exact same underlying function (SPAWN_K9, FOLLOW,
    HEAL_OR_ARMOR, etc.) as always.
]]

local lang, animations, dogs = CFG.LANG, CFG.DOG_ANIMATIONS, CFG.DOGS

-------------------------------------------------------------------
-- shared helpers
-------------------------------------------------------------------

-- plays a CFG.DOG_ANIMATIONS entry on the dog (shared by the "Other >
-- Animations" submenu and the standalone /k9animations menu - only reachable
-- through F6 now since chat commands are disabled, but the function is kept
-- shared either way)
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

function OPEN_REGISTRATION()
    if dogAmount >= CFG.SETTINGS.MAX_DOGS then
        Notify(string.format(lang.max_limit, CFG.SETTINGS.MAX_DOGS), "error", 5000)
        return
    end

    local elements = {}
    for name, spawnName in pairs(dogs) do
        elements[#elements + 1] = { label = name, value = spawnName, breed = lang.breed }
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_register',
    {
        title    = lang.register_header,
        align    = 'left',
        elements = elements
    }, function(data, menu)
        REGISTER_K9(data.current.label, data.current.value)
    end, function(data, menu)
        menu.close()
    end)
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

    local elements = {}
    for _, v in pairs(result) do
        elements[#elements + 1] = { label = ('%s (%s)'):format(v.dogName, v.dogBreed), value = v }
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_reselect',
    {
        title    = lang.select_dog,
        align    = 'left',
        elements = elements
    }, function(menuData, menu)
        menu.close()
        local selected = menuData.current.value
        data, dog_id = selected, selected.id
        OPEN_K9_MENU()
    end, function(menuData, menu)
        menu.close()
    end)
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

    local elements = {}
    for _, v in pairs(components) do
        elements[#elements + 1] = {
            label = ('Component %s (drawable %s, %s textures)'):format(v.componentId, v.drawableId, v.totalTextures),
            value = v
        }
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_appearance_components',
    {
        title    = lang.change_appearance,
        align    = 'left',
        elements = elements
    }, function(data, menu)
        local v = data.current.value
        local textures = (v.totalTextures ~= 0 and math.random(1, v.totalTextures) - 1) or v.totalTextures - 1
        local palette = math.random(1, 3)
        local curTexture = GetPedTextureVariation(dog_ent, v.componentId)

        if textures == curTexture then
            textures = (v.totalTextures ~= 0 and math.random(1, v.totalTextures) - 1) or v.totalTextures - 1
        end

        SetPedComponentVariation(dog_ent, v.componentId, v.drawableId, textures, palette)
    end, function(data, menu)
        menu.close()
        saveAppearance()
    end)
end

local function buildAppearanceMenu()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_appearance',
    {
        title    = lang.appearance,
        align    = 'left',
        elements = {
            { label = lang.dog_style,          value = 'random' },
            { label = lang.change_appearance,  value = 'editor' },
        }
    }, function(data, menu)
        if data.current.value == 'random' then
            SET_RANDOM_COMPONENTS()
        elseif data.current.value == 'editor' then
            menu.close()
            openAppearanceEditor()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------------------------------------------------
-- animations (shared between /k9animations - disabled now that chat
-- commands are off - and Other > Animations)
-------------------------------------------------------------------

function OPEN_ANIMATIONS()
    if not data or not next(data) then
        openSelection()
        return
    end

    local elements = {}
    for _, v in ipairs(animations) do
        elements[#elements + 1] = { label = v.name, value = v }
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_animations',
    {
        title    = lang.animations,
        align    = 'left',
        elements = elements
    }, function(data, menu)
        playDogAnimation(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------------------------------------------------
-- static submenus
-------------------------------------------------------------------

local function buildSearchMenu()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_search',
    {
        title    = lang.search_desc,
        align    = 'left',
        elements = {
            { label = lang.search_ped, value = 'search_ped' },
            { label = lang.search_veh, value = 'search_veh' },
        }
    }, function(data, menu)
        if data.current.value == 'search_ped' then
            SEARCH_PLAYER()
        elseif data.current.value == 'search_veh' then
            SEARCH_VEHICLE()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function buildTrackMenu()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_track',
    {
        title    = lang.track,
        align    = 'left',
        elements = {
            { label = lang.track_player, value = 'track_player' },
            { label = lang.find_tracks,  value = 'find_tracks' },
        }
    }, function(data, menu)
        if data.current.value == 'track_player' then
            TRACKING_PLAYER()
        elseif data.current.value == 'find_tracks' then
            TRACKING_ALL()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function buildCareMenu()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_care',
    {
        title    = lang.heal_desc,
        align    = 'left',
        elements = {
            { label = lang.heal_dog,  value = 'heal' },
            { label = lang.armor_dog, value = 'armor' },
        }
    }, function(data, menu)
        HEAL_OR_ARMOR(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

local function buildCameraMenu()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_camera',
    {
        title    = lang.camera_desc,
        align    = 'left',
        elements = {
            { label = lang.mount_camera, value = 'mount' },
            { label = lang.open_camera,  value = 'open' },
        }
    }, function(data, menu)
        if data.current.value == 'mount' then
            MOUNT_CAMERA()
        elseif data.current.value == 'open' then
            DOG_CAMERA()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function buildOtherMenu()
    local elements = {
        { label = lang.check_dog, value = 'check_dog' },
        { label = lang.carry,     value = 'carry' },
        { label = lang.feed_dog,  value = 'feed' },
        { label = lang.appearance, value = 'appearance' },
        { label = lang.animations, value = 'animations' },
    }

    if not CFG.SETTINGS.CAMERA.disable then
        elements[#elements + 1] = { label = lang.camera_desc, value = 'camera' }
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_other',
    {
        title    = lang.other,
        align    = 'left',
        elements = elements
    }, function(data, menu)
        local v = data.current.value
        if v == 'check_dog' then
            CHECK_DOG()
        elseif v == 'carry' then
            CARRY_DOG()
        elseif v == 'feed' then
            FEED()
        elseif v == 'appearance' then
            menu.close()
            buildAppearanceMenu()
        elseif v == 'animations' then
            menu.close()
            OPEN_ANIMATIONS()
        elseif v == 'camera' then
            menu.close()
            buildCameraMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------------------------------------------------
-- main menu
-------------------------------------------------------------------

function OPEN_K9_MENU()
    if not data or not next(data) then
        openSelection()
        return
    end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'k9_main',
    {
        title    = data.dogName,
        align    = 'left',
        elements = {
            { label = lang.spawn,                                      value = 'spawn' },
            { label = ('%s | %s'):format(lang.follow, lang.stop),       value = 'follow' },
            { label = ('%s | %s'):format(lang.get_in, lang.get_out),    value = 'vehicle' },
            { label = lang.search_desc,                                value = 'search' },
            { label = lang.track,                                      value = 'track' },
            { label = lang.heal_desc,                                  value = 'care' },
            { label = lang.other,                                      value = 'other' },
            { label = lang.reselect,                                   value = 'reselect' },
        }
    }, function(data2, menu)
        local v = data2.current.value
        if v == 'spawn' then
            SPAWN_K9(data.dogHash)
        elseif v == 'follow' then
            FOLLOW()
        elseif v == 'vehicle' then
            TOGGLE_VEHICLE()
        elseif v == 'search' then
            menu.close()
            buildSearchMenu()
        elseif v == 'track' then
            menu.close()
            buildTrackMenu()
        elseif v == 'care' then
            menu.close()
            buildCareMenu()
        elseif v == 'other' then
            menu.close()
            buildOtherMenu()
        elseif v == 'reselect' then
            menu.close()

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
    end, function(data2, menu)
        menu.close()
    end)
end
