local font = exports["fonts"]:getGuiFont("UNCON___.ttf", 9)
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		handlingGridList = guiCreateGridList(0.05, 0.05, 0.9, 0.9, true)
		guiGridListSetSortingEnabled(handlingGridList, false)
		guiGridListSetScrollBars(handlingGridList, false, false)
		guiSetVisible(handlingGridList, false)
		guiSetEnabled(handlingGridList, true)
		guiSetAlpha(handlingGridList, 0.9)
		
		guiSetFont(guiCreateLabel(0.02,0.01,1,0.08, "Handling", true, handlingGridList), font)
		
		local scroll = {}
		local label = guiCreateLabel(0.02,0.05,0.25,0.08, "mass", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.mass = guiCreateScrollBar(0.3,0.0575,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.08,0.25,0.08, "turnMass", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.turnMass = guiCreateScrollBar(0.3,0.0875,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.11,0.25,0.08, "dragCoeff", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.dragCoeff = guiCreateScrollBar(0.3,0.1175,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.14,0.25,0.08, "centerOfMass", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		
		label = guiCreateLabel(0.02,0.17,0.25,0.08, "percentSubmerged", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.percentSubmerged = guiCreateScrollBar(0.3,0.1775,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.20,0.25,0.08, "tractionMultiplier", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.tractionMultiplier = guiCreateScrollBar(0.3,0.2075,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.23,0.25,0.08, "tractionLoss", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.tractionLoss = guiCreateScrollBar(0.3,0.2375,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.26,0.25,0.08, "tractionBias", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.tractionBias = guiCreateScrollBar(0.3,0.2675,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.29,0.25,0.08, "numberOfGears", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.numberOfGears = guiCreateScrollBar(0.3,0.2975,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.32,0.25,0.08, "maxVelocity", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.maxVelocity = guiCreateScrollBar(0.3,0.3275,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.35,0.25,0.08, "engineAcceleration", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.engineAcceleration = guiCreateScrollBar(0.3,0.3575,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.38,0.25,0.08, "engineInertia", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.engineInertia = guiCreateScrollBar(0.3,0.3875,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.41,0.25,0.08, "driveType", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		
		label = guiCreateLabel(0.02,0.44,0.25,0.08, "engineType", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		
		label = guiCreateLabel(0.02,0.47,0.25,0.08, "brakeDeceleration", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.brakeDeceleration = guiCreateScrollBar(0.3,0.4775,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.50,0.25,0.08, "brakeBias", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.brakeBias = guiCreateScrollBar(0.3,0.5075,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.53,0.25,0.08, "steeringLock", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.steeringLock = guiCreateScrollBar(0.3,0.5375,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.56,0.25,0.08, "suspensionForceLevel", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionForceLevel = guiCreateScrollBar(0.3,0.5675,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.59,0.25,0.08, "suspensionDamping", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionDamping = guiCreateScrollBar(0.3,0.5975,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.62,0.25,0.08, "suspensionHighSpeedDamping", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionHighSpeedDamping = guiCreateScrollBar(0.3,0.6275,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.65,0.25,0.08, "suspensionUpperLimit", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionUpperLimit = guiCreateScrollBar(0.3,0.6575,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.68,0.25,0.08, "suspensionLowerLimit", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionLowerLimit = guiCreateScrollBar(0.3,0.6875,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.71,0.25,0.08, "suspensionFrontRearBias", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionFrontRearBias = guiCreateScrollBar(0.3,0.7175,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.74,0.25,0.08, "suspensionAntiDiveMultiplier", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.suspensionAntiDiveMultiplier = guiCreateScrollBar(0.3,0.7475,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.77,0.25,0.08, "seatOffsetDistance", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.seatOffsetDistance = guiCreateScrollBar(0.3,0.7775,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.80,0.25,0.08, "collisionDamageMultiplier", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		scroll.collisionDamageMultiplier = guiCreateScrollBar(0.3,0.8075,0.5,0.015, true, true, handlingGridList)
		
		label = guiCreateLabel(0.02,0.83,0.25,0.08, "monetary", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.02,0.86,0.25,0.08, "modelFlags", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.02,0.89,0.25,0.08, "handlingFlags", true, handlingGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)

		bindKey("f4", "down", toggleStatus)
		--showHandling(localPlayer)
	end
)

function toggleStatus()
	if not guiGetVisible(handlingGridList) then
		showHandling(localPlayer)
	else
		hideHandling()
	end
end

addEvent("toggleStatus", true)
addEventHandler("toggleStatus", root, toggleStatus)

function hideHandling()
	playSoundFrontEnd(38)
	guiSetVisible(handlingGridList, false)
	guiMoveToBack(handlingGridList)
	showCursor(false)
end

function showHandling(player)
	playSoundFrontEnd(37)
	guiSetVisible(handlingGridList, true)
	guiBringToFront(handlingGridList)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		updateHandling(vehicle)
	end
	showCursor(true)
end

function updateHandling(vehicle)
	--[[
	guiSetText(statsHeader, getPlayerName(player))
	guiLabelSetColor(statsHeader, getElementData(player, "r") or 255, getElementData(player, "g") or 255, getElementData(player, "b") or 255)
	
	local row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, getElementData(player, "class") or "Player", false, false)
	guiGridListSetItemColor(statsGridList, row, 1, getElementData(player, "r") or 255, getElementData(player, "g") or 255, getElementData(player, "b") or 255)
	]]
end

function math.round(number, decimals)
    decimals = decimals or 0
    return tonumber(("%."..decimals.."f"):format(number))
end
