

Departments = {
	{ id = 'doj',   label = 'Department Of Justice', jobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' } },
	{ id = 'le',    label = 'Law Enforcement',        jobs = { 'police', 'sheriff', 'mt' } },
	{ id = 'organ', label = 'Organ Services',         jobs = { 'taxi', 'mechanic', 'ambulance', 'weazel' } },
}

function GetDepartmentForJob(job)
	for _, dept in ipairs(Departments) do
		for _, j in ipairs(dept.jobs) do
			if j == job then return dept end
		end
	end
	return nil
end

function GetDepartmentJobSet(job)
	local dept = GetDepartmentForJob(job)
	if not dept then return nil end
	local set = {}
	for _, j in ipairs(dept.jobs) do set[j] = true end
	return set
end
