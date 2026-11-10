-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local EMAIL_PAGE_SIZE = 30

local function EnrichEmails(emails)
    for i, v in pairs(emails or {}) do
        local job = Config.Services[v.institution]
        emails[i].avatar = 'https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/' .. v.institution .. '.png'
        emails[i].name = job and job.label or v.institution:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end)
    end
    return emails
end

RegisterNUICallback('get-emails', function(body, cb)
    if CachedData.emails then
        return cb(CachedData.emails)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetEmails', function(page)
        if not page then return cb({ emails = {}, has_more = false }) end

        local result = {
            emails = EnrichEmails(page.emails),
            has_more = page.has_more and true or false
        }
        CachedData.emails = result
        cb(result)
    end, { limit = tonumber(body and body.limit) or EMAIL_PAGE_SIZE })
end)

RegisterNUICallback('get-emails-older', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetEmailsOlder', function(page)
        if not page then return cb({ emails = {}, has_more = false }) end
        cb({
            emails = EnrichEmails(page.emails),
            has_more = page.has_more and true or false
        })
    end, {
        before_ts = body and body.before_ts,
        limit = tonumber(body and body.limit) or EMAIL_PAGE_SIZE
    })
end)

RegisterNUICallback('mark-all-emails-read', function(_, cb)
    if CachedData.emails and CachedData.emails.emails then
        for i in pairs(CachedData.emails.emails) do
            CachedData.emails.emails[i].is_read = true
        end
    end
    ESX.TriggerServerEvent('sun-phone:server:MarkAllEmailsRead')
    cb('ok')
end)

RegisterNUICallback('mark-email-read', function(body, cb)
    local ts = tonumber(body and body.id)
    if ts then
        if CachedData.emails and CachedData.emails.emails then
            for i, v in pairs(CachedData.emails.emails) do
                if tonumber(v.ts) == ts then
                    CachedData.emails.emails[i].is_read = true
                    break
                end
            end
        end
        ESX.TriggerServerEvent('sun-phone:server:MarkEmailRead', ts)
    end
    cb('ok')
end)
