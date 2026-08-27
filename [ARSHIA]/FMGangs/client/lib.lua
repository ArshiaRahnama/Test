local ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
		Wait(500)
	end
end)
local AllMarkers = {}
function CreateMarker( Name , data , cb)
	if data.coord and data.type and Name then 
		if AllMarkers[Name] ~= nil then
			-- an entity/marker with this Name already exists (e.g. reloaded via
			-- For5M:UpdateMyGang broadcast) -> delete it first so we never leak
			-- a duplicate ped/object at the same coords
			RemoveMarker(Name)
		end
		AllMarkers[Name] = {
			name = Name ,
			coord = vector3(data.coord.x , data.coord.y ,data.coord.z)  , 
			type = data.type  , 
			marker = data.marker , 
			heading = data.heading , 
			size = data.size , 
			color = data.color , 
			label = data.label , 
		}
		if AllMarkers[Name].type == 'marker' then 
			AllMarkers[Name].active = true 
		elseif AllMarkers[Name].type == 'object' then 
			CreateMarkerObject(GetHashKey( AllMarkers[Name].marker ) , AllMarkers[Name].coord  , AllMarkers[Name].heading  , function(Object)  
				AllMarkers[Name].object = Object 
			end)
		elseif AllMarkers[Name].type == 'ped' then 
			CreateMarkerPed(GetHashKey( AllMarkers[Name].marker ) , AllMarkers[Name].coord  , AllMarkers[Name].heading  , function(Ped)  
				AllMarkers[Name].ped = Ped 
			end)
		elseif AllMarkers[Name].type == 'flag' then 
			SetFlagoles( AllMarkers[Name].coord , AllMarkers[Name].marker , 255 , function(Object , Object2)
				AllMarkers[Name].object = Object 
				AllMarkers[Name].object2 = Object2
			
			end) 
		else 
			print('The marker has the wrong type  ' .. Name  )
		end 
		if AllMarkers[Name].label  ~= false then 
			CreateThread(function() 
				AddEventHandler('onKeyDown',function(key)
					if key == 'e' and AllMarkers[Name]  then 		
						if  GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()) , AllMarkers[Name].coord , true) < 5.0 and  GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()) , AllMarkers[Name].coord , false) <= 	AllMarkers[Name].size.x + 0.1 then 
							cb(true)	
						end
					end
				end)
			end) 
		end 
	else 
		print('The marker could not be loaded ' .. Name )
	end 
end 
------------------------
--- Delete Markers
------------------------
function RemoveMarker(Name)
	if AllMarkers[Name].type == 'object' then 
		DeleteObject(AllMarkers[Name].object)
		
	elseif AllMarkers[Name].type == 'flag' then 
		DeleteObject(AllMarkers[Name].object)
		DeleteObject(AllMarkers[Name].object2)
	elseif AllMarkers[Name].type == 'ped' then 
		DeletePed(AllMarkers[Name].ped)
	end 	
	AllMarkers[Name] = nil 
end 
function RemoveAllMarkers()
	for Name , data in pairs(AllMarkers) do
		if AllMarkers[Name].type == 'object' then 
			DeleteObject(AllMarkers[Name].object)
			AllMarkers[Name] = nil 
		elseif AllMarkers[Name].type == 'marker' then 
			AllMarkers[Name] = nil 
		end 	
	end 
	RemveoAllBlips()
end 

------------------------
----- Marker 
------------------------
CreateThread(function() 
    while true do 
		local Sleep = true 
		local MyCoords = GetEntityCoords(PlayerPedId())
		for Name , data in pairs(AllMarkers) do
			if data.label ~= false and  GetDistanceBetweenCoords(MyCoords , data.coord , true ) <= 25.0 then 
				Sleep = false 
				if data.type == 'marker' and data.active == true then 
					DrawMarker(data.marker, data.coord.x , data.coord.y , data.coord.z , 0.0, 0.0, 0.0, 0.0, data.heading, 0.0, data.size.x  , data.size.y , data.size.z, data.color.r , data.color.g, data.color.b,90, false, true, 2, nil, nil, false)
				end 
				if GetDistanceBetweenCoords(   MyCoords , data.coord , true ) <= 5.0 then
					if GetDistanceBetweenCoords(  MyCoords  , data.coord , false ) <= data.size.x + 0.0  then
						Draw3DText(data.coord.x , data.coord.y , data.coord.z  ,  'PRESS [~y~E~w~] TO OPEN ~r~' .. string.upper( data.label)  , 4 ,  0.1 , 0.1 )
				
					end 
				end 
			end 
		end 
		if Sleep then Wait(1000) end
       Wait(3)
    end  
end)

