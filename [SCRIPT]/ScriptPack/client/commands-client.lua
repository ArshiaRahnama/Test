ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterCommand('admins',function(source)
	ESX.TriggerServerCallback('esx:GetAdminsInfo', function(info,count)
	local elements = {}
		for i=1, #info, 1 do
				table.insert(elements, {
					label = "Admin "..info[i].perm.." - "..info[i].name.."("..info[i].source..") - "..info[i].status
				})
		end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'admins',
      {
        title    = 'Admin Haye Online ('..count..') Nafar',
        align    = 'top-right',
        elements = elements
        },
            function(data2, menu2)
            end,
      function(data2, menu2)
        menu2.close()
      end
    )
	end)
end)

RegisterCommand('fps', function()
OpenFPSMenu()
end)

function OpenFPSMenu()
  local elements = {
        {label = 'High Perfomance Mode',        value = 'fps'},
        {label = 'Perfomance Mode ',        value = 'fps5'},
        {label = 'Normal',        value = 'fps2'},
    }

	if ESX.GetPlayerData().perm >= 10 then
		table.insert(elements, {label = 'oltra', value = 'fpsbost'})
		table.insert(elements, {label = 'oltra1', value = 'fpsbost1'})
		table.insert(elements, {label = 'oltra2', value = 'fpsbost2'})
		table.insert(elements, {label = 'oltra3', value = 'fpsbost3'})
		table.insert(elements, {label = 'oltra4', value = 'fpsbost4'})
	end
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fps_menu',
    {
      title    = 'Boost FPS Menu',
      align    = 'left',
      elements = elements
      },
          function(data2, menu2)
            if data2.current.value == 'fps' then
              SetTimecycleModifier('yell_tunnel_nodirect')

            elseif data2.current.value == 'fps2' then
              SetTimecycleModifier()
              ClearTimecycleModifier()
              ClearExtraTimecycleModifier()
            elseif data2.current.value == 'fps5' then
              SetTimecycleModifier('tunnel')
            elseif data2.current.value == 'fpsbost' then
				SetTimecycleModifier('MP_Powerplay_night')
            elseif data2.current.value == 'fpsbost1' then
				SetTimecycleModifier('Glasses_Darkblue')
            elseif data2.current.value == 'fpsbost2' then
				SetTimecycleModifier('BloomMid')
            elseif data2.current.value == 'fpsbost3' then
				SetTimecycleModifier('MP_Powerplay_blend')
            elseif data2.current.value == 'fpsbost4' then
				SetTimecycleModifier('scanline_cam')

            else
            end
          end,
    function(data2, menu2)
      menu2.close()
    end
  )
end

RegisterCommand('fps2', function()
OpenFPSMenu2()
end)

function OpenFPSMenu2()
  local elements = {
    {label = 'High Perfomance Mode', value = 'fps'},
    {label = 'Perfomance Mode ', value = 'fps5'},
    {label = 'Normal', value = 'fps2'},

    {label = 'oltra', value = 'fpsbost'},
    {label = 'oltra1', value = 'fpsbost1'},
    {label = 'oltra2', value = 'fpsbost2'},
    {label = 'oltra3', value = 'fpsbost3'},
    {label = 'oltra4', value = 'fpsbost4'},
  }




  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fps_menu2',
    {
      title    = 'Boost FPS Menu',
      align    = 'left',
      elements = elements
      },
          function(data2, menu2)
            if data2.current.value == 'fps' then
              SetTimecycleModifier('yell_tunnel_nodirect')

            elseif data2.current.value == 'fps2' then
              SetTimecycleModifier()
              ClearTimecycleModifier()
              ClearExtraTimecycleModifier()
            elseif data2.current.value == 'fps5' then
              SetTimecycleModifier('tunnel')
            elseif data2.current.value == 'fpsbost' then
				SetTimecycleModifier('MP_Powerplay_night')
            elseif data2.current.value == 'fpsbost1' then
				SetTimecycleModifier('Glasses_Darkblue')
            elseif data2.current.value == 'fpsbost2' then
				SetTimecycleModifier('BloomMid')
            elseif data2.current.value == 'fpsbost3' then
				SetTimecycleModifier('MP_Powerplay_blend')
            elseif data2.current.value == 'fpsbost4' then
				SetTimecycleModifier('scanline_cam')

            else
            end
          end,
    function(data2, menu2)
      menu2.close()
    end
  )
end

Citizen.CreateThread(function()
StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
end)

