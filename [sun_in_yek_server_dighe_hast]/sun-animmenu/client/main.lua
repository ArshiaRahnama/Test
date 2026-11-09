-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

--[[
    Sun Animation Menu - Client
    A clean and organized animation menu for FiveM
]]

-- ============================================================================
-- CONSTANTS & STATE
-- ============================================================================

local RESOURCE_NAME = 'sun-animmenu'
local KVP_FAVORITES = 'sun_animmenu_favorites'
local KVP_QUICKS = 'sun_animmenu_quicks'
local KVP_EXPRESSION = 'sun_animmenu_expression'
local KVP_WALK = 'sun_animmenu_walk'
local KVP_WALK_NAME = 'sun_animmenu_walk_name'

-- Menu State
local State = {
    menuReady = false,
    menuActive = false,
    isInAnimation = false,
    positioningAnim = false,
    taskActive = false,
    requestActive = false,
    requestReceiveActive = false,
    handsUp = false,
    isVip = false,
    setDataState = false,
    syncedAnimDictLoaded = false,
    propEmoteTimeout = false,
    weaponCheckThreadActive = false,
    animationThreadActive = false,
    gKeyPressed = false,
}

-- Animation State
local AnimState = {
    lastPlayedType = nil,
    lastWasScenario = false,
    currentLabel = nil,
    currentName = nil,
    currentDict = nil,
    walkStyle = 'default',
    syncedTarget = 0,
}

-- Props & Effects
local Props = {
    playerProps = {},
    hasProps = false,
    secondPropEmote = false,
    particles = {},
}

-- Particle FX State
local Ptfx = {
    prompt = false,
    notified = false,
    asset = nil,
    name = nil,
    wait = 500,
    canHold = false,
    noProp = false,
    bone = nil,
    color = nil,
    info = nil,
    scale = nil,
    placement = {},
}

-- Data
local Data = {
    animations = {},
    categories = {},
    favorites = {},
    quicks = {},
    animLookup = {},
    nearbyPlayers = {},
    myClone = nil,
}

-- Global for external access
canPlayEmote = true

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function tableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

local function round(value, decimals)
    if not decimals then
        return math.floor(value + 0.5)
    end
    local power = 10 ^ decimals
    return math.floor((value * power) + 0.5) / power
end

local function rotationToDirection(rotation)
    local rad = math.pi / 180
    local adjustedRotation = {
        x = rad * rotation.x,
        y = rad * rotation.y,
        z = rad * rotation.z
    }
    return {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
end

local function rayCastGamePlayCamera(distance)
    local camRot = GetGameplayCamRot()
    local camCoord = GetGameplayCamCoord()
    local dir = rotationToDirection(camRot)
    local dest = {
        x = camCoord.x + dir.x * distance,
        y = camCoord.y + dir.y * distance,
        z = camCoord.z + dir.z * distance
    }
    local _, hit, coords, _, entity = GetShapeTestResult(
        StartShapeTestSweptSphere(camCoord.x, camCoord.y, camCoord.z, dest.x, dest.y, dest.z, 0.2, 339, PlayerPedId(), 4)
    )
    return hit, coords, entity
end

local function simpleNotify(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

-- ============================================================================
-- ANIMATION LOADING
-- ============================================================================

local function loadAnimDict(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end

    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 100 do
        RequestAnimDict(dict)
        Wait(10)
        timeout = timeout + 1
    end

    return HasAnimDictLoaded(dict)
end

local function loadAnimSet(animSet)
    if HasAnimSetLoaded(animSet) then
        return true
    end

    local timeout = 0
    while not HasAnimSetLoaded(animSet) and timeout < 100 do
        RequestAnimSet(animSet)
        Wait(10)
        timeout = timeout + 1
    end

    return HasAnimSetLoaded(animSet)
end

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)

    if not IsModelValid(hash) then
        return false
    end

    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 100 do
        RequestModel(hash)
        Wait(10)
        timeout = timeout + 1
    end

    return HasModelLoaded(hash)
end

-- ============================================================================
-- PLAYER HELPERS
-- ============================================================================

local function getPlayers(onlyOthers, returnKeyValue, returnPeds)
    local players = {}
    local myPlayer = PlayerId()
    local active = GetActivePlayers()

    for i = 1, #active do
        local player = active[i]
        local ped = GetPlayerPed(player)

        if DoesEntityExist(ped) and IsEntityVisible(ped) then
            if not onlyOthers or player ~= myPlayer then
                if returnKeyValue then
                    players[player] = { entity = ped, id = GetPlayerServerId(player) }
                else
                    players[#players + 1] = returnPeds and ped or player
                end
            end
        end
    end

    return players
end

local function getPlayersInArea(coords, maxDistance)
    local nearby = {}
    local players = getPlayers(true, true, false)
    coords = coords or GetEntityCoords(PlayerPedId())

    for _, data in pairs(players) do
        local dist = #(coords - GetEntityCoords(data.entity))
        if dist <= maxDistance then
            nearby[#nearby + 1] = data.id
        end
    end

    return nearby
end

local function isPlayerArmed()
    return IsPedArmed(PlayerPedId(), 7)
end

local function isPlayerInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), true)
end

local function isPlayerInAir()
    return IsEntityInAir(PlayerPedId())
end

-- ============================================================================
-- PROP MANAGEMENT
-- ============================================================================

local function addPropToPlayer(propName, bone, x, y, z, rx, ry, rz, textureVariation)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if not loadModel(propName) then
        return false
    end

    local prop = ESX.Game.SpawnObject(joaat(propName), vec3(coords.x, coords.y, coords.z + 0.2), nil, true)

    if textureVariation then
        SetObjectTextureVariation(prop, textureVariation)
    end

    SetEntityCollision(prop, false, false)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone), x, y, z, rx, ry, rz, true, true, false, true, 1, true)

    Props.playerProps[#Props.playerProps + 1] = prop
    Props.hasProps = true
    SetModelAsNoLongerNeeded(propName)

    return true
end

local function destroyAllProps()
    for _, prop in pairs(Props.playerProps) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    Props.playerProps = {}
    Props.hasProps = false
end

-- ============================================================================
-- SCENARIO OBJECTS CLEANUP
-- ============================================================================

local ScenarioObjects = {
    `p_amb_coffeecup_01`, `p_amb_joint_01`, `p_cs_ciggy_01`, `p_cs_ciggy_01b_s`,
    `p_cs_clipboard`, `prop_curl_bar_01`, `p_cs_joint_01`, `p_cs_joint_02`,
    `prop_acc_guitar_01`, `prop_amb_ciggy_01`, `prop_amb_phone`, `prop_beggers_sign_01`,
    `prop_beggers_sign_02`, `prop_beggers_sign_03`, `prop_beggers_sign_04`, `prop_bongos_01`,
    `prop_cigar_01`, `prop_cigar_02`, `prop_cigar_03`, `prop_cs_beer_bot_40oz_02`,
    `prop_cs_paper_cup`, `prop_cs_trowel`, `prop_fib_clipboard`, `prop_fish_slice_01`,
    `prop_fishing_rod_01`, `prop_fishing_rod_02`, `prop_notepad_02`, `prop_parking_wand_01`,
    `prop_rag_01`, `prop_scn_police_torch`, `prop_sh_cigar_01`, `prop_sh_joint_01`,
    `prop_tool_broom`, `prop_tool_hammer`, `prop_tool_jackham`, `prop_tennis_rack_01`,
    `prop_weld_torch`, `w_me_gclub`, `p_amb_clipboard_01`
}

local animationObjects = {}

local function cleanScenarioObjects(isClone)
    local ped = isClone and Data.myClone or PlayerPedId()
    local coords = GetEntityCoords(ped)

    for i = 1, #ScenarioObjects do
        local obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, ScenarioObjects[i], false, true, true)
        if DoesEntityExist(obj) then
            SetEntityAsMissionEntity(obj, false, false)
            DeleteObject(obj)
        end
    end