------------------------
--- Object
------------------------
function CreateMarkerObject( object , Coord , Heading , cb )
	CreateThread(function()
		RequestModel(object)
		while not HasModelLoaded(object) do
			Wait(1)
		end
		local MarkerObject = CreateObject(object, Coord, false, true, true) 
		SetEntityHeading(MarkerObject, Heading )
		FreezeEntityPosition(MarkerObject, true)
		SetEntityInvincible(MarkerObject, true)
		SetBlockingOfNonTemporaryEvents(MarkerObject, true)
		SetEntityAlpha(MarkerObject,255 )
		cb( MarkerObject )
	end)
end 
------------------------
--- Ped
------------------------
function CreateMarkerPed( ped , Coord , Heading , cb )
	CreateThread(function()
		RequestModel(ped)
		while not HasModelLoaded(ped) do
			Wait(1)
		end
		local MarkerPed = CreatePed(4, ped ,Coord,Heading, false, true)
		SetEntityHeading(MarkerPed, Heading )
		FreezeEntityPosition(MarkerPed, true)
		SetEntityInvincible(MarkerPed, true)
		SetBlockingOfNonTemporaryEvents(MarkerPed, true)
		SetPedTalk(MarkerPed)
		SetEntityAlpha(MarkerPed,255 )
		GiveWeaponToPed(MarkerPed, GetHashKey('WEAPON_SMG'), 1, true, true)
		cb( MarkerPed )
	end)
end 
---------------------
---- Draw3DText
---------------------
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
---------------------
---- CREATE FUNCTION 
---------------------

