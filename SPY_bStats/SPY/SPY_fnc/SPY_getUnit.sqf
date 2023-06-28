/***************************************************************************
GET UNIT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_inVehicle", "_unit", "_vehicle", "_turret"];

_inVehicle = (_this select 0);
_unit = (_this select 1);
_vehicle = (_this select 2);
_turret = [];

// Check vehicle positions
if ((_unit in vehicles)) then {

	if (!(isNull gunner _unit)) then {_unit = (gunner _unit);} else {

		if (!(isNull commander _unit)) then {_unit = (commander _unit);} else {

			_turret = [_unit] call UNN_getTurret;
		
			if ((count _turret > 0)) then {_unit = (_turret select 0);} else {
		
				_unit = (driver _unit);
			
			};
			
		};
		
	};
	
};

// Unit is still not detected, try vehicle's killer or damaging unit
if (!(_unit isKindOf "Man")) then {

	if ((_inVehicle)) then {
	
		waitUntil {(_vehicle getVariable "SPY_VEHICLE_INFO" select 6)};
		
		_unit = (_vehicle getVariable "SPY_VEHICLE_INFO" select 5);
		
	};
	
	if (!(_unit isKindOf "Man") && (_inVehicle)) then {_unit = (_vehicle getVariable "SPY_VEHICLE_INFO" select 2);};
	
	if ((isNull _unit)) then {_unit = objNull};
	
};
	
_unit