-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

CreateThread(function()
    waitForLoad()
    while not lib do Wait(100) end
    local cd = false
    lib.registerMenu({
        id = 'weaponAnim',
        title = 'Weapon Animatiom',
        options = weaponAnimConfig.animList
    }, function(selected, scrollIndex, args)
        if cd then return end
        cd = true
        SetTimeout(3000, function()
            cd = false
        end)
        SetWeaponAnimationOverride(SUN.ped, args)
        ESX.SetPlayerState('weaponAnim', args)
        if args == 'default' then
            ESX.SetPlayerState('weaponAnim', nil)
        end
        ESX.chatMessage(('Animation ^2%s^0 set shod'):format(weaponAnimConfig.animList[selected].label), 'alarms')
    end)
    ESX.registerCommand('weaponanim', function()
        if ESX.GetPlayerData().SelfLevel >= weaponAnimConfig.neededLevel then
            lib.showMenu('weaponAnim')
        else
            ESX.chatMessage('Shoma dastresi estefade az in cmd ra nadarid', 'plarms')
        end
    end, {help = 'Weapon animation menu'})
end)

AddStateBagChangeHandler('weaponAnim', nil, function(bagName, k, v)
    local ped = ESX.getPlayerPed(GetPlayerFromStateBagName(bagName))
    if ped == 0 or not v then return end
    SetWeaponAnimationOverride(ped, v)
end)