private "_magazines";
private "_weapons";
private "_kitName";
private "_kitTag";
private "_return";
private "_limit";
_kitTag = "Rifleman";
_kitName = "EastRifle";
_limit = 10;

_magazines = [
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"30Rnd_65x39_caseless_green",
	"HandGrenade",
	"HandGrenade",
	"SmokeShell",
	"SmokeShell"
];
_weapons = [
	
	["Binocular"],
    ["NVGoggles"],
	["arifle_Khaybar_F", true]
];

_attachments = [

	"optic_ACO_grn",
	"acc_pointer_IR"
];

_backpack = [

	"B_AssaultPack_rgr",

	[
	    ["acc_flashlight", 1, false],
		["30Rnd_65x39_case_mag", 3, true],
		["HandGrenade", 2, true],
		["SmokeShell", 2, true],
		["SmokeShellGreen", 2, true],	
		["SmokeShellRed", 2, true],
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
 
_headgear = "H_HelmetO_ocamo";

_goggles = "G_Tactical_Clear";
 
 _uniform = "U_O_CombatUniform_ocamo";
 
 _vest = "V_TacVest_oli";
 
_buildings = [];

_special = ["SLAbility"];

_return = [_kitTag, _magazines, _weapons, _buildings, _special, _limit, _kitName, _items, _headgear, _vest, _backpack, _uniform, _goggles, _attachments];

_return;