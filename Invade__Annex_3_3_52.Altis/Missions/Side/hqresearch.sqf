/*@file: HQresearch.sqf
Author:	Quiksilver

Last modified:	29/07/2017 by stanhope

modified:	pos finder

Description: Creates an HQ from which research has to be recovered.
*/

private _vehicletypes = ["O_MRAP_02_F","O_Truck_03_covered_F","O_Truck_03_transport_F","O_Heli_Light_02_unarmed_F","O_Truck_02_transport_F","O_Truck_02_covered_F","C_SUV_01_F","C_Van_01_transport_F"];

//-------------------- FIND POSITION FOR OBJECTIVE

private _accepted = false;
private _flatPos = [0,0,0];

while { !_accepted } do {

    _flatPos = [getMarkerPos currentAO, missionsMinimumSpawnDistance, 15000, 5, 0, 0.2, 0, [], [0,0,0]] call BIS_fnc_findSafePos;

    _accepted = true;
    {
        if ( (_flatPos distance2D (getMarkerPos _x)) < missionsMinimumSpawnDistance) then {
            _accepted = false;
        }
    } forEach BaseArray + [currentAO];

};

//-------------------- SPAWN OBJECTIVE BUILDING AND RELATED THINGS

	private _veh = (selectRandom _vehicletypes) createVehicle ([_flatPos, 15, 30, 10, 0, 0.5, 0] call BIS_fnc_findSafePos);
	_veh lock 3;
	private _laptopType = selectRandom ["Land_Laptop_unfolded_F","Land_Laptop_device_F"];

    sideObj = "Land_Research_HQ_F" createVehicle _flatPos;
    sideObj animate ["door_1_rot", 1];
	sideObj setVectorUp [0,0,1];
	sideObj setDir 0;

    private _laptop = _laptopType createVehicle _flatPos;
    _laptop setDir 0;
    private _table = "Land_CampingTable_small_F" createVehicle _flatPos;
    _table setDir 180;
    sleep 0.3;
    [sideObj,_table,[0,0,0.8]] call BIS_fnc_relPosObject;
    sleep 1;
    [_table,_laptop,[0,0,0.85]] call BIS_fnc_relPosObject;

     //put holdaction on laptop
    [_laptop,"Secure intel and plant charges",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa",
    "_target distance _this <= 5","_target distance _this <= 5",
    {   hint "Securing intel ... Planting charges ...";
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
    {   hint "You stopped securing the intel.";
        private _unit = _this select 1;
        _unit playMoveNow "";
    },[], 8, 0,true,false] remoteExecCall ["BIS_fnc_holdActionAdd", 0, true];

//-------------------- SPAWN FORCE PROTECTION
	private _enemiesArray = [sideObj] call AW_fnc_SMenemyEAST;

//-------------------- BRIEFING
	private _fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];

	{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
	sideMarkerText = "Seize Research Data";
	"sideMarker" setMarkerText "Side Mission: Seize Research Data";
    [west,["hqResearchTask"],[
    "OPFOR are conducting advanced military research on Altis. Find the data secure it and then torch the place!  If the data gets destroyed this mission will be a failure.  Recon reports suggest that the building will look like this: <br/><br/><img image='Media\Briefing\hqResearch.jpg' width='300' height='150'/>"
    ,"Side Mission: Seize Research Data","sideCircle"],(getMarkerPos "sideCircle"),"Created",0,true,"search",true] call BIS_fnc_taskCreate;

//-------------------- [ CORE LOOPS ] ------------------------ [ CORE LOOPS ]
    sideMissionUp = true;
    SM_SUCCESS = false;
	sideMissionSpawnComplete = true;
	publicVariableServer "sideMissionSpawnComplete";

waitUntil {sleep 5; !sideMissionUp || SM_SUCCESS || !alive _laptop};

	if (!alive _laptop || !sideMissionUp) then {
        //------------------ DE-BRIEFING
        ["hqResearchTask", "Failed",true] call BIS_fnc_taskSetState;
        sideMissionUp = false;
        SM_SUCCESS = false;
        deleteVehicle _laptop;
    };

    if (SM_SUCCESS) then {

        //-------------------- BOOM!        
        sleep 30;	    										// ghetto bomb timer
        deleteVehicle _laptop;
		"Bo_Mk82" createVehicle _flatPos; 				    // default "Bo_Mk82","Bo_GBU12_LGB"
        sleep 0.1;
        //-------------------- DE-BRIEFING
        [nil, nil, _flatPos] call AW_fnc_SMhintSUCCESS;
        ["hqResearchTask", "SUCCEEDED",true] call BIS_fnc_taskSetState;
        sideMissionUp = false;
         sleep (4 + (random 3));
        "SmallSecondary" createVehicle (_flatPos getPos [random 2, random 360]);
        sleep 0.2;
        "SmallSecondary" createVehicle (_flatPos getPos [random 2, random 360]);
        sleep (2 + (random 2));
        "SmallSecondary" createVehicle (_flatPos getPos [random 3, random 360]);
        sleep (1 + (random 2));
        "SmallSecondary" createVehicle (_flatPos getPos [random 3, random 360]);
        sleep 0.2;
        "SmallSecondary" createVehicle (_flatPos getPos [random 4, random 360]);
    };

	//-------------------- DE-BRIEFING
     sleep 5;
    ["hqResearchTask",west] call bis_fnc_deleteTask;
    { _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"];
    sideMissionUp = false;

    //--------------------- DELETE
    sleep 120;
    deleteVehicle _table;
	deleteVehicle _veh;
	if (!alive sideObj)then {
        deleteVehicle nearestObject [_flatPos,"Land_Research_HQ_ruins_F"];
    } else {
        deleteVehicle sideObj;
    };
    [_enemiesArray] spawn AW_fnc_SMdelete;