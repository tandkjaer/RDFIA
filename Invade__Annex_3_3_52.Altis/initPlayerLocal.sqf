//initplayerlocal, does stuff when the player spawns

enableSaving false;
if (!hasInterface) exitWith {}; //we don't want anything but real players here

[] execVM "scripts\misc\localChecks.sqf";

//Player TK counter:
amountOfTKs = 0;
TKLimit = 3;
player setVariable ['timeTKd', round (time), false];

// Pilot spawn:
if (roleDescription player find "Pilot" > -1) then {  
	private ["_spawnpos"];
	_spawnpos = getPosATL PilotSpawnPos;
	[player, _spawnpos, "Pilot spawn"] call BIS_fnc_addRespawnPosition; 	
};

//Derp_revive setup:
if ("derp_revive" in (getMissionConfigValue "respawnTemplates")) then {
    if (getMissionConfigValue "derp_revive_everyoneCanRevive" == 0) then {
        if (player getUnitTrait "medic") then { call derp_revive_fnc_drawDowned; };
    } else {
        call derp_revive_fnc_drawDowned;
    };
    [] call derp_revive_fnc_handleDamage;
    [] call derp_revive_fnc_diaryEntries;
    if (getMissionConfigValue "respawnOnStart" == -1) then { [player] call derp_revive_fnc_reviveActions; };
};

//Player protection so stupid UAVs don't start shooting friendlies that did some TKing
player addRating 10000000;

//Some scroll wheel actions:
["AddAction"] spawn AW_fnc_slingWeapon;

if (roleDescription player find "Pilot" > -1) then {
	["AddAction"] spawn AW_fnc_helicopterDoors;
};

[] spawn {
    //Extended passenger information hud
    if (profileNamespace getVariable ["AW_I&A_3_ExtendedVehicleHud", false]) then {
    	vehicleHUDScript = [] execVM "scripts\vehicle\crew\crew.sqf";
    };
};

//Player safe zone:
[] spawn {
	waitUntil {sleep 0.5; !isNil "BaseArray"};
	player addEventHandler ["FiredMan", {
		params ["_unit", "_weapon", "", "", "", "", "_projectile"];
		private _pos = getPos _projectile;

        private _baseIndex = (BaseArray findIf {_pos distance (getMarkerPos _x) < 1000});

        if (_baseIndex == -1) exitWith {};
        if (_weapon find "CMFlareLauncher" != -1) exitWith {};
        private _base = BaseArray select _baseIndex;

		if ((_pos distance (getMarkerPos _base)) < 300) then {
		    if (player getVariable "isZeus") exitWith { hint "You are shooting in base. Be careful when doing this. Don't abuse it!"; };

		    deleteVehicle _projectile;
            hintC format ["%1, don't goof at base. Don't throw, fire or place anything inside the base.", name _unit];
		} else {
		    if (player getVariable "isZeus") exitWith {};
		    [_projectile, getMarkerPos _base] spawn {
		        params ["_proj", "_markerPos"];
		        private _dist = _proj distance _markerPos;
		        private _initialDist =  _dist;
		        while {alive _proj} do {
		            sleep 0.2;
		            _dist = _proj distance _markerPos;
		            if (_dist < 300) exitWith { deleteVehicle _proj; };
		            if ((_dist - _initialDist) > 1000) exitWith {};
		        };
		    };
		};
	}];

	player addEventHandler ["WeaponAssembled", {
        params ["_unit", "_staticWeapon"];
        private _assembledName = getText(configFile >> "CfgVehicles" >> typeOf _staticWeapon >> "DisplayName" );
        private _msg = format ["Player %1 assembled a %2", name _unit, _assembledName];
        private _code = {
        if (isServer) then {diag_log (_this select 0)};
            if (! (player getVariable ["isZeus", false])) exitWith {};
            private _logThis = profileNamespace getVariable ["enabledAssembelMsg", false];
            if (_logThis) then {
                params ["_msg"];
                Quartermaster customChat [adminChannelID, _msg];
            };
        };
        [[_msg], _code] remoteExec ["spawn", 0];
    }];

	player addEventHandler ['AnimDone', {
    	params ["_unit", "_anim"];
    	if (_anim != "amovpercmstpsraswrfldnon_ainvpercmstpsraswrfldnon_putdown"
    	        && _anim != "ainvpercmstpsraswrfldnon_putdown_amovpercmstpsraswrfldnon"
    	        && _anim != "ainvpknlmstpsraswrfldnon_putdown_amovpknlmstpsraswrfldnon"
    	        && _anim != "ainvppnemstpsraswrfldnon_putdown_amovppnemstpsraswrfldnon"
            ) exitWith {};

    	private _baseIndex = (BaseArray findIf {(getPos _unit) distance (getMarkerPos _x) < 1000});
    	if (_baseIndex == -1) exitWith {};

    	if (player getVariable "isZeus") exitWith { hint "You are putting down explosives in base. Be careful when doing this. Don't abuse it!"; };

        private _base = BaseArray select _baseIndex;
        private _mines = (getMarkerPos _base) nearObjects ['MineBase', 1000];
        if (_mines == 0) exitWith {};
        { deleteVehicle _x; } forEach _mines;
        hintC format ["%1, don't goof at base. Don't throw, fire or place anything inside the base.", name _unit];
    }];
};

