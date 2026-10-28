if not Config.Arshia or not Config.Arshia.BankOnWallet then return end

-- Arshia Phone: tapping the Wallet card opens the server bank UI (new_banking),
-- the same way the old Unique_Phone wallet did.
RegisterNUICallback("ArshiaOpenBank", function(_, cb)
    cb({ ok = true })

    if GetResourceState("new_banking") ~= "started" then
        print("^1[Arshia Phone]^7 new_banking is not started, bank UI unavailable")
        return
    end

    local ok, err = pcall(function()
        exports["new_banking"]:OpenBankUI()
    end)
    if not ok then
        print("^1[Arshia Phone]^7 OpenBankUI failed: " .. tostring(err))
    end
end)
