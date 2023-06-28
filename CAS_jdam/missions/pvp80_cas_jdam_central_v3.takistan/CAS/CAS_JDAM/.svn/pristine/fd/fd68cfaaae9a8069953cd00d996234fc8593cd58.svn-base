private ["_sector", "_zone", "_side", "_hidden", "_i", "_sectorGrids", "_grid", "_marker"];

_sector = (_this select 0);
_zone = (_this select 1);
_side = (_this select 2);
_hidden = (_this select 3);

_gridSize = (((getMarkerSize _sector select 0) / 2) - 5);
_gridPos = (_gridSize + 10);

_i = 0;
_sectorGrids = [];

{
	
	_i = _i + 1;
	
	_grid = (format ["%1_g%2_%3", _zone, _i, _side]);
	_sectorGrids = (_sectorGrids + [_grid]);
	
	// MOVE TO INIT
	if (((getMarkerPos _grid select 0) == 0)) then {
	
		_marker = createMarker [_grid, [1, 1, 1]];
		_marker setMarkerColor "Default";
		_marker setMarkerShape "Rectangle";
		_marker setMarkerSize [_gridSize, _gridSize];
		_marker setMarkerBrush "BORDER";
		
		// @REMOVE THIS
		CAS_JDAM_tracker setVariable [(format ["%1_activeGrids", _zone]), ((CAS_JDAM_tracker getVariable (format ["%1_activeGrids", _zone])) + [_grid]), true];
	
	};
	
	if ((CAS_JDAM_tracker getVariable (format ["%1_owner", _sector]) == CIVILIAN)) then {
	
		CAS_JDAM_tracker setVariable [(format ["%1_owner", _grid]), CIVILIAN, false];
	
	} else {
	
		CAS_JDAM_tracker setVariable [(format ["%1_owner", _grid]), _side, false];
	
	};
	
	CAS_JDAM_tracker setVariable [(format ["%1_westPlayers", _grid]), [], false];
	CAS_JDAM_tracker setVariable [(format ["%1_eastPlayers", _grid]), [], false];
	CAS_JDAM_tracker setVariable [(format ["%1_sector", _grid]), _sector, false];
	
	if ((_hidden)) then {
	
		_grid setMarkerPos [1, 1, 1];
	
	} else {
	
		CAS_JDAM_tracker setPos (getMarkerPos _sector);
		CAS_JDAM_tracker setDir (markerDir _sector);
		_grid setMarkerPos (CAS_JDAM_tracker modelToWorld _x);
		_grid setMarkerDir (markerDir _sector);
	
	};
	
} forEach [[_gridPos, _gridPos, 0], [-_gridPos, _gridPos, 0], [_gridPos, -_gridPos, 0], [-_gridPos, -_gridPos, 0]];

if ((!_hidden)) exitWith {

	CAS_JDAM_tracker setVariable [(format ["%1_grids", _sector]), _sectorGrids, false];

};