
-------------------------------------------------------------------
-- MERGE NOTE: this file used to be FMGangBoss/server.lua, a SEPARATE
-- resource that reached into FMGangs via exports.FMGangs:... Now both
-- live in the same Unique_ALLGangs resource, so we call the global
-- functions from server/Gangs.lua directly - no exports/cross-resource
-- hop needed (and no risk of it breaking if someone renames the
-- resource, which is exactly what broke when it was first merged).
-------------------------------------------------------------------
local Accounts = {}
function GetAccount(account)
	return GetMoneyOfGang(account)
end

function AddMoney(account, amount)
	AddGangMoney(account, amount)
end
function RemoveMoney(account, amount)
	if tonumber(amount) and tonumber(amount) > 0 then
		return RemoveGangMoney(account, amount)
	end
end

RegisterNetEvent("FMGangsBoss:server:withdrawMoney", function(amount)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local job = Player.gang.name
	if RemoveMoney(job, amount) then
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'withdraw Money | -$' ..amount   )
		Player.addMoney(tonumber(amount))
		TriggerClientEvent(Config.showNotification, src, "You have withdgangn: $" ..tonumber(amount), "success")
	else
		TriggerClientEvent(Config.showNotification, src, "You dont have enough money in the account!", "error")
	end
end)
-------------------------------------------------------------------
-- FIX (real exploit found and confirmed - unlimited money/XP
-- duplication): this had ZERO access check and took `amount` straight
-- from the client - anyone could TriggerServerEvent this directly,
-- for any gang, for any amount, and mint money from nothing (no
-- deduction anywhere). The NUI flow that's supposed to call this is
-- also broken on its own (client/main.lua sends the string
-- 'moneypack' as the amount, not a number) - but that doesn't reduce
-- the risk of the raw event still being callable directly.
-- Now: requires the same admin check every other boss/admin action in
-- this resource uses (IsPlayerCanOpenPanel), and the amount is no
-- longer taken from the client at all - it's the fixed
-- Config.Packs['moneypack'] value, exactly like itemPacks/weapon
-- packs already do it below.
-------------------------------------------------------------------
RegisterNetEvent("FMGangsBoss:server:MoneyPack", function(gang)
	local src = source
	if not IsPlayerCanOpenPanel(src) then
		print('[Unique_ALLGangs] FMGangsBoss:server:MoneyPack: source ' .. tostring(src) .. ' is not an admin - denying')
		return
	end
	if not Gangs[gang] then return end
	AddMoney(gang, tonumber(Config.Packs['moneypack']) or 0)
end)

RegisterNetEvent("FMGangsBoss:server:depositMoney", function(amount)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if tonumber(amount) and Player.money >= tonumber(amount)  then
		local job = Player.gang.name
		Player.removeMoney(amount)
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'deposit Money | +$' ..amount   )
		AddMoney(job, amount)
		TriggerClientEvent(Config.showNotification, src, "You have deposited: $" ..amount)
	else
		TriggerClientEvent(Config.showNotification, src, "You dont have enough money to add!", "error")
	end
end)

ESX.RegisterServerCallback('FMGangsBoss:getmoney', function(source , cb)
	local gangname = ESX.GetPlayerFromId(source).gang.name
	local result = GetAccount(gangname)
	cb(result)
end)

