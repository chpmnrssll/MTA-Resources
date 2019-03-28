local localPlayer = getLocalPlayer()
local respectText = {}
local damageText = {}
local bustedText = {}
local weaponText = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		for i,player in pairs(getElementsByType("player")) do
			addEventHandler("onClientElementDataChange", player, dataChange)
		end
	end
)

addEventHandler("onClientPlayerJoin", root,
	function ()
		addEventHandler("onClientElementDataChange", source, dataChange)
	end
)

addEventHandler("onClientPlayerQuit", root,
	function ()
		removeEventHandler("onClientElementDataChange", source, dataChange)
	end
)

function dataChange(dataName, oldValue)
	if getElementType(source) == "player" then
		if not isElementStreamedIn(source) then
			return
		elseif dataName == "respect" then
			local newValue = getElementData(source, "respect")
			local amount = newValue-(oldValue or 0)
			respectText[#respectText+1] = {}
			respectText[#respectText].player = source
			respectText[#respectText].bone = 8
			respectText[#respectText].amount = amount
			respectText[#respectText].tick = getTickCount()
		elseif dataName == "arrested" then
			if getElementData(source, "arrested") then
				setElementData(source, "arrested", false)
				bustedText[#bustedText+1] = {}
				bustedText[#bustedText].player = source
				bustedText[#bustedText].bone = 8
				bustedText[#bustedText].text = "Busted!"
				bustedText[#bustedText].tick = getTickCount()
			end
		else
			local weapon = getWeaponIDFromName(dataName)
			if weapon then
				if weapon >= 22 and weapon <= 34 then
					weaponText[#weaponText+1] = {}
					weaponText[#weaponText].player = source
					weaponText[#weaponText].bone = 8
					weaponText[#weaponText].text = "+1 " .. dataName
					weaponText[#weaponText].tick = getTickCount()
				end
			end
		end
	end
end

addEventHandler("onClientPlayerDamage", root,
	function (attacker, weapon, bodyPart, loss)
		if attacker and weapon then
			if getElementType(attacker) ~= "vehicle" then
				if weapon == 38 then
					cancelEvent()
					if weapon == 38 then											--mini-gun hack
						local health = getElementHealth(source)+loss
						loss = 1
						setTimer(setElementHealth, 50, 1, source, health-1)
					end
				end
			end
		end
		
		damageText[#damageText+1] = {}
		damageText[#damageText].player = source
		damageText[#damageText].bone = getBoneFromBodyPart(bodyPart)
		damageText[#damageText].loss = tostring(tonumber(("%.".. 2 .."f"):format(loss)).." HP")
		damageText[#damageText].tick = getTickCount()
	end
)

addEventHandler("onClientPreRender", root,
	function ()
		local x,y,z = getElementPosition(localPlayer)
		local interior = getElementInterior(localPlayer)
		local dimension = getElementDimension(localPlayer)
		
		for i, respect in ipairs(respectText) do
			if interior == getElementInterior(respect.player) and dimension == getElementDimension(respect.player)then
				local bx,by,bz = getPedBonePosition(respect.player, respect.bone)
				local dist = getDistanceBetweenPoints3D(x,y,z, bx,by,bz)
				if isLineOfSightClear(x,y,z, bx,by,bz, true, false, false, true, true, false, false) and dist < 64 then
					local tx, ty = getScreenFromWorldPosition(bx,by,bz)
					if tx and ty then
						local r,g,b,a = 0,255,0, 255-((getTickCount()-respect.tick)/4)
						local size = 0.8
						local font = "bankgothic"
						local text = nil
						
						if respect.amount < 0 then
							r,g,b = 255,0,0
							text = tostring(respect.amount.." Respect")
						else
							text = tostring("+"..respect.amount.." Respect")
						end
						
						ty = ty-((getTickCount()-respect.tick)/16)
						dxDrawText(text, tx+1.5,ty+1.5, tx+1.5,ty+1.5, tocolor(0,0,0,a), size, font, "center", "center")
						dxDrawText(text, tx,ty, tx,ty, tocolor(r,g,b,a), size, font, "center", "center")
					end
				end
			end
			if 255-((getTickCount()-respect.tick)/3) < 1 then
				table.remove(respectText, i)
			end
		end
		
		for i, damage in ipairs(damageText) do
			if interior == getElementInterior(damage.player) and dimension == getElementDimension(damage.player)then
				local bx,by,bz = getPedBonePosition(damage.player, damage.bone)
				local dist = getDistanceBetweenPoints3D(x,y,z, bx,by,bz)
				if isLineOfSightClear(x,y,z, bx,by,bz, true, false, false, true, true, false, false) and dist < 64 then
					local tx, ty = getScreenFromWorldPosition(bx,by,bz)
					if tx and ty then
						local r,g,b,a = 255,0,0, 255-((getTickCount()-damage.tick)/4)
						local size = 0.4
						local font = "bankgothic"
						ty = ty-((getTickCount()-damage.tick)/16)
						dxDrawText(damage.loss, tx+1.5,ty+1.5, tx+1.5,ty+1.5, tocolor(0,0,0,a), size, font, "center", "center")
						dxDrawText(damage.loss, tx,ty, tx,ty, tocolor(r,g,b,a), size, font, "center", "center")
					end
				end
			end
			if 255-((getTickCount()-damage.tick)/3) < 1 then
				table.remove(damageText, i)
			end
		end
		
		for i, busted in ipairs(bustedText) do
			if interior == getElementInterior(busted.player) and dimension == getElementDimension(busted.player)then
				local bx,by,bz = getPedBonePosition(busted.player, busted.bone)
				local dist = getDistanceBetweenPoints3D(x,y,z, bx,by,bz)
				if isLineOfSightClear(x,y,z, bx,by,bz, true, false, false, true, true, false, false) and dist < 64 then
					local tx, ty = getScreenFromWorldPosition(bx,by,bz)
					if tx and ty then
						local r,g,b,a = 255,0,0, 255-((getTickCount()-busted.tick)/4)
						local size = 0.8
						local font = "bankgothic"
						ty = ty-((getTickCount()-busted.tick)/16)
						dxDrawText(busted.text, tx+1.5,ty+1.5, tx+1.5,ty+1.5, tocolor(0,0,0,a), size, font, "center", "center")
						dxDrawText(busted.text, tx,ty, tx,ty, tocolor(r,g,b,a), size, font, "center", "center")
					end
				end
			end
			if 255-((getTickCount()-busted.tick)/3) < 1 then
				table.remove(bustedText, i)
			end
		end
		
		for i, weapon in ipairs(weaponText) do
			if interior == getElementInterior(weapon.player) and dimension == getElementDimension(weapon.player) then
				local bx,by,bz = getPedBonePosition(weapon.player, weapon.bone)
				local dist = getDistanceBetweenPoints3D(x,y,z, bx,by,bz)
				if isLineOfSightClear(x,y,z, bx,by,bz, true, false, false, true, true, false, false) and dist < 64 then
					local tx, ty = getScreenFromWorldPosition(bx,by,bz)
					if tx and ty then
						local r,g,b,a = 0,255,0, 255-((getTickCount()-weapon.tick)/4)
						local size = 0.8
						local font = "bankgothic"
						ty = ty-((getTickCount()-weapon.tick)/16)
						dxDrawText(weapon.text, tx+1.5,ty+1.5, tx+1.5,ty+1.5, tocolor(0,0,0,a), size, font, "center", "center")
						dxDrawText(weapon.text, tx,ty, tx,ty, tocolor(r,g,b,a), size, font, "center", "center")
					end
				end
			end
			if 255-((getTickCount()-weapon.tick)/3) < 1 then
				table.remove(weaponText, i)
			end
		end
		
	end
)

function getBoneFromBodyPart(bodyPart)
	if bodyPart == 3 then		--Torso
		return 3				--BONE_SPINE1
	elseif bodyPart == 4 then	--Ass
		return 1				--BONE_PELVIS1
	elseif bodyPart == 5 then	--Left Arm
		return 33				--BONE_LEFTELBOW
	elseif bodyPart == 6 then	--Right Arm
		return 23				--BONE_RIGHTELBOW
	elseif bodyPart == 7 then	--Left Leg
		return 42				--BONE_LEFTKNEE
	elseif bodyPart == 8 then	--Right Leg
		return 52				--BONE_RIGHTKNEE
	elseif bodyPart == 9 then	--Head
		return 8				--BONE_HEAD
	end
end
