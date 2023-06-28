/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
SERVER SETTINGS
****************************************************************************/
private ["_serverSettingsValues", "_serverSettings", "_compile"];

_serverSettingsValues = [

    #include "\userconfig\SPY\SPY_roe_settings_s.txt"

];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil {sleep 0.1; scriptDone _serverSettings};
/***************************************************************************
SERVER SETTINGS
****************************************************************************/



/***************************************************************************
EXEC
****************************************************************************/
_compile = [] execVM "SPY\SPY_roe\SPY_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

// Debug
_null = [1, "ROE Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
EXEC
****************************************************************************/