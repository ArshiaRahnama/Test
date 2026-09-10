ESX = nil 

CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
		Wait(0)
	end
end)
local weapons = {'WEAPON_DAGGER','WEAPON_BAT','WEAPON_BOTTLE','WEAPON_CROWBAR','WEAPON_FLASHLIGHT','WEAPON_GOLFCLUB','WEAPON_HAMMER','WEAPON_HATCHET','WEAPON_KNUCKLE','WEAPON_KNIFE','WEAPON_MACHETE','WEAPON_SWITCHBLADE','WEAPON_NIGHTSTICK','WEAPON_WRENCH','WEAPON_BATTLEAXE','WEAPON_POOLCUE','WEAPON_STONE_HATCHET','WEAPON_PISTOL','WEAPON_PISTOL_MK2','WEAPON_COMBATPISTOL','WEAPON_APPISTOL','WEAPON_STUNGUN','WEAPON_PISTOL50','WEAPON_SNSPISTOL','WEAPON_SNSPISTOL_MK2','WEAPON_HEAVYPISTOL','WEAPON_VINTAGEPISTOL','WEAPON_MARKSMANPISTOL','WEAPON_REVOLVER','WEAPON_REVOLVER_MK2','WEAPON_DOUBLEACTION','WEAPON_RAYPISTOL','WEAPON_CERAMICPISTOL','WEAPON_NAVYREVOLVER','WEAPON_GADGETPISTOL','WEAPON_MICROSMG','WEAPON_SMG','WEAPON_SMG_MK2','WEAPON_ASSAULTSMG','WEAPON_COMBATPDW','WEAPON_MACHINEPISTOL','WEAPON_MINISMG','WEAPON_RAYCARBINE','WEAPON_PUMPSHOTGUN','WEAPON_PUMPSHOTGUN_MK2','WEAPON_SAWNOFFSHOTGUN','WEAPON_ASSAULTSHOTGUN','WEAPON_BULLPUPSHOTGUN','WEAPON_MUSKET','WEAPON_HEAVYSHOTGUN','WEAPON_DBSHOTGUN','WEAPON_AUTOSHOTGUN','WEAPON_COMBATSHOTGUN','WEAPON_ASSAULTRIFLE','WEAPON_ASSAULTRIFLE_MK2','WEAPON_CARBINERIFLE','WEAPON_CARBINERIFLE_MK2','WEAPON_ADVANCEDRIFLE','WEAPON_SPECIALCARBINE','WEAPON_SPECIALCARBINE_MK2','WEAPON_BULLPUPRIFLE','WEAPON_BULLPUPRIFLE_MK2','WEAPON_COMPACTRIFLE','WEAPON_MILITARYRIFLE','WEAPON_MG','WEAPON_COMBATMG','WEAPON_COMBATMG_MK2','WEAPON_GUSENBERG','WEAPON_SNIPERRIFLE','WEAPON_HEAVYSNIPER','WEAPON_HEAVYSNIPER_MK2','WEAPON_MARKSMANRIFLE','WEAPON_MARKSMANRIFLE_MK2','WEAPON_RPG','WEAPON_GRENADELAUNCHER','WEAPON_GRENADELAUNCHER_SMOKE','WEAPON_MINIGUN','WEAPON_FIREWORK','WEAPON_RAILGUN','WEAPON_HOMINGLAUNCHER','WEAPON_COMPACTLAUNCHER','WEAPON_RAYMINIGUN','WEAPON_GRENADE','WEAPON_BZGAS','WEAPON_MOLOTOV','WEAPON_STICKYBOMB','WEAPON_PROXMINE','WEAPON_SNOWBALL','WEAPON_PIPEBOMB','WEAPON_BALL','WEAPON_SMOKEGRENADE','WEAPON_FLARE','WEAPON_PETROLCAN','WEAPON_FIREEXTINGUISHER','WEAPON_HAZARDCAN'}
local safeweapons = { 'WEAPON_BZGAS','WEAPON_GUSENBERG' ,'WEAPON_PISTOL','WEAPON_MOLOTOV','WEAPON_PISTOL_MK2','WEAPON_SMOKEGRENADE','WEAPON_COMBATPISTOL','WEAPON_APPISTOL','WEAPON_PISTOL50','WEAPON_HEAVYSHOTGUN','WEAPON_ASSAULTSHOTGUN','WEAPON_HEAVYPISTOL','WEAPON_VINTAGEPISTOL','WEAPON_MICROSMG','WEAPON_SMG','WEAPON_SMG_MK2','WEAPON_BULLPUPSHOTGUN','WEAPON_ASSAULTRIFLE','WEAPON_ASSAULTRIFLE_MK2','WEAPON_CARBINERIFLE','WEAPON_CARBINERIFLE_MK2','WEAPON_ADVANCEDRIFLE','WEAPON_SPECIALCARBINE','WEAPON_SPECIALCARBINE_MK2','WEAPON_BULLPUPRIFLE','WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_COMPACTRIFLE','WEAPON_COMBATPDW', 'WEAPON_ASSAULTSMG','WEAPON_SWITCHBLADE',}
local requiredModels = {"p_cargo_chute_s","ex_prop_adv_case_sm","prop_box_ammo03a","prop_box_wood05a","Supervolito" ,  "ex_office_swag_guns04"}
local AirDrops = {'WEAPON_MG','WEAPON_COMBATMG','WEAPON_COMBATMG_MK2','WEAPON_SNIPERRIFLE','WEAPON_HEAVYSNIPER',}
local MySelf , Distance , Zone , GlobalCoord ,Time , MyKill , AllPlayers  , NZone , GulagPlayer , ZamanSanj , MyCash  , SaveZone  = 0,0 , 0 , 0 ,0 ,0 ,0 ,0 ,0 ,0 , 0 , 0
local inheli,jump,InWarzone , PlayerDead  , Dlay  , inLobby  , inmatch , LootNow ,StartTimer , ingulag ,GulagTime , heal ,vest , showNext , inshopbox  = false,false,false , false , false , false ,false ,false ,false ,false ,false , false , false , false , false
local AllLoots  ,  AirDropGetLoot  , MyWeapon , BodyLoots , ShopBoxes , ShopCoords , TeamBlip , MyPlayersID = {} , {} ,{} , {} , {}, {} , {} , {}
local MarkerWarzone  , planekey  , tempBlip ,  plane , pilot   = nil , nil   , nil ,  nil   , nil  
local GulagCoord  =  Config.GulagZone 
local model = GetHashKey( Config.airplane)
local armoritem , bandageitem = 0 , 0
-- Fix: ZoneOne used to be declared as a `local` further down the file (after
-- the AWZ:StartMatch handler), so the `ZoneOne = true` reset inside
-- AWZ:StartMatch was actually creating/writing a separate GLOBAL variable.
-- ZoneRuning() read/wrote its own local copy that never got reset back to
-- true, so shop rotation (Sandy1->2->3) broke on the second match of a
-- session. Declaring it once here fixes that.
local ZoneOne = true
-- Spectator Mode state
local InSpectator = false
local SpectatorTargets = {}
local SpectatorIndex = 1
local SpectatorCam = nil
-- Private Loadout (shop item) state -- see PrivteLoadout() fix notes
local LoadoutCharges = 0
local UsingLoadout = false
local AllUav = 0 
local UAVLine  = false 
local solo = false 
local MapName = 'MapName'
local ShopsNumber = 0 
local Uniforms = {
	['WZ'] =	{
		male = json.decode('{"pants_1":60,"helmet_2":0,"shoes_2":0,"tshirt_1":15,"torso_2":2,"torso_1":12,"shoes_1":27,"arms":1,"tshirt_2":0,"pants_2":4,"helmet_1":54}') , 
		female = json.decode('{"pants_1":60,"helmet_2":0,"shoes_2":0,"tshirt_1":15,"torso_2":2,"torso_1":12,"shoes_1":27,"arms":1,"tshirt_2":0,"pants_2":4,"helmet_1":54}') , 
	},
}
------------------------------------
---Events 
------------------------------------ 
RegisterNetEvent("AWZ:StartMatch")
AddEventHandler("AWZ:StartMatch",function(Blood , DistanceZone , WzCoord , TimeMoveZone , Diff , Map )
	armoritem , bandageitem = 2 , 2
	AllUav = 1 
	---- Number ----
	   MySelf = Blood 
	   Distance = DistanceZone + 0.0
	   GlobalCoord  = WzCoord
	   Time = TimeMoveZone
	   Zone = DistanceZone
	   SaveZone = DistanceZone
	   MyCash = 0
	   NZone = DistanceZone 
	   MapName = Map
	---- bool ----
	   ZoneOne = true 
	   inLobby = false 
	   inheli = false 
	   jump = false 
	   PlayerDead = false
	   ingulag = false  
	   LootNow = false 
	   GulagTime = false 
	   InWarzone = true 
	   inshopbox = false
	   Dlay = true 
	   idtimeout = nil 
	------
	Revive()
	PlayNowSound("5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset")
    ESX.ShowMissionText("")
	FreezePlayer(false)
	SetClothes()
	SetMaxHealth()
	SetPedArmour(PlayerPedId(), 100)
	ClearPedBloodDamage(PlayerPedId())
	ESX.UI.Menu.CloseAll()
	RemoveAllPedWeapons(PlayerPedId(), 1)
	--
	CreateThread(function()
		for k,v in pairs(ShopBoxes) do 
			if DoesBlipExist(v.Blip) then
			RemoveBlip(v.Blip)
			end 
			if DoesEntityExist(v.Box) then 
				DeleteEntity(v.Box)
				DeleteEntity(v.Chatr)
			end 
		end
	end)
	--Anim
	CreateThread(function()
		RequestAnimDict('clothingtie')
		if not HasAnimDictLoaded('clothingtie') then
			RequestAnimDict('clothingtie') 
			while not HasAnimDictLoaded('clothingtie') do 
				Wait(1)
			end
		end
	end)
	--
	CreateShop( Config.shops [ string.upper ( MapName.. 1 ) ] )
	---
	Wait(1 * 1000)
	inmatch = true 
	CloseUiINWz()
	StartDrop()
	ShowBoxLootTexT()
	ShowZone()
	MarkerWarzone = MakeZoneBlip(GlobalCoord , DistanceZone )
	SetTimeout(5* 1000, function()
		SendNUIMessage({message	= "music",Name = 'joinbattle'}) 
	end)
	WarZone(true)
    Wait(Time * 60000)
    ZoneRuning()
end) 
RegisterNetEvent("AWZ:MyTeam")
AddEventHandler("AWZ:MyTeam",function( Myteam , Count , id , MyName  )
	local Myteam = Myteam 
	local MyId = id
	local MyName = MyName 
	local TeamInfo = {}
	TeamInfo[1] = { ID = 0 , Name = 'none'}
	TeamInfo[2]	= { ID = 0 , Name = 'none'}
	TeamInfo[3] = { ID = 0 , Name = 'none'}
	TeamInfo[4] = { ID = 0 , Name = 'none'}
	local keyI = 1 
    for i = 1 , 4  , 1 do  
		if type(Myteam[i]) == 'table' then 
			if  Myteam[i].ID ~= id then 
				TeamInfo[keyI] = Myteam[i]  
				keyI = keyI + 1
			end  
		end 
	end 
	UpdateStatus( Count ,
		TeamInfo[1].ID    ,  TeamInfo[1].Name   ,
		TeamInfo[2].ID    ,  TeamInfo[2].Name   , 
		TeamInfo[3].ID    ,  TeamInfo[3].Name   , 
		MyId , MyName 
	)
end) 
RegisterNetEvent("AWZ:ExitMision")
AddEventHandler("AWZ:ExitMision",function()
	-- Fix/feature: if this player was spectating (eliminated but their
	-- squad was still alive), make sure the free-cam + invisibility state
	-- gets torn down before the normal exit cleanup runs below.
	if InSpectator then
		StopSpectating()
	end
	TriggerServerEvent("AWZ:SetRBucket",0)
	armoritem , bandageitem = 0 , 0 
	ESX.TriggerServerCallback('AWZ:RemoveForSquad', function(remove) end)
	Revive()
	SendNUIMessage({message	= "closeIngame",})
	PlayNowSound("Hit", "RESPAWN_ONLINE_SOUNDSET")
	ingulag = false
	statusfull()
	FreezePlayer(false)
	disableDeadEfect(false)
	SetMaxHealth()
	ESX.ShowMissionText("")
	if next(TeamBlip) then
		for k,v in pairs( TeamBlip ) do 
			if DoesBlipExist( v ) then 
				RemoveBlip( v )
			end 
		end 
	end
	for k,v in pairs(BodyLoots) do 
		DeleteEntity(v.Box)
	end 
	for k,v in pairs(AllLoots) do 
		DeleteObject(v.Box)
		DeleteObject(v.Chatr)
   	end 
	for k,v in pairs(ShopBoxes) do 
		DeleteEntity(v.Box)
		RemoveBlip(v.Blip)
	 end
	 RemoveBlip(tempBlip)
	 RemoveBlip(MarkerWarzone) 
 	MySelf , Distance , Zone , GlobalCoord ,Time , MyKill , AllPlayers  , NZone , GulagPlayer , ZamanSanj , MyCash  , SaveZone  = 0,0 , 0 , 0 ,0 ,0 ,0 ,0 ,0 ,0 , 0 , 0
 	inheli,jump,InWarzone , PlayerDead  , Dlay  , inLobby  , inmatch , LootNow ,StartTimer , ingulag ,GulagTime , heal ,vest , showNext , inshopbox  = false,false,false , false , false , false ,false ,false ,false ,false ,false , false , false , false , false
 	AllLoots  ,  AirDropGetLoot  , BodyLoots , ShopBoxes , ShopCoords = {} , {} , {} , {}, {} 
 	MarkerWarzone  , planekey  , tempBlip ,  plane , pilot  = nil , nil   , nil ,  nil   , nil 
	DeleteVehicle(plane)
	DeleteEntity(pilot)
	SetEntityVisible(PlayerPedId(), true,true)
	FreezeEntityPosition(PlayerPedId(),false)
	DetachEntity(PlayerPedId(), true, true)
	SetEntityCollision(PlayerPedId(), true, true)
	SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
	SetEntityVisible(PlayerPedId(), false,false)
	ReviveTrigger()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)			
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
	Wait(3000)
	ESX.ShowMissionText("")
	RemoveAllPedWeapons(PlayerPedId(),1)
	Wait(1000)
	LoadWeapon()

	SetEntityCoords(PlayerPedId(),Config.LastCoord .x,Config.LastCoord .y,Config.LastCoord .z + 2)
	Wait(1000)
	SetEntityVisible(PlayerPedId(), true ,true)
	Wait(710)
	ReviveTrigger()
	SetPedArmour(PlayerPedId(),0)
	SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
