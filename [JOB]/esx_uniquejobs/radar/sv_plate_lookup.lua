--[[----------------------------------------------------------------------------------
	FEATURE ADDED: registered-owner name lookup for the plate reader.

	Nothing here touches esx_uniquejobs. It's a plain read against this
	server's own `owned_vehicles` table (joined to `users` for a display name),
	both of which already exist in database.sql - the same tables the
	garage/vehicle-shop scripts already use. This just listens on the
	radar's OWN pre-existing "wk:onPlateScanned" hook (cl_plate_reader.lua
	already fires it on every new plate, it's meant for exactly this kind of
	thing) and replies with the owner's name, if any.
----------------------------------------------------------------------------------]]--

local ESX = nil
Citizen.CreateThread( function()
	TriggerEvent( "esx:getSharedObject", function( obj ) ESX = obj end )
end )

RegisterServerEvent( "wk:onPlateScanned" )
AddEventHandler( "wk:onPlateScanned", function( cam, plate, index )
	local _source = source

	if ( plate == nil or plate == "" or ESX == nil ) then return end

	-- Only law-enforcement jobs should be pulling registration info off a
	-- plate scan - mirrors the same job restriction the radar itself already
	-- enforces (CONFIG.jobs, config.lua) rather than trusting the client.
	local xPlayer = ESX.GetPlayerFromId( _source )

	if ( xPlayer == nil or not CONFIG.jobs[xPlayer.job.name] ) then return end

	MySQL.Async.fetchAll(
		"SELECT owned_vehicles.owner, users.firstname, users.lastname " ..
		"FROM owned_vehicles " ..
		"LEFT JOIN users ON users.identifier = owned_vehicles.owner " ..
		"WHERE owned_vehicles.plate = @plate LIMIT 1",
		{ ["@plate"] = plate },
		function( rows )
			local ownerName = nil

			if ( rows ~= nil and rows[1] ~= nil ) then
				local first = rows[1].firstname
				local last = rows[1].lastname

				if ( first ~= nil or last ~= nil ) then
					ownerName = ( first or "" ) .. " " .. ( last or "" )
				else
					-- Owned, but the account has no name on file (e.g. never
					-- finished character creation) - still worth flagging
					-- that the plate IS registered to someone.
					ownerName = "Unknown Registrant"
				end
			end

			-- nil ownerName just means "not in owned_vehicles at all" - the
			-- client-side handler will simply hide the label in that case.
			TriggerClientEvent( "radar:plateOwnerResult", _source, cam, plate, ownerName )
		end
	)
end )
