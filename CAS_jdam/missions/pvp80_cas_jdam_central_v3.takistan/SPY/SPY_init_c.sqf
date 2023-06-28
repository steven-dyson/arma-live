/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
EXEC
****************************************************************************/
private ["_settings", "_core", "_meSys", "_bStats", "_roe"];

SPY_initialized_client = false;

player createDiarySubject ["SPY bStats","SPY bStats"];

_core = [] execVM "SPY\SPY_core\SPY_init_c.sqf";
waitUntil {sleep 0.1; scriptDone _core};

_meSys = [] execVM "SPY\SPY_meSys\SPY_init_c.sqf";
waitUntil {sleep 0.1; scriptDone _meSys};

if ((SPY_bStats_enabled)) then
{
	_bStats = [] execVM "SPY\SPY_bStats\SPY_init_c.sqf";
	waitUntil {sleep 0.1; scriptDone _bStats};
};

if ((SPY_roe_enabled)) then
{
	_roe = [] execVM "SPY\SPY_roe\SPY_init_c.sqf";
	waitUntil {sleep 0.1; scriptDone _roe};
};

SPY_initialized_client = true;

// Debug
_null = [1, "SPY Systems Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
END
****************************************************************************/