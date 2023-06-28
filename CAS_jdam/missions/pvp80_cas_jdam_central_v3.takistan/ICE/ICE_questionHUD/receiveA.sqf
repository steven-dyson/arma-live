// Desc: Process received answer.
//-----------------------------------------------------------------------------
_origCaller = _this select 0;
_queueId = _this select 1;
_answer = _this select 2;

diag_log ["receiveA.sqf: Process", _this, ICE_questionHUD_outgoingReplyTimeout, ICE_questionHUD_outgoingQueueQ];

if (isMultiplayer && _origCaller != player) exitWith {}; // not for your client

// _x = [_queueId, _target, _caller, _code, time]
_index = -1;
{
	if (_x select 0 == _queueId) exitWith
	{
		_index = _forEachIndex; // identify record to remove

		_target = _x select 1;
		_caller = _x select 2;
		_code = _x select 3;

		diag_log ["receiveA.sqf: call", _this, [_target, _caller, _origCaller, _answer]];
		[_target, _caller, _answer] call _code;

		// if query was sent to self, then sendA.sqf will have already played these sounds locally.
		if (_target != _caller) then
		{
			if (isClass (configFile >> "CfgSounds" >> "ICE_questionHUD_message")) then
			{
				player say (if (_answer) then {"ICE_questionHUD_Yes"} else {"ICE_questionHUD_No"});
				player say "ICE_questionHUD_over03";
			};
		};
	};
} forEach ICE_questionHUD_outgoingQueueQ;

// TODO: could just let queries expire, in order to only delete them from one location.
// delete query from queue
if (_index != -1) then
{
	call
	{
		ICE_questionHUD_outgoingQueueQ set [_index, -1];
		ICE_questionHUD_outgoingQueueQ = ICE_questionHUD_outgoingQueueQ - [-1];
	};
};
