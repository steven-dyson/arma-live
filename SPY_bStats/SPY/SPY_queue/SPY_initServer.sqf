/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_compile"];

if ((!(SPY_CONNECT_ENABLED))) exitWith {};

_compile = [] execVM "SPY\SPY_queue\SPY_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

SPY_eMP_I_QUEUE = [];
SPY_eMP_D_QUEUE = [];

[] spawn {

	_null = [] execVM "SPY\SPY_queue\SPY_iQueueExec.sqf";
	_null = [] execVM "SPY\SPY_queue\SPY_dQueueExec.sqf";
	
};