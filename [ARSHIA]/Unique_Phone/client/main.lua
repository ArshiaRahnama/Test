ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    Wait(200)

    LoadPhone()
    test()
end)

local PlayerJob = {}

phoneProp = 0
local phoneModel = `prop_npc_phone_02`
local FlyMode = false

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    currentTab = nil,
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    SelfTweets = {},
    Mails = {},
    Adverts = {},
    id = 1,
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
    Images = {},
}

RegisterNetEvent('Unique_Phone:client:RaceNotify')
AddEventHandler('Unique_Phone:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang['RACE_TITLE'],
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang['RACE_TITLE'],
                content = message,
                icon = "fas fa-flag-checkered",
                timeout = 3500,
                color = "#353b48",
            },
        })
    end
end)

RegisterNetEvent('Unique_Phone:client:AddRecentCall')
AddEventHandler('Unique_Phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(JobInfo)
    if PlayerJob == nil then
        PlayerJob = {}
    end

    PlayerJob = JobInfo

    SendNUIMessage({
        action = "UpdateApplications",
        JobData = JobInfo,
        applications = Config.PhoneApplications
    })
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    TriggerServerEvent('Unique_Phone:server:SaveMetaData', 'background', background)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenPhone) then
            if not PhoneData.isOpen then
                OpenPhone()
            end
        end
        Citizen.Wait(3)
    end
end)

RegisterCommand("phone", function()
OpenPhone()
newPhoneProp()
end)

