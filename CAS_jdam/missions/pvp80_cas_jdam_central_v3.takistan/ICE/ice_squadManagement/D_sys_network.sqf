//#include "\ice\ice_main\global.sqh"
// TODO: Consider adding an optional client _target parameter, so when it's called with a "client" scope, it can execute it locally if the _target is local, other broadcast like normal.
// TODO: in ICE_fnc_broadcast, if (_chan == server and isServer) then execute it locally, other broadcast like normal.

// N.B.: Modified version.
// Desc: Broadcast code on all clients and server
//-----------------------------------------------------------------------------
// Broadcast/RE constants

#define __ICE_X_Server 0
#define __ICE_X_Clients -1
#define __ICE_X_ServerClients -2
#define __ICE_X_Invalid -3
//-----------------------------------------------------------------------------
/* Usage:
[ -1, { nul=_this execVM 'script.sqf' }, [_type, _pos, _caller]] call D_NET_fSend;
[-1, compile preprocessFileLineNumbers 'script.sqf', [_type, _pos, _caller]] call D_NET_fSend;
[-1, 'script.sqf', [_type, _pos, _caller]] call D_NET_fSend;

_fn = compile preprocessFileLineNumbers 'script.sqf';
["c", _fn, [_type, _pos, _caller]] call D_NET_fSend;
*/
//-----------------------------------------------------------------------------
/* D_sys_network - s\init.sqf - by Sickboy (sb_at_6thSense.eu)
 * --------------------------------------------------------------
 * Enables network engine support to execute code over the network
 * or make a global say command
 *
 * Notes:
 * - This init.sqf might be executed through a global init script instead of individual XEH Init EH.
 * - Net Engine can be expanded to create individual channels per player, allowing for specific net messaging etc. etc.
 * - PublicVariableEventHandlers do not 'fire' on the computer where you PV the variable. As such we execute the functions also on the computer who calls
 *
 * Examples:
 * - If you want a unit1,unit2, unit3 to say something on every computer:
 * [ [unit1, unit2, unit3], "TestSound" ] call D_NET_fSay;
 * unit1, 2 and 3 would say "TestSound" (if it existed :p)
 *
 * - To execute sth on server:
 * [ 0, { superDebugMode = true } ] call D_NET_fSend;
 *
 * - To execute sth on all clients:
 * [ -1, { superDebugMode = true; player sideChat "Woah Sweet!!" }] call D_NET_fSend;
 *
 * - To execute sth on all clients, unit1, unit2, unit3 write something
 * [ -1, { superDebugMode = true; { _x sideChat "Woah Sweet!!" } forEach _this }, [unit1, unit2, unit3]] call D_NET_fSend;
 *
 * - To execute sth on server & all clients:
 * [ -2, { [] execVM "\ice\ice_main\Scripts\reset.sqf" }] call D_NET_fSend;
 *
*/

// Announce the initialization of the script
D_sys_network = false;


// Say Engine
D_NET_fSay = 
{ 
  D_PUB_SAY = _this; 
  publicVariable "D_PUB_SAY"; 
  {
    _x say (_this select 1)
  } forEach (_this select 0) 
};
"D_PUB_SAY" addPublicVariableEventHandler { 
  private ["_ar"]; 
  _ar =_this select 1; 
  {
    _x say (_ar select 1)
  } forEach (_ar select 0) 
};
//-----------------------------------------------------------------------------
// Net Engine
/*
D_NET_fSend =
{
  ICE_X = _this; 
  publicVariable "ICE_X";
  _this call D_NET_fExec; // unconditionally execute on this calling host
};
*/
ICE_fnc_broadcast =
{
  _this call D_NET_fExec; // unconditionally execute on this calling host
	//-----------------------------------
	// check if channel is 'server' and host is already server, then don't send publicVariable.

	private ["_chan", "_objAr", "_send", "_len"];
	_chan = _this select 0;
	//_cmd = _this select 1;
	if (count _this > 2) then { _objAr = _this select 2 } else { _objAr = [] /* can this be nil instead? */ };

	if (typeName _chan == "STRING") then
	{
		if (_chan in ["s", "S"]) exitWith {_chan = __ICE_X_Server};
		if (_chan in ["c", "C"]) exitWith {_chan = __ICE_X_Clients};
		if (_chan in ["cs", "CS", "sc", "SC", ""]) exitWith {_chan = __ICE_X_ServerClients};
		_chan = __ICE_X_Invalid;
		diag_log ["Error: D_NET_fExec: invalid param: ", _this];
	};

  _send = true; // true mean do broadcast via PV
	if (_chan == __ICE_X_Server && isServer) then // __ICE_X_Server
	{
		_send = false; // already called from server and only for server, so don't waste PV
	};

	if (_send) then
  { 
		ICE_X = _this; 
		publicVariable "ICE_X"; // use ultra short variable name to reduce unnecessary bandwidth. Would normally use something like "ICE_exec_PV". Was D_PUB_CMD.
	};
};
//-----------------------------------------------------------------------------
D_NET_fExec =
{
	private ["_chan", "_cmd", "_objAr", "_ex", "_len"];
	_chan = _this select 0;
	_cmd = _this select 1;
	if (count _this > 2) then { _objAr = _this select 2 } else { _objAr = [] /* can this be nil instead? */ };

	if (typeName _chan == "STRING") then
	{
		if (_chan in ["s", "S"]) exitWith {_chan = __ICE_X_Server};
		if (_chan in ["c", "C"]) exitWith {_chan = __ICE_X_Clients};
		if (_chan in ["cs", "CS", "sc", "SC", ""]) exitWith {_chan = __ICE_X_ServerClients};
		_chan = __ICE_X_Invalid;
		diag_log ["Error: D_NET_fExec: invalid param: ", _this];
	};

  _ex = false;
	switch _chan do
	{
		case 0: { if (isServer) then { _ex = true } }; // server
		case -1: { if (player == player) then { _ex = true } }; // clients only
		case -2: { _ex = true }; // server & clients
		default { _ex = false };
	};
	if (_ex) then 
  { 
    if (typeName _cmd == "STRING") then
    {
      _objAr execVM _cmd; 
    }
    else
    {
      _objAr spawn _cmd; 
    };
  };

#ifdef DEBUG_Broadcast
	DEBUG_Broadcast(_this);
#endif
};
//-----------------------------------------------------------------------------
"ICE_X" addPublicVariableEventHandler { (_this select 1) call D_NET_fExec };

// Announce the completion of the initialization of the script
D_sys_network = true;
