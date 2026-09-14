--[[
	Lets a holding's own Boss rename their holding (instead of the default
	"Holding 1" / "Holding 2"), and lets Meridian rename any business it has
	acquired/partnered with. Both use the same small persistent table.
]]

-- entity_job -> current custom label (nil = still using the default)
CustomNames = {}

function GetDisplayLabel(entityJob, defaultLabel)
	return CustomNames[entityJob] or defaultLabel
end
