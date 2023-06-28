/***************************************************************************
Squad Leader Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM Init Squad Leader Client";

private ["_bpAction", "_orpAction"];

while {true} do {

	waitUntil {sleep 0.1; (((vehicle player) == player) && (alive player) && ((count (units (group player))) >= 1) && (player == (leader (group player))))};

	_bpAction = player addAction ["Deploy Battle Position", "CAS\CAS_JDAM\bp\CAS_build_c.sqf", [], 0, false, true, "", "(player == _target)"];
	_orpAction = player addAction ["Deploy Objective Rally Point", "CAS\CAS_JDAM\orp\CAS_build_c.sqf", [], 0, false, true, "", "(player == _target)"];
	
	waitUntil {sleep 0.1; (((vehicle player) != player) || (!alive player) || ((count (units (group player))) < 1) || (player != (leader (group player))))};
	
	player removeAction _bpAction;	
	player removeAction _orpAction;

};