

Departments = {
	{ id = 'doj',   label = 'Department Of Justice', jobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' } },
	{ id = 'le',    label = 'Law Enforcement',        jobs = { 'police', 'sheriff', 'mt' } },
	{ id = 'organ', label = 'Organ Services',         jobs = { 'taxi', 'mechanic', 'ambulance', 'weazel' } },
}

-- FEATURE ADDED: fbi/cia are the two jobs treated as "agents" in a couple of
-- places (esx_uniquejobs' own server/tracker_manager.lua restricts placing a
-- GPS tracker to these two, and radar/config.lua gates its "PLACE TRACKER"
-- button the same way) - kept here as the one shared definition so both stay
-- in sync automatically instead of two separate hardcoded copies.
AgentJobs = { fbi = true, cia = true }

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

-- FEATURE ADDED: same as GetDepartmentJobSet() above but looked up by
-- department id ('doj'/'le'/'organ') instead of by one of its member jobs -
-- more convenient for building a job-set out of one or more whole
-- departments (e.g. radar/config.lua's CONFIG.jobs).
function GetDepartmentById(id)
	for _, dept in ipairs(Departments) do
		if dept.id == id then return dept end
	end
	return nil
end

function GetJobSetForDepartment(id)
	local dept = GetDepartmentById(id)
	if not dept then return nil end
	local set = {}
	for _, j in ipairs(dept.jobs) do set[j] = true end
	return set
end

-- Exported so other resources (e.g. esx_drugs' on-duty restriction check) can ask "is this job
-- part of any department?" without keeping their own separate hardcoded copy of the job list in
-- sync by hand. Shared script, so this registers on whichever side loads it; esx_drugs only
-- calls it server-side.
exports('GetDepartmentForJob', GetDepartmentForJob)
