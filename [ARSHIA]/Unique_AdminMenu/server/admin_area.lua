ESX=nil

local a={}

TriggerEvent('esx:getSharedObject',function(b)ESX=b end)

RegisterServerEvent("AdminArea:setCoords")
AddEventHandler("AdminArea:setCoords",function(c,d)

if not d then

return end

if a[c]then

a[c].coords=d

else

print("Exception happened blip id: "..tostring(c).." does not exist")

	end
end)

RegisterCommand('rpp',function(e,f)

local g=ESX.GetPlayerFromId(e)

if g.permission_level >= 1 then

if g.get('aduty')then

local h=tonumber(f[1])

if h then

h=h/1.0

else

h=80.0
end

local i=math.floor(TableLength()+1)
local j={id=269,name="Admin Area("..i..")",radius=h,color=32,index=tostring(i),coords=0}table.insert(a,j)

if h>=1 then

TriggerClientEvent("Fax:AdminAreaSet",-1,j,e)
TriggerClientEvent("sc:blipon",-1,e)
else
TriggerClientEvent('chatMessage',e,"[SYSTEM]",{255,0,0}," ^0Blip ID Bayad Bishtar Az 4 Bashad!")

end
else
TriggerClientEvent('chatMessage',e,"[SYSTEM]",{255,0,0}," ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

end

else

TriggerClientEvent('chatMessage',e,"[SYSTEM]",{255,0,0}," ^0Shoma admin nistid!")

	end
end)

RegisterCommand('rps', function(e, f)
	local g = ESX.GetPlayerFromId(e)
	if not g then return end

	if g.permission_level >= 1 then
		if g.get('aduty') then
			if f[1] then
				if tonumber(f[1]) then
					local k = tonumber(f[1])

					TriggerClientEvent("sc:blipoff", -1, e)
					if findArea(k) then
						TriggerClientEvent("Fax:AdminAreaClear", -1, tostring(k))
						SRemoveBlip(k)
					else
						TriggerClientEvent('chatMessage', e, "[SYSTEM]", {255,0,0}, " ^0Blip ID vared shode eshtebah ast!")
					end
				else
					TriggerClientEvent('chatMessage', e, "[SYSTEM]", {255,0,0}, " ^0Shoma dar ghesmat ID blip faghat mitavanid adad vared konid!")
				end
			else
				TriggerClientEvent('chatMessage', e, "[SYSTEM]", {255,0,0}, " ^0Shoma dar ghesmat ID blip chizi vared nakardid!")
			end
		else
			TriggerClientEvent('chatMessage', e, "[SYSTEM]", {255,0,0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
		end
	else
		TriggerClientEvent('chatMessage', e, "[SYSTEM]", {255,0,0}, " ^0Shoma admin nistid!")
	end
end)

AddEventHandler('esx:playerLoaded', function(e)
	if #a ~= 0 then
		for l, m in pairs(a) do
			if m.coords ~= 0 then
				TriggerClientEvent("Fax:AdminAreaSet", e, m)
			end
		end
	end
end)

function findArea(n)
	for l,m in pairs(a)do if l==n then

	return true
	end
end
	return false

end

function SRemoveBlip(n)a[n]=nil end

function TableLength()
	if#a==0 then
	return 0
	else
	return a[#a].index
	end
end