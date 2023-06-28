// Desc: Broadcast query in multiplayer, show question text box and allow player to respond yes/no.
// Note: uses display EH
//-----------------------------------------------------------------------------
#include "common.sqh"
if (isDedicated) exitWith {};
//-----------------------------------------------------------------------------
// determine whether this script was called from the addon or a mission. 
_initViaAddon = false;
if (!isNil "_this") then
{
	// An 'addon' parameter will exist for addon version. For missions, use nothing or use any other param.
	if (typeName _this == typeName "") then
	{
		_initViaAddon = (_this == 'addon');
	};
};
// any mission-defined version of this system takes precedence, so ignore this one.
if (_initViaAddon && isClass (missionConfigFile >> "RscTitles" >> "ICE_QuestionHUD")) exitWith
{
	// prevent addon sqdMgt\init.sqf being executed, but allow mission sqdMgt\init.sqf to be executed.
	if (!isMultiplayer) then {diag_log text 'init sys: ignored: a duplicate ICE_QuestionHUD was already found in mission.'}; // SP debug
};
//-----------------------------------------------------------------------------
uiNamespace setVariable ['ICE_questionHUD_Display', displayNull];

waitUntil {!isNil "ICE_CommonFunctions" || time > 25};
waitUntil {!isNil "ICE_requestLayer" || time > 25};

// private variables/functions (ascii I.C.E. = [73,67,69,...]
ICE_questionHUD_layer = if (isNil "ICE_requestLayer") then {736769} else {"ICE_questionHUD_layer" call ICE_requestLayer};
ICE_questionHUD_keyDown = compile preprocessFileLineNumbers _c_basePath(keyDown.sqf);
call compile preprocessFileLineNumbers _c_basePath(fnc_broadcast.sqf);

// private variables
ICE_questionHUD_outgoingQueueQ = [];
ICE_questionHUD_incomingQueueQ = [];
ICE_questionHUD_outgoingQueueQId = 0; // counter which is unique on this client. id which is broadcast with query, in order to identify replies.
ICE_questionHUD_outgoingReplyTimeout = 0; // used to timeout an outgoing reply and to indicate a query is currently being shown.

waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call ICE_questionHUD_keyDown"];

// public function
ICE_questionHUD_sendQ = compile preprocessFileLineNumbers _c_basePath(sendQ.sqf);
