Citizen.CreateThread(function()
    if SitConfig.Debug then
        function getEntity(player)
            local result, entity = GetEntityPlayerIsFreeAimingAt(player)
            return entity
        end


        function DrawInfos(text)
            SetTextColour(255, 255, 255, 255)
            SetTextFont(1)
            SetTextScale(0.4, 0.4)
            SetTextWrap(0.0, 1.0)
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(50, 0, 0, 0, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.3, 0.01)
        end


        local infoOn = false
        local coordsText = ""
        local headingText = ""
        local modelText = ""
        local reposistion = false

        function clonedPedSeatAnims(table, Seat_entity, playerDummy)
            if Seat_entity then
                local objectheadingOffset = 0.0
                local offsett = GetOffsetFromEntityInWorldCoords(Seat_entity,table.right_left_X,table.forward_backwards_Y,table.up_down_z)
                if table.DynamicHeading then
                    objectheadingOffset = GetEntityHeading(Seat_entity)
                else
                    objectheadingOffset = GetEntityHeading(Seat_entity) - table.Heading
                end
                local objectcoords = coords
                if offsett then
                    objectcoords = offsett
                end

                FreezeEntityPosition(Seat_entity, true)
                FreezeEntityPosition(playerDummy, true)
                if IsPedHeeled(playerDummy) then
                    objectcoords = vec3(objectcoords.x, objectcoords.y, objectcoords.z -0.12)
                end
                SetEntityCoords(playerDummy, objectcoords.x, objectcoords.y, objectcoords.z)
                SetEntityHeading(playerDummy, objectheadingOffset)
                if table.dict then
                    Animation(table.dict, table.anim, playerDummy)
                elseif table.anim then
                    inScenario = true
                    table.IsSittingAnim = table.IsSittingAnim or false
                    TaskStartScenarioAtPosition(playerDummy, table.anim, objectcoords, objectheadingOffset, 0, false, true)
                end
            end
            reposistion = false
        end

        local learning = false
        local outlinedEntity = false
        RegisterCommand("CreateObjectSeat", function()
            if not learning then
                learning = true
                local pId = PlayerPedId()
                local Seat_entity = false
                local Seat_coords = false
                while true do
                    Citizen.Wait(5)
                    DisableControlAction(0, 15, true)
                    DisableControlAction(0, 16, true)

                    DisableControlAction(0, 24, true)

                    DisableControlAction(0, 38, true)
                    DisableControlAction(0, 44, true)
                    if IsPlayerFreeAiming(PlayerId()) then
                        Seat_entity = getEntity(PlayerId())
                        Seat_coords = GetEntityCoords(Seat_entity)
                        local heading = GetEntityHeading(Seat_entity)
                        local model = GetEntityModel(Seat_entity)
                        coordsText = Seat_coords  or "no object detected exists"
                        headingText = heading or "no object detected exists"
                        modelText = model  or "no model exists"

                        if outlinedEntity and outlinedEntity ~= Seat_entity then
                            SetEntityDrawOutline(outlinedEntity, false)
                        end
                        SetEntityDrawOutline(Seat_entity, true)
                        SetEntityDrawOutlineColor(255, 255, 255, 255)
                        outlinedEntity = Seat_entity
                    end
                    DrawInfos("Coordinates: " .. coordsText .. "\nHeading: " .. headingText .. "\nHash: " .. modelText  )
                    AnyWhereSeat_String = "~INPUT_AIM~ Select Prop\n ~INPUT_TALK~ Use Prop"
                    ShowHelpNotification(AnyWhereSeat_String)
                    if Seat_entity then
                        if IsDisabledControlJustReleased(0, 38) then
                            Wait(50)
                            SeatSelected = true
                            break
                        elseif IsEntityDead(pId) or IsPedFalling(pId) or IsControlPressed(0, 21) or IsControlPressed(0, 49) or IsControlPressed(0, 55) or IsControlPressed(0, 202) then
                            SeatSelected = false
                            break
                        end
                    end
                end

                if outlinedEntity then
                    SetEntityDrawOutline(outlinedEntity, false)
                end

                if SeatSelected then
                    SeatSelected_data = {
                        objName= GetEntityModel(Seat_entity) ,
                        Animations = {
                            {anim = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                            {anim = 'PROP_HUMAN_SEAT_BENCH',right_left_X= 0.0, forward_backwards_Y= 0.1, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                            {anim = 'PROP_HUMAN_SEAT_STRIP_WATCH',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},

                            {anim = 'PROP_HUMAN_SEAT_ARMCHAIR',right_left_X= 0.0, forward_backwards_Y= 0.1, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                            {anim = 'PROP_HUMAN_SEAT_CHAIR',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                            {anim = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},

                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@female@idle_a', anim = 'idle_a'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@female@idle_a', anim = 'idle_b'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@male@base', anim = 'base'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@male@idle_a', anim = 'idle_a'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@male@idle_a', anim = 'idle_b'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@male@idle_a', anim = 'idle_c'},
                            {right_left_X=-0.5, forward_backwards_Y=0.3, up_down_z=-0.9, Heading= 180.0, dict = 'amb@prop_human_seat_sunlounger@male@idle_a', anim = 'idle_d'},
                            {right_left_X=-0.5, forward_backwards_Y=-0.3, up_down_z=0.5, Heading= 180.0, dict = 'amb@world_human_sunbathe@male@back@idle_a', anim = 'idle_a'},
                            {right_left_X=-0.5, forward_backwards_Y=-0.3, up_down_z=0.5, Heading= 180.0, dict = 'amb@world_human_sunbathe@male@back@idle_a', anim = 'idle_b'},
                            {right_left_X=-0.5, forward_backwards_Y=-0.3, up_down_z=0.5, Heading= 180.0, dict = 'amb@world_human_sunbathe@male@back@idle_a', anim = 'idle_c'},
                            {right_left_X=-0.5, forward_backwards_Y=-0.3, up_down_z=1.44, Heading=180.0, anim='WORLD_HUMAN_PICNIC'},
                            {right_left_X=-0.5, forward_backwards_Y=-0.5, up_down_z=1.4, Heading=180.0, anim='WORLD_HUMAN_SUNBATHE'},
                        },
                    }



                    local playerDummy = ClonePed(pId, false, false, true)

                    local pIdCoords = GetEntityCoords(playerDummy)
                    SetEntityAlpha(playerDummy, 90, false)
                    SetBlockingOfNonTemporaryEvents(playerDummy, true)
                    SetEntityInvincible(playerDummy, true)
                    SetEntityCollision(playerDummy, false, false)

                    FreezeEntityPosition(playerDummy, true)

                    local Cur_Anim = 1

                    SetEntityCoords(playerDummy, Seat_coords.x, Seat_coords.y, Seat_coords.z)
                    clonedPedSeatAnims(SeatSelected_data.Animations[1], Seat_entity,playerDummy)



                    CurrString = "~INPUT_JUMP~save~INPUT_FRONTEND_RIGHT_AXIS_X~Prev/Next~INPUT_FRONTEND_ACCEPT~ Finish\n~y~M~w~+ Seat"
                    local right_left_X = 0.0
                    local forward_backwards_Y = 0.0
                    local up_down_z = 0.0
                    local final_data = false

                    while learning do
                        Citizen.Wait(5)
                        SetEntityCollision(playerDummy, false, false)
                        ShowHelpNotification(CurrString)

                        DisableControlAction(0, 15, true)
                        DisableControlAction(0, 16, true)

                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 25, true)
                        DisableControlAction(0, 38, true)
                        DisableControlAction(0, 44, true)
                        DisableControlAction(0, 22, true)
                        DisableControlAction(0, 244, true)


                        DisableControlAction(0, 172, true)
                        DisableControlAction(0, 173, true)
                        DisableControlAction(0, 174, true)
                        DisableControlAction(0, 175, true)
                        if playerDummy then

                            if IsDisabledControlPressed(0, 15) then
                                SeatSelected_data.Animations[Cur_Anim].Heading = SeatSelected_data.Animations[Cur_Anim].Heading + 1.0
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 16) then
                                SeatSelected_data.Animations[Cur_Anim].Heading = SeatSelected_data.Animations[Cur_Anim].Heading - 1.0
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 44) then
                                up_down_z = up_down_z + 0.005
                                SeatSelected_data.Animations[Cur_Anim].up_down_z = up_down_z
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 38) then
                                up_down_z = up_down_z - 0.005
                                SeatSelected_data.Animations[Cur_Anim].up_down_z = up_down_z
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 173) then
                                forward_backwards_Y = forward_backwards_Y + 0.005
                                SeatSelected_data.Animations[Cur_Anim].forward_backwards_Y = forward_backwards_Y
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 172) then
                                forward_backwards_Y = forward_backwards_Y - 0.005
                                SeatSelected_data.Animations[Cur_Anim].forward_backwards_Y = forward_backwards_Y
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 174) then
                                right_left_X = right_left_X - 0.005
                                SeatSelected_data.Animations[Cur_Anim].right_left_X = right_left_X
                                reposistion = true
                            elseif IsDisabledControlPressed(0, 175) then
                                right_left_X = right_left_X + 0.005
                                SeatSelected_data.Animations[Cur_Anim].right_left_X = right_left_X
                                reposistion = true




                            elseif IsDisabledControlJustReleased(0, 197) then
                                Cur_Anim = Cur_Anim + 1
                                if Cur_Anim > #SeatSelected_data.Animations then
                                    Cur_Anim = 1
                                end
                                reposistion = true
                                Wait(50)
                                if SeatSelected_data.Animations[Cur_Anim].right_left_X == 0 and SeatSelected_data.Animations[Cur_Anim].forward_backwards_Y == 0 and SeatSelected_data.Animations[Cur_Anim].up_down_z == 0 then
                                    SeatSelected_data.Animations[Cur_Anim].right_left_X = right_left_X
                                    SeatSelected_data.Animations[Cur_Anim].forward_backwards_Y = forward_backwards_Y
                                    SeatSelected_data.Animations[Cur_Anim].up_down_z = up_down_z
                                end
                            elseif IsDisabledControlJustReleased(0, 100) then
                                Cur_Anim = Cur_Anim - 1
                                if Cur_Anim < 1 then
                                    Cur_Anim = #SeatSelected_data.Animations
                                end
                                reposistion = true
                                Wait(50)
                            elseif IsDisabledControlJustReleased(0, 22) then
                                SeatSelected_data.Animations[Cur_Anim].save = true
                                Wait(100)
                            elseif IsDisabledControlJustReleased(0, 201) then
                                Wait(100)
                                DeleteEntity(playerDummy)
                                learning = false
                                SaveData(SeatSelected_data,final_data)
                                break
                            elseif IsDisabledControlJustReleased(0, 244) then
                                Wait(10)
                                if not final_data then
                                    final_data = {
                                    objName= GetEntityModel(Seat_entity) ,
                                    Animations = {},
                                    multiSeat = {}
                                    }
                                end
                                if final_data then
                                    local tempTable = SeatSelected_data.Animations
                                    final_data.Animations[#final_data.Animations + 1] = tempTable
                                    final_data.multiSeat[#final_data.multiSeat + 1] = "Seat " ..  (#final_data.multiSeat + 1)
                                end

                                Cur_Anim = 1

                                SeatSelected_data = {
                                    objName= GetEntityModel(Seat_entity) ,
                                    Animations = {

                                        {anim = 'PROP_HUMAN_SEAT_BENCH',right_left_X= 0.0, forward_backwards_Y= 0.1, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                                        {anim = 'PROP_HUMAN_SEAT_STRIP_WATCH',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},

                                        {anim = 'PROP_HUMAN_SEAT_ARMCHAIR',right_left_X= 0.0, forward_backwards_Y= 0.1, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                                        {anim = 'PROP_HUMAN_SEAT_CHAIR',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                                        {anim = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.0, Heading= 180.0,   IsSittingAnim = true, skipExitScene = false},
                                    },
                                }
                                right_left_X = 0.0
                                forward_backwards_Y = 0.0
                                up_down_z = 0.0
                                ClearPedTasksImmediately(playerDummy)
                            elseif IsEntityDead(pId) or IsPedFalling(pId) or IsControlPressed(0, 21) or IsControlPressed(0, 49) or IsControlPressed(0, 202) then
                                DeleteEntity(playerDummy)
                                learning = false
                                break
                            end

                            if reposistion then
                                ClearPedTasksImmediately(playerDummy)
                            end
                            if SeatSelected_data.Animations[Cur_Anim].dict then
                                if not IsEntityPlayingAnim(playerDummy, SeatSelected_data.Animations[Cur_Anim].dict, SeatSelected_data.Animations[Cur_Anim].anim,3) then
                                    clonedPedSeatAnims(SeatSelected_data.Animations[Cur_Anim], Seat_entity,playerDummy)
                                end
                            elseif not IsPedUsingScenario(playerDummy, SeatSelected_data.Animations[Cur_Anim].anim) then

                                ClearAreaOfObjects(pIdCoords.x, pIdCoords.y, pIdCoords.z, 0.7,0)
                                ClearAreaOfObjects(pIdCoords.x, pIdCoords.y, pIdCoords.z - 0.2, 0.3,0)
                                Wait(1)
                                clonedPedSeatAnims(SeatSelected_data.Animations[Cur_Anim], Seat_entity,playerDummy)
                            end
                        end
                    end
                end
            end
        end)

    function SaveData(SeatSelected_data,final_data)
        if final_data then
            local holder = final_data
            final_data = {objName = holder.objName, Animations = {} , multiSeat = holder.multiSeat}
            if holder.Animations then
                for k,v in pairs(holder.Animations) do

                    if type(v) == 'table' then
                        for i = 1, #v do
                            if v[i].save then
                                if not final_data.Animations[k] then
                                    final_data.Animations[k] = {}
                                end
                                final_data.Animations[k][#final_data.Animations[k] + 1] = v[i]
                            end
                        end
                    end
                end
            end
            longstring = "{"
            for k ,v in pairs(final_data) do
                if type(k) == 'number' then
                    k = "["..k.."]"
                end
                print(v)
                if type(v) == 'table' then
                    longstring = longstring .. "" .. k .. " = {"
                    for x,y in pairs(v) do
                        if type(x) == 'number' then
                            x = "["..x.."]"
                        end
                        print(y)
                        if type(y) == 'table' then
                            longstring = longstring .. "" .. x .. " = {"
                            for t,u in pairs(y) do
                                if type(u) == 'table' then
                                    longstring = longstring .. "" .. t .. " = {"
                                    for o,p in pairs(u) do
                                        if  type(p) == 'table' then

                                        else
                                            if type(p) == 'boolean' then
                                                if p == true then
                                                    p = 'true'
                                                else
                                                    p = 'false'
                                                end
                                                longstring = longstring .. "" .. o .. " = " .. p ..","
                                            elseif type(p) == 'string' then
                                                longstring = longstring .. "" .. o .. " = " .. p ..","
                                            elseif type(p) == 'number' then
                                                longstring = longstring .. "" .. o .. " = " .. p ..","
                                            end
                                        end
                                    end
                                    longstring = longstring .. "},"
                                else
                                    if type(u) == 'boolean' then
                                        if u == true then
                                            u = 'true'
                                        else
                                            u = 'false'
                                        end
                                        longstring = longstring .. "" .. t .. " = " .. u ..","
                                    elseif type(u) == 'string' then
                                        longstring = longstring .. "" .. t .. " = '" .. u .."',"
                                    elseif type(u) == 'number' then
                                        longstring = longstring .. "" .. t .. " = " .. u ..","
                                    end
                                end
                            end
                            longstring = longstring .. "},"
                        elseif type(y) == 'string' then
                            longstring = longstring .. "" .. x .. " = '" .. y .."',"
                        elseif type(y) == 'number' then
                            longstring = longstring .. "" .. x .. " = " .. y ..","
                        end
                    end
                    longstring = longstring .. "},"
                elseif type(v) == 'string' then
                    longstring = longstring .. "" .. k .. " = '" .. v .."',"
                elseif type(v) == 'number' then
                    longstring = longstring .. "" .. k .. " = " .. v ..","
                end
            end
            longstring = longstring .."}"
            if string.find(longstring, ",}") then
                longstring = string.gsub(longstring, ",}", "}")
            end
            if string.find(longstring, "},") then
                longstring = string.gsub(longstring, "},", "},\n")
            end
            print(longstring)
            local infostring = ""
            SendNUIMessage({coords = infostring .. longstring})
        else
            local holder = SeatSelected_data
            SeatSelected_data = {objName = holder.objName, Animations = {}}
            if holder.Animations then
                for i = 1, #holder.Animations do
                    if holder.Animations[i].save then
                        SeatSelected_data.Animations[#SeatSelected_data.Animations + 1] = holder.Animations[i]
                    end
                end
            end
            longstring = "{"
            for k ,v in pairs(SeatSelected_data) do
                if type(k) == 'number' then
                    k = "["..k.."]"
                end
                print(v)
                if type(v) == 'table' then
                    longstring = longstring .. "" .. k .. " = {"
                    for x,y in pairs(v) do
                        if type(x) == 'number' then
                            x = "["..x.."]"
                        end
                        print(y)
                        if type(y) == 'table' then
                            longstring = longstring .. "" .. x .. " = {"
                            for t,u in pairs(y) do
                                if type(u) == 'boolean' then
                                    if u == true then
                                        u = 'true'
                                    else
                                        u = 'false'
                                    end
                                    longstring = longstring .. "" .. t .. " = " .. u ..","
                                elseif type(u) == 'string' then
                                    longstring = longstring .. "" .. t .. " = '" .. u .."',"
                                elseif type(u) == 'number' then
                                    longstring = longstring .. "" .. t .. " = " .. u ..","
                                end
                            end
                            longstring = longstring .. "},"
                        elseif type(y) == 'string' then
                            longstring = longstring .. "" .. x .. " = '" .. y .."',"
                        elseif type(y) == 'number' then
                            longstring = longstring .. "" .. x .. " = " .. y ..","
                        end
                    end
                    longstring = longstring .. "},"
                elseif type(v) == 'string' then
                    longstring = longstring .. "" .. k .. " = '" .. v .."',"
                elseif type(v) == 'number' then
                    longstring = longstring .. "" .. k .. " = " .. v ..","
                end
            end
            longstring = longstring .."}"
            if string.find(longstring, ",}") then
                longstring = string.gsub(longstring, ",}", "}")
            end
            if string.find(longstring, "},") then
                longstring = string.gsub(longstring, "},", "},\n")
            end
            print(longstring)
            local infostring = ""
            SendNUIMessage({coords = infostring .. longstring})
        end
    end

    RegisterCommand('fixchair', function(source, args, rawCommand)
            if not InUse and type(TableHolder) == "table" then
                if not TableHolder.object then
                    TotalTable = {}
                    local ped = PlayerPedId()
                        if TableHolder.coords then
                            local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(ped, true)

                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, TableHolder.Heading)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                            end
                        end
                        while true do
                            Citizen.Wait(3)
                            ShowHelpNotification("~INPUT_PICKUP~Save~INPUT_DIVE~Next~INPUT_ARREST~Exit\n~g~WASD ~w~XY ~g~Up-Down Arrow ~w~Z")
                            if IsControlJustPressed(0, 32) then
                                ClearPedTasksImmediately(ped)
                                TableHolder.forward_backwards_Y =  roundDec(TableHolder.forward_backwards_Y + 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                    PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end

                                Wait(100)
                            elseif IsControlJustPressed(0, 8) then
                                ClearPedTasksImmediately(ped)
                                TableHolder.forward_backwards_Y =  roundDec(TableHolder.forward_backwards_Y - 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end

                            if IsControlJustPressed(0, 34)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.right_left_X =  roundDec(TableHolder.right_left_X + 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end
                            if IsControlJustPressed(0, 35)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.right_left_X =  roundDec(TableHolder.right_left_X - 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end

                            if IsControlJustPressed(0, 172)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.up_down_z =  roundDec(TableHolder.up_down_z + 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                    PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end
                            if IsControlJustPressed(0, 173)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.up_down_z =  roundDec(TableHolder.up_down_z - 0.02 , 4)
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                    PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.Heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.Heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end

                            if IsControlPressed(0, 174)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.Heading =  roundDec(TableHolder.Heading + 1.0 , 4)
                                print(TableHolder.Heading)
                                SetEntityHeading(ped, TableHolder.Heading)
                                Wait(100)
                            end
                            if IsControlPressed(0, 175)  then
                                ClearPedTasksImmediately(ped)
                                TableHolder.Heading = roundDec(TableHolder.Heading - 1.0 , 1)
                                print(TableHolder.Heading)
                                SetEntityHeading(ped, TableHolder.Heading)
                                Wait(100)
                            end


                            if IsControlJustPressed(0, 203)  then
                                print(FixingAnimKey)
                                if not FixingMultiKey then
                                    TotalTable[FixingAnimKey] = TableHolder
                                    if SitConfig.objects[FixingIndexKey].Animations[FixingAnimKey +1] then
                                        if TotalTable[FixingAnimKey +1] then
                                            TableHolder = TotalTable[FixingAnimKey +1]
                                        else
                                            TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingAnimKey +1]
                                        end
                                        FixingAnimKey = FixingAnimKey +1
                                    else
                                        FixingAnimKey = 1
                                        if TotalTable[1] then
                                            TableHolder = TotalTable[1]
                                        else
                                            TableHolder = SitConfig.objects[FixingIndexKey].Animations[1]
                                        end
                                    end
                                elseif FixingMultiKey then

                                    if SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][FixingAnimKey +1] then
                                        if TotalTable[FixingAnimKey +1] then
                                            TableHolder = TotalTable[FixingAnimKey +1]
                                        else
                                            TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][FixingAnimKey +1]
                                        end
                                        FixingAnimKey = FixingAnimKey +1
                                    else
                                        FixingAnimKey = 1
                                        if TotalTable[1] then
                                            TableHolder = TotalTable[1]
                                        else
                                            TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][1]
                                        end
                                    end
                                end
                                TableHolder.coords = SitConfig.objects[FixingIndexKey].Seats[FixingMultiKey]
                                local objectcoords = vector3(TableHolder.coords.x + TableHolder.right_left_X, TableHolder.coords.y + TableHolder.forward_backwards_Y, TableHolder.coords.z + TableHolder.up_down_z)
                                    PlayerLastPos = GetEntityCoords(ped)
                                FreezeEntityPosition(ped, true)

                                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                                SetEntityHeading(ped, TableHolder.heading)
                                if TableHolder.dict then
                                    Animation(TableHolder.dict, TableHolder.anim, ped)
                                elseif TableHolder.anim then
                                    inScenario = true
                                    TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                    TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, TableHolder.heading, 0, TableHolder.IsSittingAnim, true)
                                end
                                Wait(100)
                            end

                            if IsControlJustPressed(0, 23)  then
                                Wait(100)
                                ClearPedTasks(ped)
                                FreezeEntityPosition(ped, false)
                                ClearPedTasks(ped)
                                break
                            end
                            if IsControlJustPressed(0, 38)  then
                                TotalTable[FixingAnimKey] = TableHolder
                                SynSit_ShowNotification("Saved Offsets. Loading Next Anim")
                            end
                        end

                    longstring = "{"
                    for k ,v in pairs(TotalTable) do
                        if type(k) == 'number' then
                            k = "["..k.."]"
                        end
                        print(v)
                        if type(v) == 'table' then
                            longstring = longstring .. "" .. k .. " = {"
                            for x,y in pairs(v) do
                                if type(x) == 'number' then
                                    x = "["..x.."]"
                                end
                                print(y)
                                if type(y) == 'table' then
                                    longstring = longstring .. "" .. x .. " = {"
                                    for t,u in pairs(y) do
                                        longstring = longstring .. "" .. x .. " = " .. y ..","
                                    end
                                    longstring = longstring .. "},"
                                elseif type(y) == 'string' then
                                    longstring = longstring .. "" .. x .. " = '" .. y .."',"
                                elseif type(y) == 'number' then
                                    longstring = longstring .. "" .. x .. " = " .. y ..","
                                end
                            end
                            longstring = longstring .. "},"
                        elseif type(v) == 'string' then
                            longstring = longstring .. "" .. k .. " = '" .. v .."',"
                        elseif type(v) == 'number' then
                            longstring = longstring .. "" .. k .. " = " .. v ..","
                        end
                    end
                    longstring = longstring .."}"
                    if string.find(longstring, ",}") then
                        longstring = string.gsub(longstring, ",}", "}")
                    end
                    if string.find(longstring, "},") then
                        longstring = string.gsub(longstring, "},", "},\n")
                    end
                    print(longstring)
                    SitConfig.objects[FixingIndexKey].objName = SitConfig.objects[FixingIndexKey].objName or "null"
                    local infostring = ""
                    if FixingMultiKey then
                        infostring = "Search for objName" ..  SitConfig.objects[FixingIndexKey].objName .. " At index #" .. FixingIndexKey .. " The MultiSeat ID is #".. FixingMultiKey .. "\n"
                    else
                        infostring = "Search for objName" ..  SitConfig.objects[FixingIndexKey].objName .. " At index #" .. FixingIndexKey .. "\n"
                    end
                    SendNUIMessage({coords = infostring .. longstring})
                else
                    TotalTable = {}
                    local ped = PlayerPedId()
                    local object = TableHolder.object
                    bobthebuildertable = {}
                    for k,v in pairs(TableHolder) do
                        if k ~= "object" then
                            bobthebuildertable[k] =  v
                        end
                    end
                    TableHolder = bobthebuildertable
                    if object then
                        local objectheadingOffset = 0.0
                        local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                        if TableHolder.DynamicHeading then
                            objectheadingOffset = GetEntityHeading(object)
                        else
                            objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                        end
                        local objectcoords = coords
                        if offsett then
                        objectcoords = offsett
                        end

                        PlayerLastPos = GetEntityCoords(ped)
                        FreezeEntityPosition(object, true)
                        FreezeEntityPosition(ped, true)
                        SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                        SetEntityHeading(ped, objectheadingOffset)
                        if TableHolder.dict then
                            Animation(TableHolder.dict, TableHolder.anim, ped)
                        elseif TableHolder.anim then
                            inScenario = true
                            TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                            TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                        end
                    end
                    while true do
                        Citizen.Wait(3)
                        ShowHelpNotification("~INPUT_PICKUP~Save~INPUT_DIVE~Next~INPUT_ARREST~Exit\n~g~WASD ~w~XY ~g~Up-Down Arrow ~w~Z")
                        if IsControlJustPressed(0, 32) then
                            ClearPedTasksImmediately(ped)
                            TableHolder.forward_backwards_Y =  roundDec(TableHolder.forward_backwards_Y + 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end

                            Wait(100)
                        elseif IsControlJustPressed(0, 8) then
                            ClearPedTasksImmediately(ped)
                            TableHolder.forward_backwards_Y =  roundDec(TableHolder.forward_backwards_Y - 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end

                        if IsControlJustPressed(0, 34)  then
                            ClearPedTasksImmediately(ped)
                            TableHolder.right_left_X =  roundDec(TableHolder.right_left_X + 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end
                        if IsControlJustPressed(0, 35)  then
                            ClearPedTasksImmediately(ped)
                            TableHolder.right_left_X =  roundDec(TableHolder.right_left_X - 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end

                        if IsControlJustPressed(0, 172)  then
                            ClearPedTasksImmediately(ped)
                            TableHolder.up_down_z =  roundDec(TableHolder.up_down_z + 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end
                        if IsControlJustPressed(0, 173)  then
                            ClearPedTasksImmediately(ped)
                            TableHolder.up_down_z =  roundDec(TableHolder.up_down_z - 0.02 , 4)
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end

                        if IsControlPressed(0, 174)  then
                            TableHolder.Heading =  roundDec(TableHolder.Heading + 0.02 , 4)
                            local objectheadingOffset = 0.0
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            SetEntityHeading(ped, objectheadingOffset)
                            Wait(100)
                        end
                        if IsControlPressed(0, 175)  then
                            TableHolder.Heading = roundDec(TableHolder.Heading - 0.02 , 4)
                            local objectheadingOffset = 0.0
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            SetEntityHeading(ped, objectheadingOffset)
                            Wait(100)
                        end


                        if IsControlJustPressed(0, 203)  then
                            print(FixingAnimKey)
                            if not FixingMultiKey then
                                TotalTable[FixingAnimKey] = TableHolder
                                if SitConfig.objects[FixingIndexKey].Animations[FixingAnimKey +1] then
                                    if TotalTable[FixingAnimKey +1] then
                                        TableHolder = TotalTable[FixingAnimKey +1]
                                    else
                                        TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingAnimKey +1]
                                    end
                                    FixingAnimKey = FixingAnimKey +1
                                else
                                    FixingAnimKey = 1
                                    if TotalTable[1] then
                                        TableHolder = TotalTable[1]
                                    else
                                        TableHolder = SitConfig.objects[FixingIndexKey].Animations[1]
                                    end
                                end
                            elseif FixingMultiKey then

                                if SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][FixingAnimKey +1] then
                                    if TotalTable[FixingAnimKey +1] then
                                        TableHolder = TotalTable[FixingAnimKey +1]
                                    else
                                        TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][FixingAnimKey +1]
                                    end
                                    FixingAnimKey = FixingAnimKey +1
                                else
                                    FixingAnimKey = 1
                                    if TotalTable[1] then
                                        TableHolder = TotalTable[1]
                                    else
                                        TableHolder = SitConfig.objects[FixingIndexKey].Animations[FixingMultiKey][1]
                                    end
                                end
                            end
                            local objectheadingOffset = 0.0
                            local offsett = GetOffsetFromEntityInWorldCoords(object,TableHolder.right_left_X,TableHolder.forward_backwards_Y,TableHolder.up_down_z)
                            if TableHolder.DynamicHeading then
                                objectheadingOffset = GetEntityHeading(object)
                            else
                                objectheadingOffset = GetEntityHeading(object) - TableHolder.Heading
                            end
                            local objectcoords = coords
                            if offsett then
                            objectcoords = offsett
                            end

                            PlayerLastPos = GetEntityCoords(ped)
                            FreezeEntityPosition(object, true)
                            FreezeEntityPosition(ped, true)
                            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z)
                            SetEntityHeading(ped, objectheadingOffset)
                            if TableHolder.dict then
                                Animation(TableHolder.dict, TableHolder.anim, ped)
                            elseif TableHolder.anim then
                                inScenario = true
                                TableHolder.IsSittingAnim = TableHolder.IsSittingAnim or false
                                TaskStartScenarioAtPosition(ped, TableHolder.anim, objectcoords, objectheadingOffset, 0, TableHolder.IsSittingAnim, true)
                            end
                            Wait(100)
                        end

                        if IsControlJustPressed(0, 23)  then
                            Wait(100)
                            ClearPedTasks(ped)
                            FreezeEntityPosition(ped, false)
                            ClearPedTasks(ped)
                            break
                        end
                        if IsControlJustPressed(0, 38)  then
                            TotalTable[FixingAnimKey] = TableHolder
                            SynSit_ShowNotification("Saved Offsets. Loading Next Anim")
                        end
                    end

                longstring = "{"
                for k ,v in pairs(TotalTable) do
                    if type(k) == 'number' then
                        k = "["..k.."]"
                    end
                    print(v)
                    if type(v) == 'table' then
                        longstring = longstring .. "" .. k .. " = {"
                        for x,y in pairs(v) do
                            if type(x) == 'number' then
                                x = "["..x.."]"
                            end
                            print(y)
                            if type(y) == 'table' then
                                longstring = longstring .. "" .. x .. " = {"
                                for t,u in pairs(y) do
                                    longstring = longstring .. "" .. x .. " = " .. y ..","
                                end
                                longstring = longstring .. "},"
                            elseif type(y) == 'string' then
                                longstring = longstring .. "" .. x .. " = '" .. y .."',"
                            elseif type(y) == 'number' then
                                longstring = longstring .. "" .. x .. " = " .. y ..","
                            end
                        end
                        longstring = longstring .. "},"
                    elseif type(v) == 'string' then
                        longstring = longstring .. "" .. k .. " = '" .. v .."',"
                    elseif type(v) == 'number' then
                        longstring = longstring .. "" .. k .. " = " .. v ..","
                    end
                end
                longstring = longstring .."}"
                if string.find(longstring, ",}") then
                    longstring = string.gsub(longstring, ",}", "}")
                end
                if string.find(longstring, "},") then
                    longstring = string.gsub(longstring, "},", "},\n")
                end
                print(longstring)
                SitConfig.objects[FixingIndexKey].objName = SitConfig.objects[FixingIndexKey].objName or "null"
                local infostring = ""
                if FixingMultiKey then
                    infostring = "Search for objName" ..  SitConfig.objects[FixingIndexKey].objName .. " At index #" .. FixingIndexKey .. " The MultiSeat ID is #".. FixingMultiKey .. "\n"
                else
                    infostring = "Search for objName" ..  SitConfig.objects[FixingIndexKey].objName .. " At index #" .. FixingIndexKey .. "\n"
                end
                SendNUIMessage({coords = infostring .. longstring})
            end
        end
        TableHolder = nil
    end)

    RegisterCommand("SaveMyHeading", function()
        SendNUIMessage({coords = "Heading = ".. roundDec(GetEntityHeading(PlayerPedId()),2)})
    end)

    RegisterCommand("Createpolygonseat", function()
    local pId = PlayerPedId()
    local pIdCoords = GetEntityCoords(pId)
    local distance = nil
    local size = nil
    local learning = true
local viewable = false
local Saveable = false
local ZoneID = nil
local PositionStrings = ""


    differencecheck = {
        low = false,
        high = false
    }
    parameters = {
        points = {},
        Seats = {},
        Animations = {},
        multiSeat = {},
        thickness = 1.0,
        debug = true,
        ZoneID = nil,
		distance = 3.0,
		objName= false,
        options = {}
    }

        local Stage = 0
        local markerheading = 0.0
        while learning do
            Citizen.Wait(5)
            local pEscena = getCoordsScene()
            if pEscena ~= nil then
                distance = #(pEscena - pIdCoords)
                if distance < 30 then
                    size = 0.1
                elseif distance > 30 and distance  < 90 then
                    size = 0.2
                else
                    size = 0.4
                end

                if IsDisabledControlPressed(0, 15) then
                    markerheading = markerheading + 3.0
                elseif IsDisabledControlPressed(0, 16) then
                    markerheading = markerheading - 3.0
                end

                if Stage == 4 then
                    DrawMarker(26, pEscena.x, pEscena.y, pEscena.z+0.1, 0, 0, 0, 0, 0, markerheading, size*3, size*3, size*3, 255, 4, 4, 100, false, false)
                end
                DrawMarker(28, pEscena.x, pEscena.y, pEscena.z, 0, 0, 0, 0, 0, 0, size, size, size, SitConfig.DebugMarkerColor, false, false)
            end

        if Stage == 0 then
        ShowHelpNotification("Press ~INPUT_ATTACK~ to Select Bottom")
        elseif Stage == 1 then
        ShowHelpNotification("Press ~INPUT_ATTACK~ to Select Top")
        elseif Stage == 2 then
        ShowHelpNotification("Press ~INPUT_ATTACK~ to Select Point number "..#parameters.points+1 .." Press ~INPUT_PICKUP~ To Continue.")
        elseif Stage == 3 then
        ShowHelpNotification("Press ~INPUT_ATTACK~ to ~g~View ~INPUT_AIM~ to ~r~Cancel")
        elseif Stage == 4 then
        ShowHelpNotification("~INPUT_ATTACK~ Add Chair ~INPUT_FRONTEND_RDOWN~ to Finish ~INPUT_AIM~ to Cancel")
        end

        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)

        DisableControlAction(0, 24, true)
        DisableControlAction(0, 38, true)
        if Stage == 2 and IsDisabledControlJustReleased(0, 38) then
            Stage = 3
        end
        if IsDisabledControlJustReleased(0, 24) then
            if  Stage == 0 then

            differencecheck.low = pEscena.z
            Stage = 1
            elseif Stage == 1 then

            differencecheck.high = pEscena.z
            Stage = 2
            elseif Stage == 2 then

            if differencecheck.low then
                SynSit_ShowNotification("Points #"..#parameters.points+1 .. " Added Successfully")
                parameters.points[#parameters.points+1] = vector3(pEscena.x,pEscena.y,differencecheck.low)


            else
                print("ERROR: No low point Found")
                learning = false
            end
            elseif Stage == 3 then
                parameters.thickness = roundDec((differencecheck.high - differencecheck.low), 1)
                if parameters.thickness < 0.1 or parameters.thickness > 5 then
                parameters.thickness = 1.0
                end


                parameters.debug = true
                if GetResourceState('ox_target') == 'started'  then
                    ZoneID = exports.ox_target:addPolyZone(parameters)
                end
                Stage = 4
            elseif  Stage == 4 then
                SynSit_ShowNotification("Seat #"..#parameters.Seats+1 .. " Added Successfully")
                parameters.Seats[#parameters.Seats+1] = pEscena
                parameters.Animations[#parameters.Animations+1] =  {
                    {anim = 'PROP_HUMAN_SEAT_BENCH',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_DECKCHAIR',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_STRIP_WATCH',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR_DRINK',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR_DRINK_BEER',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR_FOOD',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_DECKCHAIR',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_DECKCHAIR_DRINK',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_ARMCHAIR',right_left_X= 0.0, forward_backwards_Y= 0.1, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                    {anim = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT',right_left_X= 0.0, forward_backwards_Y= 0.0, up_down_z= 0.03,Heading = markerheading,   IsSittingAnim = true, skipExitScene = false},
                }
                parameters.multiSeat[#parameters.multiSeat+1] = "Seat " .. #parameters.multiSeat+1
            end
        end
            if IsControlJustReleased(0, 191) then
                if Stage == 4 then
                    Saveable = false
                    parameters.debug = false
                    longstring = "["..(#SitConfig.objects+1).."] = {\n  "
                    for k ,v in pairs(parameters) do
                        if type(k) == 'number' then
                            k = "\n["..k.."]"
                        end
                        print(v)
                        if type(v) == 'table' then
                            longstring = longstring .. "" .. k .. " = {"
                            for x,y in pairs(v) do
                                if type(x) == 'number' then
                                    x = "\n["..x.."]"
                                end
                                print(y)
                                if type(y) == 'table' then

                                    longstring = longstring .. "" .. x .. " = {"
                                    for t,u in pairs(y) do
                                        if type(u) == 'table' then
                                            if type(t) == 'number' then
                                                t = "\n["..t.."]"
                                            end
                                            longstring = longstring .. "" .. t .. " = {"
                                                for a,b in pairs(u) do
                                                    if type(b) == 'table' then
                                                        print("No Support For Quad Nested Tables")
                                                    elseif type(b) == 'string' then
                                                        longstring = longstring .. "" .. a .. " = '" .. b .."',"
                                                    elseif type(b) == 'number' then
                                                        longstring = longstring .. "" .. a .. " = " .. b ..","
                                                    elseif type(b) == 'vector3' then
                                                        longstring = longstring .. a.." = vector3(" .. b.x .. ", " .. b.y .. ", ".. b.z .. "),"
                                                    end
                                                end
                                            longstring = longstring .. "},"
                                        elseif type(u) == 'string' then
                                            longstring = longstring .. "" .. t .. " = '" .. u .."',"
                                        elseif type(u) == 'number' then
                                            longstring = longstring .. "" .. t .. " = " .. u ..","
                                        elseif type(u) == 'vector3' then
                                            longstring = longstring .. t.." = vector3(" .. u.x .. ", " .. u.y .. ", ".. u.z .. "),"
                                        end
                                    end
                                    longstring = longstring .. "},"
                                elseif type(y) == 'string' then
                                    longstring = longstring .. "" .. x .. " = '" .. y .."',"
                                elseif type(y) == 'number' then
                                    longstring = longstring .. "" .. x .. " = " .. y ..","
                                elseif type(y) == 'vector3' then
                                    longstring = longstring .. x.." = vector3(" .. y.x .. ", " .. y.y .. ", ".. y.z .. "),"
                                end
                            end
                            longstring = longstring .. "},"
                        elseif type(v) == 'string' then
                            longstring = longstring .. "" .. k .. " = '" .. v .."',"
                        elseif type(v) == 'number' then
                            longstring = longstring .. "" .. k .. " = " .. v ..","
                            elseif type(v) == 'vector3' then
                            longstring = longstring .. k.." = vector3(" .. v.x .. ", " .. v.y .. ", ".. v.z .. "),"
                        elseif type(v) == 'boolean' then
                            if v == true then
                                v = "true"
                            else
                                v = "false"
                            end
                            longstring = longstring .. "" .. k .. " = " .. v ..","
                        end
                    end
                    longstring = longstring .."}"
                    if string.find(longstring, ",}") then
                        longstring = string.gsub(longstring, ",}", "}")
                    end
                    if string.find(longstring, "},") then
                        longstring = string.gsub(longstring, "},", "},\n")
                    end
                    if string.find(longstring, "}}") then
                        longstring = string.gsub(longstring, "}}", "  }\n}")
                    end
                    print(longstring)
                    local infostring = ""

                    SendNUIMessage({
                        coords = longstring
                    })

                    SynSit_ShowNotification("Table Saved To Clipboard")
                    learning = false
                end
            elseif IsControlJustReleased(0, 73) or IsControlJustReleased(0, 177) then
                learning = false
            end
        end
    if ZoneID then
        if GetResourceState('ox_target') == 'started'  then
            exports.ox_target:removeZone(ZoneID)
        end
    end
    end)
        function getCoordsScene()
        local Cam = GetGameplayCamCoord()
        local _, Hit, Coords, _, Entity = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(Cam, getCoordsFromCam(20, Cam), -1, PlayerPedId(), 4))
        return Coords
        end

        function getCoordsFromCam(distance, coords)
        local rotation = GetGameplayCamRot()
        local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
        local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
        return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
        end
    end
end)