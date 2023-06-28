/***************************************************************************
Broadcast Information Screen All
Created by Spyder
spyder@armalive.com

Usage:

["String of text displayed", Duration to display, Fade in time, is updating text boolean]
_null = ["Text", 10, 1, false] execVM "SPY\SPY_core\SPY_msg\SPY_core_fnc_bInfoScreen.sqf";
***************************************************************************/

scriptName "SPY Core Msg Broadcast Information Screen All";

private ["_msg", "_duration", "_fadeIn", "_updating", "_endTime"];

_msg = (_this select 0);
_duration = (_this select 1);
_fadeIn = (_this select 2);
_updating = (_this select 3);

_endTime = (time + _duration + _fadeIn);

if ((_updating) && (time >= _endTime)) then {

	titleText [_msg, "BLACK FADED", 2];

} else {

	titleText [_msg, "BLACK FADED", 999];

	waitUntil {sleep 0.1; (time >= _endTime)};
			
	titleText ["", "BLACK IN", 5];

};