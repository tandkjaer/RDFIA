/*
author: stanhope, AW community member.

description: Respawn script for vehicles.  Lives on the server.
Uses a recursive function to avoid using a loop.

Last modified: 13/05/2019 by stanhope
Modified: initial
*/
if (!isServer) exitWith { /* GO AWAY PLAYER */ };
waitUntil {sleep 1; !isNil "controlledzones"};

/*
Elements of this array in the format:
[_veh, _vehType, _spawnPos, _spawnDir, _spawnDelay, _timeDestroyed, _base]
*/
RespawnVehiclesArray = [];

requestRespawningVehicles = {
	params ["_player"];
    private _respawnArray = [];

    {
        private _timeDestroyed = _x select 5;
        if (!(isNil "_timeDestroyed")) then {

            private _spawnDelay = _x select 4;
            private _timeLeft = (_spawnDelay - (time - _timeDestroyed));
            _timeLeft = _timeLeft/60;
            _timeLeft = round _timeLeft;
            if (_timeLeft < 0) then {_timeLeft = 0;};

            private _displayName = getText (configFile >> "CfgVehicles" >> _x select 1 >> "displayName");

            _respawnArray pushBackUnique format ["%1: %2 minute(s) left",_displayName, _timeLeft];
        };
    } forEach RespawnVehiclesArray;

    if (count _respawnArray > 0) then {
        ["Vehicle respawn time:", _respawnArray] remoteExecCall ["hintC", _player, false];
    } else {
        ["Currently there are no vehicles respawning"] remoteExecCall ["hintC", _player, false];
    };
};
publicVariable "requestRespawningVehicles";

//Code to check if the vehicle is abandoned
isAbandoned = {
    params ["_veh", "_spawnLoc"];
    private _returnVal = false;
    private _VehicleRespawnDistance = "VehicleRespawnDistance" call BIS_fnc_getParamValue;

    if (count (crew _veh) == 0) then {
        if ((_veh distance _spawnLoc) > 200) then {
            
			private _noPlayersClose = (allPlayers findIf {
                _veh distance _x < _VehicleRespawnDistance;
            }) == - 1;
			
            if (_noPlayersClose) then {
                _returnVal = true;
            };
        };
    };
    _returnVal
};

//the actual function that checks if vehicles should respawn
RespawnFunction = {
	[] spawn {
		{
			private _veh = _x select 0;
			private _respawn = false;

			if (alive _veh) then {
				private _isAbondoned = [_veh, _x select 2] call isAbandoned;
				if (_isAbondoned) then {
					deleteVehicle _veh;
					_x set [5, time];
				};
			} else {
				private _timeDestroyed = _x select 5;
				deleteVehicle _veh;

				if (isNil "_timeDestroyed") then {
					 _x set [5, time];
				} else {
					private _spawnDelay = _x select 4;

					if ((time -  _timeDestroyed) > _spawnDelay) then {
						_respawn = true;
					};
				};
			};

			private _base = _x select 6;
			if ( !(_base in controlledZones)) then {
				_respawn = false;
				RespawnVehiclesArray = RespawnVehiclesArray - [_x];
			};

			if (_respawn) then {
				//Spawn the vehicle

				private _vehType = (_x select 1);
				switch (_vehType) do {
                    case "Random_Cas_Jet":{
                        _vehType = selectRandom ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
                    };
                    case "Random_AA_Jet":{
                        _vehType = selectRandom ["I_Plane_Fighter_04_F","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_AA_F"];
                    };
                    case "Random_Cas_Heli":{
                        _vehType = selectRandom ["B_Heli_Attack_01_F","B_Heli_Attack_01_F","B_Heli_Attack_01_F","O_Heli_Attack_02_dynamicLoadout_black_F","O_Heli_Attack_02_dynamicLoadout_black_F"];
                    };
                };

				private _newVeh = createVehicle [_vehType, [-100,-100,100], [], 100, "NONE"];
				waitUntil{sleep 0.1; alive _newVeh};

				//Move it to the right pos
				_newVeh setDir (_x select 3);
				_newVeh setVelocity [0,0,0.3];
				private _respawnPos = _x select 2;
				_newVeh setPosWorld [_respawnPos select 0, _respawnPos select 1, (_respawnPos select 2) + 0.1];
				[_newVeh] spawn {
					params ["_newVeh"];
					sleep 2;
					if (alive _newVeh) then {
						_newVeh setDamage 0;
					};
				};
				sleep 0.1;
				
				//Call the init script
				[_newVeh] spawn AW_fnc_vSetup02;

				 _x set [5, nil];
				 _x set [0, _newVeh];
			};

			sleep 0.5;
		} forEach RespawnVehiclesArray;
	};
    
    sleep 60;
    [] spawn RespawnFunction; //call itself to get a loop structure
};

[] spawn RespawnFunction; //start her up