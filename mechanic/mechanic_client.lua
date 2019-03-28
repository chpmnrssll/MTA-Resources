function check(weapon, ammo, ammoInClip,hitX, hitY, hitZ, hitElement)
	if getTeamName(getPlayerTeam(getLocalPlayer())) == "Mechanic" then
		if hitElement then
			if getElementType(hitElement) == "vehicle" and weapon == 41 then
				triggerServerEvent ( "healVehicle", hitElement, getLocalPlayer())
			end
		end
	end
end


addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), check )