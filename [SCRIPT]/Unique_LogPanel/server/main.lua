-- ============================================================================
-- Unique_LogPanel — پنل لاگ ادمین/باس  (نسخه‌ی گسترش‌یافته)
-- - ادمین‌ها با /adminlogs همه‌چیز رو می‌بینن (همه‌ی دسته‌ها، همه‌ی شغل‌ها، آمار، خروجی، حذف)
-- - باس هر شغل با /myjoblogs یا دکمه‌ای که به باس‌منوی خودشون وصل کنن، فقط لاگ شغل خودشونو می‌بینه
-- - لایو‌آپدیت: وقتی پنل بازه، به‌محض ثبت لاگ جدید، بدون رفرش دستی خبردار می‌شه
-- ============================================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================================
-- تنظیمات
-- ============================================================================
Config = Config or {}

Config.AdminPermissionLevel = 5      -- حداقل permission_level (ESX) برای دسترسی کامل ادمین

-- روش دوم دسترسی ادمین: از طریق ACE Permission (اختیاری، مستقل از permission_level ESX)
-- مفیده وقتی می‌خوای بدون دست‌زدن به دیتابیس ادمین، یه گروه جدا برای پنل بدی.
Config.UseAceAdmin  = false
Config.AceAdminGroup = 'logpanel.admin'   -- add_ace group.logpanel.admin logpanel.access allow

-- اسم گرید(های) باس که اجازه‌ی دیدن لاگ شغل خودشونو دارن (بعضی سرورا 'owner' یا 'lead' هم دارن)
Config.BossGradeNames = { 'boss' }

-- صفحه‌بندی
Config.LogsPerPage    = 50          -- مقدار پیش‌فرض
Config.PerPageOptions = { 25, 50, 100, 200 }  -- گزینه‌های قابل‌انتخاب تو پنل

-- پاک‌سازی خودکار لاگ‌های قدیمی (روز). صفر یا false یعنی غیرفعال.
Config.RetentionDays = 30

-- محافظت از لاگ‌های مهم در برابر پاک‌سازی خودکار (پاک‌سازی دستی توسط ادمین همیشه
-- ممکنه، این دو تا فقط جلوی حذف *خودکار* رو می‌گیرن):
Config.RetentionExemptJobLogs = true  -- true = لاگ‌های ارگان‌ها/شغل‌ها (هر لاگی که فیلد job پر داره —
                                       -- پلیس، آمبولانس، تاکسی، مکانیک، CID، قاضی و بقیه) هیچ‌وقت با
                                       -- پاک‌سازی خودکار حذف نشن، فقط لاگ‌های عمومی (چت، اتصال، ادمین‌منو
                                       -- و هر چیزی که به شغل خاصی مربوط نیست) بعد از RetentionDays پاک بشن.
Config.RetentionExemptPinned  = true  -- true = لاگ‌های پین‌شده هم هیچ‌وقت با پاک‌سازی خودکار حذف نشن

-- امکانات اضافه
Config.EnableExport      = true     -- خروجی CSV (ادمین کامل، باس فقط شغل خودش)
Config.EnableDelete      = true     -- حذف تک‌لاگ توسط ادمین (با ثبت رخداد حذف)
Config.EnablePinning     = true     -- پین‌کردن لاگ‌های مهم توسط ادمین (همیشه بالای لیست)
Config.EnableLiveUpdates = true     -- اطلاع‌رسانی زنده‌ی لاگ جدید وقتی پنل بازه
Config.LiveUpdateIntervalMs = 4000  -- هر چند وقت یه‌بار چک کنه لاگ جدید اومده یا نه
Config.MaxExportRows     = 5000     -- سقف تعداد ردیف قابل‌خروجی در یک درخواست
Config.MaxSearchLength   = 100

-- ============================================================================
-- سازمان‌بندی شغل‌ها (گروه‌بندی همون esx_society/config.lua)
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

