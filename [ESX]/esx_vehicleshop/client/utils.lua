local NumberCharset = {}
local Charset = {}

math.randomseed(GetGameTimer() + GetPlayerServerId(PlayerId()))

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate

	while true do
		Citizen.Wait(2)
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters))

		else

			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomNumber(Config.PlateNumbers) .. GetRandomLetter(Config.PlateLetters))
		end




		if not IsPlateTaken(generatedPlate) then
			break
		end
	end
	return generatedPlate
end

function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(1)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end