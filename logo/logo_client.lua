local width, height = guiGetScreenSize()
local showing = false
local d = height/24
local size = 0

local logoText = "West Coast Gaming"
local logoSize = 1.75
local logoFont = "pricedown"

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		showing = true
		logoFont = exports["fonts"]:getDxFont("UNCONB___.ttf", 24)
	end
)

addEvent("showLogo", true)
addEventHandler("showLogo", root,
	function ()
		showing = true
	end
)

addEvent("hideLogo", true)
addEventHandler("hideLogo", root,
	function ()
		showing = false
	end
)

addEventHandler("onClientRender", root,
	function ()
		if size > 0 then
			local textWidth = dxGetTextWidth(logoText, logoSize, logoFont)/2
			local x = (width/2)-textWidth
			local y = (height-size)
			local c = tocolor(0,0,0,clamp(size*2, 0, 255))
			
			dxDrawRectangle(0,0, width,size, c, false)
			dxDrawRectangle(0,height-size, width,height, c, false)
			dxDrawText(logoText, x,y, x,y, tocolor(255,255,255,128), logoSize, logoFont)
			dxDrawText(logoText, x+math.random(2)-1,y+math.random(2)-1, x,y, tocolor(255,255,255,128), logoSize, logoFont)
			dxDrawText(logoText, x+math.random(6)-3,y+math.random(6)-3, x,y, tocolor(255,255,255,64), logoSize, logoFont)
		end
		
		if showing then
			showBars()
		else
			hideBars()
		end
	end
)

function showBars()
	if size < height/4 then
		size = size+d
		d = math.abs(d-1)
	else
		size = height/4
	end
end

function hideBars()
	if size > 0 then
		size = size-d
		d = math.abs(d+1)
	else
		size = 0
	end
end

function clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max
	end
	
	return num
end