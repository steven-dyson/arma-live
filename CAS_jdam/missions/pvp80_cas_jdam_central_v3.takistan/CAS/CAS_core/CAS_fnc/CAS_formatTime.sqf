/***************************************************************************
CAS FORMAT TIME
Created by Spyder & GOSCHIE
spyder@armalive.com
***************************************************************************/

private ["_time", "_h", "_m", "_s", "_timeHMS"];

_time = _this select 0;

_h = floor (_time / 3600);
_m = floor ((_time / 60) - (_h * 60));
_s = floor (_time - ((_h * 3600) + (_m * 60)));

if ((_h < 10)) then {_h = format ["0%1", _h];};
if ((_m < 10)) then {_m = format ["0%1", _m];};
if ((_s < 10)) then {_s = format ["0%1", _s];};

_timeHMS = format["%1:%2:%3", _h, _m, _s];

_timeHMS;