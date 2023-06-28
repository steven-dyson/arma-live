private "_table";
private "_UID";

_table = _this select 0;
_UID = _this select 1;

if (!isNil{_table getVariable format ["P%1KIT", _UID]}) then
{
		private "_lastKitName";
		_lastKitName = _table getVariable format ["P%1KIT", _UID];
		_table setVariable [_lastKitName, ((_table getVariable _lastKitName) + 1), true];
};