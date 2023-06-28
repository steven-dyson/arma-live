private ["_kitTag", "_kitName", "_limit", "_magazines", "_weapons", "_items", "_headgear", "_uniform", "_vest", "_buildings", "_special"];

_kitTag = "Engineer";
_kitName = "WestEngineer";
_limit = 3;

_magazines = [

	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"SLAMDirectionalMine_Wire_Mag",
	"APERSMine_Range_Mag",
	"DemoCharge_Remote_Mag",
	"HandGrenade",
	"HandGrenade",
	"SmokeShell",
	"SmokeShell"
	
];

_weapons = [

	["arifle_MX_F", true]
	
];

_attachments = [

	"optic_Aco",
	"acc_pointer_IR"
	
];

_backpack = [

	"B_AssaultPack_khk",

	[
	    ["acc_flashlight", 1, false],
		["30Rnd_65x39_caseless_mag", 3, true],
		["HandGrenade", 1, true],
		["SmokeShell", 1, true],
		["Chemlight_green", 2, true],
		["Chemlight_red", 2, true],
		["ATMine_Range_Mag", 1, true]
		
			
	]
		
];

_items = [

	"FirstAidKit",
	"ItemRadio",
	"ItemCompass",
	"ItemWatch",
	"ItemMap",
    "NVGoggles",	
	"ItemGPS"
	
 ];
 
_headgear = "H_HelmetB";

_goggles = "G_Tactical_Clear";
 
_uniform = "U_B_CombatUniform_mcam";
 
_vest = "V_PlateCarrier2_rgr";
 
_buildings = [];

_special = ["RepairAbility"];

_return = [_kitTag, _magazines, _weapons, _buildings, _special, _limit, _kitName, _items, _headgear, _vest, _backpack, _uniform, _goggles, _attachments];

_return;