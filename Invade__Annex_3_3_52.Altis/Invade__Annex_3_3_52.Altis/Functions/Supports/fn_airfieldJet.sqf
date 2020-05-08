/*
  Author: BACONMOP
  Spawns CSAT JET to CAS strike
*/

jetCounter = jetCounter + 1;
publicVariableServer "jetCounter";
if (!isNil "HC1") then {
    (owner HC1) publicVariableClient "jetCounter";
};

private _jettype = selectRandom [
    "O_Plane_CAS_02_dynamicLoadout_F","O_Plane_CAS_02_dynamicLoadout_F","O_Plane_CAS_02_Cluster_F",
    "O_Plane_Fighter_02_F","O_Plane_Fighter_02_Cluster_F","O_Plane_Fighter_02_Stealth_F",
    "I_Plane_Fighter_04_F","I_Plane_Fighter_04_Cluster_F","I_Plane_Fighter_03_dynamicLoadout_F"
];

//Select an airfield
private ["_jet"];
private _airField = [
	"AAC_CAS_Spawn",
	"Airbase_CAS_Spawn",
	"SaltLake_CAS_Spawn",
	"Molos_CAS_Spawn"
];
if ("AAC_Airfield" in controlledZones) then {
	_airField = _airField - ["AAC_CAS_Spawn"];
};
if ("Terminal" in controlledZones) then {
	_airField = _airField - ["Airbase_CAS_Spawn"];
};
if ("Salt_Flats_North" in controlledZones) then {
	_airField = _airField - ["SaltLake_CAS_Spawn"];
};
if ("Molos_Airfield" in controlledZones) then {
	_airField = _airField - ["Molos_CAS_Spawn"];
};

//create the jet
if ((count _airField) > 0) then {
	_jetSpawn = selectRandom _airField;
	_jet = _jettype createVehicle (getMarkerPos _jetSpawn);
	_jet setDir markerDir _jetSpawn;	
} else {
	_spawnPos = [(random 1000),(random 1000),2000];
	_jet = _jettype createVehicle _spawnPos;
};

waitUntil {!isNull _jet};
//Spawn the pilot and set some other thigns
createVehicleCrew _jet;

private _jetGrp = createGroup east;
_jetGrp setGroupIdGlobal [format ['RT-Jet-%1', jetCounter]];
private _dummy = _jetGrp createUnit ["O_officer_F", [0,0,0], [], 0, "NONE"];
(crew _jet) join _jetGrp;
deleteVehicle _dummy;

_jet engineOn true;
_jet lock 2;
_jet allowCrewInImmobile true;
[[_jet]+ (units _jetGrp)] remoteExec ["AW_fnc_addToAllCurators", 2];

//Send him to the AO
_jetWp = _jetGrp addWaypoint [getMarkerPos currentAO,0];
_jetWp setWaypointType "LOITER";
_jetWp setWaypointLoiterRadius (derp_PARAM_AOSize*1.5);
_jet flyInHeight (250 + random 250);
_jet limitSpeed 375;
//Wait 2 minutes for him to get there
sleep 120;
if (alive _jet) then {
    [_jet] spawn AW_fnc_enemyAirEngagement;
} else {
    jetCounter = jetCounter - 1;
    publicVariableServer "jetCounter";
    if (!isNil "HC1") then {
        (owner HC1) publicVariableClient "jetCounter";
    };
};
