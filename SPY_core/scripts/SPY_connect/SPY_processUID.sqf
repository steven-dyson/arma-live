/***************************************************************************
Process UID
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_suspense"];

player enableSimulation false;
SPY_connect_sync = false;

// Player message
_null = [3, "UID connecting, please wait...", 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;

// Ensure players are run one at a time
sleep (random ((count playableUnits) / 6));

_suspense = (diag_tickTime + 60);

// Ask server to compare what the player UID is to what the server thinks it is
_null = [[player, (getPlayerUID player)], "_this spawn SPY_core_fnc_compareUID;", "SERVER"] spawn CAS_mpCB;

// Player and server are in sync
waitUntil { (SPY_connect_sync) || (diag_tickTime > _suspense) };

// Sync success
if ((SPY_connect_sync)) exitWith
{
	_null = [3, "UID connection established...", 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;
	player enableSimulation true;

	_null = [3, (format ["Welcome %1, enjoy your stay...", (name player)]), 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;
};

// Sync timeout
if ((diag_tickTime > _suspense)) then
{
	_null = [3, "UID connection failed, please reconnect...", 2, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;
	_null = ["UID connection failed, please reconnect...", 999, 999, false] spawn SPY_core_fnc_bInfoScreen;
	
	// Don't allow script to end
	while {true} do
	{
		sleep 1;
	};
};