/*author: stanhope, AW community member.*/

private _flatPos = [getMarkerPos currentAO, 10, derp_PARAM_AOSize, 5, 0, 0.1, 0, [], [0,0,0]] call BIS_fnc_findSafePos;

private _tankType = ["O_MBT_02_cannon_F", "O_MBT_02_cannon_F", "O_MBT_04_cannon_F","O_MBT_02_cannon_F", "O_MBT_02_cannon_F", "O_MBT_04_cannon_F","O_MBT_04_command_F", "I_MBT_03_cannon_F"];

private _aoTankGroup = createGroup east;
_aoTankGroup setGroupIdGlobal [format ['AO-subobjTanks']];
private _tank1 = createVehicle [selectRandom _tankType, _flatPos, [], 0, "NONE"];
private _tank2 = createVehicle [selectRandom _tankType, _flatPos, [], 0, "NONE"];
private _tank3 = createVehicle [selectRandom _tankType, _flatPos, [], 0, "NONE"];
{
    createVehicleCrew _x;
    (crew _x) join _aoTankGroup;
    sleep 0.1;
    _x lock 3;
    _x allowCrewInImmobile true;
    _x addEventHandler ["Killed",{
        params ["_unit","","_killer"];
        private _name = name _killer;
        if (_name == "Error: No vehicle") then{
			_name = "Someone";
		};
		private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
		private _aoName = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
        private _targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Update</t><br/>____________________<br/>%2 destroyed one of a %3. Good job! Make sure to also find and eliminate the other tanks at %1.",_aoName,_name, _vehicleName];
        [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
    }];
} forEach [_tank1, _tank2, _tank3];

[_aoTankGroup, _flatPos, 175] call BIS_fnc_taskPatrol;
_aoTankGroup setFormation "COLUMN";
_aoTankGroup setSpeedMode "LIMITED";
{_x addCuratorEditableObjects [units _aoTankGroup + [_tank1,_tank2,_tank3], false];} forEach allCurators;

{_x setMarkerPos _flatPos; } forEach ["radioMarker","radioCircle"];
"radioMarker" setMarkerText "Sub-Objective: tank section";
_targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Tank Section</t><br/>____________________<br/>OPFOR have called in a tank section.  Find and destroy these MBTs, they must not survive this AO.<br/><br/>"];
[_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
[west,["SubAoTask","MainAoTask"],["OPFOR have called in a tank section.  Find and destroy these MBTs, they must not survive this AO.","Tank Section","radioMarker"],(getMarkerPos "radioMarker"),"Created",0,true,"destroy",true] call BIS_fnc_taskCreate;

waitUntil{sleep 3; !alive _tank1 && !alive _tank2 && !alive _tank3};

["SubAoTask", "Succeeded",true] call BIS_fnc_taskSetState;
sleep 5;
["SubAoTask",west] call bis_fnc_deleteTask;
  
{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["radioMarker","radioCircle"];
