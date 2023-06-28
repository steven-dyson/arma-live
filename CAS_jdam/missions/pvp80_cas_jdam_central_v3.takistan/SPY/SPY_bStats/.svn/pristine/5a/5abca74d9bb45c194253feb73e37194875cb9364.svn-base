/***************************************************************************
Reset Damage Player
Created by Spyder
spyder@armalive.com
****************************************************************************/

while {true} do 
{
	_damagingUnits = player getVariable "SPY_bStats_damagers";
	
	waitUntil { sleep 0.1; (!alive player) or (count _damagingUnits > 0)};
	
	_damagingUnits = player getVariable "SPY_bStats_damagers";
	
	// Player killed
	if ((!alive player)) then 
	{
		waitUntil {sleep 0.1; (alive player)};
		
		player setVariable ["SPY_bStats_damagers", [], false];
		player setVariable ["SPY_bStats_isDriver", false, false];
		player setVariable ["SPY_bStats_vehicle", objNull, true];
		player setVariable ["SPY_bStats_deathState", 0, false];
	}
	// Player has been healed, reset and exit.
	else
	{
		if (((damage player) isEqualTo 0) and (alive player) and (count _damagingUnits > 0)) then {

			player setVariable ["SPY_bStats_damagers", [], false];
		};
	};
	
	// Indiv damaging unit went 3 min w/o applying additional damage
	{
		if ((time >= (_x select 2))) then
		{
			_damagingUnits = player getVariable "SPY_bStats_damagers";
			_damagingUnits deleteAt _forEachIndex;
		};
	}
	forEach _damagingUnits;
};