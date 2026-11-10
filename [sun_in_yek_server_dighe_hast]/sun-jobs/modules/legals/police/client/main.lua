-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local CurrentTask             = {}
local callsign                = nil
local blip
local trackvehicle

local function OpenIdentityCardMenu()
    ESX.selectPlayerMenu(function(player)
		ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
            local elements    = {}
            local nameLabel   = _U(Shared.police.Locale, 'name', data.name:gsub('_',' '))
            local jobLabel    = nil
            local sexLabel    = nil
            local idLabel     = nil
            if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
                jobLabel = _U(Shared.police.Locale, 'job', data.job.label .. ' - ' .. data.job.grade_label)
            else
                jobLabel = _U(Shared.police.Locale, 'job', data.job.label)
            end
            if data.dob ~= nil then
                dobLabel = _U(Shared.police.Locale, 'dob', data.dob)
            else
                dobLabel = _U(Shared.police.Locale, 'dob', _U(Shared.police.Locale, 'unknown'))
            end
            if data.height ~= nil then
                heightLabel = _U(Shared.police.Locale, 'height', data.height)
            else
                heightLabel = _U(Shared.police.Locale, 'height', _U(Shared.police.Locale, 'unknown'))
            end

            local elements = {
                {label = nameLabel, value = data.name:gsub('_',' ')},
                {label = jobLabel,  value = nil},
            }

            if data.drunk ~= nil then
                table.insert(elements, {label = _U(Shared.police.Locale, 'bac', data.drunk), value = nil})
            end

            if data.licenses ~= nil then
                table.insert(elements, {label = _U(Shared.police.Locale, 'license_label'), value = nil})
                for i=1, #data.licenses, 1 do
                    table.insert(elements, {label = data.licenses[i].label, value = nil})
                end
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
                title    = _U(Shared.police.Locale, 'citizen_interaction'),
                align    = 'top-left',
                elements = elements,
            }, function(data, menu)
                if data.current.value then
                    exports['esx_carjob']:SetClipboard(data.current.value)
                end
            end, function(data, menu)
                menu.close()
            end)
        end, player)
	end, 5)
end

local function LookupVehicle()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
        title = _U(Shared.police.Locale, 'search_database_title'),
    }, function(data, menu)
        local length = string.len(data.value)
        if data.value == nil or length < 2 or length > 13 then
            ESX.ShowNotification(_U(Shared.police.Locale, 'search_database_error_invalid'))
        else
            ESX.TriggerServerCallback('police:getVehicleFromPlate', function(owner, found)
                if found then
                    ESX.ShowNotification(_U(Shared.police.Locale, 'search_database_found', owner))
                else
                    ESX.ShowNotification(_U(Shared.police.Locale, 'search_database_error_not_found'))
                end
            end, data.value)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function ShowPlayerLicense()
    ESX.selectPlayerMenu(function(player)
        exports['sunset_utils']:me('Mojavez haye fard ro check mikone',true)
        local elements = {}
        local targetName
        ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
            if data.licenses ~= nil then
                for i=1, #data.licenses, 1 do
                    if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
                        table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
                    end
                end
            end
            if Shared.police.EnableArmoryManagement then
                targetName = data.name
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
                title    = _U(Shared.police.Locale, 'license_revoke'),
                align    = 'top-left',
                elements = elements,
            }, function(data, menu)
                ESX.ShowNotification(_U(Shared.police.Locale, 'licence_you_revoked', data.current.label, targetName))
                TriggerServerEvent('police:message', player, _U(Shared.police.Locale, 'license_revoked', data.current.label))
                ExecuteCommand('removelicense '.. player .. ' ' .. data.current.value)
                ESX.SetTimeout(300, function()
                    ShowPlayerLicense()
                end)
                Citizen.Wait(1000)
                TriggerServerEvent('esx_dmvschool:updateLicense', player)
            end, function(data, menu)
                menu.close()
            end)
        end, player)
    end, 5)
end

