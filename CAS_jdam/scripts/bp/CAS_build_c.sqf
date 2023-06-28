/***************************************************************************
Build Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Build Client";

private ["_allowed", "_classes"];

_allowed = true;
_classes = (["All"] - ["Logic", "LaserTarget", "Sound", "ThingEffect"]);

// Check near objects
{
		
	if (((player distance _x) <= 5) && (_x != player)) exitWith {
		
		[3, "You are too close to other objects", "LOCAL", false] spawn SPY_bMessage;
		_allowed = false;
				
	};

} forEach (nearestObjects [player, _classes, 15]);

// Check slope
if ((_allowed)) then {

	if (((abs ([_helper] call BIS_fnc_terrainGradAngle)) > 20)) then {

		_null = [3, "Your build location has too much slope!", (getPlayerUID _player), false] spawn SPY_bMessage;
		_allowed - false;

	};

};

// Deploy if allowed
if ((_allowed)) then {

	player playMove 'amovpercmstpsraswrfldnon_amovpknlmstpslowwrfldnon';
	[[player, "", playerSide], "_this spawn CAS_JDAM_bp_build_s;", "SERVER"] call SPY_iQueueAdd;

};