//zeusupdater.sqf
stopZeusUpdaterScript = false;
zeusUpdaterFnc = {
    params ["_isUserCall"];
    private _obj = (
        entities "AllVehicles"
            - entities "Animal"
            - [
                Quartermaster,Quartermaster_1,Quartermaster_2,Quartermaster_3,Quartermaster_4,Quartermaster_5,
                CVN_CIWS_1,CVN_CIWS_2,CVN_CIWS_3,CVN_RAM,CVN_SAM_2,CVN_SAM_3,Base_AA
            ]
    );

    if (!isNil "HC1") then {
        _obj = _obj - [HC1];
    };

    [_obj] remoteExec ["AW_fnc_addToAllCurators", 2];

    if (isServer) then {
        if (stopZeusUpdaterScript) exitWith{};
    };

    if (isNil "_isUserCall") then {
        sleep 180;
        [] spawn zeusUpdaterFnc;
    };
};
sleep 20;

addMissionEventHandler ["PlayerConnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
	if (str _id == "HC1") then {
        [] spawn {
            sleep 30;
            if (!isNil "HC1") then {
                stopZeusUpdaterScript = true;
                (owner HC1) publicVariableClient "zeusUpdaterFnc";
                [[], zeusUpdaterFnc] remoteExec ["spawn", HC1];
                [Quartermaster, [adminChannelID, "HC1 connected, moving zeus updater to HC1"]] remoteExec ["customChat", 0];
            };
        };
	};
}];

addMissionEventHandler ["PlayerDisconnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
	if (str _id == "HC1") then {
	    stopZeusUpdaterScript = false;
    	[] spawn zeusUpdaterFnc;
    	[Quartermaster, [adminChannelID, "HC1 disconnected, started zeus updater on server"]] remoteExec ["customChat", 0];
		HC1 = nil;
    };
}];

if (isNil "HC1") then {
    [] spawn zeusUpdaterFnc;
    [Quartermaster, [adminChannelID, "Zeus updater started on server"]] remoteExec ["customChat", 0];
} else {
    (owner HC1) publicVariableClient "zeusUpdaterFnc";
    [[], zeusUpdaterFnc] remoteExec ["spawn", HC1];
    [Quartermaster, [adminChannelID, "Zeus updater started on HC1"]] remoteExec ["customChat", 0];
};


