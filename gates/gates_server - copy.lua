local DUMMYID = 3003

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, gate in ipairs(getElementsByType("gate", root)) do
			buildGate(gate)
		end
	end
)

function buildGate(gate)
	local center = getElementsByType("center", gate)[1]
	local closed = getElementsByType("state", gate)[1]
	local open = getElementsByType("state", gate)[2]
	
	local model = getElementData(gate, "model")
	local interior = getElementData(gate, "interior")
	local dimension = getElementData(gate, "dimension")
	local posX = getElementData(closed, "posX")
	local posY = getElementData(closed, "posY")
	local posZ = getElementData(closed, "posZ")
	local rotX = math.rad(getElementData(closed, "rotX"))
	local rotY = math.rad(getElementData(closed, "rotY"))
	local rotZ = math.rad(getElementData(closed, "rotZ"))
	local offX = getElementData(center, "posX")
	local offY = getElementData(center, "posY")
	local offZ = getElementData(center, "posZ")
	local offRX = math.rad(getElementData(center, "rotX"))
	local offRY = math.rad(getElementData(center, "rotY"))
	local offRZ = math.rad(getElementData(center, "rotZ"))
	
	local object = createObject(model, posX,posY,posZ)
	local dummy = createObject(DUMMYID, posX,posY,posZ)
	attachElements(object, dummy, offX,offY,offZ, offRX,offRY,offRZ)
	setElementRotation(dummy, rotX,rotY,rotZ)
	setElementCollisionsEnabled(dummy, false)
	setElementInterior(object, interior)
	setElementInterior(dummy, interior)
	setElementDimension(object, dimension)
	setElementDimension(dummy, dimension)
	setElementData(gate, "object", object)
	setElementData(gate, "center", dummy)
	setElementData(gate, "state", "closed")
	setElementParent(object, gate)
	setElementParent(dummy, object)
	setElementAlpha(dummy, 0)
	setObjectScale(dummy, 8)
	
	setElementData(gate, "closed", closed)
	setElementData(gate, "open", open)
	
	for j, trigger in pairs(getElementsByType("trigger", gate)) do
		local colX = getElementData(trigger, "posX")
		local colY = getElementData(trigger, "posY")
		local colZ = getElementData(trigger, "posZ")
		local colSize = getElementData(trigger, "size")
		local col = createColSphere(colX,colY,colZ, colSize)
		setElementInterior(col, interior)
		setElementDimension(col, dimension)
		setElementData(col, "size", colSize)
		setElementParent(col, gate)
		addEventHandler("onColShapeHit", col, enter)
		addEventHandler("onColShapeLeave", col, leave)
	end
end

function enter(hitElement, matchingDimension)
--	if getElementData(hitElement, "subclass") == getElementData(gate, "subclass") and isElementWithinColShape(hitElement, source) then
	if matchingDimension and getElementType(hitElement) == "player" or getElementType(hitElement) == "vehicle" then
		local gate = getElementParent(source)
		local state = getElementData(gate, "state")
		
		if state ~= "open" then
			open(gate)
		end
	end
end

function leave(leaveElement, matchingDimension)
	if matchingDimension and getElementType(leaveElement) == "player" or getElementType(leaveElement) == "vehicle" then
		local gate = getElementParent(source)
		local state = getElementData(gate, "state")
		
		if state ~= "closed" then
			close(gate)
		end
	end
end

function open(gate)
	local moveTo = getElementData(gate, "open")
	local posX = getElementData(moveTo, "posX")
	local posY = getElementData(moveTo, "posY")
	local posZ = getElementData(moveTo, "posZ")
	local rotX = getElementData(moveTo, "rotX")
	local rotY = getElementData(moveTo, "rotY")
	local rotZ = getElementData(moveTo, "rotZ")
	local center = getElementData(gate, "center")
	local state = getElementData(gate, "state")
	local speed = getElementData(gate, "speed")
	local holdTime = getElementData(gate, "holdTime")
	local easingType = getElementData(gate, "easingType")
	local easingPeriod = getElementData(gate, "easingPeriod")
	local easingAmplitude = getElementData(gate, "easingAmplitude")
	local easingOvershoot = getElementData(gate, "easingOvershoot")
	
	if state == "closed" then
		setElementData(gate, "state", "moving")
		moveObject(center, speed, posX,posY,posZ, rotX,rotY,rotZ, easingType, easingPeriod, easingAmplitude, easingOvershoot)
		setTimer(
			function(gate)
				setElementData(gate, "state", "open")
				local center = getElementData(gate, "center")
				local open = getElementData(gate, "open")
				local cx = getElementData(open, "posX")
				local cy = getElementData(open, "posY")
				local cz = getElementData(open, "posZ")
				local crx = getElementData(open, "rotX")
				local cry = getElementData(open, "rotY")
				local crz = getElementData(open, "rotZ")
				setElementPosition(center, cx,cy,cz)
				setElementRotation(center, crx,cry,crz)
			end,
		speed+holdTime, 1, gate)
	elseif state == "moving" and state ~= "open" then
		setTimer(open, holdTime, 1, gate)
	end
end

function close(gate)
	local moveTo = getElementData(gate, "closed")
	local moveFrom = getElementData(gate, "open")
	local posX = getElementData(moveTo, "posX")
	local posY = getElementData(moveTo, "posY")
	local posZ = getElementData(moveTo, "posZ")
	local rotX = -getElementData(moveFrom, "rotX")
	local rotY = -getElementData(moveFrom, "rotY")
	local rotZ = -getElementData(moveFrom, "rotZ")
	local center = getElementData(gate, "center")
	local state = getElementData(gate, "state")
	local speed = getElementData(gate, "speed")
	local holdTime = getElementData(gate, "holdTime")
	local easingType = getElementData(gate, "easingType")
	local easingPeriod = getElementData(gate, "easingPeriod")
	local easingAmplitude = getElementData(gate, "easingAmplitude")
	local easingOvershoot = getElementData(gate, "easingOvershoot")
	
	if state == "open" then
		setTimer(
			function (gate, posX,posY,posZ, rotX,rotY,rotZ)
				local hold = false
				for i, col in pairs(getElementsByType("colshape", gate)) do
					local players = getElementsWithinColShape(col, "player")
					local vehicles = getElementsWithinColShape(col, "vehicle")
					if #players > 0 or #vehicles > 0 then
						hold = true
					end
				end
				
				if not hold and state == "open" then
					setElementData(gate, "state", "moving")
					moveObject(center, speed, posX,posY,posZ, rotX,rotY,rotZ, easingType, easingPeriod, easingAmplitude, easingOvershoot)
					setTimer(
						function(gate)
							setElementData(gate, "state", "closed")
							local center = getElementData(gate, "center")
							local closed = getElementData(gate, "closed")
							local cx = getElementData(closed, "posX")
							local cy = getElementData(closed, "posY")
							local cz = getElementData(closed, "posZ")
							local crx = getElementData(closed, "rotX")
							local cry = getElementData(closed, "rotY")
							local crz = getElementData(closed, "rotZ")
							setElementPosition(center, cx,cy,cz)
							setElementRotation(center, crx,cry,crz)
						end,
					speed+holdTime, 1, gate)
				end
			end,
		holdTime, 1, gate, posX,posY,posZ, rotX,rotY,rotZ)
	end
	if state ~= "closed" then
		setTimer(close, holdTime, 1, gate)
	end
end