function SetMarkerCoord(data , cb )
	local CurrentEntity = 0
	local heading = 0.0
	local Current2Entity = 0 
	local isMarker = false 
	if data.type == 'object' then 
		RequestSpawnObject(data.marker)
		CurrentEntity = CreateObject(data.marker,1.0, 1.0, 1.0, false, true, false)
		SetEntityHeading(CurrentEntity, 0.0)
		SetEntityAlpha(CurrentEntity, 170)
		SetEntityCollision(CurrentEntity, false, false)
		FreezeEntityPosition(CurrentEntity, true)
	elseif data.type == 'marker' then 
		isMarker = true 
		heading = 0.0 
	elseif data.type == 'ped' then 
		RequestModel(data.marker)
		while not HasModelLoaded(data.marker) do
			Wait(1)
		end
		
		CurrentEntity = CreatePed(4, data.marker ,vector3(1.0 , 1.0 ,1.0),0.0, false, true)
		SetEntityHeading(CurrentEntity, 0.0)
		SetEntityAlpha(CurrentEntity, 170)
		SetEntityCollision(CurrentEntity, false, false)
		FreezeEntityPosition(CurrentEntity, true)
	elseif data.type == 'vehicle' then 
		RequestModel(data.marker)
		while not HasModelLoaded(data.marker) do
			Wait(1)
		end
		CurrentEntity = CreateVehicle(data.marker, 1.1, 1.1, 1.1, 0.0, false, true)
		SetEntityHeading(CurrentEntity, 0.0)
		SetEntityAlpha(CurrentEntity, 170)
		SetEntityCollision(CurrentEntity, false, false)
		FreezeEntityPosition(CurrentEntity, true)
	elseif data.type == 'flag' then
		SetFlagoles(GetEntityCoords(PlayerPedId()) ,data.marker  , 170 , function(obj , flagprop)
			CurrentEntity = obj
			Current2Entity = flagprop
		end) 
	else 
		isMarker = true 
		heading = 0.0 
		data = {type =  'marker' , marker = 0  , size = {x = 1.5 , y = 1.5 , z = 1.5} , color = { r = 255 , g =0 , b =0}} 
	end 
	
    CreateThread(function()
		local form = setupScaleform("instructional_buttons")
		local High = 0.0
        while true do
			Wait(1)
			local hit, coords, entity = RayCastGamePlayCamera(20.0)
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
            if hit then
				if not isMarker then 
                	SetEntityCoords(CurrentEntity, coords.x, coords.y, coords.z + High )
					if Current2Entity > 0 then 
						SetEntityCoords(Current2Entity, coords.x, coords.y, coords.z + 6 )
					end 
				end 
            end
			if not isMarker then 
				SetEntityHeading(CurrentEntity, heading)
				if Current2Entity > 0 then 
					SetEntityHeading(Current2Entity, heading)
				end 
			else 
				DrawMarker(data.marker, coords.x , coords.y , coords.z + High, 0.0, 0.0, 0.0, 0.0, heading, 0.0, data.size.x  , data.size.y , data.size.z, data.color.r , data.color.g, data.color.b,90, false, true, 2, nil, nil, false)
			end 
            if IsControlJustPressed(0, 174) or  IsDisabledControlJustPressed(0 ,174)  then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end
            if IsControlJustPressed(0, 175)  or  IsDisabledControlJustPressed(0 ,175)  then
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end
			if IsControlJustPressed(0, 172)  or  IsDisabledControlJustPressed(0 ,172)  then
                High = High + 0.5
  			end
			  if IsControlJustPressed(0, 173)  or  IsDisabledControlJustPressed(0 ,173)  then
                High = High - 0.5
  			end
            if IsControlJustPressed(0, 44) or  IsDisabledControlJustPressed(0 ,44) then
				DeleteEntity(CurrentEntity)
				DeleteEntity(Current2Entity)
				break 
            end
      
            if IsControlJustPressed(0, 38)  or  IsDisabledControlJustPressed(0 ,38)  then
				DeleteEntity(CurrentEntity)
				DeleteEntity(Current2Entity)
				cb( {  coord = vector3(coords.x , coords.y , coords.z + High ) ,heading = heading })
				break 
            end
  		end
	end) 
