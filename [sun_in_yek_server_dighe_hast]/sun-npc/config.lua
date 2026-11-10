-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

Config.Key = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

Config.AutoCamPosition = true -- If true it'll set the camera position automatically

Config.AutoCamRotation = true -- If true it'll set the camera rotation automatically

Config.HideMinimap = true -- If true it'll hide the minimap when interacting with an NPC

Config.UseOkokTextUI = true -- If true it'll use okokTextUI 

Config.CameraAnimationTime = 2000 -- Camera animation time: 1000 = 1 second

Config.TalkToNPC = {
	-- {
	-- 	npc = 'u_m_y_abner', 										-- Website too see peds name: https://wiki.rage.mp/index.php?title=Peds
	-- 	thread = true,
	-- 	header = 'جابر هستم', 								-- Text over the name
	-- 	name = '', 										-- Text under the header
	-- 	uiText = "جابر",							-- Name shown on the notification when near the NPC
	-- 	dialog = 'چه کمکی از دست من بر میاد؟',						-- Text showm on the message bubble 
	-- 	coordinates = vector3(254.17, 222.8, 105.3), 				-- coordinates of NPC
	-- 	heading = 160.0,											-- Heading of NPC (needs decimals, 0.0 for example)
	-- 	camOffset = vector3(0.0, 0.0, 0.0), 						-- Camera position relative to NPC 	| (only works if Config.AutoCamPosition = false)
	-- 	camRotation = vector3(0.0, 0.0, 0.0),						-- Camera rotation 					| (only works if Config.AutoCamRotation = false)
	-- 	interactionRange = 2.5, 									-- From how far the player can interact with the NPC
	-- 	options = {													-- Options shown when interacting (Maximum 6 options per NPC)
	-- 		{'Where is the toilet?', 'talk:toilet', 'c'},		-- 'c' for client
	-- 		{'تست',function()
	-- 			print('kos')
	-- 		end}
	-- 	},
	-- 	jobs = {},
	-- },
	--[[
	-- This is the template to create new NPCs
	{
		npc = "",
		header = "",
		name = "",
		uiText = "",
		dialog = "",
		coordinates = vector3(0.0, 0.0, 0.0),
		heading = 0.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 0,
		options = {
			{"", 'client:event', 'c'},
			{"", 'client:event', 'c'},
			{"", 'client:event', 'c'}, 
			{"", 'server:event', 's'}, 
			{"", 'server:event', 's'}, 
			{"", 'server:event', 's'}, 
		},
		jobs = {	-- Example jobs
			'police',
			'ambulance',
		},
	},
	]]--
}