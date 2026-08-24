ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerPed = false
local PlayerPos = false
local PlayerLastPos = 0
local current = nil
InUse = false
currentmenu = nil
inScenario = false
debug = false
local MultiKey = false

local cam = nil
local radius = 1.5
local angleY = 0.0
local angleZ = 0.0
local CameraZOffset = 0.5

Citizen.CreateThread(function()
    Wait(500)

    for i = 1, #SitConfig.PolySeats do
        local NewIndex = #SitConfig.objects + 1
        SitConfig.objects[NewIndex] = SitConfig.PolySeats[i]
        if SitConfig.objects[NewIndex] then
            SitConfig.objects[NewIndex].IsPolySeat = true
        end
        Wait(5)
    end

    for i = 1, #SitConfig.custom_seats do
        local NewIndex = #SitConfig.objects + 1
        SitConfig.objects[NewIndex] = SitConfig.custom_seats[i]
        if SitConfig.objects[NewIndex] then
            SitConfig.objects[NewIndex].IsCustomSeat = true
        end
        Wait(5)
    end

    for i = 1, #SitConfig.objects do
        Wait(50)
        options =  {}
        OxParams =  {}
        TargetOptions = {}
        if SitConfig.objects[i] then
            if SitConfig.TargetSytem == 'OX' then
                if SitConfig.objects[i].objName then
                    if SitConfig.objects[i].multiSeat then
                        for z = 1, #SitConfig.objects[i].Animations do
                            Wait(10)
                            OXtargetOption = {
                                name = SitConfig.OxContextName .. z,
                                icon = 'fas fa-chair',
                                label = SitConfig.OxTargetLabel .. SitConfig.objects[i].multiSeat[z],
                                distance = 2.0,
                                canInteract = function(entity, distance, coords, name)
                                    return DoesEntityExist(entity)
                                end,
                                TableRun = SitConfig.objects[i].Animations ,
                                IndexKey = i,
                                MultiKey = z,
                                onSelect = function(dataTarg)
                                        for o = 1, #dataTarg.TableRun[dataTarg.MultiKey] do
                                            Wait(10)
                                            local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].anim
                                            local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].dict
                                            if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                            elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                            end
                                            local NewInfo = {
                                                    title = dataTarg.TableRun[dataTarg.MultiKey][o].title,
                                                    description = dataTarg.TableRun[dataTarg.MultiKey][o].description,
                                                    args = {
                                                        current = SitConfig.objects[dataTarg.IndexKey],
                                                        ActiveAnimIndex = o,
                                                        entity = dataTarg.entity,
                                                        coords = dataTarg.coords,
                                                    },
                                                    onSelect = function(data)
                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].object = data.entity
                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading or false
                                                        TriggerEvent('ChairBedSystem:Client:Animation', data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex], data.coords, dataTarg.IndexKey , data.ActiveAnimIndex ,dataTarg.MultiKey)
                                                        InUse = data.current
                                                        InUse.details = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex]
                                                        SeatActivation()
                                                    end
                                                }
                                            options[#options+1] = NewInfo
                                            if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                            end
                                    end

                                    local menuTitle = SitConfig.OxContextMenuTitle .. SitConfig.objects[dataTarg.IndexKey].multiSeat[dataTarg.MultiKey]
                                    local menuId = "Seat id " .. dataTarg.IndexKey
                                    lib.registerContext({
                                            id = menuId,
                                            title = menuTitle,
                                            options = options
                                        })
                                    lib.showContext(menuId, dataTarg)
                                    options = {}
                                    currentmenu = menuId
                                end
                            }
                            TargetOptions[#TargetOptions+1] = OXtargetOption
                            OXtargetOption = {}
                        end
                    else
                        OXtargetOption = {
                        name = 'Seat Sytle',
                        icon = 'fas fa-chair',
                        label = SitConfig.OxTargetLabel,
                        distance = 2.0,
                        canInteract = function(entity, distance, coords, name)
                            return DoesEntityExist(entity)
                        end,
                        TableRun = SitConfig.objects[i].Animations ,
                        IndexKey = i,
                        onSelect = function(dataTarg)
                                    for o = 1, #dataTarg.TableRun do

                                        local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[o].anim
                                        local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[o].dict

                                        if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                            dataTarg.TableRun[o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                            dataTarg.TableRun[o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                        elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                            dataTarg.TableRun[o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                            dataTarg.TableRun[o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                        end
                                        Wait(10)

                                        local checkcoords = GetOffsetFromEntityInWorldCoords(dataTarg.entity,dataTarg.TableRun[o].right_left_X,dataTarg.TableRun[o].forward_backwards_Y,dataTarg.TableRun[o].up_down_z)

                                        local NewInfo = {
                                                title = dataTarg.TableRun[o].title,
                                                description = dataTarg.TableRun[o].description,
                                                args = {
                                                    current = SitConfig.objects[dataTarg.IndexKey],
                                                    ActiveAnimIndex = o,
                                                    entity = dataTarg.entity,
                                                    coords = dataTarg.coords,
                                                },
                                                onSelect = function(data)
                                                    if SitConfig.Debug then
                                                        for k,v in pairs(data) do
                                                            print(k,v)
                                                        end
                                                        if not data.current.Animations[data.ActiveAnimIndex] then
                                                            data.ActiveAnimIndex = 1
                                                        end
                                                        for k,v in pairs(data.current.Animations[data.ActiveAnimIndex] ) do
                                                            print(k,v)
                                                        end
                                                    end

                                                    data.current.Animations[data.ActiveAnimIndex].object = data.entity

                                                    data.current.Animations[data.ActiveAnimIndex].DynamicHeading = data.current.Animations[data.ActiveAnimIndex].DynamicHeading or false
                                                    TriggerEvent('ChairBedSystem:Client:Animation', data.current.Animations[data.ActiveAnimIndex], data.coords , data.IndexKey , data.ActiveAnimIndex )
                                                    InUse = data.current
                                                    InUse.details = data.current.Animations[data.ActiveAnimIndex]
                                                    SeatActivation()
                                                end
                                            }
                                        options[#options+1] = NewInfo
                                        if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                        end
                                end
                                local menuTitle = SitConfig.OxContextMenuTitle
                                local menuId = "Seat id " .. dataTarg.IndexKey
                                lib.registerContext({
                                        id = menuId,
                                        title = menuTitle,
                                        options = options
                                    })
                            lib.showContext(menuId, dataTarg)
                            options = {}
                            currentmenu = menuId
                        end
                    }
                    TargetOptions[#TargetOptions+1] = OXtargetOption
                    end
                else
                    if SitConfig.objects[i].multiSeat then
                        OxParams ={




                            points =  SitConfig.objects[i].points,
                            thickness =  SitConfig.objects[i].thickness,
                            debug = SitConfig.objects[i].debug,
                            options = {},
                            name = 'Seat Sytle',
                            icon = 'fas fa-chair',
                            label = SitConfig.OxTargetLabel,
                            distance = 2.0,
                        }
                        for z = 1, #SitConfig.objects[i].Animations do
                            Wait(10)
                            OXtargetOption = {
                                name = SitConfig.OxContextName .. z,
                                icon = 'fas fa-chair',
                                label = SitConfig.OxContextLabel .. SitConfig.objects[i].multiSeat[z],
                                distance = 2.0,
                                canInteract = function(entity, distance, coords, name)
                                    return distance < SitConfig.objects[i].distance
                                end,
                                TableRun = SitConfig.objects[i].Animations ,
                                IndexKey = i,
                                MultiKey = z,
                                onSelect = function(dataTarg)
                                        for o = 1, #dataTarg.TableRun[dataTarg.MultiKey] do

                                            local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].anim
                                            local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].dict
                                            if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                            elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                            end

                                            Wait(10)
                                            local NewInfo = {
                                                    title = dataTarg.TableRun[dataTarg.MultiKey][o].title,
                                                    description = dataTarg.TableRun[dataTarg.MultiKey][o].description,
                                                    args = {
                                                        current = SitConfig.objects[dataTarg.IndexKey],
                                                        ActiveAnimIndex = o,
                                                        coords = SitConfig.objects[i].Seats[z],
                                                    },
                                                    onSelect = function(data)
                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading or false
                                                        TriggerEvent('ChairBedSystem:Client:AnimationCooordsBased', data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex], data.coords, dataTarg.IndexKey , data.ActiveAnimIndex ,dataTarg.MultiKey)
                                                        InUse = data.current
                                                        InUse.details = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex]
                                                        SeatActivation()
                                                    end
                                                }
                                            options[#options+1] = NewInfo
                                            if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                            end
                                        end
                                    local menuTitle = SitConfig.OxContextMenuTitle .. SitConfig.objects[dataTarg.IndexKey].multiSeat[dataTarg.MultiKey]
                                    local menuId = "Seat id " .. dataTarg.IndexKey
                                    lib.registerContext({
                                            id = menuId,
                                            title = menuTitle,
                                            options = options
                                        })
                                    lib.showContext(menuId, dataTarg)
                                    options = {}
                                    currentmenu = menuId
                                end
                            }
                            TargetOptions[#TargetOptions+1] = OXtargetOption
                            OXtargetOption = {}
                        end
                    end
                end
                if #TargetOptions > 0 then
                    if SitConfig.objects[i].objName then
                        exports.ox_target:addModel(SitConfig.objects[i].objName, TargetOptions)
                    elseif SitConfig.objects[i].points then
                        OxParams.options= TargetOptions

                        ZoneID = exports.ox_target:addPolyZone(OxParams)
                        SitConfig.objects[i].ZoneID = ZoneID
                    end
                end
            elseif SitConfig.TargetSytem == 'QB' then
                if SitConfig.objects[i].objName then
                    if SitConfig.objects[i].multiSeat then
                        for z = 1, #SitConfig.objects[i].Animations do
                            Wait(10)
                            OXtargetOption = {
                                name = SitConfig.OxContextName .. z,
                                icon = 'fas fa-chair',
                                label = SitConfig.OxTargetLabel .. SitConfig.objects[i].multiSeat[z],
                                distance = 2.0,
                                canInteract = function(entity, distance, coords, name)
                                    return DoesEntityExist(entity)
                                end,
                                TableRun = SitConfig.objects[i].Animations ,
                                IndexKey = i,
                                MultiKey = z,
                                action = function(entity)
                                    dataTarg = {entity = entity, coords = GetEntityCoords(entity),IndexKey = i, TableRun = SitConfig.objects[i].Animations, MultiKey = z}
                                        for o = 1, #dataTarg.TableRun[dataTarg.MultiKey] do
                                            Wait(10)
                                            local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].anim
                                            local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].dict
                                            if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                            elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                            end
                                            local NewInfo = {
                                                    title = dataTarg.TableRun[dataTarg.MultiKey][o].title,
                                                    description = dataTarg.TableRun[dataTarg.MultiKey][o].description,
                                                    args = {
                                                        current = SitConfig.objects[dataTarg.IndexKey],
                                                        ActiveAnimIndex = o,
                                                        entity = dataTarg.entity,
                                                        coords = dataTarg.coords,
                                                    },
                                                    onSelect = function(data)
                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].object = data.entity
                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading or false
                                                        TriggerEvent('ChairBedSystem:Client:Animation', data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex], data.coords, dataTarg.IndexKey , data.ActiveAnimIndex ,dataTarg.MultiKey)
                                                        InUse = data.current
                                                        InUse.details = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex]
                                                        SeatActivation()
                                                    end
                                                }
                                            options[#options+1] = NewInfo
                                            if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                            end
                                    end

                                    local menuTitle = SitConfig.OxContextMenuTitle .. SitConfig.objects[dataTarg.IndexKey].multiSeat[dataTarg.MultiKey]
                                    local menuId = "Seat id " .. dataTarg.IndexKey
                                    lib.registerContext({
                                            id = menuId,
                                            title = menuTitle,
                                            options = options
                                        })
                                    lib.showContext(menuId, dataTarg)
                                    options = {}
                                    currentmenu = menuId
                                end
                            }
                            TargetOptions[#TargetOptions+1] = OXtargetOption
                            OXtargetOption = {}
                        end
                    else
                        OXtargetOption = {
                        name = 'Seat Sytle',
                        icon = 'fas fa-chair',
                        label = SitConfig.OxTargetLabel,
                        distance = 2.0,
                        canInteract = function(entity, distance, coords, name)
                            return DoesEntityExist(entity)
                        end,
                        TableRun = SitConfig.objects[i].Animations ,
                        IndexKey = i,
                        action = function(entity)
                            dataTarg = {entity = entity, coords = GetEntityCoords(entity),IndexKey = i, TableRun = SitConfig.objects[i].Animations}
                                    for o = 1, #dataTarg.TableRun do

                                        local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[o].anim
                                        local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[o].dict

                                        if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                            dataTarg.TableRun[o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                            dataTarg.TableRun[o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                        elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                            dataTarg.TableRun[o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                            dataTarg.TableRun[o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                        end
                                        Wait(10)

                                        local checkcoords = GetOffsetFromEntityInWorldCoords(dataTarg.entity,dataTarg.TableRun[o].right_left_X,dataTarg.TableRun[o].forward_backwards_Y,dataTarg.TableRun[o].up_down_z)

                                        local NewInfo = {
                                                title = dataTarg.TableRun[o].title,
                                                description = dataTarg.TableRun[o].description,
                                                args = {
                                                    current = SitConfig.objects[dataTarg.IndexKey],
                                                    ActiveAnimIndex = o,
                                                    entity = dataTarg.entity,
                                                    coords = dataTarg.coords,
                                                },
                                                onSelect = function(data)
                                                    if SitConfig.Debug then
                                                        for k,v in pairs(data) do
                                                            print(k,v)
                                                        end
                                                        if not data.current.Animations[data.ActiveAnimIndex] then
                                                            data.ActiveAnimIndex = 1
                                                        end
                                                        for k,v in pairs(data.current.Animations[data.ActiveAnimIndex] ) do
                                                            print(k,v)
                                                        end
                                                    end

                                                    data.current.Animations[data.ActiveAnimIndex].object = data.entity

                                                    data.current.Animations[data.ActiveAnimIndex].DynamicHeading = data.current.Animations[data.ActiveAnimIndex].DynamicHeading or false
                                                    TriggerEvent('ChairBedSystem:Client:Animation', data.current.Animations[data.ActiveAnimIndex], data.coords , data.IndexKey , data.ActiveAnimIndex )
                                                    InUse = data.current
                                                    InUse.details = data.current.Animations[data.ActiveAnimIndex]
                                                    SeatActivation()
                                                end
                                            }
                                        options[#options+1] = NewInfo
                                        if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                        end
                                end
                                local menuTitle = SitConfig.OxContextMenuTitle
                                local menuId = "Seat id " .. dataTarg.IndexKey
                                lib.registerContext({
                                        id = menuId,
                                        title = menuTitle,
                                        options = options
                                    })
                            lib.showContext(menuId, dataTarg)
                            options = {}
                            currentmenu = menuId
                        end
                    }
                    TargetOptions[#TargetOptions+1] = OXtargetOption
                    end
                else
                    if SitConfig.objects[i].multiSeat then
                        OxParams ={




                            points =  SitConfig.objects[i].points,
                            thickness =  SitConfig.objects[i].thickness,

                            minZ = SitConfig.objects[i].points[1].z,
                            maxZ = SitConfig.objects[i].points[1].z + SitConfig.objects[i].thickness,

                            debugPoly = SitConfig.objects[i].debug,

                            name = 'Seat Sytle',
                            icon = 'fas fa-chair',
                            label = SitConfig.OxTargetLabel,
                            distance = 2.0,
                        }
                        for z = 1, #SitConfig.objects[i].Animations do
                            Wait(10)
                            OXtargetOption = {
                                name = SitConfig.OxContextName .. z,
                                icon = 'fas fa-chair',
                                label = SitConfig.OxContextLabel .. SitConfig.objects[i].multiSeat[z],
                                distance = 2.0,
                                canInteract = function(entity, distance, coords, name)
                                    return distance < SitConfig.objects[i].distance
                                end,
                                TableRun = SitConfig.objects[i].Animations ,
                                IndexKey = i,
                                MultiKey = z,
                                action = function(entity)
                                    dataTarg = {IndexKey = i, MultiKey = z, TableRun = SitConfig.objects[i].Animations}
                                        for o = 1, #dataTarg.TableRun[dataTarg.MultiKey] do

                                            local CurrentAnim_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].anim
                                            local CurrentDict_Key = SitConfig.objects[dataTarg.IndexKey].Animations[dataTarg.MultiKey][o].dict
                                            if CurrentDict_Key and SitConfig.AnimDescriptions[CurrentDict_Key] and SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentDict_Key][CurrentAnim_Key].title
                                            elseif SitConfig.AnimDescriptions[CurrentAnim_Key] then
                                                dataTarg.TableRun[dataTarg.MultiKey][o].description = SitConfig.AnimDescriptions[CurrentAnim_Key].description
                                                dataTarg.TableRun[dataTarg.MultiKey][o].title = SitConfig.AnimDescriptions[CurrentAnim_Key].title
                                            end

                                            Wait(10)
                                            local NewInfo = {
                                                    title = dataTarg.TableRun[dataTarg.MultiKey][o].title,
                                                    description = dataTarg.TableRun[dataTarg.MultiKey][o].description,
                                                    args = {
                                                        current = SitConfig.objects[dataTarg.IndexKey],
                                                        ActiveAnimIndex = o,
                                                        coords = SitConfig.objects[i].Seats[z],
                                                    },
                                                    onSelect = function(data)
                                                        print(data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex], data.coords, dataTarg.IndexKey , data.ActiveAnimIndex ,dataTarg.MultiKey)

                                                        data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex].DynamicHeading or false
                                                        TriggerEvent('ChairBedSystem:Client:AnimationCooordsBased', data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex], data.coords, dataTarg.IndexKey , data.ActiveAnimIndex ,dataTarg.MultiKey)
                                                        InUse = data.current
                                                        InUse.details = data.current.Animations[dataTarg.MultiKey][data.ActiveAnimIndex]
                                                        SeatActivation()
                                                    end
                                                }
                                            options[#options+1] = NewInfo
                                            if SitConfig.Debug then
                                            print("Table Added " ) print(NewInfo)
                                            print("_________________________________")
                                            end
                                        end
                                    local menuTitle = SitConfig.OxContextMenuTitle .. SitConfig.objects[dataTarg.IndexKey].multiSeat[dataTarg.MultiKey]
                                    local menuId = "Seat id " .. dataTarg.IndexKey
                                    lib.registerContext({
                                            id = menuId,
                                            title = menuTitle,
                                            options = options
                                        })
                                    lib.showContext(menuId, dataTarg)
                                    options = {}
                                    currentmenu = menuId
                                end
                            }
                            TargetOptions[#TargetOptions+1] = OXtargetOption
                            OXtargetOption = {}
                        end
                    end
                end
                if #TargetOptions > 0 then
                    if SitConfig.objects[i].objName then
                        Details = {options = TargetOptions, distance = TargetOptions[1].distance}
                        exports['qb-target']:AddTargetModel(SitConfig.objects[i].objName, Details)
                    elseif SitConfig.objects[i].points then
                        OxParams.options= TargetOptions

                        Details = {options = TargetOptions, distance = TargetOptions[1].distance}
                        ZoneID = exports['qb-target']:AddPolyZone(OxParams.name, OxParams.points, OxParams , Details)
                        SitConfig.objects[i].ZoneID = ZoneID
                    end
                end
            end
        end
    end
end)

function SeatActivation()
    Citizen.CreateThread(function()
        local WhileSittingHelpText = true
        while InUse do
            PlayerPed = PlayerPedId()
            PlayerPos = GetEntityCoords(PlayerPed)
            if InUse then
                if SitConfig.AddHelpText then
                    if WhileSittingHelpText then
                        WhileSittingHelpText = false
                        SitConfig.WhileSittinginfoFunction()
                    end
                    if IsControlJustPressed(0,202) then
                        if SitConfig.WhileSittinginfoFunction_IsOpenCheck() then
                            SitConfig.WhileSittinginfoFunctionCancel()
                        else
                            SitConfig.WhileSittinginfoFunction()
                        end
                    end
                end
                if IsControlJustPressed(0, SitConfig.SmoothCancelSit ) then
                    if inScenario and not InUse.details.skipExitScene then
                        if InUse.details.noExitCollision then
                            local pos = PlayerPos
                            local rayHandle = StartShapeTestRay(pos.x, pos.y, pos.z + 0.1, pos.x, pos.y, pos.z - 0.1, 16, PlayerPed, 0)
                            local _, hit, endCoords, surfaceNormal, entityHit  = GetShapeTestResult(rayHandle)
                            if entityHit and DoesEntityExist(entityHit) then
                                ClearPedTasksImmediately(PlayerPed)
                                FreezeEntityPosition(PlayerPed, false)

                                local x, y, z = table.unpack(PlayerLastPos)
                                local dist = #(PlayerPos - vector3(x, y, z))
                                if dist <= 10 then
                                    SetEntityCoords(PlayerPed, PlayerLastPos)
                                end
                                print("here 2")
                            else
                                FreezeEntityPosition(PlayerPed, false)
                                ClearPedTasks(PlayerPed)
                            end
                            InUse = false
                            Wait(500)
                        else
                            FreezeEntityPosition(PlayerPed, false)
                            InUse = false
                            ClearPedTasks(PlayerPed)
                        end
                    else
                        if not InUse.exitPosition then
                            if InUse.details.animation then
                                FreezeEntityPosition(PlayerPed, false)
                                StopAnimTask(PlayerPed, InUse.details.animation.Dict, InUse.details.animation.Anim, 0.7)
                                SetPedToRagdoll(PlayerPed, 1, 1, 2, 0, 0, 0)
                                Wait(100)
                                FreezeEntityPosition(PlayerPed, true)
                                Wait(1000)
                                FreezeEntityPosition(PlayerPed, false)
                                Wait(500)
                                ClearPedTasks(PlayerPed)
                            else
                                ClearPedTasksImmediately(PlayerPed)
                                FreezeEntityPosition(PlayerPed, false)

                                local x, y, z = table.unpack(PlayerLastPos)
                                local dist = #(PlayerPos - vector3(x, y, z))
                                if dist <= 10 then
                                    SetEntityCoords(PlayerPed, PlayerLastPos)
                                end
                            end

                            InUse = false
                            Wait(500)
                        else
                            ClearPedTasksImmediately(PlayerPed)
                            FreezeEntityPosition(PlayerPed, false)
                            SetEntityCoords(PlayerPed, InUse.exitPosition)

                            InUse = false
                            Wait(500)
                        end
                    end
                    current = false
                    EndChairCam()
                elseif  IsControlJustPressed(0, SitConfig.QuickCancelSit) then
                    if not InUse.exitPosition then

                        ClearPedTasksImmediately(PlayerPed)
                        FreezeEntityPosition(PlayerPed, false)

                        local x, y, z = table.unpack(PlayerLastPos)
                        local dist = #(PlayerPos - vector3(x, y, z))
                        if dist <= 10 then
                            SetEntityCoords(PlayerPed, PlayerLastPos)
                        end
                        InUse = false
                        Wait(500)
                    else
                        ClearPedTasksImmediately(PlayerPed)
                        FreezeEntityPosition(PlayerPed, false)
                        SetEntityCoords(PlayerPed, InUse.exitPosition)
                        InUse = false
                        Wait(500)
                    end
                    current = false
                    EndChairCam()
                end

                if IsControlJustPressed(0,SitConfig.OpenmenuWhileSitting )  then
                    lib.showContext(currentmenu)
                    Wait(1000)
                end
                if SitConfig.AllowHeadingChange then
                    if IsControlJustPressed(0, 34)  then
                        SetEntityHeading(PlayerPed, GetEntityHeading(PlayerPed)-1)
                        Wait(100)
                    end
                    if IsControlJustPressed(0, 35)  then
                        SetEntityHeading(PlayerPed, GetEntityHeading(PlayerPed)+1)
                        Wait(100)
                    end
                end
                if SitConfig.AllowChairCamera then
                    if IsControlJustPressed(0, SitConfig.StartChairCamera )  then
                        if not cam then
                            StartChairCam()
                            radius = 1.5
                        else
                            EndChairCam()
                        end
                    end


                    if cam then
                        if IsControlJustPressed(0, 175) then
                            if radius < 5.0 then
                                radius = radius +0.1
                            end
                        end
                        if IsControlJustPressed(0, 174) then
                            if radius > 0.5 then
                                radius = radius -0.1
                            end
                        end

                        if IsControlJustPressed(0, 172) then
                            if CameraZOffset < 2.0 then
                                CameraZOffset = CameraZOffset +0.1
                            end
                        end
                        if IsControlJustPressed(0, 173) then
                            if CameraZOffset > -1.0 then
                                CameraZOffset = CameraZOffset -0.1
                            end
                        end
                        ProcessCamControls()
                    end
                end
            end

            if not InUse then
                if SitConfig.AddHelpText then
                    SitConfig.WhileSittinginfoFunctionCancel()
                end
                inScenario = false
                currentmenu = false
                Citizen.Wait(2000)
            end
            Citizen.Wait(3)
        end
        currentmenu = false
    end)
end

function StartChairCam()
    ClearFocus()

    local playerPed = PlayerPedId()

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function EndChairCam()
    ClearFocus()


    RenderScriptCams(false, true, 1000, true, false)
    DestroyCam(cam, false)

    cam = nil
end

function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)


    DisableFirstPersonCamThisFrame()


    local newPos = ProcessNewPosition()


    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)


    SetCamCoord(cam, newPos.x, newPos.y, newPos.z + CameraZOffset)


    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + (CameraZOffset/2))
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0


    if (IsInputDisabled(0)) then

        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0


    else

        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX
    angleY = angleY + mouseY

    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end

    local pCoords = GetEntityCoords(PlayerPedId())

    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (radius + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (radius + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (radius + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = radius
    local hitdist = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    if (hitBool and hitdist < radius + 0.5) and hitdist > 0.5 then
        maxRadius = hitdist - 0.08

    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    Zreducer = 0.4
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }






    return pos
end

local TableHolder = nil
local FixingIndexKey = nil
local FixingAnimKey = nil
local FixingMultiKey = nil

RegisterNetEvent('ChairBedSystem:Client:AnimationCooordsBased')
AddEventHandler('ChairBedSystem:Client:AnimationCooordsBased', function(v, coords, toot,sweet,butts)
    TableHolder = v
    TableHolder.coords = coords
    FixingIndexKey = toot
    FixingAnimKey = sweet
    FixingMultiKey = butts

    local objectcoords = vector3(coords.x + v.right_left_X, coords.y + v.forward_backwards_Y, coords.z + v.up_down_z)
    local ped = PlayerPedId()
    PlayerLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(ped, true)

    if IsPedHeeled(ped) then
        objectcoords = vec3(objectcoords.x, objectcoords.y, objectcoords.z -0.12)
    end
    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
    SetEntityHeading(ped, v.Heading)
    if v.dict then
        Animation(v.dict, v.anim, ped)
    elseif v.anim then
        inScenario = true
        v.IsSittingAnim = v.IsSittingAnim or false
        TaskStartScenarioAtPosition(ped, v.anim, objectcoords, v.Heading, 0, v.IsSittingAnim, true)
    end
end)

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(v, coords , toot,sweet,butts)
    TableHolder = v
    FixingIndexKey = toot
    FixingAnimKey = sweet
    FixingMultiKey = butts
    local object = v.object
    if object then
        local ped = PlayerPedId()


        local objectheadingOffset = 0.0
        local offsett = GetOffsetFromEntityInWorldCoords(object,v.right_left_X,v.forward_backwards_Y,v.up_down_z)
        if v.DynamicHeading then
            objectheadingOffset = GetEntityHeading(object)
        else
            objectheadingOffset = GetEntityHeading(object) - v.Heading
        end
        local objectcoords = coords
        if offsett then
        objectcoords = offsett
        end

        PlayerLastPos = GetEntityCoords(ped)
        if v.WalkIntoScene then
            if not IsEntityAtCoord(ped, offsett, 0.6, 0.6, 0.1, false, true, 0) then
                TaskGoStraightToCoord(ped, offsett, 1.0, 500, objectheadingOffset, 2.5)
                Breakcheck = 0
                while not IsEntityAtCoord(ped, offsett, 0.8, 0.8,1.5, false, true, 0) do
                Wait(1)
                Breakcheck = Breakcheck +1
                    if Breakcheck > 250 then
                        break
                    end
                end
                ClearPedTasks(ped)
            end
        end
        FreezeEntityPosition(object, true)
        FreezeEntityPosition(ped, true)
        if IsPedHeeled(ped) then
            objectcoords = vec3(objectcoords.x, objectcoords.y, objectcoords.z -0.12)
        end
        SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
        SetEntityHeading(ped, objectheadingOffset)
        if v.dict then
            Animation(v.dict, v.anim, ped)
        elseif v.anim then
            inScenario = true
            v.IsSittingAnim = v.IsSittingAnim or false
            TaskStartScenarioAtPosition(ped, v.anim, objectcoords, objectheadingOffset, 0, v.IsSittingAnim, true)
        end
    else
        InUse = false
    end
end)

