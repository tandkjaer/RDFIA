/*
Author:	Quiksilver (credit Rarek [AW] for initial design)

Description:
	Secure explosives crate on coastal HQ.
	Destroying the HQ first yields failure.
	Securing the weapons first yields success.
*/
private _noSpawning =  BaseArray + [currentAO];
private _noSpawningRange = 2500;

//-------------------- FIND SAFE POSITION FOR MISSION
private _accepted = false;
private _flatPos = [0,0,0];

while { !_accepted } do {
    _flatPos = [getMarkerPos currentAO, missionsMinimumSpawnDistance, 15000, 5, 0, 0.2, 1, [], [0,0,0]] call BIS_fnc_findSafePos;

    _accepted = true;
    {
        if ( (_flatPos distance2D (getMarkerPos _x)) < missionsMinimumSpawnDistance) then {
            _accepted = false;
        }
    } forEach BaseArray + [currentAO];

};

//------------------------------------------- SPAWN OBJECTIVE AND AMBIENCE
	private _randomDir = (random 360);
	sideObj = "Land_Cargo_HQ_V1_F" createVehicle _flatPos;
	waitUntil {alive sideObj};
	sideObj enableSimulationGlobal true;
    sideObj enableDynamicSimulation true;
	sideObj animate ["door_1_rot", 1];
	sideObj setDir _randomDir;
	sideObj setVectorUp [0,0,1];

	private _objectType = selectRandom ["Box_NATO_AmmoVeh_F","Box_East_AmmoVeh_F","O_supplyCrate_F","B_CargoNet_01_ammo_F","CargoNet_01_box_F"];
    private _object = _objectType createVehicle _flatPos;

    [sideObj,_object,[0,0,0.7]] call BIS_fnc_relPosObject;

    [_object,"Plant charges",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\destroy_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa",
    "_target distance _this <= 5","_target distance _this <= 5",
    {   hint "Planting charges ...";
         params ["","_hero"];
        if ( currentWeapon _hero != "" ) then
        {	_hero action ["SwitchWeapon", _hero, _hero, 99]; };
        _hero playMoveNow "AinvPknlMstpSnonWnonDnon_medic3";
    },{},{
         [] spawn {
             private _sidecompleted = format["<t align='center'><t size='2.2'>Side-mission update</t><br/>____________________<br/>%1 planted charges on the objective.  Clear the area, detonation in 30 seconds!</t>",name player];
             [_sidecompleted] remoteExec ["AW_fnc_globalHint",0,false];

             sleep 1;
             SM_SUCCESS = true;
             publicVariableServer "SM_SUCCESS";
         };
     },
    {   hint "You stopped planting charges.";
        private _unit = _this select 1;
        _unit playMoveNow "";
    },[], 8, 0,true,false] remoteExecCall ["BIS_fnc_holdActionAdd", 0, true];

	//--------- BOAT POSITIONS
	private _boatPos = [_flatPos, 50, 150, 10, 2, 1, 0] call BIS_fnc_findSafePos;
	private _trawlerPos = [_flatPos, 200, 300, 10, 2, 1, 0] call BIS_fnc_findSafePos;

	//--------- ENEMY HMG BOAT (SEEMS RIGHT SINCE ITS BY THE COAST)

	private _boat = "O_Boat_Armed_01_hmg_F" createVehicle _boatPos;
	waitUntil {sleep 0.1; alive _boat};

	private _smuggleGroup = createGroup east;
	private _commander = _smuggleGroup createUnit ["O_diver_TL_F", _boatPos, [], 0, "NONE"];
	private _driver = _smuggleGroup createUnit ["O_diver_F", _boatPos, [], 0, "NONE"];
	private _cargo1 = _smuggleGroup createUnit ["O_diver_F", _boatPos, [], 0, "NONE"];
	private _cargo2 = _smuggleGroup createUnit ["O_diver_F", _boatPos, [], 0, "NONE"];
	private _cargo3 = _smuggleGroup createUnit ["O_diver_F", _boatPos, [], 0, "NONE"];
	private _cargo4 = _smuggleGroup createUnit ["O_diver_F", _boatPos, [], 0, "NONE"];

	_commander assignAsCommander _boat;
	_commander moveInCommander _boat;
	_driver assignAsDriver _boat;
	_driver moveInDriver _boat;
	_cargo1 assignAsCargo _boat;
	_cargo1 moveInCargo _boat;
	_cargo2 assignAsCargo _boat;
    _cargo2 moveInCargo _boat;
	_cargo3 assignAsCargo _boat;
    _cargo3 moveInCargo _boat;
	_cargo4 assignAsCargo _boat;
    _cargo4 moveInCargo _boat;

	_boat lock 3;

    [(units _smuggleGroup)] call AW_fnc_setSkill2;
	[_smuggleGroup, getPos sideObj, 150] call BIS_fnc_taskPatrol;
	
	{_x addCuratorEditableObjects [units _smuggleGroup + [_boat], false];} forEach allCurators;
	_smuggleGroup setGroupIdGlobal [format ['Side-AssaultBoat']];
	private _unitsArray = (units _smuggleGroup);

	//---------- SHIPPING TRAWLER FOR AMBIENCE
	private _trawler = "C_Boat_Civil_04_F" createVehicle _trawlerPos;
	_trawler setDir random 360;
	_trawler allowDamage false;

