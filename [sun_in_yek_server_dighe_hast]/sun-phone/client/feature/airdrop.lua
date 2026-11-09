-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- ============================================
-- AirDrop Contact Sharing (client)
-- --------------------------------------------
-- Two NUI callbacks + one server-event listener:
--
--   NUI 'airdrop-share-contact'  → finds the closest player ped within
--                                   AIRDROP_RANGE meters and triggers the
--                                   server's AirdropSend with that target
--                                   server-id
--
--   NUI 'airdrop-respond'        → forwards the target's accept/decline
--                                   back to the server with the request_id
--
--   server event 'IncomingAirdrop' → opens the phone if it's closed, then
--                                     sends a NUI message to React so the
--                                     popup appears
-- ============================================

-- meters; configurable via config.lua → Config.AirDrop.Range
local AIRDROP_RANGE = (Config.AirDrop and Config.AirDrop.Range) or 5.0

-- Find the closest *other* player ped to the local player. Returns the
-- server-id of that player, or nil if nobody is within AIRDROP_RANGE.
local function findClosestPlayerServerId()
    local myPed = PlayerPedId()
    if myPed == 0 then return nil end
    local myCoords = GetEntityCoords(myPed)

    local bestServerId = nil
    local bestDistance = AIRDROP_RANGE + 1.0

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= 0 and targetPed ~= myPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(myCoords - targetCoords)
            if distance < bestDistance then
                bestDistance = distance
                bestServerId = GetPlayerServerId(playerId)
            end
        end
    end

    if bestServerId and bestDistance <= AIRDROP_RANGE then
        return bestServerId, bestDistance
    end
    return nil
end

-- Nearby-player picker — the same collection loop the cuff feature uses
-- (essentialmode ESX.selectPlayerMenu): every OTHER player within range,
-- visible with clear line of sight, sorted nearest-first. The UI shows the
-- server IDs so the sender picks exactly who receives the drop.
RegisterNUICallback('airdrop-nearby-players', function(_, cb)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local list = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if playerId ~= PlayerId() and targetPed ~= 0 and DoesEntityExist(targetPed)
            and IsEntityVisible(targetPed)
            and HasEntityClearLosToEntity(myPed, targetPed, 17) then
            local distance = #(GetEntityCoords(targetPed) - myCoords)
            if distance <= AIRDROP_RANGE then
                table.insert(list, {
                    id = GetPlayerServerId(playerId),
                    distance = math.floor(distance * 10) / 10
                })
            end
        end
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    cb({ success = #list > 0, players = list })
end)

RegisterNUICallback('airdrop-share-contact', function(body, cb)
    local targetServerId = body and tonumber(body.target_id) or nil
    if not targetServerId then
        targetServerId = findClosestPlayerServerId()
    end
    if not targetServerId then
        cb({ success = false, reason = 'no_one_nearby' })
        return
    end
    TriggerServerEvent('sun-phone:server:AirdropSend', targetServerId)
    cb({ success = true })
end)

RegisterNUICallback('airdrop-share-photo', function(body, cb)
    local targetServerId = body and tonumber(body.target_id) or nil
    local photoUrl = body and body.photo_url
    if not targetServerId or not photoUrl or photoUrl == '' then
        cb({ success = false })
        return
    end
    TriggerServerEvent('sun-phone:server:AirdropSendPhoto', targetServerId, tostring(photoUrl))
    cb({ success = true })
end)

-- ---- NUI: target responds via popup ----
RegisterNUICallback('airdrop-respond', function(body, cb)
    if not body or not body.request_id then
        cb({ success = false })
        return
    end
    TriggerServerEvent(
        'sun-phone:server:AirdropRespond',
        body.request_id,
        body.accept and true or false
    )
    cb({ success = true })
end)

-- ---- Server: an accepted photo drop — push it into the gallery INSTANTLY.
-- The gallery's get-photos NUI callback serves the client-side cache, so
-- without this the received photo only appeared after that cache eventually
-- refreshed. The server sends the fresh list; we pin it and notify the UI.
RegisterNetEvent('sun-phone:client:AirdropPhotoSaved')
AddEventHandler('sun-phone:client:AirdropPhotoSaved', function(photos)
    if photos and #photos > 0 then
        CachedData.photos = photos
    else
        CachedData.photos = nil
    end
    SendNUIMessage({
        event = 'sun-phone:RefreshPhotos',
        photos = photos or {},
    })
end)

-- ---- Server: incoming airdrop request for this client ----
RegisterNetEvent('sun-phone:client:IncomingAirdrop')
AddEventHandler('sun-phone:client:IncomingAirdrop', function(data)
    if not data or not data.request_id then return end

    if not PhoneData.isOpen then
        OpenPhone()
    end

    SendNUIMessage({
        event = 'sun-phone:IncomingAirdrop',
        request_id = data.request_id,
        kind = data.kind or 'contact',
        image_url = data.image_url or '',
        from_phone = data.from_phone,
        from_avatar = data.from_avatar,
    })
end)
