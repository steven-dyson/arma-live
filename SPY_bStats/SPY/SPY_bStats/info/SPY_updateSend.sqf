/***************************************************************************
UPDATE SEND
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_uid", "_playerSV"];

_uid = (getPlayerUID player);

// FORMAT PLAYER SCORE VARIABLE NAME
_playerSV = (format ["SPY_bStats_%1", _uid]);

// REBROADCAST PLAYER SCORE
SPY_GAMELOGIC setVariable [_playerSV, (SPY_GAMELOGIC getVariable _playerSV), true];

// REBROADCAST PLAYER ID
player setVariable ["SPY_PLAYER_ID", (player getVariable "SPY_PLAYER_ID"), true];