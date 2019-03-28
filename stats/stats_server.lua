local numStats = 70
local playerStats = {
	["DIST_FOOT"] = 3,
	["DIST_CAR"] = 4,
	["DIST_BIKE"] = 5,
	["DIST_BOAT"] = 6,
	["DIST_GOLF_CART"] = 7,
	["DIST_HELICOPTOR"] = 8,
	["DIST_PLANE"] = 9,
	["WEAPON_BUDGET"] = 13,
	["FOOD_BUDGET"] = 20,
	["DIST_SWIMMING"] = 26,
	["PROSTITUTE_BUDGET"] = 33,
	["MONEY_SPENT_GAMBLING"] = 35,
	["MONEY_MADE_PIMPING"] = 36,
	["MONEY_WON_GAMBLING"] = 37,
	["BIGGEST_GAMBLING_WIN"] = 38,
	["BIGGEST_GAMBLING_LOSS"] = 39,
	["LARGEST_BURGLARY_SWAG"] = 40,
	["MONEY_MADE_BURGLARY"] = 41,
	["STRIP_CLUB_BUDGET"] = 54,
	["CAR_MOD_BUDGET"] = 55,
	["RESPECT"] = 68,
	["WEAPONTYPE_PISTOL_SKILL"] = 69,
	["WEAPONTYPE_PISTOL_SILENCED_SKILL"] = 70,
	["WEAPONTYPE_DESERT_EAGLE_SKILL"] = 71,
	["WEAPONTYPE_SHOTGUN_SKILL"] = 72,
	["WEAPONTYPE_SAWNOFF_SHOTGUN_SKILL"] = 73,
	["WEAPONTYPE_SPAS12_SHOTGUN_SKILL"] = 74,
	["WEAPONTYPE_MICRO_UZI_SKILL"] = 75,
	["WEAPONTYPE_MP5_SKILL"] = 76,
	["WEAPONTYPE_AK47_SKILL"] = 77,
	["WEAPONTYPE_M4_SKILL"] = 78,
	["WEAPONTYPE_SNIPERRIFLE_SKILL"] = 79,
	["GAMBLING"] = 81,
	["PEOPLE_KILLED_BY_PLAYER"] = 121,
	["CARS_DESTROYED"] = 122,
	["BOATS_DESTROYED"] = 123,
	["HELICOPTORS_DESTROYED"] = 124,
	["PROPERTY_DESTROYED"] = 125,
	["ROUNDS_FIRED"] = 126,
	["EXPLOSIVES_USED"] = 127,
	["BULLETS_HIT"] = 128,
	["HEADS_POPPED"] = 130,
	["WANTED_STARS_ATTAINED"] = 131,
	["WANTED_STARS_EVADED"] = 132,
	["TIMES_ARRESTED"] = 133,
	["TIMES_DIED"] = 135,
	["TAXI_MONEY_MADE"] = 149,
	["PASSENGERS_DELIVERED_IN_TAXI"] = 150,
	["LIVES_SAVED"] = 151,
	["CRIMINALS_CAUGHT"] = 152,
	["FIRES_EXTINGUISHED"] = 153,
	["PIZZAS_DELIVERED"] = 154,
	["VIGILANTE_LEVEL"] = 157,
	["AMBULANCE_LEVEL"] = 158,
	["FIREFIGHTER_LEVEL"] = 159,
	["TRUCK_MISSIONS_PASSED"] = 161,
	["TRUCK_MONEY_MADE"] = 162,
	["KILL_FRENZIES_ATTEMPTED"] = 167,
	["KILL_FRENZIES_PASSED"] = 168,
	["FLIGHT_TIME"] = 169,
	["TIMES_DROWNED"] = 170,
	["NUM_GIRLS_PIMPED"] = 171,
	["FLIGHT_TIME_JETPACK"] = 173,
	["SHOOTING_RANGE_SCORE"] = 174,
	["CARS_STOLEN"] = 183,
	["TIMES_VISITED_PROSTITUTE"] = 190,
	["HOUSES_BURGLED"] = 191,
	["SAFES_CRACKED"] = 192,
	["STOLEN_ITEMS_SOLD"] = 194,
	["MEALS_EATEN"] = 200,
}

