/*
Author: Stanhope
Description: Heals all players near the person calling it (derp revive)
To be called via:
object addAction ["Revive and heal players", {_this spawn AW_FNC_baseHeal;}, [], -200, false, true, "", "vehicle _this == _this", 10, true];
*/
params ["_target"];

private _players = (getPos _target) nearObjects ["Man", 20];

{
    if (isPlayer _x) then {
        if (captive _x) then {
            [player, "REVIVED"] remoteExecCall ["derp_revive_fnc_switchState", player];
        };
        _x setDamage 0;
    };
} forEach _players;

hint "All players within 20 meters revived and healed";

