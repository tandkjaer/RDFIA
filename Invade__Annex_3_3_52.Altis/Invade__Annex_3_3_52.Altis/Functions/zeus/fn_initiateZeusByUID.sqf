if (!isServer) then {["initiatezeusbyuid was called on a different device than server"] remoteExec ["diag_log", 2];};
_this spawn {
    params ["_player"];
    private _uid = getPlayerUID _player;

    waitUntil {sleep 0.1; !isNil "zeusModules"};
    if !( isNil {_player getVariable 'zeusModule'} ) then {
        unassignCurator (zeusModules select (_player getVariable 'zeusModule'));
    };
    _player setVariable ["zeusModule", nil];

    waitUntil {sleep 0.1; !isNil "zeusSpartanUIDs"};

    private _zeusUIDs = zeusCoreStaffUIDs + zeusAdminUIDs + zeusModeratorUIDs + zeusSpartanUIDs;
    private _zeusModuleNumber = _zeusUIDs find _uid;

    if ((_zeusModuleNumber == -1) || ((zeusModeratorUIDs find _uid) > -1)) exitWith {
        _player setVariable ["isCoreStaff", false, true];
        _player setVariable ["isAdmin", false, true];
        _player setVariable ["isZeus", false, true];
        if ( _zeusModuleNumber == -1 ) exitWith {
            [parseText format ["<t align='center' font='PuristaBold' ><t size='1.6'>%1</t><br />
                <t size='1.2'>Welcome %2</t><br /><t size='0.8' font='PuristaMedium'>Ensure you are familiar with our server rules:<br />www.ahoyworld.net/index/rules</t>",
                "INVADE AND ANNEX", name _player],
                true, nil, 12, 0.3, 0.3
            ] remoteExec ["BIS_fnc_textTiles", _player];
        };

        if ( (zeusModeratorUIDs find _uid) > -1 ) exitWith{
            [parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.6'>%1</t><br />
                <t size='1.2'>Welcome %2</t>", "AWE MODERATOR: ZEUS NOT ASSIGNED", name _player],
                true, nil, 12, 0.3, 0.3
            ] remoteExec ["BIS_fnc_textTiles", _player];
        };
    };

    private _zeusModule = zeusModules select _zeusModuleNumber;
    unassignCurator _zeusModule;
    _player assignCurator _zeusModule;
    _player setVariable ["zeusModule", _zeusModuleNumber];
    _player setVariable ["isZeus", true, true];
    [_zeusModule,[-1,-2,0]] call BIS_fnc_setCuratorVisionModes;
    adminChannelID radioChannelAdd [_player];

    if ( (zeusCoreStaffUIDs find _uid) > -1 ) exitWith{
        _player setVariable ["isCoreStaff", true, true];
        _player setVariable ["isAdmin", true, true];
        diag_log format ['Zeus (admin) assigned on %1', name _player];
        [parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.6'>%1</t><br />
            <t size='1.2'>Welcome %2</t>", "ZEUS (CORE STAFF) ASSIGNED", name _player], true, nil, 12, 0.3, 0.3
        ] remoteExec ["BIS_fnc_textTiles", _player];
    };

    if ( (zeusAdminUIDs find _uid) > -1 ) exitWith{
        _player setVariable ["isAdmin", true, true];
        diag_log format ['Zeus (admin) assigned on %1', name _player];
        [parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.6'>%1</t><br />
            <t size='1.2'>Welcome %2</t>", "ZEUS (PUBLIC MOD) ASSIGNED", name _player], true, nil, 12, 0.3, 0.3
        ] remoteExec ["BIS_fnc_textTiles", _player];
    };

    if ( (zeusSpartanUIDs find _uid) > -1 ) exitWith{
        diag_log format ['Zeus (spartan) assigned on %1', name _player];
        [parseText format ["<br /><t align='center' font='PuristaBold' ><t size='1.6'>%1</t><br />
            <t size='1.2'>Welcome %2</t>", "ZEUS (SPARTAN) ASSIGNED", name _player], true, nil, 12, 0.3, 0.3
        ] remoteExec ["BIS_fnc_textTiles", _player];
    };
};