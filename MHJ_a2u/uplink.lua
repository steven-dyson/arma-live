-- Load config
verbose_load = true
function loadprogress (s) if verbose_load then print(s) end end

configfile = arg[1] or "upconfig.lua";
loadprogress ("Loading config from",configfile)
dofile (configfile);

-- Set up error log
-- This will output some diagnostic messages, particularly lua errors raised while running game-provided code.
loadprogress ("Setting up error output");
if (errorlog) then
	local errlogfile, err = io.open(errorlog, "a+")
	assert(errlogfile,err)
	errlog = function (message)
		if (message:match(".+\n.+")) then -- Multiline messages were hard to read when there were plenty of them.
			errlogfile:write("--------------------------------------------------------------------\n")	
			errlogfile:write(message)
			errlogfile:write("\n\n")
		else 
			errlogfile:write(message)
			errlogfile:write('\n')
		end
		errlogfile:flush()
		if (inputmode=="std") then print(message) end
	end
else
	errlog = print -- was: function () end
end
errlog("Uplink started " .. os.date("!%c") .. "z")
errlog("Uplink version $Revision: 81 $");

-- Set up the secure environment
-- This needs to happen before output is initialized, such that the output can make its functions available.
loadprogress ("Creating sandbox")
require("uplink.secenv")

-- Set up i/o
inputmode = inputmode or "std";
--input = 
loadprogress("Loading input module");
a2in = require ("uplink.input_"..inputmode);

if (input_search_for_beginning) then 
	a2in.search_last_init();
end
if (readonly) then 
	a2out = { 
		write = function () end,
		flush = function () end,
		init = function () end,
		ack = function () end,
	};
else 
	a2out = require ("uplink.output_"..inputmode);
end

loadprogress("Setting up global events")
-- Set up event handlers
-- User modules can override these, calling the previous function as an upvalue.
function onINIT (sid)
	reset_secenv();
	a2out.init(sid);
end
--[[	onIdle
	When the app is waiting for input (and the read is not blocking, like std does) the input module will call this.
]]
onIdle = function ()
	a2out.flush()
	collectgarbage("collect")
	-- Then sleep for a bit
	if input_sleepduration then
		require ("socket").select(nil, nil, input_sleepduration/1000)
	end
end
--[[	onExit
	Will be called when about to quit.
	std eof, or a triggerfile (when it gets implemented)
]]
onExit = function ()
end

-- Run the user modules
loadprogress("Loading user modules");
local i,v;
for i,v in ipairs(load) do
	dofile ("uplink/user/"..v..".lua");
end

-- Now do the input processing

function reset_secenv()
	cursecenv = {};
	setmetatable(cursecenv,{ __index=secenv, __metatable={}} );
end
reset_secenv()

function getblock()
	local t = {}
	local s = a2in.readline();
	while (not string.match(s,"#LOGCOMMS END")) do
		table.insert(t,s)
		s = a2in.readline();
	end
	return table.concat(t,'\n')
end

-- Last preparation before we start is to clean up the littering of the previous steps.
loadprogress("Starting the read loop")
collectgarbage("collect")

local expression = 
[[%#LOGCOMMS%s+(%a+)%s*([^%s]*)%s*]]
while (true) do
	local line = a2in.readline();
	if not line then onExit() os.exit(0) end;	-- Note that this line will not apply for most input methods.
	local command, param = string.match(line,expression);
	--debug.debug()
	if (command) then
		if (command=="BEGIN") then
			a2out.filenum = param;
			-- Get and execute block
			local block = getblock();
			local res, err = loadstring(block);	--compile
			if (res) then 
				setfenv(res,cursecenv)
				res, err = pcall (res)	--run
			end
			if (not res) then
				errlog(err)
			elseif (param and err) then	-- asked for returns AND code returned a value
				a2out.write(err)	
				-- This one's surprisingly dangerous - if there's an sqf syntax error, kills all packaged scripts.
			end
			
			a2out.flush()
			a2out.filenum = nil
			collectgarbage("collect")
		elseif (command=="ACK") then
			-- TODO, ACK is part of the write interface
			-- There isn't really that much that -needs- to be done, 
			-- unless we're using this to restrict parallelism in writing
		elseif (command=="INIT") then
			onINIT(param)
		elseif (command=="END") then
			errlog("Unmatched END!")
		end
	end
end


