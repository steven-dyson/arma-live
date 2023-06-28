private ["_swName", "_repairAction", "_kitName"];

_swName = "RepairAbility";
_repairAction = "none";
_attachedBody = "none";
_kitName = _this select 0;

while {_kitName == ((call PLAYER_KIT) select 6)} do {

	waitUntil {(((!isNull cursorTarget) && (alive cursorTarget)) && ((cursorTarget isKindOf "LandVehicle") || (cursorTarget isKindOf "Air") || (cursorTarget isKindOf "Ship")) && ((player distance cursorTarget) < (sizeOf (typeOf cursorTarget))) && (((damage cursorTarget) > 0.1) || ([cursorTarget] call CAS_vehIsDisabled))) || (!(_kitName == ((call PLAYER_KIT) select 6)))};

	if (_kitName == ((call PLAYER_KIT) select 6)) then {

		_attachedBody = player;	
		_repairAction = _attachedBody addAction ["Repair Vehicle", "CAS\CAS_kitSystem\SPECIAL_WEAPONS\ACTIONS\RepairActivity.sqf"];

	};

	waitUntil {(!(((!isNull cursorTarget) && (alive cursorTarget)) && ((cursorTarget isKindOf "LandVehicle") || (cursorTarget isKindOf "Air") || (cursorTarget isKindOf "Ship")) && ((player distance cursorTarget) < (sizeOf (typeOf cursorTarget))) && (((damage cursorTarget) > 0.1) || ([cursorTarget] call CAS_vehIsDisabled)))) || (!(_kitName == ((call PLAYER_KIT) select 6)))};

	if ((typeName _repairAction) != "STRING") then {

		_attachedBody removeAction _repairAction;
		_repairAction = "none";

	};

};