--index == weaponID
local weapons = { 331,333,334,335,336,337,338,339,341,321,322,323,0,325,326,342,343,344,0,0,0,346,347,348,349,350,351,352,353,355,356,372,357,358,359,360,361,362,363,0,365,366,367,368,369,371 }
local money = { 1212, 1550 }
local pickupModel = {}

local   bagMax = 100000
local   bagMin = 10000
local stackMax = 10000

local briefcaseTimeout = 3000

addEventHandler("onResourceStart", resourceRoot,
	function ()
		addEvent("objectPickupHit", true)
--		pickupModel["armour"] = {}
--		pickupModel["health"] = {}
		pickupModel["money"] = money
		pickupModel["weapon"] = weapons
		
		for i,player in pairs(getElementsByType("player")) do
			setElementData(player, "hasBriefcase", false)
		end
	end
)

addEventHandler("onPlayerWasted", getRootElement(),
	function (totalAmmo, killer, killerWeapon, bodypart)
		local x, y, z = getElementPosition(source)
		local model = getPedWeapon(source)
		local rotation = -getPedRotation(source)
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		
		if model > 0 then
			tx, ty = getPointFromDistanceRotation(x, y, 1.5, rotation+(math.random(30)-15))
			createObjectPickup(tx, ty, z-0.8, "weapon", model, totalAmmo, interior, dimension)
		end
		
		local playerMoney = getPlayerMoney(source)
		takePlayerMoney(source, playerMoney)
		dropPlayerMoney(source, playerMoney)
		
		if getElementData(source, "hasBriefcase") then
			setElementData(source, "hasBriefcase", false)
			tx, ty = getPointFromDistanceRotation(x, y, 1.5, rotation+(math.random(30)-15))
			local pickup = createObjectPickup(tx, ty, z-0.8, "briefcase", 1210, 1, interior, dimension)
			setElementData(pickup, "briefcase", getElementData(source, "briefcase"))
			addEventHandler("objectPickupHit", pickup,
				function (player)
					triggerClientEvent(player, "espionageStart", source)
				end
			)
			setTimer(destroyElement, briefcaseTimeOut, 1, pickup)
		end
	end
)

function dropPlayerMoney(player, amount)
	local x, y, z = getElementPosition(player)
	local rotation = -getPedRotation(player)
	local interior = getElementInterior(player)
	local dimension = getElementDimension(player)
	local stackCount = 0
	
	while amount > 0 do
		tx, ty = getPointFromDistanceRotation(x, y, 1.5, rotation+(math.random(180)-90))
		if stackCount >= 5 then
			createObjectPickup(tx, ty, z-0.8, "money", pickupModel["money"][2], amount, interior, dimension)
			amount = 0
		else
			if amount < stackMax then
				createObjectPickup(tx, ty, z-0.8, "money", pickupModel["money"][1], amount, interior, dimension)
				amount = 0
			elseif amount == stackMax then
				createObjectPickup(tx, ty, z-0.8, "money", pickupModel["money"][1], stackMax, interior, dimension)
				amount = amount-stackMax
			end
			stackCount = stackCount+1
		end
	end
end

