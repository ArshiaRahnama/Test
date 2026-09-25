-- Quiet-by-default logging. Every informational print() in this resource was
-- routed through dprint(): nothing is written to the server console / F8 unless
-- you turn debug on with   set unique_adminpanel_debug 1   in server.cfg
-- (or `setr unique_adminpanel_debug 1` to also see it on clients).
local enabled = GetConvar('unique_adminpanel_debug', '0') == '1'

function dprint(...)
    if enabled then print(...) end
end