end)
-------------------------------------------------------------------
-- Spectator Mode: eliminated (lost the Gulag) but your squad is still
-- fighting, so instead of a full exit you get a free-cam following your
-- surviving teammates until either you leave (BACKSPACE) or the match ends.
-------------------------------------------------------------------
RegisterNetEvent("AWZ:EnterSpectator")
AddEventHandler("AWZ:EnterSpectator", function(mateIds)
	SpectatorTargets = mateIds or {}
	if #SpectatorTargets == 0 then
		-- no one left to spectate, just exit normally
		TriggerEvent("AWZ:ExitMision")
		return
	end
	InSpectator = true
	SpectatorIndex = 1
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false, false)
	SetEntityCollision(ped, false, false)
	SetEntityInvincible(ped, true)
	RemoveAllPedWeapons(ped, true)
	SendNUIMessage({ message = "closeIngame" })
	ESX.ShowNotification('You are eliminated — spectating your squad. [LEFT/RIGHT] to switch, [BACKSPACE] to leave.')
	SpectatorCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamActive(SpectatorCam, true)
	RenderScriptCams(true, true, 500, true, true)
	CreateThread(function()
		while InSpectator do
			Wait(0)
			local targetId = SpectatorTargets[SpectatorIndex]
			local targetPed = targetId and GetPlayerPed(GetPlayerFromServerId(targetId))
			if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
				local coords = GetEntityCoords(targetPed)
				local camCoords = coords + vector3(0.0, -4.0, 2.0)
				SetCamCoord(SpectatorCam, camCoords.x, camCoords.y, camCoords.z)
				PointCamAtEntity(SpectatorCam, targetPed, 0.0, 0.0, 0.6, true)
				SendNUIMessage({ message = "spectating", Name = GetPlayerName(GetPlayerFromServerId(targetId)) })
			else
				-- this teammate is no longer valid (disconnected/invalid) --
				-- drop them from the rotation
				table.remove(SpectatorTargets, SpectatorIndex)
				if #SpectatorTargets == 0 then
					TriggerServerEvent("AWZ:LeaveSpectator")
					break
				end
				if SpectatorIndex > #SpectatorTargets then SpectatorIndex = 1 end
			end
			if IsControlJustPressed(0, 175) and #SpectatorTargets > 0 then -- ARROW RIGHT
				SpectatorIndex = SpectatorIndex + 1
				if SpectatorIndex > #SpectatorTargets then SpectatorIndex = 1 end
			elseif IsControlJustPressed(0, 174) and #SpectatorTargets > 0 then -- ARROW LEFT
				SpectatorIndex = SpectatorIndex - 1
				if SpectatorIndex < 1 then SpectatorIndex = #SpectatorTargets end
			elseif IsControlJustPressed(0, 194) then -- BACKSPACE
				TriggerServerEvent("AWZ:LeaveSpectator")
				break
			end
		end
	end)
