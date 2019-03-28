local screenWidth, screenHeight = guiGetScreenSize()
local dxProgressBars = {}

function dxProgressBar(x,y, width,height, bgColor, fgColor, parent)
	local obj = {
	x = x,
	y = y,
	width = width,
	height = height,
	bgColor = bgColor,
	fgColor = fgColor,
	parent = parent,
	progress = 1.0,
	}
	
	obj.bgColor[4] = obj.bgColor[4]*guiGetAlpha(parent)
	obj.fgColor[4] = obj.fgColor[4]*guiGetAlpha(parent)
	table.insert(dxProgressBars, obj)
	return obj
end

addEventHandler("onClientRender", root,
	function ()
		for i, bar in ipairs(dxProgressBars) do
			if guiGetVisible(bar.parent) then
				local x,y = guiGetPosition(bar.parent, true)
				local w,h = guiGetSize(bar.parent, true)
				local posX,posY = screenWidth*(x+bar.x), screenHeight*(y+bar.y)
				local sizX,sizY = screenWidth*(w*bar.width), screenHeight*(h*bar.height)
				
				local bgColor = tocolor(bar.bgColor[1],bar.bgColor[2],bar.bgColor[3],bar.bgColor[4])
				local fgColor = tocolor(bar.fgColor[1],bar.fgColor[2],bar.fgColor[3],bar.fgColor[4])
				
				dxDrawRectangle(posX, posY, sizX, sizY, bgColor, true)
				dxDrawRectangle(posX+2, posY+2, (sizX-4)*bar.progress, sizY-4, fgColor, true)
			end
		end
	end
)