//Artillery Computer:
if (((roleDescription player) find "FSG Gunner") == -1) then {
	enableEngineArtillery false;
} else {
	enableEngineArtillery true;
};

//EventHandlers for seat restrictions:
player addEventHandler ["GetInMan", {[] spawn AW_fnc_restrictedAircraftSeatsCheck;}];
player addEventHandler ["SeatSwitchedMan", {[] spawn AW_fnc_restrictedAircraftSeatsCheck;}];

//Arsenal:
[] spawn {
	private _arsenalDefinitions_handler = execVM "Scripts\arsenal\ArsenalDefinitions.sqf";
	waitUntil {sleep 0.1; scriptDone _arsenalDefinitions_handler};
	waitUntil {sleep 0.1; ! isNil "arsenalArray"};

	{
	    [_x] execVM "Scripts\arsenal\ArsenalInitialisation.sqf";
        _x addAction ["Toggle sling weapon action", {["Toggle"] spawn AW_fnc_slingWeapon;}, [], 4, false, true, "", "true", 5];
        _x addAction ["Revive and heal players", {_this spawn AW_FNC_baseHeal;}, [], -200, false, true, "", "vehicle _this == _this", 10, true];
        _x addAction ["Load saved loadout", {player setUnitLoadout [player getVariable "PlayerLoadout", true];}, [], -200, false, true, "", "vehicle _this == _this", 10, true];

        if (roleDescription player find "Pilot" > -1) then {
            _x addAction ["Toggle Ghost Hawk doors action", {["Toggle"] spawn AW_fnc_helicopterDoors;}, [], 4, false, true, "", "true", 5];
        };


    } forEach arsenalArray;

	player addEventHandler ["InventoryClosed", {
		[] spawn AW_fnc_cleanInventory;
		[] spawn AW_fnc_inventoryInformation;
	}];
	player addEventHandler ["Take", {
		[] spawn AW_fnc_cleanInventory;
		[] spawn AW_fnc_inventoryInformation;
	}];
	player addEventHandler ["FiredMan", { [] spawn AW_fnc_cleanInventory; }];

	//With derp_revive, this EH needs to be added to Functions/revive/fn_switchState.sqf as well.
	inGameUISetEventHandler ["Action", "
		if (_this # 4 == localize 'STR_A3_Arsenal') then {
			[] spawn {
				waitUntil {sleep 0.05; isNull (uiNamespace getVariable 'RSCDisplayArsenal')};
				[] call AW_fnc_cleanInventory;
				[] spawn AW_fnc_inventoryInformation;
				player setVariable ['PlayerLoadout', (getUnitLoadout player)];

				if (!isNil 'TFAR_core') then {
                    if ( call TFAR_fnc_haveSWRadio ) then
                    {	call RYK_fnc_TFAR_SR; };
                    if ( call TFAR_fnc_haveLRRadio ) then
                    {	call RYK_fnc_TFAR_LR; };
                };
			};
		};
		false
	"];
};

//BIS Dynamic Groups:
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

//Ares / Achilles:
missionNamespace setVariable ['Ares_Allow_Zeus_To_Execute_Code', false];

[] spawn {
    waitUntil {sleep 1; alive player};

    sleep 20;
    private _hint = "";

    switch (true) do {
        case (player getVariable ["isCoreStaff", false]): {
            _hint = format["<t align='center' size='2.2' color='#FF0000'>%1<br/></t><t size='1.4' color='#33CCFF'>%2</t><br/>has joined the server. To get involved in the Ahoy World community, register an account at www.AhoyWorld.net and get stuck in!</t><br/>","AhoyWorld Core Staff", name player];
        };
        case (player getVariable ["isAdmin", false]): {
            _hint = format["<t align='center' size='2.2' color='#FF0000'>%1<br/></t><t size='1.4' color='#33CCFF'>%2</t><br/>has joined the server. To get involved in the Ahoy World community, register an account at www.AhoyWorld.net and get stuck in!</t><br/>","AhoyWorld Public Moderator", name player];
        };
        case (player getVariable ["isZeus", false]): {
            _hint = format["<t align='center' size='2.2' color='#FF0000'>%1<br/></t><t size='1.4' color='#33CCFF'>%2</t><br/>has joined the server. To get involved in the Ahoy World community, register an account at www.AhoyWorld.net and get stuck in!</t><br/>","AhoyWorld Spartan", name player];
        };
        default {
             private _infoArray = squadParams player;
                if (count _infoArray > 0) then {

                    private _squadArray = _infoArray select 0;
                    private _memberArray = _infoArray select 1;

                    private _squadName = _squadArray select 1;
                    private _squadEmail = _squadArray select 2;

                    private _memberNick = _memberArray select 1;

                	if (_squadEmail != "staff@ahoyworld.net") exitWith {};

                	private _allowedSquads = ["AhoyWorld Core Staff", "AhoyWorld Moderator", "AW Invade and Annex Developer", "AhoyWorld Enhanced Veteran",
                		"AhoyWorld Spartan", "Ahoyworld Member", "AhoyWorld Donator", "Xwatt's Bear Battalion", "Lindi's Ye' Old Geezers","Itsmemario's Pizza Patrol",
                		"Solex's Fire and Rescue Squad", "ahoyworld member 2", "Ahoyworld Member 2", "ahoyworld field ambassador"];

                	if !(_squadName in _allowedSquads) exitWith {
                		private _text = format["Player %1 (%2) joined with a the ahoyworld staff email in their squad XML (%3). Possible hacking attempt.", name player, getPlayerUID player, _squadName];
                		[_text] remoteExec ["diag_log", 2, false];
                	};

                	_hint = format["<t align='center' size='2.2' color='#FF0000'>%1<br/></t><t size='1.4' color='#33CCFF'>%2</t><br/>has joined the server. To get involved in the Ahoy World community, register an account at www.AhoyWorld.net and get stuck in!</t><br/>",_squadName, _memberNick];
                };
        };
    };
    //if (profileNamespace getVariable ["AW_I&A_disableJoinHint", false]) exitWith {};

    if (_hint != "") then {
        [_hint] remoteExec ["AW_fnc_globalHint", 0, false];
    };
};

if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    ["unit", {
    	if (TFAR_currentUnit != (_this select 0)) then
    	{	TFAR_currentUnit setVariable ["tf_controlled_unit",(_this select 0)]; }
    	else
    	{	TFAR_currentUnit setVariable ["tf_controlled_unit",nil]; };
    }] call CBA_fnc_addPlayerEventHandler;
};

[] spawn {
    waitUntil {sleep 1; alive player};
    sleep 30;
    private _curator = getAssignedCuratorLogic player;

    if (!isNil "_curator") then {
        _curator addEventHandler ["CuratorObjectPlaced", {
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
    };

    //chat loging for chat with special chars
    rwt_chatcom_main_eh = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call RWT_fnc_chatcomVerify"];
};

[] execVM "scripts\misc\QS_icons.sqf";			//Icons
[] execVM "scripts\misc\diary.sqf";				//Diary
[] execVM "scripts\misc\earplugs.sqf";			//Earplugs
private _loadoutScript = [] execVM "Scripts\arsenal\unitLoadout.sqf";    //Default loadout
[_loadoutScript] spawn {
    params ["_loadoutScript"];
    waitUntil {sleep 0.1; scriptDone _loadoutScript};
    player setVariable ['PlayerLoadout', (getUnitLoadout player)];
};