/***************************************************************************
SPY BATTLE STATISTICS
VERSION: 1.0.8.395
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
WWW.ARMALIVE.COM
***************************************************************************/



/***************************************************************************
EULA (END USER LICENSE AGREEMENT)
***************************************************************************/
By downloading this file, you are accepting the EULA. SPY bStats (Battle Statistics) is a mission resource created by Spyder.
You can not modify any part of bStats (to include any JDAM or MHJ resources) for any reason without permission from the 
author(s). The user has the right to implement this resource into their mission at their own risk.
/***************************************************************************

***************************************************************************/



/***************************************************************************
ARMA LIVE STATISTICS (WWW.ARMALIVE.COM)
***************************************************************************/
If you wish to use your mission with bStats and MHJ ArmA 2 Uplink (A2U), feel free to contact ALS Staff at staff@armalive.com.
/***************************************************************************

***************************************************************************/



/***************************************************************************
INSTALLATION INSTRUCTIONS
***************************************************************************/
bStats

	I. Add the included userconfig file to your ArmA directory (server settings are in SPY_bStats.sqf).

	II. Add SPY, MHJ, and JDAM folders to mission directory.
	
	III. Modify init.sqf and description.ext.

		A. Copy the code from your init.sqf into the included bStats init.sqf under the MISSION SCRIPTS section intentionally left blank.

		B. Add include to your description.ext - #include "SPY\SPY_bStats\score\DFS_bStatsDlg.hpp"

A2U (Dedicated Server Boxes and Virtual Private Servers)

	I. Install luaforwindows on server (http://code.google.com/p/luaforwindows/downloads/list).
	
	II. Install A2U Folder *NOT in ArmA Directory* (https://dev-heaven.net/projects/a2uplink/files).

	III. Modify A2U config.lua:

		- inputmode: Set to "file"
		- inputfile: Path to your armaoaserver.rpt (ie C:\Users\User\Documents\ArmA 2 OA\arma2oaserver.RPT)
		- bstats_master_servername: Assigned by ALS staff (contact ALS staff for assigned username)
		- bstats_master_password: Assigned by ALS staff (contact ALS staff for assigned password)

A2U (Hosted ArmA Server)

	I. Contact ALS staff

*** ALS Staff: staff@armalive.com
/***************************************************************************

***************************************************************************/



/***************************************************************************
CREDITS
***************************************************************************/
Spyder - Author, ArmA Live Statistics (XHTML), JDAM Scripting
Mahuja - ArmA 2 Uplink, ArmA Live Statistics (Database), ArmA Script Instruction, Testing, JDAM Scripting
Hooves - Testing, Feature Suggestions, & Public Relations
Dragon - Testing
Dinky - ArmA Live Statistics (Website Features)
VMA - Testing
Deadfast - Created Score Dialog
Dr Eyeball - Scripting Suggestions
kju - Scripting Suggestions
Squint (sbsmac) - Error Checking
Ugly58 - Feature Suggestions
Goschie - JDAM Scripting
All the unnamed testers
/***************************************************************************

***************************************************************************/