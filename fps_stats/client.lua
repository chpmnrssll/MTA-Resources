---
-- Main client script counting and drawing the FPS stats
-- and managing the settings
--
-- @author	driver2
-- @copyright	2009-2010 driver2
--
-- Recent changes:
-- 2010-02-08: Only sync scoreboard columns if necessary, replaced "Current" by "FPS" and removed "[FPS]", cleaned up some stuff, added fps_stats_reset command
-- 2010-02-07: Added scoreboard support
-- 2010-02-06: Added more GUI options (reset, fullscreen graph), added sizing based on text height
-- 2010-02-04: Commented out 'old' graph drawing, corrected GUI help, GUI improved


root = getRootElement()

-------------------------
-- Initialize Settings --
-------------------------
settingsObject = Settings:new(defaultSettings,"settings.xml")

---
-- Makes accessing setting easier (shorter).
local function s(setting,settingType)
	return settingsObject:get(setting,settingType)
end

---------------
-- Constants --
---------------

fonts = {"default","default-bold","clear","arial","sans","pricedown","bankgothic","diploma","beckett"}
screenWidth, screenHeight = guiGetScreenSize()

--------------------------------
-- Initiate Clientside script --
--------------------------------

function initiate()
	settingsObject:loadFromXml()
	addEventHandler("onClientRender",root,draw)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),initiate)


-------------
-- Drawing --
-------------

---
-- Retrieves the given color from the settings and returns
-- it as hex color value.
--
-- @param   string   name: The name of the color (e.g. "font")
-- @param   float    fade (optional): This number is multiplied with the alpha
-- 			part of the color, to fade the element the color
-- 			is used with
-- @return  color   A color created with tocolor()
local function getColor(name,fade)
	if fade == nil then
		fade = 1
	end
	return tocolor(s(name.."ColorRed"),s(name.."ColorGreen"),s(name.."ColorBlue"),s(name.."ColorAlpha") * fade)
end


-- Data variables (recorded fps)
local savedFps = {}
local maxFps = 0
local minFps = nil
local totalFps = 0
local numFpsUpdates = 0

-- Recording status
local firstSecond = nil
local currentSecond = 0

-- For display (sizing)
local totalTextWidth = 0
local totalTextHeight = 0

-- The current fps
local fps = 0

-- Temp variables for fps calculation
local fpsCount = 0
local updateFpsTime = getTickCount() + 500

---
-- Reset the current data recording.
function resetData()
	maxFps = 0
	minFps = nil
	totalFps = 0
	numFpsUpdates = 0
	savedFps = {}
	firstSecond = nil
	currentSecond = 0
	fps = 0
	fpsCount = 0
	updateFpsTime = getTickCount() + 500
end
addCommandHandler("fps_stats_reset",resetData)

