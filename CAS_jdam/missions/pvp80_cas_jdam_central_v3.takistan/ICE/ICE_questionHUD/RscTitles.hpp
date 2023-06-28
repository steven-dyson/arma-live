
// Desc: Multiplayer Question HUD
//-----------------------------------------------------------------------------
#include "common.sqh"
#include "BaseClasses.hpp"

#define _x1 0.02
#define _w ((1.00-(2*_x1))*safeZoneW)
#define _h (0.024*safeZoneH)
#define _yOffset (3 * _h) // (0.10*safeZoneH) // show above chat messages

class ICE_QuestionHUD
{
	idd = -1;
	name = "ICE_QuestionHUD";
	duration = 33;
	onLoad = "uiNamespace setVariable ['ICE_questionHUD_Display', _this select 0]";
	//onUnload = "uiNamespace setVariable ['ICE_questionHUD_Display', displayNull]"; // not supported for rsc display HUD's

	class controls
	{
		class messageBackgroundBox: ICE_QuestionHUD_RscText
		{
			style = ST_HUD_BACKGROUND;

			colorBackground[] = {0,0,0,0.5};
			x = safeZoneX+_x1 * safeZoneW;
			y = safeZoneY+safeZoneH-_yOffset;
			w = _w;
			h = _yOffset - _h;
		};
		class message: ICE_QuestionHUD_RscStructuredText
		{
			idc = _c_IDC_main;

			sizeEx = _h;
			size = _h;
			colorBackground[] = {0,0,0,0};
			x = safeZoneX+_x1 * safeZoneW;
			y = safeZoneY+safeZoneH-_yOffset;
			w = _w;
			h = _yOffset - _h;

			class Attributes
			{
				font = __ICE_font1;
				color = "#ffffff";
				align = "right"; // change default to left
				shadow = 0;
			};
		};
	};
};
