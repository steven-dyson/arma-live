/***************************************************************************
SPY_deployChalk.sqf
Created by Spyder
02 MAY 2011
****************************************************************************/

private ["_aircraft", "_chalkNumber", "_chalk"];

_aircraft = _this select 0;
_chalkNumber = _this select 3;

// Inital delay before first jump
sleep 1;

// Chalk is defined in addAction as group or all
if (("group" in _chalkNumber)) then {_chalk = units (group player);}
else {_chalk = crew _aircraft;};

{

	// player is not driver
	if (_x != driver _aircraft) then {

		// Unassign from vehicle, force eject, delay inbetween jumpers
		unassignVehicle _x;
		_x action ["eject", _aircraft];
		sleep 0.5;

	};

} foreach _chalk;