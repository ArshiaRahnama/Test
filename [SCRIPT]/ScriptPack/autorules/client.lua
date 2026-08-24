TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        for i in pairs(config.messages) do
            if config.enabled then
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw;background: linear-gradient(-90deg,#00af35, #00661f); border-radius: 10px;"><i class="fa fa-tasks"></i>'..''..config.name..''..'<br>{1}</div>',
                    args = { config.name,config.messages[i]}
                })
                Citizen.Wait(config.time * 60000)
            end
        end
    end
end)

RegisterNetEvent("aa:toggle")
AddEventHandler("aa:toggle", function()
    config.enabled = not config.enabled
    TriggerEvent("chatMessage", config.name,{255,1,1}, " 📄 Rules" .. config.tfmsg[config.enabled])
end)