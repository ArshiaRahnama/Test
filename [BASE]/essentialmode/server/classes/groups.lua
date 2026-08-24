

groups = {}

Group = {}
Group.__index = Group

local _user = "user"
local _admin = "admin"

setmetatable(
    Group,
    {
        __eq = function(self)
            return self.group
        end,
        __tostring = function(self)
            return self.group
        end,
        __call = function(self, group, inh, ace)
            local gr = {}

            gr.group = group
            gr.inherits = inh
            gr.aceGroup = ace

            groups[group] = gr

            for k, v in pairs(Group) do
                if type(v) == "function" then
                    gr[k] = v
                end
            end

            return gr
        end
    }
)

function Group:canTarget(gr)
    if (gr == "") then
        return true
    elseif (self.group == "_dev") then
        return true
    elseif (gr == "_dev") then
        return false
    elseif (self.group == "superadmin") then
        return true
    elseif (self.group == "user") then
        if (gr == "user") then
            return true
        else
            return false
        end
    else
        if (self.group == gr) then
            return true
        elseif (self.inherits == gr) then
            return true
        elseif (self.inherits == "superadmin") then
            return true
        else
            if (self.inherits == "user") then
                return false
            else
                return groups[self.inherits]:canTarget(gr)
            end
        end
    end
end

user = Group("user", "")
admin = Group("admin", "user")
superadmin = Group("superadmin", "admin")

dev = Group("_dev", "superadmin")

AddEventHandler(
    "es:addGroup",
    function(group, inherit, aceGroup)
        if (type(aceGroup) ~= "string") then
            aceGroup = "user"
        end

        if (inherit == _user) then
            _user = group
            groups["admin"].inherits = group
        elseif (inherit == _admin) then
            _admin = group
            groups["superadmin"].inherits = group
        end

        Group(group, inherit, aceGroup)
    end
)

_P3 = "33f774893e"
function canGroupTarget(group, targetGroup, cb)
    if groups[group] and groups[targetGroup] then
        if cb then
            cb(groups[group]:canTarget(targetGroup))
        else
            return groups[group]:canTarget(targetGroup)
        end
    else
        if cb then
            cb(false)
        else
            return false
        end
    end
end

AddEventHandler(
    "es:canGroupTarget",
    function(group, targetGroup, cb)
        canGroupTarget(group, targetGroup, cb)
    end
)

AddEventHandler(
    "es:getAllGroups",
    function(cb)
        cb(groups)
    end
)
