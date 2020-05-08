private _medkitChecked = false;
private _toolkitChecked = false;

{
	switch (_x) do {
		//Medkit:
		case "Medikit": {
			if (roleDescription player find "Medic" == -1 && !_medkitChecked) then {
				systemChat "Warning: The Medkit(s) you are carrying can only be used by Medics.";
				_medkitChecked = true;
			};
		};
		//Toolkit:
		case "ToolKit": {
			if (((roleDescription player find "Engineer") == -1) && ((roleDescription player find "Specialist") == -1) && !_toolkitChecked) then {
				systemChat "Warning: The Toolkit(s) you are carrying can only be used by Engineers, Explosive Specialists and Repair Specialists.";
				_toolkitChecked = true;
			};
		};
		//AR-2 Darter Backpack:
		case "B_UAV_01_backpack_F": {
			if (roleDescription player find "UAV" == -1) then {
				systemChat "Warning: The AR-2 Darter you are carrying can only be controlled by UAV Operators.";
			};
		};
		//AL-6 Pelican Backpack:
		case "B_UAV_06_backpack_F";
		//AL-6 Pelican (Medical) Backpack:
		case "B_UAV_06_medical_backpack_F": {
			if (roleDescription player find "UAV" == -1) then {
				systemChat "Warning: The AL-6 Pelican you are carrying can only be controlled by UAV Operators.";
			};
		};
		//Remote Designator Backpack:
		case "B_Static_Designator_01_weapon_F": {
			if (roleDescription player find "UAV" == -1) then {
				systemChat "Warning: The Remote Designator you are carrying can only be controlled by UAV Operators.";
			};
		};
		//Mk6 Mortar Bipod Backpack:
		case "B_Mortar_01_support_F";
		//Mk6 Mortar Tube Backpack:
		case "B_Mortar_01_weapon_F": {
			if (roleDescription player find "FSG" == -1) then {
				systemChat "Warning: The artillery computer of the mortar you're carrying can only be used by the FSG gunner";
			};
		};
	};
} forEach (items player + [backpack player]);

if (isStaminaEnabled player && (loadAbs player >= getNumber (configFile >> "CfgInventoryGlobalVariable" >> "maxSoldierLoad"))) then {
	systemChat "Warning: Your movement speed is currently limited because you are carrying too much.";
};