/***************************************************************************
JDAM 2D DISTANCE
CREATED BY GOSCHIE
NO CONTACT INFO
***************************************************************************/

private "_posA";
private "_posB";
private "_distance";
private "_pos";
private "_distanceX";
private "_distanceY";
_distance = 0;
_pos = [0];
_distanceX = 0;
_distanceY = 0;
if ((count _this) != 2) exitWith {_distance;};

_posA = _this select 0;
_posB = _this select 1;

if (((typeName _posA) != "OBJECT") && ((typeName _posA) != "ARRAY")) exitWith {_distance;};
if (((typeName _posB) != "OBJECT") && ((typeName _posB) != "ARRAY")) exitWith {_distance;};

if ((typeName _posA) == "OBJECT") then
{
	_pos = getPosASL _posA;
	_posA = [(_pos select 0), (_pos select 1)];
};
if ((typeName _posB) == "OBJECT") then
{
	_pos = getPosASL _posB;
	_posB = [(_pos select 0), (_pos select 1)];
};

_distanceY = ((_posB select 0) - (_posA select 0));
_distanceX = ((_posB select 1) - (_posA select 1));
_distance = ((_distanceX * _distanceX) + (_distanceY * _distanceY));
_distance = sqrt(_distance);

_distance;