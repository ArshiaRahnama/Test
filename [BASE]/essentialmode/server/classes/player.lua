function CreatePlayer(
    source,
    permission_level,
    money,
    bank,
    identifier,
    license,
    group,
    roles,
    inventory,
    job,
    jgrade,
    gang,
    fgrade,
    loadout,
    name,
    coords,
    status,

    starterpack,
    discordid,
    level,
    respect)
    local self = {}

    self.source = source
    self.permission_level = permission_level
    self.money = money
    self.bank = bank
    self.identifier = identifier
    self.license = license
    self.group = group
    self.coords = nil
    if coords then
        self.coords = json.decode(coords)
    else
        self.coords = json.decode(settings.defaultSettings.defaultSpawn)
    end
    self.session = {}
    self.inventory = inventory
    self.job = {}

    self.gang = {}
    self.angel = 0
    self.IsDead = false
    self.StarterPack = starterpack
    self.DiscordId = discordid

    self.triggerEvent = function(eventName, ...)
        TriggerClientEvent(eventName, self.source, ...)
    end

    self.Setperm = function(p)
        if tonumber(p) then
            self.permission_level = tonumber(p)
            exports.oxmysql:execute(
                "UPDATE users SET `permission_level` = @perm  WHERE `identifier` = @identifier",
                {
                    ["perm"] = tonumber(p),
                    ["identifier"] = self.identifier
                }
            )
        end
    end

    self.setGroup = function(g)
        if tostring(g) then
            self.group = g
            exports.oxmysql:execute(
                "UPDATE users SET `group` = @group  WHERE `identifier` = @identifier",
                {
                    ["group"] = g,
                    ["identifier"] = self.identifier
                }
            )
        else
            print("Group Most Be String")
        end
    end

    self.showNotification = function(msg)
        self.triggerEvent("esx:showNotification", msg)
    end

    self.showHelpNotification = function(msg, thisFrame, beep, duration)
        self.triggerEvent("esx:showHelpNotification", msg, thisFrame, beep, duration)
    end

    self.level = level

    self.respect = respect

    if self.level < 16 then
        self.RespectCount = self.level * 2
    elseif self.level > 15 and self.level < 30 then
        self.RespectCount = self.level * 3
    elseif self.level > 30 and self.level < 45 then
        self.RespectCount = self.level * 4
    elseif self.level > 45 and self.level < 60 then
        self.RespectCount = self.level * 5
    elseif self.level > 60 and self.level < 75 then
        self.RespectCount = self.level * 6
    elseif self.level > 75 and self.level < 90 then
        self.RespectCount = self.level * 7
    else
        self.RespectCount = self.level * 8
    end

    self.ChangeDiscordId = function(new)
        if tonumber(new) then
            self.DiscordId = new
            exports.oxmysql:execute(
                "UPDATE users SET `discordid` = @sp  WHERE `identifier` = @identifier",
                {
                    ["sp"] = new,
                    ["identifier"] = self.identifier
                }
            )
        else
            print("Invalid Change Discord Id Value")
        end
    end

    if status then
        self.status = json.decode(status)
    else
        self.status = {}
    end

    if loadout then
        self.loadout = json.decode(loadout)
    else
        self.loadout = {}
    end

    if self.permission_level >= 1 then
		self.aduty = false
		if self.permission_level >= 8 then
			self.aduty = true
		end
	end

    if ESX.DoesJobExist(job, jgrade) then
        local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(jgrade)]

		self.job.id = jobObject.id
        self.job.name = jobObject.name
		if jobObject.name == 'police' or jobObject.name == 'sheriff' or jobObject.name == 'fbi' or jobObject.name == 'mt' then




			local wai = true
			exports.oxmysql:execute('SELECT * FROM police_ext WHERE identifier = @identifier',{
				['identifier'] = self.identifier
			},
			function(result)
				if result[1] then

				end
				wai = false
			end)
			while wai do
				Citizen.Wait(1)
			end
		end

        self.job.label = jobObject.label

        self.job.grade = tonumber(jgrade)
        self.job.grade_name = gradeObject.name
        self.job.grade_label = gradeObject.label
        self.job.grade_salary = gradeObject.salary

        self.job.skin_male = {}
        self.job.skin_female = {}

        if gradeObject.skin_male ~= nil then
            self.job.skin_male = json.decode(gradeObject.skin_male)
        end

        if gradeObject.skin_female ~= nil then
            self.job.skin_female = json.decode(gradeObject.skin_female)
        end
    else
        print(
            ("essentialmode: %s had an unknown job [job: %s, grade: %s], setting as nojob!"):format(
                self.identifier,
                job,
                jgrade
            )
        )

        local job, jgrade = "nojob", "0"
        local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(jgrade)]

        self.job = {}

        self.job.id = jobObject.id
        self.job.name = jobObject.name
        self.job.label = jobObject.label

        self.job.grade = tonumber(jgrade)
        self.job.grade_name = gradeObject.name
        self.job.grade_label = gradeObject.label
        self.job.grade_salary = gradeObject.salary

        self.job.skin_male = {}
        self.job.skin_female = {}
    end



    if ESX.DoesGangExist(gang, fgrade) then
        local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

        self.gang.id = gangObject.id
        self.gang.name = gangObject.name
        self.gang.label = gangObject.label

        self.gang.grade = tonumber(fgrade)
        self.gang.grade_name = gradeObject.name
        self.gang.grade_label = gradeObject.label
        self.gang.grade_salary = gradeObject.salary

        self.gang.skin_male = {}
        self.gang.skin_female = {}

        if gradeObject.skin_male ~= nil then
            self.gang.skin_male = json.decode(gradeObject.skin_male)
        end

        if gradeObject.skin_female ~= nil then
            self.gang.skin_female = json.decode(gradeObject.skin_female)
        end
    else
        local gang, fgrade = "nogang", "0"
        local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

        self.gang = {}

        self.gang.id = gangObject.id
        self.gang.name = gangObject.name
        self.gang.label = gangObject.label

        self.gang.grade = tonumber(fgrade)
        self.gang.grade_name = gradeObject.name
        self.gang.grade_label = gradeObject.label
        self.gang.grade_salary = gradeObject.salary

        self.gang.skin_male = {}
        self.gang.skin_female = {}
    end

    self.changeGangSkin = function(skin)
        self.gang.skin_male = skin
        self.gang.skin_female = skin
    end

    self.name = name or GetPlayerName(self.source)
    self.roles = stringsplit(roles, "|")

    ExecuteCommand("add_principal identifier." .. self.identifier .. " group." .. self.group)

    self.setCoords = function(x, y, z)
        self.coords = {x = x, y = y, z = z}

    end

    self.kick = function(r)
        DropPlayer(self.source, r)
    end

    self.addMoney = function(m)
        if type(m) == "number" and m > 0 then
            local newMoney = self.money + m
            self.money = newMoney
        end
        TriggerClientEvent("moneyUpdate", self.source, self.money)
    end

    self.removeMoney = function(m)
        if type(m) == "number" and m > 0 then
            local newMoney = self.money - m
            self.money = newMoney
        end
        TriggerClientEvent("moneyUpdate", self.source, self.money)
    end

    self.setMoney = function(m)
        if type(m) == "number" then
            self.money = m
        end
        TriggerClientEvent("moneyUpdate", self.source, self.money)
    end

    self.addBank = function(m)
        if type(m) == "number" and m > 0 then
            local newBank = self.bank + m
            self.bank = newBank
            TriggerClientEvent("gcphone:setUiPhone", self.source, self.bank)
            TriggerClientEvent("bankUpdate", self.source, self.bank)

        end
    end

    self.setBank = function(m)
        if type(m) == "number" then
            self.bank = m
            TriggerClientEvent("gcphone:setUiPhone", self.source, self.bank)
            TriggerClientEvent("bankUpdate", self.source, self.bank)

        end
    end

    self.removeBank = function(m)
        if type(m) == "number" and m > 0 then
            local newBank = self.bank - m
            self.bank = newBank
            TriggerClientEvent("gcphone:setUiPhone", self.source, self.bank)
            TriggerClientEvent("bankUpdate", self.source, self.bank)
        end
    end

    -- true if cash + bank together cover the amount, regardless of where it sits
    self.canAfford = function(amount)
        if type(amount) ~= "number" or amount <= 0 then return false end
        return (self.money + self.bank) >= amount
    end

    -- pays `amount` using cash first, then pulls the remainder from bank.
    -- returns true/false depending on whether the player could afford it.
    self.payAny = function(amount)
        if type(amount) ~= "number" or amount <= 0 then return true end
        if not self.canAfford(amount) then return false end

        local fromCash = math.min(self.money, amount)
        local fromBank = amount - fromCash

        if fromCash > 0 then
            self.removeMoney(fromCash)
        end

        if fromBank > 0 then
            self.removeBank(fromBank)
        end

        return true
    end

    self.setSessionVar = function(key, value)
        self.session[key] = value
    end

    self.getSessionVar = function(k)
        return self.session[k]
    end

    self.set = function(k, v)
        self[k] = v
    end

    self.setName = function(v)
        self.name = v
        TriggerClientEvent("nameUpdate", self.source, self.name)
        exports.oxmysql:execute(
            "UPDATE users SET `playerName` = @name WHERE `identifier` = @identifier",
            {
                ["name"] = self.name,
                ["identifier"] = self.identifier
            }
        )
    end

    self.get = function(k)
        return self[k]
    end

    self.setGlobal = function(g, default)
        self[g] = default or ""

        self["get" .. g:gsub("^%l", string.upper)] = function()
            return self[g]
        end

        self["set" .. g:gsub("^%l", string.upper)] = function(e)
            self[g] = e
        end

        Users[self.source] = self
    end

    self.setlevel = function(l)
        self.level = l
        exports.oxmysql:execute(
            "UPDATE users SET `level` = @level WHERE `identifier` = @identifier",
            {
                ["level"] = l,
                ["identifier"] = self.identifier
            }
        )
        self.SetRespect(0)
        TriggerClientEvent("esx:setLevel", self.source, self.level)
        self.editrespectcount(self.level)
    end

    self.addlevel = function(l)
        local oldl = self.level
        local new = self.level + l
        self.level = new
        exports.oxmysql:execute(
            "UPDATE users SET `level` = @level WHERE `identifier` = @identifier",
            {
                ["level"] = new,
                ["identifier"] = self.identifier
            }
        )
        self.SetRespect(0)
        TriggerClientEvent("esx:setLevel", self.source, self.level)
        self.editrespectcount(self.level)
        self.showNotification(
            "~r~~h~Be Shoma " .. l .. " level Ezafe Shod Va Shoma " .. self.level * 2 * 5000 .. " Jayeze Gereftid"
        )
        self.rewardme(self.level * 2)
    end

    self.SetRespect = function(R)
        self.respect = R
        if R >= self.RespectCount then
            self.addlevel(1)
            self.respect = 0
        end
        exports.oxmysql:execute(
            "UPDATE users SET `R` = @R WHERE `identifier` = @identifier",
            {
                ["R"] = self.respect,
                ["identifier"] = self.identifier
            }
        )
        TriggerClientEvent("esx:setRespect", self.source, self.respect)
    end

    self.addRespect = function(R)
        local old1 = self.respect
        local new = self.respect + R
        if new >= self.RespectCount then
            self.addlevel(1)
            self.respect = 0
        else
            self.respect = new
        end
        exports.oxmysql:execute(
            "UPDATE users SET `R` = @R WHERE `identifier` = @identifier",
            {
                ["R"] = self.respect,
                ["identifier"] = self.identifier
            }
        )
        self.showNotification("~r~~h~Be Shoma " .. R .. " Respect Ezafe Shod")
        TriggerClientEvent("esx:setRespect", self.source, self.respect)
    end

    self.editrespectcount = function(l)
        if l < 16 then
            self.RespectCount = l * 2
        elseif l > 15 and l < 30 then
            self.RespectCount = l * 3
        elseif l > 30 and l < 45 then
            self.RespectCount = l * 4
        elseif l > 45 and l < 60 then
            self.RespectCount = l * 5
        elseif l > 60 and l < 75 then
            self.RespectCount = l * 6
        elseif l > 75 and l < 90 then
            self.RespectCount = l * 7
        else
            self.RespectCount = l * 10
        end
        TriggerClientEvent("esx:setRespectCount", self.source, self.RespectCount)
    end

    if self.respect >= self.RespectCount then
        self.addlevel(1)
    end

    self.rewardme = function(v)
        self.addBank(v * 5000)
    end

    self.getInventoryItem = function(name)
        for i = 1, #self.inventory, 1 do
            if self.inventory[i].name == name then
                return self.inventory[i], i
            end
        end
        if not ESX.Items[name] then
            return nil
        end
        return {
            name = name,
            count = 0,
            label = ESX.Items[name].label,
            limit = ESX.Items[name].limit,
            usable = ESX.UsableItemsCallbacks[name] ~= nil,
            rare = ESX.Items[name].rare,
            canRemove = ESX.Items[name].canRemove
        }
    end

    self.addInventoryItem = function(name, count)
        count = tonumber(count) or 0
        local item, i = self.getInventoryItem(name)
        if not item then
            return
        end
        item.count = item.count + count
        if not i then
            table.insert(self.inventory, item)
        end
        TriggerEvent("esx:onaddInventoryItem", self.source, item, count)
        TriggerClientEvent("esx:addInventoryItem", self.source, item, count)
    end

    self.removeInventoryItem = function(name, count)
        -- SECURITY FIX: a negative (or non-numeric) `count` used to be
        -- subtracted straight from item.count, which for a negative value
        -- actually INCREASES it -- i.e. calling removeInventoryItem with a
        -- negative count duplicated items instead of removing them. Every
        -- other mutator (addMoney/removeMoney/removeBank/addBank) already
        -- guards against this; this one didn't. Now rejects anything that
        -- isn't a positive number, same as the money functions.
        count = tonumber(count)
        if type(count) ~= "number" or count <= 0 then return end

        local item, i = self.getInventoryItem(name)
        if not item then return end

        local newCount = math.max(0, item.count - count)
        item.count = newCount

        TriggerEvent("esx:onRemoveInventoryItem", self.source, item, count)
        TriggerClientEvent("esx:removeInventoryItem", self.source, item, count)

        if newCount <= 0 then
            table.remove(self.inventory, i)
        end
    end







    self.maxWeight = Config.DefaultMaxWeight or 24000

    self.getMaxWeight = function()
        return self.maxWeight
    end

    self.setMaxWeight = function(newMaxWeight)
        self.maxWeight = newMaxWeight
    end

    self.getUsedWeight = function()
        local total = 0
        for i = 1, #self.inventory, 1 do
            local entry = self.inventory[i]
            if entry.count and entry.count > 0 then
                total = total + (ESX.getItemWeight(entry.name) * entry.count)
            end
        end
        for i = 1, #self.loadout, 1 do
            total = total + ESX.getWeaponWeight(self.loadout[i].name)
        end
        return total
    end

    self.canCarryItem = function(name, count)
        local weight
        if ESX.Items[name] then
            weight = ESX.getItemWeight(name) * count
        else


            weight = ESX.getWeaponWeight(name)
        end
        return (self.getUsedWeight() + weight) <= self.maxWeight
    end

    self.setInventoryItem = function(name, count)
        local item = self.getInventoryItem(name)
        local oldCount = item.count
        item.count = count

        if oldCount > item.count then
            TriggerEvent("esx:onRemoveInventoryItem", self.source, item, oldCount - item.count)
            TriggerClientEvent("esx:removeInventoryItem", self.source, item, oldCount - item.count)
        else
            TriggerEvent("esx:onaddInventoryItem", self.source, item, item.count - oldCount)
            TriggerClientEvent("esx:addInventoryItem", self.source, item, item.count - oldCount)
        end
    end

    self.setJob = function(job, grade)
        grade = tostring(grade)

        if ESX.DoesJobExist(job, grade) then
            local lastJob = ESX.CopyTable(self.job)
            local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(grade)]
            self.job.id = jobObject.id
            self.job.name = jobObject.name
            self.job.label = jobObject.label

			if jobObject.name == 'police' or jobObject.name == 'sheriff' or jobObject.name == 'fbi' or jobObject.name == 'mt' and not self.job.ext then




				local wai = true
				exports.oxmysql:execute('SELECT * FROM police_ext WHERE identifier = @identifier',{
					['identifier'] = self.identifier
				},
				function(result)
					if result[1] then

					end
					wai = false
				end)
				while wai do
					Citizen.Wait(1)
				end
			end

            self.job.grade = tonumber(grade)
            self.job.grade_name = gradeObject.name
            self.job.grade_label = gradeObject.label
            self.job.grade_salary = gradeObject.salary

            self.job.skin_male = {}
            self.job.skin_female = {}

            if gradeObject.skin_male ~= nil then
                self.job.skin_male = json.decode(gradeObject.skin_male)
            end

            if gradeObject.skin_female ~= nil then
                self.job.skin_female = json.decode(gradeObject.skin_female)
            end

            TriggerEvent("esx:setJob", self.source, self.job, lastJob)
            TriggerClientEvent("esx:setJob", self.source, self.job)
            exports.oxmysql:execute(
                "UPDATE users SET `job` = @job, `job_grade` = @job_grade WHERE `identifier` = @identifier",
                {
                    ["job"] = job,
                    ["job_grade"] = grade,
                    ["identifier"] = self.identifier
                }
            )
        end
    end

    self.setGang = function(gang, grade)
        grade = tostring(grade)

        if ESX.DoesGangExist(gang, grade) then
            local lastGang = ESX.CopyTable(self.gang)
            local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(grade)]
            self.gang.id = gangObject.id
            self.gang.name = gangObject.name
            self.gang.label = gangObject.label

            self.gang.grade = tonumber(grade)
            self.gang.grade_name = gradeObject.name
            self.gang.grade_label = gradeObject.label
            self.gang.grade_salary = gradeObject.salary

            self.gang.skin_male = {}
            self.gang.skin_female = {}

            if gradeObject.skin_male ~= nil then
                self.gang.skin_male = json.decode(gradeObject.skin_male)
            end

            if gradeObject.skin_female ~= nil then
                self.gang.skin_female = json.decode(gradeObject.skin_female)
            end
            TriggerEvent("esx:setGang", self.source, self.gang, lastGang)
            TriggerClientEvent("esx:setGang", self.source, self.gang)
            exports.oxmysql:execute(
                "UPDATE users SET `gang` = @gang, `gang_grade` = @gang_grade WHERE `identifier` = @identifier",
                {
                    ["gang"] = gang,
                    ["gang_grade"] = grade,
                    ["identifier"] = self.identifier
                }
            )
        end
    end

    self.addWeapon = function(weaponNamex, ammo)
		weaponName = string.upper(weaponNamex)
        local weaponLabel = ESX.GetWeaponLabel(weaponName)

        if not self.hasWeapon(weaponName) then
            table.insert(
                self.loadout,
                {
                    name = weaponName,
                    ammo = ammo,
                    label = weaponLabel,
                    components = {}
                }
            )
        end

        TriggerClientEvent("esx:addWeapon", self.source, weaponName, ammo)
		if weaponLabel and weaponLabel ~= "undefind" then
			TriggerClientEvent("esx:addInventoryItem", self.source, {label = weaponLabel}, 1)
		end
    end

    self.addWeaponComponent = function(weaponNamex, weaponComponent)
		weaponName = string.upper(weaponNamex)
        local loadoutNum, weapon = self.getWeapon(weaponName)

        if self.hasWeaponComponent(weaponName, weaponComponent) then
            return
        end

        table.insert(self.loadout[loadoutNum].components, weaponComponent)

        TriggerClientEvent("esx:addWeaponComponent", self.source, weaponName, weaponComponent)
    end

    self.removeWeapon = function(weaponNamex, ammo)
		weaponName = string.upper(weaponNamex)
        local weaponLabel
        ammo = tonumber(ammo) or 0

        for i = 1, #self.loadout, 1 do
            if self.loadout[i].name == weaponName then
                weaponLabel = self.loadout[i].label











                table.remove(self.loadout, i)
                break
            end
        end

        if weaponLabel then
            weaponLabel = tostring(weaponLabel)
            TriggerClientEvent("esx:removeWeapon", self.source, weaponName, ammo)
            TriggerClientEvent("esx:removeInventoryItem", self.source, {label = weaponLabel}, 1)
        end
    end

    self.removeWeaponComponent = function(weaponNamex, weaponComponent)
		weaponName = string.upper(weaponNamex)
        local loadoutNum, weapon = self.getWeapon(weaponName)

        if weapon then
            local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

            if component then
                if self.hasWeaponComponent(weaponName, weaponComponent) then
                    for k, v in ipairs(self.loadout[loadoutNum].components) do
                        if v == weaponComponent then
                            table.remove(self.loadout[loadoutNum].components, k)
                            break
                        end
                    end

                    TriggerClientEvent("esx:removeWeaponComponent", self.source, weaponName, weaponComponent)
                end
            end
        end
    end

    local whiteListedJob =
        self.job.name == "police" or self.job.name == "government" or self.job.name == "ambulance" or
        self.job.name == "doc"
    if IsPlayerAceAllowed(self.source, "CHJOB") then
        if not whiteListedJob then
            ExecuteCommand("remove_principal identifier." .. self.identifier .. " CHJOB")
        end
    else
        if whiteListedJob then
            ExecuteCommand("add_principal identifier." .. self.identifier .. " CHJOB")
        end
    end

    self.hasWeaponComponent = function(weaponNamex, weaponComponent)
		weaponName = string.upper(weaponNamex)
        local loadoutNum, weapon = self.getWeapon(weaponName)

        if not weapon then
            return false
        end

        for i = 1, #weapon.components, 1 do
            if weapon.components[i] == weaponComponent then
                return true
            end
        end

        return false
    end

    self.hasWeapon = function(weaponNamex)
		weaponName = string.upper(weaponNamex)
        for i = 1, #self.loadout, 1 do
            if self.loadout[i].name == weaponName then
                return {ammo = self.loadout[i].ammo, components = self.loadout[i].components}
            end
        end

        return false
    end

    self.getWeapon = function(weaponNamex)
		weaponName = string.upper(weaponNamex)
        for k, v in ipairs(self.loadout) do
            if v.name == weaponName then
                return k, v
            end
        end

        return
    end

    self.SetStarterPack = function(status)
        if status then
            if status == "true" then
                self.StarterPack = "true"
                exports.oxmysql:execute(
                    "UPDATE users SET `starterpack` = @sp  WHERE `identifier` = @identifier",
                    {
                        ["sp"] = status,
                        ["identifier"] = self.identifier
                    }
                )
            elseif status == "false" then
                self.StarterPack = "false"
                exports.oxmysql:execute(
                    "UPDATE users SET `starterpack` = @sp  WHERE `identifier` = @identifier",
                    {
                        ["sp"] = status,
                        ["identifier"] = self.identifier
                    }
                )
            else
                print("essentialmode : Invalid Set Starter Pack Status pls Check")
                return
            end
        else
            print("essentialmode : Invalid Set Starter Pack Status pls Check")
        end
    end
    self.Warning = 0

    self.ban = function(areason, reason)

        exports.UNIQUE_AC:BanPlayer(self.source, reason, areason)
    end

    return self
end