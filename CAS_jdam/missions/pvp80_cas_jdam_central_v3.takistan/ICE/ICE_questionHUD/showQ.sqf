// Desc: Show next question in queue on screen.
//-----------------------------------------------------------------------------
#include "common.sqh"

//#define _ST_color_Green "<t color='#f0007f00'>"
// BIS off yellow text: E2D8A5
#define _ST_color_secondColour "<t color='#f0E2D8A5'>"
#define _ST_color_white "<t color='#f0ffffff'>"
#define _ST_text_normal "</t>"
#define _c_instructions "<t size='1'>%3<img image='%6'/></t> %1<br/>    Press [%5F5%4] for %5Yes%4.  Press [%5F6%4] for %5No%4.%4  (%5%2s%4)</t>%4"
#define _c_instructionsIcon "\CA\ui\data\ui_action_talk_ca.paa"
#define __questionTimeout 40

diag_log ["showQ.sqf: Showing", ICE_questionHUD_outgoingReplyTimeout, ICE_questionHUD_incomingQueueQ];

if (time <= ICE_questionHUD_outgoingReplyTimeout) exitWith {}; // busy

if (count ICE_questionHUD_incomingQueueQ == 0) exitWith {}; // empty
_record = +(ICE_questionHUD_incomingQueueQ select 0); // keep a copy

if (typeName _record != typeName []) exitWith {}; // not a record, probably being deleted, come back later.
if (count _record == 0) exitWith {}; // empty record
//-----------------------------------------------------------------------------
ICE_questionHUD_outgoingReplyTimeout = time + __questionTimeout;
_message = _record select 2; // string, can contain structured text

// show HUD
ICE_questionHUD_layer cutRsc ["ICE_QuestionHUD", "plain", 0];
if (isClass (configFile >> "CfgSounds" >> "ICE_questionHUD_message")) then
{
	player say "ICE_questionHUD_message";
	player say "ICE_questionHUD_over03";
};

// update HUD
while {time <= ICE_questionHUD_outgoingReplyTimeout} do
{
	_instructions = format [_c_instructions, _message, ceil (ICE_questionHUD_outgoingReplyTimeout-time), 
		_ST_color_white, _ST_text_normal, _ST_color_secondColour, _c_instructionsIcon];
	((uiNamespace getVariable 'ICE_questionHUD_Display') displayCtrl _c_IDC_main) 
		ctrlSetStructuredText parseText _instructions;
	sleep 0.25;
};
//-----------------------------------------------------------------------------
// timeout
if (ICE_questionHUD_outgoingReplyTimeout > 0) then
{
	((uiNamespace getVariable 'ICE_questionHUD_Display') displayCtrl _c_IDC_main) 
		ctrlSetStructuredText parseText format ["<t size='1'><img image='%1'/></t> Query expired.", _c_instructionsIcon];
};
sleep 2;
(uiNamespace getVariable 'ICE_questionHUD_Display') closeDisplay 0;
uiNamespace setVariable ['ICE_questionHUD_Display', displayNull];

// delete query from queue
call
{
	ICE_questionHUD_incomingQueueQ set [0, -1];
	ICE_questionHUD_incomingQueueQ = ICE_questionHUD_incomingQueueQ - [-1];
};

// timeout (sendA.sqf didn't reset timeout to 0)
if (ICE_questionHUD_outgoingReplyTimeout > 0) then
{
	ICE_questionHUD_outgoingReplyTimeout = 0;
};
//-----------------------------------------------------------------------------
// initiate new process to check for more messages in queue
execVM _c_basePath(showQ.sqf);
