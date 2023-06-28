private "_kitName";

_kitName = _this select 0;
JDAM_CLIENT_KIT_QUEUE set [(count JDAM_CLIENT_KIT_QUEUE), [[player, _kitName], 1]];