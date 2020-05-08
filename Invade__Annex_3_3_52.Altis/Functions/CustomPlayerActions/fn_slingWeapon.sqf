params ["_mode"];

switch (_mode) do {
	case "AddAction": {
		SlingWeaponActionID = player addAction ["Sling Weapon", {["Sling"] spawn AW_fnc_slingWeapon;}, "", -99, false, true, "", 
			"(vehicle player == player) && (currentWeapon player != '')", 0, false];
	};
	
	case "RemoveAction": {
		player removeAction SlingWeaponActionID;
		SlingWeaponActionID = -1;
	};
	
	case "Toggle": {
		if (isNil "SlingWeaponActionID") then {
			["AddAction"] spawn AW_fnc_slingWeapon;
			systemChat "Sling weapon action added.";
		} else {
			if (SlingWeaponActionID == -1) then {
				["AddAction"] spawn AW_fnc_slingWeapon;
				systemChat "Sling weapon action added.";
			} else {
				["RemoveAction"] spawn AW_fnc_slingWeapon;
				systemChat "Sling weapon action removed.";
			};
		};
	};
	
	case "Respawn": {
		if (isNil "SlingWeaponActionID") then {
			["AddAction"] spawn AW_fnc_slingWeapon;
		} else {
			if (SlingWeaponActionID != -1) then {
				["AddAction"] spawn AW_fnc_slingWeapon;
			};
		};
	};
	
	case "Sling": {
		player action ["SwitchWeapon", player, player, 100];
	};
	
	default {["Unknown parameter."] call BIS_fnc_error;};
};