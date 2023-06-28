================================================================================
Squad Management Dialog - for ArmA 2
================================================================================

--------------------------------------------------------------------------------
LICENCE
--------------------------------------------------------------------------------

The use of this system/addon is at your own risk. The author(s) are not responsible for any damage or problems caused to your PC or your game installation.

The scripts source code is prohibited to be used in any commercial or military product, without written permission from the author.

Credit original author when including the system in a mission or addon compilation.

--------------------------------------------------------------------------------
FEATURES
--------------------------------------------------------------------------------

- Separation of lone/single players as "Unassigned" (rather than showing a group for each).
- Squad creation (group) - even with 1 player
- Squad (group) joining
- Squad leader (SL) selection
- Fire team leader (FTL) selection
- Up to 3 Fireteams
- Display of main gear for each player.
- Custom squad info/names, both public (by SL) and private (for self). Also useful for ACRE (eg: chan#3), squad purpose (eg: armour), etc.
- Custom faction (side) flag and name
- other stuff

--------------------------------------------------------------------------------
DEPENDENCIES
--------------------------------------------------------------------------------

- it is advisable to use @CBA addons to enable full functionality. (It might be possible to set up this system without the dependency. Also, it is possible to set up this system along side other @ICE addons without @CBA. So it is up to the mission maker.)

--------------------------------------------------------------------------------
LIMITATIONS & KNOWN ISSUES
--------------------------------------------------------------------------------

- sometimes if you use Request to join a squad, the Yes/No Question box appears for a random squad member of that squad, rather than the SL. Unsure why this is happening. Might need to find a total workaround using group vars, since the code looks fine.
- the sound files are only in the addon version and are excluded from the mission-based version. They are optional anyway.

--------------------------------------------------------------------------------
USAGE (adding system to your mission)
--------------------------------------------------------------------------------

To incoporate the Squad Management Dialog as part of your mission using scripts, do the following:

- copy the "ice_squadManagement" folder to your mission folder

- in StringTable.csv, add:
  #include "ice_squadManagement\stringtable.csv"

- in description.ext, add:
  #include "ice_squadManagement\SquadManagement.hpp"

- in init.sqf, add:
  execVM 'ice_squadManagement\init.sqf';
	Note: by default, this adds a key handler for (Shift+P) to open dialog. You may comment this part out if not needed.
		
- Optional for testing: in your mission init.sqf or somewhere, add some functionality similar to this:
	call compile preprocessFileLineNumbers "ice_squadManagement\custom\showWithOptions.sqf";
	You may want to move this file elsewhere, if needed, since it only contains your specific preferences.

	For testing purposes only, you can use execVM or addAction, but then the initial displaying of the dialog will be very slow.
  player addAction ["Squad Management", "ice_squadManagement\custom\showWithOptions.sqf", [], 0, false, true, ""];
		
- edit showWithOptions.sqf to tweak the functionality, global variables and optional features as needed specific for your mission type.

- view common.sqh to verify that the _c_basePath path is correct for the script folder location.

- view common.sqh to verify that the dialog IDD value does not clash with any other dialog/display in use. Use another number if needed.

--------------------------------------------------------------------------------
USAGE (activating addon system from your mission)
--------------------------------------------------------------------------------

To be advised.

--------------------------------------------------------------------------------
VERSION HISTORY (not precise)
--------------------------------------------------------------------------------

Version | Date | Notes

0.1 | 19 Mar 2007 | First beta release - mostly functional but requires a cosmetic tidy up. Released as "Team Status Dialog".
1.0 | 23 Mar 2007 | First full release - added group joining, TL selection, Opp Team page, Targets column, colour scheme, fix comboList transparency, some new parameters
1.1 | 10 Jun 2007 | new params, multiple language support, vehicle armaments and status stats, new icons, altered & new group joining actions, rank, clear BG, combined/deleted columns, new addAction syntax, expand/collapse all groups
1.2 |  2007/2008  | included German string table, new param: "ShowAIGroups", switched to pos2grid.cpp, used ICE_groupChat, #defines used for all constants (instead of variables)
1.3 | 06 Nov 2008 | isolated functionality into one single folder, no external calls, deleted all 'common functions', scripts and unused functions, tagged all internal functions. Renamed to "Squad Management Dialog".
2.0 | 2010-01 Feb 2012 | Major revamp. New dialog layout. Support for Question HUD. Support for Squad HUD.
2.1 | 11 Oct 2012 | Public mission based version developed and released.
2.2 | ?? Oct 2012 | Standalone public addon version (to be) released.

--------------------------------------------------------------------------------
CREDITS
--------------------------------------------------------------------------------

Author: Dr_Eyeball (Contact via PM on BIS forums)
Wormeaten - for advice on the design and functionality (v2.0)
Schwab - for German string table translations (v1.2 only)
BIS Community - for many bits of information and inspiration

--------------------------------------------------------------------------------
External references:
--------------------------------------------------------------------------------
Try https://dev-heaven.net/projects/ice-devastation/files for latest download of updates. Subject to change locations. Try project "ICE" or similar on DH in future.