function CalculateTimeToDisplay()
        hour = GetClockHours()
    minute = GetClockMinutes()

    local obj = {}

        if minute <= 9 then
                minute = "0" .. minute
    end

    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        if isLoggedIn then
            ESX.TriggerServerCallback('Unique_Phone:server:GetPhoneData', function(pData)
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
                    PhoneData.Contacts = pData.PlayerContacts
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

function test()

    for j = 1, #PhoneData.Tweets do
        local TwitterMessage = PhoneData.Tweets[j].message
        local MentionTag = TwitterMessage:split("@")
        for i = 2, #MentionTag, 1 do
            local Handle = MentionTag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local Fullname = Handle:split("_")

                local Firstname = Fullname[1]
                table.remove(Fullname, 1)

                local Lastname = table.concat(Fullname, " ")

                if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then

                    TriggerServerEvent('Unique_Phone:server:MentionedPlayer', Firstname, Lastname, PhoneData.Tweets[j])
                end
            end
        end
    end
    ESX.TriggerServerCallback('Unique_Phone:server:GetPhoneData', function(pData)
        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then
            PhoneData.MentionedTweets = pData.MentionedTweets

        end
    end)

end

function LoadPhone()
    Citizen.Wait(100)
    isLoggedIn = true

    ESX.TriggerServerCallback('Unique_Phone:server:GetPhoneData', function(pData)
        PlayerJob = ESX.GetPlayerData().job
        PhoneData.PlayerData = ESX.GetPlayerData()
        PhoneData.MetaData = {}
        PhoneData.PlayerData.charinfo = pData.charinfo ~= nil and pData.charinfo or {}
        local t={}
        for str in string.gmatch(ESX.GetPlayerData().name, "([^_]+)") do
            table.insert(t, str)
        end
        PhoneData.PlayerData.firstname = t[1]
        PhoneData.PlayerData.lastname = t[2]
        PhoneData.PlayerData.identifier = pData ~= nil and pData.identifier or ""

        if pData.MetaData.profilepicture == nil then

            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = pData.MetaData.profilepicture
        end

        if pData.MetaData.background ~= nil then
            PhoneData.MetaData.background = pData.MetaData.background
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do
                Config.PhoneApplications[k].Alerts = v
            end
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end
            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end
        if pData.Tweets ~= nil then
            PhoneData.Tweets = pData.Tweets
            PhoneData.id = pData.Tweets[#pData.Tweets].id + 1
        end

        if pData.SelfTweets ~= nil then
            PhoneData.SelfTweets = pData.SelfTweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end

        if pData.Images ~= nil and next(pData.Images) ~= nil then
            PhoneData.Images = pData.Images
        end

        Citizen.Wait(300)

        SendNUIMessage({
            action       = "LoadPhoneData",
            PhoneData    = PhoneData,
            PlayerData   = PhoneData.PlayerData,
            PlayerJob    = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications,
            MetaData     = json.encode(pData.MetaData)
        })

    end)
    Citizen.Wait(2000)

end

RegisterNUICallback('HasPhone', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:HasPhone', function(HasPhone)
         cb(HasPhone)
     end)
 end)

local threadCreated

function OpenPhone()
    ESX.TriggerServerCallback('Unique_Phone:server:HasPhone', function(HasPhone)
        if HasPhone then
            ESX.TriggerServerCallback('Unique_Phone:server:GetCharacterData', function(chardata)
                PhoneData.PlayerData = ESX.GetPlayerData()
                PhoneData.PlayerData.charinfo = chardata ~= nil and chardata or {}
                local t={}
                for str in string.gmatch(ESX.GetPlayerData().name, "([^_]+)") do
                    table.insert(t, str)
                end
                PhoneData.PlayerData.charinfo.firstname = t[1]
                PhoneData.PlayerData.charinfo.lastname = t[2]
                PhoneData.PlayerData.identifier = chardata ~= nil and chardata.identifier or {}
                SetNuiFocus(true, true)
                SetNuiFocusKeepInput(true)

                SendNUIMessage({
                    action = "open",
                    Tweets = PhoneData.Tweets,
                    AppData = Config.PhoneApplications,
                    CallData = PhoneData.CallData,
                    PlayerData = PhoneData.PlayerData,
                })

                CreateThread(function()
                    while PhoneData.isOpen do

                        DisableControlAction(0, 199, true)
                        DisableControlAction(0, 1, true)
                        DisableControlAction(0, 2, true)
                        DisableControlAction(0, 3, true)
                        DisableControlAction(0, 4, true)
                        DisableControlAction(0, 5, true)
                        DisableControlAction(0, 6, true)
                        DisableControlAction(0, 263, true)
                        DisableControlAction(0, 264, true)
                        DisableControlAction(0, 257, true)
                        DisableControlAction(0, 140, true)
                        DisableControlAction(0, 141, true)
                        DisableControlAction(0, 142, true)
                        DisableControlAction(0, 143, true)
                        DisableControlAction(0, 177, true)
                        DisableControlAction(0, 200, true)
                        DisableControlAction(0, 202, true)
                        DisableControlAction(0, 322, true)
                        DisableControlAction(0, 245, true)
                        DisableControlAction(0, 245, true)
                        DisableControlAction(0, 105, true)
                        -- FIX: mouse-wheel / weapon-wheel controls were missing from
                        -- this list. Without disabling them, scrolling inside the
                        -- phone (e.g. the browser app, or any scrollable list) ALSO
                        -- scrolled the game's weapon wheel underneath — cycling or
                        -- opening it while you were just trying to scroll the phone.
                        DisableControlAction(0, 14, true)  -- INPUT_WEAPON_WHEEL_NEXT (mwheelup)
                        DisableControlAction(0, 15, true)  -- INPUT_WEAPON_WHEEL_PREV (mwheeldown)
                        DisableControlAction(0, 16, true)  -- INPUT_SELECT_NEXT_WEAPON
                        DisableControlAction(0, 17, true)  -- INPUT_SELECT_PREV_WEAPON
                        DisableControlAction(0, 19, true)  -- INPUT_WEAPON_WHEEL_UD
                        DisableControlAction(0, 20, true)  -- INPUT_WEAPON_WHEEL_LR
                        DisableControlAction(0, 37, true)  -- INPUT_SELECT_WEAPON (hold Tab/Q to open wheel)
                        if IsControlJustPressed(1, 22) then
                            TriggerEvent('KeyDown:space')
                        end
                        Wait(1)
                    end
                end)

                PhoneData.isOpen = true

                if not PhoneData.CallData.InCall then
                    DoPhoneAnimation('cellphone_text_in')
                else
                    DoPhoneAnimation('cellphone_call_to_text')
                end
                TriggerEvent("status:togglePhone", true)
                SetTimeout(250, function()
                    newPhoneProp()
                end)


                ESX.TriggerServerCallback('Unique_Phone:server:GetGarageVehicles', function(vehicles)

                    if vehicles ~= nil then
                        for k, v in pairs(vehicles) do
                            vehicles[k].fullname = GetDisplayNameFromVehicleModel(v.model)
                            vehicles[k].model = string.lower(GetDisplayNameFromVehicleModel(v.model))
                        end
                    end

                    PhoneData.GarageVehicles = vehicles
                end)
            end)
        else

            ESX.ShowNotification(Lang('PHONE_DONT_HAVE'), 'error')

        end
    end)
end

function InPutLock()
    Citizen.CreateThread(function()
       while threadCreated do
        Citizen.Wait(5)
        DisableAllControlActions(0)
        EnableControlAction(0, 249, true)
        EnableControlAction(0, 32, true)
        EnableControlAction(0, 34, true)
        EnableControlAction(0, 31, true)
        EnableControlAction(0, 30, true)
        EnableControlAction(0, 59, true)
        EnableControlAction(0, 71, true)
        EnableControlAction(0, 72, true)
        EnableControlAction(0, 21, true)
        EnableControlAction(0, 22, true)
        EnableControlAction(0, 23, true)
        EnableControlAction(0, 75, true)
       end
    end)
end


RegisterNUICallback('SetupGarageVehicles', function(data, cb)

    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('Close', function(data)
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    TriggerEvent("status:togglePhone", false)
    deletePhone()
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId

    TriggerServerEvent('Unique_Phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('Unique_Phone:client:UpdateMails')
AddEventHandler('Unique_Phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('Unique_Phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('Unique_Phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number

    ESX.TriggerServerCallback('Unique_Phone:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetBankData', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetBankData', cb)
end)

-- EXPANSION: Security app — recent-devices list + force-logout-everywhere.
RegisterNUICallback('GetSecurityDevices', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetSecurityDevices', cb)
end)

-- EXPANSION: Job Manager (Services app, admin-only)
RegisterNUICallback('IsJobManagerAdmin', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:IsJobManagerAdmin', function(result)
        cb(result)
    end)
end)

RegisterNUICallback('SaveJob', function(data, cb)
    TriggerServerEvent('Unique_Phone:server:SaveJob', data)
    cb('ok')
end)

RegisterNUICallback('LogoutAllDevices', function(data, cb)
    TriggerServerEvent('Unique_Phone:server:LogoutAllDevices')
    cb('ok')
end)

RegisterNUICallback('RequestPasswordChangeOtp', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:RequestPasswordChangeOtp', function(result)
        cb(result)
    end, data.oldPassword)
end)

RegisterNUICallback('ConfirmPasswordChange', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:ConfirmPasswordChange', function(result)
        cb(result)
    end, data.code, data.newPassword)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType

    local Ped = PlayerPedId()
    local Pos = GetEntityCoords(Ped)
    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)

    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    ts = ts,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('Unique_Phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)

            if PhoneData.Chats[NumberKey].Unread ~= nil then
                PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
            else
                PhoneData.Chats[NumberKey].Unread = 1
            end

        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            elseif ChatType == "picture" then
                PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                    message = "Photo",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.identifier,
                    type = ChatType,
                    ts = ts,
                    data = {
                        url = data.url
                    },
                }
            end
            TriggerServerEvent('Unique_Phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)

            if PhoneData.Chats[NumberKey].Unread ~= nil then
                PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
            else
                PhoneData.Chats[NumberKey].Unread = 1
            end

        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = Lang("WHATSAPP_SHARED_LOCATION"),
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        elseif ChatType == "picture" then
            PhoneData.Chats[NumberKey].messages[ChatKey].messages[#PhoneData.Chats[NumberKey].messages[ChatKey].messages+1] = {
                message = "Photo",
                time = ChatTime,
                sender = PhoneData.PlayerData.identifier,
                type = ChatType,
                ts = ts,
                data = {
                    url = data.url
                },
            }
        end
        TriggerServerEvent('Unique_Phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

    end

    ESX.TriggerServerCallback('Unique_Phone:server:GetContactPicture', function(Chat)
        SendNUIMessage({
            action = "UpdateChat",
            chatData = Chat,
            chatNumber = ChatNumber,
        })
    end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])

end)

RegisterNUICallback('SendMessageToJobs', function(data, cb)
    local Pos = GetEntityCoords(PlayerPedId())
    Wait(50)
    TriggerServerEvent('Unique_Phone:server:SendJobMessage', data, Pos)
end)

RegisterNetEvent("PX_phone_Clieant:AddMessageOdther")
AddEventHandler('PX_phone_Clieant:AddMessageOdther', function(data, ssender, Save, SteamHex, Playerthen)
    ESX.TriggerServerCallback('PX_phone_Clieant:GetDataMSG', function(DaTa)
        local ChatMessage = data.ChatMessage
        local ChatDate = DaTa.date
        local ChatNumber = data.ChatNumber
        local ChatTime = DaTa.time
        local ChatType = data.ChatType
        local Ped = PlayerPedId()

        local NumberKey = GetKeyByNumber(ChatNumber)
        local ChatKey = GetKeyByDate(NumberKey, ChatDate)

        if PhoneData.Chats[NumberKey] ~= nil then

            if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = ssender,
                        type = ChatType,
                        data = {},
                    })
                end

                if Save then
                    TriggerServerEvent('Unique_Phone:server:UpdateMessagesOdther', SteamHex, PhoneData.Chats[NumberKey].messages, ChatNumber, false)
                end

                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)

                if PhoneData.Chats[NumberKey].Unread ~= nil then
                    PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
                else
                    PhoneData.Chats[NumberKey].Unread = 1
                end

            else
                table.insert(PhoneData.Chats[NumberKey].messages, {
                    date = ChatDate,
                    messages = {},
                })
                ChatKey = GetKeyByDate(NumberKey, ChatDate)
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = ssender,
                        type = ChatType,
                        data = {},
                    })
                end

                if Save then
                    TriggerServerEvent('Unique_Phone:server:UpdateMessagesOdther', SteamHex, PhoneData.Chats[NumberKey].messages, ChatNumber, true)
                end

                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)

                if PhoneData.Chats[NumberKey].Unread ~= nil then
                    PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
                else
                    PhoneData.Chats[NumberKey].Unread = 1
                end
            end
        else

            table.insert(PhoneData.Chats, {
                name = IsNumberInContacts(ChatNumber),
                number = ChatNumber,
                messages = {},
            })
            NumberKey = GetKeyByNumber(ChatNumber)
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = ssender,
                    type = ChatType,
                    data = {},
                })
            end

            if Save then
                TriggerServerEvent('Unique_Phone:server:UpdateMessagesOdther', SteamHex, PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            end

            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)

            if PhoneData.Chats[NumberKey].Unread ~= nil then
                PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
            else
                PhoneData.Chats[NumberKey].Unread = 1
            end

        end

        if Playerthen then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = ChatNumber,
                    content = Lang("WHATSAPP_MESSAGE_TOYOU"),
                    icon = "fab fa-whatsapp",
                    timeout = 6000,
                    color = "#007BFF",
                },
            })

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "whatsapp")

            exports['xsound']:PlayUrl("notification", "./sounds/notification.mp3", 0.3)
        end
    end)
