local localPlayer = getLocalPlayer()

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		addEventHandler("onClientRender", getRootElement(),
			function ()
				local veh = getPedOccupiedVehicle(localPlayer)
				if not veh then return end
				if(isVehicleOnGround(veh)) then
					setVehicleGravity(veh, 0, 0, -1)
					counter = 0.8
				else
					local gx, gy, gz = getVehicleGravity(veh)
					setVehicleGravity(veh, gx, gy, gz*counter)
					if counter < 1 then
						counter = counter+0.1
					end
				end
			end
		)
	end
)