/*
whitelistArray and blacklistArray are being defined in ArsenalInitialisation.sqf.
*/

private _removedString = "The following equipment has been removed from your inventory:<br/><br/>";
private _removedItems = [];

if (!(alive player) || ("GearRestriction" call BIS_fnc_getParamValue == 0)) exitWith {};
if (isNil "whitelistArray" || isNil "blacklistArray") exitWith {};

//Weapons:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
		_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
		_removedItems pushBack _x;
		player removeWeapon _x;
	};
} forEach (weapons player);

//Primary weapon attachments:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
		_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
		_removedItems pushBack _x;
		player removePrimaryWeaponItem _x;
	};
} forEach (primaryWeaponItems player);

//Secondary weapon attachments:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
		_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
		_removedItems pushBack _x;
		player removeSecondaryWeaponItem _x;
	};
} forEach (secondaryWeaponItems player);

//Handgun weapon attachments:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
		_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
		_removedItems pushBack _x;
		player removeHandgunItem _x;
	};
} forEach (handgunItems player);

//Headgear:
private _headgear = headgear player;
if ((_headgear != "") && (!(_headgear in whitelistArray) || (_headgear in blacklistArray))) then {
	_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _headgear >> "displayName")) + "<br/>";
	_removedItems pushBack _headgear;
	removeHeadgear player;
};

//Uniform:
private _uniform = uniform player;
if ((_uniform != "") && (!(_uniform in whitelistArray) || (_uniform in blacklistArray))) then {
	_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _uniform >> "displayName")) + "<br/>";
	_removedItems pushBack _uniform;
	removeUniform player;
};

//Vest:
private _vest = vest player;
if ((_vest != "") && (!(_vest in whitelistArray) || (_vest in blacklistArray))) then {
	_removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _vest >> "displayName")) + "<br/>";
	_removedItems pushBack _vest;
	removeVest player;
};

//Backpack:
private _backpack = backpack player;
if ((_backpack != "") && (!(_backpack in whitelistArray) || (_backpack in blacklistArray))) then {
    if (_x find "TFAR" == -1) then {
        _removedString = _removedString + (getText (configFile >> "CfgVehicles" >> _backpack >> "displayName")) + "<br/>";
        _removedItems pushBack _backpack;
        removeBackpack player;
	};
};

//Assigned items:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
	    if (_x find "TFAR" == -1) then {
	        _removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
            _removedItems pushBack _x;
            player unassignItem _x;
            player removeItem _x;
	    };
	};
	if ((_x == "B_UavTerminal") && ((roleDescription player find "UAV") == -1)) then {
	    player unassignItem _x;
        player removeItem _x;
	};
} forEach (assignedItems player);

//Items in inventory:
{
	if ((_x != "") && (!(_x in whitelistArray) || (_x in blacklistArray))) then {
	    if (_x find "TFAR" == -1) then {
            _removedString = _removedString + (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) + "<br/>";
            _removedItems pushBack _x;
            player removeItem _x;
		};
	};
	if ((_x == "B_UavTerminal") && ((roleDescription player find "UAV") == -1)) then {
        player removeItem _x;
    };
} forEach (items player);

//Tell the player what happened:
if (count _removedItems > 0) then {
	if (!isNull (uiNamespace getVariable "RSCDisplayArsenal")) then { //Player is currently in the Virtual Arsenal where hints are not shown.
		systemChat "Some equipment you are not allowed to use has been removed.";
	};
	_removedString = _removedString + "<br/>Play a different role if you want to use it.";
	hint parseText format ['%1', _removedString];
};