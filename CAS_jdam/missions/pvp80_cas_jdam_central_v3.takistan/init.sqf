/***************************************************************************
Init
Created by Spyder
spyder@armalive.com
****************************************************************************/



/***************************************************************************
Time Critical: Server
****************************************************************************/
if ((isServer)) then {

	onPlayerConnected {_null = [_uid] execVM "SPY\SPY_bStats\events\SPY_onPlayerConnected.sqf";};
	onPlayerDisconnected {_null = [_uid] execVM "SPY\SPY_bStats\events\SPY_onPlayerDisconnected.sqf";};
	
};
/***************************************************************************
Time Critical: Server
****************************************************************************/



/***************************************************************************
Time Critical: Client
****************************************************************************/
if ((!isDedicated)) then {

	enableSentences false;
	enableSaving [false, false];
	player enableAttack false;
	
	// Define JIP player
	if ((isNil "SPY_SERVER_INITILIZED")) then {
	
		SPY_JIP_CLIENT = false;
	
	} else {
	
		SPY_JIP_CLIENT = true;
		
	};
	
	// _null = [] execVM "SPY\SPY_meSys\SPY_intro_c.sqf";
	
};
/***************************************************************************
Time Critical: Client
****************************************************************************/



/***************************************************************************
Non SPY IAC Scripts
****************************************************************************/
// Server
if (isServer) then {

	// Weather
	wtime1 = ((random 300) + 1000); //Time for Fog change
	wtime2 = ((random 300) + 1000); //Time for Overcast change
	wtime3 = ((random 300) + 700); //Time for Rain change
	wfog1 = (random 0.75); //Min. fog
	wfog2 = (random 0.5); // Max. fog
	woc1 = (random 0.6); //Min. overcast
	woc2 = (random 0.7); //Max. overcast
	wrain1 = (random 0.8); //Min. rain
	wrain2 = (random 0.8); //Max. rain
	publicVariable "wtime1";
	publicVariable "wtime2";
	publicVariable "wtime3";
	publicVariable "wfog1";
	publicVariable "wfog2";
	publicVariable "wrain1";
	publicVariable "wrain2";
	publicVariable "woc1";
	publicVariable "woc2";

	// Clear Bodies
	_null = [] execVM "scripts\clearBodies.sqf";
  
};

// Client
if ((!isDedicated)) then {

	// ICE Squad Management
	_null = [] execVM "ICE\ICE_questionHUD\init.sqf";
	_null = [] execVM "ICE\ice_squadManagement\init.sqf";
	_null = [] execVM "ICE\ice_squadManagement\initPlayer.sqf";
	
	// Helmet Cam
	// _null = [] execVM "scripts\inithcam.sqf";

};

// Weather All
[] execVM "scripts\weather.sqf";
[] execVM "scripts\DW_init.sqf";
/***************************************************************************
Non SPY IAC Scripts
****************************************************************************/



/***************************************************************************
Server
****************************************************************************/
if ((isServer)) then {

	waitUntil {time > 0};

	private ["_cas_s", "_spy_s"];

	_cas_s = [] execVM "CAS\CAS_init_s.sqf";
	waitUntil {sleep 0.1; scriptDone _cas_s};

	_spy_s = [] execVM "SPY\SPY_init_s.sqf";
	waitUntil {sleep 0.1; scriptDone _spy_s};
	
	SPY_SERVER_INITILIZED = true;
	publicVariable "SPY_SERVER_INITILIZED";

};
/***************************************************************************
Server
****************************************************************************/



/***************************************************************************
Client
****************************************************************************/	
if ((!isDedicated)) then {

	private ["_cas_c", "_spy_c", "_ice_sm", "_ice_qh"];
	
	waitUntil {sleep 0.1; ((!isNull player) && (!isNil "SPY_SERVER_INITILIZED"))};
	
	waitUntil {sleep 0.1; SPY_SERVER_INITILIZED};
	
	_cas_c = [] execVM "CAS\CAS_init_c.sqf";
	waitUntil {sleep 0.1; scriptDone _cas_c};

	_spy_c = [] execVM "SPY\SPY_init_c.sqf";
	waitUntil {sleep 0.1; scriptDone _spy_c};
	
	SPY_initilized_client = true;

};
/***************************************************************************
Client
****************************************************************************/	