---
-- Main draw function. Calculates the FPS and draws
-- the necessary stuff.
draw = function()

	if not s("enabled") then
		return
	end

	
	-- Count fps
	fpsCount = fpsCount + 1

	-- Check if update is needed
	if getTickCount() >= updateFpsTime then
		currentSecond = math.floor(getTickCount() / 1000)
		currentFps = fpsCount * 2
		-- Update saved fps stuff
		if currentFps > maxFps then
			maxFps = currentFps
		end
		if minFps == nil or currentFps < minFps then
			minFps = currentFps
		end
		numFpsUpdates = numFpsUpdates + 1
		totalFps = totalFps + currentFps
		savedFps[currentSecond] = currentFps
		avgFps = totalFps / numFpsUpdates

		if firstSecond == nil then
			firstSecond = currentSecond
		end

		fps = currentFps

		-- Update element data for scoreboard (if enabled)
		if getElementData(getResourceRootElement(),"addFpsToScoreboard") then
			setElementData(getLocalPlayer(),"fps",fps)
		end
		if getElementData(getResourceRootElement(),"addAvgFpsToScoreboard") then
			setElementData(getLocalPlayer(),"avg fps",string.format("%.1f",avgFps))
		end

		-- Reset temporary variables
		updateFpsTime = getTickCount() + 500
		fpsCount = 0
	end

	-------------
	-- Drawing --
	-------------
	
	-- Only draw if fps have been recorded
	if maxFps == 0 then
		return
	end
	
	---------------------
	-- Prepare drawing --
	---------------------
	local fontSize = s("fontSize")
	local fontType = s("fontType")
	local fontHeight = dxGetFontHeight(fontSize,fontType)

	local fontColor = getColor("font")
	local backgroundColor = getColor("background")

	local seconds = s("seconds")
	
	-- Width and Height
	local x = screenWidth * s("left")
	local y = screenHeight * s("top")
	local width = screenWidth / 1680 * 240 * s("width")
	if width < totalTextWidth then
		width = totalTextWidth
	end
	local height = screenHeight / 1050 * 30 * s("height")
	if height < totalTextHeight then
		height = totalTextHeight
	end

	-- Draw small graph if enabled
	if s("lastMinuteEnabled") then
		drawGraph(x,y,width,height,seconds)
	end
	-- Draw fullscreen graph if enabled
	if s("fullEnabled") then
		drawGraph(screenWidth*0.1,screenHeight*0.4,screenWidth*0.8,screenHeight*0.2,currentSecond - firstSecond)
		dxDrawText(duration(currentSecond - firstSecond),screenWidth*0.1,screenHeight*0.6)
	end
	
	---------------
	-- Draw text --
	---------------
	local textX = x+4
	local textY = y+height-fontHeight

	--dxDrawText("FPS",x+4,y+2,x,y,tocolor(255,255,255,20),1.5)

	--if s("fpsTextEnabled") then
	--	dxDrawText("[FPS]",textX,textY,textX,textY,fontColor,fontSize,fontType)
	--	textX = textX + dxGetTextWidth("[FPS] ",fontSize,fontType)
	--end
	if s("currentEnabled") then
		dxDrawText("FPS: "..tostring(fps),textX,textY,textX,textY,fontColor,fontSize,fontType)
		textX = textX + dxGetTextWidth(" FPS: "..tostring(fps),fontSize,fontType)
	end
	if s("maxEnabled") then
		dxDrawText("Max: "..tostring(maxFps),textX,textY,textX,textY,fontColor,fontSize,fontType)
		textX  = textX + dxGetTextWidth(" Max: "..tostring(maxFps),fontSize,fontType)
	end
	if s("minEnabled") then
		dxDrawText("Min: "..tostring(minFps),textX,textY,textX,textY,fontColor,fontSize,fontType)
		textX  = textX + dxGetTextWidth(" Min: "..tostring(minFps),fontSize,fontType)
	end
	if s("avgEnabled") then
		dxDrawText("Avg: "..string.format("%.1f",avgFps),textX,textY,textX,textY,fontColor,fontSize,fontType)
		textX = textX + dxGetTextWidth(" Avg: "..string.format("%.1f",avgFps),fontSize,fontType)
	end

	totalTextWidth = textX - x
	totalTextHeight = fontHeight
end


