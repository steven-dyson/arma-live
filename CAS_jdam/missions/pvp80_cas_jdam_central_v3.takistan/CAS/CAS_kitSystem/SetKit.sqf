private "_unit";
private "_kitName";
private "_table";
private "_UID";
private "_isQueue";

_unit = _this select 0;
_kitName = _this select 1;
_table = JDAM_KIT_TABLE;
_isQueue = false;
if ((count _this) > 2) then
{
	_isQueue = _this select 2;
};

if (!_isQueue) exitWith
{
	JDAM_SERVER_KIT_QUEUE set [(count JDAM_SERVER_KIT_QUEUE), [[_unit, _kitName, true], 1]];
};

_UID = getPlayerUID _unit;
if (_UID == "") exitWith {_null = "ABORTING, DEAD PLAYER UID" createVehicleLocal [0,0,0];};
if ((_table getVariable format ["P%1KIT", _UID]) == _kitName) exitWith {_null = "ABORTING, SAME KIT SELECTED, TO MANY CALLS" createVehicleLocal [0,0,0];};

if ((_table getVariable _kitName) > 0) then
{
	_table setVariable [_kitName, ((_table getVariable _kitName) - 1), true];
	[_table, _UID] call PlayerKits_DropKit;
	_table setVariable [format ["P%1KIT", _UID], _kitName];
	
	[[_kitName], "_this call PlayerKits_RequestFillKit;", _UID] call CAS_mpCB_A;
};