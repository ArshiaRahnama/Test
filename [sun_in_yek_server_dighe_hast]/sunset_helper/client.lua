-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
local Jobs = {}
local JobsClothe = nil
local PlayerData = {}
local CurrentJob = 'nojob'
local ClotheMater = {
    'tshirt_1',
    'tshirt_2',
    'torso_1',
    'torso_2',
    'pants_1',
    'pants_2',
}
local coords = vector3(-265.46, -963.15, 31.2)
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    ESX.TriggerServerCallback('sunset_helper:getJobsList', function(jobs,clothe)
        Jobs = jobs
        JobsClothe = clothe
	end)
    -- local blip = AddBlipForCoord(coords)
    -- SetBlipSprite (blip, 498)
    -- SetBlipDisplay(blip, 4)
    -- SetBlipScale  (blip, 1.5)
    -- SetBlipColour (blip, 60)
    -- SetBlipAsShortRange(blip, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentSubstringPlayerName('Job center')
    -- EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local near = false
    while true do 
        Citizen.Wait(1000)
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),coords)
        if distance < 10 then
            if not near then
                near = true
                Citizen.CreateThread(function()
                    while near do
                        Citizen.Wait(1)
                        ESX.Game.Utils.Draw3D(coords,'Jahat baz kardan menu job center command /jobs ra bezanid')
                    end
                end)
            end
        elseif near then
            near = false
        end
    end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

local Number = 0
local Tuto = 'none'

Config = {}

Config.Jobs = {}
Config.Helps = {
    {name= 'آموزش شغل معدنچی', info = '', picture = 'Job/miner.png', moreinfo = {
        {picture = 'https://cdn.sunrp.ir/jobs/Mine.mp4', text = 'ویدیو آموزشی' , video = true},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/1.png', text = 'ابتدا به این مکان بروید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/2.png', text = 'سپس از این مکان لباس مخوص را بپوشید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/3.png', text = 'سپس بعد از پوشیدن لباس در همان مکان ماشین را تحویل بگیرید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/4.png', text = 'سپس بعد از تحویل ماشین به مکان مورد نظر برید و خورده سنگ جمع کنید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/5.png', text = ''},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/6.png', text = 'پس از اتمام جمع کردن سنگ جهت غربال سنگ به مکان بالا بروید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/7.png', text = ''},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/8.png', text = 'برای فروش آهن و طلا ابتدا باید آن را به شمش تبدیل کنید, جهت تبدیل به مکان بالا بروید'},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/9.png', text = ''},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/10.png', text = ''},
        {picture = 'https://cdn.sunrp.ir/jobs/miner/11.png', text = 'سپس جهت فروش شمش طلا و آهن و آجر به مکان بالا بروید'},
    }, event = ""},
    {name= 'آموزش شغل شرکت نفت', info = '', picture = 'Job/fueler.png', moreinfo = {
        {picture = 'https://cdn.sunrp.ir/jobs/palayeshgah.mp4', text = 'ویدیو آموزشی' , video = true},
    }, event = ""},
    {name= 'آموزش شغل چوب بُری', info = '', picture = 'Job/lumberjack.png', moreinfo = {
        {picture = 'https://cdn.sunrp.ir/jobs/bandicam_2021-07-10_00-31-14-402_1.mp4', text = 'ویدیو آموزشی' , video = true},
    }, event = ""},
    {name= 'آموزش شغل قصابی', info = '', picture = 'Job/slaughterer.png', moreinfo = {
        {picture = 'https://cdn.sunrp.ir/jobs/bandicam_2021-07-11_02-02-43-471_1.mp4', text = 'ویدیو آموزشی' , video = true},
    }, event = ""},
    {name= 'آموزش شغل خیاطی', info = '', picture = 'Job/tailor.png', moreinfo = {
        {picture = 'https://cdn.sunrp.ir/jobs/bandicam_2021-07-10_03-33-55-962_1.mp4', text = 'ویدیو آموزشی' , video = true},
    }, event = ""},
}

Config.jobsinfo = {
    ['miner'] = 'معدنچی',
    ['fueler'] = 'شرکت نفت',
    ['lumberjack'] = 'چوب بُر',
    ['slaughterer'] = 'قصاب',
    ['tailor'] = 'خیاط',
    ['delivery'] = 'بار بری',
}

-- RegisterCommand('jobs', function ()
--     SendNuiMessage(json.encode({
--         action = 'show',
--         jobs = Jobs,
--         info = Config.jobsinfo ,
--         helpobj = Config.Helps 
--     }))
--     SetNuiFocus(true, true)
-- end)

RegisterNUICallback('SetJob', function(data)
    TriggerEvent('startJob',data.job)
end)

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ReqTutosObj', function()
    
end)

RegisterNUICallback('StartTuto', function(data)
    Number = 0
    Tuto = data.name
    data.playerpos = GetEntityCoords(PlayerPedId())
    data.number = Number
    TriggerEvent(data.event, data)
end)

function LoadNotif(obj)
    SendNuiMessage(json.encode({
        action = 'Notif',
        obj = obj
    }))
    ESX.SetTimeout(15000,function()
        exports.sunset_helper:UnLoadNotif()
    end)
end

function UnLoadNotif(obj)
    SendNuiMessage(json.encode({
        action = 'UnNotif',
    }))
end

function GetData()
    local data = {}
    data.name = Tuto
    data.number = Number
    return data
end

function Done()
    Number = 0
    Tuto = 'none'
end

exports("LoadNotif", LoadNotif);
exports("UnLoadNotif", UnLoadNotif);
exports("GetData", GetData)
exports("TutorialDone", Done)

AddEventHandler('skinchanger:modelLoaded', function()
    while not PlayerData.name do
        Citizen.Wait(100)
    end
    Citizen.Wait(10000)
    -- Citizen.CreateThread(function()
    --     while true do
    --         clotheCheck()
    --         Citizen.Wait(10000)
    --     end
    -- end)
    clotheCheck()
end)
 
function clotheCheck()
    if JobsClothe then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local data = {}
            local sex = skin.sex
            for k , v in pairs(ClotheMater) do
                data[v] = skin[v]
            end
            for k , v in pairs(JobsClothe) do
                local ok = true
                if sex == 0 then
                    if v.skin_male then
                        for k2 , v2 in pairs(data) do
                            if v2 ~= v.skin_male[k2] then
                                ok = false
                            end
                        end
                    else
                        ok = false
                    end
                else
                    if v.skin_female then
                        for k2 , v2 in pairs(data) do
                            if v2 ~= v.skin_female[k2] then
                                ok = false
                            end
                        end
                    else
                        ok = false
                    end
                end
                if ok then
                    if CurrentJob ~= k then 
                        CurrentJob = k
                        TriggerEvent('esx:inJob',CurrentJob)
                        TriggerEvent('core:setJobClothe',CurrentJob)
                    end
                else
                    if CurrentJob == k then
                        CurrentJob = 'nojob'
                        TriggerEvent('esx:inJob',CurrentJob)
                        TriggerEvent('core:setJobClothe',CurrentJob)
                    end
                end
            end
        end)
    end
end

exports('clotheCheck',clotheCheck)
exports('getJobsClothe',function()
    while JobsClothe == nil do Wait(100) end
    return JobsClothe
end)
exports('getJob',function()
    return CurrentJob
end)
TriggerEvent('chat:addSuggestion', '/jobs', 'Namayesh menu rahnamaye job ha', {
})