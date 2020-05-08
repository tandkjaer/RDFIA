/*
Author: Lost Bullet

Description: reinforces the AO with enemies while the factory building is up.  As long as the engineer in the factory building is alive the building cannot be destroyed.
*/

private _infTeams = ["OIA_InfTeam","OIA_InfTeam_AT","OIA_InfTeam_AA","OI_reconPatrol","OIA_GuardTeam"];
private _vehicleTypes = ["O_MBT_02_cannon_F", "O_MBT_02_cannon_F", "O_MBT_04_cannon_F", "O_MBT_04_command_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Tracked_02_AA_F", "O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","I_APC_tracked_03_cannon_F", "I_LT_01_AT_F", "I_LT_01_AA_F", "I_LT_01_cannon_F"];
private _attackheliTypes = ["O_Heli_Attack_02_dynamicLoadout_F", "O_T_VTOL_02_infantry_dynamicLoadout_F",
                            "O_Heli_Light_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F","O_Heli_Light_02_dynamicLoadout_F",
                            "I_Heli_light_03_dynamicLoadout_F","I_Heli_light_03_dynamicLoadout_F","I_Heli_light_03_dynamicLoadout_F","I_Heli_light_03_dynamicLoadout_F"];
private _jetTypes = ["O_Plane_CAS_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F","O_Plane_CAS_02_Cluster_F",
                         "O_Plane_Fighter_02_F","O_Plane_Fighter_02_Cluster_F","O_Plane_Fighter_02_Stealth_F",
                         "I_Plane_Fighter_04_F","I_Plane_Fighter_04_Cluster_F","I_Plane_Fighter_03_dynamicLoadout_F"];

PrioHeliCount = 0;

private _noSpawning =  BaseArray + [currentAO];
private _noSpawningRange = 2000;

waitUntil {sleep 0.5; !isNil "mainAOUnits"};

/* --- 1. FIND POSITION FOR OBJECTIVE --- */
	private _accepted = false;
private _flatPos = [0,0,0];

while { !_accepted } do {
    _flatPos = [getMarkerPos currentAO, missionsMinimumSpawnDistance, 4000, 5, 0, 0.2, 0, [], [0,0,0]] call BIS_fnc_findSafePos;

    _accepted = true;
    {
        if ( (_flatPos distance2D (getMarkerPos _x)) < missionsMinimumSpawnDistance) then {
            _accepted = false;
        }
    } forEach BaseArray + [currentAO];
};

/* --- 2. SPAWN OBJECTIVE --- */

	Factory = "Land_i_Shed_Ind_F" createVehicle _flatPos;
	waitUntil {!isNull Factory};
	Factory setDir random 360;
	Factory allowDamage false; //no CAS bombing it until the Engineer inside is killed.

	//===Place engineers team/objectives inside Factory
	
	//where should he be?
	private _garrisonpos = Factory buildingPos -1;
	private _engenieerpos =  selectRandom _garrisonpos;
	_garrisonpos = _garrisonpos - [_engenieerpos];
	
	private _priorityGroup = createGroup east;
    _priorityGroup setGroupIdGlobal [format ['Prio-FactoryUnits']];

	private _objectiveUnit = _priorityGroup createUnit ["O_V_Soldier_Exp_hex_F", _engenieerpos, [], 0, "CAN_COLLIDE"];
	_objectiveUnit disableAI "PATH";
	_objectiveUnit addEventHandler ["Killed",{
		params ["_unit","","_killer"];
		Factory allowDamage true;
		private _name = name _killer;
		if (_name == "Error: No vehicle") then{
		    _name = "some genius jarhead who thought it'd be a good idea to run an enemy over with his jacked up monster truck";
		};
		private _engineerkilled = format["<t align='center'><t size='2.2'>Prio Mission update</t><br/>____________________<br/>Fantastic job, lads! The OPFOR engineer has been killed by %1.  Now move in and demo that building</t>",_name];
		[_engineerkilled] remoteExec ["AW_fnc_globalHint",0,false];
	}];

	Factory addEventHandler ["Killed",{
        params ["_unit","","_killer"];
        ["priorArtyTask", "Succeeded",true] call BIS_fnc_taskSetState;
        private _name = name _killer;
        if (_name == "Error: No vehicle") then{
            _name = "someone";
        };
        private _msg = format["<t align='center'><t size='2.2'>Prio Mission Complete</t><br/>____________________<br/>Fantastic job, lads! The factory has been destroyed by %1</t>",_name];
        [_msg] remoteExec ["AW_fnc_globalHint",0,false];
        //debrief
        ["priorArtyTask", "Succeeded",true] call BIS_fnc_taskSetState;
        sleep 5;
        ["priorArtyTask",west] call bis_fnc_deleteTask;
        { _x setMarkerPos [-10000,-10000,-10000] } forEach ["priorityMarker","priorityCircle"];
    }];
	
	//fill the rest of the building
	private _buildingposcount = count _garrisonpos;
	_buildingposcount = floor(_buildingposcount*3/4);
	private _unittypes = ["O_recon_F","O_Soldier_SL_F","O_Soldier_lite_F","O_Soldier_AR_F","O_soldierU_exp_F","O_Soldier_F","O_HeavyGunner_F","O_Urban_HeavyGunner_F",
	"O_soldierU_F","O_Urban_Sharpshooter_F","O_Sharpshooter_F"];

	for "_i" from 1 to _buildingposcount do {
	    private _unitpos = (selectRandom _garrisonpos);
        private _unit = _priorityGroup createUnit [(selectRandom _unittypes), _unitpos, [], 0, "CAN_COLLIDE"];
        _garrisonpos = _garrisonpos - [_unitpos];
        _unit disableAI "PATH";
        sleep 0.1;
	};
	
	private _enemiesArray = units _priorityGroup;
    {_x addCuratorEditableObjects [(units _priorityGroup), true];} forEach allCurators;


