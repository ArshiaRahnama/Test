cam = nil
isCameraActive = false
mode = 'none'
ped = PlayerPedId()

componentIds = {
    ['tshirt'] = {id = 8, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['torso'] = {id = 11, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['pants'] = {id = 4, Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300},
    ['shoes'] = {id = 6, Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200},
    ['helmet'] = {id = 0, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
    ['mask'] = {id = 1, Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800},
    ['ears'] = {id = 2, Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
    ['bag'] = {id = 5, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['chain'] = {id = 7, Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100},
    ['glasses'] = {id = 1, Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
    ['bproof'] = {id = 9, Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200},
    ['watches'] = {id = 6, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['bracelets'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['decals'] = {id = 7, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
    ['arms'] = {id = 3, Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
}


RegisterNUICallback('Select', function(data, cb)
    mode = data.mode
    SendNuiMessage(json.encode({
        action = "loadClothe",
        obj = GetOwnedClotheByType(mode),
        mode = mode,
        used = GetUsedType()
    }))
    cb('ok')
end)

RegisterNUICallback('LoadPack', function(_, cb)
    SendNuiMessage(json.encode({
        action = 'loadClothe',
        obj =  GetOwnedPack(),
        mode = 'pack'
    }))
    cb('ok')
end)



local spam = false
RegisterNUICallback('ChangeClothe', function(data, cb)
    if spam then cb('ok') return end
    spam = true
    Citizen.SetTimeout(2000,function()
        spam = false
    end)
    TriggerEvent('removeSwatHelmet')
    if componentIds[data.name] then
		UnUseByType(data.name)
		playClotheAnim(data.name)
        if data.name == 'bproof' and GetPedArmour(PlayerPedId()) > 0 then
            TriggerEvent('esx:spawnObject', 'prop_bodyarmour_03')
            SetPedArmour(PlayerPedId(), 0)
            -- FIX: 'skinchanger:loadStuff' isn't a handler skinchanger
            -- registers (checked [SCRIPT]/skinchanger/client/main.lua) - this
            -- silently no-op'd. The real per-key setter is 'skinchanger:change'.
            TriggerEvent('skinchanger:change', 'bproof_1', 0)
            TriggerEvent('skinchanger:change', 'bproof_2', 0)
        end
	else
		ToggleClothe(data.name)
		local clotheData = GetClotheData(data.name)
		if clotheData then playClotheAnim(clotheData.type) end
    end
	Citizen.Wait(300)
    SendNuiMessage(json.encode({
        action = "update",
        obj = GetUsedType()
    }))
    refreshPedScreen()
    sendPlayerInventory()
    cb('ok')
end)

RegisterNUICallback('UsePack', function(data, cb)
    if spam then cb('ok') return end
    spam = true
    Citizen.SetTimeout(10000,function()
        spam = false
    end)
    closeInventory()
    TriggerServerEvent("esx:useItem", data.name)
    cb('ok')
end)

RegisterNUICallback('CreatePack', function(data, cb)
    closeInventory()
    Citizen.Wait(500)
    ESX.UI.Menu.Open(
    'dialog',
    GetCurrentResourceName(),
    'get_count',
    {
        title = "Esm pack ra vared konid"
    },
    function(data1,menu1)
        if data1.value and data1.value ~= '' then
            if data1.value:match("[^%w%s]") then
                ESX.ShowNotification("~h~Shoma faghat mojaz be vared kardan character englishi hastid!")
                return
            end
            menu1.close()
            name = data1.value
            packAnim()
            CreatePack(name)
            Wait(300)
        end
    end, function(data1,menu1)
        menu1.close()
    end)
    cb('ok')
end)

function playClotheAnim(mode)
    while not HasAnimDictLoaded(componentIds[mode].Dict) do RequestAnimDict(componentIds[mode].Dict) Wait(100) end
    if IsPedInAnyVehicle(ped) then componentIds[mode].Move = 51 end
    TaskPlayAnim(PlayerPedId(), componentIds[mode].Dict, componentIds[mode].Anim, 3.0, 3.0, componentIds[mode].Dur, componentIds[mode].Move, 0, false, false, false)

    Wait(componentIds[mode].Dur)
end
exports('playClotheAnim', playClotheAnim)
--

-- Citizen.CreateThread(Camera())

function packAnim()
    playClotheAnim('tshirt')
    playClotheAnim('pants')
    playClotheAnim('helmet')
    playClotheAnim('shoes')
    playClotheAnim('ears')
    playClotheAnim('glasses')
    playClotheAnim('bracelets')
end
exports('packAnim', packAnim)

function createPedScreen() 
    if not previewPed then
        CreateThread(function()
            SetFrontendActive(true)
            ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
            Wait(100)
            previewPed = ClonePed(PlayerPedId(), false, false, true)
            local x,y,z = table.unpack(GetEntityCoords(previewPed))
            SetEntityCoords(previewPed, x,y,z-10)
            FreezeEntityPosition(previewPed, true)
            SetEntityVisible(previewPed, false, false)
            NetworkSetEntityInvisibleToNetwork(previewPed, false)
            Wait(200)
            SetPedAsNoLongerNeeded(previewPed)
            GivePedToPauseMenu(previewPed, 2)
            SetPauseMenuPedLighting(true)
            SetPauseMenuPedSleepState(true)
            SetMouseCursorVisibleInMenus(false)
            if not isOpen then
                deletePedScreen()
            end
        end)
    end
end

function deletePedScreen()
    if previewPed then
        DeleteEntity(previewPed)
        SetFrontendActive(false)
        previewPed = nil
    end
end


function refreshPedScreen()
	deletePedScreen()
	Wait(200)
    if isOpen then
        createPedScreen()
    end
end

RegisterNUICallback('createPed', function(_, cb)
    createPedScreen() 
    cb('ok')
end)

RegisterNUICallback('deletePed', function(_, cb)
    deletePedScreen()
    cb('ok')
end)