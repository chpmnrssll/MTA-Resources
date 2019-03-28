local myShader
local rt

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end
		
		myShader, tec = dxCreateShader ( "shader_test.fx" )
		
		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )
			
			engineApplyShaderToWorldTexture ( myShader, "*" )
			--[[
			local modelID = getElementModel ( getLocalPlayer() )
			for _,texname in ipairs( engineGetModelTextureNames ( modelID ) ) do
				engineApplyShaderToWorldTexture ( myShader, texname )
			end
			]]
			rt = dxCreateScreenSource(800,600)
		end
	end
)

addEventHandler( "onClientRender", root,
	function ()
		
		if rt then
			--dxUpdateScreenSource(rt)
			--dxSetShaderValue( myShader, "Tex0", rt )
        end
	end
)
