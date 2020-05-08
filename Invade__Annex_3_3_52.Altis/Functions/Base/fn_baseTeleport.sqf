/*
    Author: BACONMOP
    Description: For teleporting to different bases
*/
params ["_unit","_baseLoc"];

switch (_baseLoc) do{
    case "BASE":{
        if (_baseLoc in controlledZones) then {
            _unit setPos (getMarkerPos "BASE");
        };
    };
    case "Carrier":{
        _unit setPosWorld (getPosWorld carrierTPPosObj);
    };
    case "Pilot":{
        _unit setPosWorld (getPosWorld PilotSpawnPos);
    };
    case "Stadium":{
        if (_baseLoc in controlledZones) then {
            _unit setPos (getMarkerPos "FOB_Marathon");
        };
    };
    case "Terminal":{
        if (_baseLoc in controlledZones) then {
            _unit setPos (getMarkerPos "FOB_Guardian");
        };
    };
    case "Molos_Airfield":{
        if (_baseLoc in controlledZones) then {
            _unit setPos (getMarkerPos "FOB_Last_Stand");
        };
    };
	case "AAC_Airfield":{
        if (_baseLoc in controlledZones) then {
            _unit setPos (getMarkerPos "FOB_Martian");
        };
    };
    default {
        ["Something went wrong while trying to teleport you"] remoteExec ["hint", _unit];
        diag_log format ["ERROR: Could not recognize %1 as a location to teleport to.", _baseLoc];
    }
};