local localPlayer = getLocalPlayer()
local pathStart = nil
local GO = false
local path

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		veh = getPedOccupiedVehicle(localPlayer)
	end
)

function path(player)
	pathStart = vec3.new({ getElementPosition(localPlayer) })
	if not GO then
		GO = true
	else
		GO = false
	end
end
addCommandHandler("path", path)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if pathStart then
			if GO then
				path = buildPath(pathStart, vec3.new({ getElementPosition(localPlayer) }), localPlayer)
				--simplifyPath(path)
			end
			drawPath(path, 0,255,0,192)
		end
		
		if veh then
			local x,y,z = getElementPosition(veh)
			local rx,ry,rz = getElementRotation(veh)
			
			--findCenterOfMaterial({ getElementPosition(localPlayer) }, 1, 1, 4)
			local left = findEdgeOfMaterial({ x,y,z }, { rx,ry,rz+2 }, 0, 16)
			local right = findEdgeOfMaterial({ x,y,z }, { rx,ry,rz-2 }, 0, 16)
			
			if not left or not right then
				left = findEdgeOfMaterial({ x,y,z }, { rx,ry,rz+2 }, 1, 16)
				right = findEdgeOfMaterial({ x,y,z }, { rx,ry,rz-2 }, 1, 16)
			end
			if left and right then
				dxDrawLine3D2(left, right, 255,255,255,255, 2)
				local avg = (left+right)/2
				local dx = left[1]-right[1]
				local dy = left[2]-right[2]
				local normal = avg + vec3.normalize(vec3.new({ -dy, dx, 0}))
				local dist = getDistanceBetweenPoints3D(x,y,z, avg[1],avg[2],avg[3])/2
				local rot = (findRotation(x,y, normal[1], normal[2])-rz)/dist
				
				local tx,ty,tz = getVehicleTurnVelocity(veh)
				rot = (tz+rot)/2
				setVehicleTurnVelocity(veh, tx,ty,rot*0.2)
				dxDrawLine3D2(avg, normal, 255,0,0,255, 2)
			end
			
		end
		--[[
		local matrix, pos, vel
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			matrix = getElementMatrix(vehicle)
			pos = vec3.new({ getElementPosition(vehicle) })
			vel = vec3.new({ getElementVelocity(vehicle) })
		else
			matrix = getElementMatrix(localPlayer)
			pos = vec3.new({ getElementPosition(localPlayer) })
			vel = vec3.new({ getElementVelocity(localPlayer) })
		end
		
		local speed = math.max(getSpeed(vel)/10, 1)
		--local front = vec3.matMul(getPointOnCircle(speed, 0, 0), matrix)
		--dxDrawLine3D2(pos[1],pos[2],pos[3], front[1],front[2],front[3], tocolor(0,255,0,255), speed)
		
		local left  = vec3.matMul(getPointOnCircle(2, -90, 0), matrix)
		local front = vec3.matMul(getPointOnCircle(2,   0, 0), matrix)
		local right = vec3.matMul(getPointOnCircle(2,  90, 0), matrix)
		local lmat = { processLineOfSight(left[1],left[2],left[3],  left[1], left[2],getGroundPosition( left[1], left[2], left[3])-2, true,true,true,true,true,false,false,false, localPlayer, true) }
		local fmat = { processLineOfSight(front[1],front[2],front[3], front[1],front[2],getGroundPosition(front[1],front[2],front[3])-2, true,true,true,true,true,false,false,false, localPlayer, true) }
		local rmat = { processLineOfSight(right[1],right[2],right[3], right[1],right[2],getGroundPosition(right[1],right[2],right[3])-2, true,true,true,true,true,false,false,false, localPlayer, true) }
		local cmat = { processLineOfSight(pos[1],pos[2],pos[3], pos[1],pos[2],getGroundPosition(pos[1],pos[2],pos[3])-2, true,true,true,true,true,false,false,false, localPlayer, true) }
		drawMat( left[1], left[2], left[3],  left[1], left[2],getGroundPosition( left[1], left[2], left[3]), lmat[9])
		drawMat(front[1],front[2],front[3], front[1],front[2],getGroundPosition(front[1],front[2],front[3]), fmat[9])
		drawMat(right[1],right[2],right[3], right[1],right[2],getGroundPosition(right[1],right[2],right[3]), rmat[9])
		drawMat(pos[1],pos[2],pos[3], pos[1],pos[2],getGroundPosition(pos[1],pos[2],pos[3]), cmat[9])
		]]
	end
)

