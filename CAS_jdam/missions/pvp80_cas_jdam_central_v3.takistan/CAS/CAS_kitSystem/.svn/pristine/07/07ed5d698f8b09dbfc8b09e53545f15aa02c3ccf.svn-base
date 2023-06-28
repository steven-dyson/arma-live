private ["_player", "_kit", "_weapons", "_magazines", "_items", "_headGear", "_vest", "_buildings", "_special", "_kitName", "_script"];

_player = (_this select 0);
_kit = (_this select 1);

if ((count _this) > 1) then {

	call compile format ["PLAYER_KIT = PlayerKits_%1;", (_this select 1)];
	
};

_kitStuff = call PLAYER_KIT;

_magazines = (_kitStuff select 1);
_weapons = (_kitStuff select 2);
_special = (_kitStuff select 4);
_kitName = (_kitStuff select 6);
_items = (_kitStuff select 7);
_headGear = (_kitStuff select 8);
_vest = (_kitStuff select 9);
_backpack = (_kitStuff select 10);
_uniform = (_kitStuff select 11);
_goggles = (_kitStuff select 12);
_attachments = (_kitStuff select 13);

_selectPrimary = (_weapons select 1);

removeAllAssignedItems _player;
removeAllWeapons _player;
removeHeadgear _player;
removeUniform _player;
removeAllContainers _player;

// Headgear
if ((_headgear != "")) then {

	_player addHeadGear _headGear;

};

// Goggles
if ((_goggles != "")) then {

	_player addGoggles _goggles;

};

// Vest
if ((_vest != "")) then {

	_player addVest _vest;

};

// Backpack
if (((_backpack select 0) != "")) then {

	_player addBackpack (_backpack select 0);
	
	{
	
		if ((_x select 2)) then {
	
			(unitBackpack _player) addMagazineCargo [(_x select 0), (_x select 1)];
			
		} else {
		
			(unitBackpack _player) addItemCargo [(_x select 0), (_x select 1)];
		
		};
		
	} forEach (_backpack select 1);
	
};

// Magazines
{

	_player addMagazine _x;
	
} foreach _magazines;

// Items
{

	_player addItem _x;
	
	if ((_x != "FirstAidKit")) then {
	
		_player assignItem _x;
		
	};
	
} forEach _items;

// Weapons
{
			
	_player addWeapon (_x select 0);
	
	if ((!isNil {_x select 1})) then {
	
		_player selectWeapon (_x select 0);
		
	};
	
} forEach _weapons;

// Attachments
{

	_player addPrimaryWeaponItem _x;

} forEach _attachments;

// Uniform
if ((_uniform != "")) then {

	player addUniform _uniform;

}; 

if (isNil "JDAM_KIT_SW_RAN") then {

	JDAM_SW_SCRIPTS = [];
	JDAM_KIT_SW_RAN = "none";
	
};

if (_kitName != JDAM_KIT_SW_RAN) then {

	waitUntil {({!scriptDone _x} count JDAM_SW_SCRIPTS) < 1};
	
	JDAM_SW_SCRIPTS = [];
	JDAM_KIT_SW_RAN = _kitName;
	
	{
	
		_script = call compile format ["private '_script'; _script = ['%2'] spawn SpecialWeapon_%1; _script;", _x, _kitName];
		JDAM_SW_SCRIPTS set [(count JDAM_SW_SCRIPTS), _script];
		
	} forEach _special;
	
};

// [_player, _kitName] call ClientBuildSystem_BuildingActionMenu;