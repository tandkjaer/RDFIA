/* 
Author:			Quiksilver

modified by:	stanhope, AW community member

Description:	Clear inventory via addAction in onPlayerRespawn.sqf.
*/

private _result = ["Are you sure you want to remove everything from this vehicle's inventory?", "", true, true] call BIS_fnc_guiMessage;

if (_result) then {
	_vehicle = vehicle player;
	clearWeaponCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearBackpackCargoGlobal _vehicle;
	
	systemChat "Vehicle inventory cleared.";
} else {
	systemChat "Vehicle inventory not cleared.";
};