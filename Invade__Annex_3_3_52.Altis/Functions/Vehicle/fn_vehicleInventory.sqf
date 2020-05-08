/*
author: stanhope, AW community member.

description: tweaks the vehicle inventory

Last modified: 20/05/2019 by stanhope

Modified: initial release
*/
params ["_vehicle"];
if (!alive _vehicle) exitWith {};
private _vehicleType = typeOf _vehicle;

clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;
private _FAKCount = [_vehicleType,true] call BIS_fnc_crewCount;
_vehicle addItemCargoGlobal ["FirstAidKit", _FAKCount];

private _addWeaponCode = {
    params ["_vehicle"];
    private _weaponCount = [typeOf _vehicle, false] call BIS_fnc_crewCount;
    _vehicle addWeaponCargoGlobal ["SMG_01_Holo_F", _weaponCount];
    _vehicle addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01", _weaponCount * 3];
    _vehicle addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01_Tracer_Red", _weaponCount];
};

switch (true) do {
    case (_vehicle isKindOf "UAV"): {
        /*We don't want to do anything with a UAV*/
    };
    case (_vehicle isKindOf "Air"): {
        private _parachuteCount = [_vehicleType,true] call BIS_fnc_crewCount;
        _parachuteCount = _parachuteCount - ([_vehicleType,false] call BIS_fnc_crewCount);
        if (_vehicle isKindOf "Plane") then {
            _parachuteCount = _parachuteCount + 1;
        } else {
            _vehicle addItemCargoGlobal ["ToolKit", 1];
        };
        if (_parachuteCount > 0) then {
            _vehicle addBackpackCargoGlobal ["B_Parachute", _parachuteCount];
        };
        [_vehicle] call _addWeaponCode;
    };
    case (_vehicle isKindOf "Quadbike_01_base_F"): {
        /*We don't want to do anything with a quad*/
    };
    case (_vehicle isKindOf "Land"): {
        _vehicle addItemCargoGlobal ["ToolKit", 1];

        _vehicle addMagazineCargoGlobal ["SmokeShell", 6];
        _vehicle addMagazineCargoGlobal ["SmokeShellBlue", 4];
        _vehicle addMagazineCargoGlobal ["HandGrenade", 4];
        _vehicle addMagazineCargoGlobal ["MiniGrenade", 4];

        _vehicle addMagazineCargoGlobal ["30Rnd_65x39_caseless_black_mag", 16];
        _vehicle addMagazineCargoGlobal ["30Rnd_65x39_caseless_black_mag_Tracer", 4];
        _vehicle addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 16];
        _vehicle addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Red", 4];

        if (_vehicle isKindOf "Truck_F" || _vehicle isKindOf "Tank") then {
            [_vehicle] call _addWeaponCode;
        };
    };
};
  
  