end)

RegisterNetEvent("PX_phone_Clieant:AddMessagetoJobS")
AddEventHandler('PX_phone_Clieant:AddMessagetoJobS', function(data, ssender, Pos, Playerids)
    local ChatMessage = (ssender.." ("..Playerids..") : "..data.ChatMessage)
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType
    local Pos = Pos
    local Ped = PlayerPedId()

    local NumberKey = GetKeyByNumber(ChatNumber)
    local ChatKey = GetKeyByDate(NumberKey, ChatDate)

    if PhoneData.Chats[NumberKey] ~= nil then
        if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = ssender,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = ssender,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)

            if PhoneData.Chats[NumberKey].Unread ~= nil then
                PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
            else
                PhoneData.Chats[NumberKey].Unread = 1
            end

        else
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = ssender,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                    message = Lang("WHATSAPP_SHARED_LOCATION"),
                    time = ChatTime,
                    sender = ssender,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end

            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)

            if PhoneData.Chats[NumberKey].Unread ~= nil then
                PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
            else
                PhoneData.Chats[NumberKey].Unread = 1
            end

        end
    else
        table.insert(PhoneData.Chats, {
            name = IsNumberInContacts(ChatNumber),
            number = ChatNumber,
            messages = {},
        })
        NumberKey = GetKeyByNumber(ChatNumber)
        table.insert(PhoneData.Chats[NumberKey].messages, {
            date = ChatDate,
            messages = {},
        })
        ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if ChatType == "message" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = ChatMessage,
                time = ChatTime,
                sender = ssender,
                type = ChatType,
                data = {},
            })
        elseif ChatType == "location" then
            table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                message = Lang("WHATSAPP_SHARED_LOCATION"),
                time = ChatTime,
                sender = ssender,
                type = ChatType,
                data = {
                    x = Pos.x,
                    y = Pos.y,
                },
            })
        end

        NumberKey = GetKeyByNumber(ChatNumber)
        ReorganizeChats(NumberKey)

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end
    end

    local color = "#25D366"
    if ChatNumber == "Ambulance Deparment" then
        color = "#FF0000"
    elseif ChatNumber == "Police Deparment" then
        color = "#007BFF"
    elseif ChatNumber == "Sheriff Deparment" then
        color = "#FFA500"
    end

    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = ChatNumber,
            content = Lang("WHATSAPP_MESSAGE_TOYOU"),
            icon = "fab fa-whatsapp",
            timeout = 6000,
            color = color,
        },
    })

    Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "whatsapp")

    exports['xsound']:PlayUrl("notification", "./sounds/notification.mp3", 0.3)
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = Lang("WHATSAPP_TITLE"),
            text = Lang("WHATSAPP_LOCATION_SET"),
            icon = "fab fa-whatsapp",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

