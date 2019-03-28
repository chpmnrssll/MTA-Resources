local serverTime = {}
local hourDiff, minDiff

function updateClock()
	local localTime = getRealTime()
	setTime(localTime.hour-hourDiff, localTime.minute-minDiff)
end

addEvent("recieveServerTime", true)
addEventHandler("recieveServerTime", getRootElement(),
	function (realTime)
		serverTime.hour = tonumber(realTime.hour)
		serverTime.minute = tonumber(realTime.minute)
		
		local localTime = getRealTime()
		hourDiff = localTime.hour-serverTime.hour
		minDiff = localTime.minute-serverTime.minute
		
		updateClock()
		setTimer(updateClock, 60000, 0)
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		setMinuteDuration(3600000)
		triggerServerEvent("requestServerTime", getLocalPlayer())
	end
)