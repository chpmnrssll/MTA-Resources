addEventHandler("onResourceStart", resourceRoot,
	function ()
		for i,briefcase in ipairs(getElementsByType("briefcase")) do
			spawnBriefcase(briefcase)
		end
	end
)

function spawnBriefcase(briefcase)
	local pickup = exports.objectPickup:createObjectPickup(getElementData(briefcase,"posX"),getElementData(briefcase,"posY"),getElementData(briefcase,"posZ"), "briefcase", 1210, 1, getElementData(briefcase,"interior"), getElementData(briefcase,"dimension"))
	setElementData(pickup, "briefcase", briefcase)
	addEventHandler("objectPickupHit", pickup,
		function (player)
			triggerClientEvent(player, "espionageStart", source)
		end
	)
end

addEvent("spawnBriefcase", true)
addEventHandler("spawnBriefcase", getRootElement(), spawnBriefcase)

addEvent("stoleBriefcase", true)
addEventHandler("stoleBriefcase", getRootElement(),
	function (briefcase)
		spawnBriefcase(briefcase)
		givePlayerMoney(source, 1000)
		setElementData(source, "totalBriefcases", (getElementData(source, "totalBriefcases") or 0)+1)
	end
)
