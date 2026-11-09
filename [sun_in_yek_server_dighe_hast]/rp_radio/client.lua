-- Dumper By Owl Team , discord.gg/owwl

ESX = exports['essentialmode']:getObject()
PlayerData = {} 
RadioBusy = false
local spam = false

Citizen.CreateThread(function()

    while not ESX do
        Wait(1000)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(1000)
    end

    PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('radio:getFreq',function(data)
        for k, v in pairs(data) do
            frqaccess[tonumber(k)] = v
        end
    end)
    Checks()
end)

RegisterNetEvent("rp_radio:recieveMessage")
AddEventHandler("rp_radio:recieveMessage", function(details)
    if radioConfig.Frequency.Current == details.freq then
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[RADIO]", "^0[^3" .. details.id .. "^0] => " .. details.message}}, 'alarms')
    end
end)

RegisterNetEvent("radio:getFreq", function(data)
    for k, v in pairs(data) do
        frqaccess[k] = v
    end
end)

AddEventHandler('onClientMapStart', function()
    NetworkSetTalkerProximity(2.5)
end)

local Radio = {
    Has = true,
    Open = false,
    On = false,
    Enabled = true,
    Handle = nil,
    Prop = `prop_cs_hand_radio`,
    Bone = 28422,
    Offset = vector3(0.0, 0.0, 0.0),
    Rotation = vector3(0.0, 0.0, 0.0),
    Dictionary = {
        "cellphone@",
        "cellphone@in_car@ds",
        "cellphone@str",    
        "random@arrests",  
    },
    Animation = {
        "cellphone_text_in",
        "cellphone_text_out",
        "cellphone_call_listen_a",
        "generic_radio_chatter",
    },
    Clicks = true, -- Radio clicks
}
Radio.Labels = {        
    { "FRZL_RADIO_HELP", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" .. radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " to hide.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ to turn radio ~g~on~s~.~n~~" .. radioConfig.Controls.Input.Name .. "~ to choose frequency~n~~" .. radioConfig.Controls.ToggleClicks.Name .. "~ to ~a~ mic clicks~n~Frequency: ~1~ MHz" },
    { "FRZL_RADIO_HELP2", "~s~" .. (radioConfig.Controls.Secondary.Enabled and "~" ..  radioConfig.Controls.Activator.Name .. "~" or "~" .. radioConfig.Controls.Activator.Name .. "~") .. " to hide.~n~~" .. radioConfig.Controls.Toggle.Name .. "~ to turn radio ~r~off~s~.~n~~" .. radioConfig.Controls.Broadcast.Name .. "~ to broadcast.~n~Frequency: ~1~ MHz" },
    { "FRZL_RADIO_INPUT", "Freqans Radio ra vared konid" },
}
Radio.Commands = {
    -- {
    --     Enabled = true, -- Add a command to be able to open/close the radio
    --     Name = "radio", -- Command name
    --     Help = "Toggle hand radio", -- Command help shown in chatbox when typing the command
    --     Params = {},
    --     Handler = function(src, args, raw)
    --         local playerPed = PlayerPedId()
    --         local isFalling = IsPedFalling(playerPed)
    --         local isDead = IsEntityDead(playerPed)

    --         if not isFalling and Radio.Enabled and Radio.Has and not isDead then
    --             Radio:Toggle(not Radio.Open)
    --         elseif (Radio.Open or Radio.On) and ((not Radio.Enabled) or (not Radio.Has) or isDead) then
    --             Radio:Toggle(false)
    --             Radio.On = false
    --             Radio:Remove()
    --             exports["mumble_voip"]:SetMumbleProperty("radioEnabled", false)
    --         elseif Radio.Open and isFalling then
    --             Radio:Toggle(false)
    --         end            
    --     end,
    -- },
    {
        Enabled = true, -- Add a command to choose radio frequency
        Name = "freq", -- Command name
        Help = "Avaz kardan freqans radio", -- Command help shown in chatbox when typing the command
        Params = {
            {name = "number", "Freq radio ra vared konid"}
        },
        Handler = function(src, args, raw)
            if Radio.Has then
                if not Radio.On then
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Radio Shoma ^2Khamoush ^0Ast "}}, 'plarms')
                    return
                end

                if args[1] then
                    local newFrequency = tonumber(args[1])
                    if newFrequency then
                        SetFrq(newFrequency)
                    else
                        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat ^2freq ^0 faghat mitavanid ^1adad ^0 vared konid!"}}, 'plarms')
                    end
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat ^2freq ^0 chizi vared nakardid!"}}, 'plarms')
                end                    
            end
        end,
    },
    {
        Enabled = true, -- Add a command to choose radio frequency
        Name = "myfreq", -- Command name
        Help = "Didan freq radio", -- Command help shown in chatbox when typing the command
        Params = {

        },
        Handler = function(src, args, raw)
            if Radio.Has then
                if not Radio.On then
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Radio shoma ^2roshan ^0nist!"}}, 'plarms')
                    return
                end

                if radioConfig.Frequency.Current then
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Freq radio shoma: ^2" .. radioConfig.Frequency.Current}}, 'plarms')
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Radio shoma hich ^2freqi ^0nadarad!"}}, 'plarms')
                end
                
                     
            end
        end,
    },
    --[[{
        Enabled = true, -- Add a command to choose radio frequency
        Name = "rmute", -- Command name
        Help = "Mute kardan click haye radio", -- Command help shown in chatbox when typing the command
        Params = {
            {name = "state", "true/false"}
        },
        Handler = function(src, args, raw)
            if Radio.Has then
                if not Radio.On then
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Radio shoma ^2roshan ^0nist!"}}, 'plarms')
                    return
                end

                if args[1] then
                    if string.lower(args[1]) == "true" then
                       -- exports["mumble_voip"]:MuteRadioClick(true)
                        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma ba movafaghiat Radio Click khod ra ^1mute ^0kardid!"}}, 'plarms')
                    elseif string.lower(args[1]) == "false" then
                       -- exports["mumble_voip"]:MuteRadioClick(false)
                        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma ba movafaghiat Radio Click khod ra ^2unmute ^0kardid!"}}, 'plarms')
                    else
                        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat satate ^2mute ^0 faghat mitavanid ^1true ya false ^0 vared konid!"}}, 'plarms')
                    end
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar state ^2mute ^0 chizi vared nakardid!"}}, 'plarms')
                end
                     
            end
        end,
    }]]
}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)


