/*
    Author: alganthe
    Handles creating the AI
    Last Modified: 19/08/2017 by stanhope
    Modified: Group names
*/

params ["_smPos","_radiusSize","_AAAVehcAmount","_MRAPAmount","_randomVehcsAmount","_infantryGroupsAmount","_AAGroupsAmount","_ATGroupsAmount"];
private _spawnedUnits = [];

private ["_grp1"];

//-------------------------------------------------- AA vehicles
private _AAvicgrpCount = 0;
for "_x" from 1 to _AAAVehcAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize / 1.5), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;
    private _AAVehicle = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;

    createVehicleCrew _AAVehicle;
    _grp1 = createGroup east;
    (crew _AAVehicle) join _grp1;
    _AAVehicle lock 2;
    _AAVehicle allowCrewInImmobile true;
	_AAvicgrpCount = _AAvicgrpCount + 1;
	_grp1 setGroupIdGlobal [format ['Side-AAVic-%1', _AAvicgrpCount]];

    _spawnedUnits pushBack _AAVehicle;
    { _spawnedUnits pushBack _x; } forEach (crew _AAVehicle);

    [_grp1, _smPos, _radiusSize] call AW_fnc_taskCircPatrol;
    _grp1 setSpeedMode "LIMITED";
};

//-------------------------------------------------- MRAP
private _MRAPCount = 0;
for "_x" from 1 to _MRAPAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;
	private _vehicleType = selectRandom ["O_MRAP_02_gmg_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_LSV_02_armed_F","O_LSV_02_armed_F","O_G_Offroad_01_armed_F"];
    private _MRAP = _vehicleType createVehicle _randompos;

    createVehicleCrew _MRAP;
    _grp1 = createGroup east;
    (crew _MRAP) join _grp1;

    _MRAP allowCrewInImmobile true;
    _MRAP lock 2;
	_MRAPCount = _MRAPCount + 1;
	_grp1 setGroupIdGlobal [format ['Side-MRAP-%1', _MRAPCount]];
    _spawnedUnits pushBack _MRAP;
    { _spawnedUnits pushBack _x; } forEach (crew _MRAP);

    [_grp1, _smPos, _radiusSize] call AW_fnc_taskCircPatrol;
    _grp1 setSpeedMode "LIMITED";
};

//-------------------------------------------------- random vehcs
private _RandomVicCount = 0;
for "_x" from 1 to _randomVehcsAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;
	private _vehicleType = selectRandom ["O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","I_APC_tracked_03_cannon_F", "I_LT_01_AT_F", "I_LT_01_AA_F", "I_LT_01_cannon_F"];
    private _vehc = _vehicleType createVehicle _randompos;

    createVehicleCrew _vehc;
    _grp1 = createGroup east;
    (crew _vehc) join _grp1;

    _vehc allowCrewInImmobile true;
    _vehc lock 2;
	_RandomVicCount = _RandomVicCount + 1;
	_grp1 setGroupIdGlobal [format ['Side-RandomVic-%1', _RandomVicCount]];
    _spawnedUnits pushBack _vehc;
    {  _spawnedUnits pushBack _x; } forEach (crew _vehc);

    [_grp1, _smPos, _radiusSize] call AW_fnc_taskCircPatrol;
    _grp1 setSpeedMode "LIMITED";
};

