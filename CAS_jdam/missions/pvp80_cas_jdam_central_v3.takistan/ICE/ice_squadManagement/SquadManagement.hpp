// Desc: Squad Management dialog
// Features: Group joining, Squad Leader selection, fireteams, statistics
// By: Dr Eyeball
//-----------------------------------------------------------------------------
// ICE_sqdMgt_ is the unique prefix associated with all unique classes for the Squad Management dialog.
//-----------------------------------------------------------------------------
#ifndef __ICE_sqdMgt_SquadManagementDialog_hpp
#define __ICE_sqdMgt_SquadManagementDialog_hpp

#include "common.sqh"
//-----------------------------------------------------------------------------
#define _c_cmdrNameW 0.19

// buttons
#define _c_btn_y (_c_y + _c_h - (_c_controlHgt*5))

// message box constants
#define _c_mb_w (safeZoneW * 0.40)
#define _c_mb_h (safeZoneH * 0.30)
#define _c_mb_x (safeZoneX + safeZoneW * 0.32)
#define _c_mb_y (safeZoneY + safeZoneH * 0.30)
//-------------------------------------
// BaseClassesExtract.hpp depends on some values above like _c_controlHgt
#include "BaseClassesExtract.hpp"
//=============================================================================
class ICE_sqdMgt_RscGearShortcutButton: ICE_sqdMgt_RscShortcutButton
{
	style = _c_ST_LEFT;
	w = _c_gridArrowW;
	h = 0.0522876;
	size = 0.0522876*0.8;
	color[] = { 1, 1, 1, 1 };
	color2[] = { 1, 1, 1, 0.85 };
	colorBackground[] = { 1, 1, 1, 1 };
	colorbackground2[] = { 1, 1, 1, 0.85 };
	colorDisabled[] = { 1, 1, 1, 0.4 };
	class HitZone
	{
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	};
	class ShortcutPos
	{
		left = -0.006;
		top = -0.007;
		w = _c_gridArrowW;
		h = 0.0522876;
	};
	class TextPos
	{
		left = 0; //0.003;
		top = 0.001;
		right = 0;
		bottom = 0;
	};
#ifdef __ICE_armaGameVer2
	animTextureNormal = "\ca\ui\data\igui_gear_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\igui_gear_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\igui_gear_over_ca.paa";
	animTextureFocused = "\ca\ui\data\igui_gear_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\igui_gear_down_ca.paa";
	animTextureDefault = "\ca\ui\data\igui_gear_normal_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
#endif
	class Attributes
	{
		font = __ICE_font1;
		color = "#E5E5E5";
		align = "center";
		shadow = "true";
	};
};
//------------------
class ICE_sqdMgt_mainButton: ICE_sqdMgt_RscShortcutButton
{
	x = _c_x+_c_w+0.01;
	y = _c_btn_y;
	w = _c_mainButtonW;
#ifdef __ICE_armaGameVer2
	h = 1.5 * _c_controlHgt;
#endif
#ifdef __ICE_armaGameVer3
	h = _c_controlHgt;
#endif
};
class ICE_sqdMgt_subMenuButton: ICE_sqdMgt_mainButton
{
	x = -1.00;
	y = -1.00;
	w = _c_subMenuButtonW;
	h = _c_controlHgt;
	animTextureNormal = _c_basePath(data\buttonList\normal.paa);
	animTextureDisabled = _c_basePath(data\buttonList\disabled.paa);
	animTextureOver = _c_basePath(data\buttonList\over.paa);
	animTextureFocused = _c_basePath(data\buttonList\focused.paa);
	animTexturePressed = _c_basePath(data\buttonList\down.paa);
	animTextureDefault = _c_basePath(data\buttonList\default.paa);
	animTextureNoShortcut = _c_basePath(data\buttonList\normal.paa);
};

