private "_friendUnit";
private "_i";
private "_fail";

if (!((!isNull cursorTarget) && (cursorTarget isKindOf "Man") && (playerSide == (side cursorTarget)) && ((player distance cursorTarget) < 3) && ((damage cursorTarget) > 0))) exitWith {};
_friendUnit = cursorTarget;
if (!isNil {player getVariable "JDAM_HEAL_ACTIVITY_IN_PROGRESS"}) exitWith {};
player setVariable ["JDAM_HEAL_ACTIVITY_IN_PROGRESS", true];

_i = 0;
_fail = false;

player playMove "ainvpknlmstpslaywrfldnon_medic";
	
if ((!isNil {SPY_bMessage})) then {
	
	_null = [3, (format ["Starting first aid on %1", (_friendUnit getVariable "SPY_id_player" select 1)]), "LOCAL", false] spawn SPY_bMessage;
	
} else {

	player sideChat (format ["Starting first aid on %1", (name _friendUnit)]);

};

_cancelAction = player addAction ["Cancel", "CAS\CAS_kitSystem\SPECIAL_WEAPONS\ACTIONS\CAS_cancelActivity.sqf"];

while {_i < 7} do {

	sleep 1;
	
	if ((!alive _friendUnit) || (!alive player) || ((_friendUnit distance player) >= 3)) exitWith {
	
		if ((!isNil {SPY_bMessage})) then {
	
			_null = [3, "First aid failed!", "LOCAL", false] spawn SPY_bMessage;
			
		} else {

			player sideChat "First aid failed";

		};
		
	};
	
	_i = _i + 1;
	
};

if (!_fail) then {

	if (alive player) then {
	
		_friendUnit setDamage 0;
		
	};
	
	if ((!isNil {SPY_bMessage})) then {
	
		// GIVE MEDIC POINTS
		
		_null = [5, (format ["You gave first aid to %1", (_friendUnit getVariable "SPY_id_player" select 1)]), "LOCAL", false] spawn SPY_bMessage;
		
	} else {
	
		player sideChat (format ["You gave first aid to %1", (name _friendUnit)]);
	
	};
		
};

player removeAction _cancelAction;

player setVariable ["JDAM_HEAL_ACTIVITY_IN_PROGRESS", nil];