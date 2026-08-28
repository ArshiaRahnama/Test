ESX = nil
local PlayerData = {}
CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
		Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
end)
local InAdminPanel  , UIColdDown = false  , false 
-----------------------------
--- ESX
-----------------------------
RegisterNetEvent(Config.DefaultEvents['setGang'])
AddEventHandler(Config.DefaultEvents['setGang'], function(gang)
	PlayerData.gang = gang
	TriggerServerEvent('For5M:SetGang', gang.name, gang.grade)
end)

RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function(xPlayer)
  PlayerData = xPlayer
end)

-------------------------
----- Panel
-------------------------
RegisterNetEvent('For5M:OpenPanel')
AddEventHandler('For5M:OpenPanel', function(data)
	InAdminPanel = true 
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = 'OPENADMINPANEL', 
		Admin = data , 
	})
end) 
RegisterNetEvent('For5M:OpenBossPanel')
AddEventHandler('For5M:OpenBossPanel', function(data , GangName )
	InAdminPanel = true 
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = 'OPENBOSSPANEL', 
		Admin = data , 
		GangName = GangName , 
	})
end) 

RegisterNUICallback('CLOSEADMINPANEL', function(data, cb)
	print('[Unique_ALLGangs] CLOSEADMINPANEL received - releasing NUI focus')
	InAdminPanel = false 
	SetNuiFocus(false, false)
	-- also make sure the boss-panel iframe (if it was ever opened) is
	-- hidden - it wasn't being told to close here before, only on the
	-- Escape-key path below, which could leave a full-screen overlay
	-- element sitting on top of the game after closing normally.
	SendNUIMessage({ type = 'displaynone' })
	if cb then cb('ok') end
	-- Defensive re-assertion: if anything else in this resource (or
	-- another one) re-locks NUI focus back to true in the same frame
	-- or shortly after (a race we haven't been able to reproduce/find
	-- in code but that would explain focus staying stuck even though
	-- this handler ran), force it back off a moment later too.
	CreateThread(function()
		Wait(250)
		if not InAdminPanel then
			SetNuiFocus(false, false)
			print('[Unique_ALLGangs] CLOSEADMINPANEL: re-asserted SetNuiFocus(false,false) after 250ms as a safety net')
		end
	end)
end)

-------------------------------------------------------------------
-- FIX (mouse gets stuck on screen when the panel is open):
-- the only way to close the panel and release NUI focus was clicking
-- the in-UI (X) button - fetch('CLOSEADMINPANEL'). Pressing Escape (the
-- instinctive way anyone tries to close a menu) did nothing at all, so
-- SetNuiFocus(true,true) just stayed on forever, leaving the cursor
-- stuck/locked with no way to get control back except relogging.
-- This adds Escape (control 322) as a fallback that closes the panel
-- the same way the (X) button does - including telling the UI to hide
-- itself (and the boss-panel iframe, via the same 'displaynone'
-- message its own close button already sends) so it isn't left open
-- and invisible with focus still stuck.
-------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(0)
		if InAdminPanel then
			if IsControlJustPressed(0, 322) then -- ESC
				InAdminPanel = false
				SetNuiFocus(false, false)
				SendNUIMessage({ type = 'CLOSEPANEL' })
				SendNUIMessage({ type = 'displaynone' }) -- also closes the boss-panel iframe if it was open
			end
		else
			Wait(500)
		end
	end
end)

RegisterNUICallback('HOMEDATA', function(data, cb)
	ESX.TriggerServerCallback('FMGangs:GetPanelData' , function(Count, OnlinePLayers, OfflinePLayers, AllMem, TopGangs,  AllMembers  )
		cb({Count = Count , Online = OnlinePLayers ,  Offline = OfflinePLayers  , All = AllMem , TopGang = TopGangs[1] , MaxXP = Config.GangLeveL , AllMembers = AllMembers  , TopGangs = TopGangs   })
	end)
end)
RegisterNUICallback('GANGSDATA', function(data, cb)
	ESX.TriggerServerCallback('FMGangs:GetGangsData' , function(Gangs , Expires , AllMembers )
		cb( {
			Gangs = Gangs ,  
			Levels = Config.GangLeveL ,
			Expires = Expires , 
			AllMembers = AllMembers , 
		} )
	end)
end)
RegisterNUICallback('GETGANG', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:GetGangsData' , function(Gangs , Expires , AllMembers )
		cb( {
			Gang = Gangs[data.gang] ,  
			Levels = Config.GangLeveL ,
			Expire =  tonumber(string.format("%2.f", Expires[data.gang])) , 
			Members = AllMembers[data.gang] , 
		} )
	end)
