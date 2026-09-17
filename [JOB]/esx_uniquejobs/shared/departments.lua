

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

-- FEATURE ADDED (government-job consolidation pass): before this, "is this
-- job DOJ?" / "is this job LE?" / "is this job government at all?" was
-- hand-copied as its own local table or inline job.name==...or... chain in
-- ~20 different places across client/, server/, and cad/ -- e.g.
-- `local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true,
-- fbi = true, doa = true }` verbatim in 10 separate files. Two copies had
-- already drifted apart (server/marshal_main.lua's own
-- esx_marshaljob:requestrelease check was missing cid/judge/doa that the
-- near-identical server/police_main.lua copy had), and several also carried
-- a dead 'forces' job name that hasn't existed since this resource's jobs
-- were renamed. Cached here ONCE from the single Departments table above --
-- every file below now just reads these instead of re-hardcoding them, so
-- adding/removing a department job here updates every one of them
-- automatically and they can't drift apart again.
-- BUG FIX: this whole block (through the exports 3 lines below) used to sit
-- ABOVE GetDepartmentById/GetJobSetForDepartment's own definitions further
-- down this same file. Since Lua runs a file top-to-bottom, calling
-- GetJobSetForDepartment('doj') here executed before that function existed
-- yet -- crashed this entire file at load, which meant NOTHING below this
-- point ever ran either (not the exports() calls, nothing) -- cascading into
-- every other file that depends on any of this (cad/config_crimescene.lua,
-- radar/config.lua, every client/teleport_*.lua, client/doj_menu.lua, etc.)
-- also erroring "attempt to call/index a nil value" at startup. Moved below
-- the functions it calls so it actually has them available when it runs.
DojJobSet = GetJobSetForDepartment('doj')
LeJobSet = GetJobSetForDepartment('le')
GovernmentJobSet = {}
for j in pairs(DojJobSet) do GovernmentJobSet[j] = true end
for j in pairs(LeJobSet) do GovernmentJobSet[j] = true end

function IsDojJob(jobName) return DojJobSet[jobName] == true end
function IsLeJob(jobName) return LeJobSet[jobName] == true end
function IsGovernmentJob(jobName) return GovernmentJobSet[jobName] == true end

-- LE (police/sheriff/mt) plus the two DOJ jobs that also respond to
-- robberies/pursuits in the field (fbi, marshal) -- was two independently
-- hardcoded copies of this exact table before (client/rob_manager.lua,
-- server/rob_manager.lua).
ResponderJobs = { fbi = true, marshal = true }
for j in pairs(LeJobSet) do ResponderJobs[j] = true end

exports('IsDojJob', IsDojJob)
exports('IsLeJob', IsLeJob)
exports('IsGovernmentJob', IsGovernmentJob)
