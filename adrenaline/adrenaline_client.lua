local localPlayer = getLocalPlayer()

local counter = 0
local countout = 90
local timer = 0
local timeout = 500

addEvent("adrenalineStart", true)
addEventHandler("adrenalineStart", getRootElement(),
	function ()
		counter = 0
		timer = 0
		addEventHandler("onClientPreRender", getRootElement(), adrenaline)
--		setTimer(removeEventHandler, 5000, 1, "onClientPreRender", getRootElement(), adrenaline)
	end
)

function adrenaline()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then
		if counter < timeout then
			counter = counter+2
			local time = 1-((countout-counter)*0.01)
			setGameSpeed(time)
		else
--			local vx, vy, vz = getElementVelocity(localPlayer)
--			local time = 1+(((vx*vx)+(vy*vy)+(vz*vz))*16)
			setGameSpeed(10)
		end
	end
	
	if timer < timeout then
		timer = timer+1
	else
		setGameSpeed(0.1)
		setTimer(
			function ()
				local speed = getGameSpeed()
				if speed < 1 then
					speed = speed+0.025
					setGameSpeed(speed)
				else
					setGameSpeed(1)
				end
			end, 50, 50)
		removeEventHandler("onClientPreRender", getRootElement(), adrenaline)
	end
end