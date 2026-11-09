-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

function IsPlayerFullyLoaded(ped)
    local playerModel = GetEntityModel(ped)
    return (playerModel ~= `player_zero` and playerModel ~= `player_one` and playerModel ~= `a_m_y_stbla_02`)
end

function IsTemporaryPlate(plate)
	local total = 0
	plate = tostring(plate)
	if not plate or #plate ~= 7 then
		return false
	end
	for i = 1, 3 do
		local c = string.byte(plate:sub(i,i))
		if c < 65 or c > 90 then
			return false
		end
		total = total + c
	end
	local number = tonumber(plate:sub(4,7))
	if not number then
		return false
	end
	local modulos = {1194, 1100, 1000, 900, 800, 700, 600, 500, 400}
	for _, modulo in pairs(modulos) do
		if (total + number) % modulo == 0 then
			return true
		end
	end
	return false
end

function GetTemporaryPlate()
	local plate = ''
	local total = 0
	for i = 1, 3 do
		local c = math.random(65, 90)
		total = total + c
		plate = plate..string.char(c)
	end
	local modulos = {1194, 1100, 1000, 900, 800, 700, 600, 500, 400}
	plate = plate..' '..(modulos[math.random(1,#modulos)] - total)
	return plate
end

function CoordsIsInsidePolygon(polygon, coords)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < coords.y and polygon[j].y >= coords.y or polygon[j].y < coords.y and polygon[i].y >= coords.y) then
            if (polygon[i].x + ( coords.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < coords.x) then
                oddNodes = not oddNodes
            end
        end
        j = i
    end
    return oddNodes
end

function ApplyRotationMatrix(vector, heading)
	local headingSin = math.sin(heading * math.pi/180.0)
	local headingCos = math.cos(heading * math.pi/180.0)
    if type(vector) == 'vector3' then
        return vector3(
            ((vector.x * headingCos) - (vector.y * headingSin)),
            ((vector.x * headingSin) + (vector.y * headingCos)),
            vector.z)
    else
        return vector2(
            ((vector.x * headingCos) - (vector.y * headingSin)),
            ((vector.x * headingSin) + (vector.y * headingCos)))
    end
end
