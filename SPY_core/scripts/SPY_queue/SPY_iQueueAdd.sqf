/***************************************************************************
Instant Queue Add
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_args", "_script", "_target"];

_args = (_this select 0);
_script = (_this select 1);
_target = (_this select 2);

if ((_target in ["LOCAL"])) then
{
	SPY_queue_instant = (SPY_queue_instant + [[_args, _script]]);
}
else
{
	[[_args, _script], "SPY_queue_instant = (SPY_queue_instant + [[(_this select 0), (_this select 1)]]);", _target] spawn CAS_mpCB;
};