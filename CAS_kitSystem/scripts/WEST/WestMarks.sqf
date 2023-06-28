private ["_kitTag", "_kitName", "_limit", "_magazines", "_weapons", "_items", "_headgear", "_uniform", "_vest", "_buildings", "_special"];

_kitTag = "Marksman";
_kitName = "WestMarks";
_limit = 2;

_magazines = [

	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"HandGrenade",
	"HandGrenade",
	"SmokeShell",
	"SmokeShell"
	
];

_weapons = [

    ["Binocular"],	
	["arifle_MXM_F", true]
	
];

_attachments = [

	"optic_Hamr",
	"acc_pointer_IR"
	
];

_backpack = [

	"B_AssaultPack_khk",

	[
	    ["acc_flashlight", 1, false],
		["30Rnd_65x39_caseless_mag", 3, true],
		["HandGrenade", 1, true],
		["SmokeShellGreen", 1, true],
		["SmokeShellRed", 1, true],
		["Chemlight_green", 2, true],
		["Chemlight_red", 2, true]
	
			
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

_special = [];

_return = [_kitTag, _magazines, _weapons, _buildings, _special, _limit, _kitName, _items, _headgear, _vest, _backpack, _uniform, _goggles, _attachments];

_return;