/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/


/***************************************************************************
Crew Authorization
****************************************************************************/
if ((SPY_meSys_crewAuthEnabled)) then {

	player setVariable ["SPY_meSys_crewAuth_isPilot", false, false];
	player setVariable ["SPY_meSys_crewAuth_isCrewman", false, false];

	_null = ["SPY_ceh_changedVehPos", "SPY_meSys_crewAuth", [], "_null = _this spawn SPY_meSys_crewAuth", "LOCAL", 0] spawn SPY_core_fnc_cehAdd;
	
};

// Debug
_null = [1, "meSys Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
/***************************************************************************
Crew Authorization
****************************************************************************/