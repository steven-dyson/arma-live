// Desc: Squad Management Dialog
// Features: Group joining, Squad Leader selection, fireteams, statistics
// By: Dr Eyeball
//-----------------------------------------------------------------------------
#include "armaGameVer.sqh"
#include "defineDIKCodes.sqh"
#include "common.sqh"
//-----------------------------------------------------------------------------
#define QUOTEME(x) #x
#define _c_joinTimeLimit 8
#define _c_recruitTimeLimit 1 // needed?
#define _c_requestToJoinTimeLimit 60
#define _c_groupSizeLimitMin 4
#define _c_teamLetters ["A", "B", "C"]

#define _c_reset_all 0
#define _c_reset_SL 1
#define _c_reset_TL 2
#define _c_reset_team 3

#define _c_gridCol_data 0
#define _c_gridCol_vehicle 0
#define _c_gridCol_seat 1
#define _c_gridCol_rank 2
#define _c_gridCol_kit 3
#define _c_gridCol_team 4
#define _c_gridCol_name 5
//----------------------
ICE_sqdMgt_keyDown = compile preprocessFileLineNumbers _c_basePath(keyDown.sqf);
ICE_sqdMgt_getGroupDesc = compile preprocessFileLineNumbers _c_basePath(fn_getGroupDesc.sqf);
ICE_sqdMgt_sortGroups = compile preprocessFileLineNumbers _c_basePath(fn_sortGroups.sqf);
call compile preprocessFileLineNumbers _c_basePath(fnc_broadcast.sqf);
//----------------------
ICE_sqdMgt_allUnitsPlusDead =
{
	if (isNil "ICE_allUnitsPlusDead") then
	{
		private ["_units", "_remove"];

		_units = (allUnits+allDead); // Warning: allDead includes deleted vehicles, not just people.
		_remove = [];

		{
			if (!(_x isKindOf "Man")) then
			{
				_remove set [count _remove, _x];
			};
		} forEach _units;

		if (count _remove > 0) then
		{
			_units = _units - _remove;
			
			//{_remove set [_forEachIndex, typeOf _x]} forEach _remove; // convert objects list to types list.
			//diag_log format ["ICE_sqdMgt_allUnitsPlusDead: Info: found %1 invalid 'man' units: %2", count _remove, _remove];
		};
		
		_units
	}
	else
	{
		call ICE_allUnitsPlusDead
	}
};
//-----------------------------------------------------------------------------
// Variables
//-----------------------------------------------------------------------------
// Global: All variables in this block are global variables to be optionally pre-initialised externally prior to using SqdMgt system.
// TODO: convert these to parameters.
if (isNil "ICE_sqdMgt_groupSizeDefault") then
{
	ICE_sqdMgt_groupSizeDefault = 6;
};
if (isNil "ICE_sqdMgt_groupSizeMax") then
{
	ICE_sqdMgt_groupSizeMax = 13;
	if (count (call ICE_sqdMgt_allUnitsPlusDead) > 36) then {ICE_sqdMgt_groupSizeMax = 13};
	if (count (call ICE_sqdMgt_allUnitsPlusDead) > 60) then {ICE_sqdMgt_groupSizeMax = 13};
};
// ICE_sqdMgt_keys is also global.

// Local: All variables in this block are local to SqdMgt system. They are set based on optional paramaters passed into ICE_sqdMgt_create
ICE_sqdMgt_showSquadHUDOnJoin = false;
ICE_sqdMgt_DeleteRemovedAI = false;
ICE_sqdMgt_AllowAILeaderSelect = false;
ICE_sqdMgt_AllowAIRecruitment = false;
ICE_sqdMgt_AllowPlayerInvites = false;
ICE_sqdMgt_AllowPlayerRecruitment = false;
ICE_sqdMgt_ShowAIGroups = false;
ICE_sqdMgt_showRank = false;
ICE_sqdMgt_QueryJoinAcceptance = true;
ICE_sqdMgt_QuerySLAcceptance = false;
ICE_sqdMgt_AnySquadMemberCanOrganise = false;
ICE_sqdMgt_EnableCommanderSelection = false;
ICE_sqdMgt_SetRankForSL = true;

