-- Drug skills live in Unique_LevelQuest now (its server/drugskill.lua), the one skill system
-- on this server. This file only forwards the calls, safely.
function SafeUpdateSkill(source, skill, amount)
	if not skill or not amount or amount == 0 then return end
	local ok, err = pcall(function()
		exports['Unique_LevelQuest']:AddDrugSkill(source, skill, amount)
	end)
	if not ok then print(('[esx_drugs] Unique_LevelQuest:AddDrugSkill failed (%s)'):format(tostring(err))) end
end
