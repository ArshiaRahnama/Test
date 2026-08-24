ESX = nil
local HaveBagOnHead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

function NajblizszyGracz()

local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
local player = PlayerPedId()

if closestPlayer == -1 or closestDistance > 2.0 then
    ESX.ShowNotification('~r~Hich Playeri Nazdik Shoma Nist!')
else
  if not HaveBagOnHead then
    TriggerServerEvent('esx_worek:sendclosest', GetPlayerServerId(closestPlayer))
    ESX.ShowNotification('~g~Shoma Sare ~w~' .. GetPlayerName(closestPlayer) .. 'Guni Gozashtid.')
    TriggerServerEvent('esx_worek:closest')
  else
    ESX.ShowNotification('~r~In Player Guni Roo Saresh Hast!')
  end
end

end

RegisterNetEvent('esx_worek:naloz')
AddEventHandler('esx_worek:naloz', function()
    OpenBagMenu()
end)

RegisterNetEvent('esx_worek:nalozNa')
AddEventHandler('esx_worek:nalozNa', function(gracz)
    local playerPed = PlayerPedId()
    Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    Worek = ESX.Game.SpawnObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(Worek, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
end)

AddEventHandler('playerSpawned', function()
DeleteEntity(Worek)
SetEntityAsNoLongerNeeded(Worek)
SendNUIMessage({type = 'closeAll'})
HaveBagOnHead = false
end)

RegisterNetEvent('esx_worek:zdejmijc')
AddEventHandler('esx_worek:zdejmijc', function(gracz)
    ESX.ShowNotification('~g~Guni Bardashte Shod.')
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

function OpenBagMenu()

    local elements = {
          {label = 'Gozashtan Guni Roo Sar', value = 'puton'},
          {label = 'Bardashtan Guni Az Sar', value = 'putoff'},

        }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'headbagging',
      {
        title    = 'Menu Guni',
        align    = 'top-left',
        elements = elements
        },

            function(data2, menu2)


              local player, distance = ESX.Game.GetClosestPlayer()

              if distance ~= -1 and distance <= 2.0 then

                if data2.current.value == 'puton' then
                    NajblizszyGracz()
					DisplayRadar(false)
                end

                if data2.current.value == 'putoff' then
                  TriggerServerEvent('esx_worek:zdejmij')
				  DisplayRadar(true)
				  TriggerEvent('esx_skin:reloadMe')
                end
              else
                ESX.ShowNotification('~r~Hich Playeri Nazdik Shoma Nist!')
              end
            end,
      function(data2, menu2)
        menu2.close()
      end
    )

  end

