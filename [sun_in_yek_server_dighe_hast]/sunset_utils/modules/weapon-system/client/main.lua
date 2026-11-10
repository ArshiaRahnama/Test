-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('weapon:playFixAnim', function(name)
    local weapon = ESX.GetWeapon(name)
    local forward = GetEntityForwardVector(SUN.ped)
    local x, y, z = table.unpack(SUN.PlayerCoords + forward * 1.1)
    local x2, y2, z2 = table.unpack(SUN.PlayerCoords + forward * 1.0)
    local model = 'prop_box_ammo05b'
    ESX.Game.SpawnObject(model, {
        x = x,
        y = y,
        z = z
    }, function(obj)
        SetEntityHeading(obj, GetEntityHeading(SUN.ped))
        PlaceObjectOnGroundProperly(obj)
        SetEntityCollision(obj, false, false)
        FreezeEntityPosition(obj2, true)
        if weapon.model and IsModelInCdimage(GetHashKey(weapon.model)) then
            obj2 = ESX.Game.SpawnObject(weapon.model, vec(x2, y2, GetEntityCoords(obj).z) + vec(0, 0, 0.08), nil, true)
            local rotation = GetEntityRotation(obj)
            SetEntityRotation(obj2, vector3(-90.0, rotation.y, rotation.z))
            SetEntityDrawOutline(obj2, true)
            FreezeEntityPosition(obj2, true)
        end
        if ESX.progressCircle(5000, false, true, {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
        }) then
            ESX.Game.DeleteEntity(obj)
            ESX.Game.DeleteEntity(obj2)
        end
    end)
end)


CreateThread(function()
    local deafultWait = 500
    local wait = deafultWait
    local whiteList = {
        [`WEAPON_UNARMED`] = true,
        [`WEAPON_OBJECT`] = true,
        [`WEAPON_PETROLCAN`] = true,
    }
    local petrolCan = `WEAPON_PETROLCAN`
    waitForLoad()
    while true do
        Wait(wait)
        local default = true
        if whiteList[SUN.CurrentWeaponModel] then
            if SUN.CurrentWeaponModel == petrolCan then
                wait = 0
                default = false
                disableFiring()
            end
        end

        if default then
            wait = deafultWait
        end
    end
end)