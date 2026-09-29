--=====================================================================
--  VMS Housing - Server Config
--  ESX integration using esx:getSharedObject (matches ArshiaRahnama/Test server pattern)
--=====================================================================

SV = {}

--=====================================================================
--  Framework bootstrap
--  ESX: TriggerEvent('esx:getSharedObject', ...) -- همون pattern سرور شما
--  در init.lua مقدار Core از Config.CoreExport() میاد، پس اینجا فقط
--  SV wrapper رو تعریف می‌کنیم که روی Core کار کنه.
--=====================================================================

--=====================================================================
--  Player helpers
--=====================================================================

--- xPlayer رو از source id برمیگردونه
function SV.GetPlayer(src)
    if Config.Core == "ESX" then
        return Core.GetPlayerFromId(src)
    elseif Config.Core == "QB-Core" then
        return Core.Functions.GetPlayer(src)
    end
    return nil
end

--- identifier (license/steam) بازیکن رو برمیگردونه
function SV.GetIdentifier(xPlayer)
    if not xPlayer then return nil end
    if Config.Core == "ESX" then
        return xPlayer.identifier
    elseif Config.Core == "QB-Core" then
        return xPlayer.PlayerData and xPlayer.PlayerData.citizenid
    end
    return nil
end

--- نام کاراکتر بازیکن
function SV.GetCharacterName(xPlayer)
    if not xPlayer then return "Unknown" end
    if Config.Core == "ESX" then
        return xPlayer.getName and xPlayer.getName() or (xPlayer.name or "Unknown")
    elseif Config.Core == "QB-Core" then
        local pd = xPlayer.PlayerData
        if pd and pd.charinfo then
            return (pd.charinfo.firstname or "") .. " " .. (pd.charinfo.lastname or "")
        end
    end
    return "Unknown"
end

--- job info: field = "name" | "grade" | "label"
function SV.GetPlayerJob(xPlayer, field)
    if not xPlayer then return nil end
    if Config.Core == "ESX" then
        local job = xPlayer.job
        if not job then return nil end
        if field == "name"  then return job.name  end
        if field == "grade" then return job.grade  end
        if field == "label" then return job.label  end
        return job
    elseif Config.Core == "QB-Core" then
        local pd = xPlayer.PlayerData
        local job = pd and pd.job
        if not job then return nil end
        if field == "name"  then return job.name  end
        if field == "grade" then return job.grade and job.grade.level end
        if field == "label" then return job.label end
        return job
    end
    return nil
end

--- تعداد آیتم از inventory بازیکن
function SV.GetItemCount(xPlayer, itemName)
    if not xPlayer then return 0 end
    if Config.Core == "ESX" then
        local item = xPlayer.getInventoryItem and xPlayer.getInventoryItem(itemName)
        return item and item.count or 0
    elseif Config.Core == "QB-Core" then
        local item = xPlayer.Functions and xPlayer.Functions.GetItemByName(itemName)
        return item and item.amount or 0
    end
    return 0
end

--- پیدا کردن بازیکن با identifier (license یا citizenid)
function SV.GetPlayerByIdentifier(identifier)
    if Config.Core == "ESX" then
        return Core.GetPlayerFromIdentifier(identifier)
    elseif Config.Core == "QB-Core" then
        return Core.Functions.GetPlayerByCitizenId(identifier)
    end
    return nil
end

--=====================================================================
--  Inventory item helpers
--  (اینا wrapper روی integration/[inventory] هستن که RegisterUsableItem و GetItem رو تعریف می‌کنن)
--=====================================================================

--- ثبت آیتم قابل استفاده
function SV.RegisterUsableItem(name, cb)
    if RegisterUsableItem then
        -- از integration/[inventory] میاد
        RegisterUsableItem(name, cb)
    elseif Config.Core == "ESX" then
        Core.RegisterUsableItem(name, function(src, itemName, itemData)
            cb(src, Core.GetPlayerFromId(src), itemData)
        end)
    elseif Config.Core == "QB-Core" then
        Core.Functions.CreateUseableItem(name, function(src, item)
            cb(src, Core.Functions.GetPlayer(src), item)
        end)
    end
end

--- گرفتن آیتم از inventory (برای چک کردن کلید)
function SV.GetItem(src, xPlayer, name, data, search)
    if GetItem then
        return GetItem(src, xPlayer, name, data, search)
    end
    return nil
end

--- اضافه کردن آیتم به inventory
function SV.AddItem(src, xPlayer, name, count, metadata)
    if AddItem then
        AddItem(src, xPlayer, name, count, metadata)
    end
end

--- حذف آیتم از inventory
function SV.RemoveItem(src, xPlayer, name, count)
    if RemoveItem then
        RemoveItem(src, xPlayer, name, count)
    end
end

--=====================================================================
--  پرداخت / مالیات
--=====================================================================

