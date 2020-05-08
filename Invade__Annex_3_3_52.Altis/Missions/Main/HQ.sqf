/*
author: McKillen

description: spawns an HQ sub-obj

Last modified: 16/11/2017 by stanhope
Modified: /
*/
private _flatPos = [getMarkerPos currentAO, 10, derp_PARAM_AOSize, 5, 0, 0.1, 0, [], [0,0,0]] call BIS_fnc_findSafePos;
private _roughPos =[((_flatPos select 0) - 200) + (random 400),((_flatPos select 1) - 200) + (random 400),0];

private _objArray = [];
private _HqBuilding = objNull;
private _buildings = [["Land_Cargo_HQ_V1_F",[-0.794922,-0.773438,7.0654],0],["RoadCone_F",[-4.4082,6.08984,3.45801],359.999],["RoadCone_F",[-7.68555,0.878906,3.458],0.00437646],["RoadCone_F",[1.75391,7.66016,3.458],0.00437646],["RoadCone_F",[-1.93945,7.85352,3.458],0.00437646],["RoadCone_F",[5.21289,7.47656,3.458],0.00437646],["RoadCone_F",[-8.83594,3.00195,3.458],268.949],["RoadCone_F",[-6.67188,-7.28125,3.458],0.00444326],["RoadCone_F",[-8.21875,5.54297,3.458],268.949],["RoadCone_F",[-5.87109,8.00391,3.458],0.00437646],["RoadCone_F",[10.0918,-0.00390625,3.458],0.00437646],["RoadCone_F",[-1.55469,-9.98047,3.458],0.00437646],["RoadCone_F",[-1.63672,10.1113,3.458],0.00437646],["RoadCone_F",[2.13867,-10.1738,3.458],0.00437646],["RoadCone_F",[1.99609,10.3906,3.458],0.00437646],["RoadCone_F",[-11.041,0.804688,3.458],268.949],["RoadCone_F",[-8.85352,-6.82813,3.458],0.00444093],["RoadCone_F",[8.87109,-6.91406,3.458],0.00437635],["RoadCone_F",[-5.48633,-9.83008,3.458],0.00437646],["RoadCone_F",[8.53711,7.55078,3.458],0.00437646],["RoadCone_F",[10.0293,-5.45898,3.458],0.00437646],["RoadCone_F",[-5.50391,10.127,3.458],0.00437646],["RoadCone_F",[5.45508,10.207,3.458],0.00437646],["RoadCone_F",[10.3555,5.34375,3.458],0.00437646],["RoadCone_F",[5.59766,-10.3574,3.458],0.00437646],["RoadCone_F",[-11.0156,4.55078,3.458],268.949],["RoadCone_F",[-9.22266,8.23438,3.458],360],["Land_HBarrier_5_F",[3.08594,12.0352,3.93051],0],["RoadCone_F",[12.4746,-1.18359,3.458],0.00437646],["RoadCone_F",[12.4629,1.79102,3.458],359.997],["Land_Sign_Mines_F",[0.257813,12.832,3.37409],180],["Land_HBarrier_5_F",[-12.8516,-1.2207,3.93051],0],["Land_HBarrier_5_F",[-4.85352,12.0508,3.93051],0],["RoadCone_F",[-8.83789,-9.59961,3.458],0.00437646],["RoadCone_F",[12.5371,-3.7168,3.458],0.00437646],["RoadCone_F",[8.7793,10.2813,3.458],0.00437646],["RoadCone_F",[-1.63477,-13.4551,3.458],0.00437646],["RoadCone_F",[12.543,5.26563,3.458],0.00437646],["RoadCone_F",[8.92188,-10.2832,3.458],0.00437646],["RoadCone_F",[2.05859,-13.6484,3.458],0.00437646],["RoadCone_F",[-9.23047,10.2715,3.458],0.00437646],["RoadCone_F",[-13.7754,0.996094,3.458],268.949],["Land_HBarrier_5_F",[-12.7422,-5.31641,3.93051],0],["RoadCone_F",[12.5254,-6.9043,3.458],0.00437635],["RoadCone_F",[12.1914,7.56055,3.458],0.00437646],["Land_HBarrier_5_F",[14.1875,2.41602,3.93051],90],["RoadCone_F",[-5.56641,-13.3047,3.458],0.00437646],["RoadCone_F",[-12.5996,-7.03516,3.458],0.00437646],["RoadCone_F",[-13.75,4.74219,3.458],268.949],["Land_HBarrier_3_F",[14.2734,-3.17969,3.98834],90],["RoadCone_F",[5.51758,-13.832,3.458],359.995],["RoadCone_F",[-12.9668,8.32813,3.458],0.00437646],["Land_Sign_Mines_F",[15.291,-3.06055,3.37409],270],["RoadCone_F",[-12.582,-9.50586,3.458],0.00437646],["Land_HBarrier_5_F",[-15.5742,2.38672,3.93051],90],["RoadCone_F",[-8.91797,-13.0742,3.458],0.00437646],["Land_HBarrier_5_F",[10.5957,12.082,3.93051],0],["RoadCone_F",[12.4336,10.291,3.458],0.00437646],["RoadCone_F",[12.5762,-10.2734,3.458],0.00437646],["RoadCone_F",[8.8418,-13.7578,3.458],0.00437646],["RoadCone_F",[-12.8516,10.3516,3.458],0.00437646],["RoadCone_F",[-1.64648,-16.6426,3.458],0.00437635],["Land_Sign_MinesDanger_English_F",[-15.793,-5.44336,4.22996],90],["Land_HBarrier_5_F",[14.2617,-8.88477,3.93051],90],["Land_HBarrier_5_F",[-11.9414,12.0059,3.93051],0],["RoadCone_F",[2.04688,-16.8359,3.458],0.00437635],["Land_HBarrier_5_F",[14.1797,9.87305,3.93051],90],["RoadCone_F",[-5.57813,-16.4922,3.458],0.00437635],["RoadCone_F",[5.50586,-17.0195,3.458],0.00437635],["Land_HBarrier_5_F",[-15.5,-8.91406,3.93051],90],["RoadCone_F",[-12.6621,-12.9805,3.458],0.00437646],["Land_HBarrier_5_F",[-15.582,9.84375,3.93051],90],["RoadCone_F",[-8.92969,-16.2617,3.458],0.00437635],["RoadCone_F",[12.4961,-13.748,3.458],0.00437646],["Land_HBarrier_5_F",[3.1875,-18.3027,3.93051],0],["Land_HBarrier_5_F",[-4.75195,-18.2871,3.93051],0],["Land_HBarrier_5_F",[-18.7422,-3.41406,3.93051],90],["RoadCone_F",[8.83008,-16.9453,3.458],0.00437635],["Land_Sign_Mines_F",[0.482422,-19.2344,3.37409],0],["RoadCone_F",[-12.6738,-16.168,3.458],0.00437646],["RoadCone_F",[12.4844,-16.9355,3.458],0.00437635],["Land_HBarrier_5_F",[10.6973,-18.2559,3.93051],0],["Land_HBarrier_5_F",[14.3047,-16.1621,3.93051],90],["Land_HBarrier_5_F",[-11.8398,-18.332,3.93051],0],["Land_HBarrier_5_F",[-15.457,-16.1914,3.93051],90]];
private _spawnFnc = {
    params ["_start", "_dif", "_type", "_dir", "_grp"];
    private _obj = objNull;
    private _pos = [(_start select 0) + (_dif select 0), (_start select 1) + (_dif select 1), 0];

    if (_type find "RoadCone" == -1) then {
        if (isNil "_grp") then {
            _obj = _type createVehicle [-100,-100,0];
        } else {
            _obj = _grp createUnit [_type, [-100,-100,0], [], 20, "NONE"];
        };
        if (_obj isEqualTo objNull) exitWith { _obj };

        _obj setDir _dir;
        _obj setPosATL _pos;
    } else {
        if (random 1 >= 0.5) then {
            private _mineType = selectRandom ["APERSMine", "APERSMine", "APERSMine"];
            _obj = createMine [_mineType, _pos, [],0];
        };
    };
    _obj
};

