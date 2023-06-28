/* 
	Test code:

		_aliveMen = allUnits;

		while {true} do
		{
			if (count _aliveMen != count allUnits) then
			{
				_deadMen = _aliveMen - allUnits;
				{
					hideBody _x;
				} forEach _deadMen;
			};

			_aliveMen = allUnits;
		};

	With the code below, we could alternatively use

		hideBody _x;

	Not sure whether hideBody will actually clear the unit
	completely or whether it just sinks it below the ground.
	To be safe (and until someone complains) we'll use 
	deleteVehicle.
*/

while {true} do
{
	sleep 60;
	{
		deleteVehicle _x;
	} forEach allDead;
};