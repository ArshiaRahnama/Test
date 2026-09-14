
ESX                      = nil
PlayerData               = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

    PlayerData.job = job

end)
Citizen.CreateThread(function()
	while true do
	local name
	local ass
	Citizen.Wait(1000)

	if PlayerData.job ~= nil then
		if PlayerData.job.name  == "police" then
		name = "Police"
		ass = "police"
		elseif PlayerData.job.name  == "sheriff" then
		name = "Sheriff"
		ass = "sheriff"
		elseif PlayerData.job.name  == "taxi" then
		name = "Taxi"
		ass = "taxi"
		elseif PlayerData.job.name  == "fbi" then
		name = "FBI"
		ass = "fbi"
		elseif PlayerData.job.name  == "ambulance" then
		name = "Ambulance"
		ass = "ambulance"
		elseif PlayerData.job.name  == "nightclub" then
		name = "NightClub"
		ass = "nightClub"
		elseif PlayerData.job.name  == "nojob" then
		name = "logo"

		ass = "discord.gg/DiscordLink"
		elseif PlayerData.job.name == "mechanic" then
		name = "Mechanic"
		ass = "mechanic"
		elseif PlayerData.job.name == "weazel" then
		name = "Weazel News"
		ass = "weazel"
		elseif PlayerData.job.name == "mt" then
		name = "MT"
		ass = "mt"
		elseif PlayerData.job.name == "coffee" then
		name = "Coffee"
		ass = "coffee"
		end
	else
		name = "logo"
		ass = "https://discord.gg/rwBHcCqzJB"
	end

	if ESX.GetPlayerData()['aduty'] == 1 then
		name = 'Staff'
		ass = "admin"
	end

		SetDiscordAppId(1350257232364961914)
		SetDiscordRichPresenceAsset('logo')
        SetDiscordRichPresenceAssetText('https://discord.gg/rwBHcCqzJB')
        SetDiscordRichPresenceAssetSmall(ass)
        SetDiscordRichPresenceAssetSmallText(name)

	Citizen.Wait(5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local pId = GetPlayerServerId(PlayerId())
		local pName = GetPlayerName(PlayerId())
		local maxPlayerSlots = 120
		players = {}
		for i = 0, 255 do
			if NetworkIsPlayerActive( i ) then
				table.insert( players, i )
			end
		end
		SetRichPresence(string.format("%s | %s Players | ID: %s", pName,#players, pId))


		SetDiscordRichPresenceAction(0, "🌐 Discord", "https://discord.gg/rwBHcCqzJB")
		SetDiscordRichPresenceAction(1, "➕ Connect ", "https://game-tools.ir/api/v1/connect/vmp?address=reven.ir:30120")

		Citizen.Wait(5000)
	end
end)