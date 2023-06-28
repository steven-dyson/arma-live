/***************************************************************************
SPY INIT AND COMPILE (METHOD)
SPY SYSTEMS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_settingsProcess"];

_settings = [

	["SPY_BSTATS_ENABLED", true],
	["SPY_CONNECT_ENABLED", true],
	["SPY_QUEUE_ENABLED", true],
	["SPY_CEH_ENABLED", true]

];

_settingsProcess = [_settings] spawn SPY_settingsProcess;

waitUntil {sleep 0.1; scriptDone _settingsProcess};

// SPY_AIROPS_ENABLED = false;
// SPY_FARP_ENABLED = false;
// SPY_MESYS_ENABLED = false;
// SPY_LOADINGPROGRESS_ENABLED = true;
// SPY_MUSIC_ENABLED = true;
// SPY_ENTRYTEXT_ENABLED = true;