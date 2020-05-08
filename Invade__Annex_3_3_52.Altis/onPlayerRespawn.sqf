//Cut to black while we set things up
cutText ["", "BLACK FADED"];

//fallback in case something else fails
if (!isNil "kickOnRespawn") then {
  [getPlayerUID player] remoteExec ["kickPlayer", 2];
};

waitUntil {sleep 0.1; alive player};

player disableConversation true;
enableSentences false;

/*
Arsenal restrictions:
	These items need to be added because the special gear compositions BIS use for their units are not defined in ArsenalDefinitions.sqf.
	This way, the default weapon / backpack the player unit spawns with doesn't get removed by AW_fnc_cleanInventory.
*/
//Get the loadout the player used before death:
if (!isNil {player getVariable "PlayerLoadout"}) then {
	player setUnitLoadout [player getVariable "PlayerLoadout", true];
};

//Fatigue settings:
if (("Fatigue" call BIS_fnc_getParamValue) == 1) then {
	player enableFatigue false;
} else {
    player enableFatigue true;
};

//Derp_revive respawn:
if (player getVariable ["derp_revive_downed", false]) then {
	[player, "REVIVED"] call derp_revive_fnc_switchState;
};

//Pilot actions:
if (roleDescription player find "Pilot" > -1) then {
	//Despawn damaged helicopters in base:
	player addAction ["<t color='#99ffc6'>Despawn damaged helicopter</t>", { //todo fix this
			private _accepted = false;
			{
				_NearBaseLoc = (getPos player) distance (getMarkerPos _x);
				if (_NearBaseLoc < 500) then {_accepted = true;};
			} forEach BaseArray;
			
			if (_accepted) then {
				private _vehicle = vehicle player;
				moveOut player;
				deleteVehicle _vehicle;
				[parseText format ["<br /><br /><t align='center' font='PuristaBold' ><t size='1.2'>Helicopter successfully despawned.</t></t>"], true, nil, 4, 0.5, 0.3] spawn BIS_fnc_textTiles;
			} else {
				[parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.2'>This action is not allowed outside of base.</t><t size='1.0'><br /> Helicopter not despawned</t></t>"], true, nil, 6, 0.5, 0.3] spawn BIS_fnc_textTiles;
			};
		}, [], -100, false, true, "",
		"   ((vehicle player) isKindOf 'Helicopter') &&
		    { ((speed (vehicle player)) < 2) &&
		    { (count (crew (vehicle player)) == 1) &&
		    { ( (!canMove (vehicle player)) || ((fuel (vehicle player)) <= 0) )
		    }}}",
        10
    ];

    //Ghost Hawk doors action:
    ["Respawn"] spawn AW_fnc_helicopterDoors;
};

//Sling weapon action:
["Respawn"] spawn AW_fnc_slingWeapon;

//Add players to Zeus:
[[player]] remoteExec ["AW_fnc_addToAllCurators", 2];

//Clear vehicle inventory action:
player addAction ["<t color='#ff0000'>Clear vehicle inventory</t>", {[] call AW_fnc_clearVehicleInventory}, [], -101, false, true, "", "
	(player == driver vehicle player) &&
	((vehicle player) != player) &&
	(count itemCargo vehicle player != 0 || 
	count weaponCargo vehicle player != 0 || 
	count magazineCargo vehicle player != 0 || 
	count backpackCargo vehicle player != 0)"
];

//Assign Zeus:
[] spawn {
    sleep 3;
    [player] remoteExecCall ["RYK_fnc_initiateZeusByUID", 2];
	sleep 2;
	if (player getVariable ["isZeus", false]) then {execVM "scripts\adminScripts.sqf";};
	missionNamespace setVariable ['Ares_Allow_Zeus_To_Execute_Code', false];

	/*Launch the naughtyCheck*/
	waitUntil {sleep 0.5; !isNil "naughtyCheck"};
	if !(player getVariable ["isZeus", false]) then {
		[] spawn {
			while {alive player} do {
				[] spawn naughtyCheck;
				sleep 30;
			};
		};
	};
};

[] spawn {
    waitUntil {sleep 0.1; ! isNil "whitelistarray"};
    {
        whitelistArray pushBackUnique _x;
    } forEach (weapons player + [backpack player]);
};

//reset the amount of pings someone has
player setVariable ["zeusPingLimit", 0];

if (!(isClass (configFile >> "CfgPatches" >> "task_force_radio"))) then {
    //disable VON in certain channels
    0 enableChannel [false, false]; //global
    1 enableChannel [true, false]; //side
    2 enableChannel [true, false]; //command
} else {
    //--------- Add TFAR event handlers
    if ( isNil "tfarEH" ) then {
        tfarEH = ["tfarUpdate", "OnRadiosReceived",{
            [] spawn {
    			sleep 1;
    			if ( call TFAR_fnc_haveSWRadio ) then {	call RYK_fnc_TFAR_SR; };
    			if ( call TFAR_fnc_haveLRRadio ) then {	call RYK_fnc_TFAR_LR; };
    		};
    	}, player] call TFAR_fnc_addEventHandler;
    };
    // setup radios in case TFAR eventhandlers never work again :(
    if ( call TFAR_fnc_haveSWRadio ) then {	call RYK_fnc_TFAR_SR; };
    if ( call TFAR_fnc_haveLRRadio ) then {	call RYK_fnc_TFAR_LR; };

    //chat
    0 enableChannel [false, false];
    1 enableChannel [true, false];
    2 enableChannel [true, false];
    3 enableChannel [true, false];
    4 enableChannel [true, false];
    5 enableChannel [true, false];
};

//wait 2 seconds before fading back in
sleep 2;
titleCut ["", "BLACK IN", 2];

private _teamSpeakMessage = "This server requires that you are connected and communicating with other players through our Teamspeak server. Please fix whatever issues you are having and connect to our Teamspeak at ts.ahoyworld.net:9987 - once you are connected this message will disappear.";

if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    if ( !([] call TFAR_fnc_isTeamSpeakPluginEnabled) ) then {
        titleText [_teamSpeakMessage, "BLACK", 2];
        waitUntil { sleep 2; (([] call TFAR_fnc_isTeamSpeakPluginEnabled) || (player getVariable ["isZeus", false]) || !isNil "adminTFARbypass")};
        titleFadeOut 2;
    };
};