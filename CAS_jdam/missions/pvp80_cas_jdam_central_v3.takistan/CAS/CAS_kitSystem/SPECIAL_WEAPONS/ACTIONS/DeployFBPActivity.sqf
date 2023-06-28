private "_position";
private "_fbpObject";

if (!isNil "JDAM_DEPLOY_FBP_IN_PROGRESS") exitWith {};
JDAM_DEPLOY_FBP_IN_PROGRESS = true;

_fbpObject = _this select 3;

_position = getPosASL player;
_position set [2, 0];
_position = [_position, 10, (getDir player)] call GlobalScripts_PolarVector;
_null = [[_fbpObject, _position], "_null = _this spawn ServerFBPSystem_DeployFBP;", "SERVER"] spawn CAS_mpCB;

JDAM_DEPLOY_FBP_IN_PROGRESS = nil;