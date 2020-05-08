/*
@filename: secureIntelVehicle.sqf
Author:

	Quiksilver

Description:

	Recover intel from a vehicle (add Action)
		If driver sees you, will attempt escape.
			If escapes, mission fail.
		If vehicle destroyed, mission fail.
		If intel recovered, mission success.

Last modified:

	29/07/2017 by stanhope
	
modified:
	
	pos finder

		
Status:

	20/04/2014
	WIP Third pass
	Open beta

Notes / To Do:

	- Locality issues and variables? Seems okay for now, but still work on the Side Mission selector.
	- remove action after completion?
	- Create ambush
	- Increase sleep timer before delete, too tight!

___________________________________________________________________________*/

private _objVehicles = ["O_MRAP_02_F","I_MRAP_03_F"];
private _objUnitTypes = [ "O_officer_F","O_Soldier_SL_F","O_recon_TL_F","O_diver_TL_F"];

//-------------------------------------------------------------------------- FIND POSITION FOR VEHICLE
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

//-------------------------------------------------------------------------- NEARBY POSITIONS TO SPAWN STUFF (THEY SPAWN IN TRIANGLE SO NO ONE WILL KNOW WHICH IS THE OBJ VEHICLE. HEHEHEHE.
	private _flatPos1 = [_flatPos, 2, random 360] call BIS_fnc_relPos;
	private _flatPos2 = [_flatPos, 10, random 360] call BIS_fnc_relPos;
	private _flatPos3 = [_flatPos, 15, random 360] call BIS_fnc_relPos;

//-------------------------------------------------------------------------- CREATE GROUP, VEHICLE AND UNIT

	//--------- OBJ 1
	private _obj1 = (selectRandom _objVehicles) createVehicle _flatPos;
	waitUntil {sleep 0.1; alive _obj1};
	_obj1 setDir (random 360);

	sleep 0.1;
	private _aGroup = createGroup east;
	private _objUnit1 = _aGroup createUnit ["O_officer_F",_flatPos1, [], 0, "FORM"];
    _objUnit1 assignAsDriver _obj1;
    _objUnit1 moveInDriver _obj1;

	//--------- OBJ 2
	private _obj2 = (selectRandom _objVehicles) createVehicle _flatPos2;
	waitUntil {sleep 0.1; alive _obj2};
	_obj2 setDir (random 360);

	sleep 0.1;
	private _bGroup = createGroup east;
    private _objUnit2 = _bGroup createUnit ["O_officer_F",_flatPos2, [], 0, "FORM"];
    _objUnit2 assignAsDriver _obj2;
    _objUnit2 moveInDriver _obj2;

	//-------- OBJ 3
	private _obj3 = (selectRandom _objVehicles) createVehicle _flatPos3;
	waitUntil {sleep 0.1; alive _obj3};
	_obj3 setDir (random 360);

	sleep 0.1;
	private _cGroup = createGroup east;
    private _objUnit3 = _cGroup createUnit ["O_officer_F",_flatPos3, [], 0, "FORM"];
    _objUnit3 assignAsDriver _obj3;
    _objUnit3 moveInDriver _obj3;

	sleep 0.1;

	{ _x lock 3 } forEach [_obj1,_obj2,_obj3];

	sleep 0.1;

	{_x addCuratorEditableObjects [(units _aGroup) + (units _bGroup) + (units _cGroup), false];} forEach allCurators;

//--------------------------------------------------------------------------- ADD ACTION TO OBJECTIVE VEHICLE. NOTE: NEEDS WORK STILL. Good enough for now though.
	//---------- WHICH VEHICLE IS THE OBJECTIVE?
	private _intelObj = selectRandom [_obj1, _obj2, _obj3];

	//---------- OKAY, NOW ADD ACTION TO IT
	[_intelObj, AW_fnc_addActionGetIntel] remoteExec ["spawn", 0, true];

