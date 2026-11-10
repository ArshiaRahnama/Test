-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local loaded = false
local spam = false
local function handler()
    if spam then return end
    if IsNextWeatherType('XMAS') then 
        spam = true
        Citizen.SetTimeout(2000,function()
            spam = false
        end)
        if not loaded then
            RequestScriptAudioBank("ICE_FOOTSTEPS", false)
            RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
            RequestNamedPtfxAsset("core_snow")
            while not HasNamedPtfxAssetLoaded("core_snow") do
                Citizen.Wait(0)
            end
            UseParticleFxAssetNextCall("core_snow")
            loaded = true
        end
        RequestAnimDict('anim@mp_snowball')
        TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0) 
        Citizen.Wait(1950) 
        if not HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_SNOWBALL')) then
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 1, false, true)
        end
    end
end
RegisterCommand('snow',handler)
AddEventHandler('snow:pickup',handler)