/***************************************************************************
PATH
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

_number = 0;

for "_i" from 1 to 100 do {

	// NEXT OBJECT
	_number = (_number + 1);

	// FORMAT MARKER NAME
	_marker = (format ["cas_stunnel_path_%1", _number]);
	
	// EXIT IF MARKER IS NOT CREATED
	if (((getMarkerPos _marker select 0) == 0)) exitWith {player sideChat "EXIT";};
	
	// DEBUG
	player sideChat format ["PATH %1", _number];
	
	// MARKER DIRECTION
	_dir = (markerDir _marker);
	
	// CREATE OBJECT
	_object = "Land_A_Castle_Gate" createVehicle (getMarkerPos _marker);
	
	// SET OBJECT DIRECTION
	_object setDir _dir;

	// OBJECT WONT ACCEPT DAMAGE
	_object addEventHandler ["HandleDamage",{}];

	// SET OBJECT HEIGHT USING ASL
	_object setPosASL [(getPosASL _object select 0), (getPosASL _object select 1), 15000];

	// ROTATE FLAT
	_object setVectorUp [0, 0, 0.00001];

};