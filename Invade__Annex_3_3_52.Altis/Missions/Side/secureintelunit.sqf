/*
@filename: secureIntelUnit.sqf
Author:
	Quiksilver

Description:
	Recover intel from a unit

modified:
	pos finder	
	
___________________________________________________________________________*/

private _objVehicles = ["O_MRAP_02_F","I_MRAP_03_F","O_MRAP_02_F","C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","O_Heli_Light_02_unarmed_F"];
private _objUnitTypes = ["O_officer_F","I_officer_F","I_Soldier_SL_F","O_Soldier_SL_F","O_recon_TL_F","O_diver_TL_F"];

//-------------------------------------------------------------------------- FIND POSITION FOR MISSION	
private _accepted = false;
private _flatPos = [0,0,0];

while { !_accepted } do {

    _flatPos = [getMarkerPos currentAO, missionsMinimumSpawnDistance, 15000, 5, 0, 0.2, 0, [], [0,0,0]] call BIS_fnc_findSafePos;

    _accepted = true;
    {
        if ( (_flatPos distance2D (getMarkerPos _x)) < missionsMinimumSpawnDistance) then {
            _accepted = false;
        }
    } forEach BaseArray + [currentAO];

};

//-------------------------------------------------------------------------- NEARBY POSITIONS TO SPAWN STUFF (THEY SPAWN IN TRIANGLE SO NO ONE WILL KNOW WHICH IS THE OBJ. HEHEHEHE.

	private _flatPos1 = [_flatPos, 2, random 360] call BIS_fnc_relPos;
	private _flatPos2 = [_flatPos, 10, random 360] call BIS_fnc_relPos;
	private _flatPos3 = [_flatPos, 15, random 360] call BIS_fnc_relPos;

//-------------------------------------------------------------------------- CREATE GROUP, VEHICLE AND UNIT

	
	_surrenderGroup = createGroup west;

	//--------- INTEL OBJ
	private _obj1 = (selectRandom _objVehicles) createVehicle _flatPos;
	waitUntil {sleep 0.1; alive _obj1};
	_obj1 setDir (random 360);

	sleep 0.1;
	
    private _aGroup = createGroup east;
	private _intelObj = _aGroup createUnit [("O_officer_F"), _flatPos1, [], 0, "NONE"];
	private _intelDriver = _aGroup createUnit ["O_crew_F", _flatPos1, [], 0, "NONE"];

	_intelObj assignAsCargo _obj1;
	_intelDriver assignAsDriver _obj1;
	_intelDriver moveInDriver _obj1;

	//--------- OBJ 2
	private _obj2 = (selectRandom _objVehicles) createVehicle _flatPos2;
	waitUntil {sleep 0.1; alive _obj2};
	_obj2 setDir (random 360);
	sleep 0.1;

	private _bGroup = createGroup east;
	private _decoy1 = _bGroup createUnit [("O_officer_F"), _flatPos1, [], 0, "NONE"];
	private _decoyDriver1 = _bGroup createUnit ["O_crew_F", _flatPos1, [], 0, "NONE"];

	sleep 0.1;
	_decoy1 assignAsCargo _obj2;
	_decoyDriver1 assignAsDriver _obj2;
	_decoyDriver1 moveInDriver _obj2;

	//-------- OBJ 3
	
	private _obj3 = (selectRandom _objVehicles) createVehicle _flatPos3;
	waitUntil {sleep 0.1; alive _obj3};
	_obj3 setDir (random 360);
	sleep 0.1;
	
	private _cGroup = createGroup east;
	private _decoy2 = _cGroup createUnit [("O_officer_F"), _flatPos1, [], 0, "NONE"];
	private _decoyDriver2 = _cGroup createUnit ["O_crew_F", _flatPos1, [], 0, "NONE"];

	sleep 0.1;
	(_decoy2) assignAsCargo _obj3;
	(_decoyDriver2) assignAsDriver _obj3;
	(_decoyDriver2) moveInDriver _obj3;

	//---------- COMMON

	{ _x lock 3 } forEach [_obj1,_obj2,_obj3];
	[(units _aGroup) + (units _bGroup) + (units _cGroup)] call AW_fnc_setSkill2;

	{_x addCuratorEditableObjects [(units _aGroup) + (units _bGroup) + (units _cGroup), false];} forEach allCurators;

