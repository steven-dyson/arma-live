verbose_load = true;	-- Print load progress when starting. Useful if it does not complete loading.
errorlog = "uplink_error.txt"

inputmode = "file"
inputfile = [[C:\Users\mahuja\AppData\Local\ArmA 2 OA\arma2oa.RPT]]
input_sleepduration = 1000
input_search_for_beginning = true

readonly = false
outputfile = [[C:\Program Files (x86)\steam\steamapps\common\arma 2 operation arrowhead\userconfig\uplink\f]]

--[[ LOGIC
	Defines modules that are to be loaded once other initialization is finished.
	These implement the server specific configuration, make stuff callable from the secure environment, etc.
]]
load = {"loopback","mso"}

--[[ MODULE SETTINGS
	The modules specified above should have their settings, as varying between installs, specified here.
]]

