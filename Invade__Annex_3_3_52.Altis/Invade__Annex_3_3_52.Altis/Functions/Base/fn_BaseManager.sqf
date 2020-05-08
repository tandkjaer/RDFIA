/*
Author:  BACONMOP
Description: For new Spawned bases

Last edited: 20/10/2017 by stanhope
Edited: Names of respawn markers + teleporter
*/
private _base = _this select 0;

// Respawn Position & markers -------------------------------
private _baseRespawnMarker = (missionConfigFile >> "Main_Aos" >> "AOs" >> _base >> "respawnPos") call BIS_fnc_getCfgData;
private _respawnMarkerPos = getMarkerPos _baseRespawnMarker;
private _basevisMarker = (missionConfigFile >> "Main_Aos" >> "AOs" >> _base >> "visMrkr") call BIS_fnc_getCfgData;
{_x setMarkerPos (getMarkerPos _baseRespawnMarker);} forEach [_basevisMarker];

private _respawnMarker = [west, _respawnMarkerPos, _basevisMarker] call BIS_fnc_addRespawnPosition;

// Create the crate -----------------------
private _arsenal = "B_CargoNet_01_ammo_F" createVehicle (getMarkerPos _baseRespawnMarker);
clearItemCargoGlobal _arsenal;
clearWeaponCargoGlobal _arsenal;
clearBackpackCargoGlobal _arsenal;
clearMagazineCargoGlobal _arsenal;
_arsenal enableRopeAttach false;
_arsenal setMass 5000;

[[_arsenal], "Scripts\arsenal\ArsenalInitialisation.sqf"] remoteExec ["execVM", -2, false];
arsenalArray = arsenalArray + [_arsenal];
publicVariable "arsenalArray";

//Stuff to be set on every box:
    //Teleports:
    [[_arsenal, _base], AW_FNC_baseTeleportSetup] remoteExec ["call", -2, true];
	//View Distance:
	[_arsenal, ["<t color='#0000ff'>View Distance Settings</t>", CHVD_fnc_openDialog, [], 0, false, true, "", "", 5]] remoteExec ["addAction", -2, true];
	[_arsenal, ["Load saved loadout", {player setUnitLoadout [player getVariable "PlayerLoadout", true];}, [], -200, false, true, "", "vehicle _this == _this", 10, true]] remoteExec ["addAction", -2, true];

	//Scroll wheel actions:
	[
		_arsenal,
		{
			_this addAction ["Toggle sling weapon action", {["Toggle"] spawn AW_fnc_slingWeapon;}, [], 4, false, true, "", "true", 5];

			if (roleDescription player find "Pilot" > -1) then {
				_this addAction ["Toggle Ghost Hawk doors action", {["Toggle"] spawn AW_fnc_helicopterDoors;}, [], 4, false, true, "", "true", 5];
			};
		}
	] remoteExec ["spawn", -2, false];

// Notification ----------------------------------------

private _txt = format["<t align='center' size='2.2'>Base Taken</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>Good Job. We have now setup a base at that location.<br/><br/>We have provided you with some vehicles at that the new FOB.", markerText _basevisMarker];
[_txt] remoteExec ["AW_fnc_globalHint", 0, false];

// Vehicles ---------------------------------------
private ["_vehType"];
private _baseVehicles = (missionConfigFile >> "Main_Aos" >> "AOs" >> _base >> "vehicles") call BIS_fnc_getCfgData;
{
	_veh = _x select 0;
	_mkr = _x select 1;
	_timer = _x select 2;
	
	switch (_veh) do {
		case "Random_Cas_Jet":{
			_vehType = selectRandom ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
		};
		case "Random_AA_Jet":{
			_vehType = selectRandom ["I_Plane_Fighter_04_F","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_AA_F"];
		};
		case "Random_Cas_Heli":{
			_vehType = selectRandom ["B_Heli_Attack_01_F","B_Heli_Attack_01_F","B_Heli_Attack_01_F","O_Heli_Attack_02_dynamicLoadout_black_F","O_Heli_Attack_02_dynamicLoadout_black_F"];
		};
		default {
			_vehType = _veh;
		};
	};
	_vehicle = _vehType createVehicle getMarkerPos _mkr;
	_vehicle setDir (markerDir _mkr);
	{_x addCuratorEditableObjects [[_vehicle], false];} forEach allCurators;
	[_vehicle, _timer, false, AW_fnc_vSetup02, _base, _veh, getPosWorld _vehicle] spawn AW_fnc_vBaseMonitor;
		
	
} forEach _baseVehicles;


