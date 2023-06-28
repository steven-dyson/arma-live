/***************************************************************************
LOADING PROGRESS DIALOG
Created by Spyder
spyder@armalive.com
****************************************************************************/

class SPY_RscText {

	type = 0;
	idc = -1;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0x100; 
	font = Zeppelin32;
	SizeEx = 0.03921;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
	shadow = 0;
	
};

class SPY_RscActiveText {

	access=0;
	type=11;
	style=2;
	h=0.050000;
	w=0.150000;
	font="TahomaB";
	sizeEx=0.040000;
	color[]={1,1,1,1};
	colorActive[]={1,0.500000,0,1};
	soundEnter[]={"",0.100000,1};
	soundPush[]={"",0.100000,1};
	soundClick[]={"",0.100000,1};
	soundEscape[]={"",0.100000,1};
	text="";
	default=0;
	shadow = 0;
	
};

class SPY_RscPicture {

	access=0;
	type=0;
	idc=-1;
	style=48;
	colorBackground[]={0,0,0,0};
	colorText[]={1,1,1,1};
	font="TahomaB";
	sizeEx=0;
	lineSpacing=0;
	text="";
	shadow = 0;
	
};

class SPY_RscLoadingText : SPY_RscText {

	style = 2;
	x = 0.323532;
	y = 0.666672;
	w = 0.352944;
	h = 0.039216;
	sizeEx = 0.03921;
	colorText[] = {0.543,0.5742,0.4102,1.0};
	
};

class SPY_RscProgress {

	x = 0.344;
	y = 0.619;
	w = 0.313726;
	h = 0.0261438;
	texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
	colorFrame[] = {0,0,0,0};
	colorBar[] = {1,1,1,1};
	shadow = 2;
	
};

class SPY_loadingProgress {

	idd = -1;
	duration = 10e10;
	fadein = 0;
	fadeout = 0;
	name = "Loading Screen";

	class ControlsBackground {
	
		class Loading_BG : SPY_RscText {
		
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH;
			text = "";
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,1};
			
		}; 
		
		class Loading_CE2 : SPY_RscText {
		
			//style = 48;
			style = 48 + 0x800; // Keep aspect ratio
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH;
			text = "ca\missions_e\campaign\missions\CE7A_FinishingTouch.Takistan\img\loading08_finishingtouch_co.paa";
			
		};
		
	};
	
	class controls {
	
		class Title1 : SPY_RscLoadingText {
		
			idc = 951;
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH/6;
			text = Mission Loading...;
			colorText[] = {1,1,0.8,1};
			shadow = 2;
			
		};
		
		class CA_Progress : SPY_RscProgress {
		
			idc = 104;
			type = 8;
			style = 0;
			x = safezoneX + safezoneW/2 - 0.25;
			y = safezoneY + safezoneH/9;
			w = 0.5;
			h = 0.025;
			texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
			shadow = 2;
			
		};
		
	}; 
	
};