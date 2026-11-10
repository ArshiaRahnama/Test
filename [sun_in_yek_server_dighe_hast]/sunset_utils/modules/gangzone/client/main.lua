-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

gangKey = nil
local gangZoneList = {}
AddEventHandler('gangs:zoneLoaded',function(data)
    waitForLoad()
    local whiteJob = {
		['police'] = true,
		['sheriff'] = true,
		['fbi'] = true,
        ['mt'] = true,
        ['detective'] = true,
	}
    local unarmed = `weapon_unarmed`
    local taze = `weapon_stungun`
    for k , v in ipairs(data) do
        local Blip = json.decode(v)
        table.insert(gangZoneList,{
            coords = vector3(Blip.x,Blip.y,Blip.z),
            radius = Blip.radius or 50.0
        })
    end
    Citizen.CreateThread(function()
        --
        while true do 
            local coords = GetEntityCoords(PlayerPedId())
            local inBase = exports['gangs']:isInGangWorld()
            -- if not (whiteJob[ESX.PlayerData.job.name] and GetSelectedPedWeapon(PlayerPedId()) == taze) then
            if not (whiteJob[ESX.PlayerData.job.name] and (GetSelectedPedWeapon(PlayerPedId()) == taze or IsPedInAnyVehicle(PlayerPedId()))) then
                for k , v in pairs(gangZoneList) do
                    if ESX.GetDistance(coords,v.coords) < v.radius and (SUN.world == 0 or inBase) then
                        if not gangKey then
                            gangKey = k
                            Citizen.CreateThread(function()
                                while gangKey and (SUN.world == 0 or inBase) do
                                    Citizen.Wait(0)
                                    if GetSelectedPedWeapon(PlayerPedId()) ~= unarmed then
                                        disableFiring()
                                    end
                                end
                                gangKey = nil
                            end)
                        end
                    elseif gangKey == k then
                        gangKey = nil
                    end
                    Citizen.Wait(10)
                end
            elseif gangKey then
                gangKey = nil
            end
            Citizen.Wait(2000)
        end
    end)

    exports('isInGangBase', function()
        local coords = GetEntityCoords(PlayerPedId())
        for k , v in pairs(gangZoneList) do
            if ESX.GetDistance(coords,v.coords) < v.radius then
                return true
            end
        end
    end)
end)
