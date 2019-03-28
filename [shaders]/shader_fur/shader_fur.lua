addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion().sortable < "1.1.0" then
			outputDebugString("Resource is not compatible with this client.")
			return
		end
		
		shader, tec = dxCreateShader("shader_fur.fx")
		
		if not shader then
			outputDebugString("Could not create shader.")
		else
			outputDebugString("Using technique " .. tec)
			
			--Apply shader to all world textures
			--engineApplyShaderToWorldTexture(shader, "*")
			engineApplyShaderToWorldTexture(shader, "*")
			
			
		end
	end
)