-- Setup each radio command if enabled
for i = 1, #Radio.Commands do
    if Radio.Commands[i].Enabled then
        RegisterCommand(Radio.Commands[i].Name, Radio.Commands[i].Handler, false)
        TriggerEvent('chat:removeSuggestion', "/" .. Radio.Commands[i].Name)
        TriggerEvent("chat:addSuggestion", "/" .. Radio.Commands[i].Name, Radio.Commands[i].Help, Radio.Commands[i].Params)
    end
end

-- Create/Destroy handheld radio object
function Radio:Toggle(toggle)
	exports["pma-voice"]:resethud()
    local playerPed = PlayerPedId()
    local count = 0

    if not self.Has or IsEntityDead(playerPed) then
        self.Open = false

        NetworkRequestControlOfEntity(self.Handle)

		while not NetworkHasControlOfEntity(self.Handle) and count < 5000 do
            Citizen.Wait(0)
            count = count + 1
        end
        
        DetachEntity(self.Handle, true, false)
        DeleteEntity(self.Handle)
        
        return
    end

    if self.Open == toggle then
        return
    end

    self.Open = toggle

    if self.On and not radioConfig.AllowRadioWhenClosed then
        exports["pma-voice"]:setVoiceProperty("radioEnabled", toggle)
    end

    local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
    local animationType = 1 + (self.Open and 0 or 1)
    local dictionary = self.Dictionary[dictionaryType]
    local animation = self.Animation[animationType]

    RequestAnimDict(dictionary)

    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(150)
    end

    if self.Open then
        Citizen.CreateThread(function()
            while self.Open do
                Citizen.Wait(0)
                -- Init local vars
                local playerPed = PlayerPedId()
                local isActivatorPressed = IsControlJustPressed(0, radioConfig.Controls.Activator.Key)
                local isSecondaryPressed = (radioConfig.Controls.Secondary.Enabled and IsControlPressed(0, radioConfig.Controls.Secondary.Key) or true)
                local isFalling = IsPedFalling(playerPed)
                local isDead = IsEntityDead(playerPed)
                local minFrequency = radioConfig.Frequency.List[1]
                local broadcastType = 3 + (radioConfig.AllowRadioWhenClosed and 1 or 0) + ((Radio.Open and radioConfig.AllowRadioWhenClosed) and -1 or 0)
                local broadcastDictionary
                local broadcastAnimation
                local isBroadcasting = IsControlPressed(0, radioConfig.Controls.Broadcast.Key)
                local isPlayingBroadcastAnim = IsEntityPlayingAnim(playerPed, broadcastDictionary, broadcastAnimation, 3)
                
                -- Remove player from private frequency that they don't have access to
        
                -- Check if player is holding radio
                if Radio.Open then
                    local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
                    local openDictionary = Radio.Dictionary[dictionaryType]
                    local openAnimation = Radio.Animation[1]
                    local isPlayingOpenAnim = IsEntityPlayingAnim(playerPed, openDictionary, openAnimation, 3)
                    local hasWeapon, currentWeapon = GetCurrentPedWeapon(playerPed, 1)
        
                    -- Remove weapon in hand as we are using the radio
                    if currentWeapon ~= "WEAPON_UNARMED" then
                        SetCurrentPedWeapon(playerPed, "WEPON_UNARMED", true)
                    end
        
                    -- Display help text
                    BeginTextCommandDisplayHelp(Radio.Labels[Radio.On and 2 or 1][1])
        
                    if not Radio.On then
                        AddTextComponentSubstringPlayerName(Radio.Clicks and "~r~disable~w~" or "~g~enable~w~")
                    end
        
                    AddTextComponentInteger(radioConfig.Frequency.Current)
                    EndTextCommandDisplayHelp(false, false, false, -1)
        
                    -- Turn radio on/off
                    if IsControlJustPressed(0, radioConfig.Controls.Toggle.Key) then
                        if (PlayerData.job.name == 'nojob' or ESX.basicJobs[PlayerData.job.name]) and PlayerData.gang.name == 'nogang' then
                            return ESX.chatMessage('Shoma nemitavanid az radio estefade konid', 'plarms')
                        end
                        if ESX.checkCooldown('radio', 3000) then
                            Radio.On = not Radio.On
        
                            exports["pma-voice"]:setVoiceProperty("radioEnabled", Radio.On)
                            exports["pma-voice"]:resethud()
                            if Radio.On then
                                exports.xsound:PlayUrl('radio_on', './sounds/radio_on.ogg', 0.3, false)
                                Radio:Add(radioConfig.Frequency.Current)
                            else
                                exports.xsound:PlayUrl('radio_off', './sounds/radio_off.ogg', 0.5, false)
                                Radio:Remove()
                            end
                        else
                            ESX.ShowNotification("~r~Spam nakonid")
                        end
                    end
        
                    -- Change radio frequency
                    if not Radio.On then
                        DisableControlAction(0, radioConfig.Controls.ToggleClicks.Key, false)
        
                        if not radioConfig.Controls.Decrease.Pressed then
                            if IsControlJustPressed(0, radioConfig.Controls.Decrease.Key) then
                                radioConfig.Controls.Decrease.Pressed = true
                                Citizen.CreateThread(function()
                                    while IsControlPressed(0, radioConfig.Controls.Decrease.Key) do
                                        Radio:Decrease()
                                        Citizen.Wait(125)
                                    end
        
                                    radioConfig.Controls.Decrease.Pressed = false
                                end)
                            end
                        end
        
                        if not radioConfig.Controls.Increase.Pressed then
                            if IsControlJustPressed(0, radioConfig.Controls.Increase.Key) then
                                radioConfig.Controls.Increase.Pressed = true
                                Citizen.CreateThread(function()
                                    while IsControlPressed(0, radioConfig.Controls.Increase.Key) do
                                        Radio:Increase()
                                        Citizen.Wait(125)
                                    end
        
                                    radioConfig.Controls.Increase.Pressed = false
                                end)
                            end
                        end
        
                        if not radioConfig.Controls.Input.Pressed then
                            if IsControlJustPressed(0, radioConfig.Controls.Input.Key) then
                                radioConfig.Controls.Input.Pressed = true
                                Citizen.CreateThread(function()
                                    DisplayOnscreenKeyboard(1, Radio.Labels[3][1], "", radioConfig.Frequency.Current, "", "", "", 3)
        
                                    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                        Citizen.Wait(150)
                                    end
        
                                    local input = nil
        
                                    if UpdateOnscreenKeyboard() ~= 2 then
                                        input = GetOnscreenKeyboardResult()
                                    end
        
                                    Citizen.Wait(500)
                                    
                                    input = tonumber(input)
        
                                    if input ~= nil then
                                        SetFrq(input)
                                    end
                                    
                                    radioConfig.Controls.Input.Pressed = false
                                end)
                            end
                        end
                        
                        -- Turn radio mic clicks on/off
                        if IsDisabledControlJustPressed(0, radioConfig.Controls.ToggleClicks.Key) then
                            Radio.Clicks = not Radio.Clicks

                            exports.xsound:PlayUrl('radio_click', './sounds/radio_off.ogg', 0.5, false)

                            exports["pma-voice"]:setVoiceProperty("micClicks", Radio.Clicks)
                        end
                    end
            end
            end
        end)
        RequestModel(self.Prop)

        while not HasModelLoaded(self.Prop) do
            Citizen.Wait(150)
        end

        ESX.Game.SpawnObject(self.Prop, {
            x = x,
            y = y,
            z = z
        }, function(obj)
        self.Handle = obj
        local bone = GetPedBoneIndex(playerPed, self.Bone)
        SetCurrentPedWeapon(playerPed, "WEAPON_UNARMED", true)
        AttachEntityToEntity(obj, playerPed, bone, self.Offset.x, self.Offset.y, self.Offset.z, self.Rotation.x, self.Rotation.y, self.Rotation.z, true, false, false, false, 2, true)

        SetModelAsNoLongerNeeded(obj)

        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)
        end)       
    else
        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)

        Citizen.Wait(700)

        StopAnimTask(playerPed, dictionary, animation, 1.0)

        NetworkRequestControlOfEntity(self.Handle)

		while not NetworkHasControlOfEntity(self.Handle) and count < 5000 do
            Citizen.Wait(0)
            count = count + 1
        end
        
        DetachEntity(self.Handle, true, false)
        DeleteEntity(self.Handle)
    end
