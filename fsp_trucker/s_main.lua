
local truckerTeam;
local mission_states = {
	["no mission"] 				= 0,
	["just started"]			= 1,
	["first trailer attach"]	= 2,
	["reattach trailer"]		= 3, 
	["back to truck"]			= 4,
}

local truck_mission = {
	[403] = 435,
	[514] = 584,
}

local destination_types = {
	[403] = "box_destination",
	[514] = "oil_destination",
}



addEventHandler( "onResourceStart", getResourceRootElement(),
	function( )
		truckerTeam = getTeamFromName( "Trucker" );
		for k, plr in pairs( getPlayersInTeam( truckerTeam ) ) do
			setElementData( plr, "TRUCK MISSION DESTINATION", nil );
			setElementData( plr, "TRUCK TRAILER", nil );
			setElementData( plr, "TRUCK MISSION STATE", mission_states[ "no mission" ] )
			setElementData( plr, "TRUCK MISSION DEST MARKER", nil )
		end
	end
);


addEventHandler( "onPlayerVehicleEnter", getRootElement(),
	function( veh, seat )
		local vehModel = getElementModel( veh );
		if vehModel and seat == 0 and getPlayerTeam( source ) == truckerTeam then
			if vehModel == 403 or vehModel == 514 then
				local trailer = getRandomTrailer( vehModel );
				startMission( source, trailer );
			end
		end
	end
);

addEventHandler( "onTrailerAttach", getResourceRootElement(),
	function( truck )
		local driver = getVehicleOccupant( truck );
		if getElementData( source, "IN TRUCK MISSION" ) and getElementData( source, "DRIVER" ) == driver then
			missionTrailerAttached( driver, source, getElementData( driver, "TRUCK MISSION STATE" ) );
		end
	end
);

addEventHandler( "onTrailerDetach", getResourceRootElement(),
	function( truck )
		local driver = getVehicleController( truck );
		if driver then
			if getElementData( driver, "TRUCK MISSION STATE" ) == mission_states[ "first trailer attach" ]
			  and getElementData( source, "DRIVER" ) == driver then
				missionTrailerDetached( driver, source, getElementData( driver, "TRUCK MISSION STATE" ) );
			end
		end
	end
);

addEventHandler( "onPlayerVehicleExit", getRootElement(),
	function( vehicle )
		if getElementData( source, "TRUCK TRAILER" ) then
			--triggerEvent( "truckMissionFailed", source );
		end
		local timer = getElementData( source, "NEXT MISSION TIMER" );
		if timer then
			killTimer( timer );
			setElementData( source, "NEXT MISSION TIMER", nil );
		end	
	end
);

addEventHandler( "onPlayerWasted", getRootElement(),
	function( )
	
	end
);

addEvent( "c_truckMissionFailed", true )
addEventHandler( "c_truckMissionFailed", getRootElement(),
	function( plr, reason )
		local trailer = getElementData( client, "TRUCK TRAILER" );
		unmarkTrailer( trailer );
		respawnVehicle( trailer );
		setElementData( trailer, "IN TRUCK MISSION", false );
		setElementData( trailer, "DRIVER", nil );
		setElementData( client or plr, "TRUCK TRAILER", nil );
		setElementData( client or plr, "TRUCK MISSION DESTINATION", nil );
		setElementData( client or plr, "TRUCK MISSION STATE", mission_states[ "no mission" ] )
		setElementData( client or plr, "TRUCK MISSION DEST MARKER", nil )
	end
);



function startMission( player, trailer )
	local timer = getElementData( player, "NEXT MISSION TIMER" );
	if timer then
		killTimer( timer );
		setElementData( player, "NEXT MISSION TIMER", nil );
	end
	triggerClientEvent( player, "truckMissionStarted", trailer );
	setElementData( trailer, "IN TRUCK MISSION", true );
	setElementData( trailer, "DRIVER", player );
	setElementData( player, "TRUCK MISSION STATE", mission_states["just started"] );
	setElementData( player, "TRUCK TRAILER", trailer );
	markTrailer( player, trailer );
end

function markTrailer( player, trailer )
	local arrowMarker = createMarker( 0, 0, 0, "arrow", 1, 255, 255, 0, 125, player );
	createBlipAttachedTo( trailer, 51, 1, 255, 255, 0, 255, 0, 8000, player );
	attachElements( arrowMarker, trailer, 0, 0, 4 );
end

function unmarkTrailer( trailer )
	local attachedElements = getAttachedElements( trailer );
	if attachedElements then
		for k, v in pairs( attachedElements ) do
			destroyElement( v );
		end
	end
end