//--------------------------------------------------------------------------- ADD ACTION TO OBJECTIVE. NOTE: NEEDS WORK STILL. Good enough for now though.

	sleep 0.1;
    [_intelObj, AW_fnc_addActionGetIntel] remoteExec ["spawn", 0, true];
	[_intelObj, AW_fnc_addActionSurrender] remoteExec ["spawn", 0, true];
	{
        removeAllWeapons _x;
        removeAllItems _x;
        removeAllAssignedItems _x;
        removeUniform _x;
        removeVest _x;
        removeBackpack _x;
        removeHeadgear _x;
        removeGoggles _x;
        _x forceAddUniform "U_O_OfficerUniform_ocamo";
        _x addVest "V_TacVest_khk";
        _x addHeadgear "H_MilCap_ocamo";
        _x addGoggles "G_Aviator";

        for "_i" from 1 to 4 do {_x addItemToUniform "SmokeShellRed";};
        for "_i" from 1 to 2 do {
            _x addItemToUniform "FirstAidKit";
            _x addItemToVest "HandGrenade";
        };
        _x addItemToVest "MiniGrenade";

        _x linkItem "ItemMap";
        _x linkItem "ItemCompass";
        _x linkItem "ItemWatch";
        _x linkItem "ItemRadio";
        _x linkItem "ItemGPS";

        if (_x != _intelObj) then {
            _x addWeapon "arifle_AK12_lush_F";
            _x addPrimaryWeaponItem "muzzle_snds_B_arid_F";
            _x addPrimaryWeaponItem "optic_Arco_AK_arid_F";
            _x addPrimaryWeaponItem "30rnd_762x39_AK12_Lush_Mag_F";
            _x addPrimaryWeaponItem "bipod_02_F_arid";
            for "_i" from 1 to 6 do {_x addItemToVest "30rnd_762x39_AK12_Lush_Mag_F";};
        };
	} forEach [_intelObj, _decoy1, _decoy2];

//--------------------------------------------------------------------------- CREATE DETECTION TRIGGER ON OBJECTIVE VEHICLE
	private _targetTrigger = createTrigger ["EmptyDetector", getPos _intelObj];
	_targetTrigger setTriggerArea [500, 500, 0, false];
	_targetTrigger setTriggerActivation ["WEST", "PRESENT", false];
	_targetTrigger setTriggerStatements ["this","",""];
	sleep 0.1;
	_targetTrigger attachTo [_intelObj,[0,0,0]];
	sleep 0.1;

//--------------------------------------------------------------------------- SPAWN GUARDS
	private _enemiesArray = [_obj1] call AW_fnc_SMenemyEASTintel;