-------------------------------------------------------------------
-- Dirty money / Wash Money
-- -------------------------
-- Went looking for the "black_money" system on this server before
-- building this: essentialmode's Config.Accounts declares a
-- black_money account type, and the `users` table has a black_money
-- column, but neither essentialmode's player class nor the
-- es_extended_bridge resource actually implement the methods
-- (getAccount('black_money'), addAccountMoney, removeAccountMoney)
-- that would make it usable - the one script that tries to use it
-- (uniquecafejobs/server/corp_server.lua) would crash if that code
-- path ever actually ran, since removeAccountMoney doesn't exist
-- anywhere. So there wasn't a genuinely working dirty-money system to
-- hook into.
--
-- Rather than depend on fixing someone else's resource first, this
-- gives the GANG its own self-contained dirty-money pool
-- (Gangs[gang].others.blackmoney, parallel to .money - see
-- server/Gangs.lua) that lives entirely inside this resource. It
-- starts at 0 for every gang and nothing feeds it automatically yet
-- (no robbery/drug-sale resource pays into it) - AddGangBlackMoney
-- below is exported specifically so another resource CAN pay into it
-- once you wire one up.
-------------------------------------------------------------------
function GetGangBlackMoney(gang)
    if Gangs[gang] ~= nil then
        return Gangs[gang].others.blackmoney or 0
    else
        return 0
    end
end
exports('GetGangBlackMoney', GetGangBlackMoney)

function AddGangBlackMoney(gang, amount)
    if Gangs[gang] ~= nil and tonumber(amount) and tonumber(amount) > 0 then
        UpdateOthers(gang, 'blackmoney', tonumber(amount), 'add')
        return true
    end
    return false
end
exports('AddGangBlackMoney', AddGangBlackMoney)

ESX.RegisterServerCallback('FMGangsBoss:getblackmoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang then return cb(0) end
    cb(GetGangBlackMoney(xPlayer.gang.name))
end)

ESX.RegisterServerCallback('FMGangsBoss:washMoney', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not amount or amount <= 0 then
        return cb(false, 'Invalid amount')
    end
    local gang = xPlayer.gang.name
    if not IsGangBossSource(source, gang) then
        return cb(false, 'Insufficient authorization')
    end
    local dirty = GetGangBlackMoney(gang)
    if dirty < amount then
        return cb(false, 'Not enough dirty money')
    end

    local cutPercent = Config.WashMoneyCutPercent or 20
    local clean = math.floor(amount * (1 - (cutPercent / 100)))

    UpdateOthers(gang, 'blackmoney', amount, 'remove')
    UpdateOthers(gang, 'money', clean, 'add')
    TriggerEvent('For5M:SendLog', source, 'Boss Action', ('Washed $%s dirty money for $%s clean (%s%% cut)'):format(amount, clean, cutPercent))

    -- Federal Case integration (44): track cumulative washed money and
    -- auto-file a real case (referred to FBI/CIA) once it crosses
    -- Config.FederalCase.WashMoneyThreshold - counter resets after
    -- filing so the next threshold has to build up again.
    local totalWashed = (Gangs[gang].others.totalWashed or 0) + amount
    UpdateOthers(gang, 'totalWashed', totalWashed, false)
    if Config.FederalCase and totalWashed >= (Config.FederalCase.WashMoneyThreshold or math.huge) then
        UpdateOthers(gang, 'totalWashed', 0, false)
        TryFileFederalCase(
            gang,
            'Gang "' .. gang .. '" - Suspected Money Laundering',
            ('Officers Of "%s" Washed A Cumulative $%s In Dirty Money.'):format(gang, totalWashed),
            source
        )
    end

    cb(true, clean)
end)

RegisterNetEvent('FMGangsBoss:server:GradeUpdate', function(data)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local Employee = ESX.GetPlayerFromIdentifier(data.cid)

	if data.grade <= 0 then
		
		-- FireEmployee now takes a single `target` param (see its
		-- definition below) - `source` doesn't need to be passed
		-- here, it's a local TriggerEvent so the ambient `source`
		-- from this same network event is already correct inside it.
		TriggerEvent("FMGangsBoss:server:FireEmployee", data)

	else
		print( data.grade)
		print( Player.gang.grade )
		if data.grade > Player.gang.grade then
			TriggerClientEvent(Config.showNotification, src, "You cannot raise your own rank.", "error") 
		else
			if Employee then
				TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Player Rank Updated | '.. Employee.name .. '|' .. data.grade   )
				Employee.setGang(Employee.gang.name, tonumber(data.grade)) 
				TriggerClientEvent(Config.showNotification, src, 'Player Rank Updated | '.. Employee.name .. '|' .. data.grade   , "success")
			else
				TriggerClientEvent(Config.showNotification, src, "Civilian not in city.", "error")
			end 
		end
	end
end)

