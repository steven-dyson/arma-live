/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
SERVER SETTINGS
****************************************************************************/
private ["_serverSettingsValues", "_serverSettings", "_missionSettings", "_compile"];

_serverSettingsValues = [

    #include "\userconfig\SPY\SPY_meSys_settings_s.txt"

];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil {sleep 0.1; scriptDone _serverSettings};
/***************************************************************************
SERVER SETTINGS
****************************************************************************/



/***************************************************************************
MISSION SETTINGS
****************************************************************************/
if ((SPY_all_allowMissionOverride)) then {

    _missionSettingsValues = [

        #include "SPY_meSys_settings_s.txt"

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

// Debug
_null = [1, "meSys Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
END
****************************************************************************/