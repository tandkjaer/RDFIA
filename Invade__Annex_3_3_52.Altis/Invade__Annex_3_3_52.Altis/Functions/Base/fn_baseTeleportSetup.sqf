/* description: to set up base teleport on objects */
params ["_obj", "_currLoc"];

if (_currLoc != "BASE") then {
    _obj addAction ["<t color='#009ACD'>Teleport to Main Base</t>","cutText ['','BLACK OUT'];sleep 1;[player,'BASE'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];", nil, -100, false, true, "", "true", 10];
};
if (_currLoc != "Pilot") then {
    _obj addAction ["<t color='#009ACD'>Teleport to Main Base Pilot Spawn</t>","cutText ['','BLACK OUT'];sleep 1;[player,'Pilot'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];", nil, -101, false, true, "", "(roleDescription player find 'Pilot' > -1)", 10];
};
if (_currLoc != "AAC_Airfield") then {
    _obj addAction ["<t color='#009ACD'>Teleport to FOB Martian</t>","cutText ['','BLACK OUT'];sleep 1;[player,'AAC_Airfield'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];",nil, -102,false,true,"","('AAC_Airfield' in controlledZones)",10];
};
if (_currLoc != "Stadium") then {
    _obj addAction ["<t color='#009ACD'>Teleport to FOB Marathon</t>","cutText ['','BLACK OUT'];sleep 1;[player,'Stadium'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];",nil, -103,false,true,"","('Stadium' in controlledZones)",10];
};
if (_currLoc != "Terminal") then {
    _obj addAction ["<t color='#009ACD'>Teleport to FOB Guardian</t>","cutText ['','BLACK OUT'];sleep 1;[player,'Terminal'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];",nil, -104,false,true,"","('Terminal' in controlledZones)",10];
};
if (_currLoc != "Molos_Airfield") then {
    _obj addAction ["<t color='#009ACD'>Teleport to FOB Last Stand</t>","cutText ['','BLACK OUT'];sleep 1;[player,'Molos_Airfield'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];",nil, -106,false,true,"","('Molos_Airfield' in controlledZones)",10];
};
if (_currLoc != "Carrier") then {
    _obj addAction ["<t color='#009ACD'>Teleport to USS Freedom</t>", "cutText ['','BLACK OUT'];sleep 1; [player,'Carrier'] remoteExec ['AW_fnc_baseTeleport',2];sleep 1; cutText ['','BLACK IN'];", nil, -106,false,true,"","(roleDescription player find 'Pilot' > -1) || typeOf player == 'B_soldier_UAV_F' || (_this getVariable 'isZeus')",10];
};
