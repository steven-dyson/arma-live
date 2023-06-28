// Desc: Squad Management Dialog
//=============================================================================
//#ifndef _DFCC9_DialogFrameworkClasses_hpp_
//-----------------------------------------------------------------------------
#define _c_CT_STATIC 0 
#define _c_CT_BUTTON 1 
#define _c_CT_EDIT 2
#define _c_CT_SLIDER 3 
#define _c_CT_COMBO 4 
#define _c_CT_LISTBOX 5 
#define _c_CT_STRUCTURED_TEXT 13 
#define _c_CT_CONTROLS_GROUP 15 
#define _c_CT_SHORTCUT_BUTTON 16
#define _c_CT_XSLIDER 43 

// Static styles 
#define _c_ST_LEFT 0x00 
#define _c_ST_RIGHT 0x01 
#define _c_ST_CENTER 0x02 
#define _c_ST_MULTI 16

#define _c_ST_PICTURE 48 
#define _c_ST_FRAME 64 
#define _c_ST_SHADOW 0x100
#define _c_ST_KEEP_ASPECT_RATIO 0x800

// Slider styles
#define _c_SL_DIR 0x400
#define _c_SL_VERT 0
#define _c_SL_HORZ 0x400
#define _c_SL_TEXTURES 0x10

// Listbox styles
#define _c_LB_TEXTURES 0x10 // sets scrollbar to texture instead of box outline

#define _c_FontM __ICE_font2
//-----------------------------------------------------------------------------
#include "common.sqh"
//-----------------------------------------------------------------------------
class ICE_sqdMgt_RscText
{
  type = _c_CT_STATIC;
  idc = -1;
  style = _c_ST_LEFT+_c_ST_SHADOW;
  
  x = 0.0;
  y = 0.0;
  w = 0.3;
  h = _c_controlHgt;
  sizeEx = _c_textHgt;
  
  colorBackground[] = {_c_colorScheme_WindowBackground, 1};
  colorText[] = {_c_colorScheme_DialogText, 1};
  font = _c_FontM;
  
  text = "";
};
//-------------------------------------
class ICE_sqdMgt_RscEdit
{
  type = _c_CT_EDIT;
  idc = -1;
  style = _c_ST_LEFT;

  w = 0.1;
  h = _c_controlHgt;
  sizeEx = _c_textHgt;

  colorText[] = {_c_colorScheme_WindowText, 1};
  colorSelection[] = {_c_colorScheme_HighlightBackground, 1};
  colorBackground[] = {_c_colorScheme_3DControlBackground, 1}; // unused?
	colorDisabled[] = {1,1,1,0.25};
  font = _c_FontM;

  autoComplete = false;
  text = "";
};
//-------------------------------------
class ICE_sqdMgt_RscListNBox //: RscListNBox
{
	access = 0;
	type = 102;
	w = 0.4;
	h = 0.4;
	font = __ICE_font2;
	sizeEx = 0.04;
	rowHeight = 0;
	colorText[] = {0.8784,0.8471,0.651,1};
	colorScrollbar[] = {0.95,0.95,0.95,1};
	colorSelect[] = {0.95,0.95,0.95,1};
	colorSelect2[] = {0.95,0.95,0.95,1};
	colorSelectBackground[] = {0,0,0,1};
	colorSelectBackground2[] = {0.8784,0.8471,0.651,1};
	colorBackground[] = {0,0,0,1};
	maxHistoryDelay = 1;
	soundSelect[] = {"",0.1,1};
	period = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	drawSideArrows = 0;
	columns[] = {0.3,0.6,0.7};
	idcLeft = -1;
	idcRight = -1;
	class ScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		shadow = 0;
#ifdef __ICE_armaGameVer2
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
#endif
	};
	style = 16;
	shadow = 2;
	color[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
};
//-------------------------------------
class ICE_sqdMgt_RscStructuredText //: RscStructuredText
{
	idc = -1;
  type = _c_CT_STRUCTURED_TEXT;
  style = _c_ST_SHADOW+_c_ST_MULTI; // change default
  
	lineSpacing = 1;
	x = 0;
	y = 0;
	w = 0.1;
	h = 0.05;
	sizeEx = _c_controlHgt; // _c_textHgt ? // required for RscStructuredText?
  size = _c_textHgt;
	shadow = 2;

	colorText[] = {0.8784,0.8471,0.651,1};
	colorBackground[] = _c_colorAttribute_clear;

	text = "";

  class Attributes
  {
    font = _c_FontM;
    color = "#ffffff"; // default text colour
    align = "left"; // change default to left
    shadow = 1;
  };
};
//-------------------------------------
class ICE_sqdMgt_RscFrame
{
  type = _c_CT_STATIC;
  idc = -1;
  style = _c_ST_FRAME;

