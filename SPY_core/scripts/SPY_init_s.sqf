/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
SERVER SETTTINGS
****************************************************************************/
private ["_serverSettingsValues", "_serverSettings", "_missionSettingsValues", "_missionSettings", "_msg", "_connect", "_fnc", "_queue"];

_serverSettingsValues = [

    #include "\userconfig\SPY\SPY_core_settings_s.txt"

];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil {sleep 0.1; scriptDone _serverSettings};
/***************************************************************************
SERVER SETTTINGS
****************************************************************************/



/***************************************************************************
MISSION SETTINGS
****************************************************************************/
if ((SPY_core_allowMissionOverride)) then {

    _missionSettingsValues = [

        #include "SPY_core_settings_s.txt"

    ];

    _missionSettings = [_missionSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";
    
    waitUntil {sleep 0.1; scriptDone _missionSettings};

};
/***************************************************************************
MISSION SETTINGS
****************************************************************************/



/***************************************************************************
EXEC
****************************************************************************/
_msg = [] execVM "SPY\SPY_core\SPY_msg\SPY_init_s.sqf";
waitUntil {sleep 0.1; scriptDone _msg};

_connect = [] execVM "SPY\SPY_core\SPY_connect\SPY_init_s.sqf";
waitUntil {sleep 0.1; scriptDone _connect};

_queue = [] execVM "SPY\SPY_core\SPY_queue\SPY_init_s.sqf";
waitUntil {sleep 0.1; scriptDone _queue};

// Debug
_null = [1, "Core Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
EXEC
****************************************************************************/