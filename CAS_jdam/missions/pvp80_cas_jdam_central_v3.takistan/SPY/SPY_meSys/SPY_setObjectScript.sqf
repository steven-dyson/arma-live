/***************************************************************************
SET OBJECT SCRIPT
Created by Spyder
spyder@armalive.com

_null = [this, "_null = [this, west, 'fixed_wing'] execVM 'SPY\SPY_meSys\SPY_setObjectScript.sqf';"] execVM "setObjectInit.sqf";
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_object", "_side", "_objectType", "_objectPos", "_marker"];

_object = _this select 0;
_side = _this select 1;
_objectType = _this select 2;

waitUntil {(!(isNil "SPY_initAircraft"))};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MARKER NAME SETUP
****************************************************************************/
// _objectPos = (getPos _object); 
// _marker = format ['JDAM_RESPAWN_MARKER_%1_%2_%3', (_objectPos select 0), (_objectPos select 1), (_objectPos select 2)];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SWITCHES FOR DIFFERENT OBJECT TYPES
****************************************************************************/
switch (_objectType) do {

	case "fixed_wing": {
 
		clearWeaponCargo _object; clearMagazineCargo _object;
		// _null = [_object, 300, _marker, 'AT_POS', 600] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};
	
 	case "cargo_plane": {

		_null = [_object] spawn SPY_initAircraft; 
		// _null = [_object, 300, _marker, 'AT_POS', 600] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};

	case "attack_helo": {
	
		clearWeaponCargo _object; clearMagazineCargo _object;
		// _null = [_object, 300, _marker, 'AT_POS', 600] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};

	case "trans_helo": {

		_null = [_object] spawn SPY_initAircraft; 
		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 120, _marker, 'AT_POS', 120] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};

	case "tank": {
 
		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 120, _marker, 'AT_POS', 300] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};

	case "apc": {

		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _object removeWeapon 'ACE_AT5B_Launcher'; _object removeWeapon 'AGS17';
		// _null = [_object, 120, _marker, 'AT_POS', 180] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};
	
	case "tracked_apc": {

		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 120, _marker, 'AT_POS', 180] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};
	
	case "sam": {
	
		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 120, _marker, 'AT_POS', 300] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;
	
	};

	case "repair_truck": {

		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 120, _marker, 'AT_POS', 180] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;
		// _null = [_object, "30"] execVM "ArmStation.sqf";

	};

	case "trans_land": {
		
		// _null = [_object] execVM 'CrateDispenser.sqf';
		// _null = [_object, 60, _marker, 'AT_POS', 180] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;
		
	};
	
	case "arty": {
	
		if ((_side == west)) then {_null = [_object, _side, 'normal', 'M119', 'Artillery', 10] spawn SPY_meSys_fnc_marker;} 
		else {_null = [_object, _side, 'normal', 'D30', 'Artillery', 10] spawn SPY_meSys_fnc_marker;};
		// _null = [_object, 120, _marker, 'AT_POS', 3600] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;
	
	};

	case "farp": {

		_null = [_object, _side, 'farp', '', 'SupplyVehicle', 10] spawn SPY_meSys_fnc_marker;
		_null = [_object, _side] spawn SPY_farpInit;
		// _null = [_object, 60, _marker, 'AT_POS', 3600] execVM 'VehicleRespawning.sqf';
		_null = [_object, _side] spawn SPY_bStats_fnc_initVehicle;

	};

	case "support_box": {
	
		_null = [_object, _side, 'normal', 'Supply Crate', 'mil_box', 10] spawn SPY_meSys_fnc_marker;
		// _null = [_object, 5, 10, 10, ["StaticWeapon"], true] execVM "AmmoHolder.sqf";
		// _null = [_object, 60, _marker, 'AT_POS', 600] execVM 'VehicleRespawning.sqf';

	};

};
/***************************************************************************
END
****************************************************************************/


/***************************************************************************
CARRIER SPAWN: SERVER
****************************************************************************/
// if (!(isServer)) exitWith {};

// Initally wait 10 seconds for script to initalize
// waitUntil {time > 10};

// Set height using its own position
// _object setPosATL ([_object, 999] call GlobalScripts_HighestSurface);
/***************************************************************************
End
****************************************************************************/