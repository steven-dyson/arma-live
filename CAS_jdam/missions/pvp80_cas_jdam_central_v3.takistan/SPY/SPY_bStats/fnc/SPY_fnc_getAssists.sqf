/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Gets assisting units in kill from array of damagers and array of crew members

	Parameter(s):
		0: SIDE - victim or victim vehicle side
		1: STRING - killer UID
		2: ARRAY - damagers
		3: ARRAY - crew members from killers vehicle

	Returns:
	ARRAY - valid units to award kill assists to
*/

scriptName "SPY_bStats_fnc_getAssists";

private ["_xUnit", "_assists"];

_vSide = [_this, 0, CIVILIAN, [WEST]] call BIS_fnc_param;
_kUID = [_this, 1, "", [""]] call BIS_fnc_param;
_damagers = [_this, 2, [], [[]]] call BIS_fnc_param;
_crew = [_this, 3, [], [[]]] call BIS_fnc_param;

_assists = [];

// unit side != victim side and unit UID != killer UID and assignedVehicleRole != "CARGO"
{
	// Damagers is sent in an array format, return only the unit
	if ((typeName _x isEqualTo "ARRAY")) then
	{
		_xUnit = (_x select 0);
	}
	else
	{
		_xUnit = _x;
	};
	
	_xUID = _xUnit getVariable "SPY_id_uid";
	_xSide = (SPY_container getVariable format ["SPY_id_%1", _xUID] select 1);
	_xSeat = [assignedVehicleRole _xUnit, 0, "", [""]] call BIS_fnc_param;

	// Ensure possible assister is not of these qualities
	if (!(_xSide isEqualTo _vSide) and !(_xUID isEqualTo _kUID) and !(_xSeat isEqualTo "CARGO")) then 
	{
		_assists pushBack _xUnit;
	};
}
forEach (_damagers + _crew);

_assists