// Local: All variables in this block are local to SqdMgt system. No external setting of values should be done.
ICE_sqdMgt_redraw_id = 0;
ICE_sqdMgt_editGroupName_group = grpNull;
ICE_sqdMgt_lastGroupsListToSort = [];
ICE_sqdMgt_lastSortedGroupsList = [];
ICE_sqdMgt_openDlgTime = time;
ICE_sqdMgt_currGridIDC = -1;
ICE_sqdMgt_currGridIndex = -1;
ICE_sqdMgt_currPageRow = 0;
ICE_sqdMgt_maxPageRow = 0;
ICE_sqdMgt_lastJoinOrRecruitTime = -_c_joinTimeLimit; // allow it to work at time==0
ICE_sqdMgt_lastRequestToJoinTime = -_c_requestToJoinTimeLimit; // allow it to work at time==0
ICE_sqdMgt_hidePopup_lastRow = -2;
ICE_sqdMgt_groupToSendJoinRequestTo = grpNull;
//-----------------------------------------------------------------------------
/* TODO: unused, finish replacing relevant code
// Desc: get name of squad, catering for no name, local name and public name.
ICE_sqdMgt_getSquadName =
{
	private ['_squadName', '_group', '_localGroupName', '_customGroupName'];

	_group = _this;

	if (isNull _group || isNil "_group") then
	{
		_group = grpNull;
		diag_log [__FILE__, "Error: invalid group param"];
	};
	_squadName = str _group;

	_localGroupName = _group getVariable ["ICE_sqdMgt_localSquadName", ""];
	if (_localGroupName != "") then {_squadName = _squadName + " ["+_localGroupName+"]"};

	_customGroupName = _group getVariable ["ICE_sqdMgt_squadName", ""];
	if (_customGroupName != "") then {_squadName = _squadName + ' "'+_customGroupName+'"'};

	_squadName
};
*/
//-----------------------------------------------------------------------------
// Desc: get the IDC of a GUI control
ICE_sqdMgt_getControlIDC =
{
	private['_control', '_count', '_i'];
	_control = toArray str _this; // Param: _this = control. str = "CONTROL #905"
	_count = count _control - 9;

	for "_i" from 0 to (_count-1) do
	{
		_control set [_i, _control select (9 + _i)];
	};

	_control resize _count;
	parseNumber toString _control
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_groupMsg =
{
	if (player in ((_this select 0) call ICE_sqdMgt_units)) then
	{
		(_this select 1) call ICE_sqdMgt_msg;
	};
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_msg =
{
	if (isNil "ICE_msg") then
	{
		hintSilent _this;
	}
	else
	{
		_this call ICE_msg;
	};
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_formattedGroupMsg =
{
	private ["_caller", "_msg", "_broadcast"];

	_caller = _this select 0;
	_msg = _this select 1;
	_broadcast = if (count _this > 2) then {_this select 2} else {true};

#define _c_ST_color_highlight "<t color='#f07EB27E'>"
#define _c_ST_text_normal "</t>"
	_msg = format [_msg, 
		_c_ST_color_highlight, // %1
		_c_ST_text_normal, // %2
		_c_color_fireteamA_hex, // %3
		_c_color_fireteamB_hex, // %4
		_c_color_fireteamC_hex // %5
	];
	if (_broadcast) then
	{
		// this version does broadcast the msg to all clients in group
		["c",
			{_this call ICE_sqdMgt_groupMsg},
			[_caller, _msg]
		] call ICE_sqdMgt_broadcast;
		//[nil, nil, rCallVar, [_caller, _msg], "ICE_sqdMgt_groupMsg"] call RE;
	}
	else
	{
		_msg = format [_msg, "", "", "", "", ""];
		[_caller, _msg] call ICE_sqdMgt_groupMsg;
	};
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_getParamIndex =
{
  // Desc: Get index of named param in array
  // Result: integer index
  //-----------------------------------------------------------------------------
  private ["_result","_paramName","_nestedArray","_paramIndex","_i","_record"];

  _paramName = _this select 0;
  _nestedArray = _this select 1; // nested array. inside array can contain 1..n fields and can also be a non-array
  _paramIndex = 0; if (count _this > 2) then {_paramIndex = _this select 2}; // specify which field index to compare with

  _result = -1;
  if (typeName _paramName == "ARRAY") exitWith {_result};
  if (typeName _nestedArray != "ARRAY") exitWith {_result};
  if (_paramIndex < 0) exitWith {_result};

  _i = 0;
  {
    _record = _x;
    if (typeName _record == "ARRAY") then
    {
      if (count _record > _paramIndex) then
      {
        if (typeName(_record select _paramIndex) == typeName _paramName) then
        {
          if ((_record select _paramIndex) == _paramName) exitWith
          {
            _result = _i;
          };
        };
      };
    };
    _i = _i + 1;
  } forEach _nestedArray;

  _result;
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_getParam =
{
  // Desc: Get variable (any type) of named param in array
  // Result: any
  //-----------------------------------------------------------------------------
  // _nestedArray = [ ["Item1", [1,[a,b],3]], ["Item2", "hello"] ]
  private ["_result", "_paramName", "_nestedArray", "_default", "_paramIndex", "_resultIndex", "_index", "_record"];

  // params
  _paramName = _this select 0;
  _nestedArray = _this select 1;
  _default = _this select 2;
  _paramIndex = 0; if (count _this > 3) then {_paramIndex = _this select 3}; // specify which field index to compare with
  _resultIndex = 1; if (count _this > 4) then {_resultIndex = _this select 4}; // specify which field index to return

  _result = _default;
  _index = [_paramName, _nestedArray, _paramIndex] call ICE_sqdMgt_getParamIndex;
  if (_index >= 0) then
  {
    _record = _nestedArray select _index;
    if (count _record > _resultIndex) then
    {
      _result = _record select _resultIndex;
    };
  };

  _result;
};
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Control functions
//-----------------------------------------------------------------------------
ICE_sqdMgt_GetGridIdc =
{
	private ['_result', '_gridId', '_ctrlIDC'];
  _gridId = _this select 0;
  _ctrlIDC = _this select 1;

	_result = _c_IDC_BaseValue+(_gridId*10)+_ctrlIDC;
	_result
};
//-----------------------------------------------------------------------------
// Player Stats functions
//-----------------------------------------------------------------------------
/*
ICE_sqdMgt_GetPlayerIndex =
{
  private ["_id"];
  _id = _this select 0;

  if (_id < 0)
  then { "" }
  else { format ["%1", _id] };
  // can't find a reliable command to return the true group position id, similar to the "3" in "WEST 1-1-A-3"
};
*/
//----------------------
ICE_sqdMgt_GetRank =
{
  private ["_rank","_unit"];
  _unit = _this select 0;

  _rank = rank _unit;

  switch toUpper _rank do
  {
    case "PRIVATE": { _rank = localize "STR_ICE_sqdMgt_26" };
    case "CORPORAL": { _rank = localize "STR_ICE_sqdMgt_27" };
    case "SERGEANT": { _rank = localize "STR_ICE_sqdMgt_28" };
    case "LIEUTENANT": { _rank = localize "STR_ICE_sqdMgt_29" };
    case "CAPTAIN": { _rank = localize "STR_ICE_sqdMgt_30" };
    case "MAJOR": { _rank = localize "STR_ICE_sqdMgt_31" };
    case "COLONEL": { _rank = localize "STR_ICE_sqdMgt_32" };
  };

  _rank;
};
//----------------------
ICE_sqdMgt_GetPlayerName =
{
  private ["_name","_unit","_rank"];
  _unit = _this select 0;
  _name = name _unit;
  _rank = if (ICE_sqdMgt_showRank) then {([_unit] call ICE_sqdMgt_GetRank+". ")} else {""};
  _name = _rank+_name;
  if (!alive _unit) then
	{
		_name = format [ "--%1-- %2", /* "Dead" */ localize "STR_ICE_sqdMgt_34", _unit call ICE_sqdMgt_safeName];
	};
  if (not isPlayer _unit) then
	{
		_name = format ["(%1) %2", localize "STR_ICE_sqdMgt_33b", _name];
	};

  _name;
};
//----------------------
ICE_sqdMgt_IsVehicle =
{
  private ["_obj"];
  _obj = _this select 0;
  if ((_obj isKindOf "LandVehicle") OR (_obj isKindOf "Air") OR (_obj isKindOf "Ship"))
  then { true }
  else { false };
};
//----------------------
ICE_sqdMgt_GetVehicleSeat =
{
  private ["_seat","_iconPath","_icon","_vehicle","_unit"];
  _unit = _this select 0;

  _seat = [];
  if (_unit isKindOf "man") then
  {
    _vehicle = vehicle _unit;
    if ([_vehicle] call ICE_sqdMgt_IsVehicle) then
    {
#ifdef __ICE_armaGameVer2
			_iconPath = "\CA\ui\data\i_%1_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
			_iconPath = "\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_%1_ca.paa";
#endif
			_icon = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");

      if (_unit == driver _vehicle) then
      {
        if (_vehicle isKindOf "Air")
        then { _seat = [["", "Pilot", format [_iconPath, "driver"], _icon]] }
        else { _seat = [["", "Driver", format [_iconPath, "driver"], _icon]] };
      };
      // TODO: Can you use new 1.05 assignedVehicleRole command here?
      if (_unit == gunner _vehicle) then { _seat = [["", "Gunner", format [_iconPath, "gunner"], _icon]] };
      if (_unit == commander _vehicle) then { _seat = [["", "Cmdr", format [_iconPath, "commander"], _icon]] };
      if (count _seat == 0 && _unit in _vehicle) then { _seat = [["", "Cargo", format [_iconPath, "cargo"], _icon]] };
    };
  };

  //['SquadManagementDialog.sqf', format ["_seat=%1:%2", _unit, _seat]] call ICE_log;
  _seat
};
//----------------------
ICE_sqdMgt_getShortDisplayName =
{
	private ["_role","_ObjType","_class"];
  _ObjType = _this select 0;

	_role = getText(configFile >> "cfgVehicles" >> _ObjType >> "displayName");
	if (_role == "") then {_role = getText(configFile >> "cfgWeapons" >> _ObjType >> "displayName");};
	if (_role == "") then {_role = _ObjType};

  _role
};
//----------------------
ICE_sqdMgt_grid_onLBSelChanged =
{
	private ["_idc2"];
  //_ctrl = _this select 0;
	
	_idc2 = (_this select 0) call ICE_sqdMgt_getControlIDC;

	if (ICE_sqdMgt_currGridIDC >= 0) then // relevant when using _idc2?
	{
		if (lnbCurSelRow _idc2 >= 0) then
		{
			ICE_sqdMgt_currGridIndex = lnbCurSelRow _idc2;
		};
		//player groupChat str [ICE_sqdMgt_currGridIDC, ICE_sqdMgt_currGridIndex, lnbCurSelRow _idc2]; // debug
	};

	// hide popup menu
	//_idc2 = (_this select 0) call ICE_sqdMgt_getControlIDC;
	if (lnbCurSelRow _idc2 != ICE_sqdMgt_hidePopup_lastRow) then
	{
		{
			(_x call ICE_sqdMgt_getControl) ctrlShow false;
		} forEach _c_IDC_AllMenuButtons;

		ICE_sqdMgt_hidePopup_lastRow = lnbCurSelRow _idc2;
	};
	
	// show unit info
	private ["_unit", "_seatInfo", "_vehicleIcon", "_text", "_kitRecord", "_kitIcon"];
  _unit = [lnbData [_idc2, [lnbCurSelRow _idc2, _c_gridCol_data]]] call ICE_sqdMgt_FindAIOrPlayerByName;
	if (isNull _unit) then
	{
		(_c_IDC_unitInfo call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText "";
	}
	else
	{
		_seatInfo = [_unit] call ICE_sqdMgt_GetVehicleSeat;

		// vehicle icon
		_vehicleIcon = "";
		_vehicleType = "";
		if (vehicle _unit != _unit) then // is in a vehicle
		{
			_vehicleType = typeOf vehicle _unit;
			_vehicleIcon = getText (configFile >> "cfgVehicles" >> _vehicleType >> "picture");
		};
		
		_kitRecord = _unit call ICE_sqdMgt_getKitInfo;
		_kitIcon = _kitRecord select 0;

		#define _c_colorST_OA_text "#FFE0D8A1" // A2 OA pale/pastel yellow text
		#define _c_getWeaponDisplayName(_CLASS) getText(configFile >> "cfgWeapons" >> (_CLASS) >> "displayName")
		#define _c_getWeaponPicture(_CLASS) getText(configFile >> "cfgWeapons" >> (_CLASS) >> "picture")

		_text = format [
			"<img image='%1' size='4.0'/> <t size='1.1' color='%8'>%7</t>  <img image='%9' size='3.0'/> <t size='1.0'>%5</t>  <img image='%10' size='3.0'/> <t size='1.0'>%6</t>  <t size='0.8' color='%8'>%2</t>", // <t size='0.8'>%4</t> <img image='%3' size='3.0'/> 
			_vehicleIcon,
			if (_vehicleType == "") then {""} else {format ["(%1)", [_vehicleType] call ICE_sqdMgt_getShortDisplayName]},
			_kitIcon,
			if (_kitRecord select 1 == "") then {""} else {format ["(%1)", _kitRecord select 1]},
			_c_getWeaponDisplayName(primaryWeapon _unit),
			_c_getWeaponDisplayName(secondaryWeapon _unit),
			_unit call ICE_sqdMgt_safeName,
			_c_colorST_OA_text,
			_c_getWeaponPicture(primaryWeapon _unit),
			_c_getWeaponPicture(secondaryWeapon _unit)
			];
		(_c_IDC_unitInfo call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText _text;
	};
};
//----------------------
ICE_sqdMgt_grid_onSetFocus =
{
	private ['_idc'];
  //_ctrl = _this select 0;
	
	_idc = (_this select 0) call ICE_sqdMgt_getControlIDC;
	ICE_sqdMgt_currGridIDC = _idc;
	//player groupChat str [ICE_sqdMgt_currGridIDC, ICE_sqdMgt_currGridIndex]; // debug
};
//----------------------
ICE_sqdMgt_grid_onKillFocus =
{
	private ["_idc"];
  //_ctrl = _this select 0;
	
	_idc = (_this select 0) call ICE_sqdMgt_getControlIDC;
	lnbSetCurSelRow [_idc, -1];
	//ICE_sqdMgt_currGridIDC = -1;
	//ICE_sqdMgt_currGridIndex = -1;
	//player globalChat str [ICE_sqdMgt_currGridIDC, ICE_sqdMgt_currGridIndex];
};
//----------------------
// save squadName from editBox
ICE_sqdMgt_squadName_onKillFocus =
{
	private ["_group", "_groupName", "_array"];
  //_ctrl = _this select 0;
	
	_group = ICE_sqdMgt_editGroupName_group;
	ICE_sqdMgt_editGroupName_group = grpNull;

	_groupName = ctrlText _c_IDC_messageBoxEditBox;
	_array = toArray _groupName;
	if (count _array > 16) then {_array resize 16};
	_groupName = toString _array;
	// TODO: remove swear words

	call ICE_sqdMgt_hideOkDialog;

	if (!isNull _group) then
	{
		if (leader _group == player) then
		{
			_group setVariable ["ICE_sqdMgt_squadName", _groupName, true]; // broadcast
			_group setVariable ["ICE_sqdMgt_localSquadName", "", false]; // local only
		}
		else
		{
			_group setVariable ["ICE_sqdMgt_localSquadName", _groupName, false]; // local only
		};	
	};
	call ICE_sqdMgt_notifyRefresh;
};
//----------------------
// Requirement: ICE_sqdMgt_JoinGroup must now be broadcast on every client.
ICE_sqdMgt_JoinGroup =
{
	private ['_unit', '_group', '_oldGroup'];
  _unit = _this select 0;
  _group = _this select 1;
	_oldGroup = _this select 2;
	//_oldGroup = group _unit; // can't use, sometimes new group is preassigned.
	
	if (player in (units _oldGroup)) then
	{
		// "%1 has left your group"
		[leader _group, 
			format ["%1 %2 (%3)", ("%1"+(name _unit)+"%2"), localize "STR_ICE_sqdMgt_40", _oldGroup], 
			false] call ICE_sqdMgt_formattedGroupMsg;
	};
	
	// TODO: notify default SL of his new role.
	/*
	(group _unit) spawn
	{
		if (player in units _oldGroup) then
		{
			sleep 5; // wait for join to register
			[leader _this, "You are now the new Squad Leader, by default.", false] call ICE_sqdMgt_formattedGroupMsg;
		};
	};
	*/

	// in MP, there may be a slight delay before it registers you in new group
	//if (local _unit) then {[_unit] joinSilent _group}; // unreliable unless broadcast.
	[_unit] joinSilent _group; 
	//_group addGroupIcon ["b_inf", [0, 0]];

	if (_unit == player) then
	{
		if (ICE_sqdMgt_showSquadHUDOnJoin) then
		{
			ICE_squadHUD_timeout = 0; //time+915;
			ICE_squadHUD_show = true;
		};
	};

	[_unit, _group, _oldGroup] spawn
	{
		private ['_unit', '_group', '_oldGroup', '_t'];
		_unit = _this select 0;
		_group = _this select 1;
		_oldGroup = _this select 2;

		_t = time+5;
		waitUntil {sleep 0.3; time > _t || _unit in (units _group)}; // wait for new group to be recognised or timeout

		// TODO: verify this is not a double draw
		[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons

		if (player in (units _group)) then
		{
			// "%1 has joined your group"
			[leader _group, 
				format ["%1 %2 (%3)", ("%1"+(name _unit)+"%2"), localize "STR_ICE_sqdMgt_41", _group], 
				false] call ICE_sqdMgt_formattedGroupMsg;
		};

		// allow empty group object to be reused. Is this really safe, since all clients don't get synchronised simultaneously?
		//sleep 5;
		if (count (units _oldGroup) == 0) then {deleteGroup _oldGroup};
	};
};
//----------------------
// Broadcast to all clients
ICE_sqdMgt_join_QReply =
{
	private ['_target', '_caller', '_answer', '_oldGroup'];
	_target = _this select 0;
	_caller = _this select 1;
	_answer = _this select 2;

	if (_answer) then
	{
		// execute join on every client, because the engine doesn't always recognise the join on some clients! (Arma2 bug/limitation?)
		//if (local _target) then {[_target] joinSilent (group _caller)}; // unreliable
		_oldGroup = group _target;
		[_target] joinSilent (group _caller);

		if (local _target || local _caller) then // have never determined which one needs to be local, so do both
		{
			// TODO: Since ICE_sqdMgt_join_QReply is already broadcast, the broadcasts in ICE_sqdMgt_JoinGroup could now be removed.
			[_target, group _caller, _oldGroup] call ICE_sqdMgt_JoinGroup;
		};
		// TODO: verify this is not a double draw
		[] call ICE_sqdMgt_DrawPage; // refresh screen
	};
	//_target sideChat (if (_answer) then {"Yes"} else {"No"});
};
//----------------------
// Broadcast to all clients
ICE_sqdMgt_requestToJoin_QReply =
{
	private ['_target', '_caller', '_answer'];
	//_target = _this select 0;
	_caller = _this select 1;
	_answer = _this select 2;

	if (_answer) then
	{
		//ICE_sqdMgt_lastRequestToJoinTime = time;

		[leader ICE_sqdMgt_groupToSendJoinRequestTo, _caller] spawn
		{
			private ['_target', '_caller', '_msg'];
			_target = _this select 0;
			_caller = _this select 1;

			sleep 3; // delay to allow double Query queue to process in SP. Not sure if it would affect MP though.

#define __ST_color_secondColour "<t color='#f0E2D8A5'>"
#define __ST_text_normal "</t>"
			_msg = format ["%2%1%3 has requested to join your squad. Do you accept?", 
				_caller call ICE_sqdMgt_safeName, __ST_color_secondColour, __ST_text_normal];
			// reverse _target & _caller params to use new query destination.
			[_target, _caller, _msg, {_this call ICE_sqdMgt_respondToRequestToJoin_QReply}] spawn ICE_questionHUD_sendQ;
		};
		
		ICE_sqdMgt_groupToSendJoinRequestTo = grpNull;
	};
};
//----------------------
// Broadcast to all clients
ICE_sqdMgt_respondToRequestToJoin_QReply =
{
	private ['_target', '_caller', '_answer'];
	_target = _this select 0;
	_caller = _this select 1;
	_answer = _this select 2;
	
	/* remove for now, since a No answer may encourage an immeidate request again.
	if (player == _caller && !_answer) then
	{
		// reset timer immediately upon response.
		ICE_sqdMgt_lastRequestToJoinTime = time-_c_requestToJoinTimeLimit;
	};
	*/

	if (_answer) then
	{
		// reverse _target & _caller params to reuse same join function.
		[_caller, _target, _answer] call ICE_sqdMgt_join_QReply;
	}
	else
	{
		if (player == _caller) then
		{
			"Sorry, you cannot join right now." call ICE_sqdMgt_msg;
		};
	};
};
//----------------------
ICE_sqdMgt_InviteAIOrPlayerIntoGroup =
{
  private ["_unit","_unitToFind","_UnitList","_CheckIfPlayerMatches","_msg"];
  _unitToFind = _this select 0;
  _UnitList = call ICE_sqdMgt_allUnitsPlusDead; //_this select 1;

	if (time < ICE_sqdMgt_lastJoinOrRecruitTime+_c_recruitTimeLimit) exitWith
	{
		[format ["You may only recruit every %1 seconds.<br/><br/>(%2s remain).", 
			_c_recruitTimeLimit, 
			ceil (_c_recruitTimeLimit-(time - ICE_sqdMgt_lastJoinOrRecruitTime))]
		] call ICE_sqdMgt_okDialog;
	};
	ICE_sqdMgt_lastJoinOrRecruitTime = time;
	
  _CheckIfPlayerMatches =
  {
    private ["_groupIsEntirelyAI","_unit","_unitToFind"];
    _unit = _this select 0;
    _unitToFind = _this select 1;

    if (_unit == _unitToFind) then
    {
      if (isPlayer _unit) then
      {
        // "Player %2 was invited into your group."
        // (or "Invitation was sent to %2 to join your group.")
        [(leader player), format ["%1 %2 %3.",
          localize "STR_ICE_sqdMgt_44",
          ("%1"+(name _unit)+"%2"),
          localize "STR_ICE_sqdMgt_61"
        ]] call ICE_sqdMgt_formattedGroupMsg;

        // "%1, you have been invited to join group: %3 (%4)"
				_msg = format ["%1, %2: %3 (%4).",
          name _unit,
          localize "STR_ICE_sqdMgt_63",
          name player,
          group player
        ];

				if (ICE_sqdMgt_QueryJoinAcceptance && !isNil "ICE_questionHUD_sendQ") then
				{
					[_unit, player, _msg, {_this call ICE_sqdMgt_join_QReply}] spawn ICE_questionHUD_sendQ;
				}
				else
				{
					["c",
						{_this call ICE_sqdMgt_join_QReply},
						[_unit, player, true]
					] call ICE_sqdMgt_broadcast;
					//[nil, nil, rCallVar, [_unit, player, true], "ICE_sqdMgt_join_QReply"] call RE;
				};
      }
      else
      {
        _groupIsEntirelyAI = true;
        {
          if (isPlayer _x) then { _groupIsEntirelyAI = false };
        } forEach (units _unit);

        // TODO: if player is greater than a certain distance, then don't allow
        // TODO: if group size is greater than a certain count or some ratio to total human players, then don't allow
        // DEV: TODO: This code needs completion to restrict how many AI can be recruited.

        // if AI is part of a human group, then don't allow leaching
        if (_groupIsEntirelyAI) then
        {
          // "A.I. %2 soldier was recruited into group."
          [(leader player), format ["%1 %2 %3.",
            localize "STR_ICE_sqdMgt_33",
            ("%1"+([typeOf _unit] call ICE_sqdMgt_getShortDisplayName)+"%2"),
            localize "STR_ICE_sqdMgt_62"
          ]] call ICE_sqdMgt_formattedGroupMsg;

// [ temp test code:
					// "%1, you have been invited to join group: %3 (%4)"
					_msg = format ["%1, %2: %3 (%4).",
						name _unit,
						localize "STR_ICE_sqdMgt_63",
						name player,
						group player
					];

					/*
					if (ICE_sqdMgt_QueryJoinAcceptance && !isNil "ICE_questionHUD_sendQ") then
					{
						[_unit, player, _msg, {_this call ICE_sqdMgt_join_QReply}] spawn ICE_questionHUD_sendQ;
					}
					else
					{
					*/
						["c",
							{_this call ICE_sqdMgt_join_QReply},
							[_unit, player, true]
						] call ICE_sqdMgt_broadcast;
						//[nil, nil, rCallVar, [_unit, player, true], "ICE_sqdMgt_join_QReply"] call RE;
					/*
					};
					*/
// ] end temp test code

          //if (local _unit) then {[_unit] joinSilent group player};
          //[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
        };
      };
    };
  };

  {
    _unit = _x;
    if ([_unit] call ICE_sqdMgt_IsVehicle) then
    {
      // process vehicle crew list
      {
        [_x, _unitToFind] call _CheckIfPlayerMatches;
      } forEach crew _unit;
    }
    else
    {
      [_unit, _unitToFind] call _CheckIfPlayerMatches;
    };
  } forEach _UnitList;
};
//----------------------
// Broadcast to all clients
ICE_sqdMgt_setSL_QReply =
{
	private ['_target', '_caller', '_answer'];
	_target = _this select 0;
	_caller = _this select 1;
	_answer = _this select 2;

	if (_answer) then
	{
		if (local _target || local _caller) then // have never determined which one needs to be local, so do both
		{
			if (ICE_sqdMgt_SetRankForSL) then
			{
				_target setVariable ["ICE_sqdMgt_squadLeader", true, true]; // set, broadcast
				{
					if (_x getVariable ["ICE_sqdMgt_squadLeader", false]) then
					{
						_x setVariable ["ICE_sqdMgt_squadLeader", false, true]; // unset, broadcast
					};
					// set lower rank to prevent Arma reverting new SL due to rank.
					if (rank _x != "CORPORAL") then
					{
						_x setRank "CORPORAL";
					};
				} forEach (units _target);

				_target setRank "COLONEL";
			};
			(group _caller) selectLeader _target;
		};
		[] call ICE_sqdMgt_DrawPage; // refresh screen
	};
	//_target sideChat (if (_answer) then {"Yes"} else {"No"});

	if (player in ((group _target) call ICE_sqdMgt_units)) then
	{
		// "Your new Squad Leader is %2. %3 has resigned"
		[_target, format ["%1 %2. %3 %4.",
			localize "STR_ICE_sqdMgt_42",
			("%1"+(name _target)+"%2"),
			name _caller,
			localize "STR_ICE_sqdMgt_43"
		], false] call ICE_sqdMgt_formattedGroupMsg;
	};
};
//----------------------
ICE_sqdMgt_SetNewSquadLeader =
{
  private ["_unit","_unitToFind","_UnitList","_CheckIfPlayerMatches"];
  _unitToFind = _this select 0;
  _UnitList = call ICE_sqdMgt_allUnitsPlusDead; //_this select 1;

  _CheckIfPlayerMatches =
  {
    private ["_unit","_unitToFind"];
		_unit = _this select 0;
		_unitToFind = _this select 1;

    if (_unit == _unitToFind) then
    {
			// "%2 was sent request to become the new squad leader."
			[(leader player), 
				format [localize "STR_ICE_sqdMgt_68",
				("%1"+(name _unit)+"%2")
			]] call ICE_sqdMgt_formattedGroupMsg;

			// "Do you accept the request to become the new squad leader of your group?"
			_msg = format [localize "STR_ICE_sqdMgt_69"];

			if (ICE_sqdMgt_QuerySLAcceptance && !isNil "ICE_questionHUD_sendQ") then
			{
				[_unit, player, _msg, {_this call ICE_sqdMgt_setSL_QReply}] spawn ICE_questionHUD_sendQ;
			}
			else
			{
				["c",
					{_this call ICE_sqdMgt_setSL_QReply},
					[_unit, player, true]
				] call ICE_sqdMgt_broadcast;
				//[nil, nil, rCallVar, [_unit, player, true], "ICE_sqdMgt_setSL_QReply"] call RE;
			};

      //[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
    };
  };

  {
    _unit = _x;
    if (group _unit == group player) then
    {
      if ([_unit] call ICE_sqdMgt_IsVehicle) then
      {
        // process vehicle crew list
        {
          [_x, _unitToFind] call _CheckIfPlayerMatches;
        } forEach crew _unit;
      }
      else
      {
        [_unit, _unitToFind] call _CheckIfPlayerMatches;
      };
    };
  } forEach _UnitList;
};
//----------------------
ICE_sqdMgt_joinSilent_grpNull =
{
	if (local _this) then {[_this] joinSilent grpNull};
};
//----------------------
ICE_sqdMgt_RemoveAIOrPlayerFromYourGroup =
{
  private ["_unit","_unitToFind","_CheckIfPlayerMatches"];
  _unitToFind = _this select 0;

  _CheckIfPlayerMatches =
  {
    private ["_unit","_unitToFind"];
    _unit = _this select 0;
    _unitToFind = _this select 1;

    if (_unit == _unitToFind) then
    {
      if (isPlayer _unit) then
      {
        // "Player %2 was kicked from the group."
        [(leader player), format ["%1 %2 %3.",
          localize "STR_ICE_sqdMgt_44",
          ("%1"+(name _unit)+"%2"),
          localize "STR_ICE_sqdMgt_45"]] call ICE_sqdMgt_formattedGroupMsg;
      }
      else
      {
        // "A.I. %2 soldier was removed from group."
        [(leader player), format ["%1 %2 %3.",
          localize "STR_ICE_sqdMgt_33",
          ("%1"+([typeOf _unit] call ICE_sqdMgt_getShortDisplayName)+"%2"),
          localize "STR_ICE_sqdMgt_46"]] call ICE_sqdMgt_formattedGroupMsg;

        // When deleted, it assumes the AI player was spawned and is replacable.
        if (ICE_sqdMgt_DeleteRemovedAI) then
        {
          deleteVehicle _unit;
        };
      };
			/* not needed.
      _unit call ICE_sqdMgt_joinSilent_grpNull;
			*/
			["cs",
				{_this call ICE_sqdMgt_joinSilent_grpNull},
				_unit
			] call ICE_sqdMgt_broadcast;
			//[_unit, _unit, "loc", rCallVar, _unit, "ICE_sqdMgt_joinSilent_grpNull"] call RE;

      //[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
			call ICE_sqdMgt_notifyRefresh;
    };
  };

  {
    _unit = _x;
    if (group _unit == group player) then
    {
      if ([_unit] call ICE_sqdMgt_IsVehicle) then
      {
        // process vehicle crew list
        {
          [_x, _unitToFind] call _CheckIfPlayerMatches;
        } forEach crew _unit;
      }
      else
      {
        [_unit, _unitToFind] call _CheckIfPlayerMatches;
      };
    };
  } forEach (units player);
};
//----------------------
ICE_sqdMgt_FindAIOrPlayerByName =
{
	private ['_unitToFind', '_result'];
  _unitToFind = _this select 0;
	_result = objNull;

  {
		if (format ["%1", _x] == _unitToFind) exitWith
		{
			_result = _x;
		};
  } forEach call ICE_sqdMgt_allUnitsPlusDead;
	_result
};
//----------------------
ICE_sqdMgt_LeaveGroup =
{
	private ["_origGroup"];

	_origGroup = group player;

	// it can be 1 if ICE_sqdMgt_squadLeader was true (above)
	if (count (units player) > 1) then
	{
		//"%1 has left your group"
		[(leader player), 
			format ["%1 %2", ("%1"+(name player)+"%2"), localize "STR_ICE_sqdMgt_40"]
			] call ICE_sqdMgt_formattedGroupMsg;
		/* not needed.
		player call ICE_sqdMgt_joinSilent_grpNull;
		*/
		["cs",
			{_this call ICE_sqdMgt_joinSilent_grpNull},
			player
		] call ICE_sqdMgt_broadcast;
		//[player, player, "loc", rCallVar, player, "ICE_sqdMgt_joinSilent_grpNull"] call RE;

		[player, _c_reset_all] call ICE_sqdMgt_resetPlayerSquadVariables;
	};
	[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons

	_origGroup spawn
	{
		private ['_origGroup', '_t'];
		_origGroup = _this;

		_t = time+1;
		waitUntil {sleep 0.3; time > _t || group player != _origGroup}; // wait for new group to be recognised or timeout
		sleep 0.2;
		[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons

		_t = time+4;
		waitUntil {sleep 0.3; time > _t || group player != _origGroup}; // wait for new group to be recognised or timeout
		sleep 0.2;
		[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
	};
};
//----------------------
ICE_sqdMgt_NewGroup =
{
	if (time < ICE_sqdMgt_lastJoinOrRecruitTime+_c_joinTimeLimit) exitWith
	{
		[format ["You may only switch teams every %1 seconds.<br/><br/>(%2s remain).", 
			_c_joinTimeLimit, 
			ceil (_c_joinTimeLimit-(time - ICE_sqdMgt_lastJoinOrRecruitTime))]
		] call ICE_sqdMgt_okDialog;
	};
	ICE_sqdMgt_lastJoinOrRecruitTime = time;
	
	call ICE_sqdMgt_LeaveGroup;
	if (ICE_sqdMgt_showSquadHUDOnJoin) then
	{
		ICE_squadHUD_timeout = 0; //time+915;
		ICE_squadHUD_show = true;
	};
	player setVariable ["ICE_sqdMgt_squadLeader", true, true]; // set, broadcast
	__ICE_debug_setVar(player, "ICE_sqdMgt_squadLeader");

	//[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
	call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_safeName =
{
	if (isNil "ICE_fn_safeName") then
	{
		name _this
	}
	else
	{
		_this call ICE_fn_safeName
	}
};
//----------------------
ICE_sqdMgt_sideChat =
{
	if (isNil "ICE_sideChat") then
	{
		(_this select 0) sideChat (_this select 1);
	}
	else
	{
		_this call ICE_sideChat;
	};
};
//----------------------
ICE_sqdMgt_setCommander =
{
	if (isNil "ICE_BFT_setCommander") exitWith {hintSilent "The BluForTracking & Commander functionality is not enabled.";};

	if (isNull (call ICE_sqdMgt_getCommander)) then
	{
		// keep this block until commander UI is confirmed as completed
		if (!isMultiplayer) then // if SP or Beta
		{
			if (count (units player) == 1 && !(player getVariable ["ICE_sqdMgt_squadLeader", false])) then
			{
				player call ICE_BFT_setCommander;
				[player, format ["New commander is %1.", (call ICE_sqdMgt_getCommander) call ICE_sqdMgt_safeName]] call ICE_sqdMgt_sideChat;
				//[] call ICE_sqdMgt_DrawPage; // refresh screen
				call ICE_sqdMgt_notifyRefresh;
			}
			else
			{
				["You must leave your squad first."] call ICE_sqdMgt_okDialog;
			};
		}
		else
		{
			hintSilent "The commander functionality has been deactivated since it's still being developed.";
		};
	}
	else
	{
		[format ["There is already a commander: ", (call ICE_sqdMgt_getCommander) call ICE_sqdMgt_safeName]] call ICE_sqdMgt_okDialog;
	};
};
//----------------------
ICE_sqdMgt_getCommander =
{
	if (isNil "ICE_BFT_setCommander") exitWith
	{
		//hintSilent "The commander functionality is not available."; 
		objNull
	};

	call ICE_BFT_getCommander
};
//----------------------
ICE_sqdMgt_leaveCommand =
{
	if ((call ICE_sqdMgt_getCommander) == player) then
	{
		playerSide call ICE_sqdMgt_setCommander; // using playerSide will unset commander

		[player, "Commander has stepped down. New commander required."] call ICE_sqdMgt_sideChat;
	};
	//[] call ICE_sqdMgt_DrawPage; // refresh screen
	call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_SetYourselfAsSLForAISL =
{
  private ["_TL_is_AI"];
  _TL_is_AI = (!isPlayer (leader player));

  if (_TL_is_AI) then
  {
    //"You are the new Squad Leader. (AI) %1 has been demoted."
    [(leader player), 
			format ["%1. (%2) %3 %4.",
				localize "STR_ICE_sqdMgt_48", // You are the new Squad Leader
				localize "STR_ICE_sqdMgt_33", // A.I.
				("%1"+(name (leader player))+"%2"),
				localize "STR_ICE_sqdMgt_49"] // has been replaced
		] call ICE_sqdMgt_formattedGroupMsg;

		(group player) selectLeader player;

		[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons
  }
  else
  {
		if (leader player == player) then
		{
			//"You are already the Squad Leader"
			//[(leader player), localize "STR_ICE_sqdMgt_67"] call ICE_sqdMgt_formattedGroupMsg;
			[localize "STR_ICE_sqdMgt_67"] call ICE_sqdMgt_okDialog;
		}
		else
		{
			//"The Squad Leader is no longer an AI player"
			//[(leader player), localize "STR_ICE_sqdMgt_50"] call ICE_sqdMgt_formattedGroupMsg;
			[localize "STR_ICE_sqdMgt_50"] call ICE_sqdMgt_okDialog;
		};
  };
};
//-----------------------------------------------------------------------------
// Cell Grid functions
//-----------------------------------------------------------------------------
ICE_sqdMgt_resetPlayerSquadVariables =
{
	private ["_unit", "_reset", "_wasStartingSL", "_hadTeam", "_wasFTLeader"];
	
	_unit = _this select 0;
	_reset = _this select 1; // 0 means reset all, 1 reset SL, 2 reset TL, 3 reset Team
	
	// reset object var
	if (_reset in [_c_reset_all, _c_reset_SL]) then
	{
		_wasStartingSL = _unit getVariable "ICE_sqdMgt_squadLeader";
		if (!isNil "_wasStartingSL") then
		{
			if (_wasStartingSL) then
			{
				_unit setVariable ["ICE_sqdMgt_squadLeader", false, true]; // reset, broadcast
				__ICE_debug_setVar(_unit, "ICE_sqdMgt_squadLeader");
			};
		};
	};
	
	// reset object var
	if (_reset in [_c_reset_all, _c_reset_TL]) then
	{
		_wasFTLeader = _unit getVariable "ICE_sqdMgt_teamLeader";
		if (!isNil "_wasFTLeader") then
		{
			if (_wasFTLeader) then
			{
				_unit setVariable ["ICE_sqdMgt_teamLeader", false, true]; // reset, broadcast
				__ICE_debug_setVar(_unit, "ICE_sqdMgt_teamLeader");
			};
		};
	};

	// reset object var
	if (_reset in [_c_reset_all, _c_reset_team]) then
	{
		_hadTeam = _unit getVariable "ICE_sqdMgt_team";
		if (!isNil "_hadTeam") then
		{
			if (_hadTeam > 0) then
			{
				_unit setVariable ["ICE_sqdMgt_team", 0, true]; // reset, broadcast
				__ICE_debug_setVar(_unit, "ICE_sqdMgt_team");
			};
		};
	};
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_JoinLeaveGroup =
{
  private ["_wasStartingSL","_hadTeam","_idc2","_playerRef","_group","_minGroupSize",
		"_groupSizeLimit", "_msg", "_reason", "_requestInstructions"];
  //_ctrl = _this select 0;

	_idc2 = (_this select 0) call ICE_sqdMgt_getControlIDC;
	_idc2 = _idc2-_c_IDC_GridJoinLeaveButton+_c_IDC_Grid;
  _playerRef = [lnbData [_idc2, [0, _c_gridCol_data]]] call ICE_sqdMgt_FindAIOrPlayerByName; // use first player in list
	// Note: _playerRef is not the 'joining' player, only the new group reference player.

  _group = group _playerRef;
	if (isNull _group) exitWith {
		["No group selected. Try refreshing."] call ICE_sqdMgt_okDialog;
	};

  _minGroupSize = 4;
  if (playersNumber playerSide <= 30) then {_minGroupSize = 3};
  if (playersNumber playerSide <= 20) then {_minGroupSize = 2};
  if (playersNumber playerSide <= 10) then {_minGroupSize = 1};

	_reason = "";

	if (_group != group player && // if joining, i.e. not leaving
		_group getVariable ["ICE_sqdMgt_lockedGroup", false] &&
		 count units _group >= _minGroupSize) then
	{
		_reason = "Squad is locked.";
	};

	_groupSizeLimit = _group getVariable ["ICE_sqdMgt_groupSizeLimit", ICE_sqdMgt_groupSizeDefault];
	if (_reason == "" &&
		_group != group player && // if joining, i.e. not leaving
		count units _group >= _groupSizeLimit) then
	{
		_reason = "Squad is full.";
	};
	
	if (_reason != "") exitWith
	{
		_requestInstructions = "See query box below to send request to join.";
		if (time < ICE_sqdMgt_lastRequestToJoinTime+_c_requestToJoinTimeLimit) then
		{
			_requestInstructions = format ["Request bypassed. You may only request to join a squad every %1 seconds. (%2s remain).", 
				_c_requestToJoinTimeLimit, 
				ceil (_c_requestToJoinTimeLimit-(time - ICE_sqdMgt_lastRequestToJoinTime))];
		};

		_msg = _reason+" (Try refreshing if not indicated).<br/><br/>"+_requestInstructions;
		[_msg] call ICE_sqdMgt_okDialog;
		//[] call ICE_sqdMgt_DrawPage; // refresh screen to redraw "join group" buttons

		if (time >= ICE_sqdMgt_lastRequestToJoinTime+_c_requestToJoinTimeLimit) then
		{
			ICE_sqdMgt_lastRequestToJoinTime = time;
			if (!isNil "ICE_questionHUD_sendQ") then
			{
				_msg = _reason+" - Do you want to send a request to SL to allow you to join?";
				ICE_sqdMgt_groupToSendJoinRequestTo = _group;
				// player is both the sender and receiver of the question in this case.
				[player, player, _msg, {_this call ICE_sqdMgt_requestToJoin_QReply}] spawn ICE_questionHUD_sendQ;
			};
		};
	};
	//-----------------------------------
	_wasStartingSL = player getVariable ["ICE_sqdMgt_squadLeader", false];
	[player, _c_reset_all] call ICE_sqdMgt_resetPlayerSquadVariables;

	if (player == (call ICE_sqdMgt_getCommander)) exitWith
	{
		["While commander you cannot join a squad."] call ICE_sqdMgt_okDialog;
	};

  if (_group == group player) then // your group
  {
    if (count (units player) > 1 || _wasStartingSL) then // if (you are not in unassigned group || _wasStartingSL)
    {
			// localize "STR__c_xx" /* "Leave" */
      [] call ICE_sqdMgt_LeaveGroup;
			call ICE_sqdMgt_notifyRefresh;
    };
  }
  else
  {
    if (count (units _group) > 0) then
    {
			if (time < ICE_sqdMgt_lastJoinOrRecruitTime+_c_joinTimeLimit) exitWith
			{
				[format ["You may only join teams every %1 seconds.<br/><br/>(%2s remain).", 
					_c_joinTimeLimit, 
					ceil (_c_joinTimeLimit-(time - ICE_sqdMgt_lastJoinOrRecruitTime))]
				] call ICE_sqdMgt_okDialog;
			};
			ICE_sqdMgt_lastJoinOrRecruitTime = time;
	
			// localize "STR_ICE_sqdMgt_52" /* "Join group" */
			// broadcast join on every client because the engine doesn't always recognise the join on some clients! (Arma2 bug/limitation?)
			["cs",
				{_this call ICE_sqdMgt_JoinGroup},
				[player, _group, group player]
			] call ICE_sqdMgt_broadcast;
			//[nil, nil, rCallVar, [player, _group, group player], "ICE_sqdMgt_JoinGroup"] call RE;
    };
  };
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_setGroupName =
{
  private ["_idc2", "_unit", "_group", "_groupName", "_title"];
  //_ctrl = _this select 0;

	_idc2 = (_this select 0) call ICE_sqdMgt_getControlIDC;
	_idc2 = _idc2-_c_IDC_GridNameButton+_c_IDC_Grid;
  _unit = [lnbData [_idc2, [0, _c_gridCol_data]]] call ICE_sqdMgt_FindAIOrPlayerByName; // use first player in list

  _group = group _unit;
	if (isNull _group) exitWith {
		["No group selected. Try refreshing."] call ICE_sqdMgt_okDialog;
	};
	
	ICE_sqdMgt_editGroupName_group = _group;

	if (leader _group == player) then
	{
		_groupName = _group getVariable ["ICE_sqdMgt_squadName", ""];
		_title = "Change squad name/info (public)";
	}
	else
	{
		_groupName = _group getVariable ["ICE_sqdMgt_localSquadName", ""];
		_title = "Change squad name/info (private)";
	};	
	
	ctrlShow [_c_IDC_messageBoxBackground, true];
	ctrlShow [_c_IDC_messageBoxTitle, true];
	ctrlShow [_c_IDC_messageBoxText, false]; // not used here
	ctrlShow [_c_IDC_messageBoxCaption, true];
	ctrlShow [_c_IDC_messageBoxEditBox, true];
	ctrlShow [_c_IDC_messageBoxButton, true];

	ctrlEnable [_c_IDC_messageBoxEditBox, true];

	ctrlSetText [_c_IDC_messageBoxTitle, _title];
	ctrlSetText [_c_IDC_messageBoxCaption, "Name:"];
	ctrlSetText [_c_IDC_messageBoxEditBox, _groupName];
	ctrlSetFocus (_c_IDC_messageBoxEditBox call ICE_sqdMgt_getControl);
	
	hintSilent "The squad name can also include info like:\n- ACRE channel (eg: chan#3)\nSquad purpose (eg: command, infantry, armour, motorized, air, helicopter, etc.)";
};
//----------------------
ICE_sqdMgt_okDialog =
{
  private ["_msg", "_title"];

  _msg = _this select 0;
	_title = if (count _this > 1) then {_this select 1} else {"Message"};

	if (isNull findDisplay _c_SqdMgt_IDD) exitWith
	{
		hintSilent _msg; 
	};
	
	if (!isNil "ICE_fn_convertLFToBR") then
	{
		_msg = _msg call ICE_fn_convertLFToBR;
	};

	ctrlShow [_c_IDC_messageBoxBackground, true];
	ctrlShow [_c_IDC_messageBoxTitle, true];
	ctrlShow [_c_IDC_messageBoxText, true];
	ctrlShow [_c_IDC_messageBoxCaption, false]; // not used here
	ctrlShow [_c_IDC_messageBoxEditBox, false]; // not used here
	ctrlShow [_c_IDC_messageBoxButton, true];

	ctrlEnable [_c_IDC_messageBoxEditBox, false]; // not used here

	ctrlSetText [_c_IDC_messageBoxTitle, _title];
	(_c_IDC_messageBoxText call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText _msg;
	ctrlSetFocus (_c_IDC_messageBoxButton call ICE_sqdMgt_getControl);
};
//----------------------
ICE_sqdMgt_hideOkDialog =
{
	ctrlShow [_c_IDC_messageBoxBackground, false];
	ctrlShow [_c_IDC_messageBoxTitle, false];
	ctrlShow [_c_IDC_messageBoxText, false];
	ctrlShow [_c_IDC_messageBoxCaption, false];
	ctrlShow [_c_IDC_messageBoxEditBox, false];
	ctrlShow [_c_IDC_messageBoxButton, false];
};
//----------------------
ICE_sqdMgt_getGridPlayer =
{
	private ["_unit","_idc2","_index","_data"];

	_unit = objNull;
	_idc2 = ICE_sqdMgt_currGridIDC;
	if (_idc2 < 0) exitWith {_unit};

	_index = ICE_sqdMgt_currGridIndex;
	_data = lnbData [_idc2, [_index, _c_gridCol_data]];
  _unit = [_data] call ICE_sqdMgt_FindAIOrPlayerByName;

	_unit
};
//----------------------
ICE_sqdMgt_setSquadLeader =
{
	private ["_unit","_leaderAndYourGroup"];

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	_leaderAndYourGroup = ((player == leader player) || ICE_sqdMgt_AnySquadMemberCanOrganise) && 
		(group _unit == group player);

	if (group _unit == group player) then
	{
		if (!isPlayer (leader _unit) && leader _unit != player && _unit == player) then // SL is AI
		{
			// localize "STR_ICE_sqdMgt_53" /* "Go SL" */
			[] call ICE_sqdMgt_SetYourselfAsSLForAISL;
		}
		else
		{
			// Setting ICE_sqdMgt_AllowAILeaderSelect to true, will allow AI SL selection, otherwise it will limit to human player restricted leader selection.
			if ((_leaderAndYourGroup || !isPlayer (leader _unit)) && // if curr SL is you or AI
				(ICE_sqdMgt_AllowAILeaderSelect || isPlayer _unit) && // if new SL is AI & AI allowed, or is Person
				(_unit != leader _unit)) then // not you again
			{
				// localize "STR_ICE_sqdMgt_54" /* "New SL" */
				[_unit] call ICE_sqdMgt_SetNewSquadLeader;
			};
		};
	}
	else
	{
		if (group _unit != group player) then
		{
			["You may only change squad leaders for your own group."] call ICE_sqdMgt_okDialog;
		};
		/*
		if (player != leader player) then
		{
			["Only a squad leader can choose a new squad leader."] call ICE_sqdMgt_okDialog;
		};
		*/
	};
};
//----------------------
ICE_sqdMgt_togglePlayerTag =
{
	private ["_unit", "_tagged"];

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	if (group _unit == group player) then
	{
		_tagged = _unit getVariable ["ICE_squadHUD_Tag", false];
		_unit setVariable ["ICE_squadHUD_Tag", !_tagged]; // tag/untag
	};
	[] call ICE_sqdMgt_DrawPage; // refresh screen
};
//----------------------
ICE_sqdMgt_SetTeam =
{
	private ["_team", "_unit"];

	_team = _this select 0;

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	if ((group _unit == group player) && (_unit getVariable ["ICE_sqdMgt_team", 0] != _team)) then
	{
		//_unit setTeam
		_unit setVariable ["ICE_sqdMgt_team", _team, true]; // broadcast
		__ICE_debug_setVar(_unit, "ICE_sqdMgt_team");

		if (_team == 0) then
		{
			[leader player, format ["Squad, %1 is now unassigned from fireteam.", 
				("%1"+(name _unit)+"%2")
			]] call ICE_sqdMgt_formattedGroupMsg;

			[_unit, _c_reset_TL] call ICE_sqdMgt_resetPlayerSquadVariables;
		};
		if (_team > 0 && _team <= count _c_teamLetters) then
		{
			[leader player, format ["Fireteam %1, %2 is now on your team.", 
				((["%1", "%3","%4","%5"] select _team)+((["?"]+_c_teamLetters) select _team)+"%2"),
				("%1"+(name _unit)+"%2")
			]] call ICE_sqdMgt_formattedGroupMsg;

			_teamCount = {_x getVariable ["ICE_sqdMgt_team", 0] == _team} count (units _unit);
			if (_teamCount > 1) then
			{
				[_unit, _c_reset_TL] call ICE_sqdMgt_resetPlayerSquadVariables;
			}
			else
			{
				_unit call ICE_sqdMgt_SetTeamLeaderForPlayer;
			};
		};
	};
	//[] call ICE_sqdMgt_DrawPage; // refresh screen
	call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_SetTeamLeader =
{
	private ["_unit","_leaderAndYourGroup","_youAreTL","_team"];

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	_team = player getVariable ["ICE_sqdMgt_team", 0];
	
	_youAreTL = (_team > 0) && 
		(player getVariable ["ICE_sqdMgt_teamLeader", false]) &&
		(_team == _unit getVariable ["ICE_sqdMgt_team", 0]);

	_leaderAndYourGroup =
		((player == leader player) || _youAreTL || ICE_sqdMgt_AnySquadMemberCanOrganise) && 
		(group _unit == group player);

	if (_leaderAndYourGroup) then
	{
		_unit call ICE_sqdMgt_SetTeamLeaderForPlayer;
	};
	//[] call ICE_sqdMgt_DrawPage; // refresh screen
	call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_SetTeamLeaderForPlayer =
{
	private ["_unit","_team","_team2","_unitIsTL"];

	_unit = _this;
	if (isNull _unit) exitWith {};
	
	_team = _unit getVariable ["ICE_sqdMgt_team", 0];
	_unitIsTL = _unit getVariable ["ICE_sqdMgt_teamLeader", false];

	if ((_team > 0) && !_unitIsTL) then
	{
		_unit setVariable ["ICE_sqdMgt_teamLeader", true, true]; // broadcast
		__ICE_debug_setVar(_unit, "ICE_sqdMgt_teamLeader");

		// check no other FT members are TL's
		{
			_team2 = _x getVariable ["ICE_sqdMgt_team", 0];
			if (_team2 == _team && _x != _unit) then // exclude new TL
			{
				[_x, _c_reset_TL] call ICE_sqdMgt_resetPlayerSquadVariables;
			};
		} forEach (units _unit);

		[leader _unit, format ["Fireteam %1, your new Team Leader is %2.", 
			((["%1", "%3","%4","%5"] select _team)+((["?"]+_c_teamLetters) select _team)+"%2"),
			("%1"+(name _unit)+"%2")
		]] call ICE_sqdMgt_formattedGroupMsg;

		call ICE_sqdMgt_notifyRefresh;
	};
};
//----------------------
ICE_sqdMgt_ToggleLockGroup =
{
	private ["_group", "_lockedGroup", "_minGroupSize"];

	_group = group player;
	_lockedGroup = _group getVariable ["ICE_sqdMgt_lockedGroup", false];
	
  _minGroupSize = 4;
  if (playersNumber playerSide <= 30) then {_minGroupSize = 3};
  if (playersNumber playerSide <= 20) then {_minGroupSize = 2};
  if (playersNumber playerSide <= 10) then {_minGroupSize = 1};

	if (!_lockedGroup && count units player < _minGroupSize) exitWith
	{
		hintSilent format ["You need at least %1 squad members before squad locking is allowed.", _minGroupSize];
	};

	_lockedGroup = !_lockedGroup;
	_group setVariable ["ICE_sqdMgt_lockedGroup", _lockedGroup, true]; // broadcast
	__ICE_debug_setVar(_group, "ICE_sqdMgt_lockedGroup");
	
	format ["Squad is now %1", if (_lockedGroup) then {"locked"} else {"unlocked"}] call ICE_sqdMgt_msg;

	[] call ICE_sqdMgt_DrawPage; // refresh screen (locked status field)
	//call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_ToggleLockFTs =
{
	private ["_group", "_lockedFTs", "_status"];

	_group = group player;
	_lockedFTs = _group getVariable ["ICE_sqdMgt_lockedFTs", false];
	
	_lockedFTs = !_lockedFTs;
	_group setVariable ["ICE_sqdMgt_lockedFTs", _lockedFTs, true]; // broadcast
	__ICE_debug_setVar(_group, "ICE_sqdMgt_lockedFTs");
	
	_status = if (_lockedFTs) then {"locked"} else {"unlocked"};
	format ["Fireteams are now %1", _status] call ICE_sqdMgt_msg;
	[leader _group, format ["The squad leader has %1 the fireteams. When FT's are locked, players cannot assign themselves to FT's.", _status]] call ICE_sqdMgt_formattedGroupMsg;

	[] call ICE_sqdMgt_DrawPage; // refresh screen (locked status field)
	//call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_changeGroupSizeLimit =
{
	private ["_changeDelta", "_group", "_groupSizeLimit", "_canChangeSize"];

	_changeDelta = _this; // either +1 or -1

	_group = group player;
	_groupSizeLimit = _group getVariable ["ICE_sqdMgt_groupSizeLimit", ICE_sqdMgt_groupSizeDefault];
	_canChangeSize = 
		(_groupSizeLimit + _changeDelta) >= _c_groupSizeLimitMin &&
		(_groupSizeLimit + _changeDelta) <= ICE_sqdMgt_groupSizeMax;
	
	if (!_canChangeSize) exitWith
	{
		hintSilent format ["You have reached the current squad size limits (based on total current players), currently at %1. (Min is %2, max is %3.)", 
			_groupSizeLimit, _c_groupSizeLimitMin, ICE_sqdMgt_groupSizeMax];
	}; // exitWith

	_groupSizeLimit = _groupSizeLimit + _changeDelta;
	_group setVariable ["ICE_sqdMgt_groupSizeLimit", _groupSizeLimit, true]; // broadcast
	__ICE_debug_setVar(_group, "ICE_sqdMgt_groupSizeLimit");
	
	format ["Squad size limit is now %1.\n\n(Min is %2, max is %3.)", _groupSizeLimit, _c_groupSizeLimitMin, ICE_sqdMgt_groupSizeMax] call ICE_sqdMgt_msg;

	[] call ICE_sqdMgt_DrawPage; // refresh screen (status fields)
	//call ICE_sqdMgt_notifyRefresh;
};
//----------------------
ICE_sqdMgt_Recruit =
{
	private ["_unit","_leaderAndOtherGroup","_command"];

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	_leaderAndOtherGroup = ((player == leader player) || ICE_sqdMgt_AnySquadMemberCanOrganise) && 
		(group _unit != group player);

	if (_leaderAndOtherGroup) then
	{
		// TODO: if player is greater than a certain distance, then don't show invite option

		_command = "";
		if (ICE_sqdMgt_AllowAIRecruitment && (ICE_sqdMgt_AllowPlayerRecruitment || not (isPlayer _unit))) then
		{
			// DEV: TODO: This code needs completion to restrict how many AI/Players can be recruited.
			_command = localize "STR_ICE_sqdMgt_57" /* "Recruit" */ ;
		};
		// Warning: ICE_sqdMgt_AllowPlayerInvites takes precedence over ICE_sqdMgt_AllowPlayerRecruitment
		if (ICE_sqdMgt_AllowPlayerInvites && isPlayer _unit) then
		{
			// DEV: TODO: This code needs completion to allow invitee to simply reject or accept invitation, leave current group and join your group automatically.
			_command = localize "STR_ICE_sqdMgt_58" /* "Invite" */
		};
		if (_command != "") then
		{
			[_unit] call ICE_sqdMgt_InviteAIOrPlayerIntoGroup;
		};
	};

	if (player != leader player && !ICE_sqdMgt_AnySquadMemberCanOrganise) then {
		["Only a squad leader can invite/recruit other players."] call ICE_sqdMgt_okDialog;
	};
};
//----------------------
ICE_sqdMgt_Kick =
{
	private ["_unit","_leaderAndYourGroup","_leaderAndOtherGroup","_command"];

	_unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};
	
	_leaderAndYourGroup = (player == leader player) && (group _unit == group player);
	_leaderAndOtherGroup = (player == leader player) && (group _unit != group player);

	if (_leaderAndYourGroup && _unit != player) then
	{
		_command = localize "STR_ICE_sqdMgt_55" /* "Remove" */ ;
		if (isPlayer _unit) then
		{
			_command = localize "STR_ICE_sqdMgt_56" /* "Kick" */
		};
		[_unit] call ICE_sqdMgt_RemoveAIOrPlayerFromYourGroup;
	};

	if (player != leader player) then {
		["Only a squad leader can kick other players."] call ICE_sqdMgt_okDialog;
	};
};
//----------------------
ICE_sqdMgt_grid_showMenu =
{
	private ['_idc', '_visibleIndex', '_unit', '_pos', '_i', '_x1', '_y1', '_show', 
		'_inYourGroup', '_youAreCommander', '_youAreSL', '_youAreTL', '_unitIsSL', '_unitIsTL', 
		'_unitIsYou', '_team', '_tagged', '_playerUnits', '_unitUnits', '_lockedGroup', 
		'_lockedFTs', '_groupSizeLimit', '_canIncSize', '_canDecSize', '_playerIsUnassigned',
		'_anyOrganiser', '_isAdmin', '_noOptions'];

  _unit = call ICE_sqdMgt_getGridPlayer;
	if (isNull _unit) exitWith {};

	_visibleIndex = ICE_sqdMgt_currGridIndex;
	if (_visibleIndex > (_c_rowsPerGrid - 1)) then {_visibleIndex = _c_rowsPerGrid - 1}; // keep menu beside grid, rather than below the grid for long lists

	_playerUnits = units player;
	_unitUnits = units _unit;
	_inYourGroup = _unit in _playerUnits;
	_youAreCommander = (call ICE_sqdMgt_getCommander) == player;
	_team = _unit getVariable ["ICE_sqdMgt_team", 0];
	_tagged = _unit getVariable ["ICE_squadHUD_Tag", false];

	_youAreSL = !_youAreCommander && (leader player == player) && 
		(count _playerUnits > 1 || player getVariable ["ICE_sqdMgt_squadLeader", false]);
	_yourTeam = player getVariable ["ICE_sqdMgt_team", 0];
	_youAreTL = (_yourTeam > 0) && (player getVariable ["ICE_sqdMgt_teamLeader", false]);

	_unitIsSL = (leader _unit == _unit) && 
		(count _playerUnits > 1 || player getVariable ["ICE_sqdMgt_squadLeader", false]);;
	_unitIsTL = (_team > 0) && (_unit getVariable ["ICE_sqdMgt_teamLeader", false]);
	_unitIsYou = _unit == player;
	
	_playerIsUnassigned = !_unitIsSL && (count _playerUnits == 1);
	_anyOrganiser = (ICE_sqdMgt_AnySquadMemberCanOrganise && !_playerIsUnassigned);
	_isAdmin = /* (!isMultiplayer) || */ serverCommandAvailable "#kick";
	
	_lockedGroup = (group player) getVariable ["ICE_sqdMgt_lockedGroup", false];
	_lockedFTs = (group player) getVariable ["ICE_sqdMgt_lockedFTs", false];

	// get current max group size
	_groupSizeLimit = (group player) getVariable ["ICE_sqdMgt_groupSizeLimit", ICE_sqdMgt_groupSizeDefault];
	_canIncSize = _groupSizeLimit < ICE_sqdMgt_groupSizeMax;
	_canDecSize = _groupSizeLimit > _c_groupSizeLimitMin;
	
	// draw and position the popup menu
	_pos = ctrlPosition (ICE_sqdMgt_currGridIDC call ICE_sqdMgt_getControl); // grid pos
	_noOptions = true;
	_i = 0; // row
	{
		_idc = _x;

		// determine pos to draw popup menu, either left or right side of grid. The menu will not draw outside of the dialog scroll box.
		_x1 = (_pos select 0)+_c_gb_w; // place buttons to right side of grid.
		if (ICE_sqdMgt_currGridIDC mod 3 == 1) then
		{
			_x1 = (_pos select 0)-_c_subMenuButtonW; // if last grid column, then place buttons to left side of grid.
		};

		_y1 = (_pos select 1)+((_visibleIndex + _i) * _c_controlHgt);
		if ((_pos select 1) > _c_y + _c_h - (10 * _c_controlHgt)) then {_y1 = _c_y + _c_h - (10 * _c_controlHgt)}; // if too low, then place buttons higher up from bottom.
		
//_x1 = 0.5-(_c_subMenuButtonW/2);
//_y1 = 0.4+((_visibleIndex + _i) * _c_controlHgt);

		// show and set pos
		(_idc call ICE_sqdMgt_getControl) ctrlSetPosition [_x1, _y1]; // not sure if this is allowed when hidden, but set button pos before show to prevent RscControlsGroup scrolling sideways

		// conditionally show buttons
		_show = false;
		if (_idc == _c_IDC_NoOptionsButton) then {_show = _noOptions; /*((!_inYourGroup || _playerIsUnassigned) && (_youAreCommander || !_youAreSL) &&
				(!_unitIsSL) // don't allow manipulation of other SL's
			)*/}; // this is always processed last in buttons list
		if (_idc == _c_IDC_RecruitButton) then {_show = (!_inYourGroup && (_youAreSL || _anyOrganiser || _isAdmin) && !_youAreCommander)};
		if (_idc == _c_IDC_KickButton) then {_show = (_inYourGroup && _youAreSL && _unit != player)};
		if (_idc == _c_IDC_TagPlayerButton) then {_show = (_inYourGroup && _unit != player && !_tagged)};
		if (_idc == _c_IDC_UntagPlayerButton) then {_show = (_inYourGroup && _unit != player && _tagged)};
		if (_idc == _c_IDC_SetSLButton) then {_show = ((count _unitUnits > 1) && !_unitIsSL && (_youAreSL || _anyOrganiser || _isAdmin))}; // non-Unassigned groups only.
		if (_idc == _c_IDC_SetTeamLeaderButton) then {_show = (_inYourGroup && (_youAreSL || _youAreTL || _anyOrganiser || _isAdmin) && _team > 0 && !_unitIsTL)};
		if (_idc == _c_IDC_SetTeam1Button) then {_show = (_inYourGroup && (_youAreSL || _anyOrganiser || _isAdmin || (!_lockedFTs && _unitIsYou && !_playerIsUnassigned) && (!_lockedFTs && _youAreTL && _yourTeam == 1)) && _team == 0)};
		if (_idc == _c_IDC_SetTeam2Button) then {_show = (_inYourGroup && (_youAreSL || _anyOrganiser || _isAdmin || (!_lockedFTs && _unitIsYou && !_playerIsUnassigned) && (!_lockedFTs && _youAreTL && _yourTeam == 2)) && _team == 0)};
		if (_idc == _c_IDC_SetTeam3Button) then {_show = (_inYourGroup && (_youAreSL || _anyOrganiser || _isAdmin || (!_lockedFTs && _unitIsYou && !_playerIsUnassigned) && (!_lockedFTs && _youAreTL && _yourTeam == 3)) && _team == 0)};
		if (_idc == _c_IDC_UnassignTeamButton) then {_show = (_inYourGroup && (_youAreSL || _anyOrganiser || _isAdmin || (!_lockedFTs && _unitIsYou && !_playerIsUnassigned) && (!_lockedFTs && _youAreTL && _team == _yourTeam)) && _team > 0)};
		if (_idc == _c_IDC_LockGroupButton) then {_show = (_inYourGroup && _youAreSL && !_lockedGroup && _unitIsYou)};
		if (_idc == _c_IDC_UnlockGroupButton) then {_show = (_inYourGroup && _youAreSL && _lockedGroup && _unitIsYou)};
		if (_idc == _c_IDC_LockFTsButton) then {_show = (_inYourGroup && _youAreSL && !_lockedFTs && _unitIsYou && !ICE_sqdMgt_AnySquadMemberCanOrganise)};
		if (_idc == _c_IDC_UnlockFTsButton) then {_show = (_inYourGroup && _youAreSL && _lockedFTs && _unitIsYou && !ICE_sqdMgt_AnySquadMemberCanOrganise)};
		if (_idc == _c_IDC_IncreaseGroupSizeLimitButton) then {_show = (_inYourGroup && _youAreSL && _canIncSize && _unitIsYou)};
		if (_idc == _c_IDC_DecreaseGroupSizeLimitButton) then {_show = (_inYourGroup && _youAreSL && _canDecSize && _unitIsYou)};
		
		ctrlShow [_idc, _show];
		if (_show) then {_i = _i + 1; _noOptions = false};
		if (!_show) then {_x1 = -2; _y1 = -2;};
		if (_idc == _c_IDC_NoOptionsButton) then {ctrlEnable [_idc, false]};

		(_idc call ICE_sqdMgt_getControl) ctrlSetPosition [_x1, _y1]; // set button pos, again
		(_idc call ICE_sqdMgt_getControl) ctrlCommit 0; // commits ctrlSetPosition
	} forEach _c_IDC_AllMenuButtons;
};
//----------------------
ICE_sqdMgt_scrollPage =
{
	private ["_ctrl", "_newRow", "_pos"];

	_ctrl = _this select 0;
	//_newRow = floor ((_this select 1) / 3.334);
	_newRow = floor (_this select 1);
	if (_newRow < 0) then {_newRow = 0};
	if (_newRow == ICE_sqdMgt_currPageRow || 
		(ICE_sqdMgt_currPageRow >= ICE_sqdMgt_maxPageRow && _newRow > ICE_sqdMgt_maxPageRow)) exitWith {};

	ICE_sqdMgt_currPageRow = if (_newRow > ICE_sqdMgt_maxPageRow) then {ICE_sqdMgt_maxPageRow} else {_newRow};
	
	// adjust slider tab pos, if manual scrolling performed
	if (isNull _ctrl) then
	{
		(_c_IDC_slider call ICE_sqdMgt_getControl) sliderSetPosition _newRow;

		_pos = ctrlPosition (_c_IDC_verticalScrollThumb call ICE_sqdMgt_getControl);
		_pos set [1, _c_gb_y + _c_sb_bh + (_c_gb_h - (2 * _c_sb_bh))*(_newRow/10)];
		(_c_IDC_verticalScrollThumb call ICE_sqdMgt_getControl) ctrlSetPosition _pos;
		(_c_IDC_verticalScrollThumb call ICE_sqdMgt_getControl) ctrlCommit 0; // commits ctrlSetPosition
	};
	
	call ICE_sqdMgt_DrawPage;
};
//----------------------
ICE_sqdMgt_repositionGrid =
{
	private ["_idc", "_gridRow", "_ctrlType", "_offset", "_pos", "_y1"];
	_idc = _this select 0;
	_gridRow = _this select 1;
	_ctrlType = _this select 2;

	_offset = 0;
	if (_ctrlType == _c_IDC_Grid) then {_offset = _c_controlHgt};
	if (_ctrlType == _c_IDC_GridBG) then {_offset = 0};
	if (_ctrlType == _c_IDC_GridCaption) then {_offset = 0};
	if (_ctrlType == _c_IDC_GridFooter) then {_offset = _c_totalUpperGridHgt};
	//if (_ctrlType == _c_IDC_GridLock) then {_offset = _c_totalUpperGridHgt+0.10* _c_controlHgt};
	if (_ctrlType == _c_IDC_GridNameButton) then {_offset = _c_totalUpperGridHgt+0.10* _c_controlHgt};
	if (_ctrlType == _c_IDC_GridJoinLeaveButton) then {_offset = _c_totalUpperGridHgt+0.10* _c_controlHgt};

	// calc screen row
//if (_ctrlType == _c_IDC_Grid) then {diag_log ["gridRow", _gridRow, [_gridRow mod _c_gridsDown, (_c_gridsDown)-(_gridRow mod _c_gridsDown)]];};
	_gridRow = _gridRow - ICE_sqdMgt_currPageRow; // mod _c_gridsDown;
	/*
	if (_gridRow / 2 == floor (_gridRow / 2)) then
	{
		_gridRow = _gridRow mod _c_gridsDown;
	}
	else
	{
		_gridRow = (_c_gridsDown-(_gridRow mod _c_gridsDown));
	};
	*/

	// calc y pos
	_y1 = _c_gb_y+_gridRow * _c_totalGridHgtAndGap + _offset;

	// set pos
	_pos = ctrlPosition (_idc call ICE_sqdMgt_getControl);
	/*
	if (_ctrlType in [_c_IDC_GridBG, _c_IDC_Grid]) then
	{
		// only do this block if you want dynamic grid resizing
		private ["_h"];
		_h = _c_rowsPerGrid * _c_controlHgt;
		if (_ctrlType == _c_IDC_Grid) then
		{
			_h = _c_rowsPerGrid * _c_gridControlHgt;
		};
		(_idc call ICE_sqdMgt_getControl) ctrlSetPosition [_pos select 0, _y1, _c_gb_w, _h];
	}
	else
	{
	*/
		(_idc call ICE_sqdMgt_getControl) ctrlSetPosition [_pos select 0, _y1];
	//};
//diag_log ["row", _idc, _y1, [_c_gb_y, _gridRow, _c_totalGridHgtAndGap], _offset];
	(_idc call ICE_sqdMgt_getControl) ctrlCommit 0; // commits ctrlSetPosition
};
//----------------------
ICE_sqdMgt_AddGrid =
{
  private ["_group", "_groupId", "_unitCount", "_gridId", "_idc", "_lockStatus", "_groupSizeLimit", 
		"_bg", "_groupName", "_squadName", "_localGroupName", "_customGroupName",
		"_needRequest", "_desc", "_gridRow", "_unassignedGroup"];
  _group = _this select 0;
	_groupId = _this select 1;
	_unitCount = _this select 2;

	_gridRow = floor (_groupId / _c_gridsAcross);
	_gridId = (_groupId - (ICE_sqdMgt_currPageRow * _c_gridsAcross));
	_unassignedGroup = isNull _group;
  //---------------------------------
  // show/hide & reposition grids
	private ['_show', '_showGrid'];

	_show = (_gridId >= 0 && _gridId < _c_gridsPerPage);
	_showGrid = _show;

	_idc = [_gridId, _c_IDC_Grid] call ICE_sqdMgt_GetGridIdc;
	if (!_show) then {lnbClear _idc};
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_Grid] call ICE_sqdMgt_repositionGrid};

	_idc = [_gridId, _c_IDC_GridBG] call ICE_sqdMgt_GetGridIdc;
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridBG] call ICE_sqdMgt_repositionGrid};

	_idc = [_gridId, _c_IDC_GridCaption] call ICE_sqdMgt_GetGridIdc;
	if (!_show) then {ctrlSetText [_idc, ""]};
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridCaption] call ICE_sqdMgt_repositionGrid};

	_idc = [_gridId, _c_IDC_GridFooter] call ICE_sqdMgt_GetGridIdc;
	if (!_show) then {ctrlSetText [_idc, ""]};
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridFooter] call ICE_sqdMgt_repositionGrid};

	// special checks for "Unassigned" grid
	_idc = [_gridId, _c_IDC_GridCaption] call ICE_sqdMgt_GetGridIdc;
	if (_unassignedGroup) then {_show = false}; // don't show rest of buttons below.
	
	_idc = [_gridId, _c_IDC_GridLock] call ICE_sqdMgt_GetGridIdc;
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridLock] call ICE_sqdMgt_repositionGrid};

	_idc = [_gridId, _c_IDC_GridNameButton] call ICE_sqdMgt_GetGridIdc;
	ctrlShow [_idc, _show];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridNameButton] call ICE_sqdMgt_repositionGrid};

	_idc = [_gridId, _c_IDC_GridJoinLeaveButton] call ICE_sqdMgt_GetGridIdc;
	ctrlShow [_idc, _show && (player != _commander)];
	if (_show) then {[_idc, _gridRow, _c_IDC_GridJoinLeaveButton] call ICE_sqdMgt_repositionGrid};
  //---------------------------------
	if (!_showGrid) exitWith
	{
//diag_log ["HIDE", _group, [_groupId, _gridId], [_gridRow, _showGrid, ICE_sqdMgt_currPageRow], _c_gridsDown, if (_showGrid) then {" =======>"} else {""}];
	}; // grid not on current page

	//_idc = [_gridId, _c_IDC_Grid] call ICE_sqdMgt_GetGridIdc;
	//ctrlShow [_idc, true];
	
	_needRequest = false;
	//-----------
#define _c_CaptionBackground 58/256, 80/256, 55/256 // BIS mid green (button over colour)
	_bg = [_c_CaptionBackground,1]; //[0.1,0.4,0.2,1];
	if (side _group == west) then {_bg = [_c_color_teamBlue, 1]};
	if (side _group == east) then {_bg = [_c_color_teamRed, 1]};
	_bg set [3, 0.8];

	_groupName = "";
	if (_unassignedGroup) then
	{
		_groupName = _group call ICE_sqdMgt_getGroupDesc; // get "unassigned" group name
	}
	else
	{
		_squadName = "";
		_localGroupName = "";
		_customGroupName = "";

		_localGroupName = _group getVariable ["ICE_sqdMgt_localSquadName", ""];
		if (_localGroupName != "") then {_squadName = _squadName+", ["+_localGroupName+"]"};

		if (_localGroupName == "") then
		{
			_customGroupName = _group getVariable ["ICE_sqdMgt_squadName", ""];
			if (_customGroupName != "") then {_squadName = _squadName+", "+_customGroupName};
		};

		_squadStatus = _group getVariable ["ICE_squadStatus", ""];
		if (_squadStatus != "") then {_squadName = _squadName+" ("+_squadStatus+")"};
		
		//_groupName = _group call ICE_fn_groupName; // use short group name
		//if (_customGroupName == "" && _localGroupName == "") then
		//{
			_groupName = _group call ICE_sqdMgt_getGroupDesc; // get longer group name
		//};

		if (_squadName != "") then {_groupName = _groupName+_squadName};
	};
	
	_idc = [_gridId, _c_IDC_GridCaption] call ICE_sqdMgt_GetGridIdc;
	(_idc call ICE_sqdMgt_getControl) ctrlSetBackgroundColor _bg;
	ctrlSetText [_idc, _groupName];
//diag_log ["draw", _groupName, _group, [_groupId, _gridId], [_gridRow, _showGrid, ICE_sqdMgt_currPageRow], _c_gridsDown, if (_showGrid) then {" =======>"} else {""}];

	_idc = [_gridId, _c_IDC_GridFooter] call ICE_sqdMgt_GetGridIdc;
	(_idc call ICE_sqdMgt_getControl) ctrlSetBackgroundColor _bg;

	if (_unassignedGroup) then
	{
		ctrlSetText [_idc, format ["(%1)", _unitCount]];
	}
	else
	{
		_groupSizeLimit = _group getVariable ["ICE_sqdMgt_groupSizeLimit", ICE_sqdMgt_groupSizeDefault];
		_lockStatus = "";
		if (_group getVariable ["ICE_sqdMgt_lockedGroup", false]) then
		{
			_minGroupSize = 4;
			if (playersNumber playerSide <= 30) then {_minGroupSize = 3};
			if (playersNumber playerSide <= 20) then {_minGroupSize = 2};
			if (playersNumber playerSide <= 10) then {_minGroupSize = 1};

			_lockStatus = "[Locked]";
			_needRequest = true;
			if (count units _group < _minGroupSize) then
			{
				_lockStatus = "[Half locked]";
				_needRequest = false;
			};
		}
		else
		{
			if (count units _group >= _groupSizeLimit) then
			{
				_lockStatus = "[Full]";
				_needRequest = true;
			};
		};
	
		ctrlSetText [_idc, format ["(%1/%2) %3", 
			count (units _group), 
			_groupSizeLimit, 
			_lockStatus]
		];
	};
	//-----------
	_idc = [_gridId, _c_IDC_GridBG] call ICE_sqdMgt_GetGridIdc;
	_bg = [0.2, 0.2, 0.2, 0.5];
	if (playerSide == west) then {_bg = [_c_color_teamBlue, 0.3]};
	if (playerSide == east) then {_bg = [_c_color_teamRed, 0.3]};
	if (_group == group player) then {_bg = [0,0.1,0, 0.6]};
	(_idc call ICE_sqdMgt_getControl) ctrlSetBackgroundColor _bg;
	//-----------
	_idc = [_gridId, _c_IDC_GridLock] call ICE_sqdMgt_GetGridIdc;
	ctrlSetText [_idc, ""]; //"\CA\ui\data\lock_off_ca.paa"]; // locking not implemented yet
	//ctrlSetText [_idc, ""]; //"\a3\ui_f\data\gui\Rsc\RscDisplayMultiplayer\sessions_locked_ca.paa"];
	//-----------
	_desc = (if (_needRequest) then {"Request"} else {"Join"});
	if (group player == _group) then {_desc = "Leave"};

	_idc = [_gridId, _c_IDC_GridJoinLeaveButton] call ICE_sqdMgt_GetGridIdc;
	(_idc call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText _desc;
};
//----------------------
ICE_sqdMgt_AddGridRow =
{
  private ["_unit","_groupId","_gridId","_nameDesc","_team","_idc","_index","_seatInfo",
		"_vehicleIcon","_kitIcon","_teamInfo","_i","_cols","_rank"];
  _unit = _this select 0;
  _groupId = _this select 1;
  //_id = _this select 2;

	_gridId = (_groupId - (ICE_sqdMgt_currPageRow * _c_gridsAcross));
	_nameDesc = [_unit] call ICE_sqdMgt_GetPlayerName;
	_team = _unit getVariable ["ICE_sqdMgt_team", 0];

	_idc = [_gridId, _c_IDC_Grid] call ICE_sqdMgt_GetGridIdc;
	lnbAddRow [_idc,
		[
			"", //[_id] call ICE_sqdMgt_GetPlayerIndex,
			"",
			"",
			""
		]
	];

	//lnbsetColumnsPos [idc,[row,column], data];
	
	_index = ((lnbSize _idc) select 0)-1; // last row
	// TODO: use index number together with a lookup array, rather than string name matching
	lnbSetData [_idc, [_index, _c_gridCol_data], format ["%1", _unit]];
	
	lnbSetText [_idc, [_index, _c_gridCol_name], _nameDesc];
	(_idc call ICE_sqdMgt_getControl) lnbSetText [[_index, _c_gridCol_name], _nameDesc]; 

	_seatInfo = [_unit] call ICE_sqdMgt_GetVehicleSeat;

	// vehicle icon
	_vehicleIcon = "";
	if (count _seatInfo > 0) then
	{
		if (count (_seatInfo select 0) > 3) then
		{
			_vehicleIcon = _seatInfo select 0 select 3;
		};
	};
	lnbSetPicture [_idc, [_index, _c_gridCol_vehicle], _vehicleIcon];

	// kit icon
	_kitRecord = _unit call ICE_sqdMgt_getKitInfo;
	_kitIcon = _kitRecord select 0;
	lnbSetPicture [_idc, [_index, _c_gridCol_kit], _kitIcon];

	// seat icon
	if (alive _unit) then
	{
		lnbSetPicture [_idc, [_index, _c_gridCol_seat], _seatInfo select 0 select 2];
	}
	else
	{
#ifdef __ICE_armaGameVer2
		lnbSetPicture [_idc, [_index, _c_gridCol_seat], "\CA\ui\data\objective_incomplete_ca.paa"];
#endif
#ifdef __ICE_armaGameVer3
		lnbSetPicture [_idc, [_index, _c_gridCol_seat], "\a3\ui_f\data\map\Diary\Icons\taskfailed_ca.paa"];
#endif
	};

	_rank = "";
	if ((_team > 0) && (_unit getVariable ["ICE_sqdMgt_teamLeader", false])) then
	{
#ifdef __ICE_armaGameVer2
		_rank = "\CA\characters\data\ico\i_tleader_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
		_rank = "\a3\ui_f\data\gui\cfg\Ranks\sergeant_gs.paa";
#endif
	};
	if ((_unit == leader _unit) && 
		((count (units _unit) > 1) || (_unit getVariable ["ICE_sqdMgt_squadLeader", false]))) then
	{
#ifdef __ICE_armaGameVer2
		_rank = "\CA\characters\data\ico\i_sleader_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
		_rank = "\a3\ui_f\data\gui\cfg\Ranks\major_gs.paa"; // captain_gs.paa
#endif
	};
	lnbSetPicture [_idc, [_index, _c_gridCol_rank], _rank];

	/*
	_teamInfo = ((["None"]+_c_teamLetters) select _team);
	if (_unit getVariable ["ICE_squadHUD_Tag", false]) then
	{
		_teamInfo = _teamInfo+"_tagged";
	};
	_teamInfo = format [_c_basePath(data\teamIcons\team%1.paa), _teamInfo];
	lnbSetPicture [_idc, [_index, _c_gridCol_team], _teamInfo];
	*/
	_teamInfo = (([""]+_c_teamLetters) select _team);
	if (_unit getVariable ["ICE_squadHUD_Tag", false]) then
	{
		_teamInfo = _teamInfo+"*";
	};
	lnbSetText [_idc, [_index, _c_gridCol_team], _teamInfo];

	if (_team >= 1 && _team <= 3) then
	{
		_cols = lnbSize _idc;
		if (count _cols > 1) then
		{
			_cols = (lnbSize _idc) select 1;
		}
		else
		{
			_cols = 4; // fall back value
		};		
		for "_i" from 0 to (_cols-1) do
		{
			lnbSetColor [_idc, [_index, _i], 
				([[_c_color_fireteamA, 1], [_c_color_fireteamB, 1], [_c_color_fireteamC, 1]] select (_team-1)) ];
		};
	};

	/*
	if (_unit == player) then
	{
		lnbSetColor [_idc, [_index, _c_gridCol_team], [_c_color_White, 1]]; // if you are in a FT, this will override the FT player name colour
	};
	*/
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_getKitInfo =
{
	private ["_result", "_kitIcon", "_kitDesc", "_unit", "_primWeapUiPicture", "_soldierPicture"];
	_unit = _this;

	_kitIcon = "";
	_kitDesc = "";
	_result = [_kitIcon, _kitDesc];

	if (!isNil "ICE_gear_hasMedicKit") then
	{
		_result = switch true do
		{
			#define __icon(_file) QUOTEME(\CA\weapons\Data\Equip\_file.paa)
			#define __icon2(_file) _c_basePath(data\kitIcons\_file.paa)
			#define __icon3(_file) QUOTEME(\CA\characters\data\Ico\_file.paa)

			case (_unit call ICE_gear_hasRiflemanKit): {[__icon(m_30stanag_ca), "Rifleman"]};
			case (_unit call ICE_gear_hasGrenadierKit): {[__icon(m_40mmhp_ca), "Grenadier"]};
			case (_unit call ICE_gear_hasMGKit): {[__icon(m_m249_ca), "Machinegunner"]};
			case (_unit call ICE_gear_hasMedicKit): {[__icon3(i_med_ca), "Medic"]};
			case (_unit call ICE_gear_hasCombatEngineerKit): {[__icon(m_satchel_ca), "Engineer"]};
			case (_unit call ICE_gear_hasLightATKit): {[__icon(m_m136_ca), "Light AT"]};
			case (_unit call ICE_gear_hasHeavyATKit): {[__icon(m_javelin_ca), "Heavy AT"]};
			case (_unit call ICE_gear_hasAAKit): {[__icon(m_stinger_ca), "Anti-air"]};
			case (_unit call ICE_gear_hasMarksmanKit): {[__icon(m_m24_ca), "Marksman"]};
			case (_unit call ICE_gear_hasSniperKit): {[__icon(m_m24_ca), "Sniper"]};
			case (_unit call ICE_gear_hasSLKit): {[__icon2(sl), "Squad leader"]};
			case (_unit call ICE_gear_hasCrewmanKit): {[__icon2(crewman), "Crewman"]};
			case (_unit call ICE_gear_hasPilotKit): {[__icon2(pilot), "Pilot"]};
			default {["", ""]};
		};
	}
	else
	{
		_result = switch true do
		{
			#define __icon(_file) QUOTEME(\CA\weapons\Data\Equip\_file.paa)
			#define __icon2(_file) _c_basePath(data\kitIcons\_file.paa)
			#define __icon3(_file) QUOTEME(\CA\characters\data\Ico\_file.paa)
			_primWeapUiPicture = getText (configFile >> "cfgWeapons" >> (primaryWeapon _unit) >> "UiPicture");
			_secWeapUiPicture = getText (configFile >> "cfgWeapons" >> (secondaryWeapon _unit) >> "UiPicture");
			_soldierPicture = getText (configFile >> "cfgVehicles" >> typeOf _unit >> "picture");
			#define __weaponUiPicture(_file) QUOTEME(\CA\weapons\data\Ico\_file.paa)

			// N.B: order of case checks is vital.
			case (_soldierPicture == __icon3(i_Med_CA)): {[__icon3(i_med_ca), "Medic"]};
			case (_secWeapUiPicture == __weaponUiPicture(i_at_CA)): {[__icon(m_m136_ca), "AT"]};
			//case (_unit call ICE_gear_hasHeavyATKit): {[__icon(m_javelin_ca), "Heavy AT"]};
			case (_secWeapUiPicture == __weaponUiPicture(i_aa_CA)): {[__icon(m_stinger_ca), "Anti-air"]};

			case (_primWeapUiPicture == __weaponUiPicture(i_regular_CA)): {[__icon(m_30stanag_ca), "Rifleman"]};
			//case (_unit call ICE_gear_hasGrenadierKit): {[__icon(m_40mmhp_ca), "Grenadier"]};
			case (_primWeapUiPicture == __weaponUiPicture(i_mg_CA)): {[__icon(m_m249_ca), "Machinegunner"]};
			//case (_unit call ICE_gear_hasCombatEngineerKit): {[__icon(m_satchel_ca), "Engineer"]};
			//case (_unit call ICE_gear_hasMarksmanKit): {[__icon(m_m24_ca), "Marksman"]};
			case (_primWeapUiPicture == __weaponUiPicture(i_sniper_ca)): {[__icon(m_m24_ca), "Sniper"]};
			//case (_unit call ICE_gear_hasSLKit): {[__icon2(sl), "Squad leader"]};
			//case (_unit call ICE_gear_hasCrewmanKit): {[__icon2(crewman), "Crewman"]};
			//case (_unit call ICE_gear_hasPilotKit): {[__icon2(pilot), "Pilot"]};
			default {["", ""]};
		};
	};

	_result
};
//-----------------------------------------------------------------------------
// Group/Unit/Vehicle processing functions
//-----------------------------------------------------------------------------
// cache sorted groups list and reuse cached list if groups are unchanged
ICE_sqdMgt_SortGroupsArray =
{
	private ["_allGroups"];
	
	_allGroups = _this;
	if (str _allGroups != str ICE_sqdMgt_lastGroupsListToSort) then
	{
//diag_log ["ICE_sqdMgt_SortGroupsArray: resorting watch"];
//diag_log ["1.", str _allGroups];
//diag_log ["2.", str ICE_sqdMgt_lastGroupsListToSort];
		ICE_sqdMgt_lastGroupsListToSort = +_allGroups; // copy array
		ICE_sqdMgt_lastSortedGroupsList = [_allGroups] call ICE_sqdMgt_sortGroups;
	}
	else
	{
//diag_log ["ICE_sqdMgt_SortGroupsArray: using cached list"];
	};

	ICE_sqdMgt_lastSortedGroupsList
};
//----------------------
ICE_sqdMgt_FillGroups =
{
	private ["_redraw_id", "_groupCount","_idc","_units","_group","_newGroup","_id",
		"_unassignedUnits","_unassignedGroup","_includeGroup","_allGroups","_drType",
		"_picture","_seatCount","_dr","_gu","_co","_ca","_vehicle","_commander"];

	// occasionally, this function takes too long to execute and a 2nd call can execute simultaneously. _redraw_id will abort the redraw if it detect a newer call.
	_redraw_id = _this;
	
	_commander = call ICE_sqdMgt_getCommander;
	ctrlShow [_c_IDC_CommanderButton, ICE_sqdMgt_EnableCommanderSelection && isNull _commander];
	ctrlShow [_c_IDC_LeaveCommanderButton, ICE_sqdMgt_EnableCommanderSelection && _commander == player];
	ctrlShow [_c_IDC_CommanderName, ICE_sqdMgt_EnableCommanderSelection];
	ctrlShow [_c_IDC_NewGroupButton, _commander != player];
	if (ICE_sqdMgt_EnableCommanderSelection) then
	{
		ctrlSetText [_c_IDC_CommanderName, if (isNull _commander) then {"Commander: No-one"} else {format ["Commander: %1", _commander call ICE_sqdMgt_safeName]}];
	};

	//call ICE_sqdMgt_hideOkDialog;
  //---------------------------------
	_groupCount = 0;
  //_lastRow = _c_screenRows;
	_allGroups = allGroups;
  //---------------------------------
	// Sort group object list
	_allGroups = _allGroups call ICE_sqdMgt_SortGroupsArray;
	if (_redraw_id != ICE_sqdMgt_redraw_id) exitWith {}; // abort this redraw, another redraw has been initiated.

	_unassignedUnits = [];

	// process all groups
	{
		_idc = [_groupCount, _c_IDC_Grid] call ICE_sqdMgt_GetGridIdc;
		lnbClear _idc;

		_group = _x;
		_units = [];

		// process unassigned group differently to a regular group
		_unassignedGroup = (typeName _group == typeName "");
		if (_unassignedGroup) then
		{
			_units = _unassignedUnits;
			_group = grpNull;
		} else {
			_units = (units _group);
		};

		// integrity check (obsolete: was due to improper allUnits command result)
		if (!_unassignedGroup) then
		{
			if (!isNull _group && !(side _group in [west, east, resistance, civilian])) then
			{
				diag_log ["Squad Mgt", "Error: group has invalid side!", _group, side _group];
				player globalChat format ["Error: group has invalid side! Please report. [%1,%2]", 
					_group, side _group];
			};
		};
		_includeGroup = ICE_sqdMgt_ShowAIGroups || ({isPlayer _x} count _units > 0);

		if ((side _group == playerSide || _unassignedGroup) && _includeGroup) then
		{
			_newGroup = false;
			if (count _units == 1) then
			{
				_newGroup = (_units select 0) getVariable ["ICE_sqdMgt_squadLeader", false];
			};

			if ((_unassignedGroup && count _unassignedUnits > 0) || _newGroup || count _units > 1) then // if (is Unassigned group || 1 player new group || group has 2+ players)
			{
				if (_redraw_id != ICE_sqdMgt_redraw_id) exitWith {};
				[_group, _groupCount, count _units] call ICE_sqdMgt_AddGrid;

				// process all units in group
				_id = 1;
				{
					if (_redraw_id != ICE_sqdMgt_redraw_id) exitWith {};
					[_x, _groupCount, _id] call ICE_sqdMgt_AddGridRow;
					_id = _id + 1;
				} forEach _units;

				_groupCount = _groupCount + 1;
			}
			else
			{
				if (count _units == 1) then
				{
					if ((_units select 0) != _commander) then // exclude commander from unassigned list.
					{
						_unassignedUnits = _unassignedUnits+[_units select 0];
					};
				};
			};
		};
		if (_redraw_id != ICE_sqdMgt_redraw_id) exitWith {};
	} forEach _allGroups+["Unassigned"];
	
	ICE_sqdMgt_maxPageRow = 0 max (floor (_groupCount / _c_gridsAcross)-_c_gridsDown+1);
  //---------------------------------
	// hide unused grids beyond end of last page
	private ['_i', '_show', '_idc', '_gridId'];

	// determine total grids, including Unassigned grid
	_gridId = (_groupCount - (ICE_sqdMgt_currPageRow * _c_gridsAcross));

	for "_i" from 0 to (_c_gridsPerPage-1) do
	{
		if (_redraw_id != ICE_sqdMgt_redraw_id) exitWith {};
		_show = (_i < _gridId);
		if (!_show) then
		{
			_idc = [_i, _c_IDC_Grid] call ICE_sqdMgt_GetGridIdc;
			if (!_show) then {lnbClear _idc};
			ctrlShow [_idc, _show];

			_idc = [_i, _c_IDC_GridBG] call ICE_sqdMgt_GetGridIdc;
			ctrlShow [_idc, _show];

			_idc = [_i, _c_IDC_GridCaption] call ICE_sqdMgt_GetGridIdc;
			if (!_show) then {ctrlSetText [_idc, ""]};
			ctrlShow [_idc, _show];

			_idc = [_i, _c_IDC_GridFooter] call ICE_sqdMgt_GetGridIdc;
			if (!_show) then {ctrlSetText [_idc, ""]};
			ctrlShow [_idc, _show];

			// special checks for "Unassigned" grid
			_idc = [_i, _c_IDC_GridCaption] call ICE_sqdMgt_GetGridIdc;
			if (ctrlText _idc == localize "STR_ICE_sqdMgt_66") then {_show = false}; // Unassigned // TODO: use a better condition.
			
			_idc = [_i, _c_IDC_GridLock] call ICE_sqdMgt_GetGridIdc;
			ctrlShow [_idc, _show];

			_idc = [_i, _c_IDC_GridNameButton] call ICE_sqdMgt_GetGridIdc;
			ctrlShow [_idc, _show];

			_idc = [_i, _c_IDC_GridJoinLeaveButton] call ICE_sqdMgt_GetGridIdc;
			ctrlShow [_idc, _show && (player != _commander)];
		};
	};
};
//----------------------
// TODO: provide param to allow minor refresh - same groups, but different info/leader/FTL/FT/etc.
ICE_sqdMgt_notifyRefresh =
{
	["c",
		{call ICE_sqdMgt_DrawPage},
		0
	] call ICE_sqdMgt_broadcast;
};
//----------------------
ICE_sqdMgt_DrawPage =
{
	if (isNull findDisplay _c_SqdMgt_IDD) exitWith {};

	ICE_sqdMgt_redraw_id = ICE_sqdMgt_redraw_id + 1;
	ICE_sqdMgt_redraw_id call ICE_sqdMgt_FillGroups;
  // execFSM _c_basePath(fastExecute.fsm); // not working yet

  call ICE_sqdMgt_SetTitle;

	ctrlSetText [_c_IDC_pageNumber, format ["Row: %1/%2", 1+ICE_sqdMgt_currPageRow, 1+ICE_sqdMgt_maxPageRow]];
	
  //ctrlSetFocus (_c_IDC_MyTeamButton call ICE_sqdMgt_getControl);
};
//----------------------
ICE_sqdMgt_SetTitle =
{
	private ["_teamName", "_flag"];

	_teamName = if (isNil "ICE_teamName_client") then {""} else {ICE_teamName_client};
	_flag = if (isNil "ICE_teamFlag_client") then {
#ifdef __ICE_armaGameVer2
		"ca\ui\data\flag_bluefor_ca.paa"
#endif
#ifdef __ICE_armaGameVer3
		"\a3\ui_f\data\map\Markers\Flags\nato_ca.paa" // TODO: find blue flag
#endif
	} else {ICE_teamFlag_client};

  ctrlSetText [_c_IDC_FrameCaption, format ["%1%2%3", 
		localize "STR_ICE_sqdMgt_01", 
		if (_teamName == "") then {""} else {" - "},
		_teamName]];
	ctrlSetText [_c_IDC_Flag, _flag];

	/*
	_idc = _c_IDC_FrameCaption;
	_bg = [1,1,1,1];
	if (playerSide == west) then {_bg = [_c_color_teamBlue, 1]};
	if (playerSide == east) then {_bg = [_c_color_teamRed, 1]};
  (_idc call ICE_sqdMgt_getControl) ctrlSetBackgroundColor _bg;
	*/
};
//----------------------
// Localize all text for: buttons, titles, grid buttons, etc
ICE_sqdMgt_LocalizeText =
{
  if (localize "STR_ICE_sqdMgt_01" == "") then { player sideChat "Missing STR_ICE_sqdMgt_* stringtable data" /* notify local client only */ };
  call ICE_sqdMgt_SetTitle;

#ifdef __ICE_armaGameVer2
  (_c_IDC_CloseButton call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText "<img image='\CA\ui\data\ui_task_failed_ca.paa'/>"; //(localize "STR_ICE_sqdMgt_02");
#endif
#ifdef __ICE_armaGameVer3
  (_c_IDC_CloseButton call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText "<img image='\a3\ui_f\data\map\MapControl\taskiconfailed_ca.paa'/>"; //(localize "STR_ICE_sqdMgt_02");
#endif
  buttonSetAction [_c_IDC_CloseButton, "closeDialog 0"];

  //(_c_IDC_VehicleButton call ICE_sqdMgt_getControl) ctrlSetStructuredText parseText (localize "STR_ICE_sqdMgt_05");
};
//----------------------
ICE_sqdMgt_local_keyDown = // warning, there is already a ICE_sqdMgt_keyDown
{
  private ['_handled', '_dikCode', '_shiftKey', '_ctrlKey', '_altKey', '_match'];
  _dikCode = _this select 1; // key
	_shiftKey = _this select 2;
	_ctrlKey = _this select 3;
	_altKey = _this select 4;
  
  _handled = false;

	// editGroupName
	if (!isNull ICE_sqdMgt_editGroupName_group) then
	{
		if (_dikCode in [DIK_ESCAPE, DIK_RETURN, DIK_NUMPADENTER]) exitWith
		{
			if (_dikCode in [DIK_ESCAPE]) then
			{
				ICE_sqdMgt_editGroupName_group = grpNull; // causes cancellation of edit
			};
			[controlNull] call ICE_sqdMgt_squadName_onKillFocus; // save or cancel edit
			_handled = true;
		};
	}
	else
	{
		if (!_altKey && !_shiftKey) then
		{
			if (_ctrlKey && _dikCode == DIK_F4) exitWith
			{
				// recompile functions - SP debug
				if (!isMultiplayer) then
				{
					_handled = true;
					closeDialog 0;
					call compile preprocessFileLineNumbers _c_basePath(initFunctions.sqf);
					hintSilent "Functions recompiled for next reactivation."
				};
			};			
		};
		if (!_ctrlKey && !_altKey && !_shiftKey) then
		{
			// scrolling keys
			if (_dikCode == DIK_PGUP) exitWith
			{
				_handled = true;
				[controlNull, ICE_sqdMgt_currPageRow - 1] call ICE_sqdMgt_scrollPage;
			};
			if (_dikCode == DIK_PGDN) exitWith
			{
				_handled = true;
				[controlNull, ICE_sqdMgt_currPageRow + 1] call ICE_sqdMgt_scrollPage;
			};
			if (_dikCode == DIK_HOME) exitWith
			{
				_handled = true;
				[controlNull, 0] call ICE_sqdMgt_scrollPage;
			};
			if (_dikCode == DIK_END) exitWith
			{
				_handled = true;
				[controlNull, ICE_sqdMgt_maxPageRow] call ICE_sqdMgt_scrollPage;
			};
			if (_dikCode in actionKeys "MenuBack") exitWith
			{
				_handled = true;
				[controlNull] call ICE_sqdMgt_grid_onLBSelChanged;
			};
		};

		// close dialog (via repeated press of same key)
		_match = false;
		// scan for matching key/shiftKeys combination
		{
			if (_dikCode == (_x select 0)) then
			{
#define _c_booleansEqual(_var1,_var2) ((!(_var1) && !(_var2)) || ((_var1) && (_var2)))
				private "_shiftKeys";
				_shiftKeys = _x select 1;
				_match = (
					_c_booleansEqual(_shiftKeys select 0, _shiftKey) &&
					_c_booleansEqual(_shiftKeys select 1, _ctrlKey) &&
					_c_booleansEqual(_shiftKeys select 2, _altKey));
			};
		} forEach ICE_sqdMgt_keys;

		if (_match) exitWith
		{
			if ((time - ICE_sqdMgt_openDlgTime) > 0.8) exitWith
			{
				_handled = true;
				closeDialog 0;
			};
		};
	};

  _handled
};
//----------------------
/*
ICE_sqdMgt_onMouseZChanged =
{
	private['_control', '_zChange'];

	_control = _this select 0;
	_zChange = _this select 1;

	diag_log ["MouseZChanged", _zChange];
	if (_zChange != 0) then
	{
		[_control, -3 * _zChange] call ICE_sqdMgt_scrollPage;		
	};

	false
};
*/
//----------------------
ICE_sqdMgt_create =
{
  private ["_actionParams","_closeDialog","_parameters","_fn_ParamExists","_getParamByName"];
  _parameters = _this;
  _actionParams = [];

	if (!isNull findDisplay _c_SqdMgt_IDD) exitWith {hintSilent "(Squad Management Dialog is already open)"};
	if (!createDialog "ICE_SquadManagementDialog") exitWith { hint "createDialog failed" };
	
	(_c_IDC_slider call ICE_sqdMgt_getControl) sliderSetSpeed [3.334, 3.334];
	(_c_IDC_slider call ICE_sqdMgt_getControl) sliderSetRange [0, 5];

  // TODO: Fix: how to detect if parameters passed are from Action or execVM?
  if (count _parameters == 4) then
  {
    if (typeName (_parameters select 3) == "ARRAY") then
    {
      _actionParams = _parameters select 3;
      // Note: This may not actually be real Action Params, but so long as it's an array, it will generally work.
    };
  };
  //['SquadManagementDialog.sqf', ["ICE_sqdMgt_create _parameters=", _parameters]] call ICE_log;
  //['SquadManagementDialog.sqf', ["ICE_sqdMgt_create _actionParams=", _actionParams] call ICE_log;

  _fn_ParamExists =
  {
    private ["_exists","_paramName","_parameters","_actionParams"];
    _paramName = _this select 0;
    _parameters = _this select 1;
    _actionParams = _this select 2;
    
    _exists = ((_parameters find _paramName) > -1);
    if (! _exists) then
    {
      _exists = ((_actionParams find _paramName) > -1);
    };

    //['SquadManagementDialog.sqf', format ["_fn_ParamExists=%1=%2", _paramName, _exists]] call ICE_log;
    _exists;
  };

  // TODO: Fix bug: if any param is not an array (eg: "AllowPlayerInvites"), it will match it instantly. So array options like "Page" (obsolete) must be listed first.
  _getParamByName =
  {
    private ["_invalid","_result","_paramName","_default","_parameters","_actionParams"];
    _paramName = _this select 0;
    _default = _this select 1; // could be of any type (including object, string, etc)
    _parameters = _this select 2;
    _actionParams = _this select 3;

    _result = [_paramName, _parameters, _default] call ICE_sqdMgt_getParam;

    _invalid = false;
    //player sideChat format ["%1=%2 (%3)=%4 (%5)", _paramName, _default, typeName _default, _result, typeName _result]; // debug
    if (typeName _default != typeName _result) then
    {
      _invalid = true;
    }
    else
    {
      if (typeName _result != "OBJECT" || typeName _default != "OBJECT")
      then { _invalid = (_result == _default) }
      else { _invalid = ((isNull _default) && (isNull _result)) };
    };

    if (_invalid) then
    {
      _result = [_paramName, _actionParams, _default] call ICE_sqdMgt_getParam;
    };

    _result;
  };

	ICE_sqdMgt_showSquadHUDOnJoin = (["ShowSquadHUDOnJoin", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_DeleteRemovedAI = (["DeleteRemovedAI", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_AllowAILeaderSelect = (["AllowAILeaderSelect", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_AllowAIRecruitment = (["AllowAIRecruitment", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_AllowPlayerRecruitment = (["AllowPlayerRecruitment", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_AllowPlayerInvites = (["AllowPlayerInvites", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_ShowAIGroups = (["ShowAIGroups", _parameters, _actionParams] call _fn_ParamExists);
  ICE_sqdMgt_showRank = (["showRank", _parameters, _actionParams] call _fn_ParamExists);
	ICE_sqdMgt_QueryJoinAcceptance = (["QueryJoinAcceptance", _parameters, _actionParams] call _fn_ParamExists);
	ICE_sqdMgt_QuerySLAcceptance = (["QuerySLAcceptance", _parameters, _actionParams] call _fn_ParamExists);
	ICE_sqdMgt_AnySquadMemberCanOrganise = (["AnySquadMemberCanOrganise", _parameters, _actionParams] call _fn_ParamExists);
	ICE_sqdMgt_EnableCommanderSelection = (["EnableCommanderSelection", _parameters, _actionParams] call _fn_ParamExists);
	ICE_sqdMgt_SetRankForSL = (["SetRankForSL", _parameters, _actionParams] call _fn_ParamExists);	
	// TODO: add getVar checks to allow selected AI(/player?) groups to be included/excluded in grid list.

	ICE_sqdMgt_openDlgTime = time;
  (findDisplay _c_SqdMgt_IDD) displayAddEventHandler ["KeyDown", "_this call ICE_sqdMgt_local_keyDown"];
	
  call ICE_sqdMgt_LocalizeText;
	[] call ICE_sqdMgt_DrawPage;
	call ICE_sqdMgt_hideOkDialog;
};
//-----------------------------------------------------------------------------
ICE_sqdMgt_getControl =
{
  (findDisplay _c_SqdMgt_IDD) displayCtrl _this;
};
//-----------------------------------------------------------------------------
