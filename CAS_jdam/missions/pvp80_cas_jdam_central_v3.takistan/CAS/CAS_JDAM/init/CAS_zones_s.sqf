/***************************************************************************
Build Zones Server
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_ao", "_nPlayers", "_nZones", "_i", "_zoneSetup", "_zone", "_marker", "_buildSectors"];

_ao = (_this select 0);

_nPlayers = 0;

{ 

	{

		private ["_uid"];

		_uid = (getPlayerUID _x);

		if ((_uid != "")) then {

			_nPlayers = (_nPlayers + 1);

		};

	} forEach units _x;

} forEach allGroups;

switch true do {

	if (((paramsArray select 2) == 0)) then {

		case (_nPlayers <= 20) : {CAS_JDAM_zonesInPlay = [1];};
		case (_nPlayers <= 40) : {CAS_JDAM_zonesInPlay = [1, 2];};
		case (_nPlayers >= 60) : {CAS_JDAM_zonesInPlay = [1, 2, 3];};
	
	} else {
	
		CAS_JDAM_zonesInPlay = [(paramsArray select 2)];
	
	};

};

for "_i" from 1 to 3 do {

	_zone = (format ["%1_z%2", _ao, _i]);

	if ((_i in CAS_JDAM_zonesInPlay)) then {
	
		CAS_JDAM_tracker setVariable [(format ["%1_owner", _zone]), CIVILIAN, false];
		CAS_JDAM_tracker setVariable [format ["%1_progressWest", _zone], 1, false];
		CAS_JDAM_tracker setVariable [format ["%1_progressEast", _zone], 3, false];
		
		_buildSectors = [_zone, false] execVM "CAS\CAS_JDAM\init\CAS_sectors_s.sqf";
		
		waitUntil {sleep 0.1; scriptDone _buildSectors};
	
	} else {
	
		_buildSectors = [_zone, true] execVM "CAS\CAS_JDAM\init\CAS_sectors_s.sqf";
	
	};

};