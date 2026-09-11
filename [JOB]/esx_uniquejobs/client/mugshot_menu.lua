-- ============================================================
-- Mugshot -- rebuilt feature (see server/mugshot_manager.lua for
-- why: the old copy referenced in this resource's markdown docs
-- was dead code, no table, no menu wiring, nothing actually ran).
--
-- Convars (all optional, set in server.cfg):
--   mugshot_upload_url    -- your own image-host upload endpoint.
--                             Left empty (the default), photos are
--                             captured and stored directly in the
--                             database as base64 -- no external host,
--                             nothing that can 404 or time out.
--   mugshot_upload_field  -- multipart field name your endpoint
--                             expects, only used if mugshot_upload_url
--                             is set (default 'files[]').
--   mugshot_cam_distance  -- how far in front of the face the camera
--                             sits, in metres (default 0.55).
--   mugshot_cam_fov       -- camera field of view / zoom -- lower is
--                             more zoomed in (default 30.0).
--   mugshot_cam_height    -- head offset from the ped's root, in
--                             metres (default 0.62).
-- ============================================================

local function extractUrlFromUpload(raw)
	if not raw or raw == '' then return nil end

	local ok, decoded = pcall(json.decode, raw)
	if ok and type(decoded) == 'table' then
		if type(decoded.url) == 'string' then return decoded.url end
		if type(decoded.link) == 'string' then return decoded.link end
		if type(decoded.data) == 'table' and type(decoded.data.url) == 'string' then return decoded.data.url end
	end

	-- Most self-hosted mugshot endpoints just echo the final URL back
	-- as plain text -- fall back to that.
	return raw
end

local function resolveTargetPed(query)
	local asId = tonumber(query)
	if not asId then return nil end

	local playerIndex = GetPlayerFromServerId(asId)
	if playerIndex == -1 then return nil end

	local ped = GetPlayerPed(playerIndex)
	if not DoesEntityExist(ped) then return nil end
	return ped
end

local function promptManualUrl(query)
	local input = lib.inputDialog('URL-e Aks (Dasti)', { { type = 'input', label = 'URL', required = true } })
	if input and input[1] then
		TriggerServerEvent('esx_uniquejobs:saveMugshot', query, input[1])
	end
end

-- ============================================================
-- Camera capture -- frames a shot on the citizen's face if they're
-- currently online, then either auto-uploads via screenshot-basic
-- (if configured) or falls back to a manual URL.
-- ============================================================

