addEvent("requestServerTime", true)
addEventHandler("requestServerTime", getRootElement(),
	function ()
		triggerClientEvent(source, "recieveServerTime", source, getRealTime())
	end
)
