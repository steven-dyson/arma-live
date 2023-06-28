/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_compile", "_pUID"];

// Compile scripts if client is not server
if ((!isServer)) then {

	_compile = [] execVM "SPY\SPY_roe\SPY_compile.sqf";
	waitUntil {sleep 0.1; scriptDone _compile};
	
};

// Retrieve player UID
_pUID = (player getVariable "SPY_id_uid");

// Initialize punish/locks variable
SPY_container setVariable ["SPY_roe_" + _pUID, [0, 0], false];

// Use bStats killed event handler as it is more accurate
if (!(SPY_bStats_enabled)) then 
{
	player addEventHandler ["Killed", {_null = [(_this select 0), (_this select 1)] spawn SPY_reviewROE;}];
};

// Log
player createDiarySubject ["SPY ROE","SPY ROE"];

// Start punish monitor
_null = [] execVM "SPY\SPY_roe\SPY_gainPunish.sqf";

// SPY Custom Event Handler hooks
// _null = [player, "SPY_bStats_onCrash", "SPY_roe_hook", [], "SPY_bStats_fnc_onTestCEH"] spawn SPY_core_fnc_cehAdd;
// _null = [player, "SPY_bStats_onTK_inf", "SPY_roe_hook", [], "SPY_bStats_fnc_onTestCEH"] spawn SPY_core_fnc_cehAdd;
// _null = [player, "SPY_bStats_onTK_veh", "SPY_roe_hook", [], "SPY_bStats_fnc_onTestCEH"] spawn SPY_core_fnc_cehAdd;

// Debug
_null = [1, "ROE initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;