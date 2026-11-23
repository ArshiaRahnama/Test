--[[
    Apex Clothing Studio - Client Apex Lib
    ────────────────────────────────────────────────────────────
    Foundation shared by every other client module:

        Apex.Callback(name, ...)         awaitable client→server RPC
        Apex.RegisterCallback(name, fn)  server→client RPC handler
        Apex.SendUI(action, payload)     SendNUIMessage envelope
        Apex.Notify(message, type)       UI toast / chat fallback
        Apex.SendLarge(kind, data)       chunked upload (>45 KB safe)
        Apex.OnLarge(kind, fn)           chunked download receiver
        Apex.GetPedModelName(ped)        Config.pedModels hash lookup

    The chunk transport exists because FiveM net events break
    above ~50 KB - project saves, AI references/results and
    export PNGs all cross the wire through it (contract §16).
]]

Apex = Apex or {}
Apex.uiOpen = false

math.randomseed(GetGameTimer() % 2147483647)

-- ─── NUI messaging ──────────────────────────────────────────

function Apex.SendUI(action, payload)
    SendNUIMessage({ action = action, payload = payload or {} })
end

-- ─── Notify ─────────────────────────────────────────────────
-- While the studio UI is open notifications render as in-UI
-- toasts; otherwise they fall back to a colored chat message.
-- Messages prefixed with '#' are treated as locale keys.

local NOTIFY_COLORS = {
    success = { 52, 199, 123 },
    error   = { 240, 85, 109 },
    info    = { 31, 94, 255 },
}

function Apex.Notify(message, msgType)
    msgType = msgType or 'info'
    if type(message) == 'string' and message:sub(1, 1) == '#' then
        local key = message:sub(2)
        message = L(key, key)
    end
    if Apex.uiOpen then
        Apex.SendUI('notify', { message = message, type = msgType })
        return
    end
    TriggerEvent('chat:addMessage', {
        color = NOTIFY_COLORS[msgType] or NOTIFY_COLORS.info,
        args = { L('studio_title', 'Clothing Studio'), tostring(message) },
    })
end

RegisterNetEvent('apex_clothing:notify', function(message, msgType)
    Apex.Notify(message, msgType)
end)

-- ─── Client → server callbacks (with auto-id) ───────────────

local callbacks = {}
local cbCounter = 0

local function pack(...)
    return { n = select('#', ...), ... }
end

local function unpackPacked(t)
    return table.unpack(t, 1, t.n or #t)
end

function Apex.Callback(name, ...)
    cbCounter = cbCounter + 1
    local id = cbCounter
    local p = promise.new()
    callbacks[id] = function(...)
        callbacks[id] = nil
        p:resolve(pack(...))
    end
    TriggerServerEvent('apex_clothing:cb', name, id, ...)
    return unpackPacked(Citizen.Await(p))
end

RegisterNetEvent('apex_clothing:cbResp', function(id, ...)
    local fn = callbacks[id]
    if fn then fn(...) end
end)

-- ─── Server → client callbacks ──────────────────────────────

local clientHandlers = {}

function Apex.RegisterCallback(name, fn)
    clientHandlers[name] = fn
end

RegisterNetEvent('apex_clothing:scb', function(name, id, ...)
    local fn = clientHandlers[name]
    if fn then
        TriggerServerEvent('apex_clothing:scbResp', id, fn(...))
    else
        TriggerServerEvent('apex_clothing:scbResp', id, nil)
    end
end)

-- ─── Chunk transport (contract §16) ─────────────────────────
-- Splits any large string into 45 000-char pieces sent through
-- 'apex_clothing:chunk' (transferId, seq, total, kind, chunk).
-- Sending is sequential with a Wait(0) between pieces so the
-- net channel never chokes; the call yields until the upload
-- finished, which also guarantees ordering (e.g. an AI
-- reference finishes uploading before ai:generate fires).

local sendCounter = 0

function Apex.SendLarge(kind, dataString)
    if type(dataString) ~= 'string' then
        dataString = tostring(dataString or '')
    end
    sendCounter = sendCounter + 1
    local transferId = ('%s_%d_%d'):format(kind, 0, sendCounter)
        .. '_' .. tostring(math.random(100000, 999999))
    -- LATENT event: FiveM's purpose-built primitive for large payloads.
    -- It streams at a fixed rate OUTSIDE the reliable-event buffer - -- chunked reliable events overflowed that buffer and KICKED the
    -- player no matter the chunk size.
    Utils.Log(('SendLarge %s: %d bytes (latent) [%s]'):format(kind, #dataString, transferId))
    TriggerLatentServerEvent('apex_clothing:blob', 1000000, transferId, kind, dataString)
    return transferId
end

-- Receiving side: server→client blobs arrive whole via a latent
-- event (FiveM streams them safely, no reliable-buffer overflow).

local largeHandlers = {}

--- Register a handler for a blob kind.
--- fn(senderSrcOrNil, transferId, dataString) - sender is always
--- nil on the client (the server is the only possible sender).
function Apex.OnLarge(kind, fn)
    largeHandlers[kind] = fn
end

RegisterNetEvent('apex_clothing:blob', function(transferId, kind, data)
    if type(kind) ~= 'string' or type(data) ~= 'string' then return end
    Utils.Log(('OnLarge %s: %d bytes received (latent) [%s]')
        :format(kind, #data, tostring(transferId)))
    local fn = largeHandlers[kind]
    if fn then
        local ok, err = pcall(fn, nil, transferId, data)
        if not ok then
            Utils.Err('OnLarge handler error for kind', kind, err)
        end
    end
end)

-- ─── Ped model lookup ───────────────────────────────────────
-- Maps the current ped's model hash back to a Config.pedModels
-- name. Returns nil when the model is not recognised.

local modelLookup = nil

function Apex.GetPedModelName(ped)
    ped = ped or PlayerPedId()
    if not modelLookup then
        modelLookup = {}
        for _, name in ipairs(Config.pedModels or {}) do
            modelLookup[GetHashKey(name)] = name
        end
    end
    return modelLookup[GetEntityModel(ped)]
end

-- ─── Exports ────────────────────────────────────────────────

exports('Notify', function(...) Apex.Notify(...) end)
