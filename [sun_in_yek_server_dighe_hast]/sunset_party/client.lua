-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
end)

RegisterNetEvent('party:open')
AddEventHandler('party:open',function(data)
    local configs = {
		size = 0.8,
		positionY = "30%"
	}
	List = {}
	local myid = GetPlayerServerId(PlayerId())
	local imleader = data[myid].level == "leader"
	for k , v in pairs(data) do
		if v.level == "leader" then
			table.insert(List,{
				img = "SS_gold.png",
				text = v.name:gsub("_"," ") .. " (Leader)", 
                text2 = v.nameooc .."(".. k ..")", 
				callBack = function()
					if imleader then
						List = {}
						table.insert(List,{
							img = "kick.png",
							text = 'Kick', 
							text2 = 'Kick', 
							callBack = function()
								TriggerServerEvent('party:kick',k)
								exports.icon_menu:ForceCloseMenu()
						end})
						exports.icon_menu:OpenMenu(List, configs)
					end
			end})
		end
	end
	for k , v in pairs(data) do
		if v.level == "member" then
			table.insert(List,{
				img = "SS_white.png",
				text = v.name:gsub("_"," "), 
                text2 = v.nameooc .."(".. k ..")", 
				callBack = function()
					if imleader then
						List = {}
						table.insert(List,{
							img = "delete.png",
							text = 'Kick', 
							text2 = 'Kick', 
							callBack = function()
								TriggerServerEvent('party:kick',k)
								exports.icon_menu:ForceCloseMenu()
						end})
						exports.icon_menu:OpenMenu(List, configs)
					end                    
			end})
		end
	end
	table.insert(List,{
		img = "back.png",
		text = 'Leave', 
		text2 = 'Leave from party', 
		callBack = function()
			TriggerServerEvent('party:leave')   
			exports.icon_menu:ForceCloseMenu()                 
	end})
	exports.icon_menu:OpenMenu(List, configs)
end)