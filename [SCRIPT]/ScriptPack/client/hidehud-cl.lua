local bigmap = false
local HUD_ELEMENTS = {
    HUD = { id = 0, hidden = false },
    HUD_WANTED_STARS = { id = 1, hidden = true },
    HUD_WEAPON_ICON = { id = 2, hidden = true },
    HUD_CASH = { id = 3, hidden = true },
    HUD_MP_CASH = { id = 4, hidden = true },
    HUD_MP_MESSAGE = { id = 5, hidden = true },
    HUD_VEHICLE_NAME = { id = 6, hidden = true },
    HUD_AREA_NAME = { id = 7, hidden = true },
    HUD_VEHICLE_CLASS = { id = 8, hidden = true },
    HUD_STREET_NAME = { id = 9, hidden = true },
    HUD_FLOATING_HELP_TEXT_1 = { id = 11, hidden = false },
    HUD_FLOATING_HELP_TEXT_2 = { id = 12, hidden = false },
    HUD_CASH_CHANGE = { id = 13, hidden = true },

    HUD_SUBTITLE_TEXT = { id = 15, hidden = false },

    HUD_SAVING_GAME = { id = 17, hidden = false },
    HUD_GAME_STREAM = { id = 18, hidden = false },
    HUD_WEAPON_WHEEL = { id = 19, hidden = false },
    HUD_WEAPON_WHEEL_STATS = { id = 20, hidden = true },
    MAX_HUD_COMPONENTS = { id = 21, hidden = false },
    MAX_HUD_WEAPONS = { id = 22, hidden = false },
    MAX_SCRIPTED_HUD_COMPONENTS = { id = 141, hidden = false }
}

local HUD_HIDE_RADAR_ON_FOOT = true

Citizen.CreateThread(function()
	-- ✅ فیکس شد: HideHudComponentThisFrame/ShowHudComponentThisFrame فقط
	-- یک فریم اثر دارن و باید هر فریم دوباره صدا زده بشن. قبلاً این حلقه
	-- فقط یک‌بار اجرا می‌شد (بدون while true)، پس بعد از فریم اول بازی
	-- خودش دوباره HUD_VEHICLE_NAME / HUD_VEHICLE_CLASS / HUD_AREA_NAME /
	-- HUD_WANTED_STARS و... رو نشون می‌داد - دقیقاً همونایی که گوشه‌ی
	-- پایین‌چپ (نزدیک مینی‌مپ) ظاهر می‌شن و باعث می‌شن موقع سوار شدن به
	-- ماشین، آیکون‌های اضافه روی مینی‌مپ بیفتن.
	while true do
		for key, val in pairs(HUD_ELEMENTS) do
			if val.hidden then
				HideHudComponentThisFrame(val.id)s
			else
				ShowHudComponentThisFrame(val.id)
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
            local player = PlayerPedId()
        if(IsPedInAnyVehicle(player, false)) then
            local speed = GetEntitySpeed(player);
			local kmh = speed * 3.6;
			if kmh > 100 then
				if bigmap == true then
					SetRadarZoomLevelThisFrame(500 + kmh)
				else
					SetRadarZoomLevelThisFrame(50 + kmh)
				end
			end
        end

    end
end)