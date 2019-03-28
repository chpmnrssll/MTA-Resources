local maxPathNodes = 64
local pathSegmentLength = 8
local angleStep = 60

function findNode(v1,v2, element)
	local node = v2
	local closest = 9999
	local height = getElementDistanceFromCentreOfMassToBaseOfModel(element)
	--local mat1 = { processLineOfSight(v1[1],v1[2], getGroundPosition(v1[1],v1[2],v1[3])-2, true,true,true,true,true,true,true,true, element, true) }
	
	if not isLineOfSightClear(v1[1],v1[2],v1[3], v2[1],v2[2],v2[3], true,true,true,true,true,true,true, element) then
		local rotation = findRotation(v1[1],v1[2], v2[1],v2[2])
		local angle = rotation+angleStep
		while angle < rotation+360 do
			--local temp = getPointFromDistanceRotation(v1[1],v1[2],getGroundPosition(v1[1],v1[2],v1[3])+height, pathSegmentLength, angle)
			local temp = getPointFromDistanceRotation({ v1[1],v1[2],getGroundPosition(v1[1],v1[2],v1[3])+height }, pathSegmentLength, angle)
			if isLineOfSightClear(v1[1],v1[2],v1[3], temp[1],temp[2],temp[3], true,true,true,true,true,true,true, element) then
				dxDrawLine3D2(v1, temp, 255,64,0,96, 1)
				local dist = getDistanceBetweenPoints3D(temp[1],temp[2],temp[3], v2[1],v2[2],v2[3])
				local mat2 = { processLineOfSight(temp[1],temp[2],temp[3], temp[1],temp[2],getGroundPosition(temp[1],temp[2],temp[3])-2, true,true,true,true,true,true,true,true, element, true) }
				if dist < closest and (mat2[9] == nil or mat2[9] == 0 or mat2[9] == 1) then		--closest clear direction result
					closest = dist
					node = temp
					--local sx,sy = getScreenFromWorldPosition(temp[1],temp[2],temp[3], 1000)
					--dxDrawText(tostring(mat2[9]), sx,sy)
				end
			else
				dxDrawLine3D2(v1, temp, 64,255,0,96, 1)
			end
			angle = angle+angleStep
		end
	end
	
	return node
end

function buildPath(v1,v2, element)
	local path = {}
	path[1] = v1
	
	local node = findNode(v1,v2,element)
	for i=2, maxPathNodes do
		path[i] = node
		if getDistanceBetweenPoints3D(node[1],node[2],node[3], v2[1],v2[2],v2[3]) > 1 then
			node = findNode(node,v2,element)
		else
			break
		end
	end
	
	return path
end

function simplifyPath(path)
	for i, p in ipairs(path) do
		if i+2 < #path then
			if isLineOfSightClear(path[i][1],path[i][2],path[i][3], path[i+1][1],path[i+1][2],path[i+1][3], true,true,true,true,true,true,false) then
				table.remove(path, i+1)
				path = simplifyPath(path)
			end
		end
	end
	
	return path
end

function drawPath(path, r,g,b,a)
	for i=1, #path-1 do
		dxDrawLine3D2(path[i], path[i+1], r,g,b,a, 2)
	end
end

function dxDrawLine3D2(v1, v2, r,g,b,a, width)
	local sx1,sy1 = getScreenFromWorldPosition(v1[1],v1[2],v1[3], 1000)
	local sx2,sy2 = getScreenFromWorldPosition(v2[1],v2[2],v2[3], 1000)
	if sx1 and sx2 and sy1 and sy2 then
		local sx3,sy3 = getScreenFromWorldPosition(v1[1],v1[2],getGroundPosition(v1[1],v1[2],1000), 1000)
		local sx4,sy4 = getScreenFromWorldPosition(v2[1],v2[2],getGroundPosition(v2[1],v2[2],1000), 1000)
		if sx3 and sx4 and sy3 and sy4 then
			local aa = a/2
			dxDrawLine(sx3,sy3, sx4,sy4, tocolor(0,0,0,aa), width)
			--dxDrawRectangle(sx3-2,sy3-2, 6,6, tocolor(0,0,0,aa/1.5))
			--dxDrawRectangle(sx4-2,sy4-2, 6,6, tocolor(0,0,0,aa/1.5))
		end
		dxDrawLine(sx1,sy1, sx2,sy2, tocolor(r,g,b,a), width)
		--dxDrawRectangle(sx1-2,sy1-2, 6,6, tocolor(r,g,b,a/1.5))
		--dxDrawRectangle(sx2-2,sy2-2, 6,6, tocolor(r,g,b,a/1.5))
	end