//--------------------------------------------------------------------------- BRIEFING

	private _fuzzyPos = [((_flatPos select 0) - 300) + (random 600),((_flatPos select 1) - 300) + (random 600),0];
	{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
	private _sideMarkerText = "Secure Intel";
	"sideMarker" setMarkerText "Side Mission: Secure Intel";
    [west,["secureIntelTask"],[
        "We have reports from locals that sensitive, strategic information is changing hands. This is a target of opportunity! We've marked the position on your map; head over there and secure the intel. It should be stored on one of the vehicles or on their persons.  Do Not Destroy the unarmed vehicles or Officers - for this will compromise the mission.",
        "Side Mission: Secure Intel","sideCircle"],(getMarkerPos "sideCircle"),"Created",0,true,"intel",true
    ] call BIS_fnc_taskCreate;
	sleep 0.1;

	//----- Reset VARS for next time

	sideMissionUp = true;
	sideMissionSpawnComplete = true;
	publicVariableServer "sideMissionSpawnComplete";
	private _notEscaping = true;
	private _gettingAway = false;
	private _heEscaped = false;
	SM_SUCCESS = false;
	HE_SURRENDERS = false;

//-------------------------- [ CORE LOOPS ] ----------------------------- [ CORE LOOPS ] ---------------------------- [ CORE LOOPS ]

while { sideMissionUp } do {
	sleep 0.1;

	//------------------------------------------ IF VEHICLE IS DESTROYED [FAIL]

	if (!alive _intelObj) exitWith {
		sleep 0.1;

		//---------- DE-BRIEF

        ["secureIntelTask", "Failed",true] call BIS_fnc_taskSetState;
        sleep 5;
        ["secureIntelTask",west] call bis_fnc_deleteTask;
		sideMissionUp = false;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"];

		//---------- REMOVE ACTION
		[_intelObj] remoteExec ["removeAllActions", 0, true];

		//---------- DELETE
		sleep 120;
		{ deleteVehicle _x } forEach [_targetTrigger,_intelObj,_decoy1,_decoy2,_intelDriver,_obj1,_obj2,_obj3,_decoyDriver1,_decoyDriver2];
		[_enemiesArray] spawn AW_fnc_SMdelete;

	};

	//----------------------------------------- IS THE ENEMY TRYING TO ESCAPE?

	if (_notEscaping) then {
		//---------- NO? then LOOP until YES or an exitWith {}.

		sleep 0.1;
		if (_intelObj call BIS_fnc_enemyDetected) then {

			sleep 0.1;

			hqSideChat = "Target has spotted you and is trying to escape with the intel!";
			[hqSideChat] remoteExec ["AW_fnc_globalSideChat",0,false];

			//---------- WHERE TO / HOW WILL THE OBJECTIVES ESCAPE?

			{
				_escape1WP = _x addWaypoint [getMarkerPos currentAO, 100];
				_escape1WP setWaypointType "MOVE";
				_escape1WP setWaypointBehaviour "CARELESS";
				_escape1WP setWaypointSpeed "FULL";
			} forEach [_aGroup,_bGroup,_cGroup];

			sleep 0.1;

			//---------- SET GETTING AWAY TO TRUE TO DETECT IF HE'S ESCAPED.
			_gettingAway = true;

			//---------- END THE NOT ESCAPING LOOP
			_notEscaping = false;
		};
	};

	//-------------------------------------------- THE ENEMY IS TRYING TO ESCAPE

	if (_gettingAway) then {
		sleep 5;  // too long?

		//_targetTrigger attachTo [_intelObj,[0,0,0]];
		if (count list _targetTrigger < 1) then {
			sleep 0.1;
			_heEscaped = true;
			_gettingAway = false;
		};

		//---------- DETECT IF HE SURRENDERS

		if (HE_SURRENDERS) then {
			sleep 0.1;

			removeAllWeapons _intelObj;
			_intelObj playAction "Surrender";
			_intelObj disableAI "ANIM";
			[_intelObj] joinSilent _surrenderGroup;

			//----- REMOVE 'SURRENDER' ACTION
			[_intelObj] remoteExec ["removeAllActions", 0, true];
		};

	};

	//------------------------------------------- THE ENEMY ESCAPED [FAIL]

	if (_heEscaped) exitWith {
			//---------- DE-BRIEF

            ["secureIntelTask", "Failed",true] call BIS_fnc_taskSetState;
            sleep 5;
            ["secureIntelTask",west] call bis_fnc_deleteTask;
			sideMissionUp = false;
			{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"];

			//---------- DELETE
			{ deleteVehicle _x } forEach [_targetTrigger,_intelObj,_decoy1,_decoy2,_intelDriver,_obj1,_obj2,_obj3,_decoyDriver1,_decoyDriver2];
			sleep 120;
			[_enemiesArray] spawn AW_fnc_SMdelete;
	};

	//-------------------------------------------- THE INTEL WAS RECOVERED [SUCCESS]

	if (SM_SUCCESS) exitWith {
		sleep 0.1;

		//---------- DE-BRIEF
        ["secureIntelTask", "Succeeded",true] call BIS_fnc_taskSetState;
        sleep 5;
        ["secureIntelTask",west] call bis_fnc_deleteTask;
		sideMissionUp = false;
		[nil, nil, _flatPos] call AW_fnc_SMhintSUCCESS;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker", "sideCircle"];

		//---------- REMOVE 'GET INTEL' ACTION
		[_intelObj] remoteExec ["removeAllActions", 0, true];

		//---------- DELETE
		sleep 120;
		{ deleteVehicle _x } forEach [_targetTrigger,_intelObj,_decoy1,_decoy2,_intelDriver,_obj1,_obj2,_obj3,_decoyDriver1,_decoyDriver2];
		[_enemiesArray] spawn AW_fnc_SMdelete;
	};
};