
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	local dict = "missminuteman_1ig_2"

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	local handsup = false
	local lastToggle = 0
	local TOGGLE_COOLDOWN = 450 -- ms - spamming X with no gap between ClearPedTasks and the
	-- next TaskPlayAnim never let the previous anim finish blending, which is what caused
	-- the character to glitch/spin ("گیج" شدن) when X was pressed several times fast.

	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		-- these only take effect for the single frame they're called in, so they have
		-- to be re-applied every tick while hands are up, not just once on toggle-in
		if handsup then
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(playerPed, true)
		end

		if IsControlJustPressed(1, Keys['X']) and GetLastInputMethod(2) and IsPedOnFoot(playerPed) and not IsPedArmed(playerPed, 7) then
			local now = GetGameTimer()
			if now - lastToggle >= TOGGLE_COOLDOWN then
				lastToggle = now
				if not handsup then
					-- blendInSpeed of 2.0 (~0.5s) makes the arms visibly rise instead of
					-- snapping instantly; the old 0.0 value caused the instant "jump" to
					-- full pose that was reported as the animation happening all at once
					TaskPlayAnim(playerPed, dict, "handsup_enter", 2.0, -4.0, -1, 50, 0, false, false, false)
					handsup = true
				else
					handsup = false
					ClearPedTasks(playerPed)
				end
			end
		end
		if handsup and IsPedArmed(playerPed, 7) then
			handsup = false
			ClearPedTasks(playerPed)
		end
		if handsup and IsPedInAnyVehicle(playerPed, false) then
			handsup = false
			ClearPedTasks(playerPed)
		end
	end
end)