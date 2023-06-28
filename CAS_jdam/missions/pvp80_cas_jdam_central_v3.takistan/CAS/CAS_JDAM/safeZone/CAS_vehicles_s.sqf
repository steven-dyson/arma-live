/***************************************************************************
Protect Vehicles Server
Created by Spyder
spyder@armalive.com

Usage: Protects vehicles initially placed in editor or dynamically created before execution of this script
***************************************************************************/

scriptName "CAS JDAM safeZone Protect Vehicles Server";

private ["_vehicle", "_protection", "_inSafeZone", "_fired", "_hDamage"];

while {sleep 0.1; true} do {

	{

		if ((_x isKindOf "Air") || (_x isKindOf "LandVehicle") || (_x isKindOf "Ship")) then {
		
			sleep 0.1;
			
			_vehicle = _x;
			_protection = (_vehicle getVariable "CAS_JDAM_safeZone_protection");
			
			// Debug to check what vehicles receive protection
			// _null = [1, (format ["SZVI: %1, %2", _vehicle, _protection]), "CLIENT", false, 0] spawn SPY_bMessage;
			
			{
				
				// Check if vehicle is in a safe zone
				_inSafeZone = [_vehicle, _x] call MSO_fnc_inArea;
				
				if ((_inSafeZone)) exitWith {};
				
			} forEach ["CAS_JDAM_mkr_safeZone_fobWest", "CAS_JDAM_mkr_safeZone_copWest", "CAS_JDAM_mkr_safeZone_fobEast", "CAS_JDAM_mkr_safeZone_copEast"];
				
			// Vehicle in safe zone for first time
			if ((_inSafeZone) && (isNil "_protection")) exitWith {
			
				_fired = _vehicle addEventHandler ["Fired", {deleteVehicle (_this select 6);}];
				_hDamage = _vehicle addEventHandler ["HandleDamage", {false}];
				
				_vehicle setVariable ["CAS_JDAM_safeZone_protection", [_fired, _hDamage], false];
				
				// _null = [1, (format ["SZVI: %1, [%2, %3]", _vehicle, _fired, _hDamage]), "CLIENT", false, 0] spawn SPY_bMessage;
			
			};
			
			// Vehicle left safe zone
			if ((!_inSafeZone) && !(isNil "_protection")) exitWith {
			
				_vehicle removeEventHandler ["Fired", (_protection select 0)];
				_vehicle removeEventHandler ["HandleDamage", (_protection select 1)];
				
				_vehicle setVariable ["CAS_JDAM_safeZone_protection", nil, false];
				
				// _null = [1, (format ["SZREH: %1, %2", _vehicle, "Removed"]), "CLIENT", false, 0] spawn SPY_bMessage;
			
			};
				
		};
		
	} forEach vehicles;
	
};