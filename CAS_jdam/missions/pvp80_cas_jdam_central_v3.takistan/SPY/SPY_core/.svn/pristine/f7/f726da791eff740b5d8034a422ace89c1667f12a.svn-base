/***************************************************************************
DELAY QUEUE ADD
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_args", "_script", "_delay", "_target"];

_args = (_this select 0);
_script = (_this select 1);
_delay = (_this select 2);
_target = (_this select 3);

if ((_target in ["LOCAL"])) then {

	SPY_queue_delay = (SPY_queue_delay + [[_args, _script, (time + _delay)]]);

} else {
	
	[[_args, _script, (time + _delay)], "SPY_queue_delay = (SPY_queue_delay + [[(_this select 0), (_this select 1), (_this select 2)]]);", _target] spawn CAS_mpCB;
	
};