class ICE_sqdMgt_MiniButton: ICE_sqdMgt_subMenuButton
{
	x = 0;
	y = 0;
	w = safeZoneW*0.09;
	h = 0.85* _c_controlHgt;
	size = 0.7* _c_controlHgt;
};
//=============================================================================
#define ExpandMacro_GridControlsClasses(RowX) \
	class gridBG_##RowX: ICE_sqdMgt_RscText\
	{\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_GridBG;\
		x = _c_gb_x+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap;\
		w = _c_gb_w;\
		h = _c_rowsPerGrid * _c_controlHgt;\
	};\
	class gridCaption_##RowX: ICE_sqdMgt_Caption\
	{\
		moving = false;\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_GridCaption;\
		x = _c_gb_x+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap;\
		w = _c_gb_w;\
		text = "";\
	};\
	class gridFooter_##RowX: ICE_sqdMgt_Caption\
	{\
		moving = false;\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_GridFooter;\
		x = _c_gb_x+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap+_c_totalUpperGridHgt;\
		w = _c_gb_w;\
		text = "";\
	};\
	class gridJoinLeaveButton_##RowX: ICE_sqdMgt_MiniButton\
	{\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_GridJoinLeaveButton;\
		x = _c_gb_x+_c_gb_w-2*(0.01+0.05*safeZoneW)+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap+_c_totalUpperGridHgt+0.10* _c_controlHgt;\
		w = 0.05*safeZoneW;\
		text = "";\
		onButtonClick = "_this call ICE_sqdMgt_JoinLeaveGroup";\
	};\
	class gridNameButton_##RowX: ICE_sqdMgt_MiniButton\
	{\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_GridNameButton;\
		x = _c_gb_x+_c_gb_w-(0.01+0.05*safeZoneW)+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap+_c_totalUpperGridHgt+0.10* _c_controlHgt;\
		w = 0.05*safeZoneW;\
		text = "Name";\
		onButtonClick = "_this call ICE_sqdMgt_setGroupName";\
	};\
	class grid_##RowX: ICE_sqdMgt_RscListNBox\
	{\
		idc = _c_IDC_BaseValue+(##RowX*10)+_c_IDC_Grid;\
		style = 0 + _c_LB_TEXTURES;\
		x = _c_gb_x+(##RowX mod _c_gridsAcross)*_c_gb_widthAndGap;\
		y = _c_gb_y+_c_controlHgt+(floor (##RowX / _c_gridsAcross))*_c_totalGridHgtAndGap;\
		w = _c_gb_w;\
		h = _c_rowsPerGrid * _c_gridControlHgt;\
		sizeEx = _c_gridControlHgt;\
		columns[] = {\
			_c_gridArrowW+_c_innerGridW*0.00,\
			_c_gridArrowW+_c_innerGridW*0.15,\
			_c_gridArrowW+_c_innerGridW*0.30,\
			_c_gridArrowW+_c_innerGridW*0.45,\
			_c_gridArrowW+_c_innerGridW*0.60,\
			_c_gridArrowW+_c_innerGridW*0.75};\
		onLBSelChanged = "_this call ICE_sqdMgt_grid_onLBSelChanged";\
		onLBDblClick	= "_this call ICE_sqdMgt_grid_showMenu";\
		onSetFocus = "_this call ICE_sqdMgt_grid_onSetFocus";\
		onKillFocus = "_this call ICE_sqdMgt_grid_onKillFocus";\
		colorSelectBackground[] = {0,0,0,0};\
		lineSpacing = 1;\
		drawSideArrows = 1;\
		idcLeft = _c_IDC_GridLeftArrow;\
		idcRight = _c_IDC_GridRightArrow;\
	}
	
//=============================================================================
class ICE_SquadManagementDialog
{
	idd = _c_SqdMgt_IDD;
	movingEnable = 1;
	objects[] = {};
	//-----------------------------------------------------------------------------
	class controlsBackground
	{
/*
class tempGridBG: ICE_sqdMgt_FullBackground
{
	idc = -1;
			x = _c_x+(0.01+0.00)*safeZoneW;
			y = _c_y+(0.01+0.04)*safeZoneW;
			w = _c_w-(0.01+0.005)*safeZoneW*2;
			h = (0.63*safeZoneH);
	colorBackground[] = {0,0,1,0.4};
};
*/
		class BackgroundShade: ICE_sqdMgt_RscPicture
		{
			idc = -1;
			x = _c_x;
			y = _c_y2;
			w = _c_w;
			h = _c_h;
			text = _c_ui_background_full;
			moving = 0;
			//onMouseZChanged = "_this call ICE_sqdMgt_onMouseZChanged";
		};
		class WindowCaption: ICE_sqdMgt_windowCaption
		{
			idc = _c_IDC_FrameCaption;
			x = _c_x+0.03*safeZoneW+safeZoneW*0.06+safeZoneW*0.01;
			y = _c_y+0.005*safeZoneH;
			w = 0.7*safeZoneW;
			h = _c_controlHgt*1.5;
			sizeEx = _c_controlHgt*1.5;
			colorBackground[] = _c_colorAttribute_clear; // {1,1,1,0.1};
			text = "";
			moving = 1;
		};
		class unitInfo: ICE_sqdMgt_RscStructuredText
		{
			idc = _c_IDC_unitInfo;
			x = _c_x+(0.02 * safeZoneW);
			y = (_c_y + _c_h - (_c_controlHgt*4.9)); // top of bottom status bar
			w = _c_w * 0.55;
			h = _c_textHgt * 4;
			sizeEx = _c_textHgt * 1.0;
			text = "";
			colorBackground[] = {0,0,0,0};
			moving = 0;
		};
		class Flag: ICE_sqdMgt_RscPicture
		{
			idc = _c_IDC_Flag;
			style = _c_ST_PICTURE+_c_ST_KEEP_ASPECT_RATIO;
			x = _c_x+0.03*safeZoneW;
			y = _c_y-0.001*safeZoneH;
			w = safeZoneW*0.06;
			h = safeZoneH*0.06;
			moving = 0;
		};
	};
	//-----------------------------------------------------------------------------
	class controls
	{
		#define __fw (0.10 * safeZoneW)
		#define __fh (_c_textHgt * 0.9)
		class sliderPageNumber: ICE_sqdMgt_Caption
		{
			idc = _c_IDC_pageNumber;
			style = _c_ST_RIGHT;
			x = _c_x + _c_w - (0.03 * safeZoneW) - (0.15 * safeZoneW) - (0.01 * safeZoneW) - __fw;
			y = _c_gb_y + _c_gb_h - (0.01 * safeZoneH) - __fh;
			w = __fw;
			h = __fh;
			sizeEx = _c_textHgt * 1.0;
			text = "";
			colorBackground[] = _c_colorAttribute_clear;
		};
 		class slider
		{
			idc = _c_IDC_slider;

			type = _c_CT_XSLIDER;
			style = _c_SL_DIR+_c_LB_TEXTURES;

			// horizontal
			x = _c_x + _c_w - (0.03 * safeZoneW) - (0.15 * safeZoneW);
			y = _c_gb_y + _c_gb_h - (0.01 * safeZoneH) - __fh;
			w = (0.15 * safeZoneW);
			h = 0.02 * safeZoneH;

			vspacing = 1.5;

			shadow = 0; // 2
			colorActive[] = {0.7, 0.7, 0.7, 1}; // XSLIDER
			color[] = {0.5, 0.5, 0.5, 0.7}; // if XSLIDER (inactive)
			//color[] = {0.7, 0.7, 0.7, 1}; // if SLIDER (active)
			colorDisabled[] = {0.5, 0.5, 0.5, 0.3};
			colorBase[] = {0.5, 0, 0, 0.5}; // XSLIDER
			
			// horizontal XSLIDER
#ifdef __ICE_armaGameVer2
			arrowEmpty = "\ca\ui\data\ui_arrow_left_ca.paa";
			arrowFull = "\ca\ui\data\ui_arrow_left_active_ca.paa";
			border = "\ca\ui\data\ui_border_frame_ca.paa";
			thumb = "\ca\ui\data\ui_slider_bar_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
			arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
			thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
#endif

			onSliderPosChanged = "_this call ICE_sqdMgt_scrollPage";
			tooltip = "To scroll, use keys: PgUp, PgDn, Home, End.";
		};
		// grids
		ExpandMacro_GridControlsClasses(00);
		ExpandMacro_GridControlsClasses(01);
		ExpandMacro_GridControlsClasses(02);
		ExpandMacro_GridControlsClasses(03);
		ExpandMacro_GridControlsClasses(04);
		ExpandMacro_GridControlsClasses(05);
		//---------
		class leftArrow: ICE_sqdMgt_RscGearShortcutButton
		{
			idc = _c_IDC_GridLeftArrow;
			style = 2048;
			x = 0;
			y = +2.00;
			h = _c_textHgt;
			size = _c_textHgt;
			onButtonClick = "[] call ICE_sqdMgt_grid_showMenu;";
			text = "&lt;";
			colorBackground[] = {0,0,0,1};
		};
		class rightArrow: leftArrow
		{
			idc = _c_IDC_GridRightArrow;
			onButtonClick = "[] call ICE_sqdMgt_grid_showMenu;";
			text = "&gt;";
		};
		//---------

		//---------
		// start: subMenuButton's
		class NoOptionsButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_NoOptionsButton;
			text = "No Options";
			action = "";
		};

		class RecruitButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_RecruitButton;
			text = "Recruit";
			action = "call ICE_sqdMgt_Recruit";
		};

		class KickButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_KickButton;
			text = "Kick";
			action = "call ICE_sqdMgt_Kick";
		};

		class TagPlayerButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_TagPlayerButton;
			text = "Tag Player";
			action = "call ICE_sqdMgt_togglePlayerTag";
		};

		class UntagPlayerButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_UntagPlayerButton;
			text = "Untag Player";
			action = "call ICE_sqdMgt_togglePlayerTag";
		};

		class SetSLButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_SetSLButton;
			text = "New squad leader";
			action = "call ICE_sqdMgt_setSquadLeader";
		};

		class UnassignTeamButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_UnassignTeamButton;
			text = "Unassign Team";
			action = "[0] call ICE_sqdMgt_SetTeam";
		};

		class SetTeamLeaderButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_SetTeamLeaderButton;
			text = "Set team leader";
			action = "call ICE_sqdMgt_SetTeamLeader";
		};

		class SetTeam1Button: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_SetTeam1Button;
			text = "Set team Alpha";
			action = "[1] call ICE_sqdMgt_SetTeam";
		};

		class SetTeam2Button: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_SetTeam2Button;
			text = "Set team Bravo";
			action = "[2] call ICE_sqdMgt_SetTeam";
		};

		class SetTeam3Button: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_SetTeam3Button;
			text = "Set team Charlie";
			action = "[3] call ICE_sqdMgt_SetTeam";
		};

		class LockGroupButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_LockGroupButton;
			text = "Lock squad";
			tooltip = "Lock squad";
			action = "call ICE_sqdMgt_ToggleLockGroup";
		};
		class UnlockGroupButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_UnlockGroupButton;
			text = "Unlock squad";
			tooltip = "Unlock squad";
			action = "call ICE_sqdMgt_ToggleLockGroup";
		};

		class IncreaseGroupSizeLimitButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_IncreaseGroupSizeLimitButton;
			text = "Increase limit";
			tooltip = "Increase group size limit";
			action = "+1 call ICE_sqdMgt_changeGroupSizeLimit";
		};
		class DecreaseGroupSizeLimitButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_DecreaseGroupSizeLimitButton;
			text = "Decrease limit";
			tooltip = "Decrease group size limit";
			action = "-1 call ICE_sqdMgt_changeGroupSizeLimit";
		};

		class LockFTsButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_LockFTsButton;
			text = "Lock FT's";
			tooltip = "Lock fireteams, so that players cannot create or assign themselves to a FT.";
			action = "call ICE_sqdMgt_ToggleLockFTs";
		};
		class UnlockFTsButton: ICE_sqdMgt_subMenuButton
		{
			idc = _c_IDC_UnlockFTsButton;
			text = "Unlock FT's";
			tooltip = "Unlock fireteams, so that any player can create or assign themselves to a FT.";
			action = "call ICE_sqdMgt_ToggleLockFTs";
		};
		// end: subMenuButton's

		class CommanderName: ICE_sqdMgt_RscText
		{
			idc = _c_IDC_CommanderName;
			x = _c_x+_c_w-0.04-3*_c_mainButtonW-0.01;
			y = (_c_y + _c_h - (_c_controlHgt*3));
			w = _c_cmdrNameW * safeZoneW;
			colorBackground[] = {0,0,0,0.2};
		};
		/*
		class MyTeamButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_MyTeamButton;
			y = safeZoneY+safeZoneH-(0.01+_c_controlHgt)*9;
			text = "My team";
			default = true;
		};
		//---------
		class MyGroupButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_MyGroupButton;
			y = safeZoneY+safeZoneH-(0.01+_c_controlHgt)*8;
			text = "My group";
		};
		//---------
		class VehicleButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_VehicleButton;
			y = safeZoneY+safeZoneH-(0.01+_c_controlHgt)*7;
			text = "Vehicle";
		};
		//---------
		class OppositionButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_OppositionButton;
			y = safeZoneY+safeZoneH-(0.01+_c_controlHgt)*6;
			text = "Opposition";
		};
		//---------
		class CollapseAllButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_CollapseAllButton;
			y = safeZoneY+safeZoneH-(0.01+_c_controlHgt)*4;
			text = "Collapse all";
		};
		*/
		//---------
