/*
@filename: QS_fnc_SMenemyEASTintel.sqf
Author: 

	Quiksilver
	
Last modified:

	25/04/2014

Description:

	Spawn OPFOR enemy around intel objectives
	Enemy should have backbone AA/AT + random composition.
	Smaller number of enemy due to more complex objective.
	
___________________________________________*/

//---------- CONFIG
params["_intelObj"];
private _infTeams =[ "OIA_InfTeam","OIA_InfTeam_AT","OIA_InfTeam_AA","OI_reconPatrol","OIA_GuardTeam"];
private _vehTypes =[ "O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Tracked_02_cannon_F"];
private ["_pos","_flatPos","_randomPos","_unitsArray","_infteamPatrol","_SMvehPatrol","_SMveh","_SMaaPatrol","_SMaa"];
private _enemiesArray = [grpNull];

//---------- INFANTRY

for "_x" from 0 to (1 + (random 3)) do {
	_infteamPatrol = createGroup east;
	_randomPos = [(getPos _intelObj), 10, (300), 5, 0, 0.3, 0, [], getPos _intelObj] call BIS_fnc_findSafePos;
	
	_infteamPatrol = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom _infTeams) )] call BIS_fnc_spawnGroup;
	[_infteamPatrol, getPos _intelObj, 100] call BIS_fnc_taskPatrol;
	[(units _infteamPatrol)] call AW_fnc_setSkill2;
				
	_enemiesArray = _enemiesArray + [_infteamPatrol];

	{
		_x addCuratorEditableObjects [units _infteamPatrol, false];
	} foreach allCurators;

};

//---------- RANDOM VEHICLE
_SMvehPatrol = createGroup east;
_randomPos = [(getPos _intelObj), 10, (300), 5, 0, 0.3, 0, [], (getPos _intelObj)] call BIS_fnc_findSafePos;
private _SMveh = (selectRandom _vehTypes) createVehicle _randomPos;
waitUntil {sleep 0.5; !isNull _SMveh};
[_SMveh, _SMvehPatrol] call BIS_fnc_spawnCrew;
[_SMvehPatrol, getPos _intelObj, 150] call BIS_fnc_taskPatrol;
[(units _SMvehPatrol)] call AW_fnc_setSkill2;
_SMveh lock 3;
if (random 1 >= 0.5) then {
	_SMveh allowCrewInImmobile true;
};
	
_enemiesArray = _enemiesArray + [_SMvehPatrol];
sleep 0.1;
_enemiesArray = _enemiesArray + [_SMveh];

{
	_x addCuratorEditableObjects [[_SMveh], false];
	_x addCuratorEditableObjects [units _SMvehPatrol, false];
} foreach allCurators;

_enemiesArray