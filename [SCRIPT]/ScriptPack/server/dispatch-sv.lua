ESX = nil
local badges = {}
local dictonary = {
    ["police"] = "Officers",
    ["mechanic"] = "Mechanics",
    ["ambulance"] = "Medics",
    ["sheriff"] = "Sheriffs",
    ["taxi"] = "Taxis",
    ["mt"] = "MT",
    ["coffee"] = "Karkonan",
    ["cid"] = "CID",
    ["cia"] = "CIA",
    ["marshal"] = "Marshals",
    ["fbi"] = "FBI",
    ["judge"] = "Judges",
    ["doa"] = "DOA",
    ["weazel"] = "Weazel",

    -- Holding 1 (uniquecafejobs)
    ["meridian"] = "Holding 1 Staff",
    ["uwucafe"] = "Cafe UwU Staff",
    ["obsidian"] = "Cafe Obsidian Staff",
    ["voltage"] = "Cafe Voltage Staff",
    ["ember"] = "Restaurant Ember Staff",
    ["anchor"] = "Restaurant Anchor Staff",
    ["crimson"] = "Restaurant Crimson Staff",
    ["flourish"] = "Bakery Flourish Staff",
    ["goldcrust"] = "Bakery GoldCrust Staff",
    ["static"] = "Bar Static Staff",
    ["nightjar"] = "Bar Nightjar Staff",
    ["firebrick"] = "Pizza Firebrick Staff",
    ["slice"] = "Pizza Slice Staff",
    ["frostbite"] = "Bastani Frostbite Staff",
    ["sundae"] = "Bastani Sundae Staff",
    ["koi"] = "Sushi Koi Staff",
    ["wasabi"] = "Sushi Wasabi Staff",
    ["carwash"] = "Carwash Suds Staff",
}

-- ================= ORGAN (Department) grouping =================
-- Used by /f (faction chat: only same-organ jobs see it) and
-- /dep (department chat: every organ member, across all 3 groups, sees it).
-- Add a job's short name here (NOT the "off" variant, that's handled
-- automatically below) if it should belong to one of these organs.
local organGroups = {
    doj = { "cid", "cia", "marshal", "fbi", "judge", "doa" },        -- Department Of Justice
    le = { "police", "sheriff", "mt" },                              -- Law Enforcement
    services = { "taxi", "mechanic", "ambulance", "weazel" },        -- Organ Services

    -- Holding 1 (uniquecafejobs): all 17 businesses + the holding job itself.
    -- /f reaches everyone in this whole group; /dep reaches every group above too.
    holding1 = {
        "meridian",
        "uwucafe", "obsidian", "voltage",
        "ember", "anchor", "crimson",
        "flourish", "goldcrust",
        "static", "nightjar",
        "firebrick", "slice",
        "frostbite", "sundae",
        "koi", "wasabi",
        "carwash",
    },
}

local organLabel = {
    doj = "Department Of Justice",
    le = "Law Enforcement",
    services = "Organ Services",
    holding1 = "Holding 1",
}

-- jobToOrgan["police"] = "le", jobToOrgan["offpolice"] = "le", etc.
-- Built automatically from organGroups so adding a job above is the only
-- thing needed to plug a new job into /f and /dep.
local jobToOrgan = {}
for organKey, jobs in pairs(organGroups) do
    for _, jobName in ipairs(jobs) do
        jobToOrgan[jobName] = organKey
        jobToOrgan["off" .. jobName] = organKey
    end
end

local function isOffDuty(jobName)
    return string.sub(jobName, 1, 3) == "off"
end