local function OpenUnpaidBillsMenu()
    ESX.selectPlayerMenu(function(player)
        exports['sunset_utils']:me('Ghabz haye fard ro check mikone',true)
        local elements = {}

        ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
            for i=1, #bills, 1 do
                table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',  {
                    title    = _U(Shared.police.Locale, 'unpaid_bills'),
                    align    = 'top-left',
                    elements = elements
                }, function(data, menu)

                end, function(data, menu)
                    menu.close()
                end)
        end, player)
    end, 5)
end

local function OpenVehicleInfosMenu(vehicleData)
    ESX.TriggerServerCallback('police:getVehicleInfos', function(retrivedInfo)
        local elements = {}
        table.insert(elements, {label = _U(Shared.police.Locale, 'plate', retrivedInfo.plate), value = nil})

        if retrivedInfo.owner == nil then
            table.insert(elements, {label = _U(Shared.police.Locale, 'owner_unknown'), value = nil})
        else
            table.insert(elements, {label = _U(Shared.police.Locale, 'owner', retrivedInfo.owner), value = nil})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
            {
                title    = _U(Shared.police.Locale, 'vehicle_info'),
                align    = 'top-left',
                elements = elements
            }, nil, function(data, menu)
                menu.close()
        end)

    end, vehicleData.plate)
end

local silentMuteSpam = false
function openPoliceCitizenInteractionMenu()
    local elements = {
        {label = _U(Shared.police.Locale, 'drag'),			    value = 'drag'},
        {label = _U(Shared.police.Locale, 'handcuff'),		    value = 'handcuff'},
        {label = _U(Shared.police.Locale, 'search'),			value = 'body_search'},
        {label = _U(Shared.police.Locale, 'uncuff'),			value = 'uncuff'},
        {label = _U(Shared.police.Locale, 'put_in_vehicle'),	value = 'put_in_vehicle'},
        {label = _U(Shared.police.Locale, 'out_the_vehicle'),	value = 'out_the_vehicle'},
        {label = _U(Shared.police.Locale, 'id_card'),			value = 'identity_card'},
        {label = _U(Shared.police.Locale, 'silent_player'),		value = 'silent_player'},
        {label = _U(Shared.police.Locale, 'unpaid_bills'),	    value = 'unpaid_bills'},
    --{label = 'Sabeghe Keifari',      value = 'criminalrecords'},
    }
    if ESX.serverNum == 2 then
        table.insert(elements, {label = 'Darkhast Medic', value = 'medic_bot'})
    end
    if ESX.GetPlayerData().job.grade >= 4 then
        table.insert(elements,{label = 'Check body', value = 'info'})
    end
    if exports['sun-society']:doesHavePerm('checkBullet') then
        table.insert(elements,{label = 'Check near bullet', value = 'bullet'})
    end
    --   if Shared.police.EnableLicenses then
    table.insert(elements, { label = _U(Shared.police.Locale, 'license_check'), value = 'license' })
    --   end

    if ESX.doesHaveJobPerm('checkMedic') then
        table.insert(elements,{label = 'Check EMS request', value = 'EMSreq'})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
            title    = _U(Shared.police.Locale, 'citizen_interaction'),
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            if IsPedInAnyVehicle(PlayerPedId(), false) then return menu2.close() end
            local action = data2.current.value
            menu2.close()
            if action == 'identity_card' then
                ExecuteCommand('me ID Card Fard Ro Check Mikone')
                OpenIdentityCardMenu()
            elseif action == 'body_search' then
                exports['sun-inventory-hud']:openSearchMenu()
                TriggerServerEvent('3dme:shareDisplay2', 'Fard ro search mikone', true)
            elseif action == 'handcuff' then
                exports['sun-jobs']:cuffplayer(1)
            elseif action == 'uncuff' then
                exports['sun-jobs']:uncuffplayer(1)
            elseif action == 'drag' then
                exports['sun-jobs']:dragplayer()
            elseif action == 'put_in_vehicle' then
                exports['sun-jobs']:putinvehicle()
            elseif action == 'out_the_vehicle' then
                exports['sun-jobs']:putoutvehicle()
            elseif action == 'license' then
                menu2.close()
                openLicenseMenu()
            elseif action == 'silent_player' then
                if silentMuteSpam then
                    ESX.ShowNotification('Spam nakonid')
                    return
                end
                silentMuteSpam = true
                Citizen.SetTimeout(5000, function() silentMuteSpam = false end)
                ESX.selectPlayerMenu(function(target)
                    if target then
                        if ESX.GetPlayerState(target, 'Cuffed') then
                            TriggerServerEvent('police:togglemute', target)
                        else
                            ESX.Alert('Error', 'Fard mored nazar cuff nist', 5000, 'error')
                        end
                    end
                end, 5)
            elseif action == 'unpaid_bills' then
                OpenUnpaidBillsMenu()
            elseif action == 'info' then
                exports['sun-jobs']:GetClosetStat()
            elseif action == 'bullet' then
                ESX.UI.Menu.CloseAll()
                exports['sun-jobs']:GetClosestSerial()
            elseif action == 'medic_bot' then
                ESX.UI.Menu.CloseAll()
                medicBotMenu()
            elseif action == 'EMSreq' then
                ESX.UI.Menu.CloseAll()
                checkEMSRequest()
            end
    end, function(data2, menu)
        menu.close()
    end)