/* --- 3. SPAWN FORCE PROTECTION --- */

	//----infantry----
	private _infteamPatrolamount = 0;
	for "_i" from 0 to (3 + (random 2)) do {
		private _infteamPatrol = createGroup east;
		private _randomPos = [position Factory, 0, (300 * 1.2), 1, 0, 0.4, 0, [], position Factory] call BIS_fnc_findSafePos;
		private _infteamPatrol = [_randomPos, east, (configFile >> "CfgGroups" >> "East" >>"OPF_F" >> "Infantry" >> selectRandom _infTeams )] call BIS_fnc_spawnGroup;
		_infteamPatrolamount = _infteamPatrolamount + 1;
		_infteamPatrol setGroupIdGlobal [format ['Prio-Protection-infantry-%1', _infteamPatrolamount]];
		[_infteamPatrol, getPos Factory, 100] call BIS_fnc_taskPatrol;
		_enemiesArray = _enemiesArray + (units _infteamPatrol);
		[(units _infteamPatrol)] call AW_fnc_setSkill2;	
		{_x addCuratorEditableObjects [units _infteamPatrol, false];} forEach allCurators;
		sleep 0.1;
	};
	//-----vehicles------
	
	private _Randomvehicle = ["O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F"];	
	
	private _Vehiclegroupamount = 0;
	for "_i" from 1 to 2 do {
		private _randomPos = [position Factory, 0, (300 * 1.2), 1, 0, 0.4, 0, [], position Factory] call BIS_fnc_findSafePos;
		private _vehicletype = selectRandom _Randomvehicle;
		_Randomvehicle = _Randomvehicle - [_vehicletype];
		_vehicle = _vehicletype createVehicle _randomPos;
		
		private _Vehiclegroup = createGroup east;
		createVehicleCrew _vehicle;
		(crew _vehicle) join _Vehiclegroup;
		
		_vehicle lock 3;
		_vehicle allowCrewInImmobile true;
		_vehicle setVehicleReportRemoteTargets false;
		_Vehiclegroupamount = _Vehiclegroupamount + 1;
		_Vehiclegroup setGroupIdGlobal [format ['Prio-Protection-vehicle-%1', _Vehiclegroupamount]];
		
		[_Vehiclegroup, getPos Factory, 100] call BIS_fnc_taskPatrol;
		{_x addCuratorEditableObjects [units _Vehiclegroup + [_vehicle], false];} forEach allCurators;
		_enemiesArray = _enemiesArray + (units _Vehiclegroup) + [_vehicle];
		sleep 0.1;
	};

/* --- 5. define the functions for the spawning of stuff --- */

