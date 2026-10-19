--[[
	This resource bundles TWO separate pre-built NUI apps (the cafe crafting
	overlay and the uwumarket Vue app) inside one resource. FiveM only
	supports one `ui_page` per resource, so html/index.html is a tiny router
	that keeps both apps in their own <iframe> and shows/hides + forwards
	messages to whichever one is active. These two helpers just wrap the
	message so the router knows which iframe to forward it to - the actual
	payload/shape sent to each app is completely unchanged.
]]

function SendCafeNUI(msg)
	SendNUIMessage({ __routeTo = 'cafe', payload = msg })
end

-- silent = true: deliver the message but do not bring this frame to the front
-- (used for background config pushes that happen while another panel is open).
function SendMarketNUI(msg, silent)
	SendNUIMessage({ __routeTo = 'market', payload = msg, __silent = silent and true or nil })
end

function SendShopNUI(msg)
	SendNUIMessage({ __routeTo = 'shop', payload = msg })
end
