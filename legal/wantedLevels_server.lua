--Increase wanted level for killing, unless an authority kills a wanted player
addEventHandler("onPlayerWasted", root,
	function (totalAmmo, killer, killerWeapon, bodypart)
		if killer and killer ~= source then
			if getElementType(killer) == "vehicle" then
				killer = getVehicleController(killer)
			end
			
			local killerWantedLevel = getElementData(killer, "wantedLevel") or 0
			if getElementData(killer, "class") == "Authorities" then
				if getElementData(source, "wantedLevel") < 1 then
					if killerWantedLevel < 6 then
						setElementData(killer, "wantedLevel", killerWantedLevel+1)
					end
				end
			else
				if killerWantedLevel < 6 then
					setElementData(killer, "wantedLevel", killerWantedLevel+1)
				end
			end
		end
	end
)

--Increase wanted level for assaulting an authority
addEventHandler("onPlayerDamage", root,
	function (attacker, attackerweapon, bodypart, loss)
		if attacker then
			if getElementType(attacker) == "vehicle" then
				attacker = getVehicleController(attacker)
			end
	
			if attacker ~= source and attacker ~= getElementData(source, "attacker") and getElementData(source, "class") == "Authorities" and getElementData(attacker, "class") ~= "Authorities" then
--			if attacker ~= source and attacker ~= getElementData(source, "attacker") and getElementData(source, "class") == "Authorities" then
--			if attacker ~= getElementData(source, "attacker") and getElementData(source, "class") == "Authorities" then
				setElementData(source, "attacker", attacker, false)
				setTimer(setElementData, 15000, 1, source, "attacker", nil, false)
				local attackerWantedLevel = getElementData(attacker, "wantedLevel") or 0
				if attackerWantedLevel < 6 then
					setElementData(attacker, "wantedLevel", attackerWantedLevel+1)
				end
			end
		end
	end
)

--Increase wanted level for carjacking, except for authorities
addEventHandler("onPlayerVehicleExit", root,
	function (theVehicle, seat, jacker)
		if jacker then
			if getElementData(jacker, "class") ~= "Authorities" then
				local jackerWantedLevel = getElementData(jacker, "wantedLevel")
				if jackerWantedLevel < 6 then
					setElementData(jacker, "wantedLevel", jackerWantedLevel+1)
				end
			end
		end
	end
)

-- WANTED LEVEL IF A COP SEES SOMEONE DOING SOMETHING ILLEGAL
-- TO MAKE THIS WORK WITH YOUR SCRIPT, SET A PLAYERS ELEMENT DATA "legalStatus" TO "illegal" WHILE DOING SOMETHING ILLEGAL
-- DONT FORGET TO CHANGE IT TO nil AFTERWARDS THOUGH!!
addEventHandler("onPlayerTarget", root,
	function (element)
		if element then
			if getElementType(element) == "player" and getElementData(source, "class") ~= "Authorities" then
				if getElementData(element, "legalStatus") == "illegal" then
					local cx, cy, cz = getElementPosition(source)
					local px, py, pz = getElementPosition(element)
					if getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz) < 15 then
--						local wantedLevel = getPlayerWantedLevel(element)
						local wantedLevel = getElementData(element, "wantedLevel")
						if wantedLevel < 6 then
--							setPlayerWantedLevel(element, wantedLevel+1)
							setElementData(element, "wantedLevel", wantedLevel+1)
						end
					end
				end
			end
		end
	end
)
