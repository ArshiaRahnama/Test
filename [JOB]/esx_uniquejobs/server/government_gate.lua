-- Government gate for the SERVER side of the organisations.
-- Government can do what every job can do. Used by the job checks in server/*.lua.
function IsJobOrGovSrc(xPlayer, job)
    if not xPlayer or not xPlayer.job then return false end
    if xPlayer.job.name == 'government' then return true end
    if xPlayer.job.name == job and OrgIsEnabled and not OrgIsEnabled(job) then return false end
    return xPlayer.job.name == job
end
