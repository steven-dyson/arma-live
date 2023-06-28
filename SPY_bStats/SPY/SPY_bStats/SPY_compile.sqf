/***************************************************************************
SPY INIT AND COMPILE (METHOD)
BSTATS COMPILE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
ALL
****************************************************************************/
SPY_initVehicle = compile preprocessFileLineNumbers "SPY\SPY_bStats\init\SPY_initVehicle.sqf";

SPY_reviewVehHit = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewVehHit.sqf";
SPY_reviewVehKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewVehKill.sqf";
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SERVER SECTION
****************************************************************************/
if ((isServer)) then {

	SPY_initAI = compile preprocessFileLineNumbers "SPY\SPY_bStats\init\SPY_initAI.sqf";
	SPY_reviewAIHit = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewAIHit.sqf";
	SPY_reviewAIKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewAIKill.sqf";
	
	SPY_kill = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_kill.sqf";
	SPY_death = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_death.sqf";
	SPY_suicide = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_suicide.sqf";
	SPY_teamKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_teamKill.sqf";
	SPY_vehKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_vehKill.sqf";
	SPY_killAssist = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_killAssist.sqf";
	SPY_acCrash = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_acCrash.sqf";
	SPY_civCas = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_civCas.sqf";
	SPY_roadKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_roadKill.sqf";
	SPY_vehTK = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_vehTK.sqf";
	SPY_trans = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_trans.sqf";
	SPY_damage = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_damage.sqf";
	SPY_capture = compile preprocessFileLineNumbers "SPY\SPY_bStats\scoreType\SPY_capture.sqf";

	SPY_addSideScore = compile preprocessFileLineNumbers "SPY\SPY_bStats\score\SPY_addSideScore.sqf";

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CLIENT SECTION
****************************************************************************/
if ((!(isDedicated))) then {

	SPY_reviewHit = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewHit.sqf";
	SPY_reviewKill = compile preprocessFileLineNumbers "SPY\SPY_bStats\review\SPY_reviewKill.sqf";

	SPY_updateRequest = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_updateRequest.sqf";
	SPY_updateSend = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_updateSend.sqf";
	SPY_storeSelection = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_storeSelection.sqf";
	SPY_storeShot = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_storeShot.sqf";
	SPY_addVeh = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_addVeh.sqf";
	SPY_removeVeh = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_removeVeh.sqf";
	SPY_reset = compile preprocessFileLineNumbers "SPY\SPY_bStats\info\SPY_reset.sqf";
	
	SPY_checkScore = compile preprocessFileLineNumbers "SPY\SPY_bStats\score\SPY_checkScore.sqf";

};
/***************************************************************************
END
****************************************************************************/