local respawnTime = 3000	--1000 ms = 1 sec
local idleTime = 3000

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, vehicle in pairs(getElementsByType("vehicle")) do	--destroys all vehicles
			destroyElement(vehicle)
		end
		
		loadVehicleDB()
	end
)
addEventHandler("onResourceStop", resourceRoot, 
	function ()
	
		saveVehicleDB()
		for i, vehicle in pairs(getElementsByType("vehicle")) do	--destroys all vehicles
			destroyElement(vehicle)
		end
	end
)
--[[
addEventHandler("onVehicleExit", root,		--???
	function (player, seat, jacker)
		setVehicleOverrideLights(source, 1)
		setVehicleEngineState(source, false)
	end
)
]]
function loadVehicleDB()
	--executeSQLCreateTable("vehicles", "model INTEGER, posX REAL, posY REAL, posZ REAL, rotX REAL, rotY REAL, rotZ REAL, color1 INTEGER, color2 INTEGER, paintjob INTEGER, upgrades TEXT")
	--executeSQLCreateTable("vehicles", "model, posX, posY, posZ, rotX, rotY, rotZ, color1, color2, paintjob, upgrades")
	executeSQLCreateTable("vehicles",
		"model, posX, posY, posZ, rotX, rotY, rotZ, r1,g1,b1, r2,g2,b2, paintjob, upgrades, "..
		"mass, turnMass, dragCoeff, centerOfMassX, centerOfMassY, centerOfMassZ, percentSubmerged, tractionMultiplier, tractionLoss, tractionBias, numberOfGears, "..
		"maxVelocity, engineAcceleration, engineInertia, driveType, engineType, brakeDeceleration, brakeBias, steeringLock, suspensionForceLevel, "..
		"suspensionDamping, suspensionHighSpeedDamping, suspensionUpperLimit, suspensionLowerLimit, suspensionFrontRearBias, suspensionAntiDiveMultiplier, "..
		"seatOffsetDistance, collisionDamageMultiplier, monetary, modelFlags, handlingFlags, headLight, tailLight, animGroup"
	)
	
	local vehicles = executeSQLQuery("SELECT * FROM vehicles")
	
	for i, v in pairs(vehicles) do
		local vehicle = createVehicle(v.model, v.posX, v.posY, v.posZ, v.rotX, v.rotY, v.rotZ)
		setVehicleRespawnPosition(vehicle, v.posX, v.posY, v.posZ, v.rotX, v.rotY, v.rotZ)
		setVehicleRespawnDelay(vehicle, respawnTime)
		setVehicleIdleRespawnDelay(vehicle, idleTime)
		toggleVehicleRespawn(vehicle, true)
		setElementData(vehicle, "RSposX", v.posX)
		setElementData(vehicle, "RSposY", v.posY)
		setElementData(vehicle, "RSposZ", v.posZ)
		setElementData(vehicle, "RSrotX", v.rotX)
		setElementData(vehicle, "RSrotY", v.rotY)
		setElementData(vehicle, "RSrotZ", v.rotZ)
		
		--setVehicleColor(vehicle, v.color1, v.color2, 0, 0)
		setVehicleColor(vehicle, v.r1,v.g1,v.b1, v.r2,v.g2,v.b2)
		
		if v.paintjob  then
			setVehiclePaintjob(vehicle, v.paintjob)
		end
		
		local upgrades = split(v.upgrades, 44)
		for index, upgrade in pairs (upgrades) do
			addVehicleUpgrade(vehicle, upgrade)
		end
		
		setVehicleHandling(vehicle, "mass", tonumber(v.mass))
		setVehicleHandling(vehicle, "turnMass", tonumber(v.turnMass))
		setVehicleHandling(vehicle, "dragCoeff", tonumber(v.dragCoeff))
		setVehicleHandling(vehicle, "centerOfMass", { v.centerOfMassX, v.centerOfMassY, v.centerOfMassZ })
		setVehicleHandling(vehicle, "percentSubmerged", tonumber(v.percentSubmerged))
		setVehicleHandling(vehicle, "tractionMultiplier", tonumber(v.tractionMultiplier))
		setVehicleHandling(vehicle, "tractionLoss", tonumber(v.tractionLoss))
		setVehicleHandling(vehicle, "tractionBias", tonumber(v.tractionBias))
		setVehicleHandling(vehicle, "numberOfGears", tonumber(v.numberOfGears))
		setVehicleHandling(vehicle, "maxVelocity", tonumber(v.maxVelocity))
		setVehicleHandling(vehicle, "engineAcceleration", tonumber(v.engineAcceleration))
		setVehicleHandling(vehicle, "engineInertia", tonumber(v.engineInertia))
		setVehicleHandling(vehicle, "driveType", tostring(v.driveType))
		setVehicleHandling(vehicle, "engineType", tostring(v.engineType))
		setVehicleHandling(vehicle, "brakeDeceleration", tonumber(v.brakeDeceleration))
		setVehicleHandling(vehicle, "brakeBias", tonumber(v.brakeBias))
		setVehicleHandling(vehicle, "steeringLock", tonumber(v.steeringLock))
		setVehicleHandling(vehicle, "suspensionForceLevel", tonumber(v.suspensionForceLevel))
		setVehicleHandling(vehicle, "suspensionDamping", tonumber(v.suspensionDamping))
		setVehicleHandling(vehicle, "suspensionHighSpeedDamping", tonumber(v.suspensionHighSpeedDamping))
		setVehicleHandling(vehicle, "suspensionUpperLimit", tonumber(v.suspensionUpperLimit))
		setVehicleHandling(vehicle, "suspensionLowerLimit", tonumber(v.suspensionLowerLimit))
		setVehicleHandling(vehicle, "suspensionFrontRearBias", tonumber(v.suspensionFrontRearBias))
		setVehicleHandling(vehicle, "suspensionAntiDiveMultiplier", tonumber(v.suspensionAntiDiveMultiplier))
		setVehicleHandling(vehicle, "seatOffsetDistance", tonumber(v.seatOffsetDistance))
		setVehicleHandling(vehicle, "collisionDamageMultiplier", tonumber(v.collisionDamageMultiplier))
		setVehicleHandling(vehicle, "monetary", tonumber(v.monetary))
		setVehicleHandling(vehicle, "modelFlags", tonumber(v.modelFlags))
		setVehicleHandling(vehicle, "handlingFlags", tonumber(v.handlingFlags))
		setVehicleHandling(vehicle, "headLight", tonumber(v.headLight))
		setVehicleHandling(vehicle, "tailLight", tonumber(v.tailLight))
		setVehicleHandling(vehicle, "animGroup", tonumber(v.animGroup))
	end
	
	outputDebugString(#vehicles.." vehicles were loaded")
end

function saveVehicleDB()
	executeSQLDropTable("vehicles")
	--executeSQLCreateTable("vehicles", "model INTEGER, posX REAL, posY REAL, posZ REAL, rotX REAL, rotY REAL, rotZ REAL, color1 INTEGER, color2 INTEGER, paintjob INTEGER, upgrades TEXT")
	--executeSQLCreateTable("vehicles", "model, posX, posY, posZ, rotX, rotY, rotZ, color1, color2, paintjob, upgrades")
	executeSQLCreateTable("vehicles",
		"model, posX, posY, posZ, rotX, rotY, rotZ, r1,g1,b1, r2,g2,b2, paintjob, upgrades, "..
		"mass, turnMass, dragCoeff, centerOfMassX, centerOfMassY, centerOfMassZ, percentSubmerged, tractionMultiplier, tractionLoss, tractionBias, numberOfGears, "..
		"maxVelocity, engineAcceleration, engineInertia, driveType, engineType, brakeDeceleration, brakeBias, steeringLock, suspensionForceLevel, "..
		"suspensionDamping, suspensionHighSpeedDamping, suspensionUpperLimit, suspensionLowerLimit, suspensionFrontRearBias, suspensionAntiDiveMultiplier, "..
		"seatOffsetDistance, collisionDamageMultiplier, monetary, modelFlags, handlingFlags, headLight, tailLight, animGroup"
	)
	
	local vehicles = getElementsByType("vehicle")
	for i, vehicle in pairs(vehicles) do
		local px = getElementData(vehicle, "RSposX")
		local py = getElementData(vehicle, "RSposY")
		local pz = getElementData(vehicle, "RSposZ")
		local rx = getElementData(vehicle, "RSrotX")
		local ry = getElementData(vehicle, "RSrotY")
		local rz = getElementData(vehicle, "RSrotZ")
		
		if px and rx then
			local model = getElementModel(vehicle)
			--local color1, color2, color3, color4 = getVehicleColor(vehicle)
			local r1,g1,b1, r2,g2,b2, r3,g3,b3, r4,g4,b4 = getVehicleColor(vehicle, true)
			local paintjob = getVehiclePaintjob(vehicle)
			local upgrades = table.concat(getVehicleUpgrades(vehicle), ",")
			
			local handling = getVehicleHandling(vehicle)
			
			--executeSQLInsert("vehicles", "'"..model.."','"..px.."','"..py.."','"..pz.."','"..rx.."','"..ry.."','"..rz.."','"..color1.."','"..color2.."','"..paintjob.."','"..upgrades.."'")
			executeSQLInsert("vehicles",
				"'"..model.."',"..
				"'"..px.."',"..
				"'"..py.."',"..
				"'"..pz.."',"..
				"'"..rx.."',"..
				"'"..ry.."',"..
				"'"..rz.."',"..
				"'"..r1.."',"..
				"'"..g1.."',"..
				"'"..b1.."',"..
				"'"..r2.."',"..
				"'"..g2.."',"..
				"'"..b2.."',"..
				"'"..paintjob.."',"..
				"'"..upgrades.."',"..
				"'"..handling["mass"].."',"..
				"'"..handling["turnMass"].."',"..
				"'"..handling["dragCoeff"].."',"..
				"'"..handling["centerOfMass"][1].."',"..
				"'"..handling["centerOfMass"][2].."',"..
				"'"..handling["centerOfMass"][3].."',"..
				"'"..handling["percentSubmerged"].."',"..
				"'"..handling["tractionMultiplier"].."',"..
				"'"..handling["tractionLoss"].."',"..
				"'"..handling["tractionBias"].."',"..
				"'"..handling["numberOfGears"].."',"..
				"'"..handling["maxVelocity"].."',"..
				"'"..handling["engineAcceleration"].."',"..
				"'"..handling["engineInertia"].."',"..
				"'"..handling["driveType"].."',"..
				"'"..handling["engineType"].."',"..
				"'"..handling["brakeDeceleration"].."',"..
				"'"..handling["brakeBias"].."',"..
				--"'"..handling["ABS"].."',"..
				"'"..handling["steeringLock"].."',"..
				"'"..handling["suspensionForceLevel"].."',"..
				"'"..handling["suspensionDamping"].."',"..
				"'"..handling["suspensionHighSpeedDamping"].."',"..
				"'"..handling["suspensionUpperLimit"].."',"..
				"'"..handling["suspensionLowerLimit"].."',"..
				"'"..handling["suspensionFrontRearBias"].."',"..
				"'"..handling["suspensionAntiDiveMultiplier"].."',"..
				"'"..handling["seatOffsetDistance"].."',"..
				"'"..handling["collisionDamageMultiplier"].."',"..
				"'"..handling["monetary"].."',"..
				"'"..handling["modelFlags"].."',"..
				"'"..handling["handlingFlags"].."',"..
				"'"..handling["headLight"].."',"..
				"'"..handling["tailLight"].."',"..
				"'"..handling["animGroup"].."'"
			)
		end
	end

	outputDebugString(#vehicles.." vehicles were saved")
end

function park(playerSource, commandName)
	local vehicle = getPedOccupiedVehicle(playerSource)
	
	if vehicle then
		local publicAccess = isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("PublicAccess"))
		if publicAccess and getVehicleController(vehicle) == playerSource then
			local x,y,z = getElementPosition(vehicle)
			local rx,ry,rz = getVehicleRotation(vehicle)
			setVehicleRespawnPosition(vehicle, x,y,z, rx,ry,rz)
			setVehicleRespawnDelay(vehicle, respawnTime)
			setVehicleIdleRespawnDelay(vehicle, idleTime)
			toggleVehicleRespawn(vehicle, true)
			setElementData(vehicle, "RSposX", x)
			setElementData(vehicle, "RSposY", y)
			setElementData(vehicle, "RSposZ", z)
			setElementData(vehicle, "RSrotX", rx)
			setElementData(vehicle, "RSrotY", ry)
			setElementData(vehicle, "RSrotZ", rz)
			
			outputChatBox(getVehicleName(vehicle).." parked.", playerSource, 0,255,0)
		end
	end
end
addCommandHandler("park", park, false)

function impound(playerSource, commandName)
	local vehicle = getPedOccupiedVehicle(playerSource)
	
	if vehicle then
		local publicAccess = isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("PublicAccess"))
		if publicAccess and getVehicleController(vehicle) == playerSource then
			outputChatBox(getVehicleName(vehicle).." impounded.", playerSource, 255,128,0)
			destroyElement(vehicle)
		end
	end
end
addCommandHandler("impound", impound, false)