end

-- ============================================================================
-- PARTICLE FX SYSTEM
-- ============================================================================

local function loadPtfxAsset(asset)
    local timeout = 0
    while not HasNamedPtfxAssetLoaded(asset) and timeout < 100 do
        RequestNamedPtfxAsset(asset)
        Wait(10)
        timeout = timeout + 1
    end
    UseParticleFxAsset(asset)
end

local function ptfxStart()
    LocalPlayer.state:set('ptfx', true, true)
end

local function ptfxStop()
    LocalPlayer.state:set('ptfx', false, true)
end

AddStateBagChangeHandler('ptfx', nil, function(bagName, key, value)
    local plyId = tonumber(bagName:gsub('player:', ''), 10)

    if (Props.particles[plyId] and value) or (not Props.particles[plyId] and not value) then
        return
    end

    local ply = GetPlayerFromServerId(plyId)
    if ply == 0 then return end

    local plyPed = GetPlayerPed(ply)
    if not DoesEntityExist(plyPed) then return end

    local myCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(plyPed)
    local stateBag = Player(plyId).state

    if value then
        if #(myCoords - targetCoords) > 40.0 then return end

        local asset = stateBag.ptfxAsset
        local name = stateBag.ptfxName
        local offset = stateBag.ptfxOffset
        local rot = stateBag.ptfxRot
        local boneIndex = stateBag.ptfxBone and GetPedBoneIndex(plyPed, stateBag.ptfxBone) or GetEntityBoneIndexByName(name, "VFX")
        local scale = stateBag.ptfxScale or 1
        local color = stateBag.ptfxColor
        local propNet = stateBag.ptfxPropNet
        local entityTarget = plyPed

        if propNet then
            local propObj = NetToObj(propNet)
            if DoesEntityExist(propObj) then
                entityTarget = propObj
            end
        end

        loadPtfxAsset(asset)
        Props.particles[plyId] = StartNetworkedParticleFxLoopedOnEntityBone(
            name, entityTarget, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneIndex, scale + 0.0, false, false, false
        )

        if color then
            if color[1] and type(color[1]) == 'table' then
                color = color[math.random(1, #color)]
            end
            SetParticleFxLoopedAlpha(Props.particles[plyId], color.A)
            SetParticleFxLoopedColour(Props.particles[plyId], color.R / 255, color.G / 255, color.B / 255, false)
        end
    else
        StopParticleFxLooped(Props.particles[plyId], false)
        RemoveNamedPtfxAsset(stateBag.ptfxAsset)
        Props.particles[plyId] = nil
    end
end)

-- ============================================================================
-- ANIMATION THREADS
-- ============================================================================

local function startWeaponCheckThread()
    if State.weaponCheckThreadActive then return end

    State.weaponCheckThreadActive = true

    CreateThread(function()
        while State.weaponCheckThreadActive do
            if isPlayerArmed() then
                Wait(2000)
                exports[RESOURCE_NAME]:cancelEmote(true)
                State.weaponCheckThreadActive = false
                break
            end
            Wait(100)
        end
        State.weaponCheckThreadActive = false
    end)
end

local function runAnimationThread()
    if State.animationThreadActive then return end

    State.animationThreadActive = true

    CreateThread(function()
        while State.animationThreadActive and (State.isInAnimation or Ptfx.prompt) do
            local sleep = 500
            local ped = PlayerPedId()

            if State.isInAnimation or IsPedUsingAnyScenario(ped) or GetIsTaskActive(ped, 134) then
                sleep = 0

                if IsPlayerFreeAiming(PlayerId()) or IsAimCamActive() or IsAimCamThirdPersonActive() then
                    exports[RESOURCE_NAME]:cancelEmote(true)
                end

                DisableControlAction(2, 140, true)
                DisableControlAction(2, 141, true)
                DisableControlAction(2, 142, true)
            end

            if Ptfx.prompt and not Ptfx.notified then
                simpleNotify(Ptfx.info)
                Ptfx.notified = true
            end

            Wait(sleep)
        end
        State.animationThreadActive = false
    end)
end

-- ============================================================================
-- CANCEL EMOTE
-- ============================================================================

local function cancelEmote(silent, force)
    local ped = PlayerPedId()

    if State.isInAnimation or IsPedUsingAnyScenario(ped) or GetIsTaskActive(ped, 134) or force then
        State.isInAnimation = false
        State.weaponCheckThreadActive = false

        cleanScenarioObjects(false)

        if not isPlayerInVehicle() then
            if AnimState.lastWasScenario then
                ClearPedTasksImmediately(ped)
                AnimState.lastWasScenario = false
            else
                ClearPedTasks(ped)
            end

            ESX.SetPlayerState('clearobject', math.random(1, 100))
            SetTimeout(500, function()
                ESX.SetPlayerState('clearobject', nil)
            end)
        else
            ClearPedTasks(ped)
        end

        if Props.hasProps then
            destroyAllProps()
        end

        if AnimState.lastPlayedType == "posAnim" then
            FreezeEntityPosition(ped, false)
        end

        if AnimState.lastPlayedType == "synced" then
            FreezeEntityPosition(ped, false)
            SetEntityCollision(ped, true, true)
            TriggerServerEvent('sun-animmenu:cancelEmote:server', AnimState.syncedTarget)
            DetachEntity(ped, false, false)
        end

        State.animationThreadActive = false
        Ptfx.notified = false
        Ptfx.prompt = false

    elseif not silent then
        if Config.CanHandsup() and Config.EnableHandsUp then
            if not HasAnimDictLoaded('missminuteman_1ig_2') then
                loadAnimDict('missminuteman_1ig_2')
            end

            State.handsUp = not State.handsUp

            if State.handsUp then
                Config.HandsupDisableControls()
                TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                Config.HandsupEnableControls()
                ClearPedTasks(ped)
            end
        end
    end
end

-- ============================================================================
-- DATA INITIALIZATION
-- ============================================================================

local CategoryConfig = {
    { key = "General", name = "general", dict = 2, anim = 3, animName = 1, labelKey = 4, labelFallback = 3 },
    { key = "Dances", name = "dances", dict = 3, anim = 4, animName = 1, labelKey = 2 },
    { key = "Expressions", name = "expressions", dict = 1, animName = 3, labelKey = 2 },
    { key = "Walks", name = "walks", dict = 1, animName = 3, labelKey = 2 },
    { key = "PlacedEmotes", name = "placedemotes", dict = 1, anim = 2, animName = 4, labelKey = 3, enabled = function() return Config.EnablePlacedAnims end },
    { key = "SyncedEmotes", name = "syncedemotes", animName = 2, labelKey = 1, enabled = function() return Config.EnableSyncedEmote end },
    { key = "PropEmotes", name = "propemotes", dict = 2, anim = 3, animName = 1, labelKey = 4 },
    { key = "ERP", name = "erpemotes", animName = 2, labelKey = 1, enabled = function() return Config.EnableERPAnims end },
    { key = "AnimalEmotes", name = "animalemotes", dict = 3, anim = 4, animName = 1, labelKey = 2, enabled = function() return Config.EnableAnimalAnims end },
}

local function reloadConfig(isVip)
    local id = 0
    local source = isVip and RESVIP or RES

    Data.animations = {}
    Data.categories = {}
    Data.animLookup = {}

    for _, catConfig in ipairs(CategoryConfig) do
        if not catConfig.enabled or catConfig.enabled() then
            local catData = source[catConfig.key]
            Data.animLookup[catConfig.key] = {}

            if catData then
                for i = 1, #catData do
                    id = id + 1
                    local anim = catData[i]
                    local label = anim[catConfig.labelKey] or (catConfig.labelFallback and anim[catConfig.labelFallback]) or anim[1]

                    Data.animations[#Data.animations + 1] = {
                        id = id,
                        name = anim[catConfig.animName],
                        label = label,
                        category = catConfig.name,
                        imgId = anim.imageId or i,
                        animId = i
                    }

                    Data.animLookup[catConfig.key][anim[catConfig.animName]] = i
                end
            end
        end
    end

    -- Build Categories
    Data.categories[#Data.categories + 1] = {
        name = "all",
        number = #Data.animations,
        label = Lang:t("categories.all"),
        image = "all",
        width = 1.7
    }

    -- Load Favorites
    local kvpFavs = GetResourceKvpString(KVP_FAVORITES)
    Data.favorites = kvpFavs and json.decode(kvpFavs) or {}

    -- Load Quick Animations
    Data.quicks = {}
    local kvpQuicks = GetResourceKvpString(KVP_QUICKS)
    if kvpQuicks then
        local quicks = json.decode(kvpQuicks)
        for _, v in pairs(quicks) do
            Data.quicks[#Data.quicks + 1] = {
                slot = tonumber(v.slot),
                id = tonumber(v.id),
                name = v.name,
                category = v.category,
                imgId = tonumber(v.imgId) or v.imgId,
                label = v.label,
                animId = tonumber(v.animId)
            }
        end
    end

    Data.categories[#Data.categories + 1] = {
        name = "favorites",
        number = tableLength(Data.favorites),
        label = Lang:t("categories.favorites"),
        image = "favorites",
        width = 2.1
    }

    local categoryLabels = {
        { key = "General", name = "general", label = "categories.general", image = "emotes", width = 0.6 },
        { key = "Dances", name = "dances", label = "categories.dances", image = "dances", width = 0.7 },
        { key = "Expressions", name = "expressions", label = "categories.expressions", image = "expressions", width = 1.6 },
        { key = "Walks", name = "walks", label = "categories.walks", image = "walks", width = 0.9 },
        { key = "PlacedEmotes", name = "placedemotes", label = "categories.placedemotes", image = "emotes", width = 0.6, enabled = function() return Config.EnablePlacedAnims end },
        { key = "SyncedEmotes", name = "syncedemotes", label = "categories.syncedemotes", image = "emotes", width = 0.6, enabled = function() return Config.EnableSyncedEmote end },
        { key = "PropEmotes", name = "propemotes", label = "categories.propemotes", image = "emotes", width = 0.6 },
        { key = "ERP", name = "erpemotes", label = "categories.erpemotes", image = "emotes", width = 0.6, enabled = function() return Config.EnableERPAnims end },
        { key = "AnimalEmotes", name = "animalemotes", label = "categories.animalemotes", image = "emotes", width = 0.6, enabled = function() return Config.EnableAnimalAnims end },
    }

    for _, cat in ipairs(categoryLabels) do
        if not cat.enabled or cat.enabled() then
            local catData = source[cat.key]
            if catData then
                Data.categories[#Data.categories + 1] = {
                    name = cat.name,
                    number = tableLength(catData),
                    label = Lang:t(cat.label),
                    image = cat.image,
                    width = cat.width
                }
            end
        end
    end
end

-- ============================================================================
-- MENU MANAGEMENT
-- ============================================================================

local function openMenu(vip)
    if not Config.CanOpenMenu() or LocalPlayer.state.nui then return end
    if IsNuiFocused() or isPlayerInVehicle() then return end
    if Ban then
        return ESX.Alert('Error', 'Shoma mahrum az kar ba emote shodid', 5000, 'error')
    end

    -- Handle VIP toggle
    if vip ~= State.isVip then
        State.isVip = vip or false
        reloadConfig(State.isVip)
        SendNUIMessage({
            action = "setData",
            categories = Data.categories,
            animations = Data.animations,
            favs = Data.favorites,
            quicks = Data.quicks,
            closeButton = Config.EnableCloseButton,
            menuAlign = Config.MenuAlign
        })
    end

    if not State.menuReady then return end

    if not State.setDataState then
        SendNUIMessage({
            action = "setData",
            sender = RESOURCE_NAME,
            categories = Data.categories,
            animations = Data.animations,
            favs = Data.favorites,
            quicks = Data.quicks,
            closeButton = Config.EnableCloseButton,
            menuAlign = Config.MenuAlign
        })

        while not State.setDataState do Wait(0) end
    end

    if State.requestActive or DoesEntityExist(Data.myClone) then return end

    local translations = {}
    for k in pairs(Lang.fallback and Lang.fallback.phrases or Lang.phrases) do
        local prefix = 'menu.'
        if k:sub(1, #prefix) == prefix then
            translations[k:sub(#prefix + 1)] = Lang:t(k)
        end
    end

    State.menuActive = true
    LocalPlayer.state.nui = true
    SetNuiFocus(true, true)

    if Config.AllowMovement then
        SetNuiFocusKeepInput(true)

        CreateThread(function()
            while State.menuActive do
                Wait(1)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
                DisableControlAction(0, 200, true)
                DisableControlAction(0, 14, true)
                DisableControlAction(0, 15, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 199, true)
                ESX.disableFiring()
            end
        end)
    end

    SendNUIMessage({
        action = "menu",
        state = true,
        translations = translations,
        closeKey = Config.MenuKey.CloseKey
    })
end

local function closeMenu()
    State.menuActive = false
    LocalPlayer.state.nui = nil
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "menu", state = false })
end

-- ============================================================================
-- ANIMATION PLAYBACK
-- ============================================================================

local AnimationTables = {
    general = { name = "General", dict = 2, anim = 3, animName = 1 },
    propemotes = { name = "PropEmotes", dict = 2, anim = 3, animName = 1 },
    dances = { name = "Dances", dict = 3, anim = 4, animName = 1 },
    expressions = { name = "Expressions", dict = 1, animName = 3 },
    walks = { name = "Walks", dict = 1, aname = 3, animName = 3 },
    placedemotes = { name = "PlacedEmotes", dict = 1, anim = 2, animName = 4 },
    syncedemotes = { name = "SyncedEmotes", animName = 2 },
    erpemotes = { name = "ERP", animName = 2 },
    animalemotes = { name = "AnimalEmotes", dict = 3, anim = 4, animName = 1 }
}

local function playGeneralAnimation(animData, tableData, inVehicle)
    local ped = PlayerPedId()
    State.isInAnimation = true
    startWeaponCheckThread()

    local opts = animData.AnimationOptions

    if opts and opts.Scenario then
        if inVehicle then return end
        ClearPedTasks(ped)
        TaskStartScenarioInPlace(ped, animData[tableData.dict], 0, true)
        AnimState.lastWasScenario = true
        cleanScenarioObjects(false)
        return
    end

    AnimState.lastWasScenario = false

    if not loadAnimDict(animData[tableData.dict]) then return end

    -- Determine movement type
    local movementType = 0
    if opts then
        if opts.Flag then
            movementType = opts.Flag
        elseif opts.EmoteMoving then
            movementType = 51
        elseif opts.EmoteLoop then
            movementType = 1
        elseif opts.EmoteStuck then
            movementType = 50
        end
    end

    if inVehicle then
        movementType = 51
    end

    local duration = (opts and opts.Duration) or -1

    -- Setup particle effects
    if opts and opts.PtfxAsset then
        Ptfx.asset = opts.PtfxAsset
        Ptfx.name = opts.PtfxName
        Ptfx.noProp = opts.PtfxNoProp or false
        Ptfx.placement = opts.PtfxPlacement or {}
        Ptfx.bone = opts.PtfxBone
        Ptfx.color = opts.PtfxColor
        Ptfx.info = opts.PtfxInfo
        Ptfx.wait = opts.PtfxWait or 500
        Ptfx.canHold = opts.PtfxCanHold
        Ptfx.notified = false
        Ptfx.prompt = true

        runAnimationThread()

        local p1, p2, p3, p4, p5, p6 = table.unpack(Ptfx.placement)
        ESX.TriggerServerEvent("sun-animmenu:ptfxSync:server", Ptfx.asset, Ptfx.name, vector3(p1 or 0, p2 or 0, p3 or 0), vector3(p4 or 0, p5 or 0, p6 or 0), Ptfx.bone, Ptfx.scale, Ptfx.color)
    else
        Ptfx.prompt = false
    end

    TaskPlayAnim(ped, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, duration, movementType, 0, false, false, false)
    RemoveAnimDict(animData[tableData.dict])

    -- Handle props
    if opts and opts.Prop then
        local propPl = opts.PropPlacement or {}
        local p1, p2, p3, p4, p5, p6 = table.unpack(propPl)

        if not addPropToPlayer(opts.Prop, opts.PropBone, p1, p2, p3, p4, p5, p6, nil) then
            return
        end

        -- Second prop (Prop2 or SecondProp)
        local secondProp = opts.Prop2 or opts.SecondProp
        local secondBone = opts.Prop2Bone or opts.SecondPropBone
        local secondPlacement = opts.Prop2Placement or opts.SecondPropPlacement

        if secondProp and secondPlacement then
            local s1, s2, s3, s4, s5, s6 = table.unpack(secondPlacement)
            if not addPropToPlayer(secondProp, secondBone, s1, s2, s3, s4, s5, s6, nil) then
                destroyAllProps()
                return
            end
        end

        if opts.PtfxAsset and not Ptfx.noProp then
            TriggerServerEvent("sun-animmenu:ptfxSyncProp:server", ObjToNet(Props.playerProps[1]))
        end
    end
end

local function playDanceAnimation(animData, tableData)
    if not loadAnimDict(animData[tableData.dict]) then return end

    TaskPlayAnim(PlayerPedId(), animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, -1, 1, 0, false, false, false)
    RemoveAnimDict(animData[tableData.dict])

    State.isInAnimation = true
    startWeaponCheckThread()
end

local function playExpression(animData, tableData)
    local expression = animData[tableData.dict]
    SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
    SetResourceKvp(KVP_EXPRESSION, expression)
end

local function playWalk(animData, tableData)
    local walk = animData[tableData.dict]
    local name = animData[tableData.aname]
    local ped = PlayerPedId()

    AnimState.walkStyle = name

    ResetPedMovementClipset(ped, 1.0)
    ResetPedWeaponMovementClipset(ped)
    ResetPedStrafeClipset(ped)

    if loadAnimSet(walk) then
        SetPedMovementClipset(ped, walk, 0.2)
        RemoveAnimSet(walk)
        SetResourceKvp(KVP_WALK, walk)
        SetResourceKvp(KVP_WALK_NAME, AnimState.walkStyle)
    end
end

local function playPlacedEmote(animData, tableData)
    if DoesEntityExist(Data.myClone) or isPlayerInVehicle() then return end

    local hit, coords, entity = rayCastGamePlayCamera(Config.MaxDistanceForAnimPos)
    if hit and (IsEntityAVehicle(entity) or IsThisModelAHeli(GetEntityModel(entity)) or IsThisModelAPlane(GetEntityModel(entity))) then
        return
    end

    if State.menuActive then
        closeMenu()
    end

    SendNUIMessage({ action = "openInfoMenu", state = true })

    local ped = PlayerPedId()
    Data.myClone = ClonePed(ped, false, false, true)

    FreezeEntityPosition(Data.myClone, true)
    SetEntityHeading(Data.myClone, GetEntityHeading(ped))
    PlaceObjectOnGroundProperly(Data.myClone)
    SetBlockingOfNonTemporaryEvents(Data.myClone, true)
    SetEntityCollision(Data.myClone, false, false)
    SetEntityAlpha(Data.myClone, 200, false)

    if not loadAnimDict(animData[tableData.dict]) then return end

    TaskPlayAnim(Data.myClone, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, -1, 1, 0, false, false, false)
    RemoveAnimDict(animData[tableData.dict])

    SetNuiFocus(true, false)
    SetNuiFocusKeepInput(true)
    State.positioningAnim = true

    local myCoords = GetEntityCoords(ped)
    local myCoordsZ = myCoords.z
    local cloneCoords, cloneHeading
    local setAnim = true

    while State.positioningAnim do
        DisableControlAction(0, 20, true)
        DisableControlAction(0, 36, true)
        DisablePlayerFiring(PlayerId(), true)

        cloneCoords = GetEntityCoords(Data.myClone)
        local hit2, coords2 = rayCastGamePlayCamera(Config.MaxDistanceForAnimPos)

        if hit2 and setAnim then
            SetEntityCoords(Data.myClone, coords2.x, coords2.y, myCoordsZ)
        end

        if IsControlPressed(0, 20) or IsDisabledControlPressed(0, 20) then
            myCoordsZ = coords2.z
        end

        -- Rotate Left
        if IsControlPressed(0, 14) then
            local rotSpeed = (IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36)) and 5 or 10
            SetEntityHeading(Data.myClone, GetEntityHeading(Data.myClone) - rotSpeed)
        end

        -- Rotate Right
        if IsControlPressed(0, 15) then
            local rotSpeed = (IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36)) and 5 or 10
            SetEntityHeading(Data.myClone, GetEntityHeading(Data.myClone) + rotSpeed)
        end

        -- Up Arrow
        if IsControlPressed(1, 27) then
            setAnim = false
            local distance = #(cloneCoords - myCoords)
            if Config.MaxDistanceForAnimPos >= round(distance) then
                local clonePos = GetEntityCoords(Data.myClone)
                local step = (IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36)) and 0.001 or 0.05
                myCoordsZ = myCoordsZ + step
                SetEntityCoords(Data.myClone, clonePos.x, clonePos.y, myCoordsZ)
            else
                SetEntityCoords(Data.myClone, myCoords.x, myCoords.y, myCoordsZ)
            end
        end

        -- Down Arrow
        if IsControlPressed(1, 173) then
            setAnim = false
            local distance = #(cloneCoords - myCoords)
            if Config.MaxDistanceForAnimPos >= round(distance) then
                local clonePos = GetEntityCoords(Data.myClone)
                local step = (IsControlPressed(0, 36) or IsDisabledControlPressed(0, 36)) and 0.001 or 0.05
                myCoordsZ = myCoordsZ - step
                SetEntityCoords(Data.myClone, clonePos.x, clonePos.y, myCoordsZ)
            else
                SetEntityCoords(Data.myClone, myCoords.x, myCoords.y, myCoordsZ)
            end
        end

        -- Confirm (E)
        if IsControlPressed(0, 38) then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({ action = "openInfoMenu", state = false })

            cloneCoords = GetEntityCoords(Data.myClone)
            cloneHeading = GetEntityHeading(Data.myClone)

            TaskGoStraightToCoord(ped, cloneCoords.x, cloneCoords.y, cloneCoords.z, 1.0, -1, cloneHeading, -1)
            DeletePed(Data.myClone)

            State.positioningAnim = false
            AnimState.lastPlayedType = "posAnim"
            State.taskActive = true
        end

        -- Cancel (ESC)
        if IsControlPressed(0, 322) then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({ action = "openInfoMenu", state = false })
            DeletePed(Data.myClone)
            State.positioningAnim = false
            State.taskActive = false
        end

        setAnim = true
        Wait(0)
    end

    -- Timeout handler
    SetTimeout(7500, function()
        if State.taskActive then
            FreezeEntityPosition(ped, true)
            Wait(250)
            SetEntityVisible(ped, false, 0)
            ClearPedTasks(ped)
            SetEntityCoordsNoOffset(ped, cloneCoords.x, cloneCoords.y, myCoordsZ + 1.0, true, true, true)
            SetEntityHeading(ped, cloneHeading)
            State.taskActive = false
            Wait(500)
            SetEntityVisible(ped, true, 0)
        end
    end)

    -- Walk to position
    while State.taskActive do
        Wait(0)
        local currentCoords = GetEntityCoords(ped)
        local distance = #(currentCoords - cloneCoords)

        if distance <= 1.5 then
            FreezeEntityPosition(ped, true)
            Wait(250)
            SetEntityVisible(ped, false, 0)
            ClearPedTasks(ped)
            SetEntityCoordsNoOffset(ped, cloneCoords.x, cloneCoords.y, myCoordsZ + 1.0, true, true, true)
            SetEntityHeading(ped, cloneHeading)
            State.taskActive = false
            State.positioningAnim = false
            Wait(500)
            SetEntityVisible(ped, true, 0)

            if not loadAnimDict(animData[tableData.dict]) then return end

            TaskPlayAnim(ped, animData[tableData.dict], animData[tableData.anim], 5.0, 5.0, -1, 1, 0, false, false, false)
            RemoveAnimDict(animData[tableData.dict])

            State.isInAnimation = true
            startWeaponCheckThread()
            break
        end
    end
