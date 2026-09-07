local Keys = {
	["ESC"] = 322,
	["F1"] = 288,
	["F2"] = 289,
	["F3"] = 170,
	["F5"] = 166,
	["F6"] = 167,
	["F7"] = 168,
	["F8"] = 169,
	["F9"] = 56,
	["F10"] = 57,
	["~"] = 243,
	["1"] = 157,
	["2"] = 158,
	["3"] = 160,
	["4"] = 164,
	["5"] = 165,
	["6"] = 159,
	["7"] = 161,
	["8"] = 162,
	["9"] = 163,
	["-"] = 84,
	["="] = 83,
	["BACKSPACE"] = 177,
	["TAB"] = 37,
	["Q"] = 44,
	["W"] = 32,
	["E"] = 38,
	["R"] = 45,
	["T"] = 245,
	["Y"] = 246,
	["U"] = 303,
	["P"] = 199,
	["["] = 39,
	["]"] = 40,
	["ENTER"] = 18,
	["CAPS"] = 137,
	["A"] = 34,
	["S"] = 8,
	["D"] = 9,
	["F"] = 23,
	["G"] = 47,
	["H"] = 74,
	["K"] = 311,
	["L"] = 182,
	["LEFTSHIFT"] = 21,
	["Z"] = 20,
	["X"] = 73,
	["C"] = 26,
	["V"] = 0,
	["B"] = 29,
	["N"] = 249,
	["M"] = 244,
	[","] = 82,
	["."] = 81,
	["LEFTCTRL"] = 36,
	["LEFTALT"] = 19,
	["SPACE"] = 22,
	["RIGHTCTRL"] = 70,
	["HOME"] = 213,
	["PAGEUP"] = 10,
	["PAGEDOWN"] = 11,
	["DELETE"] = 178,
	["LEFT"] = 174,
	["RIGHT"] = 175,
	["TOP"] = 27,
	["DOWN"] = 173,
	["NENTER"] = 201,
	["N4"] = 108,
	["N5"] = 60,
	["N6"] = 107,
	["N+"] = 96,
	["N-"] = 97,
	["N7"] = 117,
	["N8"] = 61,
	["N9"] = 118
}


ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(2)
	end
end)

local registeredKeys = {}

local keysHolding = {}

local KeysWhiteList = {["g"] = true, ["t"] = true}

local currentKeysHolding = {}



RegisterNetEvent("onKeyDown")

RegisterNetEvent("onKeyUP")

RegisterNetEvent("onMultiplePress")



function registerKey(key, type)

	local command = key .. "donttouch"


	if not registeredKeys[key] then

		registeredKeys[key] = true

		RegisterKeyMapping('+' .. command, "Edit Nakonid | Key : "..key.." | No Edit !", type, key)

	end

        

	RegisterCommand('+' .. command, function()

		if not IsPauseMenuActive() and not DisableControlAction(0, Keys[key], true) then

			if shouldSendTheKey(key) then

				TriggerEvent("onKeyDown", key)

			end

			

			table.insert(keysHolding, key)

			currentKeysHolding[key] = true



			if #keysHolding > 1 then

				TriggerEvent("onMultiplePress", currentKeysHolding)

			end



		end

	end)

	

	RegisterCommand('-' .. command, function()

		if not IsPauseMenuActive() and not DisableControlAction(0, Keys[key], true) then

			TriggerEvent("onKeyUP", key)

		end



		if currentKeysHolding[key] then

			removeKey(key)

			currentKeysHolding[key] = nil

		end

	end)

end



function removeKey(key)

	for index, currentKey in ipairs(keysHolding) do

		if currentKey == key then

			table.remove(keysHolding, index)

		end

	end

end



function shouldSendTheKey(key)

	if KeysWhiteList[key] then

		return true

	else

		local data = ESX.GetPlayerData()
		

		if data.HandCuffed ~= 1 then

			return true

		else

			return false

		end

	end

end



local haveToRegister = {

	["e"] = "keyboard",

	["k"] = "keyboard",

	["numpad4"] = "keyboard",

	["numpad5"] = "keyboard",

	["numpad6"] = "keyboard",

	["numpad7"] = "keyboard",

	["numpad8"] = "keyboard",

	["numpad9"] = "keyboard",

	["x"] = "keyboard",

	["l"] = "keyboard",

	["f"] = "keyboard",

	["r"] = "keyboard",

	["lmenu"] = "keyboard",

	["f1"] = "keyboard",

	["f2"] = "keyboard",

	["f3"] = "keyboard",

	["f4"] = "keyboard",

	["f5"] = "keyboard",

	["f6"] = "keyboard",

	["f7"] = "keyboard",

	["f9"] = "keyboard",

	["f10"] = "keyboard",

	["f11"] = "keyboard",

	["escape"] = "keyboard",

	["t"] = "keyboard",

	["y"] = "keyboard",

	["g"] = "keyboard",

	["9"] = "keyboard",

	["b"] = "keyboard",

	['oem_3'] = "keyboard",

	["lcontrol"] = "keyboard",

	["lshift"] = "keyboard",

	["return"] = "keyboard",

	["back"] = "keyboard",

	["up" ] = "keyboard",

	["right"] = "keyboard",

	["left" ] = "keyboard",

	["down"] = "keyboard",

	["mouse_left"] = "mouse_button",

	["mouse_right"] = "mouse_button",

	["delete"] = "keyboard",

	["z"] = "keyboard",

	["home"] = "keyboard",

	["end"] = "keyboard",

	["u"] = "keyboard",
	
	["i"] = "keyboard",

	["capital"] = "keyboard",

	["tab"] = "keyboard",
}



for key, type in pairs(haveToRegister) do

	registerKey(key, type)

end