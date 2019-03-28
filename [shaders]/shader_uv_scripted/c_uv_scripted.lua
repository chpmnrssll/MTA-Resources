local shader, texture, buffer, buffer2
local startTickCount
local width,height = 256,256
local sw,sh = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		shader, tec = dxCreateShader("uv_scripted.fx")
		
		--texture = dxCreateTexture("images/new.bmp")
		--dxSetShaderValue(shader, "CUSTOMTEX0", texture)
		
		buffer = dxCreateRenderTarget(width, height, true)
		buffer2 = dxCreateRenderTarget(width, height, true)
		
		if not shader then
			outputChatBox("Could not create shader. Please use debugscript 3")
		else
		outputChatBox("Using technique " .. tec)
		
		-- Apply to world texture
		--engineApplyShaderToWorldTexture(shader, "cos_hiwaymid_256")
		engineApplyShaderToWorldTexture(shader, "des_sheriffsign")
		engineApplyShaderToWorldTexture(shader, "blade92body256a")
		engineApplyShaderToWorldTexture(shader, "savanna92body256a")
		--engineApplyShaderToWorldTexture(shader, "*")
		
		-- Begin updates for UV animation
		startTickCount = getTickCount()
		addEventHandler("onClientRender", root, update)
		end
	end
)

local frameCounter = 1
function update()
	if not isElement( shader ) then return end	-- Valide shader to save bazillions of warnings
	
	local timeElapsed = (getTickCount() - startTickCount)
	local u,v = 0,-(timeElapsed / 20000)
	local y = (timeElapsed*1000) % height
	
	dxSetRenderTarget(buffer, false)
	dxDrawRectangle(0,0, width,height, tocolor(0,0,0,16))
	
	for i=1,8 do
		dxDrawImageSection(math.sin(timeElapsed/i)*0.2,-1, width,height, 0,0, width,height, buffer, 0,0,0, tocolor(255,255-i,255-(i*2),255))
	end
	
	--[[
	for i=0,width/6 do
		if math.random() > 0.98 then
			local digit = math.floor(math.random()*255)
			digit = string.char(digit)
			for k=1, 16 do
				dxDrawText(digit, i*6,(frameCounter*6)%height, 0,0, tocolor(255,192,128,255), 0.3, "bankgothic", "left", "top", false, true)
			end
		end
	end
	]]
	
	for i=0,width do
		if math.random() > 0.8 then
			local s = math.random()
			dxDrawRectangle(i,height-1, s*16,1, tocolor(s*255,s*192,s*192,s*255))
		end
	end
	
	--buffer2 = buffer
	dxSetRenderTarget()
	
	--dxDrawRectangle(0,0, sw,sh, tocolor(0,0,0,255))
	--dxDrawImage(0,0, sw,sh, buffer, 0,0,0)
	
	-- Apply uv anims
	--dxSetShaderValue(shader, "gUVPosition", u,v)
	--dxSetShaderValue(shader, "gUVScale", 2)
	dxSetShaderValue(shader, "gUVRotAngle", -1.57)
	dxSetShaderValue(shader, "CUSTOMTEX0", buffer)
	
	frameCounter = (frameCounter + 1) % height
end
