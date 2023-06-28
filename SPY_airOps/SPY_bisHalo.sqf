// Executes BIS HALO

private ["_aircraft", "_player"];

_aircraft = _this select 0;
_player = _this select 1;

_player setPos (_aircraft modelToWorld [0, -12, 0 ]);

[_player, (getpos _player select 2)] exec "ca\air2\halo\data\Scripts\HALO_init.sqs";