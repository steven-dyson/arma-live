/***************************************************************************
Reset Damage Vehicle
Created by Spyder
spyder@armalive.com
****************************************************************************/

_vehicle = _this select 0;

while { sleep random 5; alive _vehicle } do
{
	_damagingUnits = _vehicle getVariable "SPY_bStats_damagers";
	
	waitUntil { sleep 0.1; (!alive _vehicle) or (count _damagingUnits > 0)};
	
	_damagingUnits = _vehicle getVariable "SPY_bStats_damagers";
	
	// Has damagers
	if ((count _damagingUnits > 0)) then
	{
		// Vehicle has been repaired. Reset & exit.
		if (((damage _vehicle) isEqualTo 0)) exitWith 
		{
			_vehicle setVariable ["SPY_bStats_damagers", [], true];
		};
	};
			
	// Check for damage time out
	{
		// Individual damaging unit went 3 min w/o applying additional damage
		if ((alive _vehicle) and (time >= (_x select 2))) then 
		{
			_damagingUnits deleteAt _forEachIndex;
			_vehicle setVariable ["SPY_bStats_damagers", _damagingUnits, true];
		};
	}
	forEach _damagingUnits;
};