-- Fire Employee
-------------------------------------------------------------------
-- FIX: this handler's first parameter used to be named "source",
-- which SHADOWS the real global `source` FiveM sets for network
-- events - Lua's normal scoping means a local parameter with that
-- name takes over for the rest of the function, so `local src =
-- source` was reading back whatever the CLIENT sent as its first
-- argument (the target table), not the actual calling player. Worse,
-- since only one argument was ever sent, the second parameter
-- (`target`) was always nil, so `target.cid` below would have thrown
-- immediately. Renamed to `target` (single param) - matches every
-- other handler in this file, which correctly never shadows `source`.
-------------------------------------------------------------------
RegisterNetEvent('FMGangsBoss:server:FireEmployee', function(target)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	local Employee = ESX.GetPlayerFromIdentifier(target.cid)
	if Employee then
		if true then
			-- Federal Case integration (44): grab the grade BEFORE it
			-- gets wiped by setGang below - MaybeCreateInformantTip
			-- needs it to decide whether this was a low-rank member.
			local firedGrade = Employee.gang and Employee.gang.grade
			TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee fired | '.. Employee.name    )
			Employee.setGang("nogang", 0)
			MaybeCreateInformantTip(Player.gang.name, Employee.identifier, Employee.name, firedGrade)
			TriggerClientEvent(Config.showNotification, src, "Employee fired!", "success")
		else
			TriggerClientEvent(Config.showNotification, src, "You can\'t fire yourself", "error")
		end
	else
		-- Federal Case integration (44): need the offline member's
		-- grade BEFORE it's wiped below, same reasoning as the online
		-- branch above.
		MySQL.Async.fetchAll('SELECT grade FROM users WHERE identifier = @identifier', { ['@identifier'] = target.cid }, function(rows)
			local offlineGrade = rows and rows[1] and rows[1].grade
			MaybeCreateInformantTip(Player.gang.name, target.cid, target.name or 'Unknown', offlineGrade)
		end)
		MySQL.Async.execute('UPDATE users SET gang = @gang, grade = @grade WHERE identifier = @identifier', 
		{
			['@gang'] =  'nogang',
			['@grade'] = 0,
			['@identifier'] = target.cid
		}, function(result)
		end)
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee fired | Hex : '.. target.cid    )
		TriggerClientEvent(Config.showNotification, src, "Employee fired!", "success")
	end
end)

ESX.RegisterServerCallback('FMGangBoss:getname', function(source, cb)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	cb(Player.name ,Player.gang.name )
end)

-- Recruit Player
RegisterNetEvent('FMGangsBoss:server:HireEmployee', function(recruit)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local Target = ESX.GetPlayerFromId(recruit)
    if Player then
		if Target then
			TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee hired | +'..  Target.name    )
			Target.setGang(Player.gang.name, data.grade-1)
			TriggerClientEvent(Config.showNotification, src, "You hired " .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. " come " .. Player.PlayerData.job.label .. "", "success")
			TriggerClientEvent(Config.showNotification, Target.PlayerData.source , "You were hired as " .. Player.PlayerData.job.label .. "", "success")
		end
	end

end)

