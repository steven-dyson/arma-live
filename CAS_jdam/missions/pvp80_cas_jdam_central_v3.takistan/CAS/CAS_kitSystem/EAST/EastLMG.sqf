private "_magazines";
private "_weapons";
private "_kitName";
private "_kitTag";
private "_return";
private "_limit";
_kitTag = "LMG";
_kitName = "EastLMG";
_limit = 3;

_magazines = [
	"200Rnd_65x39_cased_Box",
	"200Rnd_65x39_cased_Box",
	"HandGrenade",
    "SmokeShell"
];
_weapons = [
	
	

	
	["LMG_Mk200_F", true]
];

_attachments = [

	"optic_ACO_grn",
	"acc_pointer_IR"
	
];

_backpack = [

	"B_AssaultPack_rgr",

	[
	     ["acc_flashlight", 1, false],
		["200Rnd_65x39_cased_Box_Tracer", 1, true],
		["200Rnd_65x39_cased_Box", 2, true],
		["HandGrenade", 1, true],
		["SmokeShell", 1, true],
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