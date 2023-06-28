private ["_kitTag", "_kitName", "_limit", "_magazines", "_weapons", "_items", "_headgear", "_uniform", "_vest", "_buildings", "_special"];

_kitTag = "Grenadier";
_kitName = "WestGrenadier";
_limit = 3;

_magazines = [

	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag",
	"1Rnd_HE_Grenade_shell",
	"1Rnd_HE_Grenade_shell",
	"1Rnd_HE_Grenade_shell",
	"1Rnd_HE_Grenade_shell",
	"1Rnd_Smoke_Grenade_shell",
	"1Rnd_Smoke_Grenade_shell",
	"1Rnd_Smoke_Grenade_shell",
    "1Rnd_SmokeRed_Grenade_shell",
	"1Rnd_SmokeGreen_Grenade_shell"
	
];

_weapons = [
	
	["arifle_MX_GL_F", true]
	
];

_attachments = [

	"optic_Aco",
	"acc_pointer_IR"
	

];

_backpack = [

	"B_AssaultPack_khk",

	[
	
		["30Rnd_65x39_caseless_mag", 3, true],
		["acc_flashlight", 1, false],
		["HandGrenade", 1, true],
		["SmokeShell", 1, true],
		["1Rnd_SmokeRed_Grenade_shell", 2, true],
		["1Rnd_SmokeGreen_Grenade_shell", 2, true],
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
 
_vest = "V_PlateCarrierGL_rgr";
 
_buildings = [];

_special = [];

_return = [_kitTag, _magazines, _weapons, _buildings, _special, _limit, _kitName, _items, _headgear, _vest, _backpack, _uniform, _goggles, _attachments];

_return;