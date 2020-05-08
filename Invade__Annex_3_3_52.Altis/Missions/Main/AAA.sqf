/*
author: stanhope, AW community member.
description: spawns a AAA truck as subobj
*/

private _flatPos = [getMarkerPos currentAO, 10, derp_PARAM_AOSize, 3, 0, 0.1, 0, [], [0,0,0]] call BIS_fnc_findSafePos;
private _position = _flatPos;

private _truck = "O_Truck_03_transport_F" createVehicle _flatPos;
private _AAA = "B_AAA_System_01_F" createVehicle _flatPos;
_truck setVariable ["_AAA", _AAA];
_AAA setVariable ["_truck", _truck];
[_AAA,["Green",1], true] call BIS_fnc_initVehicle;

_truck setDir 0;
_AAA attachTo [_truck,[0,-2.5,2.1]];
_AAA setDir 180;
_AAA setVehicleRadar 1;

private _aoTankGroup = createGroup east;
_aoTankGroup setGroupIdGlobal [format ['AO-subobjAAA']];

createVehicleCrew _truck;
(crew _truck) join _aoTankGroup;
_truck lock 3;
_truck allowCrewInImmobile true;

private _AAACrew = _aoTankGroup createUnit ["O_UAV_AI_F", [0,0,0], [], 0, "NONE"];
_AAACrew moveInAny _AAA;

_AAA addEventHandler ["Killed",{
    params ["_AAA","","_killer"];
    private _name = name _killer;
	if (_name == "Error: No vehicle") then{ _name = "Someone"; };
	_aoName = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
    _targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Update</t><br/>____________________<br/>%2 destroyed the goalkeeper. CSAT will now have a tougher time keeping a hold of %1.",_aoName,_name];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
    private _truck = _AAA getVariable ["_truck", objNull];
    _truck setDamage 1;
}];
_truck addEventHandler ["Killed",{
    params ["_truck","","_killer"];
    private _name = name _killer;
	if (_name == "Error: No vehicle") then{ _name = "Someone"; };
	_aoName = (missionConfigFile >> "Main_Aos" >> "AOs" >> currentAO >> "name") call BIS_fnc_getCfgData;
    _targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Update</t><br/>____________________<br/>%2 destroyed the goalkeeper. CSAT will now have a tougher time keeping a hold of %1.",_aoName,_name];
    [_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
    private _AAA = _truck getVariable ["_AAA", objNull];
    _AAA setDamage 1;
}];

[_aoTankGroup, _flatPos, 175] call BIS_fnc_taskPatrol;
{_x addCuratorEditableObjects [[_truck,_AAA] + units _aoTankGroup, false];} forEach allCurators;

{_x setMarkerPos _position; } forEach ["radioMarker","radioCircle"];
"radioMarker" setMarkerText "Sub-Objective: Goalkeeper";
_targetStartText = format["<t align='center' size='2.2'>Sub-Objective</t><br/><t size='1.5' align='center' color='#FFCF11'>Goalkeeper</t><br/>____________________<br/>OPFOR is fieldtesting their latest prototype AAA system.  A goalkeeper strapped to a transport truck.  Take it out before so they don't get any usefull data from the test.<br/><br/>"];
[_targetStartText] remoteExec ["AW_fnc_globalHint",0,false];
[west,["SubAoTask","MainAoTask"],[
"OPFOR is fieldtesting their latest prototype AAA system.  A goalkeeper strapped to a transport truck.  Take it out before so they don't get any usefull data from the test.  Intel suggest it'll look like this:<br/><br/><img image='Media\Briefing\goalKeeper.jpg' width='300' height='150'/>",
"Goalkeeper","radioMarker"],(getMarkerPos "radioMarker"),"Created",0,true,"destroy",true] call BIS_fnc_taskCreate;

waitUntil{sleep 3; !alive _AAA && !alive _truck};

["SubAoTask", "Succeeded",true] call BIS_fnc_taskSetState;
sleep 5;
["SubAoTask",west] call bis_fnc_deleteTask;
  
{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["radioMarker","radioCircle"];
