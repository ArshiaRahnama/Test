

ESX                         = nil
inMenu                      = false
local showblips = true
local anim = "mini@atmenter"
local blocked = false
local modeltypes = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}

local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=106, x=246.40, y=222.99, z=106.29},
  {name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('new_banking:disableforhour')
AddEventHandler('new_banking:disableforhour', function(pos, time)
  local condition = true
  SetTimeout(time, function()
    condition = false
    blocked = false
  end)
  Citizen.CreateThread(function()
    while condition do
      Citizen.Wait(5000)
      local playerloc = GetEntityCoords(PlayerPedId())
      local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc.x, playerloc.y, playerloc.z, false)
      if distance <= 20.0 then
        blocked = true
      else
        blocked = false
      end
    end
  end)
end)

RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance, iban)
    local id = PlayerId()
    local playerName = GetPlayerName(id)
    SendNUIMessage({
        type = "balanceHUD",
        balance = balance,
        player = playerName,
        cardnumber = iban
    })
end)

Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		-- local blip = AddBlipForCoord(v.x, v.y, v.z)
		-- SetBlipSprite(blip, v.id)
		-- SetBlipScale(blip, 0.7)
		-- SetBlipColour(blip, 2)
		-- SetBlipAsShortRange(blip, true)
		-- BeginTextCommandSetBlipName("STRING")
		-- AddTextComponentString(tostring(v.name))
		-- EndTextCommandSetBlipName(blip)
	  end
	end
end)

exports.ox_target:addModel(modeltypes, {
    {
        name = 'new_banking:open',
        icon = 'fa-solid fa-building-columns',
        label = 'استفاده از خودپرداز (Bank)',
        distance = 2.0,
        canInteract = function(entity, distance, coords, name)
            if blocked then return false end
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, true) then return false end
            return true
        end,
        onSelect = function(data)
            OpenBankAtm(data.entity)
        end,
    }
})

function OpenBankAtm(atmEntity)
	if inMenu then return end

	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	DisableAllControlActions(0)
	SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)

	local atmOffset = GetOffsetFromEntityInWorldCoords(atmEntity, 0.0, -0.65, 0.0)
	local atmX, atmY, atmZ = atmOffset.x, atmOffset.y, atmOffset.z

	RequestAnimDict("mini@atmbase")
	RequestAnimDict(anim)
	while not HasAnimDictLoaded(anim) do
		Wait(1)
	end

	Wait(500)
	TaskLookAtEntity(playerPed, atmEntity, 2000, 2048, 2)
	Wait(500)
	TaskGoStraightToCoord(playerPed, atmX, atmY, atmZ, 0.1, 4000, GetEntityHeading(atmEntity), 0.5)
	Wait(2000)
	TaskPlayAnim(playerPed, anim, "enter", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
	RemoveAnimDict(anim)
	Wait(4000)
	TaskPlayAnim(playerPed, "mini@atmbase", "base", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
	RemoveAnimDict("mini@atmbase")
	Wait(1000)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:balance')


	Citizen.CreateThread(function()
		while inMenu do
			Wait(0)
			DisableControlAction(0, 201, true)
			DisableControlAction(1, 201, true)
			DisableAllControlActions(0)
			FreezeEntityPosition(PlayerPedId(), true)
		end
	end)
end

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:depositx', tonumber(data.amount))
end)

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdrawx', tonumber(data.amountw))
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)

	SendNUIMessage({type = 'balanceReturn', bal = balance})

end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transferx', data.to, data.amountt)

end)

RegisterNUICallback('NUIFocusOff', function()
  FreezeEntityPosition(PlayerPedId(), false)
  PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)