end)
function StopSpectating()
	InSpectator = false
	SpectatorTargets = {}
	SpectatorIndex = 1
	if SpectatorCam then
		RenderScriptCams(false, true, 500, true, true)
		DestroyCam(SpectatorCam, false)
		SpectatorCam = nil
	end
	SendNUIMessage({ message = "closeIngame" })
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, false)
	SetEntityVisible(ped, true, true)
	SetEntityCollision(ped, true, true)
	SetEntityInvincible(ped, false)
end
RegisterNetEvent("AWZ:respwan")
AddEventHandler("AWZ:respwan",function(addkill , Killed , Killer)
	if addkill then 
		MyKill = MyKill + 1 
		MyCash = MyCash + 500
		SendNUIMessage({message	= "kill",MyKill =  MyKill ,}) 
		SendNUIMessage({message	= "cash",MyCash =  MyCash ,}) 
		SendNUIMessage({message = 'kilmsg' ,Killer = Killer , killed = Killed  })
		SetTimeout(3000 , function() SendNUIMessage({message = 'delmsg'}) end)
		return 
	end 
	RemoveAllPedWeapons(PlayerPedId(),1)
	PlayerDead = true 
	if InWarzone then 
		PlayerDead = true
		MySelf = MySelf -1
		if MySelf > 0  then 
			local pos = GetEntityCoords(PlayerPedId())
			SetEntityCoords( PlayerPedId() ,vector3( pos.x , pos.y , pos.z + 200) , false )
			FreezePlayer(  true  )  
			SetEntityVisible(PlayerPedId(), true ,true)
			FreezeEntityPosition( PlayerPedId() , true )
			SetPlayerCanRevive()
		else 
			-- Fix: this branch used to be commented out entirely, which made
			-- SetPLayerInGulag() -- a fully built and working feature, both
			-- here and on the server -- permanently unreachable dead code.
			-- Running out of redeploys used to just revive the player in
			-- place and immediately exit them from the match instead of
			-- giving them their one shot at fighting back in via the Gulag.
			if not GulagTime  then 
				GulagTime = true 
				SetPLayerInGulag() 
			else  
				Revive()
				TriggerEvent("AWZ:ExitMision")
			end 
		end 
	end

end)
function SetPlayerCanRevive()
	Revive()
	RemoveAllPedWeapons(PlayerPedId(),1)
	SetEntityVisible(PlayerPedId(), false,false)
	ESX.ShowMissionText("")
	WarZone()
end 

------------------------------------
---UI 
------------------------------------ 
RegisterNetEvent("AWZ:OpenUI")
AddEventHandler("AWZ:OpenUI",function()
	SetNuiFocus(true, true)
    SendNUIMessage({
	    message	= "open"
	})	
end)
RegisterNetEvent("AWZ:CloseUI")
AddEventHandler("AWZ:CloseUI",function()
	SetNuiFocus(false, false)
    SendNUIMessage({
	    message	= "close"
	})	
end)
-- Fix: server-side SendNotifyServerToPlayer() now routes here instead of the
-- nonexistent 'esx:ShowNotification' net event, so admin/error messages
-- (e.g. "Warzone has started") actually reach the player.
RegisterNetEvent("AWZ:ShowNotification")
AddEventHandler("AWZ:ShowNotification", function(msg)
	ESX.ShowNotification(msg)
end)
RegisterNUICallback('start', function(data, cb)
	SetNuiFocus(false, false)
	ESX.TriggerServerCallback('AWZ:SetPlayerInWarZone', function(CanJoin) 
		if CanJoin then 
			JoinLobbey()
		end 
	end)
end)
RegisterNUICallback('exit', function(data, cb)
	SetNuiFocus(false, false)
end)
-------------------------------------------------------------------
-- Admin GUI panel: replaces typing /startmatch <blood> <time> <map> <team>
-- by hand (which is where the classic typo-crash used to come from).
-------------------------------------------------------------------
RegisterNetEvent("AWZ:OpenAdminPanel")
AddEventHandler("AWZ:OpenAdminPanel", function(lobbyOpen, matchStarted)
	SetNuiFocus(true, true)
	SendNUIMessage({
		message = "openAdminPanel",
		lobbyOpen = lobbyOpen,
		matchStarted = matchStarted,
		startCommend = Config.StartCommend,
	})
end)
RegisterNUICallback('adminOpenLobby', function(data, cb)
	TriggerServerEvent('AWZ:AdminOpenLobby')
	cb('ok')
end)
RegisterNUICallback('adminStart', function(data, cb)
	TriggerServerEvent('AWZ:AdminStart', data.blood, data.time, data.map, data.team)
	SetNuiFocus(false, false)
	cb('ok')
end)
RegisterNUICallback('adminPanelClose', function(data, cb)
	SetNuiFocus(false, false)
	cb('ok')
end)
-----------------------------------
--function
-----------------------------------
function JoinLobbey()
	CreateThread(function()
		BlackSceern(6000)
		Wait(1500)
		insertToJoinLobbey()
		AllLoots = {}
		InWarzone = true 
		inmatch = false 
		inLobby = true 
		SaveWeapons()
		ESX.UI.Menu.CloseAll()
		ClearPedBloodDamage(PlayerPedId())
		SetEntityCoords(PlayerPedId(),Config.LobbeyCoord )
		Wait(50) 
		FreezePlayer(true)
		Wait(5000)
		RemoveAllPedWeapons(PlayerPedId(),1)
		FreezePlayer(false)
		statusfull()
		Wait(710)
		ReviveTrigger()
		SetMaxHealth()
		disableDeadEfect( true )
		LobbeyDisbale()
		SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
		for i = 1, #requiredModels do
			RequestModel(GetHashKey(requiredModels[i]))
			while not HasModelLoaded(GetHashKey(requiredModels[i])) do
			Wait(0)
			end
		end
		Wait(500)
	end)
end
function SaveWeapons()
	-- Fix: 'wept' had no `local`, leaking it as a global.
	local wept = ESX.GetPlayerData().loadout
    for k , v in ipairs(wept) do
        if wept then
            table.insert(MyWeapon,{label = v.label, name = v.name, ammo = v.ammo, components = v.components})
        end
    end
end 




function LoadWeapon()
	ESX.TriggerServerCallback('setweapons', function(asd) 
		if asd then 
			Wait(20)
			MyWeapon = {}
		end
	end, MyWeapon)
end 


function BlackSceern(w)
	CreateThread(function()
	DoScreenFadeOut(1000)
    Wait(w)
    DoScreenFadeIn(1000)
	end)
end
function  SetBlipForTeam( i )
		local blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(i)))
		SetBlipSprite(blip, 480)
		table.insert(TeamBlip , blip )
end
function LobbeyDisbale()
	CreateThread(function()
		while inLobby do 
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 263, true) -- Melee Attack 1
			ESX.UI.Menu.CloseAll()
			 Wait(5)
		end 
	end)
end 
function SetClothes()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin,Uniforms["WZ"].male  )
		else
			TriggerEvent('skinchanger:loadClothes', skin,Uniforms["WZ"].female )
		end
	end)