--- کسر مبلغ از حساب بازیکن (برای خرید خانه / پرداخت قبض)
--- returns true اگه موفق بود
function SV.AddTax(xPlayer, amount, reason)
    if not xPlayer or not amount then return false end
    amount = math.abs(tonumber(amount) or 0)
    if amount <= 0 then return false end

    if Config.Core == "ESX" then
        local money = xPlayer.getMoney and xPlayer.getMoney() or 0
        if money < amount then
            return false
        end
        xPlayer.removeMoney(amount, reason or "vms_housing")
        return true

    elseif Config.Core == "QB-Core" then
        local cash = xPlayer.Functions and xPlayer.Functions.GetMoney("cash") or 0
        if cash < amount then
            return false
        end
        xPlayer.Functions.RemoveMoney("cash", amount, reason or "vms_housing")
        return true
    end

    return false
end

--- اضافه کردن پول به بازیکن (برای فروش / برگشت وجه)
function SV.GiveMoney(xPlayer, amount, reason)
    if not xPlayer or not amount then return end
    amount = math.abs(tonumber(amount) or 0)
    if amount <= 0 then return end

    if Config.Core == "ESX" then
        xPlayer.addMoney(amount, reason or "vms_housing")
    elseif Config.Core == "QB-Core" then
        xPlayer.Functions.AddMoney("cash", amount, reason or "vms_housing")
    end
end

--=====================================================================
--  ورود / خروج خانه
--  این دو تابع از طرف main.lua صدا زده میشن
--  بررسی می‌کنن آیا بازیکن اجازه ورود یا خروج داره
--=====================================================================

function SV.CanEnterHouse(src, xPlayer)
    -- اجازه ورود به همه داده میشه؛ بررسی واقعی (lock/key)
    -- توی main.lua بعد از این تابع انجام میشه
    if not xPlayer then
        return false, "player_not_found"
    end
    return true, nil
end

function SV.CanExitHouse(src, xPlayer)
    if not xPlayer then
        return false, "player_not_found"
    end
    return true, nil
end

--- گرفتن موجودی حساب (account: "bank" | "cash")
function SV.GetMoney(xPlayer, account)
    if not xPlayer then return 0 end
    account = account or "bank"
    if Config.Core == "ESX" then
        if account == "cash" then
            return xPlayer.getMoney and xPlayer.getMoney() or 0
        end
        local acc = xPlayer.getAccount and xPlayer.getAccount(account)
        return acc and acc.money or 0
    elseif Config.Core == "QB-Core" then
        local qbAccount = (account == "bank") and "bank" or "cash"
        return xPlayer.Functions and xPlayer.Functions.GetMoney(qbAccount) or 0
    end
    return 0
end

--- کسر پول از حساب بازیکن
function SV.RemoveMoney(xPlayer, account, amount, reason)
    if not xPlayer or not amount then return false end
    amount = math.abs(tonumber(amount) or 0)
    if amount <= 0 then return false end
    account = account or "bank"
    if Config.Core == "ESX" then
        if account == "cash" then
            xPlayer.removeMoney(amount, reason or "vms_housing")
        else
            xPlayer.removeAccountMoney(account, amount, reason or "vms_housing")
        end
        return true
    elseif Config.Core == "QB-Core" then
        xPlayer.Functions.RemoveMoney((account == "bank") and "bank" or "cash", amount, reason or "vms_housing")
        return true
    end
    return false
end

--- اضافه کردن پول به حساب بازیکن آنلاین
function SV.AddMoney(xPlayer, account, amount, reason)
    if not xPlayer or not amount then return end
    amount = math.abs(tonumber(amount) or 0)
    if amount <= 0 then return end
    account = account or "bank"
    if Config.Core == "ESX" then
        if account == "cash" then
            xPlayer.addMoney(amount, reason or "vms_housing")
        else
            xPlayer.addAccountMoney(account, amount, reason or "vms_housing")
        end
    elseif Config.Core == "QB-Core" then
        xPlayer.Functions.AddMoney((account == "bank") and "bank" or "cash", amount, reason or "vms_housing")
    end
end

--- پرداخت آفلاین - مستقیم DB update (oxmysql)
function SV.AddMoneyOffline(xPlayer, account, amount, reason)
    if xPlayer then
        SV.AddMoney(xPlayer, account, amount, reason)
        return
    end
    -- بازیکن آفلاینه: این case توسط main.lua هندل میشه (ownerPlayer == nil)
end

--=====================================================================
--  Webhook logger
--  SV.Webhook(eventKey, title, description, color, identifier)
--=====================================================================
function SV.Webhook(eventKey, title, description, color, identifier)
    if not Webhooks then return end
    local url = Webhooks[eventKey]
    if not url or url == "" then return end

    color      = color or 3447003
    identifier = identifier or ""

    local payload = json.encode({
        embeds = {{
            title       = tostring(title or eventKey),
            description = tostring(description or ""),
            color       = tonumber(color) or 3447003,
            footer      = { text = "vms_housing • " .. tostring(identifier) },
            timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }}
    })

    PerformHttpRequest(url, function(statusCode)
        if Config.Debug and statusCode ~= 204 and statusCode ~= 200 then
            print("[vms_housing] Webhook error '" .. eventKey .. "': HTTP " .. tostring(statusCode))
        end
    end, "POST", payload, { ["Content-Type"] = "application/json" })
end