RegisterNetEvent('FMGangBoss:SetGang', function(id)
	local src = source
	local Employee = ESX.GetPlayerFromId(id)
	local Player = ESX.GetPlayerFromId(src)
	-------------------------------------------------------------------
	-- SECURITY FIX: no permission check at all before - any client
	-- could call this directly and recruit ANY online player straight
	-- into their own gang, bypassing every menu. Now requires the
	-- caller to actually be a boss (or have bossaction access) of
	-- their own gang, same check every other boss action already uses.
	-------------------------------------------------------------------
	if not Player or not Player.gang or Player.gang.name == 'nogang' or not Gangs[Player.gang.name] then
		return TriggerClientEvent(Config.showNotification, src, "You're not in a gang.", "error")
	end
	local LastRank = CountTable(Gangs[Player.gang.name].grades)
	local isBoss = Player.gang.grade == LastRank
	local hasBossAccess = Gangs[Player.gang.name].grades[Player.gang.grade] and Gangs[Player.gang.name].grades[Player.gang.grade].access['bossaction']
	if not isBoss and not hasBossAccess then
		return TriggerClientEvent(Config.showNotification, src, "Insufficient authorization", "error")
	end

	if Employee then
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee hired | +'..  Employee.name    )
		Employee.setGang(Player.gang.name,1)
		TriggerClientEvent(Config.showNotification, src, "Employee hired!", "success")
	else
		TriggerClientEvent(Config.showNotification, src, "Civilian not in city.", "error")
	end
end)

-------------------------------------------------------------------
-- Lists online players not currently in the calling player's gang -
-- used by the "Recruit" menu (client/boss_esx_menu.lua) so the boss
-- can pick from a list instead of typing a server ID blind.
-------------------------------------------------------------------
-------------------------------------------------------------------
-- Registers a gang vehicle into Unique_Garage/esx_vehicleshop's
-- shared `owned_vehicles` table (owner = gang name, job = 'gang') -
-- the exact same shape esx_vehicleshop's own admin
-- 'esx_vehicleshop:setVehicleGang' event writes, confirmed by reading
-- its source first. That event is hard-gated to server admins only
-- (permission_level >= 10) though, so a regular gang boss can't use
-- it - this does the same insert directly, gated by our own
-- boss/garage-access check instead, so a boss can register a vehicle
-- to their own gang without needing admin rights. Access is already
-- checked client-side before the vehicle is even spawned (access['garage']
-- and, per-model, access.vehicleAccess), but checked again here too since
-- this is the actual trust boundary.
-------------------------------------------------------------------
ESX.RegisterServerCallback('FMGangs:RegisterGangVehicle', function(source, cb, vehicleProps, model, category)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not Gangs[xPlayer.gang.name] then
        return cb(false)
    end
    local gradeData = Gangs[xPlayer.gang.name].grades[xPlayer.gang.grade]
    local LastRank = CountTable(Gangs[xPlayer.gang.name].grades)
    local isBoss = xPlayer.gang.grade == LastRank
    if not isBoss and not (gradeData and gradeData.access['garage']) then
        return cb(false)
    end
    -- Per-model rank access (see FMGangs:EditVehicleAccess in
    -- server/Gangs.lua): models never explicitly toggled default to
    -- accessible, same as itemAccess. Applies uniformly, same as
    -- itemAccess (no boss bypass there either).
    local vehicleAccess = gradeData and gradeData.access and gradeData.access.vehicleAccess
    if model and vehicleAccess and vehicleAccess[model] == false then
        return cb(false)
    end
    if not vehicleProps or not vehicleProps.plate then
        return cb(false)
    end

    -- FEATURE: stamps the real spawn-code model name into the stored
    -- vehicle JSON (Config.GangVehicles already gives us this as a
    -- plain string here, no native lookup needed) so
    -- FMGangs:GetOwnedVehicleModels below can offer it in the boss's
    -- Vehicle Access menu even though it's a real vehicle, not just a
    -- Config.GangVehicles entry.
    vehicleProps.modelName = model

    -- FIX: `type` was always hardcoded 'car' regardless of what was
    -- actually spawned, so a registered heli/boat would silently never
    -- show up when browsing the 'heli'/'boat' tab in the real garage UI
    -- (Unique_Garage's GetVehicles filters by this exact column). Uses
    -- the real category passed in from client/load.lua now.
    MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, job, type, stored, engine, fuel, body) VALUES (@owner, @plate, @vehicle, @job, @type, @stored, @engine, @fuel, @body)',
    {
        ['@owner']   = xPlayer.gang.name,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@job']     = 'gang',
        ['@type']    = category or 'car',
        ['@stored']  = 0,
        ['@engine']  = 1000,
        ['@fuel']    = 100,
        ['@body']    = 1000,
    }, function(rowsChanged)
        local success = rowsChanged and rowsChanged > 0
        -- Federal Case integration (44): if this gang currently has an
        -- open federal case on file, log the new plate as evidence -
        -- gives FBI/CIA something real to run a tracker/BOLO against.
        -- No-op if there's no open case (see AddEvidenceToOpenCase).
        if success then
            AddEvidenceToOpenCase(xPlayer.gang.name, ('New Vehicle Registered To Gang: Plate "%s" (%s).'):format(vehicleProps.plate, model or 'Unknown Model'), xPlayer.name)
        end
        cb(success)
    end)
