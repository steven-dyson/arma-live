private "_code";
_code = _this select 0;

if (isServer) then {

	if (!isNil {JDAM_KIT_TABLE getVariable (_code select 6)}) exitWith {"DUPLICATE KIT NAME EXISTS!" createVehicleLocal [0,0,0];};
	JDAM_KIT_TABLE setVariable [(_code select 6), (_code select 5), true];
	
};

if (isDedicated) exitWith {};

_this spawn {

	private "_code";
	private "_crate";
	private "_listRank";
	private "_wait";
	private "_id";

	_code = _this select 0;
	_crate = _this select 1;
	_listRank = _this select 2;
	_wait = 1;
	_id = "none";

	waitUntil {!isNil "JDAM_KIT_TABLE"};
	waitUntil {!isNil {JDAM_KIT_TABLE getVariable (_code select 6)}};

	while {_wait == 1} do {
	
		_lastVal = JDAM_KIT_TABLE getVariable (_code select 6);
		
		if((typeName _id) != "STRING") then {
		
			_crate removeAction _id;
			
		};
		
		_id = _crate addAction [format ["%1 %2/%3", (_code select 0), _lastVal, (_code select 5)], "CAS\CAS_kitSystem\SelectKit.sqf", (_code select 6), _listRank];
		
		waitUntil {_lastVal != (JDAM_KIT_TABLE getVariable (_code select 6))};
		
	};
	
};