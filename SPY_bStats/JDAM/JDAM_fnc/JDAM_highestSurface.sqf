/***************************************************************************
HIGHESTSURFACE.SQF
CREATED BY GOSCHIE & SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_position", "_maxPosition", "_maxHeight", "_roofHeight"];

_position = (_this select 0);
_maxPosition = (_this select 1);

if ("OBJECT" == (typeName _position)) then {_position = (getPosASL _position);};

if (("OBJECT" == (typeName _maxPosition))) then {

	_maxPosition = (getPosATL _maxPosition);
	_maxHeight = (_maxPosition select 2);

} else {

	_maxHeight = _maxPosition;

};

if (isNil "JDAM_ROOF_FINDER") then {JDAM_ROOF_FINDER = "Logic" createVehicleLocal [0,0,0];};

JDAM_ROOF_FINDER setPosATL [(_position select 0), (_position select 1), 2000];

_roofHeight = (2000 - (getPos JDAM_ROOF_FINDER select 2));
_position = [(_position select 0), (_position select 1), _roofHeight];

if (((_roofHeight) > (_maxHeight))) then {_position = [(_position select 0), (_position select 1), _maxHeight];};

_position