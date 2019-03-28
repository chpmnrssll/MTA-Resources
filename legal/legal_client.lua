local currentArrestTarget = nil
local legalDistance = 6
local class = nil
local rx,ry,rz

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		class = getElementData(localPlayer, "class")
	end
)

addEventHandler("onClientPlayerSpawn", localPlayer,
	function (team)
		class = getElementData(localPlayer, "class")
	end
)

addEventHandler("onClientPlayerTarget", getRootElement(),
	function (target)
		if class == "Authorities" and getControlState("aim_weapon") and target then
			if getElementType(target) == "player" then
				local wantedLevel = getElementData(target, "wantedLevel") or 0
				if wantedLevel > 0 then
					local x,y,z = getElementPosition(localPlayer)
					local tx,ty,tz = getElementPosition(target)
					if getDistanceBetweenPoints3D(x,y,z, tx,ty,tz) < legalDistance then
						if currentArrestTarget ~= target then
							triggerServerEvent("arrest", getRootElement(), target, localPlayer)
							currentArrestTarget = target
						end
					end
				end
			end
		end
	end
)

addEvent("clearArrestTarget", true)
addEventHandler("clearArrestTarget", getRootElement(),
	function ()
		if currentArrestTarget == source then
			currentArrestTarget = nil
		end
	end
)

addEvent("jailCam", true)
addEventHandler("jailCam", getRootElement(),
	function (x,y,z)
		rx,ry,rz = x,y,z
		addEventHandler("onClientPreRender", getRootElement(), jailCam)
	end
)
	
function jailCam()
	local cx,cy,cz = getPedBonePosition(localPlayer, 8)
	setCameraMatrix(rx,ry,rz, cx,cy,cz, 0, 120)
end

addEvent("jailCamOff", true)
addEventHandler("jailCamOff", getRootElement(),
	function ()
		removeEventHandler("onClientPreRender", getRootElement(), jailCam)
		setCameraTarget(localPlayer)
	end
)