end

local function playSyncedEmote(animData, tableData, category, animId)
    if State.requestActive or isPlayerInVehicle() then return end

    local ped = PlayerPedId()
    Data.nearbyPlayers = getPlayersInArea(GetEntityCoords(ped), 5.0)

    if not next(Data.nearbyPlayers) then
        Config.Notify(Lang:t("notifications.no_players_nearby"), 7500, "error")
        return
    end

    closeMenu()
    State.requestActive = true
    Config.ShowTextUI(Lang:t("notifications.waiting_for_a_decision"), "ESC")

    animData.type = category
    animData.animNumber = animId
    animData.targetAnimName = animData[5] or nil

    for _, id in pairs(Data.nearbyPlayers) do
        Config.Create3DTextUIOnPlayer("sun-animmenu-request-" .. id, {
            id = id,
            displayDist = 5.0,
            interactDist = 1.3,
            enableKeyClick = true,
            keyNum = 38,
            key = "E",
            text = animData[1] .. "?",
            theme = "green",
            triggerData = {
                triggerName = "sun-animmenu:sendAnimRequest:client",
                args = { data = animData, id = id }
            }
        })
    end

    -- Cancel listener
    CreateThread(function()
        while State.requestActive do
            Wait(0)
            if IsControlPressed(0, 322) then
                Config.Notify(Lang:t("notifications.request_cancelled"), 7500, "error")
                State.requestActive = false
                Config.HideTextUI()
                for _, id in pairs(Data.nearbyPlayers) do
                    Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. id)
                end
                break
            end
        end
    end)

    -- Timeout
    SetTimeout(7500, function()
        if State.requestActive then
            Config.Notify(Lang:t("notifications.request_timed_out"), 7500, "error")
            State.requestActive = false
            Config.HideTextUI()
            for _, id in pairs(Data.nearbyPlayers) do
                Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. id)
            end
        end
    end)
