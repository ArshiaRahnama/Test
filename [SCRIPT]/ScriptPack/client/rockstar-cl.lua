function NET(eventName, func)
	RegisterNetEvent(eventName)
	AddEventHandler(eventName, func)
end

NET('record', function()
	StartRecording(1)
end)

NET('crecord', function()
	StopRecordingAndDiscardClip()
end)

NET('srecord', function()
	StopRecordingAndSaveClip()
end)

NET('editor', function()
	ActivateRockstarEditor()
end)

NET('oeditor', function()
	NetworkSessionLeaveSinglePlayer()
	ActivateRockstarEditor()
end)