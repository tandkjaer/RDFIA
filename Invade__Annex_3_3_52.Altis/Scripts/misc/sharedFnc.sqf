//TK message
sendTKhintC = {
	if (player getVariable "isZeus") exitWith {};
	params ["_killed"];
	hintC format ["%1, you just teamkilled %2, which is not allowed. You should apologize to %2.", name player, _killed];
};

turretFunction = {
    params ["_heli", "", "_id"];
	if ( isNil "_heli" ) exitWith {};
	if !( _heli isKindOf "Heli_Transport_01_base_F" ) exitWith {};

	_turretStatus = _heli getVariable ['turretStatus', true];

	if ( _turretStatus ) then{
	    [_heli, ["LMG_Minigun_Transport", [1]]] remoteExecCall ["removeWeaponTurret", 0, false];
		[_heli, ["LMG_Minigun_Transport2", [2]]] remoteExecCall ["removeWeaponTurret", 0, false];
		systemChat "Turrets disabled. Use this action again to enable turrets.";
		_heli setVariable ['turretStatus', false, true];
		_heli setUserActionText [_id, "Enable turrets"];
	} else {
	    [_heli, ["LMG_Minigun_Transport", [1]]] remoteExecCall ["addWeaponTurret", 0, false];
		[_heli, ["LMG_Minigun_Transport2", [2]]] remoteExecCall ["addWeaponTurret", 0, false];
		systemChat "Turrets enabled. Use this action again to disable turrets.";
		_heli setVariable ['turretStatus', true, true];
		_heli setUserActionText [_id, "Disable turrets"];
	};
};

kickPlayer = {
    if (hasInterface) exitWith {};
	params ["_name"];
	private _serverpassword = [] call getServerPassword;
	_serverpassword serverCommand format ["#kick %1",_name];
};

banPlayer = {
    if (hasInterface) exitWith {};
	params ["_name"];
	private _serverpassword = [] call getServerPassword;
	_serverpassword serverCommand format ["#exec ban %1",_name];
};

toggleVehicleHUDFunction = {
	if (isNil "vehicleHUDScript") then {
		vehicleHUDScript = execVM "scripts\vehicle\crew\crew.sqf";
		systemChat "Extended passenger information HUD on.";
		profileNamespace setVariable ["AW_I&A_3_ExtendedVehicleHud", true];
		saveProfileNamespace;
	} else {
		terminate vehicleHUDScript;
		vehicleHUDScript = nil;
		disableSerialization;
		1000 cutRsc ["HudNames", "PLAIN"];
		_ui = uiNamespace getVariable "HudNames";
		_HudNames = _ui displayCtrl 99999;
		_HudNames ctrlSetStructuredText parseText "";
		_HudNames ctrlCommit 0;
		systemChat "Extended passenger information HUD off.";
		profileNamespace setVariable ["AW_I&A_3_ExtendedVehicleHud", nil];
		saveProfileNamespace;
	};
};

playerTKed = {
    if (player getVariable "isZeus") exitWith {};
    if ((player getVariable 'timeTKd' == round(time)) || (roleDescription player find "Pilot" > -1) || (player getVariable "isZeus")) exitWith {};

    amountOfTKs = amountOfTKs + 1;
    player setVariable ['timeTKd', round (time), false];

    if (amountOfTKs == (TKLimit -1)) exitWith {
        if (player getVariable "isZeus") exitWith {};
        player enableSimulation false;
		titleText ["<t align='center'><t size='1.6' font='PuristaBold'>Simulation has been disabled as a result of excessive teamkilling. </t><br /> <t size='1.2' font='PuristaBold'>This is a final warning.  Respawn to re-enable simulation and make this message disappear.</t><br /><br /><t size='0.9' font='PuristaBold'>If you continue to teamkill AhoyWorld cannot be held responsible for the consequences.</t></t>", "BLACK", 2, true, true];
		[] spawn {
			waitUntil{!alive player};
			titleFadeOut 0;
			sleep 6000;
			amountOfTKs = amountOfTKs - 1;
		};
	};
    if (amountOfTKs >= TKLimit) exitWith {
        if (player getVariable "isZeus") exitWith {};
		private _uid = getPlayerUID player;

		[player, format["Automated server message: %1 will be kicked for teamkilling.", name player]] remoteExecCall ["sideChat", 0, false];
		titleText ["<t align='center'><t size='1.8' font='PuristaBold'>You have exceeded the server limit for teamkills. <br /> You will be kicked shortly.</t><br /> <t size='1.2' font='PuristaBold'>Your unique ID has been logged along with with your name.</t><br/><br /><t size='1.0' font='PuristaBold'>This message will not go away. In 30 seconds or when you open the esc-menu, you will be kicked from the server.</t><br/><br/><t size='0.8' font='PuristaBold'>We reserve the right to ban you for these teamkills. This may happen without any further notice.</t></t>", "BLACK", 2, true, true];
		private _diagLogTxt = format ['TKScript: Player %1 (UID: %2) has been kicked for teamkilling.', name player, _uid];
		[_diagLogTxt] remoteExecCall ["diag_log", 2];
		player enableSimulation false;

		[_uid] spawn {
		    params ["_uid"];
			waitUntil {!isNull (findDisplay 49)};
			[_uid] remoteExec ["kickPlayer", 2];
		};
        kickOnRespawn = true;

		[_uid] spawn {params ["_uid"]; sleep 30; [_uid] remoteExec ["kickPlayer", 2]; };
	};

	[] spawn {
        sleep 6000;
        amountOfTKs = amountOfTKs - 1;
	};
};