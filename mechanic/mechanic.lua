function healVehicle(playerSource)
	hp = getElementHealth(source)
	if hp <= 1000 then
		setElementHealth ( source,hp+1 )
		givePlayerMoney ( playerSource, 1 )
	else
		fixVehicle(source)
	end
		
end

addEvent("healVehicle", true)
addEventHandler ( "healVehicle", getRootElement(), healVehicle)