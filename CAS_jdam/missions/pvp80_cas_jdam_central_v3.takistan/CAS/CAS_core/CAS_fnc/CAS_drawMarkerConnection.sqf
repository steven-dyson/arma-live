/***************************************************************************
DRAW MARKER CONNECTION
Created by Spyder & GOSCHIE
spyder@armalive.com
***************************************************************************/

private ["_posMarkerA", "_posMarkerB", "_width", "_color", "_distX", "_distX", "_dir", "_axisPosX", "_axisPosY", "_marker"];

_posMarkerA = (getMarkerPos (_this select 0));
_posMarkerB = (getMarkerPos (_this select 1));
_width = (_this select 2);
_color = (_this select 3);

_distX = (_posMarkerA select 0) - (_posMarkerB select 0);
_distY = (_posMarkerA select 1) - (_posMarkerB select 1);

if (_distY == 0) then {

	_dir = 90;
	
} else {

	_dir = ((_posMarkerA select 0) - (_posMarkerB select 0)) atan2 ((_posMarkerA select 1) - (_posMarkerB select 1)); 
	
};

_axisPosX = (_posMarkerA select 0) - (_distX / 2);
_axisPosY = (_posMarkerA select 1) - (_distY / 2);

_marker = createMarker [(format ["SPY_%1%2", _distX, _distY]), [_axisPosX, _axisPosY]];
_marker setMarkerDir _dir;
_marker setMarkerShape "RECTANGLE";
_marker setMarkerColor "ColorBlack";
_marker setMarkerSize [_width, (([_posMarkerA, _posMarkerB] call CAS_2dDistance) / 2)];

_markers = ((CAS_JDAM_tracker getVariable "CAS_JDAM_mkrs") + [_marker]);

CAS_JDAM_tracker setVariable ["CAS_JDAM_mkrs", _markers, false];