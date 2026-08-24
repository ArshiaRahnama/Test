

CreateThread(function()
	Wait(1000)
	TriggerEvent('chat:addSuggestion', '/mp', 'Chat with your own job only (e.g. CID -> CID)', {
		{ name = 'message', help = 'Message to send' },
	})
end)
