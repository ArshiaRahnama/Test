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

-- EXPANSION: Airplane Mode — authoritative, server-side state (keyed by
-- identifier, same pattern as Calls above). This is what makes airplane
-- mode a REAL disconnect instead of just a client-side popup filter: a
-- caller trying to reach a player with this on gets treated exactly like
-- reaching an offline player (see GetCallState / GetCallStateAdmin below),
-- so they get an instant "person unavailable" instead of a call that rings
-- out for the full timeout. Set from the client whenever the toggle
-- changes (see 'Unique_Phone:server:SetFlyModeState') and also once at
-- phone-load time, so a relog while airplane mode was left on is honored
-- immediately rather than only after the next manual toggle.
local PhoneFlyMode = {}

RegisterServerEvent('Unique_Phone:server:SetFlyModeState')
AddEventHandler('Unique_Phone:server:SetFlyModeState', function(enabled)
    local src = source
    local Ply = ESX.GetPlayerFromId(src)
    if Ply == nil then return end

    PhoneFlyMode[Ply.identifier] = enabled and true or nil
end)
local Adverts = {}
local GeneratedPlates = {}

-- FIX: was a generic "052-XXXXXXXX"-style number with no real-world
-- resemblance. Now picks a real Iranian mobile prefix (Config.PhoneNumberPrefixes)
-- and appends 7 random digits — same total length (11 chars) as before, so
-- nothing that stores/matches this number elsewhere needed to change.
function getPhoneRandomNumber()
    local prefix = Config.PhoneNumberPrefixes[math.random(1, #Config.PhoneNumberPrefixes)]
    local rest = ""
    for i = 1, 7 do
        rest = rest .. tostring(math.random(0, 9))
    end
    return prefix .. rest
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

    -- EXPANSION: a target with airplane mode on is treated exactly like a
    -- target that isn't online at all — cb(false, false) — so the caller
    -- gets the existing "person unavailable" message instantly instead of
    -- the phone ringing out with no answer. This is also what stops
    -- CallContact() (the Lua function that actually rings the target) from
    -- ever running for them: it's only invoked when CanCall is true.
    if Target ~= nil and not PhoneFlyMode[Target.identifier] then
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

    -- EXPANSION: same airplane-mode short-circuit as GetCallState above.
    if Target ~= nil and not PhoneFlyMode[Target.identifier] then
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

    -- EXPANSION: defense-in-depth — GetCallState already stops a caller
    -- from reaching this point for a fly-mode target, but this event is
    -- also reachable directly, so re-check here rather than trusting the
    -- client not to have raced the toggle.
    if Target ~= nil and not PhoneFlyMode[Target.identifier] then
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

        if PhoneItem then
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

                    if PhoneItem then
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

ESX.RegisterUsableItem('phone', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil and xPlayer.getInventoryItem("phone").count > 0 then
        TriggerClientEvent('Unique_Phone:client:UseItem', source)
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

-- FIX: this used to hardcode a fixed list of job names directly in Lua
-- (ambulance/taxi/mechanic/weazel/police/sheriff/mt/fbi/cid/cia/marshal/
-- judge/doa/uwucafe) — any job added to the server later (like the newer
-- custom jobs) silently never showed up here, because the list was never
-- updated to match. `jobs.hasapp` already existed in the database schema
-- for exactly this purpose (mark a job as "should appear in the phone's
-- Services directory") but was never wired up (every job had it at 0).
-- Now this reads that column live, so adding a job to this directory going
-- forward is just:
--     UPDATE jobs SET hasapp = 1 WHERE name = 'yourjobname';
-- — no more code edits needed here ever again.
ESX.RegisterServerCallback('Unique_Phone:server:GetCurrentpolices', function(source, cb)
    MySQL.Async.fetchAll("SELECT name FROM jobs WHERE hasapp = 1", {}, function(jobRows)
        local allowedJobs = {}
        for _, row in ipairs(jobRows or {}) do
            allowedJobs[row.name] = true
        end

        local polices = {}
        for k, v in pairs(ESX.GetPlayers()) do
            local Player = ESX.GetPlayerFromId(v)
            local character = GetCharacter(v)

            if Player ~= nil and allowedJobs[Player.job.name] then
                table.insert(polices, {
                    name = Player.name,
                    phone = character.phone or 0,
                    typejob = Player.job.name,
                    -- EXPANSION: real, human-readable job name (e.g. "Judge"
                    -- instead of "judge") for any job the client-side UI
                    -- doesn't have a hardcoded label for — see polices.js.
                    jobLabel = Player.job.label,
                })
            end
        end
        cb(polices)
    end)
end)

-- ─────────────────────────────────────────────────────────
-- EXPANSION: Job Manager — admin-only, single upsert form (see
-- html/js/job-manager.js + the "⚙️" gear in the Services app header).
-- Deliberately simple: one form either creates a job or updates it
-- (matched by internal name) — no big editable list to keep this small.
-- ─────────────────────────────────────────────────────────

local function isPhoneJobManagerAdmin(src, cb)
    local ok, result = pcall(function()
        return exports['Unique_AdminPanel']:isAdmin(src)
    end)
    cb(ok and result == true)
end

ESX.RegisterServerCallback('Unique_Phone:server:IsJobManagerAdmin', function(source, cb)
    isPhoneJobManagerAdmin(source, cb)
end)

RegisterServerEvent('Unique_Phone:server:SaveJob')
AddEventHandler('Unique_Phone:server:SaveJob', function(data)
    local src = source
    isPhoneJobManagerAdmin(src, function(isAdmin)
        if not isAdmin then return end
        if type(data) ~= "table" then return end

        local name = data.name and tostring(data.name):lower():gsub("%s+", "") or nil
        local label = data.label and tostring(data.label):sub(1, 50) or nil
        local hasapp = data.hasapp and 1 or 0

        -- Keep job names safe: ESX uses job.name as an identifier all over
        -- (permissions, spawn points, vehicle shops, etc.), so only allow
        -- the same charset FiveM/ESX itself expects there.
        if not name or name == "" or not name:match("^[a-z0-9_]+$") then return end
        if not label or label == "" then return end

        -- INSERT ... ON DUPLICATE KEY UPDATE: creates the job if `name` is
        -- new, or just updates label/hasapp if it already exists — one
        -- query handles both "add" and "edit".
        MySQL.Async.execute(
            "INSERT INTO jobs (name, label, whitelisted, washmoney, handyservice, hasapp, onlyboss, icon_url) "
                .. "VALUES (@name, @label, 0, 0, '0', @hasapp, 0, NULL) "
                .. "ON DUPLICATE KEY UPDATE label = VALUES(label), hasapp = VALUES(hasapp)",
            { ["@name"] = name, ["@label"] = label, ["@hasapp"] = hasapp }
        )

        -- A job with zero grades breaks essentialmode's job assignment/HUD
        -- for it — make sure a brand-new job always has at least a default
        -- grade 0. INSERT IGNORE so re-saving an EXISTING job never
        -- touches/duplicates its real grades.
        MySQL.Async.execute(
            "INSERT IGNORE INTO job_grades (job_name, grade, name, label, salary) VALUES (@job_name, 0, 'employee', 'Employee', 50)",
            { ["@job_name"] = name }
        )
    end)
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

-- ==========================================================================
-- EXPANSION: Discord app — real servers/channels, messages persisted in the
-- DB (phone_discord_* tables, see sql/discord.sql) and pushed live to every
-- other online member of the server. Mirrors the existing style in this
-- file: ExecuteSql(wait, query, params, cb) for reads, MySQL.Async.execute
-- for fire-and-forget writes, ESX.GetPlayerFromIdentifier to find an online
-- member's client to push to.
-- ==========================================================================

local DiscordIconPalette = {"#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4"}

-- ---- identity / permission helpers -------------------------------------

-- xPlayer.firstname/lastname are not reliable on this server (lastname came
-- back nil and crashed server creation), so build the display name from every
-- source we have, in order of trust, and never return nil.
function Discord_GetDisplayName(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer == nil then return "Player" end

    local first, last = xPlayer.firstname, xPlayer.lastname
    if type(first) == "string" and type(last) == "string" and first ~= "" and last ~= "" then
        return first .. " " .. last
    end

    local raw = xPlayer.name
    if (type(raw) ~= "string" or raw == "") and type(xPlayer.getName) == "function" then
        local ok, res = pcall(xPlayer.getName, xPlayer)
        if ok then raw = res end
    end
    if type(raw) == "string" and raw ~= "" and raw ~= GetPlayerName(src) then
        return (raw:gsub("_", " "))
    end

    local rows = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    if rows[1] and rows[1].firstname and rows[1].firstname ~= "" then
        return rows[1].firstname .. ((rows[1].lastname and rows[1].lastname ~= "") and (" " .. rows[1].lastname) or "")
    end

    if type(first) == "string" and first ~= "" then return first end
    return GetPlayerName(src) or "Player"
end

-- Game staff. Same source of truth the Job Manager uses (Unique_AdminPanel's
-- exported isAdmin), with the perm-level check other scripts here use as a
-- fallback so it still works if that resource is stopped.
function Discord_IsStaff(src)
    local ok, res = pcall(function() return exports['Unique_AdminPanel']:isAdmin(src) end)
    if ok and res == true then return true end

    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer == nil then return false end
    if (tonumber(xPlayer.perm) or tonumber(xPlayer.permission_level) or 0) >= 1 then return true end
    if type(xPlayer.getGroup) == "function" then
        local ok2, group = pcall(xPlayer.getGroup, xPlayer)
        if ok2 and (group == "admin" or group == "superadmin" or group == "mod") then return true end
    end
    return false
end

-- Discord-wide bans, kept in memory (single source of truth is the table;
-- this just avoids a query on every single Discord call).
local DiscordBans = {}

function Discord_GetBan(identifier)
    local ban = DiscordBans[identifier]
    if ban == nil then return nil end
    if ban.expires_at ~= nil and ban.expires_at <= os.time() then
        DiscordBans[identifier] = nil
        MySQL.Async.execute("DELETE FROM phone_discord_bans WHERE identifier = @id", { ['@id'] = identifier })
        return nil
    end
    return ban
end

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    local rows = MySQL.Sync.fetchAll("SELECT * FROM phone_discord_bans", {})
    for _, r in pairs(rows or {}) do DiscordBans[r.identifier] = r end

    -- A failed server creation (before the name fix above) could leave a
    -- server row with no members. Clean those up; FKs cascade the rest.
    MySQL.Async.execute("DELETE FROM phone_discord_servers WHERE id NOT IN (SELECT DISTINCT server_id FROM phone_discord_members)", {})
end)

-- Every Discord endpoint gets its player through this, so a banned account
-- is treated exactly like "no player" and every handler already returns
-- its normal empty/false result.
function Discord_GetPlayer(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer == nil then return nil end
    if Discord_GetBan(xPlayer.identifier) ~= nil then return nil end
    return xPlayer
end

function Discord_GenerateInviteCode()
    local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    local code = ""
    for i = 1, 7 do
        local idx = math.random(1, #chars)
        code = code .. string.sub(chars, idx, idx)
    end
    return code
end

-- string.sub cuts by BYTE, not character. Server/channel names here are
-- very often Persian (this whole server is), and every Persian character
-- is 2+ bytes in UTF-8 — a byte-based sub can slice a character in half
-- and corrupt it (and everything after it) into mojibake. This cuts on
-- codepoint boundaries instead, using Lua 5.4's built-in utf8 library.
function Discord_Utf8SafeSub(str, maxChars)
    if str == nil or maxChars == nil then return str end

    local ok, len = pcall(utf8.len, str)
    if not ok or len == nil then
        return string.sub(str, 1, maxChars) -- not valid UTF-8 at all — fall back
    end
    if len <= maxChars then return str end

    local byteIndex = utf8.offset(str, maxChars + 1)
    if byteIndex == nil then return str end
    return string.sub(str, 1, byteIndex - 1)
end

function Discord_IconText(name)
    local words = {}
    for word in string.gmatch(name, "%S+") do
        table.insert(words, word)
    end

    if #words >= 2 then
        return string.upper(Discord_Utf8SafeSub(words[1], 1) .. Discord_Utf8SafeSub(words[2], 1))
    elseif #words == 1 then
        return string.upper(Discord_Utf8SafeSub(words[1], 2))
    end

    return "D"
end

function Discord_IsMember(identifier, serverId)
    local result = ExecuteSql(true, "SELECT id FROM phone_discord_members WHERE server_id = @sid AND identifier = @id", {
        ['@sid'] = serverId,
        ['@id'] = identifier,
    })
    return result[1] ~= nil
end

function Discord_IsOwner(identifier, serverId)
    local result = ExecuteSql(true, "SELECT id FROM phone_discord_servers WHERE id = @sid AND owner_identifier = @id", {
        ['@sid'] = serverId,
        ['@id'] = identifier,
    })
    return result[1] ~= nil
end

function Discord_IsAdmin(identifier, serverId)
    local result = ExecuteSql(true, "SELECT id FROM phone_discord_members WHERE server_id = @sid AND identifier = @id AND is_admin = 1", {
        ['@sid'] = serverId,
        ['@id'] = identifier,
    })
    return result[1] ~= nil
end

-- Channel management (create/delete/pin) is owner-or-admin; server-level
-- actions (delete server, kick, promote admins, settings) stay owner-only.
function Discord_CanManageChannels(identifier, serverId)
    return Discord_IsOwner(identifier, serverId) or Discord_IsAdmin(identifier, serverId)
end

function Discord_GetServerIdForChannel(channelId)
    local result = ExecuteSql(true, "SELECT server_id FROM phone_discord_channels WHERE id = @cid", {['@cid'] = channelId})
    if result[1] then return result[1].server_id end
    return nil
end

-- Pushes a payload to every online member of a server (optionally skipping
-- one source, e.g. the sender, who already updated their own UI locally).
function Discord_BroadcastToServerMembers(serverId, eventName, payload, skipSource)
    local members = ExecuteSql(true, "SELECT identifier FROM phone_discord_members WHERE server_id = @sid", {['@sid'] = serverId})
    for _, member in pairs(members) do
        local Ply = ESX.GetPlayerFromIdentifier(member.identifier)
        if Ply ~= nil and Ply.source ~= skipSource then
            TriggerClientEvent(eventName, Ply.source, payload)
        end
    end
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetServers', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end

    local servers = ExecuteSql(true, [[
        SELECT s.id, s.name, s.icon_text, s.icon_color, s.invite_code, s.owner_identifier, s.is_public, s.is_verified, m.is_admin
        FROM phone_discord_servers s
        INNER JOIN phone_discord_members m ON m.server_id = s.id
        WHERE m.identifier = @id
        ORDER BY s.id ASC
    ]], {['@id'] = xPlayer.identifier})

    for _, server in pairs(servers) do
        server.isOwner = (server.owner_identifier == xPlayer.identifier)
        server.isAdmin = (server.is_admin == 1 or server.is_admin == true)
        server.isPublic = (server.is_public == 1 or server.is_public == true)
        server.isVerified = (server.is_verified == 1 or server.is_verified == true)
        server.is_verified = nil
        server.owner_identifier = nil
        server.is_admin = nil
        server.is_public = nil
    end

    cb(servers)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetChannels', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local channels = ExecuteSql(true, "SELECT id, name, position, is_verified, is_locked, kind FROM phone_discord_channels WHERE server_id = @sid ORDER BY position ASC, id ASC", {
        ['@sid'] = serverId,
    })

    for _, ch in pairs(channels) do
        ch.isVerified = (ch.is_verified == 1 or ch.is_verified == true)
        ch.isLocked = (ch.is_locked == 1 or ch.is_locked == true)
        ch.is_verified, ch.is_locked = nil, nil
    end

    cb(Discord_ExtFilterChannels(xPlayer, source, serverId, channels)) -- v8: view / send permissions
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetMessages', function(source, cb, channelId)
    local xPlayer = Discord_GetPlayer(source)
    local serverId = channelId ~= nil and Discord_GetServerIdForChannel(channelId) or nil

    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId)
        or not Discord_ExtCan(xPlayer.identifier, serverId, 'view', channelId, source) then
        cb(false)
        return
    end

    local messages = ExecuteSql(true, "SELECT id, identifier, author_name, message, created_at, edited_at, is_pinned, is_announcement, reply_to_id, role_mentions FROM phone_discord_messages WHERE channel_id = @cid ORDER BY id ASC LIMIT 200", {
        ['@cid'] = channelId,
    })

    -- One query for every reaction on this page of messages, then group by
    -- message id in Lua — cheaper than N+1 queries per message.
    local reactionsByMessage = {}
    local replyPreviewById = {}
    if #messages > 0 then
        local idParts = {}
        local replyIdParts = {}
        for _, msg in pairs(messages) do
            table.insert(idParts, tostring(msg.id))
            if msg.reply_to_id ~= nil then table.insert(replyIdParts, tostring(msg.reply_to_id)) end
        end

        local reactions = ExecuteSql(true, "SELECT message_id, identifier, emoji FROM phone_discord_reactions WHERE message_id IN (" .. table.concat(idParts, ",") .. ")", {})

        for _, r in pairs(reactions) do
            reactionsByMessage[r.message_id] = reactionsByMessage[r.message_id] or {}
            local byEmoji = reactionsByMessage[r.message_id]
            byEmoji[r.emoji] = byEmoji[r.emoji] or { emoji = r.emoji, count = 0, reacted = false }
            byEmoji[r.emoji].count = byEmoji[r.emoji].count + 1
            if r.identifier == xPlayer.identifier then byEmoji[r.emoji].reacted = true end
        end

        if #replyIdParts > 0 then
            local replied = ExecuteSql(true, "SELECT id, author_name, message FROM phone_discord_messages WHERE id IN (" .. table.concat(replyIdParts, ",") .. ")", {})
            for _, r in pairs(replied) do
                replyPreviewById[r.id] = { author_name = r.author_name, message = Discord_Utf8SafeSub(r.message, 80) }
            end
        end
    end

    local memberRowByIdentifier, verifiedByIdentifier, nickByIdentifier = {}, {}, {}
    for _, m in pairs(ExecuteSql(true, "SELECT m.id, m.identifier, m.nickname, p.verified FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = @sid", { ['@sid'] = serverId })) do
        memberRowByIdentifier[m.identifier] = m.id
        verifiedByIdentifier[m.identifier] = (m.verified == 1 or m.verified == true)
        nickByIdentifier[m.identifier] = m.nickname
    end

    for _, msg in pairs(messages) do
        msg.isMine = (msg.identifier == xPlayer.identifier)
        if nickByIdentifier[msg.identifier] and nickByIdentifier[msg.identifier] ~= "" then msg.author_name = nickByIdentifier[msg.identifier] end -- v8: current per-server nickname
        msg.roleMentions = Discord_ExtParseRoleIds(msg.role_mentions)
        msg.role_mentions = nil
        msg.authorVerified = verifiedByIdentifier[msg.identifier] or false
        msg.isAnnouncement = (msg.is_announcement == 1 or msg.is_announcement == true)
        msg.is_announcement = nil
        msg.authorMemberId = memberRowByIdentifier[msg.identifier] -- lets the UI open the author's profile without exposing identifiers
        msg.identifier = nil -- don't leak other players' identifiers to the client

        local list = {}
        if reactionsByMessage[msg.id] then
            for _, r in pairs(reactionsByMessage[msg.id]) do table.insert(list, r) end
        end
        msg.reactions = list

        if msg.reply_to_id ~= nil then
            msg.replyPreview = replyPreviewById[msg.reply_to_id] or nil
        end
    end

    cb(messages)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetMembers', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local server = ExecuteSql(true, "SELECT owner_identifier FROM phone_discord_servers WHERE id = @sid", {['@sid'] = serverId})
    local ownerIdentifier = server[1] and server[1].owner_identifier or nil

    local members = ExecuteSql(true, [[
        SELECT m.id, m.identifier, m.nickname, m.is_admin, p.status, p.custom_status, p.verified
        FROM phone_discord_members m
        LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier
        WHERE m.server_id = @sid
        ORDER BY m.nickname ASC
    ]], {
        ['@sid'] = serverId,
    })

    for _, member in pairs(members) do
        member.isOwner = (member.identifier == ownerIdentifier)
        member.isAdmin = (member.is_admin == 1 or member.is_admin == true)
        member.is_admin = nil
        member.isVerified = (member.verified == 1 or member.verified == true)
        member.verified = nil

        -- "invisible" shows as offline to everyone else, like real Discord.
        local status = member.status or "online"
        local isConnected = ESX.GetPlayerFromIdentifier(member.identifier) ~= nil
        member.isOnline = isConnected and status ~= "invisible"
        member.status = member.isOnline and status or "offline"
        member.customStatus = member.isOnline and member.custom_status or nil
        member.custom_status = nil
        member.activity = member.isOnline and Discord_GetActivity(member.identifier) or nil -- v7 rich presence
        member.identifier = nil
    end

    cb(members)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:SendMessage', function(source, cb, channelId, message, replyToId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or type(message) ~= "string" then cb(false) return end

    message = Discord_Utf8SafeSub(message, 1000)
    if string.gsub(message, "%s+", "") == "" then cb(false) return end

    local serverId = Discord_GetServerIdForChannel(channelId)
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end

    -- Locked channels are read-only for regular members (announcement
    -- channels etc.) — owner, server admins and game staff can still post.
    local lockRow = ExecuteSql(true, "SELECT is_locked FROM phone_discord_channels WHERE id = @cid", { ['@cid'] = channelId })
    if lockRow[1] and (lockRow[1].is_locked == 1 or lockRow[1].is_locked == true)
        and not Discord_CanManageChannels(xPlayer.identifier, serverId) and not Discord_IsStaff(source) then
        cb({ error = "LOCKED" })
        return
    end

    -- v7: timeout (mute) + auto-mod. Returns nil or { error = "TIMEOUT"|"AUTOMOD", ... }
    local blocked = Discord_ExtPreSend(xPlayer, source, serverId, message, channelId)
    if blocked then cb(blocked) return end

    if type(replyToId) ~= "number" then replyToId = nil end

    local authorName = Discord_ExtAuthorName(xPlayer, source, serverId) -- v8: per-server nickname
    local createdAt = os.time()

    local newMessageId = MySQL.Sync.insert("INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at, reply_to_id) VALUES (@cid, @id, @name, @msg, @time, @reply)", {
        ['@cid'] = channelId,
        ['@id'] = xPlayer.identifier,
        ['@name'] = authorName,
        ['@msg'] = message,
        ['@time'] = createdAt,
        ['@reply'] = replyToId,
    })

    local replyPreview = nil
    if replyToId ~= nil then
        local replied = ExecuteSql(true, "SELECT author_name, message FROM phone_discord_messages WHERE id = @rid", { ['@rid'] = replyToId })
        if replied[1] then
            replyPreview = { author_name = replied[1].author_name, message = Discord_Utf8SafeSub(replied[1].message, 80) }
        end
    end

    local roleMentions = Discord_ExtPostSend(xPlayer, source, serverId, channelId, newMessageId, message)

    local payload = {
        id = newMessageId,
        serverId = serverId,
        channelId = channelId,
        author_name = authorName,
        message = message,
        created_at = createdAt,
        replyPreview = replyPreview,
        roleMentions = roleMentions,
        authorVerified = (Discord_EnsureProfile(xPlayer.identifier).verified == 1 or Discord_EnsureProfile(xPlayer.identifier).verified == true),
        authorMemberId = (ExecuteSql(true, "SELECT id FROM phone_discord_members WHERE server_id = @sid AND identifier = @id", { ['@sid'] = serverId, ['@id'] = xPlayer.identifier })[1] or {}).id,
    }

    -- Sender's own client already appended the message optimistically — it
    -- just needs the id back (see below) to attach reactions/edit/delete to
    -- it. Every other online member gets the full live payload.
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:NewMessage', payload, source)

    cb({ id = newMessageId, created_at = createdAt, replyPreview = replyPreview })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:CreateServer', function(source, cb, serverName)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or type(serverName) ~= "string" then cb(false) return end

    serverName = Discord_Utf8SafeSub(string.gsub(serverName, "^%s+", ""), 40)
    if serverName == "" then cb(false) return end

    local inviteCode = Discord_GenerateInviteCode()
    local iconColor = DiscordIconPalette[math.random(1, #DiscordIconPalette)]
    local iconText = Discord_IconText(serverName)
    local createdAt = os.time()

    local newServerId = MySQL.Sync.insert("INSERT INTO phone_discord_servers (name, icon_text, icon_color, owner_identifier, invite_code, created_at) VALUES (@name, @icon, @color, @owner, @code, @time)", {
        ['@name'] = serverName,
        ['@icon'] = iconText,
        ['@color'] = iconColor,
        ['@owner'] = xPlayer.identifier,
        ['@code'] = inviteCode,
        ['@time'] = createdAt,
    })

    MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at) VALUES (@sid, 'general', 0, @time)", {
        ['@sid'] = newServerId,
        ['@time'] = createdAt,
    })

    MySQL.Sync.insert("INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at) VALUES (@sid, @id, @nick, @time)", {
        ['@sid'] = newServerId,
        ['@id'] = xPlayer.identifier,
        ['@nick'] = Discord_GetDisplayName(source),
        ['@time'] = createdAt,
    })

    cb({
        id = newServerId,
        name = serverName,
        icon_text = iconText,
        icon_color = iconColor,
        invite_code = inviteCode,
        isOwner = true,
    })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:CreateChannel', function(source, cb, serverId, channelName)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or type(channelName) ~= "string" or not Discord_CanManageChannels(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    channelName = string.lower(string.gsub(Discord_Utf8SafeSub(string.gsub(channelName, "^%s+", ""), 30), "%s+", "-"))
    if channelName == "" then cb(false) return end

    local countResult = ExecuteSql(true, "SELECT COUNT(*) as count FROM phone_discord_channels WHERE server_id = @sid", {['@sid'] = serverId})
    local position = countResult[1] and countResult[1].count or 0

    local newChannelId = MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at) VALUES (@sid, @name, @pos, @time)", {
        ['@sid'] = serverId,
        ['@name'] = channelName,
        ['@pos'] = position,
        ['@time'] = os.time(),
    })

    local channel = { id = newChannelId, name = channelName, position = position }

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:NewChannel', { serverId = serverId, channel = channel }, source)

    cb(channel)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:JoinServer', function(source, cb, inviteCode)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or type(inviteCode) ~= "string" then cb(false) return end

    local rawInvite = Discord_ExtNormalizeInvite(inviteCode) -- v8: accepts "discord.gg/name", vanity names, limited invites
    inviteCode = string.upper(string.gsub(rawInvite, "%s+", ""))

    local server = ExecuteSql(true, "SELECT id, name, icon_text, icon_color, invite_code, owner_identifier, is_verified FROM phone_discord_servers WHERE invite_code = @code", {
        ['@code'] = inviteCode,
    })

    local viaInvite = nil
    if server[1] == nil then
        local sid, invErr, invId = Discord_ExtResolveInvite(rawInvite)
        if invErr then cb({ error = invErr }) return end
        if sid then
            server = ExecuteSql(true, "SELECT id, name, icon_text, icon_color, invite_code, owner_identifier, is_verified FROM phone_discord_servers WHERE id = @id", { ['@id'] = sid })
            viaInvite = invId
        end
    end

    if server[1] == nil then
        cb({ error = "NOT_FOUND" })
        return
    end

    server = server[1]

    if Discord_IsMember(xPlayer.identifier, server.id) then
        cb({ error = "ALREADY_MEMBER" })
        return
    end


    MySQL.Sync.insert("INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at) VALUES (@sid, @id, @nick, @time)", {
        ['@sid'] = server.id,
        ['@id'] = xPlayer.identifier,
        ['@nick'] = Discord_GetDisplayName(source),
        ['@time'] = os.time(),
    })

    if viaInvite then Discord_ExtConsumeInvite(viaInvite) end

    server.isOwner = (server.owner_identifier == xPlayer.identifier)
    server.owner_identifier = nil
    server.isVerified = (server.is_verified == 1 or server.is_verified == true)
    server.is_verified = nil

    cb(server)
