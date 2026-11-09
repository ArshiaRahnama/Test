-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

--[[
    سلام دوست عزیز
    خوشحالم که این متن رو میخونی
    زمانی که این کد رو میزدم فقط من و خدا میدونستیم که این کد چجوری کار میکنه
    ولی فکر کنم بعد یه مدت خودم هم یادم بره چجوری کار میکنه
    امیدوارم لحظات خوب و خوشی رو هنگام بازسازی این کد داشته باشی
    
]]

ESX = exports['essentialmode']:getObject()
usedClothe = {}
clothes = {}
dataLoaded = false
playerLoaded = false
firstSpawn = true
Config.clothe2 = {}
labelTemp = {
    ['tshirt'] = 'T-shirt',
    ['torso'] = 'Lebas',
    ['pants'] = 'Shalvar',
    ['shoes'] = 'Kafsh',
    ['mask'] = 'Mask',
    ['bproof'] = 'Jelighe',
    ['chain'] = 'Gardan band',
    ['helmet'] = 'Kolah',
    ['glasses'] = 'Eynak',
    ['watches'] = 'Sa\'at',
    ['bracelets'] = 'Dastband',
    ['bag'] = 'Kif',
    ['ears'] = 'Gush',
    ['arms'] = 'Dastkesh',
    ['decals'] = 'Neshan',
}
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(1000)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    local tempMale = json.decode(Config.tempClothe[0])
    local tempFemale = json.decode(Config.tempClothe[1])
    Config.noneClotheNum[0] = tempMale
    Config.noneClotheNum[1] = tempFemale
    for k , v in pairs(Config.clothe) do
        if not Config.clothe2[k] then
            Config.clothe2[k] = {}
        end
        for k2 , v2 in pairs(v) do
            if type(v2.num[2]) == 'table' then
                for i = v2.num[2][1],v2.num[2][2] do
                    local new = ESX.CopyTable(v2)
                    new.num[2] = i
                    table.insert(Config.clothe2[k],new)
                end
            else
                table.insert(Config.clothe2[k],v2)
            end
        end
    end
    for k , v in pairs(Config.clothe2) do
        for k2 , v2 in pairs(v) do
            local name = k .. '_' .. (v2.sex == 0 and 'm' or 'f').. '_' .. v2.num[1] .. '_' .. v2.num[2]
            v2.type = k
            v2.name = name
            local label = nil
            if v2.label then
                label = v2.label .. '('.. (v2.sex == 0 and 'M' or 'F') ..')'
            else
                label = labelTemp[k] .. ' '.. v2.num[1] ..' '.. v2.num[2] ..' ('.. (v2.sex == 0 and 'M' or 'F') ..')'
            end
            v2.label = label
            local num = v2.num
            v2.num2 = {v2.num[1],v2.num[2]}
            if k == 'tshirt' then
                -- v2.num = {
                --     {
                --         key = 'tshirt_1',
                --         value = v2.num[1]
                --     },
                --     {
                --         key = 'tshirt_2',
                --         value = v2.num[2]
                --     }
                -- }
                v2.num = {
                    ['tshirt_1'] = v2.num[1],
                    ['tshirt_2'] = v2.num[2],
                }
            elseif k == 'torso' then
                v2.num = {
                    ['torso_1'] = v2.num[1],
                    ['torso_2'] = v2.num[2],
                }
            elseif k == 'pants' then
                v2.num = {
                    ['pants_1'] = v2.num[1],
                    ['pants_2'] = v2.num[2],
                }
            elseif k == 'shoes' then
                v2.num = {
                    ['shoes_1'] = v2.num[1],
                    ['shoes_2'] = v2.num[2],
                }
            elseif k == 'mask' then
                v2.num = {
                    ['mask_1'] = v2.num[1],
                    ['mask_2'] = v2.num[2],
                }
            elseif k == 'bproof' then
                v2.num = {
                    ['bproof_1'] = v2.num[1],
                    ['bproof_2'] = v2.num[2],
                }
            elseif k == 'helmet' then
                v2.num = {
                    ['helmet_1'] = v2.num[1],
                    ['helmet_2'] = v2.num[2],
                }
            elseif k == 'glasses' then
                v2.num = {
                    ['glasses_1'] = v2.num[1],
                    ['glasses_2'] = v2.num[2],
                }
            elseif k == 'watches' then
                v2.num = {
                    ['watches_1'] = v2.num[1],
                    ['watches_2'] = v2.num[2],
                }
            elseif k == 'bracelets' then
                v2.num = {
                    ['bracelets_1'] = v2.num[1],
                    ['bracelets_2'] = v2.num[2],
                }
            elseif k == 'bag' then
                v2.num = {
                    ['bags_1'] = v2.num[1],
                    ['bags_2'] = v2.num[2],
                }
            elseif k == 'ears' then
                v2.num = {
                    ['ears_1'] = v2.num[1],
                    ['ears_2'] = v2.num[2],
                }
            elseif k == 'arms' then
                v2.num = {
                    ['arms'] = v2.num[1],
                    ['arms_2'] = v2.num[2],
                }
            elseif k == 'chain' then
                v2.num = {
                    ['chain_1'] = v2.num[1],
                    ['chain_2'] = v2.num[2],
                }
            elseif k == 'decals' then
                v2.num = {
                    ['decals_1'] = v2.num[1],
                    ['decals_2'] = v2.num[2],
                }
            end
            if v2.personal then
                ESX.addBlockedItem(name)
                -- ESX.addBlockedButCanGiveItem(name)
            end
            clothes[name] = v2
        end
    end
    dataLoaded = true
