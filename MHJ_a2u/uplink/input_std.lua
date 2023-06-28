local io = io;

local print = print;
local os = os;

module ("uplink.input_std")
function readline()
	local line = io.read("*l");
	if false and not line then print ("\n\nReached end of input, terminating...\n") os.exit() end
	return line
end
function search_last_init()
	-- do nothing; console input doesn't have rewind features.
end
