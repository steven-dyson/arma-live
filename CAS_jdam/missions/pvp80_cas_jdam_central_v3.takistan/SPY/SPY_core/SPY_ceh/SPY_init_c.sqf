/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

// Start CEH
_null = [player] execVM "SPY\SPY_core\SPY_ceh\SPY_eh_changedVehPos.sqf";
_null = [player] execVM "SPY\SPY_core\SPY_ceh\SPY_eh_switchedWpn.sqf";
_null = [player] execVM "SPY\SPY_core\SPY_ceh\SPY_eh_isIdle.sqf";

// Debug
_null = [1, "Core: CEH Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;