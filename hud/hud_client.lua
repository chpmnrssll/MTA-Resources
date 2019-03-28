local localPlayer = getLocalPlayer()
local width, height = guiGetScreenSize()
local showing = true

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		showPlayerHudComponent("clock", false)
		showPlayerHudComponent("money", false)
		--showPlayerHudComponent("all", false)
	end
)

function toggle(playerSource, commandName)
	if showing then
		showPlayerHudComponent("ammo", false)
		showPlayerHudComponent("area_name", false)
		showPlayerHudComponent("armour", false)
		showPlayerHudComponent("breath", false)
		showPlayerHudComponent("health", false)
		showPlayerHudComponent("vehicle_name", false)
		showPlayerHudComponent("weapon", false)
		--showPlayerHudComponent("radio", false)
		showPlayerHudComponent("radar", false)
		showPlayerHudComponent("wanted", false)
		showPlayerHudComponent("crosshair", false)
		outputChatBox("Hiding HUD")
	else
		showPlayerHudComponent("ammo", true)
		showPlayerHudComponent("area_name", true)
		showPlayerHudComponent("armour", true)
		showPlayerHudComponent("breath", true)
		showPlayerHudComponent("health", true)
		showPlayerHudComponent("vehicle_name", true)
		showPlayerHudComponent("weapon", true)
		--showPlayerHudComponent("radio", true)
		showPlayerHudComponent("radar", true)
		showPlayerHudComponent("wanted", true)
		showPlayerHudComponent("crosshair", true)
		outputChatBox("Showing HUD")
	end
end
addCommandHandler("hud", toggle, false)
--[[
addEventHandler("onClientPreRender", getRootElement(),
	function ()
		if not isPlayerMapVisible() then
			local posX, posY = 0.935*width, 0.075*height
			local hour, minute = getTime()
			local meridiem = "AM"
			if hour > 12 then
				meridiem = "PM"
				hour = hour-12
			elseif hour < 1 then
				hour = 12
			end
			if minute < 10 then
				minute = "0"..minute
			end
			local tw = dxGetTextWidth(tostring(hour..":"..minute))/1.7
			dxDrawTextOutlined(hour..":"..minute, posX,posY, posX,posY, 192,192,192,255, 1.3, "pricedown", "right", "center", false, true)
			dxDrawTextOutlined(meridiem, posX+tw,posY, posX+tw,posY, 192,192,192,255, 0.5, "pricedown", "right", "top", false, true)
			
			local posX, posY = 0.95*width, 0.225*height
			if getPlayerMoney(localPlayer) < 0 then
				dxDrawTextOutlined("$"..(getPlayerMoney(localPlayer) or 0), posX,posY, posX,posY, 128,0,0,255, 1.2, "pricedown", "right", "center", false, true)
			else
				dxDrawTextOutlined("$"..(getPlayerMoney(localPlayer) or 0), posX,posY, posX,posY, 48,96,48,255, 1.2, "pricedown", "right", "center", false, true)
			end
		end
		
	end
)
]]
function dxDrawTextOutlined(text, posX,posY, sizeX,sizeY, r,g,b,a, scale, font, alignX, alignY, clip, postGUI)
	local s = scale*2
	dxDrawText(text, posX-s,posY-s, sizeX-s,sizeY-s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+s,posY-s, sizeX+s,sizeY-s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX-s,posY+s, sizeX-s,sizeY+s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+s,posY+s, sizeX+s,sizeY+s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	
	dxDrawText(text, posX,posY, sizeX,sizeY, tocolor(r,g,b,a), scale, font, alignX, alignY, clip, postGUI)
end
