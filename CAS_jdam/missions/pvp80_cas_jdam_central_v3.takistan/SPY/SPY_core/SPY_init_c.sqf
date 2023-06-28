/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
EXEC
****************************************************************************/
private ["_msg", "_connect", "_id", "_fnc", "_queue", "_ceh"];

_msg = [] execVM "SPY\SPY_core\SPY_msg\SPY_init_c.sqf";
waitUntil {scriptDone _msg};

_connect = [] execVM "SPY\SPY_core\SPY_connect\SPY_init_c.sqf";
waitUntil {sleep 0.1; scriptDone _connect};

_id = [] execVM "SPY\SPY_core\SPY_id\SPY_init_c.sqf";
waitUntil {sleep 0.1; scriptDone _id};

_queue = [] execVM "SPY\SPY_core\SPY_queue\SPY_init_c.sqf";
waitUntil {scriptDone _queue};

_ceh = [] execVM "SPY\SPY_core\SPY_ceh\SPY_init_c.sqf";
waitUntil {scriptDone _ceh};

// Debug
_null = [1, "Core Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
END
****************************************************************************/