function createObjectPickup(posX, posY, posZ, pickupType, model, amount, interior, dimension)
	if pickupType == "money" then
		id = model
	elseif pickupType == "briefcase" then
		id = 1210
	elseif pickupType == "adrenaline" then
		id = 1241
	elseif pickupType == "weapon" then
		id = pickupModel[pickupType][model]
	end
	
	local rx, ry, rz = 0, 0, 0
	
	if id >= 331 and id <= 340 then
		rx, ry, rz = 90, 0, -(math.random(90)-45)
	elseif id >= 340 and id <= 372 then
		rx, ry, rz = 90, 0, 90-(math.random(90)-45)
	elseif id == 1210 then
		rx, ry, rz = 90, 0, 90-(math.random(90)-45)
	elseif id == 1241 then
		rx, ry, rz = 90, 0, 90-(math.random(90)-45)
	end

	local object = createObject(id, posX, posY, posZ, rx, ry, rz)
	local colSphere = createColSphere(posX, posY, posZ+0.2, 1)
	
	setElementInterior(object, interior)
	setElementInterior(colSphere, interior)
	setElementDimension(object, dimension)
	setElementDimension(colSphere, dimension)
	setElementData(colSphere, "pickupType", pickupType, false)
	setElementData(colSphere, "model", model, false)
	setElementData(colSphere, "amount", amount, false)
	setElementData(colSphere, "object", object, false)
	
	if pickupType == "money" then
		addEventHandler("onColShapeHit", colSphere,
			function (hitElement, matchingDimension)
				if getElementType(hitElement) == "player" and matchingDimension then
					givePlayerMoney(hitElement, getElementData(source, "amount"))
					triggerEvent("objectPickupHit", source, hitElement)
					destroyElement(getElementData(source, "object"))
					destroyElement(source)
				end
			end
		)
	elseif pickupType == "briefcase" then
		addEventHandler("onColShapeHit", colSphere,
			function (hitElement, matchingDimension)
				if getElementType(hitElement) == "player" and matchingDimension then
					if not getElementData(hitElement, "hasBriefcase") then
						triggerEvent("objectPickupHit", source, hitElement)
						setElementData(hitElement, "hasBriefcase", true)
						destroyElement(getElementData(source, "object"))
						destroyElement(source)
					end
				end
			end
		)
	elseif pickupType == "adrenaline" then
		addEventHandler("onColShapeHit", colSphere,
			function (hitElement, matchingDimension)
				if getElementType(hitElement) == "player" and matchingDimension then
					triggerEvent("objectPickupHit", source, hitElement)
					destroyElement(getElementData(source, "object"))
					destroyElement(source)
				end
			end
		)
	elseif pickupType == "weapon" then
		addEventHandler("onColShapeHit", colSphere,
			function (hitElement, matchingDimension)
				if getElementType(hitElement) == "player" and matchingDimension then
					giveWeapon(hitElement, getElementData(source, "model"), getElementData(source, "amount"), true)
					triggerEvent("objectPickupHit", source, hitElement)
					destroyElement(getElementData(source, "object"))
					destroyElement(source)
				end
			end
		)
	end
	
	return colSphere
end

addCommandHandler("drop",
	function (playerSource, commandName, amount)
		local x, y, z = getElementPosition(playerSource)
		local interior = getElementInterior(playerSource)
		local dimension = getElementDimension(playerSource)
		local model = getPedWeapon(playerSource)
--		local model = math.random(#weapons)
		local ammo = getPedTotalAmmo(playerSource)
		local rotation = -getPedRotation(playerSource)
		
		if not amount then
			takeWeapon(playerSource, model)
			x, y = getPointFromDistanceRotation(x, y, 1.5, rotation+(math.random(30)-15))
			if model ~= 0 then
				createObjectPickup(x, y, z-0.8, "weapon", model, ammo, interior, dimension)
			elseif getElementData(playerSource, "hasBriefcase") then
				setElementData(playerSource, "hasBriefcase", false)
				tx, ty = getPointFromDistanceRotation(x, y, 1.5, rotation+(math.random(30)-15))
				local pickup = createObjectPickup(tx, ty, z-0.8, "briefcase", 1210, 1, interior, dimension)
				setElementData(pickup, "briefcase", getElementData(playerSource, "briefcase"))
				addEventHandler("objectPickupHit", pickup,
					function (player)
						triggerClientEvent(player, "espionageStart", source)
					end
				)
				setTimer(triggerEvent, briefcaseTimeOut, 1, "spawnBriefcase", getRootElement(), getElementData(pickup, "briefcase"))
				setTimer(destroyElement, briefcaseTimeOut, 1, pickup)
			end
		else
			if tonumber(amount) <= getPlayerMoney(playerSource) then
				takePlayerMoney(playerSource, tonumber(amount))
				dropPlayerMoney(playerSource, tonumber(amount))
			end
		end
	end
)

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90-angle)
	local dx = math.cos(a)*dist
	local dy = math.sin(a)*dist
	return x+dx, y+dy
end
