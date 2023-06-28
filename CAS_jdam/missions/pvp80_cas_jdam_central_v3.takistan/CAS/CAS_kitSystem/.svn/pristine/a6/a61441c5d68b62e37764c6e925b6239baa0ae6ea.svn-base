private "_kitName";
private "_crate";

_kitName = _this select 3;
_crate = _this select 0;

if (((call PLAYER_KIT) select 6) == _kitName) exitWith {hint "ALREADY HAVE THIS KIT!";};
if ((_crate getVariable _kitName) < 1) exitWith {hint "OUT OF KIT!";};
		

if (_crate == JDAM_WEST_KIT_CRATE) then
{
	if ((side player) == west) then
	{
		_null = [[player, _kitName], "_null = _this spawn PlayerKits_SetKit;", "SERVER"] spawn CAS_mpCB;
	}
	else
	{
		hint "THESE ARE NOT YOUR WEAPONS!";
	};
};
if (_crate == JDAM_EAST_KIT_CRATE) then
{
	if ((side player) == east) then
	{
		_null = [[player, _kitName], "_null = _this spawn PlayerKits_SetKit;", "SERVER"] spawn CAS_mpCB;
	}
	else
	{
		hint "THESE ARE NOT YOUR WEAPONS!";
	};
};