local def = [[
	account TEXT,
	DIST_FOOT REAL,
	DIST_CAR REAL,
	DIST_BIKE REAL,
	DIST_BOAT REAL,
	DIST_GOLF_CART REAL,
	DIST_HELICOPTOR REAL,
	DIST_PLANE REAL,
	WEAPON_BUDGET REAL,
	FOOD_BUDGET REAL,
	DIST_SWIMMING REAL,
	PROSTITUTE_BUDGET REAL,
	MONEY_SPENT_GAMBLING REAL,
	MONEY_MADE_PIMPING REAL,
	MONEY_WON_GAMBLING REAL,
	BIGGEST_GAMBLING_WIN REAL,
	BIGGEST_GAMBLING_LOSS REAL,
	LARGEST_BURGLARY_SWAG REAL,
	MONEY_MADE_BURGLARY REAL,
	STRIP_CLUB_BUDGET REAL,
	CAR_MOD_BUDGET REAL,
	RESPECT REAL,
	WEAPONTYPE_PISTOL_SKILL REAL,
	WEAPONTYPE_PISTOL_SILENCED_SKILL REAL,
	WEAPONTYPE_DESERT_EAGLE_SKILL REAL,
	WEAPONTYPE_SHOTGUN_SKILL REAL,
	WEAPONTYPE_SAWNOFF_SHOTGUN_SKILL REAL,
	WEAPONTYPE_SPAS12_SHOTGUN_SKILL REAL,
	WEAPONTYPE_MICRO_UZI_SKILL REAL,
	WEAPONTYPE_MP5_SKILL REAL,
	WEAPONTYPE_AK47_SKILL REAL,
	WEAPONTYPE_M4_SKILL REAL,
	WEAPONTYPE_SNIPERRIFLE_SKILL REAL,
	GAMBLING REAL,
	PEOPLE_KILLED_BY_PLAYER INTEGER,
	CARS_DESTROYED INTEGER,
	BOATS_DESTROYED INTEGER,
	HELICOPTORS_DESTROYED INTEGER,
	PROPERTY_DESTROYED INTEGER,
	ROUNDS_FIRED INTEGER,
	EXPLOSIVES_USED INTEGER,
	BULLETS_HIT INTEGER,
	HEADS_POPPED INTEGER,
	WANTED_STARS_ATTAINED INTEGER,
	WANTED_STARS_EVADED INTEGER,
	TIMES_ARRESTED INTEGER,
	TIMES_DIED INTEGER,
	TAXI_MONEY_MADE INTEGER,
	PASSENGERS_DELIVERED_IN_TAXI INTEGER,
	LIVES_SAVED INTEGER,
	CRIMINALS_CAUGHT INTEGER,
	FIRES_EXTINGUISHED INTEGER,
	PIZZAS_DELIVERED INTEGER,
	VIGILANTE_LEVEL INTEGER,
	AMBULANCE_LEVEL INTEGER,
	FIREFIGHTER_LEVEL INTEGER,
	TRUCK_MISSIONS_PASSED INTEGER,
	TRUCK_MONEY_MADE INTEGER,
	KILL_FRENZIES_ATTEMPTED INTEGER,
	KILL_FRENZIES_PASSED INTEGER,
	FLIGHT_TIME INTEGER,
	TIMES_DROWNED INTEGER,
	NUM_GIRLS_PIMPED INTEGER,
	FLIGHT_TIME_JETPACK INTEGER,
	SHOOTING_RANGE_SCORE INTEGER,
	CARS_STOLEN INTEGER,
	TIMES_VISITED_PROSTITUTE INTEGER,
	HOUSES_BURGLED INTEGER,
	SAFES_CRACKED INTEGER,
	STOLEN_ITEMS_SOLD INTEGER,
	MEALS_EATEN INTEGER
]]

