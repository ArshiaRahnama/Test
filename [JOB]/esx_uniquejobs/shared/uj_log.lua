-- Debug log for the Government / organisation systems. Lines start with [UJ].
-- Server: txAdmin console. Client: F8 console. Search for "[UJ]".
UJ_DEBUG = true

function UJLog(tag, msg)
    if UJ_DEBUG then
        print(('[UJ][%s] %s'):format(tostring(tag), tostring(msg)))
    end
end

-- The job before the current esx:setJob. Every job file's handler calls this with the NEW
-- job name; the first call records the change, the others get the same previous job.
UJJobState = UJJobState or { current = nil, prev = nil }
function UJPrevJob(newName)
    if UJJobState.current ~= newName then
        UJJobState.prev = UJJobState.current
        UJJobState.current = newName
    end
    return UJJobState.prev
end
