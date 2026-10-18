-- Client side of the drug skills. Values are owned by Unique_LevelQuest and cached here.
DrugSkillCache = {}

function DrugSkillValue(skill)
	return DrugSkillCache[skill] or 0
end

RegisterNetEvent('Drug-Skill:Sync')
AddEventHandler('Drug-Skill:Sync', function(skill, value)
	DrugSkillCache[skill] = tonumber(value) or 0
end)

CreateThread(function()
	while ESX == nil do Wait(200) end
	Wait(3000)
	ESX.TriggerServerCallback('Drug-Skill:GetAll', function(t)
		for k, v in pairs(t or {}) do DrugSkillCache[k] = v end
	end)
end)
