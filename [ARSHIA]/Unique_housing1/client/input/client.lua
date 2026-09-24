--

local callback = false

--

Open = function(header,style,cb)
  callback = cb
  SetNuiFocus(true,true)
  SendNUIMessage({
    type   = ("uh_input_open"),
    header = (header or "Input"),
    style  = (style or "Native")
  })
end

--

Posted = function(data)
  SetNuiFocus(false,false)
  if callback then
    callback(data.message)
  end
end

--

RegisterNUICallback('uh_input_post', Posted)

--

AddEventHandler('Input:Open',Open)
exports("Open",Open)


--