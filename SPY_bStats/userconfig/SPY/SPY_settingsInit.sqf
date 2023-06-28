/***************************************************************************
SPY INIT AND COMPILE (METHOD)
SPY INIT SETTINGS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

SPY_settingsProcess = compile preprocessFileLineNumbers "\userconfig\SPY\SPY_settingsProcess.sqf";

_systems = execVM "\userconfig\SPY\SPY_systems.sqf";
waitUntil {sleep 0.1; scriptDone _systems};

_bStats = execVM "\userconfig\SPY\SPY_bStats.sqf";
waitUntil {sleep 0.1; scriptDone _bStats};