end

local function isAnimalPed()
    local myPed = GetEntityModel(PlayerPedId())
    for _, v in pairs(Config.AnimalPeds) do
        if myPed == GetHashKey(v) then
            return true
        end
    end
    return false
end

local function playAnimation(category, animId)
    if Ban then
        return ESX.Alert('Error', 'Shoma mahrum az kar ba emote shodid', 5000, 'error')
    end

    if not Config.CanOpenMenu() then return end
    if not ESX.checkCooldown('emoteMenu', 1000) then
        return ESX.ShowNotification('Spam nakonid')
    end

    local inVehicle = isPlayerInVehicle()
    if inVehicle then return end

    if isPlayerInAir() then return end

    if isPlayerArmed() then
        ESX.notification('error', 'شما نمیتوانید با اسلحه انیمیشن اجرا کنید')
        return
    end

    SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)

    -- Prop timeout
    if category == "propemotes" then
        if State.propEmoteTimeout then return end
        State.propEmoteTimeout = true
        SendNUIMessage({ action = "propTimeout", state = true })
        SetTimeout(Config.PropTimeout, function()
            State.propEmoteTimeout = false
            SendNUIMessage({ action = "propTimeout", state = false })
        end)
    end

    cancelEmote(true)

    local tableData = AnimationTables[category]
    if not tableData then
        print("[sun-animmenu] Unknown category: " .. tostring(category))
        return
    end

    local animData = RES[tableData.name] and RES[tableData.name][animId]
    if not animData then
        print("[sun-animmenu] Animation not found: " .. tableData.name .. "[" .. tostring(animId) .. "]")
        return
    end

    AnimState.lastPlayedType = nil
    AnimState.currentLabel = animData[tableData.animName]
    AnimState.currentName = animData[tableData.anim]
    AnimState.currentDict = animData[tableData.dict]

    -- Animal check
    if category == "animalemotes" then
        Wait(500)
        if not isAnimalPed() then
            Config.Notify(Lang:t("notifications.just_animals"), 7500, "error")
            return
        end
    end

    -- Play animation based on category
    if category == "general" or category == "propemotes" or category == "animalemotes" then
        playGeneralAnimation(animData, tableData, inVehicle)
        TriggerEvent('PlayEmote', animData[tableData.animName]:lower())

    elseif category == "dances" then
        playDanceAnimation(animData, tableData)

    elseif category == "expressions" then
        playExpression(animData, tableData)

    elseif category == "walks" then
        playWalk(animData, tableData)

    elseif category == "placedemotes" then
        playPlacedEmote(animData, tableData)

    elseif category == "syncedemotes" or category == "erpemotes" then
        playSyncedEmote(animData, tableData, category, animId)
    end