end)

RegisterServerEvent('Unique_Phone:server:Discord:LeaveServer')
AddEventHandler('Unique_Phone:server:Discord:LeaveServer', function(serverId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer == nil or serverId == nil then return end
    if Discord_IsOwner(xPlayer.identifier, serverId) then return end -- owner must delete the server instead
    if Discord_IsAutoServer(serverId) then return end -- gang/job servers: membership follows the gang/job (see server/discord_ext.lua)

    MySQL.Async.execute("DELETE FROM phone_discord_members WHERE server_id = @sid AND identifier = @id", {
        ['@sid'] = serverId,
        ['@id'] = xPlayer.identifier,
    })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:DeleteServer', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsOwner(xPlayer.identifier, serverId) or Discord_IsAutoServer(serverId) then
        cb(false)
        return
    end

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:ServerDeleted', { serverId = serverId }, source)

    -- Foreign keys cascade channels/members/messages.
    MySQL.Async.execute("DELETE FROM phone_discord_servers WHERE id = @sid", {['@sid'] = serverId})

    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:DeleteChannel', function(source, cb, channelId)
    local xPlayer = Discord_GetPlayer(source)
    local serverId = channelId ~= nil and Discord_GetServerIdForChannel(channelId) or nil

    if xPlayer == nil or serverId == nil or not Discord_CanManageChannels(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local countResult = ExecuteSql(true, "SELECT COUNT(*) as count FROM phone_discord_channels WHERE server_id = @sid", {['@sid'] = serverId})
    if countResult[1] and countResult[1].count <= 1 then
        cb({ error = "LAST_CHANNEL" })
        return
    end

    MySQL.Async.execute("DELETE FROM phone_discord_channels WHERE id = @cid", {['@cid'] = channelId})

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:ChannelDeleted', { serverId = serverId, channelId = channelId }, source)

    cb(true)
end)

-- ==========================================================================
-- EXPANSION v2: reactions, edit/delete/pin, kicking members, server settings.
-- ==========================================================================

local DiscordAllowedEmoji = {
    ["👍"] = true, ["❤️"] = true, ["😂"] = true, ["😮"] = true,
    ["😢"] = true, ["🔥"] = true, ["🎉"] = true, ["👀"] = true,
}

function Discord_GetMessageOwnerAndServer(messageId)
    local result = ExecuteSql(true, [[
        SELECT m.identifier, c.server_id
        FROM phone_discord_messages m
        INNER JOIN phone_discord_channels c ON c.id = m.channel_id
        WHERE m.id = @mid
    ]], { ['@mid'] = messageId })

    if result[1] then return result[1].identifier, result[1].server_id end
    return nil, nil
end

function Discord_GetMessageReactions(messageId, viewerIdentifier)
    local reactions = ExecuteSql(true, "SELECT identifier, emoji FROM phone_discord_reactions WHERE message_id = @mid", { ['@mid'] = messageId })
    local byEmoji = {}

    for _, r in pairs(reactions) do
        byEmoji[r.emoji] = byEmoji[r.emoji] or { emoji = r.emoji, count = 0, reacted = false }
        byEmoji[r.emoji].count = byEmoji[r.emoji].count + 1
        if r.identifier == viewerIdentifier then byEmoji[r.emoji].reacted = true end
    end

    local list = {}
    for _, r in pairs(byEmoji) do table.insert(list, r) end
    return list
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:ToggleReaction', function(source, cb, messageId, emoji)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or messageId == nil or type(emoji) ~= "string" or #emoji > 16 then cb(false) return end

    local _, serverId = Discord_GetMessageOwnerAndServer(messageId)
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    -- v7: default set OR one of this server's custom (boost-slot) emoji
    if not DiscordAllowedEmoji[emoji] and not Discord_ExtCustomEmojiAllowed(serverId, emoji) then cb(false) return end
    if not Discord_ExtCanReact(xPlayer, source, serverId, messageId) then cb(false) return end -- v8

    local existing = ExecuteSql(true, "SELECT id FROM phone_discord_reactions WHERE message_id = @mid AND identifier = @id AND emoji = @emoji", {
        ['@mid'] = messageId, ['@id'] = xPlayer.identifier, ['@emoji'] = emoji,
    })

    if existing[1] then
        MySQL.Async.execute("DELETE FROM phone_discord_reactions WHERE id = @id", { ['@id'] = existing[1].id })
    else
        MySQL.Async.execute("INSERT INTO phone_discord_reactions (message_id, identifier, emoji, created_at) VALUES (@mid, @id, @emoji, @time)", {
            ['@mid'] = messageId, ['@id'] = xPlayer.identifier, ['@emoji'] = emoji, ['@time'] = os.time(),
        })
    end

    -- Every member gets a fully-recomputed reaction list for this message —
    -- cheap (one small query) and avoids drift from partial +1/-1 patches.
    local members = ExecuteSql(true, [[
        SELECT identifier FROM phone_discord_members WHERE server_id = @sid
    ]], { ['@sid'] = serverId })

    for _, member in pairs(members) do
        local Ply = ESX.GetPlayerFromIdentifier(member.identifier)
        if Ply ~= nil then
            TriggerClientEvent('Unique_Phone:client:Discord:ReactionsUpdated', Ply.source, {
                serverId = serverId,
                messageId = messageId,
                reactions = Discord_GetMessageReactions(messageId, member.identifier),
            })
        end
    end

    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:EditMessage', function(source, cb, messageId, newText)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or messageId == nil or type(newText) ~= "string" then cb(false) return end

    newText = Discord_Utf8SafeSub(newText, 1000)
    if string.gsub(newText, "%s+", "") == "" then cb(false) return end

    local authorIdentifier, serverId = Discord_GetMessageOwnerAndServer(messageId)
    if serverId == nil or authorIdentifier ~= xPlayer.identifier then cb(false) return end -- only the author may edit
    if Discord_ExtAutoModHit(serverId, newText) then cb(false) return end -- v7 auto-mod applies to edits too

    local editedAt = os.time()
    MySQL.Async.execute("UPDATE phone_discord_messages SET message = @msg, edited_at = @time WHERE id = @mid", {
        ['@msg'] = newText, ['@time'] = editedAt, ['@mid'] = messageId,
    })

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:MessageEdited', {
        serverId = serverId, messageId = messageId, message = newText, edited_at = editedAt,
    })

    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:DeleteMessage', function(source, cb, messageId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or messageId == nil then cb(false) return end

    local authorIdentifier, serverId = Discord_GetMessageOwnerAndServer(messageId)
    if serverId == nil then cb(false) return end

    local canDelete = (authorIdentifier == xPlayer.identifier) or Discord_IsOwner(xPlayer.identifier, serverId) or Discord_IsStaff(source)
        or Discord_ExtCan(xPlayer.identifier, serverId, 'manage_messages', nil, source) -- v8
    if not canDelete then cb(false) return end

    MySQL.Async.execute("DELETE FROM phone_discord_messages WHERE id = @mid", { ['@mid'] = messageId })

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:MessageDeleted', {
        serverId = serverId, messageId = messageId,
    })

    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:TogglePinMessage', function(source, cb, messageId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or messageId == nil then cb(false) return end

    local _, serverId = Discord_GetMessageOwnerAndServer(messageId)
    if serverId == nil or not (Discord_CanManageChannels(xPlayer.identifier, serverId) or Discord_IsStaff(source) or Discord_ExtCan(xPlayer.identifier, serverId, 'pin', nil, source)) then cb(false) return end

    local current = ExecuteSql(true, "SELECT is_pinned FROM phone_discord_messages WHERE id = @mid", { ['@mid'] = messageId })
    if current[1] == nil then cb(false) return end

    local newValue = (current[1].is_pinned == 1) and 0 or 1
    MySQL.Async.execute("UPDATE phone_discord_messages SET is_pinned = @val WHERE id = @mid", { ['@val'] = newValue, ['@mid'] = messageId })

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:MessagePinToggled', {
        serverId = serverId, messageId = messageId, isPinned = (newValue == 1),
    })

    cb({ isPinned = (newValue == 1) })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetPinnedMessages', function(source, cb, channelId)
    local xPlayer = Discord_GetPlayer(source)
    local serverId = channelId ~= nil and Discord_GetServerIdForChannel(channelId) or nil

    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local pinned = ExecuteSql(true, "SELECT id, author_name, message, created_at FROM phone_discord_messages WHERE channel_id = @cid AND is_pinned = 1 ORDER BY id DESC", {
        ['@cid'] = channelId,
    })

    cb(pinned)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:KickMember', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or memberRowId == nil or Discord_IsAutoServer(serverId)
        or not (Discord_IsOwner(xPlayer.identifier, serverId) or Discord_ExtCan(xPlayer.identifier, serverId, 'kick', nil, source)) then
        cb(false)
        return
    end

    local server = ExecuteSql(true, "SELECT owner_identifier FROM phone_discord_servers WHERE id = @sid", { ['@sid'] = serverId })
    local target = ExecuteSql(true, "SELECT identifier, nickname FROM phone_discord_members WHERE id = @mid AND server_id = @sid", {
        ['@mid'] = memberRowId, ['@sid'] = serverId,
    })

    if target[1] == nil or (server[1] and target[1].identifier == server[1].owner_identifier) then
        cb(false) -- no such member, or trying to kick the owner
        return
    end
    if not Discord_IsOwner(xPlayer.identifier, serverId) and not Discord_ExtOutranks(xPlayer.identifier, serverId, target[1].identifier) then
        cb(false) -- v8: a role-based moderator can't kick someone with an equal/higher role
        return
    end

    MySQL.Async.execute("DELETE FROM phone_discord_members WHERE id = @mid", { ['@mid'] = memberRowId })

    local KickedPly = ESX.GetPlayerFromIdentifier(target[1].identifier)
    if KickedPly ~= nil then
        TriggerClientEvent('Unique_Phone:client:Discord:Kicked', KickedPly.source, { serverId = serverId })
    end

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:MemberKicked', {
        serverId = serverId, memberRowId = memberRowId, nickname = target[1].nickname,
    }, source)

    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:UpdateServerSettings', function(source, cb, serverId, newName, newIconColor, regenerateInvite, isPublic)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsOwner(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local updates, params = {}, {}

    if type(newName) == "string" then
        newName = Discord_Utf8SafeSub(string.gsub(newName, "^%s+", ""), 40)
        if newName ~= "" then
            table.insert(updates, "name = @name")
            params['@name'] = newName
            table.insert(updates, "icon_text = @icon")
            params['@icon'] = Discord_IconText(newName)
        end
    end

    if type(newIconColor) == "string" and DiscordIconPalette[1] ~= nil then
        local isValidColor = false
        for _, c in pairs(DiscordIconPalette) do if c == newIconColor then isValidColor = true end end
        if isValidColor then
            table.insert(updates, "icon_color = @color")
            params['@color'] = newIconColor
        end
    end

    local newInviteCode = nil
    if regenerateInvite == true then
        newInviteCode = Discord_GenerateInviteCode()
        table.insert(updates, "invite_code = @code")
        params['@code'] = newInviteCode
    end

    if type(isPublic) == "boolean" then
        table.insert(updates, "is_public = @public")
        params['@public'] = isPublic and 1 or 0
    end

    if #updates == 0 then cb(false) return end

    params['@sid'] = serverId
    MySQL.Async.execute("UPDATE phone_discord_servers SET " .. table.concat(updates, ", ") .. " WHERE id = @sid", params)

    local updated = ExecuteSql(true, "SELECT name, icon_text, icon_color, invite_code, is_public FROM phone_discord_servers WHERE id = @sid", { ['@sid'] = serverId })
    local server = updated[1]

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:ServerUpdated', {
        serverId = serverId, name = server.name, icon_text = server.icon_text, icon_color = server.icon_color,
    }, source)

    cb({ name = server.name, icon_text = server.icon_text, icon_color = server.icon_color, invite_code = server.invite_code, isPublic = (server.is_public == 1 or server.is_public == true) })
