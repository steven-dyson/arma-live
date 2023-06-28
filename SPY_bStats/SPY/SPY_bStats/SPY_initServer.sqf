/***************************************************************************
SPY INIT AND COMPILE (METHOD)
SPY BSTATS SERVER
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
DEFINE VARIABLES: ALL SERVER

MISSION INFO: [MISSION NAME, MISSION NUMBER, TEAM ONE NAME, TEAM TWO NAME]
SIDE SCORE: [WEST KILLS, WEST DEATHS, EAST KILLS, EAST DEATHS]
****************************************************************************/
private ["_serverName", "_teamOne", "_teamTwo", "_compile"];

if ((!(SPY_BSTATS_ENABLED))) exitWith {};

_serverName = "DAO-XR [ALS] Valhalla";
_teamOne = "BLUFOR";
_teamTwo = "OPFOR";

SPY_GAMELOGIC setVariable ["SPY_MISSION_INFO", [_serverName, missionName, _teamOne, _teamTwo], true];
SPY_GAMELOGIC setVariable ["SPY_SIDE_SCORE", [0, 0, 0, 0], true]; // %NOTE% This may be affected by JIP bug, test
SPY_GAMELOGIC setVariable ["MHJ_A2U_MODE", ["NOT RUNNING", "NOT RANKED UN-OFFICIAL"], true];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MONITOR BALANCE
****************************************************************************/
_null = [] execVM "SPY\SPY_bStats\balance\SPY_rankingChange.sqf";
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
COMPILE: DEDICATED SERVER
****************************************************************************/
if ((!isDedicated)) exitWith {};

_compile = [] execVM "SPY\SPY_bStats\SPY_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};
/***************************************************************************
END
****************************************************************************/