AddEventHandler("playerSpawned", function()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    Citizen.Wait(7000)

	if PlayerJob == nil then
        PlayerJob = {}
    end

    JobInfo = ESX.GetPlayerData().job

    LoadPhone()

    SendNUIMessage({
        action = "UpdateApplications",
        JobData = JobInfo,
        applications = Config.PhoneApplications
    })

end)

RegisterNetEvent('Unique_Phone:client:UpdateMessages', function(ChatMessages, SenderNumber ,date, trt)
    if FlyMode then return end
    local NumberKey = GetKeyByNumber(SenderNumber)
    local New = true
    for k , v in pairs(PhoneData.Chats) do
        if v.number == SenderNumber then
            New = false
        end
    end
    exports['xsound']:PlayUrl("notification", "./sounds/notification.mp3", 0.1)

    if New then
	    PhoneData.Chats[#PhoneData.Chats+1] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = {},
        }

        NumberKey = GetKeyByNumber(SenderNumber)

        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.phoneNumber then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 5000,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Messaged yourself",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            local chats = ESX.CopyTable(PhoneData.Chats)
            local chats2 = PhoneData.Chats
            for k, v in pairs(chats) do
                chats[k].messages = {}
            end
            ESX.TriggerServerCallback('Unique_Phone:server:GetContactPictures', function(Chats)
                for k, v in pairs(chats2) do
                    for k2, v2 in pairs(Chats) do
                        if v2.number == v.number then
                            v.picture = v2.picture
                        end
                    end
                end
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end, chats)
        else
	    SendNUIMessage({
	        action = "PhoneNotification",
	        PhoneNotify = {
		    title = "Whatsapp",
		    text = "New message from "..IsNumberInContacts(SenderNumber).."!",
		    icon = "fab fa-whatsapp",
		    color = "#25D366",
		    timeout = 3500,
	        },
	    })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.phoneNumber then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Messaged yourself",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            local chats = ESX.CopyTable(PhoneData.Chats)
            local chats2 = PhoneData.Chats
            for k, v in pairs(chats) do
                chats[k].messages = {}
            end
            ESX.TriggerServerCallback('Unique_Phone:server:GetContactPictures', function(Chats)
                for k, v in pairs(chats2) do
                    for k2, v2 in pairs(Chats) do
                        if v2.number == v.number then
                            v.picture = v2.picture
                        end
                    end
                end
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end, chats)
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Whatsapp",
                    text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                    icon = "fab fa-whatsapp",
                    color = "#25D366",
                    timeout = 3500,
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
    if trt then
        LoadPhone()
    end
end)

RegisterNetEvent("Unique_Phone:client:BankNotify")
AddEventHandler("Unique_Phone:client:BankNotify", function(text)
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = Lang("BANK_TITLE"),
            content = text,
            icon = "fas fa-university",
            timeout = 3500,
            color = "#ff002f",
        },
    })
end)

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "updateTweets",
                tweets = PhoneData.Tweets,
                selfTweets = PhoneData.SelfTweets,
            })
        end
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('Unique_Phone:client:NewMailNotify')
AddEventHandler('Unique_Phone:client:NewMailNotify', function(MailData)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("MAIL_TITLE"),
                text = Lang("MAIL_NEW") .. " " .. MailData.sender,
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("MAIL_TITLE"),
                content = Lang("MAIL_NEW") .. " " .. MailData.sender,
                icon = "fas fa-envelope",
                timeout = 3500,
                color = "#ff002f",
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('Unique_Phone:server:AddAdvert', data.message)
end)

RegisterNUICallback('GetIranianDateTime', function(daaa, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetDateTime', function(date, time)

        cb({
            dateString = date,
            timeString = time
        })
    end)
end)

