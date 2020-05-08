/*
author: ?
Description: scripts that cleans up things every 360 seconds
last edited: 9/5/18 by stanhope
edited: general cleanup
*/
cleanupScript = true;

while {cleanupScript} do {

	{
        if (_x isKindOf "AllVehicles") then {
            private _myvehicle = _x;
            { _myvehicle deleteVehicleCrew _x } forEach crew _myvehicle;
        };
        deleteVehicle _x;
        sleep 0.1;
    } forEach allDead;

	sleep 1;
	{deleteVehicle _x;} forEach(allMissionObjects "CraterLong");
	sleep 1;
	{deleteVehicle _x;} forEach(allMissionObjects "WeaponHolder");
	sleep 1;
	{deleteVehicle _x;} forEach (allMissionObjects "WeaponHolderSimulated");
	sleep 1;
	{
	    if ((count units _x) == 0) then {
	        deleteGroup _x;
	    };
	    sleep 0.1;
    } forEach allGroups;
	sleep 1;
    
    private _ejectionItems = [
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
		if ( speed _x == 0 ) then{
		    deleteVehicle _x;
		};
    } forEach (entities [_ejectionItems, []]);
	
    private _fog = fogParams;
	private _fogValue = _fog select 0;
	private _fogDecay = _fog select 1;
	private _fogBase = _fog select 2;
	if (_fogdecay != 0) then {_fogdecay = 0;};
	if (_fogBase != 0) then {_fogBase = 0;};
	1 setFog [_fogValue, _fogDecay, _fogBase];
	sleep 1;
	
	if (_fogValue > 0.7) then {
		for "_i" from 0 to 19 do {_fogValue = _fogValue - 0.035; 2 setFog [_fogValue, _fogDecay, _fogBase]; sleep 2;};
	};
	if (_fogValue > 0.4) then {
		for "_i" from 0 to 19 do {_fogValue = _fogValue - 0.02; 2 setFog [_fogValue, _fogDecay, _fogBase]; sleep 2;};
	};
	
	if ((daytime > 20) || (daytime < 5)) then {
		setTimeMultiplier 6;
	} else{
		setTimeMultiplier 1;
	};
	
	sleep 360;
};