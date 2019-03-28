local currentNodeFile = 0
local nodeFiles = {}
local drivers = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		--[[
		outputChatBox("Parsing node data...", 0,255,128)
		local node = "files\\NODES14.DAT"
		nodeFiles[node] = readNodeFile(node)
		currentNodeFile = node
		
		setTimer(
			function ()
				local node = "files\\NODES"..currentNodeFile..".DAT"
				nodeFiles[node] = readNodeFile(node)
				currentNodeFile = currentNodeFile+1
				if node == "files\\NODES63.DAT" then
					outputChatBox("Done...", 0,255,128)
				end
			end,
		50, 64)
		]]
	end
)
--[[
addEvent("driverCreated", true)
addEventHandler("driverCreated", root,
	function (nodeFileID, targetNodeID)
		local driver = {}
		driver.vehicle = source
		driver.controller = getElementData(source, "controller")
		driver.turn = vec3.new({ getVehicleTurnVelocity(driver.vehicle) })
		driver.vel = vec3.new({ getElementVelocity(driver.vehicle) })
		driver.pos = vec3.new({ getElementPosition(source) })
		driver.speedLimit = 10
		driver.speed = 0
		
		driver.currentNodeFile = nodeFileID
		driver.targetNodeID = targetNodeID
		
		table.insert(drivers, driver)
	end
)
]]
addEvent("driverCreated", true)
addEventHandler("driverCreated", root,
	function ()
		local driver = {}
		driver.ped = source
		driver.vehicle = getPedOccupiedVehicle(source)
		driver.controller = getElementData(source, "controller")
		driver.speedLimit = 10
		driver.speed = 0.0
		driver.turn = vec3.new({ 0,0,0 })
		driver.vel = vec3.new({ 0,0,0 })
		driver.height = getElementDistanceFromCentreOfMassToBaseOfModel(driver.vehicle)*0.5
		table.insert(drivers, driver)
	end
)

function findHiddenNode(nodeFile)
	local cx,cy,cz, tx,ty,tz = getCameraMatrix()
	local closestNode = nil
	local closestDistance = 999
	
	for i, node in pairs(nodeFile.vehicleNodes) do
		local distance = getDistanceBetweenPoints3D(node.position.x,node.position.y,node.position.z, cx,cy,cz)
		local visible = isLineOfSightClear(cx,cy,cz, node.position.x,node.position.y,node.position.z, true,false,false,true,true,false,false, localPlayer)
		if distance < closestDistance and not visible then
			closestNode = node
		end
	end
	
	return closestNode
end

function chooseRandomLink(nodeFile, node)
	local r = math.floor(math.random()*node.flags.linkCount)
	outputChatBox(type( nodeFile.links[node.linkID].nodeID ))
	return nodeFile.vehicleNodes[nodeFile.links[node.linkID+1]]
end

function changeElementData(element, dataName, value)
	if getElementData(element, dataName) ~= value then
		setElementData(element, dataName, value)
	end
end

addEventHandler("onClientPreRender", root,
	function ()
		for i, driver in ipairs(drivers) do
			update(driver)															--all clients
			
			if getElementData(driver.vehicle, "controller") == localPlayer then		--controller/syncer only
				--update(driver)
				if not isElementSyncer(driver.vehicle) then
					changeElementData(driver.vehicle, "controller", false)			--reassign
				end
			end
		end
	end
)

function update(driver)
	if driver.vehicle then
		driver.turn = vec3.new({ getVehicleTurnVelocity(driver.vehicle) })
		driver.vel = vec3.new({ getElementVelocity(driver.vehicle) })
		driver.pos = vec3.new({ getElementPosition(driver.vehicle) })
		local matrix = getElementMatrix(driver.vehicle)
		local front = vec3.matMul(getPointOnCircle(1, 0), matrix)
		local fwd = (front-driver.pos)*driver.speed
		local steer = vec3.new({ 0,0,0 })
		local fcol = { processLineOfSight(driver.pos[1],driver.pos[2],driver.pos[3],  front[1],front[2],front[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		
		if isVehicleOnGround(driver.vehicle) then
			if getElementSpeed(driver.vehicle) < driver.speedLimit then
				driver.speed = driver.speed + 0.001
			end
			
			turn = turn + steer
			local rot = findRotation(driver.pos[1], driver.pos[2], 
			
			setElementVelocity(driver.vehicle, fwd[1],fwd[2],fwd[3])
			--setVehicleTurnVelocity(driver.vehicle, turn[1],turn[2],turn[3])
		end
		
	end
end
--[[
function followPath(npc)
	if npc.pathNode <= #npc.path then
		setPedCameraRotation(npc.ped, -findRotation(npc.posX,npc.posY, npc.path[npc.pathNode].x,npc.path[npc.pathNode].y))
		changeElementData(npc.ped, "forwards", true)
		if getDistanceBetweenPoints3D(npc.posX,npc.posY,npc.posZ, npc.path[npc.pathNode].x,npc.path[npc.pathNode].y,npc.path[npc.pathNode].z) < 1 then
			changeElementData(npc.ped, "pathNode", npc.pathNode+1)
		end
	else
		changeElementData(npc.ped, "forwards", false)
	end
end
]]
function getElementSpeed(element)
	local vx,vy,vz = getElementVelocity(element)
	return (vx^2 + vy^2 + vz^2) ^ 0.5 * 100
end

function setElementSpeed(element, speed)
	local currentSpeed = getElementSpeed(element)
	if currentSpeed then
		local diff = speed/currentSpeed
		local vx,vy,vz = getElementVelocity(element)
		setElementVelocity(element, x*diff, y*diff, z*diff)
		return true
	end
	
	return false
end

function getPointOnCircle(size, angle)
	local a = math.rad(90 - angle)
	local x = math.cos(a) * size
	local y = math.sin(a) * size
	return vec3.new({ x,y,0 })
end

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end