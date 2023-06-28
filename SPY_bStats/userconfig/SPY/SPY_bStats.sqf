/***************************************************************************
SPY INIT AND COMPILE (METHOD)
BSTATS SETTINGS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_settingsProcess"];

_settings = [

	["SPY_bStats_valhalla", false],
	["SPY_bStats_delayMsgTime", 0],
	["SPY_bStats_msgsEnabled", true],
	["SPY_bStats_scoreBoard", true],
	["SPY_bStats_balanceEnabled", true],
	["SPY_bStats_balanceNum", 5],
	["SPY_roePunish_enabled", true]

];

_settingsProcess = [_settings] spawn SPY_settingsProcess;

waitUntil {sleep 0.1; scriptDone _settingsProcess};