local shotsToIncrease = {}
local settings = createElement("settings")

addEventHandler("onResourceStart", resourceRoot,
	function ()
		addEventHandler("onSettingChange", resourceRoot, getSettings)
		getSettings()
		
		--executeSQLDropTable("players")
		executeSQLCreateTable("players", def)
		
		for i,player in pairs(getElementsByType("player")) do
			addEventHandler("onElementDataChange", player, dataChange)
			initPlayerStats(player)
		end
	end
)

function getSettings()
	shotsToIncrease["Colt 45"] = tonumber(get("shotsToIncrease Colt 45"))
	shotsToIncrease["Silenced"] = tonumber(get("shotsToIncrease Silenced"))
	shotsToIncrease["Deagle"] = tonumber(get("shotsToIncrease Deagle"))
	shotsToIncrease["Shotgun"] = tonumber(get("shotsToIncrease Shotgun"))
	shotsToIncrease["Sawed-off"] = tonumber(get("shotsToIncrease Sawed-off"))
	shotsToIncrease["Combat Shotgun"] = tonumber(get("shotsToIncrease Combat Shotgun"))
	shotsToIncrease["Uzi"] = tonumber(get("shotsToIncrease Uzi"))
	shotsToIncrease["MP5"] = tonumber(get("shotsToIncrease MP5"))
	shotsToIncrease["AK-47"] = tonumber(get("shotsToIncrease AK-47"))
	shotsToIncrease["M4"] = tonumber(get("shotsToIncrease M4"))
	shotsToIncrease["Sniper"] = tonumber(get("shotsToIncrease Sniper"))
	
	for name,value in pairs(shotsToIncrease) do
		setElementData(settings, name, value)
	end
	setTimer(triggerClientEvent, 1000, 1, "settingsChange", settings)
end

addEventHandler("onPlayerLogin", root,
	function (previousAccount, currentAccount, autoLogin)
		initPlayerStats(source)
	end
)

addEventHandler("onPlayerJoin", root,
	function ()
		addEventHandler("onElementDataChange", source, dataChange)
		initPlayerStats(source)
		
		setPedStat(source, 24, 1000)	--MAX_HEALTH
		setPedStat(source, 164, 0)		--ARMOUR
		setPedStat(source, 165, 1000)	--ENERGY
		setPedStat(source, 160, 1000)	--DRIVING_SKILL
		setPedStat(source, 225, 1000)	--UNDERWATER_STAMINA
		setPedStat(source, 229, 1000)	--BIKE_SKILL
		setPedStat(source, 230, 1000)	--CYCLE_SKILL
		
		setElementData(source, "busted", false)
		setElementData(source, "wantedLevel", 0)
		triggerClientEvent(source, "settingsChange", settings)
	end
)

addEventHandler("onPlayerWasted", root,
	function (totalAmmo, killer, killerWeapon, bodypart, stealth)
		setElementData(source, "TIMES_DIED", getPedStat(source, playerStats["TIMES_DIED"])+1, false)
		setElementData(source, "sessionDeaths", (getElementData(source, "sessionDeaths") or 0)+1)
		
		if killer and killer ~= source then
			if getElementType(killer) == "vehicle" then
				killer = getVehicleController(killer)
			end
			
			setElementData(killer, "PEOPLE_KILLED_BY_PLAYER", getPedStat(source, playerStats["PEOPLE_KILLED_BY_PLAYER"])+1, false)
			setElementData(killer, "sessionKills", (getElementData(source, "sessionKills") or 0)+1)
			
			if getElementData(killer, "subclass") == getElementData(source, "subclass") then
				setElementData(killer, "RESPECT", getPedStat(killer, playerStats["RESPECT"])-1, false)
			else
				setElementData(killer, "RESPECT", getPedStat(killer, playerStats["RESPECT"])+1, false)
			end
			
			if bodypart == 9 then
				setElementData(killer, "HEADS_POPPED", getPedStat(killer, playerStats["HEADS_POPPED"])+1, false)
			end
		elseif killerWeapon == 53 then
			setElementData(killer, "TIMES_DROWNED", getPedStat(killer, playerStats["TIMES_DROWNED"])+1, false)
		end
	end
)