end)

RegisterNetEvent('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
end)

exports('getClothe2',function()
    while not dataLoaded do Wait(1) end
    return Config.clothe2
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    --xPlayer.data.usedClothe = xPlayer.data.usedClothe or {}
    usedClothe = xPlayer.data.usedClothe or {}
    playerLoaded = true
end)


RegisterNetEvent('clothe:useClothe',function(name)
    toggleClothe(name,nil,true)
    exports['sun-inventory-hud']:loadPlayerInventory()
end)

RegisterNetEvent('esx:removeInventoryItemss',function(label,count,name,newcount)
    if usedClothe[name] and newcount <= 0 then
        removeClothe(name)
    end
end)

function toggleClothe(name,force,anim)
    if not doesHave(name) and not force then return end
    if ESX.isDeadOrCuff() then return end
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanane' or 'mardane') .. ' ast',5000,'error')
    end
    local add = true
    if usedClothe[name] then
        add = false
    end
    if add then
        addClothe(name)
    else
        removeClothe(name)
    end
    if anim then
        exports['sun-inventory-hud']:playClotheAnim(clothes[name].type)
    end
end
exports('toggleClothe', toggleClothe)
function addClothe(name,notsend,addUsed)
    if not doesHave(name) then return end
    local type = clothes[name].type
    unUseByType(type,name)
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanane' or 'mardane') .. ' ast',5000,'error')
    end
    if clothes[name] and clothes[name].access then
        if not ESX.PlayerData.identifier then
            ESX.PlayerData = ESX.GetPlayerData()
        end
        if not clothes[name].access[ESX.PlayerData.gang.name] and not clothes[name].access[ESX.PlayerData.identifier] then
            return ESX.chatMessage('Nemitavanid in item ro beposhid', 'plarms')
        end
    end
    if clothes[name] and clothes[name].prime then
        if not ESX.PlayerData.identifier then
            ESX.PlayerData = ESX.GetPlayerData()
        end
        if not ESX.isPrime() or ESX.getPrimePoint() < clothes[name].prime.point then
            return ESX.chatMessage(('In item baraye prime ast(%s)'):format(clothes[name].prime.point), 'plarms')
        end
    end
    if addUsed then
        usedClothe[name] = true
    end
    if not notsend then
        ESX.TriggerServerCallback('clothe:setUsed',function(__)
            usedClothe = __
            if not doesHave(name) then return end
            local data = clothes[name]
            if data then
                --if data.type == 'tshirt' then
                local num = data.num
                -- local load = {}
                -- for k , v in pairs(num) do
                --     load[k] = v
                -- end
                TriggerEvent('skinchanger:loadStuff',num)
                --end
            end
        end,name,true)
    else
        if not doesHave(name) then return end
        local data = clothes[name]
        if data then
            local num = data.num
            TriggerEvent('skinchanger:loadStuff',num)
        end
    end
