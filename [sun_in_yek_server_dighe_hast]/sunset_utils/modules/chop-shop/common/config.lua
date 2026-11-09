-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

chopConfig = {}
chopConfig.DrawDistance = 15
chopConfig.MarkerSize   = {x = 3.0, y = 3.0, z = 3.0}
chopConfig.MarkerSize2   = {x = 0.5, y = 0.5, z = 0.5}
chopConfig.MarkerColor  = {r = 355, g = 0, b = 0}
chopConfig.MarkerType   = 1
chopConfig.craftcoords = {coords = vec(-427.43, 1115.93, 326.78) , head = 77.64}
chopConfig.craftped = GetHashKey('ig_lestercrest_2')
chopConfig.Chopshops = {
    [1] = vec(1540.15, 6335.79, 23.07),
    [2] = vec(384.47, 3561.81, 32.31),
    [3] = vec(2423.56, 3131.04, 47.02),
    [4] = vec(-3090.3, 1903.65, 0.2),
}
chopConfig.tokenzero = 5000
chopConfig.sell = {}
chopConfig.craftengine = {}

chopConfig.ChopParts = {
    all = {
        {name = 'hood', bone = 'bonnet', door = 4, type = 'hood', time = 25000, insurancedtime = 34000},
        {name = 'trunk', bone = 'boot', door = 5, type = 'trunk', time = 10000, insurancedtime = 14000},
        {name = 'Dar ranande', bone = 'door_dside_f', door = 0, type = 'door', time = 30000, insurancedtime = 41000},
        {name = 'Dar shagerd', bone = 'door_pside_f', door = 1, type = 'door', time = 30000, insurancedtime = 41000},
        {name = 'Dar aghab samte chap', bone = 'door_dside_r', door = 2, type = 'door', time = 3000, insurancedtime = 4000},
        {name = 'Dar aghab samte rast', bone = 'door_pside_r', door = 3, type = 'door', time = 3000, insurancedtime = 4000},
        {name = 'charkh ranande', bone = 'wheel_lf', wheel = 0, type = 'wheel', time = 20000, insurancedtime = 27000},
        {name = 'charkh shagerd', bone = 'wheel_rf', wheel = 1, type = 'wheel', time = 20000, insurancedtime = 27000},
        {name = 'charkh aghab samte chap', bone = 'wheel_lr', wheel = 4, type = 'wheel', time = 20000, insurancedtime = 27000},
        {name = 'charkh aghab samte rast', bone = 'wheel_rr', wheel = 5, type = 'wheel', time = 20000, insurancedtime = 27000},
    },
    [8] = {
        {name = 'hood', bone = 'bonnet', door = 4, type = 'hood', time = 10000, insurancedtime = 15000},
        {name = 'trunk', bone = 'boot', door = 5, type = 'trunk', time = 10000, insurancedtime = 15000},
        {name = 'Dar ranande', bone = 'door_dside_f', door = 0, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'Dar shagerd', bone = 'door_pside_f', door = 1, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'Dar aghab samte chap', bone = 'door_dside_r', door = 2, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'Dar aghab samte rast', bone = 'door_pside_r', door = 3, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'charkh ranande', bone = 'wheel_lf', wheel = 0, type = 'wheel', time = 80000, insurancedtime = 110000},
        {name = 'charkh shagerd', bone = 'wheel_rf', wheel = 1, type = 'wheel', time = 80000, insurancedtime = 110000},
        {name = 'charkh aghab samte chap', bone = 'wheel_lr', wheel = 4, type = 'wheel', time = 80000, insurancedtime = 110000},
        {name = 'charkh aghab samte rast', bone = 'wheel_rr', wheel = 5, type = 'wheel', time = 80000, insurancedtime = 110000},
    },
    [15] = {
        {name = 'hood', bone = 'bonnet', door = 4, type = 'hood', time = 10000, insurancedtime = 55000},
        {name = 'trunk', bone = 'boot', door = 5, type = 'trunk', time = 10000, insurancedtime = 55000},
        {name = 'Dar ranande', bone = 'door_dside_f', door = 0, type = 'door', time = 40000, insurancedtime = 55000},
        {name = 'Dar shagerd', bone = 'door_pside_f', door = 1, type = 'door', time = 40000, insurancedtime = 55000},
        {name = 'Dar aghab samte chap', bone = 'door_dside_r', door = 2, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'Dar aghab samte rast', bone = 'door_pside_r', door = 3, type = 'door', time = 10000, insurancedtime = 15000},
        {name = 'charkh ranande', bone = 'wheel_lf', wheel = 0, type = 'wheel', time = 20000, insurancedtime = 28000},
        {name = 'charkh shagerd', bone = 'wheel_rf', wheel = 1, type = 'wheel', time = 20000, insurancedtime = 28000},
        {name = 'charkh aghab samte chap', bone = 'wheel_lr', wheel = 4, type = 'wheel', time = 20000, insurancedtime = 28000},
        {name = 'charkh aghab samte rast', bone = 'wheel_rr', wheel = 5, type = 'wheel', time = 20000, insurancedtime = 28000},
    },
}

chopConfig.PartProps = {
    hood = 'imp_prop_impexp_bonnet_02a',
    trunk = 'imp_prop_impexp_bonnet_02a',
    door = 'imp_prop_impexp_car_door_04a',
    wheel = 'imp_prop_impexp_tyre_01b'
}

chopConfig.OutlineColor = {r = 255, g = 165, b = 0}
chopConfig.MaxChopDistance = 10.0
chopConfig.chopTime = 10000
chopConfig.insuredChopTime = 20000
chopConfig.maxChopTime = 450

chopConfig.fallbackPart = {
    {name = 'Oragh', bone = '', type = 'timer', time = 160000, insurancedtime = 240000}
}