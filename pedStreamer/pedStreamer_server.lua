local drivers = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
	end
)
--[[
addEvent("createDriver", true)
addEventHandler("createDriver", root,
	function (vehicleID, x1,y1,z1, x2,y2,z2, nodeFileID, targetNodeID)
		local vehicle = createVehicle(vehicleID, x1,y1,z1)
		local rot = findRotation(x1,y1, x2,y2)
		
		setVehicleRotation(vehicle, 0,0, rot)
		setVehicleDamageProof(vehicle, true)
		findController(vehicle)
		
		createBlipAttachedTo(vehicle, 0, 1, 0,255,0,255)	--DEBUG
		addEventHandler("onElementDataChange", vehicle, onElementDataChange)
		triggerClientEvent("driverCreated", vehicle, nodeFileID, targetNodeID)
		
		table.insert(drivers, vehicle)
	end
)
]]
function drv(player)
	local x,y,z = getElementPosition(player)
	local rot = getPedRotation(player)
	--x,y = getPointFromDistanceRotation(x,y, 2, 90)
	
	local driver = createPed(220, x,y,z)
	local vehicle = createVehicle(438, x,y,z)
	setVehicleRotation(vehicle, 0,0, rot)
	--setVehicleDamageProof(vehicle, true)
	setVehicleTaxiLightOn(vehicle, true)
	warpPedIntoVehicle(driver, vehicle, 0)
	warpPedIntoVehicle(player, vehicle, 3)
	findController(vehicle)
	
	createBlipAttachedTo(driver, 0, 1, 0,255,0,255)	--DEBUG
	addEventHandler("onElementDataChange", driver, onElementDataChange)
	addEventHandler("onElementDataChange", vehicle, onElementDataChange)
	triggerClientEvent("driverCreated", driver)
	
	table.insert(drivers, driver)
end
addCommandHandler("drv", drv)

function findController(element)
	local syncer = getElementSyncer(element)
	if syncer then
		setTimer(setElementData, 50, 2, element, "controller", syncer)
	else
		setTimer(findController, 250, 1, element)
	end
end

function onElementDataChange(dataName, oldValue)
	if dataName == "tvel" then
		local turn = getElementData(source, dataName)
		setVehicleTurnVelocity(source, turn[1],turn[2],turn[3])
	elseif dataName == "vel" then
		local vel = getElementData(source, dataName)
		setElementVelocity(source, vel[1],vel[2],vel[3])
	elseif dataName == "controller" and not getElementData(source, "controller") then
		setElementSyncer(source, true)
		findController(source)
	end
end

function findRotation(x1,y1, x2,y2)
	local t = -math.deg(math.atan2(x2-x1, y2-y1))
	if t < 0 then
		t = t+360
	end
	return t
end
