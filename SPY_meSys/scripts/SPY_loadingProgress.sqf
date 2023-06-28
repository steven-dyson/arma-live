/***************************************************************************
LOADING PROGRESS
Created by Spyder
spyder@armalive.com
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_loading", "_progress"];

SPY_LOADING_COMPLETE = false;

waitUntil {time > 0};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
PROGRESS BAR
****************************************************************************/	
startLoadingScreen ["", "SPY_loadingProgress"];

// DISABLE PLAYER CONTROL, GAME SOUND, ENVIROMENT, MESSAGES, AND ANIMATIONS
0 fadeSound 0;
(vehicle player) enableSimulation false;
enableEnvironment false ;
enableRadio false;
disableUserInput true;

// START MUSIC
_null = [] execVM "SPY\SPY_meSys\SPY_music.sqf";

// ARTIFICIAL LOADING PROGRESS
waitUntil {time > 2};
progressLoadingScreen 0.25;

waitUntil {time > 4};
progressLoadingScreen 0.50;

waitUntil {time > 6};
progressLoadingScreen 0.75;

waitUntil {time > 8};
progressLoadingScreen 1.00;
waitUntil {time > 10};

// ENABLE PLAYER CONTROL, GAME SOUND, ENVIROMENT, MESSAGES, AND ANIMATIONS
3 fadeSound 1;
(vehicle player) enableSimulation true;
enableEnvironment true;
enableRadio true;
disableUserInput false;

endLoadingScreen;

SPY_LOADING_COMPLETE = true;

// START ENTRY TEXT
_null = [] execVM "SPY\SPY_meSys\SPY_entryText.sqf";
/***************************************************************************
End
****************************************************************************/