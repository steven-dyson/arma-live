
function dt(t) for k,v in pairs(t) do print(k,v) end end
function dumplocal()
	local i = 1;
	local k = 1;
	while (k~=null) do
		k = debug.getlocal(4,i);
		print(debug.getlocal(4,i))
		i=i+1
	end
end
-- This needs a reference which I don't know how to pick off the stack.
function dumpupval(f)
	local i = 1;
	local k = 1;
	while (k~=null) do
		k = debug.getupvalue(f,i);
		print(debug.getupvalue(f,i))
		i=i+1
	end
end