end 
function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 152, true))
    ButtonMessage("Cancel")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 153, true))
    ButtonMessage("Place object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 190, true))
    Button(GetControlInstructionalButton(2, 189, true))
	Button(GetControlInstructionalButton(2, 187, true))
    Button(GetControlInstructionalButton(2, 188, true))
    ButtonMessage("Rotate object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end
function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end
function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1000)
    end
end
------------------------
----- Blip 
------------------------ 
local GangBlips = {}
function CreateBlip( GangName , data  )
	local CurrentBlip = AddBlipForCoord( data.coord.x , data.coord.y ,data.coord.z  )
	SetBlipSprite (CurrentBlip, data.marker )
	SetBlipDisplay(CurrentBlip, 4 )
	SetBlipScale  (CurrentBlip, 1.2)
	SetBlipColour (CurrentBlip,  data.color)
	SetBlipAsShortRange(CurrentBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString( 'GANG | ' .. GangName )
	EndTextCommandSetBlipName(CurrentBlip)
	table.insert(GangBlips ,  CurrentBlip )
end 
function RemveoAllBlips()
	for k , v in pairs( GangBlips ) do 
		RemoveBlip(v)
	end 
end 

function GetPlayerHandsup(player, type)
	if Config.NeedHandsup[type] then
		if IsEntityPlayingAnim(GetPlayerPed(player), Config.Animations['dead_anim'], Config.Animations['dead_anim_dict'], 3) then
			return true
		elseif IsEntityPlayingAnim(GetPlayerPed(player), Config.Animations['handsup_anim'], Config.Animations['handsup_anim_dict'], 3) then
			return true
		elseif IsEntityPlayingAnim(GetPlayerPed(player), "mp_arresting", "idle", 3) then
			return true
		else
			return false
		end
	else
		return true
	end
end 


function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

function TeleportToCoord(coord)
	StartFade()
	SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z)
	Wait(3000)
	EndFade()
end

RegisterNetEvent('For5M:TpToCoord', function(coord)
	TeleportToCoord(coord)
end)
function GetNeaestrCoordsValueInTable(table)
	local Nears = 1000.0
	local Key = 0 
	for k,v in pairs(table) do 
		local Distance = GetDistanceBetweenCoords( GetEntityCoords(PlayerPedId())  , vector3(v.coord.x ,v.coord.y , v.coord.z) , true )
		if Distance < Nears  then 
			if ESX.Game.IsSpawnPointClear(vector3(v.coord.x ,v.coord.y , v.coord.z), 3.0) then
				Nears = Distance 
				Key = k 
			end 
		end 
	end 
	return Nears , Key 
end 
--- Flag
function SetFlagoles(coords ,Teams  , Alpha, cb )
	CreateThread(function()
		RequestModel(GetHashKey("prop_flagpole_1a"))
		while not HasModelLoaded(GetHashKey("prop_flagpole_1a")) do
			Wait(1)
		end
		RequestModel(GetHashKey(Teams))
		while not HasModelLoaded(GetHashKey(Teams)) do
			Wait(1)
		end
		local crateSpawn = coords
		local falgpole =  CreateObject(GetHashKey("prop_flagpole_1a"), crateSpawn.x , crateSpawn.y , crateSpawn.z , false, true, false) 
		while falgpole == 0 do 
			falgpole =  CreateObject(GetHashKey("prop_flagpole_1a"), crateSpawn.x , crateSpawn.y , crateSpawn.z , false, true, false) 
		end 
		SetEntityVelocity(falgpole, 0.0, 0.0, -0.2)
		SetEntityHeading(falgpole, 0.0)
		SetEntityAlpha(falgpole, Alpha)
		SetEntityCollision(falgpole, false, false)
		FreezeEntityPosition(falgpole, true)
		SetBlockingOfNonTemporaryEvents(falgpole, true)
		if Alpha == 255 then 
			SetEntityCollision(falgpole, true, true)
		end 
		AttchFlag(Teams , Alpha , coords ,function(flagprop) 
			cb(falgpole , flagprop)
		end)
	
	end)
end 
function AttchFlag(Teams , Alpha  , coords , cb )
	CreateThread(function()
		local flagpoleCoords = coords 
		local flagprop = CreateObject(GetHashKey(Teams), vector3( flagpoleCoords.x, flagpoleCoords.y, flagpoleCoords.z + 6), false, true, true) 
		while flagprop == 0 do 
			flagprop = CreateObject(GetHashKey(Teams), vector3( flagpoleCoords.x, flagpoleCoords.y, flagpoleCoords.z + 6), false, true, true) 
			Wait(100)
		end  
		
		SetEntityVelocity(flagprop, 0.0, 0.0, -0.2)
		SetEntityHeading(flagprop, 0.0)
		SetEntityAlpha(flagprop, Alpha)
		SetEntityCollision(flagprop, false, false)
		FreezeEntityPosition(flagprop, true)
		cb(flagprop)
	end)
end
local AllZonesBlip = {} 
function MakeZoneForRadius(pos, radius , color   )
	local blip = AddBlipForRadius(vector3(pos.x , pos.y , pos.z ), radius + 0.0)
	SetBlipHighDetail(blip, true)
	if color ~= nil then 
		SetBlipColour(blip, color)
	else 
		SetBlipColour(blip, 1)
	end 
	SetBlipAlpha (blip, 225)
	SetBlipFade(blip, 40, 40)
	SetBlipAsShortRange(blip, true)
	table.insert(AllZonesBlip ,  blip )

end
function RemveoAllZones()
	for k , v in pairs( AllZonesBlip ) do 
		RemoveBlip(v)
	end 
	for Name , data in pairs(AllMarkers) do

		if AllMarkers[Name].type == 'flag' then 
			DeleteObject(AllMarkers[Name].object)
			DeleteObject(AllMarkers[Name].object2)
			AllMarkers[Name] = nil 
		elseif AllMarkers[Name].type == 'ped' then 
			DeletePed(AllMarkers[Name].ped)
			AllMarkers[Name] = nil 
		end 	
	
	end 
end 