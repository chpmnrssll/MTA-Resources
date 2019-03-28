local shader, tec = dxCreateShader("shine.fx")

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if shader then
			outputChatBox("Darkness falls upon the land.")
			dxSetShaderValue(shader, "gLightAmount", 16)
			engineApplyShaderToWorldTexture(shader, "*")
		end
	end
)

addEventHandler("onClientRender", root,
	function ()
		local cx,cy,cz, tx,ty,tz = getCameraMatrix()
		dxSetShaderValue(shader, "gLightPos", cx,cy,cz)
	end
)
