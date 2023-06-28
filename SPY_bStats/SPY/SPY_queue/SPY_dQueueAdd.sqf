/***************************************************************************
DELAY QUEUE ADD
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_args", "_script", "_delay"];

_args = (_this select 0);
_script = (_this select 1);
_delay = (_this select 2);

SPY_eMP_D_QUEUE set [(count SPY_eMP_D_QUEUE), [_args, _script, (time + _delay)]];