end

-- Add player to radio channel
function Radio:Add(id)
    exports["pma-voice"]:setRadioChannel(id)
end

-- Remove player from radio channel
function Radio:Remove()
    exports["pma-voice"]:setRadioChannel(0)
end

RegisterNetEvent('pma-voice:radioLimit', function()
    Wait(200)
    Radio.On = false
end)

-- Generate list of available frequencies
function GenerateFrequencyList()
    radioConfig.Frequency.List = {}

    for i = radioConfig.Frequency.Min, radioConfig.Frequency.Max do
        radioConfig.Frequency.List[#radioConfig.Frequency.List + 1] = i
    end
end

-- Check if radio is open
function IsRadioOpen()
    return Radio.Open
end

-- Check if radio is switched on
function IsRadioOn()
    return Radio.On
end

-- Check if player has radio
function IsRadioAvailable()
    return Radio.Has
end

-- Check if radio is enabled or not
function IsRadioEnabled()
    return not Radio.Enabled
end

-- Check if radio can be used
function CanRadioBeUsed()
    return Radio.Has and Radio.On and Radio.Enabled
end

-- Set if the radio is enabled or not
function SetRadioEnabled(value)
    Radio.Enabled = value
end

-- Set if player has a radio or not
function SetRadio(value)
    Radio.Has = value
end

-- Set if player has access to use the radio when closed
function SetAllowRadioWhenClosed(value)
    radioConfig.Frequency.AllowRadioWhenClosed = value

    if Radio.On and not Radio.Open and radioConfig.AllowRadioWhenClosed then
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
end

-- Add new frequency
-- Define exports
exports("IsRadioOpen", IsRadioOpen)
exports("IsRadioOn", IsRadioOn)
exports("IsRadioAvailable", IsRadioAvailable)
exports("IsRadioEnabled", IsRadioEnabled)
exports("CanRadioBeUsed", CanRadioBeUsed)
exports("SetRadioEnabled", SetRadioEnabled)
exports("SetRadio", SetRadio)
exports("SetAllowRadioWhenClosed", SetAllowRadioWhenClosed)
exports("AddPrivateFrequency", AddPrivateFrequency)
exports("RemovePrivateFrequency", RemovePrivateFrequency)
exports("GivePlayerAccessToFrequency", GivePlayerAccessToFrequency)
exports("RemovePlayerAccessToFrequency", RemovePlayerAccessToFrequency)
exports("GivePlayerAccessToFrequencies", GivePlayerAccessToFrequencies)
exports("RemovePlayerAccessToFrequencies", RemovePlayerAccessToFrequencies)

function getRadioAnimation()
    if PlayerData.job and PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mt" or PlayerData.job.name == "fbi" or PlayerData.job.name == "justice" or PlayerData.job.name == "detective" then
        return "random@arrests", "generic_radio_chatter"
    else
        return "cellphone@str", "cellphone_call_listen_a"
    end
end

AddEventHandler("KeyDown:m", function()
	if (radioConfig.Frequency.Current > 0 and Radio.Has and Radio.On and not RadioBusy) and ESX.GetPlayerData()['IsDead'] ~= 1 then
        RadioBusy = true
        busyStuf()
        local broadcastDictionary, broadcastAnimation = getRadioAnimation()
        RequestAnimDict(broadcastDictionary)
            
        while not HasAnimDictLoaded(broadcastDictionary) do
            Citizen.Wait(150)
        end
        
        TaskPlayAnim(PlayerPedId(), broadcastDictionary, broadcastAnimation, 8.0, -8, -1, 49, 0, 0, 0, 0)
	end
end)

AddEventHandler("KeyUP:m", function()
    if RadioBusy then
        local broadcastDictionary, broadcastAnimation = getRadioAnimation()
        StopAnimTask(PlayerPedId(), broadcastDictionary, broadcastAnimation, -4.0)
        RadioBusy = false
	end
end)


function Checks()
    Citizen.CreateThread(function()
        -- Add Labels
        for i = 1, #Radio.Labels do
            AddTextEntry(Radio.Labels[i][1], Radio.Labels[i][2])
        end
    
        GenerateFrequencyList()
    
    end)
end

AddEventHandler("onMultiplePress", function(keys)
    if PlayerData.job and PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mt" or PlayerData.job.name == "detective" then 
        if keys["lshift"] and keys["1"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 901
            Radio:Add(901)
            ESX.ShowNotification("~h~Shoma join ~g~901~w~ dadid!")
        elseif keys["lshift"] and keys["2"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 902
            Radio:Add(902)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 1~w~ dadid!")
        elseif keys["lshift"] and keys["3"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 903
            Radio:Add(903)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 2~w~ dadid!")
        elseif keys["lshift"] and keys["4"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 904
            Radio:Add(904)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 3~w~ dadid!")
        elseif keys["lshift"] and keys["5"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 905
            Radio:Add(905)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 4~w~ dadid!")
        elseif keys["lshift"] and keys["6"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 906
            Radio:Add(906)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 5~w~ dadid!")
        elseif keys["lshift"] and keys["7"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 907
            Radio:Add(907)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 6~w~ dadid!")
        elseif keys["lshift"] and keys["8"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 908
            Radio:Add(908)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 7~w~ dadid!")
        end
    end

    if PlayerData.job and PlayerData.job.name == "fbi" then 
        if keys["lshift"] and keys["1"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 950
            Radio:Add(950)
            ESX.ShowNotification("~h~Shoma join ~g~main~w~ dadid!")
        elseif keys["lshift"] and keys["2"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 951
            Radio:Add(951)
            ESX.ShowNotification("~h~Shoma join ~g~in justic~w~ dadid!")
        elseif keys["lshift"] and keys["3"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 952
            Radio:Add(952)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 1~w~ dadid!")
        elseif keys["lshift"] and keys["4"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 953
            Radio:Add(953)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 2~w~ dadid!")
        elseif keys["lshift"] and keys["5"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 954
            Radio:Add(954)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 3~w~ dadid!")
        elseif keys["lshift"] and keys["6"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 955
            Radio:Add(955)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 4~w~ dadid!")
        elseif keys["lshift"] and keys["7"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 956
            Radio:Add(956)
            ESX.ShowNotification("~h~Shoma join ~g~TAC 5~w~ dadid!")
        end
    end

    if PlayerData.job and PlayerData.job.name == "ambulance" then 
        if keys["lshift"] and keys["1"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 911
            Radio:Add(911)
            ESX.ShowNotification("~h~Shoma join ~g~Main~w~ dadid!")
        elseif keys["lshift"] and keys["2"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 912
            Radio:Add(912)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 2~w~ dadid!")
        elseif keys["lshift"] and keys["3"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 913
            Radio:Add(913)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 3~w~ dadid!")
        elseif keys["lshift"] and keys["4"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 914
            Radio:Add(914)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 4~w~ dadid!")
        elseif keys["lshift"] and keys["5"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 915
            Radio:Add(915)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 5~w~ dadid!")
        elseif keys["lshift"] and keys["6"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 916
            Radio:Add(916)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 6~w~ dadid!")
        elseif keys["lshift"] and keys["7"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 917
            Radio:Add(917)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 7~w~ dadid!")
        elseif keys["lshift"] and keys["8"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 918
            Radio:Add(918)
            ESX.ShowNotification("~h~Shoma join ~g~Freq 8~w~ dadid!")
        end
    end

    if PlayerData.job and PlayerData.job.name == "justice" then 
        if keys["lshift"] and keys["1"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 893
            Radio:Add(893)
            ESX.ShowNotification("~h~Shoma join ~g~Main~w~ dadid!")
        elseif keys["lshift"] and keys["2"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 894
            Radio:Add(894)
            ESX.ShowNotification("~h~Shoma join ~g~In Justice~w~ dadid!")
        elseif keys["lshift"] and keys["3"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 895
            Radio:Add(895)
            ESX.ShowNotification("~h~Shoma join ~g~Tac 1~w~ dadid!")
        elseif keys["lshift"] and keys["4"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 896
            Radio:Add(896)
            ESX.ShowNotification("~h~Shoma join ~g~Tac 2~w~ dadid!")
        elseif keys["lshift"] and keys["5"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 897
            Radio:Add(897)
            ESX.ShowNotification("~h~Shoma join ~g~Tac 3~w~ dadid!")
        elseif keys["lshift"] and keys["6"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 898
            Radio:Add(898)
            ESX.ShowNotification("~h~Shoma join ~g~Tac 4~w~ dadid!")
        elseif keys["lshift"] and keys["7"] and (Radio.Has and Radio.On) and ESX.GetPlayerData()['IsDead'] ~= 1 then
            if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
            spam = true
            Citizen.SetTimeout(5 * 1000,function()
                spam = false
            end)
            BlockWeaponWheelThisFrame()
            radioConfig.Frequency.Current = 899
            Radio:Add(899)
            ESX.ShowNotification("~h~Shoma join ~g~Tac 5~w~ dadid!")
        end
    end

end)

AddEventHandler('KeyDown:back',function()
    if Radio.Enabled and Radio.Has then
        if Radio.Open then
            Radio:Toggle(false)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
            exports["pma-voice"]:setVoiceProperty("radioClickMaxChannel", radioConfig.Frequency.Max) -- Set radio clicks enabled for all radio frequencies
            exports["pma-voice"]:setVoiceProperty("radioEnabled", false) -- Disable radio control
			return
		end
	end
end)

RegisterNetEvent("Radio.Toggle")
AddEventHandler("Radio.Toggle", function()
    local playerPed = PlayerPedId()
    local isFalling = IsPedFalling(playerPed)
    local isDead = IsEntityDead(playerPed)
    
    if not isFalling and not isDead then
        Radio:Toggle(not Radio.Open)
    end
end)

RegisterNetEvent("Radio.Clear")
AddEventHandler("Radio.Clear", function()
    Radio:Remove()
    radioConfig.Frequency.CurrentIndex = 1
    radioConfig.Frequency.Current = minFrequency
    Radio:Add(radioConfig.Frequency.Current)
    Radio:Toggle(false)
    Radio.On = false
    Radio:Add(0)
end)

function busyStuf()
    Citizen.CreateThread(function()
        while RadioBusy do
            Citizen.Wait(1)
            DisableControlAction(2, 24, true) -- Attack
            DisableControlAction(2, 257, true) -- Attack 2
            DisableControlAction(2, 25, true) -- Aim
            DisableControlAction(2, 263, true) -- Melee Attack 1
            DisableControlAction(2, 45, true) -- Reload
            DisableControlAction(2, 37, true) -- Select Weapon
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
        end
    end)
end


RegisterNetEvent("Radio.Set")
AddEventHandler("Radio.Set", function(value)
    Radio.Has = value
end)


function SetFrq(newFrequency)
    if spam then return ESX.ShowNotification('~r~Spam nakonid!~w~') end
    if (PlayerData.job.name == 'nojob' or ESX.basicJobs[PlayerData.job.name]) and PlayerData.gang.name == 'nogang' then
        return ESX.chatMessage('Shoma nemitavanid az radio estefade konid', 'plarms')
    end
    spam = true
    Citizen.SetTimeout(5 * 1000,function()
        spam = false
    end)
    if newFrequency then
        local minFrequency = radioConfig.Frequency.List[1]
        if newFrequency >= minFrequency and newFrequency <= radioConfig.Frequency.List[#radioConfig.Frequency.List] and newFrequency == math.floor(newFrequency) then
            if not frqaccess[newFrequency] or frqaccess[newFrequency][PlayerData.job.name] or (frqaccess[newFrequency][PlayerData.gang.name] and PlayerData.gang.grade > 1) then
                local idx = nil
    
                for i = 1, #radioConfig.Frequency.List do
                    if radioConfig.Frequency.List[i] == newFrequency then
                        idx = i
                        break
                    end
                end
    
                if idx ~= nil then
                    if Radio.Enabled then
                        Radio:Remove()
                    end

                    radioConfig.Frequency.CurrentIndex = idx
                    radioConfig.Frequency.Current = newFrequency
                    exports["pma-voice"]:resethud()
                    if Radio.On then
                        Radio:Add(radioConfig.Frequency.Current)
                    end
                end
            else
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi be in frq nadarid!"}}, 'plarms')
            end
        end
    else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dar ghesmat ^2freq ^0 faghat mitavanid ^1adad ^0 vared konid!"}}, 'plarms')
    end
end


RegisterNetEvent('radio:openMenu', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        frequencies = data
    })
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('setFreq', function(data, cb)
    ESX.TriggerServerEvent('radio:setFreq', tostring(data.freq), data.access)
    cb('ok')
end)