end)

-------------------------------------------------------------------
-- FEATURE (requested: a gang member drives their OWN personal
-- vehicle to the gang's spawn point, presses E while in it, gets a
-- Yes/No confirmation, and on Yes it becomes the gang's - manageable
-- from Boss Action's Vehicle Access afterwards same as any other gang
-- vehicle). The actual ownership hand-off: flips the SAME
-- owned_vehicles row from owner=<player identifier> to
-- owner=<gang name>, job='gang' - exactly the shape
-- FMGangs:RegisterGangVehicle above already writes, so it's
-- immediately visible in the real garage UI and Vehicle Access.
-- Trust boundary: verifies the plate is actually currently owned by
-- THIS player before touching it - a parked vehicle sitting nearby
-- that isn't even the caller's cannot be donated.
-------------------------------------------------------------------
ESX.RegisterServerCallback('FMGangs:DonateVehicleToGang', function(source, cb, gangName, plate, category, modelName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name ~= gangName or gangName == 'nogang' or not Gangs[gangName] then
        return cb(false)
    end
    if not plate or plate == '' then return cb(false) end

    MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = plate }, function(result)
        local row = result and result[1]
        if not row or row.owner ~= xPlayer.identifier then
            -- not this player's vehicle (or not a tracked/owned vehicle at all)
            return cb(false)
        end
        -- stamps modelName into the existing vehicle JSON the same way
        -- RegisterGangVehicle does above, so a donated vehicle's model
        -- is offerable in Vehicle Access too (see
        -- FMGangs:GetOwnedVehicleModels).
        local ok, decodedProps = pcall(json.decode, row.vehicle)
        if ok and type(decodedProps) == 'table' and modelName then
            decodedProps.modelName = modelName
        end
        MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner, job = @job, type = @type, stored = 1, vehicle = @vehicle WHERE plate = @plate',
        {
            ['@owner']   = gangName,
            ['@job']     = 'gang',
            ['@type']    = category or 'car',
            ['@vehicle'] = (ok and type(decodedProps) == 'table') and json.encode(decodedProps) or row.vehicle,
            ['@plate']   = plate,
        }, function(rowsChanged)
            cb(rowsChanged and rowsChanged > 0)
        end)
    end)
end)

-------------------------------------------------------------------
-- Supports the boss's Vehicle Access menu (client/boss_esx_menu.lua):
-- Config.GangVehicles is only a preset starter list, but a donated
-- vehicle (FMGangs:DonateVehicleToGang above) can be any model a
-- member happened to own - this returns the real, distinct model
-- names actually sitting in the gang's garage for a category, read
-- from the modelName stamp both registration paths write into the
-- stored vehicle JSON, so those can be offered for per-rank access
-- too instead of only the config presets.
-------------------------------------------------------------------
ESX.RegisterServerCallback('FMGangs:GetOwnedVehicleModels', function(source, cb, gang, category)
    if type(gang) ~= 'string' or gang == '' then return cb({}) end
    MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE LOWER(owner) = @owner AND type = @type', {
        ['@owner'] = string.lower(gang),
        ['@type']  = category or 'car',
    }, function(result)
        local seen, models = {}, {}
        for _, row in ipairs(result or {}) do
            local ok, decoded = pcall(json.decode, row.vehicle)
            if ok and type(decoded) == 'table' and decoded.modelName and not seen[decoded.modelName] then
                seen[decoded.modelName] = true
                table.insert(models, decoded.modelName)
            end
        end
        cb(models)
    end)
