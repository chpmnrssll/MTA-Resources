addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		shader = dxCreateShader("fog.fx")
		engineApplyShaderToWorldTexture(shader, "*")
		
		setFogStart(-50)
		setFogEnd(1000)
		setBlurLevel(0)
	end
)

function setFogStart(dist)
	dxSetShaderValue(shader, "fogStart", dist)
end

function setFogEnd(dist)
	dxSetShaderValue(shader, "fogEnd", dist)
end