private _infSpawnCode = {
    params ["_reinforceGroupamount", "_enemiesArray"];
    //ground troop multiplier --> account for number of players on AO
    private _totalspawnUnits = 3 + floor (_numPlayersinAO * 0.2);
    if (_totalspawnUnits > 16) then { _totalspawnUnits = 16;};

    private _reinforceGroup = createGroup east;
    _reinforceGroupamount = _reinforceGroupamount + 1;
    _reinforceGroup setGroupIdGlobal [format ['Prio-reinforce-infantry-%1', _reinforceGroupamount]];

    private _unitArray = (missionConfigFile >> "unitList" >> MainFaction >> "units") call BIS_fnc_getCfgData;
    private _randomspawnPosition = [position Factory, 0, (300 * 1.2), 1, 0, 0.4, 0, [], position Factory] call BIS_fnc_findSafePos;
    for "_i" from 1 to _totalspawnUnits do {
        _unit = selectRandom _unitArray;
        _grpMember = _reinforceGroup createUnit [_unit, _randomspawnPosition, [], 0, "FORM"];
        sleep 0.1;
    };
    [_reinforceGroup, getMarkerPos currentAO, (derp_PARAM_AOSize/2)] call BIS_fnc_taskPatrol;

    {_x addCuratorEditableObjects [units _reinforceGroup, false];} forEach allCurators;
    _enemiesArray = _enemiesArray + (units _reinforceGroup);
    mainAOUnits = mainAOUnits + (units _reinforceGroup);

    sleep 240;
    [_reinforceGroupamount, _enemiesArray]
};

private _vehSpawnCode = {
    params ["_reinforceGroupamount","_enemiesArray"];

    private _randomspawnPosition = [position Factory, 0, (300 * 1.2), 1, 0, 0.4, 0, [], position Factory] call BIS_fnc_findSafePos;
    private _veh = (selectRandom _vehicleTypes) createVehicle _randomspawnPosition;
    waitUntil {sleep 0.5; !isNull _veh};
    private _reinforceGroup = createGroup east;
    createVehicleCrew _veh;
    (crew _veh) join _reinforceGroup;
    _reinforceGroupamount = _reinforceGroupamount + 1;
    _reinforceGroup setGroupIdGlobal [format ['Prio-reinforce-vehicle-%1', _reinforceGroupamount]];
    [_reinforceGroup, getMarkerPos currentAO, (derp_PARAM_AOSize/2)] call BIS_fnc_taskPatrol;
    _veh lock 3;
    _veh allowCrewInImmobile true;
    _reinforceGroup setBehaviour "COMBAT";
    _reinforceGroup setCombatMode "RED";
    _veh engineOn true;

    _enemiesArray = _enemiesArray + (units _reinforceGroup) + [_veh];
    mainAOUnits = mainAOUnits + (units _reinforceGroup) + [_veh];
    {_x addCuratorEditableObjects [units _reinforceGroup + [_veh], false];} forEach allCurators;

    private _timetosleep = 300 - floor (_numPlayersinAO * 2);
    sleep _timetosleep;
    [_reinforceGroupamount, _enemiesArray]
};

private _casHeliCode = {
    params ["_reinforceGroupamount","_enemiesArray"];

    if (PrioHeliCount < 4) then {
        private _randomspawnPosition = [position Factory, 0, (300 * 1.2), 1, 0, 0.4, 0, [], position Factory] call BIS_fnc_findSafePos;
        private _veh = (selectRandom _attackheliTypes) createVehicle _randomspawnPosition;
        waitUntil {sleep 0.5; !isNull _veh};
        private _reinforceGroup = createGroup east;
        createVehicleCrew _veh;
        (crew _veh) join _reinforceGroup;
        _reinforceGroupamount = _reinforceGroupamount + 1;
        _reinforceGroup setGroupIdGlobal [format ['Prio-reinforce-heli-%1', _reinforceGroupamount]];
        [_reinforceGroup, getMarkerPos currentAO, (derp_PARAM_AOSize/2)] call BIS_fnc_taskPatrol;
        _veh lock 3;
        _veh allowCrewInImmobile true;
        _reinforceGroup setBehaviour "COMBAT";
        _reinforceGroup setCombatMode "RED";
        _veh engineOn true;
        PrioHeliCount = PrioHeliCount + 1;
        _veh addEventHandler ["Killed",{PrioHeliCount = PrioHeliCount - 1;}];
        [_veh, false, getMarkerPos currentAO, (derp_PARAM_AOSize * (0.5 + (random 0.5)))] spawn AW_fnc_enemyAirEngagement;
        _enemiesArray = _enemiesArray + (units _reinforceGroup) + [_veh];
        mainAOUnits = mainAOUnits + (units _reinforceGroup) + [_veh];
        {_x addCuratorEditableObjects [units _reinforceGroup + [_veh], false];} forEach allCurators;

    };

    private _timetosleep = 480 - floor (_numPlayersinAO * 4);
    sleep _timetosleep;
    [_reinforceGroupamount, _enemiesArray]
};

