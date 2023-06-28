/***************************************************************************
SPY_core_fnc_isKey.SQF
Created by Spyder
spyder@armalive.com

[KEY PRESSED, ACTION TO COMPARE] call SPY_core_fnc_isKey;
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