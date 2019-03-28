-- Settings variables
local textFont       = "default-bold"						-- The font of the tag text
local textScale      = 1									-- The scale of the tag text
local fontHeight     = dxGetFontHeight(textScale,textFont)	-- The height of the font
local heightPadding  = 1									-- The amount of pixels the tag should be extended on either side of the vertical axis
local widthPadding   = 1									-- The amount of pixels the tag should be extended on either side of the horizontal axis
local xOffset        = 8									-- Horizontal distance between the player blip and the tag
local yOffset        = fontHeight/2							-- Vertical distance between the player blip and the top of the tag
local minAlpha       = 10									-- If blip alpha falls below this, the tag won't the shown
local textAlpha      = 255
local rectangleColor = tocolor(0,0,0,230)

local function drawMapNames()
	if exports.maximap:isPlayerMapVisible() then
		for k,v in ipairs(getElementsByType("blip")) do
			local attached=getElementAttachedTo(v)
			
			if isElement(attached) and getElementType(attached)=="player" then
				
				local px,py      = getElementPosition(attached)						-- Player's position
				local x,y        = exports.maximap:getMapFromWorldPosition(px,py)	-- Get the blip position on the map
				x                = x+xOffset										-- X for the nametag
				y                = y-yOffset										-- Y for the nametag
				local pname      = getPlayerName(attached)							-- Player name
				local nameLength = dxGetTextWidth(pname,textScale,textFont)			-- Width of the playername
				local r,g,b      = getPlayerNametagColor(attached)					-- Player's nametag color
				local _,_,_,a    = getBlipColor(v)									-- Blip alpha
				
				if a>minAlpha then
					
					dxDrawRectangle(x-widthPadding,y+heightPadding,nameLength+widthPadding*2,fontHeight-heightPadding*2,rectangleColor,false)
					dxDrawText(pname,x,y,x+nameLength,y+fontHeight,tocolor(r,g,b,textAlpha),textScale,textFont,"left","top",false,false,false)
					
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),drawMapNames)