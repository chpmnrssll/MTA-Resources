--
-- c_roadshine.lua
--


addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end

		-- Create shader
		local shader, tec = dxCreateShader ( "roadshine.fx" )

		if not shader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )

			-- Apply shader to all world textures
			engineApplyShaderToWorldTexture ( shader, "*" )
		end
	end
)