local rankdict = {
    [1] = "^*Intern",
    [2] = "^*HELPER",
    [3] = "^*HEAD HELPER",
    [4] = "^*ADMIN",
    [5] = "^*SENIOR ADMIN",
    [6] = "^*HEAD ADMIN",
    [7] = "^*MODERATOR",
    [8] = "^*SUPERVISOR",
    [9] = "^*ADMIN MANAGER",
    [10] = "^*MANAGER",
    [11] = "^*CO OWNER",
    [12] = "^*OWNER",
    [13] = "^*DEVELOPER"
}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('flist', function(source, args)
    
        local xPlayer = ESX.GetPlayerFromId(source)
        local onduties = 0
        local offduties = 0
        local total1 = 0

        if dictonary[xPlayer.job.name] then

            local job = xPlayer.job.name
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                
                if xPlayer.job.name == job then
                    onduties = onduties + 1
                    TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[^2^*On-Duty^4] ^3" .. string.gsub(xPlayer.name, "_", " ") }})
                elseif xPlayer.job.name == 'off' .. job then
                    offduties = offduties + 1
                    TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[^2^*Off-Duty^4] ^3" .. string.gsub(xPlayer.name, "_", " ") }})
                end

            end
            total1 = onduties + offduties
            TriggerClientEvent('esx:showNotification', source, '~h~~g~' .. total1 .. '~w~ '.. dictonary[job] .. ' Online' .. '~n~On Duty: ~g~' .. onduties .. '~w~~n~Off Duty: ~r~' .. offduties)   

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
        end

    end)

    RegisterCommand('admins', function(source, args)
    
        local xPlayer = ESX.GetPlayerFromId(source)
        local onduties = 0
        local offduties = 0
        local total1 = 0
        local color 
        local admins = exports.esx_playerinfo:GetAdmins()
        
        if TableLengthx(admins) == 0 then
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich admini baraye namayesh vojod nadarad!")
            return
        end

        for k,v in pairs(admins) do
            if xPlayer.permission_level >= 1 then
                local zPlayer = ESX.GetPlayerFromId(v.id)
                local aduty = zPlayer.get('aduty')
                if aduty then
                    color = "^2"
                    onduties = onduties + 1
                    --TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3" .. GetPlayerName(v.id) }})
                else
                    color = "^1"
                    offduties = offduties + 1
                    --TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3" .. GetPlayerName(v.id) }})
                end
            else
                local zPlayer = ESX.GetPlayerFromId(v.id)
                local aduty = zPlayer.get('aduty')
                if aduty then
                    color = "^2"
                    onduties = onduties + 1
                    --TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3(" .. GetPlayerName(v.id).." | "..v.id..")" }})
                else
                    color = "^1"
                    offduties = offduties + 1
                   -- TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = true, args = {"^4[" .. color.. rankdict[v.perm] .."^4] ^3(" .. GetPlayerName(v.id).." | "..v.id..")" }})
                end
            end
        end

        total1 = onduties + offduties
        TriggerClientEvent('esx:showNotification', source,'~h~~g~' .. total1 .. '~w~ Staff Online.' .. '~n~On Duty: ~g~' .. onduties .. '~w~~n~Off Duty: ~r~' .. offduties)   
      
      end)

    RegisterCommand('f', function(source, args)

        local xPlayer = ESX.GetPlayerFromId(source)
        local organ = jobToOrgan[xPlayer.job.name]

        if organ then
            if not args[1] then
                return
            end

                local dutytext = nil
                local jobGrade = xPlayer.job.grade_label
                local name = GetPlayerName(source)
                local message = table.concat(args, " ")

                if xPlayer.job.name == "psuspend" then
                    dutytext = "^4[^2^*Suspended ^4| ^1^*"
                elseif isOffDuty(xPlayer.job.name) then
                    dutytext = "^4[^2^*Off-Duty ^4| ^1^*"
                else
                    dutytext = "^4[^2^*On-Duty ^4| ^1^*"
                end

                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers do
                    local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                    -- same ORGAN (DOJ / Law Enforcement / Organ Services), not just same exact job
                    if jobToOrgan[tplayer.job.name] == organ then
                        TriggerClientEvent('chatMessage', xPlayers[i], "", {255, 0, 0}, dutytext .. "^1" ..jobGrade .. "^4]: ^3" .. name .. " ^4(( " .. "^0^*" .. message .. "^4 ))")
                    end
                end
            
    
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
        end
    
    end)


    RegisterCommand("r", function(source, args)
        --local freq = exports.pma-voice:GetRadioChannel(source)
        local freq = exports["pma-voice"]:GetRadioChannel(source)
        if freq ~= 0 then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat message chizi vared nakardid!")
                return
            end
            
            local message = table.concat(args, " ", 1)
            TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. source .." ^8^*: ^r", "^0^* " .. message , false)
            TriggerClientEvent('rp_radio:recieveMessage', -1, {id = source, freq = freq, message = message})

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan radio khod ra roshan konid!")
        end
    end, false)

    RegisterCommand("sr", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "mechanic" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "government" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "artesh"then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid payam khali befrestid!")
                return
            end

            if xPlayer.job.grade >= 4 then
                local name = string.gsub(xPlayer.name, "_", " ")
                local job = xPlayer.job.name
                local jobGrade = xPlayer.job.grade_label
                local message = table.concat(args, " ", 1)
    
                TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. name.." ^8^*: ^r", "^0^* " .. message , false)
    
                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers do
                    local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                    if tplayer.job.name == job then
                        --TriggerClientEvent('InteractSound_CL:PlayOnOne', tplayer.source, 'pager', 1.0)
                        TriggerClientEvent('chatMessage', tplayer.source, "", {255, 0, 0}, "^4[^2^*Radio ^4| ^1^*".. jobGrade .. "^4] ^3" .. name.." ^8^*^~>>^r" .. "^2^* " .. message)
                    end
                end
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
            end

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
    end, false)

    RegisterCommand("dep", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        local organ = jobToOrgan[xPlayer.job.name]

        if organ then
            if not args[1] then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid payam khali befrestid!")
                return
            end

            local name = string.gsub(xPlayer.name, "_", " ")
            local job  = string.upper(xPlayer.job.name)
            local message = table.concat(args, " ", 1)

            TriggerClientEvent("sendProximityMessageradio",-1, source, "^4[^2^*Radio^4] ^3" .. name.." ^8^*: ^r", "^0^* " .. message , false)

            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers do
                local tplayer = ESX.GetPlayerFromId(xPlayers[i])
                -- /dep is department-wide: EVERY organ member sees it, regardless of
                -- which of the 3 organs (DOJ / Law Enforcement / Organ Services) they're in
                if jobToOrgan[tplayer.job.name] then
                    TriggerClientEvent('chatMessage', tplayer.source, "", {255, 0, 0}, "^4[^2^*Department ^4| ^1^*".. job .. "^4] ^3" .. name.." ^8^*:^r" .. "^0^* " .. message)
                end
            end

        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
    end, false)


    RegisterCommand('badge', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        if jobToOrgan[xPlayer.job.name] then
            TriggerClientEvent('scriptpack:playBadgeAnim', source)

            local playerName = string.gsub(xPlayer.get('name'), "_", " ")
            local playerJob = xPlayer.job.label
            local playerJobGrade = xPlayer.job.grade_label
            local playerPed = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(playerPed)
            local xPlayers = ESX.GetPlayers()

            for i=1, #xPlayers, 1 do
                local otherPlayerPed = GetPlayerPed(xPlayers[i])
                local otherPlayerCoords = GetEntityCoords(otherPlayerPed)
                local distance = math.sqrt((playerCoords.x - otherPlayerCoords.x) ^ 2 + (playerCoords.y - otherPlayerCoords.y) ^ 2 + (playerCoords.z - otherPlayerCoords.z) ^ 2)
                if distance < 15.0 then
                    TriggerClientEvent('chatMessage', xPlayers[i], "", {252, 1, 1}, "Job Badge:\n^5Name: ^0" .. playerName .. "\n^5Job: ^0" .. playerJob .. "\n^5Job Grade: ^0" .. playerJobGrade)
                end
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
    end, false)

    RegisterCommand('assign', function(source, args)

        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then

            local perm
            if xPlayer.job.name == "police" then
                perm = 8
            elseif xPlayer.job.name == "ambulance" then
                perm = 4
            end

            if perm > xPlayer.job.grade then
                if not xPlayer.hasDivision("hr") then
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye in dastor kafi nist!")
                    return
                end
            end

            if not args[1] then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                return
            end
    
            if not tonumber(args[1]) then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
                return
            end
    
            if not args[2] then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat badge chizi vared nakardid!")
                return
            end
    
            if not tonumber(args[2]) then 
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat badge faghat mitavanid adad vared konid!")
                return
            end
    
            if string.len(args[2]) > 4 then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Badge nemitavanad bishtar az 4 ragham bashad!")
                return
            end

            local target = tonumber(args[1])
            local zPlayer = ESX.GetPlayerFromId(target)
        
            if not zPlayer then
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID playe rmored nazar sahih nist!")
                return
            end

            if zPlayer.job.name == xPlayer.job.name then
                if badges[zPlayer.identifier] then
                    badges[zPlayer.identifier].badge = tonumber(args[2])
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge ^3 " .. string.gsub(zPlayer.name, "_", " ") .. "^0 ra be ^2" .. args[2] .. "^0 taghir dadid!")
                    TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Badge shoma be ^1 " .. args[2] .. "^0 taghir yaft!")
                else
                    badges[zPlayer.identifier] = {badge = tonumber(args[2]), hide = false, isOn = false}
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma badge ^3 " .. string.gsub(zPlayer.name, "_", " ") .. "^0 ra be ^2" .. args[2] .. "^0 taghir dadid!")
                    TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Badge shoma be ^1 " .. args[2] .. "^0 taghir yaft!")
                end
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Fard mored nazar ham shoghl shoma nist!")
            end
            
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv hich organ dolati nistid!")
        end
        
    end, false)

    AddEventHandler('esx:playerLoaded', function(source)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" or xPlayer.job.name == "offpolice" then

            MySQL.Async.fetchAll("SELECT badge FROM users WHERE identifier = @identifier", { ["@identifier"] = xPlayer.identifier }, function(result)

                if result then
        
                    local badge = result[1].badge
                    badges[xPlayer.identifier] = {badge = badge, hide = false, isOn = false}

        
                else
                    print('Moshkeli dar gereftan badge ' .. GetPlayerName(_source) .. ' pish amad lotfan peygiri konid!')
                end
        
            end)
        
        end
    
    end)

    AddEventHandler('playerDropped', function()
	
        local _source = source

            if _source ~= nil then
                local identifier = GetPlayerIdentifier(_source)

                if badges[identifier] then
                    local badgeN = badges[identifier].badge

                    MySQL.Async.execute('UPDATE users SET badge = @badge WHERE identifier=@identifier', 
                    {
                        ['@identifier'] = identifier,
                        ['@badge'] = badgeN
                        
                    }, function(rowsChanged)
    
                        if rowsChanged == 0 then
                            print('Moshkeli dar save kardan badge ' .. GetPlayerName(_source) .. ' pish amad lotfan peygiri konid!')
                            return
                        end

                        badges[identifier] = nil
    
                    end)

                    
                end
    
            end
    
    end)
    

    RegisterCommand("invite", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.job.name
        if job == "police" or job == "ambulance" then
            if job == "police" then
                if xPlayer.job.grade >= 14 then
                    if not args[1] then
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                       return
                    end

                    if not tonumber(args[1]) then
                         TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid")
                        return
                    end

                    local target = tonumber(args[1])

                    local zPlayer = ESX.GetPlayerFromId(target)
                    
                    if zPlayer then
                        if zPlayer.job.name == "nojob" then
                            zPlayer.setJob(job, 0)
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat ^3" .. string.gsub(zPlayer.source, "_", " ") .. "^0 ra estekhdam kardid!")
                            TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma be estekhdam ^2police ^0 darmadid!")
                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid yek fard shaghel ra estekhdam konid!")
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast")
                    end
                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
                end
            elseif job == "ambulance" then
                if xPlayer.job.grade >= 4 then
                    if not args[1] then
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID chizi vared nakardid!")
                       return
                    end

                    if not tonumber(args[1]) then
                         TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid")
                        return
                    end

                    local target = tonumber(args[1])

                    local zPlayer = ESX.GetPlayerFromId(target)
                    
                    if zPlayer then
                        if zPlayer.job.name == "nojob" then
                            zPlayer.setJob(job, 0)
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat ^3" .. string.gsub(zPlayer.source, "_", " ") .. "^0 ra estekhdam kardid!")
                            TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma be estekhdam ^2Medic ^0 darmadid!")
                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid yek fard shaghel ra estekhdam konid!")
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0ID vared shode eshtebah ast")
                    end

                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
                end
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Dastresi shoma baraye estefade az in dastor kafi nist!")
        end
    end, false)

function TableLengthx(table)

    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count

end