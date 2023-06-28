/***************************************************************************
ENTER TUNNEL
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

_player = (_this select 1);
_args = (_this select 3);

_entrance = (_args select 0);

_player setPosASL (getPosASL _entrance);

_h = (floor ((date select 3) + (time / 360)));
_m = (round ((date select 4) + ((time - (_h / 360)) / 60)));

player sideChat format ["T: %1, %2", _h, _m];

_player setVariable ["CAS_STUNNEL_INFO", [true, [_h, _m, time]], true];

setDate [(date select 0), (date select 1), (date select 2), 22, _m];