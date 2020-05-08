/*
author: stanhope
description: small anti-script-kids-script
*/
/*Kick action, for things not too serious or that don't benifit the script kid*/
kickPlayerWithReason = { 
	if (player getVariable ["isZeus", false]) exitWith {};
	
	params ["_reason"];
	private _name = name player;
	private _uid = getPlayerUID player;
	private _diagLogTxt = (format ['anti-script-kidies-script: %1 (%2) activated a script (%3) and was kicked', _name, _uid, _reason]);
	[_diagLogTxt] remoteExecCall ["diag_log", 2];
	
	[player, "Automated server message: All my user input has been disabled for hacking."] remoteExecCall ["sideChat", 0];
	private _adminMessage = format["Player %1 (%3) has been kicked for %2 by the anti-script-kiddie script", _name, _reason, getPlayerUID player];
	[Quartermaster, [adminChannelID, _adminMessage]] remoteExecCall ["customChat", 0];
	titleText ["<t align='center'><t size='1.8' font='PuristaBold'>Your use of scripts has been detected.<br /> You will be kicked shortly.</t><br /> <t size='1.2' font='PuristaBold'>Your unique ID has been logged along with with your name.</t><br/><br /><t size='1.0' font='PuristaBold'>This message will not go away.</t><br/><br/><t size='0.8' font='PuristaBold'>Your user account will likely be banned for the use of these scripts. Appeal any bans on our forums (forums.ahoyworld.net)</t></t>", "BLACK", 2, true, true];
	
	player enableSimulation false;
	
	[_uid] spawn {
        waitUntil {!isNull (findDisplay 49)};
        params ["_uid"];
        [_uid] remoteExec ["kickPlayer", 2];
	};

	[30, kickPlayer, [_uid]] remoteExec ["delayedFunction", 2];
};

/*Ban action, for things that are serious*/
banPlayerWithReason = { 
	if (player getVariable ["isZeus", false]) exitWith {};
	
	params ["_reason"];
	private _name = name player;
	private _uid = getPlayerUID player;
	private _diagLogTxt = (format ['anti-script-kidies-script: %1 (%2) activated a script (%3) and was banned', _name, _uid, _reason]);
	[_diagLogTxt] remoteExecCall ["diag_log", 2];
	
	[player, "Automated server message: All my user input has been disabled for hacking."] remoteExecCall ["sideChat", 0];
	private _adminMessage = format["Player %1 has been banned for %2 by the anti-script-kiddie script", _name, _reason];
	[Quartermaster, [adminChannelID, _adminMessage]] remoteExecCall ["customChat", 0];
	titleText ["<t align='center'><t size='1.8' font='PuristaBold'>Your use of scripts has been detected.<br /> All user input has been disabled.</t><br /> <t size='1.2' font='PuristaBold'>Your unique ID has been logged along with your name.</t><br/><br /><t size='1.0' font='PuristaBold'>This message will not go away and your input will not be re-enabled.</t><br/><br/><t size='0.8' font='PuristaBold'>Your user account will likely be banned for the use of these scripts. Appeal any bans on our forums (forums.ahoyworld.net)</t></t>", "BLACK", 2, true, true];
	
	disableUserInput true;
	
	[30, banPlayer, [_uid]] remoteExec ["delayedFunction", 2];
	[32, kickPlayer, [_uid]] remoteExec ["delayedFunction", 2];
};

playerDamageDisabledCount = 0;
playerExcessiveSpeedCount = 0;
playerHiddenCount = 0;

/*scrollwheel options to look out for*/	
forbiddenScrollWheelOptions = ["no recoil","no reciol","unlimitied ammo","unlimited ammo","script executor","slient aim","heal self",
	"speed hack","speedhack","god mode","god-mod","godmode","nuke","kill all","kill 2","spam database","delete all database",
	"fuck","deaths dance scroll menu", "kick all", "troll", "-back-", "dick", "hack", "cock", "script menu"];
	
/*The action to be executed in the loop*/
naughtyCheck = {	
	if ((unitRecoilCoefficient player) <= 0.9) exitWith {
		["recoil reduced"] spawn banPlayerWithReason;
	};
	sleep 0.1;
	
	if ((unitRecoilCoefficient player) > 2) exitWith {
		["recoil increased"] spawn kickPlayerWithReason;
	};
	sleep 0.1;
	
	if ((getAnimSpeedCoef player) <= 0.9) exitWith {
		["anim speed slowed"] spawn kickPlayerWithReason;
	};
	sleep 0.1;
	
	if ((getAnimSpeedCoef player) > 2) exitWith {
		["anim speed increased (speedhack)"] spawn banPlayerWithReason;
	};
	sleep 0.1;
	
	if (!(isDamageAllowed player) && (lifeState player != "INCAPACITATED")) then {
		playerDamageDisabledCount = playerDamageDisabledCount + 1;
		[] spawn { sleep 600; playerDamageDisabledCount = playerDamageDisabledCount - 1;};
		if (playerDamageDisabledCount > 4) exitWith {
			["damage disabled (godmode)"] spawn kickPlayerWithReason;
		};
	};
	sleep 0.1;
	
	if (isObjectHidden player) then {
		playerHiddenCount = playerHiddenCount + 1;
		[] spawn {sleep 600; playerHiddenCount = playerHiddenCount - 1;};
		if (playerHiddenCount > 1) exitWith {
			["player is hidden"] spawn kickPlayerWithReason;
		};
	};
	
	(uiNamespace getVariable "BIS_AAN") closeDisplay 1;
	sleep 0.1;
	
	onEachFrame {};
	onMapSingleClick {};
	sleep 0.1;
	
	if (vehicle player == player) then {
		_vel = velocity player;
        if ((_vel select 0) > 370 || (_vel select 1) > 370) then {
            playerExcessiveSpeedCount = playerExcessiveSpeedCount + 1;
            [] spawn { sleep 600; playerExcessiveSpeedCount = playerExcessiveSpeedCount - 1;};
        };

		if (playerExcessiveSpeedCount > 6) exitWith {
			["excessive speed"] spawn kickPlayerWithReason;
		};
	};
	sleep 0.1;
	
	/*Check the players scrollwheel options*/
	private _actionTitle = "";
	for "_i" from 0 to (count (actionIDs player) - 1) do {
		{
			_actionTitle = (player actionParams _i) select 0;
			if (! isNil "_actionTitle") then{
				_actionTitle = toLower _actionTitle;
				
				if (_actionTitle find _x > -1) exitWith {
					private _text = format ["Scrollwheel option %1 detected", _x];
					[_text] spawn banPlayerWithReason;
				};
			};
			sleep 0.1;
		} forEach forbiddenScrollWheelOptions;
		sleep 0.1;
	};
};