{
    switch (true) do {
        case ((_x select 0) isKindOf "Land_Cargo_HQ_V1_F"): {
            private _obj = [_flatPos, _x select 1, (_x select 0), _x select 2] call _spawnFnc;
            _objArray pushBack _obj;
            _obj allowDamage false;
            _obj enableDynamicSimulation false;
            _HqBuilding = _obj;
        };
        case ((_x select 0) isKindOf "Land_HBarrier_5_F"): {
            private _obj = [_flatPos, _x select 1, (_x select 0), _x select 2] call _spawnFnc;
            _objArray pushBack _obj;
            _obj setVectorUp surfaceNormal position _obj;
        };
        default {
            private _obj = [_flatPos, _x select 1, (_x select 0), _x select 2] call _spawnFnc;
            _objArray pushBack _obj;
        };
    };
} forEach _buildings;
_buildings = nil;

if (_HqBuilding isEqualTo objNull) exitWith {
    {deleteVehicle _x} forEach _buildings;
};

private _HQpos = _HqBuilding buildingPos -1;
private _officerPos = selectRandom _HQpos;
_HQpos = _HQpos - [_officerPos];

private _garrisongroup = createGroup east;
_garrisongroup setGroupIdGlobal [format ['AO-subobjgroup']];
private _officer = _garrisongroup createUnit ["O_officer_F", _officerPos, [], 0, "CAN_COLLIDE"];

