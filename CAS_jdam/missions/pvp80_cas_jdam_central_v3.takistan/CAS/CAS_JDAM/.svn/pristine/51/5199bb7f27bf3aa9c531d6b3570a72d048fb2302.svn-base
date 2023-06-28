/***************************************************************************
ACTION CONTAINERS CLIENT
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_cop", "_boat", "_fob"];

JDAM_WEST_KIT_CRATE addAction["<t color='#0000ff'>Scuba Gear</t>", "CAS\CAS_kitSystem\scuba\add_scubaWest.sqf", [], 100, false, true, "", ""];

{

	if ((_forEachIndex < 3)) then {

		_cop = "cop_west";
		_boat = "CAS_JDAM_mkr_boat_west";
		_fob = "respawn_west";

	} else {
	
		_cop = "cop_east";
		_boat = "CAS_JDAM_mkr_boat_east";
		_fob = "respawn_east";
	
	};

	_x addAction ["<t color=""#ff0033"">Deploy to ORP", "CAS\CAS_JDAM\orp\CAS_deploy_c.sqf", [], 100, false, true, "", ""];
	
	if (!(_x in [CAS_JDAM_obj_deploy_copWest, CAS_JDAM_obj_deploy_copEast])) then {

		_x addAction ["<t color=""#993300"">Deploy to COP", "CAS\CAS_JDAM\deploy\CAS_fastTravel_c.sqf", [_cop], 99, false, true, "", ""];
		
	};
	
	if (!(_x in [CAS_JDAM_obj_deploy_fobWest, CAS_JDAM_obj_deploy_fobEast])) then {
	
		_x addAction ["<t color=""#336600"">Deploy to FOB", "CAS\CAS_JDAM\deploy\CAS_fastTravel_c.sqf", [_fob], 98, false, true, "", ""];
		
	};
	
	if (!(_x in [CAS_JDAM_obj_deploy_boatWest, CAS_JDAM_obj_deploy_boatEast])) then {
	
		_x addAction ["<t color=""#0000ff"">Deploy to Boat Launch", "CAS\CAS_JDAM\deploy\CAS_fastTravel_c.sqf", [_boat], 97, false, true, "", ""];
		
	};

} forEach [CAS_JDAM_obj_deploy_fobWest, CAS_JDAM_obj_deploy_copWest, CAS_JDAM_obj_deploy_boatWest, CAS_JDAM_obj_deploy_fobEast, CAS_JDAM_obj_deploy_copEast, CAS_JDAM_obj_deploy_boatEast];

{

	// _null = [(_x select 0), 1000, 0, 0, ["Land", "Air"], false, (_x select 1)] execVM "AmmoHolder.sqf";

} forEach [[CAS_JDAM_obj_vsp_fobWest, west], [CAS_JDAM_obj_vsp_copWest, west], [CAS_JDAM_obj_vsp_fobEast, east], [CAS_JDAM_obj_vsp_copEast, east]];