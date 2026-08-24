

function SpawnLocalPed(pedType, model, coords, heading)
	ESX.Streaming.RequestModel(model)
	local ped = CreatePed(pedType, GetHashKey(model), coords.x, coords.y, coords.z, heading or 0.0, true, true)
	SetModelAsNoLongerNeeded(GetHashKey(model))
	return ped
end

function SpawnLocalPed_Callback(pedType, model, coords, heading, cb)
	local ped = SpawnLocalPed(pedType, model, coords, heading)
	if cb then cb(ped) end
end
