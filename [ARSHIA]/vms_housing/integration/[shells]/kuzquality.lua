if not Config.Shells.KuzQuality then
    return
end

AddEventHandler('vms_housing:init', function()
    local shells = {}

    local kqShells = GlobalState.vms_housing_kq_shells
    if kqShells and next(kqShells) then
        for k, v in pairs(kqShells) do
            shells['kq_sbx_shell_' .. v.id] = {
                label = v.title,
    
                tags = {'kuzquality'},
                rooms = 1,
    
                model = 'kq_sbx_shell_' .. v.id,
    
                doors = {
                    x = v.spawnPoint.x,
                    y = v.spawnPoint.y,
                    z = 500.0 + (v.spawnPoint.z * 1.5),
                    heading = v.spawnPoint.w
                },
            }
        end

        addShells(shells)

        reloadShells()
    end
end)