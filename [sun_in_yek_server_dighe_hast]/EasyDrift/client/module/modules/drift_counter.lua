-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Modules.DriftCounter = {}
Modules.DriftCounter.IsEnabled = true
Modules.DriftCounter.IsDrifting = false
Modules.DriftCounter.CurrentPoints = 0
Modules.DriftCounter.CurrentAngle = 0 -- Only refreshed when the player is drifting
Modules.DriftCounter.ChainCooldown = ConfigShared.DriftChainTime
Modules.DriftCounter.ChainLoopStarted = false
Modules.DriftCounter.ChainTimeLeft = 0
Modules.DriftCounter.GlobalAlpha = 0
if ConfigShared.devmod then
    Modules.DriftCounter.GlobalAlpha = 255
end
Modules.DriftCounter.InAnimation = false
Modules.DriftCounter.CachedAllowedVeh = {}



-- Source: https://github.com/Blumlaut/FiveM-DriftCounter/blob/master/driftcounter_c.lua
-- Lot of math stuff i don't understand, thanks Blumlaut
function Modules.DriftCounter.GetCurrentAngle()
    local vx,vy,_ = table.unpack(GetEntityVelocity(vehicle))
	local modV = math.sqrt(vx*vx + vy*vy)


	local _,_,rz = table.unpack(GetEntityRotation(vehicle,0))
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

	if GetEntitySpeed(vehicle)* 3.6 < 25 or GetVehicleCurrentGear(vehicle) == 0 then return 0,modV end --speed over 25 km/h

	local cosX = (sn*vx + cs*vy)/modV
	return math.deg(math.acos(cosX))*0.5, modV
end

-- Cleaning the cache to avoid any memory leak as the system will load up every vehicule entity the player goes in. If the entity is deleted or not in range it will be removed from the list to avoid memory leaks
function Modules.DriftCounter.CleanUpCache()
    for veh, allowed in pairs(Modules.DriftCounter.CachedAllowedVeh) do
        if not DoesEntityExist(veh) then
            Modules.DriftCounter.CachedAllowedVeh[veh] = nil
        end
    end
end

function Modules.DriftCounter.IsVehiculeAllowedToDrift(pVeh)
    if ConfigShared.UseVehicleWhitelist then
        if Modules.DriftCounter.CachedAllowedVeh[pVeh] == nil then
            local pVehModel = GetEntityModel(pVeh)
            if ConfigShared.WhitelistedVehicules[pVehModel] ~= nil then
                Modules.DriftCounter.CachedAllowedVeh[pVeh] = true
            else
                Modules.DriftCounter.CachedAllowedVeh[pVeh] = false
            end
            Modules.DriftCounter.CleanUpCache()
        else
            return Modules.DriftCounter.CachedAllowedVeh[pVeh] -- Using a cache system allow better performance, we don't check the vehicle model every time.
        end
    else
        return true
    end
end

function Modules.DriftCounter.IsPlayerDrifting()
    if GetEntityHeightAboveGround(vehicle) <= 1.5 then
        Modules.DriftCounter.CurrentAngle = Modules.DriftCounter.GetCurrentAngle()
		return Modules.DriftCounter.CurrentAngle > 10 and not exports['sunset_utils']:doesSpeedLimited()
	else
		return false
	end
end

function Modules.DriftCounter.StartChainBreakLoop()
    if not Modules.DriftCounter.ChainLoopStarted then
        Modules.DriftCounter.ChainLoopStarted = true
        if ConfigShared.UseDefaultUI then
            Modules.DriftCounter.FadeInHud()
        end
        TriggerEvent(ConfigShared.DriftStartEvent)
        Citizen.CreateThread(function()
            Modules.Utils.RealWait(Modules.DriftCounter.ChainCooldown, function(cb, timeLeft)
                Modules.DriftCounter.ChainTimeLeft = timeLeft - (timeLeft * 2) -- Duh
                if Modules.DriftCounter.IsDrifting then
                    cb(false, ConfigShared.DriftChainTime)
                end
            end)
            if ConfigShared.UseDefaultUI then
                Modules.DriftCounter.FadeOutHud()
            end
            TriggerEvent(ConfigShared.DriftFinishedEvent, Modules.DriftCounter.CurrentPoints)
            Modules.DriftCounter.ChainCooldown = ConfigShared.DriftChainTime
            Modules.DriftCounter.ChainLoopStarted = false
            ESX.TriggerServerEvent('drift:addPoint', Modules.DriftCounter.CurrentPoints)
            Modules.DriftCounter.CurrentPoints = 0
            Modules.DriftCounter.CurrentAngle = 0
            Modules.DriftCounter.ChainTimeLeft = 0
        end)
    end
