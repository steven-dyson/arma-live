This file is very preliminary, and is more of an outline than anything else.

Requirements:
Lua 5.1 interpreter with the following modules installed:
  luasocket	(for sleep through select, as well as ftp)
ArmA2, and access to its output log.
ArmA2 missions/addons that use a2uplink to communicate with the outside world.

Optional requirements:
Module "luasql" for database access.
System must allow enough file handles for the server to open all the generated files.


Instructions:
Extract the files, then edit the config file. The config file is a lua interpreted, and so can do some pretty advanced stuff, like searching for the input file rather than straight out saying its path.

To do more advanced stuff, you have to make custom modules, available from lua. These modules are called up in the order listed in the config, and it's suggested that their "config" (like what database to open, etc) is also contained in the config file. This will make them easy to copy to other servers.

The lua code can also run commands in game. (If the config specifies readonly, it will be ignored.) This is done with the function sqf(). Note that the order or execution of different calls of sqf() is undefined. This is necessary to insulate the various commands from each others syntax errors. If sending multiple commands, try to do so in a single call to sqf(), even if the ordering isn't important.

The function takes two values. 
The first is the armascript code that will be passed back into the game.
The second value is optional, and specifies a callback function that shall then be able to call the code in the first parameter, and get its return value - or lack thereof. This method was chosen so that errors could be pushed into armascript exception handling. Good armascript must be MT safe anyhow.

The code sent to sqf() will be sent to the game when the flush() function is run, which will happen automatically when the program is again waiting for input.

Limitations, known bugs:
ArmA2 keeps the files it reads open. That means for every time we inject sqf, a file handle will be kept open. When this hits a Operating System limit, the server is terminated - indistinguishable from a crash.


