RegisterCommand('migratehouses', function(source, args, rawCommand)
    if source ~= 0 then
        print('The command can only be used in the console.')
        return
    end

    if Migration[args[1]] then
        print('Started migration from ' .. args[1] .. ' to vms_housing.')
        Migration[args[1]]()
        print('^1To ensure full functionality, restart the server!^7')
    else
        print('Housing ' .. args[1] .. ' is not supported for migration.')
        print('You can add migration command in the vms_housing/integration/[migration]/')
    end
end, true)