end)

-------------------------------------------------------------------
-- Completes the DeleteTheVehicle (store vehicle) fix in
-- client/load.lua: checks ownership against the real owned_vehicles
-- table this resource actually writes to (via
-- FMGangs:RegisterGangVehicle above), instead of the dead
-- For5mG-garage:getvehiclebyplate callback that never existed here.
-------------------------------------------------------------------
ESX.RegisterServerCallback('FMGangs:GetGangVehicleByPlate', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not plate then
        return cb(false)
    end
    MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE plate = @plate AND owner = @owner AND job = @job',
    {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.gang.name,
        ['@job']   = 'gang',
    }, function(result)
        cb(result and result[1] ~= nil)
    end)
end)

RegisterServerEvent('FMGangs:StoreGangVehicle')
AddEventHandler('FMGangs:StoreGangVehicle', function(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not plate then return end
    MySQL.Async.execute('UPDATE owned_vehicles SET stored = 1 WHERE plate = @plate AND owner = @owner AND job = @job',
    {
        ['@plate'] = plate,
        ['@owner'] = xPlayer.gang.name,
        ['@job']   = 'gang',
    })
end)

ESX.RegisterServerCallback('FMGangsBoss:GetRecruitablePlayers', function(source, cb)
	local Player = ESX.GetPlayerFromId(source)
	if not Player or not Player.gang then return cb({}) end

	-------------------------------------------------------------------
	-- FIX (recruit showed every online player server-wide): now only
	-- lists players within 10 meters of the boss, matching how
	-- recruiting is meant to work (you walk up to someone and recruit
	-- them, not pick anyone from across the map).
	-------------------------------------------------------------------
	local myGang = Player.gang.name
	local myCoords = GetEntityCoords(GetPlayerPed(source))
	local candidates = {}
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
		if xPlayers[i] ~= source then
			local xTarget = ESX.GetPlayerFromId(xPlayers[i])
			if xTarget and xTarget.gang and xTarget.gang.name ~= myGang then
				local targetCoords = GetEntityCoords(GetPlayerPed(xTarget.source))
				if #(myCoords - targetCoords) <= 10.0 then
					table.insert(candidates, xTarget)
				end
			end
		end
	end

	if #candidates == 0 then return cb({}) end

	-------------------------------------------------------------------
	-- Federal Case integration (44): flags anyone with an open
	-- dept_cases record (esx_uniquejobs's own DOJ case table, read
	-- directly - no job-gated callback needed for a plain SELECT) as
	-- "under investigation" so the boss sees the risk BEFORE recruiting
	-- them, not after. Skipped entirely (candidates returned as-is) if
	-- esx_uniquejobs isn't running.
	-------------------------------------------------------------------
	if GetResourceState('esx_uniquejobs') ~= 'started' then
		local players = {}
		for _, xTarget in ipairs(candidates) do
			table.insert(players, { source = xTarget.source, name = xTarget.name })
		end
		return cb(players)
	end

	local players = {}
	local pending = #candidates
	for _, xTarget in ipairs(candidates) do
		MySQL.Async.fetchAll(
			"SELECT dept_cases.id FROM dept_case_suspects JOIN dept_cases ON dept_cases.id = dept_case_suspects.case_id WHERE dept_case_suspects.identifier = @id AND dept_cases.status NOT IN ('closed','dismissed') LIMIT 1",
			{ ['@id'] = xTarget.identifier },
			function(rows)
				table.insert(players, { source = xTarget.source, name = xTarget.name, underInvestigation = (rows and rows[1] ~= nil) or false })
				pending = pending - 1
				if pending == 0 then cb(players) end
			end
		)
	end
end)

