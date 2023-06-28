/***************************************************************************
Play Demolitions Alarm Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Play Demo Alarm";

private ["_source", "_bp", "_alarmDelay"];

_source = (_this select 0);
_bp = (_this select 1);
	
_alarmDelay = 2;

while {(_bp getVariable "CAS_JDAM_chargeSet")} do {

	if ((isNil {_bp getVariable "CAS_JDAM_chargeSet"})) exitWith {};

	_source say3D "CAS_JDAM_fx_demoSet";
	
	sleep _alarmDelay;
	
	_alarmDelay = (_alarmDelay - 0.03);

};