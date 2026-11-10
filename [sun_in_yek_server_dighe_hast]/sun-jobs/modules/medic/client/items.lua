-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local usingItem = false
local usingAdr = false
local stuffOut = 0
local blackListLocation = {
    vec(1159.35, -319.83, 69.95, 30),    -- shop kenare casino
    vec(1137.07, -981.79, 46.41, 20),    -- shop kenare mechanici
    vec(-712.0, -917.96, 19.21, 25),     -- shope kenare weazel
    vec(-53.3, -1757.12, 29.44, 25),     -- shope grove
    vec(32.25, -1349.79, 29.33, 25),     -- shop 1
    vec(198.26, 173.83, 105.36, 180),    -- bank markazi
    vec(314.25, -279.1, 54.17, 20),      -- mini 1
    vec(-351.78, -51.8, 49.04, 20),      -- mini 2
    vec(-634.47, -239.71, 38.05, 25),    -- javaheri
    vec(-1090.48, -267.73, 37.74, 200),  -- bime
    vec(-1316.13, -843.33, 16.8, 100),   -- maze
    vec(-1485.2, -375.23, 40.16, 18),    -- shop kenare bime
    vec(378.08, 329.81, 103.57, 15),     -- shop bank markazi
    vec(-1219.58, -909.94, 12.33, 15),   -- mini shop 1
    vec(-1827.67, 793.33, 138.22 ,25),   -- shop biroon 1
    vec(-2959.57, 389.44, 14.04, 22),    -- shop sahel 1
    vec(-2957.54, 484.23, 15.68, 22),    -- mini sahel
    vec(-3047.23, 585.85, 7.91, 20),     -- shop sahel 2
    vec(-3249.21, 1005.35, 12.83, 20),   -- shop sahel 3
    vec(-1115.17, 4922.44, 217.99, 150), -- cargo
    vec(-112.66, 6460.38, 31.47, 100),   -- paleto
    vec(1736.32, 6419.47, 35.04 ,23),    -- shop bala
    vec(2373.03, 5008.66, 44.49, 250),   -- mythic
    vec(1707.53, 4920.12, 42.06, 22),    -- shop kenare coca
    vec(1959.63, 3748.25, 32.34, 22),    -- shop sheriff
    vec(2737.87, 3476.84, 55.71, 40),    -- javaheri shams
    vec(2673.1, 3286.81, 55.24, 22),     -- shop abrisham
    vec(1171.31, 2714.03, 38.07, 22),    -- mini sandy
    vec(546.66, 2663.26, 42.16, 22),     -- shop sandy
    vec(2550.08, 385.46, 108.62, 22),    -- shop gov
    vec(827.11, -2021.3, 28.9, 45),      -- javaheir flat
    vec(-1132.29, -1357.35, 5.03, 23),   -- mini javaheri
    vec(-1541.67, -417.04, 35.64, 23),   -- mini javaheri
    vec(1645.99, 4881.41, 42.16, 23),    -- sandybala mini
    vec(561.5, 2749.62, 42.21, 23),      -- sandy mini
    vec(-243.97, 239.12, 92.03, 23),     -- sanvitus
    vec(-1036.61, -2734.62, 20.17, 50),  -- air
    vec(815.3, -2146.35, 30.0, 50),      -- gunshop robbery
    vec(-209.39, -1311.23, 30.89, 45),   -- Benny robbery
    vec(-3451.89, -3463.96, 462.35, 35), -- cs

}

RegisterNetEvent('medic:useItem',function(name)
    if usingItem then return end
    if name == 'epinephrine' and (not ESX.GetPlayerData().IsInjure or ESX.GetPlayerData().IsDead or usingAdr) then
        return ESX.ShowNotification('Shoma nemitavanid in item use konid!')
    end
    local coords = GetEntityCoords(PlayerPedId())
    local canUse = true
    for k , v in pairs(blackListLocation) do
        if ESX.GetDistance(coords,v.xyz) <= v.w then
            canUse = false
            break
        end
    end
    if canUse and not exports['sun-robbery']:doesInRob() then
        TriggerServerEvent('medic:useItem',name)
    else
        ESX.ShowNotification('Shoma nemitavanid in item ra dar in makan use konid!')
    end
end)

