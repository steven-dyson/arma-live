/***************************************************************************
INSTANT QUEUE ADD
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_args", "_script"];

_args = (_this select 0);
_script = (_this select 1);

SPY_eMP_I_QUEUE set [(count SPY_eMP_I_QUEUE), [_args, _script, (time + 0.5)]];