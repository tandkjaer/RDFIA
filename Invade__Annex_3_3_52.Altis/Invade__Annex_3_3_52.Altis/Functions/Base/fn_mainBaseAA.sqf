/*
Author: ansin11

description: Code that handles the AA protection for main base.

Last modified: 25/01/2018 by stan

modified: rewritten for main base AA
*/
if (isNil "Base_AA_Active") then {Base_AA_Active = false;};
if (isNil "Base_AA_Cooldown") then {Base_AA_Cooldown = false;};

if (!(Base_AA_Cooldown) && !(Base_AA_Active)) then {
	
	sleep 2;
    //activate AA
    {
        _x setVehicleReportOwnPosition true;
        _x setVehicleReceiveRemoteTargets true;
        _x setVehicleReportRemoteTargets true;
        _x setVehicleRadar 1;
        _x setVehicleAmmo 1;
        _x setAutonomous true;
        _x setVehicleLock "LOCKEDPLAYER";
        createVehicleCrew _x;
    } forEach [Base_AA];

    Base_AA_Active = true;
    publicVariable "Base_AA_Active";
	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'><t color='#0090ff'>Crossroads: </t><br />Base air-defense activated.</t>"], true, nil, 3, 1, 0.3] remoteExec ["BIS_fnc_textTiles", -2];

    //deactivate and enter cooldown after 300 sec
    sleep 300;

    Base_AA_Active = false;
    Base_AA_Cooldown = true;
    publicVariable "Base_AA_Active";
    publicVariable "Base_AA_Cooldown";

    {
        _x setVehicleRadar 2;
        _x setVehicleAmmo 0;
        _x setVehicleLock "LOCKED";
        deleteVehicle gunner _x;

    } forEach [Base_AA];

    //cooldown complete after 900 sec
	[parseText format ["<br /><t align='center' font='PuristaBold'><t size='1.4' color='#0090ff'>Crossroads: </t><t size='1.2'><br />Base air-defense going into cooldown.</t></t>"], true, nil, 3, 1, 0.3] remoteExec ["BIS_fnc_textTiles", -2];
    sleep 900;
    Base_AA_Cooldown = false;
    publicVariable "Base_AA_Cooldown";
	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'><t color='#0090ff'>Crossroads: </t><br />Base air-defense available.</t>"], true, nil, 3, 1, 0.3] remoteExec ["BIS_fnc_textTiles", -2];

};

if (Base_AA_Active) then {/*player get's a local hint that AA is up*/};

if (Base_AA_Cooldown) then {/*player get's a local hint that AA is cooling down*/};