--- Draw Graph
-- Draws the graph at the specified size and position.
--
-- @param   int   x: x position in pixels
-- @param   int   y: y position in pixels
-- @param   int   width: The width of the graph in pixels
-- @param   int   height: The height of the graph in pixels
-- @param   int   seconds: How many seconds to display
function drawGraph(x,y,width,height,seconds)
	local dataColor = getColor("data")
	local secondWidth = width / seconds
	local frameHeight = height / maxFps	

	--dxDrawText(tostring(width).." "..tostring(secondWidth),0,0)

	--[[
	-- Draw background
	dxDrawRectangle(x,y,width,height,tocolor(255,255,255,50))

	-- Draw actual data
	
		for i = 1,seconds,1 do
			local fpsValue = savedFps[currentSecond - i]
			--
			if fpsValue ~= nil then
				--outputChatBox(tostring(x + width - i*secondWidth))
				local fpsPixelHeight = math.floor(frameHeight * fpsValue)
				dxDrawRectangle(
					x + width - i*secondWidth,
					y + height - fpsPixelHeight,
					secondWidth,
					fpsPixelHeight,
					dataColor
				)
			end
		end
	]]
		dxDrawRectangle(x,y,width,height,getColor("background"))
		local atPixel = 0
		local fillPixel = 1
		-- Which fps value (which second) to use next
		local atSecond = 1
		-- How much of the current fps value was already used
		local currentValueUsed = 0
		local previousValue = 0
		-- Draw all pixels (until the whole width is filled)
		while atPixel < width do
			-- This is the actual fps value to draw (possibly calculated from several different values)
			local drawThisValue = 0
			while fillPixel > 0 do
				-- Get the fps value of the current second
				local fpsValue = savedFps[currentSecond - atSecond]
				-- If value is not yet set, leave the loop
				if fpsValue == nil then
					break
					-- TODO: maybe dont stop if just one second isnt available
				end
				--outputChatBox("fps drain :P")
				--outputChatBox(tostring(fpsValue))
				-- Calculate the theorectical width of this fps value 
				-- (depending on how much was used for the pixel(s) before, if anything)
				local leftSecondWidth = secondWidth - currentValueUsed
				-- If the space to be filled in this pixel is greater or equal to the
				-- space needed for this fps value (only greater before, but >= might save one
				-- loop execution, since currentValueUsed would be == secondWidth and
				-- leftSecondWidth == 0)
				if fillPixel >= leftSecondWidth then
					-- Test >= vs > thingy
					--if leftSecondWidth == 0 then
					--	outputChatBox("0")
					--end
					drawThisValue = drawThisValue + leftSecondWidth * fpsValue
					-- Advance one second (fps value) forward, since it is now fully used
					-- (it fits fully into the remaining space)
					atSecond = atSecond + 1
					-- Since the next second is used, reset this
					currentValueUsed = 0
					-- Increase pixel by the width used for this fps value
					atPixel = atPixel + leftSecondWidth
					-- Decrease pixel by the width used for this fps value
					fillPixel = fillPixel - leftSecondWidth
				else
					-- fillPixel is smaller to the space needed for this
					-- fps value, so use fillPixel as width
					drawThisValue = drawThisValue + fillPixel * fpsValue
					-- add the space used by this fps value to be already used
					currentValueUsed = currentValueUsed + fillPixel
					atPixel = atPixel + fillPixel
					-- This is 0 now of course
					fillPixel = fillPixel - fillPixel
				end
			end
			--outputChatBox(tostring(currentValueUsed))
			-- Leave the loop if pixel is not fully filled
			if fillPixel > 0 then
				break
			end
			-- atPixel should be dividable by 1 here
			local fpsPixelHeight = math.floor(drawThisValue * frameHeight)
			dxDrawRectangle(x + width - atPixel,y+height-fpsPixelHeight,1,fpsPixelHeight,getColor("data"))
			--if previousValue < fpsPixelHeight then
			--	local aaHeight = fpsPixelHeight - previousValue
				--dxDrawRectangle(x + width - atPixel + 1,y+height-fpsPixelHeight - 100,1,aaHeight,tocolor(255,0,255,255))
				--outputChatBox(tostring(aaHeight))
			--end
			previousValue = fpsPixelHeight
			fillPixel = 1
		end
	

		-- Draw average fps line
		local avgFpsPixelHeight = math.floor(avgFps * frameHeight)
		dxDrawRectangle(x,y + height - avgFpsPixelHeight,width,2,getColor("avgLine"))

		-- Draw min fps line
		local minFpsPixelHeight = math.floor(minFps * frameHeight)
		dxDrawRectangle(x,y + height - minFpsPixelHeight,width,2,getColor("minLine"))

		
end

------------------
-- Settings Gui --
------------------


local gui = {}

---
-- Handles the change of the value of a editbox (changes the settings accordingly).
--
-- @param   element   element: The gui element whose text was changed
local function handleEdit(element)
	for k,v in pairs(gui) do
		if element == v and settingsObject.settings.default[k] ~= nil then
			if type(settingsObject.settings.main[k]) == "boolean" then
				settingsObject:set(k,guiCheckBoxGetSelected(element))
			else
				settingsObject:set(k,guiGetText(element))
			end
		end
	end
end

---
-- Handles a single click on the GUI.
local function handleClick()

	handleEdit(source)

	if source == gui.buttonSave then
		settingsObject:saveToXml()
	end
	if source == gui.buttonClose then
		closeGui()
	end
	if source == gui.buttonReset then
		resetData()
	end
