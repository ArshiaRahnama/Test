

local Keys_cad = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

ESX = nil
local PlayerData_cad = {}
local MdtDisplay_cad = false

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData_cad = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData_cad.job = job
end)

local function CheckPerm_cad()
    -- BUG FIX: this used to only block a non-job player when
    -- DuckMdt.BlockNuiDevTool was true -- if that flag were ever set to
    -- false (its name suggests it's just about dev-tool detection/logging,
    -- not about whether job-based access applies at all), ANY player with
    -- no valid job could call every NUI callback below with zero
    -- restriction. Job-based access is now unconditional; BlockNuiDevTool
    -- only controls whether the log/announce side-effects fire.
    if PlayerData_cad.job == nil then return true end

    local hasAccess = PlayerData_cad.job.name == DuckMdt.PoliceJob or PlayerData_cad.job.name == 'sheriff' or PlayerData_cad.job.name == 'fbi' or PlayerData_cad.job.name == 'mt' or PlayerData_cad.job.name == 'cid' or PlayerData_cad.job.name == 'cia' or PlayerData_cad.job.name == 'marshal' or PlayerData_cad.job.name == 'judge' or PlayerData_cad.job.name == 'doa'

    if hasAccess then
        return false
    end

    if DuckMdt.BlockNuiDevTool then
        if DuckMdt.LogUsingNuiDevTool then
            TriggerServerEvent('DuckMdt:PrintLog')
        end
        if DuckMdt.AnnouneAdminUsingNuiDevTool then
            TriggerServerEvent('DuckMdt:Announce')
        end
    end

    return true
end

RegisterCommand(DuckMdt.Command, function()
    if PlayerData_cad.job == nil then return end

    if PlayerData_cad.job.name == DuckMdt.PoliceJob or PlayerData_cad.job.name == 'sheriff' or PlayerData_cad.job.name == 'fbi' or PlayerData_cad.job.name == 'mt' or PlayerData_cad.job.name == 'cid' or PlayerData_cad.job.name == 'cia' or PlayerData_cad.job.name == 'marshal' or PlayerData_cad.job.name == 'judge' or PlayerData_cad.job.name == 'doa' then
        if MdtDisplay_cad then
            ClearPedTasks(PlayerPedId())
            SendNuiMessage(json.encode({
                type = 'MDT',
                info = 'Close'
            }))
        else
            ExecuteCommand('e tablet2')
            SendNuiMessage(json.encode({
                type = 'MDT',
                info = 'Open',
            }))
        end
        MdtDisplay_cad = not MdtDisplay_cad
        SetNuiFocus(MdtDisplay_cad, MdtDisplay_cad)
    end
end, false)

RegisterNUICallback('Login', function()
    if CheckPerm_cad() then return end
    local xPlayer = ESX.GetPlayerData()
    ESX.TriggerServerCallback('DuckMdt:GetAllWanteds', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoginUpdate',
            name = string.gsub(xPlayer.name, "_", " "),
            rank = PlayerData_cad.job.grade_label,
            job = PlayerData_cad.job.name,
            PeopleWanteds = obj.peoples,
            WantedCars = obj.cars
        }))
    end)
end)

RegisterNUICallback('SearchCitizen', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:SearchCitizen', function(obj)
        SendNuiMessage(json.encode({
            type = 'SearchResult',
            Stype = 'Citizen',
            object = obj.Citizens
        }))
    end, data.Text)
end)

RegisterNUICallback('SearchOfficers', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:SearchOfficers', function(obj)
        SendNuiMessage(json.encode({
            type = 'SearchResult',
            Stype = 'Officer',
            object = obj.Officers
        }))
    end, data.Text)
end)

RegisterNUICallback('SearchCars', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:SearchCars', function(obj)
        SendNuiMessage(json.encode({
            type = 'SearchResult',
            Stype = 'Car',
            object = obj.Cars
        }))
    end, data.Text)
end)

RegisterNUICallback('CitizenProfile', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:CitizenProfile', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadCitizenProfile',
            object = obj.CitizenProfile,
            cars = obj.CitizenCars,
            records = obj.CriminalRecords
        }))

        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.Data
        }))
    end, data.Steam)
end)

RegisterNUICallback('CarProfile', function(data, cb)
    if CheckPerm_cad() then return end
    ESX.TriggerServerCallback('DuckMdt:CarProfile', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadCarProfile',
            object = obj.CarInfo,
            owner = obj.OwnerInfo
        }))
    end, data.Plate)
