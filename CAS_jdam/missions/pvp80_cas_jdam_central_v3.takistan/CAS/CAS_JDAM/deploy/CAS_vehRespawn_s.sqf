private ["_vehicle", "_spawntime", "_side", "_destroyedOnly", "_initLine", "_startpos", "_type", "_inside", "_tseconds", "_meters", "_eventdone", "_eventnumber", "_zonesize", "_identitypos", "_wait"];

_vehicle = _this select 0;

if (isServer) then {
	
	_spawntime = _this select 1;
	_side = _this select 2;
	_destroyedOnly = _this select 3;
	_initLine = _this select 4;
	
	// _initLine = format ["%1; this disableTIEquipment true", _initLine];
	
	_startpos = getPos _vehicle;
	_type = typeOf _vehicle;
	_dir = (direction _vehicle);
	_inside = 0;
	_tseconds = 0;
	_meters = 0;
	_eventdone = 0;
	_eventnumber = 0;
	_zonesize = 5;
	_identityPos = "";
	
	{
		
		_identityPos = format ["%2-%1", _x, _identityPos];
		
	} foreach _startpos;
	
	_vehicle setVariable ["RESPAWN_IDENTITY_POS", _identityPos];
	_wait = 1;
	
	while {_wait == 1} do {
		
		_inside = 0;
		_tseconds = 0;
		
		_meters = _vehicle distance _startpos;
		
		//if ((_meters <= _zonesize) && (_eventdone == 0)) then
		//{
		//	_eventnumber = _vehicle addEventHandler ["HandleDamage", {false}];
		//	_eventdone = 1;
		//};
		//if ((_meters > _zonesize) && (_eventdone == 1)) then
		//{
		//	_vehicle removeEventHandler ["HandleDamage", _eventnumber];
		//	_eventdone = 0;
		//};
								
		if ((!alive _vehicle) && (!isNull _vehicle)) then {
			
			sleep _spawntime;
			
			deleteVehicle _vehicle;
			_vehicle = _type createVehicle _startpos;
			_vehicle setPos _startpos;
			_vehicle setDir _dir;
			_vehicle setVariable ["RESPAWN_IDENTITY_POS", _identityPos];
			
			if (_initLine != "") then {
				
				//_vehicle setVehicleInit _initLine;
				//processInitCommands;
				
			};
			
			_eventdone = 0;
			
		};
		
		if (!(_destroyedOnly)) then {
			
			if (((_meters > _zonesize) || ((getDammage _vehicle) != 0)) && (!isNull _vehicle)) then {

				_people = crew _vehicle;
				_inside = {_x isKindOf "Man"} count _people;

				while {(_tseconds <= (_spawntime * 4)) && (_inside == 0) && (alive _vehicle) && (!(isNull _vehicle))} do {

					sleep 1;

					_people = crew _vehicle;
					_inside = {_x isKindOf "Man"} count _people;
					_tseconds = _tseconds + 1;

				};

				if ((_inside < 1) && (alive _vehicle) && (!(isNull _vehicle))) then {

					deleteVehicle _vehicle;
					_vehicle = _type createVehicle _startpos;
					_vehicle setPos _startpos;
					_vehicle setDir _dir;
					_vehicle setVariable ["RESPAWN_IDENTITY_POS", _identityPos];

					if (_initLine != "") then {

						// _vehicle setVehicleInit _initLine;
						// processInitCommands;

					};

					_eventdone = 0;

				};

			};
		
		};
		
		if (isNull _vehicle) then {
			
			private ["_i"];
			
			_i = 1;
			
			while {_i == 1} do {
				
				{
					
					if (!(isNil {_x getVariable "RESPAWN_IDENTITY_POS"})) then {
						
						if ((_x getVariable "RESPAWN_IDENTITY_POS") == _identityPos) then {
							
							_i = 0;
							_vehicle = _x;
							
						};
						
					};
					
				} foreach vehicles;
				
				sleep 0.25;
				
			};
			
		};
		
		sleep 1;
		
	};
	10
};