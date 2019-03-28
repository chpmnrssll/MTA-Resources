local localPlayer = getLocalPlayer()
local width, height = guiGetScreenSize()

local TICKS = 64
local counter = TICKS+1
local target = nil

local alpha = 0
local d = 16

addEventHandler("onClientPlayerWasted", localPlayer,
	function (killer, weapon, bodypart)
		triggerEvent("showLogo", getRootElement())
		if killer then
			target = killer
			counter = 0
		else
			target = source
			counter = 0
		end
	end
)

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		if counter < TICKS then
			local cx,cy,cz = getPedBonePosition(localPlayer, 8)
			local tx,ty,tz = getElementPosition(target)
			local c = counter/d
			setCameraMatrix(cx,cy,cz+(c/d), tx,ty,tz, c, 100+(c/2))
			counter = counter+1
			d = 16
			if alpha < 128 then
				alpha = alpha+d
			end
		elseif target then
			d = -d
			triggerEvent("toggleSpawnGui", getRootElement())
			if getElementType(target) == "vehicle" then
				target = getVehicleController(target)
			end
			setCameraTarget(target)
			target = nil
		end
		
		if target and getElementHealth(localPlayer) == 0 then
			local interior = getElementInterior(target)
			local dimension = getElementDimension(target)
			setCameraInterior(interior)
			setElementDimension(localPlayer, dimension)
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if d < 0 then
			if alpha > 0 then
				alpha = alpha+d
			else
				alpha = 0
			end
		end
		
		if alpha > 0 then
			dxDrawRectangle(0,0, width,height, tocolor(128,0,0,alpha), false)
		end
		
		local target = getCameraTarget()
		if target and target ~= localPlayer then
			local interior = getElementInterior(target)
			if interior ~= getElementInterior(localPlayer) then
				setCameraTarget(localPlayer)
			end
		end
	end
)