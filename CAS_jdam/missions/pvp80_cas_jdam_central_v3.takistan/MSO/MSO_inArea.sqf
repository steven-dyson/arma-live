//Function: MSO_fnc_inArea

//Description:
	//A function used to determine if a position is within a zone.
//Parameters:
	//Marker, Object, Location, Group or Position, Zone (Marker, Trigger, Array)
//Example:
	
//Returns:
	//Boolean
//Author:
	//Rommel
private ["_position","_zref"];
_position = (_this select 0) call MSO_fnc_getpos;
_zref = _this select 1;

private ["_typename"];
_typename = tolower (typename _zref);

private ["_zsize","_zdir","_zshape","_zpos"];
switch (_typename) do {
	case ("string") : {
		_zsize = markersize _zref;
		_zdir = markerdir _zref;
		_zshape = tolower (markershape _zref);
		_zpos = getmarkerpos _zref;
	};
	case ("object") : {
		_zsize = triggerarea _zref;
		_zdir = _zsize select 2;
		_zshape = if (_zsize select 3) then {"rectangle"} else {"ellipse"};
		_zpos = getpos _zref;
	};
};

if (isnil "_zsize") exitwith {false};

_position = [_zpos,_position,_zdir] call MSO_fnc_vectRotate2D;

private ["_x1","_y1"];
_x1 = _zpos select 0;
_y1 = _zpos select 1;

private ["_x2","_y2"];
_x2 = _position select 0;
_y2 = _position select 1;

private ["_dx","_dy"];
_dx = _x2 - _x1;
_dy = _y2 - _y1;

private ["_zx","_zy"];
_zx = _zsize select 0;
_zy = _zsize select 1;

switch (_zshape) do {
	case ("ellipse") : {
		((_dx^2)/(_zx^2) + (_dy^2)/(_zy^2)) < 1
	};
	case ("rectangle") : {
		(abs _dx < _zx) and (abs _dy < _zy)
	};
};