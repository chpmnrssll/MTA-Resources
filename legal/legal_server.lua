local jailTime = 5000
local jailCost = 100
local giveUpTimeout = 2500
local arrestTimers = {}
local jails = {
	["Los Santos"] = { interior=6, dimension=0, cell={x=265.41, y=78.38, z=1001.03, r=270}, release={x=267.20, y=78.38, z=1001.03, r=270} },
	["San Fierro"] = { interior=10, dimension=0, cell={x=216.40, y=112.08, z=999.01, r=0}, release={x=216.37, y=113.19, z=999.01, r=0} },
	["Los Venturas"] = { interior=3, dimension=0, cell={x=198.61, y=161.07, z=1003.02, r=180}, release={x=198.61, y=159.53, z=1003.02, r=180} },
	["Fort Carson"] = { interior=5, dimension=0, cell={x=322.13, y=310.47, z=999.14, r=180}, release={x=322.15, y=308.69, z=999.14, r=180} }
}

addEventHandler("onPlayerSpawn", root,
	function (posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension)
		if isTimer(arrestTimers[source]) then
			killTimer(arrestTimers[source])
		end
		if isElement(getElementData(source, "arrestCol")) then
			destroyElement(getElementData(source, "arrestCol"))
		end
		setElementData(source, "jailed", false)
		setElementData(source, "wantedLevel", 0)
		setElementData(source, "evadedArrest", false, false)
		setElementData(source, "arrestCol", false, false)
		setElementData(source, "arrestingAuthority", false, false)
	end
)

addEventHandler("onPlayerWasted", root,
	function ()
		setElementData(source, "wantedLevel", 0)
	end
)

addEventHandler("onPlayerQuit", root,
	function ()
		if isTimer(arrestTimers[source]) then
			killTimer(arrestTimers[source])
		end
	end
)

addEvent("arrest", true)
addEventHandler("arrest", resourceRoot,
	function (target, authority)
		--if not getElementData(target, "arrestCol") then
		if getElementData(target, "arrestingAuthority") ~= authority then
			local tx,ty,tz = getElementPosition(target)
			local col = createColSphere(tx,ty,tz, 1.0)
			setElementData(target, "arrestCol", col, false)
			setElementData(target, "arrestingAuthority", authority, false)
			setElementData(col, "target", target, false)
			addEventHandler("onColShapeLeave", col, evadeArrest)
			if isTimer(arrestTimers[target]) then
				killTimer(arrestTimers[target])
			end
			arrestTimers[target] = setTimer(giveUp, giveUpTimeout, 1, target, authority)
		else
			triggerClientEvent(authority, "clearArrestTarget", target)
			--[[
			if isElement(getElementData(target, "arrestCol")) then
				destroyElement(getElementData(target, "arrestCol"))
			end
			
			if isTimer(arrestTimers[target]) then
				killTimer(arrestTimers[target])
			end
			]]
		end
	end
)

function evadeArrest()
	local target = getElementData(source, "target")
	local authority = getElementData(target, "arrestingAuthority")
	
	if isTimer(arrestTimers[target]) then
		killTimer(arrestTimers[target])
	end
	
	triggerClientEvent(authority, "clearArrestTarget", target)
	if not getElementData(target, "evadedArrest") then
		setElementData(target, "wantedLevel", (getElementData(target, "wantedLevel") or 0)+1)
		setElementData(target, "WANTED_STARS_EVADED", (getElementData(target, "WANTED_STARS_EVADED") or 0)+1)
		--setElementData(target, "timesEvaded", (getElementData(target, "timesEvaded") or 0)+1)
		setElementData(target, "evadedArrest", true, false)
	end
	
	setElementData(target, "arrestingAuthority", false)
	destroyElement(source)
end

--Gives up to an authority and takes weapons
function giveUp(player, authority)
	local arrestCol = getElementData(player, "arrestCol")
	if arrestCol then
		removeEventHandler("onColShapeLeave", arrestCol, evadeArrest)
		triggerClientEvent(authority, "clearArrestTarget", player)
		destroyElement(arrestCol)
	end
	
	if not isPedDead(player) and not isPedDead(authority) and not getElementData(player, "arrested") then
		setElementData(authority, "respect", (getElementData(authority, "respect") or 0)+(2*(getElementData(player, "wantedLevel") or 1)))
		setElementData(authority, "totalArrests", (getElementData(authority, "totalArrests") or 0)+1)
		setElementData(player, "arrested", true)
		takeAllWeapons(player)
		setPedAnimation(player, "ped", "handsup", -1, false)
		setTimer(gotoJail, giveUpTimeout*2, 1, player, authority)
		triggerClientEvent(authority, "clearArrestTarget", player)
	else
		setElementData(player, "arrested", false)
	end
end

--Moves wanted player to arresting authorities jail
function gotoJail(player, authority)
	if not isPedDead(player) and not isPedDead(authority) then
		local interior = jails[getElementData(authority, "spawnpoint")].interior
		local dimension = jails[getElementData(authority, "spawnpoint")].dimension
		local x = jails[getElementData(authority, "spawnpoint")].cell.x
		local y = jails[getElementData(authority, "spawnpoint")].cell.y
		local z = jails[getElementData(authority, "spawnpoint")].cell.z
		local r = jails[getElementData(authority, "spawnpoint")].cell.r
			
		setCameraInterior(player, interior)
		showPlayerHudComponent(player, "radar", false)
		triggerClientEvent(player, "colfix", player)
		setElementData(player, "interior", interior)
		setElementData(player, "dimension", dimension)
		setElementInterior(player, interior)
		setElementDimension(player, dimension)
		setElementPosition(player, x,y,z)
		setPedRotation(player, r)
		setTimer(doTime, jailTime, 1, player, authority)
		
		setElementData(player, "jailed", true)
		x = jails[getElementData(authority, "spawnpoint")].release.x
		y = jails[getElementData(authority, "spawnpoint")].release.y
		z = jails[getElementData(authority, "spawnpoint")].release.z+1
		triggerClientEvent(player, "jailCam", player, x,y,z)
		setElementData(player, "arrestingAuthority", false)
	end
end

--Spend time in jail and pay arresting authority for each wanted star (bribeCost/2)
function doTime(player, authority)
	local wantedLevel = getElementData(player, "wantedLevel")
	if wantedLevel > 0 then
		setElementData(player, "wantedLevel", wantedLevel-1)
		if getPlayerMoney(player) >= jailCost then
			takePlayerMoney(player, jailCost)
			givePlayerMoney(authority, jailCost)
		else
			givePlayerMoney(authority, getPlayerMoney(player))
			takePlayerMoney(player, getPlayerMoney(player))
		end
		
		setTimer(doTime, jailTime, 1, player, authority)
	else
		local x = jails[getElementData(authority, "spawnpoint")].release.x
		local y = jails[getElementData(authority, "spawnpoint")].release.y
		local z = jails[getElementData(authority, "spawnpoint")].release.z
		local r = jails[getElementData(authority, "spawnpoint")].release.r
		setElementPosition(player, x,y,z)
		setPedRotation(player, r)
		setElementData(player, "evadedArrest", false, false)
		setElementData(player, "jailed", false)
		setElementData(player, "arrested", false)
		triggerClientEvent(player, "jailCamOff", player)
	end
end