end

-- ============================================================================
-- NUI CALLBACKS
-- ============================================================================

RegisterNUICallback('callback', function(data)
    local action = data.action

    if action == "playSound" then
        PlaySound(-1, data.sound, data.type, 0, 0, 1)

    elseif action == "disableMovement" then
        if Config.AllowMovement then
            SetNuiFocusKeepInput(false)
        end

    elseif action == "enableMovement" then
        if Config.AllowMovement then
            SetNuiFocusKeepInput(true)
        end

    elseif action == "dataReady" then
        State.setDataState = true

    elseif action == "saveFavAnims" then
        SetResourceKvp(KVP_FAVORITES, json.encode(data.favoriteAnimations))

    elseif action == "saveQuickAnims" then
        local quickTable = {}
        for _, v in pairs(data.quickAnimations) do
            quickTable[#quickTable + 1] = {
                slot = tonumber(v.slot),
                id = tonumber(v.id),
                name = v.name,
                category = v.category,
                imgId = tonumber(v.imgId) or v.imgId,
                label = v.label,
                animId = tonumber(v.animId)
            }
        end
        SetResourceKvp(KVP_QUICKS, json.encode(quickTable))

    elseif action == "resetExpression" then
        ClearFacialIdleAnimOverride(PlayerPedId())
        DeleteResourceKvp(KVP_EXPRESSION)
        Config.Notify(Lang:t("notifications.expression_reset"), 5000, "success")

    elseif action == "resetWalk" then
        local ped = PlayerPedId()
        AnimState.walkStyle = 'default'
        ResetPedMovementClipset(ped, 1.0)
        ResetPedWeaponMovementClipset(ped)
        ResetPedStrafeClipset(ped)
        DeleteResourceKvp(KVP_WALK)
        DeleteResourceKvp(KVP_WALK_NAME)
        Config.Notify(Lang:t("notifications.walk_reset"), 5000, "success")

    elseif action == "copyToClipboard" then
        SendNUIMessage({ action = "doCopy", text = data.text })

    elseif action == "close" then
        closeMenu()

    elseif action == "closeAnimPos" then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        State.positioningAnim = false
        if DoesEntityExist(Data.myClone) then
            DeletePed(Data.myClone)
        end

    elseif action == "playAnim" then
        playAnimation(data.category, data.id)
    end
end)

