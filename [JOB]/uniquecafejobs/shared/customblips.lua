--[[
	Lets a holding's own Boss change the map blip (sprite/colour) of any
	business it owns - same persistence pattern as shared/customnames.lua.
	Blip *position* and *scale* stay fixed in shared/cafes.lua; only the
	icon (sprite) and colour are overridable per business.
]]

-- entity_job -> { sprite = n, colour = n } (nil = still using the cafe's default Blip config)
CustomBlips = {}

function GetDisplaySprite(entityJob, defaultSprite)
	local o = CustomBlips[entityJob]
	return (o and o.sprite) or defaultSprite
end

function GetDisplayColour(entityJob, defaultColour)
	local o = CustomBlips[entityJob]
	return (o and o.colour) or defaultColour
end
