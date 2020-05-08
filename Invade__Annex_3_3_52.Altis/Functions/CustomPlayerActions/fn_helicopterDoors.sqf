params ["_mode"];

switch (_mode) do {
	case "AddAction": {
		HelicopterDoorsActionID = player addAction ["Open / close doors", {["Open/Close"] spawn AW_fnc_helicopterDoors;}, [], -99, false, true, "", 
			"(typeOf (vehicle _target) == 'B_Heli_Transport_01_F')"];
	};
	
	case "RemoveAction": {
		player removeAction HelicopterDoorsActionID;
		HelicopterDoorsActionID = -1;
	};
	
	case "Toggle": {
		if (isNil "HelicopterDoorsActionID") then {
			["AddAction"] spawn AW_fnc_helicopterDoors;
			systemChat "Ghost Hawk doors action added.";
		} else {
			if (HelicopterDoorsActionID == -1) then {
				["AddAction"] spawn AW_fnc_helicopterDoors;
				systemChat "Ghost Hawk doors action added.";
			} else {
				["RemoveAction"] spawn AW_fnc_helicopterDoors;
				systemChat "Ghost Hawk doors action removed.";
			};
		};
	};
	
	case "Respawn": {
		if (isNil "HelicopterDoorsActionID") then {
			["AddAction"] spawn AW_fnc_helicopterDoors;
		} else {
			if (HelicopterDoorsActionID != -1) then {
				["AddAction"] spawn AW_fnc_helicopterDoors;
			};
		};
	};
	
	case "Open/Close": {
		_helicopter = vehicle player;
			if (_helicopter doorPhase 'door_R' == 0) then {
				_helicopter animateDoor ['door_R', 1];
				_helicopter animateDoor ['door_L', 1];
			} else {
				_helicopter animateDoor ['door_R', 0];
				_helicopter animateDoor ['door_L', 0];
			};
	};
	
	default {["Unknown parameter."] call BIS_fnc_error;};
};