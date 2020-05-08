/*
Author:	BACONMOP
Edited by:
    S0zi0p4th
    Ryko
    Stanhope
    LostBullet
    McKillen

Description:	Things that may run on the server.
*/

enableSaving false;
enableEnvironment false;

jetspawnpos = 0;

//let's start this baby up
missionsMinimumSpawnDistance = 1500;
[] spawn {
	execVM "Local\localInit.sqf";	                                    //defines map specific stuff on server
	execVM "scripts\vehicle\VehicleRespawn.sqf";                        //vehicle respawn server script
	if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
	    [] execVM "scripts\misc\radioChannelChart.sqf";
	};
	sleep 4;
	mainObjScript = [] execVM "Missions\Main\Main_Machine.sqf";			// Main Aos
	waitUntil {sleep 0.1; !isNil "BaseArray"};
	waitUntil {sleep 0.1; !isNil "mainAOUnits"};
	waitUntil {sleep 0.1; !isNil "currentAO"};
	waitUntil {sleep 0.1; !isNil "missionsMinimumSpawnDistance"};
	prioObjScript = [] execVM "Missions\Priority\MissionControl.sqf";	// Priority Missions
	sideObjScript = [] execVM "Missions\Side\MissionControl.sqf";		// Side Missions
	sleep 3;
	execVM "scripts\misc\cleanup.sqf";									// cleanup
	execVM "scripts\misc\zeusupdater.sqf";								// zeus updater
};

//BIS Dynamic Groups:
["Initialize"] call BIS_fnc_dynamicGroups;

//Server functions
serverRestart = {
    diag_log "Server restart function was called by the mission";
	private _serverpassword = [] call getServerPassword;
	_serverpassword serverCommand "#shutdown";
};

missionRestart = {
    diag_log "Mission restart function was called by the mission";
	private _serverpassword = [] call getServerPassword;
	_serverpassword serverCommand "#restart";
};

delayedFunction = {
    params ["_sleepTime", "_function", "_params"];
    sleep _sleepTime;
    _params spawn _function;
};

//======================Zeus Modules
zeusModules = [zeus_1, zeus_2, zeus_3, zeus_4, zeus_5, zeus_6, zeus_7, zeus_8, zeus_9, zeus_10, zeus_11, zeus_12, zeus_13, zeus_14, zeus_15, zeus_16, zeus_17, zeus_18, zeus_19, zeus_20, zeus_21, zeus_22, zeus_23, zeus_24, zeus_25, zeus_26, zeus_27, zeus_28, zeus_29, zeus_30, zeus_31, zeus_32, zeus_33, zeus_34, zeus_35, zeus_36, zeus_37, zeus_38, zeus_39, zeus_40, zeus_41, zeus_42, zeus_43, zeus_44, zeus_45];

// get local Zeus info
#include "\arma3_readme.txt";

addMissionEventHandler ["HandleDisconnect", {
		params ["_unit", "", "", "_name"];
		if !( isNil {_unit getVariable 'zeusModule'} ) then{
			_zeus = _unit getVariable 'zeusModule';
			unassignCurator (zeusModules select _zeus);
		};
		if ("derp_revive" in (getMissionConfigValue "respawnTemplates")) then {
			_unit setVariable ["derp_revive_downed", false, true];
		};
		false
	}
];

[] spawn {
    zeus_1 addEventHandler ["CuratorPinged", {
        params ["_curator", "_unit"];

        private _pingTime = _unit getVariable ["zeusPingTime", 0];
        if (_pingTime == round(time)) exitWith {};
        _unit setVariable ["zeusPingTime", round(time)];

        private _curatorFound = allPlayers findIf {_x getVariable ["isZeus", false]};
        if ( _curatorFound == -1 ) exitWith {
            "Zeus is not online at the moment. If you have an urgent matter, notify admins on discord with the !admin command." remoteExecCall ["hint", _unit];
        };

        private _pingLimit = _unit getVariable ["zeusPingLimit", 0];
        _pingLimit = _pingLimit + 1;
        if (_pingLimit > 10) then {
          ["ZEUS PINGED", "You exceeded the maximum amount of times you're allowed to ping zeus."] remoteExecCall ["hintC", _unit];
            [_unit] remoteExecCall ["forceRespawn", _unit];
        } else {
            ["ZEUS PINGED", "Zeus has been made aware of your request. Your ping has been transmitted, and further pings will produce this hint."] remoteExecCall ["hintC", _unit];
        };

        _unit setVariable ["zeusPingLimit", _pingLimit];
        [ _unit ] spawn {
            sleep 60;
            params ["_unit"];
            private _pingLimit = _unit getVariable ["zeusPingLimit", 0];
            _pingLimit = _pingLimit - 1;
            if (_pingLimit > 0) then {
                _unit setVariable ["zeusPingLimit", _pingLimit];
            };
        };

        private _msg = format ['Zeus was pinged by: %1', _name];
        [Quartermaster, [adminChannelID, _msg]] remoteExecCall ["customChat", getAssignedCuratorUnit _curator, false];

        true
    }];
};

[] spawn {
    {
        _x addEventHandler ["CuratorObjectPlaced", {
            params ["_curator", "_entity"];

            [[_entity]] remoteExec ["AW_fnc_addToAllCurators", 2];

            if (!isNil "HC1") then {
                if (owner HC1 == 0 || owner _entity == 0) exitWith {};

                if (! ((group _entity) isEqualTo grpNull)) then {
                    [(group _entity), (owner HC1)] remoteExec ["setGroupOwner", 2];
                };
                [_entity, (owner HC1)] remoteExec ["setOwner", 2];
            };
        }];
    } forEach allCurators;
};

	/*------------------- Restricted slots ------------------------------*/

allowed = call compile preprocessFileLineNumbers "allowedIDs.txt";
