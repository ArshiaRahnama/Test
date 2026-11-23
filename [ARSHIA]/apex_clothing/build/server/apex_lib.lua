--[[
    Apex Clothing Studio - server library ("the bus")
    Clean rewrite. Same events and API as the original build/server/apex_lib.lua.

    Server API
      Apex.IsAllowed(src)                    may this player use the studio?
      Apex.Notify(src, message, kind)        toast / chat message on the player's screen
      Apex.RegisterCallback(name, fn)        fn(src, respond, ...) answers a client callback
      Apex.Callback(src, name, ...)          asks a client and waits for the answer (yields)
      Apex.OnLarge(kind, fn)                 fn(src, transferId, data) for big uploads
      Apex.SendLarge(kind, data, src)        sends a big string to one player (latent)

    Network events used (client -> server unless noted)
      apex_clothing:cb / cbResp (to client)  client calls a server callback
      apex_clothing:scb (to client) / scbResp  server calls a client callback
      apex_clothing:blob                     large upload (and, to the client, large download)
]]

Apex = Apex or {}

local MAX_TRANSFER_ID_LENGTH = 128
local MAX_KIND_LENGTH        = 32
local DEFAULT_MAX_BYTES      = 12582912   -- 12 MB

----------------------------------------------------------------------
-- Access and notifications
----------------------------------------------------------------------
function Apex.IsAllowed(src)
    return Access.Check(src) and true or false
end

function Apex.Notify(src, message, kind)
    src = tonumber(src)
    if not src or src <= 0 then return end
    TriggerClientEvent('apex_clothing:notify', src, message, kind or 'info')
end

----------------------------------------------------------------------
-- Client -> server callbacks
----------------------------------------------------------------------
local callbackHandlers = {}

function Apex.RegisterCallback(name, handler)
    callbackHandlers[name] = handler
end

RegisterNetEvent('apex_clothing:cb', function(name, requestId, ...)
    local src = source
    local handler = callbackHandlers[name]

    if not handler then
        Utils.Warn(('callback "%s" has no server handler'):format(tostring(name)))
        TriggerClientEvent('apex_clothing:cbResp', src, requestId, nil,
            ('SERVER: callback "%s" is not registered - restart apex_clothing'):format(tostring(name)))
        return
    end

    local args = table.pack(...)

    CreateThread(function()
        local function respond(...)
            TriggerClientEvent('apex_clothing:cbResp', src, requestId, ...)
        end

        local ok, err = pcall(function()
            handler(src, respond, table.unpack(args, 1, args.n))
        end)

        if not ok then
            Utils.Err('callback error:', name, err)
            TriggerClientEvent('apex_clothing:cbResp', src, requestId, nil,
                ('SERVER ERROR in %s: %s'):format(tostring(name), tostring(err)))
        end
    end)
end)

----------------------------------------------------------------------
-- Server -> client callbacks (the calling thread waits for the answer)
----------------------------------------------------------------------
local lastRequestId = 0
local pendingRequests = {}   -- id -> { target = src, resolve = function(...) }

function Apex.Callback(src, name, ...)
    lastRequestId = lastRequestId + 1
    local requestId = lastRequestId

    local waiting = promise.new()
    pendingRequests[requestId] = {
        target  = tonumber(src),
        resolve = function(...)
            pendingRequests[requestId] = nil
            waiting:resolve(table.pack(...))
        end,
    }

    TriggerClientEvent('apex_clothing:scb', src, name, requestId, ...)

    local answer = Citizen.Await(waiting)
    -- Always hand back at least one value (nil), so tostring(Apex.Callback(...)) is safe.
    return table.unpack(answer, 1, math.max(answer.n, 1))
end

RegisterNetEvent('apex_clothing:scbResp', function(requestId, ...)
    local pending = pendingRequests[requestId]
    if not pending then return end

    -- Only the player that was asked may answer.
    if pending.target and tonumber(source) ~= pending.target then return end

    pending.resolve(...)
end)

----------------------------------------------------------------------
-- Large transfers
----------------------------------------------------------------------
local largeHandlers = {}    -- kind -> list of functions
local lastTransferNumber = 0

function Apex.OnLarge(kind, handler)
    local list = largeHandlers[kind]
    if not list then
        list = {}
        largeHandlers[kind] = list
    end
    list[#list + 1] = handler
end

--- A refused upload also tells the player, in a way the right screen understands.
local function refuseUpload(src, kind, transferId, localeKey, detail)
    Utils.Warn(('blob %s from %d refused: %s'):format(transferId, src, detail))

    if kind == 'export_run' then
        TriggerClientEvent('apex_clothing:exportDone', src, false, 'package', nil, localeKey)
    elseif kind == 'project_save' then
        TriggerClientEvent('apex_clothing:projectSaved', src, false, nil, nil, '#' .. tostring(localeKey))
    else
        Apex.Notify(src, localeKey and ('#' .. localeKey) or detail, 'error')
    end
end

local function isShortString(value, maxLength)
    return type(value) == 'string' and value ~= '' and #value <= maxLength
end

RegisterNetEvent('apex_clothing:blob', function(transferId, kind, data)
    local src = source
    if not src or src <= 0 then return end

    if not isShortString(transferId, MAX_TRANSFER_ID_LENGTH) then return end
    if not isShortString(kind, MAX_KIND_LENGTH) then return end
    if type(data) ~= 'string' or data == '' then return end

    local maxBytes = (Config.limits and Config.limits.maxTransferBytes) or DEFAULT_MAX_BYTES
    if #data > maxBytes then
        return refuseUpload(src, kind, transferId, 'export_err_too_big',
            ('%d bytes exceeds the %d byte limit - lower the export resolution or split the design'):format(#data, maxBytes))
    end

    if not Apex.IsAllowed(src) then
        return refuseUpload(src, kind, transferId, 'err_no_access', 'player is not allowed to use the studio')
    end

    Utils.Log(('received "%s" blob %s from %d (%d bytes)'):format(kind, transferId, src, #data))

    local handlers = largeHandlers[kind]
    if not handlers or #handlers == 0 then
        return refuseUpload(src, kind, transferId, 'export_err_artifact',
            ('no Apex.OnLarge handler is registered for "%s" - restart the resource'):format(kind))
    end

    for _, handler in ipairs(handlers) do
        CreateThread(function()
            local ok, err = pcall(handler, src, transferId, data)
            if not ok then
                Utils.Err(('OnLarge handler for "%s" failed: %s'):format(kind, tostring(err)))
            end
        end)
    end
end)

--- Sends a large string to one player. Returns the transfer id, or nil on bad input.
function Apex.SendLarge(kind, data, src)
    if type(kind) ~= 'string' or kind == '' then return nil end
    if type(data) ~= 'string' then return nil end

    src = tonumber(src)
    if not src or src <= 0 then
        Utils.Err('Apex.SendLarge (server) requires a target src')
        return nil
    end

    lastTransferNumber = lastTransferNumber + 1
    local transferId = ('%s_%d_%d_%d'):format(kind, src, lastTransferNumber, math.random(100000, 999999))

    TriggerLatentClientEvent('apex_clothing:blob', src, 1000000, transferId, kind, data)
    Utils.Log(('sent "%s" blob %s to %d (%d bytes, latent)'):format(kind, transferId, src, #data))
    return transferId
end

----------------------------------------------------------------------
-- Start-up message
----------------------------------------------------------------------
CreateThread(function()
    local resourceName = GetCurrentResourceName()
    Utils.Log(('server bus online - %s v%s'):format(resourceName, GetResourceMetadata(resourceName, 'version', 0) or '?'))
end)