end

function removeClothe(name,notsend)
    local sex = getSex()
    if sex ~= clothes[name].sex then
        return ESX.Alert('Error','In lebas '.. (sex == 0 and 'zanane' or 'mardane') .. ' ast',5000,'error')
    end
    if not notsend then
        ESX.TriggerServerCallback('clothe:setUsed',function(__)
            usedClothe = __
            local data = clothes[name]
            if data then
                local load = {}
                for k ,v in pairs(data.num) do
                    local num = Config.noneClotheNum[sex][k]
                    if num then
                        load[k] = num
                    end
                end
                TriggerEvent('skinchanger:loadStuff',load)
            end
        end,name,false)
    else
        usedClothe[name] = nil
        local data = clothes[name]
        if data then
            local load = {}
            for k ,v in pairs(data.num) do
                local num = Config.noneClotheNum[sex][k]
                if num then
                    load[k] = num
                end
            end
            TriggerEvent('skinchanger:loadStuff',load)
        end
    end
end

RegisterNetEvent('clothe:load', function()
    while not dataLoaded or not playerLoaded do
        Citizen.Wait(0)
    end
    if firstSpawn then
        firstSpawn = false
        local save = false
        for k , v in pairs(usedClothe) do
            if not clothes[k] or not doesHave(k) or clothes[k].sex ~= getSex() then
                usedClothe[k] = nil
                save = true
            end
        end
        loadPack(usedClothe,true)
        if save then
            Citizen.Wait(500)
            saveUsed()
        end
        local job = exports['esx_jobs']:getLastJob()
        if job and job ~= '' and job ~= 'nojob' then
            local data = exports['sunset_helper']:getJobsClothe()
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female)
                end
            end)
        end
        Citizen.Wait(3000)
        TriggerEvent('esx:restoreLoadout')
        TriggerEvent('sun:clotheLoaded')
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(0,0,0))
        local distance2 = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(-542.6, -216.61, 37.65))
        local distance3 = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(-2000.36, 3194.38, 32.81))
        if distance < 10 or distance2 < 10 or distance3 < 70 then
            ESX.Game.Teleport(PlayerPedId(),vector3(215,-809,30))
        end
        ESX.TriggerServerCallback('esx_skin:getped', function(data)
            for k , v in pairs(data) do
                if v then
                    if v.used then
                        TriggerEvent("resetpedHandler",k)
                        Wait(500)
                        TriggerEvent("esx:restoreLoadout")
                        TriggerServerEvent('esx_skin:useped',k)
                        break
                    end
                end
            end
        end)

        SetTimeout(30000, function()
            local result = exports['headshot-base64']:getBase64(PlayerPedId())
            if result.success then
                ESX.TriggerServerEvent('clothe:saveHeadShot', result.base64)
            end
        end)
    end
end)

