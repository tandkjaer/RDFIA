/*
Author: BACONMOP

Example:
_pos = getPos Player;
_unit = arty;
[_unit,_pos] call AW_fnc_artyStrike;

Parameters:
1. Unit that will fire.
2. Target Location.
*/
params ["_arty", "_pos"];
_arty setVehicleAmmo 1;
private _amount = _arty ammo (currentWeapon _arty);
private _shotsFired = floor (random _amount);
if (_shotsFired < 3) then {
	_shotsFired = 3;
};
private _ammo = (getArtilleryAmmo [_arty] select 0);
private _smokePos = [_pos select 0, _pos select 1, ((_pos select 2) + 10)];
private _redSmoke = createVehicle ["SmokeShellRed", _smokePos, [], 10, "NONE"];
_arty commandArtilleryFire [_pos, _ammo, _shotsFired];