local crosshairParameters =
{
	["width"] =
	{
		["label"] = "Width",
		["allValues"] = {0.002, 0.0025, 0.003, 0.0035, 0.004, 0.0045, 0.005, 0.0055, 0.006, 0.0065, 0.007, 0.0075, 0.008, 0.0085, 0.009, 0.0095, 0.010,
		0.0105, 0.011, 0.0115, 0.012, 0.0125, 0.013, 0.0135, 0.014, 0.0145, 0.015, 0.0155, 0.016, 0.0165, 0.017, 0.0175, 0.018, 0.0185, 0.019, 0.0195, 0.02},
		["currentValue"] = 3,
	},
	["gap"] =
	{
		["label"] = "Gap",
		["allValues"] = {0.0, 0.0005, 0.001, 0.0015, 0.002, 0.0025, 0.003, 0.0035, 0.004, 0.0045, 0.005, 0.0055, 0.006, 0.0065, 0.007, 0.0075, 0.008, 0.0085, 0.009, 0.0095, 0.01},
		["currentValue"] = 3,
	},
	["dot"] =
	{
		["label"] = "Dot",
		["allValues"] = {false, true},
		["currentValue"] = 2,
	},
	["thickness"] =
	{
		["label"] = "Thickness",
		["allValues"] = {0.002, 0.004, 0.006, 0.008, 0.01, 0.012, 0.014, 0.016, 0.018, 0.02},
		["currentValue"] = 1,
	},
	["gtacross"] =
	{
		["label"] = "Activate default GTA (1 = OFF)",
		["allValues"] = {false, true},
		["currentValue"] = 2,
	},
	["color"] =
	{
		["label"] = "Color",
		["allValues"] = {
			{R = 255,	G = 255,	B = 255},{R = 0,	G = 0,	B = 0},{R = 255,	G = 0,	B = 0},{R = 0,	G = 255,	B = 0},{R = 0,	G = 0,	B = 255},{R = 255,	G = 255,	B = 0},
			{R = 255,	G = 0,	B = 255},{R = 0,	G = 255,	B = 255},{R = 255,	G = 165,	B = 0},{R = 0,	G = 128,	B = 0},{R = 128,	G = 0,	B = 128},
		},
		["currentValue"] = 1,
	},
	["opacity"] =
	{
		["label"] = "Opacity",
		["allValues"] = {25, 50, 75, 100, 125, 150, 175, 200, 225, 255},
		["currentValue"] = 10,
	},
}

local allDefaultValues =
	{
		{param = "thickness", value = 1},
		{param = "width", value = 3},
		{param = "gap", value = 3},
		{param = "dot", value = 2},
		{param = "gtacross", value = 2},
		{param = "color", value = 1},
		{param = "opacity", value = 10},
	}

local parameters = {"width", "gap", "dot", "thickness", "gtacross", "color", "opacity"}

local currentParamIndex = 1
local isEditing = false
local customCrosshairState = true

local function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function notify(text, duration)
	Citizen.CreateThread(function()
		SetNotificationTextEntry("STRING")
		AddTextComponentSubstringPlayerName(text)
		if duration then
			local Notification = DrawNotification(true, true)
			Citizen.Wait(duration)
			RemoveNotification(Notification)
		else
			DrawNotification(false, false)
		end
	end)
end

local function GetInitialDatas()
	local customCrosshairData = GetResourceKvpInt("cookcrosshair_custom")
	if not customCrosshairData or customCrosshairData == 0 then
		customCrosshairData = 1
		SetResourceKvpInt("cookcrosshair_custom", 1)
	end

	if customCrosshairData == 1 then
		customCrosshairState = false
	else
		customCrosshairState = true
	end

	for k,v in pairs(allDefaultValues) do
		local currentData = GetResourceKvpInt("cookcrosshair_" .. v.param)
		if not currentData or currentData == 0 then
			SetResourceKvpInt("cookcrosshair_" .. v.param, v.value)
		else
			crosshairParameters[v.param]["currentValue"] = currentData
		end
	end
end

local function SaveDatas()
	for k,v in pairs(allDefaultValues) do
		SetResourceKvpInt("cookcrosshair_" .. v.param, crosshairParameters[v.param]["currentValue"])
	end

	notify("~y~Crosshair datas~s~ has been ~g~saved~s~.", 5000)
end

