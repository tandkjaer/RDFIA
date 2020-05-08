/* Author: BACONMOP
Description: Main selector for the main AO's
*/
//Set up variables
jetCounter = 0;
controlledZones = profileNamespace getVariable ["controlledZones", ["BASE"]];
capturedFOBs = profileNamespace getVariable ["capturedFOBs", []];
mainAOUnits = [];
subObjUnits = [];
manualAO = "";
missionActive = true;

waitUntil {sleep 0.1; !isNil "amountOfAOsToComplete"};
if ((count controlledZones) >= amountOfAOsToComplete) then {
    controlledZones = ["BASE"];
    capturedFOBs = [];
};

private _currentAOIndex = (count controlledZones) - 1;
currentAO = controlledZones select _currentAOIndex;
publicVariable "controlledZones";

if ((count capturedFOBs) > 0) then {
    {
        [_x] spawn { [_this select 0] call AW_fnc_BaseManager; };
        controlledZones = controlledZones + [_x];
    } forEach capturedFOBs;
};
publicVariable "capturedFOBs";

private _EnemyLeftThreshhold = 9;

diag_log(format ["Starting main AO, isNil HC1: %1", str isNil "HC1"]);

private _sendToAdminChat = {
    if (player getVariable ["isZeus", false]) then {
        if (profileNamespace getVariable ["enabledAOMsg", false]) then {
            params ["_msg"];
            Quartermaster customChat [adminChannelID, _msg];
        };
    };
};

while {missionActive} do {
    currentAO = [currentAO] call AW_fnc_getAo;
    if(!isNil "HC1") then {
        (owner HC1) publicVariableClient "currentAO";
    };

    manualAO = "";
    mainAOUnitsSpawnCompleted = false;

    if (isNil "HC1" || count controlledZones < 1) then {
        [["HC1 not found, spawning AO units on server"], _sendToAdminChat] remoteExec ["spawn", 0];
        [getMarkerPos currentAO] spawn derp_fnc_mainAOSpawnHandler;
        if (isNil "HC1") then {
            diag_log("Unit being spawned on server because HC1 was not found");
        } else {
            diag_log("First AO, not spawning on HC1");
        };
    } else {
        [getMarkerPos currentAO, derp_PARAM_AOSize] remoteExec ["derp_fnc_mainAOSpawnHandler", HC1];
        [["HC1 found, spawning AO units on headless client"], _sendToAdminChat] remoteExec ["spawn", 0];
    };

    private _timer = 0;
    while {!mainAOUnitsSpawnCompleted} do {
        sleep 1;
        _timer = _timer + 1;
        if (_timer > 120) exitWith {
            private _msg = format ["ERROR: AO %1 failed to spawn its units in under 2 minutes", (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData];
            [[_msg], _sendToAdminChat] remoteExec ["spawn", 0];
            [_msg] remoteExec ["diag_log", 2];
        };
    };

    //Spawn Markers and Notifications -----------------------
    private _name = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
    "aoMarker" setMarkerText _name;
    {_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle","aoMarker"];
    private _targetStartText = format["<t align='center' size='2.2'>New Target</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>Good work on that last OP. I want to see the same again. We have a new objective you you. High Command has decided that %1 is of strategic value.<br/><br/>Don't forget about the secondary targets.", _name ];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];

    private _mainAoTaskName = format ["Take %1", _name];
    private _mainAoTaskDesc = format ["Clear %1 of hostile forces.", _name];
    [west,["MainAoTask"],[_mainAoTaskDesc,_mainAoTaskName,currentAO],(getMarkerPos currentAO),"Created",0,true,"attack",true] call BIS_fnc_taskCreate;

    subObjComplete = 0;
    subObjScript = [] execVM "Missions\Main\SubObj.sqf";

    private _mainMissionTreshold = createTrigger ["EmptyDetector", getMarkerPos currentAO];
    _mainMissionTreshold setTriggerArea [800, 800, 0, false];
    _mainMissionTreshold setTriggerActivation ["EAST", "PRESENT", false];
    _mainMissionTreshold setTriggerStatements ["this","",""];

    waitUntil {sleep 7; subObjComplete == 1 || !missionActive;};

    private _heliReinf = [currentAO, "airCavSpawnMarker"] call AW_fnc_airCav;
    mainAOUnits = mainAOUnits + _heliReinf;

    waitUntil {sleep 5;(count list _mainMissionTreshold < _EnemyLeftThreshhold) || !missionActive;};

    controlledZones = controlledZones + [currentAO];
    publicVariable "controlledZones";
    deleteVehicle _mainMissionTreshold;

    private _targetStartText = format["<t align='center' size='2.2'>Secured</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>Good work out there. We have provided you with some light assets to help you redeploy to the next assignment.", _name ];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
    ["MainAoTask", "Succeeded",true] call BIS_fnc_taskSetState;

    {
        if (!(isNull _x) && {alive _x}) then {
            if (_x isKindOf "AllVehicles") then {
                private _myvehicle = _x;
                {_myvehicle deleteVehicleCrew _x} forEach crew _myvehicle;
            };
            deleteVehicle _x;
        };
    } forEach (mainAOUnits + subObjUnits);

    sleep 1;
    ["MainAoTask",west] call bis_fnc_deleteTask;
    { _x setMarkerPos [-10000,-10000,-10000]; } forEach ["aoCircle","aoMarker"];

    mainAOUnits = [];
    subObjUnits = [];

    private _type = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "type") call BIS_fnc_getCfgData;
    if (_type == "base") then {
        [currentAO] call AW_fnc_BaseManager;
        capturedFOBs pushBack currentAO;
        publicVariable "capturedFOBs";
    };

    if (count controlledZones >= amountOfAOsToComplete) then {
        missionActive = false;
        [] spawn {
            profileNamespace setVariable ["capturedFOBs", []];
            sleep 0.1;
            profileNamespace setVariable ["controlledZones", ["BASE"]];
            sleep 0.1;
            saveProfileNamespace;
            sleep 1;
            [["success", true, true, true, false],BIS_fnc_endMission] remoteExecCall["spawn", 0];
        };
    };

    "captureProgress" setMarkerText format["Capture progress: %1%2", round ((count controlledZones / amountOfAOsToComplete) *100), "%"];

    //admin wanted a restart:
    if (!isNil "missionRestartAfterCurrentAO") then {
        if (missionRestartAfterCurrentAO) then { [] call missionRestart; };
    };

    if (!isNil "serverRestartAfterCurrentAO") then {
        if (serverRestartAfterCurrentAO) then { [] call serverRestart; };
    };
};
diag_log("MAIN AO: ERROR: something went wrong, the end of main_machine.sqf was reached.");
