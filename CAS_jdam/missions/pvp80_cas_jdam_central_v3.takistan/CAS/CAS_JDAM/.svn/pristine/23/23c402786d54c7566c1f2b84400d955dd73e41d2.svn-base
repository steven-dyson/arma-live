/***************************************************************************
Build Server
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM ORP Build Server";

private ["_player", "_side", "_group", "_var", "_success", "_inSectorOrSafeZone", "_typeNotAllowed", "_redeploy", "_object", "_name", "_orp", "_marker"];

_player = (_this select 0);
_side = (_this select 1);

_group = (group _player);

_var = ("CAS_JDAM_orp_" + (groupID (group _player)));
_object = (CAS_JDAM_tracker getVariable (_var + "_object"));
_success = true;

_sectors = ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_sectorList") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z2_sectorList") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z3_sectorList"));
_safeZones = ["CAS_JDAM_mkr_safeZone_fobWest", "CAS_JDAM_mkr_safeZone_copWest", "CAS_JDAM_mkr_safeZone_fobEast", "CAS_JDAM_mkr_safeZone_copEast"];

{

	_inSectorOrSafeZone = [_player, _x] call MSO_fnc_inArea;
	
	if ((_inSectorOrSafeZone)) exitWith {
	
		if ((_x in _sectors)) then {
	
			_typeNotAllowed = "sector";
			
		} else {
		
			_typeNotAllowed = "safe zone";
		
		};
		
	};

} forEach (_sectors + _safeZones);

if ((_inSectorOrSafeZone)) exitWith {

	_null = [3, (format ["You can't deploy an ORP in a %1!", _typeNotAllowed]), (getPlayerUID _player), false] spawn SPY_bMessage;

};

if ((!isNil {CAS_JDAM_tracker getVariable (_var + "_assigned")})) then {

	_redeploy = (CAS_JDAM_tracker getVariable (_var + "_redeploy"));

	if ((diag_tickTime < _redeploy)) exitWith {
	
		_null = [3, (format ["You have to wait %1 to redeploy", ([_redeploy - diag_tickTime] call CAS_formatTime)]), (getPlayerUID _player), false, 1] spawn SPY_bMessage;
		_success = false;
		
	};

	_name = (CAS_JDAM_tracker getVariable (_var + "_assigned"));
	_object setPos [1, 1, 1];
	_object setDamage 1;

} else {
	
	_name = (format ["CAS_JDAM_mkr_orp_%1", (groupID (group player))]);

};

if ((!_success)) exitWith {};

_orp = "B_supplyCrate_F" createVehicle [1, 1, 1];

_orp setPos (_player modelToWorld [0, 2, 0]);

CAS_JDAM_tracker setVariable [(format ["%1_respawns", _var]), CAS_JDAM_orp_deploys, true];
CAS_JDAM_tracker setVariable [(format ["%1_redeploy", _var]), (diag_ticktime + CAS_JDAM_orp_redeployDelay), true];
CAS_JDAM_tracker setVariable [(format ["%1_assigned", _var]), _name, true];
CAS_JDAM_tracker setVariable [(format ["%1_object", _var]), _orp, true];

sleep 1;

_marker = (format ["[this, [%1], %2, %3, %4, %5, %6, %7, %8] execVM 'SPY\SPY_meSys\SPY_marker.sqf';", _side, "'ANY'", [("ORP " + (groupID (group _player))), (_var + "_respawns")], "'mil_dot'", 0, "'Default'", 5, (str _name)]);
// _ammo = (format ["_null = [this, %1, %2, %3, %4, %5, %6] execVM 'AmmoHolder.sqf';", 0, 10, 0, [""], false, _side]);

_orp setVehicleInit (_marker);
processInitCommands;

while {sleep 1; true} do {

	if (((CAS_JDAM_tracker getVariable (_var + "_respawns")) <= 0)) exitWith {
	
		_orp setDamage 1;
		_orp setPos [1, 1, 1];
	
	};
	
	if (!(alive _orp)) exitWith {
	
		_orp setDamage 1;
		_orp setPos [1, 1, 1];
		
		CAS_JDAM_tracker setVariable [(_var + "_redeploy"), ((CAS_JDAM_tracker getVariable (_var + "_redeploy")) + 120), true];
	
	};
	
	if (((count (units _group)) < 1)) exitWith {
	
		_orp setDamage 1;
		_orp setPos [1, 1, 1];
	
	};
	
};