local inputfile = inputfile;
local io=io;
local error=error;
local string=string;
local _G=_G;

local file, errormsg = io.open(inputfile)
if (file==nil) then 
	error (errormsg);
end

-- begin declaring the interface
module ("uplink.input_filets")

function readline()
	local str = file:read("*l");
	while (str==nil) do
		_G.onIdle();
		str = file:read("*l");
	end
	str = str:match("%d+/%d+/%d+, %d+:%d+:%d+ (.+)")	-- Non timestamped lines will be discarded as a result of this
	if not str then return readline() end
	return str
end
function search_last_init()
	-- This will usually be run before any reads have occurred.
	-- Even if it has, been run, it's generally harmless.
	local offset = file:seek();
	local coffset = file:seek();
	local str = "";
	while (str ~= nil) do
		coffset = file:seek();
		if (string.match(str,"#LOGCOMMS%s+INIT.*")) then
			offset = coffset;
		end
		str = file:read("*l");
	end
	file:seek("set",offset);
end
