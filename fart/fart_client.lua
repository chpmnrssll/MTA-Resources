local fartPercentage = 1.5
local maxVolume = 0.5

addEventHandler("onClientRender", getRootElement(),
	function ()
		local cx,cy,cz = getCameraMatrix()
		for key, player in ipairs(getElementsByType("player")) do
			if getPedTask(player, "secondary", 1) == "TASK_SIMPLE_DUCK" then
				if math.random(1000)*0.1 < fartPercentage then
					local px, py, pz = getPedBonePosition(player, 1)
					local dist = maxVolume-(getDistanceBetweenPoints3D(cx,cy,cz, px,py,pz)*2)*0.01
					if dist > 0 then
						local rx, ry = getPointFromDistanceRotation(px, py, -1, -getPedRotation(player))
						sound = playSound("fart.mp3")
						setSoundVolume(sound, dist)
						setSoundSpeed(sound, math.random(7,10)*0.1)
						fxAddPunchImpact(px, py, pz, rx-px, ry-py, -0.5)
						fxAddBulletImpact(px, py, pz, rx-px, ry-py, -0.5, math.random(2, 8),0,1)
					end
				end
			end
		end
	end
)

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	return x+dx, y+dy
end
