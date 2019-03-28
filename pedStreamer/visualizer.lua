local currentNodeFile = 0
local nodeFiles = {}
local objects = {}
local markers = {}
local blips = {}
local lines = {}
local totalTime

--local vehicle,ped

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		totalTime = getTickCount()
		outputChatBox("Parsing node data. Please wait...", 0,255,128)
		--[[
		local node = "files\\NODES14.DAT"
		nodeFiles[node] = readNodeFile(node)
		--addEventHandler("onClientRender", root, render)
		
		local r = math.floor(math.random()*nodeFiles[node].numberOfVehicleNodes)
		local rand = nodeFiles[node].vehicleNodes[r]
		local linkID = nodeFiles[node].vehicleNodes[r].linkID
		local linkNodeID = nodeFiles[node].links[linkID+1+math.floor(math.random()*(nodeFiles[node].vehicleNodes[r].flags.linkCount))].nodeID
		local dest = nodeFiles[node].vehicleNodes[linkNodeID]
		outputChatBox(r.." "..linkNodeID)
		local rot = findRotation(rand.position.x,rand.position.y, dest.position.x,dest.position.y)
		vehicle = createVehicle(596, rand.position.x,rand.position.y,rand.position.z+1.5, 0,0,rot, "SMRTDRVR")
		createBlipAttachedTo(vehicle, 0, 2, 0,0,255,255)
		
		setElementPosition(localPlayer, rand.position.x,rand.position.y,rand.position.z+3)
		]]
		
		setTimer(
			function ()
				local node = "files\\NODES"..currentNodeFile..".DAT"
				nodeFiles[node] = readNodeFile(node)
				currentNodeFile = currentNodeFile+1
				outputChatBox("Loaded "..node, 0,255,128)
				if node == "files\\NODES63.DAT" then
					outputChatBox("Finished in "..getTickCount()-totalTime.." ms", 0,255,128)
					addEventHandler("onClientRender", root, render)
				end
			end,
		50, 64)
		
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		outputDebugString("Destroying visualization.")
		
		for i, blip in pairs(blips) do
			exports["text3D"]:destroyText3D(blip.id)
		end
	end
)

function render()
	local x,y,z = getElementPosition(localPlayer)
	x = (x + 3000) / 750
	y = (y + 3000) / 750
	
	local num = (math.floor(x) + (math.floor(y) * 8))
	local node = "files\\NODES"..tostring(num)..".DAT"
	dxDrawText(tostring(node), 600,250)
	
	if currentNodeFile ~= node then
		currentNodeFile = node
		
		for i, object in pairs(objects) do
			destroyElement(object)
		end
		objects = {}
		
		for i, marker in pairs(markers) do
			destroyElement(marker)
		end
		markers = {}
		
		for i, blip in pairs(blips) do
			exports["text3D"]:destroyText3D(blip.id)
		end
		blips = {}
		
		createPathNodeMarkers(nodeFiles[currentNodeFile].vehicleNodes, 0,255,0,32, false)
		createPathNodeMarkers(nodeFiles[currentNodeFile].pedNodes, 192,192,0,32, true)
		createNaviNodeMarkers(nodeFiles[currentNodeFile].naviNodes, 0,128,255,32)
		outputChatBox("Visualizing: "..node, 0,255,128)
	end
	
	for i,line in ipairs(lines) do
		dxDrawLine3D2(line[2],line[3],line[4], line[5],line[6],line[7], line[8],line[9],line[10],line[11], 3)
	end
end