end)

-- ==========================================================================
-- EXPANSION v3: admin role, public server discovery,
-- typing indicator.
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:Discord:ToggleAdmin', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or memberRowId == nil or not Discord_IsOwner(xPlayer.identifier, serverId) or Discord_IsAutoServer(serverId) then
        cb(false)
        return
    end

    local member = ExecuteSql(true, "SELECT is_admin FROM phone_discord_members WHERE id = @mid AND server_id = @sid", { ['@mid'] = memberRowId, ['@sid'] = serverId })
    if member[1] == nil then cb(false) return end

    local newValue = (member[1].is_admin == 1 or member[1].is_admin == true) and 0 or 1
    MySQL.Async.execute("UPDATE phone_discord_members SET is_admin = @val WHERE id = @mid", { ['@val'] = newValue, ['@mid'] = memberRowId })

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:MemberAdminToggled', {
        serverId = serverId, memberRowId = memberRowId, isAdmin = (newValue == 1),
    })

    cb({ isAdmin = (newValue == 1) })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetPublicServers', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end

    local servers = ExecuteSql(true, [[
        SELECT s.id, s.name, s.icon_text, s.icon_color, s.is_verified,
               (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) as memberCount
        FROM phone_discord_servers s
        WHERE s.is_public = 1
          AND s.id NOT IN (SELECT server_id FROM phone_discord_members WHERE identifier = @id)
        ORDER BY memberCount DESC
        LIMIT 50
    ]], { ['@id'] = xPlayer.identifier })

    cb(servers)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:JoinPublicServer', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end

    local server = ExecuteSql(true, "SELECT id, name, icon_text, icon_color, invite_code, owner_identifier, is_public, is_verified FROM phone_discord_servers WHERE id = @sid", { ['@sid'] = serverId })
    if server[1] == nil or server[1].is_public ~= 1 then cb(false) return end
    if Discord_IsMember(xPlayer.identifier, serverId) then cb({ error = "ALREADY_MEMBER" }) return end

    MySQL.Sync.insert("INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at) VALUES (@sid, @id, @nick, @time)", {
        ['@sid'] = serverId, ['@id'] = xPlayer.identifier,
        ['@nick'] = Discord_GetDisplayName(source), ['@time'] = os.time(),
    })

    local result = server[1]
    result.isOwner = (result.owner_identifier == xPlayer.identifier)
    result.owner_identifier = nil
    result.is_public = nil
    result.isVerified = (result.is_verified == 1 or result.is_verified == true)
    result.is_verified = nil

    cb(result)
