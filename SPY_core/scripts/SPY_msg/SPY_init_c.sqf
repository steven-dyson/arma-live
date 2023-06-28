/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

// Init diary
player createDiarySubject ["SPY Systems", "SPY Systems"];

// Debug
_null = [1, "Core: Msg Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;