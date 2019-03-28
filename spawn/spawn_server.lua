local spawnClassRoot = getElementChild(resourceRoot, 1)
local playersTeam = createTeam("Players", 255,255,255)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i, subclass in ipairs(getElementsByType("subclass", spawnClassRoot)) do
			local r = getElementData(subclass, "r")
			local g = getElementData(subclass, "g")
			local b = getElementData(subclass, "b")
			local team = createTeam(getElementID(subclass), r,g,b)
		end
		
		for i, player in ipairs(getElementsByType("player")) do
			local subclassID = getElementData(player, "subclass") or ""
			local team = getTeamFromName(subclassID)
			if subclassID then setElementParent(player, getElementByID(subclassID)) end
			if not isPedDead(player) then
				setTimer(setPlayerTeam, 50, 1, player, team)
			else
				setTimer(setPlayerTeam, 50, 1, player, playersTeam)
			end
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function ()
		setPlayerTeam(source, playersTeam)
		
		local aclList = aclGroupList()
		local access = ""
		for i, group in pairs(aclList) do
			if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), group) then
				access = aclGroupGetName(group) .. "," .. access
			end
		end
		
		setElementData(source, "ACLGroups", access)
	end
)

addEventHandler("onPlayerLogin", root,
	function (previousAccount, currentAccount, autoLogin)
		local aclList = aclGroupList()
		local access = ""
		for i, group in pairs(aclList) do
			if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), group) then
				access = aclGroupGetName(group) .. "," .. access
			end
		end
		
		setElementData(source, "ACLGroups", access)
		--outputChatBox(access)
	end
)

addEventHandler("onPlayerWasted", root,
	function ()
		setPlayerTeam(source, playersTeam)
	end
)

addEvent("spawnPlayer", true)
addEventHandler("spawnPlayer", root,
	function (spawnpoint, spawnMoney)
		local subclass = getElementParent(spawnpoint)
		local class = getElementParent(subclass)
		local size = 1
		local skins = split(getElementData(spawnpoint, "skins"), string.byte(','))
		local skin = skins[1 + math.floor(math.random() * #skins)]
		spawnPlayer(
			source,
			getElementData(spawnpoint, "posX") + (math.random()*size)-(size/2),
			getElementData(spawnpoint, "posY") + (math.random()*size)-(size/2),
			getElementData(spawnpoint, "posZ"),
			getElementData(spawnpoint, "rotation") + (math.random()*10)-5,
			--getElementData(spawnpoint, "skin"),
			skin,
			getElementData(spawnpoint, "interior"),
			getElementData(spawnpoint, "dimension")
		)
		
		local weapons = split(getElementData(subclass, "weapons"), string.byte(';'))
		for k,weapon in ipairs(weapons) do
			weaponId = gettok(weapon, 1, string.byte(','))
			weaponAmmo = gettok(weapon, 2, string.byte(','))
			if weaponId and weaponAmmo then
				giveWeapon(source, weaponId, weaponAmmo)
			end
		end
		
		setPlayerTeam(source, getTeamFromName(getElementID(subclass)))
		setElementParent(source, subclass)
		setElementData(source, "r", getElementData(subclass, "r"))
		setElementData(source, "g", getElementData(subclass, "g"))
		setElementData(source, "b", getElementData(subclass, "b"))
		setElementData(source, "class", getElementID(class))
		setElementData(source, "subclass", getElementID(subclass))
		setElementData(source, "spawnpoint", getElementID(spawnpoint))
--		setElementData(source, "spawnpoint", spawnpoint)
		setElementData(source, "warpTo", nil)
		setElementData(source, "attacker", nil)
		setElementData(source, "interior", getElementData(spawnpoint, "interior"))			--server sync hack
		setElementData(source, "dimension", getElementData(spawnpoint, "dimension"))
		setPlayerMoney(source, spawnMoney)
	end
)

addCommandHandler("kill",
	function (player)
		if not getElementData(player, "jailed") then
			setElementHealth(player, 0)
		end
	end
)
