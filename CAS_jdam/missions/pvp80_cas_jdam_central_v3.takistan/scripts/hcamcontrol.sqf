/*
  Author: Tajin
  File: hcamcontrol.sqf
  Version: 0.15
  Date: 20130320
  Desc: Part of the helmetcam-script. Handles user input.
  Syntax: none
  - This is called by the eventhandler in "scripts\inithcam.sqf"
*/

disableSerialization;
private ["_key","_shift","_ctrl","_alt","_camtarget","_ct"];

_key = _this select 0;
_shift = _this select 1;
_ctrl = _this select 2;
_alt = _this select 3;

// Not the key we want? End the script!
if (_key != 55) exitWith {};	// 55 is * on your Numpad

// Player not wearing suitable Glasses? End the script!
if !( (goggles player) in hcam_goggles ) exitWith {};

_camtarget = player getVariable "HCamTarget";

if ( _camtarget < -1 ) then {
	nul = [0] execVM "scripts\helmetcam.sqf";
	_camtarget = -1;
};

if ( !_shift && !_ctrl && _alt ) then {	// ALT+* pressed
	player setVariable["HCamTarget",-1,true];  
};

if ( !_shift && !_ctrl && !_alt ) then {	// Only * pressed
	_camtarget = _camtarget + 1;
	if ( _camtarget >= count units (group player) ) then {
		_camtarget = 0;
	};
	_ct = (units group player) select _camtarget;
	hint format["Viewing %2: %1 ", name _ct,_camtarget+1];
	player setVariable["HCamTarget",_camtarget,true];
};