//[============================================================================
/*
// DEBUG BLOCK - testing 'units' & 'allUnits' JIP bug.
#define ICE_sqdMgt_SW ((safeZoneW - _c_w) * 0.5)
#define ICE_sqdMgt_SH 0.49
		//---------
		class text1: ICE_sqdMgt_RscText
		{
			idc = 988;
			x = safeZoneX+ICE_sqdMgt_SW*1.1;
			y = safeZoneY+0.05;
			w = safeZoneW-ICE_sqdMgt_SW*1.1*2;
			colorBackground[] = {0.2, 0.2, 0.2, 0.8};
		};
		//---------
		class border1: ICE_sqdMgt_RscText
		{
			x = safeZoneX;
			y = safeZoneY;
			w = ICE_sqdMgt_SW;
			h = safeZoneH *ICE_sqdMgt_SH;
			colorBackground[] = {0.2, 0.2, 0.2, 0.8};
		};
		class border2: border1
		{
			x = safeZoneX;
			y = safeZoneY + (safeZoneH *(ICE_sqdMgt_SH+0.01));
		};
		class border3: border1
		{
			x = safeZoneX+safeZoneW-ICE_sqdMgt_SW;
			y = safeZoneY;
		};
		class border4: border3
		{
			y = safeZoneY + (safeZoneH *(ICE_sqdMgt_SH+0.01));
		};
		//---------
		class debugAllGroups1: ICE_sqdMgt_RscListBox
		{
			style = 0 + _c_LB_TEXTURES;
			idc = 997;
			x = safeZoneX;
			y = safeZoneY;
			w = ICE_sqdMgt_SW;
			h = safeZoneH *ICE_sqdMgt_SH;
			sizeEx = 0.034;
			rowHeight = 0.034;
			//size = 0.034;
			onLBSelChanged = "ctrlSetText [988, ((_this select 0) lbText (lbCurSel (_this select 0)))]";
		};
		//---------
		class debugAllGroups2: debugAllGroups1
		{
			idc = 998;
			y = safeZoneY + (safeZoneH *(ICE_sqdMgt_SH+0.01));
		};
		//---------
		class debugAllUnits1: debugAllGroups1
		{
			idc = 933;
			x = safeZoneX+safeZoneW-ICE_sqdMgt_SW;
			y = safeZoneY;
			w = ICE_sqdMgt_SW;
			h = safeZoneH *ICE_sqdMgt_SH;
			sizeEx = 0.028;
			rowHeight = 0.028;
		};
		//---------
		class debugAllUnits2: debugAllUnits1
		{
			idc = 934;
			y = safeZoneY + (safeZoneH *(ICE_sqdMgt_SH+0.01));
		};
*/
//]============================================================================
		//---------
		class messageBoxBackground: ICE_sqdMgt_RscPicture
		{
			idc = _c_IDC_messageBoxBackground;
			style = _c_ST_PICTURE; //+_c_ST_KEEP_ASPECT_RATIO;
			x = _c_mb_x;
			y = _c_mb_y;
			w = _c_mb_w;
			h = _c_mb_h;		
			text = _c_ui_background_messagebox;
		};
		class messageBoxTitle: ICE_sqdMgt_Caption
		{
			idc = _c_IDC_messageBoxTitle;
			x	= _c_mb_x+(safeZoneW * 0.02);
			y = _c_mb_y+(safeZoneH * 0.03);
			w = _c_mb_w-safeZoneW * 0.02*2;
			h = _c_textHgt * 1.5;
			sizeEx = _c_textHgt * 1.5;
			text = "";
			colorBackground[] = _c_colorAttribute_clear;
		};
