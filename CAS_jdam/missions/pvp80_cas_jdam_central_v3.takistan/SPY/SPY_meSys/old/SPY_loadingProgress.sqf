/***************************************************************************
SPY Mission Resources (SPY Loading Progress)
Version: 0-2-0
SPY_loadingProgress.sqf
Created by: Spyder
15 Nov 2010
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
if (!isDedicated && time < 5) then {

	_delay = 0.1;
	_waitTime = time + _delay;

	// Inital value for progress bar
	_SPY_PROGRESS_CURR = 0;
	
	// Max value for progress bar, 100%
	_SPY_PROGRESS_MAX = 1.0;
	
	// waits until player is in game
	waitUntil {time > _waitTime};
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Progress Bar
****************************************************************************/
	// Disables player input
	disableUserInput true;

	// Play into music set in music section of init.sqf
	SPY_MUSIC_INTRO_START = true;
	
	// Starts the progrress bar
	StartLoadingScreen["", "SPY_loadingProgress"];

	// While loading isn't finished
	while {!SPY_LOADING_COMPLETE} do {

		// Set the current loading bar progress to it's current value and + 0.000001
		_SPY_PROGRESS_CURR = _SPY_PROGRESS_CURR + 0.0000008;
		
		// Progress the loading screen to previous
		progressLoadingScreen _SPY_PROGRESS_CURR;
		
		// When progress current reaches 100% end the loading screen
		if (_SPY_PROGRESS_CURR >= _SPY_PROGRESS_MAX) 
		
		then {
		
			endLoadingScreen; 
			SPY_LOADING_COMPLETE = true;
			
			// Re-enables player input
			disableUserInput false;
			
		};

	};
	
};
/***************************************************************************
End
****************************************************************************/