//-------------------- SPAWN FORCE PROTECTION
	private _enemiesArray = [sideObj] call AW_fnc_SMenemyEAST;

//-------------------- BRIEFING
	private _fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];

	{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
	sideMarkerText = "Secure Smuggled Explosives";
	"sideMarker" setMarkerText "Side Mission: Secure Smuggled Explosives";
    [west,["hqCoastTask"],[
    "OPFOR have been smuggling explosives onto the island and hiding them in a Mobile HQ on the coastline.We've marked the building on your map; head over there and secure the current shipment. Keep well back when you blow it, there's a lot of stuff in that building.  Aerial surveillance suggests the building will look like this: <br/><br/><img image='Media\Briefing\hqCoast.jpg' width='300' height='150'/>"
    ,"Side Mission: Secure Smuggled Explosives","sideCircle"],(getMarkerPos "sideCircle"),"Created",0,true,"search",true] call BIS_fnc_taskCreate;
	sideMissionSpawnComplete = true;
	publicVariableServer "sideMissionSpawnComplete";


//-------------------- [ CORE LOOPS ]----------------------- [CORE LOOPS]
	sideMissionUp = true;
	SM_SUCCESS = false;
	private _objPos = getPos _object;

waitUntil {sleep 5; !sideMissionUp || SM_SUCCESS|| !alive _object};

	if (!sideMissionUp) then {
        deleteVehicle _object;
		//-------------------- DE-BRIEFING
		sideMissionUp = false;
		SM_SUCCESS = false;
        ["hqCoastTask", "Failed",true] call BIS_fnc_taskSetState;
	};

	if (SM_SUCCESS) then {
        sleep 30;
        "Bo_GBU12_LGB" createVehicle _objPos; 		
        deleteVehicle _object;
		
		//-------------------- DE-BRIEFING
		sideMissionUp = false;
		[nil, nil, _flatPos] call AW_fnc_SMhintSUCCESS;
        ["hqCoastTask", "SUCCEEDED",true] call BIS_fnc_taskSetState;
		
        sleep (4 + (random 3));
        "SmallSecondary" createVehicle (_objPos getPos [random 2, random 360]);
        sleep 0.2;
        "SmallSecondary" createVehicle (_objPos getPos [random 2, random 360]);
        sleep (2 + (random 2));
        "SmallSecondary" createVehicle (_objPos getPos [random 3, random 360]);
        sleep (1 + (random 2));
        "SmallSecondary" createVehicle (_objPos getPos [random 3, random 360]);
        sleep 0.2;
        "SmallSecondary" createVehicle (_objPos getPos [random 4, random 360]);
	};

	if (!alive _object && !SM_SUCCESS) then {
        //-------------------- DE-BRIEFING
        sideMissionUp = false;
        [nil, nil, _flatPos] call AW_fnc_SMhintSUCCESS;
        deleteVehicle _object;
        ["hqCoastTask", "SUCCEEDED",true] call BIS_fnc_taskSetState;
     };

	sleep 5;
	["hqCoastTask",west] call bis_fnc_deleteTask;
	{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"];

	//cleanup
	sleep 120;

	{ deleteVehicle _x } forEach [_boat,_trawler];

	if (!alive sideObj)then {
        deleteVehicle nearestObject [_flatPos,"Land_Cargo_HQ_V1_ruins_F"];
    } else {
        deleteVehicle sideObj
    };

	{ [_x] spawn AW_fnc_SMdelete } forEach [_unitsArray,_enemiesArray];