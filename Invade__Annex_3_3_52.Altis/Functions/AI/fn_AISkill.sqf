/*
* Author: alganthe
* Set the mission parameter defined skill values for an array of units.
*
* Arguments:
* 0: Array of units to change <ARRAY>
*
* Return Value:
* NOTHING
*/
params ["_AIArray"];

{
    _x setSkill ["general", (( "AIGeneralSkill" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["aimingAccuracy", (( "AIAimingAccuracy" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["aimingShake", (( "AIAimingShake" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["aimingSpeed", (( "AIAimingSpeed" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["spotDistance", (( "AISpotingDistance" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["spotTime", (( "AISpottingSpeed" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["courage", (( "AICourage" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["reloadSpeed", (( "AIReloadSpeed" call BIS_fnc_getParamValue) / 10)];
    _x setSkill ["commanding", (( "AICommandingSkill" call BIS_fnc_getParamValue) / 10)];
} forEach _AIArray;
