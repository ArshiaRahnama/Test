AddMoneyToSociety = function(money, sellerJobName)
    if Config.Core == "ESX" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..sellerJobName, function(account)
            if account then
                account.addMoney(money)
            else
                print(('[vms_gym] ^1society account "society_%s" does not exist^7 - %s$ was not paid out.'):format(sellerJobName, money))
            end
        end)
    elseif Config.Core == "QB-Core" then
        exports['qb-management']:AddGangMoney(sellerJobName, money)
    end
end