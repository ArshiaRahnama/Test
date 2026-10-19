-- Routes this resource's gang NUI messages to the gang panel frame (see router.html).
function SendGangNUI(msg) SendNUIMessage({ __routeTo = 'gang', payload = msg }) end
