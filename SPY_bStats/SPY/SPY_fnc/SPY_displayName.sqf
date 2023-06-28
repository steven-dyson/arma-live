/***************************************************************************
DISPLAY NAME
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_className", "_displayName"];

_className = (_this select 0);

// OBJECT WAS SENT
if ((typeName _className != "STRING") && (typeName _className != "SIDE")) then {_className = typeOf _className};

switch (_className) do {

	// SIDES & FACTIONS

		// BLUFOR
		case WEST: {_displayName = "BLUFOR";};
		case BIS_US: {_displayName = "US Army";};
		case USMC: {_displayName = "US Marines";};

		// OPFOR
		case EAST: {_displayName = "OPFOR";};
		case BIS_TK: {_displayName = "Takistani Army";};
		case RU: {_displayName = "Russian Ground Forces";};
		
		// ALL
		case "HandGrenadeMuzzle": {_displayName = "Grenade";};

	// BLUFOR WEAPONS

		// RIFLES
		case "SCAR_L_STD_EGLM_RCO": {_displayName = "Mk16 EGLM";};
		case "SCAR_L_CQC_Holo": {_displayName = "Mk16";};
		case "SCAR_L_STD_HOLO": {_displayName = "Mk16";};
		case "G36a": {_displayName = "G36";};
		case "G36C": {_displayName = "G36c";};
		case "G36_C_SD_eotech": {_displayName = "G36C Eotech SD";};
		case "G36K": {_displayName = "G36k";};
		case "M16A2": {_displayName = "M16A2";};
		case "M16A2GL": {_displayName = "M16A2 M203";};
		case "M16A4": {_displayName = "M16A4";};
		case "M16A4_GL": {_displayName = "M16A4 M203";};
		case "M16A4_ACG_GL": {_displayName = "M16A4 M203 RCO";};
		case "M16A4_ACG": {_displayName = "M16A4 RCO";};
		case "M4A1": {_displayName = "M4A1";};
		case "M4A1_HWS_GL": {_displayName = "M4A1 M203 Holo";};
		case "M4A1_HWS_GL_camo": {_displayName = "M4A1 M203 Holo Camo";};
		case "M4A1_HWS_GL_SD_Camo": {_displayName = "M4A1 M203 Holo SD";};
		case "M4A1_RCO_GL": {_displayName = "M4A1 M203 RCO";};
		case "M4A1_Aim": {_displayName = "M4A1 CCO";};
		case "M4A1_Aim_camo": {_displayName = "M4A1 CCO Camo";};
		case "M4A1_AIM_SD_camo": {_displayName = "M4A1 CCO Camo SD";};
		case "MP5A5": {_displayName = "MP5A5";};
		case "MP5SD": {_displayName = "MP5SD6";};
		case "VSS_vintorez": {_displayName = "VSS Vintorez";};
		case "M8_carbine": {_displayName = "XM8 Carabine";};
		case "M8_carbineGL": {_displayName = "XM8 Carabine M203";};
		case "M8_compact": {_displayName = "XM8 Compact";};
		case "G36A_camo": {_displayName = "G36A Camo";};
		case "G36C_camo": {_displayName = "G36C Camo";};
		case "G36_C_SD_camo": {_displayName = "G36C SD Camo";};
		case "G36K_camo": {_displayName = "G36K Camo";};
		case "M14_EP1": {_displayName = "M14 Aimpoint";};
		case "M4A3_RCO_GL_EP1": {_displayName = "M4A3 M203 Acog";};
		case "M4A3_CCO_EP1": {_displayName = "M4A3 CCO";};
		case "SCAR_L_CQC_CCO_SD": {_displayName = "Mk16 CCO SD";};
		case "SCAR_L_CQC": {_displayName = "Mk16 CQC";};
		case "SCAR_L_CQC_Holo": {_displayName = "Mk16 CQC Holo";};
		case "SCAR_L_CQC_EGLM_Holo": {_displayName = "Mk16 EGLM Holo";};
		case "SCAR_L_STD_EGLM_RCO": {_displayName = "Mk16 EGLM RCO";};
		case "SCAR_L_STD_EGLM_TWS": {_displayName = "Mk16 EGLM TWS";};
		case "SCAR_L_STD_HOLO": {_displayName = "Mk16 Holo";};
		case "SCAR_L_STD_Mk4CQT": {_displayName = "Mk16 Mk4CQ/T";};
		case "SCAR_H_CQC_CCO": {_displayName = "Mk17 CCO";};
		case "SCAR_H_CQC_CCO_SD": {_displayName = "Mk17 CCO SD";};
		case "SCAR_H_STD_EGLM_Spect": {_displayName = "Mk17 EGLM RCO";};
		case "m8_tws_sd": {_displayName = "XM8 TWS SD";};
		case "m8_tws": {_displayName = "XM8 TWS";};
		case "m8_holo_sd": {_displayName = "XM8 Holo SD";};
		case "m8_compact_pmc": {_displayName = "XM8 Compact";};
		case "m8_carbine_pmc": {_displayName = "XM8 Compact";};
		case "BAF_L110A1_Aim": {_displayName = "L110A1";};
		case "BAF_L85A2_RIS_ACOG": {_displayName = "L85A2 Acog";};
		case "BAF_L85A2_RIS_CWS": {_displayName = "L85A2 AWS";};
		case "BAF_L85A2_RIS_Holo": {_displayName = "L85A2 Holo";};
		case "BAF_L85A2_RIS_SUSAT": {_displayName = "L85A2 SUSAT";};
		case "BAF_L85A2_UGL_ACOG": {_displayName = "L85A2 Acog GL";};
		case "BAF_L85A2_UGL_Holo": {_displayName = "L85A2 Holo GL";};
		case "BAF_L85A2_UGL_SUSAT": {_displayName = "L85A2 SUSAT GL";};
		case "BAF_L86A2_ACOG": {_displayName = "L86A2 LSW";};
		
		// MACHINE GUNS
		case "M249_EP1": {_displayName = "M249 SAW";};
		case "Mk_48": {_displayName = "Mk 48 Mod 0";};
		case "M240": {_displayName = "M240";};
		case "M249": {_displayName = "M249";};
		case "M8_SAW": {_displayName = "XM8 Automatic Rifle";};
		case "MG36_camo": {_displayName = "MG36 Camo";};
		case "m240_scoped_EP1": {_displayName = "M240 Scope";};
		case "M249_m145_EP1": {_displayName = "M249 Scope";};
		case "M249_TWS_EP1": {_displayName = "M249 TWS";};
		case "M60A4_EP1": {_displayName = "M60E4";};
		case "Mk_48_DES_EP1": {_displayName = "Mk48 Desert";};
		
		// SNIPER RIFLES
		case "M107": {_displayName = "M107";};
		case "DMR": {_displayName = "DMR";};
		case "M24": {_displayName = "M24";};
		case "M40A3": {_displayName = "M40A3";};
		case "M4SPR": {_displayName = "Mk12 SPR";};
		case "M8_sharpshooter": {_displayName = "XM8 Sharpshooter";};
		case "SCAR_H_LNG_Sniper": {_displayName = "Mk17 Sniper";};
		case "SCAR_H_LNG_Sniper_SD": {_displayName = "Mk17 Sniper SD";};
		case "SCAR_H_STD_TWS_SD": {_displayName = "Mk17 TWS SD";};
		case "m107_TWS_EP1": {_displayName = "M107 TWS";};
		case "M110_NVG_EP1": {_displayName = "M110 NV Scope";};
		case "M110_TWS_EP1": {_displayName = "M110 TI Scope";};
		case "M24_des_EP1": {_displayName = "M24 Desert";};
		case "PMC_AS50_TWS": {_displayName = "AS50 TWS";};
		case "PMC_AS50_scoped": {_displayName = "AS50 Scoped";};
		case "BAF_AS50_scoped": {_displayName = "AS50";};
		case "BAF_AS50_TWS": {_displayName = "AS50 TWS";};
		case "BAF_LRR_scoped": {_displayName = "L115A3 LRR";};
		case "BAF_LRR_scoped_W": {_displayName = "L115A3 LRR";};
		
		// PISTOLS
		case "Colt1911": {_displayName = "M1911A1";};
		case "M9": {_displayName = "M9";};
		case "M9SD": {_displayName = "M9 Silenced";};
		case "glock17_EP1": {_displayName = "Glock17";};
		
		// MISC
		case "EGLMMuzzle": {_displayName = "EGLM";};
		case "M136": {_displayName = "M136 AT4";};
		case "M1014": {_displayName = "M1014";};
		case "Saiga12K": {_displayName = "Saiga 12K";};
		case "AA12_PMC": {_displayName = "AA12";};
		case "BAF_NLAW_Launcher": {_displayName = "NLAW";};
		case "Javelin": {_displayName = "Javelin";};
		case "SMAW": {_displayName = "SMAW";};
		case "Stinger": {_displayName = "Stinger";};
		case "M47Launcher_EP1": {_displayName = "M47 Dragon";};
		case "MAAWS": {_displayName = "MAAWS";};
		case "PipeBombMuzzle": {_displayName = "Satchel Charge";};
		case "Mine": {_displayName = "Anti Armor Mine";};
		
	// BLUFOR VEHICLES
	
		// CARS
		case "HMMWV_DES_EP1": {_displayName = "HMMWV";};
		case "ATV_US_EP1": {_displayName = "ATV";};
		case "HMMWV_MK19_DES_EP1": {_displayName = "HMMWV Mk19";};
		case "HMMWV_TOW_DES_EP1": {_displayName = "HMMWV TOW";};
		case "HMMWV_M998_crows_M2_DES_EP1": {_displayName = "HMMWV CROWS M2";};
		case "HMMWV_M998_crows_MK19_DES_EP1": {_displayName = "HMMWV CROWS Mk19";};
		case "HMMWV_M1151_M2_DES_EP1": {_displayName = "HMMWV GPK M2";};
		case "HMMWV_M998A2_SOV_DES_EP1": {_displayName = "HMMWV SOV";};
		case "HMMWV_Terminal_EP1": {_displayName = "HMMWV Terminal";};
		case "HMMWV_M1035_DES_EP1": {_displayName = "HMMWV Utility";};
		case "HMMWV_Avenger_DES_EP1": {_displayName = "HMMWV Avenger";};
		case "M1030_US_DES_EP1": {_displayName = "HMMWV";};
		case "MTVR_DES_EP1": {_displayName = "MTVR";};
		case "HMMWV": {_displayName = "HMMWV";};
		case "HMMWV_M2": {_displayName = "HMMWV M2";};
		case "HMMWV_Armored": {_displayName = "HMMWV M240";};
		case "HMMWV_MK19": {_displayName = "HMMWV Mk19";};
		case "HMMWV_TOW": {_displayName = "HMMWV TOW";};
		case "HMMWV_Avenger": {_displayName = "M1097 Avenger";};
		case "M1030": {_displayName = "HMMWV";};
		case "MMT_USMC": {_displayName = "Mountainbike";};
		case "MTVR": {_displayName = "MTVR";};
		case "TowingTractor": {_displayName = "Towing Tractor";};	
		
		// ARMOR
		case "M1A1_US_DES_EP1": {_displayName = "M1A1";};
		case "M1A2_US_TUSK_MG_EP1": {_displayName = "M1A2 TUSK";};
		case "MLRS_DES_EP1": {_displayName = "M270 MLRS";};
		case "M2A2_EP1": {_displayName = "M2A2 Bradley IFV";};
		case "M2A3_EP1": {_displayName = "M2A3 ERA Bradly IFV";};
		case "M6_EP1": {_displayName = "M6 Linebacker";};
		case "M1135_ATGMV_EP1": {_displayName = "Stryker TOW";};
		case "M1130_CV_EP1": {_displayName = "Stryker CV";};
		case "M1126_ICV_M2_EP1": {_displayName = "Stryker ICV M2";};
		case "M1126_ICV_mk19_EP1": {_displayName = "Stryker ICV Mk19";};
		case "M1129_MC_EP1": {_displayName = "Stryker MC";};
		case "M1128_MGS_EP1": {_displayName = "Stryker MGS";};
		case "AAV": {_displayName = "AAVP7A1";};
		case "LAV25": {_displayName = "LAV25";};
		case "LAV25_HQ": {_displayName = "LAV25 HQ";};
		case "M1A1": {_displayName = "M1A1";};
		case "M1A2_TUSK_MG": {_displayName = "M1A2 TUSK";};
		case "MLRS": {_displayName = "M270 MLRS";};
		case "BAF_FV510_D": {_displayName = "FV510 Warrior 2";};
		case "BAF_FV510_W": {_displayName = "FV510 Warrior 2";};
		case "BAF_ATV_D": {_displayName = "ATV";};
		case "BAF_Jackal2_GMG_D": {_displayName = "Jackal 2 MWMIK GMG";};
		case "BAF_Jackal2_L2A1_D": {_displayName = "Jackal 2 MWMIK HMG";};
		case "BAF_Offroad_D": {_displayName = "Offroad";};
		case "BAF_ATV_W": {_displayName = "ATV";};
		case "BAF_Jackal2_GMG_W": {_displayName = "Jackal 2 MWMIK GMG";};
		case "BAF_Jackal2_L2A1_W": {_displayName = "Jackal 2 MWMIK HMG";};
		case "BAF_Offroad_W ": {_displayName = "Offroad";};
		case "SUV_PMC_BAF": {_displayName = "SUV";};
		case "SUV_TK_EP1 ": {_displayName = "SUV";};
		case "SUV_UN_EP1 ": {_displayName = "SUV";};
		case "SUV_PMC": {_displayName = "SUV";};
		case "SUV_TK_CIV_EP1 ": {_displayName = "SUV";};
		case "ArmoredSUV_PMC": {_displayName = "Armored SUV";};
		
		
		// SUPPORT
		case "HMMWV_Ambulance_DES_EP1": {_displayName = "HMMWV Ambulance";};
		case "MtvrReammo_DES_EP1": {_displayName = "MTVR Ammo";};
		case "MtvrRefuel_DES_EP1": {_displayName = "MTVR Fuel";};
		case "MtvrRepair_DES_EP1": {_displayName = "MTVR Repair";};
		case "MtvrSupply_DES_EP1": {_displayName = "Stryker MGS";};
		case "M1133_MEV_EP1": {_displayName = "Stryker MEV";};
		case "MtvrSalvage_DES_EP1": {_displayName = "Supply Truck";};
		case "UH60M_MEV_EP1": {_displayName = "UH-60M MEV";};
		case "Zodiac": {_displayName = "Zodiac";};
		case "RHIB": {_displayName = "RHIB";};
		case "RHIB2Turret": {_displayName = "RHIB Mk19";};
		case "HMMWV_Ambulance": {_displayName = "HMMWV Ambulance";};
		case "MtvrReammo": {_displayName = "MTVR Ammunition";};
		case "MtvrRefuel": {_displayName = "MTVR Fuel";};
		case "MtvrRepair": {_displayName = "MTVR Repair";};
		
		//STATIC
		case "Stinger_Pod_US_EP1": {_displayName = "AA Launcher";};
		case "M119_US_EP1": {_displayName = "M119";};
		case "M2StaticMG_US_EP1": {_displayName = "M2 Static MG";};
		case "M2HD_mini_TriPod_US_EP1": {_displayName = "M2 Minitripod";};
		case "MK19_TriPod_US_EP1": {_displayName = "Mk19 Minitripod";};
		case "M252_US_EP1": {_displayName = "M252 81mm Mortar";};
		case "TOW_TriPod_US_EP1": {_displayName = "TOW Tripod";};
		case "Stinger_Pod": {_displayName = "AA Pod";};
		case "M119": {_displayName = "M119";};
		case "M2StaticMG": {_displayName = "M2 Machine Gun";};
		case "M252": {_displayName = "M252 81mm Mortar";};
		case "M2HD_mini_TriPod": {_displayName = "M2HD Minitripod";};
		case "MK19_TriPod": {_displayName = "Mk19 Minitripod";};
		case "TOW_TriPod": {_displayName = "TOW Tripod";};
		case "MG Nest M240": {_displayName = "Fort_Nest_M240";};
		case "BAF_GMG_Tripod_D": {_displayName = "GMG Minitripod";};
		case "BAF_GPMG_Minitripod_D": {_displayName = "GPMG Minitripod";};
		case "BAF_L2A1_Minitripod_D": {_displayName = "L111A1 Minitripod";};
		case "BAF_L2A1_Tripod_D": {_displayName = "L111A1 Tripod";};
		case "BAF_GMG_Tripod_W": {_displayName = "GMG Minitripod";};
		case "BAF_GPMG_Minitripod_W": {_displayName = "GPMG Minitripod";};
		case "BAF_L2A1_Minitripod_W": {_displayName = "L111A1 Minitripod";};
		case "BAF_L2A1_Tripod_W": {_displayName = "L111A1 Tripod";};
		
		// AIRCRAFT
		case "UH60M_EP1": {_displayName = "UH60M";};
		case "A10_US_EP1": {_displayName = "A10";};
		case "AH64D_EP1": {_displayName = "AH64D";};
		case "AH6J_EP1": {_displayName = "AH6J";};
		case "AH6X_EP1": {_displayName = "AH6X";};
		case "C130J_US_EP1": {_displayName = "C130J";};
		case "CH_47F_EP1": {_displayName = "CH47F";};
		case "MH6J_EP1": {_displayName = "MH6J";};
		case "MQ9PredatorB_US_EP1": {_displayName = "MQ9";};
		case "A10": {_displayName = "A10";};
		case "AH1Z": {_displayName = "AH1Z";};
		case "AV8B2": {_displayName = "AV8B";};
		case "AV8B": {_displayName = "AV8B";};
		case "C130J": {_displayName = "C130J";};
		case "F35B": {_displayName = "F35B";};
		case "MH60S": {_displayName = "MH60S";};
		case "MQ9PredatorB": {_displayName = "MQ9";};
		case "MV22": {_displayName = "MV22";};
		case "UH1Y": {_displayName = "UH1Y";};
		case "BAF_Apache_AH1_D": {_displayName = "Apache AH1";};
		case "CH_47F_BAF": {_displayName = "Chinook HC4";};
		case "BAF_Merlin_HC3_D": {_displayName = "Merlin HC3";};
		case "AW159_Lynx_BAF": {_displayName = "Wildcat AH11";};
		
	// OPFOR WEAPONS
	
		// RIFLES
		case "AK_107_GL_kobra": {_displayName = "AK107 GP25";};
		case "AK_107_kobra": {_displayName = "AK107";};	
		case "AKS_74_U": {_displayName = "AKS74U";};
		case "AK_107_GL_pso": {_displayName = "AK107 GP25 PSO";};
		case "AK_107_pso": {_displayName = "AK107 PSO";};
		case "AK_74": {_displayName = "AK74";};
		case "AK_74_GL": {_displayName = "AK74 GP25";};
		case "AK_47_M": {_displayName = "AKM";};
		case "AK_47_S": {_displayName = "AKS";};
		case "AKS_74_kobra": {_displayName = "AKS74 Kobra";};
		case "AKS_74_pso": {_displayName = "AKS74 PSO";};
		case "AKS_74_UN_kobra": {_displayName = "AKS74UN Kobra";};
		case "Bizon": {_displayName = "Bizon PP19";};
		case "bizon_silenced": {_displayName = "Bizon PP19 SD";};
		case "AK_74_GL_kobra": {_displayName = "AK74 GP25 Cobra";};
		case "AKS_74": {_displayName = "AKS74";};
		case "AKS_74_GOSHAWK": {_displayName = "AKS74 GOSHAWK";};
		case "AKS_74_NSPU": {_displayName = "AKS74 NSPU";};
		case "FN_FAL": {_displayName = "FN FAL";};
		case "FN_FAL_ANPVS4": {_displayName = "FN FAL ANPVS4";};
		case "LeeEnfield": {_displayName = "Lee Enfield";};
		case "Sa58P_EP1": {_displayName = "Sa vz.58P";};
		case "Sa58V_EP1": {_displayName = "Sa vz.58V";};
		case "Sa58V_RCO_EP1": {_displayName = "Sa vz.58V Acog";};
		case "Sa58V_CCO_EP1": {_displayName = "Sa vz.58V CCO";};

		// MACHINE GUNS
		case "RPK_74": {_displayName = "RPK74";};
		case "Pecheneg": {_displayName = "Pecheneg";};
		case "PK": {_displayName = "PK";};
		
		// SNIPER RIFLES
		case "Huntingrifle": {_displayName = "CZ 550 Scoped";};
		case "KSVK": {_displayName = "KSVK";};
		case "SVD": {_displayName = "SVD";};
		case "SVD_CAMO": {_displayName = "SVD Camo";};
		case "SVD_des_EP1": {_displayName = "SVD Desert";};
		case "SVD_NSPU_EP1": {_displayName = "SVD NSPU";};
		
		// PISTOLS
		case "Makarov": {_displayName = "Makarov PM";};
		case "MakarovSD": {_displayName = "Makarov Silenced";};
		case "revolver_EP1": {_displayName = "Revolver";};
		case "revolver_gold_EP1": {_displayName = "Revolver Gold";};
		case "Sa61_EP1": {_displayName = "Sa vz.61";};
		case "UZI_EP1": {_displayName = "UZI";};
		case "UZI_SD_EP1": {_displayName = "UZI SD";};
		
		// MISC
		case "GP25Muzzle": {_displayName = "GP25";};
		case "Igla": {_displayName = "Igla";};
		case "MetisLauncher": {_displayName = "Metis AT13";};
		case "RPG18": {_displayName = "RPG18";};
		case "RPG7V": {_displayName = "RPG7V";};
		case "Strela": {_displayName = "Strela";};
		case "TimeBombMuzzle": {_displayName = "Satchel Charge";};
		case "MineE": {_displayName = "Anti Armor Mine";};
		
	// OPFOR VEHICLES
	
		// CARS
		case "UAZ_Unarmed_TK_EP1": {_displayName = "UAZ";};
		case "ATV_CZ_EP1": {_displayName = "ATV";};
		case "HMMWV_M1151_M2_CZ_DES_EP1": {_displayName = "HMMWV GPK M2";};
		case "LandRover_CZ_EP1": {_displayName = "Land Rover";};
		case "LandRover_Special_CZ_EP1": {_displayName = "Land Rover Special";};
		case "MAZ_543_SCUD_TK_EP1": {_displayName = "9P117 SCUD-B";};
		case "GRAD_TK_EP1": {_displayName = "BM21 Grad";};
		case "LandRover_MG_TK_EP1": {_displayName = "Land Rover MG";};
		case "LandRover_SPG9_TK_EP1": {_displayName = "Land Rover SPG-9";};
		case "TT650_TK_EP1": {_displayName = "Motorcycle";};
		case "SUV_TK_EP1": {_displayName = "SUV";};
		case "UAZ_AGS30_TK_EP1": {_displayName = "UAZ AGS30";};
		case "UAZ_MG_TK_EP1": {_displayName = "UAZ DShKM";};
		case "Ural_ZU23_TK_EP1": {_displayName = "Ural ZU23";};
		case "V3S_TK_EP1": {_displayName = "V3S";};
		case "V3S_Open_TK_EP1": {_displayName = "V3S Open";};
		case "LandRover_MG_TK_INS_EP1": {_displayName = "Land Rover MG";};
		case "LandRover_SPG9_TK_INS_EP1": {_displayName = "Land Rover SPG9";};
		case "Old_bike_TK_INS_EP1": {_displayName = "Old Bike";};
		case "SUV_UN_EP1": {_displayName = "SUV";};
		case "UAZ_Unarmed_UN_EP1": {_displayName = "UAZ";};
		case "Ural_UN_EP1": {_displayName = "Ural";};
		case "Offroad_DSHKM_TK_GUE_EP1": {_displayName = "Offroad DShKM";};
		case "Offroad_SPG9_TK_GUE_EP1": {_displayName = "Offroad SPG9";};
		case "Pickup_PK_TK_GUE_EP1": {_displayName = "Pickup PK";};
		case "Ural_ZU23_TK_GUE_EP1": {_displayName = "Ural ZU23";};
		case "V3S_TK_GUE_EP1": {_displayName = "V3S";};
		case "Ikarus_TK_CIV_EP1": {_displayName = "Bus";};
		case "Lada1_TK_CIV_EP1": {_displayName = "Lada TK";};
		case "Lada2_TK_CIV_EP1": {_displayName = "Lada TK2";};
		case "LandRover_TK_CIV_EP1": {_displayName = "Land Rover";};
		case "TT650_TK_CIV_EP1": {_displayName = "Motorcycle";};
		case "Old_bike_TK_CIV_EP1": {_displayName = "Old Bike";};
		case "Old_moto_TK_Civ_EP1": {_displayName = "Old Motorcycle";};
		case "hilux1_civil_3_open_EP1": {_displayName = "Pickup";};
		case "S1203_TK_CIV_EP1": {_displayName = "S1203";};
		case "SUV_TK_CIV_EP1": {_displayName = "SUV";};
		case "UAZ_Unarmed_TK_CIV_EP1": {_displayName = "UAZ";};
		case "Ural_TK_CIV_EP1": {_displayName = "Ural";};
		case "V3S_Open_TK_CIV_EP1": {_displayName = "V3S Open";};
		case "Volha_1_TK_CIV_EP1": {_displayName = "Vloha Blue";};
		case "Volha_2_TK_CIV_EP1": {_displayName = "Vloha Grey";};
		case "VolhaLimo_TK_CIV_EP1": {_displayName = "Vloha Limo";};
		case "GRAD_CDF": {_displayName = "BM21 Grad";};
		case "UAZ_CDF": {_displayName = "UAZ";};
		case "UAZ_AGS30_CDF": {_displayName = "UAZ AGS30";};
		case "UAZ_MG_CDF": {_displayName = "UAZ DShKM";};
		case "Ural_CDF": {_displayName = "Ural";};
		case "UralOpen_CDF": {_displayName = "Ural Open";};
		case "Ural_ZU23_CDF": {_displayName = "Ural (ZU-23";};
		case "GRAD_RU": {_displayName = "BM21 Grad";};
		case "UAZ_RU": {_displayName = "UAZ";};
		case "UAZ_AGS30_RU": {_displayName = "UAZ AGS30";};
		case "Kamaz": {_displayName = "Utility Truck";};
		case "KamazOpen": {_displayName = "Utility Truck Open";};
		case "GRAD_INS": {_displayName = "BM21 Grad";};
		case "TT650_Ins": {_displayName = "Motorcycle";};
		case "Offroad_DSHKM_INS": {_displayName = "Offroad DSHKM";};
		case "Pickup_PK_INS": {_displayName = "Pickup PK";};
		case "UAZ_INS": {_displayName = "UAZ";};
		case "UAZ_AGS30_INS": {_displayName = "UAZ AGS30";};
		case "UAZ_MG_INS": {_displayName = "UAZ MG";};
		case "UAZ_SPG9_INS": {_displayName = "UAZ SPG9";};
		case "Ural_INS": {_displayName = "Ural";};
		case "UralOpen_INS": {_displayName = "Ural Open";};
		case "Ural_ZU23_INS": {_displayName = "Ural ZU23";};
		case "TT650_Gue": {_displayName = "Motorcycle";};
		case "Offroad_DSHKM_Gue": {_displayName = "Offroad DSHKM";};
		case "Offroad_SPG9_Gue": {_displayName = "Offroad SPG9";};
		case "Pickup_PK_GUE": {_displayName = "Pickup PK";};
		case "V3S_Gue": {_displayName = "Praha V3S";};
		case "Ural_ZU23_Gue": {_displayName = "Ural ZU23";};
		case "Ikarus": {_displayName = "Bus";};
		case "SkodaBlue": {_displayName = "Car";};
		case "SkodaGreen": {_displayName = "Car";};
		case "SkodaRed": {_displayName = "Car";};
		case "Skoda": {_displayName = "Car";};
		case "VWGolf": {_displayName = "Car";};
		case "TT650_Civ": {_displayName = "Motorcycle";};
		case "MMT_Civ": {_displayName = "Mountainbike";};
		case "hilux1_civil_2_covered": {_displayName = "Offroad";};
		case "hilux1_civil_1_open": {_displayName = "Offroad";};
		case "hilux1_civil_3_open": {_displayName = "Offroad";};
		case "car_hatchback": {_displayName = "Car";};
		case "datsun1_civil_1_open": {_displayName = "Pickup";};
		case "datsun1_civil_2_covered": {_displayName = "Pickup";};
		case "datsun1_civil_3_open": {_displayName = "Pickup";};
		case "KV3S_Civ": {_displayName = "Praha V3S";};
		case "Kcar_sedan": {_displayName = "Car";};
		case "Tractor": {_displayName = "Tractor";};
		case "UralCivil": {_displayName = "Ural civ";};
		case "UralCivil2": {_displayName = "Ural civ";};
		case "Lada_base": {_displayName = "VAZ";};
		case "LadaLM": {_displayName = "VAZ";};
		case "Lada2": {_displayName = "VAZ";};
		case "Lada1": {_displayName = "VAZ";};
		
		// ARMOR
		case "BMP2_TK_EP1": {_displayName = "BMP2";};
		case "BMP2_HQ_TK_EP1": {_displayName = "BMP2 HQ";};
		case "BRDM2_TK_EP1": {_displayName = "BRDM2";};
		case "BRDM2_ATGM_TK_EP1": {_displayName = "BRDM2 ATGM";};
		case "BTR60_TK_EP1": {_displayName = "BTR60";};
		case "M113_TK_EP1": {_displayName = "M113";};
		case "T34_TK_EP1": {_displayName = "T34";};
		case "T55_TK_EP1": {_displayName = "T55";};
		case "T72_TK_EP1": {_displayName = "T72";};
		case "ZSU_TK_EP1": {_displayName = "ZSU23";};
		case "BTR40_TK_INS_EP1": {_displayName = "BTR40";};
		case "BTR40_MG_TK_INS_EP1": {_displayName = "BTR40 DShKM";};
		case "BMP2_UN_EP1": {_displayName = "BMP2";};
		case "M113_UN_EP1": {_displayName = "M113";};
		case "BRDM2_TK_GUE_EP1": {_displayName = "BRDM2";};
		case "BRDM2_HQ_TK_GUE_EP1": {_displayName = "BRDM2 HQ";};
		case "BTR40_TK_GUE_EP1": {_displayName = "BTR40";};
		case "BTR40_MG_TK_GUE_EP1": {_displayName = "BTR40 DShKM";};
		case "T34_TK_GUE_EP1": {_displayName = "T34";};
		case "T55_TK_GUE_EP1": {_displayName = "T55";};
		case "BMP2_CDF": {_displayName = "BMP2";};
		case "BMP2_HQ_CDF": {_displayName = "BMP2 HQ";};
		case "BRDM2_CDF": {_displayName = "BRDM2";};
		case "BRDM2_ATGM_CDF": {_displayName = "BRDM2 ATGM";};
		case "T72_CDF": {_displayName = "T72";};
		case "ZSU_CDF": {_displayName = "ZSU23 Shilka";};
		case "2S6M_Tunguska": {_displayName = "2S6M Tunguska";};
		case "BMP3": {_displayName = "BMP3";};
		case "BTR90": {_displayName = "BTR90";};
		case "BTR90_HQ": {_displayName = "BTR90 HQ";};
		case "T72_RU": {_displayName = "T72";};
		case "T90": {_displayName = "T90";};
		case "GAZ_Vodnik": {_displayName = "Vodnik 2xPK";};
		case "GAZ_Vodnik_HMG": {_displayName = "Vodnik BPPU";};
		case "BMP2_INS": {_displayName = "BMP2";};
		case "BMP2_HQ_INS": {_displayName = "BMP2 HQ";};
		case "BRDM2_INS": {_displayName = "BRDM2";};
		case "BRDM2_ATGM_INS": {_displayName = "BRDM2 ATGM";};
		case "T72_INS": {_displayName = "T72";};
		case "ZSU_INS": {_displayName = "ZSU23 Shilka";};
		case "BMP2_Gue": {_displayName = "BMP2";};
		case "BRDM2_Gue": {_displayName = "BRDM2";};
		case "BRDM2_HQ_Gue": {_displayName = "BRDM2 HQ";};
		case "T34": {_displayName = "T34";};
		case "T72_Gue": {_displayName = "T72";};
		
		// SUPPORT
		case "HMMWV_Ambulance_CZ_DES_EP": {_displayName = "HMMWV Ambulance";};
		case "M113Ambul_TK_EP1": {_displayName = "M113 Ambulance";};
		case "UralSupply_TK_EP1": {_displayName = "Supply Truck";};
		case "UralSalvage_TK_EP1": {_displayName = "Salvage Truck";};
		case "UralReammo_TK_EP1": {_displayName = "Ural Ammo";};
		case "UralRefuel_TK_EP1": {_displayName = "Ural Fuel";};
		case "UralRepair_TK_EP1": {_displayName = "Ural Repair";};
		case "M113Ambul_UN_EP1": {_displayName = "M113 Ambulance";};
		case "V3S_Salvage_TK_GUE_EP1": {_displayName = "Salvage Truck";};
		case "V3S_Supply_TK_GUE_EP1": {_displayName = "Supply Truck";};
		case "V3S_Reammo_TK_GUE_EP1": {_displayName = "Ural Ammo";};
		case "V3S_Refuel_TK_GUE_EP1": {_displayName = "Ural Fuel";};
		case "V3S_Repair_TK_GUE_EP1": {_displayName = "Ural Repair";};
		case "S1203_ambulance_EP1": {_displayName = "S1203 Ambulance";};
		case "BMP2_Ambul_CDF": {_displayName = "BMP2 Ambulance";};
		case "Mi17_medevac_CDF": {_displayName = "Mi17IVA Medevac";};
		case "UralReammo_CDF": {_displayName = "Ural Ammunition";};
		case "UralRefuel_CDF": {_displayName = "Ural Fuel";};
		case "UralRepair_CDF": {_displayName = "Ural Repair";};
		case "PBX": {_displayName = "PBX";};
		case "KamazReammo": {_displayName = "Kamaz Ammunition";};
		case "Mi17_medevac_RU": {_displayName = "Mi8MT Medevac";};
		case "KamazRefuel": {_displayName = "Utility Truck Fuel";};
		case "KamazRepair": {_displayName = "Utility Truck Repair";};
		case "GAZ_Vodnik_MedEvac": {_displayName = "Vodnik Ambulance";};
		case "BMP2_Ambul_INS": {_displayName = "BMP2 Ambulance";};
		case "Mi17_medevac_Ins": {_displayName = "Mi8MT Medevac";};
		case "UralReammo_INS": {_displayName = "Ural Ammunition";};
		case "UralRefuel_INS": {_displayName = "Ural Fuel";};
		case "UralRepair_INS": {_displayName = "Ural Repair";};
		case "Fishing_Boat": {_displayName = "Fishing Boat";};
		case "Smallboat_1": {_displayName = "Small Boat";};
		case "Smallboat_2": {_displayName = "Small Boat";};
		
		// STATIC
		case "Igla_AA_pod_TK_EP1": {_displayName = "AA Igla Pod";};
		case "AGS_TK_EP1": {_displayName = "AGS30";};
		case "D30_TK_EP1": {_displayName = "D30";};
		case "KORD_high_TK_EP1": {_displayName = "KORD";};
		case "KORD_TK_EP1": {_displayName = "KORD Minitripod";};
		case "Metis_TK_EP1": {_displayName = "Metis AT13";};
		case "2b14_82mm_TK_EP1": {_displayName = "Podnos 2B14";};
		case "ZU23_TK_EP1": {_displayName = "ZU-3";};
		case "AGS_TK_GUE_EP1": {_displayName = "AGS30";};
		case "D30_TK_GUE_EP1": {_displayName = "D30";};
		case "DSHKM_TK_GUE_EP1": {_displayName = "DShKM";};
		case "DSHkM_Mini_TriPod_TK_GUE_EP1": {_displayName = "DShKM Minitripod";};
		case "2b14_82mm_TK_GUE_EP1": {_displayName = "Podnos 2B14";};
		case "SPG9_TK_GUE_EP1": {_displayName = "SPG9";};
		case "ZU23_TK_GUE_EP1": {_displayName = "ZU23";};
		case "AGS_CDF": {_displayName = "AGS30";};
		case "D30_CDF": {_displayName = "D30";};
		case "DSHKM_CDF": {_displayName = "DShKM";};
		case "DSHkM_Mini_TriPod_CDF": {_displayName = "DShKM Minitripod";};
		case "2b14_82mm_CDF": {_displayName = "Podnos 2B14";};
		case "SPG9_CDF": {_displayName = "SPG9";};
		case "ZU23_CDF": {_displayName = "ZU23";};
		case "Igla_AA_pod_East": {_displayName = "AA IGLA Pod";};
		case "AGS_RU": {_displayName = "AGS30";};
		case "D30_RU": {_displayName = "D30";};
		case "KORD_high": {_displayName = "KORD";};
		case "KORD": {_displayName = "KORD Minitripod";};
		case "Metis": {_displayName = "Metis AT13";};
		case "2b14_82mm": {_displayName = "Podnos 2B14";};
		case "AGS_Ins": {_displayName = "AGS30";};
		case "D30_Ins": {_displayName = "D30";};
		case "DSHKM_Ins": {_displayName = "DSHKM";};
		case "DSHkM_Mini_TriPod": {_displayName = "DShKM Minitripod";};
		case "2b14_82mm_INS": {_displayName = "Podnos 2B14";};
		case "SPG9_Ins": {_displayName = "SPG9";};
		case "ZU23_Ins": {_displayName = "ZU23";};
		case "DSHKM_Gue": {_displayName = "DSHKM";};
		case "2b14_82mm_GUE": {_displayName = "Podnos 2B14";};
		case "SPG9_Gue": {_displayName = "SPG9";};
		case "ZU23_Gue": {_displayName = "ZU23";};
		
		// AIRCRAFT
		case "Mi17_CDF": {_displayName = "Mi17";};	
		case "Mi171Sh_CZ_EP1": {_displayName = "Mi171Sh";};
		case "Mi171Sh_rockets_CZ_EP1": {_displayName = "Mi-171Sh Rockets";};
		case "An2_TK_EP1": {_displayName = "An2";};
		case "L39_TK_EP1": {_displayName = "L39ZA";};
		case "Mi24_D_TK_EP1": {_displayName = "Mi24D";};
		case "Mi17_TK_EP1": {_displayName = "Mi8";};
		case "Su25_TK_EP1": {_displayName = "Su25";};
		case "UH1H_TK_EP1": {_displayName = "UH1H";};
		case "Mi17_UN_CDF_EP1": {_displayName = "Mi8";};
		case "UH1H_TK_GUE_EP1": {_displayName = "UH1H";};
		case "An2_1_TK_CIV_EP1": {_displayName = "An2 Aeroshrot";};
		case "An2_2_TK_CIV_EP1": {_displayName = "An2 TakAir";};
		case "Mi17_CDF": {_displayName = "Mi17";};
		case "Mi24_D": {_displayName = "Mi24D";};
		case "Su25_CDF": {_displayName = "Su25";};
		case "Ka52": {_displayName = "Ka52";};
		case "Ka52Black": {_displayName = "Ka52 Black";};
		case "Mi24_P": {_displayName = "Mi24P";};
		case "Mi24_V": {_displayName = "Mi24V";};
		case "Mi17_rockets_RU": {_displayName = "Mi8MTV3";};
		case "Pchela1T": {_displayName = "Pchela1T";};
		case "Su39": {_displayName = "Su39";};
		case "Su34": {_displayName = "Su34";};
		case "Mi17_Ins": {_displayName = "Mi8MT";};
		case "Su25_Ins": {_displayName = "Su25";};
		
	// DEFAULT
	default {_displayName = _className;};

};

_displayName;