function getRandomTrailer( vehModel )
	local trailers = getElementsByType( "vehicle", getResourceRootElement( ) );
	local rndTrailers = { };
	for i, trailer in pairs( trailers ) do
		if truck_mission[ vehModel ] == getElementModel( trailer ) then
			if not getElementData( trailer, "IN TRUCK MISSION" ) then
				table.insert( rndTrailers, trailer );
			end
		end
	end
	math.randomseed( getTickCount() );
	return rndTrailers[ math.random( 1, #rndTrailers ) ]
end

function markTruck( player )
	local arrowMarker = createMarker( 0, 0, 0, "arrow", 1, 255, 255, 0, 125, player );
	local truck = getElementData( player, "TRUCK TRAILER" );
	createBlipAttachedTo( truck, 51, 1, 255, 255, 0, 255, 0, 8000, player );
	attachElements( arrowMarker, truck, 0, 0, 4 );
end

function unmarkTruck( player )
	local truck = getElementData( player, "TRUCK TRAILER" );
	local attachedElements = getAttachedElements( truck );
	if attachedElements then
		for k, v in pairs( attachedElements ) do
			destroyElement( v );
		end
	end
end

function missionTrailerAttached( driver, trailer, missionState )
	unmarkTrailer( trailer );
	if missionState == mission_states[ "just started" ] or missionState == mission_states[ "reattach trailer" ] then
		setElementData( driver, "TRUCK MISSION STATE", mission_states[ "first trailer attach" ] );
		local dest = getElementData( driver, "TRUCK MISSION DESTINATION" );
		if not dest then
			local veh = getPedOccupiedVehicle( driver );
			local dests = getElementsByType( destination_types[ getElementModel( veh ) ], getResourceRootElement() );
			dest = dests[ math.random( 1, #dests ) ];
			setElementData( driver, "TRUCK MISSION DESTINATION", dest );
			setElementData( driver, "TRUCK MISSION START POS", { getElementPosition( trailer ) } );
		end
		setPlayerMissionDestination( driver, dest )
	end
end

function missionTrailerDetached( driver, trailer, missionState )
	if missionState == mission_states[ "first trailer attach" ] then
		setElementData( driver, "TRUCK MISSION STATE", mission_states[ "reattach attach" ] );
		markTrailer( driver, trailer );
		destroyPlayerMissionDestination( driver );
	end
end

function setPlayerMissionDestination( driver )
	local destElement = getElementData( driver, "TRUCK MISSION DESTINATION" );
	local x = getElementData( destElement, "posX" );
	local y = getElementData( destElement, "posY" );
	local z = getElementData( destElement, "posZ" );
	local marker = createMarker( x, y, z-1, "cylinder", 3, 255, 0, 0, 120, driver );
	addEventHandler( "onMarkerHit", marker, destinationMarkerHit, false );
	createBlipAttachedTo( marker, 0, 3, 255, 0, 0, 255, 0, 8000, driver );
	setElementData( driver, "TRUCK MISSION DEST MARKER", marker );
end

function destroyPlayerMissionDestination( driver )
	local marker = getElementData( driver, "TRUCK MISSION DEST MARKER" );
	if marker then
		local attached = getAttachedElements( marker );
		for k, v in pairs( attached ) do
			destroyElement( v );
		end
		destroyElement( marker );
		setElementData( driver, "TRUCK MISSION DEST MARKER", nil );
	end
end


function destinationMarkerHit( veh )
	if getElementType( veh ) == "vehicle" then
		local trailer = getVehicleTowedByVehicle( veh );
		if trailer then
			local driver = getVehicleOccupant( veh );
			setElementData( trailer, "IN TRUCK MISSION", false );
			destroyPlayerMissionDestination( driver );
			missionComplete( driver );
			--setVehicleFrozen( trailer, true );
			local x = getElementData( trailer, "posX" );
			local y = getElementData( trailer, "posY" );
			local z = getElementData( trailer, "posZ" );
			local rotX = getElementData( trailer, "rotX" );
			local rotY = getElementData( trailer, "rotY" );
			local rotZ = getElementData( trailer, "rotZ" );
			local model = getElementModel( trailer );			
			destroyElement( trailer );
			local newTrailer = createVehicle( model, x, y, z,
				(rotX) and rotX or 0,
				(rotY) and rotY or 0,
				(rotZ) and rotZ or 0
			);
			setElementData( newTrailer, "posX", x );
			setElementData( newTrailer, "posY", y );
			setElementData( newTrailer, "posZ", z );
			setElementData( newTrailer, "rotX", rotX );
			setElementData( newTrailer, "rotY", rotY );
			setElementData( newTrailer, "rotZ", rotZ );
			
			local randomTrailer = getRandomTrailer( getElementModel( veh ) );
			setElementData( driver, "NEXT MISSION TIMER", setTimer( startMission, 4500, 1, driver, randomTrailer ) );
		end
	end
end

function missionComplete( driver )
	setElementData( driver, "TRUCK TRAILER", nil );
	setElementData( driver, "TRUCK MISSION DESTINATION", nil );
	setElementData( driver, "TRUCK MISSION DEST MARKER", nil );
	setElementData( driver, "TRUCK MISSION STATE", mission_states[ "no mission" ] );
	local startPos = getElementData( driver, "TRUCK MISSION START POS" );
	local endPosX, endPosY, endPosZ = getElementPosition( driver );
	local distance = getDistanceBetweenPoints3D( startPos[ 1 ], startPos[ 2 ], startPos[ 3 ], endPosX, endPosY, endPosZ );
	local reward = math.floor( distance * 3 );
	givePlayerMoney( driver, reward );
	triggerClientEvent( driver, "truckMissionComplete", getRootElement(), reward );
end
