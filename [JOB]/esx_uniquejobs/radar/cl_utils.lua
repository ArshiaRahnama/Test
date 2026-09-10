--[[---------------------------------------------------------------------------------------

	Wraith ARS 2X
	Created by WolfKnight

	For discussions, information on future updates, and more, join
	my Discord: https://discord.gg/fD4e6WD

	MIT License

	Copyright (c) 2020-2021 WolfKnight

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

---------------------------------------------------------------------------------------]]--

UTIL = {}

-- Returns a number to a set number of decimal places
function UTIL:Round( num, numDecimalPlaces )
	return tonumber( string.format( "%." .. ( numDecimalPlaces or 0 ) .. "f", num ) )
end

-- The custom font used for the digital displays have the ¦ symbol as an empty character, this function
-- takes a speed and returns a formatted speed that can be displayed on the radar
function UTIL:FormatSpeed( speed )
	-- Return "Err" (Error) if the given speed is outside the 0-999 range
	if ( speed < 0 or speed > 999 ) then return "Err" end

	-- Convert the speed to a string
	local text = tostring( speed )
	local pipes = ""

	-- Create a string of pipes (¦) for the number of spaces
	for i = 1, 3 - string.len( text ) do
		pipes = pipes .. "¦"
	end

	-- Return the formatted speed
	return pipes .. text
end

-- Returns a clamped numerical value based on the given parameters
function UTIL:Clamp( val, min, max )
	-- Return the min value if the given value is less than the min
	if ( val < min ) then
		return min
	-- Return the max value if the given value is larger than the max
	elseif ( val > max ) then
		return max
	end

	-- Return the given value if it's between the min and max
	return val
end

-- Returns if the given table is empty, includes numerical and non-numerical key values
function UTIL:IsTableEmpty( t )
	local c = 0

	for _ in pairs( t ) do c = c + 1 end

	return c == 0
end

-- Credit to Deltanic for this function
function UTIL:Values( xs )
	local i = 0

	return function()
		i = i + 1
		return xs[i]
	end
end

-- Old ray trace function for getting a vehicle in a specific direction from a start point
function UTIL:GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
	local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
	return vehicle
end

-- Returns if a target vehicle is coming towards or going away from the patrol vehicle, it has a range
-- so if a vehicle is sideways compared to the patrol vehicle, the directional arrows won't light up
function UTIL:GetEntityRelativeDirection( myAng, tarAng )
	local angleDiff = math.abs( ( myAng - tarAng + 180 ) % 360 - 180 )

	if ( angleDiff < 45 ) then
		return 1
	elseif ( angleDiff > 135 ) then
		return 2
	end

	return 0
end

-- Returns if there is a player in the given vehicle
function UTIL:IsPlayerInVeh( veh )
	for i = -1, GetVehicleMaxNumberOfPassengers( veh ) + 1, 1 do
		local ped = GetPedInVehicleSeat( veh, i )

		if ( DoesEntityExist( ped ) ) then
			if ( IsPedAPlayer( ped ) ) then return true end
		end
	end

	return false
end

-- Your everyday GTA notification function
function UTIL:Notify( text )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentSubstringPlayerName( text )
	DrawNotification( false, true )
end

-- Prints the given message to the client console
function UTIL:Log( msg )
	--print( "[Wraith ARS 2X]: " .. msg )
end

-- Used to draw text to the screen, helpful for debugging issues
function UTIL:DrawDebugText( x, y, scale, centre, text )
	SetTextFont( 4 )
	SetTextProportional( 0 )
	SetTextScale( scale, scale )
	SetTextColour( 255, 255, 255, 255 )
	SetTextDropShadow( 0, 0, 0, 0, 255 )
	SetTextEdge( 2, 0, 0, 0, 255 )
	SetTextCentre( centre )
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry( "STRING" )
	AddTextComponentString( text )
	DrawText( x, y )
end

-- FIX (works regardless of what the resource folder is named):
-- This used to require the resource folder to be named exactly "sun-radar" or
-- else NO keybinds would register at all (silently - the whole radar would
-- appear completely dead). Combined with the same hardcoded name in radar.js,
-- this was a leftover restriction from a previous rebrand of the script.
-- Now always allowed, so it works under whatever folder name you use.
function UTIL:IsResourceNameValid()
	return true
end

--[[The MIT License (MIT)

	Copyright (c) 2017 IllidanS4

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.

	The below code can be found at: https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2
]]

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function UTIL:EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

