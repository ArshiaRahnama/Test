--[[----------------------------------------------------------------------------------
	FEATURE ADDED: Plate reader <-> esx_uniquejobs integration

	This deliberately does NOT add or change anything inside esx_uniquejobs.
	That resource already exposes everything needed:

	  - ESX.RegisterServerCallback('CrimeScene:getActiveBOLOs', ...)
	    (cad/server/crimescene.lua) - returns the DOJ/Crime Scene system's
	    currently active BOLOs as { plate, caseId, issuedBy, issuedAt }. It's
	    already gated server-side to police/sheriff/mt (Config_cs.LawEnforcementJobs),
	    so nothing extra needs to be checked here.

	This file just polls that existing callback every few seconds and caches
	the plates locally, so cl_plate_reader.lua's scan loop (cl_plate_reader.lua,
	READER:Main) can flag a match instantly without hitting the server on every
	single scan tick.

	Owner name lookup ("who is this plate registered to") is NOT part of
	esx_uniquejobs at all - it's just the base `owned_vehicles` table joined
	against `users`, so that query lives entirely in this resource's own
	sv_plate_lookup.lua instead.
----------------------------------------------------------------------------------]]--

local ActiveBoloPlates = {}

-- FEATURE ADDED: live GPS-tracker plates (esx_uniquejobs' tracker_manager.lua).
-- Unlike BOLOs this is a broadcast, not a poll - the server pushes an update
-- to everyone the moment a tracker is placed/removed/expires, so we just
-- cache whatever we're told rather than asking on a timer.
local TrackedPlates = {}

function IsUniqueJobsBoloPlate( plate )
	if ( plate == nil or plate == "" ) then return false end

	return ActiveBoloPlates[plate] == true
end

-- Exposed for cl_plate_reader.lua
function IsUniqueJobsTrackedPlate( plate )
	if ( plate == nil or plate == "" ) then return false end

	return TrackedPlates[plate] == true
end

RegisterNetEvent( "esx_uniquejobs:trackedPlatesUpdated" )
AddEventHandler( "esx_uniquejobs:trackedPlatesUpdated", function( plates )
	local fresh = {}

	if ( plates ~= nil ) then
		for i = 1, #plates do
			fresh[plates[i]] = true
		end
	end

	TrackedPlates = fresh
end )

-- Ask for the current list once on load - the broadcast above only fires on
-- CHANGE, so a fresh client (or resource restart) needs to request the
-- starting state explicitly.
Citizen.CreateThread( function()
	Citizen.Wait( 2000 )

	TriggerServerEvent( "esx_uniquejobs:requestTrackedPlates" )
end )

Citizen.CreateThread( function()
	Citizen.Wait( 1000 ) -- give ESX.getSharedObject a moment to resolve first

	while ( true ) do
		if ( ESX ~= nil and ESX.GetPlayerData ~= nil ) then
			local job = ESX.GetPlayerData().job

			-- Only bother polling if this player's job is one the radar is even
			-- configured to allow (CONFIG.jobs, config.lua) - no point spamming
			-- the callback for jobs that will never get a real answer back.
			if ( job ~= nil and CONFIG.jobs[job.name] ) then
				ESX.TriggerServerCallback( "CrimeScene:getActiveBOLOs", function( list )
					local fresh = {}

					if ( list ~= nil ) then
						for i = 1, #list do
							fresh[list[i].plate] = true
						end
					end

					ActiveBoloPlates = fresh
				end )
			end
		end

		-- 15 seconds is frequent enough to feel live without hammering the
		-- DOJ/CrimeScene callback for every officer running a radar at once
		Citizen.Wait( 15000 )
	end
end )

-- FEATURE ADDED: registered-owner name lookup. The server figures out the
-- owner (see sv_plate_lookup.lua) off the existing "wk:onPlateScanned" hook
-- that cl_plate_reader.lua already fires on every new plate, then replies
-- here with the result.
RegisterNetEvent( "radar:plateOwnerResult" )
AddEventHandler( "radar:plateOwnerResult", function( cam, plate, ownerName )
	-- Guard against a stale/late reply: only apply it if that camera is still
	-- actually showing the same plate the lookup was for (the vehicle in view
	-- may have already changed by the time the DB query comes back).
	if ( READER ~= nil and READER:GetPlate( cam ) == plate ) then
		SendNUIMessage( { _type = "plateOwner", cam = cam, owner = ownerName } )
	end
end )
