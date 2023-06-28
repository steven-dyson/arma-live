/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/

if ((!isServer)) then {

	private ["_compile"];

	_compile = [] execVM "CAS\CAS_core\CAS_mpcs\CAS_compile.sqf";
	waitUntil {sleep 0.1; scriptDone _compile};
	
	_null = [] execVM "CAS\CAS_core\CAS_mpcs\CAS_mpCEH.sqf";
	_null = [] execVM "CAS\CAS_core\CAS_mpcs\CAS_mpCEH_A.sqf";
	
};