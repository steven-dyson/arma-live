private "_table";
private "_UID";
_table = _this select 0;
_UID = _this select 1;

//if (({_UID == getPlayerUID _x} count playableUnits) > 0) exitWith {};

[_table, _UID] call PlayerKits_DropKit;
_table setVariable [format ["P%1KIT", _UID], nil];