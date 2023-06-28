/***************************************************************************
Disable Simulation Server
Created by Spyder
spyder@armalive.com
****************************************************************************/

scriptName "SPY meSys Disable Simulation Server";

private ["_includes", "_excludes", "_disabled"];

while {true} do {

	_includes = ((allMissionObjects "Static") + (allMissionObjects "Thing"));
	_excludes = ((allMissionObjects "ThingEffect") + (allMissionObjects "ReammoBox") + (allMissionObjects "HeliH"));
	_disabled = 0;
	
	{
	
		if ((simulationEnabled _x)) then {
			
			_disabled = (_disabled + 1);
			
			_x enableSimulation false;
			
			_x addEventHandler ["Hit", {(_this select 0) enableSimulation true; (_this select 0) removeAllEventHandlers "Hit";}];  
			
		};
			
	} forEach (_includes - _excludes);
	
	// Debug
	_null = [1, (format ["dObjSim - %1 objects disabled", _disabled]), "CLIENT", false] spawn SPY_core_fnc_bMessage;

	sleep 300;
	
};