  x = 0.0;
  y = 0.0;
  w = 1.0;
  h = 1.0;
  sizeEx = _c_controlHgt;
  
  colorBackground[] = {_c_color_Red, 1}; // always clear?
  colorText[] = {_c_colorScheme_WindowText, 1};
  font = _c_FontM;

  text = "";
};
//-------------------------------------
class ICE_sqdMgt_RscButton
{
  type = _c_CT_BUTTON;
  idc = -1;
  style = _c_ST_CENTER;
  
  x = 0.0;
  y = 0.0;
  w = 0.1;
  h = _c_controlHgt;
  sizeEx = _c_textHgt;
  offsetX = 0;
  offsetY = 0;
  offsetPressedX = 0;
  offsetPressedY = 0;
  borderSize = 0.001;
  
  colorText[] = {_c_colorScheme_3DControlText,1};
  colorBackground[] = {_c_colorScheme_3DControlBackground, 1};
  colorFocused[] = {_c_colorScheme_3DControlFocus,1};

  colorShadow[] = {_c_color_Red,0.2};
  colorBorder[] = {_c_color_White,0.2};
  colorBackgroundActive[] = {_c_colorScheme_HighlightBackground,1.0};
  colorDisabled[] = {_c_color_Gray_7, 0.7};
  colorBackgroundDisabled[] = {_c_colorScheme_3DControlBackground,0.3};
  font = _c_FontM;

#ifdef __ICE_armaGameVer2
  soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
  soundPush[] = {"\ca\ui\data\sound\new1", 0.2, 1};
  soundClick[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
  soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};
#endif
#ifdef __ICE_armaGameVer3
	soundEnter[] = {"\A3\ui_f\data\sound\onover",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\new1",0,0};
	soundClick[] = {"\A3\ui_f\data\sound\onclick",0.07,1};
	soundEscape[] = {"\A3\ui_f\data\sound\onescape",0.09,1};
#endif

  default = false;
  text = "";
  action = "";
};
//-------------------------------------
class ICE_sqdMgt_RscShortcutButton: ICE_sqdMgt_RscButton
{
  type = _c_CT_SHORTCUT_BUTTON;

#ifdef __ICE_armaGameVer2
  h = 1.5* _c_controlHgt;
#endif
#ifdef __ICE_armaGameVer3
  h = _c_controlHgt;
#endif
  sizeEx = _c_controlHgt;
  size = _c_controlHgt;

	period = 0.4;
	periodFocus = 0.6;
	periodOver = 0.4;

	color[] = {0.95, 0.95, 0.95, 1};
	color2[] = {1, 1, 1, 0.4};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};

	class HitZone {
		left = 0.002;
		top = 0.003;
		right = 0.002;
		bottom = 0.003; //0.016;
	};
	
	class ShortcutPos {
		left = -0.006;
		top = -0.007;
		w = 0.0392157;
		h = 2* _c_controlHgt; //0.0522876;
	};
	
	class TextPos {
		left = 0.008; // indent
		top = 0.002;
		right = 0.002;
		bottom = 0.002; //0.016;
	};

	class Attributes {
		font = __ICE_font1;
		color = "#E5E5E5";
		align = "center";
		shadow = "true";
	};
	
	class AttributesImage {
		font = __ICE_font1;
		color = "#E5E5E5";
		align = "left";
	};

#ifdef __ICE_armaGameVer2
	animTextureNormal = "\ca\ui\data\igui_button_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\igui_button_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\igui_button_over_ca.paa";
	animTextureFocused = "\ca\ui\data\igui_button_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\igui_button_down_ca.paa";
	animTextureDefault = "\ca\ui\data\igui_button_normal_ca.paa";
	animTextureNoShortcut = "\ca\ui\data\igui_button_normal_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
	animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
	animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
	animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
	animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";
#endif
	textureNoShortcut = ""; // valid property?
};
//-------------------------------------
class ICE_sqdMgt_RscLB_LIST
{
  // type = defined in derived class
  idc = -1;
  style = _c_ST_LEFT;

  x = 0.1;
  y = 0.1;
  w = 0.2;
  h = _c_controlHgt;
  sizeEx = _c_textHgt;
  rowHeight = _c_textHgt;