private _fobStuff = (getMarkerPos _baseRespawnMarker) nearObjects 500;
{	
	if ( isObjectHidden _x ) then{
		_x hideObjectGlobal false;
	};
} forEach _fobStuff;

//FOB specific stuff
switch (_base) do {
	case "Terminal":{
        //service triggers
        TerminalServiceGroundTrigger setPos (getPos GuardianGroundServicePad);
        TerminalServiceAirTrigger setPos (getPos GuardianAirServicePad);

        //service pad markers
        _GuardianGroundServiceMarker = createMarker ["GuardianGroundService",(getPos GuardianGroundServicePad)];
        "GuardianGroundService" setMarkerShape "ICON";
        "GuardianGroundService" setMarkerType "b_maint";
        "GuardianGroundService" setMarkerText "Ground service";
        "GuardianGroundService" setMarkerSize [0.5, 0.5];

        _GuardianAirServiceMarker = createMarker ["GuardianAirService",(getPos GuardianAirServicePad)];
        "GuardianAirService" setMarkerShape "ICON";
        "GuardianAirService" setMarkerType "o_maint";
        "GuardianAirService" setMarkerColor "colorBLUFOR";
        "GuardianAirService" setMarkerText "Air service";
        "GuardianAirService" setMarkerSize [0.5, 0.5];
    };
	
	case "AAC_Airfield":{
	
        AACServiceTrigger setPos (getPos MartianGroundServicePad);

        _MartianGroundServiceMarker = createMarker ["MartianGroundService",(getPos MartianGroundServicePad)];
        "MartianGroundService" setMarkerShape "ICON";
        "MartianGroundService" setMarkerType "b_maint";
        "MartianGroundService" setMarkerText "Ground service";
        "MartianGroundService" setMarkerSize [0.5, 0.5];
    };
	
	case "Stadium":{
        StadiumServiceTrigger setPos (getPos MarathonGroundServicePad);

        _MarathonGroundServiceMarker = createMarker ["MarathonGroundService",(getPos MarathonGroundServicePad)];
        "MarathonGroundService" setMarkerShape "ICON";
        "MarathonGroundService" setMarkerType "b_maint";
        "MarathonGroundService" setMarkerText "Ground service";
        "MarathonGroundService" setMarkerSize [0.5, 0.5];
    };
	
	case "Molos_Airfield":{
        MolosServiceGroundTrigger setPos (getPos LastStandGroundServicePad);
        MolosServiceAirTrigger setPos (getPos LastStandAirServicePad);

        _LastStandGroundServiceMarker = createMarker ["LastStandGroundService",(getPos LastStandGroundServicePad)];
        "LastStandGroundService" setMarkerShape "ICON";
        "LastStandGroundService" setMarkerType "b_maint";
        "LastStandGroundService" setMarkerText "Ground service";
        "LastStandGroundService" setMarkerSize [0.5, 0.5];

        _LastStandAirServiceMarker = createMarker ["LastStandAirService",(getPos LastStandAirServicePad)];
        "LastStandAirService" setMarkerShape "ICON";
        "LastStandAirService" setMarkerType "o_maint";
        "LastStandAirService" setMarkerColor "colorBLUFOR";
        "LastStandAirService" setMarkerText "Air service";
        "LastStandAirService" setMarkerSize [0.5, 0.5];
    };

	case "Corton":{
         //service triggers
        cortonGroundServiceTrigger setPos (getPos cortonGroundServicePad);
        cortonAirServiceTrigger setPos (getPos cortonAirServicePad);

        //service pad markers
        _cortonGroundServiceMarker = createMarker ["GuardianGroundService",(getPos cortonGroundServicePad)];
        "GuardianGroundService" setMarkerShape "ICON";
        "GuardianGroundService" setMarkerType "b_maint";
        "GuardianGroundService" setMarkerText "Ground service";
        "GuardianGroundService" setMarkerSize [0.5, 0.5];

        _cortonAirServiceMarker = createMarker ["GuardianAirService",(getPos cortonAirServicePad)];
        "GuardianAirService" setMarkerShape "ICON";
        "GuardianAirService" setMarkerType "o_maint";
        "GuardianAirService" setMarkerColor "colorBLUFOR";
        "GuardianAirService" setMarkerText "Air service";
        "GuardianAirService" setMarkerSize [0.5, 0.5];
     };

	default { 
        private _text = format ["ERROR with fn_BaseManager.sqf, %1 was not recognized as an FOB", _base];
        diag_log _text;
	};

};

[_arsenal] spawn {
	sleep 3; 
	_crate = (_this select 0);
	_crate setVectorUp surfaceNormal position _crate;
};