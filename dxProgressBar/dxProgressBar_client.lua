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
	visible = true
	}
	
	if parent then
		local alpha = guiGetAlpha(parent)
		obj.bgColor[4] = obj.bgColor[4]*alpha
		obj.fgColor[4] = obj.fgColor[4]*alpha
	end
	
	table.insert(dxProgressBars, obj)
	return obj
end

addEventHandler("onClientRender", root,
	function ()
		for i, bar in ipairs(dxProgressBars) do
			if bar.visible then
				local posX,posY,sizX,sizY
				if isElement(bar.parent) and guiGetVisible(bar.parent) then
					local x,y = guiGetPosition(bar.parent, true)
					local w,h = guiGetSize(bar.parent, true)
					posX,posY = screenWidth*(x+bar.x), screenHeight*(y+bar.y)
					sizX,sizY = screenWidth*(w*bar.width), screenHeight*(h*bar.height)
				elseif bar.parent == root then
					posX,posY = screenWidth*bar.x, screenHeight*bar.y
					sizX,sizY = screenWidth*bar.width, screenHeight*bar.height
				elseif not isElement(bar.parent) then
					table.remove(dxProgressBars, i)
				end
				
				local bgColor = tocolor(bar.bgColor[1],bar.bgColor[2],bar.bgColor[3],bar.bgColor[4])
				local fgColor = tocolor(bar.fgColor[1],bar.fgColor[2],bar.fgColor[3],bar.fgColor[4])
				if posX and posY and sizX and sizY then
					dxDrawRectangle(posX, posY, sizX, sizY, bgColor, true)
					dxDrawRectangle(posX+2, posY+2, (sizX-4)*bar.progress, sizY-4, fgColor, true)
				end
			end
		end
	end
)