_officer disableAI "PATH";
removeAllWeapons _officer;
_officer addMagazine "6Rnd_45ACP_Cylinder";
_officer addWeapon "hgun_Pistol_heavy_02_F";
_officer addMagazine "6Rnd_45ACP_Cylinder";
_officer addMagazine "6Rnd_45ACP_Cylinder";

_officer setVariable ["_HqBuilding", _HqBuilding];

_officer addEventHandler ["Killed",{
    params ["_unit","","_killer"];
    private _hq = _unit getVariable ["_HqBuilding", objNull];
    _hq allowDamage true;

    private _name = name _killer;
    if (_name == "Error: No vehicle") then{
        _name = "someone";
    };
    _aoName = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
    _targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>UPDATE</t><br/>____________________<br/>Good job everyone, %2 neutralised the officer. Now destroy the HQ building.",_aoName,_name];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
}];

_HqBuilding addEventHandler ["Killed",{
    params ["_unit","","_killer"];

    private _name = name _killer;
    if (_name == "Error: No vehicle") then{
        _name = "someone";
    };
    _aoName = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
    _targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Complete</t><br/>____________________<br/>Good job everyone, %2 destroyed the HQ building. OPFOR should find it harder to co-ordinate their attacks in %1.",_aoName,_name];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
}];

{ _x setMarkerPos _roughPos; } forEach ["radioMarker","radioCircle"];
"radioMarker" setMarkerText "Sub-Objective: HQ Building";
_targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>HQ Building</t><br/>____________________<br/>OPFOR have set up an HQ building in the AO. Inside is an officer, neutralise him using any force necessary.  After that destroy the building.<br/><br/>"];
[_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];

[west,["SubAoTask","MainAoTask"],["OPFOR have set up an HQ building in the AO. Inside is an officer, neutralise him using any force necessary.  After that destroy the building.","HQ Building","radioMarker"],(getMarkerPos "radioMarker"),"Created",0,true,"destroy",true] call BIS_fnc_taskCreate;
private _infunits = ["O_Soldier_LAT_F", "O_soldier_M_F", "O_Soldier_TL_F", "O_Soldier_AR_F", "O_Soldier_GL_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F"];

private _Garrisonpos = count _HQpos;
for "_i" from 1 to _Garrisonpos do {
    _unitpos = selectRandom _HQpos ;
    _HQpos = _HQpos - [_unitpos];
    _unittype = selectRandom _infunits;
    _unit = _garrisongroup createUnit [_unittype, _unitpos, [], 0, "CAN_COLLIDE"];
    _unit disableAI "PATH";
    sleep 0.1;
};
{_x addCuratorEditableObjects [units _garrisongroup, false];} forEach allCurators;

[_officer] spawn {
    params ["_officer"];
    sleep (30 + (random 60));
    while {(alive _officer)} do {
        if (jetCounter < 3) then {
            [] spawn AW_fnc_airfieldJet;
        };
       sleep (720 + (random 480));
    };
};

subObjUnits = subObjUnits + units _garrisongroup + _objArray;

waitUntil {sleep 3; !alive _officer && !alive _HqBuilding};

["SubAoTask", "Succeeded",true] call BIS_fnc_taskSetState;
sleep 5;
deleteVehicle (nearestObject [_roughPos, "Land_Cargo_HQ_V1_ruins_F"]);
["SubAoTask",west] call bis_fnc_deleteTask;
{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["radioMarker","radioCircle"];