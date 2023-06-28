/***************************************************************************
Intro
Created by Spyder
spyder@armalive.com
****************************************************************************/

scriptName "SPY MeSys Intro Client";

private ["_sitrep"];

_pathVideo = (_this select 0);
_textUAV = (_this select 1);

SPY_introComplete = false;

//_video = ["CAS\CAS_JDAM\sounds\Jdamintro.ogv", false] spawn BIS_fnc_titlecard;
//waitUntil {sleep 0.1; (!isNil "BIS_fnc_titlecard_finished")};

titleText ["", "BLACK FADED", 999];

_video = [_pathVideo] spawn BIS_fnc_playVideo;

sleep 0.8;

titleText ["", "PLAIN"];

waitUntil {scriptDone _video};

// waitUntil {sleep 0.1; scriptDone _video};

_sitrep = [player, _textUAV, 100, 10, 0, 1] spawn BIS_fnc_establishingShot;
waitUntil {scriptDone _sitrep};

SPY_introComplete = true;