ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    local sourcePlayer = playerId
    local identifier = xPlayer.identifier

    getOrGeneratePhoneNumber(identifier, function(myPhoneNumber)
    end)

    getOrGenerateIBAN(identifier, function(iban)
    end)


end)

function GetIranianDateTime()
    local utcTime = os.time(os.date("!*t"))
    local iranOffset = 3.5 * 60 * 60
    local iranTime = utcTime + iranOffset
    local iranDate = os.date("*t", iranTime)


    local dateString = string.format("%02d-%02d-%04d", iranDate.day, iranDate.month, iranDate.year)


    local timeString = string.format("%02d:%02d", iranDate.hour, iranDate.min)

    return {
        dateString = dateString,
        timeString = timeString
    }
end

ESX.RegisterServerCallback('Unique_Phone:server:GetDateTime', function(source, cb)
    local datetime = GetIranianDateTime()
    cb(datetime.dateString, datetime.timeString)
end)

local MIPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}

function getPhoneRandomNumber()
    local numBase0  = 0
    local numBase1  = 5
    local numBase2  = 2
    local numBase3  = math.random(1, 9)
    local numBase4  = math.random(0, 9)
    local numBase5  = math.random(0, 9)
    local numBase6  = math.random(0, 9)
    local numBase7  = math.random(0, 9)
    local numBase8  = math.random(0, 9)
    local numBase9  = math.random(0, 9)
    local numBase10 = math.random(0, 9)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. ""..numBase3 .. "" .. numBase4 .. "" .. numBase5 .. "" .. numBase6 .. "" .. numBase7 .. "" .. numBase8 .. "" .. numBase9 .. "" .. numBase10 .. "")
    return num
end

function generateIBAN()
    local numBase0 = math.random(1111111, 9999999)
    local num = string.format(numBase0)

	return num
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end

function getIBAN(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.iban FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].iban
    end
    return nil
end

function getOrGenerateIBAN(identifier, cb)
    local identifier = identifier
    local myIBAN = getIBAN(identifier)

    if myIBAN == '0' or myIBAN == nil then
        repeat
            myIBAN = generateIBAN()
            local id = getPlayerFromIBAN(myIBAN)

        until id == nil

        MySQL.Async.insert("UPDATE users SET iban = @myIBAN WHERE identifier = @identifier", {
            ['@myIBAN'] = myIBAN,
            ['@identifier'] = identifier

        }, function()
            cb(myIBAN)
        end)
    else
        cb(myIBAN)
    end
end

function getOrGeneratePhoneNumber(identifier, cb)
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)

    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = GetPlayerFromPhone(myPhoneNumber)

        until id == nil

        MySQL.Async.insert("UPDATE users SET phone = @myPhoneNumber WHERE identifier = @identifier", {
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier

        }, function()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end

RegisterServerEvent('Unique_Phone:saveTwitterToDatabase')
AddEventHandler('Unique_Phone:saveTwitterToDatabase', function(firstName, lastname, message, url, time, picture)
    local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO twitter_tweets (firstname, lastname, message, url, time, picture, owner) VALUES (@firstname, @lastname, @message, @url, @time, @picture, @owner)',
	{
		['@firstname']   	= firstName,
		['@lastname']   	= lastname,
		['@message'] 	= message,
        ['@url']       = url,
		['@time']  = time,
        ['@picture'] 		= picture,
        ['@owner'] 		= xPlayer.identifier,

	})
end)

ESX.RegisterServerCallback("Unique_Phone:Server:GetPhoneNumber", function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer then
        cb(getNumberPhone(xPlayer.identifier), string.gsub(xPlayer.name, "_", " "))
    else
        cb(false)
    end
end)

RegisterServerEvent('Unique_Phone:server:AddAdvert')
AddEventHandler('Unique_Phone:server:AddAdvert', function(msg)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local Identifier = Player.identifier
    local character = GetCharacter(src)

    if Adverts[Identifier] ~= nil then
        Adverts[Identifier].message = msg
        Adverts[Identifier].name = "@" .. character.name
        Adverts[Identifier].number = character.phone
    else
        Adverts[Identifier] = {
            message = msg,
            name = "@" .. character.name,
            number = character.phone,
        }
    end

    TriggerClientEvent('Unique_Phone:client:UpdateAdverts', -1, Adverts, "@" .. character.name)
end)

function GetOnlineStatus(number)
    local Target = GetPlayerFromPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

RegisterServerEvent('Unique_Phone:server:updateForEveryone')
AddEventHandler('Unique_Phone:server:updateForEveryone', function(newTweet)
    local src = source
    TriggerClientEvent('Unique_Phone:updateForEveryone', -1, newTweet)
end)