-- ستون‌های مجاز برای مرتب‌سازی (وایت‌لیست، برای جلوگیری از SQL injection روی ORDER BY)
local SORTABLE_COLUMNS = {
	id         = 'id',
	created_at = 'created_at',
	category   = 'category',
	job        = 'job',
	player_name = 'player_name',
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
	if Config.UseAceAdmin and IsPlayerAceAllowed(source, Config.AceAdminGroup) then
		return true
	end
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end
	return (xPlayer.permission_level or 0) >= Config.AdminPermissionLevel
end

local function isBossGrade(gradeName)
	for _, g in ipairs(Config.BossGradeNames) do
		if g == gradeName then return true end
	end
	return false
end

local function isJobBoss(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not xPlayer.job then return false, nil, nil end
	if isBossGrade(xPlayer.job.grade_name) then
		return true, xPlayer.job.name, xPlayer.job.label
	end
	return false, nil, nil
end

-- ============================================================================
-- امن‌سازی ورودی سرچ برای LIKE (escape کردن % و _ که تو LIKE معنای خاص دارن)
-- ============================================================================
local function escapeLike(str)
	str = tostring(str)
	if #str > Config.MaxSearchLength then str = str:sub(1, Config.MaxSearchLength) end
	return (str:gsub('([%%_\\])', '\\%1'))
end

-- ============================================================================
-- ردیابی سشن‌های بازِ پنل (برای لایو‌آپدیت لاگ جدید)
-- openSessions[source] = { mode = 'admin'|'boss', job = 'police'|nil }
-- ============================================================================
local openSessions = {}

local function trackSessionOpen(source, mode, job)
	openSessions[source] = { mode = mode, job = job }
end
local function trackSessionClose(source)
	openSessions[source] = nil
end

AddEventHandler('playerDropped', function()
	trackSessionClose(source)
end)

-- ============================================================================
-- ساخت شرط WHERE مشترک برای GetLogs / GetStats / ExportLogs
-- ============================================================================
local function buildWhere(source, filters, admin, bossJob)
	filters = filters or {}
	local where, params = {}, {}

	if not admin then
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
		where[#where + 1] = "(message LIKE @search ESCAPE '\\\\' OR player_name LIKE @search ESCAPE '\\\\' OR identifier LIKE @search ESCAPE '\\\\' OR title LIKE @search ESCAPE '\\\\')"
		params['@search'] = '%' .. escapeLike(filters.search) .. '%'
	end

	-- فیلتر بازه‌ی تاریخ (YYYY-MM-DD)
	if filters.dateFrom and tostring(filters.dateFrom) ~= '' then
		where[#where + 1] = 'created_at >= @dateFrom'
		params['@dateFrom'] = tostring(filters.dateFrom) .. ' 00:00:00'
	end
	if filters.dateTo and tostring(filters.dateTo) ~= '' then
		where[#where + 1] = 'created_at <= @dateTo'
		params['@dateTo'] = tostring(filters.dateTo) .. ' 23:59:59'
	end

	-- فیلتر دقیق پلیر (drill-down از کلیک روی اسم پلیر تو UI) — بر خلاف "search" که فازی‌ه،
	-- این دقیقاً همون identifier رو می‌خواد
	if filters.identifierExact and tostring(filters.identifierExact) ~= '' then
		where[#where + 1] = 'identifier = @identifierExact'
		params['@identifierExact'] = tostring(filters.identifierExact)
	end

	-- فقط لاگ‌های پین‌شده
	if filters.pinnedOnly then
		where[#where + 1] = 'pinned = 1'
	end

	local whereClause = (#where > 0) and ('WHERE ' .. table.concat(where, ' AND ')) or ''
	return whereClause, params
end

-- ============================================================================
-- گرفتن لاگ‌ها (فیلترشده بر اساس دسترسی + مرتب‌سازی + صفحه‌بندی)
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

	local whereClause, params = buildWhere(source, filters, admin, bossJob)

	-- مرتب‌سازی امن (وایت‌لیست‌شده)
	local sortCol = SORTABLE_COLUMNS[filters.sortBy] or 'id'
	local sortDir = (tostring(filters.sortDir or ''):upper() == 'ASC') and 'ASC' or 'DESC'

	-- صفحه‌بندی امن
	local perPage = tonumber(filters.perPage) or Config.LogsPerPage
	local validPerPage = false
	for _, v in ipairs(Config.PerPageOptions) do if v == perPage then validPerPage = true end end
	if not validPerPage then perPage = Config.LogsPerPage end

	local page = tonumber(filters.page) or 1
	if page < 1 then page = 1 end
	local offset = (page - 1) * perPage

	local function fetchRows(total)
		local listParams = {}
		for k, v in pairs(params) do listParams[k] = v end
		listParams['@limit']  = perPage
		listParams['@offset'] = offset

		MySQL.Async.fetchAll(
			'SELECT id, category, job, title, message, source, identifier, player_name, pinned, created_at FROM unique_logpanel '
			.. whereClause .. ' ORDER BY pinned DESC, ' .. sortCol .. ' ' .. sortDir .. ' LIMIT @limit OFFSET @offset',
			listParams,
			function(result)
				-- ثبت این سشن به‌عنوان «پنل باز» برای لایو‌آپدیت
				if Config.EnableLiveUpdates then
					trackSessionOpen(source, admin and 'admin' or 'boss', admin and (filters.job ~= 'all' and filters.job or nil) or bossJob)
				end

				cb({
					logs        = result or {},
					total       = total, -- nil یعنی «تغییری نکرده، همون قبلی رو نگه دار» (پایین توضیح داده شده)
					page        = page,
					perPage     = perPage,
					perPageOpts = Config.PerPageOptions,
					isAdmin     = admin,
					job         = bossJob,
					canExport   = Config.EnableExport,
					canDelete   = Config.EnableDelete and admin,
					canPin      = Config.EnablePinning and admin,
				})
			end
		)
	end

	-- بهینه‌سازی مهم رو جدول‌های بزرگ: COUNT(*) فقط وقتی واقعاً لازمه اجرا بشه.
	-- تغییر صفحه یا مرتب‌سازی، تعداد کل نتایج مطابق فیلتر رو عوض نمی‌کنه؛ فقط وقتی
	-- خودِ فیلترها (دسته/شغل/سرچ/تاریخ/...) عوض شده باشن، کلاینت needCount=true
	-- می‌فرسته و شمارش دوباره انجام می‌شه. این‌جوری با هر کلیک next/prev یا عوض‌کردن
	-- مرتب‌سازی، یه اسکن سنگین COUNT روی کل جدول اجرا نمی‌شه.
	if filters.needCount == false then
		fetchRows(nil)
	else
		MySQL.Async.fetchScalar('SELECT COUNT(*) FROM unique_logpanel ' .. whereClause, params, function(total)
			fetchRows(total or 0)
		end)
	end
end)

-- ============================================================================
-- گرفتن لیست دسته‌ها/شغل‌ها (برای تب‌ها) + گزینه‌های صفحه‌بندی
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

	local base = {
		perPageOptions = Config.PerPageOptions,
		defaultPerPage = Config.LogsPerPage,
		canExport      = Config.EnableExport,
		canDelete      = Config.EnableDelete and admin,
		canPin         = Config.EnablePinning and admin,
		retentionDays  = Config.RetentionDays,
	}

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
				base.categories = cats or {}
				base.jobs       = jobList
				base.jobGroups  = Config.JobGroups
				base.isAdmin    = true
				cb(base)
			end)
		end)
	else
		MySQL.Async.fetchAll('SELECT DISTINCT category FROM unique_logpanel WHERE job = @job ORDER BY category ASC', { ['@job'] = bossJob }, function(cats)
			base.categories = cats or {}
			base.jobs       = { { job = bossJob, label = bossJobLabel } }
			base.isAdmin    = false
			base.job        = bossJob
			base.jobLabel   = bossJobLabel
			cb(base)
		end)
	end
end)

-- ============================================================================
-- آمار (Dashboard) — کل لاگ‌ها، لاگ‌های امروز، پرتکرارترین دسته‌ها/شغل‌ها
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:GetStats', function(source, cb, filters)
	local admin = isAdmin(source)
	local boss, bossJob = isJobBoss(source)

	if not admin and not boss then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local whereClause, params = buildWhere(source, filters or {}, admin, bossJob)
	local andOr = (whereClause == '') and 'WHERE' or (whereClause .. ' AND')

	-- برای نمودار روند، فیلتر تاریخِ کاربر رو نادیده می‌گیریم و همیشه ۱۴ روز اخیر رو نشون می‌دیم
	-- (ولی دسته/شغل/سرچ رو حفظ می‌کنیم)، چون هدف این نموداره که "روند اخیر" رو مستقل از بازه‌ی
	-- انتخابی کاربر نشون بده.
	local trendFilters = {}
	for k, v in pairs(filters or {}) do trendFilters[k] = v end
	trendFilters.dateFrom = nil
	trendFilters.dateTo = nil
	local trendWhere, trendParams = buildWhere(source, trendFilters, admin, bossJob)
	local trendAndOr = (trendWhere == '') and 'WHERE' or (trendWhere .. ' AND')
	trendParams['@trendDays'] = 13

	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM unique_logpanel ' .. whereClause, params, function(total)
		MySQL.Async.fetchScalar(
			'SELECT COUNT(*) FROM unique_logpanel ' .. andOr .. ' created_at >= CURDATE()',
			params, function(today)
				MySQL.Async.fetchAll(
					'SELECT category, COUNT(*) as cnt FROM unique_logpanel ' .. whereClause ..
					' GROUP BY category ORDER BY cnt DESC LIMIT 6', params, function(topCats)
						MySQL.Async.fetchAll(
							"SELECT DATE(created_at) as d, COUNT(*) as cnt FROM unique_logpanel " .. trendAndOr ..
							' created_at >= CURDATE() - INTERVAL @trendDays DAY GROUP BY DATE(created_at) ORDER BY d ASC',
							trendParams, function(dailyRows)
								local playerFilterPart = "player_name IS NOT NULL AND player_name <> ''"
								local playerWhere = (whereClause == '')
									and ('WHERE ' .. playerFilterPart)
									or (whereClause .. ' AND ' .. playerFilterPart)
								MySQL.Async.fetchAll(
									'SELECT player_name, identifier, COUNT(*) as cnt FROM unique_logpanel ' .. playerWhere ..
									' GROUP BY identifier, player_name ORDER BY cnt DESC LIMIT 6',
									params, function(topPlayers)
										local function finish(topJobs)
											cb({
												total       = total or 0,
												today       = today or 0,
												topCategories = topCats or {},
												topJobs     = topJobs or {},
												topPlayers  = topPlayers or {},
												dailyActivity = dailyRows or {},
											})
										end
										if admin then
											local jobFilterPart = "job IS NOT NULL AND job <> ''"
											local jobWhere = (whereClause == '')
												and ('WHERE ' .. jobFilterPart)
												or (whereClause .. ' AND ' .. jobFilterPart)
											MySQL.Async.fetchAll(
												'SELECT job, COUNT(*) as cnt FROM unique_logpanel ' .. jobWhere ..
												' GROUP BY job ORDER BY cnt DESC LIMIT 6',
												params, finish)
										else
											finish({})
										end
									end)
							end)
					end)
			end)
	end)
end)

-- ============================================================================
-- خروجی CSV (با همون فیلترهای فعلی، بدون صفحه‌بندی، تا سقف MaxExportRows)
-- ============================================================================
local function csvEscape(v)
	v = tostring(v or '')
	v = v:gsub('"', '""')
	return '"' .. v .. '"'
end

-- oxmysql (بسته به تنظیماتش) ستون DATETIME رو به‌جای رشته، به‌صورت عدد epoch
-- (میلی‌ثانیه یا ثانیه) به Lua برمی‌گردونه؛ این تابع همیشه یه رشته‌ی خوانا تحویل می‌ده.
local function formatDateValue(v)
	if type(v) == 'number' then
		local seconds = (v > 1e12) and (v / 1000) or v
		return os.date('%Y-%m-%d %H:%M:%S', math.floor(seconds))
	end
	return v
end

ESX.RegisterServerCallback('LogPanel:ExportLogs', function(source, cb, filters)
	if not Config.EnableExport then cb({ error = 'disabled' }) return end

	local admin = isAdmin(source)
	local boss, bossJob = isJobBoss(source)
	if not admin and not boss then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local whereClause, params = buildWhere(source, filters or {}, admin, bossJob)
	params['@limit'] = Config.MaxExportRows

	MySQL.Async.fetchAll(
		'SELECT id, category, job, title, message, source, identifier, player_name, pinned, created_at FROM unique_logpanel '
		.. whereClause .. ' ORDER BY pinned DESC, id DESC LIMIT @limit', params, function(rows)
			rows = rows or {}
			local lines = { 'id,created_at,category,job,player_name,identifier,source,title,message,pinned' }
			for _, r in ipairs(rows) do
				lines[#lines + 1] = table.concat({
					csvEscape(r.id), csvEscape(formatDateValue(r.created_at)), csvEscape(r.category), csvEscape(r.job),
					csvEscape(r.player_name), csvEscape(r.identifier), csvEscape(r.source),
					csvEscape(r.title), csvEscape((r.message or ''):gsub('\n', ' ')),
					csvEscape((tonumber(r.pinned) == 1) and 'yes' or 'no')
				}, ',')
			end
			cb({ csv = table.concat(lines, '\n'), count = #rows })
		end)
end)

-- ============================================================================
-- پین/آن‌پین کردن یه لاگ (فقط ادمین) — لاگ‌های پین‌شده همیشه بالای لیست می‌مونن
-- ============================================================================

-- oxmysql بسته به نسخه/تنظیماتش، ستون TINYINT(1) رو گاهی به‌صورت boolean (true/false)
-- به Lua برمی‌گردونه، نه عدد. tonumber(true) در Lua مقدار nil می‌ده (نه خطا)، پس اگه
-- مستقیم از tonumber() استفاده می‌کردیم، چک "current == 1" همیشه false می‌شد و پین
-- هیچ‌وقت درست toggle نمی‌شد (همیشه می‌رفت رو 1). این تابع هر سه حالت boolean/عدد/رشته
-- رو درست به 0 یا 1 تبدیل می‌کنه.
local function toBit(v)
	if v == true then return 1 end
	if v == false or v == nil then return 0 end
	return (tonumber(v) == 1) and 1 or 0
end

-- برای اکشن‌های گروهی (پین/حذف چندتایی): از یه لیست عدد Lua، یه IN (@id1,@id2,...) امن
-- (پارامتری، نه string concat مستقیم) می‌سازه.
local function buildIdInClause(ids)
	local placeholders, params = {}, {}
	for i, id in ipairs(ids) do
		local key = '@bid' .. i
		placeholders[#placeholders + 1] = key
		params[key] = id
	end
	return table.concat(placeholders, ', '), params
end
local function sanitizeIdList(raw, maxCount)
	local ids = {}
	for _, v in ipairs(raw or {}) do
		local n = tonumber(v)
		if n then ids[#ids + 1] = n end
		if #ids >= maxCount then break end
	end
	return ids
end

ESX.RegisterServerCallback('LogPanel:TogglePin', function(source, cb, data)
	if not Config.EnablePinning then cb({ error = 'disabled' }) return end
	if not isAdmin(source) then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local id = tonumber(data and data.id)
	if not id then cb({ error = 'invalid_id' }) return end

	MySQL.Async.fetchScalar('SELECT pinned FROM unique_logpanel WHERE id = @id', { ['@id'] = id }, function(current)
		if current == nil then cb({ error = 'not_found' }) return end
		local newValue = (toBit(current) == 1) and 0 or 1

		MySQL.Async.execute('UPDATE unique_logpanel SET pinned = @pinned WHERE id = @id', { ['@pinned'] = newValue, ['@id'] = id }, function(affected)
			if affected and affected > 0 then
				cb({ success = true, pinned = (newValue == 1) })
			else
				cb({ error = 'update_failed' })
			end
		end)
	end)
end)

-- ============================================================================
-- حذف یه لاگ (فقط ادمین) — با ثبت رخداد حذف برای شفافیت (audit trail)
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:DeleteLog', function(source, cb, data)
	if not Config.EnableDelete then cb({ error = 'disabled' }) return end
	if not isAdmin(source) then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local id = tonumber(data and data.id)
	if not id then cb({ error = 'invalid_id' }) return end

	local xPlayer = ESX.GetPlayerFromId(source)
	local adminName = xPlayer and xPlayer.getName and xPlayer.getName() or ('ID:' .. source)
	local adminIdentifier = xPlayer and xPlayer.identifier or nil

	MySQL.Async.fetchAll('SELECT * FROM unique_logpanel WHERE id = @id', { ['@id'] = id }, function(rows)
		if not rows or not rows[1] then cb({ error = 'not_found' }) return end
		local row = rows[1]

		MySQL.Async.execute('DELETE FROM unique_logpanel WHERE id = @id', { ['@id'] = id }, function(affected)
			if affected and affected > 0 then
				MySQL.Async.execute(
					'INSERT INTO unique_logpanel (category, job, title, message, source, identifier, player_name) VALUES (@c, @j, @t, @m, @s, @i, @p)',
					{
						['@c'] = 'logpanel_delete',
						['@j'] = row.job,
						['@t'] = 'حذف لاگ توسط ادمین',
						['@m'] = string.format('لاگ #%d (دسته: %s) توسط %s حذف شد.\nپیام اصلی:\n%s', id, tostring(row.category), adminName, tostring(row.message)),
						['@s'] = source,
						['@i'] = adminIdentifier,
						['@p'] = adminName,
					}
				)
				cb({ success = true })
			else
				cb({ error = 'delete_failed' })
			end
		end)
	end)
end)

-- ============================================================================
-- حذف گروهی (چندتا لاگ با هم، فقط ادمین) — برای وقتی چندتا ردیف رو تیک زده و
-- می‌خواد یه‌جا پاک‌شون کنه. حداکثر ۲۰۰ تا در هر درخواست (محافظتی، نه محدودیت UI).
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:BulkDelete', function(source, cb, data)
	if not Config.EnableDelete then cb({ error = 'disabled' }) return end
	if not isAdmin(source) then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local ids = sanitizeIdList(data and data.ids, 200)
	if #ids == 0 then cb({ error = 'invalid_ids' }) return end

	local inClause, params = buildIdInClause(ids)
	local xPlayer = ESX.GetPlayerFromId(source)
	local adminName = xPlayer and xPlayer.getName and xPlayer.getName() or ('ID:' .. source)
	local adminIdentifier = xPlayer and xPlayer.identifier or nil

	MySQL.Async.execute('DELETE FROM unique_logpanel WHERE id IN (' .. inClause .. ')', params, function(affected)
		affected = affected or 0
		if affected > 0 then
			local idListStr = table.concat(ids, ', ')
			if #idListStr > 300 then idListStr = idListStr:sub(1, 300) .. '...' end
			MySQL.Async.execute(
				'INSERT INTO unique_logpanel (category, job, title, message, source, identifier, player_name) VALUES (@c, @j, @t, @m, @s, @i, @p)',
				{
					['@c'] = 'logpanel_delete',
					['@j'] = nil,
					['@t'] = 'حذف گروهی لاگ توسط ادمین',
					['@m'] = string.format('%d لاگ به‌صورت گروهی توسط %s حذف شد.\nشناسه‌ها: %s', affected, adminName, idListStr),
					['@s'] = source,
					['@i'] = adminIdentifier,
					['@p'] = adminName,
				}
			)
			cb({ success = true, count = affected })
		else
			cb({ error = 'delete_failed' })
		end
	end)
end)

-- ============================================================================
-- پین/آن‌پین گروهی (چندتا لاگ با هم، فقط ادمین)
-- ============================================================================
ESX.RegisterServerCallback('LogPanel:BulkPin', function(source, cb, data)
	if not Config.EnablePinning then cb({ error = 'disabled' }) return end
	if not isAdmin(source) then cb({ error = 'no_access' }) return end
	if not MySQL or not MySQL.Async then cb({ error = 'no_database' }) return end

	local ids = sanitizeIdList(data and data.ids, 200)
	if #ids == 0 then cb({ error = 'invalid_ids' }) return end

	local pinnedValue = (data and data.pinned == false) and 0 or 1
	local inClause, params = buildIdInClause(ids)
	params['@pinned'] = pinnedValue

	MySQL.Async.execute('UPDATE unique_logpanel SET pinned = @pinned WHERE id IN (' .. inClause .. ')', params, function(affected)
		cb({ success = true, count = affected or 0, pinned = (pinnedValue == 1) })
	end)
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

RegisterCommand('joblogs', function(source)
	if source == 0 then return end
	OpenBossPanel(source)
end, false)
-- توجه: عمداً «joblogs» نه «myjoblogs» — چون نسخه‌ی قبلی روی «myjoblogs» یه کیبایند
-- پیش‌فرض F9 ثبت کرده بود و کنسول‌کامند unbind تو پروداکشن FiveM غیرفعاله، پس تنها
-- راه تضمینی برای بی‌اثر کردن اون بایند قدیمی، عوض‌کردن اسم خودِ کامنده (توضیح کامل
-- تو client/main.lua هست).

-- ============================================================================
-- اتصال از بیرون (دکمه‌ی باس‌منوی هر جاب، یا هر ریسورس دیگه)
-- ============================================================================
RegisterServerEvent('LogPanel:OpenForJob')
AddEventHandler('LogPanel:OpenForJob', function()
	OpenBossPanel(source)
end)

RegisterServerEvent('LogPanel:OpenAdmin')
AddEventHandler('LogPanel:OpenAdmin', function()
	OpenAdminPanel(source)
end)

-- کلاینت به سرور اطلاع میده پنلش بسته شده (برای قطع لایو‌آپدیت)
RegisterServerEvent('LogPanel:PanelClosed')
AddEventHandler('LogPanel:PanelClosed', function()
	trackSessionClose(source)
end)

exports('OpenLogPanel', OpenBossPanel)
exports('OpenAdminLogPanel', OpenAdminPanel)
exports('IsLogPanelBoss', isJobBoss)
exports('IsLogPanelAdmin', isAdmin)

-- ============================================================================
-- لایو‌آپدیت: هر چند ثانیه یه‌بار چک می‌کنه آیا لاگ جدیدی اومده، و فقط به
-- کسایی که الان پنل‌شون بازه (و دسترسی دارن) خبر میده — بدون نیاز به رفرش دستی
-- ============================================================================
if Config.EnableLiveUpdates then
	CreateThread(function()
		if not MySQL or not MySQL.Async then return end
		local lastMaxId = 0

		-- مقداردهی اولیه‌ی lastMaxId موقع استارت ریسورس، تا اولین چک یه پیام کاذب نفرسته
		while not MySQL or not MySQL.Async do Wait(500) end
		MySQL.Async.fetchScalar('SELECT MAX(id) FROM unique_logpanel', {}, function(v)
			lastMaxId = tonumber(v) or 0
		end)

		while true do
			Wait(Config.LiveUpdateIntervalMs)

			local hasSessions = false
			for _ in pairs(openSessions) do hasSessions = true break end
			if hasSessions then
				MySQL.Async.fetchAll('SELECT id, job FROM unique_logpanel WHERE id > @id ORDER BY id ASC LIMIT 200', { ['@id'] = lastMaxId }, function(rows)
					if rows and #rows > 0 then
						local newMax = lastMaxId
						local countByJob = {}   -- ['police'] = 3
						local totalCount = 0
						for _, r in ipairs(rows) do
							if r.id > newMax then newMax = r.id end
							totalCount = totalCount + 1
							if r.job then
								countByJob[r.job] = (countByJob[r.job] or 0) + 1
							end
						end
						lastMaxId = newMax

						for src, session in pairs(openSessions) do
							if GetPlayerName(src) then
								if session.mode == 'admin' then
									TriggerClientEvent('LogPanel:client:NewLogs', src, totalCount)
								elseif session.job then
									local c = countByJob[session.job] or 0
									if c > 0 then
										TriggerClientEvent('LogPanel:client:NewLogs', src, c)
									end
								end
							else
								openSessions[src] = nil
							end
						end
					end
				end)
			end
		end
	end)
end

-- ============================================================================
-- پاک‌سازی خودکار لاگ‌های قدیمی (Config.RetentionDays)، به‌صورت دسته‌ای (batch) تا
-- روی جدول‌های بزرگ یه DELETE عظیم و طولانی، جدول رو برای بقیه (کوئری‌های دیگه‌ی
-- پنل) قفل نکنه. هر بار حداکثر ۲۰۰۰ ردیف حذف می‌شه و بین بچ‌ها یه مکث کوتاه هست.
-- لاگ‌های ارگان/شغل (اگه Config.RetentionExemptJobLogs فعال باشه، که پیش‌فرض هست)
-- و لاگ‌های پین‌شده (اگه Config.RetentionExemptPinned فعال باشه) از این پاک‌سازی
-- خودکار معاف می‌مونن — فقط ادمین می‌تونه دستی حذف‌شون کنه.
-- ============================================================================
if Config.RetentionDays and tonumber(Config.RetentionDays) and tonumber(Config.RetentionDays) > 0 then
	CreateThread(function()
		while not MySQL or not MySQL.Async do Wait(1000) end
		local BATCH_SIZE = 2000

		local exemptConditions = { 'category <> "logpanel_delete"' }
		if Config.RetentionExemptJobLogs then
			exemptConditions[#exemptConditions + 1] = "(job IS NULL OR job = '')"
		end
		if Config.RetentionExemptPinned then
			exemptConditions[#exemptConditions + 1] = '(pinned IS NULL OR pinned = 0)'
		end
		local exemptClause = table.concat(exemptConditions, ' AND ')

		while true do
			local totalDeleted = 0
			while true do
				local done, affected = false, 0
				MySQL.Async.execute(
					'DELETE FROM unique_logpanel WHERE created_at < NOW() - INTERVAL @days DAY AND ' .. exemptClause .. ' LIMIT @batch',
					{ ['@days'] = tonumber(Config.RetentionDays), ['@batch'] = BATCH_SIZE },
					function(aff)
						affected = aff or 0
						done = true
					end
				)
				while not done do Wait(50) end
				totalDeleted = totalDeleted + affected
				if affected < BATCH_SIZE then break end
				Wait(400) -- مکث کوتاه بین بچ‌ها تا فشار لحظه‌ای رو دیتابیس کم بشه
			end

			if totalDeleted > 0 then
				print(('[Unique_LogPanel] پاک‌سازی خودکار: %d لاگ قدیمی‌تر از %d روز حذف شد (دسته‌ای، بدون قفل‌کردن طولانی جدول؛ لاگ‌های ارگان/پین‌شده معاف بودن).'):format(totalDeleted, Config.RetentionDays))
			end

			Wait(6 * 60 * 60 * 1000) -- هر ۶ ساعت یه دور کامل پاک‌سازی
		end
	end)
end
