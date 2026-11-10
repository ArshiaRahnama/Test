-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil

local greenZone = {
	vec(-206.87,-1248.82,37.18,2200.0),	-- shahr asli
	vec(-105.62, 897.06, 236.42, 250),	-- ezafe shahr
	vec(-1909.58, 339.36, 88.91, 250),	-- ezafe shahr
	vec(-108.61,6407.37,31.49, 700.0),	-- paleto
	vec(1805.83,3747.41,33.56, 300.0),	-- sandy
	vec(905.17,2696.91,40.85, 365.0),	-- sandy mc
	vec(1734.2,3300.74,41.22,30.0),		-- air sandy
	vec(2544.99,-383.41,92.99,100.0),	-- fbi 2

	-- drug
	vec(2333.42,2578.74,46.44,60.0),	-- marijuana
	vec(3559.76,3674.53,28.12,150.0),	-- opum

	vec(-2193.59, 5169.49, 13.91,100.0),	-- event

	-- public jobs
	vec(-626.14,5083.66,131.8,250.0),	-- shekar
	vec(1964.35, 5187.15, 47.93, 40.0), -- khayati pashm
	vec(2736.94,1418.0,24.48,50.0),		-- sherkat naft raffin
	vec(-517.36, 5336.48, 74.1, 70.0),  -- najari
	vec(2955.26, 2787.55, 41.43, 100.0),-- mineri madan
	vec(297.6, 2869.64, 43.64, 40.0),   -- mineri gharbal

	vec(1690.8, 2591.14, 45.97, 140.0), -- prison

	vec(2732.11, 3479.14, 56.35, 60.0),   -- shams javaheri
	vec(-2951.75, 482.32, 15.12, 25.0),   -- mini bank saheli

	vec(-1954.99, 3317.02, 32.96, 200.0), -- dummy

}

openui = false
openui2 = false
lvl = 0
locksound = false
local gang_xp_config = {}
gang_xp_config[1] = 480
gang_xp_config[2] = 900
gang_xp_config[3] = 1500
gang_xp_config[4] = 2300
gang_xp_config[5] = 4000
gang_xp_config[6] = 6500
gang_xp_config[7] = 8600
gang_xp_config[8] = 11500
gang_xp_config[9] = 15000
gang_xp_config[10] = 18000
gang_xp_config[11] = 21600
gang_xp_config[12] = 26000
gang_xp_config[13] = 31000
gang_xp_config[14] = 37000
gang_xp_config[15] = 45000
gang_xp_config[16] = 53000
gang_xp_config[17] = 65000
gang_xp_config[18] = 77000
gang_xp_config[19] = 93000
gang_xp_config[20] = 110000
-- new level
gang_xp_config[21] = 150000
gang_xp_config[22] = 150000
gang_xp_config[23] = 150000
gang_xp_config[24] = 150000
gang_xp_config[25] = 150000
gang_xp_config[26] = 300000
gang_xp_config[27] = 450000
gang_xp_config[28] = 600000
gang_xp_config[29] = 900000
gang_xp_config[30] = 1000000
gang_xp_config[31] = 10000000
local gradeCount, gradeGangName = 0, nil

sanctionList = {
	'hamid',
	'ChErNobYl',
	'Black_Disciple',
	--'Vision', --  kamel
	-- 'North_Kids',
	--'Vendetta', -- borj 2 hazf shod
}

function checkSanction()
	return ESX.TableContainsValue(sanctionList, ESX.PlayerData.gang.name)
end

exports('checkSanction', checkSanction)

Citizen.CreateThread(function()
	ESX = exports['essentialmode']:getObject()

 	while ESX.GetPlayerData().gang == nil do
		Wait(1000)
	end

 	ESX.PlayerData = ESX.GetPlayerData()

	ESX.RegisterCommand('fireself', function()
		if ESX.PlayerData.gang.name == 'nogang' then
			return ESX.chatMessage('Shoma dar gangi nistid', 'plarms')
		end
		local alert = lib.alertDialog({
			header = 'Fire az gang',
			content = 'Aya az darkhast fire etminan darid? in amal gheir ghabel bazgasht ast',
			centered = true,
			cancel = true
		})
		if alert == 'confirm' then
			local alert = lib.alertDialog({
				header = 'درخواست خروج از گنگ',
				content = 'ایا از خروج از گنگ اطمینان دارید؟ این عمل غیر قابل بازگشت است',
				centered = true,
				cancel = true
			})
			if alert == 'confirm' then
				ESX.TriggerServerEvent('gangs:fireSelf')
			end
		end
	end, {help = 'Darkhast fire az gang'})
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
end)

RegisterNetEvent('gangs:xpupdate')
AddEventHandler('gangs:xpupdate', function(oldxp,newxp,needxp,newlvl)
	CreateRankBar(1,needxp,oldxp,newxp,newlvl)
end)
redcolor = false

RegisterNetEvent("gangs:newlevel")
AddEventHandler("gangs:newlevel", function(level,red)
    openui = true
    openui2 = true
    lvl = level
    if red then
        redcolor = true
    end
	levelBarThread()
    Citizen.SetTimeout(10000, function()
		openui = false
        openui2 = false
        if redcolor then
            redcolor = false
        end
    end)
end)
local capsCD = nil