#define _c_mb_captionW (0.20 * _c_mb_w)
		class messageBoxCaption: ICE_sqdMgt_Caption
		{
			idc = _c_IDC_messageBoxCaption;
			style = _c_ST_RIGHT;
			x	= _c_mb_x+safeZoneW * 0.01;
			y = _c_mb_y+(safeZoneH * 0.09);
			w = _c_mb_captionW;
			h = _c_textHgt * 1.5;
			sizeEx = _c_textHgt * 1.5;
			text = "";
			colorBackground[] = _c_colorAttribute_clear;
		};
		class messageBoxEdit: ICE_sqdMgt_RscEdit
		{
			idc = _c_IDC_messageBoxEditBox;
			x	= _c_mb_x+(safeZoneW * 0.01)*2+_c_mb_captionW;
			y = _c_mb_y+(safeZoneH * 0.09);
			w = _c_mb_w-(safeZoneW * 0.01)*(3+5)-_c_mb_captionW; // bg image width doesn't fully reach width _c_mb_w, so +5
			onKillFocus = "_this call ICE_sqdMgt_squadName_onKillFocus";
		};
		class messageBoxText: ICE_sqdMgt_RscStructuredText
		{
			idc = _c_IDC_messageBoxText;
			x	= _c_mb_x+safeZoneW * 0.01;
			y = _c_mb_y+(safeZoneH * 0.09);
			w = _c_mb_w-safeZoneW * 0.01*2;
			h = _c_mb_h-3 * _c_controlHgt;
			text = "";
			size = _c_textHgt;
			lineSpacing = 1;

			class Attributes
			{
				font = __ICE_font1;
				color = "#ffffff";
				align = "left"; // change default to left
				shadow = 0;
			};
		};
		class messageBoxButton: ICE_sqdMgt_mainButton
		{
#define _c_local 0.20
			idc = _c_IDC_messageBoxButton;
			x = _c_mb_x + _c_mb_w/2 - (_c_local * _c_mb_w/2);
			y = _c_mb_y+(safeZoneH * 0.22);
			w = _c_local * _c_mb_w;
#ifdef __ICE_armaGameVer2
			h = 1.5 * _c_controlHgt;
#endif
#ifdef __ICE_armaGameVer3
			h = _c_controlHgt;
#endif
			size = _c_controlHgt;
			text = "Ok";
			action = "call ICE_sqdMgt_hideOkDialog";
			onKillFocus = "call ICE_sqdMgt_hideOkDialog";
			//default = true;
		};
		//---------
		class CommanderButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_CommanderButton;
			x = _c_x+_c_w-0.03-3*(_c_mainButtonW+0.01);
			y = _c_btn_y;
