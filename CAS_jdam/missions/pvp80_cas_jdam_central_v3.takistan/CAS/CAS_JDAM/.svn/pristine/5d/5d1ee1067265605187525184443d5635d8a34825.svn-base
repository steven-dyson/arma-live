private ["_sidePlayer", "_inGrid"];

_sidePlayer = (side player);

while {sleep 5; true} do {

	{

		_inGrid = [player, _x] call MSO_fnc_inArea;
		
		// CHECK SAME SIDE, IF NOT SAME SIDE CHECK SECTORS MET, IF NOT MET EXIT
		if ((_inGrid) && ((getPos player select 2) < 1) && ((vehicle player) == player)) then {

			// CHECK CALL USAGE
			_null = [[_x, player, _sidePlayer, true], "_this call CAS_obj_onChangedGridStatus_s", "SERVER"] spawn SPY_iQueueAdd;

			waitUntil {sleep 1; !([player, _x] call MSO_fnc_inArea)  || ((getPos (vehicle player) select 2) > 1)};

			// CHECK CALL USAGE
			_null = [[_x, player, _sidePlayer, false], "_this call CAS_obj_onChangedGridStatus_s", "SERVER"] spawn SPY_iQueueAdd;

		};

	// DYNAMIC ADD
	} forEach ((CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z1_activeGrids") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z2_activeGrids") + (CAS_JDAM_tracker getVariable "CAS_JDAM_ao1_z3_activeGrids"));
	
};