end)

-- Typing indicator — ephemeral, nothing touches the database. The client
-- throttles how often it sends this (see js/discord.js), so this stays cheap.
RegisterServerEvent('Unique_Phone:server:Discord:Typing')
AddEventHandler('Unique_Phone:server:Discord:Typing', function(channelId)
    local xPlayer = Discord_GetPlayer(source)
    local serverId = channelId ~= nil and Discord_GetServerIdForChannel(channelId) or nil
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then return end

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:Typing', {
        serverId = serverId, channelId = channelId, name = (Discord_GetDisplayName(source):match("^(%S+)") or ""),
    }, source)
end)

-- ==========================================================================
-- EXPANSION v4: Discord account/profile. Discord-specific bits (bio, status,
-- banner, privacy) live in phone_discord_profiles; the in-game info shown on
-- a profile (name, phone, job, gender, birthdate) is read live from the
-- character's own `users` / `jobs` / `job_grades` rows, so it can never go
-- stale or be faked from the client.
-- ==========================================================================

local DiscordAllowedStatus = { online = true, idle = true, dnd = true, invisible = true }

function Discord_EnsureProfile(identifier)
    local rows = ExecuteSql(true, "SELECT * FROM phone_discord_profiles WHERE identifier = @id", { ['@id'] = identifier })
    if rows[1] then return rows[1] end

    local now = os.time()
    MySQL.Sync.execute("INSERT IGNORE INTO phone_discord_profiles (identifier, discriminator, created_at, updated_at) VALUES (@id, @disc, @now, @now)", {
        ['@id'] = identifier,
        ['@disc'] = string.format("%04d", math.random(0, 9999)),
        ['@now'] = now,
    })

    return ExecuteSql(true, "SELECT * FROM phone_discord_profiles WHERE identifier = @id", { ['@id'] = identifier })[1]