end

function Modules.DriftCounter.FadeInHud()
    Citizen.CreateThread(function()
        Modules.DriftCounter.InAnimation = true
        while Modules.DriftCounter.GlobalAlpha < 255 do
            Modules.DriftCounter.GlobalAlpha = Modules.DriftCounter.GlobalAlpha + (0.5 * Modules.Utils.TimeFrame)
            Wait(0)
        end
        Modules.DriftCounter.InAnimation = false
        Modules.DriftCounter.GlobalAlpha = 255
    end)
end

function Modules.DriftCounter.FadeOutHud()
    Citizen.CreateThread(function()
        Modules.DriftCounter.InAnimation = true
        while Modules.DriftCounter.GlobalAlpha > 0 do
            Modules.DriftCounter.GlobalAlpha = Modules.DriftCounter.GlobalAlpha - (0.5 * Modules.Utils.TimeFrame)
            Wait(0)
        end
        Modules.DriftCounter.InAnimation = false
        Modules.DriftCounter.GlobalAlpha = 0
    end)
end
vehicle = 0
bDriftThread = false
AddEventHandler('enterVehicle', function(_vehicle, bDriver)
	if bDriver then
		if not bDriftThread then
            bDriftThread = true
			vehicle = _vehicle
            startNativeUIThread()
            startNativePageThread()
            local timer = GetGameTimer()
            Citizen.CreateThread(function()
                while bDriftThread do
                    Modules.Utils.TimeFrame = (GetGameTimer() - timer)
                    timer = GetGameTimer()
                    Wait(0)
                end
            end)
			Citizen.CreateThread(function()
                while bDriftThread do
                    if Modules.DriftCounter.IsEnabled then -- Check we're enabled
                        if Modules.DriftCounter.IsPlayerDrifting() then
                            Modules.DriftCounter.IsDrifting = true
                            Modules.DriftCounter.StartChainBreakLoop()
                            if Modules.DriftCounter.CurrentAngle > 10 then
                                if ConfigShared.AddPointBasedOnAngle then
                                    Modules.DriftCounter.CurrentPoints = math.floor(Modules.DriftCounter.CurrentPoints + (Modules.DriftCounter.CurrentAngle / 1000) * Modules.Utils.TimeFrame) -- This fix the issue where player with low fps would get less point then player with high fps count.
                                end
            
                                if ConfigShared.AddStaticPointOnDrifting then
                                    Modules.DriftCounter.CurrentPoints = math.floor(Modules.DriftCounter.CurrentPoints + ConfigShared.StaticPointToAdd * Modules.Utils.TimeFrame) -- This fix the issue where player with low fps would get less point then player with high fps count. 
                                end
                            end
                        else
                            Modules.DriftCounter.IsDrifting = false
                            if Modules.DriftCounter.ChainLoopStarted then
                                Wait(0) -- Chain active, so we need to check if the player start drifting again or not as fast as possible
                            else
                                Wait(100) -- Could be longer i guess, but will take more time to detect if the player is drifting or not.
                            end
                        end
                    else
                        Wait(1000) -- Sleep if disabled
                    end
                    Wait(0)
                end
            end)
		end
	end
end)

AddEventHandler('exitVehicle', function(vehicle, bDriver)
	bDriftThread = false
    vehicle = 0
end)


AddEventHandler(ConfigShared.GetCurrentDriftScore, function(cb)
    cb(Modules.DriftCounter.CurrentPoints) 
end)

AddEventHandler(ConfigShared.IsDrifting, function(cb)
    cb(Modules.DriftCounter.IsDrifting) 
end)

AddEventHandler(ConfigShared.IsEnabled, function(cb)
    cb(Modules.DriftCounter.IsEnabled) 
end)

AddEventHandler(ConfigShared.EnableEvent, function()
    Modules.DriftCounter.IsEnabled = true
end)

AddEventHandler(ConfigShared.DisableEvent, function()
    Modules.DriftCounter.IsEnabled = false
end)

AddEventHandler(ConfigShared.ToggleEvent, function()
    Modules.DriftCounter.IsEnabled = not Modules.DriftCounter.IsEnabled
end)