end

function findRotation(x1,y1, x2,y2)
	local t = -math.deg(math.atan2(x2-x1, y2-y1))
	if t < 0 then
		t = t+360
	end
	return t
end

--function getPointFromDistanceRotation(x,y,z, dist, angle)
function getPointFromDistanceRotation(pos, dist, angle)
	local a = math.rad(90-angle)
	local dx = math.cos(a)*dist
	local dy = math.sin(a)*dist
	return vec3.new({ pos[1]+dx, pos[2]+dy, pos[3] })
end

function getPointOnCircle(size, angle, z)
	local a = math.rad(90 - angle)
	local x = math.cos(a) * size
	local y = math.sin(a) * size
	return vec3.new({ x,y,z })
end

function findCenterOfMaterial(pos, mat, distance, depth)
	if depth <= 0 then return false end
	depth = depth - 1
	
	local res = checkMaterialOnGround(pos)		--check material at this position
	if res ~= mat then return false end
	
	--if match, check in 30deg increments, 1unit away for matches
	local matches = {}
	local angle = 0
	while angle < 360 do
		local newPos = getPointFromDistanceRotation(pos, distance, angle)
		local newRes = checkMaterialOnGround(newPos)
		if newRes == mat then
			
			dxDrawLine3D2({ pos[1],pos[2],pos[3] }, { newPos[1],newPos[2],newPos[3] }, 0,255,0,64, 2)
			local sx,sy = getScreenFromWorldPosition(newPos[1],newPos[2],newPos[3], 1000)
			if sx and sy then
				dxDrawText(tostring(newRes), sx,sy)
			end
			
			--store position of match
			table.insert(matches, newPos)
			
			
			newPos = getPointFromDistanceRotation(newPos, distance*2, angle)
			findCenterOfMaterial(newPos, mat, distance*2, depth)
		else
			--dxDrawLine3D2({ pos[1],pos[2],pos[3] }, { newPos[1],newPos[2],newPos[3] }, 255,0,0,64, 2)
		end
		angle = angle + angleStep
	end
end

function findEdgeOfMaterial(pos, dir, material, depth)
	if depth <= 0 then return false end
	depth = depth - 1
	
	local res = checkMaterialOnGround(pos)		--check material at this position
	if res ~= material then return false end
	
	local newPos = pos + getPointOnCircle(6, -dir[3], 0)
	newPos[3] = newPos[3] + 0.5
	--newPos[3] = getGroundPosition(newPos[1],newPos[2],1000) + 1
	local newRes = checkMaterialOnGround(newPos)
	
	dxDrawLine3D2(pos, newPos, 255,255,255,64, 2)
	local sx,sy = getScreenFromWorldPosition(newPos[1],newPos[2],newPos[3], 1000)
	if sx and sy then
		dxDrawText(tostring(newRes), sx,sy)
	end

	if newRes == material then
		newPos = findEdgeOfMaterial(newPos, dir, material, depth)
	end
	
	return newPos
end

function checkMaterialOnGround(pos)
	local results = { processLineOfSight(pos[1],pos[2],pos[3], pos[1],pos[2],-1000, true,false,false,true,true,false,false,false, nil, true) }
	
	return not results[1] and results[9] or results[9]
end
