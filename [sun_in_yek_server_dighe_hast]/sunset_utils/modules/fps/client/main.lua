-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local type = nil
local _menu = {
    {label = 'Reset',  value = 'reset'},
    {label = 'Ultra Low',    value = 'ulow'},
    {label = 'Low',    value = 'low'},
    {label = 'Medium', value = 'medium'},
}

RegisterCommand("fps", function()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps', {
		title    = 'FPS Menu',
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
            --DistantCopCarSirens(true)
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
            --DistantCopCarSirens(false)
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
            DistantCopCarSirens(false)
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
            --DistantCopCarSirens(false)
            SetArtificialLightsState(false)
		end
        type = v
	end, function(data, menu)
		menu.close()
	end)
end)

function threadFPS()
    Citizen.CreateThread(function()
        while type and type ~= 'reset' do
            if type == "ulow" then
                --// Find closest ped and set the alpha
                DisableOcclusionThisFrame()
                SetDisableDecalRenderingThisFrame()
                RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
                OverrideLodscaleThisFrame(0.4)
                SetArtificialLightsState(true)
            elseif type == "low" then
                --// Find closest ped and set the alpha
                SetDisableDecalRenderingThisFrame()
                RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
                OverrideLodscaleThisFrame(0.6)
                SetArtificialLightsState(true)
            elseif type == "medium" then
                --// Find closest ped and set the alpha
                OverrideLodscaleThisFrame(0.8)
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(0)
        end
    end)
    
    --// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
    Citizen.CreateThread(function()
        while type and type ~= 'reset' do
            if type == "ulow" or type == "low" then
                ClearAllBrokenGlass()
                ClearAllHelpMessages()
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
                ClearOverrideWeather()
                ClearHdArea()
                DisableVehicleDistantlights(false)
                DisableScreenblurFade()
                SetRainLevel(0.0)
                SetWindSpeed(0.0)
                Citizen.Wait(300)
            elseif type == "medium" then
                ClearAllBrokenGlass()
                ClearAllHelpMessages()
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
                Citizen.Wait(1000)
            else
                Citizen.Wait(1500)
            end
        end
    end)
end