function TakeMugshotPhoto(query)
	local targetPed = resolveTargetPed(query)

	if not targetPed then
		lib.alertDialog({
			header = 'Mugshot',
			content = 'In Shahrvand Alan Online Nist -- Faghat Vared Kardan-e URL-e Aks (Dasti) Momken Ast.',
			centered = true,
		})
		promptManualUrl(query)
		return
	end

	local myPed = PlayerPedId()
	local camDist = tonumber(GetConvar('mugshot_cam_distance', '0.55')) or 0.55
	local camFov = tonumber(GetConvar('mugshot_cam_fov', '30.0')) or 30.0
	local camHeight = tonumber(GetConvar('mugshot_cam_height', '0.62')) or 0.62

	local headCoords = GetEntityCoords(targetPed) + vector3(0.0, 0.0, camHeight)
	local forward = GetEntityForwardVector(targetPed)
	-- BUG FIX: this used to be `headCoords - (forward * dist)`, which
	-- places the camera BEHIND the target (where their back is) since
	-- `forward` points the way they're facing -- that's why the shot
	-- came out as the back of the neck. The camera needs to sit in
	-- front of them, i.e. further along their own forward vector, then
	-- look back at the head.
	local camCoords = headCoords + (forward * camDist)

	FreezeEntityPosition(targetPed, true)
	FreezeEntityPosition(myPed, true)
	DisplayRadar(false)

	local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camCoords.x, camCoords.y, camCoords.z, 0.0, 0.0, 0.0, camFov, false, 0)
	PointCamAtCoord(cam, headCoords.x, headCoords.y, headCoords.z)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 0, true, true)

	Wait(450)
	PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true) -- shutter click
	Wait(150)

	-- BUG FIX: if screenshot-basic's own upload fetch fails/throws (e.g.
	-- an unreachable or misconfigured mugshot_upload_url), its NUI can
	-- reject the promise instead of calling our Lua callback at all --
	-- previously that meant cleanup() never ran and both peds stayed
	-- frozen with the cam stuck on forever. `handled` + a timeout below
	-- now guarantee cleanup happens exactly once no matter what.
	local handled = false

	local function cleanup()
		if handled then return end
		handled = true
		RenderScriptCams(false, false, 0, true, true)
		DestroyCam(cam, false)
		DisplayRadar(true)
		if DoesEntityExist(targetPed) then FreezeEntityPosition(targetPed, false) end
		FreezeEntityPosition(myPed, false)
	end

	if GetResourceState('screenshot-basic') ~= 'started' then
		cleanup()
		promptManualUrl(query)
		return
	end

	local uploadUrl = GetConvar('mugshot_upload_url', '')

	if uploadUrl ~= '' then
		-- Upload path (only used if you've set mugshot_upload_url)
		local field = GetConvar('mugshot_upload_field', 'files[]')

		CreateThread(function()
			Wait(8000)
			if handled then return end
			cleanup()
			ESX.ShowNotification('~r~Upload-e Aks Timeout Shod (mugshot_upload_url Ra Check Konid) -- URL Dasti')
			promptManualUrl(query)
		end)

		exports['screenshot-basic']:requestScreenshotUpload(uploadUrl, field, function(data)
			if handled then return end -- the 8s timeout above already fired
			cleanup()
			local url = extractUrlFromUpload(data)
			if url and url ~= '' then
				TriggerServerEvent('esx_uniquejobs:saveMugshot', query, url)
			else
				ESX.ShowNotification('~r~Upload-e Aks Shekast Khord -- URL Peida Nashod')
			end
		end)
	else
		-- Default path: no external host needed at all -- capture the
		-- shot as base64 and store it straight in dept_mugshots.photo_url
		-- (MEDIUMTEXT). Same stuck-forever protection via the timeout.
		CreateThread(function()
			Wait(8000)
			if handled then return end
			cleanup()
			ESX.ShowNotification('~r~Gereftan-e Aks Timeout Shod -- URL Dasti')
			promptManualUrl(query)
		end)

		exports['screenshot-basic']:requestScreenshot(function(data)
			if handled then return end
			cleanup()
			if data and data ~= '' then
				TriggerServerEvent('esx_uniquejobs:saveMugshot', query, data)
			else
				ESX.ShowNotification('~r~Gereftan-e Aks Shekast Khord')
			end
		end)
	end
end

-- ============================================================
-- Photo history -- ox_lib shows a thumbnail per row via `image`
-- ============================================================

function OpenMugshotHistory(query)
	ESX.TriggerServerCallback('esx_uniquejobs:getMugshotHistory', function(rows)
		rows = rows or {}
		local options = {}

		if #rows == 0 then
			options[#options + 1] = { title = 'Hich Aksi Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, row in ipairs(rows) do
				local minsAgo = math.floor((GetServerUnixTime() - row.timestamp) / 60)
				options[#options + 1] = {
					title = 'Sabt-Konande: ' .. row.taken_by_name,
					description = minsAgo .. ' Daghighe Pish',
					image = row.photo_url,
					icon = 'camera',
					onSelect = function()
						lib.alertDialog({
							header = 'Mugshot -- ' .. row.taken_by_name,
							content = '![mugshot](' .. row.photo_url .. ')',
							centered = true,
						})
					end,
				}
			end
		end

		lib.registerContext({ id = 'mugshot_history', title = 'Tarikhche-ye Aks-ha', menu = 'mugshot_main', options = options })
		lib.showContext('mugshot_history')
	end, query)
end

-- ============================================================
-- Main entry point -- called from client/law_menu.lua
-- ============================================================

function OpenMugshotMenu()
	local input = lib.inputDialog('Mugshot', { { type = 'input', label = 'ID Ya Esm-e Shahrvand', required = true } })
	if not input or not input[1] then return end
	local query = input[1]

	local options = {
		{
			title = 'Gereftan Aks Jadid (Mugshot Camera)',
			description = 'Agar Shahrvand Online Bashad, Doorbin Mostaghim Rooye Sooratesh Miravad',
			icon = 'camera',
			onSelect = function()
				TakeMugshotPhoto(query)
			end,
		},
		{
			title = 'Rap Sheet + Aks',
			description = 'Sabeghe-ye Kayfari-e Kamel Be Hamrah Akharin Aks-e Sabt-Shode',
			icon = 'file-shield',
			onSelect = function()
				RecordSearchReturnMenu = 'law_main'
				TriggerServerEvent('esx_uniquejobs:menuGetCriminalRecord', query)
			end,
		},
		{
			title = 'Tarikhche-ye Aks-ha',
			description = 'Hame-ye Aks-haye Ghablan Sabt-Shode Baraye In Shahrvand',
			icon = 'images',
			onSelect = function()
				OpenMugshotHistory(query)
			end,
		},
	}

	lib.registerContext({ id = 'mugshot_main', title = 'Mugshot', menu = 'law_main', options = options })
	lib.showContext('mugshot_main')
end
