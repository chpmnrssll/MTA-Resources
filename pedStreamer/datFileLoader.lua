
function readNodeFile(fileName)
	local startTime = getTickCount()
	local file = fileOpen(fileName, true)
	if not file then return false end
	
	local nodeFile = {}
	-- header
	nodeFile.numberOfNodes = bytesToInt(fileRead(file, 4), false)				-- 4b - UINT32 - number of nodes (section 1)
	nodeFile.numberOfVehicleNodes = bytesToInt(fileRead(file, 4), false)		-- 4b - UINT32 - number of vehicle nodes (section 1a)
	nodeFile.numberOfPedNodes = bytesToInt(fileRead(file, 4), false)			-- 4b - UINT32 - number of ped nodes (section 1b)
	nodeFile.numberOfNaviNodes = bytesToInt(fileRead(file, 4), false)			-- 4b - UINT32 - number of navi nodes (section 2)
	nodeFile.numberOfLinks = bytesToInt(fileRead(file, 4), false)				-- 4b - UINT32 - number of links (section 3/5/6)
	
	nodeFile.vehicleNodes = readPathNodes(file, nodeFile.numberOfVehicleNodes)
	nodeFile.pedNodes = readPathNodes(file, nodeFile.numberOfPedNodes)
	nodeFile.naviNodes = readNaviNodes(file, nodeFile.numberOfNaviNodes)
	nodeFile.links = readLinks(file, nodeFile.numberOfLinks)
	
	-- filler (repeating data pattern 0xFF,0xFF,0x00,0x00)
	fileRead(file, 768)
	
	nodeFile.naviLinks = readNaviLinks(file, nodeFile.numberOfLinks)
	nodeFile.linkLengths = readLinkLengths(file, nodeFile.numberOfLinks)
	
	fileClose(file)
	return nodeFile
end

function readPathNodes(file, numberOfNodes)
	local nodes = {}
	for i=1,numberOfNodes do
		local node = {}
		node.memAddress = bytesToInt(fileRead(file, 4), false)			-- 4b - UINT32   - Mem Address, unused
		node.alwaysZero = bytesToInt(fileRead(file, 4), false)			-- 4b - UINT32   - always zero, unused
		node.position = {}												-- 6b - INT16[3] - Position (XYZ)
		node.position.x = bytesToInt(fileRead(file, 2), true) / 8
		node.position.y = bytesToInt(fileRead(file, 2), true) / 8
		node.position.z = bytesToInt(fileRead(file, 2), false) / 8
		node.unknown = bytesToInt(fileRead(file, 2), true)				-- 2b - INT16    - unknown, always 0x7FFE, appears to have something to do with links
		node.linkID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16   - Link ID
		node.areaID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16   - Area ID (same as in filename)
		node.nodeID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16   - Node ID (increments by 1)
		node.pathWidth = bytesToChar(fileRead(file, 1), true) / 8		-- 1b - UINT8    - Path Width
		node.nodeType = bytesToChar(fileRead(file, 1), false)			-- 1b - UINT8    - Node Type
		local flags = bytesToInt(fileRead(file, 4), false)				-- 4b - UINT32   - Flags
		node.flags = {}
		node.flags.linkCount = bit_and(flags, to_dec('0x0000000F'))					-- Link Count defines the number of enties incrementing from the LinkID
		node.flags.trafficLevel = bit_and(flags, to_dec('0x00000030'))/16			-- 0=full 1=high 2=medium 3=low)
		node.flags.boats = bit_and(flags, to_dec('0x00000080')) > 0
		node.flags.emergencyVehiclesOnly = bit_and(flags, to_dec('0x00000100')) > 0
		node.flags.isNotHighway = bit_and(flags, to_dec('0x00001000')) > 0
		node.flags.isHighway = bit_and(flags, to_dec('0x00002000')) > 0				-- ignored for PED-Nodes and never 11 or 00 for Cars!
		node.flags.spawnProbability = bit_and(flags, to_dec('0x000F0000'))/65536	-- 0x00 to 0x0F
		node.flags.parking = bit_and(flags, to_dec('0x00200000')) > 0
		nodes[node.nodeID] = node
	end
	
	return nodes
end

function readNaviNodes(file, numberOfNodes)
	local nodes = {}
	for i=1,numberOfNodes do
		local node = {}
		node.position = {}												-- 4b - INT16[2] - Position (XY), see below
		node.position.x = bytesToInt(fileRead(file, 2), true) / 8
		node.position.y = bytesToInt(fileRead(file, 2), true) / 8
		node.areaID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16   - Area ID
		node.nodeID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16   - Node ID
		node.direction = {}												-- 2b - INT8[2]  - Direction (XY)
		node.direction.x = bytesToChar(fileRead(file, 1), true) / 100
		node.direction.y = bytesToChar(fileRead(file, 1), true) / 100
		local flags = bytesToInt(fileRead(file, 4), false)				-- 4b - UINT32   - Flags
		node.flags = {}
		node.flags.pathWidth = bit_and(flags, to_dec('0x000000FF'))					--  0- 7 - path node width, usually a copy of the linked node's path width (byte)
		node.flags.numberOfLeftLanes = bit_and(flags, to_dec('0x00000700'))/256		--  8-10 - number of left lanes
		node.flags.numberOfRightLanes = bit_and(flags, to_dec('0x00003800'))/2048		-- 11-13 - number of right lanes
		node.flags.trafficLightDirection = bit_and(flags, to_dec('0x00004000'))/16384	--    14 - traffic light direction behavior
		node.flags.trafficLightBehavior = bit_and(flags, to_dec('0x00030000'))/65536	-- 16,17 - traffic light behavior
		nodes[node.nodeID] = node
	end
	
	return nodes
end

function readLinks(file, numberOfLinks)
	local links = {}
	for i=1,numberOfLinks do
		local link = {}
		link.areaID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16 - Area ID
		link.nodeID = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16 - Node ID
		links[i] = link
	end
	
	return links
end

function readNaviLinks(file, numberOfLinks)
	local links = {}
	for i=1,numberOfLinks do
		local link = {}
		local data = bytesToInt(fileRead(file, 2), false)				-- 2b - UINT16 - lower 10 bit are the Navi Node ID, upper 6 bit the corresponding Area ID
		link.nodeID = bit_and(data, to_dec('0x000003FF'))
		link.areaID = bit_and(data, to_dec('0x0000FC00'))
		links[i] = link
	end
	
	return links
end

function readLinkLengths(file, numberOfLinks)
	local linkLengths = {}
	for i=1,numberOfLinks do
		linkLengths[i] = bytesToChar(fileRead(file, 1), false)			-- 1b - UINT8 - Length
	end
	
	return linkLengths
end

function bytesToInt(str, signed)
	local bits = { str:byte(1,-1) }		-- use length of string to determine 8,16,32,64 bits
	local len = #bits
	local num = 0
	
	for bit = 1, len do
		num = num + bits[bit] * 256^(bit-1)
	end
	
	if signed then
		if num > 32768 then
			num = num-65536
		end
	end
	
	return num
end

function bytesToChar(str, signed)
	local bits = { str:byte(1,-1) }		-- use length of string to determine 8,16,32,64 bits
	local len = #bits
	local num = 0
	
	for bit = 1, len do
		num = num + bits[bit] * 256^(bit-1)
	end
	
	if signed then
		if num > 128 then
			num = num-256
		end
	end
	
	return num
end
