/*
author: ?
Description: scripts that cleans up things every 360 seconds
*/

cleanupScript = true;

while {cleanupScript} do {
	
	{deleteVehicle _x;} count allDead;
	sleep 1;
	{deleteVehicle _x;} count (allMissionObjects "CraterLong");
	sleep 1;
	{deleteVehicle _x;} count (allMissionObjects "WeaponHolder");
	sleep 1;
	{deleteVehicle _x;} count (allMissionObjects "WeaponHolderSimulated");
	sleep 1;
	{if ((count units _x) == 0) then {deleteGroup _x;};} count allGroups;
	sleep 1;
    
    _ejectionItems = [
		"B_Ejection_Seat_Plane_Fighter_01_F",
		"B_Ejection_Seat_Plane_CAS_01_F",
		"O_Ejection_Seat_Plane_CAS_02_F",
		"O_Ejection_Seat_Plane_Fighter_02_F",
		"I_Ejection_Seat_Plane_Fighter_04_F",
		"I_Ejection_Seat_Plane_Fighter_03_F",
		"plane_fighter_01_canopy_f",
		"plane_fighter_02_canopy_f",
		"plane_fighter_03_canopy_f",
		"plane_fighter_04_canopy_f",
		"Plane_CAS_01_Canopy_f",
		"Plane_CAS_02_Canopy_f"
	];
	
    {
		if ( speed _x == 0 ) then{ deleteVehicle _x; }; 
    } forEach (entities [_ejectionItems, []]);
	
    _fog = fogParams;
	_fogValue = _fog select 0;
	_fogDecay = _fog select 1;
	_fogBase = _fog select 2;
	if (_fogdecay > 0) then {_fogdecay = 0;};
	if (_fogBase > 0) then {_fogBase = 0;};
	if (_fogValue > 0.7) then {
	    [5, [0.3, _fogDecay, _fogBase]] remoteExec ["setFog", 2];
	};
	if (_fogValue > 0.4) then {
        [5, [0.0, _fogDecay, _fogBase]] remoteExec ["setFog", 2];
    };
	
	if ((daytime > 21) || (daytime < 5)) then {
	    [6] remoteExec ["setTimeMultiplier", 2] ;
	} else{
		[1] remoteExec ["setTimeMultiplier", 2] ;
	};

	private _windArray = wind;
	{
	    if (_x > 12) then {
	        _windArray set [_forEachIndex, 12];
	    };
	} forEach _windArray;
    _windArray pushBack false;
    [_windArray] remoteExec ["setWind", 2] ;
	
	sleep 360;
};