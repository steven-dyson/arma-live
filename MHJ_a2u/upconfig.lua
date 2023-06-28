--[=[ This file is interpreted as lua
	Its settings are used to set up what the program will be doing, but code can run from here too.
	-- Denotes comments, --[[ ]] is a block comment.
	
	File paths on windows should be held within [[ ]]
	instead of "" to allow for single \s.
]=]
verbose_load = true;	-- Print load progress when starting. Useful if it does not complete loading.
errorlog = "uplink_error.txt"

--[[ INPUT

	inputmode: "std" "file" "ftp" modes supported (when implemented)
		std refers to stdin/stdout and is mostly useful for testing and debugging.
	inputfile: the "where" parameter for the input. Ignored for console.
		std: ignored
		file: path of file - relative paths acceptable
		ftp: ftp://user:pass@server/path/filename
			In the case the default directory is not the root, you may need to use
			ftp://user:pass@server//path/filename
	input_sleepduration: How long to wait between polling the file for new changes. 
		For ftp this should naturally be larger than for file.
		std will ignore this value
		Should this value be ommitted, the program may go into a BUSY_WAIT loop.
		Value in milliseconds.
	input_search_for_beginning: Should we look for the last INIT and start from there?
		When false, you will get processing for previous rounds as well; desirable for late offline parsing.
		When true, will only run every command passed since the start of the last round (which sent an INIT)
		(No current functionality is provided for starting this midway into a round 
		and only running from the current point. Previous commands may have been important for setting up the effects of current rounds.)
]]
inputmode = "file"
inputfile = [[C:\Users\mahuja\AppData\Local\ArmA 2 OA\arma2oa.RPT]]
--inputfile = "../arma2server/log.2302.txt"	-- linux server w/ default script
--inputfile = "ftp://mahuja:x@server/path/testfile.txt"	-- relative to wherever the session starts
--inputfile = "ftp://mahuja:x@server//path/testfile.txt" -- relative to root
input_sleepduration = 1000
input_search_for_beginning = true
--input_ftp_linebreak = "\r\n"	-- If you get a 501 error, try uncommenting this

--[[ OUTPUT
	Outputmode will implicitly mirror inputmode.
	Only std and file modes have implementations, and file mode is quite alpha quality yet.
	
	Note that outputfile is only the base name of the file; additional parts (session#.file#) will be added.
	This value MUST match the setting in the sqf.
	
	For ftp, this may need to be a relative path compared to the infile's directory.
	
	readonly disables writing entirely.
]]
readonly = true
outputfile = [[C:\Program Files (x86)\steam\steamapps\common\arma 2 operation arrowhead\userconfig\logcomms\f]]

--[[ LOGIC
	Defines modules that are to be loaded once other initialization is finished.
	These implement the server specific configuration, make stuff callable from the secure environment, etc.
]]
load = {"loopback"}

--[[ MODULE SETTINGS
	The modules specified above should have their settings, as varying between installs, specified here.
]]