end 

-------------------------------
--Wz Function
-------------------------------
function Revive()
    SetEntityCoordsNoOffset(PlayerPedId(), GetEntityCoords(PlayerPedId()), false, false, false, true)
    NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 20, true, false)
    SetPlayerInvincible(PlayerPedId(), false)                            
	SetPedArmour(PlayerPedId(), 0)                        
    ClearPedBloodDamage(PlayerPedId())
    ESX.UI.Menu.CloseAll()
	SetMaxHealth()
    PlayerDead = false
	statusfull()
end 

function CloseUiINWz()
	CreateThread(function()
		while InWarzone do 
			if not  inshopbox then 
				ESX.UI.Menu.CloseAll()
			else 
				Wait(1000)
			end 
			if not HasPedGotWeapon(PlayerPedId(), GetHashKey("gadget_parachute"), false) then
				AddWeapon('gadget_parachute' , 1)
			end
	 		Wait(1500)
		end 
	end)
 	CreateThread(function()
    	while InWarzone do
        	Wait(1000)   
        	if inmatch then 
           		if not InWarzone  then return end  
        			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GlobalCoord,false) > Distance   then 	
           				 if PlayerDead == false and inheli == false and Dlay == false  and ingulag == false and jump == true    then 
							SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) - 5 )
            				ESX.ShowMissionText("~r~You are outside the zone ")
           	 				DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
            			else 
                			Wait(1000) 
            			end
        			else 
        				Wait(1000) 
        			end 
   			end 
      	end 
  	end)
end 
function StartDrop()
	CreateThread(function()
		while InWarzone do 
			Wait(25000)
            if not InWarzone  then return end 
			if LootNow  then 
				CreateAirDrop()
			end 
		end 
	end)
end 
function CreateAirDrop()
    if not InWarzone  then return end 
	local WeaponForThisLoot   
	local Pos1 = math.random(-100,100)
    local Pos2 = math.random(-100,100)
	local we = math.random(1,30)
	for k,v in pairs(safeweapons) do 
		if we == k then 
			WeaponForThisLoot  = v 
		end 
	end 
        if heal then 
            heal = false 
            vest = true 
        else 
            heal = true
            vest = false 
        end  
	CreateThread(function()
		local Keys = #AllLoots 
		if  Keys > 5 then 
			for k,v in pairs(AllLoots) do 
				DeleteEntity(v.Box)
				DeleteEntity(v.Chatr)
				table.remove(AllLoots , k,v)
				break  
			end
		end 
		local MyCoord = GetEntityCoords(PlayerPedId())
		local crateSpawn = vector3(MyCoord.x + Pos1 + 0.0, MyCoord.y + Pos2  + 0.0, MyCoord.z + 70 + 0.0) 
	    local objLootBox = CreateObject(GetHashKey("prop_box_ammo03a"), crateSpawn, false, true, true) 
		local UavChans = math.random(1,100)
		local Uav = false  
		local Money =  math.random(100 , 500)
		if UavChans >= 80 then 
			Uav = true 
		end 
        SetEntityLodDist(objLootBox, 2000) 
        ActivatePhysics(objLootBox)
        SetDamping(objLootBox, 2, 0.1) 
        SetEntityVelocity(objLootBox, 0.0, 0.0, -0.2)
		local parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, false, true, true) 
        SetEntityLodDist(parachute, 2000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
		AttachEntityToEntity(parachute, objLootBox, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) 
		table.insert(AllLoots,{Box = objLootBox ,  Chatr = parachute , weapon = WeaponForThisLoot , Heal = heal , Vest = vest , Uav = Uav  , Money = Money})
		while not IsEntityAttached(parachute) do
			Wait(0)
			AttachEntityToEntity(parachute, objLootBox, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
		end
	end)
end  
function ShowBoxLootTexT()
	local Waitt = true 
	CreateThread(function()
		while  InWarzone do 
			Wait(5)
			Waitt = true
			for k,v in pairs (AllLoots) do 
		   		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId() ) , GetEntityCoords(v.Chatr) , false  )   < 4.0 then 
					local crds = GetEntityCoords(v.Chatr) 
					local tostrings =  tostring(v.weapon)
					local weapon = string.gsub(tostrings, "WEAPON_", " ")
					local other
						if v.Heal then 
							other = "~y~ Bandage [1]" .. " ~w~|~g~  " .. v.Money ..'$'
						else 
							other = "~b~ Armor [1]".. "~w~ |~g~ " .. v.Money ..'$'
						end 
		    		local string = "~r~"..weapon.."~w~ | "..other
					if v.Uav then 
						string =	"~r~"..weapon.."~w~ | "..other .. ' ~w~| ~p~' .. 'UAV'
					end 
					Draw3DText(crds.x,crds.y,crds.z ,string,4, 0.1, 0.1)
					Waitt = false 
		   		end 
			end 
			for k,v in pairs (ShopBoxes) do 
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId() ) , GetEntityCoords(v.Box) , false  )   < 5.0 then 
					local crds = GetEntityCoords(v.Box) 
			 		local string = "~y~WarZone Shop"
			 		Draw3DText(crds.x,crds.y,crds.z ,string,4, 0.1, 0.1)
			 		Waitt = false 
				end 
		 	end 
			if MyPlayersID[1] ~= 0 then 
				local crds = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(MyPlayersID[1])))
				local string = "~w~[~b~Teammate~w~]"
				if IsEntityOnScreen( GetPlayerPed(GetPlayerFromServerId(MyPlayersID[1]))) then 
					Draw3DText(crds.x,crds.y,crds.z ,string,4, 0.1, 0.1)
					Waitt = false 
				end 
			end 
			if MyPlayersID[2] ~= 0 then 
				local crds = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(MyPlayersID[2])))
				local string = "~w~[~b~Teammate~w~]"
				if IsEntityOnScreen( GetPlayerPed(GetPlayerFromServerId(MyPlayersID[2]))) then 
					Draw3DText(crds.x,crds.y,crds.z ,string,4, 0.1, 0.1)
					Waitt = false 
				end 
			end 
			if MyPlayersID[3] ~= 0 then 
				local crds = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(MyPlayersID[3])))
				local string = "~w~[~b~Teammate~w~]"
				if IsEntityOnScreen( GetPlayerPed(GetPlayerFromServerId(MyPlayersID[3])) ) then 
					Draw3DText(crds.x,crds.y,crds.z ,string,4, 0.1, 0.1)
					Waitt = false 
				end 
			end 
			if Waitt then 
				inshopbox = false
				ESX.UI.Menu.CloseAll() 
				Wait(850)
			end 
		end  
	end)
end
function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end
function ShowZone()
	CreateThread(function()
		while InWarzone do
			if  ingulag then
				DrawMarker(28,GulagCoord , 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 50 + 0.0, 50 +0.0, 50 +0.0, 255, 128, 0, 50, false, true, 2, nil, nil, false)
            	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GulagCoord , false ) > 50.0 then 
            		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) - 3 )
            	end 
			else 
				if inheli then 
             		ESX.ShowHelpNotification(" For Jump Presse ~INPUT_VEH_EXIT~ ")	
				end
				DrawMarker(28, GlobalCoord, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Distance + 0.0, Distance +0.0, Distance +0.0, 255, 128, 0, 50, false, true, 2, nil, nil, false)		 
			end 
			Wait(5)
		end
	end)
end 
function MakeZoneBlip(pos, radius , color )
	local blip = AddBlipForRadius(vector3(pos.x , pos.y , pos.z ), radius + 0.0)
	SetBlipHighDetail(blip, true)
	if color ~= nil then 
		SetBlipColour(blip, color)
	else 
	SetBlipColour(blip, 1)
	end 
	SetBlipAlpha (blip, 255)
	SetBlipFade(blip, 40, 40)
	SetBlipAsShortRange(blip, true)
	return tonumber(blip)
end
function CreateShop(SCoord)
	CreateThread(function()
		for k,v in pairs(SCoord) do 
			ShopWzDrop(v  )
		end 
	end)