RegisterNetEvent('Unique_Phone:client:UpdateAdverts')
AddEventHandler('Unique_Phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("ADVERTISEMENT_TITLE"),
                text = Lang("ADVERTISEMENT_NEW") .. " " .. LastAd,
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("ADVERTISEMENT_TITLE"),
                content = Lang("ADVERTISEMENT_NEW") .. " " .. LastAd,
                icon = "fas fa-ad",
                timeout = 2500,
                color = "#ff8f1a",
            },
        })
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    print(chat)
    local ChatKey = GetKeyByNumber(chat)
    print(json.encode(PhoneData.Chats[ChatKey].Unread))
    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    ESX.TriggerServerCallback('Unique_Phone:server:CanPayInvoice', function(CanPay)
        if CanPay then
            PayInvoice(cb,invoiceId)
        else
            cb(false)
        end
    end, amount)
end)

function PayInvoice(cb,invoiceId)
    cb(true)
    ESX.TriggerServerCallback('esx_billing:payBill', function()
        ESX.TriggerServerCallback('Unique_Phone:server:GetInvoices', function(Invoices)
            PhoneData.Invoices = Invoices
        end)
    end, invoiceId)
end

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    ESX.TriggerServerCallback('Unique_Phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('Unique_Phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('Unique_Phone:client:UpdateHashtags')
AddEventHandler('Unique_Phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

local function getIndex(tab, val)
    local index = nil
    for i, v in ipairs (tab) do
        if (v.id == val) then
          index = i
        end
    end
    return index
end

RegisterNUICallback('isInHomePage', function(data, cb)

end)

RegisterNUICallback('DeleteTweet', function(data, cb)
    TriggerServerEvent("Unique_Phone:deleteTweet", data.id)
    local idx = getIndex(PhoneData.SelfTweets, data.id)
    local idx2 = getIndex(PhoneData.Tweets, data.id)

    table.remove(PhoneData.SelfTweets,idx)
    table.remove(PhoneData.Tweets,idx2)
    TriggerServerEvent('Unique_Phone:server:updateForEveryone', PhoneData.Tweets)
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)

end)

RegisterNUICallback('GetSelfTweets', function(data, cb)
    cb(PhoneData.SelfTweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    TriggerServerEvent('Unique_Phone:server:SaveMetaData', 'profilepicture', pf)
end)
local test

local patt = "[?!@#]"

RegisterNetEvent("Unique_Phone:updateForEveryone")
AddEventHandler("Unique_Phone:updateForEveryone", function(newTweet)
    PhoneData.Tweets = newTweet
end)

RegisterNetEvent("Unique_Phone:updateidForEveryone")
AddEventHandler("Unique_Phone:updateidForEveryone", function()
    PhoneData.id  = PhoneData.id + 1
end)

RegisterNUICallback('PostNewTweet', function(data, cb)

    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = data.Message,
        url = test or "",
        time = data.Date,
        id =  PhoneData.id,
        picture = data.Picture
    }
    test = ""
    TriggerServerEvent("Unique_Phone:saveTwitterToDatabase", TweetMessage.firstName, TweetMessage.lastName, TweetMessage.message, TweetMessage.url, TweetMessage.time, TweetMessage.picture)
   TriggerServerEvent("Unique_Phone:server:updateidForEveryone")
    local TwitterMessage = data.Message
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local InvalidSymbol = string.match(Handle, patt)
            if InvalidSymbol then
                Handle = Handle:gsub("%"..InvalidSymbol, "")
            end
            TriggerServerEvent('Unique_Phone:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('Unique_Phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                else
                    SetTimeout(2500, function()
                        SendNUIMessage({
                            action = "PhoneNotification",
                            PhoneNotify = {
                                title = Lang("TWITTER_TITLE"),
                                text = Lang("MENTION_YOURSELF"),
                                icon = "fab fa-twitter",
                                color = "#1DA1F2",
                            },
                        })
                    end)
                end
            end
        end
    end
    Citizen.Wait(1000)

    table.insert(PhoneData.Tweets, TweetMessage)
    table.insert(PhoneData.SelfTweets, TweetMessage)
    TriggerServerEvent('Unique_Phone:server:updateForEveryone', PhoneData.Tweets)
    cb(PhoneData.Tweets)
    TriggerServerEvent('Unique_Phone:server:UpdateTweets', TweetMessage)
    SendNUIMessage({
        action= "updateTest",
        selftTweets= PhoneData.SelfTweets
    })
end)

RegisterNetEvent('Unique_Phone:client:TransferMoney')
AddEventHandler('Unique_Phone:client:TransferMoney', function(amount, newmoney)
    if PhoneData.isOpen then
        SendNUIMessage({ action = "UpdateBank", NewBalance = newmoney })
    end
end)

RegisterNetEvent('Unique_Phone:client:UpdateTweets')
AddEventHandler('Unique_Phone:client:UpdateTweets', function(src, NewTweetData)
    local MyPlayerId = PhoneData.PlayerData.source

    if src ~= MyPlayerId then
        if not PhoneData.isOpen then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = Lang("TWITTER_NEW") .. " (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")",
                    content = NewTweetData.message,
                    icon = "fab fa-twitter",
                    timeout = 3500,
                    color = nil,
                },
            })
        else
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = Lang("TWITTER_NEW") .. " (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")",
                    text = NewTweetData.message,
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
        end
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("TWITTER_TITLE"),
                text = Lang("TWITTER_POSTED"),
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('Unique_Phone:client:GetMentioned')
AddEventHandler('Unique_Phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({ action = "Notification", NotifyData = { title = Lang("TWITTER_GETMENTIONED"), content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, }, })
    else
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = Lang("TWITTER_GETMENTIONED"), text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = TweetMessage.message, time = TweetMessage.time, picture = TweetMessage.picture}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, callback)
    local cb = callback
    local amount = tonumber(data.amount)

    ESX.TriggerServerCallback('Unique_Phone:server:GetBankData', function(bankdata)
        if tonumber(bankdata.bank) >= amount then
            local amaountata = tonumber(bankdata.bank) - amount
            TriggerServerEvent('Unique_Phone:server:TransferMoney', data.iban, amount)
            local cbdata = {
                CanTransfer = true,
                NewAmount = amaountata
            }
            cb(cbdata)
        else
            local cbdata = {
                CanTransfer = false,
                NewAmount = nil,
            }
            cb(cbdata)
        end
    end)
