/*
author: stanhope

description: executes the function that controlls the AA

this addAction ['<t color=""#ff1111"">Activate Base Air-Defense</t>',{['base'] execVM 'scripts\misc\ActivateBaseAA.sqf'},[],21,true,true,'','((vehicle player) == player)',5];
this addAction ['<t color=""#ff1111"">Activate Carrier Air-Defense</t>',{['carrier'] execVM 'scripts\misc\ActivateBaseAA.sqf'},[],21,true,true,'','((vehicle player) == player)',5];
*/
params ["_type"];

if (isNil "Base_AA_Active") then {Base_AA_Active = false;};
if (isNil "Base_AA_Cooldown") then {Base_AA_Cooldown = false;};
if (isNil "CVN_CIWS_Active") then {CVN_CIWS_Active = false;};
if (isNil "CVN_CIWS_Cooldown") then {CVN_CIWS_Cooldown = false;};

switch (_type) do {
    case "base": {
        [] remoteExec ["AW_fnc_mainBaseAA", 2];

        if ((not Base_AA_Cooldown) && (not Base_AA_Active)) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Activating base AA ...</t>"], true, nil, 2, 0.5, 0.3] spawn BIS_fnc_textTiles;
        	private _msg = format ["Player %1 activated base AA", name player];
        	[Quartermaster, [adminChannelID, _msg]] remoteExecCall ["customChat", 0, false];
        };

        if (Base_AA_Active) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Base AA is already active</t>"], true, nil, 4, 1, 0.3] spawn BIS_fnc_textTiles;
        };

        if (Base_AA_Cooldown) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Base AA is cooling down</t>"], true, nil, 4, 1, 0.3] spawn BIS_fnc_textTiles;
        };
    };
    case "carrier": {
        [] remoteExec ["AW_fnc_cvnCIWS", 2];

        if ((not CVN_CIWS_Cooldown) && (not CVN_CIWS_Active)) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Activating carrier AA ...</t>"], true, nil, 2, 0.5, 0.3] spawn BIS_fnc_textTiles;
        	private _msg = format ["Player %1 activated carrier AA", name player];
        	[Quartermaster, [adminChannelID, _msg]] remoteExecCall ["customChat", 0, false];
        };

        if (CVN_CIWS_Active) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Carrier AA is already active</t>"], true, nil, 4, 1, 0.3] spawn BIS_fnc_textTiles;
        };

        if (CVN_CIWS_Cooldown) then {
        	[parseText format ["<br /><t align='center' font='PuristaBold' size='1.4'>Carrier AA is cooling down</t>"], true, nil, 4, 1, 0.3] spawn BIS_fnc_textTiles;
        };
    };
    default {
        hint "Something went wrong while activating base AA, please inform staff of this.";
    };
};

