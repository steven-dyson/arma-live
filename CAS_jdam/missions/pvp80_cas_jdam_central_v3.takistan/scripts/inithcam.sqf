/*
  Author: Tajin
  File: inithcam.sqf
  Version: 0.1
  Date: 20130313
  Desc: Part of the helmetcam-script. Used to initialize the script.
  Syntax: nul = [] execVM "inithcam.sqf";
	- It's enough to put that line in your "init.sqf"
*/

// selection of glasses suitable for displaying the video feed
hcam_goggles = ["G_Tactical_Clear"];

// selection of helmets/headgear with cameras
hcam_headgear = ["H_HelmetB","H_HelmetB_paint"," H_HelmetB_light","H_HelmetO_ocamo","H_PilotHelmetHeli_B","H_PilotHelmetHeli_O"];

waitUntil {alive player};

player setVariable["HCamTarget",-999,false];  
if (!isDedicated) then {
	waitUntil { ! isNull (findDisplay 46) };
};
(findDisplay 46) displayAddEventHandler ["KeyDown"," nul=[_this select 1,_this select 2,_this select 3,_this select 4] execVM 'scripts\hcamcontrol.sqf'; "];