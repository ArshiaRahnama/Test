-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Pac-Man NUI bridge. The React PacmanComponent (which embeds the exact game in
-- an iframe) calls these; they relay to the namespaced server handlers.

-- Leaderboard + price in one shot (ConfigPacman is shared, so it's here too).
RegisterNUICallback('pacman-info', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:pacman:leaderboard', function(scores)
        cb({ scores = scores or {}, price = (ConfigPacman and ConfigPacman.Price) or 3000 })
    end)
end)

RegisterNUICallback('pacman-pay', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:pacman:pay', function(ok)
        cb({ ok = ok == true })
    end)
end)

RegisterNUICallback('pacman-score', function(body, cb)
    ESX.TriggerServerEvent('sun-phone:pacman:newScore', body and body.score or 0)
    cb('ok')
end)

RegisterNUICallback('pacman-win', function(body, cb)
    ESX.TriggerServerEvent('sun-phone:pacman:winLevel', body and body.level or 1)
    cb('ok')
end)

RegisterNUICallback('pacman-fullscreen', function(_, cb)
    if PhoneData.ArcadePending then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:pacman:canAfford', function(canAfford)
        if not canAfford then
            return cb({ ok = false, message = "Not enough money!" })
        end

        cb({ ok = true })
        PhoneData.ArcadePending = true
        ClosePhoneFully()
        SetTimeout(600, function()
            if PhoneData.isOpen then
                PhoneData.ArcadePending = false
                return
            end
            -- Fire the arcade's own launch event (same flow as the in-world
            -- eye-target) with a from-phone trigger. A triggered event can't
            -- miss the way a cross-resource export can, so it never falls back
            -- to the "arcade not available" error.
            TriggerEvent('pacman:client:startArcade')
            SetTimeout(4000, function()
                PhoneData.ArcadePending = false
            end)
        end)
    end)
end)