//-------------------------------------------------- main infantry groups
private _MaininfCount = 0;
mainAoPatrolDistance = _radiusSize/10;
for "_x" from 1 to _infantryGroupsAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize * 1.2), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;

	private ["_Faction","_normalInfGroup","_infteamPatrol"];
    _Faction = selectRandom ["OPF_F","OPF_F","OPF_T_F"];
    if (_Faction == "OPF_F") then {
        _normalInfGroup = selectRandom ["OIA_InfAssault","OIA_InfSquad","OIA_InfSquad_Weapons","OIA_InfTeam","OIA_GuardSquad","OIA_GuardTeam"];
        /*OI_reconPatrol OI_reconTeam OI_SniperTeam OIA_InfTeam_AA OIA_InfTeam_AT OIA_ReconSquad OI_ViperTeam OI_support_MG*/
    } else {
        _normalInfGroup = selectRandom ["O_T_InfSquad","O_T_InfSquad_Weapons","O_T_InfTeam"];
        /*O_T_InfTeam_AA O_T_InfTeam_AT O_T_reconPatrol O_T_reconSentry O_T_reconTeam O_T_SniperTeam O_T_ViperTeam O_T_support_MG*/
    };
    switch (_normalInfGroup) do {
        //normal infantry groups
        case "O_T_InfSquad";
        case "O_T_InfSquad_Weapons";
        case "O_T_InfTeam";
        case "OIA_InfAssault";
        case "OIA_InfSquad";
        case "OIA_InfSquad_Weapons";
        case "OIA_InfTeam": {_infteamPatrol = [_randomPos, east, (configFile >> "CfgGroups" >> "East" >> _Faction >> "Infantry" >> _normalInfGroup)] call BIS_fnc_spawnGroup;};
        //guard inf
        case "OIA_GuardTeam";
        case "OIA_GuardSquad": {_infteamPatrol = [_randomPos, east, (configFile >> "CfgGroups" >> "East" >> _Faction >> "UInfantry" >> _normalInfGroup)] call BIS_fnc_spawnGroup;};
        default {diag_log "ERROR: fn_mainAOSpawnHandler.sqf: main infantry group spawn.  Group was not recognized"};
    };
    mainAoPatrolDistance = mainAoPatrolDistance + 25 + floor(random (75));
    if (mainAoPatrolDistance > _radiusSize*1.2) then {mainAoPatrolDistance = _radiusSize/10 + 25 + floor(random (75));};
    [_infteamPatrol, _smPos, mainAoPatrolDistance] call AW_fnc_taskCircPatrol;
	_MaininfCount = _MaininfCount + 1;
	_infteamPatrol setGroupIdGlobal [format ['Side-MainInf-%1', _MaininfCount]];

    { _spawnedUnits pushBack _x; } forEach (units _infteamPatrol);
};


//-------------------------------------------------- AA groups
private _AAInfAmount = 0;
for "_x" from 1 to _AAGroupsAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;

	private _infantryGroup = [_randomPos, east, (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
    _AAInfAmount = _AAInfAmount + 1;
	_infantryGroup setGroupIdGlobal [format ['Side-AAInf-%1', _AAInfAmount]];

    mainAoPatrolDistance = mainAoPatrolDistance + 25 + floor(random (75));
    if (mainAoPatrolDistance > _radiusSize*1.2) then {mainAoPatrolDistance = _radiusSize/10 + 25 + floor(random (75));};
    [_infantryGroup, _smPos, mainAoPatrolDistance] call AW_fnc_taskCircPatrol;

    { _spawnedUnits pushBack _x; } forEach (units _infantryGroup);
};

//-------------------------------------------------- AT groups
private _ATInfAmount = 0;
for "_x" from 1 to _ATGroupsAmount do {
	private _randomPos = [_smPos, 10, (_radiusSize), 5, 0, 0.3, 0, [], _smPos] call BIS_fnc_findSafePos;
	
    private _infantryGroup = [_randomPos, east, (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT")] call BIS_fnc_spawnGroup;
	_ATInfAmount = _ATInfAmount + 1;
	_infantryGroup setGroupIdGlobal [format ['Side-ATInf-%1', _ATInfAmount]];
    mainAoPatrolDistance = mainAoPatrolDistance + 25 + floor(random (75));
    if (mainAoPatrolDistance > _radiusSize*1.2) then {mainAoPatrolDistance = _radiusSize/10 + 25 + floor(random (75));};
    [_infantryGroup, _smPos, mainAoPatrolDistance] call AW_fnc_taskCircPatrol;

    { _spawnedUnits pushBack _x; } forEach (units _infantryGroup);
};

//-------------------------------------------------- SetSkill + network operations
[_spawnedUnits] call derp_fnc_AISkill;
{_x addCuratorEditableObjects [_spawnedUnits, true];} forEach allCurators;

_spawnedUnits