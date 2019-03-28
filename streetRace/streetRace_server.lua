local raceStartMarker
local checkpointMarkers = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for j, spawnpoint in pairs(getElementsByType("spawnpoint", resourceRoot)) do
			if j == 1 then
				local marker = createMarker(getElementData(spawnpoint, "posX"),getElementData(spawnpoint, "posY"),getElementData(spawnpoint, "posZ")-1, "cylinder", 2, 0,255,0,64)
				local blip = createBlip(getElementData(spawnpoint, "posX"),getElementData(spawnpoint, "posY"),getElementData(spawnpoint, "posZ"), 53, 1)
				setElementData(marker, "blip", blip)
				addEventHandler("onMarkerHit", marker, startRace)
				raceStartMarker = marker
			end
			--setElementVisibleTo(marker, getRootElement(), false)
		end
		
		local checkpoints = getElementsByType("checkpoint", resourceRoot)
		for j, checkpoint in pairs(checkpoints) do
			local marker = createMarker(getElementData(checkpoint, "posX"),getElementData(checkpoint, "posY"),getElementData(checkpoint, "posZ"), "checkpoint", 16, 0,255,0,16)
			local blip = createBlip(getElementData(checkpoint, "posX"),getElementData(checkpoint, "posY"),getElementData(checkpoint, "posZ"), 0, 4, 0,255,0,64)
			if j <= #checkpoints-1 then
				setMarkerTarget(marker, getElementData(checkpoints[j+1], "posX"),getElementData(checkpoints[j+1], "posY"),getElementData(checkpoints[j+1], "posZ"))
			end
			addEventHandler("onMarkerHit", marker, showNextCheckpoint)
			setElementData(marker, "blip", blip)
			setElementParent(marker, checkpoint)
			setElementVisibleTo(marker, getRootElement(), false)
			setElementVisibleTo(blip, getRootElement(), false)
			table.insert(checkpointMarkers, marker)
		end
	end
)

function startRace(hitElement, matchingDimension)
	if getElementType(hitElement) == "vehicle" then
		local driver = getVehicleOccupant(hitElement, 0)
		setElementData(driver, "raceTime", getTickCount())
		if driver then
			setElementVisibleTo(raceStartMarker, driver, false)
			setElementVisibleTo(getElementData(raceStartMarker, "blip"), driver, false)
			setElementVisibleTo(checkpointMarkers[1], driver, true)
			setElementVisibleTo(getElementData(checkpointMarkers[1], "blip"), driver, true)
			setElementData(driver, "currentCheckpoint", 1)
			outputChatBox("GO!", driver, 128,255,0)
			--outputChatBox("GO! 1/"..#checkpointMarkers-1, driver, 128,255,0)
		end
	end
end

function showNextCheckpoint(hitElement, matchingDimension)
	if getElementType(hitElement) == "vehicle" then
		local driver = getVehicleOccupant(hitElement, 0)
		if driver and isElementVisibleTo(source, driver) then
			local currentCheckpoint = getElementData(driver, "currentCheckpoint")
			setElementVisibleTo(checkpointMarkers[currentCheckpoint], driver, false)
			setElementVisibleTo(getElementData(checkpointMarkers[currentCheckpoint], "blip"), driver, false)
			
			if currentCheckpoint+1 < #checkpointMarkers then
				--outputChatBox("Checkpoint "..currentCheckpoint+1 .."/"..#checkpointMarkers-1, driver, 0,255,0)
				setElementData(driver, "currentCheckpoint", currentCheckpoint+1)
				setElementVisibleTo(checkpointMarkers[currentCheckpoint+1], driver, true)
				setElementVisibleTo(getElementData(checkpointMarkers[currentCheckpoint+1], "blip"), driver, true)
				showArrow(currentCheckpoint+1)
			else
				setElementData(driver, "currentCheckpoint", false)
				local raceTime = (getTickCount()-getElementData(driver, "raceTime"))/1000
				outputChatBox("Finish - "..raceTime, driver, 128,255,0)
			end
		end
	end
end

function showArrow(checkpoint)
	if checkpoint+1 < #checkpointMarkers and checkpoint > 1 then
		local x1,y1,z1 = getElementPosition(checkpointMarkers[checkpoint-1])
		local x2,y2,z2 = getElementPosition(checkpointMarkers[checkpoint])
		local x3,y3,z3 = getElementPosition(checkpointMarkers[checkpoint+1])
		local rz1,rz2 = findRotation(x1,y1,x2,y2)-90, findRotation(x2,y2,x3,y3)-90
		if isElement(arrow) then
			destroyElement(arrow)
		end
		arrow = createObject(1318, x2,y2,z2+0.5, 90,90,(rz1+rz2)/2)
	end
end

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end
	return t
end