-- ============================================================================
-- COMMAND HANDLERS
-- ============================================================================

local lastEmoteCommand = 0

local function emoteCommandStart(args, disableX)
    if #args == 0 then return end
    local now = GetGameTimer()
    if now - lastEmoteCommand < 1000 then return end
    lastEmoteCommand = now
    if ESX.isDeadOrCuff() or not ESX.isEmoteMenuActive() or LocalPlayer.state.reviveThread or LocalPlayer.state.lowFood then return end
    if not Config.CanOpenMenu() then return end

    if State.isInAnimation or IsPedUsingAnyScenario(PlayerPedId()) or GetIsTaskActive(PlayerPedId(), 134) then
        cancelEmote(true)
    end

    if disableX then
        exports['essentialmode']:disablecontrol('x', true)
        SetTimeout(5000, function()
            exports['essentialmode']:disablecontrol('x', false)
        end)
    end

    local name = string.lower(args[1])

    -- Cancel command
    if name == "c" then
        if AnimState.walkStyle ~= 'default' and Config.CancelWalk then
            local ped = PlayerPedId()
            local animSet = IsPedMale(ped) and "move_m@multiplayer" or "move_f@multiplayer"
            AnimState.walkStyle = IsPedMale(ped) and "defaultmale" or "defaultfemale"

            ResetPedMovementClipset(ped, 1.0)
            ResetPedWeaponMovementClipset(ped)
            ResetPedStrafeClipset(ped)

            if loadAnimSet(animSet) then
                SetPedMovementClipset(ped, animSet, 0.2)
                RemoveAnimSet(animSet)
                SetResourceKvp(KVP_WALK, animSet)
                SetResourceKvp(KVP_WALK_NAME, AnimState.walkStyle)
            end

            Config.Notify(Lang:t("notifications.walk_style_is_set_default"), 7500, "error")
            return
        end

        if State.isInAnimation or IsPedUsingAnyScenario(PlayerPedId()) or GetIsTaskActive(PlayerPedId(), 134) then
            cancelEmote(true)
        else
            Config.Notify(Lang:t("notifications.no_emote_to_cancel"), 7500, "error")
        end
        return
    end

    -- Rebuild lookup tables
    Data.animLookup.General = {}
    for i = 1, #RES.General do
        Data.animLookup.General[RES.General[i][1]] = i
    end
    if RESVIP and RESVIP.General then
        for i = 1, #RESVIP.General do
            Data.animLookup.General[RESVIP.General[i][1]] = i
        end
    end

    Wait(500)

    -- Find and play animation
    local categoryMap = {
        { lookup = "General", category = "general" },
        { lookup = "Dances", category = "dances" },
        { lookup = "Expressions", category = "expressions" },
        { lookup = "Walks", category = "walks" },
        { lookup = "PlacedEmotes", category = "placedemotes" },
        { lookup = "PropEmotes", category = "propemotes" },
        { lookup = "ERPEmotes", category = "erpemotes" },
    }

    for _, cat in ipairs(categoryMap) do
        if Data.animLookup[cat.lookup] and Data.animLookup[cat.lookup][name] then
            playAnimation(cat.category, Data.animLookup[cat.lookup][name])
            return
        end
    end

    Config.Notify(name .. " is not a valid emote.", 7500, "error")
end

RegisterCommand('e', function(_, args)
    emoteCommandStart(args)
end, false)

RegisterCommand('resetquicks', function()
    SetResourceKvp(KVP_QUICKS, json.encode({}))
    SendNUIMessage({ action = "resetQuicks" })
end)

-- ============================================================================
-- SYNCED EMOTES
-- ============================================================================

RegisterNetEvent('sun-animmenu:sendAnimRequest:client', function(data)
    data.target = GetPlayerServerId(PlayerId())

    if next(Data.nearbyPlayers) and State.requestActive then
        State.requestActive = false
        Config.HideTextUI()
        for _, id in pairs(Data.nearbyPlayers) do
            Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. id)
        end
    end

    TriggerServerEvent('sun-animmenu:sendAnimRequest:server', data)
end)

RegisterNetEvent('sun-animmenu:receiveAnimRequest:client', function(data)
    Config.ShowTextUI(Lang:t("notifications.waiting_for_a_decision"), "ESC")
    State.requestReceiveActive = true

    Config.Create3DTextUIOnPlayer("sun-animmenu-request-" .. data.target, {
        id = data.target,
        displayDist = 5.0,
        interactDist = 1.3,
        enableKeyClick = true,
        keyNum = 38,
        key = "E",
        text = data.data[1] .. "?",
        theme = "green",
        triggerData = {
            triggerName = "sun-animmenu:playAnimTogetherReceiver:client",
            args = { data = data }
        }
    })

    CreateThread(function()
        while State.requestReceiveActive do
            Wait(0)
            if IsControlPressed(0, 322) then
                Config.Notify(Lang:t("notifications.request_cancelled"), 7500, "error")
                State.requestReceiveActive = false
                Config.HideTextUI()
                Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. data.target)
                TriggerServerEvent('sun-animmenu:requestCancelledNotif:server', data.target)
                break
            end
        end
    end)

    SetTimeout(7500, function()
        if State.requestReceiveActive then
            State.requestReceiveActive = false
            Config.HideTextUI()
            Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. data.target)
            Config.Notify(Lang:t("notifications.request_timed_out"), 7500, "error")
        end
    end)
end)

RegisterNetEvent('sun-animmenu:requestCancelledNotif:client', function()
    Config.Notify(Lang:t("notifications.request_cancelled"), 7500, "error")
end)

RegisterNetEvent('sun-animmenu:animDictLoaded:client', function()
    State.syncedAnimDictLoaded = true
end)