addEventHandler("onPlayerDamage", root,
	function (attacker, weapon, bodypart, loss)
		if attacker and attacker ~= source then
			if weapon >= 22 and weapon <= 34 then
				setElementData(attacker, "BULLETS_HIT", getPedStat(attacker, playerStats["BULLETS_HIT"])+1, false)
			end
		end
	end
)

function dataChange(dataName, oldValue)
	local newValue = getElementData(source, dataName)
	oldValue = oldValue or 0
	
	for name,stat in pairs(playerStats) do
		if dataName == name then
			setPedStat(source, stat, newValue)
			updateDB(source, name)
			if stat >= 69 and stat <= 79 then
				setPedStat(source, playerStats["ROUNDS_FIRED"], getPedStat(source, playerStats["ROUNDS_FIRED"])+shotsToIncrease[getWeaponNameFromID(stat-47)])
				updateDB(source, "ROUNDS_FIRED")
			end
			return
		end
	end
	
	if dataName == "wantedLevel" then
		newValue = math.min(newValue, 6)
		setPlayerWantedLevel(source, newValue)
		if newValue > oldValue then
			setElementData(source, "WANTED_STARS_ATTAINED", getPedStat(source, playerStats["WANTED_STARS_ATTAINED"])+(newValue-oldValue), false)
			--setPedStat(source, playerStats["WANTED_STARS_ATTAINED"], getPedStat(source, playerStats["WANTED_STARS_ATTAINED"])+(newValue-oldValue))
			updateDB(source, "WANTED_STARS_ATTAINED")
		end
	elseif dataName == "busted" then
		if newValue then
			setElementData(source, "TIMES_ARRESTED", getPedStat(source, playerStats["TIMES_ARRESTED"])+1, false)
			--setPedStat(source, playerStats["TIMES_ARRESTED"], getPedStat(source, playerStats["TIMES_ARRESTED"])+1)
			updateDB(source, "TIMES_ARRESTED")
		end
	end
end

function updateDB(player, statName)
	local account = getPlayerAccount(player)
	
	if not isGuestAccount(account) then
		local res = executeSQLUpdate("players", statName.." = '"..getPedStat(player, playerStats[statName]).."'", "account = '"..getAccountName(account).."'")
		outputDebugString("updateDB:"..getPlayerName(player)..":"..statName..":"..tostring(res))
	end
end

function initPlayerStats(player)
	local account = getPlayerAccount(player)
	local accountName = getAccountName(account)
	local result = executeSQLQuery("SELECT * FROM players WHERE account=?", accountName)
	
	if (type(result) == "table" and #result == 0) or not result then	--not found in DB
		if not isGuestAccount(account) then								--is logged in
			local init = ""
			for n = 1,numStats do
				if n == numStats then
					init = init.."'0'"
				else
					init = init.."'0',"
				end
			end
			executeSQLInsert("players", "'"..accountName.."',"..init)	--add to DB
			outputDebugString("Adding new player account to DB.")
		end
		
		for name,stat in pairs(playerStats) do							--clear stats
			setElementData(player, name, 0)
			setPedStat(player, stat, 0)
		end
	else																--found in DB
		for name,value in pairs(result[1]) do							--load stats
			local stat = playerStats[name]
			if stat then
				setPedStat(player, stat, value)
			end
		end
		outputDebugString("Player found in DB, loading stats.")
	end
end
