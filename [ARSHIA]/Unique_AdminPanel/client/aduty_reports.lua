local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

local result = ""

local function IsMenuOpen()
	return (JayMenu.IsMenuOpened('report') or string.find(tostring(JayMenu.CurrentMenu() or ""), "REPORT_"))
end

local function Display()
	if JayMenu.IsMenuOpened('report') then
		for k, v in ipairs(Config_RPS.ReportCats) do
			JayMenu.MenuButton(v[2], v[1])
		end
		JayMenu.Display()
	end

	for k, v in ipairs(Config_RPS.ReportCats) do
		if JayMenu.IsMenuOpened(v[1]) then
			local clicked, hovered = JayMenu.Button("Report Reason", "~HUD_COLOUR_RED~"..v[2])
			if v[1] == "REPORT_MORE" then
				local clicked, hovered = JayMenu.Button("Type Your Report")
				if clicked then
					DisplayOnscreenKeyboard(1, "", "", result, "", "", "", 128)
					while (UpdateOnscreenKeyboard() == 0) do
						DisableAllControlActions(0);
						Wait(0);
					end
					if (GetOnscreenKeyboardResult()) then
						result = GetOnscreenKeyboardResult()
					end
				end
			end
			local clicked, hovered = JayMenu.Button("~HUD_COLOUR_GREEN~Send Report")
			if clicked and v[1] == "REPORT_MORE" then
				if #result < 10 then
					lib.notify({ position = 'center-right', title = "ERROR", description = "Lotfan hadaghal 10 character darbare report khod benevisid!", type = 'error', duration = 5000 })
				else
					print(1)
					print(GetPlayerName(source))
					TriggerServerEvent('esx_Report:CreateReport', v[2], result)
					JayMenu.CloseMenu()
					result = ""
					TriggerEvent('chat:addMessage', {
						template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(3, 207, 216, 0.4); border-radius: 3px; font-weight: bold;"><i class="fas fa-exclamation-triangle"></i> [REPORT SYSTEM]<br>  {0}</div>',
						args = {'گزارش شما ارسال شد تا دریافت پاسخ صبور باشید و اگر در ارپی هستید تحت هر شرایطی به ارپی خود ادامه دهید'}
					})
				end
			elseif clicked then
				TriggerServerEvent('esx_Report:CreateReport', v[2])
				JayMenu.CloseMenu()
				result = ""
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(3, 207, 216, 0.4); border-radius: 3px; font-weight: bold;"><i class="fas fa-exclamation-triangle"></i> [REPORT SYSTEM]<br>  {0}</div>',
					args = {'گزارش شما ارسال شد تا دریافت پاسخ صبور باشید و اگر در ارپی هستید تحت هر شرایطی به ارپی خود ادامه دهید'}
				})
			end
			JayMenu.Display()
		end
	end
	if IsMenuOpen() then
		SetTimeout(0, Display)
	end
end

local function OpenMenu()
	if not IsMenuOpen() then
		JayMenu.OpenMenu('report')
		Display()
	end
end

function onEvent(event, ...)
	RegisterNetEvent(event)
	AddEventHandler(event, ...)
end

onEvent('sr_reportsystem:openMenu', OpenMenu)

Citizen.CreateThread(function()
	JayMenu.CreateMenu("report", "Report Menu", function()
		result = ""
		return true
	end)
	JayMenu.SetTitleColor('report', 255, 113, 0, 255)
	JayMenu.SetSubTitle('report', 'Choose Your Report')
	for k, v in ipairs(Config_RPS.ReportCats) do
		JayMenu.CreateSubMenu(v[1], 'report', v[2])
		JayMenu.SetSubTitle(v[1], v[2])
	end
end)

RegisterNetEvent("esx_Report:ManageReports")
AddEventHandler("esx_Report:ManageReports", function(data)

	OpenMenu(data)
end)

function OpenMenu(info)

	for k, v in pairs(info) do
		if v.category == "More" then
			TriggerEvent('chat:addMessage', {args = {"^1[System]: ^0Report : ^2"..v.owner.name.."^0(^5"..v.owner.id.."^0) : (^2"..v.Detail.." ^0)"}})
		else
			TriggerEvent('chat:addMessage', {args = {"^1[System]: ^0Report : ^2"..v.owner.name.."^0(^5"..v.owner.id.."^0) : ( ^2"..v.category.." ^0)"}})
		end
	end
end

function GiveInformation(cb, data, id)
	local ped = PlayerPedId()
	for k, v in pairs(data) do
		if k == id then
			if v.Detail == nil then
				if v.status == "open" then
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('esx_Report:Pending', id,ped)
				break
				else
					print(123)
					ESX.UI.Menu.CloseAll()
				end
			else
				cb(v.Detail)
				TriggerServerEvent('esx_Report:Pending', id)
				break
			end
		end
	end
end

RegisterNetEvent('esx_Report:spectate')
AddEventHandler('esx_Report:spectate', function(tid)
local ped = PlayerPedId()
NetworkSetInSpectatorMode(true, ped)
end)

RegisterNetEvent('esx_Report:spectate')
AddEventHandler('esx_Report:spectate', function()
	ESX.UI.Menu.CloseAll()
end)