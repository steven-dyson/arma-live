// Desc: Process received query.
//-----------------------------------------------------------------------------
#include "common.sqh"

if (count _this != 5) then {diag_log ["Error: bad param's", _this]};
_target = _this select 0;
_caller = _this select 1;
_message = _this select 2;
_code = _this select 3;
_queueId = _this select 4;

diag_log ["receiveQ.sqf: Receiving", _this];

if (isMultiplayer && _target != player) exitWith {}; // not for your client

ICE_questionHUD_incomingQueueQ = ICE_questionHUD_incomingQueueQ + [[_queueId, _caller, _message, time]];

execVM _c_basePath(showQ.sqf);
