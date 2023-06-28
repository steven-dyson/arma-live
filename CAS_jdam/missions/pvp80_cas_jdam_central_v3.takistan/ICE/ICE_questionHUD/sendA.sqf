// Desc: Broadcast an answer to a client.
//-----------------------------------------------------------------------------
#include "common.sqh"

#define _ST_color_lightGray "<t color='#f0FFFFFF'>"
#define _ST_text_normal "</t>"

_answer = _this select 0; // boolean: yes/no choice

if (count ICE_questionHUD_incomingQueueQ == 0) exitWith {}; // empty
_record = +(ICE_questionHUD_incomingQueueQ select 0); // keep a copy

if (typeName _record != typeName []) exitWith {}; // not a record, probably being deleted, come back later.
if (count _record == 0) exitWith {}; // empty record

ICE_questionHUD_outgoingReplyTimeout = 0; // causes message to be removed from queue (in showQ.sqf)

if (isClass (configFile >> "CfgSounds" >> "ICE_questionHUD_message")) then
{
	player say (if (_answer) then {"ICE_questionHUD_Yes"} else {"ICE_questionHUD_No"});
	player say "ICE_questionHUD_over03";
};

sleep 0.3;
_reply = format ["%2%1%3", (if (_answer) then {"Yes"} else {"No"}), _ST_color_lightGray, _ST_text_normal];
((uiNamespace getVariable 'ICE_questionHUD_Display') displayCtrl _c_IDC_main) 
	ctrlSetStructuredText parseText _reply;

// _record = [_queueId, _caller, time]
_queueId = _record select 0;
_caller = _record select 1;
//_time2 = _record select 2;

["c",
  {_this execVM _c_basePath(receiveA.sqf)}, 
	[_caller, _queueId, _answer]
] call ICE_questionHUD_broadcast;
