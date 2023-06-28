/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/




/***************************************************************************
Server Settings
****************************************************************************/
private ["_serverSettingsValues", "_serverSettings", "_compile", "_buildAO", "_actionContainers"];

_serverSettingsValues = [

    #include "\userconfig\CAS\CAS_jdam_settings_s.txt"

];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil {sleep 0.1; scriptDone _serverSettings};
/***************************************************************************
Server Settings
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
_compile = [] execVM "CAS\CAS_JDAM\CAS_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

// MAKE DYNAMIC
CAS_JDAM_tracker setVariable ["CAS_JDAM_ao1_z1_activeGrids", [], true];
CAS_JDAM_tracker setVariable ["CAS_JDAM_ao1_z2_activeGrids", [], true];
CAS_JDAM_tracker setVariable ["CAS_JDAM_ao1_z3_activeGrids", [], true];
CAS_JDAM_tracker setVariable ["CAS_JDAM_mkrs", [], false];

_buildAO = ["CAS_JDAM_ao1"] execVM "CAS\CAS_JDAM\init\CAS_zones_s.sqf";
waitUntil {sleep 0.1; scriptDone _buildAO};

_actionContainers = [] execVM "CAS\CAS_JDAM\safeZone\CAS_objects_s.sqf";
waitUntil {sleep 0.1; scriptDone _actionContainers};

// Vehicle Spawn Protection Thread
_null = [] execVM "CAS\CAS_JDAM\safeZone\CAS_vehicles_s.sqf";
/***************************************************************************
Init
****************************************************************************/



/***************************************************************************
Victory Conditions
****************************************************************************/
[] spawn {

	private ["_endTime", "_sectorsWest", "_sectorsEast"];

	_endTime = (diag_tickTime + 3600);
	
	_sectorsWest = 0;
	_sectorsEast = 0;

	waitUntil {sleep 0.1; diag_ticktime >= _endTime};
	
	{
	
		if ((CAS_JDAM_tracker getVariable (format ["%1_owner", _x])) == WEST) then {
		
			_sectorsWest = (_sectorsWest + 1);
		
		};
		
		if ((CAS_JDAM_tracker getVariable (format ["%1_owner", _x])) == EAST) then {
		
			_sectorsEast = (_sectorsEast + 1);
		
		};
	
	} forEach (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_sectorList");
	
	_null = [(format ["End of Mission - BLUFOR: %1 - OPFOR: %2", _sectorsWest, _sectorsEast]), "CLIENT", 999, 0] spawn SPY_bInfoScreen;
	
	sleep 10;
	
	if ((_sectorsWest > _sectorsEast)) then {
	
		_null = [[], "player enableSimulation false; endMission 'end1'; player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn CAS_mpCB;
		_null = [(format ["bstats_endsession (%1, 'BLUFOR')", time])] call uplink_exec;
	
	}; 
	
	if ((_sectorsWest < _sectorsEast)) then {
	
		_null = [[], "player enableSimulation false; endMission 'end2'; player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn CAS_mpCB;
		_null = [(format ["bstats_endsession (%1, 'OPFOR')", time])] call uplink_exec;
		
	}; 
	
	if ((_sectorsWest == _sectorsEast)) then {
	
		_null = [[], "player enableSimulation false; endMission 'end3'; player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn CAS_mpCB;
		_null = [(format ["bstats_endsession (%1, 'TIE')", time])] call uplink_exec;
	
	}; 

};
/***************************************************************************
Victory Conditions
****************************************************************************/