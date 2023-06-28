/***************************************************************************
INIT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
TIME CRITICAL: SERVER
****************************************************************************/
private ["_spySettings"];

if ((isServer)) then {

	onPlayerConnected {_null = [_uid] execVM "SPY\SPY_connect\SPY_onPlayerConnected.sqf";};
	onPlayerDisconnected {_null = [_uid] execVM "SPY\SPY_connect\SPY_onPlayerDisconnected.sqf";};
	
	_null = [] execVM "SPY\SPY_oNetU.sqf";
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
TIME CRITICAL: CLIENT
****************************************************************************/
if ((!(isDedicated))) then {

	// VARIABLES
	if ((isNil "SPY_SERVER_INITILIZED")) then {SPY_JIP_CLIENT = false;} else {SPY_JIP_CLIENT = true;};

	// EXEC
	// _null = [] execVM "SPY\SPY_meSys\SPY_loadingProgress.sqf";
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MISSION SCRIPTS
****************************************************************************/
// COPY AND PASTE YOUR INIT.SQF HERE
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
INIT SCRIPTS: SERVER
****************************************************************************/
if ((isServer)) then {

	private ["_jdamServer", "_spyServer", "_mhjServer"];
	
	_spySettings = [] execVM "\userconfig\SPY\SPY_settingsInit.sqf";
	waitUntil {sleep 0.1; scriptDone _spySettings};
	
	waitUntil {time > 0};
	
	_jdamServer = [] execVM "JDAM\JDAM_initServer.sqf";
	waitUntil {sleep 0.1; scriptDone _jdamServer};
	// JDAM_GAMELOGIC globalChat "JDAM: SYSTEMS INITILIZED (SERVER)";

	_spyServer = [] execVM "SPY\SPY_initServer.sqf";
	waitUntil {sleep 0.1; scriptDone _spyServer};
	// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: SYSTEMS INITILIZED (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

	_mhjServer = [] execVM "MHJ\SPY_initServer.sqf";
	waitUntil {sleep 0.1; scriptDone _mhjServer};
	// _null = [[], "SPY_GAMELOGIC globalChat 'MHJ: SYSTEMS INITILIZED (SERVER)';", "CLIENT"] spawn JDAM_mpCB;
	
	SPY_SERVER_INITILIZED = true;
	publicVariable "SPY_SERVER_INITILIZED";
	// _null = [[], "SPY_GAMELOGIC globalChat 'SERVER INITILIZED';", "CLIENT"] spawn JDAM_mpCB;
	
	// DEMO MISSION ENDING SCRIPT
	_null = [] execVM "SPY_demoEnd.sqf";
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
INIT: CLIENT
****************************************************************************/	
if ((!isDedicated)) then {

	waitUntil {(!(isNull player))};

	enableSaving [false, false];
	enableSentences false;
	player enableAttack false;

	waitUntil {sleep 0.1; (!(isNil "SPY_SERVER_INITILIZED"))};

	waitUntil {sleep 0.1; SPY_SERVER_INITILIZED};
/***************************************************************************
END
****************************************************************************/	
	
	
	
/***************************************************************************
INIT SCRIPTS: CLIENT
****************************************************************************/
	private ["_jdamClient", "_spyClient"];
	
	_jdamClient = [] execVM "JDAM\JDAM_initClient.sqf";
	waitUntil {sleep 0.1; scriptDone _jdamClient};
	// JDAM_GAMELOGIC globalChat "JDAM: SYSTEMS INITILIZED (ALL)";
	
	_spyClient = [] execVM "SPY\SPY_initClient.sqf";
	waitUntil {sleep 0.1; scriptDone _spyClient};
	// SPY_GAMELOGIC globalChat "SPY: SYSTEMS INITILIZED (CLIENT)";
	
	SPY_GAMELOGIC globalChat format ["WELCOME %1, ENJOY YOUR STAY...", (name player)];
	
};
/***************************************************************************
END
****************************************************************************/