#ifdef __ICE_armaGameVer2
			h = _c_controlHgt*2;
#endif
#ifdef __ICE_armaGameVer3
			h = _c_controlHgt;
#endif
			//sizeEx = _c_controlHgt*2;
			size = _c_controlHgt*1.0;
			text = "Go commander";
			action = "call ICE_sqdMgt_setCommander";
		};
		class LeaveCommanderButton: CommanderButton
		{
			idc = _c_IDC_LeaveCommanderButton;
			text = "Leave Command";
			action = "call ICE_sqdMgt_leaveCommand";
size = _c_controlHgt*1.0;
		};

		class NewGroupButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_NewGroupButton;
			x = _c_x+_c_w-0.03-2*(_c_mainButtonW+0.01);
			y = _c_btn_y;
#ifdef __ICE_armaGameVer2
			h = _c_controlHgt*2;
#endif
#ifdef __ICE_armaGameVer3
			h = _c_controlHgt;
#endif
			//sizeEx = _c_controlHgt*2;
			size = _c_controlHgt*1.0;
			text = "New squad";
			action = "call ICE_sqdMgt_NewGroup";
		};
		class RefreshButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_RefreshButton;
			x = _c_x+_c_w-0.03-1*(_c_mainButtonW+0.01);
			y = _c_btn_y;
