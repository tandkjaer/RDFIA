/*
author: Ryko

description: sets up short range radios

Last modified: 11/09/2019 by stanhope
*/

private _roleDesc = roleDescription player;

switch (true) do {
    case (_roleDesc find "Platoon" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "40"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Alpha" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "50"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Bravo" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "51"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Charlie" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "52"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Delta" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "53"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Echo" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "54"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Foxtrot" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "55"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Golf" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "60"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Hotel" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "61"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Vortex" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "80"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "FSG" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "70"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Recon" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "71"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Sniper" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "72"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    case (_roleDesc find "Staff" != -1): {
        for "_i" from 1 to 8 do {
            [(call TFAR_fnc_activeSwRadio), _i, "41"] call TFAR_fnc_SetChannelFrequency;
        }
    };
    default {
        [(call TFAR_fnc_activeSwRadio), 1, "40"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 2, "50"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 3, "51"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 4, "52"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 5, "53"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 6, "54"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 7, "60"] call TFAR_fnc_SetChannelFrequency;
        [(call TFAR_fnc_activeSwRadio), 8, "61"] call TFAR_fnc_SetChannelFrequency;
    };
};


if ( !(isNil {player getVariable 'radioSR'}) ) then
{	_frequency = player getVariable 'radioSR';
    _channel = (floor (_frequency/10)) - 4;
    _frequency = str _frequency;

    [(call TFAR_fnc_activeSwRadio), (_channel+1), _frequency] call TFAR_fnc_SetChannelFrequency;
    [(call TFAR_fnc_activeSwRadio), _channel] call TFAR_fnc_setSwChannel;
}
else
{	[(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_setSwChannel; };

if ( (call TFAR_fnc_activeSwRadio) find TFAR_PR_RADIO_BF > -1 ) then
{	player setVariable ['radioSRmodel', TFAR_PR_RADIO_BF]; };
if ( (call TFAR_fnc_activeSwRadio) find TFAR_SR_RADIO_BF > -1 ) then
{	player setVariable ['radioSRmodel', TFAR_SR_RADIO_BF]; };
if ( (call TFAR_fnc_activeSwRadio) find TFAR_PR_RADIO_OF > -1 ) then
{	player setVariable ['radioSRmodel', TFAR_PR_RADIO_OF]; };
if ( (call TFAR_fnc_activeSwRadio) find TFAR_SR_RADIO_OF > -1 ) then
{	player setVariable ['radioSRmodel', TFAR_SR_RADIO_OF]; };