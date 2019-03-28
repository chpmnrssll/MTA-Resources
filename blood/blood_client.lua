--[[
addEventHandler("onClientResourceStart", resourceRoot,		--All players vomit blood
	function ()
		setTimer(
			function ()
				for i, ped in ipairs(getElementsByType("player")) do
					spurtBlood(ped, getBoneFromBodyPart(9), -getPedRotation(ped), 32, 4)
				end
			end
		, 100, 0)
	end
)
]]
addEventHandler("onClientPlayerDamage", root,
	function (attacker, weapon, bodypart, loss)
		if not attacker then return end
		local ax, ay, az = getElementPosition(attacker)
		local x, y, z = getElementPosition(source)
		local rotation = findRotation(ax,ay, x, y)
		
		setTimer(spurtBlood, 500, 8, source, getBoneFromBodyPart(bodypart), 180-rotation, loss/2, loss/10)
	end
)

function spurtBlood(ped, bone, rotation, numSquirts, distance)
	if not ped then return end
	local brightness = distance*0.15
	local px,py,pz = getPedBonePosition(ped, bone)
	local dx,dy,dz = getElementVelocity(ped)
	dx,dy = getPointFromDistanceRotation(px+dx, py+dy, distance, rotation)
	fxAddBlood(px,py,pz, dx-px,dy-py,0, 1, brightness)
	if numSquirts > 0 then
		distance = distance-(distance/numSquirts)
		setTimer(spurtBlood, 50, 1, ped, bone, rotation, numSquirts-1, distance)
	end
end

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

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	return x+dx, y+dy
end

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then
		t = t + 360
	end
	return t
end
