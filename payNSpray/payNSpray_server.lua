local sprayTime = 2000
local sprayCost = 100

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i=0,49 do
			setGarageOpen(i,true)
		end
		
		for i, p in ipairs(getElementsByType('payNSpray')) do
			local x = getElementData(p, 'posX')
			local y = getElementData(p, 'posY')
			local z = getElementData(p, 'posZ')
			local sx = getElementData(p, 'sizeX')
			local sy = getElementData(p, 'sizeY')
			local sz = getElementData(p, 'sizeZ')
			local west = getElementData(p, 'west')
			local east = getElementData(p, 'east')
			local south = getElementData(p, 'south')
			local north = getElementData(p, 'north')
			local cx = west+(east-west)
			local cy = south+(north-south)
			local cz = (sz/2)+z
			
			local col = createColCuboid(west,south,z, east-west,north-south,sz/2)
			--setElementData(col, 'posX', west + ((east-west) / 2) )
			--setElementData(col, 'posY', south + ((north-south) / 2) )
			--setElementData(col, 'posZ', z+2)
			setElementData(col, 'type', 'payNSpray')
			setElementData(col, 'garageID', tonumber(getElementID(p)))
			
			addEventHandler("onColShapeHit", col,
				function (hitElement, matchingDimension)
					if getElementType(hitElement) == "vehicle" then
						local player = getVehicleController(hitElement)
						if getPlayerMoney(player) < tonumber(get("sprayCost")) then
							setTimer(playSoundFrontEnd, 1000, 1, player, 40)
						else
							setGarageOpen(getElementData(source, "garageID"), false)
							toggleAllControls(player, false, true, false)
							setControlState(player, "handbrake", true)
							setTimer(
								--function (garageID, vehicle, x,y,z)
								function (garageID, vehicle, x,y,z)
									local player = getVehicleController(vehicle)
									setElementData(player, "wantedLevel", 0)
									playSoundFrontEnd(player, 16)
									takePlayerMoney(player, get("sprayCost"))
									setGarageOpen(garageID, true)
									--setElementPosition(vehicle, x,y,z)
									setElementHealth(vehicle, 1000)
									setVehicleDoorState(vehicle, 0, 0)
									setVehicleDoorState(vehicle, 1, 0)
									setVehicleDoorState(vehicle, 2, 0)
									setVehicleDoorState(vehicle, 3, 0)
									setVehicleDoorState(vehicle, 4, 0)
									setVehicleDoorState(vehicle, 5, 0)
									setVehiclePanelState(vehicle, 0, 0)
									setVehiclePanelState(vehicle, 1, 0)
									setVehiclePanelState(vehicle, 2, 0)
									setVehiclePanelState(vehicle, 3, 0)
									setVehiclePanelState(vehicle, 4, 0)
									setVehiclePanelState(vehicle, 5, 0)
									setVehiclePanelState(vehicle, 6, 0)
									setVehicleLightState(vehicle, 0, 0)
									setVehicleLightState(vehicle, 1, 0)
									setVehicleLightState(vehicle, 2, 0)
									setVehicleLightState(vehicle, 3, 0)
									--local c = math.random(126)
									--setVehicleColor(vehicle, c,c,c,c)
									local r,g,b = math.random(255),math.random(255),math.random(255)
									setVehicleColor(vehicle, r,g,b, r,g,b, r,g,b, r,g,b)
									setControlState(player, "handbrake", false)
									toggleAllControls(player, true, true, true)
								end,
							get("sprayTime"), 1, getElementData(source, "garageID"), hitElement)
							--get("sprayTime"), 1, getElementData(source, "garageID"), hitElement, getElementData(source, 'posX'), getElementData(source, 'posY'), getElementData(source, 'posZ'))
						end
					end
				end
			)
		end
	end
)