end) 
RegisterNUICallback('UPGRADEGANGINFO', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:GetGangDataFromName' , function(Dataa)
		cb(Dataa)
	end, data.gang_name)
end)

RegisterNUICallback('CREATEGANG', function(data, cb) 
	-------------------------------------------------------------------
	-- FIX (clicking Create does nothing): UIColdDown is ONE global
	-- flag shared by 7 different buttons (Create, EditRank, EditAccess,
	-- DeleteRank, AddRank, UpdateGang, AddOptions). If ANY of them had
	-- fired in the last second, this would just `return` here without
	-- ever calling cb(...) - the button's fetch() request never
	-- resolves, so nothing visibly happens at all, no error, nothing.
	-- Also: neither success nor failure ever showed any notification,
	-- so even a create that DID work looked identical to one that
	-- didn't (this exists in the panel elsewhere too - not something
	-- I've swept the whole file for, but this is the one you hit).
	-- Now: still resolves cb() either way, and always tells the player
	-- what happened.
	-------------------------------------------------------------------
	if UIColdDown then 
		print('^1[Unique_ALLGangs] CREATEGANG blocked by UIColdDown (shared cooldown was active)^7')
		cb( { Created = false } )
		return Notifiaction('Please wait a moment before trying again')
	end 
	UIColdDowns()
	print(('[Unique_ALLGangs] CREATEGANG fired | name=%s label=%s expire=%s logo=%s webhook=%s'):format(
		tostring(data['name']), tostring(data['label']), tostring(data['expire']), tostring(data['logo']), tostring(data['webhook'])
	))
	ESX.TriggerServerCallback('FMGangs:CreateGang' , function(Create, msg)
		print('[Unique_ALLGangs] CREATEGANG server response | Create=' .. tostring(Create) .. ' msg=' .. tostring(msg))
		if Create then
			Notifiaction('Gang created')
			cb( { Created = true })
		else
			Notifiaction(msg or 'Could not create the gang')
			cb( { Created = false })
		end
	end, { name = data['name'], label = data['label'], expire = data['expire'], logo = data['logo'] ,  webhook = data['webhook'] })
end)
RegisterNUICallback('UPGRADEOPTIONS', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:GetCoordDataFromName' , function(Dataa)
		
		cb( Dataa )
	end, data.gang_name, data.option )
end)
RegisterNUICallback('EDITRANK', function(data, cb) 
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	ESX.TriggerServerCallback('FMGangs:EditRank' , function(Dataa)
		cb( Dataa )
	end, data.gang_name, data.grade, data.name,  data.label , data.salary ) 
end)
RegisterNUICallback('EDITACCESS', function(data, cb) 
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	ESX.TriggerServerCallback('FMGangs:EditAccess' , function(Update)
		cb( Update )
	end, data.gang_name, data.grade,  data.access , data.value  ) 
end)
RegisterNUICallback('DELETERANK', function(data, cb)
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	ESX.TriggerServerCallback('FMGangs:DeleteRank' , function(Dataa)
		cb(Dataa)
	end, data.gang_name, data.grade)
end)
RegisterNUICallback('ADDRANK', function(data, cb) 
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	ESX.TriggerServerCallback('FMGangs:AddRank' , function(Dataa)
		cb(Dataa)
	end, data.gang_name, data.label, data.name, data.salary  )
end)
RegisterNUICallback('UPDATEGANG', function(data, cb) 
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	ESX.TriggerServerCallback('FMGangs:UpdateGang' , function(Dataa)
		cb(true)
	end, data['gang_name'], data['label'], data['expire'], data['logo'] ,  data['webhook'] ) 
end)
RegisterNUICallback('ADDOPTIONS', function(data, cb) 
	if UIColdDown then cb(false) return Notifiaction('Please wait a moment before trying again') end 
	UIColdDowns()
	if data.option == 'bots' and data.type  ~= 'ped' then 
		return  Notifiaction('This Option Is For Ped Types')
	end 
	data.size.x = tonumber( data.size.x ) + 0.0 or 1.5 
	data.size.y = tonumber( data.size.y ) + 0.0 or 1.5 
	data.size.z = tonumber( data.size.z ) + 0.0  or 1.5  
	data.type = string.gsub(data.type , ' ' , '')
	data.color  =   data.colour 
	if  data.option == 'vehspawn' or  data.option == 'helispawn' or data.option == 'boatspawn' then 
		data.type = 'vehicle' 
		if data.option == 'vehspawn' then 
			data.marker = 'neon'
		elseif data.option == 'helispawn' then 
			data.marker = 'buzzard'
		else 
			data.marker = 'speeder'
		end 
	end  

	SetMarkerCoord({type = data.type , marker = data.marker  , size = data.size, color =  data.colour } , function(tab)
		data.coord = tab.coord
		data.heading = tab.heading
		ESX.TriggerServerCallback('FMGangs:AddOption' , function(Dataa)
			ExecuteCommand(Config.OPENPANELCMD)
		end, data.gang_name, data.option, data)
	end)
end)
function UIColdDowns()
	UIColdDown = true 
	SetTimeout(1000, function()
		UIColdDown = false
	end)
