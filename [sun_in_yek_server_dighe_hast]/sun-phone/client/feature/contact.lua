-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('get-contacts', function(_, cb)
    -- Serve from cache only when it actually HAS contacts. Previously an empty
    -- result (e.g. fetched in the ~1s window before cache.lua finished loading
    -- phone_contacts at server start) was cached as an empty table — which is
    -- truthy in Lua — so the phone then returned "no contacts" forever until a
    -- resource restart. That was a big part of the "contacts sometimes show,
    -- sometimes don't" instability. Now an empty result is NOT cached, so the
    -- next time the Contacts app opens it re-fetches and self-heals.
    if CachedData.contacts and #CachedData.contacts > 0 then
        return cb(CachedData.contacts)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetContacts', function(result)
        if result and #result > 0 then
            CachedData.contacts = result
        end
        cb(result or {})
    end)
end)

-- Mutations no longer patch the local cache here — the server pushes the
-- full authoritative list via sun-phone:client:ContactsPushed right after
-- every mutation (see server/feature/contact.lua PushContactsTo). One write
-- path = the local cache, the server cache and the UI can never drift apart
-- again (the old incremental patches were where the "contacts vanished /
-- didn't appear until reopen" bugs lived).
RegisterNUICallback('delete-contact', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:DeleteContact', function(result)
        cb({success = result and result.success or false})
    end, body)
end)

RegisterNUICallback('update-contact', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:UpdateContact', function(result)
        cb({success = result and result.success or false})
    end, body)
end)

RegisterNUICallback('toggle-favourite', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:ToggleFavourite', function(result)
        if result and result.success then
            cb({ success = true, is_favourite = result.is_favourite })
        else
            cb({ success = false })
        end
    end, body)
end)

RegisterNUICallback('save-contact', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:SaveContact', function(result)
        if result and result.success then
            cb({success = true, contact = result.contact})
        else
            cb({success = false})
        end
    end, body)
end)

RegisterNUICallback('add-contact', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:SaveContact', function(result)
        if result and result.success then
            cb({success = true, contact = result.contact})
        else
            cb({success = false})
        end
    end, body)
end)

RegisterNUICallback('manage-block-list', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:ManageBlockList', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('get-my-location', function(_, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    cb({ x = coords.x, y = coords.y, z = coords.z })
end)