local function ResetDatas()
	local allSettings =
	{
		{param = "thickness", value = 1},
		{param = "width", value = 3},
		{param = "gap", value = 3},
		{param = "dot", value = 2},
		{param = "gtacross", value = 2},
		{param = "color", value = 1},
		{param = "opacity", value = 10},
	}

	for k,v in pairs(allSettings) do
		SetResourceKvpInt("cookcrosshair_" .. v.param, v.value)
	end

	notify("~y~Crosshair datas~s~ has been ~r~reset~s~.", 5000)

	GetInitialDatas()
end

Citizen.CreateThread(function()
	GetInitialDatas()

	Citizen.Wait(2000)

	while true do

		if not crosshairParameters["gtacross"]["allValues"][crosshairParameters["gtacross"]["currentValue"]] then
			HideHudComponentThisFrame(14)
		end


		if customCrosshairState then
			local ratio = GetAspectRatio()


			local thickness = crosshairParameters["thickness"]["allValues"][crosshairParameters["thickness"]["currentValue"]]
			local width		= crosshairParameters["width"]["allValues"][crosshairParameters["width"]["currentValue"]]
			local gap		= crosshairParameters["gap"]["allValues"][crosshairParameters["gap"]["currentValue"]]
			local dot		= crosshairParameters["dot"]["allValues"][crosshairParameters["dot"]["currentValue"]]

			local colorSelected = crosshairParameters["color"]["currentValue"]
			local colorR = crosshairParameters["color"]["allValues"][colorSelected].R
			local colorG = crosshairParameters["color"]["allValues"][colorSelected].G
			local colorB = crosshairParameters["color"]["allValues"][colorSelected].B

			local colorOpacity	= crosshairParameters["opacity"]["allValues"][crosshairParameters["opacity"]["currentValue"]]



			DrawRect(0.5 - gap - width / 2, 0.5, width, thickness, colorR, colorG, colorB, colorOpacity)

			DrawRect(0.5 + gap + width / 2, 0.5, width, thickness, colorR, colorG, colorB, colorOpacity)

			DrawRect(0.5, 0.5 - (gap*ratio) - (width*ratio) / 2, thickness / ratio, width * ratio, colorR, colorG, colorB, colorOpacity)

			DrawRect(0.5, 0.5 + (gap*ratio) + (width*ratio) / 2, thickness / ratio, width * ratio, colorR, colorG, colorB, colorOpacity)

			if dot then
				DrawRect(0.5, 0.5, (thickness/2), (thickness/2) * ratio, colorR, colorG, colorB, colorOpacity)
			end
		end


		if isEditing then
			local currentParameter = parameters[currentParamIndex]


			DisplayHelpText("~INPUT_CELLPHONE_UP~ " .. crosshairParameters[currentParameter]["label"] .. "\n~INPUT_REPLAY_ADVANCE~ " .. crosshairParameters[currentParameter]["currentValue"] .. "\n~INPUT_CONTEXT~ Save")



			if IsControlJustPressed(1, 172) then
				currentParamIndex = currentParamIndex + 1
				if currentParamIndex > #parameters then currentParamIndex = 1 end
			elseif IsControlJustPressed(1, 173) then
				currentParamIndex = currentParamIndex - 1
				if currentParamIndex < 1 then currentParamIndex = #parameters end

			elseif IsControlJustPressed(1, 307) then
				local currentValue = crosshairParameters[currentParameter]["currentValue"] + 1
				if currentValue > #crosshairParameters[currentParameter]["allValues"] then currentValue = 1 end
				crosshairParameters[currentParameter]["currentValue"] = currentValue

			elseif IsControlJustPressed(1, 308) then
				local currentValue = crosshairParameters[currentParameter]["currentValue"] - 1
				if currentValue < 1 then currentValue = #crosshairParameters[currentParameter]["allValues"] end
				crosshairParameters[currentParameter]["currentValue"] = currentValue
			elseif IsControlJustPressed(1, 51) then
				SaveDatas()
				isEditing = false
			end
		end

		Citizen.Wait(1)
	end
end)

AddEventHandler("cookcrosshair:active", function()
	customCrosshairState = not customCrosshairState
	if customCrosshairState then
		SetResourceKvpInt("cookcrosshair_custom", 2)
	else
		SetResourceKvpInt("cookcrosshair_custom", 1)
	end
end)

AddEventHandler("cookcrosshair:edit", function()
	isEditing = true
end)

AddEventHandler("cookcrosshair:reset", function()
	ResetDatas()
end)

