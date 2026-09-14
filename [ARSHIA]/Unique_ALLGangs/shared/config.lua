
BossData = {}
BossData.Mysql = "mysql-async"
function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if BossData.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
            -------------------------------- 
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
        -------------------------------- 
    elseif BossData.Mysql == "ghmattimysql" then
        exports.ghmattimysql:execute(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    elseif BossData.Mysql == "mysql-async" then   
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
        -------------------------------- 
    end
    while IsBusy do
        Wait(0)
    end
    return result
end