end

function Discord_GetInGameInfo(identifier)
    local rows = ExecuteSql(true, [[
        SELECT u.firstname, u.lastname, u.phone, u.dateofbirth, u.sex, u.job, u.job_grade,
               j.label AS job_label, g.label AS grade_label
        FROM users u
        LEFT JOIN jobs j ON j.name = u.job
        LEFT JOIN job_grades g ON g.job_name = u.job AND g.grade = u.job_grade
        WHERE u.identifier = @id
    ]], { ['@id'] = identifier })

    local u = rows[1]
    if u == nil then return {} end

    -- Online players' names can differ from the users row (multichar), so
    -- prefer the live ESX values when the player is connected.
    local Ply = ESX.GetPlayerFromIdentifier(identifier)
    local first = (Ply and Ply.firstname) or u.firstname or ""
    local last = (Ply and Ply.lastname) or u.lastname or ""

    local gender = nil
    if u.sex == "m" or u.sex == "M" or u.sex == 0 or u.sex == "0" then gender = "Male"
    elseif u.sex == "f" or u.sex == "F" or u.sex == 1 or u.sex == "1" then gender = "Female" end

    return {
        fullName = (first .. " " .. last):gsub("^%s+", ""),
        phone = u.phone,
        birthdate = u.dateofbirth,
        gender = gender,
        jobLabel = u.job_label or u.job,
        gradeLabel = u.grade_label,
    }
