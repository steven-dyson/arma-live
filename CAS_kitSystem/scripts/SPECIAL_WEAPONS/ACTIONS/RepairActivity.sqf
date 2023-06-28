private "_friendUnit";
private "_i";
private "_fail";

if (!(((!isNull cursorTarget) && (alive cursorTarget)) && ((cursorTarget isKindOf "LandVehicle") || (cursorTarget isKindOf "Air") || (cursorTarget isKindOf "Ship")) && ((player distance cursorTarget) < (sizeOf (typeOf cursorTarget))) && (((damage cursorTarget) > 0.1) || ([cursorTarget] call CAS_vehIsDisabled)))) exitWith {};

_friendUnit = cursorTarget;

if (!isNil {player getVariable "JDAM_REPAIR_ACTIVITY_IN_PROGRESS"}) exitWith {};

player setVariable ["JDAM_REPAIR_ACTIVITY_IN_PROGRESS", true];

_i = 0;
_fail = false;

player playMove "ainvpknlmstpslaywrfldnon_medic";

if ((!isNil {SPY_bMessage})) then {

	_null = [3, "Starting repairs", "LOCAL", false] spawn SPY_bMessage;
	
} else {

	player sideChat "Starting repairs";

};

_cancelAction = player addAction ["Cancel", "CAS\CAS_kitSystem\SPECIAL_WEAPONS\ACTIONS\CAS_cancelActivity.sqf"];

while {_i < 29} do {

	sleep 1;
	
	if ((!alive _friendUnit) || (!alive player) || ((_friendUnit distance player) >= (sizeOf (typeOf _friendUnit))) || (isNil {player getVariable "JDAM_REPAIR_ACTIVITY_IN_PROGRESS"})) exitWith {
	
		_fail = true; 
		
		if ((!isNil {SPY_bMessage})) then {
		
			_null = [3, "Repairs failed!", "LOCAL", false] spawn SPY_bMessage;
			
		} else {

			player sideChat "Repairs failed!";

		};
		
	};
	
	_i = _i + 1;
	
	if (_i == 7) then {
	
		player playMove "ainvpknlmstpslaywrfldnon_medic";
		
	};
	
	if (_i == 15) then {
	
		player playMove "ainvpknlmstpslaywrfldnon_medic";
		
	};
	
	if (_i == 22) then {
	
		player playMove "ainvpknlmstpslaywrfldnon_medic";
		
	};
	
};

if (!_fail) then {

	//_null = [[_friendUnit], "_this call GlobalScripts_PVRepair;", "SERVER"] spawn CAS_mpCB; 
	_friendUnit setDamage 0;
	
	if ((!isNil {SPY_bMessage})) then {
		
		_null = [5, "Repairs complete", "LOCAL", false] spawn SPY_bMessage;
		
	} else {

		player sideChat "Repairs complete";

	};
	
};

player removeAction _cancelAction;

player setVariable ["JDAM_REPAIR_ACTIVITY_IN_PROGRESS", nil];