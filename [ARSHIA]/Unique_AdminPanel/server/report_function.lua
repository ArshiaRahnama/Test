--[[
    PNG_ReportSystem - server/function.lua
    FIXED VERSION - همه‌ی توابع اینجا دقیقا همون اسمی هستن که تو main.lua صدا زده میشن.
]]

local Q = {
    GetAdminXP      = "SELECT png_admin_xp FROM users WHERE identifier = @identifier",
    UpdateAdminXP   = "UPDATE users SET png_admin_xp = @xp WHERE identifier = @identifier",
    GetChat         = "SELECT chat FROM reports WHERE ID = @id",
    UpdateChat      = "UPDATE reports SET chat = @chat WHERE ID = @id",
    GetReportById   = "SELECT * FROM reports WHERE ID = @id",
}

-- ==================== Notifications ====================

-- نوتیف/چت به یک پلیر خاص (بر اساس Config_Server.alertToNewMessage / alertToNewReport استفاده میشه)
function SendNotif(playerId, message)
    if not playerId or not message then return end
    TriggerClientEvent('chat:addMessage', playerId, {
        color = { 255, 60, 60 },
        multiline = true,
        args = { "^3 [ Report System ] ^0", message }
    })
end

-- ==================== Access ====================

function serverAceess(source, requiredLevel, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        callback(tonumber(xPlayer.permission_level) >= tonumber(requiredLevel))
    else
        callback(false)
    end
end

-- ==================== Admin XP ====================
-- توجه: اینجا با identifier کار میکنیم نه source، چون وقتی پلیری
-- بهش فیدبک میدن ممکنه ادمین آفلاین شده باشه.

function GetAdminXPByIdentifier(identifier)
    if not identifier then return 0 end
    local result = MySQL.Sync.fetchAll(Q.GetAdminXP, { ['@identifier'] = identifier })
    if result and result[1] and result[1].png_admin_xp then
        return tonumber(result[1].png_admin_xp) or 0
    end
    return 0
end

function SetAdminXPByIdentifier(identifier, newXP)
    if not identifier then return end
    if newXP < 0 then newXP = 0 end
    MySQL.Async.execute(Q.UpdateAdminXP, {
        ['@identifier'] = identifier,
        ['@xp'] = newXP
    })
end

function AddAdminXPByIdentifier(identifier, amount)
    local current = GetAdminXPByIdentifier(identifier)
    SetAdminXPByIdentifier(identifier, current + (tonumber(amount) or 0))
end

-- exports اعلام‌شده تو fxmanifest (PNG_GET_ADMIN_XP / PNG_ADD_ADMIN_XP / ...)
-- این‌ها با آیدی آنلاین پلیر کار میکنن (برای دستورات ادمین /addxp و ...)
function PNG_GET_ADMIN_XP(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return 0 end
    return GetAdminXPByIdentifier(xPlayer.identifier)
end

function PNG_ADD_ADMIN_XP(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false end
    AddAdminXPByIdentifier(xPlayer.identifier, tonumber(amount) or 0)
    return true
end

function PNG_REMOVE_ADMIN_XP(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false end
    AddAdminXPByIdentifier(xPlayer.identifier, -(tonumber(amount) or 0))
    return true
end

function PNG_CLEAN_ADMIN_XP(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return false end
    SetAdminXPByIdentifier(xPlayer.identifier, 0)
    return true
end

-- ==================== Chat / گفتگوی داخل ریپورت ====================

function GetChatMessages(reportId)
    local result = MySQL.Sync.fetchAll(Q.GetChat, { ['@id'] = reportId })
    if result and result[1] and result[1].chat then
        local ok, decoded = pcall(json.decode, result[1].chat)
        if ok and decoded then
            table.sort(decoded, function(a, b) return (a.msgid or 0) < (b.msgid or 0) end)
            return decoded
        end
    end
    return {}
end

function SaveChatMessage(reportId, user, text)
    if not text or text == '' then return false end
    local chat = GetChatMessages(reportId)
    local maxId = 0
    for _, msg in ipairs(chat) do
        if (msg.msgid or 0) > maxId then maxId = msg.msgid end
    end
    table.insert(chat, { msgid = maxId + 1, user = user, text = text })
    MySQL.Async.execute(Q.UpdateChat, {
        ['@chat'] = json.encode(chat),
        ['@id'] = reportId
    })
    return true
end

function GetReportById(reportId)
    local result = MySQL.Sync.fetchAll(Q.GetReportById, { ['@id'] = reportId })
    if result and result[1] then
        return result[1]
    end
    return nil
end

-- ==================== Broadcast به ادمین‌ها ====================

function UpdateAllReport()
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
        if xPlayer and tonumber(xPlayer.permission_level) > 0 then
            TriggerClientEvent('PNG_ReportSystem:updateReportListAllAdmin', xPlayer.source)
        end
    end
end

function SendNotifToAllAdmin()
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
        if xPlayer and tonumber(xPlayer.permission_level) > 0 then
            local alertType = Config_Server.alertToNewReport
            if alertType == "chat" then
                SendNotif(xPlayer.source, ReportLan.newReprot)
            elseif alertType == "notif" then
                TriggerClientEvent('esx:showNotification', xPlayer.source, ReportLan.newReprot)
            elseif alertType == "png_notif" then
                pcall(function()
                    exports['PNG_AdminAndLogSystem']:SendNotif(xPlayer.source, 'success', 'ریپورت', ReportLan.newReprot, 5000, 'msg')
                end)
            end
        end
    end
end

function NotifyAdminNewMessage(adminIdentifier)
    local xAdmin = ESX.GetPlayerFromIdentifier(adminIdentifier)
    if xAdmin then
        TriggerClientEvent('PNG_ReportSystem:UpdateUIMessage', xAdmin.source, 'admin')
        if Config_Server.alertToNewMessage == "chat" then
            SendNotif(xAdmin.source, ReportLan.AdminAlertNewMessage)
        elseif Config_Server.alertToNewMessage == "notif" then
            TriggerClientEvent('esx:showNotification', xAdmin.source, ReportLan.AdminAlertNewMessage)
        end
    end
end

function NotifyUserNewMessage(userIdentifier)
    local xUser = ESX.GetPlayerFromIdentifier(userIdentifier)
    if xUser then
        TriggerClientEvent('PNG_ReportSystem:UpdateUIMessage', xUser.source, 'user')
        if Config_Server.alertToNewMessage == "chat" then
            SendNotif(xUser.source, ReportLan.UserAlertNewMessage)
        elseif Config_Server.alertToNewMessage == "notif" then
            TriggerClientEvent('esx:showNotification', xUser.source, ReportLan.UserAlertNewMessage)
        end
    end
end

-- ==================== Steam Avatar (best effort) ====================

function GetSteamAvatarByIdentifier(identifier, cb)
    if not identifier or not identifier:find('steam:') then
        return cb("./img/self.png")
    end
    local steamID = identifier:gsub("steam:", "")
    local url = ("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s")
        :format(Config_Server.SteamAPIKey or "", steamID)

    if not Config_Server.SteamAPIKey or Config_Server.SteamAPIKey == "" then
        return cb("./img/self.png")
    end

    PerformHttpRequest(url, function(status, response)
        if status ~= 200 or not response then return cb("./img/self.png") end
        local ok, data = pcall(json.decode, response)
        if ok and data and data.response and data.response.players and data.response.players[1] then
            cb(data.response.players[1].avatarfull or "./img/self.png")
        else
            cb("./img/self.png")
        end
    end, 'GET', '', {})
end
