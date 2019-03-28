--
-- c_ped_morph.lua
--

local myShader
local size = 0

addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end

		-- Create shader
		myShader, tec = dxCreateShader ( "ped_morph.fx" )

		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )

			-- Get current ped model
			local modelID = getElementModel ( getLocalPlayer() )

			-- Apply shader to ped skin
			for _,texname in ipairs( engineGetModelTextureNames ( modelID ) ) do
				engineApplyShaderToWorldTexture ( myShader, texname )
			end

			outputChatBox( "Press 'k' and 'l' to change size" )
		end
	end
)


----------------------------------------------------------------
-- Do change
----------------------------------------------------------------
function changeSize(key, state, dir)
	size = size + 0.005 * dir
	dxSetShaderValue( myShader, "gMorphSize", size, size, size )
end

bindKey("k", "down", changeSize, -1 )
bindKey("l", "down", changeSize, 1 )
