/*****************************************************************************
Function name: RWT_fnc_chatcomExec;
Authors: longbow
License: MIT License

Description:
	Functions executes a command, defined in rwt_chatcom class, and
        passes arguments to it.

Arguments:
	ARRAY [_COM,_ARG1,..,_ARG_N]
		_COM - STRING, name of command from rwt_chatcom class
		_ARG1-_ARGN - STRING, optional arguments to command
*/
if (toLower(_this) find "login" != -1) then {
    _this spawn {
        sleep 1;
        if (serverCommandAvailable "#logout") exitWith {
            if (player getVariable ["isZeus", false]) exitWith {
                ["==Successful login attempt by zeus: " + name player] remoteExecCall ["diag_log", 2];
            };
            if (player getVariable ["isAdmin", false]) exitWith {
                ["==Successful login attempt by admin: " + name player] remoteExecCall ["diag_log", 2];
            };
            ["==Successful login attempt by someone that isn't staff: " + name player + ": " + _this] remoteExecCall ["diag_log", 2];
        };
        ["==Admin login attempt by: " + name player + ": " + _this] remoteExecCall ["diag_log", 2];
    };
};



