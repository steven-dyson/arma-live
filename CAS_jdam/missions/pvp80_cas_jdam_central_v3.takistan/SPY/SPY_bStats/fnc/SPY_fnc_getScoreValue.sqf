/***************************************************************************
SCORE VALUE
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_score", "_base"];

_type = (_this select 0);
_condition = (_this select 1);
_multiplier = (_this select 2);

switch (_type) do 
{
	case "kill": 
	{
		_base = 20;
		switch (_condition) do 
		{
			case 1: 
			{
				if ((_multiplier <= 50)) then 
				{
					_score = (_base + (round ((50 - _multiplier) / 5)));
				} 
				else 
				{
					if ((_multiplier > 400)) then 
					{
						_score = (_base + (round (1 + ((_multiplier - 400) / 100))));
					}
					else
					{
						_score = _base;
					};
				};
			};
			case 2: 
			{
				if ((_multiplier <= 100)) then 
				{
					_score = (_base + (round ((100 - _multiplier) / 5)));
				} 
				else 
				{
					if ((_multiplier > 1000)) then 
					{
						_score = (_base + (round (1 + ((_multiplier - 1000) / 100))));
					} 
					else 
					{
						_score = _base;
					};
				};
			};
		};
	};
	case "death": { _score = 0; };
	case "suicide": { _score = -10; };
	case "teamkill": 
	{
		if ((_multiplier < 2)) then { _score = -1 } else { _score = (-1 + (-_multiplier * 5)); };
		if ((_score < -30)) then { _score = -30; };
	};
	case "vehkill": 
	{
		switch (true) do 
		{
			case ((_condition select 1) isKindOf "Plane"): { _base = 40; };
			case ((_condition select 1) isKindOf "Helicopter"): { _base = 35; };
			case ((_condition select 1) isKindOf "Wheeled_APC"): { _base = 25; };
			case ((_condition select 1) isKindOf "Tracked_APC"): { _base = 25; };
			case ((_condition select 1) isKindOf "Tank"): { _base = 30; };
			case ((_condition select 1) isKindOf "Car"): { _base = 20; };
			case ((_condition select 1) isKindOf "Ship"): { _base = 20; };
			case ((_condition select 1) isKindOf "Static"): { _base = 10; };
			default { _base = 20; };	
		};
		switch (_condition select 0) do 
		{
			case 1: 
			{
				if ((_multiplier <= 50)) then 
				{
					_score = (_base + (round ((50 - _multiplier) / 5)));
				}
				else
				{
					if ((_multiplier > 400)) then 
					{
						_score = (_base + (round (1 + ((_multiplier - 400) / 100))));
					}
					else
					{
						_score = _base;
					};
				};
			};
			case 2: 
			{
				if ((_multiplier <= 100)) then 
				{
					_score = (_base + (round ((100 - _multiplier) / 5)));
				}
				else
				{
					if ((_multiplier > 1000)) then 
					{
						_score = (_base + (round (1 + ((_multiplier - 1000) / 100))));
					}
					else
					{
						_score = _base;
					};
				};
			};
		};
	};
	case "killassist": 
	{
		_score = (10 + (round (_multiplier * 10)));
	};
	case "accrash": {_score = ((-10) + (-_multiplier * 2));};
	case "civcas": 
	{
		_score = (-5 * (_multiplier * _multiplier)); 
		if ((_score < -30)) then { _score = -30; };
	};	
	case "vehtk": 
	{
		if ((_multiplier < 2)) then { _score = -1 } else { _score = (-1 + (-_multiplier * 5)); };
		if ((_score < -30)) then { _score = -30; };
	};	
	case "damageteam": { _score = -1; };
	case "damageciv": { _score = -1; };
	case "trans": { _score = 3; };
	case "capture": { _score = 50; };
};

if ((_score > 100)) then { _score = _base };

_score