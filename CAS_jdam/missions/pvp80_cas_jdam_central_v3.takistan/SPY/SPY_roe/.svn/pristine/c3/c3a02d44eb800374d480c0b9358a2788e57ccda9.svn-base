/***************************************************************************
Gain Punish
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_pUID", "_varName", "_reset", "_banned", "_currentValues", "_punishes", "_locks", "_disabledTime", "_unlockTime", "_pName", "_uplink", "_punishTimeout", "_stackDelay"];

if ((!SPY_roe_enabled)) exitWith {};

_pUID = (player getVariable "SPY_id_uid");

_varName = (format ["SPY_roe_%1", _pUID]);
_reset = 1;
_banned = false;

while {true} do
{	
	// Inital ROE violation
	waitUntil { sleep 0.1; (((SPY_container getVariable _varName) select 0) > 0) };
	
	_reset = 0;
	_stackDelay = (time + 1);

	// While punish timeout has not reset values
	while {_reset == 0} do
	{
		_currentValues = (SPY_container getVariable _varName);
		_punishes = (_currentValues select 0);
		_locks = (_currentValues select 1);
		
		// ROE violation stacking penalty
		if ((_punishes > 1)) then
		{		
			if ((time < _stackDelay)) exitWith {};
			
			_punishes = ((_punishes - 1) * 3);
			SPY_container setVariable [_varName, [_punishes, _locks], true];
		};

		// excessive ROE violations
		if ((_punishes > SPY_roe_punishLimit)) then
		{
			_disabledTime = (_punishes * 10);
			_unlockTime = (time + _disabledTime);
			_pName = (SPY_container getVariable ("SPY_id_" + _pUID) select 0);
			
			// Add lock value
			_locks = (_locks + 1);
			SPY_container setVariable [_varName, [_punishes, _locks], true];
			
			// Add lock and check if ban is required
			if ((_locks >= SPY_roe_locksLimit) && (SPY_roe_banOnExcessiveLocks)) then
			{	
				// Attempt to ban violator from admin computer
				[[player, "Server", "Multiple ROE Violation Locks", "banned"], "SPY_connect_fnc_clientKick", true, false] call BIS_fnc_MP;
				
				// Post ROE ban to uplink
				// _uplink = (format ["bstats_roeban (%1, %2)", _pUID, time]);
				// _null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn CAS_mpCB;
				
				_banned = true;
			};
			
			// Send message to all clients (don't send flag if player is banned)
			if  (!(_banned)) then
			{
				_null = [[4, (format ["%1 is flagged for excessive ROE violations", _pName]), 0, ["SPY ROE", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP
			};
			
			// Post ROE flag to uplink
			//_uplink = (format ["bstats_roeflag (%1, %2)", _pUID, time]);
			//_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn CAS_mpCB;
			
			// Suspend here as player is banned already
			if ((_banned)) then
			{
				waitUntil {sleep 0.1; isNull player};
			};
			
			// Disable the users input for severity
			disableUserInput true;
			
			// Update remaining lock time on screen
			while {sleep 0.1; (time <= _unlockTime)} do
			{
				_null = [(format ["USER INPUT DISABLED FOR EXCESSIVE ROE VIOLATIONS (%1)", ([_unlockTime - time] call CAS_formatTime)]), 999, 999, true] spawn SPY_core_fnc_bInfoScreen;
				
				// Recheck for additional punishments that may have not processed
				_currentValues = (SPY_container getVariable _varName);
				
				if (((_currentValues select 0) != _punishes)) then
				{
					_punishes = (_currentValues select 0);
					_disabledTime = (_punishes * 10);
					_unlockTime = (time + _disabledTime);
				};
			};
			
			// Give player written warning
			_null = ["User input enabled, follow the ROE!", 5, 3, false] spawn SPY_core_fnc_bInfoScreen;
			
			sleep 10;
			
			// Re-enable user input
			disableUserInput false;
		};
		
		// Set punish reset timeout
		_punishTimeout = (time + SPY_roe_punishResetTimeout);
		
		// Wait for punish reset timeout or another event to occur
		waitUntil { sleep 0.1; (((SPY_container getVariable _varName) select 0) > _punishes) || (time > _punishTimeout) };
		
		// Reset punish value to 0 for good behavior
		if ((time > _punishTimeout)) then
		{
			_reset = 1;
			_currentScore = (SPY_container getVariable _varName);
			SPY_container setVariable [_varName, [0, 0], true];
		};
	};
};