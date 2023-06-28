/***************************************************************************
SPY_ISKEY.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM

[KEY PRESSED, ACTION TO COMPARE] call SPY_isKey;
****************************************************************************/

private ["_key", "_action", "_isKey"];

_key = (_this select 0);
_action = (_this select 1);

if ((_key in actionKeys _action)) then {

	_isKey = true;

} else {

	_isKey = false;

};

_isKey