end)

RegisterNUICallback('SaveNewData', function(data, cb)
    if CheckPerm_cad() then return end
    local xPlayer = ESX.GetPlayerData()
    ESX.TriggerServerCallback('DuckMdt:SaveNewData', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.result,
        }))
    end, data.Reason, xPlayer.name, data.steam)
end)

RegisterNUICallback('DeleteData', function(data)
    if CheckPerm_cad() then return end

    ESX.TriggerServerCallback('DuckMdt:DeleteData', function(obj)
        SendNuiMessage(json.encode({
            type = 'LoadDataList',
            object = obj.result,
        }))
    end, data.id, data.steam)
end)

RegisterNUICallback('UpdateCharacterStatus', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateCharacterStatus', data.NewStatus, data.steam)
end)

RegisterNUICallback('UpdateCarStatus', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateCarStatus', data.NewStatus, data.plate)
end)

RegisterNUICallback('UpdateProfilePicCharacter', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateProfilePicCharacter', data.url, data.steam)
end)

RegisterNUICallback('UpdateProfilePicCar', function(data)
    if CheckPerm_cad() then return end
    TriggerServerEvent('DuckMdt:UpdateProfilePicCar', data.url, data.plate)
end)

RegisterNUICallback('Exit', function(data)
    SendNuiMessage(json.encode({
        type = 'MDT',
        info = 'Close'
    }))
    MdtDisplay_cad = not MdtDisplay_cad
    SetNuiFocus(MdtDisplay_cad, MdtDisplay_cad)
    ClearPedTasks(PlayerPedId())
end)

RegisterNUICallback('LoadTenCodes', function()
    SendNuiMessage(json.encode({
        type = 'LoadTenCodes',
        Codes = DuckMdt.TenCodes
    }))
end)

-- Crime Scene Investigation bridge -- cad/server/crimescene.lua owns the
-- actual logic/DB/permission checks, this just relays the CS_ tab UI calls
-- to it by event/callback name.

local function GetClosestVehicle_cad(coords, maxDist)
    local vehicles = GetGamePool('CVehicle')
    local closest, closestDist = 0, maxDist
    for i = 1, #vehicles do
        local dist = #(GetEntityCoords(vehicles[i]) - coords)
        if dist < closestDist then
            closest = vehicles[i]
            closestDist = dist
        end
    end
    return closest
end

RegisterNUICallback('CS_GetCases', function()
    ESX.TriggerServerCallback('CrimeScene:getCases', function(cases)
        SendNuiMessage(json.encode({ type = 'CS_Cases', list = cases }))
    end)
end)

RegisterNUICallback('CS_GetCaseDetail', function(data)
    ESX.TriggerServerCallback('CrimeScene:getCaseDetail', function(detail)
        SendNuiMessage(json.encode({ type = 'CS_CaseDetail', data = detail }))
    end, tonumber(data.id))
end)

RegisterNUICallback('CS_AddNote', function(data)
    TriggerServerEvent('CrimeScene:addNote', tonumber(data.id), data.note)
end)

RegisterNUICallback('CS_ReferCase', function(data)
    TriggerServerEvent('CrimeScene:referCase', tonumber(data.id), data.job)
end)

RegisterNUICallback('CS_RunMatch', function(data)
    TriggerServerEvent('CrimeScene:runFingerprintMatch', tonumber(data.id))
end)

RegisterNUICallback('CS_IssueBOLO', function(data)
    TriggerServerEvent('CrimeScene:issueBOLO', tonumber(data.id))
end)

RegisterNUICallback('CS_RequestWarrant', function(data)
    TriggerServerEvent('CrimeScene:requestWarrant', tonumber(data.id))
end)

RegisterNUICallback('CS_DecideWarrant', function(data)
    TriggerServerEvent('CrimeScene:decideWarrant', tonumber(data.id), data.approved and true or false)
end)

RegisterNUICallback('CS_CloseCase', function(data)
    TriggerServerEvent('CrimeScene:closeCase', tonumber(data.id), data.verdict)
end)

RegisterNUICallback('CS_GetWanted', function()
    ESX.TriggerServerCallback('CrimeScene:getWantedBoard', function(list)
        SendNuiMessage(json.encode({ type = 'CS_Wanted', list = list }))
    end)
end)

