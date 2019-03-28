local classes = getElementChildren(getElementByID("spawn.xml"))
local font = exports["fonts"]:getGuiFont("UNCON___.ttf", 9)
local updateSpeed = 1000
local updateTimer = nil

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		scoreGridList = guiCreateGridList(0.05, 0.05, 0.9, 0.9, true)
		guiGridListSetSortingEnabled(scoreGridList, false)
		guiGridListSetScrollBars(scoreGridList, false, false)
		guiSetVisible(scoreGridList, false)
		guiSetEnabled(scoreGridList, true)
		guiSetAlpha(scoreGridList, 0.9)
		
		scoreColumn = guiGridListAddColumn(scoreGridList, "", 0.25)
		killsColumn = guiGridListAddColumn(scoreGridList, "", 0.07)
		deathsColumn = guiGridListAddColumn(scoreGridList, "", 0.07)
		ratioColumn = guiGridListAddColumn(scoreGridList, "", 0.07)
		respectColumn = guiGridListAddColumn(scoreGridList, "", 0.07)
		wantedColumn = guiGridListAddColumn(scoreGridList, "", 0.11)
		locationColumn = guiGridListAddColumn(scoreGridList, "", 0.3)
		
		guiSetFont(guiCreateLabel(0.02,0.01,1,0.08, "Scoreboard", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.26,0.01,1,0.08, "Kills", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.33,0.01,1,0.08, "Deaths", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.40,0.01,1,0.08, "Ratio", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.47,0.01,1,0.08, "Respect", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.54,0.01,1,0.08, "Wanted", true, scoreGridList), font)
		guiSetFont(guiCreateLabel(0.65,0.01,1,0.08, "Last Seen", true, scoreGridList), font)
		guiSetFont(scoreGridList, font)
		
		addEventHandler("onClientGUIDoubleClick", scoreGridList,
			function (button, state, absoluteX, absoluteY)
				if source == scoreGridList then
					local row, col = guiGridListGetSelectedItem(source)
					local data = guiGridListGetItemData(source, row, col)
					if data then
						if gettok(data, 1, ":") == "player" then
							local selectedPlayer = gettok(data, 2, ":")
							for i,player in pairs(getElementsByType("player")) do
								if getPlayerName(player) == selectedPlayer then
									exports["statsViewer"]:showStats(player)
								end
							end
						end
					end
				end
			end
		)
		
		bindKey("tab", "both", toggleScore)
		updateScore()
	end
)

function toggleScore()
	if not guiGetVisible(scoreGridList) then
		playSoundFrontEnd(37)
		updateTimer = setTimer(updateScore, updateSpeed, 0)
		guiSetVisible(scoreGridList, true)
		guiBringToFront(scoreGridList)
		updateScore()
		showCursor(true)
	else
		playSoundFrontEnd(38)
		guiSetVisible(scoreGridList, false)
		guiMoveToBack(scoreGridList)
		killTimer(updateTimer)
		showCursor(false)
	end
end

addEvent("toggleScore", true)
addEventHandler("toggleScore", getRootElement(), toggleScore)
addCommandHandler("score", toggleScore)

