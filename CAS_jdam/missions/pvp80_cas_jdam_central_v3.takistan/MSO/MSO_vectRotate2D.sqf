//Function: MSO_fnc_vectRotate2D

//Description:
	//Rotates a 2D vector around a given center, for rotating of a vector from its origin, use BIS_fnc_rotateVector2D

//Parameters:
	//Center, Vector, Angle

//Returns:
	//The rotated vector

//Author:
	//Rommel

private ["_center","_vector","_angle"];
_center = _this select 0;
_vector = _this select 1;
_angle = _this select 2;

private ["_x","_y"];
_x = _center select 0;
_y = _center select 1;

private ["_dx","_dy"];
_dx = _x - (_vector select 0);
_dy = _y - (_vector select 1);	

[
	_x - ((_dx* cos(_angle)) - (_dy* sin(_angle))),
	_y - ((_dx* sin(_angle)) + (_dy* cos(_angle)))
]