RegisterServerEvent('Unique_Phone:server:updateidForEveryone')
AddEventHandler('Unique_Phone:server:updateidForEveryone', function()
    TriggerClientEvent('Unique_Phone:updateidForEveryone', -1)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            SelfTweets = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            MetaData = {},
        }
        PhoneData.Adverts = Adverts

        ExecuteSql(false, "SELECT * FROM `users` WHERE `identifier`=@p1", {['@p1'] = Player.identifier}, function(result)
            if result then
                PhoneData.MetaData = result[1]
            end


            ExecuteSql(false, "SELECT * FROM player_contacts WHERE `identifier` = @p1 ORDER BY `name` ASC", {['@p1'] = Player.identifier}, function(result)
                local Contacts = {}
                if result[1] ~= nil then
                    for k, v in pairs(result) do
                        v.status = GetOnlineStatus(v.number)
                    end

                    PhoneData.PlayerContacts = result
                end

                ExecuteSql(false, "SELECT * FROM twitter_tweets", {}, function(result)
                    if result[1] ~= nil then
                        PhoneData.Tweets = result
                    else
                        PhoneData.Tweets = nil
                    end

                    ExecuteSql(false, "SELECT * FROM twitter_tweets WHERE owner = @p1", {['@p1'] = Player.identifier}, function(result)
                        if result ~= nil then
                            PhoneData.SelfTweets = result

                        end
                ExecuteSql(false, "SELECT * FROM owned_vehicles WHERE `owner` = @p1", {['@p1'] = Player.identifier}, function(garageresult)

                    if garageresult[1] ~= nil then
                        PhoneData.Garage = garageresult
                    end

                    ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` ASC", {['@p1'] = Player.identifier}, function(mails)

                        if mails[1] ~= nil then
                            for k, v in pairs(mails) do
                                if mails[k].button ~= nil then
                                    mails[k].button = json.decode(mails[k].button)
                                end
                            end
                            PhoneData.Mails = mails
                        end

                        ExecuteSql(false, "SELECT * FROM phone_messages WHERE `identifier` = @p1", {['@p1'] = Player.identifier}, function(messages)
                            if messages ~= nil and next(messages) ~= nil then
                                PhoneData.Chats = messages
                            end

                            if AppAlerts[Player.identifier] ~= nil then
                                PhoneData.Applications = AppAlerts[Player.identifier]
                            end

                            if MentionedTweets[Player.identifier] ~= nil then
                                PhoneData.MentionedTweets = MentionedTweets[Player.identifier]
                            end

                            if Hashtags ~= nil and next(Hashtags) ~= nil then
                                PhoneData.Hashtags = Hashtags
                            end



                            PhoneData.charinfo = GetCharacter(src)

                            ExecuteSql(false, "SELECT image_url FROM phone_gallery  WHERE `identifier` = @p1", {['@p1'] = Player.identifier}, function(images)
                                if images[1] ~= nil then

                                    PhoneData.Images = images
                                else
                                    PhoneData.Images = {}
                                end

                                if Config.UseESXBilling then
                                    ExecuteSql(false, "SELECT * FROM billing  WHERE `identifier` = @p1", {['@p1'] = Player.identifier}, function(invoices)
                                        if invoices[1] ~= nil then
                                            for k, v in pairs(invoices) do
                                                local Ply = ESX.GetPlayerFromIdentifier(v.sender)
                                                if Ply ~= nil then
                                                    v.number = GetCharacter(Ply.source).phone
                                                else
                                                    ExecuteSql(true, "SELECT * FROM `users` WHERE `identifier` = @p1", {['@p1'] = v.sender}, function(res)
                                                        if res[1] ~= nil then
                                                            v.number = res[1].phone
                                                        else
                                                            v.number = nil
                                                        end
                                                    end)
                                                end
                                            end
                                            PhoneData.Invoices = invoices
                                        end
                                        cb(PhoneData)
                                    end)
                                else
                                    PhoneData.Invoices = {}
                                    cb(PhoneData)
                                end
                            end)
                        end)
                    end)
                    end)
                end)
            end)
            end)
        end)
    end
end)

RegisterServerEvent('Unique_Phone:deleteTweet')
AddEventHandler('Unique_Phone:deleteTweet', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM twitter_tweets WHERE owner = @owner AND id = @id', {['@owner'] = xPlayer.identifier, ['@id'] = id})
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetCallState', function(source, cb, ContactData)

    local Target = GetPlayerFromPhone(ContactData)

    if Target ~= nil then
        if Calls[Target.identifier] ~= nil then
            if Calls[Target.identifier].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetCallStateAdmin', function(source, cb, ContactData)

    local Target = ESX.GetPlayerFromId(ContactData)

    if Target ~= nil then
        if Calls[Target.identifier] ~= nil then
            if Calls[Target.identifier].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('Unique_Phone:server:SetCallState')
AddEventHandler('Unique_Phone:server:SetCallState', function(bool)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)

    if Calls[Ply.identifier] ~= nil then
        Calls[Ply.identifier].inCall = bool
    else
        Calls[Ply.identifier] = {}
        Calls[Ply.identifier].inCall = bool
    end
end)

RegisterServerEvent('Unique_Phone:server:RemoveMail')
AddEventHandler('Unique_Phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "DELETE FROM `player_mails` WHERE `mailid` = @p1 AND `identifier` = @p2", {['@p1'] = MailId, ['@p2'] = Player.identifier})
    SetTimeout(100, function()
        ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` ASC", {['@p1'] = Player.identifier}, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('Unique_Phone:client:UpdateMails', src, mails)
        end)
    end)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('Unique_Phone:server:sendNewMail')
AddEventHandler('Unique_Phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if mailData.button == nil then
        ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@p1, @p2, @p3, @p4, @p5, '0')", {['@p1'] = Player.identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId()})
    else
        ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@p1, @p2, @p3, @p4, @p5, '0', @p6)", {['@p1'] = Player.identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId(), ['@p6'] = json.encode(mailData.button)})
    end
    TriggerClientEvent('Unique_Phone:client:NewMailNotify', src, mailData)

    SetTimeout(200, function()
        ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` DESC", {['@p1'] = Player.identifier}, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('Unique_Phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('Unique_Phone:server:sendNewMailToOffline')
AddEventHandler('Unique_Phone:server:sendNewMailToOffline', function(steam, mailData)
    local Player = ESX.GetPlayerFromIdentifier(steam)

    if Player ~= nil then
        local src = Player.source

        if mailData.button == nil then
            ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@p1, @p2, @p3, @p4, @p5, '0')", {['@p1'] = Player.identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId()})
            TriggerClientEvent('Unique_Phone:client:NewMailNotify', src, mailData)
        else
            ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@p1, @p2, @p3, @p4, @p5, '0', @p6)", {['@p1'] = Player.identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId(), ['@p6'] = json.encode(mailData.button)})
            TriggerClientEvent('Unique_Phone:client:NewMailNotify', src, mailData)
        end

        SetTimeout(200, function()
            ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` DESC", {['@p1'] = Player.identifier}, function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end

                TriggerClientEvent('Unique_Phone:client:UpdateMails', src, mails)
            end)
        end)
    else
        if mailData.button == nil then
            ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@p1, @p2, @p3, @p4, @p5, '0')", {['@p1'] = identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId()})
        else
            ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@p1, @p2, @p3, @p4, @p5, '0', @p6)", {['@p1'] = identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId(), ['@p6'] = json.encode(mailData.button)})
        end
    end
