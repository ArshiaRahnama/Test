-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local sound = exports['xsound']
exports('Play',function(name)
    --local url = 'https://ac.sunrp.ir/helpvc/'.. name .. '.mp3'
    local url = 'https://cdn.sunrp.ir/sunco/sound/help/'.. name .. '.mp3'
    sound:PlayUrl('qvoice',url,0.5)
end)

exports('Stop',function()
    sound:Destroy('qvoice')
end)

function Menu()
    local configs = {
        positionX   = "45%",
        positionY   = "50%",
        size        = "0.8", -- size in proportion
        maxHeight   = "80vh", -- maximum menu size ( recommended 30vh to 80vh )
        itemColor = "rgba(0, 0, 0, 0.8)", -- background color of the items
        itemSelectedColor = "rgba(233, 79, 55, 1.0)", -- background color of the selected item
    }
    List = {}
    table.insert(List,{
        img = 'SS_white.png',
        text = 'تی سی (TC)', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Play('05_tc')
    end})

    table.insert(List,{
        img = 'quest.png',
        text = 'سیستم کوئست (Quest)', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Play('04_quest')
    end})
    
    table.insert(List,{
        img = 'ah.png',
        text = 'اکشن هوس (AH)', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Play('06_ah')
    end})

    table.insert(List,{
        img = 'level.png',
        text = 'لول یا تجربه شخصی', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Play('07_level')
    end})

    table.insert(List,{
        img = 'car.png',
        text = 'آموزش خرید ماشین', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Play('08_buycar')
    end})

    table.insert(List,{
        img = 'stop.png',
        text = 'متوقف کردن آموزش', 
        text2 = '', 
        callBack = function()
            exports['sunset_quest']:Stop()
            exports.icon_menu:ForceCloseMenu()
    end})

    exports.icon_menu:OpenMenu(List, configs)
end

RegisterCommand('help',function()
    if SelfLevel <= 5 or (ESX.GetPlayerData()['permission_level'] or 0) > 0 then
        Menu()
        newthread = false
    else
        ESX.Alert('Error','Shoma tajrobe kafi ra darid!','warning',7000)
    end
end)
TriggerEvent('chat:addSuggestion', '/help', 'Open help menu', {
})