/***************************************************************************
Punish
Created by Spyder
spyder@armalive.com
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_k", "_kName", "_kUID", "_vName", "_kVarName", "_timeOut", "_punish", "_forgive", "_addPunish", "_currentScore"];

_k = (_this select 0);
_kName = (_this select 1);
_kUID = (_this select 2);
_vName = (_this select 3);
_kIsAI = (_this select 4);

if ((_kIsAI)) exitWith { true };

_kVarName = ("SPY_roe_" + _kUID);
_timeOut = (time + SPY_roe_voteTimeout);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MANUAL PUNISH START
****************************************************************************/
if (!(_kName isEqualTo "Auto")) then
{
	waitUntil {sleep 0.1; (!(isNull(findDisplay 46)))};
		
	_null = [3, (format ["Press zeroing up/down to punish or forgive %1", _kName]), 2, ["SPY ROE", "Event Log"], false] spawn SPY_core_fnc_bMessage;

	_punish = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (([(_this select 1), 'ZeroingUp'] call SPY_core_fnc_isKey)) then {SPY_punishValue = true;}; ([(_this select 1), 'ZeroingUp'] call SPY_core_fnc_isKey);"];
	_forgive = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (([(_this select 1), 'ZeroingDown'] call SPY_core_fnc_isKey)) then {SPY_punishValue = false;}; ([(_this select 1), 'ZeroingUDown'] call SPY_core_fnc_isKey);"];
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
AUTO & TIMEOUT PUNISH START
****************************************************************************/
waitUntil { sleep 0.1; (!isNil "SPY_punishValue") || (time > _timeOut) || (SPY_roe_autoPunish) || (_kName in ["Auto"]) };

if ((time > _timeOut) || (SPY_roe_autoPunish) || (_kName in ["Auto"])) then
{
	SPY_punishValue = SPY_roe_defaultPunish;
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
Punish and forgive
****************************************************************************/
// Punished
if ((SPY_punishValue)) then
{
	// ALL CURRENT VALUES IN THE ARRAY
	_currentScore = (SPY_container getVariable _kVarName);

	// SET INCREASED VALUE IN ARRAY
	_currentScore set [0, ((_currentScore select 0) + 1)];

	// BROADCAST ARRAY
	SPY_container setVariable [_kVarName, _currentScore, true];
	
	// DISPLAY PUNISH MESSAGE
	_null = [[4, (format ["%1 punished you for an ROE violation", _vName]), 2, ["SPY ROE", "Event Log"], false], "SPY_core_fnc_bMessage", _k, false, false] call BIS_fnc_MP;
	
	if (!(_kName in ["Auto"])) then
	{
		_null = [3, (format ["You punished %1 for an ROE violation", _kName]), 1, ["SPY ROE", "Event Log"], false] spawn SPY_core_fnc_bMessage;
	};
};

// Forgiven
if (!(SPY_punishValue)) then
{
	// Display forgive message
	_null = [[3, (format ["%1 forgave you for an ROE violation", _vName]), 2, ["SPY ROE", "Event Log"], false], "SPY_core_fnc_bMessage", _k, false, false] call BIS_fnc_MP;

	if (!(_kName isEqualTo "Auto")) then
	{
		_null = [3, (format ["You forgave %1 for an ROE violation", _kName]), 0, ["SPY ROE", "Event Log"], false] spawn SPY_core_fnc_bMessage;
	};
};
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Terminate
****************************************************************************/
if (!(_kName isEqualTo "Auto")) then
{
	(findDisplay 46) displayRemoveEventHandler ["KeyDown", _punish];
	(findDisplay 46) displayRemoveEventHandler ["KeyDown", _forgive];
};

SPY_punishValue = nil;
/***************************************************************************
End
****************************************************************************/