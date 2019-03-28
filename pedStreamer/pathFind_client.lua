local maxPathNodes = 64
local pathSegmentLength = 2
local angleStep = 15 --67.5

function findNode(x1,y1,z1, x2,y2,z2)
	local x,y,z = x2,y2,z2
	local closest = 9999
	
	if not isLineOfSightClear(x1,y1,z1, x2,y2,z2, true,true,true,true,true,true,false) then
		local rotation = findRotation(x1,y1, x2,y2)
		local angle = rotation+angleStep
		while angle < rotation+360 do
			--local nx,ny = getPointFromDistanceRotation(x1,y1, getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)/8, angle)
			local nx,ny = getPointFromDistanceRotation(x1,y1, pathSegmentLength, angle)
			if isLineOfSightClear(x1,y1,z1, nx,ny,z1, true,true,true,true,true,true,false) then
				local dist = getDistanceBetweenPoints3D(nx,ny,z1, x2,y2,z2)
				if dist < closest then
					closest = dist
					x,y,z = nx,ny,z1																--closest clear direction result
				end
			end
			angle = angle+angleStep
		end
	end
	
	return x,y,getGroundPosition(x,y,z)+0.5
end

function buildPath(x1,y1,z1, x2,y2,z2)
	local path = {}
	path[1] = {}
	path[1].x = x1
	path[1].y = y1
	path[1].z = z1
	
	local nx,ny,nz = findNode(x1,y1,z1, x2,y2,z2)
	for i=2, maxPathNodes do
		path[i] = {}
		path[i].x = nx
		path[i].y = ny
		path[i].z = nz
		if getDistanceBetweenPoints3D(nx,ny,nz, x2,y2,z2) > 1 then
			nx,ny,nz = findNode(nx,ny,nz, x2,y2,z2)
		else
			break
		end
	end
	
	return path
end

function simplifyPath(path)
	for i, p in ipairs(path) do
		if i+2 < #path then
			local x1,y1,z1 = path[i].x,path[i].y,path[i].z
			local x2,y2,z2 = path[i+2].x,path[i+2].y,path[i+2].z
			if isLineOfSightClear(x1,y1,z1, x2,y2,z2, true,true,true,true,true,true,false) then
				table.remove(path, i+1)
				path = simplifyPath(path)
			end
		end
	end
	
	return path
end

function drawPath(path, r,g,b,a)
	for i=1, #path-1 do
		x1,y1,z1 = path[i].x,path[i].y,path[i].z
		x2,y2,z2 = path[i+1].x, path[i+1].y, path[i+1].z
		dxDrawLine3D2(x1,y1,z1, x2,y2,z2, r,g,b,a, 1)
	end
end

function dxDrawLine3D2(x1,y1,z1, x2,y2,z2, r,g,b,a, width)
	x1,y1 = getScreenFromWorldPosition(x1,y1,z1, 1)
	x2,y2 = getScreenFromWorldPosition(x2,y2,z2, 1)
	if x1 and y1 and x2 and y2 then
		dxDrawLine(x1,y1, x2,y2, tocolor(r,g,b,a), width)
		dxDrawRectangle(x1-2,y1-2, 4,4, tocolor(r,g,b,a/2))
		dxDrawRectangle(x2-2,y2-2, 4,4, tocolor(r,g,b,a/2))
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
