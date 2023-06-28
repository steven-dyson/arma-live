/***************************************************************************
DFS_scoreBoard.hpp
Created by Deadfast
29 MAY 2011
****************************************************************************/

class SPY_dlg_bg
{
	idc = -1;
	x = 0.0;
	y = 0.0;
	w = 1.0;
	h = 1.0;
	type = 0;
	style = 0;
	colorText[] = {1,1,1,0};
	colorBackground[] = {0.25,0.28,0.25,0.8};
	size = 0.023;
	sizeEx = 0.023;
	font = "Zeppelin32";
	text = "";
};
class SPY_dlg_text : SPY_dlg_bg
{
	h = 0.023;
	colorText[] = {1,1,1,1};
	colorBackground[] = {1,1,1,0};
	shadow = 2;  
};
class SPY_dlg_borderH : SPY_dlg_bg
{
	h = 0.002;
	colorBackground[] = {1,1,1,1};
};
class SPY_dlg_borderHThick : SPY_dlg_borderH
{
	h = 0.005;
};
class SPY_dlg_borderV : SPY_dlg_borderH
{
	w = 0.005*(4/3);
};
class SPY_dlg_ctrlGroup
{
	idc = -1;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	type = 15;
	style = 16;
	
	class Controls
	{
	};
	class ScrollBar
	{
		color[] = {1, 1, 1, 0};
		colorActive[] = {1, 1, 1, 0};
		colorDisabled[] = {1, 1, 1, 0};
		shadow = 0;
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
	class HScrollbar
	{
		color[] = {1, 1, 1, 0};
		height = 0.0;
		shadow = 0;
	};
	class VScrollbar
	{
		color[] = {1, 1, 1, 0};
		width = 0.0;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		shadow = 0;
	};
};
class SPY_dlg_nlb
{
	idc = -1;
	style = 16;
	type = 102;
	x = 0;
	y = 0;
	w = 0.4;
	h = 0.4;
	font = "Zeppelin32";
	sizeEx = 0.028;
	rowHeight = 0;
	colorText[] = {1, 1, 1, 1};
	colorScrollbar[] = {0.95, 0.95, 0.95, 1};
	colorSelect[] = {1, 1, 1, 1};
	colorSelect2[] = {1, 1, 1, 1};
	colorSelectBackground[] = {0.4, 0.4, 0.4, 0.5};
	colorSelectBackground2[] = {0.4, 0.4, 0.4, 0.5};
	colorBackground[] = {0, 0, 0, 1};
	maxHistoryDelay = 1;
	soundSelect[] = {"", 0.1, 1};
	period = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	drawSideArrows = 0;
	columns[] = {0.0, 0.5};
	idcLeft = -1;
	idcRight = -1;
	shadow = 2;
	color[] = {1, 1, 1, 1};
	
	class ScrollBar
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		shadow = 0;
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};
};


class SPY_dlg_stats
{
	idd = 201751;
	
