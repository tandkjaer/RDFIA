/*
Author: 

	Quiksilver
	
Last modified:

	12/04/2014

Description:

	Delete enemies.
	
___________________________________________*/

private _deleteVehicleAndCrew = {
    params ["_veh"];
    if (isNil "_veh") exitWith {};
    if (!(isNull _veh) && {alive _veh}) then {
        if (_veh isKindOf "AllVehicles") then {
            {_veh deleteVehicleCrew _x} forEach crew _veh;
        };
        deleteVehicle _veh;
    };
};


{
    if (typeName _x == "GROUP") then {
        {
            if (vehicle _x != _x) then {
                [vehicle _x] call _deleteVehicleAndCrew;
            } else {
                deleteVehicle _x;
            };
        } forEach (units _x);
        deleteGroup _x;
    } else {
        if (vehicle _x != _x) then {
            [vehicle _x] call _deleteVehicleAndCrew;
        };
        if (_x isKindOf "AllVehicles") then {
            [vehicle _x] call _deleteVehicleAndCrew;
        };

        if (!isNull _x) then {
            deleteVehicle _x;
        };
    };
    sleep 0.1;
} forEach (_this select 0);