#ifdef __ICE_armaGameVer2
			h = _c_controlHgt*2;
#endif
#ifdef __ICE_armaGameVer3
			h = _c_controlHgt;
#endif
			//sizeEx = _c_controlHgt*2;
			size = _c_controlHgt*1.0;
			text = "Refresh";
			action = "call ICE_sqdMgt_DrawPage";
		};
		//---------
		class CloseButton: ICE_sqdMgt_mainButton
		{
			idc = _c_IDC_CloseButton;
			x = _c_x+_c_w-0.01-(safeZoneW*0.06);
			y = _c_y;
			w = safeZoneW*0.06;
			h = 1.5* _c_controlHgt;
			size = 1.5* _c_controlHgt;
#ifdef __ICE_armaGameVer2
			text = "<img image='\CA\ui\data\ui_task_failed_ca.paa'/>";
#endif
#ifdef __ICE_armaGameVer3
			text = "<img image='\a3\ui_f\data\map\Diary\Icons\taskfailed_ca.paa'/>";
#endif
			default = true;
			animTextureNormal = "";
			animTextureDisabled = "";
			animTextureOver = "";
			animTextureFocused = "";
			animTexturePressed = ""; //"\ca\ui\data\igui_gear_down_ca.paa";
			animTextureDefault = "";
		};
	};
};

#endif // __ICE_sqdMgt_SquadManagementDialog_hpp
