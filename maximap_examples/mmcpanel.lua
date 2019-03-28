local sw,sh=guiGetScreenSize()
local scrollRedPos,scrollGreenPos,scrollBluePos,scrollAlphaPos
local defaultImage="images/radar.jpg"

function createCPanel()	-- Create a small GUI, for managing the maximap
	window         = guiCreateWindow(sw-125,0,125,330,"Control panel",false)
	labelImage     = guiCreateLabel(10,20,115,20,"Image adjustment",false,window)
	radioRadar     = guiCreateRadioButton(0,40,100,20,"Radar",false,window)
	radioSattelite = guiCreateRadioButton(0,60,100,20,"Sattelite",false,window)
	labelSepr1     = guiCreateLabel(10,80,125,20,"-------------------------------------",false,window)
	labelColor     = guiCreateLabel(10,100,115,20,"Color adjustment",false,window)
	scrollRed      = guiCreateScrollBar(0,120,125,10,true,false,window)
	scrollGreen    = guiCreateScrollBar(0,130,125,10,true,false,window)
	scrollBlue     = guiCreateScrollBar(0,140,125,10,true,false,window)
	scrollAlpha    = guiCreateScrollBar(0,150,125,10,true,false,window)
	labelSepr2     = guiCreateLabel(10,160,125,20,"-------------------------------------",false,window)
	labelProp      = guiCreateLabel(10,180,115,20,"Property adjustment",false,window)
	editMovement   = guiCreateEdit(75,200,50,20,"5",false,window)
	editZoom       = guiCreateEdit(75,220,50,20,"1",false,window)
	editZoomRate   = guiCreateEdit(75,240,50,20,"0.1",false,window)
	editMinZoom    = guiCreateEdit(75,260,50,20,"1",false,window)
	editMaxZoom    = guiCreateEdit(75,280,50,20,"5",false,window)
	labelMovement  = guiCreateLabel(10,200,65,20,"Mov speed",false,window)
	labelZoom      = guiCreateLabel(10,220,65,20,"Zoom",false,window)
	labelZoomRate  = guiCreateLabel(10,240,65,20,"Zoom rate",false,window)
	labelMinZoom   = guiCreateLabel(10,260,65,20,"Min zoom",false,window)
	labelMaxZoom   = guiCreateLabel(10,280,65,20,"Max zoom",false,window)
	btnAccept      = guiCreateButton(0,300,125,20,"Accept",false,window)
	
	guiSetFont(labelImage,"default-bold-small")
	guiSetFont(labelColor,"default-bold-small")
	guiSetFont(labelProp,"default-bold-small")
	
	local r,g,b,a = exports.maximap:getPlayerMapColor() -- Get the current player map color so we can update our scrollbar with this
	
	scrollRedPos   = r/2.55
	scrollGreenPos = g/2.55
	scrollBluePos  = b/2.55
	scrollAlphaPos = a/2.55
	
	guiScrollBarSetScrollPosition(scrollRed,scrollRedPos)
	guiScrollBarSetScrollPosition(scrollGreen,scrollGreenPos)
	guiScrollBarSetScrollPosition(scrollBlue,scrollBluePos)
	guiScrollBarSetScrollPosition(scrollAlpha,scrollAlphaPos)
	
	guiRadioButtonSetSelected(radioRadar,exports.maximap:getPlayerMapImage()==defaultImage)  -- Make it clear that "Radar" is the default option by automatically highlighting it, if default image is showing
	
	local mapVisible=exports.maximap:isPlayerMapVisible()
	guiSetVisible(window,mapVisible) -- Make sure the window is visible in case the map is opened, and invisible if the map isn't opened
	showCursor(mapVisible,false) -- Same counts for our little mechanical cheese eater
	
	addEventHandler("onClientGUIClick",radioRadar,toggleMap,false)
	addEventHandler("onClientGUIClick",radioSattelite,toggleMap,false)
	addEventHandler("onClientGUIClick",btnAccept,changeParameters,false)
end
addEventHandler("onClientResourceStart",getResourceRootElement(),createCPanel)

function toggleCPanel(toggledByScript) -- This function toggles the control panel, accordingly to opening/closing the maximap
	if not toggledByScript then
		setFPSTimer(continueToggleCPanel,1,1) -- Delay the function for 1 frame, to make sure that if the event is cancelled by another script, we're aware of it
	else
		continueToggleCPanel() -- Since if it's toggled by script it can't be cancelled, let's not delay it that precious frame!
	end
end
addEventHandler("onClientPlayerMapShow",getRootElement(),toggleCPanel)
addEventHandler("onClientPlayerMapHide",getRootElement(),toggleCPanel)

function continueToggleCPanel()
	local toggle=exports.maximap:isPlayerMapVisible() -- See if the maximap is visible
	guiSetVisible(window,toggle) -- Show/hide the control panel accordingly
	showCursor(toggle,false) -- Same for our cursor
	
	if toggle then -- If the maximap is visible
		addEventHandler("onClientRender",getRootElement(),onRenderFunctions) -- Make sure our functions that need to be executed onRender are executed
	else
		removeEventHandler("onClientRender",getRootElement(),onRenderFunctions) -- Otherwise, make sure they're not
	end
end

function toggleMap()
	local sattelite=guiRadioButtonGetSelected(radioSattelite) -- Check if the "Sattelite" option has been selected
	if sattelite then -- If so
		exports.maximap:setPlayerMapImage("images/sattelite.jpg",-3000,3000,3000,-3000) -- Change the image to our glorious, pretty high definition (1 pixel/2 meter) sattelite image!
	else -- Otherwise
		exports.maximap:setPlayerMapImage() -- Change back to the lame, standard, low as the highest point of the Netherlands definition image... boo...
	end
end

function onRenderFunctions()
	changeColor() -- Check for a color change
end

function changeColor()
	local srP=guiScrollBarGetScrollPosition(scrollRed)  -- Get the scrollbar data
	local sgP=guiScrollBarGetScrollPosition(scrollGreen)
	local sbP=guiScrollBarGetScrollPosition(scrollBlue)
	local saP=guiScrollBarGetScrollPosition(scrollAlpha)
	if srP~=scrollRedPos or sgP~=scrollGreenPos or sbP~=scrollBluePos or saP~=scrollAlphaPos then -- If something's changed in comparison with last frame then
		exports.maximap:setPlayerMapColor(srP*2.55,sgP*2.55,sbP*2.55,saP*2.55) -- Set the map color accordingly
		scrollRedPos,scrollGreenPos,scrollBluePos,scrollAlphaPos=srP,sgP,sbP,saP -- Save the new positions so it doesn't change the color to the same all the time
	end
end

function changeParameters()  -- This function should be veeeeery obvious so I'll just shut my trap
	local newMovSpeed=tonumber(guiGetText(editMovement))
	local newZoom=tonumber(guiGetText(editZoom))
	local newZoomRate=tonumber(guiGetText(editZoomRate))
	local newMinZoom=tonumber(guiGetText(editMinZoom))
	local newMaxZoom=tonumber(guiGetText(editMaxZoom))
	
	if newMovSpeed then
		exports.maximap:setPlayerMapMovementSpeed(newMovSpeed)
	end
	
	if newZoom then
		exports.maximap:setPlayerMapZoomFactor(newZoom)
	end
	
	if newZoomRate then
		exports.maximap:setPlayerMapZoomRate(newZoomRate)
	end
	
	if newMinZoom then
		exports.maximap:setPlayerMapMinZoomLimit(newMinZoom)
	end
	
	if newMaxZoom then
		exports.maximap:setPlayerMapMaxZoomLimit(newMaxZoom)
	end
end