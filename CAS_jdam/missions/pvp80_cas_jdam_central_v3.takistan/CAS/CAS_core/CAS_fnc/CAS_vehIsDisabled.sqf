private "_unit";
private "_return";
_unit = _this select 0;
_return = false;

if (isNull _unit) exitWith {_return;};
if (!(canMove _unit)) then
{
	_return = true;
};

_return;