-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RayCast = {}
RayCast.isPlacing = false
RayCast.args = {}
local CurrentModel
local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end


local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, cache.ped, 4))
	return b, c, e
end

local function DoesObjectCollide(entity)
    local coords = GetEntityCoords(entity)
    local minV, maxV = GetModelDimensions(GetEntityModel(entity))
    local modelResult = maxV - minV

    local rayHandle = StartShapeTestBox(
        coords.x, coords.y, coords.z + 2.0,
        modelResult.x, modelResult.y, modelResult.z,
        0.0, 0.0, 0.0,
        2, 339,
        entity, 4)

    local retval, hit, endCoords, _, materialHash, entity2 = GetShapeTestResultIncludingMaterial(rayHandle)
    return hit
end

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

local function setupScaleform(scaleform)
    local scaleform = lib.requestScaleformMovie(scaleform) or 0
    if scaleform == 0 then return end

    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()


    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    Button(GetControlInstructionalButton(2, 177, true))
    ButtonMessage("Cancel")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    Button(GetControlInstructionalButton(2, 153, true))
    ButtonMessage("Place object")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    Button(GetControlInstructionalButton(2, 190, true))
    Button(GetControlInstructionalButton(2, 189, true))
    ButtonMessage("Rotate object")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(3)
    Button(GetControlInstructionalButton(2, 21, true))
    ButtonMessage("Slow Rotate")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()

    return scaleform
end

function RayCast.Object(model, distance)
    if RayCast.isPlacing then print('[CAST] another object is being placed') return false end
    CurrentModel = (type(model) == "string" and joaat(model)) or model
    local distance = (distance or 20)

    lib.requestModel(CurrentModel)
    local CurrentObject = CreateObject(CurrentModel, 1.0, 1.0, 1.0, false, false, false)
    -- CreateObject(CurrentModel, 1.0, 1.0, 1.0, false, true, false)
    if not DoesEntityExist(CurrentObject) then print('[CAST] tried to raycast invalid object') return false end

    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)

    SetEntityAlpha(CurrentObject, 150)
    SetEntityCollision(CurrentObject, false, false)
    -- SetEntityInvincible(CurrentObject, true)
    FreezeEntityPosition(CurrentObject, true)
    RayCast.isPlacing = true

    local p = promise.new()
    CreateThread(function()
        -- Scale Form
        local form = setupScaleform("instructional_buttons")
        local xPos = 0.39 -- position from the left edge of the screen
        local yPos = 0.51 -- position from the top edge of the screen
        local scaleformWidth = 1 -- width of the scaleform
        local scaleformHeight = 1 -- height of the scaleform

        local lastCoords = vector3(1.0, 1.0, 1.0)
        local collide = false

        while RayCast.isPlacing do
            if GetEntityModel(CurrentObject) ~= CurrentModel then
                DeleteEntity(CurrentObject)
                CurrentObject = CreateObject(CurrentModel, 1.0, 1.0, 1.0, false, true, false)
                SetEntityHeading(CurrentObject, heading)
                SetEntityAlpha(CurrentObject, 150)
                SetEntityCollision(CurrentObject, false, false)
                -- SetEntityInvincible(CurrentObject, true)
                FreezeEntityPosition(CurrentObject, true)
                SetEntityCoords(CurrentObject, lastCoords.x, lastCoords.y, lastCoords.z)
            end
            local hit, coords, entity = RayCastGamePlayCamera(distance)
            ---@diagnostic disable-next-line: param-type-mismatch
            DrawScaleformMovie(form, xPos, yPos, scaleformWidth, scaleformHeight, 255, 255, 255, 255, 0)

            if hit and coords ~= lastCoords then
                lastCoords = coords
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(CurrentObject)
            end
            collide = DoesObjectCollide(CurrentObject)
            SetEntityDrawOutline(CurrentObject, collide)

            local myCoords = GetEntityCoords(cache.ped)
            if #(lastCoords - myCoords) > distance then
                SetEntityCoords(CurrentObject, myCoords.x, myCoords.y, myCoords.z)
                PlaceObjectOnGroundProperly(CurrentObject)
            end

            if IsControlPressed(0, 174) and not lib.getOpenMenu() then
                heading = heading + (IsControlPressed(0, 21) and 1 or 5)
                if heading > 360 then heading = 0.0 end
            end

            if IsControlPressed(0, 175) and not lib.getOpenMenu() then
                heading = heading - (IsControlPressed(0, 21) and 1 or 5)
                if heading < 0 then heading = 360.0 end
            end

            if IsControlJustPressed(0, 177) or IsPedInAnyVehicle(PlayerPedId(), true) then
                p:resolve(false)
                RayCast.isPlacing = false
                lib.hideMenu(true)
                break
            end

            SetEntityHeading(CurrentObject, heading)
            if IsControlJustPressed(0, 38) then
                local objectCoords = GetEntityCoords(CurrentObject)
                p:resolve(not collide and vector4(objectCoords.x, objectCoords.y, objectCoords.z, heading))
                RayCast.isPlacing = false
                break
            end
            DisableControlAction(0, 22, true)
            Wait(0)
        end

        if DoesEntityExist(CurrentObject) then DeleteEntity(CurrentObject) end
        if p.state == 0 then
            p:resolve(false)
        end
    end)

    return Citizen.Await(p)
end

function RayCast.Cancel()
    if not RayCast.isPlacing then return false end
    RayCast.isPlacing = false
    return true
end

function RayCast.RpPut(model, distance, args)
    RayCast.args = args
    local coords = RayCast.Object(model, distance)
    if not coords then return false end
    local thisCoords = vector3(coords.x, coords.y, coords.z)
    local start_time = GetGameTimer()
    local difference = #(GetEntityCoords(cache.ped) - thisCoords)
    TaskGoToCoordAnyMeans(cache.ped, coords.x, coords.y, coords.z, 5.0, 0, false, 786603, 1.0)
    SetPedKeepTask(cache.ped, true)
    repeat
        Wait(250)
        difference = #(GetEntityCoords(cache.ped) - thisCoords)
    until difference <= 1.5 or (GetGameTimer() - start_time > 3000)
    ClearPedTasksImmediately(cache.ped)

    if difference <= 1.5 then
        ExecuteCommand('e pickup')
        Wait(250)
        return coords, RayCast.args
    else
        return false
    end
end

function RayCast.changeModel(model, args)
    RayCast.args = args
    CurrentModel = model
end
exports('rayCastPut', RayCast.RpPut)