/*
Author:	Quiksilver

Description:	Mission control
*/
private ["_mission","_currentMission"];

sideMissionList = [
	"HQcoast",
	"HQresearch",
	"policeProtection",
    "prototypeTank",
	"secureIntelUnit",
	"secureIntelVehicle",
	"secureRadar",
	"destroyurban",
	"PilotRescue",
	"Viperintel",
	"MilitiaCamp",
	"FreeCivs",
	"secureAsset"
];

//enable pushing a manual type of sidemission to queue
if (isNil "manualSide") then {
    manualSide = "";
};

private _oldOldMission = "policeProtection";
private _oldMission = "policeProtection";
private _delay = 300 + (random 600);
private _loopTimeout = 10 + (random 10);

while {missionActive} do {

    //check if there's a manualSide in queue and assign that if valid
    if (manualSide != "") then {
        if ((sideMissionList find manualSide) > -1) then {
            _mission = manualSide;
        } else {
            _mission = selectRandom (sideMissionList - [_oldMission, _oldOldMission]);
        };
    } else {
        _mission = selectRandom (sideMissionList - [_oldMission, _oldOldMission]);
    };

    //start the mission
    _currentMission = execVM format ["missions\side\%1.sqf", _mission];
    _oldOldMission = _oldMission;
    _oldMission = _mission;
    sideMissionSpawnComplete = false;
    publicVariableServer "sideMissionSpawnComplete";
    _shouldterminate = true;

    //reset manualSide
    manualSide = "";

    //waiting for the mission to let us know that it successfully spawned
    for "_i" from 0 to 60 do {
        sleep 5;
        if (sideMissionSpawnComplete) exitWith {
        _shouldterminate = false;
        };
    };

    if (_shouldterminate) then {
        terminate _currentMission;
        diag_log format["ERROR: SIDE MISSION CONTROL: mission %1 failed to spawn and was terminated", _mission];
    } else {
        waitUntil {sleep 5;	scriptDone _currentMission};
        sleep _delay;
    };

	sleep _loopTimeout;
};