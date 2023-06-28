/***************************************************************************
CAS JDAM ORP Deploy Client
Created by Spyder
spyder@armalive.com
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
private ["_player", "_side", "_var", "_orp", "_respawns", "_enemyNear"];

scriptName "CAS JDAM ORP Deploy Client";

_player = (_this select 1);

_side = (_player getVariable "SPY_id_player" select 2);
_var = (format ["CAS_JDAM_orp_%1", (groupID (group player))]);
_orp = (CAS_JDAM_tracker getVariable (_var + "_assigned"));
_respawns = (CAS_JDAM_tracker getVariable (_var + "_respawns"));
_object = (CAS_JDAM_tracker getVariable (_var + "_object"));

_enemyNear = false;
/***************************************************************************
Init
****************************************************************************/



/***************************************************************************
Non-deployment conditions
****************************************************************************/
// if ((isNil {(CAS_JDAM_tracker getVariable (_var + "_assigned"))})) exitWith {

	// _null = [3, "The squad leader needs a squad leader kit", "LOCAL", false] spawn SPY_bMessage;

// };

if ((isNil "_object")) exitWith {

	_null = [3, "Your squad ORP is not deployed", "LOCAL", false, 1] spawn SPY_bMessage;

};

if ((!alive _object)) exitWith {

	_null = [3, "Your squad ORP is not deployed", "LOCAL", false, 1] spawn SPY_bMessage;

};

if ((_respawns <= 0)) exitWith {

	_null = [3, "The ORP is out of deployments", "LOCAL", false, 1] spawn SPY_bMessage;

};

{

	if (!((_x getVariable "SPY_id_player" select 2) in [_side]) && (alive _x)) exitWith {
	
		_enemyNear = true;
		
	};

} forEach (nearestObjects [_object, ["CAManBase"], 100]);

if ((_enemyNear)) exitWith {

	_null = [3, "There are enemies near your ORP", "LOCAL", false, 1] spawn SPY_bMessage;

};
/***************************************************************************
Non-deployment conditions
****************************************************************************/



/***************************************************************************
Deploy player
****************************************************************************/
_player setPos [((getMarkerPos _orp select 0) + ((random 5) + 2)), ((getMarkerPos _orp select 1) + ((random 5) + 2)), 0];

CAS_JDAM_tracker setVariable [(_var + "_respawns"), (_respawns - 1), true];
/***************************************************************************
Deploy player
****************************************************************************/