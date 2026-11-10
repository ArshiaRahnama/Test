-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Debugger = {
	speedBuffer = {},
	speed = 0.0,
	accel = 0.0,
	decel = 0.0,
}

--[[ Functions ]]--
function TruncateNumber(value)
	value = value * Config.Precision

	return (value % 1.0 > 0.5 and math.ceil(value) or math.floor(value)) / Config.Precision
end

function Debugger:Set(vehicle)
	self.vehicle = vehicle
	self:ResetStats()

	local model = GetEntityModel(vehicle)
	if self.originals == nil then self.originals = {} end
	local capture = self.originals[model] == nil
	if capture then self.originals[model] = {} end

	local handlingText = ""

	-- Loop fields.
	for key, field in pairs(Config.Fields) do
		-- Get field type.
		local fieldType = Config.Types[field.type]
		if fieldType == nil then error("no field type") end

		-- Get value.
		local value = fieldType.getter(vehicle, "CHandlingData", field.name)
		if capture then
			self.originals[model][key] = value
		end
		if type(value) == "vector3" then
			value = ("%s,%s,%s"):format(value.x, value.y, value.z)
		elseif field.type == "float" then
			value = TruncateNumber(value)
		end

		-- Get input.
		local input = ([[
			<input
				oninput='updateHandling(this.id, this.value)'
				id='%s'
				value=%s
			>
			</input>
		]]):format(key, value)
		
		-- Append text.
		handlingText = handlingText..([[
			<div class='tooltip'><span class='tooltip-text'>%s</span><span>%s</span>%s</div>
		]]):format(field.description or "Unspecified.", field.name, input)
	end

	-- Update text.
	self:Invoke("updateText", {
		["handling-fields"] = handlingText,
	})
end

function Debugger:UpdateVehicle()
	local ped = PlayerPedId()
	local isInVehicle = IsPedInAnyVehicle(ped, false)
	local vehicle = isInVehicle and GetVehiclePedIsIn(ped, false)

	if self.isInVehicle ~= isInVehicle or self.vehicle ~= vehicle then
		self.vehicle = vehicle
		self.isInVehicle = isInVehicle

		if isInVehicle and DoesEntityExist(vehicle) then
			self:Set(vehicle)
		end
	end
end

function Debugger:UpdateInput()
	if self.hasFocus then
		DisableControlAction(0, 1)
		DisableControlAction(0, 2)
	end
end

function Debugger:UpdateAverages()
	if not DoesEntityExist(self.vehicle or 0) then return end

	-- Get the speed.
	local speed = GetEntitySpeed(self.vehicle)
	
	-- Speed buffer.
	table.insert(self.speedBuffer, speed)

	if #self.speedBuffer > 100 then
		table.remove(self.speedBuffer, 1)
	end

	-- Calculate averages.
	local accel = 0.0
	local decel = 0.0
	local accelCount = 0
	local decelCount = 0

	for k, v in ipairs(self.speedBuffer) do
		if k > 1 then
			local change = (v - self.speedBuffer[k - 1])
			if change > 0.0 then
				accel = accel + change
				accelCount = accelCount + 1
			else
				decel = accel + change
				decelCount = decelCount + 1
			end
		end
	end

	accel = accel / accelCount
	decel = decel / decelCount

	-- Set tops.
	self.speed = math.max(self.speed, speed)
	self.accel = math.max(self.accel, accel)
	self.decel = math.min(self.decel, decel)

	-- Update text.
	self:Invoke("updateText", {
		["top-speed"] = self.speed * 2.236936,
		["top-accel"] = self.accel * 60.0 * 2.236936,
		["top-decel"] = math.abs(self.decel) * 60.0 * 2.236936,
	})
end

function Debugger:ResetStats()
	self.speed = 0.0
	self.accel = 0.0
	self.decel = 0.0
	self.speedBuffer = {}
end

function Debugger:ResetHandling()
	local vehicle = self.vehicle
	if not DoesEntityExist(vehicle or 0) then return end

	local originals = self.originals and self.originals[GetEntityModel(vehicle)]
	if originals == nil then return end

	for key, field in pairs(Config.Fields) do
		local value = originals[key]
		if value ~= nil then
			local fieldType = Config.Types[field.type]
			if type(value) == "vector3" then
				fieldType.setter(vehicle, "CHandlingData", field.name, ("%s,%s,%s"):format(value.x, value.y, value.z))
			else
				fieldType.setter(vehicle, "CHandlingData", field.name, value)
			end
		end
	end

	ModifyVehicleTopSpeed(vehicle, 1.0)
	self:Set(vehicle)