end

-- Builds the profile a *viewer* is allowed to see. Privacy toggles only
-- apply to other people — you always see your own phone/job.
function Discord_BuildProfile(targetIdentifier, viewerIdentifier)
    local profile = Discord_EnsureProfile(targetIdentifier)
    local info = Discord_GetInGameInfo(targetIdentifier)
    local isSelf = (targetIdentifier == viewerIdentifier)

    if not isSelf then
        if profile.show_phone ~= 1 and profile.show_phone ~= true then info.phone = nil end
        if profile.show_job ~= 1 and profile.show_job ~= true then info.jobLabel = nil; info.gradeLabel = nil end
    end

    local status = profile.status or "online"
    local isConnected = ESX.GetPlayerFromIdentifier(targetIdentifier) ~= nil

    return {
        discriminator = profile.discriminator,
        bio = profile.bio,
        status = isSelf and status or ((isConnected and status ~= "invisible") and status or "offline"),
        customStatus = profile.custom_status,
        bannerColor = profile.banner_color,
        showPhone = (profile.show_phone == 1 or profile.show_phone == true),
        showJob = (profile.show_job == 1 or profile.show_job == true),
        discordSince = profile.created_at,
        verified = (profile.verified == 1 or profile.verified == true),
        info = info,
        isSelf = isSelf,
    }
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetMyProfile', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then cb(false) return end

    local ban = Discord_GetBan(xPlayer.identifier)
    if ban then
        cb({ banned = true, reason = ban.reason, expiresAt = ban.expires_at, bannedBy = ban.banned_by })
        return
    end

    local profile = Discord_BuildProfile(xPlayer.identifier, xPlayer.identifier)
    local count = ExecuteSql(true, "SELECT COUNT(*) as count FROM phone_discord_members WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    profile.serverCount = count[1] and count[1].count or 0
    profile.displayName = Discord_GetDisplayName(source)
    profile.isStaff = Discord_IsStaff(source)

    cb(profile)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetProfile', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or memberRowId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then
        cb(false)
        return
    end

    local member = ExecuteSql(true, "SELECT identifier, nickname, is_admin, joined_at FROM phone_discord_members WHERE id = @mid AND server_id = @sid", {
        ['@mid'] = memberRowId, ['@sid'] = serverId,
    })
    if member[1] == nil then cb(false) return end

    local profile = Discord_BuildProfile(member[1].identifier, xPlayer.identifier)
    profile.nickname = member[1].nickname
    profile.isOwner = Discord_IsOwner(member[1].identifier, serverId)
    profile.isAdmin = (member[1].is_admin == 1 or member[1].is_admin == true)
    profile.memberSince = member[1].joined_at

    cb(profile)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:UpdateMyProfile', function(source, cb, data)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or type(data) ~= "table" then cb(false) return end

    Discord_EnsureProfile(xPlayer.identifier)

    local bio = type(data.bio) == "string" and Discord_Utf8SafeSub(data.bio, 190) or ""
    local customStatus = type(data.customStatus) == "string" and Discord_Utf8SafeSub(data.customStatus, 60) or ""
    local status = DiscordAllowedStatus[data.status] and data.status or "online"

    local bannerColor = DiscordIconPalette[1]
    for _, c in pairs(DiscordIconPalette) do
        if c == data.bannerColor then bannerColor = c end
    end

    MySQL.Sync.execute([[
        UPDATE phone_discord_profiles
        SET bio = @bio, custom_status = @cs, status = @status, banner_color = @banner,
            show_phone = @sp, show_job = @sj, updated_at = @now
        WHERE identifier = @id
    ]], {
        ['@bio'] = bio, ['@cs'] = customStatus, ['@status'] = status, ['@banner'] = bannerColor,
        ['@sp'] = data.showPhone == false and 0 or 1,
        ['@sj'] = data.showJob == false and 0 or 1,
        ['@now'] = os.time(), ['@id'] = xPlayer.identifier,
    })

    -- Tell every server this player is in, so member lists refresh live.
    local servers = ExecuteSql(true, "SELECT server_id FROM phone_discord_members WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    for _, row in pairs(servers) do
        Discord_BroadcastToServerMembers(row.server_id, 'Unique_Phone:client:Discord:ProfileUpdated', { serverId = row.server_id }, source)
    end

    cb(Discord_BuildProfile(xPlayer.identifier, xPlayer.identifier))
end)

-- ==========================================================================
-- EXPANSION v5: Discord staff panel — for game admins only (same admin check
-- as the Job Manager: Unique_AdminPanel's isAdmin, with a perm-level
-- fallback). Everything goes through ONE callback, and every action re-checks
-- staff status on the server, so nothing here can be reached by editing the
-- client. Actions are written to phone_discord_audit.
-- ==========================================================================

function Discord_Audit(src, action, target)
    MySQL.Async.execute("INSERT INTO phone_discord_audit (staff_name, action, target, created_at) VALUES (@n, @a, @t, @now)", {
        ['@n'] = Discord_GetDisplayName(src), ['@a'] = action, ['@t'] = Discord_Utf8SafeSub(tostring(target or ""), 120), ['@now'] = os.time(),
    })
end

local function likeQuery(q)
    if type(q) ~= "string" then return "%" end
    q = Discord_Utf8SafeSub(q, 40):gsub("[%%_\\]", "")
    return "%" .. q .. "%"
end

local function toggleColumn(table_, column, idColumn, id)
    local row = ExecuteSql(true, ("SELECT %s AS v FROM %s WHERE %s = @id"):format(column, table_, idColumn), { ['@id'] = id })
    if row[1] == nil then return nil end
    local new = (row[1].v == 1 or row[1].v == true) and 0 or 1
    MySQL.Sync.execute(("UPDATE %s SET %s = @v WHERE %s = @id"):format(table_, column, idColumn), { ['@v'] = new, ['@id'] = id })
    return new == 1
end

-- Puts one announcement row into a channel and pushes it live to the server.
local function postAnnouncement(staffSrc, staffIdentifier, channelId, text)
    local serverId = Discord_GetServerIdForChannel(channelId)
    if serverId == nil then return false end

    local now = os.time()
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at, is_announcement) VALUES (@cid, @id, 'Discord Staff', @msg, @now, 1)", {
        ['@cid'] = channelId, ['@id'] = staffIdentifier, ['@msg'] = text, ['@now'] = now,
    })

    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:NewMessage', {
        id = id, serverId = serverId, channelId = channelId, author_name = "Discord Staff",
        message = text, created_at = now, isAnnouncement = true, authorVerified = true,
    })
    return true
end

local DiscordStaffActions = {}

DiscordStaffActions.Overview = function(src, data)
    local function count(q) local r = ExecuteSql(true, q, {}) return r[1] and r[1].c or 0 end
    return {
        servers = count("SELECT COUNT(*) c FROM phone_discord_servers"),
        verifiedServers = count("SELECT COUNT(*) c FROM phone_discord_servers WHERE is_verified = 1"),
        channels = count("SELECT COUNT(*) c FROM phone_discord_channels"),
        messages = count("SELECT COUNT(*) c FROM phone_discord_messages"),
        accounts = count("SELECT COUNT(*) c FROM (SELECT identifier FROM phone_discord_members UNION SELECT identifier FROM phone_discord_profiles) a"),
        verifiedAccounts = count("SELECT COUNT(*) c FROM phone_discord_profiles WHERE verified = 1"),
        bans = count("SELECT COUNT(*) c FROM phone_discord_bans"),
        messagesToday = count("SELECT COUNT(*) c FROM phone_discord_messages WHERE created_at > " .. (os.time() - 86400)),
    }
end

DiscordStaffActions.Servers = function(src, data)
    local rows = ExecuteSql(true, [[
        SELECT s.id, s.name, s.icon_text, s.icon_color, s.is_verified, s.is_public, s.is_featured, s.invite_code,
               (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) AS memberCount,
               (SELECT COUNT(*) FROM phone_discord_channels c WHERE c.server_id = s.id) AS channelCount,
               (SELECT m2.nickname FROM phone_discord_members m2 WHERE m2.server_id = s.id AND m2.identifier = s.owner_identifier LIMIT 1) AS ownerName
        FROM phone_discord_servers s
        WHERE s.name LIKE @q OR s.invite_code LIKE @q
        ORDER BY s.is_verified DESC, memberCount DESC
        LIMIT 60
    ]], { ['@q'] = likeQuery(data.query) })

    for _, r in pairs(rows) do
        r.isVerified = (r.is_verified == 1 or r.is_verified == true)
        r.isPublic = (r.is_public == 1 or r.is_public == true)
        r.isFeatured = (r.is_featured == 1 or r.is_featured == true)
        r.is_verified, r.is_public, r.is_featured = nil, nil, nil
    end
    return rows
end

DiscordStaffActions.ServerChannels = function(src, data)
    local rows = ExecuteSql(true, "SELECT id, name, is_verified, is_locked FROM phone_discord_channels WHERE server_id = @sid ORDER BY position ASC, id ASC", { ['@sid'] = data.serverId })
    for _, r in pairs(rows) do
        r.isVerified = (r.is_verified == 1 or r.is_verified == true)
        r.isLocked = (r.is_locked == 1 or r.is_locked == true)
        r.is_verified, r.is_locked = nil, nil
    end
    return rows
