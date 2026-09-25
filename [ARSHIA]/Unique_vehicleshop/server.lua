
AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	print("^2[Unique_vehicleshop]^7 started - fixed/secured build")
end)