end

---
-- Adds a set of gui elements to change a color setting. Also adds help
-- to all elements.
local function addColor(color,name,top,help)
	local label = guiCreateLabel(24,top,80,20,name..":",false,gui.window)
	local defaultButton = {}
	gui[color.."Red"] = guiCreateEdit(120,top,50,20,tostring(s(color.."Red")),false,gui.window)
	table.insert(defaultButton,{mode="set",edit=gui[color.."Red"],value=s(color.."Red","default")})
	gui[color.."Green"] = guiCreateEdit(175,top,50,20,tostring(s(color.."Green")),false,gui.window)
	table.insert(defaultButton,{mode="set",edit=gui[color.."Green"],value=s(color.."Green","default")})
	gui[color.."Blue"] = guiCreateEdit(230,top,50,20,tostring(s(color.."Blue")),false,gui.window)
	table.insert(defaultButton,{mode="set",edit=gui[color.."Blue"],value=s(color.."Blue","default")})
	gui[color.."Alpha"] = guiCreateEdit(285,top,50,20,tostring(s(color.."Alpha")),false,gui.window)
	table.insert(defaultButton,{mode="set",edit=gui[color.."Alpha"],value=s(color.."Alpha","default")})
	addEditButton(350,top,50,20,"default",false,gui.window,unpack(defaultButton))
	if help ~= nil then
		addHelp(help,label,gui[color.."Red"],gui[color.."Green"],gui[color.."Blue"],gui[color.."Alpha"])
	end
end

