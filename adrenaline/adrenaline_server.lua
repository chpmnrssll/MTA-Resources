addCommandHandler("createAD",
function (player, command)
	local x,y,z = getElementPosition(player)
	local rotation = -getPedRotation(player)
	local interior = getElementInterior(player)
	local dimension = getElementDimension(player)
	local tx,ty = getPointFromDistanceRotation(x,y, 2, rotation)
	local adrenaline = exports.objectPickup:createObjectPickup(tx,ty,z-0.75, "adrenaline", 1241, 1, interior, dimension)
	addEventHandler("objectPickupHit", adrenaline,
		function (player)
			triggerClientEvent(player, "adrenalineStart", player)
		end
	)
end
)

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90-angle)
	local dx = math.cos(a)*dist
	local dy = math.sin(a)*dist
	return x+dx, y+dy
end