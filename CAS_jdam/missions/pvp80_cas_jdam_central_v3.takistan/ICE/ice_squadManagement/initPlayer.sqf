waitUntil {sleep 0.1; (alive player) && (SPY_introComplete)};

_null = [] execVM "ICE\ice_squadManagement\custom\showWithOptions.sqf";

while {true} do {

	waitUntil {sleep 0.1; (alive player)};
	
	player addAction ["Squad Management", "ICE\ice_squadManagement\custom\showWithOptions.sqf", [], 0, false, true, ""];
	
	waitUntil {sleep 0.1; !(alive player)};
	
};