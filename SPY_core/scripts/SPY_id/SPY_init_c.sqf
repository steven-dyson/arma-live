/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

_uid = (getPlayerUID player);

// Player ID variable
player setVariable ["SPY_id_uid", (getPlayerUID player), true];
SPY_container setVariable [("SPY_id_" + _uid), [(name player), (playerSide), (faction player), false], true];

// Monitor side and ensure team killing doesn't modify it
// _null = [] execVM "SPY\SPY_core\SPY_id\SPY_setEnemy.sqf";

// Debug
_null = [1, "(Core) ID initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;