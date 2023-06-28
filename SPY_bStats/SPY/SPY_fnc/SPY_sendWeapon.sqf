/***************************************************************************
SEND WEAPON
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_unit", "_ammoClass", "_victimUID", "_wpnVar", "_loadout", "_grenades", "_grenadesSmoke", "_grenadesNL", "_explosives", "_weapon", "_weapons", "_allowedMags", "_wpnChecked"];

_unit = (_this select 0);
_ammoClass = (_this select 1);
_victimUID = (_this select 2);
_wpnVar = (_this select 3);

_loadout = (player getVariable "SPY_PLAYER_LOADOUT");

_grenades = ["GrenadeHandTimedEast", "GrenadeHandTimedWest", "GrenadeHand"];
_grenadesSmoke = ["SmokeShell", "SmokeShellGreen", "SmokeShellRed", "SmokeShellOrange", "SmokeShellYellow", "SmokeShellPurple", "SmokeShellBlue"];
_grenadesNL = ["IRStrobe"];
_explosives = ["Mine", "MineE", "PipeBomb", "TimeBomb"];

if (((vehicle player) isKindOf "Man")) then {

	if ((_ammoClass == "")) then {
		
		_weapon = (currentMuzzle _unit);
	
	} else {
	
		_weapons = [(_loadout select 0),  (_loadout select 1), (_loadout select 3)] + (_loadout select 2) + (_loadout select 4);
		
		// PRIMARY, LAUNCHER, PISTOL
		{
					
			_allowedMags = getArray (configFile >> "cfgWeapons" >> _x >> "magazines");

			_wpnChecked = _x;

			{

				if ((_ammoClass == (getText (configFile >> "CfgMagazines" >> _x >> "ammo"))) && !(_ammoClass in _explosives)) exitWith {_weapon = _wpnChecked};

			} forEach _allowedMags;
			
			if ((!(isNil "_weapon"))) exitWith {_weapon};
			
			// GRENADES
			// if ((count _allowedMags == 0)) then {
			
				if ((_ammoClass in _grenades)) then {
				
					_weapon = "HandGrenadeMuzzle";
					
				} else {
				
					if ((_ammoClass in _grenadesSmoke)) then {
					
						_weapon = "SmokeShellMuzzle";
						
					} else {
					
						if ((_ammoClass in _grenadesNL)) exitWith {_weapon = "IRStrobe";};
					
					};
					
				};
			
			// };
			
			// EXPLOSIVES
			if ((isNil "_weapon") && (_x == _ammoClass)) exitWith {_weapon = (format ["%1Muzzle", _x]);};
			
			if ((!isNil "_weapon")) exitWith {};

		} forEach _weapons;
		
		// GRENADE LAUNCHER
		if ((isNil "_weapon")) then {_weapon = (_weapons select 1);};
		
		if ((_victimUID != "")) then {
		
			_null = [[player, _wpnVar, _weapon], "(_this select 0) setVariable [(_this select 1), (_this select 2), false]", _victimUID] spawn JDAM_mpCB;
			
		};
	
	};
	
} else {

	_weapon = (typeOf (vehicle player));
	
	if ((_victimUID != "")) then {
		
		_null = [[player, _wpnVar, _weapon], "(_this select 0) setVariable [(_this select 1), (_this select 2), false]", _victimUID] spawn JDAM_mpCB;
			
	};
	
};

if ((isNil "_weapon")) then {_weapon = (currentMuzzle player);};

// DEBUG
// _null = [[_ammoClass, _weapon], "player sideChat format ['SEND WEAPON: %1, %2', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;

_weapon