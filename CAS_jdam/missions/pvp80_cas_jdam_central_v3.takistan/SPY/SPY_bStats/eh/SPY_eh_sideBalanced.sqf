/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Determines the amount of players sides are over numbers and then balances teams by sending players back to the lobby.

	Parameter(s):
		0: NONE

	Returns:
	NONE 
*/

scriptName "SPY_bStats_eh_ranking";

while {true} do {

	waitUntil {sleep 30; (!([] call SPY_vMission))};
	
	_null = [[3, "Waiting for more players...", 0, ["SPY_bStats", "Event Log"], false], "SPY_bStats", true, false, false] call BIS_fnc_MP;
	SPY_bStats_ranked = false;
	
	waitUntil {sleep 30; ([] call SPY_vMission)};
	
	_null = [[3, "Minimum players met. Stats will be recorded.", 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	SPY_bStats_ranked = true;
	
};