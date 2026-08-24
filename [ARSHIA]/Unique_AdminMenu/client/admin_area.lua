ESX=nil

Citizen.CreateThread(function()
	while ESX==nil do
		Citizen.Wait(50)
	TriggerEvent('esx:getSharedObject',function(a)ESX=a end)
	end
end)

local b={}

function missionTextDisplay(c,d)

ClearPrints()
SetTextEntry_2("STRING")
AddTextComponentString(c)
DrawSubtitleTimed(d,1)

end

local function e(f)
	local g={}
	local h=GetGameTimer()/1000;
		g.r=math.floor(math.sin(h*f+0)*127+128)
		g.g=math.floor(math.sin(h*f+2)*127+128)
		g.b=math.floor(math.sin(h*f+4)*127+128)
	return g
end

function Draw3DTextsx(i,j,k,c,l)
local m,n,o=World3dToScreen2d(i,j,k)
local p,q,r=table.unpack(GetGameplayCamCoords())
local s= #(vector3(p,q,r) - vector3(i,j,k))
local t=1/s*l
local u=1/GetGameplayCamFov()*100;
local t=t*u

	if m then

	SetTextScale(0.0*t,1.1*t)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255,255,255,255)
	SetTextDropshadow(0,0,0,0,255)
	SetTextEdge(2,0,0,0,150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString("~a~"..c)
	DrawText(n,o)
	end
end

RegisterNetEvent('Fax:AdminAreaSet')
AddEventHandler("Fax:AdminAreaSet",function(v,w)
	local i,j,k=table.unpack(GetEntityCoords(PlayerPedId(),true))
	ax=i
	ay=j
	az=k
	if w~=nil then
	src=w
	coords=GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
	coordss=GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(-1)))
	else
	coords=v.coords
	end
	if not b[v.index]then
	b[v.index]={}
	end
	if not givenCoords then

	TriggerServerEvent('AdminArea:setCoords',tonumber(v.index),coords)

	end

	b[v.index]["blip"]=AddBlipForCoord(coords.x,coords.y,coords.z)
	b[v.index]["radius"]=AddBlipForRadius(coords.x,coords.y,coords.z,v.radius)

	SetBlipSprite(b[v.index].blip,v.id)
	SetBlipAsShortRange(b[v.index].blip,true)
	SetBlipColour(b[v.index].blip,v.color)
	SetBlipScale(b[v.index].blip, 0.7)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(v.name)
	EndTextCommandSetBlipName(b[v.index].blip)
	b[v.index]["coords"]=coords
	SetBlipAlpha(b[v.index]["radius"],80)
	SetBlipColour(b[v.index]["radius"],v.color)
	b[v.index]["active"]=true
	if w~=nil then
	source=w
	missionTextDisplay("~r~RP PAUSE ~o~| ~g~MANTAGHE: ADMIN AREA ("..tonumber(v.index)..") ~o~| ~r~ADMIN: "..GetPlayerName(GetPlayerFromServerId(source)),8000)
	lib.notify({ position = 'center-right', description = "<b style='color:Black'>RP STOP </b> <br /><br /><b style='color:#00FF00'>MANTAGHE: ("..tonumber(v.index)..") </b><br /><br /> <b style='color:Black'>ADMIN NAZER: ("..GetPlayerName(GetPlayerFromServerId(source))..") </b><br /><br /><b style='color:yellow'>Az Mantaghe RP STOP Dor Shavid.</b>", type = "error", duration = 15000 })

	end

	while b[v.index]["active"]do
		Wait(1)
	local x=e(1)
	local y=v.radius
	local i,j,k=table.unpack(GetEntityCoords(PlayerPedId(),true))
	DrawMarker(28,b[v.index]["coords"],0.0,0.0,0.0,0,0.0,0.0,v.radius-1.5,v.radius-1.5,v.radius-1.5,x.r,x.g,x.b,100,false,false,2,false,false,false,false)DrawMarker(28,b[v.index]["coords"],0.0,0.0,0.0,0,0.0,0.0,v.radius+0.8,v.radius+0.8,v.radius+0.8,255,255,255,100,false,false,2,false,false,false,false)
	if b[v.index]["coords"]~=nil then
	source=w
	if #(GetEntityCoords(PlayerPedId()) - vector3(ax,ay,az)) <=y then

	TriggerEvent("sc_adminarea:scary","CHAR_BLOCKED",1,"~r~RP STOP ","~g~MANTAGHE: ("..tonumber(v.index)..") ","ADMIN NAZER: ("..GetPlayerName(GetPlayerFromServerId(source))..")     ~r~Az Mantaghe RP STOP Dor Shavid.")

	end
	if #(vector3(i,j,k) - vector3(b[v.index]["coords"].x,b[v.index]["coords"].y,b[v.index]["coords"].z))<=y then

	SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
	SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
	DisableControlAction(0,37,true)
	DisableControlAction(0,24,true)
	DisableControlAction(0,205,true)
	DisableControlAction(0,200,true)
	DisableControlAction(0,170,true)

	if #(vector3(i,j,k) - vector3(b[v.index]["coords"].x,b[v.index]["coords"].y,b[v.index]["coords"].z))>=y-1.5 then
	SetPedCoordsKeepVehicle(PlayerPedId(),b[v.index]["coords"])
	end
	qx=GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(-1)))
	if #(vector3(i,j,k) - vector3(b[v.index]["coords"].x,b[v.index]["coords"].y,b[v.index]["coords"].z))>=y-1 then
	SetPedCoordsKeepVehicle(PlayerPedId(),qx.x-y,qx.y+y+1,qx.z)

				end
			end
		end
	end
end)

RegisterNetEvent('sc:blipon')
AddEventHandler("sc:blipon",function(src)
scary=true
end)

RegisterNetEvent('sc:blipoff')
AddEventHandler("sc:blipoff",function(src)
scary=false
end)

RegisterNetEvent("sc_adminarea:scary")
AddEventHandler("sc_adminarea:scary",function(z,A,B,C,c)

Citizen.CreateThread(function()
	Wait(50)

SetNotificationTextEntry("STRING")
AddTextComponentString(c)
SetNotificationMessage(z,z,true,A,B,C,c)
DrawNotification(false,true)
	end)
end)

RegisterNetEvent('Fax:AdminAreaClear')
AddEventHandler("Fax:AdminAreaClear",function(D)

	if b[D]then

	b[D]["active"]=false

	RemoveBlip(b[D].blip)
	RemoveBlip(b[D].radius)
	b[D]=nil
	missionTextDisplay("~p~RP UNPAUSE ~o~| ~g~MANTAGHE: ADMIN AREA ("..D..") ~o~| ~p~MANTAGHE AZAD SHOD",5000)
	else

	end
end)