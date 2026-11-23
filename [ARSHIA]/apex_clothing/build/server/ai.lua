--[[
    Apex Clothing Studio - AI module (server side)
    Clean rewrite, v19.

    What this file does
      * Generates textures with an image provider and sends the result
        to the player who asked for it.
      * Answers questions in the studio's help panel (optional).

    Protocol with the client (unchanged from the original resource)
      callback  ai:engines                  -> { engines, defaultEngine, support }
      event     apex_clothing:aiRequest     (requestId, prompt, refTransferId, engineId)
      large     ai_ref                      reference image uploaded by the client
      large     ai_result                   { requestId, ok = true, image = <base64> }
      event     apex_clothing:aiDone        (requestId, false, errorMessage)
      event     apex_clothing:aiSupport     (questionId, question, language, history)
      event     apex_clothing:aiSupportDone (questionId, ok, text)

    Where the API key comes from (first match wins)
      1. secret.txt next to fxmanifest.lua  (server only, never sent to players)
      2. the convar named by the engine's keyConvar (default apex_clothing_ai_key)
      3. Config.ai.apiKey                    (not recommended: shared with players)

    Providers: gemini, together, fal, openai, custom (e.g. Cloudflare Workers AI).
    Run  apexai_test  in the SERVER console for a full self-test.
]]

local RESOURCE      = GetCurrentResourceName()
local VERSION       = 'v19-clean'
local MAIN_KEY_NAME = 'apex_clothing_ai_key'

----------------------------------------------------------------------
-- Logging. Always prints (Utils.Log is silent unless Config.debug).
----------------------------------------------------------------------
local function say(colour, fmt, ...)
    local ok, text = pcall(string.format, fmt, ...)
    print(('^%d[apex_clothing:ai]^7 %s'):format(colour, ok and text or tostring(fmt)))
end
local function logInfo(...)  say(5, ...) end
local function logWarn(...)  say(3, ...) end
local function logError(...) say(1, ...) end

