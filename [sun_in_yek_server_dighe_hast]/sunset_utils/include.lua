-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

InvokeNativeWeather = Citizen.InvokeNative

function FreezeEntityPosition(entity, toggle, partial)
	if DoesEntityExist(entity) then
		if not partial and IsEntityAPed(entity) and IsPedAPlayer(entity) then
			SetPedConfigFlag(entity, 292, toggle)
		end
		if NetworkGetEntityIsNetworked(entity) then
			Entity(entity).state.frozen = toggle
		end
		InvokeNativeWeather(0x428CA6DBD1094446, entity, toggle)
	end
end

function GetFreezeEntityPosition(entity)
	if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
		return Entity(entity).state.frozen
	end
	return false
end

function CreateBlip(coords, text, sprite, colour, scale, display, radius, radiusColour)
	local blip = AddBlipForCoord(coords)
	SetBlipHighDetail(blip, true)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, display or 4)
	SetBlipScale(blip, scale or 0.75)
	SetBlipColour(blip, colour or 0)
	SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	
	local zoneblip = nil
	if radius then
		zoneblip = AddBlipForRadius(coords, radius)
		SetBlipSprite(zoneblip,1)
		SetBlipColour(zoneblip, radiusColour or colour)
		SetBlipAlpha(zoneblip,100)
	end
	return blip, zoneblip
end

function ArrayHasValue(array, value, field)
	if field then
		for _, v in pairs(array) do
			if value == v[field] then
				return true
			end
		end
	else 
		for _, v in pairs(array) do
			if value == v then
				return true
			end
		end
	end

	return false
end

-- local ChangeFaceForMasks = {
-- 	[0] = {28,32,35,37,47,48,51,52,53,54,55,56,57,58,61,62,64,68,69,70,72,77,78,85,89,93,96,97,98,99,100,102,104,108,110,111,113,117,119,123,130,132,134,141,146,155,167,169,170,174,178,185,187,189,190,191,192,194,195,196,197,199,200,201,202,204,205,212},
-- 	[1] = {28,32,35,37,47,48,51,52,53,54,55,56,57,58,61,62,63,65,68,69,70,71,72,77,78,85,86,89,92,93,96,97,98,99,100,102,103,104,110,111,112,113,117,118,119,122,123,126,129,130,132,134,136,137,138,139,141,142,146,149,154,155,158,159,169,170,174,178,180,181,184,185,187,188,189}
-- }
-- SetPedComponentVariationNative = SetPedComponentVariation				
-- SetPedComponentVariation = function(ped, componentId, drawableId, textureId, paletteId)
-- 	if componentId == 1 then
-- 			local changeMask = ArrayHasValue(ChangeFaceForMasks[skin.sex], drawableId)
-- 			local face = changeMask and (skin.sex == 0 and 0 or 21) or skin.face
-- 			local nose = changeMask and 10 or skin.nose_3
-- 			SetPedHeadBlendData(ped, face, face, face, skin['skin'], skin['skin'], skin['skin'], 1.0, 1.0, 1.0, true)
-- 			SetPedComponentVariationNative(ped, componentId, drawableId, textureId, paletteId)
-- 			SetPedFaceFeature(ped, 2, nose) 
-- 		end)
-- 	else
-- 		SetPedComponentVariationNative(ped, componentId, drawableId, textureId, paletteId)
-- 	end
-- end

function CheckNumber(number)
	number = tonumber(number)
	if number then
		number = math.floor(number)
		if number >= 0 then
			return true, number
		end
	end
	return false, number
end

-- UI FUNCTIONS --
function GetKeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', tostring(inputText or ''), '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(100)
		return result
	else
		Citizen.Wait(100)
		return nil
	end
end

function GetKeyboardInputNumber(entryTitle, textEntry, inputText, maxLength)
	return CheckNumber(GetKeyboardInput(entryTitle, textEntry, inputText, maxLength))
end
