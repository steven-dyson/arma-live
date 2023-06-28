private "_armData";
private "_vehicle";
private "_objectData";
private "_player";
private "_armStation";
	_armData = _this select 0;
				
	_vehicle = _armData select 1;
	_objectData = _armData select 2;
	_player = _armData select 3;
	_armStation = _armData select 4;
	
	if ((_armStation getVariable "ARM_STATION_K_CHARGES") < 1) exitWith {};
	_armStation setVariable ["ARM_STATION_K_CHARGES", ((_armStation getVariable "ARM_STATION_K_CHARGES") - 1), true];
	
	//_player setVariable ["CLIENT_PUBLIC_CODE", "_null = [] spawn AmmoHolder_Rearm", true];
	_null = [[], "_null = [] spawn AmmoHolder_Rearm;", (getPlayerUID _player)] spawn CAS_mpCB;