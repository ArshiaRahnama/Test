-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/dduty', 'Toggle dispatch duty')	
	TriggerEvent('chat:addSuggestion', '/dlist', 'Show dispatch list')
	TriggerEvent('chat:addSuggestion', '/weapback', 'Toggle weapon on back')
	TriggerEvent('chat:addSuggestion', '/sunsetpay', 'Sunset pay')
	TriggerEvent('chat:addSuggestion', '/fbipay', 'FBI pay')

	--crosshair
	TriggerEvent('chat:addSuggestion', '/cross', 'Toggle crosshair')
	TriggerEvent('chat:addSuggestion', '/crosse', 'Edit crosshair')
	TriggerEvent('chat:addSuggestion', '/crossr', 'Reset crosshair')

	--
	TriggerEvent('chat:addSuggestion', '/resetrobpoint', 'Reset point')
	TriggerEvent('chat:addSuggestion', '/resetrobplan', 'Reset plan')

	TriggerEvent('chat:addSuggestion', '/glist', 'List a\'azaye gang')
	TriggerEvent('chat:addSuggestion', '/flist', 'List a\'azaye job')
	TriggerEvent('chat:addSuggestion', '/admins', 'List admin ha')
	TriggerEvent('chat:addSuggestion', '/f', '',{
		{name = 'msg', help = 'Message' }
	})
	TriggerEvent('chat:addSuggestion', '/dep', '',{
		{name = 'msg', help = 'Message' }
	})
	TriggerEvent('chat:addSuggestion', '/findnumber', '',{
		{name = 'number', help = 'number' }
	})
	TriggerEvent('chat:addSuggestion', '/findplate', '',{
		{name = 'plate', help = 'plate' }
	})
	TriggerEvent('chat:addSuggestion', '/banbank', 'Ban hesab banki',{
		{name = 'identifier', help = 'HEX/Name'},
		{name = 'state', help = '0/1'},
		{name = 'reason', help = 'Reason'}
	})
	TriggerEvent('chat:addSuggestion', '/banplate', 'Ban plate',{
		{name = 'plate', help = 'plate'},
		{name = 'state', help = 'Day | 0 unban | -1 perm.'},
		{name = 'reason', help = 'Reason'}
	})

	TriggerEvent('chat:addSuggestion', '/banparking', 'Ban parking',{
		{name = 'hex', help = 'hex'},
		{name = 'state', help = '0/1'},
		{name = 'reason', help = 'Reason'}
	})

	TriggerEvent('chat:addSuggestion', '/fwarn', 'Set warn',{
		{name = 'identifier', help = 'HEX/Name'},
		{name = 'reason', help = 'Reason or 0'}
	})

	TriggerEvent('chat:addSuggestion', '/checkacc', 'Check account',{
		{name = 'identifier', help = 'HEX/Name'}
	})

	TriggerEvent('chat:addSuggestion', '/checkfightban', 'Check fight ban')
	TriggerEvent('chat:addSuggestion', '/checkbanemote', 'Check emote ban')
	TriggerEvent('chat:addSuggestion', '/checkdysban', 'Check dys ban')

	TriggerEvent('chat:addSuggestion', '/edivision', 'Add/Remove extra division',{
		{name = 'ID', help = 'ID'}
	})

	TriggerEvent('chat:addSuggestion', '/regfbi', 'Register menu',{
		{name = 'ID', help = 'ID'},
	})

	TriggerEvent('chat:addSuggestion', '/p', 'Party chat',{
		{name = 'Message', help = ''},
	})

	TriggerEvent('chat:addSuggestion', '/rlist', 'Namayesh a\'azaye radio')

	TriggerEvent('chat:addSuggestion', '/shophook', 'Tanzim webhook shop haye ekhtesasi')

	TriggerEvent('chat:addSuggestion', '/tabligh', 'Ersal tabligh be weazel news',{
		{name = 'matn', help = 'Matn tabligh'}
	})

	TriggerEvent('chat:addSuggestion', '/ads', 'Namayesh list tablighat')

	TriggerEvent('chat:addSuggestion', '/ad', 'accept or decline tabligh',{
		{name = 'id tabligh', help = 'shomare tabligh'},
		{name = 'view / accept / decline', help = 'namayesh ya accept ya decline tabligh'},
	})

	TriggerEvent('chat:addSuggestion', '/news', 'Khabar',{
		{name = 'Matn', help = 'Mant Khabar' }
	})

	TriggerEvent('chat:addSuggestion', '/vreg', 'Taghir region voice')
	TriggerEvent('chat:addSuggestion', '/vr', 'Reset voice')

	TriggerEvent('chat:addSuggestion', '/showgang', 'Namayes gang ha')

	TriggerEvent('chat:addSuggestion', '/me', 'Me', {
		{name  = 'Matn', help = 'Matn'}
	})
	TriggerEvent('chat:addSuggestion', '/do', 'Do', {
		{name = 'Matn', help = 'Matn'}
	})

	TriggerEvent('chat:addSuggestion', '/cm', 'Capture menu')
    TriggerEvent('chat:addSuggestion', '/pvp', 'Join pvp')
    TriggerEvent('chat:addSuggestion', '/die', 'Die(Just pvp)')
    TriggerEvent('chat:addSuggestion', '/detach', 'Detach weapon attachment')
    TriggerEvent('chat:addSuggestion', '/g', 'Gang chat')

	TriggerEvent('chat:addSuggestion', '/takehostage', 'Azad sazi gerogan')
	TriggerEvent('chat:addSuggestion', '/radialmenu', 'END Menu')
	TriggerEvent('chat:addSuggestion', '/bimeh', 'Namayesh vaziat bimeh mashin')
	TriggerEvent('chat:addSuggestion', '/carbimeh', 'Baz kardan menu kharid bimeh',{
		{name = 'ID', help = 'ID'},
	})

	TriggerEvent('chat:addSuggestion', '/delobjectjob', 'Delete kardan object haye spawn shode tavasot job')
	TriggerEvent('chat:addSuggestion', '/mg', 'G')
	TriggerEvent('chat:addSuggestion', '/play', 'View time play')

	TriggerEvent('chat:addSuggestion', '/banjob', 'Ban job', {
		{name = 'Steam hex', help = 'hex'},
		{name = 'Time', help = 'Day | 0 for unban'},
		{name = 'Reason', help = 'Reason'},
	})

	TriggerEvent('chat:addSuggestion', '/offense', 'Namayesh list offense ha')
	TriggerEvent('chat:addSuggestion', '/track', 'Track persuit', {
		{name = 'id', help = 'id'}
	})
	TriggerEvent('chat:addSuggestion', '/trackh', 'Track khane', {
		{name = 'id', help = 'id'}
	})

	TriggerEvent('chat:addSuggestion', '/rob', 'Namayesh vaziat robbery')
	TriggerEvent('chat:addSuggestion', '/ready', 'Ready robbery')

	TriggerEvent('chat:addSuggestion', '/vat', 'Jahat ray dadan')
	TriggerEvent('chat:addSuggestion', '/openvote', 'Baz kardan panel admin vote')
	TriggerEvent('chat:addSuggestion', '/votestats', 'Mooshahedeye amaraye vote')

	TriggerEvent('chat:addSuggestion', '/managecw', 'Modiriat change world')

	TriggerEvent('chat:addSuggestion', '/cwr', 'Change world range dar mahal mojaz', {
		{name = 'range', help = 'range (max 50)'},
		{name = 'world', help = 'world mored nazar'}
	})

	TriggerEvent('chat:addSuggestion', '/setjwarn', 'Set justice warn', {
		{name = 'hex', help = 'Steam hex'},
		{name = 'reason'}
	})
	TriggerEvent('chat:addSuggestion', '/viewjwarn', 'View justice warn')
	TriggerEvent('chat:addSuggestion', '/checkchatban', 'Namayesh vaziat chat ban')
	TriggerEvent('chat:addSuggestion', '/dashboard', 'Modiriat ghofl dashboard')

	TriggerEvent('chat:addSuggestion', '/die', 'Die(capture)')

	TriggerEvent('chat:addSuggestion', '/shab', 'Shab baraye bazi mafia')
	TriggerEvent('chat:addSuggestion', '/rooz', 'Rooz baraye bazi mafia')
	TriggerEvent('chat:addSuggestion', '/like', 'Like')
	TriggerEvent('chat:addSuggestion', '/dlike', 'Diss like')

	TriggerEvent('chat:addSuggestion', '/acall', 'Tamas ba yek fard (admin)',{
		{name = 'id', help = 'ID fard (khali = fardi ke spect mikonid)'}
	})
	TriggerEvent('chat:addSuggestion', '/acall2', 'Tamas ba yek fard (FBI)',{
		{name = 'id', help = 'ID fard (khali = fardi ke spect mikonid)'}
	})

end)
