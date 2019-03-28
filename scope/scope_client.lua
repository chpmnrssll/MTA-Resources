local width, height = guiGetScreenSize()
local w,h = width/7.25, height-(height/7)
local localPlayer = getLocalPlayer()
local col = createColSphere(0,0,0,64)
local SCALE = 5

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		local interior = getElementInterior(localPlayer)
		
		if interior ~= 0 then
			local px,py,pz = getElementPosition(localPlayer)
			--pz = pz-0.25
			pz = pz+0.25
			local rot = getPedRotation(localPlayer)
			local cx,cy,cz, tx,ty,tz = getCameraMatrix()
			local crot = findRotation(cx,cy, tx,ty)
			
			setElementPosition(col, px,py,pz)
			setElementInterior(col, interior)
			setElementDimension(col, getElementDimension(localPlayer))
			--dxDrawRectangle(w-64,h-64,128,128, tocolor(0,0,0,128))	
			for i=-45,45 do
				local x,y = getPointFromDistanceRotation(px,py, 100, (i*4)-crot)
				local hit, hx,hy,hz, element = processLineOfSight(px,py,pz, x,y,cz, true, false, true, true, false, false, true, true, localPlayer)
				if hit then
					dx = ((hx-px)*SCALE)
					dy = ((hy-py)*SCALE)
					dx,dy = rotate2DPoint(dx,dy, w,h, math.rad(-crot))
					
					local dist = getDistanceBetweenPoints2D(dx,dy, w,h)
					if dist < 128 then
						local a = (255-dist)/8
						local d = dist/8
						local d2 = d/2
						dxDrawLine(w,h, dx,dy, tocolor(16,16,16,a/2), a/2)
						dxDrawRectangle(dx-d2,dy-d2,d,d, tocolor(255,255,255,d))
						dxDrawRectangle(dx-1,dy-1,3,3, tocolor(255,255,255,a))
						dxDrawRectangle(dx,dy,1,1, tocolor(255,255,255,a))
					end
				end
			end
			
			dxDrawImage(w-6,h-6, 12,12, "2.png", crot-rot)
--			for i, player in getElementsWithinColShape(col, "player") do
--				dxDrawRectangle(w-6,h-6, 12,12, "2.png", crot-rot)
--			end
		end
	end
)

function rotate2DPoint(x,y, cx,cy, angle)
	local rx = cx+(math.cos(angle)*x - math.sin(angle)*y)
	local ry = cy-(math.sin(angle)*x + math.cos(angle)*y)
	
	return rx,ry
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
 
    return x+dx, y+dy
end

function findRotation(x1,y1, x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then
		t = t + 360
	end
	
	return t
end