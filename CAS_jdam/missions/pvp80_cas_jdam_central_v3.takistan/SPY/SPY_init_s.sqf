/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
Server Settings
****************************************************************************/
private ["_serverSettingsValues", "_serverSettings", "_missionSettingsValues", "_missionSettings", "_settingsServer", "_settingsMission", "_core", "_meSys", "_bStats", "_roe"];

_serverSettingsValues =
[
    #include "\userconfig\SPY\SPY_all_settings_s.txt"
];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil {sleep 0.1; scriptDone _serverSettings};
/***************************************************************************
Server Settings
****************************************************************************/



/***************************************************************************
Mission Settings
****************************************************************************/
if ((SPY_all_allowMissionOverride)) then
{
    _missionSettingsValues =
	[
        #include "SPY_all_settings_s.txt"
    ];

    _missionSettings = [_missionSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";
    waitUntil {sleep 0.1; scriptDone _missionSettings};
};
/***************************************************************************
Mission Settings
****************************************************************************/



/***************************************************************************
Create Container
****************************************************************************/
_center = createCenter sideLogic;
_group = createGroup _center;
SPY_container = _group createUnit ["LOGIC", [4000, 4000, 0], [], 0, "NONE"];
publicVariable "SPY_container";
/***************************************************************************
Create Container
****************************************************************************/



/***************************************************************************
Exec
****************************************************************************/
//["SPY_connect_oPC", "onPlayerConnected", {[_uid] execVM "SPY\SPY_bStats\events\SPY_onPlayerConnected.sqf";}] call BIS_fnc_addStackedEventHandler;
// ["SPY_connect_oPD", "onPlayerDisconnected", {[_uid] execVM "SPY\SPY_bStats\events\SPY_onPlayerDisconnected.sqf";}] call BIS_fnc_addStackedEventHandler;

_core = [] execVM "SPY\SPY_core\SPY_init_s.sqf";
waitUntil {sleep 0.1; scriptDone _core};

_meSys = [] execVM "SPY\SPY_meSys\SPY_init_s.sqf";
waitUntil {sleep 0.1; scriptDone _meSys};

if ((SPY_bStats_enabled)) then
{
    _bStats = [] execVM "SPY\SPY_bStats\SPY_init_s.sqf";
   // waitUntil {sleep 0.1; scriptDone _bStats};
};

if ((SPY_roe_enabled)) then
{
    _roe = [] execVM "SPY\SPY_roe\SPY_init_s.sqf";
    waitUntil {sleep 0.1; scriptDone _roe};
};

SPY_server_initialized = true;
publicVariable "SPY_server_initialized";

// Debug
_null = [1, "SPY Systems Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
Exec
****************************************************************************/