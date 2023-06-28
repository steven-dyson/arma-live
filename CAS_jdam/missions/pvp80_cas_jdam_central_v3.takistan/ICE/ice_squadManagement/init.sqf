// Squad Management
// Desc: init (functions & key EH)
// Params: (conditional), _this can be: 'addon' or nil
//-----------------------------------------------------------------------------
#include "common.sqh"
CBA_fnc_globalExecute = compile preprocessFileLineNumbers "ICE\ICE_squadManagement\D_sys_network.sqf";
//-----------------------------------------------------------------------------
// Determine whether to init this system. By default, the system will not load.
_enable = 1;
if (!isNil "ICE_fnc_getSetting") then
{
	#define __settingsSystem "squad_management"
	_enable = [__settingsSystem, "enable", 0] call ICE_fnc_getSetting;
};
if (_enable == 0) exitWith {}; // do not load system
//-----------------------------------------------------------------------------
// determine whether this script was called from the addon or a mission. 
_initViaAddon = false;
if (!isNil "_this") then
{
	// An 'addon' parameter will exist for addon version. For missions, use nothing or use any other param.
	if (typeName _this == typeName "") then
	{
		_initViaAddon = (_this == 'addon');
	};
};
// any mission-defined version of this system takes precedence, so ignore this one.
if (_initViaAddon && isClass (missionConfigFile >> "ICE_SquadManagementDialog")) exitWith
{
	// prevent addon sqdMgt\init.sqf being executed, but allow mission sqdMgt\init.sqf to be executed.
	if (!isMultiplayer) then {diag_log text 'init addon: ICE_squadManagement: ignored: a duplicate system was already found in mission.'}; // SP debug
};

diag_log text "init addon: ICE_squadManagement";
//-----------------------------------------------------------------------------
if (isServer) then
{
	// monitor and remove empty groups periodically
	execVM _c_basePath(groupGC.sqf); // garbage collector
};

call compile preprocessFileLineNumbers _c_basePath(initFunctions.sqf);
call compile preprocessFileLineNumbers _c_basePath(initKeys.sqf);

if ((isDedicated)) exitWith {};