---
-- Creates the GUI if it isn't already. Adds it to gamecenter if available.
function createGui()
	if gui.window ~= nil then
		return
	end

	-- GAMECENTER
	-- Check if "gamecenter" is running and if so, get a srcollpane to add the elements to,
	-- otherwise create a window.
	gamecenterResource = getResourceFromName("gamecenter")

	if gamecenterResource then
		gui.window = call(gamecenterResource,"addWindow","Settings","FPS Stats",500,560)
	else
		gui.window = guiCreateWindow ( 320, 240, 500, 560, "FPS Stats settings", false )
	end

	guiCreateLabel(24,24,40,20,"Enable:",false,gui.window)
	gui.enabled = guiCreateCheckBox(100,24,30,20,"All",s("enabled"),false,gui.window)
	addHelp("Shows or hides all enabled FPS Stats elements",gui.enabled)

	gui.currentEnabled = guiCreateCheckBox(160,24,90,20,"Current FPS",s("currentEnabled"),false,gui.window)
	addHelp("Shows or hides the display of the current FPS.",gui.currentEnabled)

	gui.maxEnabled = guiCreateCheckBox(250,24,40,20,"Max",s("maxEnabled"),false,gui.window)
	addHelp("Shows or hides the display of the maximum FPS.",gui.maxEnabled)

	gui.minEnabled = guiCreateCheckBox(295,24,40,20,"Min",s("minEnabled"),false,gui.window)
	addHelp("Shows or hides the display of the minimum FPS.",gui.minEnabled)

	gui.avgEnabled = guiCreateCheckBox(340,24,40,20,"Avg",s("avgEnabled"),false,gui.window)
	addHelp("Shows or hides the display of the average FPS.",gui.avgEnabled)

	gui.lastMinuteEnabled = guiCreateCheckBox(385,24,80,20,"Graph",s("lastMinuteEnabled"),false,gui.window)
	addHelp("Shows or hides the graph.",gui.lastMinuteEnabled)

	--gui.fpsTextEnabled = guiCreateCheckBox(440,24,40,20,"FPS",s("fpsTextEnabled"),false,gui.window)
	--addHelp("Shows or hides the \"[FPS]\" text in front",gui.fpsTextEnabled)

	gui.fullEnabled = guiCreateCheckBox(100,48,180,20,"Full screen graph (all data)",s("fullEnabled"),false,gui.window)
	addHelp("Shows or hides the fullscreen graph showing all recorded data at once (you can also use the /fps_stats_full command).",gui.fullEnabled)

	

	gui.buttonReset = guiCreateButton(300,48,80,20,"Reset data",false,gui.window)
	--addEventHandler("onClientGUIClick",gui.resetButton,resetData)
	addHelp("Resets all recorded FPS data (min, max, graph).",gui.buttonReset)

	local label = guiCreateLabel(24,80,70,20,"Width:",false,gui.window)
	gui.width = guiCreateEdit(100,80,80,20,tostring(s("width")),false,gui.window)
	addHelp("The width of the FPS Stats Graph (relative to screen resolution). This can never be smaller than needed as background for the text drawn ontop.",gui.width,label)
	addEditButton(190,80,60,20,"smaller",false,gui.window,{mode="add",edit=gui.width,add=-0.1})
	addEditButton(260,80,60,20,"bigger",false,gui.window,{mode="add",edit=gui.width,add=0.1})
	addEditButton(330,80,60,20,"default",false,gui.window,{mode="set",edit=gui.width,value=s("width","default")})

	local label = guiCreateLabel(24,110,70,20,"Height:",false,gui.window)
	gui.height = guiCreateEdit(100,110,80,20,tostring(s("height")),false,gui.window)
	addHelp("The height of the FPS Stats graph (relative to screen resolution).",gui.height,label)
	addEditButton(190,110,60,20,"smaller",false,gui.window,{mode="add",edit=gui.height,add=-0.1})
	addEditButton(260,110,60,20,"bigger",false,gui.window,{mode="add",edit=gui.height,add=0.1})
	addEditButton(330,110,60,20,"default",false,gui.window,{mode="set",edit=gui.height,value=s("height","default")})

	local label = guiCreateLabel(24,140,80,20,"Font size:",false,gui.window)
	gui.fontSize = guiCreateEdit(100,140,80,20,tostring(s("fontSize")),false,gui.window)
	addHelp("The size of the text.",gui.fontSize,label)
	addEditButton(190,140,60,20,"smaller",false,gui.window,{mode="add",edit=gui.fontSize,add=-0.1})
	addEditButton(260,140,60,20,"bigger",false,gui.window,{mode="add",edit=gui.fontSize,add=0.1})
	addEditButton(330,140,60,20,"default",false,gui.window,{mode="set",edit=gui.fontSize,value=s("fontSize","default")})

	local label = guiCreateLabel(24,170,80,20,"Font type:",false,gui.window)
	gui.fontType = guiCreateEdit(100,170,80,20,tostring(s("fontType")),false,gui.window)
	addHelp("Switch between the available font types.",gui.fontType,label)
	addEditButton(190,170,60,20,"<--",false,gui.window,{mode="cyclebackwards",edit=gui.fontType,values=fonts})
	addEditButton(260,170,60,20,"-->",false,gui.window,{mode="cycle",edit=gui.fontType,values=fonts})
	addEditButton(330,170,60,20,"default",false,gui.window,{mode="set",edit=gui.fontType,value=s("fontType","default")})

	guiCreateLabel(24, 196, 60, 20, "Position:", false, gui.window )

	local label = guiCreateLabel(100, 196, 40, 20, "Top:", false, gui.window )
	gui.top = guiCreateEdit( 140, 196, 60, 20, tostring(s("top")), false, gui.window )
	addHelp("The relative position of the FPS Stats graph from the top border of the screen. For example 0.5 means it is positioned in the middle of the screen.",gui.top,label)

	addEditButton(258, 196, 40, 20, "up", false, gui.window, {mode="add",edit=gui.top,add=-0.01})
	addEditButton(258, 220, 40, 20, "down", false, gui.window, {mode="add",edit=gui.top,add=0.01})
	
	local label = guiCreateLabel(100, 220, 40, 20, "Left:", false, gui.window )
	gui.left = guiCreateEdit( 140, 220, 60, 20, tostring(s("left")), false, gui.window )
	addHelp("The relative position of the FPS Stats graph from the left border of the screen. For example 0.5 means it is positioned in the middle of the screen.",gui.left,label)
	addEditButton(210, 220, 40, 20, "left", false, gui.window, {mode="add",edit=gui.left,add=-0.01})
	addEditButton( 306, 220, 40, 20, "right", false, gui.window, {mode="add",edit=gui.left,add=0.01})
	
	addEditButton(360, 220, 50, 20, "default", false, gui.window,
		{mode="set",edit=gui.top,value=s("top","default")},
		{mode="set",edit=gui.left,value=s("left","default")}
	)

	local label = guiCreateLabel(24,260,70,20,"Seconds:",false,gui.window)
	gui.seconds = guiCreateEdit(100,260,80,20,tostring(s("seconds")),false,gui.window)
	addHelp("The number of seconds to display on the FPS Stats graph.",gui.seconds,label)
	addEditButton(190,260,60,20,"smaller",false,gui.window,{mode="add",edit=gui.seconds,add=-10})
	addEditButton(260,260,60,20,"bigger",false,gui.window,{mode="add",edit=gui.seconds,add=10})
	addEditButton(330,260,60,20,"default",false,gui.window,{mode="set",edit=gui.seconds,value=s("seconds","default")})


	guiCreateLabel(125,296,40,20,"Red",false,gui.window)
	guiCreateLabel(180,296,40,20,"Green",false,gui.window)
	guiCreateLabel(235,296,40,20,"Blue",false,gui.window)
	guiCreateLabel(285,296,40,20,"Alpha",false,gui.window)

	addColor("dataColor","FPS data",320,"The color of the bars showing the fps.")
	addColor("fontColor","Font Color",343,"The color of the text.")
	addColor("backgroundColor","Background",366,"The color of the background of the graph.")
	addColor("avgLineColor","Avg FPS Line",389,"The color of the line denoting the average FPS.")
	addColor("minLineColor","Min FPS Line",412,"The color of the line denoting the minimum FPS.")

	

	-- Always visible
	gui.helpMemo = guiCreateMemo(0,440,500,80,"Move your mouse over a GUI Element to get help (if available).",false,gui.window)
	guiHelpMemo = gui.helpMemo

	gui.buttonSave = guiCreateButton( 160, 530, 50, 20, "Save", false, gui.window )
	addHelp("Saves the settings on your local computer in an XML file. This means that they will be saved even if you leave this server.",gui.buttonSave)
	gui.buttonClose = guiCreateButton( 240, 530, 50, 20, "Close", false, gui.window )
	addHelp("Closes without saving the settings to file. You changes will stay until you leave this server.",gui.buttonClose)

	-- GAMECENTER
	-- Don't show the window just yet, when added to gamecenter
	if gamecenterResource then
		guiSetEnabled(gui.buttonClose,false)
	else
		guiSetVisible(gui.window,false)
	end

	addEventHandler("onClientGUIClick",gui.window,handleClick)
	addEventHandler("onClientGUIChanged",gui.window,handleEdit)
	addEventHandler("onClientMouseEnter",gui.window,handleHelp)
