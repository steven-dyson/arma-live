// Desc: "keyDown" EH
//-----------------------------------------------------------------------------
#include "armaGameVer.sqh"
#include "defineDIKCodes.sqh"
#include "common.sqh"

private['_handled' /*, '_control' */, '_dikCode', '_shiftKey', '_ctrlKey', '_altKey', '_keys'];
//_control = _this select 0;
_dikCode = _this select 1; // key
_shiftKey = _this select 2;
_ctrlKey = _this select 3;
_altKey = _this select 4;

_handled = false;
//if (count ICE_questionHUD_incomingQueueQ == 0) exitWith {_handled};
if (ICE_questionHUD_outgoingReplyTimeout == 0) exitWith {_handled}; // no active question exists
if (time > ICE_questionHUD_outgoingReplyTimeout) exitWith {_handled}; // question has expired, waiting for removal from queue

#define _keys [DIK_PGUP, DIK_PGDN, DIK_F5, DIK_F6, DIK_Y, DIK_N, DIK_HOME, DIK_END]
if (_dikCode in _keys) then
{
	if (!_ctrlKey && !_altKey && !_shiftKey) then
	{
		[_dikCode in [DIK_PGUP, DIK_F5, DIK_HOME]] execVM _c_basePath(sendA.sqf);
		_handled = true;
	};
	if (!_ctrlKey && _altKey && !_shiftKey) then
	{
		[_dikCode == DIK_Y] execVM _c_basePath(sendA.sqf);
		_handled = true;
	};
};

_handled
