ESX = nil
local id = PlayerId()
local PlayerData = {}
Citizen.CreateThread(function ()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(100)
  end

  while not ESX.GetPlayerData().job do
	  Citizen.Wait(100)
  end

  PlayerData = ESX.GetPlayerData()
end)

local block = {["sheriff"] = true, ["police"] = true, ["ambulance"] = true, ["mt"] = true}

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)









RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(data)
  if data.id == id then
    TriggerEvent('chatMessage', data.prefix, data.color, data.message)
  elseif Vdist(GetEntityCoords(PlayerPedId()), data.coords) <= data.distance then
    TriggerEvent('chatMessage', data.prefix, data.color, data.message)
  end
end)

RegisterNetEvent('sendProximityMessageMP')
AddEventHandler('sendProximityMessageMP', function(data)
  if data.id == id then

    if data.incar then
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    else
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    end
  elseif Vdist(GetEntityCoords(PlayerPedId()), data.coords) <= data.distance then

    if data.incar then
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    else
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    end
  end
end)

RegisterNetEvent('sendProximityMessageMP2')
AddEventHandler('sendProximityMessageMP2', function(data)
  if data.id == id then

    if data.incar then
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(160, 139, 114, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    else
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(160, 139, 114, 0.4)); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    end
  elseif Vdist(GetEntityCoords(PlayerPedId()), data.coords) <= data.distance then

    if data.incar then
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(160, 139, 114, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    else
      TriggerEvent(
        "chat:addMessage",
        {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(160, 139, 114, 0.4); border: 3px red solid; border-radius: 3px; color: white;"><i class="far fa-newspaper"></i>{0}<br>{1}</div>',
          args = {data.prefix, data.message}
        }
      )
    end
  end
end)

RegisterNetEvent('sendProximityRadio')
AddEventHandler('sendProximityRadio', function(data)
  if id ~= data.id and data.radio ~= exports.rp_radio:getCurrentFreq() then
    if Vdist(GetEntityCoords(PlayerPedId()), data.coords) <= data.distance then
      TriggerEvent('chatMessage', data.prefix, data.color, data.message)
    end
  end
end)

RegisterNetEvent('sendProximityDep')
AddEventHandler('sendProximityDep', function(data)
  if id ~= data.id and not block[PlayerData.job.name] then
      if Vdist(GetEntityCoords(PlayerPedId()), data.coords) <= data.distance then
        TriggerEvent('chatMessage', data.prefix, data.color, data.message)
      end
  end
end)

RegisterNetEvent('sendRollThatShit')
AddEventHandler('sendRollThatShit', function()
	RequestAnimDict('mp_player_int_upperwank')
	if not HasAnimDictLoaded('mp_player_int_upperwank') then
		RequestAnimDict('mp_player_int_upperwank')
		while not HasAnimDictLoaded('mp_player_int_upperwank') do
			Citizen.Wait(1)
		end
	end
	TriggerServerEvent('InteractSirrpound_SV:PlayWitirrphinDistance', 6.0, 'shake', 0.9)
	TriggerServerEvent('InteractSirrpound_SV:PlayWitirrphinDistance', 6.0, 'drop', 0.9)
	local playerPed = PlayerPedId()
	local animation = 'mp_player_int_wank_01_enter'
	local animation2 = 'mp_player_int_wank_01_exit'
	local flags = 8
	TaskPlayAnim(playerPed, 'mp_player_int_upperwank', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
	Citizen.Wait(650)
	TaskPlayAnim(playerPed, 'mp_player_int_upperwank', animation2, 8.0, -8, -1, flags, 0, 0, 0, 0)
end)

function contains(table, val)
  for i=1,#table do
     if table[i] == val then
      return true
     end
  end
  return false
end