private _jetSpawnCode = {
    params ["_reinforceGroupamount","_enemiesArray"];
    if (PrioHeliCount < 3) then {
        private _jet = createVehicle [(selectRandom _jetTypes), [100,100,5000],[] , 100, "FLY"];
        _jet engineOn true;
        waitUntil {!isNull _jet};
        private _reinforceGroup = createGroup east;
        createVehicleCrew _jet;
        (crew _jet) join _reinforceGroup;
        _reinforceGroupamount = _reinforceGroupamount + 1;
        _reinforceGroup setGroupIdGlobal [format ['Prio-reinforce-jets-%1', _reinforceGroupamount]];
        PrioHeliCount = PrioHeliCount + 1;
        _jet allowCrewInImmobile true;
        _jet flyInHeight 500;
        _jet lock 2;
        [_jet, false] spawn AW_fnc_enemyAirEngagement;
        _enemiesArray = _enemiesArray + (units _reinforceGroup) + [_jet];
        _jet addEventHandler ["Killed",{PrioHeliCount = PrioHeliCount - 1;}];
    };

    _timetosleep = 480 - floor (_numPlayersinAO * 4);
    sleep _timetosleep;
    [_reinforceGroupamount, _enemiesArray]
};

/* --- 6. GET RANDOM TYPE OF FACTORY MISSION --- */
private _typeFactory = selectRandom["infantry","infantry","infantry","vehicle","vehicle","cas helicopters","cas helicopters","jets"];

/* --- 7. BRIEF --- */
    private _fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];
    { _x setMarkerPos _fuzzyPos; } forEach ["priorityMarker", "priorityCircle"];
    priorityTargetText = "Support Factory";
    "priorityMarker" setMarkerText "Priority Target: Factory";
    private _typeFactoryText = format["The enemies have set up a factory. (The factory is producing %1)  Enemy reinforcements will keep coming to the AO until this factory is taken out!  Intel suggests that the factory looks like a big industrial shed.  First kill the viper engineer inside then demo that building.  Previous sites looked like this: <br/><br/><img image='Media\Briefing\prioFactory.jpg' width='300' height='150'/>",_typeFactory];
    [west,["priorArtyTask"],[_typeFactoryText,"Priority Target: Factory","priorityCircle"],(getMarkerPos "priorityCircle"),"Created",0,true,"NewPriorityTarget",true] call BIS_fnc_taskCreate;
    ["priorArtyTask", "Created",true] call BIS_fnc_taskSetState;

/* --- 8. core loop --- */
prioMissionSpawnComplete = true;
publicVariableServer "prioMissionSpawnComplete";

private _reinforceGroupamount = 0;

while { alive Factory} do{
	
	// ---- if its the first run or current AO doesn't have friendly's, don't spawn anything ----
	_numPlayersinAO = 0;
	_playerClose = [];
	{	
		if ((_x distance (getMarkerPos currentAO)) < derp_PARAM_AOSize) then {
			_playerClose pushBack _x;
		};
	}forEach allPlayers;
	_numPlayersinAO = count _playerClose;
	sleep 0.1;
	
	if (_numPlayersinAO < 0) then{
	    //Wait 2 minutes then check if there are enough people in the AO.
		sleep 120;
		
	}else{
		//_typefactory = "cas helicopters"; //testing
		switch (_typefactory) do {
			case "infantry": {
                private _returnArray = [_reinforceGroupamount, _enemiesArray] call _infSpawnCode;
                _reinforceGroupamount = _returnArray select 0;
                _enemiesArray = _returnArray select 1;
			};
			case "vehicle": {
				 private _returnArray = [_reinforceGroupamount, _enemiesArray] call _vehSpawnCode;
                _reinforceGroupamount = _returnArray select 0;
                _enemiesArray = _returnArray select 1;
			};

			case "cas helicopters": {
				 private _returnArray = [_reinforceGroupamount, _enemiesArray] call _casHeliCode;
                _reinforceGroupamount = _returnArray select 0;
                _enemiesArray = _returnArray select 1;
			};
			case "jets": {
				 private _returnArray = [_reinforceGroupamount, _enemiesArray] call _jetSpawnCode;
                _reinforceGroupamount = _returnArray select 0;
                _enemiesArray = _returnArray select 1;
			};
		};         
	};
};

if ("priorArtyTask" call BIS_fnc_taskExists) then {
    ["priorArtyTask",west] call bis_fnc_deleteTask;
    { _x setMarkerPos [-10000,-10000,-10000] } forEach ["priorityMarker","priorityCircle"];
};

//cleanup
sleep 60;
deleteVehicle nearestObject[_flatPos, "Land_Shed_Ind_ruins_F"];
[_enemiesArray] spawn AW_fnc_SMdelete;