end 
function ShopWzDrop(PlaneCoords, Code)
	if realyWait  then return end 
	CreateThread(function()
    	local crateSpawn = vector3(PlaneCoords.x , PlaneCoords.y ,PlaneCoords.z - 1)
		local blip2
		local ShopBox = nil 
			RequestModel(GetHashKey("ex_office_swag_guns04"))
			while not HasModelLoaded(GetHashKey("ex_office_swag_guns04")) do
			Wait(1)
			end
       		ShopBox = CreateObject(GetHashKey("ex_office_swag_guns04"), crateSpawn, false, true, true) 
	   		SetEntityLodDist(ShopBox, 2000) 
	   		ActivatePhysics(ShopBox)
	   		SetDamping(ShopBox, 2, 0.1) 
	   		SetEntityVelocity(ShopBox, 0.0, 0.0, -0.2)
       		FreezeEntityPosition(ShopBox , true)
	   		blip2 = AddBlipForCoord(GetEntityCoords(ShopBox))
	  		SetBlipSprite (blip2,434)
	   		SetBlipDisplay(blip2, 2)
	  		SetBlipScale  (blip2,1.3)
	  		SetBlipColour (blip2,1)
	 		SetBlipAsShortRange(blip2, true)
	  		BeginTextCommandSetBlipName("STRING")
	   		AddTextComponentString('DWZ Shop')
	   		EndTextCommandSetBlipName(blip2)
	   		table.insert(ShopBoxes,{Box = ShopBox , Blip = blip2 , CanUse = true   })
	end)

end
local dropcheack = false 
function WarZone(loadHud)
	CreateThread(function()
    	if not InWarzone then   TriggerEvent("AWZ:ExitMision") return end 
		armoritem , bandageitem = 2 , 2
		MyCash = 0
		SendNUIMessage({message	= "cash",MyCash =  MyCash ,}) 
		AllUav = 1 
		PlayerDead = false 
		for k,v in pairs(AllLoots) do 
			DeleteObject(v.Box)
			DeleteObject(v.Chatr)
   		end 
		AllLoots = {}
		Dlay = true 
		LootNow = false
    	jump = false 
		ReviveTrigger() 
    	RequestModel(model)
    	while not HasModelLoaded(model) do
		Wait(1)
		end
    	DeleteVehicle(plane)
    	Wait(200)
		plane = CreateVehicle(model,GlobalCoord.x, GlobalCoord.y - Zone, GlobalCoord.z + Zone, 10, false, true)
		while not HasModelLoaded(model) do
			Wait(1)
		end
		while not DoesEntityExist(plane) do
			plane = CreateVehicle(model,GlobalCoord.x, GlobalCoord.y - Zone, GlobalCoord.z + Zone, 10, false, true)
			Wait(0)
		end 
		FreezeEntityPosition(plane, true)
		Wait(500)
		SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
		RemoveAllPedWeapons(PlayerPedId(),1)
		SetEntityVisible(PlayerPedId(), false,false)
		SetEntityDynamic(plane, true)
		ActivatePhysics(plane)
		SetVehicleForwardSpeed(plane, 100.0)
		SetHeliBladesFullSpeed(plane)
		SetVehicleEngineOn(plane, true, true, false)
		ControlLandingGear(plane, 1)
		OpenBombBayDoors(plane)
		SetEntityProofs(plane, true, false, true, false, false, false, false, false)
		pilot = CreatePedInsideVehicle(plane, 1, GetHashKey("mp_m_freemode_01"), -1, false, true)
		SetBlockingOfNonTemporaryEvents(pilot, true)
		SetPedKeepTask(pilot, true)
		SetPlaneMinHeightAboveTerrain(plane, 50)
		TaskVehicleDriveToCoord(pilot, plane,GlobalCoord.x, GlobalCoord.y + Zone, GlobalCoord.z + Zone + 5, 90.0, 95.0, model, 16777216, 1.0, 1)
		FreezePlayer(  false  )  
		SetEntityVisible(PlayerPedId(), false ,false)
		Wait(5000)
		ClearPedTasksImmediately(PlayerPedId())
		SetPedArmour(PlayerPedId(),0) 
		SetEntityCollision(PlayerPedId(), false, false)
		TaskWarpPedIntoVehicle(PlayerPedId(),plane, 2)
		if loadHud then SendNUIMessage({message	= "Ingame",}) end 
		FreezeEntityPosition(plane, false)
		Wait(2000)
		SetMaxHealth()
		jump = false
		inheli = true
		-- Fix: this used to AddEventHandler('onKeyDown', ...) here, and
		-- WarZone() runs again on every redeploy/Gulag win -- so after a few
		-- deaths each 'f' press would call JumpNow() once per stacked
		-- handler (duplicate weapon grants, redundant plane/pilot deletes).
		-- The jump key is now registered exactly once, outside this
		-- function (see the one-time onKeyDown block below), guarded by the
		-- same `inheli` flag this used to check.
		local Time = 27 
		while inheli do 
			Wait(3000)
			if inheli == true  and  jump == false then 
				Time = Time - 3
					if Time <= 0 then 
						JumpNow()
					end 
			else 
           		return
			end
		end 
	end)
end 
function JumpNow()
	CreateThread(function()
	planekey   = nil
	inheli = false
	jump = true
	idtimeout = nil 
	SetTimeout(15000,function()
		Dlay = false
	end)
	TaskLeaveVehicle( PlayerPedId() , GetVehiclePedIsIn(PlayerPedId(), false) , 16)
	SetEntityVisible(PlayerPedId(), true,true)
	AddWeapon('WEAPON_SNSPISTOL' , 250)
	AddWeapon('gadget_parachute' , 1)
	SetEntityCollision(PlayerPedId(), true, true)
	Wait(5000)
	DeleteVehicle(plane)
	DeleteEntity(pilot)
	SetEntityVisible(PlayerPedId(), true,true)
	if GetPedParachuteState(PlayerPedId()) ~= 1 and  GetPedParachuteState(PlayerPedId()) ~= 2  then 
		ForcePedToOpenParachute(PlayerPedId())
	end 
	Wait(1000)
	DeleteEntity(pilot)
	plane , pilot  = nil , nil
	LootNow = true 
	end)
end
function UpdateZoneBlip(blip,oldRadius, newRadius)
CreateThread(function()
	if  not DoesBlipExist(blip) then
		if not InWarzone  then return end 
	 	tempBlip = AddBlipForRadius(vector3(GlobalCoord.x, GlobalCoord.y , GlobalCoord.z ), newRadius + 0.0)
		SetBlipHighDetail(tempBlip, true)
		SetBlipColour(tempBlip, 0)
		SetBlipAlpha (tempBlip, 255)
		SetBlipFade(tempBlip, 40, 40)
		SetBlipAsShortRange(tempBlip, true)
		SetBlipScale(tempBlip, newRadius)
	end 
	if DoesBlipExist(MarkerWarzone) then
		if not InWarzone  then return end 
		local r = tonumber(oldRadius)+0.0
		if r > newRadius then 
			r = r - 1.0
		SetBlipScale(MarkerWarzone, r)
		else 
		RemoveBlip(tempBlip) 
		end 
	end
end) 
end
function PlayNowSound(audioName, audioRef)
	CreateThread(function()
		SetAudioFlag("LoadMPData", true)
		PlaySoundFrontend(-1, audioName, audioRef, true)
	end)
end
function PrivteLoadout()
	-- Fix: this used to AddEventHandler('onKeyDown', ...) on every call, and
	-- this function runs once per "loadout" shop purchase (repeatable) --
	-- so buying it twice stacked two handlers, and a single click could
	-- fire two airdrops for the price of two separate future clicks. The
	-- actual key handler is now registered once (see the one-time
	-- onKeyDown block below); this just banks a use.
	LoadoutCharges = LoadoutCharges + 1
	SendNotifyToPlayer('Bray Estfade Az Loadout Ba FlayerGun Tir Bezanid' , 'info')
end 
function ZoneRuning()
	if not InWarzone  then return end 
