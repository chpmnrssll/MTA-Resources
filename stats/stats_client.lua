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
	["MEALS_EATEN"] = 200
}

local currentWeapon = nil
local shotsToIncrease = {}
local currentShotsFired = 1

addEvent("settingsChange", true)
addEventHandler("settingsChange", root,
	function ()
		shotsToIncrease["Colt 45"] = getElementData(source, "Colt 45")
		shotsToIncrease["Silenced"] = getElementData(source, "Silenced")
		shotsToIncrease["Deagle"] = getElementData(source, "Deagle")
		shotsToIncrease["Shotgun"] = getElementData(source, "Shotgun")
		shotsToIncrease["Sawed-off"] = getElementData(source, "Sawed-off")
		shotsToIncrease["Combat Shotgun"] = getElementData(source, "Combat Shotgun")
		shotsToIncrease["Uzi"] = getElementData(source, "Uzi")
		shotsToIncrease["MP5"] = getElementData(source, "MP5")
		shotsToIncrease["AK-47"] = getElementData(source, "AK-47")
		shotsToIncrease["M4"] = getElementData(source, "M4")
		shotsToIncrease["Sniper"] = getElementData(source, "Sniper")
	end
)

--increases weapon stats when fired every (shotsToIncrease) times
addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weapon, ammo, ammoInClip, hitX,hitY,hitZ, hitElement)
		if weapon == currentWeapon then
			local increase = shotsToIncrease[getWeaponNameFromID(weapon)] or 1
			if currentShotsFired < increase then
				currentShotsFired = currentShotsFired+1
			else
				if weapon == 32 then		--tec-9 == uzi
					weapon = 28
				end
				
				local statName = getWeaponStat(getWeaponNameFromID(weapon))
				if statName then
					local statValue = getPedStat(localPlayer, playerStats[statName])
					if (weapon == 26 or weapon == 28) and statValue >= 998 then			--sawn-off and tec9/uzi never go over 998
						return
					else
						setElementData(localPlayer, statName, statValue+1)
						currentShotsFired = 1
					end
				end
			end
		else
			currentWeapon = weapon
			currentShotsFired = 1
		end
		
		if weapon == 16 or weapon == 39 then
			setElementData(localPlayer, "EXPLOSIVES_USED", getPedStat(localPlayer, playerStats["EXPLOSIVES_USED"])+1)
		end
	end
)

function getWeaponStat(weaponName)
	if weaponName == "Colt 45" then
		return "WEAPONTYPE_PISTOL_SKILL"
	elseif weaponName == "Silenced" then
		return "WEAPONTYPE_PISTOL_SILENCED_SKILL"
	elseif weaponName == "Deagle" then
		return "WEAPONTYPE_DESERT_EAGLE_SKILL"
	elseif weaponName == "Shotgun" then
		return "WEAPONTYPE_SHOTGUN_SKILL"
	elseif weaponName == "Sawed-off" then
		return "WEAPONTYPE_SAWNOFF_SHOTGUN_SKILL"
	elseif weaponName == "Combat Shotgun" then
		return "WEAPONTYPE_SPAS12_SHOTGUN_SKILL"
	elseif weaponName == "Uzi" then
		return "WEAPONTYPE_MICRO_UZI_SKILL"
	elseif weaponName == "MP5" then
		return "WEAPONTYPE_MP5_SKILL"
	elseif weaponName == "AK-47" then
		return "WEAPONTYPE_AK47_SKILL"
	elseif weaponName == "M4" then
		return "WEAPONTYPE_M4_SKILL"
	elseif weaponName == "Sniper" then
		return "WEAPONTYPE_SNIPERRIFLE_SKILL"
	else
		return false
	end
end
