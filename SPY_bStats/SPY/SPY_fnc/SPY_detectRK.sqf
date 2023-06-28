/***************************************************************************
SPY_detectRK.sqf
Created by Spyder
23 JUN 2011
****************************************************************************/

private ["_player", "_nearVehicles", "_roadKill", "_nearestVehicle", "_roadKill"];

_player = (_this select 0);

_roadKill = [false, objNull];

_nearVehicles = nearestObjects [(getPos _player), ["LandVehicle", "Air"], 20];

while {true} do {

	_nearestVehicle = _nearVehicles select 0;
	
	if ((isNull driver _nearestVehicle) || (abs (speed _nearestVehicle) < 5) || (!(alive _nearestVehicle)) || ((_player distance _nearestVehicle) > (sizeOf (typeOf _nearestVehicle)))) then {
	
		_nearVehicles = _nearVehicles - [_nearestVehicle];
		
	};
	
	if ((count _nearVehicles == 0)) exitWith {
	
		_roadKill = [false, objNull];
		
	};
	
	if (!(isNull driver _nearestVehicle) && (abs (speed _nearestVehicle) >= 5)) exitWith {
	
		_roadKill = [true, driver _nearestVehicle];
		
	};

};

_roadKill