local ZoneRun = true  
NZone = Distance / 2 
	SoundZoneMoved()
	for k,v in pairs(ShopBoxes) do 
		RemoveBlip(v.Blip)
		v.CanUse = false 
    end
	if ZoneOne then  
		ZoneOne = false 
		CreateShop(Config.shops [ string.upper ( MapName .. 2 ) ]  )
	else
		CreateShop(Config.shops [ string.upper ( MapName .. 3 ) ]  )
	end 
	SendNotifyToPlayer("~b~ WarZone ~w~ : ~r~ Zone moved  ")
      CreateThread(function()
          while InWarzone and ZoneRun do 
            Wait(1000)
            if NZone <= Distance then 
               Distance = Distance - 1
			   UpdateZoneBlip( tempBlip , Distance , NZone)
			   if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GlobalCoord,true) < NZone then 
				showNext = false 
			   else 
				showNext = true 
			   end 
                  if Distance <= 60.0 then 
					if not InWarzone  then return end 
	                 ZoneRun = false 
	                 GulagTime = true 
					 showNext = false 
	                   if ingulag then 
		                ingulag = false 
	                TriggerEvent("AWZ:Prisonbreak")
                      end 
	            SendNotifyToPlayer("~b~ WarZone ~w~ : ~r~ Prison Closed   ")
                      end 
                  elseif NZone > Distance then 
					showNext = false 
                        Wait(60000)
      if not InWarzone  then return end 
                    	Wait(Time * 60000)
           if not InWarzone  then return end 
                    SoundZoneMoved()
	                 SendNotifyToPlayer("~b~ WarZone ~w~ : ~r~ Zone moved  ")
	              NZone = NZone / 2
            end 
         end 
    end)
	CreateThread(function()
		while InWarzone and ZoneRun do 
			Wait(3)
			if showNext then 
	    		DrawMarker(28, GlobalCoord, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, NZone + 0.0, NZone +0.0, NZone +0.0,224, 224,224, 60, false, true, 2, nil, nil, false)
	    	else 
				Wait(2000)
			end 
	   end     
    end)
end 
function SoundZoneMoved()
--	SendNUIMessage({message	= "music",Name = 'enemyuav'})  
SendNUIMessage({message	= "music",Name = 'ZoneMove'}) 
end 

