--[[
    Apex Clothing Studio - client main (clean rewrite)

    Same behaviour as the original build/client/main.lua, with readable names.
    Order matches the original file:
      1  state, language, boot payload, open/close, command
      2  /<command>_lang and the studio's NUI callbacks (templates, live, projects)
      3  AI request path (reference chunks, aiGenerate)
      4  texture download, help assistant, engine list
      5  export: texture candidates, ped component info, report, exportRun
      6  AI result delivery to the UI
      7  project and export events, /testai, resource stop, ApexMain
]]

--[[
    Apex Clothing Studio - client main
    PART 1 of 6: shared state, language, boot payload, open/close and the command.

    Replaces lines 1-511 of the decompiled build/client/main.lua.
    Parts 2-6 (NUI callbacks, net events, handlers) are not written yet, so this
    file is reviewed on its own before it is wired into the full main.lua.
]]

----------------------------------------------------------------------
-- Shared state (names used by later parts)
----------------------------------------------------------------------
local studioOpen        = false       -- the studio UI is open
local studioOpening     = false       -- an open attempt is running
local pedModelName      = 'unknown'   -- model name of the player's ped
local closeSession      = 0           -- bumped on every close; cancels older focus watchdogs
local focusWatchdogOn   = false       -- the focus watchdog thread has work to do
local nuiReady          = false       -- the NUI page has reported ready (set in part 6)
local openStudio                      -- defined below
local closeStudio                     -- defined below
local LANGUAGE_KVP      = 'apex_clothing_lang'

----------------------------------------------------------------------
-- Language
----------------------------------------------------------------------
--- The configured default language, 'en' when missing.
local function configuredLocale()
    local locale = Config and Config.locale
    if type(locale) ~= 'string' or locale == '' then
        return 'en'
    end
    return locale
end

--- The language the player picked with /clothingstudio_lang, or nil
--- ('auto', unknown languages and an empty value all mean "use the default").
local function playerLanguage()
    local saved = GetResourceKvpString(LANGUAGE_KVP)
    if type(saved) == 'string' and saved ~= '' and saved ~= 'auto'
        and Locales and Locales[saved] then
        return saved
    end
    return nil
end

--- English strings with the active language on top, so a missing key falls back to English.
local function mergedLocaleTable()
    local merged = {}
    if Locales and Locales.en then
        for key, text in pairs(Locales.en) do
            merged[key] = text
        end
    end
    local active = Locales and Locales[Utils.ActiveLocale()]
    if active and active ~= (Locales and Locales.en) then
        for key, text in pairs(active) do
            merged[key] = text
        end
    end
    return merged
end

----------------------------------------------------------------------
-- Boot payload for the UI
----------------------------------------------------------------------
local function capitalise(text)
    return (tostring(text):gsub('^%l', string.upper))
end

--- Quick themes as the UI shows them: id, translated label, prompt.
local function quickThemeList()
    local list = {}
    for _, theme in ipairs(Config.quickThemes or {}) do
        local labelKey = theme.labelKey or ('theme_' .. tostring(theme.id))
        list[#list + 1] = {
            id     = theme.id,
            label  = L(labelKey, capitalise(theme.id)),
            prompt = theme.prompt,
        }
    end
    return list
end

local function studioConfigForUi()
    local canvas = Config.canvas or {}
    local ai = Config.ai or {}
    local preview = Config.preview or {}
    return {
        canvasSizes     = canvas.sizes,
        defaultSize     = canvas.defaultSize,
        maxLayers       = canvas.maxLayers,
        aiEnabled       = ai.enabled,
        aiProvider      = ai.provider or 'gemini',
        quickThemes     = quickThemeList(),
        frameThrottleMs = preview.frameThrottleMs,
        exportModes     = { 'live', 'package' },
    }
end

local function pedInfoForUi()
    -- Female freemode models contain "_f_" in their name.
    local isFemale = pedModelName:find('_f_', 1, true) ~= nil
    return {
        model  = pedModelName,
        gender = isFemale and 'female' or 'male',
    }
end

local function buildBootPayload()
    return {
        locale = mergedLocaleTable(),
        config = studioConfigForUi(),
        ped    = pedInfoForUi(),
    }
end

--- Sends the boot data, then the "open" message with the wardrobe state.
local function sendBootToUi()
    Apex.SendUI('boot', buildBootPayload())
    Apex.SendUI('open', { wardrobe = Wardrobe.GetState() })
end

----------------------------------------------------------------------
-- Opening and closing
----------------------------------------------------------------------
local function commandName()
    return Config.command or 'clothingstudio'
end