--[[----------------------------------------------------------------------------------
	FIX #2: the class-18 ("Emergency") check above breaks on custom/add-on police
	vehicles whose vehicles.meta was never tagged as the Emergency class (very
	common with reskinned/add-on cars). That made CanControlRadar() always false,
	so the remote never opened no matter what key was pressed - even though the
	job check passed. Job restriction (CONFIG.jobs) is already the real security
	gate here, so the vehicle just needs to be an actual vehicle, not a specific
	in-game class.
----------------------------------------------------------------------------------]]--
local function IsValidRadarVehicle(veh)
	if veh == nil or veh == 0 or not DoesEntityExist(veh) then
		return false
	end

	return true
end

function startThread()
	if not threadBool then
		threadBool = true
		Citizen.CreateThread( function()
			while ( threadBool ) do
				-- Run the main plate reader function
				READER:Main()
		
				-- Wait half a second
				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			Citizen.Wait( 100 )
		
			while ( threadBool ) do
				-- Run the check
				READER:RunDisplayValidationCheck()
		
				-- Wait half a second
				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				PLY.ped = PlayerPedId()
				PLY.veh = GetVehiclePedIsIn( PLY.ped, false )
				PLY.inDriverSeat = GetPedInVehicleSeat( PLY.veh, -1 ) == PLY.ped
				PLY.inPassengerSeat = GetPedInVehicleSeat( PLY.veh, 0 ) == PLY.ped
				PLY.vehClassValid = IsValidRadarVehicle(PLY.veh)
		
				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				-- The sync trigger should only start when the player is getting into a vehicle
				if ( IsPedGettingIntoAVehicle( PLY.ped ) and RADAR:IsPassengerViewAllowed() ) then
					-- Get the vehicle the player is entering
					local vehEntering = GetVehiclePedIsEntering( PLY.ped )
		
					-- Only proceed if the vehicle the player is entering is an emergency vehicle
					if ( IsValidRadarVehicle(PLY.veh) ) then
						-- Wait two seconds, this gives enough time for the player to get sat in the seat
						Citizen.Wait( 2000 )
		
						-- Get the vehicle the player is now in
						local veh = GetVehiclePedIsIn( PLY.ped, false )
		
						-- Trigger the main sync data function if the vehicle the player is now in is the same as the one they
						-- began entering
						if ( veh == vehEntering ) then
							SYNC:SyncDataOnEnter()
						end
					end
				end
		
				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				-- Run the function
				RADAR:RunDynamicThreadWaitCheck()
		
				-- Make the thread wait two seconds
				Citizen.Wait( 2000 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				-- Run the function
				RADAR:RunThreads()
		
				-- Make the thread wait 0 ms
				Citizen.Wait( 0 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				RADAR:Main()
		
				Citizen.Wait( 100 )
			end
		end )

		Citizen.CreateThread( function()
			Citizen.Wait( 100 )
		
			while ( threadBool ) do
				-- Run the check
				RADAR:RunDisplayValidationCheck()
		
				-- Wait half a second
				Citizen.Wait( 500 )
			end
		end )

		-- FEATURE ADDED: hide/show the pursuit timer based on vehicle state,
		-- same as the radar display itself does above.
		local lastPtVehState = nil

		-- FIX: Quick Actions (PANIC + PLACE TRACKER) used to only appear
		-- after manually opening the full radar remote (item interact),
		-- unlike every other always-on HUD widget in this resource. Now
		-- it follows the same "in a vehicle + right job" rule as the
		-- pursuit timer above, live, with no remote-opening required -
		-- matching how the rest of the server's Insert-menu HUD toggles
		-- behave (always there, just needs the mouse free to click).
		local lastQaState = nil
		local lastQaAgentState = nil

		Citizen.CreateThread( function()
			while ( threadBool ) do
				local inVeh = PLY.veh ~= nil and PLY.veh > 0
				local job = ( ESX ~= nil and ESX.GetPlayerData() ~= nil ) and ESX.GetPlayerData().job or nil
				local hasAccess = job ~= nil and CONFIG.jobs[job.name] == true
				local qaState = inVeh and hasAccess
				local agentState = qaState and CONFIG.agentJobs[job.name] == true

				if ( qaState ~= lastQaState ) then
					lastQaState = qaState
					SendNUIMessage( { _type = "showQuickActions", state = qaState } )
				end

				if ( agentState ~= lastQaAgentState ) then
					lastQaAgentState = agentState
					SendNUIMessage( { _type = "setAgentAccess", state = agentState } )
				end

				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				local inVeh = PLY.veh ~= nil and PLY.veh > 0

				if ( inVeh ~= lastPtVehState ) then
					lastPtVehState = inVeh
					SendNUIMessage( { _type = "pursuitTimerVehicleState", state = inVeh } )
				end

				Citizen.Wait( 500 )
			end
		end )

		Citizen.CreateThread( function()
			while ( threadBool ) do
				-- Update the vehicle pool
				RADAR:UpdateVehiclePool()
		
				-- Wait 3 seconds
				Citizen.Wait( 3000 )
			end
		end )
	end
end