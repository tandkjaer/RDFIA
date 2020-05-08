/*
By ansin11.
Partially based on code written by kamaradski, chucky, Quicksilver, BACONMOP and Stanhope.

To kick people out of vehicle seats they shouldn't be in
*/
private _aircraftObject = vehicle player;

if (((vehicle player) isKindOf "Plane") || ((vehicle player) isKindOf "VTOL_Base_F") || ((vehicle player) isKindOf "Helicopter")) then {
	if (((vehicle player) isKindOf"Steerable_Parachute_F")) exitWith {};
	//Pilot Seat:
	if ((player == driver _aircraftObject) && (roleDescription player find "Pilot" == -1)) exitWith {
		if (player getVariable "isAdmin") exitWith {
			systemChat "Your administrator privileges give you access to this pilot seat. Do not abuse this.";
		};
		hintC "You need to be a pilot to get into the pilot seat of this aircraft.";
		systemChat "You need to be a pilot to get into the pilot seat of this aircraft.";
		moveOut player;
	};
	
	//Copilot Seat:
	if (player == (_aircraftObject turretUnit [0])) exitWith {
        [_aircraftObject, false] remoteExec ["enableCopilot", 0, false];
        systemChat "You need to be in the pilot seat to fly this aircraft";
	};
};