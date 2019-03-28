local localPlayer = getLocalPlayer()
local font = "bankgothic"
--local font = exports["fonts"]:getDxFont("UNCON___.ttf", 16)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local cx,cy,cz = getCameraMatrix()
		
		for i, player in ipairs(getElementsByType("player")) do
			if isPlayerNametagShowing(player) then
				setPlayerNametagShowing(player, false)
			end
			
			if isElementOnScreen(player) and player ~= localPlayer then
--				local px,py,pz = getPedBonePosition(player, 8)
--				pz = pz+0.6
				local px,py,pz = getElementPosition(player)
				pz = pz+0.5
				if isLineOfSightClear(cx,cy,cz, px,py,pz, true, false, false, true, true, false, false) then
					local x, y = getScreenFromWorldPosition(px,py,pz, 0)
					if x and y then
						local dist = getDistanceBetweenPoints3D(cx,cy,cz, px,py,pz)
						local r,g,b = getPlayerNametagColor(player)
						local playerName = getPlayerName(player)
						local scale = math.max(4/dist, 0.3)
						dxDrawText(playerName, x-4,y-4, x+8,y+8, tocolor(0,0,0,192), scale, font, "center", "center")
						dxDrawText(playerName, x,y, x,y, tocolor(r,g,b,192), scale, font, "center", "center")
						
						local health = 50*(getElementHealth(player)*0.01)
						local scale100 = 100*scale
						local hx,hy = x-(scale100/2), y+(15*scale)
						local hw,hh = health*scale, 5*scale
						health = math.min(255*(health*0.01), 255)
						dxDrawRectangle(hx-2,hy-2, (scale100)+4,hh+4, tocolor(0,0,0,128))
						dxDrawRectangle(hx,hy, hw,hh, tocolor(255-health,health, 0,128))
						
						local armor = getPedArmor(player)
						if armor > 0 then
							local hx,hy = x-(scale100/2), y+(24*scale)
							local hw,hh = armor*scale, 5*scale
							dxDrawRectangle(hx-2,hy-2, (scale100)+4,hh+4, tocolor(0,0,0,128))
							dxDrawRectangle(hx,hy, hw,hh, tocolor(255,255,255,128))
						end
						
						local wantedLevel = getElementData(player, "wantedLevel") or 0
						scale = math.max(64/(dist), 4)
						x = x+(wantedLevel*scale)/4
						hy = hy-4
						for i=1, wantedLevel do
							local iscale = i/2*scale
							dxDrawImage(x-iscale-3,hy+scale-3, scale+6,scale+6, "star.png", 0,0,0, tocolor(0,0,0,192))
							dxDrawImage(x-iscale,hy+scale, scale,scale, "star.png", 0,0,0, tocolor(192,128,0,192))
						end
					end
				end
			end
		end
	end
)
