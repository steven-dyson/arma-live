/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

// Start process UID
_process = [] execVM "SPY\SPY_core\SPY_connect\SPY_processUID.sqf";
waitUntil {sleep 0.1; scriptDone _process};

// Add connect isIdle to CEH
[] spawn { 

	waitUntil {sleep 0.1; !isNil "SPY_core_fnc_cehAdd"};

	// Idle CEH
	if ((SPY_connect_idleKick)) then {
	
		//_null = ["SPY_ceh_isIdle", "SPY_connect", [], "_null = ['SERVER', 'IDLE'] spawn SPY_connect_fnc_clientKick;", "LOCAL", 0] spawn SPY_core_fnc_cehAdd;

	};
		
};

// Debug
_null = [1, "Core: Connect Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;