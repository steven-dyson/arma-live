--[[
	Feel free to delete this after installing and providing your own code.
	Until then, this is your template for what you need to interface against.

	If this file is named in the config, will allow the game to run chunks like
	donothing("whatever")
	helloworld()
]]

local _G = _G	-- If all non-secenv accesses are through this, it will work even with lua 5.2

function donothing()
	-- do nothing
end
secenv.donothing = donothing	-- Make it available to game code


function secenv.helloworld()	
-- the secenv. prefix makes it available to the game code, but will need to be called with the prefix from anywhere else.

	-- Won't work on readonly
	local str =[[
[-1, {player globalChat _this}, "Hello World"] call CBA_fnc_globalExecute;
]]
	output.write(str);
	-- Have fun
end

local prevINIT = onINIT
function onINIT(sid)
	--[[ A new round just started. If you were gathering statistics for the previous round, 
	now is probably the time to send it. 
	
	Don't call write from here. If you flush you'd write to the old session that's not listening, and the write buffer is about to be cleared.
	
	All data in the current secure environment (cursecenv) is going to be gone in a little bit.	
	]]

	return prevINIT(sid)	-- Tail call the next part of the chain. Make sure to pass along the new session ID.
end

local prevIdle = onIdle
function onIdle()
	-- This code will be run while waiting for more input data, right before it starts the sleep. After that, if it still doesn't have any more instructions, it will run again. 
	-- Do not count on the timing set by input_sleepduration
	-- The last in the call chain will flush any pending output.
	-- Keep in mind it does, by default, not get called in std mode.
	
	return prevIdle()
end


--[[
	Any of the above functions can resume coroutines.

	Regarding lanes,
	-start the lane here, with a linda to it
	-define a function that passes the info to that linda, possibly waiting for some event
	-make that function available in secenv
	-If needed, add a onINIT function that notifies the lane.
]]