//--------------------------------------------------------------------------- CREATE DETECTION TRIGGER ON OBJECTIVE VEHICLE
	sleep 0.1;
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
    [west,["secureIntelVicTask"],["We have reports from locals that sensitive, strategic information is changing hands. This is a target of opportunity! We've marked the position on your map; head over there and secure the intel. It should be stored on one of the vehicles or on their persons.  Do Not Destroy the unarmed vehicles or Officers - for this will compromise the mission.","Side Mission: Secure Intel","sideCircle"], (getMarkerPos "sideCircle"),"Created",0,true,"intel",true] call BIS_fnc_taskCreate;
	sleep 0.1;

	//----- Reset VARS for loops
	sideMissionUp = true;
	private _notEscaping = true;		
	private _gettingAway = false;		
	private _heEscaped = false;
	SM_SUCCESS = false;
	sideMissionSpawnComplete = true;
	publicVariableServer "sideMissionSpawnComplete";
	sleep 0.1;

//-------------------------- [ CORE LOOPS ]

while { sideMissionUp } do {
	sleep 0.1; //to prevent loop from spamming RPT if it bugs out

	//------------------------------------------ IF VEHICLE IS DESTROYED [FAIL]

	if (!alive _intelObj) exitWith {

		sleep 0.1;

        ["secureIntelVicTask", "Failed",true] call BIS_fnc_taskSetState;
        sleep 5;
        ["secureIntelVicTask",west] call bis_fnc_deleteTask;
		sideMissionUp = false;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker","sideCircle"];

		sleep 120;

		{ deleteVehicle _x } forEach [_targetTrigger,_objUnit1,_objUnit2,_objUnit3,_obj1,_obj2,_obj3];
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

			//---------- END THE NOT ESCAPING LOOP

			_notEscaping = false;

			sleep 0.1;

			//---------- SET GETTING AWAY TO TRUE TO DETECT IF HE'S ESCAPED.

			_gettingAway = true;
		};
	};

	//-------------------------------------------- THE ENEMY IS TRYING TO ESCAPE

	if (_gettingAway) then {

		sleep 0.1;

		//_targetTrigger attachTo [_intelObj,[0,0,0]];

		if (count list _targetTrigger < 1) then {

			sleep 0.1;

			_heEscaped = true;

			sleep 0.1;

			_gettingAway = false;
		};
	};

	//------------------------------------------- THE ENEMY ESCAPED [FAIL]

	if (_heEscaped) exitWith {
            ["secureIntelVicTask", "Failed",true] call BIS_fnc_taskSetState;
            sleep 5;

            ["secureIntelVicTask",west] call bis_fnc_deleteTask;
			sideMissionUp = false;
			{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker","sideCircle"];

			//---------- DELETE
			{ deleteVehicle _x } forEach [_targetTrigger,_objUnit1,_objUnit2,_objUnit3,_obj1,_obj2,_obj3];
			sleep 120;
			[_enemiesArray] spawn AW_fnc_SMdelete;
	};

	//-------------------------------------------- THE INTEL WAS RECOVERED [SUCCESS]

	if (SM_SUCCESS) exitWith {
        ["secureIntelVicTask", "Succeeded",true] call BIS_fnc_taskSetState;
        sleep 5;
        ["secureIntelVicTask",west] call bis_fnc_deleteTask;

		sideMissionUp = false;
		[nil, nil, _flatPos] call AW_fnc_SMhintSUCCESS;
		{ _x setMarkerPos [-10000,-10000,-10000]; } forEach ["sideMarker","sideCircle"];

		//---------- REMOVE 'GET INTEL' ACTION
		[_intelObj] remoteExec ["removeAllActions", 0, true];

		//---------- DELETE

		sleep 120;

		{ deleteVehicle _x } forEach [_targetTrigger,_objUnit1,_objUnit2,_objUnit3,_obj1,_obj2,_obj3];
		[_enemiesArray] spawn AW_fnc_SMdelete;
	};
	//-------------------- END LOOP
};
