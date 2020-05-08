/*
	author: stanhope
	description: spawns an AO vehicle
	returns: vehicle
*/

params ["_AOpos", "_radiusSize", "_vehType", "_grpName"];

private _randomPos = [_AOpos, 0, _radiusSize, 5, 0, 0.4, 0, [], _AOpos] call BIS_fnc_findSafePos;
private _veh = createVehicle [_vehType, _randomPos, [], 5, "NONE"];

private _grp = createGroup east;
createVehicleCrew _veh;
(crew _veh) join _grp;
_veh lock 2;
_veh allowCrewInImmobile true;
_veh setVehicleRadar 1;
_veh setVehicleReportRemoteTargets false;

_grp setGroupIdGlobal [_grpName];
_grp setCombatMode "YELLOW";
_grp setBehaviour "AWARE";

[_grp, _AOpos, _radiusSize] call AW_fnc_taskCircPatrol;

_veh