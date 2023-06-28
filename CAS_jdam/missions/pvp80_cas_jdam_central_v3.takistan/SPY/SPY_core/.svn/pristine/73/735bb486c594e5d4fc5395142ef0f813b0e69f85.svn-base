/***************************************************************************
Create Object
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Create Object";

private ["_class", "_pos", "_dir", "_setVector", "_invul"];

_class = (_this select 0);
_pos = (_this select 1);
_height = (_this select 2);
_dir = (_this select 3);
_setVector = (_this select 4);
_invul = (_this select 5);

// Helper object used to override placement correction
_helper = "Sign_Sphere25cm_F" createVehicleLocal [1, 1, 1000];
_helper setPos ([_pos, 999] call CAS_highestSurface);

// Create and place object
_object = _class createVehicle [1, 1, 1];

if ((_invul)) then {

	_object addEventHandler ["HandleDamage", {false}];
	
};

_object setDir _dir;
_object setPos (_helper modelToWorld [0, 0, _height]);

if ((_setVector)) then {

	_object setVectorUp (vectorUp _helper);
	
};

deleteVehicle _helper;

_object