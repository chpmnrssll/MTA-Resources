local briefcases = {}

function givePlayerBriefcase(player)
	local object = createObject(1210, 0, 0, 0)
	setElementCollisionsEnabled(object, false)
	table.insert(briefcases, { player = player, object = object, hidden = false })
end

function takePlayerBriefcase(player)
	for i,briefcase in ipairs(briefcases) do
		if (briefcase.player == player) then
			destroyElement(briefcase.object)
			table.remove(briefcases, i)
			break
		end
	end
end

addEventHandler("onClientElementDataChange", root,
	function (dataName, oldValue)
		if getElementType(source) == "player" then
			if dataName == "hasBriefcase" then
				if getElementData(source, "hasBriefcase") then
					givePlayerBriefcase(source)
				else
					takePlayerBriefcase(source)
				end
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "hasBriefcase") then
				givePlayerBriefcase(player)
			end
		end
	end
)

addEventHandler("onClientRender", root,
	function ()
		for i,briefcase in ipairs(briefcases) do
			if not isElement(briefcase.player) then	--perhaps the player has left unexpectedly
				takePlayerBriefcase(briefcase.player)
			end
			if isElementStreamedIn(briefcase.player) then
				local veh = getPedOccupiedVehicle(briefcase.player)
				if veh then
					if getVehicleType(veh) == "Bike" then veh = false end
				end
				if not veh then
--				if not isPedInVehicle(briefcase.player) then
					local interior = getElementInterior(briefcase.player)
					local dimension = getElementDimension(briefcase.player)
					local rotationOffset = -90
					local weapID = getPedWeapon(briefcase.player)
					if weapID == 9 then
						rotationOffset = 0			--flip it sideways
					elseif weapID == 25 or weapID == 27 or weapID == 30 or weapID == 31 or weapID == 33 or weapID == 34 or weapID == 37 or weapID == 38 then --problem ids: 9, 37, 38
						if not isPedDoingTask(briefcase.player, "TASK_SIMPLE_USE_GUN") then
							rotationOffset = 0		--flip it sideways if not aiming
						end
					end
					local x,y,z = getPedBonePosition(briefcase.player, 35)
					local rx,ry,rz = getElementRotation(briefcase.player)
					local xOffset = 0.1 * math.cos(math.rad(rz+90-90))
					local yOffset = 0.1 * math.sin(math.rad(rz+90-90))
					setElementInterior(briefcase.object, interior)
					setElementDimension(briefcase.object, dimension)
					setElementPosition(briefcase.object, x+xOffset, y+yOffset, z-0.2)
					setElementRotation(briefcase.object, rx, ry, rz+rotationOffset)
					if briefcase.hidden then
						briefcase.hidden = false
					end
				elseif not briefcase.hidden then
					setElementPosition(briefcase.object, 0, 0, 0)
					briefcase.hidden = true
				end
			end
		end
	end
)
