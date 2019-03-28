local localPlayer = getLocalPlayer()

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
		if weapon >= 22 and weapon <= 38 and weapon ~= 37 then
			local x,y,z = getElementPosition(localPlayer)
			createExplosion(x,y,z-10, 12, false, 0.18, false)
		end
	end
)
