private "_config";
private "_count";
private "_i";
private "_magazines";
private "_object";
private "_type";
private "_type_name";

_object = _this select 0;

_type = typeof _object;
_object setVehicleAmmo 1;
_type_name = typeOf _object;
_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

if (count _magazines > 0) then 
{
	_removed = [];
	{
		if (!(_x in _removed)) then {
			_object removeMagazines _x;
			_removed = _removed + [_x];
		};
	} forEach _magazines;
	
	{
		_object addMagazine _x;
	} forEach _magazines;
};
_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
if (_count > 0) then 
{
	for "_i" from 0 to (_count - 1) do 
	{
		_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
		_magazines = getArray(_config >> "magazines");
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_object removeMagazines _x;
				_removed = _removed + [_x];
			};
		} forEach _magazines;
		
		{
			_object addMagazine _x;
		} forEach _magazines;
	};
};
_object setVehicleAmmo 1;
_object setDamage 0;
_object setFuel 1;