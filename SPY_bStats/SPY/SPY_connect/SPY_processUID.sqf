/***************************************************************************
PROCESS UID
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_suspense"];

player enableSimulation false;
SPY_CONNECT_SYNC = false;
SPY_GAMELOGIC globalChat "UID CONNECTING, PLEASE WAIT...";

sleep (random ((count playableUnits) / 6));

_suspense = (diag_tickTime + 60);

_null = [[player, (getPlayerUID player)], "_this spawn SPY_compareUID;", "SERVER"] spawn JDAM_mpCB;

waitUntil {(SPY_CONNECT_SYNC) || (diag_tickTime > _suspense)};

if ((SPY_CONNECT_SYNC)) exitWith {

	SPY_GAMELOGIC globalChat "UID CONNECTION ESTABLISHED...";
	player enableSimulation true;

};

if ((diag_tickTime > _suspense)) then {

	SPY_GAMELOGIC globalChat "UID CONNECTION FAILED, PLEASE RECONNECT...";
	
	while {true} do {sleep 1;};

};