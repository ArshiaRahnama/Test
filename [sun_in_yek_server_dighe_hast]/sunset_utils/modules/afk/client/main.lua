-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local afkThreadState = false
Citizen.CreateThread(function()
	waitForLoad()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    local job = ESX.GetPlayerData().job.name
    if ESX.GetPlayerData().job.name ~= 'nojob' and not string.find(ESX.GetPlayerData().job.name,'off') and ESX.GetPlayerData().job.name ~= 'resturan' and job ~= 'wash' and job ~= 'carbimeh' and not (job == 'fbi' and ESX.GetPlayerData().job.grade >= 13) then
        if not afkThreadState then
            afkThreadState = true
            afkThread()
        end
    end
end)

RegisterNetEvent('esx:setJob',function(job)
    if job.name ~= 'nojob' and not string.find(job.name,'off') and job.name ~= 'resturan' and job.name ~= 'wash' and job.name ~= 'carbimeh' and not (job.name == 'fbi' and job.grade >= 13) then
        if not afkThreadState then
            afkThreadState = true
            afkThread()
        end
    else
        afkThreadState = false
    end
end)

local prevPos
local info = {
	warnings = 0,
	warned = false,
	timer = 0,
	maths = {
		result = 0
	},
	fail = 0
}

function afkThread()
    Citizen.CreateThread(function()
        while afkThreadState do
            Citizen.Wait(1000)
            local ped = PlayerPedId()
            local position = GetEntityCoords(ped)
            if prevPos then
                local distance = Vdist(position, prevPos)
                if distance <= 2 and ESX.GetPlayerData()['IsDead'] ~= 1 then
                    info.warnings = info.warnings + 1
                    if info.warnings >= 1200 then
                        if not info.warned then
                            info.timer = 120
                            info.maths.a = math.random(1, 10)
                            info.maths.b = math.random(1, 10)
                            info.maths.result = info.maths.a + info.maths.b
                            TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. info.timer .. " ^0saniye digar be elaat ^1AFK ^0bodan off duty mishavid, lotfan az makan fe'eli khod ta hengami ke peygham afk ra daryaft konid jabeja shavid ya be soal robero javab dahid ^3/afk ^2" .. info.maths.a .. "^0+^4" .. info.maths.b .. "^0", 'plarms')
                            info.warned = true
                        else
                            info.timer = info.timer - 1
                            if info.timer <= 0 then
                                afkOffDuty()
                                --break
                            end
    
                            if info.timer == 60 or info.timer == 30 or info.timer == 10 then
                                TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma ^2" .. info.timer .. " ^0saniye digar be elaat ^1AFK ^0bodan off duty mishavid, lotfan az makan fe'eli khod ta hengami ke peygham afk ra daryaft konid jabeja shavid ya be soal robero javab dahid ^3/afk ^2" .. info.maths.a .. "^0+^4" .. info.maths.b .. "^0", 'plarms')
                            end
                        end
                    end
                else
                    if info.warned then
                        resetAFK()
                    else
                        info = {warnings = 0, warned = false, timer = 0, maths = {result = 0}, fail = 0}
                    end
                end
            end
            prevPos = position
        end
    end)
end

local failLimit = 3
RegisterCommand("afk", function(source, args)
	if info.warned then
		if not args[1] then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab chizi vared nakardid!", 'plarms')
		end

		if not tonumber(args[1]) then
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat javab faghat mitavanid adad vared konid!", 'plarms')
		end

		local input = tonumber(args[1])

		if input == info.maths.result then
			resetAFK()
		else
			info.fail = info.fail + 1
			if info.fail > 3 then
				afkOffDuty()
				return
			end
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Javab vared shode eshtebah bod, shoma ^2" .. failLimit - info.fail .. "^0 bar digar ^3forsat^0 javab darid!", 'plarms')
		end
	else
		TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma hich afk math acitivi nadarid!", 'plarms')
	end
end, false)

function afkOffDuty()
	TriggerServerEvent('duty:toggle', 'afk')
    ExecuteCommand('f [Auto message] man be dalil afk off duty shodam.')
    afkThreadState = false
end

function resetAFK()
	TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma digar be onvan karbar ^1AFK ^0hesab ^2nemishavid^0!", 'plarms')
	info = {warnings = 0, warned = false, timer = 0, maths = {result = 0}, fail = 0}
end