  color[] = {_c_color_White,1};
  colorText[] = {_c_colorScheme_WindowText,1};
  colorBackground[] = {_c_colorScheme_WindowBackground, 1}; // always clear?
  colorSelect[] = {_c_colorScheme_WindowText,1};
  colorSelect2[] = {_c_colorScheme_WindowText,1};
  colorScrollbar[] = {_c_color_White,1};
  colorSelectBackground[] = {_c_colorScheme_3DControlBackground,1};
  colorSelectBackground2[] = {_c_colorScheme_HighlightBackground,1};
  font = _c_FontM;
  
#ifdef __ICE_armaGameVer2
	arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";

  soundSelect[] = {"\ca\ui\data\sound\mouse3", 0.2, 1};
  soundExpand[] = {"\ca\ui\data\sound\mouse2", 0.2, 1};
  soundCollapse[] = {"\ca\ui\data\sound\mouse1", 0.2, 1};
#endif
#ifdef __ICE_armaGameVer3
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";

	soundSelect[] = {"",0.1,1};
#endif

  maxHistoryDelay = 1.0;

	class ScrollBar
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
#ifdef __ICE_armaGameVer2
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
#endif
	};
};
//-------------------------------------
class ICE_sqdMgt_RscListBox: ICE_sqdMgt_RscLB_LIST
{
  type = _c_CT_LISTBOX;

	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;
};
//-------------------------------------
class ICE_sqdMgt_RscCombo: ICE_sqdMgt_RscLB_LIST
{
  type = _c_CT_COMBO;

  wholeHeight = 0.3;

  colorSelectBackground[] = {ICE_c_colorScheme_3DControlFocus,1};
};
//-------------------------------------
class ICE_sqdMgt_RscPicture
{
	type = _c_CT_STATIC;
	idc = -1;
	style = _c_ST_PICTURE;

	sizeEx = _c_textHgt;

	colorBackground[] = _c_colorAttribute_clear;
	colorText[] = {_c_colorScheme_WindowText, 1};
	font = _c_FontM;

  text = "";
};
//-------------------------------------
class ICE_sqdMgt_FullBackground: ICE_sqdMgt_RscText
{
  x = safeZoneX;
  y = safeZoneY;
  w = safeZoneW;
  h = safeZoneH;

  colorBackground[] = {_c_colorScheme_DialogBackground,0.9};
};
//-------------------------------------
class ICE_sqdMgt_FullBackgroundFrame: ICE_sqdMgt_RscFrame
{
  x = safeZoneX;
  y = safeZoneY;
  w = safeZoneW;
  h = safeZoneH;

  text = " Dialog ";
};
//-------------------------------------
class ICE_sqdMgt_Caption: ICE_sqdMgt_RscText
{
  //TODO style = ST_HUD_BACKGROUND+ST_LEFT;
  x = 0.0;
  y = 0.0;
  w = 0.3;

  colorBackground[] = {_c_colorScheme_CaptionBackground, 1};
  colorText[] = {_c_colorScheme_CaptionText, 1};
};
//-------------------------------------
class ICE_sqdMgt_windowCaption: ICE_sqdMgt_Caption
{
  moving = true;
  x = safeZoneX;
  y = safeZoneY;
  w = safeZoneW;
};
//-------------------------------------
class ICE_sqdMgt_RscSlider
{
	idc = -1;
	type = _c_CT_SLIDER;
  style = 0; //1024;

	sizeEx = 0.025;
  w = 0.025;
  h = 0.80;
  color[] = {1,1,1,0.8};
  colorActive[] = {1,1,1,1};
};
//-------------------------------------
class ICE_sqdMgt_RscXSliderH
{
	type = _c_CT_XSLIDER;
	style = "0x400 + 0x10";
	x = 0;
	y = 0;
	h = 0.03;
	w = 0.40;
	color[] = {1,1,1,0.4};
	colorActive[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.2};
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
};
//-------------------------------------
/*
class ICE_sqdMgt_RscControlsGroup: RscControlsGroup
{
	idc = -1;
	type = _c_CT_CONTROLS_GROUP;
  style = 0 + _c_LB_TEXTURES;
  
  x = 0.1;
  y = 0.1;
  w = 0.3;
  h = 0.3;
  
  class VScrollbar
  {
    color[] = {1,1,1,1};
    width = 0.014*safeZoneW;
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
  };
  class HScrollbar
  {
    color[] = {1,1,1,1};
    height = 0.018*safeZoneH;
  };
	class ScrollBar
	{
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
#ifdef __ICE_armaGameVer2
		thumb = "\ca\ui\data\igui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\igui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\igui_arrow_top_ca.paa";
		border = "\ca\ui\data\igui_border_scroll_ca.paa";
#endif
#ifdef __ICE_armaGameVer3
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
#endif
	};

  class Controls {};
};
*/
//-----------------------------------------------------------------------------
//#endif // _DFCC9_DialogFrameworkClasses_hpp_
