local localPlayer = getLocalPlayer()
local playerClass = nil
local playerSubClass = nil
local blackSky = false
local warpTo = nil

local colSize = 1.75
local vehicleLift = 0.05

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		setElementData(localPlayer, "interior", getElementInterior(localPlayer))	--server sync hack onElementDataChange
		setElementData(localPlayer, "dimension", getElementDimension(localPlayer))
		
		for i, warp in ipairs(getElementsByType("warp")) do
			local posX = tonumber(getElementData(warp, "posX"))
			local posY = tonumber(getElementData(warp, "posY"))
			local posZ = tonumber(getElementData(warp, "posZ"))
			local interior = tonumber(getElementData(warp, "interior"))
			local dimension = tonumber(getElementData(warp, "dimension"))
			local hidden = getElementData(warp, "hidden")
			
			local colSphere = createColSphere(posX, posY, posZ, colSize)
			addEventHandler("onClientColShapeHit", colSphere, warpHandler)
			setElementInterior(colSphere, interior)
			setElementDimension(colSphere, dimension)
			setElementParent(colSphere, warp)
			
			if not hidden then
				local marker = createMarker(posX, posY, posZ+1.25, "corona", 1, 64,128,0,128)
				setElementInterior(marker, interior)
				setElementDimension(marker, dimension)
				setElementData(warp, "marker", marker, false)
			end
		end
		
		updateMarkers()
		setTimer(
			function ()
				local int = getElementInterior(localPlayer)
				local dim = getElementDimension(localPlayer)
				if int ~= getElementData(localPlayer, "interior") then
					setElementData(localPlayer, "interior", int)
				end
				if dim ~= getElementData(localPlayer, "dimension") then
					setElementData(localPlayer, "dimension", dim)
				end
			end,
		1000, 0)
	end
)

addEventHandler("onClientPlayerSpawn", getRootElement(),
	function (team)
		if source == localPlayer then
			setTimer(updateMarkers, 500, 1)
		end
	end
)

function updateMarkers()
	playerClass = getElementData(localPlayer, "class")
	playerSubClass = getElementData(localPlayer, "subclass")
	for i, warp in ipairs(getElementsByType("warp")) do
		local class = getElementData(warp, "class")
		local subclass = getElementData(warp, "subclass")
		local marker = getElementData(warp, "marker")
		if marker then
			if class and class ~= playerClass then
				setMarkerColor(marker, 128,0,0,0)
			elseif subclass and subclass ~= playerSubClass then
				setMarkerColor(marker, 128,0,0,0)
			else
				setMarkerColor(marker, 64,128,0,128)
			end
		end
	end
end

function warpHandler(hitElement, matchingDimension)
	local warp = getElementParent(source)
	local class = getElementData(warp, "class")
	local subclass = getElementData(warp, "subclass")
	
	if hitElement == localPlayer and matchingDimension and not isPedInVehicle(hitElement) then
		if warpTo then												--cancel if warpTo triggers
			setTimer(function () warpTo = nil end, 1000, 1)
			cancelEvent()
		elseif class and class ~= playerClass then					--locked warp
			cancelEvent()
		elseif subclass and subclass ~= playerSubClass then			--locked warp
			cancelEvent()
		else
			warpTo = getElementByID(getElementData(warp, "to"))
			local posX = tonumber(getElementData(warpTo, "posX"))
			local posY = tonumber(getElementData(warpTo, "posY"))
			local posZ = tonumber(getElementData(warpTo, "posZ"))
			local rotation = tonumber(getElementData(warpTo, "rotation"))
			local interior = tonumber(getElementData(warpTo, "interior"))
			local dimension = tonumber(getElementData(warpTo, "dimension"))
			
			checkSkyGradient(interior)
			setElementInterior(hitElement, interior)
			setElementDimension(hitElement, dimension)
			setElementData(hitElement, "interior", interior)			--server sync hack onElementDataChange
			setElementData(hitElement, "dimension", dimension)
			setElementPosition(hitElement, posX,posY,posZ, false)
			setPedRotation(hitElement, rotation)
			triggerEvent("colfix", localPlayer)
			setCameraInterior(interior)
			setTimer(setCameraTarget, 50, 2, localPlayer)
		end
	end
end

function checkSkyGradient(interior)
	if interior > 0 and not blackSky then
		showPlayerHudComponent("radar", false)
		setSkyGradient(0,0,0, 0,0,0)
		blackSky = true
	--elseif blackSky then
	elseif interior == 0 then
		showPlayerHudComponent("radar", true)
		resetSkyGradient()
		blackSky = false
	end
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
 
    return x+dx, y+dy
end