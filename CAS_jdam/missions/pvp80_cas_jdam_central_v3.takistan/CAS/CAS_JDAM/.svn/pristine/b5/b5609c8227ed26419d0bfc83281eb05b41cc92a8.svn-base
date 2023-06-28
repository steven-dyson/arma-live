/***************************************************************************
Build Server
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
Init
***************************************************************************/
scriptName "CAS JDAM BP Build Server";

private ["_player", "_type", "_sidePlayer", "_inSector", "_sector", "_sectorOwner", "_bpDeployed", "_ammoClass", "_flagClass", "_bp", "_hescoF", "_hescoR", "_hescoB", "_hescoL"];

_player = (_this select 0);
_type = (_this select 1);
_sidePlayer = (_this select 2);
/***************************************************************************
Init
***************************************************************************/



/***************************************************************************
Retrieve sector information
***************************************************************************/
{

	_inSector = [_player, _x] call MSO_fnc_inArea;
	
	if ((_inSector)) exitWith {
	
		_sector = _x;
		_sectorOwner = (CAS_JDAM_tracker getVariable format ["%1_owner", _x]);
		_bpDeployed = (CAS_JDAM_tracker getVariable format ["%1_bpDeployed", _sector]);
		
	};
	
} forEach ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_sectorList") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z2_sectorList") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z3_sectorList"));
/***************************************************************************
Retrieve sector information
***************************************************************************/



/***************************************************************************
Exit if deploy conditions are not met
***************************************************************************/
if ((_sectorOwner != _sidePlayer)) exitWith {

	[3, "You do not control this sector", (_player getVariable "SPY_id_player" select 0), false, 1] spawn SPY_bMessage;

};

if ((_bpDeployed != "")) exitWith {

	[3, "There is already a battle position here", (_player getVariable "SPY_id_player" select 0), false, 1] spawn SPY_bMessage;
	
};

if ((!_inSector)) exitWith {

	[3, "You must be in a friendly frontline sector", (_player getVariable "SPY_id_player" select 0), false, 1] spawn SPY_bMessage;

};
/***************************************************************************
Exit if deploy conditions are not met
***************************************************************************/



/***************************************************************************
Define side object classes
***************************************************************************/
switch (_sidePlayer) do {

	case west: {
	
		_ammoClass = "B_supplyCrate_F";
		_flagClass = "FlagChecked_F";
	
	};
	
	case east: {
	
		_ammoClass = "Box_East_Ammo_F";
		_flagClass = "FlagSmall_F";
	
	};
	
};
/***************************************************************************
Define side object classeset
***************************************************************************/



/***************************************************************************
Create BP
***************************************************************************/
// Create battle position objects
_bp = ["Land_Cargo_Patrol_V1_F", (_player modelToWorld [0, 4, 0]), -1, ((getDir _player) - 180), false, true] call SPY_core_fnc_createObject; // Tower
_hescoF = ["Land_HBarrier_5_F", (_player modelToWorld [-2.5, 8, 0]), 0, (getDir _player), true, true] call SPY_core_fnc_createObject; // Front
_hescoR = ["Land_HBarrier_5_F", (_player modelToWorld [5, 0.5, 0]), 0, ((getDir _player) - 90), true, true] call SPY_core_fnc_createObject; // Right
_hescoB = ["Land_HBarrier_5_F", (_player modelToWorld [-2.5, -2.5, 0]), 0, (getDir _player), true, true] call SPY_core_fnc_createObject; // Back
_hescoL = ["Land_HBarrier_5_F", (_player modelToWorld [-5, 0.5, 0]), 0, ((getDir _player) - 90), true, true] call SPY_core_fnc_createObject; // Left
_flag = [_flagClass, (_bp modelToWorld [0, 0, 0]), -0.9, 0, false, true] call SPY_core_fnc_createObject; // Flag
_ammo = [_ammoClass, (_bp modelToWorld [1.5, -1.1, 0]), -1.6, 0, true, true] call SPY_core_fnc_createObject; // Ammo

// Define all objects
_bpObjects = [_bp, _ammo, _flag, _hescoF, _hescoR, _hescoB, _hescoL];

// Set battle position variables
_bp setVariable ["CAS_JDAM_side", _sidePlayer, false];
_bp setVariable ["CAS_JDAM_sector", _sector, false];
_bp setVariable ["CAS_JDAM_bpObjects", _bpObjects, false];
_bp setVariable ["CAS_JDAM_chargeSet", false, true];
CAS_JDAM_tracker setVariable [(format ["%1_bpDeployed", _sector]), _sector, true];

// Message
[3, "Battle position set, advance to the next sector!", _sidePlayer, false, 1] spawn SPY_bMessage;

// Add destroy action, defuse action, and marker
_marker = (format ["[this, %1, %2, %3, %4, %5, %6, %7] execVM 'SPY\SPY_meSys\SPY_marker.sqf';", [_sidePlayer], "'ANY'", "'Battle Position'", "'mil_box'", 0, "'Default'", 1000]);
_destroy = (format ["this addAction ['<t color=''#ff0000''>Destroy BP', 'CAS\CAS_JDAM\bp\CAS_destroy_c.sqf', [], -97, false, true, '', '((_this distance _target) <= 3) && !(_target getVariable ''CAS_JDAM_chargeSet'') && ((side _this) == %1)'];", _sidePlayer]);
_defuse = (format ["this addAction ['<t color=''#ff0000''>Defuse Charge', 'CAS\CAS_JDAM\bp\CAS_defuse_c.sqf', [], -97, false, true, '', '((_this distance _target) <= 3) && (_target getVariable ''CAS_JDAM_chargeSet'') && ((side _this) == %1)'];", _sidePlayer]);
// _supply = (format ["_null = [this, %1, %2, %3, %4, %5, %6] execVM 'AmmoHolder.sqf';", 0, 10, 0, [""], false, _sideBP]);

// Broadcast actions and marker
_bp setVehicleInit (_destroy + _defuse + _marker);
processInitCommands;

// Return successful creation
true
/***************************************************************************
Create BP
***************************************************************************/