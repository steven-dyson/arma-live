private ["_swName", "_medicalAction", "_kitName"];

_swName = "MedicAbility";
_medicalAction = "none";
_attachedBody = "none";
_kitName = _this select 0;

while {_kitName == ((call PLAYER_KIT) select 6)} do {

	waitUntil {(((!isNull cursorTarget) && (alive cursorTarget)) && (cursorTarget isKindOf "Man") && (playerSide == (side cursorTarget)) && ((player distance cursorTarget) < 3) && ((damage cursorTarget) > 0)) || (!(_kitName == ((call PLAYER_KIT) select 6)))};

	if (_kitName == ((call PLAYER_KIT) select 6)) then {
	
		_attachedBody = player;
		_medicalAction = _attachedBody addAction ["Begin First Aid", "CAS\CAS_kitSystem\SPECIAL_WEAPONS\ACTIONS\HealActivity.sqf"];
	
	};
	
	waitUntil {(!(((!isNull cursorTarget) && (alive cursorTarget)) && (cursorTarget isKindOf "Man") && (playerSide == (side cursorTarget)) && ((player distance cursorTarget) < 3) && ((damage cursorTarget) > 0))) || (!(_kitName == ((call PLAYER_KIT) select 6)))};
	
	if ((typeName _medicalAction) != "STRING") then {
	
		_attachedBody removeAction _medicalAction;
		_medicalAction = "none";
	
	};

};