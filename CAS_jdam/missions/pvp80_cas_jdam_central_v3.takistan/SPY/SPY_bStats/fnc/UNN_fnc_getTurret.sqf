/***************************************************************************
UNN_getTurret.sqf
Created by UNN
01 JULY 2007
****************************************************************************/

private ["_gunners", "_vehicle"]; 

_vehicle = _this select 0;

[_vehicle] call {

	_gunners = []; 
	
	{
	
		If (count (assignedVehicleRole _x) > 1) then {
		
			_gunners = _gunners + [_x]
			
		}
		
	} forEach (crew (_this select 0)); 
	
	_gunners
	
}