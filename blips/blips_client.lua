local localPlayer = getLocalPlayer()
local playerBlips = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i, player in ipairs(getElementsByType("player")) do
			local x, y, z = getElementPosition(player)			
			local r = getElementData(player, "r")
			local g = getElementData(player, "g")
			local b = getElementData(player, "b")
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255)
			attachElements(playerBlips[player], player)
		end
	end
)

addEventHandler("onClientPlayerSpawn", getRootElement(),
	function()
		if(isElement(playerBlips[source])) then
			destroyElement(playerBlips[source])
		end
		
		local x, y, z = getElementPosition(source)
		local r = getElementData(source, "r")
		local g = getElementData(source, "g")
		local b = getElementData(source, "b")
		playerBlips[source] = createBlipAttachedTo(source, 0, 2, r, g, b, 255)
		attachElements(playerBlips[source], source)
	end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
	function()
		if(isElement(playerBlips[source])) then
			destroyElement(playerBlips[source])
		end
		playerBlips[source] = nil
	end
)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function()
		if(isElement(playerBlips[source])) then
			destroyElement(playerBlips[source])
		end
		playerBlips[source] = nil
	end
)

addEventHandler("onClientRender", getRootElement(),
	function()
		local x, y, z = getElementPosition(localPlayer)

		for i, player in ipairs(getElementsByType("player")) do
			if not isPlayerDead(player) and getElementInterior(player) == 0 and playerBlips[player] then
				local px, py, pz = getElementPosition(player)
				local pr, pg, pb, pa = getBlipColor(playerBlips[player])
				local element = getPedOccupiedVehicle(localPlayer)
				if not element then
					element = localPlayer
				end
				
				pr = getElementData(player, "r")			--HACK
				pg = getElementData(player, "g")
				pb = getElementData(player, "b")
				
				if(getPedTask(player, "secondary", 1) == "TASK_SIMPLE_DUCK") and (getPedControlState(player, "fire") ~= true) then
					if(isLineOfSightClear(x, y, z, px, py, pz, true, true, false, true, true, false, false, element)) then
						fadeBlip(playerBlips[player], pr, pg, pb, pa, true)
					else
						fadeBlip(playerBlips[player], pr, pg, pb, pa, false)
					end				
				else
					fadeBlip(playerBlips[player], pr, pg, pb, pa, true)
				end
				
			elseif not isPlayerDead(player) and getElementInterior(player) ~= 0 and playerBlips[player] then
				local pr, pg, pb, pa = getBlipColor(playerBlips[player])
				setBlipColor(playerBlips[player], pr, pg, pb, 0)
			end
		end
	end
)

function fadeBlip(blip, r, g, b, a, fadeIn)
	if(fadeIn) then
		if(a < 248) then
			a = a+8
		end
	elseif(fadeIn == false) then
		if(a > 8) then
			a = a-8
		end
	end
	
	if blip then
		setBlipColor(blip, r or 0, g or 0, b or 0, math.floor(a) or 0)
	end
end