end

DiscordStaffActions.ToggleServerVerified = function(src, data)
    local v = toggleColumn("phone_discord_servers", "is_verified", "id", data.serverId)
    if v == nil then return false end
    Discord_Audit(src, v and "Verified server" or "Unverified server", "server #" .. tostring(data.serverId))
    Discord_BroadcastToServerMembers(data.serverId, 'Unique_Phone:client:Discord:ServerUpdated', { serverId = data.serverId, isVerified = v })
    return { isVerified = v }
end

DiscordStaffActions.ToggleChannelVerified = function(src, data)
    local v = toggleColumn("phone_discord_channels", "is_verified", "id", data.channelId)
    if v == nil then return false end
    Discord_Audit(src, v and "Verified channel" or "Unverified channel", "channel #" .. tostring(data.channelId))
    local sid = Discord_GetServerIdForChannel(data.channelId)
    if sid then Discord_BroadcastToServerMembers(sid, 'Unique_Phone:client:Discord:ChannelUpdated', { serverId = sid, channelId = data.channelId, isVerified = v }) end
    return { isVerified = v }
end

DiscordStaffActions.ToggleChannelLocked = function(src, data)
    local v = toggleColumn("phone_discord_channels", "is_locked", "id", data.channelId)
    if v == nil then return false end
    Discord_Audit(src, v and "Locked channel" or "Unlocked channel", "channel #" .. tostring(data.channelId))
    local sid = Discord_GetServerIdForChannel(data.channelId)
    if sid then Discord_BroadcastToServerMembers(sid, 'Unique_Phone:client:Discord:ChannelUpdated', { serverId = sid, channelId = data.channelId, isLocked = v }) end
    return { isLocked = v }
end

DiscordStaffActions.DeleteChannel = function(src, data)
    local sid = Discord_GetServerIdForChannel(data.channelId)
    if sid == nil then return false end
    local count = ExecuteSql(true, "SELECT COUNT(*) c FROM phone_discord_channels WHERE server_id = @sid", { ['@sid'] = sid })
    if count[1] and count[1].c <= 1 then return { error = "LAST_CHANNEL" } end

    MySQL.Sync.execute("DELETE FROM phone_discord_channels WHERE id = @id", { ['@id'] = data.channelId })
    Discord_Audit(src, "Deleted channel", "channel #" .. tostring(data.channelId))
    Discord_BroadcastToServerMembers(sid, 'Unique_Phone:client:Discord:ChannelDeleted', { serverId = sid, channelId = data.channelId })
    return true
end

DiscordStaffActions.DeleteServer = function(src, data)
    local row = ExecuteSql(true, "SELECT name FROM phone_discord_servers WHERE id = @id", { ['@id'] = data.serverId })
    if row[1] == nil then return false end
    Discord_BroadcastToServerMembers(data.serverId, 'Unique_Phone:client:Discord:ServerDeleted', { serverId = data.serverId })
    MySQL.Sync.execute("DELETE FROM phone_discord_servers WHERE id = @id", { ['@id'] = data.serverId })
    Discord_Audit(src, "Deleted server", row[1].name)
    return true
end

DiscordStaffActions.Accounts = function(src, data)
    local rows = ExecuteSql(true, [[
        SELECT a.identifier, u.firstname, u.lastname, u.phone, p.discriminator, p.verified, p.status,
               (SELECT nickname FROM phone_discord_members m WHERE m.identifier = a.identifier LIMIT 1) AS nickname,
               (SELECT COUNT(*) FROM phone_discord_members m2 WHERE m2.identifier = a.identifier) AS serverCount,
               b.reason AS banReason
        FROM (SELECT identifier FROM phone_discord_members UNION SELECT identifier FROM phone_discord_profiles) a
        LEFT JOIN users u ON u.identifier = a.identifier
        LEFT JOIN phone_discord_profiles p ON p.identifier = a.identifier
        LEFT JOIN phone_discord_bans b ON b.identifier = a.identifier
        WHERE u.firstname LIKE @q OR u.lastname LIKE @q OR u.phone LIKE @q OR a.identifier LIKE @q
           OR EXISTS (SELECT 1 FROM phone_discord_members m3 WHERE m3.identifier = a.identifier AND m3.nickname LIKE @q)
        ORDER BY p.verified DESC, serverCount DESC
        LIMIT 50
    ]], { ['@q'] = likeQuery(data.query) })

    for _, r in pairs(rows) do
        local name = r.nickname
        if (name == nil or name == "") and r.firstname then name = r.firstname .. " " .. (r.lastname or "") end
        r.name = name or "Unknown"
        r.isVerified = (r.verified == 1 or r.verified == true)
        r.isBanned = r.banReason ~= nil
        r.isOnline = ESX.GetPlayerFromIdentifier(r.identifier) ~= nil
        r.verified, r.firstname, r.lastname, r.nickname = nil, nil, nil, nil
    end
    return rows
end

DiscordStaffActions.ToggleAccountVerified = function(src, data)
    if type(data.identifier) ~= "string" then return false end
    Discord_EnsureProfile(data.identifier)
    local v = toggleColumn("phone_discord_profiles", "verified", "identifier", data.identifier)
    if v == nil then return false end
    Discord_Audit(src, v and "Verified account" or "Unverified account", data.identifier)

    local servers = ExecuteSql(true, "SELECT server_id FROM phone_discord_members WHERE identifier = @id", { ['@id'] = data.identifier })
    for _, row in pairs(servers) do
        Discord_BroadcastToServerMembers(row.server_id, 'Unique_Phone:client:Discord:ProfileUpdated', { serverId = row.server_id })
    end
    return { isVerified = v }
end

DiscordStaffActions.ClearProfile = function(src, data)
    if type(data.identifier) ~= "string" then return false end
    MySQL.Sync.execute("UPDATE phone_discord_profiles SET bio = '', custom_status = '' WHERE identifier = @id", { ['@id'] = data.identifier })
    Discord_Audit(src, "Cleared profile text", data.identifier)
    return true
end

DiscordStaffActions.Ban = function(src, data)
    if type(data.identifier) ~= "string" then return false end

    local target = ESX.GetPlayerFromIdentifier(data.identifier)
    if target and Discord_IsStaff(target.source) then return { error = "STAFF" } end -- never ban other staff from here

    local reason = type(data.reason) == "string" and Discord_Utf8SafeSub(data.reason, 150) or ""
    if reason == "" then reason = "Violation of the rules" end

    local hours = tonumber(data.hours) or 0
    local expiresAt = hours > 0 and (os.time() + math.floor(hours * 3600)) or nil

    local nameRow = ExecuteSql(true, "SELECT (SELECT nickname FROM phone_discord_members WHERE identifier = @id LIMIT 1) AS nick", { ['@id'] = data.identifier })
    local name = (nameRow[1] and nameRow[1].nick) or data.identifier

    MySQL.Sync.execute([[
        REPLACE INTO phone_discord_bans (identifier, name, reason, banned_by, created_at, expires_at)
        VALUES (@id, @name, @reason, @by, @now, @exp)
    ]], { ['@id'] = data.identifier, ['@name'] = name, ['@reason'] = reason, ['@by'] = Discord_GetDisplayName(src), ['@now'] = os.time(), ['@exp'] = expiresAt })

    DiscordBans[data.identifier] = { identifier = data.identifier, name = name, reason = reason, banned_by = Discord_GetDisplayName(src), created_at = os.time(), expires_at = expiresAt }

    if data.purge == true then
        MySQL.Sync.execute("DELETE FROM phone_discord_messages WHERE identifier = @id", { ['@id'] = data.identifier })
    end

    if target then
        TriggerClientEvent('Unique_Phone:client:Discord:Banned', target.source, { reason = reason, expiresAt = expiresAt, bannedBy = Discord_GetDisplayName(src) })
    end

    Discord_Audit(src, "Banned from Discord" .. (hours > 0 and (" (" .. hours .. "h)") or " (permanent)"), name .. " — " .. reason)
    return true
end

DiscordStaffActions.Unban = function(src, data)
    if type(data.identifier) ~= "string" then return false end
    MySQL.Sync.execute("DELETE FROM phone_discord_bans WHERE identifier = @id", { ['@id'] = data.identifier })
    DiscordBans[data.identifier] = nil
    Discord_Audit(src, "Unbanned from Discord", data.identifier)
    return true
end

DiscordStaffActions.Bans = function(src, data)
    local rows = ExecuteSql(true, "SELECT identifier, name, reason, banned_by, created_at, expires_at FROM phone_discord_bans ORDER BY created_at DESC LIMIT 100", {})
    return rows
end

-- scope: "channel" (one channel) | "server" (every channel of one server)
--        | "global" (the first channel of every server)
DiscordStaffActions.Announce = function(src, data)
    local xPlayer = ESX.GetPlayerFromId(src)
    local text = type(data.text) == "string" and Discord_Utf8SafeSub(data.text, 600) or ""
    if string.gsub(text, "%s+", "") == "" then return false end

    local channelIds = {}
    if data.scope == "channel" then
        channelIds = { data.channelId }
    elseif data.scope == "server" then
        for _, r in pairs(ExecuteSql(true, "SELECT id FROM phone_discord_channels WHERE server_id = @sid", { ['@sid'] = data.serverId })) do table.insert(channelIds, r.id) end
    elseif data.scope == "global" then
        for _, r in pairs(ExecuteSql(true, "SELECT MIN(id) AS id FROM phone_discord_channels GROUP BY server_id", {})) do table.insert(channelIds, r.id) end
    else
        return false
    end

    local posted = 0
    for _, cid in pairs(channelIds) do
        if cid and postAnnouncement(src, xPlayer.identifier, cid, text) then posted = posted + 1 end
    end

    Discord_Audit(src, "Announcement (" .. tostring(data.scope) .. ", " .. posted .. " channel(s))", text)
    return { posted = posted }