end

function openPoliceVehicleInteractionMenu()
    local elements  = {}
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    table.insert(elements, {label = _U(Shared.police.Locale, 'vehicle_info'),	value = 'vehicle_infos'})
    table.insert(elements, {label = _U(Shared.police.Locale, 'pick_lock'),	value = 'hijack_vehicle'})
    table.insert(elements, {label = _U(Shared.police.Locale, 'impound'),		value = 'impound'})

    table.insert(elements, {label = _U(Shared.police.Locale, 'search_database'), value = 'search_database'})
    table.insert(elements, {label = 'Dar avardan az impound', value = 'impound3'})
    table.insert(elements,  {label = 'Check Insurance', value = 'insurance'})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
        {
            title    = _U(Shared.police.Locale, 'vehicle_interaction'),
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            coords  = GetEntityCoords(playerPed)
            vehicle = ESX.Game.GetVehicleInDirection()
            action  = data2.current.value

            if action == 'search_database' then
                LookupVehicle()
            elseif action == 'impound3' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_id',
                    {
                        title = "pelak mashin ro vared kon"
                    },
                function(data1,menu1)
                    menu1.close()
                    if data1.value then
                        TriggerServerEvent("garage:setpdimpoundfalse",data1.value)
                    end
                end, function(data1,menu1)
                    menu1.close()
                end)
            elseif action == 'vehicle_infos' then
                ESX.selectVehicleMenu(function(vehicle)
                    OpenVehicleInfosMenu(ESX.Game.GetVehicleProperties(vehicle))
                end, 5)
            elseif action == 'hijack_vehicle' then
                if CurrentTask.Busy then return end
                ESX.selectVehicleMenu(function(vehicle)
                    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                        CurrentTask.Busy = true

                        Citizen.CreateThread(function()
                            while CurrentTask.Busy do
                                Wait(2000)
                                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 20 then
                                    ESX.ShowNotification('Mashin az shoma fasele gereft')
                                    TriggerEvent('mythic_progbar:client:cancel')
                                end
                            end
                          end)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "hijack_vehicle2",
                            duration = 30000,
                            label = "dar hal baz kardan dar haye mashin",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                        }, function(status)
                            if not status then
                                ClearPedTasksImmediately(playerPed)
                                SetVehicleDoorsLocked(vehicle, 1)
                                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                ESX.ShowNotification(_U(Shared.police.Locale, 'vehicle_unlocked'))
                                CurrentTask.Busy = false
                                TriggerEvent('esx_customItems:checkVehicleStatus', false)
                                SUN.log(('job_%s_hijack'):format(ESX.PlayerData.job.name),"Hijack car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " hijack kard")
                                SUN.log('alljack',"Hijack car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " hijack kard")
                            elseif status then
                                ClearPedTasksImmediately(playerPed)
                                CurrentTask.Busy = false
                                TriggerEvent('esx_customItems:checkVehicleStatus', false)
                            end
                        end)
                    end
                end, 5)
            elseif action == 'impound' then
                ESX.selectVehicleMenu(function(vehicle)
                    SUN.log(('job_%s_impound'):format(ESX.PlayerData.job.name),"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                    SUN.log('allimp',"Impound car",GetPlayerName(PlayerId()).." (".. ESX.PlayerData.name ..") (".. ESX.PlayerData.job.name ..") (".. GetPlayerServerId(PlayerId()) ..") ".. ESX.GetVehicleLabelFromHash(GetEntityModel(vehicle)) .. " pelak ".. GetVehicleNumberPlateText(vehicle) .. " impound kard")
                    exports["esx_vehiclecontrol"]:ImpoundPolice(vehicle)
                end, 5)
            elseif action == 'impound2' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_id', {
                        title = "zaman impound(az 1 ta 24 sa'at)"
                    }, function(data1,menu1)
                    menu1.close()
                    if tonumber(data1.value) then
                        local timee = tonumber(data1.value)
                        if timee < 1 or timee > 24 then
                            ESX.ShowNotification('zaman vared shode eshtebah ast (had aghal zaman 1 sa\'at had aksar zaman 24 sa\'at)')
                        else
                            local vehicle = ESX.Game.GetVehicleInDirection(6)
                            if vehicle == 0 then
                                TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'plarms')
                                return
                            end
                            exports["esx_vehiclecontrol"]:ImpoundPolice(vehicle,timee)
                        end
                    end
                end, function(data1,menu1)
                    menu1.close()
                end)
            elseif action == 'insurance' then
                ESX.selectVehicleMenu(function(vehicle)
                    exports['sun-jobs']:checkVehicleInsurance(vehicle)
                end, 5)
            end
    end, function(data2, menu2)
        menu2.close()
    end)
