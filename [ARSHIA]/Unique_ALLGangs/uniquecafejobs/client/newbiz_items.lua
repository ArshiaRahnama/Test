--[[
	One generic handler for all 30 new bakery/bar/pizza/icecream/sushi items,
	instead of 30 duplicated blocks. Same prop-attach + idle animation the
	original AH_uwucafejob items already used - only the prop model changes.
]]

local IsAnimatedNewBiz = false

RegisterNetEvent('uniquecafejobs:onConsumeNewBiz')
AddEventHandler('uniquecafejobs:onConsumeNewBiz', function(propModel)
	if IsAnimatedNewBiz then return end
	propModel = propModel or 'prop_cs_burger_01'
	IsAnimatedNewBiz = true

	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed))
		local prop = CreateObject(GetHashKey(propModel), x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 28422)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.01, -0.01, -0.06, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

		ESX.Streaming.RequestAnimDict('amb@world_human_drinking@coffee@male@idle_a', function()
			TaskPlayAnim(playerPed, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_c', 1.0, -1.0, 20000, 0, 1, true, true, true)

			Citizen.Wait(15000)
			IsAnimatedNewBiz = false
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end)
	end)
end)
