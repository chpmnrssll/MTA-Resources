local localPlayer = getLocalPlayer()
local width, height = guiGetScreenSize()
local w,h = width/2, height/2
local maxNumRows = 4
local maxDarkPolys = 16
local buttonWidth = 0.07
local buttonHeight = 0.11
local buttonRelWidth = width*buttonWidth
local buttonRelHeight = height*buttonHeight
local background = {}
local buttonList = {}
local cancelCol = nil
local shopType = nil

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for i, shop in ipairs(getElementsByType("shop", resourceRoot)) do
			local type = getElementData(shop, "type")
			local icon = 0
			local size = 1
			
			if type == "BurgerShot" then
				icon = 10
			elseif type == "Cluckin' Bell" then
				icon = 14
			elseif type == "The Well Stacked Pizza Co." then
				icon = 29
			elseif type == "DonutShop" then
				icon = 0
			elseif type == "Ammu-Nation" then
				icon = 6
			elseif type == "Bank" then
				icon = 52
			end
			if getElementData(shop, "posX") then
				createBlip(getElementData(shop, "posX"),getElementData(shop, "posY"),getElementData(shop, "posZ"), icon, size, 255,255,255,255, 0, 255)
			end
		end
		
		for i, marker in ipairs(getElementsByType("marker", resourceRoot)) do
			col = createColSphere(getElementData(marker, "posX"), getElementData(marker, "posY"), getElementData(marker, "posZ")+1, getElementData(marker, "size"))
			setElementDimension(col, getElementDimension(marker))
			setElementData(col, "marker", marker, false)
			addEventHandler("onClientColShapeHit", col, shopStart)
		end
--		local button = guiCreateButton(0.778, 0.054, 0.07, 0.11, "Weapon", true)
--		guiSetAlpha(button, 0.5)
	end
)

function shopStart(hitElement, matchingDimension)
	if hitElement == localPlayer and matchingDimension then
		local marker = getElementData(source, "marker")
		local shop = getElementParent(marker)
		local list = getElementByID(getElementData(shop, "type"))
		local mx,my,mz = getElementPosition(marker)
		local px,py,pz = getElementPosition(marker)
		local cx,cy,cz,tx,ty,tz = getCameraMatrix()
		setCameraMatrix(cx,cy,cz,tx,ty,tz)
		
		shopType = getElementData(shop, "type")
		cancelCol = source
		removeEventHandler("onClientColShapeHit", source, shopStart)
		toggleAllControls(false, true, false)
		setTimer(setElementPosition, 50, 1, localPlayer, mx,my,mz+0.5)
		--setTimer(setPedRotation, 50, 1, localPlayer, findRotation(mx,my, px,py))
		setTimer(showCursor, 50, 1, true)
		--setTimer(createBackground, 100, 1)
		setSkyGradient(16,16,16, 0,0,0)
		exports["fog"]:setFogEnd(7)
		setTimer(createButtonList, 150, 1, list)
		
		if shopType == "Bank" then
			amountGridList = guiCreateGridList(0.4, 0.6, 0.2, 0.09, true, getRootElement())
			guiSetAlpha(amountGridList, 0.8)
			guiSetVisible(amountGridList, false)
			guiGridListAddColumn(amountGridList, "Amount", 0.9)
			
			amountEdit = guiCreateEdit(0.01, 0.4, 0.975, 0.55, "", true, amountGridList)
			guiSetVisible(amountEdit, false)
			
			addEventHandler("onClientGUIAccepted", amountEdit,
				function ()
					local amount = tonumber(guiGetText(amountEdit))
					local action = getElementData(amountEdit, "action")
					
					if amount then
						if action == "Deposit" and amount > 0 and amount <= getPlayerMoney(localPlayer) then
							triggerServerEvent("depositMoney", localPlayer, amount)
						elseif action == "Withdraw" and amount > 0 and amount <= getElementData(localPlayer, "bankBalance") then
							triggerServerEvent("withdrawMoney", localPlayer, amount)
						end
					end
					
					guiSetVisible(amountEdit, false)
					guiSetVisible(amountGridList, false)
					guiSetText(amountEdit, "")
				end
			)
		end
	end
