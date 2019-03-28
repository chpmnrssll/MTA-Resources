local DUMMYID = 3003

-- states --
function close(obj, element)
	local rx,ry,rz = getElementRotation(obj.center)
	local state = getElementsByType("state", obj.gate)[1]
	local posX,posY,posZ = getElementData(state, "posX"),getElementData(state, "posY"),getElementData(state, "posZ")
	local rotX,rotY,rotZ = getElementData(state, "rotX"),getElementData(state, "rotY"),getElementData(state, "rotZ")
	
	moveObject(obj.center, obj.speed, posX,posY,posZ, rotX-rx,rotY-ry,rotZ-rz, obj.easingType, obj.easingPeriod, obj.easingAmplitude, obj.easingOvershoot)
	outputChatBox("closed")
end

function open(obj, element)
	if not unlock(obj, element) then
		obj.state = close
		obj.state(obj, element)
		return
	end
	
	local rx,ry,rz = getElementRotation(obj.center)
	local state = getElementsByType("state", obj.gate)[2]
	local posX,posY,posZ = getElementData(state, "posX"),getElementData(state, "posY"),getElementData(state, "posZ")
	local rotX,rotY,rotZ = getElementData(state, "rotX"),getElementData(state, "rotY"),getElementData(state, "rotZ")
	
	moveObject(obj.center, obj.speed, posX,posY,posZ, rotX-rx,rotY-ry,rotZ-rz, obj.easingType, obj.easingPeriod, obj.easingAmplitude, obj.easingOvershoot)
	outputChatBox("open")
end

function checkTriggers(obj, element)
	local hold = false
	for i, trigger in pairs(obj.triggers) do
		local players = getElementsWithinColShape(trigger, "player")
		local vehicles = getElementsWithinColShape(trigger, "vehicle")
		if #players > 0 or #vehicles > 0 then
			hold = true
		end
	end
	
	if not hold then
		obj.state = close
	else
		obj.state = open
	end
	
	setTimer(obj.state, 100, 1, obj, element)
end


-- transition table --
local stateTable = {
{ open, "onColShapeLeave", checkTriggers },
{ close, "onColShapeHit", checkTriggers },
}

function unlock(obj, element)
	local key = false					--default state
	
	if getElementType(element) == "vehicle" then
		for i, e in pairs(getVehicleOccupants(element)) do
			local class = getElementData(e, "class")
			local subclass = getElementData(e, "subclass")
			
			if obj.class and obj.class == class then
				key = true
			elseif obj.subclass and obj.subclass == subclass then
				key = true
			end
		end
	else
		local class = getElementData(element, "class")
		local subclass = getElementData(element, "subclass")
		
		if obj.class and obj.class == class then
			key = true
		elseif obj.subclass and obj.subclass == subclass then
			key = true
		end
	end
	
	outputChatBox("unlock:"..tostring(key))
	return key
end

function event(event, obj, element)
	if getElementType(element) == "player" or getElementType(element) == "vehicle" then
		if fsm[obj.state] and fsm[obj.state][event] then
			obj.state = fsm[obj.state][event]
			obj.state(obj, element)
		end
	end
end

function createFSM(stateTable)
	local fsm = {}
	for k,v in ipairs(stateTable) do
		local state, event, transition = v[1], v[2], v[3]
		if fsm[state] == nil then fsm[state] = {} end
		fsm[state][event] = transition
	end
	
	return fsm
end

function buildGate(gate)
	local offset = getElementsByType("offset", gate)[1]
	local closed = getElementsByType("state", gate)[1]
	local open = getElementsByType("state", gate)[2]
	local interior = getElementData(gate, "interior")
	local dimension = getElementData(gate, "dimension")
	
	local obj = {}
	obj.gate = gate
	obj.id = getElementID(gate)
	obj.speed = math.max(getElementData(gate, "speed"), 50) or 50
	obj.easingType = getElementData(gate, "easingType") or "Linear"
	obj.easingPeriod = getElementData(gate, "easingPeriod") or 0.3
	obj.easingAmplitude = getElementData(gate, "easingAmplitude") or 1.0
	obj.easingOvershoot = getElementData(gate, "easingOvershoot") or 1.701
	obj.class = getElementData(gate, "class") or false
	obj.subclass = getElementData(gate, "subclass") or false
	obj.state = close
	
	obj.center = createObject(DUMMYID,
		getElementData(closed, "posX"),getElementData(closed, "posY"),getElementData(closed, "posZ"),
		getElementData(closed, "rotX"),getElementData(closed, "rotY"),getElementData(closed, "rotZ"))
	obj.object = createObject(getElementData(gate, "model"),
		getElementData(closed, "posX"),getElementData(closed, "posY"),getElementData(closed, "posZ"),
		getElementData(closed, "rotX"),getElementData(closed, "rotY"),getElementData(closed, "rotZ"))
	
	setElementData(gate, "center", obj.center)
	setElementInterior(obj.object, interior)
	setElementInterior(obj.center, interior)
	setElementDimension(obj.object, dimension)
	setElementDimension(obj.center, dimension)
	setElementCollisionsEnabled(obj.center, false)
	setElementAlpha(obj.center, 0)
	setObjectScale(obj.center, 8)
	
	if offset then
		local rotX = getElementData(offset, "rotX") or 0
		local rotY = getElementData(offset, "rotY") or 0
		local rotZ = getElementData(offset, "rotZ") or 0
		attachElements(obj.object, obj.center, getElementData(offset, "posX"),getElementData(offset, "posY"),getElementData(offset, "posZ"), rotX,rotY,rotZ)
	else
		attachElements(obj.object, obj.center, 0,0,0)
	end
	
	obj.triggers = {}
	for j, trigger in pairs(getElementsByType("trigger", gate)) do
		local col = createColSphere(getElementData(trigger, "posX"),getElementData(trigger, "posY"),getElementData(trigger, "posZ"), getElementData(trigger, "size"))
		addEventHandler("onColShapeHit", col, function (element, matchingDimension) if matchingDimension then event("onColShapeHit", obj, element) end end)
		addEventHandler("onColShapeLeave", col, function (element, matchingDimension) if matchingDimension then event("onColShapeLeave", obj, element) end end)
		setElementInterior(col, interior)
		setElementDimension(col, dimension)
		setElementData(col, "size", getElementData(trigger, "size"))
		setElementParent(col, gate)
		table.insert(obj.triggers, col)
	end
	
	return obj
end

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, gate in ipairs(getElementsByType("gate", root)) do
			buildGate(gate)
		end
		fsm = createFSM(stateTable)
	end
)
