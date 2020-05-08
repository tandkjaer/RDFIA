/*
Triggers by initServer.sqf
Sets up serverside & global stuff
*/
/*Altis*/

//Respawn points in main base
[west, getMarkerPos "BASE", "Main base"] call BIS_fnc_addRespawnPosition;

//hide some stuff:
{
	_allStuff = (getMarkerPos _x) nearObjects 250;
	_fobStuff = _allStuff - nearestTerrainObjects [(getMarkerPos _x), [], 250, false];
	{_x hideObjectGlobal true;} forEach _fobStuff;
} forEach ["term_pl_res","aac_pl_res","sdm_pl_res","mol_pl_res"];

//admin channel
adminChannelID = radioChannelCreate [[0.8, 0, 0, 1], "Admin Channel", "%UNIT_NAME", [], true];
publicVariable "adminChannelID";
[adminChannelID, [Quartermaster]] remoteExec ["radioChannelAdd", 0, true];

//global
arsenalArray = [Quartermaster, Quartermaster_1, Quartermaster_2, Quartermaster_3, Quartermaster_4, Quartermaster_5];
publicVariable "arsenalArray";

//global
BaseArray = ["BASE","FOB_Martian","FOB_Marathon","FOB_Guardian","FOB_Last_Stand","USS_Freedom"];
publicVariable "BaseArray";

amountOfAOsToComplete = 85;