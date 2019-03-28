local width, height = guiGetScreenSize()
local buffer = {}
local current = 1
local MAX = 4
local counter = 1

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for i=1, MAX do
			buffer[i] = {}
			buffer[i].screen = dxCreateScreenSource(width/2, height/2)
			buffer[i].life = MAX
			outputDebugString("Start")
		end
	end
)
addEventHandler("onClientRender", root,
	function ()
	
		dxUpdateScreenSource(buffer[counter].screen)
		buffer[counter].life = 32
		
		for i=1, MAX do
			if buffer[i].life > 0 then
				buffer[i].life = buffer[i].life-1
			end
			
			dxDrawImage(0,0, width,height, buffer[i].screen, 0,0,0, tocolor(255,255,255,buffer[i].life))	--8*(MAX-i)
		end
		
		if counter < MAX then
			counter = counter+1
		else
			counter = 1
		end
		
	end
)
