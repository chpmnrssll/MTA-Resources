local bodies = {}

addEventHandler("onPlayerWasted", root,
	function (totalAmmo, killer, killerWeapon, bodypart, stealth)
		if getPedOccupiedVehicle(source) then return end
		if not bodies[source] then
			bodies[source] = {}
		end
		bodies[source].skin = getPedSkin(source)
		bodies[source].x,bodies[source].y,bodies[source].z = getElementPosition(source)
		bodies[source].rotation = getPedRotation(source)
		bodies[source].interior = getElementInterior(source)
		bodies[source].dimension = getElementDimension(source)
	end
)

addEventHandler("onPlayerSpawn", root,
	function (posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension)
		if bodies[source] then
			if bodies[source].ped then
				destroyElement(bodies[source].ped)
			end
			bodies[source].ped = createPed(bodies[source].skin, bodies[source].x,bodies[source].y,bodies[source].z)
			setElementInterior(bodies[source].ped, bodies[source].interior)
			setElementDimension(bodies[source].ped, bodies[source].dimension)
			setPedRotation(bodies[source].ped, bodies[source].rotation)
			killPed(bodies[source].ped)
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function (reason)
		if bodies[source] then
			destroyElement(bodies[source].ped)
			bodies[source] = nil
		end
	end
)
