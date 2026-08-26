GarageData = GarageData or {}

-- General Settings
GarageData.Framework = "esx" -- newqb, oldqb, esx
GarageData.BotToken = "" -- https://www.youtube.com/watch?v=-m-Z7Wav-fM&ab_channel=GAKventure
GarageData.SQL = "mysql-async" -- mysql-async -- oxmysql -- ghmattimysql -- pls fxmanifest and open requirement

GarageData.playerLoaded = "esx:playerLoaded" -- Modify your ESX-based framework here.
GarageData.setJob = "esx:setJob" -- Modify your ESX-based framework here.
GarageData.QBCoreplayerLoaded = 'QBCore:Client:OnPlayerLoaded' -- Modify your QBCore-based framework here.
GarageData.QBCoreOnJobUpdate = 'QBCore:Client:OnJobUpdate' -- Modify your QBCore-based framework here.

-- Marker / 3D Text Settings
GarageData.Drawmarker = true -- True for Marker / False for 3D Text (effects only Vehicle Storing Locations)

GarageData.Drawtextput = '[E] Put the vehicle in the garage'
GarageData.DrawtextGarage = '[E] Garage'
GarageData.DrawtextDistance = 3.0

GarageData.drawmarkerid = 1
GarageData.DrawmarkerDistance = 5.0
GarageData.red = 255
GarageData.green = 10
GarageData.blue = 20
GarageData.alpha = 155

-- Garage Settings
GarageData.Notify = false
GarageData.GarageName = false -- if false all garages are shared (you can get every car from every garage) / if true you can only get cars from the garage where it was stored before
GarageData.Sell = false -- true or false
GarageData.Blip = false -- true or false
GarageData.Transfer = false -- true or false 
GarageData.Repair = false -- true or false 
GarageData.FilterCiv = true
GarageData.Vehiclekey =  true -- if you are using vehiclekey please true
GarageData.UseLegacyFuel = false -- if you are using legacy fuel please true
GarageData.MileageFormat = "KM" -- "KM" "MI"
GarageData.GetVehicleEstimatedMaxSpeed = function(vehicle)
    if GarageData.MileageFormat == "MI" then
        return math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicle) * 2.24) or 200
    end
    return math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicle) * 3.605936) or 200
end

-- Price Settings
GarageData.Defaultprice = 500
GarageData.ValePrice = 5000
GarageData.RepairPrice = 3000
GarageData.RepairMoneyType = 'bank' 
GarageData.ValeMoneyType = 'bank'

-- Misc Settings
GarageData.TaskLeaveVehicle = true -- true or false
GarageData.PlateLetters  = 4
GarageData.PlateNumbers  = 4
GarageData.PlateUseSpace = true
GarageData.ShowVehicleDelay = true -- Something done to prevent vehicle spam, something that is not recommended to be false
GarageData.ShowVehicleSecond = 650
GarageData.Out = true -- if the vehicle is in the world it won't let me take it out

GarageData.Garages = {}
GarageData.JobGarages = {}

GarageData.Notifications = {
    ['sell'] = {
        message = 'Vehicle successfully sold.',
        type = "success"
    },
    ['transfer'] = {
        message = 'Vehicle transferred successfully.',
        type = "success"
    },
    ['transfererror'] = {
        message = 'Vehicle transfer failed.',
        type = "error"
    },
    ['requiredjob'] = {
        message = "You don't have the required job.",
        type = "error"
    },
    ['vehiclenotyour'] = {
        message = 'The vehicle is not yours.',
        type = "error"
    },
    ['notgarageinvehicle'] = {
        message = "You don't have a car in this garage.",
        type = "error"
    },
    ['nomoneyvale'] = {
        message = "You don't have money",
        type = "error"
    },
    ['nomoneyreapir'] = {
        message = "You don't have money",
        type = "error"
    },
    ['carnotfound'] = {
        message = "An error occurred while loading the vehicle",
        type = "error"
    },
    ['parkingsuccesful'] = {
        message = "Parked it successfully",
        type = "success"
    },
}

GarageData.Notification = function(message, type, isServer, src) -- You can change here events for notifications
    if GarageData.Notify then
        if isServer then
            if GarageData.Framework == "esx" then
                TriggerClientEvent("esx:showNotification", src, message)
            else 
                TriggerClientEvent('QBCore:Notify',src, message, type, 1500)
            end 
        else
            if GarageData.Framework == "esx" then
                TriggerEvent("esx:showNotification", message)
            else
                TriggerEvent('QBCore:Notify', message, type, 1500)
            end
        end
    end
end 

-- Function

function VehicleKeys(plate) 
    if true  then
        TriggerServerEvent("garage:addKeys", plate)
    end
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GarageData.GetVehicleFuel = function(vehicle) -- you can change LegacyFuel export if you use another fuel system 
    return GetVehicleFuelLevel(vehicle)
end

GarageData.SetVehicleFuel = function(vehicle,fuel_level) -- you can change LegacyFuel export if you use another fuel system 
   
    return SetVehicleFuelLevel(vehicle, 100.0)
 
end

GarageData.Weight = {
    [0] = 1000,-- Compacts  
    [1] = 1500,-- Sedans  
    [2] = 2000,-- SUVs  
    [3] = 2500,-- Coupes 
    [4] = 3000,-- Muscle 
    [5] = 4000,-- Sports Classics 
    [6] = 5000,-- Sports 
    [7] = 6000,-- Super
    [8] = 7000,-- Motorcycles  
    [9] = 8000,--  Off-road 
    [10] = 9000,-- Industrial
    [11] = 10000,-- Utility
    [12] = 11000,-- Vans  
    [13] = 12000,-- Cycles
    [14] = 13000,-- Boats  
    [15] = 14000,-- Helicopters
    [16] = 15000,-- Planes 
    [17] = 16000,-- Service
    [18] = 17000,-- Emergency 
    [19] = 18000, -- Military  
    [20] = 19000 -- Commercial  
}

GarageData.Text = {
    [0]  = '', 
    [1]  = '', 
    [2]  = '', 
    [3]  = '', 
    [4]  = '', 
    [5]  = '', 
    [6]  = '', 
    [7]  = '',  
    [8]  = '', 
    [9]  = '', 
    [10]  = '',  
    [11]  = '', 
    [12]  = '', 
    [13]  = '', 
    [14]  = '', 
    [15]  = '', 
    [16]  = '', 
    [17]  = '', 
    [18]  = '', 
    [19]  = '', 
    [20]  = '', 
}