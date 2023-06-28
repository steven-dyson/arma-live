/***************************************************************************
ENTRY TEXT
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_date", "_blackScreen", "_entryBlur"];

_topText = "MISSION ENHANCEMENT SYSTEM";
_date = (format ["%1 %2 %3", (date select 2), (date select 1), (date select 0)]);
_bottomText = "Created by Spyder";

_blackScreen = [] spawn {titleText ["", "BLACK FADED", 999];};

sleep 5;
	
// FADE IN
titleText ["", "BLACK IN", 5];

// BLUR EFFECT
_entryBlur = ppEffectCreate ["dynamicBlur", 450];
_entryBlur ppEffectEnable true;   
_entryBlur ppEffectAdjust [10];   
_entryBlur ppEffectCommit 0;

sleep 2;

// BLUR IN
_entryBlur ppEffectAdjust [0];  
_entryBlur ppEffectCommit 8;

// TEXT
[(str _topText) , (str _date), (str _bottomText)] spawn BIS_fnc_infoText;