	class ControlsBackground
	{
		class Header : SPY_dlg_ctrlGroup
		{
			x = "safeZoneX";
			y = "safeZoneY";
			w = "safeZoneW";
			#define __HeaderHeight 0.005+(0.01*4/3)+0.07+0.035+0.03+0.030+0.005
			h = __HeaderHeight+0.01;
			class Controls
			{
				class HeaderBg : SPY_dlg_bg
				{
					x = 0;
					y = 0;
					w = "safeZoneW";
					h = __HeaderHeight;
				};
				class HeaderBorderUp : SPY_dlg_borderHThick
				{
					x = 0;
					y = 0;
					w = "safeZoneW";
				};
				class HeaderBorderDown : HeaderBorderUp
				{
					y = __HeaderHeight;
				};
				class Title : SPY_dlg_text
				{
					x = 0.01;
					y = "0.005+(0.01*4/3)";
					w = "safeZoneW";
					h = 0.07;
					sizeEx = 0.07;
					font = "Zeppelin33";
					text = "SPY BATTLE STATISTICS";
				};
				class Subtitle : Title
				{
					idc = 1;
					y = "0.005+(0.01*4/3)+0.07";
					h = 0.035;
					sizeEx = 0.035;
					text = "ARMA 2 UPLINK RUNNING (CONNECTED TO MASTER DB)";
				};
				class Server : Subtitle
				{
					idc = 2;
					y = "0.005+(0.01*4/3)+0.07+0.035+0.03";
					h = 0.030;
					sizeEx = 0.030;
					font = "Zeppelin32";
					text = "SERVER NAME: %1";
				};
				class Time : Server
				{
					idc = 3;
					x = "safeZoneW/2-0.1";
					text = "GAME TIME: %1";
				};
				class Mission : Server
				{
					idc = 4;
					style = 1;
					x = -0.01;
					text = "MISSION NAME: %1";
				};
			};
		};
	};
	class Controls
	{
		class Side1 : SPY_dlg_ctrlGroup
		{
			x = "safeZoneX+0.01";
			#define __SideOffsetY 0.04
			y = safeZoneY+__HeaderHeight+__SideOffsetY;
			#define __SideWidth (safeZoneW/2-0.01*2)
			w = __SideWidth;
			#define __SideHeight (safeZoneH-(__HeaderHeight+__SideOffsetY*2))
			h = __SideHeight;
			class Controls
			{
				class Background : SPY_dlg_bg
				{
					x = 0;
					y = 0;
					w = __SideWidth;
					h = __SideHeight;
				};
				class Border : Background
				{
					x = __SideWidth-0.01;
					y = 0;
					h = __SideHeight;
					w = 0.01;
					colorBackground[] = {1,1,1,1};
				};
				class FrameUp : SPY_dlg_borderHThick
				{
					x = 0;
					y = 0;
					w = __SideWidth;
				};
				class FrameDown : FrameUp
				{
					y = __SideHeight-0.005;
				};
				class SideName : SPY_dlg_text
				{
					idc = 10;
					x = 0.01;
					y = 0.01;
					h = 0.045;
					sizeEx = 0.045;
					font = "Zeppelin33";
					text = "BLUFOR: %1";
				};
				class ScoreTotal : SideName
				{
					idc = 11;
					y = "0.01+0.045";
					h = 0.030;
					sizeEx = 0.030;
					text = "TOTAL SCORE: %1";
				};
				class ScoreKills : ScoreTotal
				{
					idc = 12;
					x = (__SideWidth/10)*4.5;
					text = "KILLS: %1";
				};
				class ScoreDeaths : ScoreTotal
				{
					idc = 13;
					x = (__SideWidth/10)*7;
					text = "DEATHS: %1";
				};
				class Separator1 : SPY_dlg_borderH
				{
					x = 0.005;
					y = "0.01+0.045+0.030";
					w = __SideWidth-0.01-0.005;
				};
				#define __StatsWidth (__SideWidth-0.01-0.01)
				#define __StatsRow(x) (0.01+__StatsWidth*0.34+__StatsWidth*0.07*x)
				class HintPlayer : ScoreTotal
				{
					style = 2;
					y = "0.01+0.045+0.030+0.01";
					w = __StatsWidth*0.33;
					h = 0.026;
					sizeEx = 0.026;
					text = "PLAYER";
					font = "Zeppelin32";
				};
				class HintX : HintPlayer
				{
					x = __StatsRow(0);
					w = __StatsWidth*0.07;
					text = "X";
				};
				class HintK : HintX
				{
					x = __StatsRow(1);
					text = "K";
				};
				class HintD : HintX
				{
					x = __StatsRow(2);
					text = "D";
				};
				class HintS : HintX
				{
					x = __StatsRow(3);
					text = "S";
				};
				class HintTK : HintX
				{
					x = __StatsRow(4);
					text = "TK";
				};
				class HintVK : HintX
				{
					x = __StatsRow(5);
					text = "VK";
				};
				class HintKA : HintX
				{
					x = __StatsRow(6);
					text = "KA";
				};
				class HintAC : HintX
				{
					x = __StatsRow(7);
					text = "AC";
				};
				class HintCC : HintX
				{
					x = __StatsRow(8);
					text = "CC";
				};
				class Separator2 : Separator1
				{
					y = "0.01+0.045+0.030+0.01+0.026+0.002";
				};
				class Stats : SPY_dlg_nlb
				{
					idc = 14;
					x = 0.01;
					y = "0.01+0.045+0.030+0.01+0.026+0.002+0.002";
					w = __StatsWidth;
					h = __SideHeight-(0.01+0.045+0.030+0.01+0.026+0.002+0.002)-0.005;
					columns[] = {0, 0.33, 0.40, 0.47, 0.54, 0.61, 0.68, 0.75, 0.82, 0.89};
				};
			};
		};
		class Side2 : Side1
		{
			x = 0.5;
			class Controls : Controls
			{
				class Background : Background {};
				class Border : Border {};
				class FrameUp : FrameUp {};
				class FrameDown : FrameDown {};
				class SideName : SideName
				{
					idc = 20;
					text = "OPFOR: %1";
				};
				class ScoreTotal : ScoreTotal
				{
					idc = 21;
				};
				class ScoreKills : ScoreKills
				{
					idc = 22;
				};
				class ScoreDeaths : ScoreDeaths
				{
					idc = 23;
				};
				class Separator1 : Separator1 {};
				class HintPlayer : HintPlayer {};
				class HintX : HintX {};
				class HintK : HintK {};
				class HintD : HintD {};
				class HintS : HintS {};
				class HintTK : HintTK {};
				class HintVK : HintVK {};
				class HintKA : HintKA {};
				class HintAC : HintAC {};
				class HintCC : HintCC {};
				class Separator2 : Separator2 {};
				class Stats : Stats
				{
					idc = 24;
					idcLeft = -2; //Has to have a different id than the other lnb due to a bug
					idcRight = -2;
				};
			};
		};
	};
};