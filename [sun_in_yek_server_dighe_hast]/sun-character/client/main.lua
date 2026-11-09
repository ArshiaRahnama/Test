-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ESX = exports['essentialmode']:getObject()
local needRegister, uiReady, uiOpen
local loadStep = 0
RegisterNetEvent('char:showRegister', function(state, cmd)
    needRegister = state
    if state and cmd then
        showUI(true)
    end
end)

CreateThread(function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    while not ESX do Wait(1000) end
    ESX.SetPlayerData('connect', 1)
    DoScreenFadeOut(50)
    showLoadingMessage('Retrieving data')
    Wait(2000)
    exports['suncore']:SetPlayerVisible(false)
    SetTimeout(15000, function()
        if needRegister == nil then
            TriggerServerEvent('core:registerCheck')
        end
    end)
    while needRegister == nil do
        Wait(1000)
    end
    if needRegister then
        showLoadingMessage('Register')
        showUI(true)
    else
        loadCharacter()
    end
end)

RegisterNUICallback('initialize', function(data, cb)
	uiReady = true
end)

function showUI(state)
    while not uiReady do Wait(5000) uiReady = true end
    SetNuiFocus(state, state)
    uiOpen = state
    if uiOpen then
        startThread()
    end
    SendNUIMessage({
        type = 'enableui',
        enable = state
    })
end

RegisterNUICallback('register', function(data, cb)
    local name = data.firstname ..'_'.. data.lastname
    local date 	= "01/01/2000"
    ESX.TriggerServerCallback('core:isNameAvailable', function(avalible)
        if name:find(' ') then
            SendNUIMessage({
                action = 'notification',
                message= 'Esm nabayad daraye space bashad!'
            })
        else
            if avalible then
                ESX.TriggerServerEvent('db:updateUserName', name, date)
                ESX.TriggerServerEvent('newName', name)
                showUI(false)
                needRegister = false
                Wait(500)
                loadStep = 2
                loadCharacter()
                exports['sunset_quest']:Play('02_register_finish')
            else
                SendNUIMessage({
                    action = 'notification',
                    message= 'این نام قبلا ثبت شده، یک نام دیگر انتخاب کنید'
                })
            end
        end
    end, name)
end)

function startThread()
    CreateThread(function()
        while uiOpen do
            Wait(0)
            DisableControlAction(0, 1,   true) -- LookLeftRight
            DisableControlAction(0, 2,   true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
            DisableControlAction(0, 21,  true) -- disable sprint
            DisableControlAction(0, 24,  true) -- disable attack
            DisableControlAction(0, 25,  true) -- disable aim
            DisableControlAction(0, 47,  true) -- disable weapon
            DisableControlAction(0, 58,  true) -- disable weapon
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 75,  true) -- disable exit vehicle
            DisableControlAction(27, 75, true) -- disable exit vehicle
        end
    end)
end

function loadCharacter()
    Wait(1000)
    uiOpen = true
    startThread()
    exports.suncore:SetPlayerVisible(true)
	TriggerEvent('loading:Loaded')
    TriggerEvent('es_admin:freezePlayer', false)
    Wait(5000)
    TriggerEvent('es_admin:freezePlayer', false)
    while loadStep < 2 do
        Wait(100)
    end
    showLoadingMessage('Welcome🙂')
    uiOpen = false
    DoScreenFadeIn(3000)
    exports['ps-ui']:StatusHide()
end

function showLoadingMessage(message)
    exports['ps-ui']:StatusShow('Loading character...', {
        message
    })
end

AddEventHandler('char:teleported', function()
    while needRegister == nil or needRegister do
        Wait(1000)
    end
    showLoadingMessage('Preparing for spawn')
    Wait(2000)
    showLoadingMessage('Teleporting to last location')
    loadStep += 1
end)

AddEventHandler('sun:clotheLoaded', function()
    while needRegister == nil or needRegister do
        Wait(1000)
    end
    showLoadingMessage('Wearing clothe')
    Wait(5000)
    loadStep += 1
end)
ShutdownLoadingScreen()
ShutdownLoadingScreenNui()