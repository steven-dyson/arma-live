/***************************************************************************
Detect Roadkill
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_unit", "_nearVehicles", "_roadKill", "_nearestVehicle", "_roadKill"];

_unit = (_this select 0);

_roadKill = [false, objNull, objNull];

_nearVehicles = nearestObjects [(getPos _unit), ["LandVehicle", "Air"], 7];

// Unit was in a vehicle
if ((!isNull (_unit getVariable "SPY_bStats_vehicle"))) exitWith
{
	_roadKill
};

while {true} do 
{
	_nearestVehicle = (_nearVehicles select 0);
	
	if ((count _nearVehicles isEqualTo 0)) exitWith 
	{
		_roadKill = [false, objNull, objNull];
	};
	
	if (!(isNull driver _nearestVehicle) and !(driver _nearestVehicle isEqualTo _unit) and (abs (speed _nearestVehicle) >= 1)) exitWith 
	{
		_roadKill = [true, (driver _nearestVehicle), _nearestVehicle];
	};
	
	if ((isNull driver _nearestVehicle) || (abs (speed _nearestVehicle) < 1) || ((_unit distance _nearestVehicle) > (sizeOf (typeOf _nearestVehicle)))) then 
	{
		_nearVehicles = _nearVehicles - [_nearestVehicle];
	};
};

_roadKill