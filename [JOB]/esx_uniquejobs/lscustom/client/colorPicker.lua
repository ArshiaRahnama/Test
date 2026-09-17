RegisterNetEvent("showpicker")
AddEventHandler('showpicker', function(value)
SendNUIMessage({type = 'ON_SHOW', show = value})
end)

local onPick = nil
local onSelect = nil
local onCancel = nil
local focused = 0
local hue = 0
local saturation = 100
local value = 100
local singlePickCooldown = 300
local leftStart = nil
local rightStart = nil
local sendUpdateOnHold = true
local rgb
local hsv

RegisterNetEvent("colorPicker:pick")
AddEventHandler('colorPicker:pick', function(initialR, initialG, initialB, callOnPickCallbackWhenHolding, onPickCallback, onSelectCallback, onCancelCallback)
	sendUpdateOnHold = callOnPickCallbackWhenHolding
	focused = 0
	SetHighlight()
	if initialR and initialG and initialB then
		hsv = RGBtoHSV(initialR, initialG, initialB)
		hue = hsv.h * 360
		saturation = hsv.s * 100
		value = hsv.v * 100
		SendNUIMessage({type = 'ON_COLOR_CHANGED', h = hue, s = saturation, v = value})
	end

	SendNUIMessage({type = 'ON_SHOW', show = true})

	onPick = onPickCallback
	onSelect = onSelectCallback
	onCancel = onCancelCallback

	Citizen.CreateThread(function()
		while(true) do
			if IsControlJustReleased(3, 177) then
				SendNUIMessage({type = 'ON_SHOW', show = false})
				if(onCancel)then
					local rgb = HSVtoRGB(hue/360, saturation/100, value/100)
					onCancel(rgb.r, rgb.g, rgb.b)
				end
				onPick = nil
				onSelect = nil
				onCancel = nil
				break
			end
			if IsControlJustReleased(3, 176) then
				SendNUIMessage({type = 'ON_SHOW', show = false})
				if(onSelect)then
					local rgb = HSVtoRGB(hue/360, saturation/100, value/100)
					onSelect(rgb.r, rgb.g, rgb.b)
				end
				onPick = nil
				onSelect = nil
				onCancel = nil
				break
			end
			if IsControlJustReleased(3, 172) then
				focused = (focused - 1)%3
				SetHighlight()
			end
			if IsControlJustReleased(3, 173) then
				focused = (focused + 1)%3
				SetHighlight()
			end
			if IsControlJustPressed(3, 174) then
				if not rightStart then
					DecrementFocus()
					leftStart = GetNetworkTime()
					if(onPick)then
						rgb = HSVtoRGB(hue/360, saturation/100, value/100)
						onPick(rgb.r, rgb.g, rgb.b)
					end
				end
			end
			if IsControlJustReleased(3, 174) then
				if leftStart then
					leftStart = nil
					if(not sendUpdateOnHold and onPick)then
						rgb = HSVtoRGB(hue/360, saturation/100, value/100)
						onPick(rgb.r, rgb.g, rgb.b)
					end
				end
			end
			if IsControlJustPressed(3, 175) then
				if not leftStart then
					IncrementFocus()
					rightStart = GetNetworkTime()
					if(onPick)then
						rgb = HSVtoRGB(hue/360, saturation/100, value/100)
						onPick(rgb.r, rgb.g, rgb.b)
					end
				end
			elseif IsControlJustReleased(3, 175) then
				if rightStart then
					rightStart = nil
					if(not sendUpdateOnHold and onPick)then
						rgb = HSVtoRGB(hue/360, saturation/100, value/100)
						onPick(rgb.r, rgb.g, rgb.b)
					end
				end
			end
			if leftStart and ((GetNetworkTime() - leftStart) > singlePickCooldown) then
				DecrementFocus()
				if sendUpdateOnHold then
					rgb = HSVtoRGB(hue/360, saturation/100, value/100)
					onPick(rgb.r, rgb.g, rgb.b)
				end
			elseif rightStart and ((GetNetworkTime() - rightStart) > singlePickCooldown) then
				IncrementFocus()
				if sendUpdateOnHold then
					rgb = HSVtoRGB(hue/360, saturation/100, value/100)
					onPick(rgb.r, rgb.g, rgb.b)
				end
			end
		Wait(1)
		end
	end)
end)

local display = false;

function IncrementFocus()
	if(focused==0)then
		hue = (hue+1)%360
	elseif(focused==1)then
		saturation = saturation+1
		if(saturation>100)then saturation = 100 end
	elseif(focused==2)then
		value = value+1
		if(value>100)then value = 100 end
	end
	SendNUIMessage({type = 'ON_COLOR_CHANGED', h = hue, s = saturation, v = value})
end

function DecrementFocus()
	if(focused==0)then
		hue = (hue-1)%360
	elseif(focused==1)then
		saturation = saturation-1
		if(saturation<0)then saturation = 0 end
	elseif(focused==2)then
		value = value-1
		if(value<0)then value = 0 end
	end
	SendNUIMessage({type = 'ON_COLOR_CHANGED', h = hue, s = saturation,	v = value})
end

function SetHighlight()
	if(focused==0)then
		SendNUIMessage({type = 'ON_HIGHLIGHT', marker = 'hue'})
	elseif(focused==1)then
		SendNUIMessage({type = 'ON_HIGHLIGHT', marker = 'saturation'})
	elseif(focused==2)then
		SendNUIMessage({type = 'ON_HIGHLIGHT', marker = 'value'})
	end
end

function HSVtoRGB( h, s, v )
	local r, g, b, i, f, p, q, t
	i = math.floor(h * 6)
	f = h * 6 - i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
	i = i % 6
	if(i==0)then
		r = v
		g = t
		b = p
	elseif(i==1)then
		r = q
		g = v
		b = p
	elseif(i==2)then
		r = p
		g = v
		b = t
	elseif(i==3)then
		r = p
		g = q
		b = v
	elseif(i==4)then
		r = t
		g = p
		b = v
	elseif(i==5)then
		r = v
		g = p
		b = q
	end
	return {r=math.floor(r * 255 + 0.5), g=math.floor(g * 255 + 0.5), b=math.floor(b * 255 + 0.5)}
end

function RGBtoHSV(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max
  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end
  return {h=h, s=s, v=v}
end