openStudio = function()
    if studioOpen or studioOpening then return end

    studioOpening = true
    Utils.Log(('/%s used - checking access…'):format(commandName()))

    if not Apex.Callback('perm:check') then
        studioOpening = false
        print(('^3[apex_clothing]^7 ACCESS DENIED - run ^5/%s_access^7 and check the SERVER console: it prints every method\'s verdict and your identifiers.')
            :format(commandName()))
        Apex.Notify(L('err_no_access', "You don't have access to the clothing studio."), 'error')
        return
    end

    local ped = PlayerPedId()
    local model = Apex.GetPedModelName(ped)
    pedModelName = model or 'unknown'
    if not model then
        Apex.Notify(L('err_unknown_model', 'Unrecognized ped model - live preview and export are limited.'), 'error')
    end

    local entered, enterError = pcall(function()
        Wardrobe.Snapshot()
        Stage.Enter()
    end)
    if not entered then
        studioOpening = false
        Utils.Log('failed to enter the studio: ' .. tostring(enterError))
        pcall(Stage.Exit)
        pcall(Wardrobe.Restore)
        Apex.Notify(L('err_open_failed', 'The studio could not open - check the F8 console.'), 'error')
        return
    end

    SetNuiFocus(true, true)
    focusWatchdogOn = true
    Apex.uiOpen = true
    studioOpen = true
    studioOpening = false
    Apex.SendUI('loading')

    local built, buildError = pcall(sendBootToUi)
    if not built then
        Utils.Log('failed to build the UI payload: ' .. tostring(buildError))
        closeStudio()
        Apex.Notify(L('err_open_failed', 'The studio could not open - check the F8 console.'), 'error')
        return
    end

    Utils.Log(('studio opened (model %s)'):format(pedModelName))
end

closeStudio = function()
    local wasOpen = studioOpen
    studioOpen = false
    Apex.uiOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)

    closeSession = closeSession + 1
    local thisSession = closeSession

    -- For about 2 seconds, keep NUI focus released unless the studio reopens.
    CreateThread(function()
        for _ = 1, 40 do
            if studioOpen or thisSession ~= closeSession then return end
            if IsNuiFocused() then
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
            end
            Wait(50)
        end
    end)

    if not wasOpen then return end

    Preview.Clear()
    Stage.Exit()
    Wardrobe.Restore()
    Apex.SendUI('close')
    Utils.Log('studio closed')
end

--- Keeps NUI focus from getting stuck after the studio closes.
CreateThread(function()
    while true do
        Wait(250)
        if focusWatchdogOn and not studioOpen then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            if not IsNuiFocused() then
                focusWatchdogOn = false
            end
        end
    end
end)

----------------------------------------------------------------------
-- Command and key binding
----------------------------------------------------------------------
--- The command toggles: open when closed, close when open.
local function toggleStudio()
    if studioOpen then
        closeStudio()
    else
        openStudio()
    end
end

RegisterCommand(commandName(), toggleStudio, false)

if type(Config.keybind) == 'string' and Config.keybind ~= '' then
    RegisterKeyMapping(commandName(), L('keybind_desc', 'Open the clothing studio'), 'keyboard', Config.keybind)
end

--[[
    Apex Clothing Studio - client main
    PART 6 of 7: language command and the studio's NUI callbacks
    (page lifecycle, templates, live textures, projects).

    Replaces lines 512-1137 of the decompiled build/client/main.lua.
    Depends on: studioOpen, nuiReady, closeStudio, sendBootToUi, configuredLocale,
    playerLanguage, commandName, LANGUAGE_KVP (part 1), Apex, Utils, L, json.
]]