function drawLinks(hitPlayer, matchingDimension)
	if hitPlayer ~= localPlayer then return end
	local data = getElementData(source, "nodeID")
	local nodeType = gettok(data, 1, ":")
	local nodeID = tonumber(gettok(data, 2, ":"))
	
	for i,line in ipairs(lines) do
		lines[i] = nil
	end
	if nodeType == "vehicleNode" then
		local x1 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.x
		local y1 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.y
		local z1 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.z
		local linkID = nodeFiles[currentNodeFile].vehicleNodes[nodeID].linkID
		for i=1, nodeFiles[currentNodeFile].vehicleNodes[nodeID].flags.linkCount do
			local linkNodeID = nodeFiles[currentNodeFile].links[linkID+i].nodeID
			local x2 = nodeFiles[currentNodeFile].vehicleNodes[linkNodeID].position.x
			local y2 = nodeFiles[currentNodeFile].vehicleNodes[linkNodeID].position.y
			local z2 = nodeFiles[currentNodeFile].vehicleNodes[linkNodeID].position.z
			table.insert(lines, { nodeID, x1,y1,z1, x2,y2,z2, 0,255,0,192 })
			--outputDebugString("link: "..nodeID.."->"..linkNodeID)
		end
	elseif nodeType == "pedNode" then
		local x1 = nodeFiles[currentNodeFile].pedNodes[nodeID].position.x
		local y1 = nodeFiles[currentNodeFile].pedNodes[nodeID].position.y
		local z1 = nodeFiles[currentNodeFile].pedNodes[nodeID].position.z
		local linkID = nodeFiles[currentNodeFile].pedNodes[nodeID].linkID
		for i=1, nodeFiles[currentNodeFile].pedNodes[nodeID].flags.linkCount do
			local linkNodeID = nodeFiles[currentNodeFile].links[linkID+i].nodeID
			local x2 = nodeFiles[currentNodeFile].pedNodes[linkNodeID].position.x
			local y2 = nodeFiles[currentNodeFile].pedNodes[linkNodeID].position.y
			local z2 = nodeFiles[currentNodeFile].pedNodes[linkNodeID].position.z
			table.insert(lines, { nodeID, x1,y1,z1, x2,y2,z2, 192,192,0,192 })
			--outputDebugString("link: "..nodeID.."->"..linkNodeID)
		end
	elseif nodeType == "naviNode" then
		local x1 = nodeFiles[currentNodeFile].naviNodes[nodeID].position.x
		local y1 = nodeFiles[currentNodeFile].naviNodes[nodeID].position.y
		local z1 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.z
		
		local x2 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.x
		local y2 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.y
		local z2 = nodeFiles[currentNodeFile].vehicleNodes[nodeID].position.z
		table.insert(lines, { nodeID, x1,y1,z1, x2,y2,z2, 0,128,255,192 })
	end
end

function createNaviNodeMarkers(nodes, r,g,b,a)
	for i,node in pairs(nodes) do
		local text = "naviNode: "..node.nodeID.."\n"
		text = text.."pathWidth: "..node.flags.pathWidth.."\n"
		text = text.."leftLanes: "..node.flags.numberOfLeftLanes.."\n"
		text = text.."rightLanes: "..node.flags.numberOfRightLanes.."\n"
		text = text.."lightDirection: "..node.flags.trafficLightDirection.."\n"
		text = text.."lightBehavior: "..node.flags.trafficLightBehavior.."\n"
		
		local z = nodeFiles[currentNodeFile].vehicleNodes[node.nodeID].position.z
		table.insert(blips, exports["text3D"]:createText3D("node"..i, text, "default-bold", 8, r,g,b, node.position.x,node.position.y,z+1, getElementInterior(localPlayer), getElementDimension(localPlayer), false, false, false))
		local marker = createMarker(node.position.x, node.position.y, z, "cylinder", node.flags.pathWidth, r,g,b,a)
		setElementData(marker, "nodeID", "naviNode:"..node.nodeID, false)
		addEventHandler("onClientMarkerHit", marker, drawLinks)
		table.insert(markers, marker)
		
		local pathWidth = math.max(nodeFiles[currentNodeFile].vehicleNodes[node.nodeID].pathWidth, 1)*2
		local rot = findRotation(node.position.x, node.position.y, node.position.x+node.direction.x, node.position.y+node.direction.y)-90
		
		if node.flags.numberOfLeftLanes == 1 and node.flags.numberOfRightLanes == 0 then
			local object = createObject(1318, node.position.x, node.position.y, z+0.25)
			setElementRotation(object, 0, 90, rot)
			table.insert(objects, object)
		elseif node.flags.numberOfLeftLanes > 0 then
			local x,y = getPointFromDistanceRotation(node.position.x, node.position.y, pathWidth, -rot)
			local object = createObject(1318, x,y, z+0.25)
			setElementRotation(object, 0, 90, rot)
			table.insert(objects, object)
			if node.flags.numberOfLeftLanes > 1 then
				x,y = getPointFromDistanceRotation(node.position.x, node.position.y, pathWidth, -rot+180)
				object = createObject(1318, x,y, z+0.25)
				setElementRotation(object, 0, 90, rot)
				table.insert(objects, object)
			end
		end
		
		if node.flags.numberOfRightLanes == 1 and node.flags.numberOfLeftLanes == 0 then
			local object = createObject(1318, node.position.x, node.position.y, z+0.25)
			setElementRotation(object, 0, 90, rot-180)
			table.insert(objects, object)
		elseif node.flags.numberOfRightLanes > 0 then
			local x,y = getPointFromDistanceRotation(node.position.x, node.position.y, pathWidth, -rot+180)
			local object = createObject(1318, x,y, z+0.25)
			setElementRotation(object, 0, 90, rot-180)
			table.insert(objects, object)
			if node.flags.numberOfRightLanes > 1 then
				x,y = getPointFromDistanceRotation(node.position.x, node.position.y, pathWidth, -rot)
				object = createObject(1318, x,y, z+0.25)
				setElementRotation(object, 0, 90, rot-180)
				table.insert(objects, object)
			end
		end
	end
