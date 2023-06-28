/*
  Author: Tajin
  File: helmetcam.sqf
  Version: 0.3
  Date: 20130320
  Desc: Part of the helmetcam-script. Main part, controls the camera.
  Syntax: nul = [0] execVM "scripts\helmetcam.sqf";
  - Use the inithcam.sqf to launch this script
*/

private ["_camtarget","_ct","_old","_neck","_pilot","_target","_pos1","_pos2","_vx1","_vy1","_vz1","_dir","_tilt","_dive","_tz","_camOn"];

_camtarget = _this select 0;
player setVariable["HCamTarget",_camtarget,true];  
_ct = (units group player) select _camtarget;

// Init
_old = -1;
_neck = "Sign_Sphere10cm_F" createVehicleLocal position player;
_pilot = "Sign_Sphere10cm_F" createVehicleLocal position player;
_target = "Sign_Sphere10cm_F" createVehicleLocal position player;

hideObject _neck; 
hideObject _pilot; 
hideObject _target; 

_target attachTo [_neck,[0.5,10,0]];

[_ct,_target,player,0] call BIS_fnc_liveFeed;
waitUntil {BIS_liveFeed != ObjNull};
//

// adjust Camera offset & settings
BIS_liveFeed attachTo [_neck,[-0.18,0.08,0.05]];
BIS_liveFeed camSetFov 0.6;

// commit Changes
BIS_liveFeed camCommit 2;

// add color correction
"rendertarget0" setPiPEffect [3, 1, 0.8, 1, 0.1, [0.3, 0.3, 0.3, -0.1], [1.0, 0.0, 1.0, 1.0], [0, 0, 0, 0]];

_camOn = true;

// start cam-update loop
while {BIS_liveFeed != ObjNull} do {
	// get current Camtarget
	_camtarget = player getVariable "HCamTarget";
	
	// destroy camera and cancell the loop if player closes the liveFeed or takes off his tactical glasses.
	if ( (_camtarget == -1) ||  !( (goggles player) in hcam_goggles ) ) then {
		BIS_liveFeed cameraEffect ["TERMINATE", "BACK"];
		camDestroy BIS_liveFeed;
		["rendertarget0"] call BIS_fnc_PIP;
		BIS_liveFeed = nil;
	} else {
		// check if the camtarget has changed and update the camera
		_ct = (units group player) select _camtarget;
		if (_camtarget != _old) then {
			_neck attachTo [_ct,[0,0,0],"neck"];
			_pilot attachTo [_ct,[0,0,0],"pilot"];
			_old = _camtarget;
		};

		// check if camtarget has a suitable headgear
		if ( (headgear _ct) in hcam_headgear ) then {
			if (!_camOn) then {
				// Ok. Re-enable the camera
				BIS_liveFeed cameraEffect ["INTERNAL", "BACK","rendertarget0"];
				"rendertarget0" setPiPEffect [3, 1, 0.8, 1, 0.1, [0.3, 0.3, 0.3, -0.1], [1.0, 0.0, 1.0, 1.0], [0, 0, 0, 0]];
				_camOn = true;
			};
		} else {
			if (_camOn) then {
				// No valid headgear. Disable the camera
				BIS_liveFeed cameraEffect ["TERMINATE", "BACK"];
				_camOn = false;
			};
		};

		// Recalculate headposition of camtarget
		_pos1 = _ct worldToModel getPos _pilot;
		_pos2 = _ct worldToModel getPos _neck;

		_vx1 = (_pos1 select 0) - (_pos2 select 0);
		_vy1 = (_pos1 select 1) - (_pos2 select 1);
		_vz1 = (_pos1 select 2) - (_pos2 select 2);
		_dir = (_vx1 atan2 _vy1) - 25;
		// _tilt = (_vz1 atan2 _vx1) - 56.6;
		_dive = (_vy1 atan2 _vz1) + 35; 
		
		if ((sin _dive) == 0) then {_dive = _dive +1};
		_tz = ((1 / sin _dive) * cos _dive); 	

		// Update cameraposition
		_target attachTo [_neck,[0.5,10,_tz*10]];
		_neck setDir _dir;
		
		sleep 0.1;
	};
};

// loop ended, remove proxies
player setVariable["HCamTarget",-999,true];  
deleteVehicle _neck;
deleteVehicle _pilot;
deleteVehicle _target;