----------------------------------------------------------------------
-- /<command>_lang  (choose the studio language, or "auto")
----------------------------------------------------------------------
local function availableLanguages()
    local codes = {}
    for code in pairs(Locales or {}) do
        codes[#codes + 1] = code
    end
    table.sort(codes)
    return codes
end

RegisterCommand(commandName() .. '_lang', function(_, args)
    local codes = availableLanguages()
    local wanted = tostring(args[1] or ''):lower()

    -- No argument: show the current state.
    if wanted == '' then
        local ownPick = playerLanguage()
        local origin = ownPick and 'your own pick'
            or ('following the server default "' .. configuredLocale() .. '"')
        Utils.Log(('language: ^5%s^7 (%s)'):format(Utils.ActiveLocale(), origin))
        Utils.Log(('available: auto, %s'):format(table.concat(codes, ', ')))
        Utils.Log(('usage: /%s_lang <code|auto>'):format(commandName()))
        return
    end

    if wanted == 'auto' then
        DeleteResourceKvp(LANGUAGE_KVP)
    else
        if not (Locales and Locales[wanted]) then
            Utils.Log(('unknown language "%s" - available: auto, %s'):format(wanted, table.concat(codes, ', ')))
            return
        end
        SetResourceKvp(LANGUAGE_KVP, wanted)
    end

    Utils.Log(('language set to ^5%s^7'):format(Utils.ActiveLocale()))
    if studioOpen then
        closeStudio()
    end
    Apex.Notify(L('lang_changed', 'Language changed - reopen the studio to apply it.'), 'info')
end, false)

----------------------------------------------------------------------
-- Page lifecycle
----------------------------------------------------------------------
RegisterNUICallback('uiReady', function(_, cb)
    cb({})
    nuiReady = true
    Utils.Log('NUI reported ready')
    if studioOpen then
        sendBootToUi()
    end
end)

RegisterNUICallback('uiClose', function(_, cb)
    cb({})
    Utils.Log('uiClose received - releasing NUI focus')
    closeStudio()
end)

----------------------------------------------------------------------
-- Small helpers for the callbacks below
----------------------------------------------------------------------
local function emptyProjects()
    return { mine = {}, shared = {} }
end

--- Asks the server for the project list and pushes it to the UI.
local function pushProjectList()
    Apex.SendUI('projectsList', Apex.Callback('project:list') or emptyProjects())
end

----------------------------------------------------------------------
-- Templates
----------------------------------------------------------------------
RegisterNUICallback('templatesList', function(_, cb)
    local templates = Apex.Callback('templates:list')
    Apex.SendUI('templatesList', { templates = templates or {} })
    cb({})
end)

RegisterNUICallback('templatesRescan', function(_, cb)
    local templates = Apex.Callback('templates:rescan')
    Apex.SendUI('templatesList', { templates = templates or {} })
    cb({})
end)

RegisterNUICallback('templatesSave', function(data, cb)
    local saved = Apex.Callback('templates:save', (data or {}).templates)
    cb({ ok = saved and true or false })
end)

----------------------------------------------------------------------
-- Live textures
----------------------------------------------------------------------
RegisterNUICallback('liveList', function(_, cb)
    local items = Apex.Callback('live:list')
    Apex.SendUI('liveList', { items = items or {} })
    cb({})
end)

RegisterNUICallback('liveRemove', function(data, cb)
    local removed = Apex.Callback('live:remove', (data or {}).name)
    cb({ ok = removed and true or false })
end)

RegisterNUICallback('liveClear', function(_, cb)
    local cleared = Apex.Callback('live:clear')
    cb({ ok = cleared and true or false })
end)

----------------------------------------------------------------------
-- Projects
----------------------------------------------------------------------
RegisterNUICallback('projectSave', function(data, cb)
    Apex.SendLarge('project_save', json.encode(data or {}))
    cb({ ok = true })
end)

RegisterNUICallback('projectList', function(_, cb)
    pushProjectList()
    cb({})
end)

RegisterNUICallback('projectGallery', function(_, cb)
    local items = Apex.Callback('project:gallery')
    Apex.SendUI('galleryList', items or { items = {} })
    cb({})
end)

RegisterNUICallback('projectPublish', function(data, cb)
    data = data or {}
    local done = Apex.Callback('project:publish', data.id, data.pub and true or false)
    cb({ ok = done and true or false })
end)

RegisterNUICallback('projectLoad', function(data, cb)
    data = data or {}
    local loaded = Apex.Callback('project:load', data.id)
    cb({})
    if not loaded then
        Apex.Notify(L('err_project_load', 'Could not load that project.'), 'error')
    end
end)

RegisterNUICallback('projectDelete', function(data, cb)
    data = data or {}
    local deleted = Apex.Callback('project:delete', data.id)
    cb({ ok = deleted and true or false })
end)

RegisterNUICallback('projectRename', function(data, cb)
    data = data or {}
    local renamed = Apex.Callback('project:rename', data.id, data.name)
    cb({ ok = renamed and true or false })
end)

RegisterNUICallback('projectShareCode', function(data, cb)
    data = data or {}
    local ok, code = Apex.Callback('project:shareCode', data.id)
    cb({ ok = ok and true or false, code = code })
    if ok and code then
        Apex.SendUI('shareCode', { id = data.id, code = code })
    end
end)

RegisterNUICallback('projectImportCode', function(data, cb)
    data = data or {}
    local ok, message = Apex.Callback('project:importCode', data.code)
    cb({ ok = ok and true or false, message = message })
    if ok then
        pushProjectList()
    end
end)

RegisterNUICallback('projectSharePlayer', function(data, cb)
    data = data or {}
    local ok, message = Apex.Callback('project:sharePlayer', data.id, data.target)
    cb({ ok = ok and true or false, message = message })
end)

--[[
    Apex Clothing Studio - client main
    PART 2 of 6: AI request path - reference image chunks and the aiGenerate callback.

    Replaces the decompiled block that creates the reference buffer table
    and ends before the dlChunk callback in build/client/main.lua.
    Depends on: Apex, Utils, RegisterNUICallback, TriggerServerEvent (FiveM globals).
]]

-- Reference images arrive from the UI in numbered pieces (seq starts at 1).
-- requestId -> { [seq] = piece }
local referenceBuffers = {}

local REFERENCE_LABEL = 'referência'   -- kept with its accent, as the UI shows it

RegisterNUICallback('aiRefChunk', function(data, cb)
    cb({})
    data = data or {}

    local requestId = tostring(data.requestId or '')
    if requestId == '' then return end

    local buffer = referenceBuffers[requestId]
    if not buffer then
        buffer = {}
        referenceBuffers[requestId] = buffer
    end

    local seq = tonumber(data.seq) or 0
    buffer[seq] = tostring(data.data or '')
end)

--- Joins the pieces received for requestId and forgets them. nil when none arrived.
local function takeReferenceBuffer(requestId)
    local buffer = referenceBuffers[requestId]
    if not buffer then return nil end
    referenceBuffers[requestId] = nil
    return table.concat(buffer)
end

--- Sends the reference to the server as a large transfer. Returns the transfer id.
local function sendReferenceToServer(reference)
    local transferId = Apex.SendLarge('ai_ref', reference)
    Utils.Log(('[AI 1b/3] %s (%d chars) enviada, transferId %s'):format(
        REFERENCE_LABEL, #reference, tostring(transferId)))
    return transferId
end

RegisterNUICallback('aiGenerate', function(data, cb)
    data = data or {}

    local requestId = tostring(data.requestId or '')
    local prompt = data.prompt or ''
    local hasReference = data.hasReference

    Utils.Log(('[AI 1/3] pedido recebido da UI - prompt %d chars, %s: %s'):format(
        #tostring(prompt), REFERENCE_LABEL, hasReference and 'sim' or 'não'))

    local reference
    if hasReference then
        reference = takeReferenceBuffer(requestId)
    elseif type(data.reference) == 'string' and data.reference ~= '' then
        reference = data.reference
    end

    local transferId
    if reference and reference ~= '' then
        transferId = sendReferenceToServer(reference)
    end

    TriggerServerEvent('apex_clothing:aiRequest',
        data.requestId, data.prompt, transferId, tostring(data.engine or ''))

    Utils.Log('[AI 2/3] pedido enviado ao servidor (evento apex_clothing:aiRequest)')
    cb({ accepted = true })
end)

--[[
    Apex Clothing Studio - client main
    PART 3 of 6: texture download, the help assistant, and the AI engine list.

    Replaces the decompiled block from the download buffer setup to just before
    the Config.preview section in build/client/main.lua.
    Depends on: Apex, Utils, L, RegisterNUICallback, RegisterNetEvent, TriggerServerEvent, json.
]]

----------------------------------------------------------------------
-- Texture download: the UI sends the PNG in numbered pieces (seq starts at 1)
----------------------------------------------------------------------
local downloadBuffer = {}   -- [seq] = piece

RegisterNUICallback('dlChunk', function(data, cb)
    cb({})
    data = data or {}
    local seq = tonumber(data.seq) or 0
    downloadBuffer[seq] = tostring(data.data or '')
end)

RegisterNUICallback('textureDownload', function(data, cb)
    data = data or {}

    local png = table.concat(downloadBuffer)
    downloadBuffer = {}

    if png == '' then
        cb({ ok = false })
        return
    end

    Apex.SendLarge('texture_dl', json.encode({
        name = tostring(data.name or 'texture'),
        png  = png,
    }))
    cb({ ok = true })
end)

--- Result of the server-side save. Success and failure carry different fields.
RegisterNetEvent('apex_clothing:downloadDone', function(ok, value)
    local result = { ok = ok and true or false }

    -- path is only set on success, message only on failure
    if ok and value then
        result.path = value
    end
    if not ok and value then
        result.message = value
    end
    Apex.SendUI('downloadDone', result)

    if ok then
        Apex.Notify(L('dl_ok', 'PNG saved: %s', tostring(value)), 'success')
    end
end)

----------------------------------------------------------------------
-- Language names shown in the help assistant
----------------------------------------------------------------------
local LANGUAGE_NAMES = {
    en      = 'English',
    pt      = 'European Portuguese (pt-PT)',
    ['pt-br'] = 'Brazilian Portuguese (pt-BR)',
    es      = 'Spanish',
    fr      = 'French',
    de      = 'German',
    it      = 'Italian',
    ja      = 'Japanese',
    tr      = 'Turkish',
}

----------------------------------------------------------------------
-- Help assistant
----------------------------------------------------------------------
RegisterNUICallback('aiSupport', function(data, cb)
    data = data or {}

    local language = LANGUAGE_NAMES[Utils.ActiveLocale()] or 'English'
    local history = type(data.history) == 'table' and data.history or {}

    TriggerServerEvent('apex_clothing:aiSupport',
        tostring(data.requestId or ''),
        tostring(data.question or ''),
        language,
        history)

    cb({ accepted = true })
end)

--- The server's answer. Errors may arrive as a locale key ("#key") that is translated here.
RegisterNetEvent('apex_clothing:aiSupportDone', function(requestId, ok, text)
    local message = tostring(text or '')

    if not ok and message:sub(1, 1) == '#' then
        message = L(message:sub(2), message)
    end

    Apex.SendUI('aiSupportResult', {
        requestId = requestId,
        ok        = ok and true or false,
        text      = message,
    })
end)

----------------------------------------------------------------------
-- Engine list for the studio's engine picker
----------------------------------------------------------------------
RegisterNUICallback('aiEngines', function(data, cb)
    local result = Apex.Callback('ai:engines')
    if type(result) ~= 'table' or not result then
        result = { engines = {}, support = false }
    end
    cb(result)
end)

--[[
    Apex Clothing Studio - client main
    PART 4a of 6: texture candidate lookup and ped component/prop info.

    Replaces the decompiled block from the raceSuffixes setup up to (not including)
    the helper that comes right after the component info helper in build/client/main.lua.
    Depends on: Config, Apex, PlayerPedId and the GetPed* natives (FiveM globals).
]]

----------------------------------------------------------------------
-- Race suffixes used to find sibling texture files (uni_xxx / whi_xxx / bla_xxx)
----------------------------------------------------------------------
local RACE_SUFFIXES = (Config.preview and Config.preview.raceSuffixes)
    or { 'uni', 'whi', 'bla' }

--- Given a texture dictionary (txd) and texture name (txn), returns every
--- {txd, txn} pair the live retexture should replace: the pair itself, plus
--- the same texture under the other race suffixes when it has one of them.
local function collectTextureCandidates(txd, txn)
    local pairs_ = {}
    local seen = {}

    local function add(dictionary, name)
        if type(dictionary) ~= 'string' or dictionary == '' then return end
        if type(name) ~= 'string' or name == '' then return end
        local key = dictionary .. '|' .. name
        if seen[key] then return end
        seen[key] = true
        pairs_[#pairs_ + 1] = { txd = dictionary, txn = name }
    end

    if type(txd) ~= 'string' or type(txn) ~= 'string' then
        return pairs_
    end

    add(txd, txn)

    local base, suffix = txn:match('^(.+)_(%a%a%a)$')
    local isRaceSuffix = false
    for _, candidate in ipairs(RACE_SUFFIXES) do
        if candidate == suffix then
            isRaceSuffix = true
        end
    end

    if base and isRaceSuffix then
        local directory = txd:match('^(.*/)') or ''
        for _, candidate in ipairs(RACE_SUFFIXES) do
            if candidate ~= suffix then
                local name = base .. '_' .. candidate
                add(directory .. name, name)
            end
        end
    end

    return pairs_
end

----------------------------------------------------------------------
-- Ped component / prop information
----------------------------------------------------------------------
--- Reads the current drawable, texture and collection of a component (or prop) slot.
--- kind: 'component' (default) or 'prop'. Returns nil when the ped or the slot is unusable.
local function readPedComponentInfo(request)
    if type(request) ~= 'table' then return nil end

    local ped = PlayerPedId()
    local model = Apex.GetPedModelName(ped)
    if not model then return nil end

    local kind = tostring(request.kind or 'component')
    local slot = math.floor(tonumber(request.id) or -1)
    if slot < 0 then return nil end

    local info = { model = model, kind = kind, id = slot, coll = '' }

    if kind == 'component' then
        info.drawable = GetPedDrawableVariation(ped, slot)
        if info.drawable == nil or info.drawable < 0 then
            return info
        end

        info.texture = GetPedTextureVariation(ped, slot)
        info.textures = GetNumberOfPedTextureVariations(ped, slot, info.drawable)
        info.localIndex = info.drawable

        local okName, collectionName = pcall(GetPedDrawableVariationCollectionName, ped, slot)
        local okLocal, localIndex = pcall(GetPedDrawableVariationCollectionLocalIndex, ped, slot)
        if okName and okLocal
            and type(collectionName) == 'string'
            and type(localIndex) == 'number' and localIndex >= 0 then
            info.localIndex = localIndex
            info.coll = collectionName
        end
        return info
    end

    -- props
    info.drawable = GetPedPropIndex(ped, slot)
    if info.drawable == nil or info.drawable < 0 then
        return info
    end

    info.texture = GetPedPropTextureIndex(ped, slot)
    info.textures = GetNumberOfPedPropTextureVariations(ped, slot, info.drawable)
    info.localIndex = info.drawable

    local okName, collectionName = pcall(GetPedCollectionNameFromProp, ped, slot, info.drawable)
    local okLocal, localIndex = pcall(GetPedCollectionLocalIndexFromProp, ped, slot, info.drawable)
    if okName and okLocal
        and type(collectionName) == 'string'
        and type(localIndex) == 'number' and localIndex >= 0 then
        info.localIndex = localIndex
        info.coll = collectionName
    end
    return info
end

--[[
    Apex Clothing Studio - client main
    PART 4b1 of 6: naming helpers for the export report.

    Replaces the decompiled block for the template-name split and collection
    description, up to the cache initialisation, in build/client/main.lua.
    The diagnostics builder is part 4b2.
]]

--- Splits a texture path such as "models/.../mp_m_freemode_01_jbib_007_u"
--- into the model prefix and the rest of the name.
--- kind 'prop' also drops the leading "_p" of prop names.
local function splitTemplateName(path, kind)
    local text = tostring(path or '')

    local base = text:match('^(.-)/') or text
    local prefix = base:match('^(mp_[mf]_freemode_01)') or base
    local rest = base:sub(#prefix + 1)

    if kind == 'prop' then
        rest = rest:gsub('^_p', '')
    end

    return prefix, (rest:gsub('^_', ''))
end

--- How a collection name is shown in the report: quoted, or "base game" when empty.
local function describeCollection(collection)
    if collection == nil or collection == '' then
        return L('export_coll_base', 'base game')
    end
    return ('"%s"'):format(collection)
end

-- Shared with the report builder (part 4b2): the last issues list and wearing text.
local lastIssues = {}
local lastWearing = nil

--[[
    Apex Clothing Studio - client main
    PART 4b2 of 6: the export report - what the worn garment is and what would stop
    a pack from showing it.

    Replaces the decompiled report builder in build/client/main.lua (the function
    that fills the per-texture report and prints the export hints).
    Depends on: L (translator), print, readPedComponentInfo, collectTextureCandidates,
    splitTemplateName, describeCollection, lastIssues, lastWearing (parts 4a and 4b1).
]]

-- English texts. Used when the locale has no entry for the key.
local FALLBACK = {
    not_worn = 'You are not wearing anything in that slot right now. Put the garment on before exporting so the studio can check it targets the right item.',
    gender   = 'This template belongs to the %s ped, but your character is %s - the texture only exists on the other model.',
    collection = 'You are wearing this as drawable %d of the %s collection, so that texture name is replaced as well (the template file said %s).',
    no_variant = 'In game this garment has only %d texture variant(s) (A-%s). Variant %s does not exist for it, so a pack cannot show it: export variant A instead, or stream your own .ytd for the new one.',
    wrong_item = 'You are wearing drawable %d of the %s collection, but this export targets drawable %d of the %s collection. Put that exact item on to see the design.',
}

--- Builds the per-texture report for an export.
--- context.slot     : { kind = 'component'|'prop', id = <slot number> }
--- context.textures : list of { txd, txn, png }
--- Returns the report (same order as context.textures) and the "wearing" line (or nil).
local function buildExportReport(context)
    local report = {}
    local issues = {}
    local seenIssue = {}

    local function addIssue(key, fallback, ...)
        local text = L(key, fallback, ...)
        if seenIssue[text] then return end
        seenIssue[text] = true
        issues[#issues + 1] = text
    end

    local info = readPedComponentInfo(context.slot)

    local wearing
    if info and info.drawable and info.drawable >= 0 then
        wearing = ('%s slot %d: drawable %d (%s, local index %d), texture %d of %d'):format(
            info.kind, info.id, info.drawable,
            (info.coll ~= '' and info.coll) or 'base game',
            info.localIndex or info.drawable,
            info.texture or 0,
            info.textures or 0)
    end

    for index, entry in ipairs(context.textures or {}) do
        local candidates = collectTextureCandidates(entry.txd, entry.txn)

        local txn = tostring(entry.txn or '')
        local _, digits, letter = txn:match('^(.-)_diff_(%d+)_(%a)')
        local tplNumber = digits and tonumber(digits) or nil

        local kind = (info and info.kind) or 'component'
        local _, rest = splitTemplateName(entry.txd, kind)

        if info and tplNumber then
            if info.drawable ~= nil and not (info.drawable < 0) then
                local templateModel = splitTemplateName(entry.txd, kind)

                if templateModel ~= info.model then
                    addIssue('export_hint_gender', FALLBACK.gender, templateModel, info.model)
                else
                    local localIndex = info.localIndex or info.drawable

                    if localIndex == tplNumber then
                        if info.coll ~= rest then
                            -- the name the game would use for this item
                            local expectedModel = info.model
                                .. ((info.coll ~= '' and ('_' .. info.coll)) or '')
                            if info.kind == 'prop' then
                                expectedModel = info.model
                                    .. '_p'
                                    .. ((info.coll ~= '' and ('_' .. info.coll)) or '')
                            end

                            local extra = collectTextureCandidates(expectedModel .. '/' .. txn, txn)
                            for _, candidate in ipairs(extra) do
                                candidates[#candidates + 1] = candidate
                            end

                            addIssue('export_hint_collection', FALLBACK.collection,
                                tplNumber, describeCollection(info.coll), describeCollection(rest))
                        end

                        local variant = 0
                        if letter then
                            variant = letter:lower():byte() - 97
                        end
                        if type(info.textures) == 'number' and info.textures > 0
                            and variant >= info.textures then
                            addIssue('export_hint_no_variant', FALLBACK.no_variant,
                                info.textures, string.char(64 + info.textures), (letter or ''):upper())
                        end
                    else
                        addIssue('export_hint_wrong_item', FALLBACK.wrong_item,
                            localIndex, describeCollection(info.coll), tplNumber, describeCollection(rest))
                    end
                end
            else
                addIssue('export_hint_not_worn', FALLBACK.not_worn)
            end
        end

        report[index] = {
            txd        = entry.txd,
            txn        = entry.txn,
            png        = entry.png,
            candidates = candidates,
        }
    end

    if wearing then
        print('^5[apex_clothing]^7 export: wearing ' .. wearing)
    end
    for _, issue in ipairs(issues) do
        print('^3[apex_clothing]^7 export: ' .. issue)
    end

    lastIssues = issues
    lastWearing = wearing
    return report, wearing
end

--[[
    Apex Clothing Studio - client main
    PART 4c of 6: the export request from the studio.

    Replaces the decompiled exportRun callback in build/client/main.lua.
    Depends on: buildExportReport (part 4b2), collectTextureCandidates (part 4a),
    Apex, Utils, json, RegisterNUICallback.
]]

RegisterNUICallback('exportRun', function(data, cb)
    data = data or {}

    local ok, report, wearing = pcall(buildExportReport, data)

    if not ok then
        Utils.Err('export cross-check failed: ' .. tostring(report))

        -- Fallback: send the textures without hints, so the export still goes through.
        report = {}
        for index, entry in ipairs(data.textures or {}) do
            report[index] = {
                txd        = entry.txd,
                txn        = entry.txn,
                png        = entry.png,
                candidates = collectTextureCandidates(entry.txd, entry.txn),
            }
        end
        wearing = nil
        lastWearing = nil
        lastIssues = {}
    end

    Apex.SendLarge('export_run', json.encode({
        mode     = data.mode,
        name     = data.name,
        slot     = data.slot,
        worn     = wearing,
        textures = report,
    }))

    cb({ accepted = true })
end)

--[[
    Apex Clothing Studio - client main
    PART 5a of 6: returning an AI result to the studio UI.

    Replaces the decompiled image delivery function, the "ai_result" large-transfer
    handler and the aiDone event in build/client/main.lua.
    (This is where the original crashed with "attempt to compare number with nil".)
    Depends on: Apex, Utils, json, Wait, RegisterNetEvent.
]]

local IMAGE_CHUNK_SIZE = 200000   -- characters per NUI message

--- The server sends bare base64. Browsers need a data URL, and the label should
--- match the picture (Cloudflare and Gemini send JPEG, OpenAI sends PNG).
local function asDataUrl(image)
    image = tostring(image or '')
    if image:sub(1, 5) == 'data:' then return image end

    local mime = 'image/png'
    if image:sub(1, 4) == '/9j/' then
        mime = 'image/jpeg'
    elseif image:sub(1, 5) == 'UklGR' then
        mime = 'image/webp'
    elseif image:sub(1, 5) == 'R0lGO' then
        mime = 'image/gif'
    end
    return ('data:%s;base64,%s'):format(mime, image)
end

--- Sends the picture to the UI in pieces (one NUI message may not be too big).
local function deliverImageToUi(requestId, dataUrl)
    local total = math.max(1, math.ceil(#dataUrl / IMAGE_CHUNK_SIZE))
    Utils.Log(('[AI 3/3] delivering the image to the UI in %d part(s)'):format(total))

    Apex.SendUI('aiImageBegin', { requestId = requestId, total = total })

    for seq = 1, total do
        local first = (seq - 1) * IMAGE_CHUNK_SIZE + 1
        Apex.SendUI('aiImageChunk', {
            requestId = requestId,
            seq       = seq,
            data      = dataUrl:sub(first, first + IMAGE_CHUNK_SIZE - 1),
        })
        Wait(0)
    end

    Apex.SendUI('aiImageEnd', { requestId = requestId })
end

-- Normal path: the server sends the result as a large transfer (JSON text).
Apex.OnLarge('ai_result', function(_, _, data)
    Utils.Log(('[AI 3/3] resultado recebido do servidor (%d chars)'):format(#tostring(data or '')))

    local decoded, payload = pcall(json.decode, data)
    if not decoded or type(payload) ~= 'table' then
        Utils.Err('ai_result payload could not be decoded')
        return
    end

    if payload.ok then
        deliverImageToUi(payload.requestId, asDataUrl(payload.image))
    else
        Apex.SendUI('aiError', { requestId = payload.requestId, message = payload.message })
    end
end)

-- Direct path (older servers) and every failure: (requestId, ok, imageOrMessage).
RegisterNetEvent('apex_clothing:aiDone', function(requestId, ok, result)
    Utils.Log(('[AI 3/3] aiDone - ok=%s %s'):format(
        tostring(ok),
        ok and 'imagem recebida' or ('erro: ' .. tostring(result))))

    if ok then
        deliverImageToUi(requestId, asDataUrl(result))
    else
        Apex.SendUI('aiError', { requestId = requestId, message = result })
    end
end)

--[[
    Apex Clothing Studio - client main
    PART 5b of 6: project and export events, the /testai command, resource stop,
    and the public ApexMain table. This is the end of the file.

    Replaces the last ~280 decompiled lines of build/client/main.lua (from the
    project_load transfer handler to the end).
    Depends on: studioOpen, openStudio, closeStudio (part 1), lastIssues, lastWearing
    (part 4b1), Apex, Utils, L, json, Preview, Stage, Wardrobe.
]]

----------------------------------------------------------------------
-- Projects
----------------------------------------------------------------------
-- A project the server sends as a large transfer (JSON text).
Apex.OnLarge('project_load', function(_, _, data)
    local decoded, project = pcall(json.decode, data)

    if decoded then
        if type(project) == 'table' then
            Apex.SendUI('projectLoaded', project)
        end
    else
        Utils.Err('project_load payload could not be decoded')
        Apex.Notify(L('err_project_load', 'Could not load that project.'), 'error')
    end
end)

RegisterNetEvent('apex_clothing:projectSaved', function(ok, id, name, errorMessage)
    Apex.SendUI('projectSaved', { ok = ok and true or false, id = id, name = name })

    if ok then
        Apex.Notify(L('project_saved', 'Project "%s" saved.', tostring(name or '')), 'success')
    else
        local message = errorMessage or L('err_project_save', 'Could not save the project.')
        Apex.Notify(message, 'error')
    end
end)

RegisterNetEvent('apex_clothing:projectShared', function(sharerName)
    Apex.Notify(
        L('project_shared_toast', '%s shared a clothing project with you.', tostring(sharerName or 'Someone')),
        'success')

    -- Refresh the list when the studio is open.
    if studioOpen then
        local projects = Apex.Callback('project:list')
        Apex.SendUI('projectsList', projects or { mine = {}, shared = {} })
    end
end)

----------------------------------------------------------------------
-- Export result
----------------------------------------------------------------------
RegisterNetEvent('apex_clothing:exportDone', function(ok, mode, path, messageKey, details)
    local defaultMessage = ok and 'Export complete.' or 'Export failed.'
    local key = messageKey or (ok and 'export_done' or 'export_failed')

    if type(details) ~= 'table' or not details then
        details = {}
    end

    Apex.SendUI('exportResult', {
        ok       = ok and true or false,
        mode     = mode,
        path     = path,
        message  = L(key, defaultMessage),
        slug     = details.slug,
        nested   = details.nested,
        files    = details.files,
        prefix   = details.prefix,
        textures = details.textures,
        pairs    = details.pairs,
        players  = details.players,
        hints    = lastIssues,
        worn     = lastWearing,
    })

    -- The hints belong to this export only.
    lastIssues = {}
    lastWearing = nil
end)

----------------------------------------------------------------------
-- /testai: asks the server for a test texture (check the F8 console)
----------------------------------------------------------------------
RegisterCommand('testai', function()
    local requestId = 'test_' .. tostring(GetGameTimer())

    Utils.Log('/testai - requesting a test texture from the server...')
    Apex.Notify(L('ai_test_started', 'AI test started - result in the F8 console in ~10s.'), 'info')
    TriggerServerEvent('apex_clothing:aiRequest', requestId, 'seamless red plaid fabric texture', nil)
end, false)

Utils.Log('client v18 loaded (transporte latente)')

----------------------------------------------------------------------
-- Cleanup when the resource stops
----------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    studioOpen = false
    Apex.uiOpen = false
    SetNuiFocus(false, false)
    pcall(Preview.Clear)
    pcall(Stage.Exit)
    pcall(Wardrobe.Restore)
end)

----------------------------------------------------------------------
-- Public API for other resources
----------------------------------------------------------------------
ApexMain = {
    Open   = openStudio,
    Close  = closeStudio,
    IsOpen = function() return studioOpen end,
}