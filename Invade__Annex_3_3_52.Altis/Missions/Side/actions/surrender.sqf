/*
Author:

	Quiksilver

Description:

	Object is teleported to side mission location
	addAction on object executes this script
	when script is done, spawn explosion and teleport object away

	Modified for simplicity and other applications (non-destroy missions).
	BIS_fnc_spawn/BIS_fnc_timetostring are all performance hogs.

To do:

	Needs re-framing for 'talk to contact' type missions [DONE]

	This code is now just a variable switch, to be sent back in order that the mission script can continue.

	Does it allow for possibility of failure? I dont know, too tired at the moment.

_______________________________________________________*/

//-------------------- Send hint to player that he's done something...
hint "You ordered him to surrender";
sleep 1;


params ["_unit"];
[_unit, 'Acts_AidlPsitMstpSsurWnonDnon_loop'] remoteExec ['switchMove', _unit, false];

//---------- Send notice to all players that something has been done.
SM_SUCCESS = true;
HE_SURRENDERS = true;
publicVariableServer "SM_SUCCESS";
publicVariableServer "HE_SURRENDERS";
