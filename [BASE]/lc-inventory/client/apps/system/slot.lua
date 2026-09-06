RegisterNUICallback("PutIntoFast", function(data, cb)
    if not Config.BL_SlotInv[data.item.name] then
	    if data.item.slot ~= nil then
		    Inv.FastWeapons[data.item.slot] = nil
	    end
	    if data.item.type == 'item_weapon' then
	        Inv.FastWeapons[data.slot] = { name = data.item.name, serial = data.item.serial }
	    else
	        Inv.FastWeapons[data.slot] = data.item.name
	    end
        SetFieldValueFromNameEncode('lc-inventory', {name = Inv.FastWeapons})
	    loadPlayerInventory('slot', nil, true, true)
        cb("ok")
    end
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
	Inv.FastWeapons[data.item.slot] = nil
    SetFieldValueFromNameEncode('lc-inventory', {name = Inv.FastWeapons})
    loadPlayerInventory(currentMenu, nil, true, true)
	cb("ok")
end)

for k, v in pairs(Config.KeyBinds) do 
    RegisterKeyMapping(v.Command, v.Description, 'keyboard', v.Bind)
end



function useitem(num)
    if IsPedRagdoll(PlayerPedId())  then
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
        return
    end

    local bind = Inv.FastWeapons[num]
    local bindName = type(bind) == 'table' and bind.name or bind

    if not Config.BL_SlotInv[bindName] and not Inv.isInInventory then
        if bindName ~= nil then
            local prefix = string.sub(bindName, 1, 7) -- extrait les 7 premiers caractères
            if prefix ~= 'WEAPON_' then
                TriggerServerEvent(Config.Trigger["esx:useItem"], bindName)
            else
                local ped = PlayerPedId()

                if not weaponLock then
                    weaponLock = true
                    if  weaponEquiped ~= bindName then
                        weaponEquiped = bindName
                        SetCurrentPedWeapon(ped, bindName, true)
                        -- SetPedCurrentWeaponVisible(ped, 0, true, 1, 0) -- Cache l'arme

                        Wait(150)
                        weaponLock = false
                    else 
                        weaponEquiped = nil
                        SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
                        Wait(150)
                        weaponLock = false
                    end 
                end
            end
        end
    end
end
