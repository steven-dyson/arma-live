/***************************************************************************
SPY INIT AND COMPILE (METHOD)
SPY SYSTEMS SERVER
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT: SERVER
****************************************************************************/
private ["_center", "_group", "_queue", "_fnc", "_connect", "_bstats", "_airOps", "_farp", "_meSys"];

if ((isNil ("SPY_GAMELOGIC"))) then {

	_center = createCenter sideLogic;
	_group = createGroup _center;
	SPY_GAMELOGIC = _group createUnit ["LOGIC", [0, 0, 0], [], 0, "NONE"];
	publicVariable "SPY_GAMELOGIC";

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
EXEC SCRIPTS: SERVER
****************************************************************************/		
_connect = [] execVM "SPY\SPY_connect\SPY_initServer.sqf";
waitUntil {sleep 0.1; scriptDone _connect};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: CONNECT INITILIZED (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

_fnc = [] execVM "SPY\SPY_fnc\SPY_initServer.sqf";
waitUntil {sleep 0.1; scriptDone _fnc};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: FUNCTIONS SET (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

_queue = [] execVM "SPY\SPY_queue\SPY_initServer.sqf";
waitUntil {sleep 0.1; scriptDone _queue};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: QUEUE OPERATIONAL (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

_bstats = [] execVM "SPY\SPY_bStats\SPY_initServer.sqf";
waitUntil {sleep 0.1; scriptDone _bstats};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: BSTATS OPERATIONAL (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

// _mesys = [] execVM "SPY\SPY_meSys\SPY_initServer.sqf";
// waitUntil {sleep 0.1; scriptDone _mesys};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: MESYS INITILIZED (SERVER)';", "CLIENT"] spawn JDAM_mpCB;

// _farp = [] execVM "SPY\SPY_farp\SPY_initServer.sqf";
// waitUntil {sleep 0.1; scriptDone _farp};
// _null = [[], "SPY_GAMELOGIC globalChat 'SPY: FARP INITILIZED (SERVER)';", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/