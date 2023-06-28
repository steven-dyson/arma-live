/***************************************************************************
BUILD SECTORS SERVER
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_zone", "_sectorList", "_sector", "_marker", "_buildGridsWest", "_buildGridsEast"];

_zone = (_this select 0);
_hidden = (_this select 1);
_sectorList = [];

if ((!_hidden)) then {

	for "_i" from 1 to 5 do {

		_sector = (format ["%1_s%2", _zone, _i]);
		_sectorNext = (format ["%1_s%2", _zone, _i + 1]);

		_sectorList = (_sectorList + [_sector]);
				
		// DEFAULT VARIABLES FOR A SECTOR
		CAS_JDAM_tracker setVariable [(format ["%1_owner", _sector]), CIVILIAN, false];
		CAS_JDAM_tracker setVariable [(format ["%1_zone", _sector]), _zone, false];
		CAS_JDAM_tracker setVariable [(format ["%1_bpDeployed", _sector]), "", false];
		
		// INITIAL SECTOR OWNERS
		if ((_i in [1, 2])) then {
			
			CAS_JDAM_tracker setVariable [(format ["%1_owner", _sector]), WEST, false];
			_sector setMarkerColor "ColorBLUFOR";
			_sector setMarkerBrush "Horizontal";
			
		};
		
		if ((_i in [4, 5])) then {
			
			CAS_JDAM_tracker setVariable [(format ["%1_owner", _sector]), EAST, false];
			_sector setMarkerColor "ColorOPFOR";
			_sector setMarkerBrush "Horizontal";
			
		};
		
		if (!(_i in [5])) then {
		
			_null = [_sector, _sectorNext, 5, "ColorBlack"] spawn CAS_drawMarkerConnection;
		
		};

	};
	
	// DEFINE ALL SECTORS IN A ZONE
	CAS_JDAM_tracker setVariable [(format ["%1_sectorList", _zone]), _sectorList, false];
	
	// BUILD FIRST ACTIVE SECTOR; MANUALLY SET
	_buildGridsWest = [(_sectorList select 2), _zone, WEST, false] spawn CAS_JDAM_init_grids_s;
	waitUntil {sleep 0.1; scriptDone _buildGridsWest};

	// BUILD FIRST ACTIVE SECTOR; MANUALLY SET
	_buildGridsEast = [(_sectorList select 2), _zone, EAST, true] spawn CAS_JDAM_init_grids_s;
	waitUntil {sleep 0.1; scriptDone _buildGridsEast};
	
} else {

	CAS_JDAM_tracker setVariable [(format ["%1_sectorList", _zone]), [], false];

	for "_i" from 1 to 5 do {
	
		_sector = (format ["%1_s%2", _zone, _i]);
		_sector setMarkerPos [1, 1, 1];
	
	};

};