/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

// Init player container variables
SPY_container setVariable ["SPY_bStats_players_blu", [], true];
SPY_container setVariable ["SPY_bStats_players_op", [], true];

// Start balance monitor
if ((SPY_connect_balanceEnabled)) then
{
	SPY_connect_forceBalance_admin = false;
	publicVariable "SPY_bStats_forceBalance_admin";
	
	//_null = [] execVM "SPY\SPY_bStats\balance\SPY_sideBalance.sqf";
};

// Debug
_null = [1, "Core: Connect Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;