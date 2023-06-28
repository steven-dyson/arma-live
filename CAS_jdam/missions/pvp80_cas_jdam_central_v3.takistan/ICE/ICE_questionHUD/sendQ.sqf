// Desc: Broadcast a query to a client.
//-----------------------------------------------------------------------------
#include "common.sqh"

if (count _this != 4) then {diag_log ["Error: bad param's", _this]};
_target = _this select 0;
_caller = _this select 1; // always player or server
_message = _this select 2;
_code = _this select 3;

ICE_questionHUD_outgoingQueueQId = ICE_questionHUD_outgoingQueueQId + 1;
_queueId = ICE_questionHUD_outgoingQueueQId; // store current value

// store id, which is unique on this client, used for identifying reply.
// store time message was sent, to allow for timeout.
ICE_questionHUD_outgoingQueueQ = ICE_questionHUD_outgoingQueueQ + [[_queueId, _target, _caller, _code, time]];

if (_target == player) then
{
	// no need to broadcast to all clients if query initiated by this client.
	(_this+[_queueId]) execVM _c_basePath(receiveQ.sqf);
}
else
{
	["c",
		{_this execVM _c_basePath(receiveQ.sqf)}, 
		_this+[_queueId]
	] call ICE_questionHUD_broadcast;
};

diag_log ["sendQ.sqf: Sending", _this+[_queueId]];
