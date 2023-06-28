/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

if ((!isServer)) then
{
	// Init variables
	SPY_queue_instant = [];
	SPY_queue_delay = [];

	// Start queue monitor
	[] spawn
	{
		_null = [] execVM "SPY\SPY_core\SPY_queue\SPY_iQueueExec.sqf";
		_null = [] execVM "SPY\SPY_core\SPY_queue\SPY_dQueueExec.sqf";
	};
};

// Debug
_null = [1, "Core: Queue Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;