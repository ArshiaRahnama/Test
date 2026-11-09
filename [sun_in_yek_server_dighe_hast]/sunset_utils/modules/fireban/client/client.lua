-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local banned = false
foxState = false
forceFox = false
foxBan = false
local thread2World = {
    [0] = true,
    [98] = true,
    [97] = true,
    [96] = true,
    [95] = true,
}

local function hourCheck()
    ESX.TriggerServerEvent('fightban:hourCheck')
    SetTimeout(60 * 60000, hourCheck)
end

RegisterNetEvent('esx:setGang')
RegisterNetEvent('esx:setGang', function(gang)
    if not banned and ESX.TableContainsValue(fireBanConfig.gang, gang.name) then
        TriggerEvent('fireBan:setBan', true)
    end
end)

Citizen.CreateThread(function()
    waitForLoad()
    while ESX == nil do Wait(1000) end
    ESX.TriggerServerCallback('fireBan:check',function(state, _foxBan)
        Citizen.Wait(1000)
        banned = state or ESX.TableContainsValue(fireBanConfig.gang, ESX.PlayerData.gang.name)
        foxBan = _foxBan
        -- fatmaState = _fatma
        -- TriggerEvent('fatmaState', fatmaState)
        -- if fatmaState then
        --     ESX.SetPlayerState('fatmaState', true)
        -- end
        if banned then
            fireBanThread2()
            TriggerServerEvent('kill:imFightBan')
            AddEventHandler('KeyDown:mouse_left',function()
                if banned and not ESX.meleeWeapons[SUN.CurrentWeaponModel] and not fatmaState then
                    ExecuteCommand('checkfightban')
                end
            end)
        else
            while ESX.GetPlayerData().SelfLevel == nil do
                Citizen.Wait(1000)
            end
            if ESX.GetPlayerData().SelfLevel < 2 then
                banned = true
                fireBanThread()
                Citizen.CreateThread(function()
                    while banned do
                        Citizen.Wait(10000)
                        if ESX.GetPlayerData().SelfLevel > 1 then
                            banned = false
                        end
                    end
                end)
            end
        end
        CreateThread(function()
            while true do
                Wait(10000)
                if IsFoxAlive() then
                    if not foxState then
                        foxState = true
                        ESX.TriggerServerEvent('fireban:foxState', true)
                        ESX.TriggerServerEvent('kill:imFightBanFatma')
                        ESX.SetPlayerState('fatmaState', true)
                        ESX.TriggerServerEvent('setFatma', true)
                    end
                elseif foxState then
                    foxState = false
                    ESX.TriggerServerEvent('fireban:foxState', false)
                    TriggerServerEvent('kill:imFightBan')
                    ESX.TriggerServerEvent('setFatma', false)
                    ESX.SetPlayerState('fatmaState', false)
                end
            end
        end)
        CreateThread(function()
            local wait = 5000
            while true do
                Wait(wait)
                if forceFox or SUN.world == 0 or (SUN.world >= 300 and SUN.world <= 400) or SUN.world == 97 then
                    if not foxState then
                        disableFiring()
                        wait = 0
                    else
                        wait = 5000
                    end
                else
                    wait = 5000
                end
            end
        end)
        AddEventHandler('KeyDown:mouse_left',function()
            if forceFox or SUN.world == 0 or (SUN.world >= 300 and SUN.world <= 400) or SUN.world == 97 then
                if not foxState and SUN.isArmed then
                    ESX.chatMessage('Baraye tir andazi be FoxG niaz darid!', 'plarms')
                end
            end
        end)
        SetTimeout(60 * 60000, hourCheck)
    end)
end)

RegisterNetEvent('fireBan:setBan',function(state)
    banned = state
    if banned then
        fireBanThread2()
        AddEventHandler('KeyDown:mouse_left',function()
            if banned then
                -- ExecuteCommand('checkfightban')
            end
        end)
    end
end)



function fireBanThread()
    Citizen.CreateThread(function()
        local _ = false
        while banned do
            Citizen.Wait(500)
            if World == 0 and (SUN.VehiclePlayerIsIn == 0 or not SUN.PlayerIsDriver)then
                if not _ then
                    _ = true
                    NetworkSetFriendlyFireOption(false)
                end
            else
                _ = false
                NetworkSetFriendlyFireOption(true)
            end
        end
        NetworkSetFriendlyFireOption(true)
    end)
end

function fireBanThread2()
    Citizen.CreateThread(function()
        local _ = false
        local robbery = false
        CreateThread(function()
            while banned do
                Wait(500)
                _ = LocalPlayer.state.job == 'hunter' or ESX.meleeWeapons[SUN.CurrentWeaponModel]
                robbery = exports['sun-robbery']:doesInRob()
            end
        end)
        while banned do
            Citizen.Wait(0)
            -- if (thread2World[World] or robbery) and not _ and (not foxState or foxBan) then
            if (thread2World[World] or robbery or (SUN.world >= 300 and SUN.world <= 400)) and not _ then
                -- DisablePlayerFiring(SUN.PlayerId,true)
                disableFiring()
            end
        end
    end)
end

-- RegisterNetEvent('fightban:fatmaState', function(_state)
--     fatmaState = _state
--     TriggerEvent('fatmaState', fatmaState)
--     ESX.SetPlayerState('fatmaState', fatmaState)
--     if banned then
--         if not _state then
--             TriggerServerEvent('kill:imFightBan')
--         else
--             ESX.TriggerServerEvent('kill:imFightBanFatma')
--         end
--     end
-- end)

-- AddStateBagChangeHandler('fatmaState', nil, function(bagName, key, value)
--     if not bagName:match('player:') then return end
--     local player = tonumber(bagName:gsub('player:', ''), 10)
--     if player == ESX.src and value and not fatmaState then
--         ESX.alarm('FG Tag Cheat?')
--     end
-- end)


AddEventHandler('setForceFox', function(state)
    forceFox = state
end)