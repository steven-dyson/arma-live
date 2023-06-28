/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
EXEC SCRIPTS: CLIENT
****************************************************************************/
private ["_connect", "_bstats", "_fnc", "_ceh", "_meSys", "_airOps", "_farp"];

_connect = [] execVM "SPY\SPY_connect\SPY_initClient.sqf";
waitUntil {sleep 0.1; scriptDone _connect};
// SPY_GAMELOGIC globalChat "SPY: CONNECT OPERATION COMPLETE (CLIENT)";

_fnc = [] execVM "SPY\SPY_fnc\SPY_initClient.sqf";
waitUntil {sleep 0.1; scriptDone _fnc};
// SPY_GAMELOGIC globalChat "SPY: FUNCTIONS SET (CLIENT)";

_bstats = [] execVM "SPY\SPY_bStats\SPY_initClient.sqf";
waitUntil {sleep 0.1; scriptDone _bstats};
// SPY_GAMELOGIC globalChat "SPY: BSTATS OPERATIONAL (CLIENT)";

_ceh = [] execVM "SPY\SPY_ceh\SPY_initClient.sqf";
waitUntil {sleep 0.1; scriptDone _ceh};
// SPY_GAMELOGIC globalChat "SPY: CEH OPERATIONAL (CLIENT)";

// _airOps = [] execVM "SPY\SPY_airOps\SPY_initClient.sqf";
// waitUntil {sleep 0.1; scriptDone _airOps};
// SPY_GAMELOGIC globalChat "SPY: AIROPS INITILIZED (CLIENT)";

// _mesys = [] execVM "SPY\SPY_meSys\SPY_initClient.sqf";
// waitUntil {sleep 0.1; scriptDone _mesys};
// SPY_GAMELOGIC globalChat "SPY: MESYS INITILIZED (CLIENT)";

// _farp = [] execVM "SPY\SPY_farp\SPY_initClient.sqf";
// waitUntil {sleep 0.1; scriptDone _farp};
// SPY_GAMELOGIC globalChat "SPY: FARP INITILIZED (CLIENT)";
/***************************************************************************
END
****************************************************************************/