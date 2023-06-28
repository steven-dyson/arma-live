_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Unit has weapon and in alive
waitUntil {sleep 0.1; !(currentMuzzle player isEqualTo "") and (alive player)};

while {true} do
{
	waitUntil { sleep 0.1; alive player };
	
	// Initial weapon
	_muzzleStart = currentMuzzle player;
	
	// Unit switched weapon
	waitUntil { sleep 0.1; !(currentMuzzle player isEqualTo _muzzleStart) };
	
	// Exec CEH
	_null = [[player, currentMuzzle player, _muzzleStart], "SPY_ceh_switchedWpn", 0, true] spawn SPY_core_fnc_cehExec;
	
	// Debug
	_null = [1, format ["Switched Weapon %1 to %2", _muzzleStart, currentMuzzle player], 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage
};