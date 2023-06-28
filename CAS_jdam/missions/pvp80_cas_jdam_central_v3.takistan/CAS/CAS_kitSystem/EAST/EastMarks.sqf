private "_magazines";
private "_weapons";
private "_kitName";
private "_kitTag";
private "_return";
private "_limit";
_kitTag = "Marksman";
_kitName = "EastMarks";
_limit = 2;

_magazines = [
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"20Rnd_762x45_Mag",
	"HandGrenade",
	"HandGrenade",
	"SmokeShell",
	"SmokeShell"
];
_weapons = [
	
	["Binocular"],
	["srifle_EBR_F", true]
];

_attachments = [

	"optic_Arco",
	"acc_pointer_IR"
];

_backpack = [

	"B_AssaultPack_rgr",

	[
	    ["acc_flashlight", 1, false],
		["20Rnd_762x45_Mag", 3, true],
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
 
_headgear = "H_HelmetO_ocamo";

_goggles = "G_Tactical_Clear";
 
 _uniform = "U_O_CombatUniform_ocamo";
 
 _vest = "V_TacVest_oli";
 
_buildings = [];

_special = [];

_return = [_kitTag, _magazines, _weapons, _buildings, _special, _limit, _kitName, _items, _headgear, _vest, _backpack, _uniform, _goggles, _attachments];

_return;