end)

RegisterNUICallback('CallContact', function(data, cb)

    ESX.TriggerServerCallback('Unique_Phone:server:GetCallState', function(CanCall, IsOnline)
        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous, false)

        end
    end, data.ContactData.number)
end)

RegisterNUICallback('CallContactJobs', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetCallState', function(CanCall, IsOnline)

        if not PhoneData.isOpen then
            OpenPhone()
        end
        Wait(1000)

        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }

        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous, false)

        end
    end, data.ContactData.number)
end)

RegisterNUICallback('CallContactAdmins', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetCallStateAdmin', function(CanCall, IsOnline)

        if not PhoneData.isOpen then
            OpenPhone()
        end
        Wait(1000)

        local status = {
            CanCall = CanCall,
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }

        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous, true)

        end
    end, data.ContactData.id)
end)

RegisterNetEvent("Unique_Phone:Cleant:CallNumberr")
AddEventHandler("Unique_Phone:Cleant:CallNumberr", function(ID)
    ESX.TriggerServerCallback('Unique_Phone:Server:GetPhoneNumber', function(number, namee)
        if number then
            SendNUIMessage({
                action      = "calltojobs",
                PhoneNumber = tostring(number),
                name        = namee,
                id          = ID
            })
        end
    end, ID)
end)

function SendCallAdmin(ID)
    ESX.TriggerServerCallback('Unique_Phone:Server:GetPhoneNumber', function(number, namee)
        if number then
            SendNUIMessage({
                action      = "calltoAdmin",
                PhoneNumber = tostring(number),
                name        = namee,
                id          = ID
            })
        end
    end, ID)
end

RegisterCommand("acall", function(source, args)
    if ESX.GetPlayerData().perm >= 1 then
        SendCallAdmin(tonumber(args[1]))
    end
end)

RegisterNUICallback("Unique_Phone:RequestToJobs", function(data, cb)
    if data.contactData == "mechanic" then
        cb(true)
        MechanicRequests()
        Wait(1000)
        lib.showMenu('mechaic_menu')
    elseif data.contactData == "taxi" then
        cb(true)
        TaxiRequests()
        Wait(1000)
        lib.showMenu('taxi_menu')
    else
        cb(false)
    end
end)

local inputox = nil

function MechanicRequests()
    local options = {}
    ESX.TriggerServerCallback('esx_mechanicjob:ChekRequest', function(ChekReq)
        ESX.TriggerServerCallback("esx_mechanicjob:GetAccepterID", function(ID)

            if ChekReq then
                table.insert(options, {label = '🛠️ Ersal Darkhast', args = {value = 'Send_request'}})
            else
                if ID then
                    table.insert(options,  {label = '📞 Call', args = {value = 'call'}})
                end
                table.insert(options,  {label = '❌ Cancel', args = {value = 'cancel'}})
            end
            Wait(100)
            lib.registerMenu({
                id = 'mechaic_menu',
                title = 'Send Request Mechanic',
                position = 'top-right',
                options = options
            }, function(selected, scrollIndex, args)
                if args.value == "Send_request" then
                    TriggerServerEvent('esx_mechanicjob:addreq', "I Need Mechanic (Phone)")
                    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[System]", "Darkhast Shoma Be Mechanic ^2Ersal ^0Shod!"}})
                elseif args.value == "cancel" then
                    TriggerServerEvent("esx_mechanincjob:CloseRequest", GetPlayerServerId(PlayerId()))
                    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[System]", "Darkhast Mechanic Shoma ^1Baste ^0Shod!"}})
                elseif args.value == "call" then
                    TriggerEvent('Unique_Phone:Cleant:CallNumberr', ID)
                end
                options = {}
            end)
            ESX.UI.Menu.CloseAll()
        end)
    end)
end

function TaxiRequests()
    local options2 = {}

    ESX.TriggerServerCallback('esx_taxijob:ChekRequest', function(ChekReq)
        ESX.TriggerServerCallback("esx_taxijob:GetAccepterID", function(ID)

            if ChekReq then
                table.insert(options2, {label = '🚖 Ersal Darkhast', args = {value = 'Send_request'}})
            else
                if ID then
                    table.insert(options2,  {label = '📞 Call', args = {value = 'call'}})
                end
                table.insert(options2,  {label = '❌ Cancel', args = {value = 'cancel'}})
            end

            lib.registerMenu({
                id = 'taxi_menu',
                title = 'Send Request Taxi',
                position = 'top-right',
                options = options2
            }, function(selected, scrollIndex, args)
                if args.value == "Send_request" then
                    TriggerServerEvent('esx_taxijob:addreq', "I Need Taxi (Phone)")
                    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[System]", "Darkhast Shoma Be Taxi ^2Ersal ^0Shod!"}})
                elseif args.value == "cancel" then

                    TriggerServerEvent("esx_taxijob:CloseRequest", GetPlayerServerId(PlayerId()))
                    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[System]", "Darkhast Taxi Shoma ^1Baste ^0Shod!"}})
                elseif args.value == "call" then
                    TriggerEvent('Unique_Phone:Cleant:CallNumberr', ID)
                end
                options2 = {}
            end)
            ESX.UI.Menu.CloseAll()
        end)
    end)