end

function createPathNodeMarkers(nodes, r,g,b,a, peds)
	for i,node in pairs(nodes) do
		local text = ""
		if not peds then
			if node.nodeType == 1 then
				text = text.."Cars\n"
			elseif node.nodeType == 2 then
				text = text.."Boats\n"
			else
				text = text.."Mission: "..node.nodeType.."\n"
			end
		else
			text = text.."Peds: "..node.nodeType.."\n"
		end
		
		text = text.."nodeID: "..node.nodeID.."\n"
		text = text.."pathWidth: "..node.pathWidth.."\n"
		text = text.."linkCount "..node.flags.linkCount.."\n"
		text = text.."spawnProbability: "..node.flags.spawnProbability.."\n"
		
		if node.flags.trafficLevel then
			if node.flags.trafficLevel == 0 then
				text = text.."trafficLevel: full\n"
			elseif node.flags.trafficLevel == 1 then
				text = text.."trafficLevel: high\n"
			elseif node.flags.trafficLevel == 2 then
				text = text.."trafficLevel: medium\n"
			elseif node.flags.trafficLevel == 1 then
				text = text.."trafficLevel: low\n"
			end
		end
		
		--if node.flags.boats then
			--text = text.."boats".."\n"
		--end
		if node.flags.emergencyVehiclesOnly then
			text = text.."emergencyVehiclesOnly".."\n"
		end
		if node.flags.isNotHighway then
			text = text.."isNotHighway".."\n"
		end
		if node.flags.isHighway then
			text = text.."isHighway".."\n"
		end
		if node.flags.parking then
			text = text.."parking".."\n"
		end
		
		table.insert(blips, exports["text3D"]:createText3D("node"..i, text, "default-bold", 8, r,g,b, node.position.x,node.position.y,node.position.z+1, getElementInterior(localPlayer), getElementDimension(localPlayer), false, false, false))
		local marker = createMarker(node.position.x, node.position.y, node.position.z, "cylinder", node.pathWidth, r,g,b,a)
		addEventHandler("onClientMarkerHit", marker, drawLinks)
		if not peds then
			setElementData(marker, "nodeID", "vehicleNode:"..node.nodeID, false)
		else
			setElementData(marker, "nodeID", "pedNode:"..node.nodeID, false)
		end
		table.insert(markers, marker)
	end
end

function findRotation(x1,y1, x2,y2)
	local t = -math.deg(math.atan2(x2-x1, y2-y1))
	if t < 0 then
		t = t+360
	end
	return t
end

function getPointFromDistanceRotation(x,y, dist, angle)
	local a = math.rad(90-angle)
	local dx = math.cos(a)*dist
	local dy = math.sin(a)*dist
	return x+dx, y+dy
end

function dxDrawLine3D2(x1,y1,z1, x2,y2,z2, r,g,b,a, width)
	x1,y1 = getScreenFromWorldPosition(x1,y1,z1, 6000)
	x2,y2 = getScreenFromWorldPosition(x2,y2,z2, 6000)
	if x1 and y1 and x2 and y2 then
		dxDrawLine(x1,y1, x2,y2, tocolor(r,g,b,a), width)
		dxDrawRectangle(x1-3,y1-3, 9,9, tocolor(r,g,b,a/2))
		dxDrawRectangle(x2-3,y2-3, 9,9, tocolor(r,g,b,a/2))
	end
end