end

DiscordStaffActions.Audit = function(src, data)
    return ExecuteSql(true, "SELECT staff_name, action, target, created_at FROM phone_discord_audit ORDER BY id DESC LIMIT 80", {})
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:Staff', function(source, cb, action, data)
    if not Discord_IsStaff(source) then cb(false) return end

    local handler = DiscordStaffActions[action]
    if handler == nil or type(data) ~= "table" then cb(false) return end

    local ok, result = pcall(handler, source, data)
    if not ok then
        print(("[Unique_Phone] Discord staff action '%s' failed: %s"):format(tostring(action), tostring(result)))
        cb(false)
        return
    end
    cb(result)
end)

-- ==========================================================================
-- EXPANSION v6: VIP (staff-featured) servers, and mandatory Discord account
-- verification via a login code delivered through arshiahub.ir/mail.
-- ==========================================================================

DiscordStaffActions.ToggleServerFeatured = function(src, data)
    local v = toggleColumn("phone_discord_servers", "is_featured", "id", data.serverId)
    if v == nil then return false end
    Discord_Audit(src, v and "Featured server (VIP)" or "Unfeatured server", "server #" .. tostring(data.serverId))
    return { isFeatured = v }
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetVIPServers', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end

    local servers = ExecuteSql(true, [[
        SELECT s.id, s.name, s.icon_text, s.icon_color, s.is_verified,
               (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) as memberCount
        FROM phone_discord_servers s
        WHERE s.is_featured = 1
          AND s.id NOT IN (SELECT server_id FROM phone_discord_members WHERE identifier = @id)
        ORDER BY memberCount DESC
        LIMIT 50
    ]], { ['@id'] = xPlayer.identifier })

    for _, s in pairs(servers) do
        s.isVerified = (s.is_verified == 1 or s.is_verified == true)
        s.is_verified = nil
    end

    cb(servers)
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:JoinVIPServer', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end

    local server = ExecuteSql(true, "SELECT id, name, icon_text, icon_color, invite_code, owner_identifier, is_featured, is_verified FROM phone_discord_servers WHERE id = @sid", { ['@sid'] = serverId })
    if server[1] == nil or (server[1].is_featured ~= 1 and server[1].is_featured ~= true) then cb(false) return end
    if Discord_IsMember(xPlayer.identifier, serverId) then cb({ error = "ALREADY_MEMBER" }) return end

    MySQL.Sync.insert("INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at) VALUES (@sid, @id, @nick, @time)", {
        ['@sid'] = serverId, ['@id'] = xPlayer.identifier,
        ['@nick'] = Discord_GetDisplayName(source), ['@time'] = os.time(),
    })

    local result = server[1]
    result.isOwner = (result.owner_identifier == xPlayer.identifier)
    result.isVerified = (result.is_verified == 1 or result.is_verified == true)
    result.owner_identifier, result.is_featured, result.is_verified = nil, nil, nil

    cb(result)
end)

-- ---- Discord account: mailbox + login code via arshiahub.ir/mail --------

local DiscordCodeCooldown = {} -- identifier -> last request timestamp (extra guard in front of the DB check)

function Discord_SendMailCode(mailbox, code)
    local cfg = Config.DiscordMailAPI
    if cfg == nil or cfg.url == nil then return false end

    local fields = { [cfg.fieldMailbox or "to"] = mailbox, [cfg.fieldCode or "code"] = code }
    if cfg.fieldSubject then fields[cfg.fieldSubject] = cfg.subjectText or "Verification Code" end
    for k, v in pairs(cfg.extraFields or {}) do fields[k] = v end

    local headers, body
    if cfg.bodyFormat == "form" then
        headers = { ["Content-Type"] = "application/x-www-form-urlencoded" }
        local parts = {}
        for k, v in pairs(fields) do table.insert(parts, k .. "=" .. tostring(v)) end
        body = table.concat(parts, "&")
    else
        headers = { ["Content-Type"] = "application/json" }
        body = json.encode(fields)
    end

    local p = promise.new()
    PerformHttpRequest(cfg.url, function(statusCode, response, respHeaders)
        p:resolve(statusCode ~= nil and statusCode >= 200 and statusCode < 300)
    end, cfg.method or "POST", body, headers)

    return Citizen.Await(p)
end

function Discord_ValidMailbox(mailbox)
    if type(mailbox) ~= "string" then return false end
    return mailbox:match("^[%w._-]+$") ~= nil and #mailbox >= 3 and #mailbox <= 60
end

ESX.RegisterServerCallback('Unique_Phone:server:Discord:GetAccountStatus', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end

    local row = ExecuteSql(true, "SELECT mailbox, logged_in FROM phone_discord_accounts WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    if row[1] == nil then
        cb({ hasAccount = false, loggedIn = false, siteUrl = Config.DiscordMailAPI.siteUrl })
        return
    end

    cb({
        hasAccount = true,
        loggedIn = (row[1].logged_in == 1 or row[1].logged_in == true),
        mailbox = row[1].mailbox,
        siteUrl = Config.DiscordMailAPI.siteUrl,
    })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:RequestLoginCode', function(source, cb, mailbox)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end

    if not Discord_ValidMailbox(mailbox) then cb({ error = "INVALID_MAILBOX" }) return end
    mailbox = mailbox:lower()

    local lastRequest = DiscordCodeCooldown[xPlayer.identifier]
    if lastRequest and os.time() - lastRequest < 60 then
        cb({ error = "COOLDOWN", retryIn = 60 - (os.time() - lastRequest) })
        return
    end

    -- A verified mailbox already linked to a DIFFERENT character can't be
    -- claimed again — one mailbox, one character.
    local existing = ExecuteSql(true, "SELECT identifier FROM phone_discord_accounts WHERE mailbox = @m", { ['@m'] = mailbox })
    if existing[1] and existing[1].identifier ~= xPlayer.identifier then
        cb({ error = "MAILBOX_TAKEN" })
        return
    end

    DiscordCodeCooldown[xPlayer.identifier] = os.time()

    local code = tostring(math.random(100000, 999999))
    local now = os.time()

    MySQL.Sync.execute([[
        REPLACE INTO phone_discord_login_codes (identifier, mailbox, code, attempts, requested_at, expires_at)
        VALUES (@id, @mailbox, @code, 0, @now, @exp)
    ]], { ['@id'] = xPlayer.identifier, ['@mailbox'] = mailbox, ['@code'] = code, ['@now'] = now, ['@exp'] = now + 600 })

    local sent = Discord_SendMailCode(mailbox, code)
    if not sent then
        cb({ error = "MAIL_SEND_FAILED" })
        return
    end

    cb({ ok = true, siteUrl = Config.DiscordMailAPI.siteUrl })
end)

ESX.RegisterServerCallback('Unique_Phone:server:Discord:VerifyLoginCode', function(source, cb, code)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or type(code) ~= "string" then cb(false) return end

    local row = ExecuteSql(true, "SELECT * FROM phone_discord_login_codes WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    if row[1] == nil then cb({ error = "NO_PENDING_CODE" }) return end
    if row[1].expires_at <= os.time() then
        MySQL.Async.execute("DELETE FROM phone_discord_login_codes WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
        cb({ error = "CODE_EXPIRED" })
        return
    end
    if row[1].attempts >= 5 then cb({ error = "TOO_MANY_ATTEMPTS" }) return end

    if code ~= row[1].code then
        MySQL.Sync.execute("UPDATE phone_discord_login_codes SET attempts = attempts + 1 WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
        cb({ error = "WRONG_CODE", attemptsLeft = 5 - (row[1].attempts + 1) })
        return
    end

    local now = os.time()
    MySQL.Sync.execute([[
        INSERT INTO phone_discord_accounts (identifier, mailbox, verified_at, logged_in, created_at)
        VALUES (@id, @mailbox, @now, 1, @now)
        ON DUPLICATE KEY UPDATE logged_in = 1, verified_at = @now
    ]], { ['@id'] = xPlayer.identifier, ['@mailbox'] = row[1].mailbox, ['@now'] = now })

    MySQL.Async.execute("DELETE FROM phone_discord_login_codes WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    Discord_Audit(source, "Discord account verified", row[1].mailbox)

    cb({ ok = true, mailbox = row[1].mailbox })
end)

-- Always keyed by `source` — there is no version of this that takes a
-- target identifier, so a player can only ever log out their own session.
ESX.RegisterServerCallback('Unique_Phone:server:Discord:Logout', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end

    MySQL.Sync.execute("UPDATE phone_discord_accounts SET logged_in = 0 WHERE identifier = @id", { ['@id'] = xPlayer.identifier })
    cb(true)
end)