end

function Debugger:ImportHandling(text)
	local vehicle = self.vehicle
	if not DoesEntityExist(vehicle or 0) then return end
	if type(text) ~= "string" then return end

	local byName = {}
	for _, field in pairs(Config.Fields) do
		byName[field.name] = field
	end

	for name, body in text:gmatch("<([%w_]+)([^>]*)>") do
		local field = byName[name]
		if field ~= nil then
			local fieldType = Config.Types[field.type]
			if fieldType ~= nil then
				if field.type == "vector" then
					local x = body:match('x="([^"]*)"')
					local y = body:match('y="([^"]*)"')
					local z = body:match('z="([^"]*)"')
					if tonumber(x) and tonumber(y) and tonumber(z) then
						fieldType.setter(vehicle, "CHandlingData", field.name, ("%s,%s,%s"):format(x, y, z))
					end
				else
					local v = body:match('value="([^"]*)"')
					if tonumber(v) ~= nil then
						fieldType.setter(vehicle, "CHandlingData", field.name, v)
					end
				end
			end
		end
	end

	ModifyVehicleTopSpeed(vehicle, 1.0)
	self:Set(vehicle)
end

function Debugger:SetHandling(key, value)
	if not DoesEntityExist(self.vehicle or 0) then return end

	-- Get field.
	local field = Config.Fields[key]
	if field == nil then error("no field") end

	-- Get field type.
	local fieldType = Config.Types[field.type]
	if fieldType == nil then error("no field type") end

	-- Set field.
	fieldType.setter(self.vehicle, "CHandlingData", field.name, value)

	-- Needed for some values to work.
	ModifyVehicleTopSpeed(self.vehicle, 1.0)
end

function Debugger:CopyHandling()
	local text = ""

	-- Line writer.
	local function writeLine(append)
		if text ~= "" then
			text = text.."\n\t\t\t"
		end
		text = text..append
	end

	-- Get vehicle.
	local vehicle = self.vehicle
	if not DoesEntityExist(vehicle) then return end

	-- Loop fields.
	for key, field in pairs(Config.Fields) do
		-- Get field type.
		local fieldType = Config.Types[field.type]
		if fieldType == nil then error("no field type") end

		-- Get value.
		local value = fieldType.getter(vehicle, "CHandlingData", field.name, true)
		local nValue = tonumber(value)

		-- Append text.
		if nValue ~= nil then
			writeLine(("<%s value=\"%s\" />"):format(field.name, field.type == "float" and TruncateNumber(nValue) or nValue))
		elseif field.type == "vector" then
			writeLine(("<%s x=\"%s\" y=\"%s\" z=\"%s\" />"):format(field.name, value.x, value.y, value.z))
		end
	end

	-- Copy text.
	self:Invoke("copyText", text)
end

function Debugger:Focus(toggle)
	SetNuiFocus(toggle, toggle)
	SetNuiFocusKeepInput(toggle)
	
	self.hasFocus = toggle
	threads()
	self:Invoke("setFocus", toggle)
end

function Debugger:Invoke(_type, data)
	SendNUIMessage({
		callback = {
			type = _type,
			data = data,
		},
	})
end

--[[ Threads ]]--
function threads()
	Citizen.CreateThread(function()
		while Debugger.hasFocus do
			Citizen.Wait(1000)
			Debugger:UpdateVehicle()
		end
	end)
	
	Citizen.CreateThread(function()
		while Debugger.hasFocus do
			if Debugger.isInVehicle then
				Citizen.Wait(0)
				Debugger:UpdateInput()
				Debugger:UpdateAverages()
			else
				Citizen.Wait(500)
			end
		end
	end)
end

--[[ NUI Events ]]--
RegisterNUICallback("updateHandling", function(data, cb)
	cb(true)
	Debugger:SetHandling(tonumber(data.key), data.value)
end)

RegisterNUICallback("copyHandling", function(data, cb)
	cb(true)
	Debugger:CopyHandling()
end)

RegisterNUICallback("resetHandling", function(data, cb)
	cb(true)
	Debugger:ResetHandling()
end)

RegisterNUICallback("importHandling", function(data, cb)
	cb(true)
	Debugger:ImportHandling(data.text)
end)

--[[ Commands ]]--
RegisterNetEvent('openVehicleDebugger',function()
	if not Debugger.hasFocus then
		Debugger:Focus(true)
	end
end)

RegisterNetEvent('sun-vehicle-debugger:close',function()
	if Debugger.hasFocus then
		Debugger:Focus(false)
	end
end)