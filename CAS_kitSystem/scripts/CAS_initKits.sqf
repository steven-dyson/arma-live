private ["_compile"];

_compile = [] execVM "CAS\CAS_kitSystem\CAS_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

if (isServer) then
{
	JDAM_SERVER_KIT_QUEUE = [];
	
	JDAM_KIT_TABLE = "RoadCone_F" createVehicle [0,0,-500]; //MP table (logic wont work for some reason)
	publicVariable "JDAM_KIT_TABLE";
	
	onPlayerDisconnected "JDAM_SERVER_KIT_QUEUE set [(count JDAM_SERVER_KIT_QUEUE), [[JDAM_KIT_TABLE, _uid], 2]];";
	
	_null = [] spawn PlayerKits_ServerKitThread;
};

if (!isDedicated) then
{
	JDAM_BUILD_ROOF_FINDER = "Logic" createVehicleLocal [0,0,0];
	JDAM_BUILDING_MENU_QUEUE = [];
	JDAM_BUILD_ARGUMENTS = [];
	
	// _null = [] spawn ClientBuildSystem_BuildVisualizer;
	
	private "_kit";
	_kit = "none";

	if (playerSide == west) then
	{
		//_null = [[player, (getPlayerUID player), JDAM_WEST_KIT_CRATE], "_null = _this spawn PlayerKits_AttachKit;", "SERVER"] spawn CAS_mpCB;
		_kit = "WestDefaultKit";
	};
	if (playerSide == east) then
	{
		//_null = [[player, (getPlayerUID player), JDAM_EAST_KIT_CRATE], "_null = _this spawn PlayerKits_AttachKit;", "SERVER"] spawn CAS_mpCB;
		_kit = "EastDefaultKit";
	};

	JDAM_CLIENT_KIT_QUEUE = [[[player, _kit], 1]];
	
	/*_null = player addEventHandler ["Killed", {
		call ClientBuildSystem_ClearBuildingActions;
	}];*/

	_null = player addEventHandler ["Respawn", {
		JDAM_CLIENT_KIT_QUEUE set [(count JDAM_CLIENT_KIT_QUEUE), [[_this select 0], 1]];
	}];
	
	_null = [] spawn PlayerKits_ClientKitThread;
};

[] call PlayerKits_LoadKits;