RegisterNetEvent('medic:useItem2',function(name)
    usingItem = true
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
    local playerPed = PlayerPedId()
    exports['essentialmode']:disableallControl(true)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        Citizen.Wait(500)
        Citizen.CreateThread(function()
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
        end)
    end)
    if name == 'gelophen' then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "pp",
            duration = 10000,
            label = "",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            },
            }, function(status)

            end)
        Citizen.Wait(10000)
        exports['essentialmode']:disableallControl(false)
        Citizen.CreateThread(function()
            local lastheal = nil
            local addHeal = 50
            while addHeal > 0 and GetEntityHealth(PlayerPedId()) < GetEntityMaxHealth(PlayerPedId()) and not exports['sun-robbery']:doesInRob() do
                if lastheal and lastheal ~= GetEntityHealth(PlayerPedId()) then
                    break
                end
                addHeal = addHeal - 1
                ESX.SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) + 1)
                lastheal = GetEntityHealth(PlayerPedId())
                Citizen.Wait(500)
            end
        end)
    elseif name == 'acetaminophen' then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "pp",
            duration = 10000,
            label = "",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            },
            }, function(status)

            end)
        Citizen.Wait(10000)
        exports['essentialmode']:disableallControl(false)
        Citizen.CreateThread(function()
            local lastheal = nil
            local addHeal = 25
            while addHeal > 0 and GetEntityHealth(PlayerPedId()) < GetEntityMaxHealth(PlayerPedId()) and not exports['sun-robbery']:doesInRob() do
                if lastheal and lastheal ~= GetEntityHealth(PlayerPedId()) then
                    break
                end
                addHeal = addHeal - 1
                ESX.SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) + 1)
                lastheal = GetEntityHealth(PlayerPedId())
                Citizen.Wait(500)
            end
        end)
    elseif name == 'erythropoietin' then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "pp",
            duration = 10000,
            label = "",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            },
            }, function(status)

            end)
        Citizen.Wait(10000)
        exports['essentialmode']:disableallControl(false)
        Citizen.CreateThread(function()
            local lastheal = nil
            local addHeal = 100
            while addHeal > 0 and GetEntityHealth(PlayerPedId()) < GetEntityMaxHealth(PlayerPedId()) and not exports['sun-robbery']:doesInRob() do
                if lastheal and lastheal < GetEntityHealth(PlayerPedId()) then
                    break
                end
                addHeal = addHeal - 1
                ESX.SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) + 1)
                lastheal = GetEntityHealth(PlayerPedId())
                Citizen.Wait(2000)
            end
        end)
    elseif name == 'epinephrine' then
        ESX.SetPlayerState('adrenaline',true)
        usingAdr = true
        TriggerEvent("mythic_progbar:client:progress", {
            name = "pp",
            duration = 20000,
            label = "",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            },
        }, function(status)

        end)
        Citizen.Wait(20000)
        exports['essentialmode']:disableallControl(false)
        if not ESX.GetPlayerData().IsDead and not IsPedInAnyVehicle(PlayerPedId(), true) then
            adrenalineThread()
            exports['sunset_utils']:addStress('use_adrenaline')
        end
    end
    usingItem = false
end)

function medicResetADR()
    if usingAdr then
        TriggerServerEvent('medic:setDeathState', false,false)
    end
    usingAdr = false
    ESX.ClearTimeout(stuffOut)
    ESX.hideTextUI()
end

exports('notBlackListCoords',function()
    local coords = GetEntityCoords(PlayerPedId())
    local canUse = true
    for k , v in pairs(blackListLocation) do
        if ESX.GetDistance(coords,v.xyz) <= v.w then
            canUse = false
            break
        end
    end
    return canUse
end)

function adrenalineThread()
    ESX.ClearTimeout(stuffOut)
    TriggerEvent('medic:revive', false, nil, false, false, true)
    lib.progressCircle({
		duration = 4000,
		position = 'middle',
		useWhileDead = false,
		canCancel = false,
		allowRagdoll = true,
		allowFalling = true,
		disable = {
			car = true,
			move = true,
			combat = true,
		},
	})
    local disableAction = true
    SetTimeout(10000, function()
        disableAction = false
    end)
    CreateThread(function()
        while disableAction do
            Citizen.Wait(0)
            DisableControlAction(0,22,true)
            exports['sunset_utils']:disableFiring()
        end
    end)
    Wait(2000)
    stuffOut = ESX.SetTimeout(5 * 60 * 1000,function()
        if usingAdr then
            usingAdr = false
            ESX.SetEntityHealth(PlayerPedId(),0)
            ESX.SetPlayerState('adrenaline',false)
        end
    end)
    if ESX.GetPlayerData().IsDead then
        return
    end
    exports['suncore']:whiteStuff(10000)
    Wait(2500)
    usingAdr = true
    CreateThread(function()
        while usingAdr do
            Citizen.Wait(0)
            DisableControlAction(0,22,true)
            exports['sunset_utils']:disableFiring()
        end
    end)
    local timer = 5 * 60
    CreateThread(function()
        while timer > 0 and usingAdr do
            ESX.showTextUI('Adrenaline effect '.. timer .. 's')
            timer = timer - 1
            Citizen.Wait(1000)
        end
        ESX.hideTextUI()
        ESX.SetPlayerState('adrenaline',false)
    end)
end