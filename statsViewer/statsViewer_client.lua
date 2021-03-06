local font = exports["fonts"]:getGuiFont("UNCON___.ttf", 9)
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		statusGridList = guiCreateGridList(0.05, 0.05, 0.9, 0.9, true)
		guiGridListSetSortingEnabled(statusGridList, false)
		guiGridListSetScrollBars(statusGridList, false, false)
		guiSetVisible(statusGridList, false)
		guiSetEnabled(statusGridList, true)
		guiSetAlpha(statusGridList, 0.9)
		
		guiSetFont(guiCreateLabel(0.02,0.01,1,0.08, "Player", true, statusGridList), font)
		
		statsGridList = guiCreateGridList(0.01, 0.04, 0.485, 0.45, true, statusGridList)
		guiGridListSetSortingEnabled(statsGridList, false)
		guiGridListSetScrollBars(statsGridList, false, false)
		guiSetEnabled(statsGridList, true)
		guiSetAlpha(statsGridList, 0.9)
		guiSetFont(statsGridList, font)
		guiGridListAddColumn(statsGridList, "", 0.55)
		guiGridListAddColumn(statsGridList, "", 0.35)
		
		statsHeader = guiCreateLabel(0.05,0.02,0.5,0.08, "", true, statsGridList)
		guiLabelSetHorizontalAlign(statsHeader, "left")
		guiSetFont(statsHeader, font)
		
		barGridList = guiCreateGridList(0.5,0.04,0.49,0.45, true, statusGridList)
		guiSetAlpha(barGridList, 0.9)
		
		local label = guiCreateLabel(0.05,0.02,0.17,0.08, "Colt 45", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.10,0.17,0.08, "Silenced", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.18,0.17,0.08, "Deagle", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.26,0.17,0.08, "Shotgun", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.34,0.17,0.08, "Sawed-off", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.42,0.17,0.08, "Combat SG", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.50,0.17,0.08, "UZI", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.58,0.17,0.08, "MP5", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.66,0.17,0.08, "AK-47", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.74,0.17,0.08, "M4", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.82,0.17,0.08, "Sniper", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		label = guiCreateLabel(0.05,0.90,0.17,0.08, "Respect", true, barGridList)
		guiLabelSetHorizontalAlign(label, "right")
		guiSetFont(label, font)
		
		pistolBar =   dxProgressBar(0.11,0.060,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		silencedBar = dxProgressBar(0.11,0.092,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		deagleBar =   dxProgressBar(0.11,0.126,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		shotgunBar =  dxProgressBar(0.11,0.158,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		sawedOffBar = dxProgressBar(0.11,0.190,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		combatBar =   dxProgressBar(0.11,0.222,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		uziBar =      dxProgressBar(0.11,0.256,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		mp5Bar =      dxProgressBar(0.11,0.288,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		ak47Bar =     dxProgressBar(0.11,0.320,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		m4Bar =       dxProgressBar(0.11,0.352,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		sniperBar =   dxProgressBar(0.11,0.384,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		respectBar =  dxProgressBar(0.11,0.418,0.64,0.048, { 64,64,64,192 }, { 255,0,0,192 }, barGridList)
		
		guiSetFont(guiCreateLabel(0.02,0.5,1,0.08, "Vehicles", true, statusGridList), font)
		vehiclesGridList = guiCreateGridList(0.01,0.535,0.98,0.45, true, statusGridList)
		guiGridListSetSortingEnabled(vehiclesGridList, false)
		guiGridListSetScrollBars(vehiclesGridList, false, false)
		guiSetEnabled(vehiclesGridList, true)
		
		guiSetAlpha(vehiclesGridList, 0.9)
		guiSetFont(vehiclesGridList, font)
		guiGridListAddColumn(vehiclesGridList, "Vehicle", 0.25)
		guiGridListAddColumn(vehiclesGridList, "Position", 0.7)
		
		bindKey("f1", "down", toggleStatus)
		--showStats(localPlayer)
	end
)

function toggleStatus()
	if not guiGetVisible(statusGridList) then
		showStats(localPlayer)
	else
		hideStats()
	end
end

addEvent("toggleStatus", true)
addEventHandler("toggleStatus", root, toggleStatus)

function hideStats()
	playSoundFrontEnd(38)
	guiSetVisible(statusGridList, false)
	guiMoveToBack(statusGridList)
	showCursor(false)
end

function showStats(player)
	playSoundFrontEnd(37)
	guiSetVisible(statusGridList, true)
	guiBringToFront(statusGridList)
	updateStats(player)
	showCursor(true)
end

function updateStats(player)
	guiGridListClear(statsGridList)
	guiGridListClear(vehiclesGridList)
	
	guiSetText(statsHeader, getPlayerName(player))
	guiLabelSetColor(statsHeader, getElementData(player, "r") or 255, getElementData(player, "g") or 255, getElementData(player, "b") or 255)
	
	local row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, getElementData(player, "class") or "Player", false, false)
	guiGridListSetItemColor(statsGridList, row, 1, getElementData(player, "r") or 255, getElementData(player, "g") or 255, getElementData(player, "b") or 255)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "  "..(getElementData(player, "subclass") or ""), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, getElementData(player, "r") or 255, getElementData(player, "g") or 255, getElementData(player, "b") or 255)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Kills", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 121), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Deaths", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 135), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Drowned", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 170), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Ratio", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..math.round(math.max(getPedStat(player, 121), 1) / math.max(getPedStat(player, 135), 1), 2), false, false)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Rounds Fired", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 126), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Bullets Hit", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 128), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Explosives Used", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 127), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Headshots", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 130), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Accuracy", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..math.round((math.max(getPedStat(player, 126), 1) / 100) * getPedStat(player, 128), 2).."%", false, false)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Wanted Stars Attained", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 131), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Wanted Stars Evaded", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 132), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Times Arrested", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 133), false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Arrests Made", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 152), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Account Balance", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..(getElementData(player, "bankBalance") or 0), false, false)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 192, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Weapon Budget", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 13), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Food Shop Budget", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 20), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Mod Shop Budget", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 55), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Strip Club Budget", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 54), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Prostitute Budget", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 33), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Spent Gambling", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 35), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Made Gambling", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 37), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Biggest Gambling Win", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 38), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Biggest Gambling Loss", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 39), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Made Pimping", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 36), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Made Stealing", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 41), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Biggest Take Stealing", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 40), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Made in Taxi", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 149), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Money Made Truckin", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 162), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Meals Eaten", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 200), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Prostitute Visits", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 190), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Number Girls Pimped", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 171), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Cars Stolen", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 183), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Houses Robbed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 191), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Safes Cracked", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 192), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Stolen Items Sold", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 194), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Passengers in Taxi", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 150), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Lives Saved", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 151), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Fires Extinguished", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 153), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Pizzas Delivered", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 154), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Vigilante Level", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 157), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Medic Level", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 158), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Firefighter Level", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 159), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Truckin Missions Passed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 161), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Rampages Attempted", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 167), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Rampages Passed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 168), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Shooting Range Score", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 174), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Cars Destroyed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 122), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Boats Destroyed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 123), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Aircraft Destroyed", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 124), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Total Property Damage", false, false)
	guiGridListSetItemText(statsGridList, row, 2, "$"..getPedStat(player, 124), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 32, 96, 32)
	
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "", false, false)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance on Foot", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 3), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance Swimming", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 26), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Car", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 4), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Bike", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 5), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Boat", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 6), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Cart", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 7), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Heli", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 8), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Distance by Plane", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 9), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Jetpack Time", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 173), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)
	row = guiGridListAddRow(statsGridList)
	guiGridListSetItemText(statsGridList, row, 1, "Flight Time", false, false)
	guiGridListSetItemText(statsGridList, row, 2, " "..getPedStat(player, 169), false, false)
	guiGridListSetItemColor(statsGridList, row, 1, 64, 64, 64)
	guiGridListSetItemColor(statsGridList, row, 2, 64, 64, 64)

	pistolBar.progress = getPedStat(player, 69)*0.001
	silencedBar.progress = getPedStat(player, 70)*0.001
	deagleBar.progress = getPedStat(player, 71)*0.001
	shotgunBar.progress = getPedStat(player, 72)*0.001
	sawedOffBar.progress = getPedStat(player, 73)*0.001
	combatBar.progress = getPedStat(player, 74)*0.001
	uziBar.progress = getPedStat(player, 75)*0.001
	mp5Bar.progress = getPedStat(player, 76)*0.001
	ak47Bar.progress = getPedStat(player, 77)*0.001
	m4Bar.progress = getPedStat(player, 78)*0.001
	sniperBar.progress = getPedStat(player, 79)*0.001
	respectBar.progress = getPedStat(player, 68)*0.001
	
	pistolBar.fgColor = { 255-(255*pistolBar.progress),255*pistolBar.progress,0,192 }
	silencedBar.fgColor = { 255-(255*deagleBar.progress),255*deagleBar.progress,0,192 }
	deagleBar.fgColor = { 255-(255*deagleBar.progress),255*deagleBar.progress,0,192 }
	shotgunBar.fgColor = { 255-(255*shotgunBar.progress),255*shotgunBar.progress,0,192 }
	sawedOffBar.fgColor = { 255-(255*sawedOffBar.progress),255*sawedOffBar.progress,0,192 }
	combatBar.fgColor = { 255-(255*combatBar.progress),255*combatBar.progress,0,192 }
	uziBar.fgColor = { 255-(255*uziBar.progress),255*uziBar.progress,0,192 }
	mp5Bar.fgColor = { 255-(255*mp5Bar.progress),255*mp5Bar.progress,0,192 }
	ak47Bar.fgColor = { 255-(255*ak47Bar.progress),255*ak47Bar.progress,0,192 }
	m4Bar.fgColor = { 255-(255*m4Bar.progress),255*m4Bar.progress,0,192 }
	sniperBar.fgColor = { 255-(255*sniperBar.progress),255*sniperBar.progress,0,192 }
	respectBar.fgColor = { 255-(255*respectBar.progress),255*respectBar.progress,0,192 }
	
	for i,vehicle in pairs(getElementsByType("vehicle")) do
		local owner = getElementData(vehicle, "owner") or ""
		--if not owner then
			local x,y,z = getElementPosition(vehicle)
			row = guiGridListAddRow(vehiclesGridList)
			guiGridListSetItemText(vehiclesGridList, row, 1, getVehicleName(vehicle), false, false)
			guiGridListSetItemText(vehiclesGridList, row, 2, owner..getElementID(vehicle), false, false)
		--end
	end
end

function math.round(number, decimals)
    decimals = decimals or 0
    return tonumber(("%."..decimals.."f"):format(number))
end