RegisterNetEvent('sun-animmenu:playAnimTogetherReceiver:client', function(data)
    State.requestReceiveActive = false
    AnimState.lastPlayedType = "synced"
    AnimState.syncedTarget = data.data.target

    Config.HideTextUI()
    Config.Delete3DTextUIOnPlayer("sun-animmenu-request-" .. data.data.target)

    if isPlayerInVehicle() then return end

    TriggerServerEvent('sun-animmenu:playAnimTogetherSender:server', data)
    Wait(300)

    local targetPed = GetPlayerPed(GetPlayerFromServerId(data.data.target))
    local opts = data.data.data.AnimationOptions

    local offsetFront = opts and opts.SyncOffsetFront or 1.0
    local offsetSide = opts and opts.SyncOffsetSide or 0.0
    local offsetHeight = opts and opts.SyncOffsetHeight or 0.0
    local offsetHeading = opts and opts.SyncOffsetHeading or 180.1

    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(targetPed, offsetSide, offsetFront, offsetHeight)
    local heading = GetEntityHeading(targetPed)

    SetEntityHeading(ped, heading - offsetHeading)
    FreezeEntityPosition(ped, true)
    Wait(250)
    SetEntityCollision(ped, false, false)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false)

    local receiver = data.data.data.receiver
    local animDict = receiver.dict
    local animName = receiver.anim

    loadAnimDict(animDict)
    TriggerServerEvent('sun-animmenu:animDictLoaded:server', data.data.target)

    while not State.syncedAnimDictLoaded do Wait(0) end

    local movementType = 0
    if opts then
        if opts.Flag then
            movementType = opts.Flag
        elseif opts.EmoteMoving then
            movementType = 51
        elseif opts.EmoteLoop then
            movementType = 1
        elseif opts.EmoteStuck then
            movementType = 50
        end
    end

    if receiver.flag then
        movementType = receiver.flag
    end

    TaskPlayAnim(ped, animDict, animName, 5.0, 5.0, -1, movementType, 0, false, false, false)
    RemoveAnimDict(animDict)

    State.isInAnimation = true
    startWeaponCheckThread()
    State.syncedAnimDictLoaded = false

    FreezeEntityPosition(ped, false)
    SetEntityCollision(ped, true, true)

    if receiver.collision == false then
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
    end

    if receiver.attach then
        AttachEntityToEntity(ped, targetPed, GetPedBoneIndex(40269), 0.14, 0.03, 0.44, 0.0, 0.0, 0.0, false, false, false, true, 1, true)
    end

    if opts and opts.Duration then
        Wait(opts.Duration)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        TriggerServerEvent('sun-animmenu:cancelEmote:server', AnimState.syncedTarget)
        DetachEntity(ped, false, false)
    end
end)

RegisterNetEvent('sun-animmenu:playAnimTogetherSender:client', function(data)
    AnimState.lastPlayedType = "synced"
    AnimState.syncedTarget = data.data.id

    if isPlayerInVehicle() then return end

    local sender = data.data.data.sender or RES["ERP"][data.data.data.animNumber]
    local animDict = sender.dict or sender[2]
    local animName = sender.anim or sender[3]
    local opts = data.data.data.AnimationOptions

    loadAnimDict(animDict)
    TriggerServerEvent('sun-animmenu:animDictLoaded:server', data.data.id)

    while not State.syncedAnimDictLoaded do Wait(0) end

    local movementType = 0
    if opts then
        if opts.Flag then
            movementType = opts.Flag
        elseif opts.EmoteMoving then
            movementType = 51
        elseif opts.EmoteLoop then
            movementType = 1
        elseif opts.EmoteStuck then
            movementType = 50
        end
    end

    Wait(300)

    if sender.flag then
        movementType = sender.flag
    end

    TaskPlayAnim(PlayerPedId(), animDict, animName, 5.0, 5.0, -1, movementType, 0, false, false, false)
    RemoveAnimDict(animDict)

    State.isInAnimation = true
    startWeaponCheckThread()
    State.syncedAnimDictLoaded = false

    if opts and opts.Duration then
        Wait(opts.Duration)
        SetEntityCollision(PlayerPedId(), true, true)
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerServerEvent('sun-animmenu:cancelEmote:server', AnimState.syncedTarget)
        DetachEntity(PlayerPedId(), false, false)
    end
end)

RegisterNetEvent('sun-animmenu:cancelEmote:client', function()
    cancelEmote(true)
end)

-- ============================================================================
-- STATE BAG HANDLERS
-- ============================================================================

AddStateBagChangeHandler('clearobject', nil, function(bagName, key, value)
    local ped = GetPlayerPed(GetPlayerFromStateBagName(bagName))
    if ped == 0 or ped == PlayerPedId() then return end

    if value then
        local coords = GetEntityCoords(ped)
        for _, obj in pairs(ESX.Game.GetObjects()) do
            local model = GetEntityModel(obj)
            if #(coords - GetEntityCoords(obj)) < 1 then
                if not Entity(obj).state.antiDelete and not NetworkGetEntityIsNetworked(obj) and IsEntityStatic(obj) then
                    if ESX.TableContainsValue(animationObjects, model) then
                        ESX.Game.DeleteEntity(obj)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- KEY EVENTS
-- ============================================================================

AddEventHandler('KeyDown:f3', function()
    openMenu()
end)

AddEventHandler('KeyDown:f', function()
    if GetSelectedPedWeapon(PlayerPedId()) == `weapon_unarmed` then
        ESX.deleteNearAttachedObject()
    end
end)

AddEventHandler('KeyDown:g', function()
    if Ptfx.prompt and State.isInAnimation then
        State.gKeyPressed = true
        ptfxStart()
        Wait(Ptfx.wait)

        if Ptfx.canHold then
            while State.gKeyPressed and State.isInAnimation and State.animationThreadActive do
                Wait(5)
            end
        end

        ptfxStop()
        State.gKeyPressed = false
    end
end)

AddEventHandler('KeyUP:g', function()
    State.gKeyPressed = false
end)

AddEventHandler('KeyDown:h', function()
    exports[RESOURCE_NAME]:PlayEmote('taxi')
end)

AddEventHandler('KeyDown:x', function()
    if Config.EnableXtoCancel and Config.CancelEmote.KeyMapping.Enable and ESX.isEmoteMenuActive() and not LocalPlayer.state.reviveThread and not LocalPlayer.state.lowFood then
        cancelEmote()
    end
end)


AddEventHandler('enterVehicle', function ()
    if Config.EnableXtoCancel and Config.CancelEmote.KeyMapping.Enable and ESX.isEmoteMenuActive() then
        cancelEmote()
    end
end)

-- ============================================================================
-- EXTERNAL EVENTS
-- ============================================================================

RegisterNetEvent('dpemote:enable', function(state)
    canPlayEmote = state
end)

RegisterNetEvent('dp:RecieveMenu', function()
    openMenu()
end)

RegisterNetEvent('rp:RecieveMenu', function()
    openMenu()
end)

RegisterNetEvent('sun-animmenu:openMenu', function()
    openMenu()
end)

RegisterNetEvent('sun-animmenu:closeMenu', function()
    closeMenu()
end)

RegisterNetEvent('sun-animmenu:copyCode:client', function(code)
    SendNUIMessage({ action = "copyCode", code = code })
end)

RegisterNetEvent('animations:client:EmoteCommandStart', function(data)
    emoteCommandStart({ data, nil })
end)

RegisterNetEvent('crouch:disable', function(state)
    -- Reserved for crouch disable handling
end)

-- ============================================================================
-- SPECIAL FEATURES
-- ============================================================================

-- Pointing
CreateThread(function()
    if not Config.Pointing.Enable then return end

    local pointAnimActive = false

    local function startPointing()
        local ped = PlayerPedId()
        loadAnimDict("anim@mp_point")
        SetPedCurrentWeaponVisible(ped, 0, true, true, true)
        SetPedConfigFlag(ped, 36, 1)
        TaskMoveNetworkByName(ped, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
        RemoveAnimDict("anim@mp_point")
    end

    local function stopPointing()
        local ped = PlayerPedId()
        if not IsPedInjured(ped) then
            RequestTaskMoveNetworkStateTransition(ped, 'Stop')
            if not isPlayerInVehicle() then
                SetPedCurrentWeaponVisible(ped, 1, true, true, true)
            end
            SetPedConfigFlag(ped, 36, false)
        end
    end

    local function pointAnim()
        local ped = PlayerPedId()
        if isPlayerInVehicle() or LocalPlayer.state.reviveThread or LocalPlayer.state.lowFood then return end

        pointAnimActive = not pointAnimActive

        if pointAnimActive then
            startPointing()
        else
            stopPointing()
        end

        while pointAnimActive do
            local camPitch = GetGameplayCamRelativePitch()
            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = math.cos(math.rad(camHeading))
            local sinCamHeading = math.sin(math.rad(camHeading))

            camPitch = math.max(-70.0, math.min(42.0, camPitch))
            camPitch = (camPitch + 70.0) / 112.0

            camHeading = math.max(-180.0, math.min(180.0, camHeading))
            camHeading = (camHeading + 180.0) / 360.0

            local coords = GetOffsetFromEntityInWorldCoords(
                ped,
                (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)),
                (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)),
                0.6
            )

            local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)
            local _, blocked = GetRaycastResult(ray)

            SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
            SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
            SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
            SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)

            Wait(0)
        end
    end

    if Config.Pointing.KeyMapping.Enable then
        RegisterCommand('pointanim', function()
            pointAnim()
        end, false)
        RegisterKeyMapping("pointanim", Lang:t("keybinds.toggle_point_description"), "keyboard", Config.Pointing.KeyMapping.Key)
    else
        CreateThread(function()
            while true do
                Wait(0)
                if IsControlJustReleased(0, Config.Pointing.NormalKey.Key) then
                    pointAnim()
                end
            end
        end)
    end