end

function medicBotMenu()
    ESX.selectPlayerMenu(function(src)
        TriggerServerEvent('medic:startReviveBot', src)
    end, 5, function()
        return ESX.GetPlayerState(src, 'isInjure')
    end)
end

RegisterNetEvent('police:notifyp', function(message, passedJob,share)
    if ESX.PlayerData.job.name == passedJob then
        if share then
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH SHARE]", message}}, 'dispatch')
        else
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}}, 'dispatch')
        end
    end
end)

RegisterNetEvent('police:playSound', function(file, volume, passedJob,ext)
    if ext then ExecuteCommand("resp ".. ext) end
    if not passedJob then
        if ESX.PlayerData.job.name == "police"  then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    else
        if ESX.PlayerData.job.name == passedJob then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    end
end)


-- AddEventHandler("onKeyUP",function(key)
--     if key == "e" and isback ~= nil then
--         SetNewWaypoint(isback.x,isback.y)
--         SetNewWaypoint(isback.x,isback.y)
--     end
-- end)
RegisterCommand('bc',function(src,args)
    if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == "sheriff" or ESX.PlayerData.job.name == "mt" or ESX.PlayerData.job.name == "detective" or ESX.PlayerData.job.name == "justice" then
        if doesHaveUnit() then
            local ped = PlayerPedId()
            local backup = {
                type = "code1",
            }
            TriggerServerEvent("police:addbackup", backup)
            TriggerServerEvent('3dme:shareDisplay2', "Dastesho mibare be samte radio va dokme panic ro feshar mide", true)
        else
            ESX.ShowNotification('Shoma dar uniti nistid!')
        end
    end
end, false)

RegisterCommand('pc',function(src,args)
    if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == "sheriff" or ESX.PlayerData.job.name == "mt" or ESX.PlayerData.job.name == "detective" or ESX.PlayerData.job.name == "justice" then
        if doesHaveUnit() then
            local ped = PlayerPedId()
            local backup = {
                type = "code1",
                pc = true,
            }
            TriggerServerEvent("police:addbackup", backup)
            TriggerServerEvent('3dme:shareDisplay2', "Dastesho mibare be samte radio va dokme panic ro feshar mide", true)
        else
            ESX.ShowNotification('Shoma dar uniti nistid!')
        end
    end
end, false)

