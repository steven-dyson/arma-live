/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
ALL
****************************************************************************/
MSO_fnc_getPos = compile preprocessFileLineNumbers "MSO\MSO_getPos.sqf";
MSO_fnc_vectRotate2D = compile preprocessFileLineNumbers "MSO\MSO_vectRotate2D.sqf";
MSO_fnc_inArea = compile preprocessFileLineNumbers "MSO\MSO_inArea.sqf";
/***************************************************************************
ALL
****************************************************************************/



/***************************************************************************
SERVER
****************************************************************************/
if ((isServer)) then {
	
	CAS_JDAM_init_grids_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\init\CAS_grids_s.sqf";
	
	CAS_JDAM_bp_build_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\bp\CAS_build_s.sqf";
	CAS_JDAM_bp_destroy_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\bp\CAS_destroy_s.sqf";
	
	CAS_JDAM_orp_build_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\orp\CAS_build_s.sqf";
	
	CAS_JDAM_obj_winSector_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\obj\CAS_winSector_s.sqf";
	CAS_JDAM_obj_onChangedGridStatus_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\obj\CAS_onChangedGridStatus_s.sqf";
	CAS_JDAM_obj_onJIP_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\obj\CAS_onJIP_s.sqf";
	CAS_JDAM_obj_ownerChangeSector_s = compile preprocessFileLineNumbers "CAS\CAS_JDAM\obj\CAS_ownerChangeSector_s.sqf";
	
};
/***************************************************************************
ALL
****************************************************************************/



/***************************************************************************
CLIENT
****************************************************************************/
if ((!isDedicated)) then {
	
	CAS_JDAM_bp_playAlarm_c = compile preprocessFileLineNumbers "CAS\CAS_JDAM\bp\CAS_playAlarm_c.sqf";
	
};
/***************************************************************************
ALL
****************************************************************************/