end


---
-- As soon as the "gamecenter" resource is started, this will create the GUI
-- if it wasn't already (if it is created, it will also be added to the gamecenter gui).
addEventHandler("onClientResourceStart",getRootElement(),
	function(resource)
		if getResourceName(resource) == "gamecenter" then
			-- Create the GUI as soon as the gamecenter-resource starts (if it hasn't been created yet)
			createGui()
			--recreateGui()
		elseif resource == getThisResource() then
			if getResourceFromName("gamecenter") then
				createGui()
			end
		end
	end
)

---
-- Opens the GUI and also creates it if necessary.
function openGui()
	createGui()

	if gamecenterResource then
		exports.gamecenter:open("Settings","FPS Stats")
	else
		guiSetVisible(gui.window,true)
		showCursor(true)
	end
end

---
-- Closes the GUI
function closeGui()
	if gamecenterResource then
		exports.gamecenter:close()
	else
		guiSetVisible(gui.window,false)
		showCursor(false)
	end
end

---
-- Shows/hides the GUI depending on the current state.
function toggleGui()
	if guiGetVisible(gui.window) then
		closeGui()
	else
		openGui()
	end
end
addCommandHandler("fps_stats",toggleGui)


---
-- Shows or hides the fullscreen graph
function toggleFullDisplay()
	if s("fullEnabled") then
		settingsObject:set("fullEnabled",false)
	else
		settingsObject:set("fullEnabled",true)
	end
end
addCommandHandler("fps_stats_full",toggleFullDisplay)