RegisterNUICallback('CS_GetBolos', function()
    ESX.TriggerServerCallback('CrimeScene:getActiveBOLOs', function(list)
        SendNuiMessage(json.encode({ type = 'CS_Bolos', list = list }))
    end)
end)

RegisterNUICallback('CS_CheckNearestVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then
        veh = GetClosestVehicle_cad(GetEntityCoords(ped), 5.0)
    end

    if veh == 0 then
        SendNuiMessage(json.encode({ type = 'CS_PlateCheckResult', found = false, noVehicle = true }))
        return
    end

    TriggerServerEvent('CrimeScene:checkPlate', GetVehicleNumberPlateText(veh))
end)

RegisterNetEvent('CrimeScene:plateCheckResult')
AddEventHandler('CrimeScene:plateCheckResult', function(matched, plate, caseId)
    SendNuiMessage(json.encode({ type = 'CS_PlateCheckResult', found = matched, plate = plate, caseId = caseId }))
end)

RegisterNUICallback('CS_SubmitBooking', function(data)
    TriggerServerEvent(
        'CrimeScene:createBooking',
        data.caseId and tonumber(data.caseId) or nil,
        data.suspectName,
        data.charges,
        data.fine and tonumber(data.fine) or 0,
        data.jailMinutes and tonumber(data.jailMinutes) or 0,
        data.targetServerId and tonumber(data.targetServerId) or nil
    )
end)

RegisterNUICallback('CS_GetRecords', function()
    ESX.TriggerServerCallback('CrimeScene:getRecords', function(list)
        SendNuiMessage(json.encode({ type = 'CS_Records', list = list }))
    end)
end)

RegisterNUICallback('CS_GetLeaderboard', function()
    ESX.TriggerServerCallback('CrimeScene:getLeaderboard', function(lb)
        SendNuiMessage(json.encode({ type = 'CS_Leaderboard', data = lb }))
    end)
end)

-- ============================================================
-- Cold cases (reopen / archive)
-- ============================================================

RegisterNUICallback('CS_GetColdCases', function()
    ESX.TriggerServerCallback('CrimeScene:getColdCases', function(cases)
        SendNuiMessage(json.encode({ type = 'CS_ColdCases', list = cases }))
    end)
end)

RegisterNUICallback('CS_ReopenCase', function(data)
    TriggerServerEvent('CrimeScene:reopenCase', tonumber(data.id))
end)

RegisterNUICallback('CS_ArchiveCase', function(data)
    TriggerServerEvent('CrimeScene:archiveCase', tonumber(data.id))
end)

-- ============================================================
-- Internal Affairs
-- ============================================================

RegisterNUICallback('CS_GetOfficerActivity', function()
    ESX.TriggerServerCallback('CrimeScene:getOfficerActivity', function(list)
        SendNuiMessage(json.encode({ type = 'CS_OfficerActivity', list = list }))
    end)
end)

RegisterNUICallback('CS_FileIAReport', function(data)
    TriggerServerEvent('CrimeScene:fileIAReport', data.targetName, data.targetJob, data.category, data.description, data.targetIdentifier)
end)

RegisterNUICallback('CS_GetIAReports', function()
    ESX.TriggerServerCallback('CrimeScene:getIAReports', function(list)
        SendNuiMessage(json.encode({ type = 'CS_IAReports', list = list }))
    end)
end)

RegisterNUICallback('CS_CloseIAReport', function(data)
    TriggerServerEvent('CrimeScene:closeIAReport', tonumber(data.id), data.outcome, data.verdict)
end)

-- Live refresh: if the currently open case gets updated by someone else
-- (or from a rob elsewhere), re-pull it so the CS_ tabs stay in sync.
RegisterNetEvent('CrimeScene:refreshCase')
AddEventHandler('CrimeScene:refreshCase', function(caseId)
    if not MdtDisplay_cad then return end
    ESX.TriggerServerCallback('CrimeScene:getCaseDetail', function(detail)
        SendNuiMessage(json.encode({ type = 'CS_CaseDetail', data = detail }))
    end, caseId)
end)

RegisterNetEvent('CrimeScene:boloListUpdated')
AddEventHandler('CrimeScene:boloListUpdated', function()
    if not MdtDisplay_cad then return end
    ESX.TriggerServerCallback('CrimeScene:getActiveBOLOs', function(list)
        SendNuiMessage(json.encode({ type = 'CS_Bolos', list = list }))
    end)
end)
