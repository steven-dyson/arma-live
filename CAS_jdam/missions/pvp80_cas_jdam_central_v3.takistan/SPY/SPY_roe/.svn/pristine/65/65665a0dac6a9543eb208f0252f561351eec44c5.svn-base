/***************************************************************************
Review ROE
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_player", "_killer", "_pUID", "_pSide", "_kUID", "_kName", "_kSide", "_kScoreVar"];

_player = (_this select 0);
_killer = (_this select 1);

// Retrieve player information
_pUID = (_player getVariable "SPY_id_uid");
_pSide = (SPY_container getVariable ("SPY_id_" + _pUID) select 1);

// Retrieve killer information
_kUID = (_killer getVariable "SPY_id_uid");
_kName = (SPY_container getVariable ("SPY_id_" + _kUID) select 0);
_kSide = (SPY_container getVariable ("SPY_id_" + _kUID) select 1);
_kScoreVar = (format ["SPY_bStats_%1", _kUID]);

// Auto punish
if ((_pUID isEqualTo "")) exitWith
{
	_null = ["AUTO", _kScoreVar, _kUID] spawn SPY_punish;
};

// Team kill
if ((_pSide isEqualTo _kSide)) then
{
	_null = [_kName, _kScoreVar, _kUID] spawn SPY_punish;
};