/*
author: stanhope
Description: Function that pushes a given vehicle into the RespawnVehiclesArray (scripts/vehicle/vehiclerespawn.sqf) array
*/
if (!isServer) exitWith {}; // GO AWAY PLAYER

params ["_vehicle", "_delay", "_setup", "_init", ["_base", "BASE"], "_vehType", "_vehPos"];

_vehicle lock 2;
[_vehicle] spawn AW_fnc_vSetup02;

if (isNil "_vehType") then {
    _vehType = typeOf _vehicle;
};
if (isNil "_vehPos") then {
    _vehPos = getPosWorld _vehicle;
};


sleep 2;
private _toPushBack = [_vehicle, _vehType, _vehPos, getDir _vehicle, _delay, nil, _base];

waitUntil {sleep 1; !isNil "RespawnVehiclesArray"};
_vehicle lock 0;
RespawnVehiclesArray pushBack _toPushBack;