local localPlayer = getLocalPlayer()

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for i, g in ipairs(getElementsByType('payNSpray')) do
			createBlip(getElementData(g, 'posX'),getElementData(g, 'posY'),getElementData(g, 'posZ'), 63, 1, 0,255,128,128, 0, 255)
		end
		
		addEventHandler('onClientColShapeHit', getRootElement(),
			function (hitElement, matchingDimension)
				if hitElement == getPedOccupiedVehicle(localPlayer) then
					if getElementData(source, 'type') == 'payNSpray' then
						local cx,cy,cz,tx,ty,tz = getCameraMatrix()
						setCameraMatrix(cx,cy,cz,tx,ty,tz)
					end
				end
			end
		)
		
		addEventHandler('onClientColShapeLeave', getRootElement(),
			function (hitElement, matchingDimension)
				if hitElement == getPedOccupiedVehicle(getLocalPlayer()) then
					if getElementData(source, 'type') == 'payNSpray' then
						setCameraTarget(localPlayer)
					end
				end
			end
		)
	end
)
