
g_Me = getLocalPlayer();

screenSize = { guiGetScreenSize( ) };

local missionMessage;
local missionFailedText;
local mission_states = {
	["no mission"] 				= 0,
	["just started"]			= 1,
	["first trailer attach"]	= 2,
	["reattach trailer"]		= 3, 
	["back to truck"]			= 4,
}
local cancelFailTimer;

addEvent( "truckMissionStarted", true )
addEventHandler( "truckMissionStarted", getRootElement(),
	function( trailer )
		if not missionStartedText then
			missionStartedText = dxText:create( "TRUCK MISSION\nSTARTED", screenSize[ 1 ] / 2, screenSize[ 2 ] / 2 - screenSize[ 2 ] * .1, false );
			missionStartedText:scale( 2 );
			missionStartedText:color( 0, 200, 0 );
			missionStartedText:font( "bankgothic" );
			missionStartedText:type( "border" );
			missionStartedText.___timer = setTimer( hideMissionStartedText, 4000, 1 );
		else
			if missionStartedText.___timer then
				killTimer( missionStartedText.___timer );
			end
			missionStartedText:visible( true );
			missionStartedText.___timer = setTimer( hideMissionStartedText, 4000, 1 );
		end
		if not missionMessage then
			missionMessage = dxText:create( "Drive to and attach the trailer marked on your radar.", screenSize[ 1 ] * 0.54, screenSize[ 2 ] * .75, false );
			missionMessage:scale( 1.8 );
			missionMessage:type( "border" );
			missionMessage.___timer = setTimer( hideMissionText, 6000, 1 );
		else
			missionMessage:color( 255, 255, 255 );
			missionMessage:text( "Drive to and attach the trailer marked on your radar." );
			missionMessage:visible( true );
			if missionMessage.___timer then
				killTimer( missionMessage.___timer );
			end
			missionMessage.___timer = setTimer( hideMissionText, 6000, 1 );
		end
		if missionFailedText and missionFailedText.___timer then
			missionFailedText:visible( false );
			killTimer( missionFailedText.___timer );
			missionFailedText.___timer = nil;
		end
	end
);

addEvent( "truckMissionComplete", true );
addEventHandler( "truckMissionComplete", getRootElement(),
	function( reward )
		missionCompleteText = dxText:create( "MISSION COMPLETE\nreward: $"..tostring( reward ), screenSize[ 1 ]/2, screenSize[ 2 ] /2, false )
		missionCompleteText:scale( 2 );
		missionCompleteText:color( 0, 200, 0 );
		missionCompleteText:font( "bankgothic" );
		missionCompleteText:type( "border" );
		missionCompleteText.___timer = setTimer( destroyMissionCompleteText, 4000, 1 );
	end
);


addEventHandler( "onClientTrailerAttach", getResourceRootElement(),
	function( )
		if getElementData( source, "IN TRUCK MISSION" ) and source == getElementData( g_Me, "TRUCK TRAILER" ) then --and getElementData( g_Me, "TRUCK MISSION STATE" ) == mission_states["just started"] then
			if getElementData( g_Me, "TRUCK MISSION STATE" ) == mission_states[ "just started" ] then
				missionMessage:text( "You need to deliver this trailer to\nthe destination point marked on your radar." );
				setTimer( hideMissionText, 6000, 1 );
			else
				cancelFailTimer = true;
				missionMessage:visible( true );
				missionMessage:color( 255, 255, 255 );
				missionMessage:text( "Deliver this trailer to the destination point." );
				if missionMessage.___timer then
					killTimer( missionMessage.___timer );
				end
				missionMessage.___timer = setTimer( hideMissionText, 6000, 1 );
			end
		end
	end
);

addEventHandler( "onClientTrailerDetach", getResourceRootElement(),
	function( truck )
		if getElementData( g_Me, "TRUCK MISSION STATE" ) == mission_states[ "first trailer attach" ] 
		 and getElementData( source, "DRIVER" ) == g_Me then
			setElementData( g_Me, "TRUCK MISSION STATE", mission_states[ "reattach trailer" ] );
			if missionMessage.___timer then
				killTimer( missionMessage.___timer );
				missionMessage.___timer = nil;
			end
			
			cancelFailTimer = false;
						
			countDown( 30 );
			missionMessage:visible(true);
		end
	end
);

function hideMissionText( )
	missionMessage.___timer = nil;
	missionMessage:visible(false);
end

function hideMissionStartedText( )
	missionStartedText.___timer = nil;
	missionStartedText:visible( false );
end

function destroyMissionFailedText( )
	missionFailedText.___timer = nil;
	missionFailedText:destroy( );
	missionMessage:visible( false );
end

function destroyMissionCompleteText( )
	missionCompleteText.___timer = nil;
	missionCompleteText:destroy( );
end

function countDown( seconds )
	if seconds >= 0 and not cancelFailTimer then
		if seconds > 0 then
			if seconds < 10 and seconds >= 5 then
				missionMessage:color( 255, 100, 0 );
			elseif seconds < 5 then
				missionMessage:color( 255, 0, 0 );
				playSoundFrontEnd( 45 );
			end
			missionMessage:text( "You have " .. tostring( seconds ) .. " seconds left to reattach the trailer." );
			setTimer( countDown, 1000, 1, seconds - 1 );
		else
			missionFailed( "You didn't reattach trailer on time." );
		end
	end
end

function missionFailed( reason )
	setElementData( g_Me, "TRUCK MISSION STATE", mission_states[ "no mission" ] )
	if missionFailedText and missionFailedText.___timer then
		killTimer( missionFailedText.___timer );
		missionFailedText:destroy();
	end
	missionFailedText = dxText:create( "MISSION FAILED", screenSize[ 1 ] / 2, screenSize[ 2 ] / 2, false );
	missionFailedText:font( "bankgothic" );
	missionFailedText:color( 255, 0, 0 );
	missionFailedText:type( "border" );
	missionFailedText:scale( 2 );
	triggerServerEvent( "c_truckMissionFailed", getRootElement() );
	missionFailedText.___timer = setTimer( destroyMissionFailedText, 5000, 1 );
	if missionMessage.___timer then
		killTimer( missionMessage.___timer );
	end
	if reason then
		missionMessage:color( 255, 0, 0 );
		missionMessage:text( reason );
		missionMessage:visible( true );
	else
		missionMessage:visible( false );
	end
	missionMessage.___timer = setTimer( hideMissionText, 5000, 1 );
end

addEventHandler( "onClientPlayerVehicleExit", getRootElement( ),
	function( vehicle )
		if getElementData( g_Me, "TRUCK TRAILER" ) and source == g_Me then
			missionStartedText:visible( false );
			missionFailed( "You left vehicle while on mission." );
		end
	end
)