end

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall, Admins)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)



    TriggerServerEvent('Unique_Phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall, Admins)
    TriggerServerEvent('Unique_Phone:server:SetCallState', true)
    exports['xsound']:PlayUrl("phonecall", "./sounds/phonecall.ogg", 0.5, true)
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1

                else
                    exports['xsound']:Destroy("phonecall")
                    exports['xsound']:PlayUrl("phonecall", "./sounds/regect.mp3", 0.5)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                exports['xsound']:Destroy("phonecall")
                exports['xsound']:PlayUrl("phonecall", "./sounds/regect.mp3", 0.5)
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('Unique_Phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        if Config.Tokovoip then
            exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
        else
            exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
        end
    end

    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('Unique_Phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone-volume",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone-volume",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('Unique_Phone:client:CancelCall')
AddEventHandler('Unique_Phone:client:CancelCall', function()
    exports['xsound']:Destroy("zangkhor")
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        if Config.Tokovoip then
        exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
        else
            exports['pma-voice']:removePlayerFromCall(PhoneData.CallData.CallId)
        end

    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('Unique_Phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone-volume",
                timeout = 3500,
                color = "#e84118",
            },
        })
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_CALL_END"),
                icon = "fas fa-phone-volume",
                color = "#e84118",
            },
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('Unique_Phone:client:GetCalled')
AddEventHandler('Unique_Phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    if FlyMode then return end
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }

    if AnonymousCall then
        CallData.name = "Anoniem"
    end

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('Unique_Phone:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })
    exports['xsound']:PlayUrl("zangkhor", "./sounds/zangkhor.mp3", 0.5,true)
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1


                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('Unique_Phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('Unique_Phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('Unique_Phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
    exports['xsound']:Destroy("zangkhor")
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
    exports['xsound']:Destroy("zangkhor")
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
    exports['xsound']:Destroy("zangkhor")
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
    exports['xsound']:Destroy("zangkhor")
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('Unique_Phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('Unique_Phone:server:AnswerCall', PhoneData.CallData)
    if Config.Tokovoip then
        exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Phone')
    else
        exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
        exports['xsound']:Destroy("phonecall")
    end
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_NOINCOMING"),
                icon = "fas fa-phone-volume",
                color = "#e84118",
            },
        })
    end
end

RegisterNetEvent('Unique_Phone:client:AnswerCall')
AddEventHandler('Unique_Phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('Unique_Phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)
        if Config.Tokovoip then
            exports.tokovoip_script:addPlayerToRadio(PhoneData.CallData.CallId, 'Phone')
        else
            exports['pma-voice']:addPlayerToCall(PhoneData.CallData.CallId)
            exports['xsound']:Destroy("phonecall")
        end
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("PHONE_NOINCOMING"),
                icon = "fas fa-phone-volume",
                color = "#e84118",
            },
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
     if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        TriggerEvent("status:togglePhone", false)
     end
end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetVehicleSearchResults', function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                result[k].isFlagged = false
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = ESX.Game.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)

    ESX.TriggerServerCallback('Unique_Phone:server:ScanPlate', function(result)
        result.isFlagged = false
        result.label = model
        cb(result)
    end, plate)
end)