RegisterNetEvent('clothe:usePack',function(name)
    if ESX.isDead() then
        return
    end
    if ESX.tableLength(usedClothe) > 0 then
        return ESX.chatMessage('Ebteda lebas haye khod ra dar avarde, va sepas eghdam be pooshidan pack konid', 'plarms')
    end
    exports['sun-inventory-hud']:packAnim()
    if ESX.tableLength(usedClothe) > 0 then
        return ESX.chatMessage('Ebteda lebas haye khod ra dar avarde, va sepas eghdam be pooshidan pack konid', 'plarms')
    end
    ESX.TriggerServerCallback('clothe:usePack',function(data)
        Citizen.Wait(500)
        local _ = {}
        if data then
            loadPack(data,false,true)
        end
    end,name)
end)

function getSex()
    local p = promise.new()
    local sex = nil
    TriggerEvent('skinchanger:getSkin', function(skin)
        p:resolve(skin.sex)
    end)
    return Citizen.Await(p)
end

function doesHave(name)
    return ESX.DoesHaveItem(name,1,nil,nil,false)
end

function saveUsed()
    ESX.TriggerServerCallback('clothe:setUsed',nil,usedClothe)
end

exports('getUsed',function()
    return usedClothe
end)

function loadPack(_,notsave,pack)
    for k , v in pairs(_) do
        addClothe(k,true,true)
        -- usedClothe[k] = true
    end
    if not notsave then
        saveUsed()
    end
end

exports('loadPack',loadPack)

exports('loadUsed',function()
    loadPack(usedClothe,true)
end)

exports('removeStuff',function(_)
    for k , v in pairs(_) do
        for k2 , v2 in pairs(usedClothe) do
            local data = clothes[k2]
            if data and data.num[k] then
                usedClothe[k2] = nil
            end
        end
    end
    saveUsed()
end)

exports('removeStuffJob',function(_)
    if _ then
        local load = {}
        for k , v in pairs(_) do
            local num = Config.noneClotheNum[getSex()][k]
            if num then
                load[k] = num
            end
        end
        TriggerEvent('skinchanger:loadStuff',load)
    else
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadClothes', skin,  json.decode(Config.tempClothe[skin.sex]))
        end)
    end
end)

function createPack(name)
    if ESX.isDead() then
        return
    end
    local __ = {}
    for k , v in pairs(usedClothe) do
        if not clothes[k].antiSearch then
            __[k] = v
        end
    end
    ESX.TriggerServerEvent('clothe:createPack',__,name)
end
exports('createPack', createPack)

-- function usePack(name)
--     ESX.TriggerServerEvent('clothe:unpack',name)
-- end

function getClotheData(name)
    return clothes[name]
end

exports('getClotheData',getClotheData)

function getUsedType()
    local __ = {}
    for k , v in pairs(usedClothe) do
        if clothes[k] then
            local type = clothes[k].type
            __[type] = true
        end
    end
    for k , v in pairs(Config.clothe) do
        if not __[k] then
            __[k] = false
        end
    end
    return __
end
exports('getUsedType', getUsedType)

function getOwnedClotheByType(type,sexCheck)
    local __ = {}
    local sex = getSex()
    local inventory = ESX.GetPlayerData().inventory
    for k, v in pairs(inventory) do
        local name = v.name:lower()
        local cData = clothes[name]
        if cData and cData.type == type and v.count > 0 and (not sexCheck or cData.sex == sex) then
            cData.name = name
            cData.used = usedClothe[name] == true
            table.insert(__,cData)
        end
    end
    return __
end
exports('getOwnedClotheByType', getOwnedClotheByType)
function unUseByType(_,name)
    for k , v in pairs(usedClothe) do
        if clothes[k] then
            local type = clothes[k].type
            if type == _ and (name == nil or k ~= name) then
                toggleClothe(k,true)
            end
        end
    end
end
exports('unUseByType', unUseByType)

function getOwnedPack()
    local pack = {}
    local inventory = ESX.GetPlayerData().inventory
    for k, v in pairs(inventory) do
        local name = v.name:lower()
        if string.find(name,'pack_') and v.count > 0 then
            table.insert(pack,v)
        end
    end
    return pack
end
exports('getOwnedPack',getOwnedPack)