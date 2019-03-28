local ss

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion ().sortable < "1.1.0" then
			outputChatBox("Resource is not compatible with this client.")
			return
		end
		
		local myShader, tec = dxCreateShader("car_paint.fx")
		ss = dxCreateScreenSource(50, 50)
		
		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )
			
			-- Set textures
			dxUpdateScreenSource(ss)
			dxSetShaderValue(myShader, "reflection_Tex", ss)
			
			-- Apply to world texture
			engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
		end
	end
)

addEventHandler("onClientRender", root,
	function ()
		if ss then
			dxUpdateScreenSource(ss)
		end
	end
)
