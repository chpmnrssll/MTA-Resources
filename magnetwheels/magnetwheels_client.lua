allClientPlayers = {}
turnoff = {}

function start()
    setPedCanBeKnockedOffBike(getLocalPlayer(),false)
    addEventHandler("onClientPlayerVehicleEnter",getLocalPlayer(),addGravityFinder)
    addEventHandler("onClientPlayerVehicleExit",getLocalPlayer(),removeGravityFinder)
end

function addGravityFinder(veh)
    addEventHandler("onClientRender",getRootElement(),magnetWheels)
	setElementHealth(veh,1000000)
end

function removeGravityFinder(veh)
    removeEventHandler("onClientRender",getRootElement(),magnetWheels)
end

function magnetWheels()
    local veh = getPedOccupiedVehicle(getLocalPlayer())
	local x,y,z = getElementPosition(veh)
    local underx,undery,underz = getPositionUnderTheElement(veh)
	local gravity = getGravity()
	local vx,vy,vz = getVehicleGravity(veh)
	--if isVehicleOnGround(veh) then
		--setVehicleGravity(veh, underx - x,undery - y,underz - z - gravity)
		setVehicleGravity(veh, vx,vy,vz+underz-z)
	--end
end

function getPositionUnderTheElement(element)
    local matrix = getElementMatrix (element)
    local offX = 0 * matrix[1][1] + 0 * matrix[2][1] - 1 * matrix[3][1] + matrix[4][1]
    local offY = 0 * matrix[1][2] + 0 * matrix[2][2] - 1 * matrix[3][2] + matrix[4][2]
    local offZ = 0 * matrix[1][3] + 0 * matrix[2][3] - 1 * matrix[3][3] + matrix[4][3]
    return offX,offY,offZ
end

function stopMagnets(player)
    if not turnoff[player] then
	    removeEventHandler("onClientPlayerVehicleEnter",getLocalPlayer(),addGravityFinder)
	    removeEventHandler("onClientPlayerVehicleExit",getLocalPlayer(),removeGravityFinder)
		removeEventHandler("onClientRender",getRootElement(),magnetWheels)    
		setPedCanBeKnockedOffBike(getLocalPlayer(),true)
		veh = getPedOccupiedVehicle(getLocalPlayer())
	    if veh then
	        setVehicleGravity(veh,0,0,-1)
	    end
	    turnoff[player] = true
	else
	    addEventHandler("onClientPlayerVehicleEnter",getLocalPlayer(),addGravityFinder)
        addEventHandler("onClientPlayerVehicleExit",getLocalPlayer(),removeGravityFinder)
		addEventHandler("onClientRender",getRootElement(),magnetWheels)
		setPedCanBeKnockedOffBike(getLocalPlayer(),false)
		turnoff[player] = nil
	end
end

addCommandHandler("magnet",stopMagnets)
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),start)