local scx, scy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		-- Version check
		if getVersion().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end
		
		cam = dxCreateScreenSource(scx, scy)
		scr = dxCreateScreenSource(scx, scy)
	end
)

local cx,cy,cz,tx,ty,tz
local frames = 0

addEventHandler("onClientPreRender", root,
	function()
		if cam and scr then
			if frames == 1 then
				frames = 0
				setCameraMatrix(cx,cy,cz,tx,ty,tz)
				setCameraTarget(localPlayer)
				dxUpdateScreenSource(cam)
			else
				cx,cy,cz,tx,ty,tz = getCameraMatrix()
				setCameraMatrix(1525,-1674,14, 1552,-1675, 17)
				dxUpdateScreenSource(scr)
				frames = 1
			end
        end
    end
)

addEventHandler("onClientRender", root,
	function()
		if cam then
			dxDrawImage(0, 0, scx, scy, scr)
			dxDrawImage(0, scy/4, scx/2, scy/2, cam)
		end
	end
)