end)

RegisterServerEvent('Unique_Phone:server:sendNewEventMail')
AddEventHandler('Unique_Phone:server:sendNewEventMail', function(steam, mailData)
    if mailData.button == nil then
        ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (@p1, @p2, @p3, @p4, @p5, '0')", {['@p1'] = identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId()})
    else
        ExecuteSql(false, "INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (@p1, @p2, @p3, @p4, @p5, '0', @p6)", {['@p1'] = identifier, ['@p2'] = mailData.sender, ['@p3'] = mailData.subject, ['@p4'] = mailData.message, ['@p5'] = GenerateMailId(), ['@p6'] = json.encode(mailData.button)})
    end
    SetTimeout(200, function()
        ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` DESC", {['@p1'] = Player.identifier}, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('Unique_Phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('Unique_Phone:server:ClearButtonData')
AddEventHandler('Unique_Phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "UPDATE `player_mails` SET `button` = \"\" WHERE `mailid` = @p1 AND `identifier` = @p2", {['@p1'] = mailId, ['@p2'] = Player.identifier})
    SetTimeout(200, function()
        ExecuteSql(false, "SELECT * FROM `player_mails` WHERE `identifier` = @p1 ORDER BY `date` DESC", {['@p1'] = Player.identifier}, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('Unique_Phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('Unique_Phone:server:MentionedPlayer')
AddEventHandler('Unique_Phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayerFromId(v)
        local character = GetCharacter(v)

        if Player ~= nil then
            if (character.firstname == firstName and character.lastname == lastName) then
                MIPhone.SetPhoneAlerts(Player.identifier, "twitter")

                MIPhone.AddMentionedTweet(Player.identifier, TweetMessage)
                TriggerClientEvent('Unique_Phone:client:GetMentioned', Player.source, TweetMessage, AppAlerts[Player.identifier]["twitter"])

            else
                ExecuteSql(false, "SELECT * FROM `users` WHERE `firstname`=@p1 AND `lastname`=@p2", {['@p1'] = firstName, ['@p2'] = lastName}, function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].identifier
                        MIPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                        MIPhone.AddMentionedTweet(MentionedTarget, TweetMessage)

                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('Unique_Phone:server:CallContact')
AddEventHandler('Unique_Phone:server:CallContact', function(TargetData, CallId, AnonymousCall, Acall)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    local Target = GetPlayerFromPhone(TargetData.number)
    local character = GetCharacter(src)
    local PhoneNum
    if Acall then
        PhoneNum = "(Staff)"
    else
        PhoneNum = character.phone
    end

    if Target ~= nil then
        TriggerClientEvent('Unique_Phone:client:GetCalled', Target.source, PhoneNum, CallId, AnonymousCall)
    end
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetBankData', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    cb({bank = xPlayer.bank, iban = character.iban})
end)

-- EXPANSION: Security app — recent-devices list + force-logout-everywhere +
-- in-game password change. All the actual DB work lives in Unique_Login;
-- this resource just forwards to its exports so login_users/login_audit
-- are only ever touched from one place.
ESX.RegisterServerCallback('Unique_Phone:server:GetSecurityDevices', function(source, cb)
    exports['Unique_Login']:getDevicesForPlayer(source, function(data)
        cb(data)
    end)
end)

-- EXPANSION: two-step password change (current password -> SMS OTP to the
-- account's registered phone -> confirm). Split into two callbacks so the
-- phone UI can show a code-entry screen between them.
ESX.RegisterServerCallback('Unique_Phone:server:RequestPasswordChangeOtp', function(source, cb, oldPassword)
    exports['Unique_Login']:requestPasswordChangeOtp(source, oldPassword, function(success, reason, maskedPhone)
        cb({ success = success, reason = reason, maskedPhone = maskedPhone })
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:ConfirmPasswordChange', function(source, cb, code, newPassword)
    exports['Unique_Login']:confirmPasswordChange(source, code, newPassword, function(success, reason)
        cb({ success = success, reason = reason })
    end)
end)

RegisterServerEvent('Unique_Phone:server:LogoutAllDevices')
AddEventHandler('Unique_Phone:server:LogoutAllDevices', function()
    local src = source
    exports['Unique_Login']:logoutAllDevices(src)
end)

ESX.RegisterServerCallback('Unique_Phone:server:CanPayInvoice', function(source, cb, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    cb(xPlayer.bank >= amount)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetInvoices', function(source, cb)
    Player = ESX.GetPlayerFromId(source)
    ExecuteSql(false, "SELECT * FROM billing  WHERE `identifier` = @p1", {['@p1'] = Player.identifier}, function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = ESX.GetPlayerFromIdentifier(v.sender)
                if Ply ~= nil then
                    v.number = GetCharacter(Ply.source).phone
                else
                    ExecuteSql(true, "SELECT * FROM `users` WHERE `identifier` = @p1", {['@p1'] = v.sender}, function(res)
                        if res[1] ~= nil then
                            v.number = res[1].phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            PhoneData.Invoices = invoices
            cb(invoices)
        else
            cb({})
        end
    end)
end)

RegisterServerEvent('Unique_Phone:server:UpdateHashtags')
AddEventHandler('Unique_Phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('Unique_Phone:client:UpdateHashtags', -1, Handle, messageData)
end)

MIPhone.AddMentionedTweet = function(identifier, TweetData)
    if MentionedTweets[identifier] == nil then MentionedTweets[identifier] = {} end
    table.insert(MentionedTweets[identifier], TweetData)
end

MIPhone.SetPhoneAlerts = function(identifier, app, alerts)
    if identifier ~= nil and app ~= nil then
        if AppAlerts[identifier] == nil then
            AppAlerts[identifier] = {}
            if AppAlerts[identifier][app] == nil then
                if alerts == nil then
                    AppAlerts[identifier][app] = 1
                else
                    AppAlerts[identifier][app] = alerts
                end
            end
        else
            if AppAlerts[identifier][app] == nil then
                if alerts == nil then
                    AppAlerts[identifier][app] = 1
                else
                    AppAlerts[identifier][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[identifier][app] = AppAlerts[identifier][app] + 1

                else
                    AppAlerts[identifier][app] = AppAlerts[identifier][app] + 0
                end
            end
        end
    end
end

ESX.RegisterServerCallback('Unique_Phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = ESX.GetPlayerFromIdentifier(v.number)

        ExecuteSql(false, "SELECT * FROM `users` WHERE `phone`=@p1", {['@p1'] = v.number}, function(result)
            if result[1] ~= nil then
                if result[1].profilepicture ~= nil then
                    v.picture = result[1].profilepicture
                else
                    v.picture = "default"
                end
            end
        end)
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetContactPicture', function(source, cb, Chat)
    ExecuteSql(false, "SELECT * FROM `users` WHERE `phone`=@p1", {['@p1'] = Chat.number}, function(result)
        if result[1] and result[1].background then
            Chat.picture = result[1].background
            cb(Chat)
        else
            Chat.picture = "default"
            cb(Chat)
        end
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetPicture', function(source, cb, number)
    local Player = GetPlayerFromPhone(number)
    local Picture = nil

    ExecuteSql(false, "SELECT * FROM `users` WHERE `phone`=@p1", {['@p1'] = number}, function(result)
        if result[1] ~= nil then
            if result[1].profilepicture ~= nil then
                Picture = result[1].profilepicture
            else
                Picture = "default"
            end
            cb(Picture)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('Unique_Phone:server:SetPhoneAlerts')
AddEventHandler('Unique_Phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local Identifier = ESX.GetPlayerFromId(src).identifier
    MIPhone.SetPhoneAlerts(Identifier, app, alerts)
end)

RegisterServerEvent('Unique_Phone:server:UpdateTweets')
AddEventHandler('Unique_Phone:server:UpdateTweets', function(TweetData, type)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('Unique_Phone:client:UpdateTweets', -1, src, TwtData, type)
end)

RegisterServerEvent('Unique_Phone:server:TransferMoney')
AddEventHandler('Unique_Phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = ESX.GetPlayerFromId(src)
    if not sender then return end






    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then
        TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Meqdar Eshtebah ast!'})
        return
    end
    if sender.bank < amount then
        TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Mojodi Shoma Kafi Nist!'})
        return
    end

    local Girande = ESX.GetPlayerFromId(iban)

    if Girande then
        if Girande.source == sender.source then
            TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Nemitavanid be khodetan enteqal dahid!'})
            return
        end

        local PhoneItem = Girande.getInventoryItem("phone").count and Girande.getInventoryItem("phone").count > 0



        sender.removeBank(amount)
        Girande.addBank(amount)

        if PhoneItem ~= nil then
            TriggerClientEvent('Unique_Phone:client:TransferMoney', Girande.source, amount, Girande.bank)

            TriggerClientEvent('rp_notify:client:SendAlert', sender.source, { type = 'inform', text = 'Para transferi başarılı!'})
            TriggerClientEvent('rp_notify:client:SendAlert',  Girande.source, { type = 'inform', text = 'Hesabına para transferi yapıldı: $' .. amount .. ', yatıran ID: ' .. sender.source .. ''})

        end
    else

        ExecuteSql(false, "SELECT * FROM `users` WHERE `iban`=@p1", {['@p1'] = iban}, function(result)
            if result[1] ~= nil then
                local recieverSteam = ESX.GetPlayerFromIdentifier(result[1].identifier)




                if sender.bank < amount then
                    TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Mojodi Shoma Kafi Nist!'})
                    return
                end

                if recieverSteam ~= nil then
                    if recieverSteam.source == sender.source then
                        TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Nemitavanid be khodetan enteqal dahid!'})
                        return
                    end

                    local PhoneItem = recieverSteam.getInventoryItem("phone").count and recieverSteam.getInventoryItem("phone").count > 0
                    sender.removeBank(amount)
                    recieverSteam.addBank(amount)

                    if PhoneItem ~= nil then
                        TriggerClientEvent('Unique_Phone:client:TransferMoney', recieverSteam.source, amount, recieverSteam.bank)

                        ExecuteSql(false, "SELECT * FROM `users` WHERE `identifier`=@p1", {['@p1'] = ESX.GetPlayerFromId(src).identifier}, function(result)
                            TriggerClientEvent('rp_notify:client:SendAlert', sender.source, { type = 'inform', text = 'Para transferi başarılı!'})
                            TriggerClientEvent('rp_notify:client:SendAlert',  recieverSteam.source, { type = 'inform', text = 'Hesabına para transferi yapıldı: $' .. amount .. ', yatıran IBAN: ' .. result[1].iban .. ''})
                        end)
                    end

                else




                    sender.removeBank(amount)
                    ExecuteSql(false, "UPDATE `users` SET `bank` = `bank` + @p1 WHERE `identifier` = @p2", {['@p1'] = amount, ['@p2'] = result[1].identifier})
                    exports.ScriptPack:TransferLog({source = sender.source, target = result[1].identifier, type = "transfer_offline", amount = amount})
                end
            else
                TriggerClientEvent('rp_notify:client:SendAlert', src, { type = 'inform', text = 'Bu IBAN mevcut değil!'})
            end
        end)
    end
end)

RegisterServerEvent('Unique_Phone:server:EditContact')
AddEventHandler('Unique_Phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    ExecuteSql(false, "UPDATE `player_contacts` SET `name` = @p1, `number` = @p2, `iban` = @p3 WHERE `identifier` = @p4 AND `name` = @p5 AND `number` = @p6", {['@p1'] = newName, ['@p2'] = newNumber, ['@p3'] = newIban, ['@p4'] = Player.identifier, ['@p5'] = oldName, ['@p6'] = oldNumber})
end)

RegisterServerEvent('Unique_Phone:server:RemoveContact')
AddEventHandler('Unique_Phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "DELETE FROM `player_contacts` WHERE `name` = @p1 AND `number` = @p2 AND `identifier` = @p3", {['@p1'] = Name, ['@p2'] = Number, ['@p3'] = Player.identifier})
end)

RegisterServerEvent('Unique_Phone:server:AddNewContact')
AddEventHandler('Unique_Phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "INSERT INTO `player_contacts` (`identifier`, `name`, `number`, `iban`) VALUES (@p1, @p2, @p3, @p4)", {['@p1'] = Player.identifier, ['@p2'] = tostring(name), ['@p3'] = tostring(number), ['@p4'] = tostring(iban)})
end)

RegisterServerEvent('Unique_Phone:server:UpdateMessages')
AddEventHandler('Unique_Phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderCharacter = GetCharacter(src)
    local SenderData = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "SELECT * FROM `users` WHERE `phone`=@p1", {['@p1'] = ChatNumber}, function(Player)



        if Player[1] ~= nil and (ChatNumber ~= "Police Deparment" and ChatNumber ~= "Ambulance Deparment" and ChatNumber ~= "Sheriff Deparment") then

            local TargetPhone = getPhoneNumber(Player[1].identifier)
            local TargetData = ESX.GetPlayerFromIdentifier(Player[1].identifier)
            local SenderPhone = getPhoneNumber(SenderData.identifier)


            if TargetData ~= nil then
                ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `identifier` = @p1 AND `number` = @p2", {['@p1'] = SenderData.identifier, ['@p2'] = ChatNumber}, function(Chat)
                    if Chat[1] ~= nil then

                        ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = Player[1].identifier, ['@p3'] = SenderPhone})


                        ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = SenderData.identifier, ['@p3'] = TargetPhone})


                        TriggerClientEvent('Unique_Phone:client:UpdateMessages', TargetData.source, ChatMessages, SenderPhone, false, false)
                    else

                        ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = Player[1].identifier, ['@p2'] = SenderPhone, ['@p3'] = json.encode(ChatMessages)})


                        ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = SenderData.identifier, ['@p2'] = TargetPhone, ['@p3'] = json.encode(ChatMessages)})


                        TriggerClientEvent('Unique_Phone:client:UpdateMessages', TargetData.source, ChatMessages, SenderPhone, true, false)
                    end
                end)
            else
                ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `identifier` = @p1 AND `number` = @p2", {['@p1'] = SenderData.identifier, ['@p2'] = ChatNumber}, function(Chat)
                    if Chat[1] ~= nil then

                        ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = Player[1].identifier, ['@p3'] = SenderPhone})


                        ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = SenderData.identifier, ['@p3'] = TargetPhone})
                    else

                        ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = Player[1].identifier, ['@p2'] = SenderPhone, ['@p3'] = json.encode(ChatMessages)})


                        ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = SenderData.identifier, ['@p2'] = TargetPhone, ['@p3'] = json.encode(ChatMessages)})
                    end
                end)
            end
        else

            local SenderPhone = getPhoneNumber(SenderData.identifier)
            ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `identifier` = @p1 AND `number` = @p2", {['@p1'] = SenderData.identifier, ['@p2'] = ChatNumber}, function(Chat)
                if Chat[1] ~= nil then

                    ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = ChatNumber, ['@p3'] = ChatNumber})


                    ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = SenderData.identifier, ['@p3'] = ChatNumber})
                else

                    ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = ChatNumber, ['@p2'] = ChatNumber, ['@p3'] = json.encode(ChatMessages)})


                    ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = SenderData.identifier, ['@p2'] = ChatNumber, ['@p3'] = json.encode(ChatMessages)})
                end
            end)

        end
    end)
end)

RegisterServerEvent('Unique_Phone:server:UpdateMessagesOdther')
AddEventHandler('Unique_Phone:server:UpdateMessagesOdther', function(SteamHex, ChatMessages, ChatNumber, New)
    ExecuteSql(false, "SELECT * FROM `phone_messages` WHERE `identifier` = @p1 AND `number` = @p2", {['@p1'] = SteamHex, ['@p2'] = ChatNumber}, function(Chat)
        if Chat[1] ~= nil then
            ExecuteSql(false, "UPDATE `phone_messages` SET `messages` = @p1 WHERE `identifier` = @p2 AND `number` = @p3", {['@p1'] = json.encode(ChatMessages), ['@p2'] = SteamHex, ['@p3'] = ChatNumber})
        else
            ExecuteSql(false, "INSERT INTO `phone_messages` (`identifier`, `number`, `messages`) VALUES (@p1, @p2, @p3)", {['@p1'] = SteamHex, ['@p2'] = ChatNumber, ['@p3'] = json.encode(ChatMessages)})
        end
    end)
end)

function getPhoneNumber(identifier)
	local result = MySQL.Sync.fetchAll("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
		['@identifier'] = identifier
	})
	if result[1] ~= nil then
		return result[1].phone
	end
	return nil
end

RegisterServerEvent('Unique_Phone:server:AddRecentCall')
AddEventHandler('Unique_Phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('Unique_Phone:client:AddRecentCall', src, data, label, type)

    local Trgt = GetPlayerFromPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('Unique_Phone:client:AddRecentCall', Trgt.source, {
            name = string.gsub(Ply.name, "_", " "),
            number = character.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterServerEvent('Unique_Phone:server:CancelCall')
AddEventHandler('Unique_Phone:server:CancelCall', function(ContactData)
    local Ply = GetPlayerFromPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('Unique_Phone:client:CancelCall', Ply.source)
    end
end)

RegisterServerEvent('Unique_Phone:server:AnswerCall')
AddEventHandler('Unique_Phone:server:AnswerCall', function(CallData)
    local Ply = GetPlayerFromPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('Unique_Phone:client:AnswerCall', Ply.source)
    end
end)

local SaveMetaData_AllowedColumns = {
    ['background']      = true,
    ['profilepicture']  = true,
}

RegisterServerEvent('Unique_Phone:server:SaveMetaData')
AddEventHandler('Unique_Phone:server:SaveMetaData', function(column, data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if not Player then return end
    if not (data and column) then return end
    if type(column) ~= 'string' or not SaveMetaData_AllowedColumns[column] then
        print(("[Unique_Phone] SECURITY: player %s tried SaveMetaData with disallowed column '%s'"):format(src, tostring(column)))
        return
    end

    local value = data
    if type(data) == 'table' then
        value = json.encode(data)
    end




    ExecuteSql(false, "UPDATE `users` SET `" .. column .. "` = @p1 WHERE `identifier` = @p2", {['@p1'] = value, ['@p2'] = Player.identifier})
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements )
end

ESX.RegisterServerCallback('Unique_Phone:server:FetchResult', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    local character = GetCharacter(src)
    ExecuteSql(false, "SELECT * FROM `users` WHERE firstname LIKE @p1", {['@p1'] = '%' .. search .. '%'}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local driverlicense = false
                local weaponlicense = false
                local doingSomething = true

                if Config.UseESXLicense then
                    CheckLicense(v.identifier, 'weapon', function(has)
                        if has then
                            weaponlicense = true
                        end

                        CheckLicense(v.identifier, 'drive', function(has)
                            if has then
                                driverlicense = true
                            end

                            doingSomething = false
                        end)
                    end)
                else
                    doingSomething = false
                end

                while doingSomething do Wait(1) end

                table.insert(searchData, {
                    identifier = v.identifier,
                    firstname = character.firstname,
                    lastname = character.lastname,
                    birthdate = character.dateofbirth,
                    phone = character.phone,
                    gender = character.sex,
                    weaponlicense = weaponlicense,
                    driverlicense = driverlicense,
                })
            end
            cb(searchData)
        else
            cb(nil)
        end
    end)
end)

function CheckLicense(target, type, cb)
	local target = target

	if target then
		MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
			['@type'] = type,
			['@owner'] = target
		}, function(result)
			if tonumber(result[1].count) > 0 then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end

ESX.RegisterServerCallback('Unique_Phone:server:GetVehicleSearchResults', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local character = GetCharacter(src)

    ExecuteSql(false, "SELECT * FROM `owned_vehicles` WHERE `plate` LIKE @p1 OR `owner` = @p2", {['@p1'] = '%' .. search .. '%', ['@p2'] = search}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                ExecuteSql(true, "SELECT * FROM `users` WHERE `identifier` = @p1", {['@p1'] = result[k].identifier}, function(player)
                    if player[1] ~= nil then
                        local vehicleInfo = { ['name'] = json.decode(result[k].vehicle).model }
                        if vehicleInfo ~= nil then
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = character.firstname .. " " .. character.lastname,
                                identifier = result[k].identifier,
                                label = vehicleInfo["name"]
                            })
                        else
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = character.firstname .. " " .. character.lastname,
                                identifier = result[k].identifier,
                                label = "Name not found"
                            })
                        end
                    end
                end)
            end
        elseif GeneratedPlates[search] ~= nil then
            table.insert(searchData, {
                plate = GeneratedPlates[search].plate,
                status = GeneratedPlates[search].status,
                owner = GeneratedPlates[search].owner,
                identifier = GeneratedPlates[search].identifier,
                label = "Brand unknown.."
            })
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[search] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                identifier = ownerInfo.identifier,
            }
            table.insert(searchData, {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                identifier = ownerInfo.identifier,
                label = "Brand unknown .."
            })
        end
        cb(searchData)
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    local character = GetCharacter(src)
    if plate ~= nil then
        ExecuteSql(false, "SELECT * FROM `owned_vehicles` WHERE `plate` = @p1", {['@p1'] = plate}, function(result)
            if result[1] ~= nil then
                ExecuteSql(true, "SELECT * FROM `users` WHERE `identifier` = @p1", {['@p1'] = result[1].identifier}, function(player)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = character.firstname .. " " .. character.lastname,
                        identifier = result[1].identifier,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    identifier = ownerInfo.identifier,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    identifier = ownerInfo.identifier,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('notification', src, Lang('NO_VEHICLE'), 2)
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", identifier = "DSH091G93" },
        [2] = { name = "Jay Dendam", identifier = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", identifier = "DVH091T93" },
        [4] = { name = "Karel Bakker", identifier = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", identifier = "DRH09Z193" },
        [6] = { name = "Nico Wolters", identifier = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", identifier = "ODF09S193" },
        [8] = { name = "Bert Johannes", identifier = "KSD0919H3" },
        [9] = { name = "Karel de Grote", identifier = "NDX091D93" },
        [10] = { name = "Jan Pieter", identifier = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", identifier = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", identifier = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", identifier = "TEW0J9193" },
        [14] = { name = "Bart Rielink", identifier = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", identifier = "QBC091H93" },
        [16] = { name = "Aad Keizer", identifier = "YDN091H93" },
        [17] = { name = "Thijn Kiel", identifier = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", identifier = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", identifier = "QWE091A93" },
        [20] = { name = "Dries Stielstra", identifier = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", identifier = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", identifier = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", identifier = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", identifier = "IOP091O93" },
        [25] = { name = "Renske de Raaf", identifier = "PIO091R93" },
        [26] = { name = "Krisje Moltman", identifier = "LEK091X93" },
        [27] = { name = "Mirre Steevens", identifier = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", identifier = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", identifier = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", identifier = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

ESX.RegisterServerCallback('Unique_Phone:server:GetGarageVehicles', function(source, cb)
    local Player = ESX.GetPlayerFromId(source)
    local Vehicles = {}
    local garagenume = 0
    local Fuel = 50
    local Engin = 500
    local Body = 500

    ExecuteSql(false, "SELECT * FROM `owned_vehicles` WHERE `owner` = @p1", {['@p1'] = Player.identifier}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if v.garagenum == 0 then
                    VehicleState = "Not Found"
                    garagenume = 'Not Found'
                elseif tonumber(v.stored) == 0 then
                    VehicleState = "OUT"
                    garagenume = 'Impound'
                else
                    VehicleState = "Garage"
                    garagenume = v.garagenum
                end

                local vehdata = {}






                if VehicleState == "Garage" and v.damage ~= nil and v.damage ~= "" then
                    local ok, damageData = pcall(json.decode, v.damage)
                    if ok and type(damageData) == "table" then
                        for key, value in pairs(damageData) do
                            if key == 'fuel_health' then
                                Fuel = value
                            elseif key == 'body_health' then
                                Body = value
                            elseif key == 'engine_health' then
                                Engin = value
                            end
                        end
                    end
                end
                vehdata = {
                    model = json.decode(result[k].vehicle).model,
                    plate = v.plate,

                    garage = garagenume,
                    state = VehicleState,
                    fuel = Fuel,
                    engine = Engin or 1000,
                    body = Body or 1000,
                }

                table.insert(Vehicles, vehdata)
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetCharacterData', function(source, cb,id)
    local src = source or id
    local xPlayer = ESX.GetPlayerFromId(source)

    cb(GetCharacter(src))
end)

ESX.RegisterServerCallback('Unique_Phone:server:HasPhone', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        local HasPhone = xPlayer.getInventoryItem("phone").count

        if HasPhone >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('Unique_Phone:server:GiveContactDetails')
AddEventHandler('Unique_Phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local character = GetCharacter(src)

    local SuggestionData = {
        name = {
            [1] = character.firstname,
            [2] = character.lastname
        },
        number = character.phone,
        bank = Player.bank,
    }

    TriggerClientEvent('Unique_Phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterServerEvent('Unique_Phone:server:AddTransaction')
AddEventHandler('Unique_Phone:server:AddTransaction', function(data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    ExecuteSql(false, "INSERT INTO `crypto_transactions` (`identifier`, `title`, `message`) VALUES (@p1, @p2, @p3)", {['@p1'] = Player.identifier, ['@p2'] = escape_sqli(data.TransactionTitle), ['@p3'] = escape_sqli(data.TransactionMessage)})
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetCurrentpolices', function(source, cb)
    local polices = {}
    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayerFromId(v)
        local character = GetCharacter(v)

        if Player ~= nil then
            if (Player.job.name == "ambulance" or Player.job.name == "taxi" or Player.job.name == "mechanic" or Player.job.name == "weazel" or Player.job.name == "police" or Player.job.name == "sheriff" or Player.job.name == "mt" or Player.job.name == "fbi" or Player.job.name == "cid" or Player.job.name == "cia" or Player.job.name == "marshal" or Player.job.name == "judge" or Player.job.name == "doa" or Player.job.name == "uwucafe") then
                table.insert(polices, {
                    name = Player.name,
                    phone = character.phone or 0,
                    typejob = Player.job.name
                })
            end
        end
    end
    cb(polices)
end)

function GetCharacter(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

    result[1].firstname = xPlayer.firstname
    result[1].lastname = xPlayer.lastname
    return result[1]
end

function GetPlayerFromPhone(phone)
    local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE phone = @phone', {
        ['@phone'] = tostring(phone)
    })

    if result[1] and result[1].identifier then

        return ESX.GetPlayerFromIdentifier(tostring(result[1].identifier))
    end

    return nil
end

function getPlayerFromIBAN(iban)
    local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE iban = @iban', {
		['@iban'] = iban
    })

    if result[1] and result[1].identifier then
        return ESX.GetPlayerFromIdentifier(result[1].identifier)
    end

    return nil
end

function ExecuteSql(wait, query, params, cb)
	local rtndata = {}
	local waiting = true
	MySQL.Async.fetchAll(query, params or {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
    end

	return rtndata
end

function Lang(item)
    local lang = Config.Languages[Config.Language]

    if lang and lang[item] then
        return lang[item]
    end

    return item
end

RegisterServerEvent('Unique_Phone:server:SendJobMessage')
AddEventHandler('Unique_Phone:server:SendJobMessage', function(data, Pos)
    local src = source
    local players = GetPlayers()
    local sender = string.gsub(ESX.GetPlayerFromId(src).name, "_", " ")
    local xPlayer = ESX.GetPlayerFromId(src)

    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local date = os.date('%Y-%m-%d')

        if xPlayer and xPlayer.job.name == string.lower(string.gsub(data.ChatNumber, " Deparment", "")) then

            TriggerClientEvent('PX_phone_Clieant:AddMessagetoJobS', playerId, data, sender, Pos, xPlayer.source)
        end
    end
end)

RegisterServerEvent('Unique_Phone:server:addImageToGallery')
AddEventHandler('Unique_Phone:server:addImageToGallery', function(imageUrl)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    MySQL.Async.execute('INSERT INTO phone_gallery (identifier, image_url) VALUES (@identifier, @image_url)', {
        ['@identifier'] = xPlayer.identifier,
        ['@image_url'] = imageUrl
    }, function(rowsChanged)
        if rowsChanged > 0 then

        end
    end)
end)

RegisterServerEvent('Unique_Phone:server:RemoveImageFromGallery')
AddEventHandler('Unique_Phone:server:RemoveImageFromGallery', function(imageData)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if not player then return end


    if not imageData or not imageData.image then

        return
    end


    MySQL.Async.execute('DELETE FROM phone_gallery WHERE identifier = @identifier AND image_url = @image_url', {
        ['@identifier'] = player.identifier,
        ['@image_url'] = imageData.image
    }, function(rowsChanged)
        if rowsChanged > 0 then

            TriggerClientEvent('Unique_Phone:client:ImageRemoved', src)
        else

        end
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:getImageFromGallery', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT image_url FROM phone_gallery WHERE identifier = @identifier ORDER BY id DESC', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local images = {}
        for i=1, #result do
            table.insert(images, result[i].image_url)
        end
        cb(images)
    end)
end)

RegisterServerEvent('Unique_Phone:server:getImageFromGallery')
AddEventHandler('Unique_Phone:server:getImageFromGallery', function()
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if not player then return end


    MySQL.Async.fetchAll('SELECT * FROM phone_gallery WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(result)
        local images = {}

        for _, row in ipairs(result) do
            table.insert(images, {
                url = row.image_url,
                date = row.date
            })
        end

        TriggerClientEvent('Unique_Phone:client:refreshImages', src, images)
    end)
end)

ESX.RegisterServerCallback('Unique_Phone:server:GetGalleryImages', function(source, cb)
    local src = source
    local player = ESX.GetPlayerFromId(src)

    if not player then return cb({}) end

    MySQL.Async.fetchAll('SELECT * FROM phone_gallery WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(result)
        local images = {}

        for _, row in ipairs(result) do
            table.insert(images, {
                url = row.image_url,
                date = row.date,
                id = row.id
            })
        end

        cb(images)
    end)
end)

ESX.RegisterServerCallback("PX_phone_Clieant:GetDataMSG", function(source, cb)
    cb(GetCurrentDateKey())
end)

function GetCurrentDateKey()
    local CurrentDate = os.date('*t')

    local NewHour = CurrentDate.hour
    local NewMinute = CurrentDate.min

    local CurrentMonth = CurrentDate.month
    local CurrentDOM = CurrentDate.day
    local CurrentYear = CurrentDate.year

    local CurDate = string.format("%d-%d-%d", CurrentDOM, CurrentMonth-1, CurrentYear)

    local Minutessss = (NewMinute < 10) and ("0"..NewMinute) or NewMinute
    local Hourssssss = (NewHour < 10) and ("0"..NewHour) or NewHour

    local MessageTime = Hourssssss .. ":" .. Minutessss

    return {date = CurDate, time = MessageTime}
end

RegisterNetEvent('Unique_Phone:Delete_Message')
AddEventHandler('Unique_Phone:Delete_Message', function(PhoneNumber)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('DELETE FROM phone_messages WHERE identifier = ? AND number = ?', {
        xPlayer.identifier,
        PhoneNumber
    })
end)