RegisterNetEvent('Unique_Phone:client:addPoliceAlert')
AddEventHandler('Unique_Phone:client:addPoliceAlert', function(alertData)
    if PlayerJob.name == 'police' or PlayerJob.name == 'sheriff' or PlayerJob.name == 'mt' or PlayerJob.name == 'fbi' or PlayerJob.name == 'cid' or PlayerJob.name == 'cia' or PlayerJob.name == 'marshal' or PlayerJob.name == 'judge' or PlayerJob.name == 'doa' then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    TriggerEvent('esx:showNotification', Lang("GPS_SET") .. data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

RegisterNetEvent('Unique_Phone:client:GiveContactDetails')
AddEventHandler('Unique_Phone:client:GiveContactDetails', function()
    local ped = PlayerPedId()

    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('Unique_Phone:server:GiveContactDetails', PlayerId)
        ESX.ShowNotification("Shomareye Shoma Be Fard Nazdik Shoma Give Shod", 'success')
    else

        ESX.ShowNotification(Lang("NO_ONE"), 'error')
    end
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = Lang("PHONE_TITLE"),
                        text = Lang("CONTACTS_REMOVED"),
                        icon = "fas fa-phone-volume",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "Notification",
                    NotifyData = {
                        title = Lang("PHONE_TITLE"),
                        content = Lang("CONTACTS_REMOVED"),
                        icon = "fas fa-phone-volume",
                        timeout = 3500,
                        color = "#04b543",
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('Unique_Phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('Unique_Phone:client:AddNewSuggestion')
AddEventHandler('Unique_Phone:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("PHONE_TITLE"),
                text = Lang("CONTACTS_NEWSUGGESTED"),
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("PHONE_TITLE"),
                content = Lang("CONTACTS_NEWSUGGESTED"),
                icon = "fa fa-phone-alt",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end

    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('Unique_Phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    ESX.TriggerServerCallback('PX_crypto:server:GetCryptoData', function(CryptoData)
        cb(CryptoData)
    end, data.crypto)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    ESX.TriggerServerCallback('PX_crypto:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    ESX.TriggerServerCallback('PX_crypto:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    ESX.TriggerServerCallback('PX_crypto:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNetEvent('Unique_Phone:client:RemoveBankMoney')
AddEventHandler('Unique_Phone:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("BANK_TITLE"),
                text = "There is Γé¼"..amount.." withdraw from your bank!",
                icon = "fas fa-university",
                color = "#ff002f",
                timeout = 3500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("BANK_TITLE"),
                content = "There is Γé¼"..amount.." withdraw from your bank!",
                icon = "fas fa-university",
                timeout = 3500,
                color = "#ff002f",
            },
        })
    end
end)

RegisterNetEvent('Unique_Phone:client:AddTransaction')
AddEventHandler('Unique_Phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }

    table.insert(PhoneData.CryptoTransactions, Data)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = Lang("CRYPTO_TITLE"),
                text = Message,
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = Lang("CRYPTO_TITLE"),
                content = Message,
                icon = "fas fa-chart-pie",
                timeout = 3500,
                color = "#04b543",
            },
        })
    end

    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('Unique_Phone:server:AddTransaction', Data)
end)

RegisterNUICallback('GetCryptoTransactions', function(data, cb)
    local Data = {
        CryptoTransactions = PhoneData.CryptoTransactions
    }
    cb(Data)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('PX_lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('PX_lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('PX_lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('Unique_Phone:client:UpdateLapraces')
AddEventHandler('Unique_Phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('PX_lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['PX_lapraces']:IsInRace()

    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:IsAuthorizedToCreateRaces', function(NameAvailable)
        local data = {
            IsAuthorized = true,
            IsBusy = exports['PX_lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('PX_lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:GetRacingData', function(RaceData)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)

        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('PX_lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            TriggerEvent('esx:showNotification', 'You are too far from the race. Your navigation is set to the race.')
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['PX_lapraces']:IsInEditor())
    else
        cb(exports['PX_lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    ESX.TriggerServerCallback('PX_lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('PX_houses:server:removeHouseKey', data.HouseData.name, {
        identifier = data.HolderData.identifier,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = PlayerPedId()

    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerEvent('esx:showNotification', 'GPS is set!')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    TriggerEvent('esx:showNotification', 'GPS is set!')
end)

RegisterNUICallback('GetCurrentpolices', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetCurrentpolices', function(polices)
        cb(polices)
    end)

end)

Lang = function(item)
    local lang = Config.Languages[Config.Language]

    if lang and lang[item] then
        return lang[item]
    end

    return item
end

RegisterNUICallback('GetLangData', function(data, cb)
    cb({ table = Config.Languages, current = Config.Language })
end)

RegisterNUICallback('DeleteImage', function(image,cb)
    TriggerServerEvent('Unique_Phone:server:RemoveImageFromGallery',image)
    Wait(1000)
    TriggerServerEvent('Unique_Phone:server:getImageFromGallery')
    cb(true)
end)

RegisterNUICallback("TakePhoto", function(data,cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    CreateMobilePhone(4)
    CellCamActivate(true, true)
    takePhoto = true
    while takePhoto do
        if IsControlJustPressed(1, 27) then
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then
            DestroyMobilePhone()
            CellCamActivate(false, false)
            cb(json.encode({ url = nil }))
            takePhoto = false
            frontCam = false
            CellFrontCamActivate(frontCam)
            break
        elseif IsControlJustPressed(1, 176) then
            if Config.webhooksscreenshot then
                Citizen.SetTimeout(500,function()
                    frontCam = false
                    CellFrontCamActivate(frontCam)
                    DestroyMobilePhone()
                    CellCamActivate(false, false)
                end)
                -- pcall guard: if screenshot-basic is missing/broken (no
                -- requestScreenshotUpload export), calling it directly
                -- throws immediately and this whole NUI callback aborts
                -- right there - cb() never fires, and the phone UI is left
                -- waiting forever for a response. Catching it lets us tell
                -- the player and still resolve the callback cleanly.
                local ok, err = pcall(function()
                    exports['screenshot-basic']:requestScreenshotUpload(tostring(Config.webhooksscreenshot), "files[]", function(data)
                        local image = json.decode(data)
                        TriggerServerEvent('Unique_Phone:server:addImageToGallery', image.attachments[1].proxy_url)
                        Wait(1000)
                        TriggerServerEvent('Unique_Phone:server:getImageFromGallery')
                        cb(json.encode(image.attachments[1].proxy_url))
                    end)
                end)
                if not ok then
                    print("[Unique_Phone] screenshot-basic export call failed: " .. tostring(err))
                    TriggerEvent('esx:showNotification', "~r~Camera is unavailable right now (screenshot-basic error)")
                    cb(json.encode({ url = nil }))
                end
            end

            takePhoto = false
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        EnableAllControlActions(0)
        Wait(0)
    end
    Wait(1000)
    OpenPhone()
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetTimeout(500, function()
        PhoneData.isOpen = false
    end)
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNUICallback('GetGalleryData', function(data, cb)
    local data = PhoneData.Images
    cb(data)
end)

RegisterNetEvent('Unique_Phone:client:refreshImages', function(images)

    PhoneData.Images = images
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    ESX.TriggerServerCallback('Unique_Phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('SetFlyMode', function(data)
    FlyMode = data.toggle
end)

RegisterNUICallback('Delete_Message', function(data, cb)
    TriggerServerEvent('Unique_Phone:Delete_Message', data.phone_number)
    local ChatNumberK = GetKeyByNumber(data.phone_number)
    PhoneData.Chats[ChatNumberK] = nil
end)