end)

-- Ragdoll
CreateThread(function()
    if not Config.Ragdoll.Enable then return end

    local ragdolled = false

    local function toggleRagdoll()
        if IsEntityDead(PlayerPedId()) or isPlayerInVehicle() or LocalPlayer.state.reviveThread or LocalPlayer.state.lowFood then return end

        ragdolled = not ragdolled

        while ragdolled do
            Wait(0)
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        end
    end

    if Config.Ragdoll.KeyMapping.Enable then
        RegisterCommand('ragdoll', function()
            toggleRagdoll()
        end, false)
        RegisterKeyMapping("ragdoll", Lang:t("keybinds.ragdoll_description"), "keyboard", Config.Ragdoll.KeyMapping.Key)
    else
        CreateThread(function()
            while true do
                Wait(0)
                if IsControlJustReleased(0, Config.Ragdoll.NormalKey.Key) then
                    toggleRagdoll()
                end
            end
        end)
    end
end)

-- Crouching
CreateThread(function()
    if not Config.CrouchingEnabled then return end

    local isCrouching = false

    local function resetAnimSet()
        local ped = PlayerPedId()
        ResetPedMovementClipset(ped, 1.0)
        ResetPedWeaponMovementClipset(ped)
        ResetPedStrafeClipset(ped)

        local walk = GetResourceKvpString(KVP_WALK)
        if walk then
            AnimState.walkStyle = walk
            if AnimState.walkStyle ~= 'default' and loadAnimSet(AnimState.walkStyle) then
                SetPedMovementClipset(ped, AnimState.walkStyle, 1.0)
                RemoveAnimSet(AnimState.walkStyle)
            end
        end
    end

    -- Crouch function available for future use
    local function crouchAnim()
        local ped = PlayerPedId()

        if isCrouching then
            ClearPedTasks(ped)
            resetAnimSet()
            SetPedStealthMovement(ped, false, 'DEFAULT_ACTION')
            isCrouching = false
        else
            ClearPedTasks(ped)
            if loadAnimSet('move_ped_crouched') then
                SetPedMovementClipset(ped, 'move_ped_crouched', 1.0)
                SetPedStrafeClipset(ped, 'move_ped_crouched_strafing')
                isCrouching = true
            end
        end
    end
end)

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

CreateThread(function()
    -- Wait for resources
    while RES == nil do Wait(0) end

    local startTime = GetGameTimer()
    while not CoreReady and GetGameTimer() - startTime < 5000 do
        Wait(100)
    end

    startTime = GetGameTimer()
    while not next(GetPlayerData()) and GetGameTimer() - startTime < 5000 do
        Wait(100)
    end

    print("[sun-animmenu] Data loaded successfully")

    reloadConfig()

    print("[sun-animmenu] Menu ready")
    State.menuReady = true

    Wait(500)

    SendNUIMessage({
        action = "setData",
        categories = Data.categories,
        animations = Data.animations,
        favs = Data.favorites,
        quicks = Data.quicks,
        closeButton = Config.EnableCloseButton,
        menuAlign = Config.MenuAlign
    })
end)

-- Load saved walk and expression on spawn
AddEventHandler('sun:clotheLoaded', function()
    Wait(10000)

    local walk = GetResourceKvpString(KVP_WALK)
    local walkName = GetResourceKvpString(KVP_WALK_NAME)

    if walk then
        Wait(2500)
        if loadAnimSet(walk) then
            SetPedMovementClipset(PlayerPedId(), walk, 0.2)
            RemoveAnimSet(walk)
            AnimState.walkStyle = walkName or walk
        end
    end

    local expression = GetResourceKvpString(KVP_EXPRESSION)
    if expression then
        Wait(2500)
        SetFacialIdleAnimOverride(PlayerPedId(), expression, 0)
    end
end)

-- Build animation objects list
CreateThread(function()
    for _, v in pairs(ScenarioObjects) do
        animationObjects[#animationObjects + 1] = v
    end

    for _, category in pairs(RES) do
        for _, anim in pairs(category) do
            if anim.AnimationOptions then
                if anim.AnimationOptions.Prop then
                    animationObjects[#animationObjects + 1] = joaat(anim.AnimationOptions.Prop)
                end
                if anim.AnimationOptions.Prop2 then
                    animationObjects[#animationObjects + 1] = joaat(anim.AnimationOptions.Prop2)
                end
                if anim.AnimationOptions.SecondProp then
                    animationObjects[#animationObjects + 1] = joaat(anim.AnimationOptions.SecondProp)
                end
            end
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    cancelEmote(true, true)
    destroyAllProps()
    Config.HandsupEnableControls()
    DetachEntity(PlayerPedId(), false, false)

    if DoesEntityExist(Data.myClone) then
        DeletePed(Data.myClone)
    end
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('cancelEmote', function(force) cancelEmote(true, force) end)
exports('PlayEmote', function(emoteName, force, disableX)
    if force and ESX.isEmoteMenuActive() then
        cancelEmote(true)
    end
    emoteCommandStart({ emoteName, nil }, disableX)
end)
exports('IsPlayerInAnim', function() return State.isInAnimation end)
exports('Walk', function(walkName)
    local name
    for _, v in pairs(RES.Walks) do
        if v[3] == walkName then
            name = v[1]
            break
        end
    end

    if not name then return end

    local ped = PlayerPedId()
    ResetPedMovementClipset(ped, 1.0)
    ResetPedWeaponMovementClipset(ped)
    ResetPedStrafeClipset(ped)

    if loadAnimSet(name) then
        SetPedMovementClipset(ped, name, 0.2)
        RemoveAnimSet(name)
    end
end)
exports('getCurrentAnimation', function()
    return AnimState.currentLabel, AnimState.currentName, AnimState.currentDict
end)

-- Animation list export for external use
RegisterNetEvent('sun-animmenu:getAnimationList:client', function()
    TriggerEvent('sun-anim-recorder:setAnimationList:client', RES)
end)