end 
RegisterNUICallback('GETOPTIONSDATA', function(data, cb) 
	cb( { 
		marker =  Config.markers   ,
		ped    =  Config.peds      , 
		object =  Config.object    ,
		blip   =  Config.blip      ,
		flag   =  Config.flag      ,
})
end)
RegisterNUICallback('DELETEGANG', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:DeleteGang' , function(callback)
		if callback then
			cb(true)
		end
	end, data.gang_name)
end)
RegisterNUICallback('DISBANDGANG', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:DisbandGang' , function(callback)
		cb(true)
	end, data.gang_name)
end)
RegisterNUICallback('TELEPORT', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:TeleportToGang' , function()
	end, data.gang_name)
end)
-- EDITMARKER 
RegisterNUICallback('EDITMARKER', function(data, cb) 
	local MarkerData = data.AllData
	local MarkerCode = data.code
	local MarkerCatgory = data.option
	SetMarkerCoord({type = MarkerData.type , marker = MarkerData.marker  , size = MarkerData.size, color =  MarkerData.color } , function(tab)
		MarkerData.coord = tab.coord
		MarkerData.heading = tab.heading
		ESX.TriggerServerCallback('FMGangs:EditMarker' , function()
		end, data.gang_name, MarkerCatgory, MarkerCode, MarkerData)
		Wait(100)
		cb(true)
	end)
end)
RegisterNUICallback('DELETEMARKER', function(data, cb) 
	local MarkerData = data.AllData
	local MarkerCode = data.code
	local MarkerCatgory = data.option
	ESX.TriggerServerCallback('FMGangs:DeleteMarker' , function(done)
		cb(true)
	end, data.gang_name, MarkerCatgory, MarkerCode)
end)
RegisterNUICallback('TELEPORTMARKER', function(data, cb) 
	local MarkerData = data.AllData
	local MarkerCoord = MarkerData.coord
	local MarkerCode = data.code
	local MarkerCatgory = data.option
	TeleportToCoord(MarkerCoord)
end)
RegisterNUICallback('GETOTHERS', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:GetGangDataFromName' , function(Dataa)
		cb(Dataa.others)
	end, data.gang_name ) 
end)
RegisterNUICallback('GIVEPACK', function(data, cb) 
	if data.pack == 'moneypack' then 
		TriggerServerEvent('FMGangsBoss:server:MoneyPack', data.gang_name ,  data.pack )
	elseif data.pack == 'xppack' then 
		TriggerServerEvent('For5M:AddGangXP', Config.Packs['xppack'], data.gang_name ) 
	else 
		TriggerServerEvent('For5M:itemPacks' ,data.gang_name ,  data.pack  )
	end 
end)
RegisterNUICallback('SAVEOTHERS', function(data, cb) 
	ESX.TriggerServerCallback('FMGangs:UpdateOthers' , function(Dataa)
		cb(true)
	end, data.gang_name, data.option, data.value)
end)