function PuckUP()
	PlayNowSound("PICK_UP_WEAPON", "HUD_FRONTEND_CUSTOM_SOUNDSET")
	local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
	RequestAnimDict(dictname)
		if not HasAnimDictLoaded(dictname) then
			RequestAnimDict(dictname) 
			while not HasAnimDictLoaded(dictname) do 
				Wait(1)
			end
		end
	TaskPlayAnim(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
	TriggerEvent("LG_Progbar:client:progress", {name = "wzpickup",duration = 2000,label = 'Opening...',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
	Wait(850)
	Wait(1000)
	ClearPedTasks(PlayerPedId())
end 


function BuyUAV()
	if AllUav <= 4 then 
		AllUav = AllUav + 1 
		SendNotifyToPlayer(' You Have ~r~'..AllUav..'~w~ UAV')
		SendNotifyToPlayer('Presse [ ~r~Q~w~ ] For Use UAV ') 
	else 
		SendNotifyToPlayer('You cannot buy more than 4 UAV')
	end 

end 
function UAVBlipThread()
	if UAVLine then return 	SendNotifyToPlayer('You Already Used Uav') end 
	AllUav = AllUav - 1
    local eBlips = {}
    local Timer = 20000
	UAVLine = true 
	SendNotifyToPlayer('UAV Online')
	SendNUIMessage({message	= "music",Name = 'uavonline'}) 
	eBlips[PlayerId()] = AddBlipForEntity(PlayerPedId())
	SetBlipScale(eBlips[PlayerId()], 5.0)
	SetBlipSprite(eBlips[PlayerId()], 161)
	SetBlipColour(eBlips[PlayerId()], 45) 
	SetBlipAlpha(eBlips[PlayerId()], 80) 
    while Timer > 0 do
        Timer = Timer - 2000
		if  PlayerDead or  inheli    or  not InWarzone  then 
			SendNotifyToPlayer('UAV Offline')
			Timer = 0 
			for k, v in pairs(eBlips) do
				RemoveBlip(v)
			end
		end 
        for k, v in pairs(GetActivePlayers()) do
        	 if v ~= PlayerId() then
			  if not DoesBlipExist(GetBlipFromEntity(GetPlayerPed(v))) then
                    eBlips[v] = AddBlipForEntity(GetPlayerPed(v))
                    SetBlipScale(eBlips[v], 0.8)
                    SetBlipSprite(eBlips[v], 303)
                    SetBlipColour(eBlips[v], 1)
				end
            end
        end
		Wait(2000)
    end
    for k, v in pairs(eBlips) do
        RemoveBlip(v)
    end
	UAVLine = false 
	SendNotifyToPlayer('UAV Offline')
end


function SetPLayerInGulag()
	if not InWarzone  then return end 
	armoritem , bandageitem = 0 , 0
	AllUav = 0 
	ESX.TriggerServerCallback('AWZ:SetPlayerInGulag', function(prisoner) 
		GulagPlayer  = prisoner 
	end)
	SendNUIMessage({message	= "music",Name = 'welcometogulag'}) 
	SetEntityVisible(PlayerPedId(), false,false)
	local MyCoordInGulag = nil
	local RandmSpwan = math.random(0,3) + math.random(0,2)  + 1
	for k,v in pairs(Config.GulagCoordSpwan) do 
     	if k ==  RandmSpwan then 
     		MyCoordInGulag = v
	 	end 
	end 
	TriggerServerEvent("Warzone:SetW",Config.Gulagworld)
	LootNow = false
	Dlay = true 
	RemoveAllPedWeapons(PlayerPedId(), 1)
	ESX.ShowMissionText("")
	for k,v in pairs(AllLoots) do 
		DeleteObject(v.Box)
		DeleteObject(v.Chatr)
   end 
   Revive()
   AllLoots = {}
   SetEntityCoords(PlayerPedId(), Config.GulagZone  )
   ingulag = true 
   SetEntityVisible(PlayerPedId(), false,false)
   if GulagPlayer <= 1  then 
   		SendNotifyToPlayer("Wait ...")
   		FreezePlayer(true)
   		SetEntityVisible(PlayerPedId(), false,false)
   		SetTimeout(60*1000,function()
   			if ingulag then 
				if GulagPlayer <= 1  then  
					ESX.TriggerServerCallback('AWZ:SetPlayerRemoveGulag', function(remove)end) 
					SendNotifyToPlayer('You are  Respawn because there is no opponent')
					TriggerEvent("AWZ:Prisonbreak")
				return  
				end  
   			end
   		end)
   		while GulagPlayer <= 1 and ingulag  do 
			ESX.TriggerServerCallback('AWZ:GetPlayerInGulag', function(prisoner) 
				GulagPlayer  = prisoner 
			end)
    		Wait(5000)
   		end 
   		if not ingulag  then return end 
   		FreezePlayer(false)
   end 
  	if MyCoordInGulag == nil then 
		for k,v in pairs(Config.GulagCoordSpwan) do 
			if k ==  RandmSpwan then 
				MyCoordInGulag = v
			end 
	   end 
	end 	
	Dlay = true 
	Wait(2000)
	AddWeapon('WEAPON_PISTOL', 250)
	SetEntityCoords(PlayerPedId(),MyCoordInGulag,false)
	Wait(200)
	FreezePlayer(true)
	Wait(5000)
	FreezePlayer(false)
	FreezeEntityPosition( PlayerPedId() , false )
	SetEntityVisible(PlayerPedId(), true,true)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_PISTOL"), true)
	SetMaxHealth()
  	SendNotifyToPlayer('Kill someone to Respawn')
   	SendNotifyToPlayer('You have 1 minute')
	SendNUIMessage({message	= "music",Name = 'ingulag'}) 
  	Wait(60000)
   	if ingulag then 
		if not InWarzone  then return end 
		if GulagPlayer <= 1  then   
		if not InWarzone  then return end 
		SendNotifyToPlayer('You are  Respawn because there is no opponent')
		TriggerEvent("AWZ:Prisonbreak")
	else
		SendNotifyToPlayer('You could not kill anyone')
    	TriggerEvent("AWZ:ExitMision")
   end 
end 
end
AddEventHandler("esx:onPlayerDeath",function(KillData)
	if not InWarzone  then return end 
	if ingulag  then return end
	local MyDropLoot = { }
	 MyDropLoot.weapon = {}
	 MyDropLoot.Money = MyCash
	for k , v in ipairs(weapons) do
		if HasPedGotWeapon(PlayerPedId(),GetHashKey(v))  then
			table.insert(MyDropLoot.weapon, v)
		end
	end 
	PlayNowSound("GO", "HUD_MINI_GAME_SOUNDSET")
	TriggerServerEvent("WarZone:SetBodyBox", MyDropLoot ,GetEntityCoords(PlayerPedId()))
end)
RegisterNetEvent("WarZone:GetBoxLoot")
AddEventHandler("WarZone:GetBoxLoot",function( Weapons , Coord , CodeBox)
	if InWarzone  then   
		if not ingulag  then   
			BodyBox( Weapons ,Coord , CodeBox )
		end
	end  
end)
function BodyBox( Weapons , Coords , CodeBox)
	local  Weapons = Weapons
	CreateThread(function()
		local crateSpawn = vector3(Coords.x , Coords.y, Coords.z -0.9) 
		local BodyBoxObject = CreateObject(GetHashKey("prop_box_ammo06a"), crateSpawn, false, true, true) 
	   	SetEntityLodDist(BodyBoxObject, 2000) 
	   	ActivatePhysics(BodyBoxObject)
	   	SetDamping(BodyBoxObject, 2, 0.1) 
	   	SetEntityVelocity(BodyBoxObject, 0.0, 0.0, -0.2)
	   	FreezeEntityPosition(BodyBoxObject, true )
        table.insert(BodyLoots,{Box = BodyBoxObject, CodeMeli = CodeBox , Weapons = Weapons.weapon , Money = Weapons.Money  })
    end)
end 
RegisterNetEvent("WarZone:clSyncDelBox")
AddEventHandler("WarZone:clSyncDelBox",function( CodePrivteBox )
	if InWarzone then   
		for k,v in pairs(BodyLoots) do
    		if CodePrivteBox == v.CodeMeli then 
				DeleteEntity(v.Box)		
			end 
		end
	end 
end) 
local inUseitem = false 
CreateThread(function() 
	AddEventHandler('onKeyDown',function(key)
		if  key == 'f' then 
			if inheli == true  then 
				PlayerDead , inheli  = false  , false
				jump = true
				JumpNow()
			end
		end 
	end)
	-------------
	-- Private Loadout airdrop (bought from the shop, see PrivteLoadout()).
	-- Registered once here instead of once per purchase (see fix notes).
	AddEventHandler('onKeyDown', function(key)
		if key == 'mouse_left' then
			if not InWarzone then return end
			if UsingLoadout or LoadoutCharges <= 0 then return end
			if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_FLARE') then
				UsingLoadout = true
				LoadoutCharges = LoadoutCharges - 1
				local Sploot = nil
				local NumerofLoot = math.random(1,5)
				for k,v in pairs(AirDrops) do
					if NumerofLoot == k then
						Sploot = v
					end
				end
				SendNotifyToPlayer('Loadout Kamtar Az 10s Dar Makan ke Istadeid Miresad', 'info')
				CreateThread(function()
					local crateSpawn = vector3(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z + 100)
					local objLootBox = CreateObject(GetHashKey("prop_box_wood05a"), crateSpawn, true, true, true)
					SetEntityLodDist(objLootBox, 2000)
					ActivatePhysics(objLootBox)
					SetDamping(objLootBox, 2, 0.1)
					SetEntityVelocity(objLootBox, 0.0, 0.0, -0.2)
					local parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true)
					SetEntityLodDist(parachute, 2000)
					SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
					AttachEntityToEntity(parachute, objLootBox, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true)
					table.insert(AirDropGetLoot, {Box = objLootBox, Chatr = parachute, weapon = Sploot, Heal = true, Vest = true, Code = 'Privte'})
					TriggerServerEvent('AWZ:Loadout', {Box = objLootBox, Chatr = parachute, weapon = Sploot, Heal = true, Vest = true, Code = 'Privte'})
					while not IsEntityAttached(parachute) do
						Wait(0)
						AttachEntityToEntity(parachute, objLootBox, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)
					end
				end)
				Wait(3000)
				RemoveWeaponFromPed(PlayerPedId(), 'WEAPON_FLARE')
				UsingLoadout = false
			end
		end
	end)
	-------------
	AddEventHandler('onKeyDown',function(key)
		if InWarzone and not inheli and  not PlayerDead and not inUseitem then 
			if key == 'y' then 
				if armoritem >= 1  and GetPedArmour(PlayerPedId()) ~= 100 then 
					armoritem = armoritem - 1 
					inUseitem = true 
					SendNUIMessage({message	= "music",Name = 'armor'}) 
					TaskPlayAnim(PlayerPedId(), 'clothingtie' ,'try_tie_negative_a' , 3.0, 3.0, 3000, 51, 0, false, false, false)
					Wait(  2* 1000)
					inUseitem = false  
					SetPedArmour(PlayerPedId() , GetPedArmour(PlayerPedId()) + 25  )
				end 
			end	 
		end 
	end)
	-------------
	AddEventHandler('onKeyDown',function(key)
		if InWarzone and not inheli and  not PlayerDead and  not inUseitem then 
			if key == 'u' then 
				if bandageitem >=  1 and  GetEntityHealth(PlayerPedId()) ~= GetEntityMaxHealth(PlayerPedId()) then 
					bandageitem = bandageitem - 1 
					inUseitem = true 
					SendNUIMessage({message	= "music",Name = 'heal'}) 
					TaskPlayAnim(PlayerPedId(), 'clothingtie' ,'try_tie_negative_a' , 3.0, 3.0, 3000, 51, 0, false, false, false)
					Wait( 2 * 1000)
					inUseitem = false   
					SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+ 25 ) 
				end 
			end 
		end 
	end) 
	-------------
	AddEventHandler('onKeyDown',function(key)
		if key == 'e' then  
			if InWarzone  then
				if not  PlayerDead   then   
					for k,v in pairs(BodyLoots) do 
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(v.Box), true) < 3.0   then 
							if DoesEntityExist(v.Box) then 
								TriggerServerEvent("WarZone:SyncDelBox",v.CodeMeli)
				 				PuckUP()
								MyCash = MyCash + v.Money
								for c, d in pairs(v.Weapons) do 
									AddWeapon( d, 250)
								end 
							end 
						end 
					end 
				end
			end
		end 
	end) 
		-------------
		AddEventHandler('onKeyDown',function(key)
			if key == 'e' then   
				if InWarzone then 
					for k,v in pairs(AllLoots) do 
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(v.Box),false) <= 2  then
							DeleteObject(v.Box)
					 		DeleteObject(v.Chatr)
							if v.weapon == 'WEAPON_SMOKEGRENADE' or  v.weapon == 'WEAPON_MOLOTOV' or v.weapon == 'WEAPON_BZGAS' then 
								AddWeapon(v.weapon, 3)
							else   
					 			AddWeapon(v.weapon, 250)
							end 
							MyCash	= MyCash +  v.Money 
							SendNUIMessage({message	= "cash",MyCash =  MyCash ,}) 
					 		if v.Heal then 
								bandageitem = bandageitem + 1
							elseif v.Vest then 
								armoritem = armoritem + 1 
							end 
							if v.Uav then 
								AllUav = AllUav + 1
							end 
							table.remove(AllLoots , k,v )
							PuckUP()
						end
					end
				end 
			end 
		end)


	-----------------------
	AddEventHandler('onKeyDown',function(key)
		if key == 'e' then 
			if InWarzone  then
				for k,v in pairs(AirDropGetLoot) do 
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(v.Box),false) <= 2  then
						AddWeapon(v.weapon, 250)
				 		DeleteEntity(v.Box )
						DeleteObject(v.Chatr)
						SendNUIMessage({message	= "music",Name = 'bigloot'}) 
						if v.Heal and v.Vest then 
							bandageitem = bandageitem + 4
							armoritem = armoritem + 4
							AllUav = AllUav + 2 
						end 
						PuckUP()
					end
				end 
			end 
		end
	end)
	-------------------
	AddEventHandler('onKeyDown',function(key) 
		if key == 'q' then   
		
			if InWarzone and not inheli and  not PlayerDead and not inUseitem then 
			
				if AllUav ~= 0 then 
					
					UAVBlipThread()
				end 
			end 
		end
	end)
	-------------------
	AddEventHandler('onKeyDown',function(key)
		if key == 'e' then  
			if InWarzone  then
				for k,v in pairs(ShopBoxes) do 
					if GetDistanceBetweenCoords(GetEntityCoords(v.Box),GetEntityCoords(PlayerPedId()), true) < 2.3  then
						if v.CanUse  then 
							local elements = {}
							table.insert(elements, {label = ("[------- WarZone Shop -------]"), value = 'BP'})
							table.insert(elements, {label = ("Your WzCash : "..MyCash), value = 'vest50'})
							table.insert(elements, {label = ("Armor [2]  300$"), value = 'vest50'})
							table.insert(elements, {label = ("Bandage [2]  300$"), value = 'heal50'})
							table.insert(elements, {label = ("Armor Pack [4] 500$"), value = 'vest100'})
							table.insert(elements, {label = ("Bandage Pack [4] 500$"), value = 'heal100'})
							table.insert(elements, {label = ("Uav  [1]  400$"), value = 'uav'})
							table.insert(elements, {label = ("Blood [1]  1000$"), value = 'blood'})
							table.insert(elements, {label = ("Loadout [1] 1000$"), value = 'loadout'})
							table.insert(elements, {label = ("[------- WarZone Shop -------]"), value = 'BP'})
							ESX.UI.Menu.CloseAll()
							inshopbox = true 
							ESX.UI.Menu.Open(
								'default', GetCurrentResourceName(), 'WarZone_Shop',
								{
								title    = "WZ",
								align    = 'center',
								elements = elements
								},
							function(data, menu) 
							local action = data.current.value
								if action == 'heal50' then 
									if MyCash >= 300 then 
										bandageitem = bandageitem + 2
										SendNotifyToPlayer('You have purchased Armor')
										MyCash = MyCash - 300 
									else 
										SendNotifyToPlayer('Your money is not enough' )
									end 
								elseif action == 'heal100' then 
									if MyCash >= 500 then 
										bandageitem = bandageitem + 4
										SendNotifyToPlayer('You have purchased  bandage Pack ')
										MyCash = MyCash - 500 
									else 
										SendNotifyToPlayer('Your money is not enough' )
									end 
								elseif action == 'vest50' then 
									if MyCash >= 300 then 
										armoritem = armoritem + 2
										SendNotifyToPlayer('You have purchased Armor') 
										MyCash = MyCash - 300 
									else 
									SendNotifyToPlayer('Your money is not enough' )
									end 
								elseif action == 'vest100' then 
									if MyCash >= 500 then 
										SendNotifyToPlayer('You have purchased  Armor Pack ')
										MyCash = MyCash - 500 
										armoritem = armoritem +4 
									else 
										SendNotifyToPlayer('Your money is not enough' )
									end 
								elseif action == 'uav' then 
									if AllUav <= 4 then 
										if MyCash >= 400 then 
											MyCash = MyCash - 400 
											BuyUAV()
										else 
											SendNotifyToPlayer('Your money is not enough' )
										end 
									else 
										SendNotifyToPlayer('You cannot buy more than 4 UAV')
									end 
								elseif action == 'blood' then 
									if MyCash >= 1000 then 
										MyCash = MyCash - 1000 
										MySelf = MySelf + 1	
									else 
										SendNotifyToPlayer('Your money is not enough' )
									end 
								elseif action == 'loadout' then 
									if MyCash >= 1000 then 
										MyCash = MyCash - 1000 
										AddWeapon( "WEAPON_FLARE", 1)
										PrivteLoadout()
									else 
										SendNotifyToPlayer('Your money is not enough' )
									end 
								end 
								menu.close()
								inshopbox = false
								SendNUIMessage({message	= "cash",MyCash =  MyCash ,}) 
								end, function(data, menu)
		 						 menu.close() 
		  						inshopbox = false
							end)
						else 
							 SendNotifyToPlayer('This shop no longer has items, use the new shops')
						end 
					end 
				end
			end 
		end 
	end)