----------------------------------------------------------------------
-- Small helpers
----------------------------------------------------------------------
local function trim(text)
    return (tostring(text or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

local function excerpt(text, limit)
    local flat = tostring(text or ''):gsub('%s+', ' ')
    return flat:sub(1, limit or 300)
end

local function aiConfig()
    return (Config and Config.ai) or {}
end

local function providerConfig(name)
    local section = aiConfig()[name]
    return type(section) == 'table' and section or {}
end

local function decode(text)
    local ok, value = pcall(json.decode, text)
    if ok and type(value) == 'table' then return value end
    return nil
end

--- Follows "a.b.0.c" through decoded JSON (numeric parts are 0-based).
local function walkPath(root, path)
    local node = root
    for part in tostring(path or ''):gmatch('[^.]+') do
        if type(node) ~= 'table' then return nil end
        local index = tonumber(part)
        if index ~= nil then node = node[index + 1] else node = node[part] end
    end
    if type(node) == 'string' and node ~= '' then return node end
    return nil
end

local function stripDataUrl(text)
    if type(text) ~= 'string' then return nil end
    return text:match('^data:image/[%w+.%-]+;base64,(.+)$') or text
end

----------------------------------------------------------------------
-- API keys
----------------------------------------------------------------------
local function cleanKey(raw)
    if type(raw) ~= 'string' then return '' end
    return (raw:gsub('^[%s"\']+', ''):gsub('[%s"\']+$', ''))
end

local function readSecretFile()
    local raw = LoadResourceFile(RESOURCE, 'secret.txt')
    if type(raw) ~= 'string' then return '' end
    return cleanKey((raw:gsub('%s+', '')))
end

local function keyConvarOf(engine)
    local name = engine and engine.keyConvar
    if type(name) == 'string' and name ~= '' then return name end
    return MAIN_KEY_NAME
end

--- Returns key, sourceDescription. key is '' when nothing is configured.
local function resolveKey(engine)
    local convarName = keyConvarOf(engine)
    if convarName == MAIN_KEY_NAME then
        local fromFile = readSecretFile()
        if fromFile ~= '' then return fromFile, 'secret.txt' end
    end
    local fromConvar = cleanKey(GetConvar(convarName, ''))
    if fromConvar ~= '' then return fromConvar, 'convar ' .. convarName end
    if convarName == MAIN_KEY_NAME then
        local fromConfig = cleanKey(aiConfig().apiKey or '')
        if fromConfig ~= '' then return fromConfig, 'Config.ai.apiKey' end
    end
    return '', 'not set'
end

local function resolveSupportKey()
    local name = (aiConfig().support or {}).keyConvar
    if type(name) == 'string' and name ~= '' and name ~= MAIN_KEY_NAME then
        local own = cleanKey(GetConvar(name, ''))
        if own ~= '' then return own end
    end
    return (resolveKey(nil))
end

--- Safe to print: first 5 characters and the length only.
local function describeKey(key, source)
    if key == '' then return 'NOT SET' end
    return ('%s... (%d chars, from %s)'):format(key:sub(1, 5), #key, source)
end

----------------------------------------------------------------------
-- Engines (what the studio offers in its engine picker)
----------------------------------------------------------------------
local function enabledEngines()
    local list = {}
    for _, engine in ipairs(aiConfig().engines or {}) do
        if type(engine) == 'table' and engine.enabled ~= false and engine.id and engine.provider then
            list[#list + 1] = engine
        end
    end
    return list
end

local function pickEngine(wantedId)
    local list = enabledEngines()
    for _, engine in ipairs(list) do
        if engine.id == wantedId then return engine end
    end
    local defaultId = aiConfig().defaultEngine
    if defaultId then
        for _, engine in ipairs(list) do
            if engine.id == defaultId then return engine end
        end
    end
    return list[1]
end

function AiEnginesForUi()
    local result = {}
    for _, engine in ipairs(enabledEngines()) do
        local key = resolveKey(engine)
        result[#result + 1] = {
            id       = engine.id,
            labelKey = engine.labelKey,
            descKey  = engine.descKey,
            icon     = engine.icon,
            ready    = key ~= '',
        }
    end
    return result
end

----------------------------------------------------------------------
-- Prompt cleaning and rate limiting
----------------------------------------------------------------------
local function cleanPrompt(raw)
    local text = trim(tostring(raw or ''):gsub('%c', ' '))
    if #text < 3 then return nil end
    if #text > 1500 then text = text:sub(1, 1500) end
    return text
end

local function newLimiter(getCooldown, getMaxPerHour)
    local players = {}
    local limiter = {}

    local function record(id)
        players[id] = players[id] or { lastAt = 0, stamps = {} }
        return players[id]
    end

    --- true, or false + locale key
    function limiter.check(id)
        local now, entry = os.time(), record(id)
        if now - entry.lastAt < getCooldown() then return false, '#ai_err_cooldown' end
        local recent = {}
        for _, stamp in ipairs(entry.stamps) do
            if now - stamp < 3600 then recent[#recent + 1] = stamp end
        end
        entry.stamps = recent
        if #recent >= getMaxPerHour() then return false, '#ai_err_quota' end
        return true
    end

    function limiter.mark(id)
        local entry = record(id)
        entry.lastAt = os.time()
        entry.stamps[#entry.stamps + 1] = entry.lastAt
    end

    --- Give the hourly slot back after a failure (cooldown still applies).
    function limiter.refund(id)
        local entry = players[id]
        if entry and #entry.stamps > 0 then table.remove(entry.stamps) end
    end

    return limiter
end

local imageLimiter = newLimiter(
    function() return tonumber(aiConfig().cooldownSeconds) or 20 end,
    function() return tonumber(aiConfig().maxPerHour) or 20 end
)

local supportLimiter = newLimiter(
    function() return tonumber((aiConfig().support or {}).cooldownSeconds) or 5 end,
    function() return tonumber((aiConfig().support or {}).maxPerHour) or 60 end
)

local function playerIdentifier(src)
    local ok, identifier = pcall(function() return Bridge.GetIdentifier(src) end)
    if ok and identifier then return identifier end
    return 'src:' .. tostring(src)
end

----------------------------------------------------------------------
-- Reference images uploaded by the client ("use canvas as reference")
----------------------------------------------------------------------
local references = {}

Apex.OnLarge('ai_ref', function(src, transferId, data)
    references[('%d_%s'):format(src, tostring(transferId))] = { data = data, at = os.time() }
end)

CreateThread(function()
    while true do
        Wait(300000)
        local now = os.time()
        for id, entry in pairs(references) do
            if now - (entry.at or 0) > 300 then references[id] = nil end
        end
    end
end)

--- Waits up to 10 s for the upload to arrive. Returns base64 or nil.
local function takeReference(src, transferId)
    if type(transferId) ~= 'string' or transferId == '' then return nil end
    local id = ('%d_%s'):format(src, transferId)
    for _ = 1, 100 do
        local entry = references[id]
        if entry then
            references[id] = nil
            return stripDataUrl(entry.data)
        end
        Wait(100)
    end
    return nil
end

----------------------------------------------------------------------
-- HTTP
----------------------------------------------------------------------
local function request(url, method, body, headers)
    local waiting = promise.new()
    PerformHttpRequest(url, function(status, responseBody, responseHeaders, errorData)
        waiting:resolve({
            status  = tonumber(status) or 0,
            body    = responseBody or '',
            headers = responseHeaders or {},
            err     = errorData,
        })
    end, method or 'POST', body or '', headers or { ['Content-Type'] = 'application/json' })
    return Citizen.Await(waiting)
end

local function requestJson(url, method, payload, headers)
    return request(url, method, payload and json.encode(payload) or '', headers)
end

local function headerOf(response, wanted)
    wanted = wanted:lower()
    for name, value in pairs(response.headers or {}) do
        if tostring(name):lower() == wanted then return tostring(value) end
    end
    return nil
end

local function describeResponse(response)
    local parts = { 'HTTP ' .. tostring(response.status) }
    for _, name in ipairs({ 'content-type', 'server', 'www-authenticate', 'cf-ray' }) do
        local value = headerOf(response, name)
        if value then parts[#parts + 1] = name .. '=' .. value end
    end
    if response.err then parts[#parts + 1] = 'err=' .. tostring(response.err) end
    parts[#parts + 1] = 'body=' .. excerpt(response.body, 400)
    return table.concat(parts, ' | ')
end

--- Logs the failure and maps it to the locale key the studio understands.
local function classifyFailure(provider, response)
    logError('%s request failed -> %s', provider, describeResponse(response))
    local status, body = response.status, tostring(response.body or ''):lower()
    if status == 0 then return nil, '#ai_err_timeout' end
    if status == 401 or status == 403 then return nil, '#ai_err_nokey' end
    if status == 402 or status == 429
        or body:find('insufficient_quota', 1, true)
        or body:find('credit_balance', 1, true) then
        return nil, '#ai_err_provider_quota'
    end
    return nil, '#ai_err_provider'
end

----------------------------------------------------------------------
-- Pulling images and text out of provider responses
----------------------------------------------------------------------
local IMAGE_KEYS = {
    'b64_json', 'partial_image_b64', 'result', 'image', 'url', 'image_url', 'b64',
    'data', 'inlineData', 'inline_data', 'images', 'output', 'candidates',
    'content', 'parts', 'response',
}

local function looksLikeBase64(text)
    return type(text) == 'string' and #text > 1000 and not text:find('[^%w+/=%s]')
end

local function findImage(node, depth)
    depth = depth or 0
    if depth > 8 then return nil end

    if type(node) == 'string' then
        if node:sub(1, 11) == 'data:image/' then return stripDataUrl(node) end
        if looksLikeBase64(node) then return (node:gsub('%s+', '')) end
        return nil
    end
    if type(node) ~= 'table' then return nil end

    for _, key in ipairs(IMAGE_KEYS) do
        if node[key] ~= nil then
            local found = findImage(node[key], depth + 1)
            if found then return found end
        end
    end
    for _, value in ipairs(node) do
        local found = findImage(value, depth + 1)
        if found then return found end
    end
    for _, value in pairs(node) do
        if type(value) == 'table' then
            local found = findImage(value, depth + 1)
            if found then return found end
        end
    end
    return nil
end

--- Server-sent events: the LAST image wins (partial previews come first).
local function imageFromEvents(body)
    local last
    for chunk in tostring(body):gmatch('data:%s*(%b{})') do
        local event = decode(chunk)
        if event then last = findImage(event) or last end
    end
    return last
end

local function imageFromBody(body)
    local parsed = decode(body)
    if parsed then
        local found = findImage(parsed)
        if found then return found end
    end
    return imageFromEvents(body)
end

local function textFromEvents(body)
    local pieces = {}
    for chunk in tostring(body):gmatch('data:%s*(%b{})') do
        local event = decode(chunk)
        local candidate = event and type(event.candidates) == 'table' and event.candidates[1]
        local parts = candidate and candidate.content and candidate.content.parts
        if type(parts) == 'table' then
            for _, part in ipairs(parts) do
                if type(part) == 'table' and type(part.text) == 'string' and part.text ~= '' then
                    pieces[#pieces + 1] = part.text
                end
            end
        end
    end
    if #pieces == 0 then return nil end
    return table.concat(pieces)
end

----------------------------------------------------------------------
-- Image providers
-- Every provider is function(prompt, referenceBase64OrNil, key)
-- and returns  imageBase64  or  nil, '#locale_key'.
----------------------------------------------------------------------
local providers = {}

-- Google Gemini ------------------------------------------------------
providers.gemini = function(prompt, reference, key)
    local cfg = providerConfig('gemini')
    local models = { cfg.model or 'gemini-2.5-flash-image' }
    for _, name in ipairs(cfg.fallbackModels or {
        'gemini-3.1-flash-lite-image', 'gemini-3.1-flash-image', 'gemini-3-pro-image',
    }) do
        if name ~= models[1] then models[#models + 1] = name end
    end

    local parts = { { text = prompt } }
    if reference then
        parts[#parts + 1] = { inlineData = { mimeType = 'image/png', data = reference } }
    end
    local payload = {
        contents         = { { parts = parts } },
        generationConfig = { responseModalities = { 'TEXT', 'IMAGE' } },
    }
    local headers = { ['Content-Type'] = 'application/json', ['x-goog-api-key'] = key }
    local base = 'https://generativelanguage.googleapis.com/v1beta/models/%s:%s'

    for index, model in ipairs(models) do
        local response
        for attempt = 1, 5 do
            response = requestJson(base:format(model, 'streamGenerateContent?alt=sse'), 'POST', payload, headers)
            if response.status ~= 0 then break end
            logWarn('gemini: no response within 5 s (attempt %d/5) - retrying', attempt)
            Wait(400)
        end

        if response.status == 200 then
            local image = imageFromEvents(response.body) or imageFromBody(response.body)
            if image then return image end
            -- Streaming gave nothing: try the plain endpoint once.
            local direct = requestJson(base:format(model, 'generateContent'), 'POST', payload, headers)
            if direct.status == 200 then
                image = imageFromBody(direct.body)
                if image then return image end
            end
            logError('gemini: HTTP 200 but no image part. body=%s', excerpt(response.body, 400))
            return nil, '#ai_err_provider'
        elseif response.status == 400 or response.status == 404 then
            if models[index + 1] then
                logWarn('gemini: model "%s" refused (HTTP %d) - trying "%s"', model, response.status, models[index + 1])
            else
                logError('gemini: no model accepted the request (or the key is invalid) -> %s', describeResponse(response))
                return nil, '#ai_err_nokey'
            end
        else
            return classifyFailure('gemini', response)
        end
    end
    return nil, '#ai_err_provider'
end

-- Together AI --------------------------------------------------------
providers.together = function(prompt, reference, key)
    local cfg = providerConfig('together')
    local payload
    if reference then
        payload = {
            model           = cfg.editModel or 'black-forest-labs/FLUX.1-kontext-pro',
            prompt          = prompt,
            image_url       = 'data:image/png;base64,' .. reference,
            response_format = 'base64',
        }
    else
        payload = {
            model           = cfg.model or 'black-forest-labs/FLUX.1-schnell',
            prompt          = prompt,
            width           = cfg.width or 1024,
            height          = cfg.height or 1024,
            steps           = cfg.steps or 4,
            n               = 1,
            response_format = 'base64',
        }
    end
    local headers = { ['Content-Type'] = 'application/json', ['Authorization'] = 'Bearer ' .. key }

    for attempt = 1, 2 do
        local response = requestJson('https://api.together.ai/v1/images/generations', 'POST', payload, headers)
        if response.status == 200 then
            local image = imageFromBody(response.body)
            if image then return image end
            logError('together: HTTP 200 but no image. body=%s', excerpt(response.body, 400))
            return nil, '#ai_err_provider'
        elseif response.status == 0 and attempt == 1 then
            logWarn('together: no response within 5 s - retrying once')
            Wait(1000)
        else
            return classifyFailure('together', response)
        end
    end
    return nil, '#ai_err_timeout'
end

-- fal.ai (queue API: submit, then poll) --------------------------------
providers.fal = function(prompt, reference, key)
    local cfg = providerConfig('fal')
    local model = reference and (cfg.editModel or 'fal-ai/flux-kontext/dev')
                            or (cfg.model or 'fal-ai/flux/schnell')
    local headers = { ['Content-Type'] = 'application/json', ['Authorization'] = 'Key ' .. key }

    local payload = { prompt = prompt, sync_mode = true, output_format = 'jpeg' }
    if reference then
        payload.image_url = 'data:image/png;base64,' .. reference
        payload.resolution_mode = 'match_input'
    else
        payload.image_size = 'square_hd'
    end

    local submit = requestJson('https://queue.fal.run/' .. model, 'POST', payload, headers)
    if submit.status ~= 200 and submit.status ~= 201 and submit.status ~= 202 then
        return classifyFailure('fal', submit)
    end
    local submitted = decode(submit.body)
    if not submitted then
        logError('fal: submit answered but not with JSON. body=%s', excerpt(submit.body, 300))
        return nil, '#ai_err_provider'
    end
    local immediate = findImage(submitted)
    if immediate then return immediate end

    local requestId = submitted.request_id
    local statusUrl = submitted.status_url
        or (requestId and ('https://queue.fal.run/%s/requests/%s/status'):format(model, requestId))
    local resultUrl = submitted.response_url
        or (requestId and ('https://queue.fal.run/%s/requests/%s'):format(model, requestId))
    if not statusUrl or not resultUrl then
        logError('fal: no request id / status url in the answer. body=%s', excerpt(submit.body, 300))
        return nil, '#ai_err_provider'
    end

    local interval = tonumber(cfg.pollIntervalMs) or 2000
    local deadline = GetGameTimer() + (tonumber(aiConfig().timeoutMs) or 120000)
    while GetGameTimer() < deadline do
        Wait(interval)
        local poll = request(statusUrl, 'GET', '', headers)
        if poll.status == 200 then
            local state = decode(poll.body)
            local status = state and tostring(state.status or '') or ''
            if status == 'COMPLETED' then
                local result = request(resultUrl, 'GET', '', headers)
                if result.status == 200 then
                    local image = imageFromBody(result.body)
                    if image then return image end
                end
                logError('fal: finished but no image. %s', describeResponse(result))
                return nil, '#ai_err_provider'
            elseif status == 'FAILED' or status == 'CANCELLED' then
                logError('fal: job %s. body=%s', status, excerpt(poll.body, 300))
                return nil, '#ai_err_provider'
            end
        elseif poll.status == 401 or poll.status == 403 then
            return classifyFailure('fal', poll)
        end
    end
    return nil, '#ai_err_timeout'
end

-- OpenAI ---------------------------------------------------------------
providers.openai = function(prompt, reference, key)
    local cfg = providerConfig('openai')
    local headers = { ['Content-Type'] = 'application/json', ['Authorization'] = 'Bearer ' .. key }
    local url, payload

    if reference then
        -- Reference edit: the Responses API with the image_generation tool.
        url = 'https://api.openai.com/v1/responses'
        payload = {
            model  = cfg.responsesModel or 'gpt-5',
            stream = true,
            input  = { {
                role    = 'user',
                content = {
                    { type = 'input_text',  text = prompt },
                    { type = 'input_image', image_url = 'data:image/png;base64,' .. reference },
                },
            } },
            tools       = { { type = 'image_generation', partial_images = 1, model = cfg.model or 'gpt-image-1-mini' } },
            tool_choice = { type = 'image_generation' },
        }
    else
        url = 'https://api.openai.com/v1/images/generations'
        payload = {
            model          = cfg.model or 'gpt-image-1-mini',
            prompt         = prompt,
            size           = cfg.size or '1024x1024',
            quality        = cfg.quality or 'low',
            n              = 1,
            stream         = true,
            -- FiveM drops a request that gets zero bytes for 5 s. A partial
            -- preview makes OpenAI start talking early; the last image wins.
            partial_images = 1,
        }
    end

    for attempt = 1, 2 do
        local response = requestJson(url, 'POST', payload, headers)
        if response.status == 200 then
            local body = tostring(response.body)
            if body:find('event: error', 1, true) or body:find('response.failed', 1, true) then
                logError('openai: the stream reported an error -> %s', excerpt(body:sub(body:find('event: error', 1, true) or 1), 500))
                if body:find('insufficient_quota', 1, true) or body:find('credit_balance', 1, true) then
                    return nil, '#ai_err_provider_quota'
                end
                return nil, '#ai_err_provider'
            end
            local image = imageFromBody(body)
            if image then return image end
            logError('openai: HTTP 200 but no image. body=%s', excerpt(body, 400))
            return nil, '#ai_err_provider'
        elseif response.status == 0 and attempt == 1 then
            logWarn('openai: no response within 5 s - retrying once')
            Wait(1000)
        else
            return classifyFailure('openai', response)
        end
    end
    return nil, '#ai_err_timeout'
end

-- Custom JSON provider (Cloudflare Workers AI, ...) ------------------------
local customReferenceNoticeShown = false

providers.custom = function(prompt, reference, key)
    local cfg = providerConfig('custom')
    if type(cfg.url) ~= 'string' or cfg.url == '' then
        logError('custom: Config.ai.custom.url is empty')
        return nil, '#ai_err_provider'
    end
    if cfg.url:find('YOUR_ACCOUNT_ID', 1, true) then
        logError('custom: Config.ai.custom.url still contains YOUR_ACCOUNT_ID - put your real account id there')
        return nil, '#ai_err_provider'
    end
    if reference and not customReferenceNoticeShown then
        customReferenceNoticeShown = true
        logWarn('custom provider is text-to-image only: the canvas reference is ignored')
    end

    -- The prompt goes into bodyTemplate at every %s, escaped for JSON.
    local escaped = json.encode(prompt):sub(2, -2)
    local body = (cfg.bodyTemplate or '{"prompt":"%s"}'):gsub('%%s', function() return escaped end)

    -- %KEY% in a header becomes the real key (taken from the server only).
    local headers, count = {}, 0
    for name, value in pairs(cfg.headers or {}) do
        headers[name] = tostring(value):gsub('%%KEY%%', function() return key end)
        count = count + 1
    end
    if count == 0 then headers['Content-Type'] = 'application/json' end
    if not headers['Content-Type'] and not headers['content-type'] then
        headers['Content-Type'] = 'application/json'
    end

    local response
    for attempt = 1, 2 do
        response = request(cfg.url, cfg.method or 'POST', body, headers)
        if response.status ~= 0 or attempt == 2 then break end
        logWarn('custom: no response within 5 s - retrying once')
        Wait(1000)
    end

    if response.status ~= 200 then
        logError('custom request to %s', cfg.url:gsub('^(https?://[^/]+/[^?]*).*$', '%1'))
        return classifyFailure('custom', response)
    end
    local parsed = decode(response.body)
    if not parsed then
        logError('custom: HTTP 200 but the body is not JSON. body=%s', excerpt(response.body, 300))
        return nil, '#ai_err_provider'
    end
    local image = walkPath(parsed, cfg.responsePath or 'data.0.b64_json') or findImage(parsed)
    if image then return stripDataUrl(image) end
    logError('custom: HTTP 200 but no image at "%s". body=%s', tostring(cfg.responsePath), excerpt(response.body, 300))
    return nil, '#ai_err_provider'
end

----------------------------------------------------------------------
-- Generating an image for a player
----------------------------------------------------------------------
local function generate(src, requestId, rawPrompt, referenceToken, wantedEngine)
    local finished = false

    local identifier = playerIdentifier(src)
    local function finish(ok, payload)
        if finished then return end
        finished = true
        if ok then
            logInfo('player %d: image sent (%d chars)', src, #payload)
            Apex.SendLarge('ai_result', json.encode({ requestId = requestId, ok = true, image = payload }), src)
        else
            imageLimiter.refund(identifier)
            logWarn('player %d: generation failed -> %s', src, tostring(payload))
            TriggerClientEvent('apex_clothing:aiDone', src, requestId, false, payload)
        end
    end

    -- Quick rejections: nothing has been charged yet.
    local function reject(message)
        logWarn('player %d: request rejected -> %s', src, tostring(message))
        TriggerClientEvent('apex_clothing:aiDone', src, requestId, false, message)
    end

    if not aiConfig().enabled then return reject('#ai_err_disabled') end
    if not Apex.IsAllowed(src) then return reject('#ai_err_disabled') end

    local engine = pickEngine(wantedEngine)
    if not engine then return reject('#ai_err_provider') end
    if type(wantedEngine) == 'string' and wantedEngine ~= '' and engine.id ~= wantedEngine then
        logWarn('engine "%s" is not enabled - using "%s" (check Config.ai.engines)', wantedEngine, engine.id)
    end

    local adapter = providers[engine.provider]
    if not adapter then
        logError('engine "%s" uses unknown provider "%s" (gemini, together, fal, openai, custom)', engine.id, tostring(engine.provider))
        return reject('#ai_err_provider')
    end

    local key, keySource = resolveKey(engine)
    if key == '' then
        logError('engine "%s" has no key. Put it in secret.txt or set %s in server.cfg and restart the SERVER.',
            engine.id, keyConvarOf(engine))
        return reject('#ai_err_nokey')
    end

    local allowed, why = imageLimiter.check(identifier)
    if not allowed then return reject(why) end

    local prompt = cleanPrompt(rawPrompt)
    if not prompt then return reject('#ai_err_prompt') end

    logInfo('player %d: generating - engine=%s provider=%s key=%s prompt=%d chars',
        src, engine.id, engine.provider, describeKey(key, keySource), #prompt)

    local reference = takeReference(src, referenceToken)
    imageLimiter.mark(identifier)

    SetTimeout(tonumber(aiConfig().timeoutMs) or 120000, function()
        finish(false, '#ai_err_timeout')
    end)

    local ok, image, errorKey = pcall(adapter, prompt, reference, key)
    if not ok then
        logError('provider crashed: %s', tostring(image))
        return finish(false, 'SERVER ERROR (provider): ' .. tostring(image))
    end
    if image then
        finish(true, image)
    else
        finish(false, errorKey or '#ai_err_provider')
    end
end

RegisterNetEvent('apex_clothing:aiRequest', function(requestId, prompt, referenceToken, engineId)
    local src = source
    CreateThread(function()
        local ok, err = pcall(generate, src, requestId, prompt, referenceToken, engineId)
        if not ok then
            logError('ai request crashed: %s', tostring(err))
            TriggerClientEvent('apex_clothing:aiDone', src, requestId, false, 'SERVER ERROR: ' .. tostring(err))
        end
    end)
end)

-- Older client builds call this instead of the event (no engine argument).
Apex.RegisterCallback('ai:generate', function(src, cb, requestId, prompt, referenceToken)
    cb(true)
    local ok, err = pcall(generate, src, requestId, prompt, referenceToken, nil)
    if not ok then
        logError('ai callback crashed: %s', tostring(err))
        TriggerClientEvent('apex_clothing:aiDone', src, requestId, false, 'SERVER ERROR: ' .. tostring(err))
    end
end)

----------------------------------------------------------------------
-- Help assistant (text model)
----------------------------------------------------------------------
local PRODUCT_FACTS = [==[
PRODUCT: Apex Clothing Studio - a FiveM resource for designing clothing textures for FiveM.
It is fully self-contained: no companion resource, no database, no
external tool. Projects and settings persist to JSON in its data/ folder.

OPENING IT: the chat command /clothingstudio (configurable via Config.command),
or an optional keybind set in Config.keybind.

ACCESS: shared/config.lua -> Config.access has FIVE independent methods,
each with its own enabled switch, and they ADD UP (the first enabled
method that passes lets the player in):
  everyone     - anyone at all
  ace          - a FiveM ace permission; also accepts the owner aces
                 command / txadmin.everything / group.admin unless
                 acceptOwnerAces = false
  groups       - a framework rank (ESX group, QBCore/QBox permission,
                 or the plain aces name / group.name / qbcore.name / qbx.name)
  jobs         - a job with a minimum grade
  identifiers  - a hand-picked list of player identifiers
If someone is refused, they run /clothingstudio_access in game and the SERVER
console prints every method's verdict plus their own identifiers.
IMPORTANT: an add_ace line in server.cfg only takes effect when the
server STARTS. Restarting the resource is not enough - paste the line
into the live server console to apply it immediately.

LANGUAGE: Config.locale is the server default; nine languages ship
100% translated (en, pt, pt-br, es, fr, de, it, ja, tr). A player can
override it for themselves with /clothingstudio_lang <code>, and go back to
the server default with /clothingstudio_lang auto. Changing it closes the
studio, because the whole interface is built from the dictionary it
received when it opened.

EXPORT: there are exactly two modes, and both finish inside the studio.
  Resource - writes a complete, installable FiveM resource into the
             studio's exports/ folder. By default the files land FLAT
             and are named <name>__fxmanifest.lua, <name>__client.lua,
             <name>__README.md and <name>__tex_N.png. The owner makes a
             folder inside resources/, moves those files in, drops the
             <name>__ prefix, adds "ensure <name>" to server.cfg and
             restarts. The Export panel shows the exact path, the folder
             name and the ensure line, each with a copy button.
             Config.export.createFolder = true makes the server create
             the folder instead - it is OFF by default because creating
             a directory and writing into it has hard-crashed the
             FXServer process on Linux.
  Live     - broadcasts the design to every connected player instantly.
             It survives a restart and late joiners receive it on spawn.
             Undo it with /clothingliveclear.

AI IMAGES: two engines are offered and the player picks one per
generation. Keys are set in server.cfg with convars, never hard-coded.
Each engine can use its own key and falls back to apex_clothing_ai_key.

TROUBLESHOOTING FACTS:
- "AI says no key": the server owner must set the key convar in
  server.cfg and restart the server.
- Export said done but nothing appears: the Resource export only writes
  files; they still have to be moved into resources/ and ensured.
- A live design not showing on a garment: it applies to everyone
  automatically; ask them to check the server console for errors.
- Nothing in the Models list: the catalog is built by the tools in the
  studio's tools/ folder; see the README.
]==]

local HISTORY_TURNS, HISTORY_CHARS = 8, 600

local function supportConfig()
    return aiConfig().support or {}
end

--- Keeps the last few turns, as {role = 'user'|'assistant', text = ...},
--- and makes sure the list starts with a user turn.
local function cleanHistory(history)
    local turns = {}
    if type(history) ~= 'table' then return turns end
    for _, item in ipairs(history) do
        if type(item) == 'table' then
            local text = trim(tostring(item.text or ''):gsub('%c', ' '))
            if text ~= '' then
                turns[#turns + 1] = {
                    role = (item.role == 'assistant') and 'assistant' or 'user',
                    text = text:sub(1, HISTORY_CHARS),
                }
            end
        end
    end
    while #turns > HISTORY_TURNS do table.remove(turns, 1) end
    while #turns > 0 and turns[1].role ~= 'user' do table.remove(turns, 1) end
    return turns
end

local function supportSystemPrompt(language, maxChars)
    return PRODUCT_FACTS .. '\n\nYOU ARE the in-studio help assistant for this resource.\nRULES:\n'
        .. "- Answer ONLY from the facts above. If the facts do not cover it, say\n"
        .. "  you are not sure and point at the resource's README - never invent a\n"
        .. "  command, a config key or a file name.\n"
        .. '- Reply in ' .. language .. '.\n'
        .. '- This is an ongoing conversation. Earlier turns are given to you; treat\n'
        .. '  a short follow-up ("and on Linux?", "show me the steps") as being about\n'
        .. '  what was just discussed. Do not repeat an answer you already gave.\n'
        .. '- Be short: a few sentences, or a numbered list of at most 5 steps.\n'
        .. '- Plain text only. No markdown, no code fences, no headings.\n'
        .. '- Stay under ' .. tostring(maxChars) .. ' characters.\n'
end

--- Returns answerText, or nil + a message for the player.
local function askAssistant(question, language, key, history)
    local cfg = supportConfig()
    local maxChars = tonumber(cfg.maxAnswerChars) or 900
    local system = supportSystemPrompt(language, maxChars)
    local turns = cleanHistory(history)

    if cfg.provider == 'openai' then
        local messages = { { role = 'system', content = system } }
        for _, turn in ipairs(turns) do
            messages[#messages + 1] = { role = turn.role, content = turn.text }
        end
        messages[#messages + 1] = { role = 'user', content = question }
        local response = requestJson('https://api.openai.com/v1/chat/completions', 'POST', {
            model = cfg.openaiModel or 'gpt-5-mini', messages = messages,
        }, { ['Content-Type'] = 'application/json', ['Authorization'] = 'Bearer ' .. key })
        if response.status == 200 then
            local text = walkPath(decode(response.body) or {}, 'choices.0.message.content')
            if text then return text end
            logError('support (openai): HTTP 200 without message content')
            return nil, '#ai_err_provider'
        end
        logError('support (openai): %s', describeResponse(response))
        return nil, ('The help assistant could not reach the AI (HTTP %s).'):format(tostring(response.status))
    end

    local models = { cfg.geminiModel or 'gemini-flash-latest' }
    for _, name in ipairs(cfg.geminiFallbackModels or {}) do
        if name ~= models[1] then models[#models + 1] = name end
    end
    local contents = {}
    for _, turn in ipairs(turns) do
        contents[#contents + 1] = {
            role  = (turn.role == 'assistant') and 'model' or 'user',
            parts = { { text = turn.text } },
        }
    end
    contents[#contents + 1] = { role = 'user', parts = { { text = question } } }
    local payload = {
        system_instruction = { parts = { { text = system } } },
        contents           = contents,
        generationConfig   = { temperature = 0.3 },
    }
    local headers = { ['Content-Type'] = 'application/json', ['x-goog-api-key'] = key }

    local lastStatus
    for _, model in ipairs(models) do
        local url = ('https://generativelanguage.googleapis.com/v1beta/models/%s:streamGenerateContent?alt=sse'):format(model)
        for attempt = 1, 3 do
            local response = requestJson(url, 'POST', payload, headers)
            lastStatus = response.status
            if response.status == 200 then
                local text = textFromEvents(response.body)
                    or walkPath(decode(response.body) or {}, 'candidates.0.content.parts.0.text')
                if text and text ~= '' then return text end
                logError('support: %s answered 200 without text', model)
                break
            elseif response.status == 0 and attempt < 3 then
                logWarn('support: %s produced no bytes in 5 s - retry %d/3', model, attempt)
                Wait(300)
            else
                logError('support: %s -> %s', model, describeResponse(response))
                break
            end
        end
    end
    if lastStatus == 0 then
        return nil, 'The assistant took too long to answer. Try again, or pick a faster model in Config.ai.support.geminiModel.'
    end
    return nil, ('The help assistant could not reach the AI (HTTP %s).'):format(tostring(lastStatus))
end

RegisterNetEvent('apex_clothing:aiSupport', function(questionId, rawQuestion, rawLanguage, history)
    local src = source
    local function reply(ok, text)
        TriggerClientEvent('apex_clothing:aiSupportDone', src, questionId, ok, text)
    end

    CreateThread(function()
        if not supportConfig().enabled then return reply(false, '#support_err_off') end
        if not Apex.IsAllowed(src) then return reply(false, '#ai_err_disabled') end

        local key = resolveSupportKey()
        if key == '' then return reply(false, '#ai_err_nokey') end

        local question = cleanPrompt(rawQuestion)
        if not question then return reply(false, '#support_err_short') end

        local identifier = playerIdentifier(src)
        local allowed, why = supportLimiter.check(identifier)
        if not allowed then return reply(false, why) end
        supportLimiter.mark(identifier)

        local language = tostring(rawLanguage or 'English')
        if #language > 40 then language = language:sub(1, 40) end

        local ok, answer, message = pcall(askAssistant, question, language, key, history)
        if not ok then
            logError('support assistant crashed: %s', tostring(answer))
            return reply(false, '#ai_err_provider')
        end
        if not answer then return reply(false, message or '#ai_err_provider') end

        local limit = tonumber(supportConfig().maxAnswerChars) or 900
        if #answer > limit then answer = answer:sub(1, limit) end
        logInfo('support answered player %d (%d chars)', src, #answer)
        reply(true, answer)
    end)
end)

----------------------------------------------------------------------
-- Studio asks which engines exist
----------------------------------------------------------------------
Apex.RegisterCallback('ai:engines', function(src, cb)
    if not Apex.IsAllowed(src) then
        return cb({ engines = {}, support = false })
    end
    cb({
        engines       = AiEnginesForUi(),
        defaultEngine = aiConfig().defaultEngine,
        support       = supportConfig().enabled == true,
    })
end)

----------------------------------------------------------------------
-- Self-test: run  apexai_test  in the SERVER console
----------------------------------------------------------------------
RegisterCommand('apexai_test', function(src)
    if src ~= 0 then return end
    CreateThread(function()
        logInfo('==== AI self-test (%s) ====', VERSION)
        logInfo('resource folder : %s', tostring(GetResourcePath(RESOURCE)))
        logInfo('Config.ai.enabled=%s  provider=%s  timeoutMs=%s',
            tostring(aiConfig().enabled), tostring(aiConfig().provider), tostring(aiConfig().timeoutMs))

        local firstReady
        for _, engine in ipairs(enabledEngines()) do
            local key, source = resolveKey(engine)
            logInfo('engine %-6s provider=%-8s key=%s', engine.id, engine.provider, describeKey(key, source))
            if key ~= '' and not firstReady then firstReady = { engine = engine, key = key } end
        end
        if not firstReady then
            logError('no engine has a key. Create secret.txt next to fxmanifest.lua, or set %s in server.cfg.', MAIN_KEY_NAME)
            return
        end

        local engine = firstReady.engine
        logInfo('requesting a tiny test image from engine "%s" ...', engine.id)
        local started = GetGameTimer()
        local ok, image, errorKey = pcall(providers[engine.provider] or function() return nil, 'unknown provider' end,
            'a simple red circle on a white background', nil, firstReady.key)
        local elapsed = GetGameTimer() - started
        if not ok then
            logError('provider crashed: %s', tostring(image))
        elseif image then
            logInfo('SUCCESS: got an image (%d base64 chars) in %d ms', #image, elapsed)
        else
            logError('FAILED after %d ms: %s  (the lines above show the provider\'s answer)', elapsed, tostring(errorKey))
        end
    end)
end, true)

----------------------------------------------------------------------
-- Start-up banner (always visible)
----------------------------------------------------------------------
do
    local engineNotes = {}
    for _, engine in ipairs(enabledEngines()) do
        local key, source = resolveKey(engine)
        engineNotes[#engineNotes + 1] = ('%s[%s] key=%s'):format(engine.id, engine.provider, describeKey(key, source))
    end
    logInfo('ai.lua %s loaded from %s', VERSION, tostring(GetResourcePath(RESOURCE)))
    logInfo('engines: %s', #engineNotes > 0 and table.concat(engineNotes, ' | ') or 'none enabled')
    logInfo('run "apexai_test" in this console to test the provider')
end