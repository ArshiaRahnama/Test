-- ============================================================================
-- Unique_LogPanel — پنل لاگ ادمین/باس
-- - ادمین‌ها با کامند /adminlogs همه‌چیز رو می‌بینن (همه‌ی دسته‌ها، همه‌ی شغل‌ها)
-- - باس هر شغل با کامند /myjoblogs یا دکمه‌ای که تو باس‌منوی خودشون وصل کنن
--   فقط لاگ‌های شغل خودشون رو می‌بینن، نه بقیه رو
-- ============================================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================================
-- تنظیمات
-- ============================================================================
Config = Config or {}
Config.AdminPermissionLevel = 5  -- حداقل permission_level برای دسترسی کامل ادمین (مطابق بقیه‌ی پروژه)
Config.LogsPerPage = 50

-- ============================================================================
-- سازمان‌بندی شغل‌ها (همون گروه‌بندی esx_society/config.lua، اینجا هم تکرار
-- شده که Unique_LogPanel وابستگی سختی به اون ریسورس نداشته باشه)
-- ============================================================================
Config.JobGroups = {
	{ id = 'doj',         label = 'Department Of Justice', jobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' } },
	{ id = 'policejob',   label = 'Law Enforcement',        jobs = { 'police', 'sheriff', 'mt' } },
	{ id = 'organserver', label = 'Organ Services',         jobs = { 'taxi', 'mechanic', 'ambulance', 'weazel' } },
}
Config.JobDisplayLabels = {
	cid = 'CID', cia = 'CIA', marshal = 'Marshal', fbi = 'FBI', judge = 'Judge', doa = 'DOA',
	police = 'Police', sheriff = 'Sheriff', mt = 'MT',
	taxi = 'Taxi', mechanic = 'Mechanic', ambulance = 'Medic', weazel = 'Weazel',
}

local function getJobGroup(job)
	for _, group in ipairs(Config.JobGroups) do
		for _, j in ipairs(group.jobs) do
			if j == job then return group.id, group.label end
		end
	end
	return 'other', 'سایر'
end

-- ============================================================================
-- توابع کمکی پرمیشن
-- ============================================================================
local function isAdmin(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end
	return (xPlayer.permission_level or 0) >= Config.AdminPermissionLevel
end

local function isJobBoss(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not xPlayer.job then return false, nil, nil end
	if xPlayer.job.grade_name == 'boss' then
		return true, xPlayer.job.name, xPlayer.job.label
	end
	return false, nil, nil
end

-- ============================================================================
-- گرفتن لاگ‌ها (فیلترشده بر اساس دسترسی)
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:GetLogs', function(source, cb, filters)
	filters = filters or {}

	local admin = isAdmin(source)
	local boss, bossJob = isJobBoss(source)

	if not admin and not boss then
		cb({ error = 'no_access', logs = {}, total = 0 })
		return
	end

	if not MySQL or not MySQL.Async then
		cb({ error = 'no_database', logs = {}, total = 0 })
		return
	end

	local where = {}
	local params = {}

	if not admin then
		-- باس فقط دسترسی به لاگ‌های شغل خودشو داره، حتی اگه فیلتر دیگه‌ای بفرسته
		where[#where + 1] = 'job = @job'
		params['@job'] = bossJob
	elseif filters.job and filters.job ~= 'all' and filters.job ~= '' then
		where[#where + 1] = 'job = @job'
		params['@job'] = tostring(filters.job)
	end

	if filters.category and filters.category ~= 'all' and filters.category ~= '' then
		where[#where + 1] = 'category = @category'
		params['@category'] = tostring(filters.category)
	end

	if filters.search and tostring(filters.search) ~= '' then
		where[#where + 1] = '(message LIKE @search OR player_name LIKE @search OR identifier LIKE @search OR title LIKE @search)'
		params['@search'] = '%' .. tostring(filters.search) .. '%'
	end

	local page = tonumber(filters.page) or 1
	if page < 1 then page = 1 end
	local perPage = Config.LogsPerPage
	local offset = (page - 1) * perPage

	local whereClause = (#where > 0) and ('WHERE ' .. table.concat(where, ' AND ')) or ''

	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM unique_logpanel ' .. whereClause, params, function(total)
		total = total or 0

		local listParams = {}
		for k, v in pairs(params) do listParams[k] = v end
		listParams['@limit']  = perPage
		listParams['@offset'] = offset

		MySQL.Async.fetchAll(
			'SELECT id, category, job, title, message, source, identifier, player_name, created_at FROM unique_logpanel '
			.. whereClause .. ' ORDER BY id DESC LIMIT @limit OFFSET @offset',
			listParams,
			function(result)
				cb({
					logs    = result or {},
					total   = total,
					page    = page,
					perPage = perPage,
					isAdmin = admin,
					job     = bossJob,
				})
			end
		)
	end)
end)

-- ============================================================================
-- گرفتن لیست دسته‌ها/شغل‌های موجود (برای پرکردن تب‌ها)
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:GetMeta', function(source, cb)
	local admin = isAdmin(source)
	local boss, bossJob, bossJobLabel = isJobBoss(source)

	if not admin and not boss then
		cb({ error = 'no_access' })
		return
	end

	if not MySQL or not MySQL.Async then
		cb({ error = 'no_database' })
		return
	end

	if admin then
		MySQL.Async.fetchAll('SELECT DISTINCT category FROM unique_logpanel ORDER BY category ASC', {}, function(cats)
			MySQL.Async.fetchAll('SELECT DISTINCT job FROM unique_logpanel WHERE job IS NOT NULL AND job <> "" ORDER BY job ASC', {}, function(jobs)
				local jobList = {}
				for _, row in ipairs(jobs or {}) do
					local groupId, groupLabel = getJobGroup(row.job)
					jobList[#jobList + 1] = {
						job = row.job,
						label = Config.JobDisplayLabels[row.job] or row.job,
						groupId = groupId,
						groupLabel = groupLabel,
					}
				end
				cb({ categories = cats or {}, jobs = jobList, jobGroups = Config.JobGroups, isAdmin = true })
			end)
		end)
	else
		MySQL.Async.fetchAll('SELECT DISTINCT category FROM unique_logpanel WHERE job = @job ORDER BY category ASC', { ['@job'] = bossJob }, function(cats)
			cb({ categories = cats or {}, jobs = { { job = bossJob, label = bossJobLabel } }, isAdmin = false, job = bossJob, jobLabel = bossJobLabel })
		end)
	end
end)

-- ============================================================================
-- باز کردن پنل: تابع مرکزی مشترک بین کامند و هر جای دیگه‌ای که وصلش کنی
-- ============================================================================
local function OpenAdminPanel(source)
	if isAdmin(source) then
		TriggerClientEvent('LogPanel:client:Open', source, 'admin', nil)
		return true
	end
	TriggerClientEvent('esx:showNotification', source, '~r~Shoma Dastresi Be Panel Kamel Ra Nadarid')
	return false
end

local function OpenBossPanel(source)
	local boss, bossJob, bossJobLabel = isJobBoss(source)
	if boss then
		TriggerClientEvent('LogPanel:client:Open', source, 'boss', bossJob, bossJobLabel)
		return true
	end
	TriggerClientEvent('esx:showNotification', source, '~r~Shoma Boss In Job Nistid')
	return false
end

-- ============================================================================
-- کامندها
-- ============================================================================
RegisterCommand('adminlogs', function(source)
	if source == 0 then return end
	OpenAdminPanel(source)
end, false)

RegisterCommand('myjoblogs', function(source)
	if source == 0 then return end
	OpenBossPanel(source)
end, false)

-- ============================================================================
-- اتصال از بیرون (دکمه‌ی باس‌منوی هر جاب، یا هر ریسورس دیگه)
-- سمت کلاینت: TriggerServerEvent('LogPanel:OpenForJob')
-- سمت سرور (مثلاً از داخل یه callback دکمه‌ی باس‌منو): exports['Unique_LogPanel']:OpenLogPanel(source)
-- ============================================================================
RegisterServerEvent('LogPanel:OpenForJob')
AddEventHandler('LogPanel:OpenForJob', function()
	OpenBossPanel(source)
end)

RegisterServerEvent('LogPanel:OpenAdmin')
AddEventHandler('LogPanel:OpenAdmin', function()
	OpenAdminPanel(source)
end)

exports('OpenLogPanel', OpenBossPanel)
exports('OpenAdminLogPanel', OpenAdminPanel)
exports('IsLogPanelBoss', isJobBoss)
exports('IsLogPanelAdmin', isAdmin)
