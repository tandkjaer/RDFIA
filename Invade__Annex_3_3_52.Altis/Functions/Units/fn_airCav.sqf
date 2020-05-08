/*
Author: BACONMOP
Description: Create Air Cav reinforce
last edited: 19/08/2017 by stanhope
edited: remove unneeded code
*/
params ["_dropZone","_startPos"];

private _returnArray = [];
private _accepted = false;
private _flatPos = [0,0,0];

while { !_accepted } do {
    _flatPos = [getMarkerPos _dropZone, 10, "AOSize" call BIS_fnc_getParamValue, 5, 0, 0.3, 0, [], [0,0,0]] call BIS_fnc_findSafePos;

    _accepted = true;
    {
        if ( (_flatPos distance2D (getMarkerPos _x)) < missionsMinimumSpawnDistance) then {
            _accepted = false;
        }
    } forEach BaseArray;
};

private _heliArray = ["O_Heli_Attack_02_dynamicLoadout_F", "O_T_VTOL_02_infantry_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","I_Heli_light_03_dynamicLoadout_F",
    "O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F", "I_Heli_Transport_02_F", "I_Heli_light_03_unarmed_F",
    "O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_covered_F", "I_Heli_Transport_02_F", "I_Heli_light_03_unarmed_F"
];
private _heli = selectRandom _heliArray;

private _ambientHeli = createVehicle [_heli, getMarkerPos _startPos, [], 0, "FLY" ];
createVehicleCrew _ambientHeli;
private _heliGrp = createGroup east;
(crew _ambientHeli) join _heliGrp;
{_x allowFleeing 0;} forEach units _heliGrp;
_heliGrp setGroupIdGlobal [format ['AO-ReinfHeli']];

private _squadSize = _ambientHeli emptyPositions "cargo";

private _unitArray = ["I_Soldier_SL_F", "I_Soldier_AR_F", "I_Soldier_AAR_F", "I_Soldier_GL_F", 
    "I_Soldier_M_F", "I_Soldier_LAT_F", "I_medic_F", "I_engineer_F",
    "I_Soldier_AT_F", "I_Soldier_AT_F", "I_Soldier_AAT_F", "I_Soldier_repair_F",
    "I_Soldier_AA_F", "I_Soldier_AA_F", "I_Soldier_AAA_F", "I_Soldier_exp_F",
    "I_Soldier_AR_F", "I_Soldier_AR_F", "I_Soldier_AAR_F", "I_Soldier_AAR_F"
];

if (_squadSize > count _unitArray) then {
    _squadSize = count _unitArray;
};

private _dummyGrp = createGroup east;
for "_i" from 1 to _squadSize do {
    _dummyGrp createUnit [_unitArray select (_i - 1), getMarkerPos _startPos, [], 0, "NONE"];
};

private _GRP1 = createGroup east;
private _dummy = _GRP1 createUnit ["O_officer_F", _flatPos, [], 0, "NONE"];
_GRP1 setGroupIdGlobal [format ['AO-ReinfGroup']];
(units _dummyGrp) join _GRP1;
deleteVehicle _dummy;

{_x moveInCargo _ambientHeli} forEach units _GRP1;

private _heliWp = _heliGrp addWaypoint [_flatPos,0];
_heliWp setWaypointType "TR UNLOAD";
_heliWp setWaypointCompletionRadius 5;
private _wpPos3 = getMarkerPos _startPos;
private _heliWp3 = _heliGrp addWaypoint [_wpPos3,1];
_heliWp3 setWaypointType "Move";
_heliWp3 setWaypointCompletionRadius 5;
_heliWp3 setWaypointStatements ["true", "private _veh = vehicle this; { _veh deleteVehicleCrew _x } forEach crew _veh; deleteVehicle _veh;"];
[_GRP1,getMarkerPos _dropZone, 400 ] call BIS_fnc_taskPatrol;

{_returnArray pushBack _x} forEach units _GRP1;
{_returnArray pushBack _x} forEach units _heliGrp;
_returnArray pushBack _ambientHeli;

{_x addCuratorEditableObjects [(_returnArray), true]; } forEach allCurators;
[_returnArray] call derp_fnc_AISkill;

_returnArray
