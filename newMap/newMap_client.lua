local width, height = guiGetScreenSize()
local halfWidth, halfHeight = width/2, height/2
local imgW,imgH = 3000,3000

local satteliteTex = dxCreateTexture("images/sattelite.jpg")
local radarTex = dxCreateTexture("images/radar.jpg")
local rt = dxCreateRenderTarget(imgW,imgH, true)

local zoom = 3000
local size = height
local halfSize = size/2

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		showPlayerHudComponent("radar", false)
	end
)

addEventHandler("onClientRender", root,
	function ()
		local getTickStart = getTickCount()
		
		
		drawMap(width*0.5,height*0.5)
		--drawMap(width*0.16,height*0.785)
		
		
		local getTickEnd = getTickCount()
		dxDrawText("Time elapsed: " .. getTickEnd - getTickStart .. " milliseconds", 100,200)
	end
)

function drawMap(x,y)
	local playerX,playerY,playerZ = getElementPosition(localPlayer)
	local cameraX,cameraY,cameraZ,targetX,targetY,targetZ = getCameraMatrix()
	local cameraRotation = findRotation(cameraX,cameraY, targetX,targetY)
	local playerRotation = getPedRotation(localPlayer)
	
	local speed = 0
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local vx,vy,vz = getElementVelocity(veh)
		speed = (vx^2 + vy^2 + vz^2) * 200
	end
	
	local scale = zoom+speed
	local halfScale = scale/2
	local iconSize = math.max(12-(speed/12), 8)
	local halfIconSize = iconSize/2
	local u = ((3000+playerX)/2)-halfScale
	local v = ((3000-playerY)/2)-halfScale
	
	dxSetRenderTarget(rt, true)
	dxDrawImageSection(0,0, size,size, u,v, scale,scale, satteliteTex, 0, 0,0, tocolor(255,255,255,255))
	dxDrawImageSection(0,0, size,size, u,v, scale,scale, radarTex, 0, 0,0, tocolor(255,255,255,96))
	dxDrawImage(halfSize-halfIconSize,halfSize-halfIconSize, iconSize,iconSize, "blips/2.png", -playerRotation, 0, 0, tocolor(255,255,255,255))
	
	local posX = x-halfSize
	local posY = y-halfSize
	dxSetRenderTarget()
	--[[
	for i=0, 31 do
		local j = i*4
		local s = size-j-j
		--dxDrawImageSection(posX+j,posY+j, s,s, j,j, s,s, rt, cameraRotation, 0,0, tocolor(255,255,255,i^2))
		dxDrawImageSection(posX+j,posY+j, s,s, j,j, s,s, rt, 0, 0,0, tocolor(255,255,255,i^2))
	end
	]]
	--dxDrawImageSection(posX,posY, size,size, 0,0, size,size, rt, 0, 0,0, tocolor(255,255,255,220))
	dxDrawImageSection(posX,posY, size,size, 0,0, size,size, rt, 0, 0,0, tocolor(255,255,255,255))
end

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