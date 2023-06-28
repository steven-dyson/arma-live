/***************************************************************************
SPY Mission Resources (SPY Music)
Version: 0-1-0
SPY_music.sqf
Created by: Spyder
15 Nov 2010
****************************************************************************/



/***************************************************************************
Intro program
****************************************************************************/
if (!isDedicated) then {

	// Sets up delay
	_delay = 2;
	_waitTime = time + _delay;

	// Wait until you want music to start. (Delay if heavy scripting causes pauses in music)
	waitUntil {SPY_MUSIC_INTRO_START && time > _waitTime};
	
	// Play music defined in init.sqf (music fades in from a 0 volume)
	0 fadeMusic 0;
	3 fadeMusic 0.4;
	playMusic SPY_MUSIC_INTRO;

	// Fade to 50 percent, delay set in init.sqf
	sleep SPY_MUSIC_LOWER;
	3 fadeMusic 0.2;

	// Turn off music, delay set in init.sqf
	sleep SPY_MUSIC_OFF;
	3 fadeMusic 0;
	
	// Set to false for later use
	SPY_MUSIC_INTRO_START = false;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Outro Program (Will have resource done for next release)
****************************************************************************/
	// Wait until you want music to start
	waitUntil {SPY_MUSIC_OUTRO_START};
	
	// Play music defined in init.sqf (music fades in from a 0 volume)
	0 fadeMusic 0;
	3 fadeMusic 0.4;
	playMusic SPY_MUSIC_OUTRO;

	// Fade to 50 percent, delay set in init.sqf
	sleep SPY_MUSIC_LOWER;
	3 fadeMusic 0.2;

	// Turn off music, delay set in init.sqf
	sleep SPY_MUSIC_OFF;
	3 fadeMusic 0;
	
	// Set to false for later use
	SPY_MUSIC_OUTRO_START = false;

};
/***************************************************************************
End
****************************************************************************/