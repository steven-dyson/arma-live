
#define _c_CT_STATIC 0 
#define _c_CT_STRUCTURED_TEXT 13 

// Static styles 
#define _c_ST_LEFT 0x00 
#define _c_ST_RIGHT 0x01 
#define _c_ST_CENTER 0x02 
#define _c_ST_MULTI 16

#define _c_ST_SHADOW 0x100

#define _c_FontM __ICE_font2

#define _c_TEXTHGT_MOD 0.76
#define _c_screenRows 34
#define _c_controlHgt ((safeZoneH * 100 / _c_screenRows) / 100)
#define _c_textHgt (_c_controlHgt * _c_TEXTHGT_MOD)

#define _c_colorAttribute_clear {0, 0, 0, 0}
#define _c_colorScheme_DialogText 1,1,1 // _c_color_white
#define _c_colorScheme_WindowBackground 40/256, 51/256, 34/256 // A2 Dark green bg
//-----------------------------------------------------------------------------
class ICE_QuestionHUD_RscText
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
class ICE_QuestionHUD_RscStructuredText //: RscStructuredText
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