end )

RegisterNetEvent("AWZ:UpdateAlive")
AddEventHandler("AWZ:UpdateAlive",function(Player , Squad)
	SendNUIMessage({
	    message	= "Members",
		Squad =  Squad ,
		Players = Player , 
	}) 
end)
function UpdateStatus (Count ,
	PI , NI ,
	PII , NII , 
	PIII , NIII ,
	Id , Name 
)
 MyPlayersID = {
	PI ,
	PII ,
	PIII ,
}
	for k,v in pairs( MyPlayersID ) do 
		if v ~= 0 then 
			SetBlipForTeam(v)
		end 
	end 
	SendNUIMessage({  message	= "showsquad",
		count = Count , 
		NameOne =  NI  ,
		NameTwo = NII    ,
		NameThree = NIII   , 
		MyName =  string.gsub( Name , '_' , ' ') 
	}) 
	CreateThread(function() 
		local Ped = PlayerPedId()
		local MyHeal , MyArmor = 0,0 
		local PStatus = {}
		PStatus[1] = { Heal = 0  , Armor = 0 }
		PStatus[2] = { Heal = 0  , Armor = 0  }
		PStatus[3] = { Heal = 0  , Armor = 0  }

		while InWarzone do 
			Wait(1500)
			MyHeal =  GetEntityHealth(Ped)  
			MyArmor = GetPedArmour(Ped)  
			for k,v in pairs( MyPlayersID ) do 
				if v ~= 0 then 
					PStatus[k].Heal  =  GetEntityHealth(NetworkGetPlayerIndexFromPed(GetPlayerPed(GetPlayerFromServerId(v))))
					PStatus[k].Armor =  GetPedArmour(NetworkGetPlayerIndexFromPed(GetPlayerPed(GetPlayerFromServerId(v))))
					
				else 
				
					PStatus[k].Heal  =  0
					PStatus[k].Armor =  0
				end 
			end 
			SendNUIMessage({message	= "item",Armor =  armoritem , Heal = bandageitem , Uav = AllUav , Self = MySelf  }) 
			SendNUIMessage({ message = "UpdateStatus" ,
				MyHealth = MyHeal , MyArmor = MyArmor ,
				p1heal = PStatus[1].Heal  , p1armor = PStatus[1].Armor   ,
				p2heal = PStatus[2].Heal  , p2armor = PStatus[2].Armor   ,
				p3heal = PStatus[3].Heal  , p3armor = PStatus[3].Armor   ,
			 }) 
		end 
	end)
end 
RegisterNetEvent("AWZ:Prisonbreak")
AddEventHandler("AWZ:Prisonbreak",function()
	TriggerServerEvent("AWZ:SetRBucket",Config.FightWorld)
	FreezePlayer( false )
	ESX.ShowMissionText("")
	MySelf = 1 
	ingulag = false 
	SetEntityVisible(PlayerPedId(), false,false)
	WarZone()
end)
RegisterNetEvent("AWZ:ShowWinner")
AddEventHandler("AWZ:ShowWinner",function( p1 , p2 , p3 , p4  , i , squad  ) 
	if not i then  return end  
	SendNUIMessage({message	= "TeamWon",PlayerOne =  p1 , PlayerTwo = p2 , PlayerThree = p3 , PlayerFour = p4 }) 
	Wait( 10 * 1000) 
	SendNUIMessage({message	= "RTeamWon" }) 
end)
RegisterNetEvent("AWZ:WinnerTeam")
AddEventHandler('AWZ:WinnerTeam',function( i  ) 
	if not i then  return end  
	SendNUIMessage({message	= "music",Name = 'victory'}) 
	Wait(5 * 1000)
	TriggerEvent('AWZ:ExitMision')
end)
CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/'.. Config.StartCommend..'', 'Jahate Start Lobbey Warozne', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.JoinLobbeyCommend..'', 'Jahate Join Warozne', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.Startmatchcommend..'', 'Jahate Start Match Warozne', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.panelCommend..'', 'Open the WarZone admin panel (GUI)', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.wztopCommend..'', 'Show the season leaderboard', {})
	TriggerEvent('chat:addSuggestion', '/'..Config.seasonresetCommend..'', 'Admin: reset the WarZone season', {})
end)
RegisterNetEvent("AWZ:UpdateLoadout")
AddEventHandler("AWZ:UpdateLoadout", function(loadout)
	table.insert(AirDropGetLoot ,  loadout )		
end) 