function update(driver)
	if driver.vehicle then
		local matrix = getElementMatrix(driver.vehicle)
		local pos = vec3.new({ getElementPosition(driver.vehicle) })
		local rot = vec3.new({ getVehicleRotation(driver.vehicle) })
		local vel = vec3.new({ getElementVelocity(driver.vehicle) })
		local turn = vec3.new({ getVehicleTurnVelocity(driver.vehicle) })
		local steer = vec3.new({ 0,0,0 })
		local speed = getSpeed(vel)
		
		local front = vec3.matMul(getPointOnCircle(math.max(speed, 4)*0.8, 0, 0), matrix)
		local lf = vec3.matMul(getPointOnCircle(math.max(speed, 4), -7, 0), matrix)
		local rf = vec3.matMul(getPointOnCircle(math.max(speed, 4), 7, 0), matrix)
		local lr = vec3.matMul(getPointOnCircle(math.max(speed, 4)*0.5, -20, 0), matrix)
		local rr = vec3.matMul(getPointOnCircle(math.max(speed, 4)*0.5, 20, 0), matrix)
		
		front[3] = getGroundPosition(front[1],front[2],front[3])+2
		lf[3] = getGroundPosition(lf[1],lf[2],lf[3])+2
		rf[3] = getGroundPosition(rf[1],rf[2],rf[3])+2
		lr[3] = getGroundPosition(lr[1],lr[2],lr[3])+2
		rr[3] = getGroundPosition(rr[1],rr[2],rr[3])+2
		matrix[4][1] = 0
		matrix[4][2] = 0
		matrix[4][3] = 0
		local fwd = vec3.matMul(getPointOnCircle(1, 0, 0), matrix)
		local fcol = { processLineOfSight(pos[1],pos[2],pos[3],  front[1], front[2], front[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local lfcol = { processLineOfSight(pos[1],pos[2],pos[3],  lf[1], lf[2], lf[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local rfcol = { processLineOfSight(pos[1],pos[2],pos[3],  rf[1], rf[2], rf[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local lrcol = { processLineOfSight(pos[1],pos[2],pos[3],  lr[1], lr[2], lr[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local rrcol = { processLineOfSight(pos[1],pos[2],pos[3],  rr[1], rr[2], rr[3], true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local fmat = { processLineOfSight(front[1],front[2],front[3], front[1],front[2],getGroundPosition(front[1],front[2],front[3])-2, true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local lfmat = { processLineOfSight(lf[1], lf[2], lf[3], lf[1], lf[2],getGroundPosition(lf[1], lf[2], lf[3])-2, true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local rfmat = { processLineOfSight(rf[1], rf[2], rf[3], rf[1], rf[2],getGroundPosition(rf[1], rf[2], rf[3])-2, true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local lrmat = { processLineOfSight(lr[1], lr[2], lr[3], lr[1], lr[2],getGroundPosition(lr[1], lr[2], lr[3])-2, true,true,true,true,true,false,false,false, driver.vehicle, true) }
		local rrmat = { processLineOfSight(rr[1], rr[2], rr[3], rr[1], rr[2],getGroundPosition(rr[1], rr[2], rr[3])-2, true,true,true,true,true,false,false,false, driver.vehicle, true) }
		
		drawLOS(pos[1],pos[2],pos[3], front[1], front[2], front[3], fcol[1], fmat[9])
		drawLOS(pos[1],pos[2],pos[3], lf[1], lf[2], lf[3], lfcol[1], lfmat[9])
		drawLOS(pos[1],pos[2],pos[3], rf[1], rf[2], rf[3], rfcol[1], rfmat[9])
		drawLOS(pos[1],pos[2],pos[3], lr[1], lr[2], lr[3], lrcol[1], lrmat[9])
		drawLOS(pos[1],pos[2],pos[3], rr[1], rr[2], rr[3], rrcol[1], rrmat[9])
		drawMat(front[1],front[2],front[3], front[1],front[2],getGroundPosition(front[1],front[2],front[3]), fmat[9])
		drawMat(lf[1], lf[2], lf[3], lf[1], lf[2],getGroundPosition(lf[1], lf[2], lf[3]), lfmat[9])
		drawMat(rf[1], rf[2], rf[3], rf[1], rf[2],getGroundPosition(rf[1], rf[2], rf[3]), rfmat[9])
		drawMat(lr[1], lr[2], lr[3], lr[1], lr[2],getGroundPosition(lr[1], lr[2], lr[3]), lrmat[9])
		drawMat(rr[1], rr[2], rr[3], rr[1], rr[2],getGroundPosition(rr[1], rr[2], rr[3]), rrmat[9])
		
		if isVehicleOnGround(driver.vehicle) then
			local factor = (LIMIT+0.5)-driver.speed
			if fcol[1] or (fmat[9] ~= 0 and fmat[9] ~= 1 and fmat[9] ~= nil) then
				if fcol[1] then
					steer = steer + vec3.scale(vec3.cross({ fcol[6], fcol[7], fcol[8] }, fwd), -factor*0.05)
				end
				if (fmat[9] ~= 0 and fmat[9] ~= 1 and fmat[9] ~= nil) then
					steer = steer + vec3.scale(vec3.cross(vec3.normalize(front), fwd), -factor*0.05)
				end
				
				steer[1] = 0
				steer[2] = 0
				if driver.speed > -0.1 then
					driver.speed = driver.speed-0.05
				end
			else
				if driver.speed < LIMIT then
					driver.speed = driver.speed+0.05
				end
			end
			
			if lfcol[1] or (lfmat[9] ~= 0 and lfmat[9] ~= 1 and lfmat[9] ~= nil) then
				steer[3] = steer[3] - factor*0.01
			end
			if rfcol[1] or (rfmat[9] ~= 0 and rfmat[9] ~= 1 and rfmat[9] ~= nil) then
				steer[3] = steer[3] + factor*0.01
			end
			
			if lrcol[1] or (lrmat[9] ~= 0 and lrmat[9] ~= 1 and lrmat[9] ~= nil) then
				steer[3] = steer[3] - factor*0.015
			end
			if rrcol[1] or (rrmat[9] ~= 0 and rrmat[9] ~= 1 and rrmat[9] ~= nil) then
				steer[3] = steer[3] + factor*0.015
			end
			
			turn = turn + steer
			local sv = vec3.scale(fwd, driver.speed)
			sv[3] = sv[3]-0.005
			setVehicleTurnVelocity(driver.vehicle, turn[1],turn[2],turn[3])
			setElementVelocity(driver.vehicle, sv[1],sv[2],sv[3]-(0.005))
			--setElementData(driver.vehicle, "tvel", turn)
			--setElementData(driver.vehicle, "vel", sv)
		end
	end
end

function getSpeed(vel)
	return (vel[1]^2 + vel[2]^2 + vel[3]^2)^(0.5) * 100
end

function getPointOnCircle(size, angle, z)
	local a = math.rad(90 - angle)
	local x = math.cos(a) * size
	local y = math.sin(a) * size
	return vec3.new({ x,y,z })
end

function drawLOS(x1,y1,z1, x2,y2,z2, hit, mat)
	local color = tocolor(64,255,0,128)
	if hit or (mat ~= 0 and mat ~= 1) then color = tocolor(255,64,0,64) end
	dxDrawLine3D2(x1,y1,z1, x2,y2,z2, color, 2)
end

function drawMat(x1,y1,z1, x2,y2,z2, mat)
	local color = tocolor(255,64,0,64)
	if mat == 0 or mat == 1 then color = tocolor(64,255,0,128) end
	dxDrawLine3D2(x1,y1,z1, x2,y2,z2, color, 2)
	local sx,sy = getScreenFromWorldPosition(x2,y2,z2)
	if sx and sy then
		if mat == 0 or mat == 1 then
			dxDrawText("Clear", sx,sy,sx,sy,tocolor(255,255,255,255), 0.75)
		end
	end
end

function dxDrawLine3D2(x1,y1,z1, x2,y2,z2, color, width)
	local sx1,sy1 = getScreenFromWorldPosition(x1,y1,z1, 1000)
	local sx2,sy2 = getScreenFromWorldPosition(x2,y2,z2, 1000)
	if sx1 and sx2 and sy1 and sy2 then
		dxDrawLine(sx1,sy1, sx2,sy2, color, width)
	end
end
