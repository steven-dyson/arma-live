/***************************************************************************
OBJECT NETWORK UPDATE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM

_null = [] execVM "SPY\SPY_oNetU.sqf";
****************************************************************************/

private ["_includes", "_excludes", "_disabled"];

waitUntil {time > 1};

while {true} do {

	_includes = ((allMissionObjects "Static") + (allMissionObjects "Thing"));
	_excludes = ((allMissionObjects "ThingEffect") + (allMissionObjects "ReammoBox") + (allMissionObjects "HeliH"));
	_disabled = 0;
	
	{
	
		if ((simulationEnabled _x)) then {
		
		_disabled = (_disabled + 1);
		
			[_x] spawn {
			
				private ["_object", "_damage"];
				
				sleep (random ((count playableUnits) / 3));
				
				_object = (_this select 0);
				
				_object enableSimulation false;
				
				_object setVariable ["SPY_oNetU_running", 1, false];
				
				// DEBUG
				// player sideChat format ["OBJ: %1", _object];
				
				while {true} do {
				
					_damage = (damage _object);
					
					waitUntil {sleep 0.5; (_damage < (damage _object))};

					_object enableSimulation true;
					
					// DEBUG
					// player sideChat "SIMULATION ENABLED";
					
					sleep 5;
					
					_object enableSimulation false;
					
					// DEBUG
					// player sideChat "SIMULATION DISABLED";
					
					if (((damage _object) >= 1)) exitWith {};
				
				};
				
			};
			
		};
			
	} forEach (_includes - _excludes);
	
	// DEBUG
	diag_log format ["(SPY oNetU - %1): %2 / %3 Objects Disabled", (round time), _disabled, (count (_includes - _excludes))];

	sleep 30;
	
};