Citizen.CreateThread(function()
	while ESX == nil do Wait(1000) end
	ESX.TriggerServerCallback("gangs:getzone",function(data)
		for k , v in ipairs(data) do
			local Blip = json.decode(v)
			local meleeBlip = AddBlipForRadius(Blip.x, Blip.y, Blip.z, (Blip.radius  or 50.0) + 0.0)
			SetBlipHighDetail(meleeBlip, true)
			SetBlipColour(meleeBlip, 17)
			SetBlipAlpha(meleeBlip, 100)
			SetBlipAsShortRange(meleeBlip, true)
		end
		TriggerEvent('gangs:zoneLoaded',data)
	end)
	for k, v in pairs(greenZone) do
		local meleeBlip = AddBlipForRadius(v)
		SetBlipHighDetail(meleeBlip, true)
		SetBlipColour(meleeBlip, 11)
		SetBlipAlpha(meleeBlip, 30)
		SetBlipAsShortRange(meleeBlip, true)
	end
end)

AddEventHandler('KeyDown:capital', function()
	if (not capsCD or capsCD < GetGameTimer()) then
		capsCD = GetGameTimer() + 15000
		ESX.TriggerServerCallback("gangs:getGangData2",function(data)
			if data ~=nil then
				CreateRankBar(1,gang_xp_config[data.level + 1],data.xp,data.xp,data.level)
			end
		end)
	end
end)

function levelBarThread()
	CreateThread(function()
		while openui do
			Citizen.Wait(0)
			if openui == true then

				if not locksound then
					PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
					locksound = true
				end
				local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

				if HasScaleformMovieLoaded(scaleform) then
					Citizen.Wait(0)

					PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
					BeginTextComponent("STRING")
					if redcolor then
						AddTextComponentString("~r~Gang Level Lose ".. lvl)
					else
						AddTextComponentString("~g~Well done Gang Level ".. lvl)
					end
					EndTextComponent()
					PopScaleformMovieFunctionVoid()

					Citizen.Wait(500)

					PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
					while openui2 do
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
						Citizen.Wait(0)
					end
					locksound = false
					openui = false
				end
			end
		end
	end)
end

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
	RankBarColor = 116
	RankBarColor = 6
	if not HasHudScaleformLoaded(19) then
		RequestHudScaleform(19)
		while not HasHudScaleformLoaded(19) do
			Wait(1)
		end
	end

	BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
	PushScaleformMovieFunctionParameterInt(RankBarColor)
	EndScaleformMovieMethodReturn()

	BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
	PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
	PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
	PushScaleformMovieFunctionParameterInt(playersPreviousXP)
	PushScaleformMovieFunctionParameterInt(playersCurrentXP)
	PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
	PushScaleformMovieFunctionParameterInt(100)
	EndScaleformMovieMethodReturn()
end

RegisterNetEvent('gangs:inv')
AddEventHandler('gangs:inv', function(gang)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Join',
		{
		title 	 = 'Voroud Be Gang',
		align    = 'center',
		question = 'Aya Shoma Mikhahid Vared Gang ('.. gang ..') Shavid?',
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheir', value = 'no'},
		}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'yes' then
				TriggerServerEvent("gangs:acceptinv")
			end
	end)
end)

function doesGradeHavePerm(perms, grade, key)
	return perms and perms[tostring(grade)] and perms[tostring(grade)][key]
end

AddEventHandler('gangs:openBossMenu', function(gang, close)
	local options = {
		{label = 'منوی مدیریت گنگ', args = 'gangMenu'},
	}

	print(ESX.GetPlayerData().gang.grade)

	if ESX.GetPlayerData().gang.grade >= getGradeCount() - 1 then
		table.insert(options, {label = 'منوی مزایده', args = 'auctionMenu'})
	end
	-- if not ESX.jobsGang[ESX.PlayerData.gang.name] then
	-- 	table.insert(options, {label = 'قرعه کشی', args = 'lottery'})
	-- end

	lib.registerMenu({
        id = 'gang_menu_1',
        title = 'Boss Action',
        options = options
    }, function(selected, scrollIndex, args)
        if args == 'gangMenu' then
			openGangAction()
		elseif args == 'lottery' then
			if ESX.PlayerData.gang.name ~= 'Army' and ESX.doesHaveGangPerm('ghoreKeshi') then
				if checkSanction() then
					return ESX.chatMessage('Nemitavanid dar ghore keshi sherkat konid', 'gang')
				end
				exports['sun-robbery']:buyTicket()
			end
		elseif args == 'auctionMenu' then
			TriggerEvent('auction:open')
        end
    end)
    lib.showMenu('gang_menu_1')
end)

local drawEndCD = false
local spam = false
local fetchBool = false
local jobsGang = {
	TX = true,
	Army = true,
	Mechanics = true,
	Weazels = true,
	Medics = true,
	D_O_J = true,
}

exports('isInGreenZone',function()
	local coords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(greenZone) do
		if ESX.GetDistance(coords,v.xyz) < v.w then
			return true
		end
	end
end)

RegisterNetEvent('cd:startNewPlanSession',function()
	if ESX.PlayerData.gang.name ~= 'nogang' and not jobsGang[ESX.PlayerData.gang.name] then
		TriggerEvent('chat:addMessage',{
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 150, 0, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i> Robbery Plan:<br>  {1}</div>',
			args = { '', 'Ghore keshi robbery ta 5 daghighe digar start mishavad!' }
		})
	end
end)

function getGradeCount()
	if gradeCount == 0 or not gradeGangName or gradeGangName ~= ESX.PlayerData.gang.name then
		Citizen.Await(promise.new(function (p)
			ESX.TriggerServerCallback('gangs:getGang', function(gang)
				if gang then
					gradeCount = ESX.tableLength(gang.grades)
					gradeGangName = ESX.PlayerData.gang.name
				end
				p:resolve()
			end)
		end))
	end
	return gradeCount
end

exports('getGradeCount', getGradeCount)