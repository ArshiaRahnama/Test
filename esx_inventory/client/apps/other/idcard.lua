local sex = nil
local typeCard = nil
local image = nil

-- FIX: the mugshot export lives in an optional external resource
-- (MugShotBase64). If it isn't installed/started, calling it directly
-- would throw and leave `image` nil (broken ID card). This wraps it so a
-- missing/failing resource always falls back to Config.PictureIdCard
-- instead of erroring.
local function safeGetMugshot(entity)
    if GetResourceState('MugShotBase64') ~= 'started' then
        return Config.PictureIdCard
    end
    local ok, result = pcall(function()
        return exports["MugShotBase64"]:GetMugShotBase64(entity, false)
    end)
    if ok and result then
        return result
    end
    return Config.PictureIdCard
end


RegisterNUICallback('lookCard', function(data)
    if Config.ActiveMugShot == false then
        image = Config.PictureIdCard 
    else
        image = safeGetMugshot(PlayerPedId())
    end
    SendNUIMessage({
        action = "open:idCard", 
        type = data.type, 
        title = Config.IdCardName[data.type].name, 
        information = data.info,
        sex = Config.GenreIdCard[data.info.sex],
        image = image,
        icon = Config.IdCardName[data.type].icon,
        color = Config.IdCardName[data.type].color,
    })

end)

RegisterNUICallback('giveCard', function(data)
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance < 2.5 then
        TriggerServerEvent('lgddddd:lookCard', GetPlayerServerId(closestPlayer), GetPlayerServerId(PlayerId()), data)

    else 
        NotificationInInventory(Locales[Config.Language]['no_player'], 'error')
    end
end)

RegisterNetEvent('lgd:lookCard')
AddEventHandler('lgd:lookCard', function(networkId, data)
    open = true
    
    if Config.ActiveMugShot == false then
        image = Config.PictureIdCard 
    else

        local entity = NetworkGetEntityFromNetworkId(networkId)
        if DoesEntityExist(entity) then
            image = safeGetMugshot(entity)
        else
            debugprint("Entity with this ID in netword " .. networkId .. " does not exist.")
            image = Config.PictureIdCard
        end
    end
    SendNUIMessage({
        action = "open:idCard", 
        type = data.type, 
        title = Config.IdCardName[data.type].name, 
        information = data.info,
        sex = Config.GenreIdCard[data.info.sex],
        image = image,
        icon = Config.IdCardName[data.type].icon,
        color = Config.IdCardName[data.type].color,
    })
    while open do 
		Wait(0)

		if (IsControlJustReleased(0, 322) and open) or (IsControlJustReleased(0, 177) and open) then
			SendNUIMessage({
				action = 'close:idCard'
			})
			open = false
		end
	end
end)