end

function createButtonList(list)
	local items = getElementsByType("item", list)
	local numColumns = math.ceil(#items/maxNumRows)
	local numRows = #items/numColumns
	
	if #items <= 4 then
		numColumns = #items
		numRows = 1
	end
	
	local row, column = -numRows/2,-numColumns/2
	
	for j, item in ipairs(items) do
		local x = column*(buttonRelWidth*1.25)+w
		local y = row*(buttonRelHeight*1.25)+h
		
		local model = getElementData(item, "model")
		local offX = getElementData(item, "offX") or 0
		local offY = getElementData(item, "offY") or 0
		local offZ = getElementData(item, "offZ") or 0
		local scale = getElementData(item, "scale") or 0.175
		local rotX = getElementData(item, "rotX") or 0
		local rotY = getElementData(item, "rotY") or 0
		local rotZ = getElementData(item, "rotZ") or 0
		buttonList[#buttonList+1] = createObjectButton(x/width,y/height, buttonWidth,buttonHeight, "", model, offX,offY,offZ, scale, rotX,rotY,rotZ)
		setElementData(buttonList[#buttonList], "itemID", getElementID(item), false)
		setElementData(buttonList[#buttonList], "price", getElementData(item, "price"), false)
		setElementData(buttonList[#buttonList], "weaponID", getElementData(item, "weaponid") or false, false)
		setElementData(buttonList[#buttonList], "amount", getElementData(item, "amount"), false)
		
		if column+1 < numColumns/2 then
			column = column+1
		else
			column = -numColumns/2
			row = row+1
		end
	end
	
	local buttonExit = guiCreateButton((w/width)-(buttonWidth*1.25/2), 1-((h/4)/height)-(buttonHeight/2), buttonWidth, buttonHeight, "Exit", true)
	guiSetAlpha(buttonExit, 0.8)
	guiSetProperty(buttonExit, "HoverTextColour", "FFFF4400")
	buttonList[#buttonList+1] = buttonExit
	addEventHandler("onClientGUIClick", buttonExit, shopEnd)
	addEventHandler("onClientPlayerDamage", localPlayer, shopEnd)
end

function shopEnd()
	destroyButtonList()
	--destroyBackground()
	exports["fog"]:setFogEnd(3000)
	resetSkyGradient()
	setTimer(showCursor, 50, 1, false)
	addEventHandler("onClientColShapeHit", cancelCol, shopStart)
	toggleAllControls(true, true, false)
	setCameraTarget(localPlayer)
	removeEventHandler("onClientPlayerDamage", localPlayer, shopEnd)
	if isElement(amountEdit) then
		destroyElement(amountEdit)
	end
	if isElement(amountGridList) then
		destroyElement(amountGridList)
	end
end

function destroyButtonList()
	for i, button in pairs(buttonList) do
--		killTimer(getElementData(button, "timer"))
		if getElementData(button, "object") then
			destroyElement(getElementData(button, "object"))
			destroyElement(getElementData(button, "dummy"))
		end
		destroyElement(button)
		buttonList[i] = nil
	end
end

function createObjectButton(x,y, bW,bH, text, model, offX,offY,offZ, scale, rotX,rotY,rotZ)
	local button = guiCreateButton(x,y, bW,bH, text, true)
	local cx,cy,cz = getCameraMatrix()
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(cx,cy,cz, px,py,pz)
	local rot = findRotation(cx,cy, px,py)
	local wx,wy,wz = getWorldFromScreenPosition((x+(bW/2))*width, (y+(bH/1.5))*height, 0.9)
	local dummy = createObject(3060, wx,wy,wz+0.1)
	local object = createObject(model, wx,wy,wz+0.1)
	
	guiSetAlpha(button, 0.2)
	setElementAlpha(dummy, 0)
	setObjectScale(dummy, 0.06)
	setObjectScale(object, scale)
	setElementDoubleSided(object, true)
	setElementCollisionsEnabled(dummy, false)
	setElementCollisionsEnabled(object, false)
	setElementInterior(dummy, getElementInterior(localPlayer))
	setElementDimension(dummy, getElementDimension(localPlayer))
	setElementInterior(object, getElementInterior(localPlayer))
	setElementDimension(object, getElementDimension(localPlayer))
	
	setElementData(dummy, "rot", rot, false)
	setElementData(object, "scale", scale, false)
	setElementData(button, "dummy", dummy, false)
	setElementData(button, "object", object, false)
	
	attachElements(object, dummy, offX,offY,offZ, rotX,rotY,rotZ)
	setTimer(moveObject, 50, 1, dummy, 0, wx,wy,wz,0,0,rot)				--HACK delay moving objects into position until camera is settled
	
	addEventHandler("onClientGUIClick", button, purchaseItem)
	
	addEventHandler("onClientMouseEnter", button,						--start spinning dummy
		function ()
			local object = getElementData(source, "object")
			local dummy = getElementData(source, "dummy")
			local timer = setTimer(rotateObjectOnZAxis, 50,0, dummy, 4)
			setElementData(source, "timer", timer, false)
			setObjectScale(object, getElementData(object, "scale")*1.1)
		end
	)
	
	addEventHandler("onClientMouseLeave", button,						--stop spinning dummy, reset rotation
		function ()
			local object = getElementData(source, "object")
			local dummy = getElementData(source, "dummy")
			local rx,ry,rz = getElementRotation(dummy)
			killTimer(getElementData(source, "timer"))
			setElementRotation(dummy, rx,ry, getElementData(dummy, "rot"))
			setObjectScale(object, getElementData(object, "scale"))
		end
	)
	
	return button
end

function rotateObjectOnZAxis(object, speed)
	if object then
		local rx,ry,rz = getElementRotation(object)
		if rz < 360 then
			rz = rz+speed
		else
			rz = 0
		end
		setElementRotation(object, rx,ry,rz)
	end
end

function purchaseItem()
	local itemID = getElementData(source, "itemID")
	local weaponID = getElementData(source, "weaponID")
	local amount = getElementData(source, "amount")
	local price = tonumber(getElementData(source, "price"))
	local playerMoney = getPlayerMoney(localPlayer)
	
	if itemID == "Deposit" then
		setElementData(amountEdit, "action", "Deposit")
		guiSetText(amountEdit, tostring(getPlayerMoney(localPlayer)))
		guiSetVisible(amountEdit, true)
		guiSetVisible(amountGridList, true)
		guiBringToFront(amountEdit)
		guiEditSetCaretIndex(amountEdit, string.len(guiGetText(amountEdit)))
		
		local object = getElementData(source, "object")
		setObjectScale(object, getElementData(object, "scale")*1.2)
		setTimer(setObjectScale, 50, 1, object, getElementData(object, "scale")*1.1)
		setTimer(setObjectScale, 100, 1, object, getElementData(object, "scale"))
	elseif itemID == "Withdraw" then
		setElementData(amountEdit, "action", "Withdraw")
		guiSetText(amountEdit, "500")
		guiSetVisible(amountEdit, true)
		guiSetVisible(amountGridList, true)
		guiBringToFront(amountEdit)
		guiEditSetCaretIndex(amountEdit, string.len(guiGetText(amountEdit)))
		
		local object = getElementData(source, "object")
		setObjectScale(object, getElementData(object, "scale")*1.2)
		setTimer(setObjectScale, 50, 1, object, getElementData(object, "scale")*1.1)
		setTimer(setObjectScale, 100, 1, object, getElementData(object, "scale"))
	elseif itemID == "Transfer" then
		outputChatBox("Transfer (Under Construction)", 0,128,255)
		
		local object = getElementData(source, "object")
		setObjectScale(object, getElementData(object, "scale")*1.2)
		setTimer(setObjectScale, 50, 1, object, getElementData(object, "scale")*1.1)
		setTimer(setObjectScale, 100, 1, object, getElementData(object, "scale"))
	elseif price <= playerMoney then
		local object = getElementData(source, "object")
		setObjectScale(object, getElementData(object, "scale")*1.2)
		setTimer(setObjectScale, 50, 1, object, getElementData(object, "scale")*1.1)
		setTimer(setObjectScale, 100, 1, object, getElementData(object, "scale"))
		if weaponID then
			triggerServerEvent("purchaseWeapon", localPlayer, weaponID, amount, price)
		else
			triggerServerEvent("purchaseHealth", localPlayer, amount, price)
		end
	end
end

addEventHandler("onClientRender", root,
	function ()
		for i, button in pairs(buttonList) do
			local itemID = getElementData(button, "itemID")
			if itemID then
				local posX, posY = guiGetPosition(button, false)
				local sizeX, sizeY = guiGetSize(button, false)
				local price = getElementData(button, "price")
				local amount = getElementData(button, "amount")
				
				dxDrawTextOutlined(itemID, posX-6,posY, posX+sizeX+6,posY+sizeY+8, 192,240,255,192, 0.7, "default-bold", "center", "bottom", true, true)
				if price then
					dxDrawTextOutlined("$ "..price, posX+2,posY, posX+sizeX,posY+sizeY, 48,128,48,192, 0.6, "pricedown", "left", "top", true, true)
				end
				if amount then
					dxDrawTextOutlined("x "..amount, posX+2,posY+2, posX+sizeX-2,posY+sizeY-2, 192,240,255,192, 0.9, "default-bold", "right", "bottom", true, true)
				end
				
				if itemID == "Deposit" then
					dxDrawRectangle(posX,posY, sizeX,sizeY, tocolor(0,255,0,32))
				elseif itemID == "Withdraw" then
					dxDrawRectangle(posX,posY, sizeX,sizeY, tocolor(255,64,0,32))
				elseif itemID == "Transfer" then
					dxDrawRectangle(posX,posY, sizeX,sizeY, tocolor(0,64,255,32))
				end
			end
		end
		
		if #buttonList > 0 and shopType == "Bank" then
			dxDrawTextOutlined("Account Balance:\n$"..(getElementData(localPlayer, "bankBalance") or 0), w,h-(h/4), w,h-(h/4), 48,96,48,255, 1.2, "pricedown", "center", "center", false, true)
		end
	end
)

function dxDrawTextOutlined(text, posX,posY, sizeX,sizeY, r,g,b,a, scale, font, alignX, alignY, clip, postGUI)
	local s = scale*2
	dxDrawText(text, posX-s,posY-s, sizeX-s,sizeY-s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+s,posY-s, sizeX+s,sizeY-s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX-s,posY+s, sizeX-s,sizeY+s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX+s,posY+s, sizeX+s,sizeY+s, tocolor(0,0,0,a), scale, font, alignX, alignY, clip, postGUI)
	dxDrawText(text, posX,posY, sizeX,sizeY, tocolor(r,g,b,a), scale, font, alignX, alignY, clip, postGUI)
end

function createBackground()
	local interior = getElementInterior(localPlayer)
	local dimension = getElementDimension(localPlayer)
	local cx,cy,cz = getCameraMatrix()
	local px,py,pz = getElementPosition(localPlayer)
	local dist = getDistanceBetweenPoints3D(cx,cy,cz, px,py,pz)
	local rot = findRotation(cx,cy, px,py)
	
	for i=1,maxDarkPolys do
		local sx,sy,sz = getWorldFromScreenPosition(w,h, 1.5+(i/dist))
		--background[i] = createObject(13654, sx,sy,sz+0.1,0,0,180+rot)
		background[i] = createObject(13654, sx,sy,sz+0.1,0,0,math.rad(180+rot))
		setObjectScale(background[i], 0.375)
		setElementAlpha(background[i], 32)
		setElementInterior(background[i], interior)
		setElementDimension(background[i], dimension)
		setTimer(moveObject, 50, 1, background[i], 0, sx,sy,sz, 0,0,180+rot)
	end
end

function destroyBackground()
	for i, bg in ipairs(background) do
		destroyElement(bg)
		background[i] = nil
	end
end

function findRotation(x1, y1, x2, y2)
	local t = -math.deg(math.atan2(x2-x1, y2-y1))
	if t < 0 then
		t = t+360
	end
	return t
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90-angle)
	local dx = math.cos(a)*dist
	local dy = math.sin(a)*dist
	return x+dx, y+dy
end