local ___shot = {
    ['police'] = true,
    ['sheriff'] = true,
    ['mt'] = true,
    ['detective'] = true,
}

local ___allow = {
    [0] = {
        [116] = true, -- PD
        [117] = true, -- PD
        [118] = true, -- PD
        [119] = true, -- PD
    },
    [1] = {
        [115] = true, -- PD
        [116] = true, -- PD
        [117] = true, -- PD
        [118] = true, -- PD
    },
}
local __flag = false
Citizen.CreateThread(function()
    repeat Wait(100) until ESX ~= nil
	while true do
		Citizen.Wait(5000)
		local ped = PlayerPedId()
        SetPedCanLosePropsOnDamage(ped, false, 0)
        if not exports['sunset_utils']:checkArmoredHelmetActive() then
            if ___shot[ESX.PlayerData.job.name] then
                TriggerEvent('skinchanger:getSkin',function(cb)
                    if ___allow[cb.sex][cb.helmet_1] then
                        __flag = false
                        SetPedConfigFlag(ped, 438, false)
                        ESX.SetPlayerData('IsSwat', 1)
                    else
                        __flag = true
                        SetPedConfigFlag(ped, 438, true)
                        ESX.SetPlayerData('IsSwat', 0)
                    end
                end)
            else
                __flag = true
                SetPedConfigFlag(ped, 438, true)
                ESX.SetPlayerData('IsSwat', 0)
            end
        end
	end
end)

AddEventHandler('removeSwatHelmet', function()
    if not __flag then
        __flag = true
        SetPedConfigFlag(PlayerPedId(), 438, true)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin, {helmet_1 = -1, helmet_2 = 0})
        end)
    end
end)

RegisterCommand('sl', function(source, args, user)
	if args[1] then
		if tonumber(args[1]) then
			local target = tonumber(args[1])
			if not ESX.Game.PlayerExist(target) then return end
			if GetPlayerFromServerId(target) ~= -1 then
				if target ~= GetPlayerServerId(PlayerId()) then
					local coords = GetEntityCoords(GetPlayerPed(-1))
					local tcoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
					if #(coords - tcoords) < 2 then
						TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "^0Shoma madarek khod ra be ^3" .. target ..  " ^0neshan dadid!", 'plarms')
						TriggerServerEvent('esx_showlicense:ShowTheLicense', target)
                        exports['sun-animmenu']:PlayEmote('pointdown',true)
					else
						TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "^0Player mored nazar nazdik shoma nist", 'plarms')
					end
				else
					TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid Madarek ra be khodetan neshan dahid", 'plarms')
				end
			else
				TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast", 'plarms')
			end
		else
			TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "^0Shoma dar ghesmat ID fagat mitavanid adad vared konid", 'plarms')
		end
	else
		TriggerServerEvent('esx_showlicense:ShowTheLicense', GetPlayerServerId(PlayerId()))
	end
end, false)

function checkEMSRequest()
    ESX.selectPlayerMenu(function(targetSrc)
        if not (ESX.GetPlayerState(targetSrc, 'isInjure') or ESX.GetPlayerState(targetSrc, 'isDead')) then
            return ESX.chatMessage('Fard zende ast', 'plarms')
        end
		ESX.TriggerServerCallback('medic:checksignal2',function(state, name)
            if state then
                if name then
                    ESX.chatMessage(('Darkhast EMS tavasot %s accept shode'):format(name), 'plarms')
                else
                    ESX.chatMessage('Fard darkhast EMS ersal karde ast, vali kasi accept nakarde ast', 'plarms')
                end
            else
                local alert = lib.alertDialog({
                    header = 'Darkhast EMS',
                    content = 'Fard mored nazar darkhast EMS ersal nakarde ast, aya mayel be ersal darkhast hastid?',
                    centered = true,
                    cancel = true
                })
                if alert == 'confirm' then
                    TriggerServerEvent('medic:job:forceReuqest', targetSrc)
                    ESX.chatMessage('Darkhast ersal shod', 'plarms')
                end
            end
        end, targetSrc)
	end, 5)
end