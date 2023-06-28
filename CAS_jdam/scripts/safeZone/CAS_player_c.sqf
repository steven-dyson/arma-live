/***************************************************************************
On Status Change Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM safeZone On Status Change Client";

private ["_sidePlayer", "_inSafeZoneFriendly", "_inSafeZoneEnemy", "_inSafeZone", "_fired", "_hDamage", "_safeZone"];

_sidePlayer = (playerSide);

_inSafeZoneFriendly = false;
_inSafeZoneEnemy = false;

while {true} do {
	
	{
	
		sleep 1;
		
		waitUntil {sleep 0.1; (alive player)};
	
		_inSafeZone = [player, _x] call MSO_fnc_inArea;
		
		if ((_inSafeZone) && ((getPos player select 2) < CAS_JDAM_safeZone_height)) exitWith {
		
			_safeZone = _x;
			
			if (((_safeZone in ["CAS_JDAM_mkr_safeZone_fobWest", "CAS_JDAM_mkr_safeZone_copWest"]) && (_sidePlayer in [west])) || ((_safeZone in ["CAS_JDAM_mkr_safeZone_fobEast", "CAS_JDAM_mkr_safeZone_copEast"]) && (_sidePlayer in [east]))) then {
		
				_fired = player addEventHandler ["Fired", {deleteVehicle (_this select 6);}];
				_hDamage = player addEventHandler ["HandleDamage", {false}];
			
				_null = [3, "You entered a friendly safe zone", "LOCAL", false, 1] spawn SPY_bMessage;
				
				_inSafeZoneFriendly = true;
			
			};
			
			if (((_safeZone in ["CAS_JDAM_mkr_safeZone_fobWest", "CAS_JDAM_mkr_safeZone_copWest"]) && (_sidePlayer in [east])) || ((_safeZone in ["CAS_JDAM_mkr_safeZone_fobEast", "CAS_JDAM_mkr_safeZone_copEast"]) && (_sidePlayer in [west]))) then {
			
				_null = [4, "You entered an enemy safe zone and will be killed!", "LOCAL", false, 1] spawn SPY_bMessage;
				
				_inSafeZoneEnemy = true;
				
				[_safeZone] spawn {
				
					_safeZone = (_this select 0);
				
					sleep CAS_JDAM_safeZone_killDelay;
					
					_inSafeZone = [player, _safeZone] call MSO_fnc_inArea;
					
					if ((_inSafeZone)) then {
					
						(vehicle player) setDamage 1;
						
						_null = [4, (format ["%1 was punished (in an enemy safe zone)!", (name player)]), "CLIENT", false, 1] spawn SPY_bMessage;
					
					};
					
				};
			
			};
			
			waitUntil {sleep 0.1; !([player, _safeZone] call MSO_fnc_inArea) || ((getPos player select 2) > CAS_JDAM_safeZone_height)};
			
			if ((_inSafeZoneFriendly)) then {
			
				player removeEventHandler ["Fired", _fired];
				player removeEventHandler["HandleDamage", _hDamage];
			
				_null = [3, "You left a friendly safe zone", "LOCAL", false, 1] spawn SPY_bMessage;
				
				_inSafeZoneFriendly = false;
				
			} else {
			
				_null = [4, "You left an enemy safe zone", "LOCAL", false, 1] spawn SPY_bMessage;
				
				_inSafeZoneEnemy = false;
			
			};
			
		};
	
	} forEach ["CAS_JDAM_mkr_safeZone_fobWest", "CAS_JDAM_mkr_safeZone_copWest", "CAS_JDAM_mkr_safeZone_fobEast", "CAS_JDAM_mkr_safeZone_copEast"];

};