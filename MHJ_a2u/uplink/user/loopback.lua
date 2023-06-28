--[[
	This module has one purpose in life: to test the write functionality.
]]

local _G = _G	-- If all non-secenv accesses are through this, it will work even with lua 5.2

function secenv.loopbackhint(text)
	local str = "[-1, {hint _this}, " .. secenv.sqf_escape(text) .. "] call CBA_fnc_globalExecute;"
	secenv.sqf(str);
	print ("Loopbackhint called:",text);
end