function updateScore()
	guiGridListClear(scoreGridList)
	for i, class in ipairs(classes) do
		local subclasses = getElementChildren(class)
		local count = 0
		for j, subclass in ipairs(subclasses) do
			local team = getTeamFromName(getElementID(subclass))
			if team then
				local numPlayers = countPlayersInTeam(team) or 0
				count = count+numPlayers
			end
		end
		
		if count > 0 then
			local r = getElementData(class, "r")
			local g = getElementData(class, "g")
			local b = getElementData(class, "b")
			local row = guiGridListAddRow(scoreGridList)
			
			guiGridListSetItemText(scoreGridList, row, scoreColumn, getElementID(class), false, false)
			guiGridListSetItemColor(scoreGridList, row, scoreColumn, r, g, b)
			for j, subclass in ipairs(subclasses) do
				local team = getTeamFromName(getElementID(subclass))
				local plrs = getPlayersInTeam(team)
				
				if #plrs > 0 then
					r, g, b = getTeamColor(team)
					row = guiGridListAddRow(scoreGridList)
					guiGridListSetItemText(scoreGridList, row, scoreColumn, "  "..getTeamName(team), false, false)
					guiGridListSetItemColor(scoreGridList, row, scoreColumn, r,g,b)
					for k, plr in ipairs(plrs) do
						row = guiGridListAddRow(scoreGridList)
						guiGridListSetItemText(scoreGridList, row, scoreColumn, "    "..getPlayerName(plr), false, false)
						guiGridListSetItemData(scoreGridList, row, scoreColumn, "player:"..getPlayerName(plr))
						guiGridListSetItemColor(scoreGridList, row, scoreColumn, r,g,b)
						
						--local kills = getPedStat(plr, 121)
						local kills = getElementData(plr, "sessionKills") or 0
						guiGridListSetItemText(scoreGridList, row, killsColumn, kills, false, false)
						guiGridListSetItemColor(scoreGridList, row, killsColumn, r,g,b)
						
						--local deaths = getPedStat(plr, 135)
						local deaths = getElementData(plr, "sessionDeaths") or 0
						guiGridListSetItemText(scoreGridList, row, deathsColumn, deaths, false, false)
						guiGridListSetItemColor(scoreGridList, row, deathsColumn, r,g,b)
						
						local ratio = math.round(math.max(kills, 1) / math.max(deaths, 1), 2)
						guiGridListSetItemText(scoreGridList, row, ratioColumn, ratio, false, false)
						guiGridListSetItemColor(scoreGridList, row, ratioColumn, r,g,b)
						
						guiGridListSetItemText(scoreGridList, row, respectColumn, getPedStat(plr, 68), false, false)
						guiGridListSetItemColor(scoreGridList, row, respectColumn, r,g,b)
						
						local wantedLevel = getElementData(plr, "wantedLevel") or 0
						local wantedString = ""
						for i=1, math.min(wantedLevel, 6) do
							wantedString = wantedString.."*"
						end
						guiGridListSetItemText(scoreGridList, row, wantedColumn, wantedString, false, false)
						guiGridListSetItemColor(scoreGridList, row, wantedColumn, r,g,b)
						
						if getElementInterior(plr) == 0 then
							local x,y,z = getElementPosition(plr)
							setElementData(plr, "lastLocation", getZoneName(x,y,z), false)
						end
						local lastLocation = getElementData(plr, "lastLocation") or ""
						guiGridListSetItemText(scoreGridList, row, locationColumn, lastLocation, false, false)
						guiGridListSetItemColor(scoreGridList, row, locationColumn, r, g, b)
					end
				end
			end
		end
	end
	
	local players = getPlayersInTeam(getTeamFromName("Players"))
	if #players > 0 then
		local row = guiGridListAddRow(scoreGridList)
		local r,g,b = 255,255,255
		guiGridListSetItemText(scoreGridList, row, scoreColumn, "Players", false, false)
		guiGridListSetItemColor(scoreGridList, row, scoreColumn, r,g,b)
		for i, plr in ipairs(players) do
			row = guiGridListAddRow(scoreGridList)
			guiGridListSetItemText(scoreGridList, row, scoreColumn, "    "..getPlayerName(plr), false, false)
			guiGridListSetItemData(scoreGridList, row, scoreColumn, "player:"..getPlayerName(plr))
			guiGridListSetItemColor(scoreGridList, row, scoreColumn, r,g,b)
			
			--local kills = getPedStat(plr, 121)
			local kills = getElementData(plr, "sessionKills") or 0
			guiGridListSetItemText(scoreGridList, row, killsColumn, kills, false, false)
			guiGridListSetItemColor(scoreGridList, row, killsColumn, r,g,b)
			
			--local deaths = getPedStat(plr, 135)
			local deaths = getElementData(plr, "sessionDeaths") or 0
			guiGridListSetItemText(scoreGridList, row, deathsColumn, deaths, false, false)
			guiGridListSetItemColor(scoreGridList, row, deathsColumn, r,g,b)
			
			local ratio = math.max(kills, 1) / math.max(deaths, 1)
			guiGridListSetItemText(scoreGridList, row, ratioColumn, math.round(ratio, 2), false, false)
			guiGridListSetItemColor(scoreGridList, row, ratioColumn, r,g,b)
			
			guiGridListSetItemText(scoreGridList, row, respectColumn, getPedStat(plr, 68), false, false)
			guiGridListSetItemColor(scoreGridList, row, respectColumn, r,g,b)
			
			local wantedLevel = getElementData(plr, "wantedLevel") or 0
			local wantedString = ""
			for i=1, math.min(wantedLevel, 6) do
				wantedString = wantedString.."*"
			end
			guiGridListSetItemText(scoreGridList, row, wantedColumn, wantedString, false, false)
			guiGridListSetItemColor(scoreGridList, row, wantedColumn, r,g,b)
			
			local lastLocation = getElementData(plr, "lastLocation") or ""
			guiGridListSetItemText(scoreGridList, row, locationColumn, lastLocation, false, false)
			guiGridListSetItemColor(scoreGridList, row, locationColumn, r,g,b)
		end
	end
end

function math.round(number, decimals)
    decimals = decimals or 0
    return tonumber(("%."..decimals.."f"):format(number))
end
