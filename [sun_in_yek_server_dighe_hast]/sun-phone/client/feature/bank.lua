-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- ============================================================================
-- Wallet (phone) — slimmed down per management request.
--
-- Only TWO things now:
--   1. Bank  → close the phone and open the external mobile-bank UI
--              (sun-banking's `bank:openMobileBank`). No in-phone balance,
--              transfer, or history anymore.
--   2. Invoices → list + pay the player's bills. These go DIRECTLY to the
--              sun-billing callbacks the F7 menu used (esx_billing:getBills /
--              billing:payBill) so there's a single source of truth and no
--              server-side wrapper to break.
-- ============================================================================

-- Open the external bank: dismiss the phone, then fire the bank event.
-- Mirrors the old phone's openBank exactly.
RegisterNUICallback('open-mobile-bank', function(_, cb)
    -- ClosePhoneFully (global, defined in client/main.lua) hides the NUI,
    -- releases focus and plays the put-away animation — equivalent to the
    -- old phone's SendNUIMessage({action='close'}).
    if ClosePhoneFully then
        ClosePhoneFully()
    end
    cb('ok')
    Citizen.SetTimeout(1000, function()
        TriggerEvent('bank:openMobileBank')
    end)
end)

-- Read-only: current bank + cash balance for the Wallet home header, so the
-- player sees their balance before opening the external bank.
RegisterNUICallback('get-balance', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetBalance', function(balance)
        cb(balance or { bank = 0, cash = 0 })
    end)
end)

-- Fetch this player's pending invoices. Uses sun-billing's own callback
-- (registered as esx_billing:getBills) — same data the F7 menu showed.
RegisterNUICallback('get-invoices', function(_, cb)
    ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
        cb(bills or {})
    end)
end)

-- Pay an invoice by id. Calls sun-billing's billing:payBill DIRECTLY
-- (client → server callback), exactly like the F7 menu did. The previous
-- code routed through a sun-phone server callback that re-invoked
-- billing:payBill with the wrong server-side argument order, which is what
-- caused: "@sun-billing/server/main.lua:220: attempt to index a nil value
-- (local 'xPlayer')".
RegisterNUICallback('pay-invoice', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Wallet.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    local id = body and (body.id or body.bill_id)
    if not id then
        cb(false)
        return
    end

    ESX.TriggerServerCallback('billing:payBill', function()
        -- billing:payBill calls cb() with no value whether it succeeded or
        -- not (on insufficient funds it just chat-messages the player). We
        -- report success; the wallet refetches the list, so an unpaid bill
        -- simply reappears.
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Wallet.Name,
            message = "Invoice paid!"
        })
        cb(true)
    end, id)
end)

-- ============================================================================
-- Card-to-card (Contacts → chat → "Send money")
--
-- The phone deliberately owns NO financial logic. Per design:
--   1. Resolve the CONTACT's 6-digit bank code (their `bank_number`) on the
--      server — a read-only lookup, no money touched here.
--   2. Hand that code to the bank resource's OWN trigger (`bank:openMobileBank`)
--      so the real bank UI performs the actual transfer.
--
-- The resolved code is also returned to the UI so it can be copied to the
-- clipboard (the bank UI ships minified, so it can't be programmatically
-- populated from here). sun-banking's bank:openMobileBank now accepts an
-- optional { card = "<6digits>" } payload: when present it opens the bank
-- with the transfer panel enabled and the code wired through (prefillCard).
-- ============================================================================
RegisterNUICallback('open-bank-transfer', function(body, cb)
    local toIdentifier = body and body.to_identifier
    local toPhone = body and body.to_phone_number
    if (not toIdentifier or toIdentifier == '') and (not toPhone or toPhone == '') then
        cb(false)
        return
    end

    ESX.TriggerServerCallback('sun-phone:server:GetBankCard', function(card)
        if not card or card == '' then
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = Config.App.Wallet.Name,
                message = "This contact doesn't have a bank account."
            })
            cb(false)
            return
        end

        card = tostring(card)

        -- Return the code to the UI first (lets it copy to clipboard for
        -- pasting), THEN dismiss the phone and open the real bank.
        cb({ ok = true, card = card })

        if ClosePhoneFully then
            ClosePhoneFully()
        end

        Citizen.SetTimeout(1000, function()
            TriggerEvent('bank:openMobileBank', { card = card })
        end)
    end, toIdentifier, toPhone)
end)