RegisterCommand('crosse', function(source, args)

	TriggerEvent("cookcrosshair:edit")
end, false)

RegisterCommand('crossr', function(source, args)

	TriggerEvent("cookcrosshair:reset")
end, false)

RegisterCommand('cross', function(source, args)

	TriggerEvent("cookcrosshair:active")
end, false)

local type = nil
local _menu = {
    {label = 'Reset',  value = 'reset'},
    {label = 'Ultra Low',    value = 'ulow'},
    {label = 'Low',    value = 'low'},
    {label = 'Medium', value = 'medium'},
}

RegisterCommand("fpsmenu", function()
  	ESX.UI.Menu.CloseAll()
  	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps', {
  		title    = 'FPS Booster',
  		align    = 'top-left',
  		elements = _menu
  	}, function(data, menu)
          local v = data.current.value


  		if v == "reset" then
              RopeDrawShadowEnabled(true)
              CascadeShadowsSetAircraftMode(true)
              CascadeShadowsEnableEntityTracker(false)
              CascadeShadowsSetDynamicDepthMode(true)
              CascadeShadowsSetEntityTrackerScale(5.0)
              CascadeShadowsSetDynamicDepthValue(5.0)
              CascadeShadowsSetCascadeBoundsScale(5.0)

              SetFlashLightFadeDistance(10.0)
              SetLightsCutoffDistanceTweak(10.0)

              SetArtificialLightsState(false)
          elseif v == "ulow" then
              RopeDrawShadowEnabled(false)

              CascadeShadowsClearShadowSampleType()
              CascadeShadowsSetAircraftMode(false)
              CascadeShadowsEnableEntityTracker(true)
              CascadeShadowsSetDynamicDepthMode(false)
              CascadeShadowsSetEntityTrackerScale(0.0)
              CascadeShadowsSetDynamicDepthValue(0.0)
              CascadeShadowsSetCascadeBoundsScale(0.0)

              SetFlashLightFadeDistance(0.0)
              SetLightsCutoffDistanceTweak(0.0)

			  ClearAllBrokenGlass()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearPedBloodDamage(PlayerPedId())
            ClearPedWetness(PlayerPedId())
            ClearPedEnvDirt(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)


            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Citizen.Wait(100)
            end

            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.4)
            SetArtificialLightsState(true)

          elseif v == "low" then
              RopeDrawShadowEnabled(false)

              CascadeShadowsClearShadowSampleType()
              CascadeShadowsSetAircraftMode(false)
              CascadeShadowsEnableEntityTracker(true)
              CascadeShadowsSetDynamicDepthMode(false)
              CascadeShadowsSetEntityTrackerScale(0.0)
              CascadeShadowsSetDynamicDepthValue(0.0)
              CascadeShadowsSetCascadeBoundsScale(0.0)

              SetFlashLightFadeDistance(5.0)
              SetLightsCutoffDistanceTweak(5.0)

			  ClearAllBrokenGlass()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearPedBloodDamage(PlayerPedId())
            ClearPedWetness(PlayerPedId())
            ClearPedEnvDirt(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)


            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                Citizen.Wait(100)
            end

            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.6)
            SetArtificialLightsState(true)

          elseif v == "medium" then
              RopeDrawShadowEnabled(true)

              CascadeShadowsClearShadowSampleType()
              CascadeShadowsSetAircraftMode(false)
              CascadeShadowsEnableEntityTracker(true)
              CascadeShadowsSetDynamicDepthMode(false)
              CascadeShadowsSetEntityTrackerScale(5.0)
              CascadeShadowsSetDynamicDepthValue(3.0)
              CascadeShadowsSetCascadeBoundsScale(3.0)

              SetFlashLightFadeDistance(3.0)
              SetLightsCutoffDistanceTweak(3.0)

              SetArtificialLightsState(false)
				  ClearAllBrokenGlass()
				LeaderboardsReadClearAll()
				ClearBrief()
				ClearGpsFlags()
				ClearPrints()
				ClearSmallPrints()
				ClearReplayStats()
				LeaderboardsClearCacheData()
				ClearFocus()
				ClearHdArea()
				SetWindSpeed(0.0)


            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Citizen.Wait(100)
            end

            OverrideLodscaleThisFrame(0.8)
 		end

          type = v
 	end, function(data, menu)
 		menu.close()
 	end)
 end)

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function GetWorldObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function GetWorldPeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetWorldVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetWorldPickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

