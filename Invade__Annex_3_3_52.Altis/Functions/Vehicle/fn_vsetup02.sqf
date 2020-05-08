/*
@filename: fn_vSetup02.sqf
Author:     ???
	
Last modified:  13/5/19 by stanhope
modified:  code cleanup

Description:    Apply code to vehicle
	            vSetup02 deals with code that is already applied where it should be.
*/

//============================================= CONFIG
private ["_camo","_innerpylon","_AMRAAMcount","_outerpylon","_wingtipAA","_middlepylon","_rocketpod","_missilepod","_bombs"];

private _vehicle = _this select 0;
if (!alive _vehicle) exitWith {};
private _vehicleType = typeOf _vehicle;

[_vehicle] spawn AW_fnc_vehicleInventory;
_vehicle lock 0;

//=============vehicle specific
switch (_vehicleType) do {
    case "B_Plane_CAS_01_dynamicLoadout_F": { //wipeout
        //an A-164 Wipeout (CAS)
    	_vehicle removeMagazine "120Rnd_CMFlare_Chaff_Magazine";
    	_vehicle addMagazine "60Rnd_CMFlare_Chaff_Magazine";
    	{_vehicle removeWeapon _x} forEach ["Missile_AA_04_Plane_CAS_01_F","Missile_AGM_02_Plane_CAS_01_F","Rocket_04_HE_Plane_CAS_01_F","Rocket_04_AP_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F"];

    	//====select random loadout=====
    	_rocketpod = selectRandom ["PylonRack_12Rnd_missiles","PylonRack_12Rnd_PG_missiles","Shrieker"];
    	if (_rocketpod == "PylonRack_12Rnd_PG_missiles") then {
    	    _missilepod = selectRandom ["PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_1Rnd_LG_scalpel"];
    	} else {
    	    _missilepod = selectRandom ["PylonRack_3Rnd_Missile_AGM_02_F","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_LG_scalpel"];
    	};
    	_bombs = selectRandom ["PylonMissile_1Rnd_Bomb_04_F","PylonMissile_1Rnd_Mk82_F","2x2"];

    	//=========defensive AA=========
    	_vehicle setPylonLoadOut [1, "PylonRack_1Rnd_Missile_AA_04_F",false,[]];
    	_vehicle setPylonLoadOut [10, "PylonRack_1Rnd_Missile_AA_04_F",false,[]];
    	//=========rocket pod===========
    	if (_rocketpod == "Shrieker") then {
    	_vehicle setPylonLoadOut [2, "PylonRack_7Rnd_Rocket_04_HE_F",false,[]];
    	_vehicle setPylonLoadOut [9, "PylonRack_7Rnd_Rocket_04_AP_F",false,[]];
    	}else{
    	_vehicle setPylonLoadOut [2, _rocketpod,false,[]];
    	_vehicle setPylonLoadOut [9, _rocketpod,false,[]];
    	};
    	//==========missiles==========
    	_vehicle setPylonLoadOut [3, _missilepod,false,[]];
    	_vehicle setPylonLoadOut [8, _missilepod,false,[]];
    	//==========bombs==============
    	if (_bombs == "2x2") then {
            _vehicle setPylonLoadOut [4, "PylonMissile_1Rnd_Mk82_F",false,[]];
            _vehicle setPylonLoadOut [5, "PylonMissile_1Rnd_Bomb_04_F",false,[]];
            _vehicle setPylonLoadOut [6, "PylonMissile_1Rnd_Bomb_04_F",false,[]];
            _vehicle setPylonLoadOut [7, "PylonMissile_1Rnd_Mk82_F",false,[]];
    	}else{
    	    for "_i" from 4 to 7 do{ _vehicle setPylonLoadOut [_i, _bombs,false,[]]; };
    	};
    };

    case "B_Plane_Fighter_01_Stealth_F": { //an F/A-181 Black Wasp II (stealth)
        private _waspcamo = selectRandom [
    	    ['a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_01_co.paa','a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_02_co.paa'],
    	    ['a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_01_camo_co.paa','a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_02_camo_co.paa']
    	];
    	_vehicle setObjectTextureGlobal[0, (_waspcamo select 0)];
    	_vehicle setObjectTextureGlobal[1, (_waspcamo select 1)];
    	_vehicle removeMagazine "240Rnd_CMFlare_Chaff_Magazine";
    	_vehicle addMagazine "120Rnd_CMFlare_Chaff_Magazine";
    	_vehicle removeWeapon "weapon_GBU12Launcher";

    	//========outer AA bays=========
    	_vehicle setPylonLoadOut [5, "PylonRack_Missile_BIM9X_x1",false,[]];
    	_vehicle setPylonLoadOut [6, "PylonRack_Missile_BIM9X_x1",false,[]];

    	//=====outer and middle inner bay
        private _AMRAAMcount = selectRandom ["2","2","2","2","2","2","2","4","4","6"];

    	switch (_AMRAAMcount) do {
    		case "2":{
    			_vehicle setPylonLoadOut [7, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];
    			_vehicle setPylonLoadOut [8, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];
    			for "_i" from 9 to 12 do{_vehicle setPylonLoadOut [_i, "",false,[]];};
    		};
    		case "4":{
    			for "_i" from 7 to 10 do{_vehicle setPylonLoadOut [_i, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];};
    			_vehicle setPylonLoadOut [11, "",false,[]];
    			_vehicle setPylonLoadOut [12, "",false,[]];
    		};
    		case "6":{
    			for "_i" from 7 to 12 do{_vehicle setPylonLoadOut [_i, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];};
    		};
    	};

    	_vehicle setVehicleReportRemoteTargets true;
    };

    case "B_Plane_Fighter_01_F": { //an F/A-181 Black Wasp II
        private _waspcamo = selectRandom [
            ['a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_01_co.paa','a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_02_co.paa'],
            ['a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_01_camo_co.paa','a3\air_f_jets\plane_fighter_01\data\Fighter_01_fuselage_02_camo_co.paa']
        ];
        _vehicle setObjectTextureGlobal[0, (_waspcamo select 0)];
        _vehicle setObjectTextureGlobal[1, (_waspcamo select 1)];
        _vehicle removeMagazine "240Rnd_CMFlare_Chaff_Magazine";
        _vehicle addMagazine "120Rnd_CMFlare_Chaff_Magazine";
        _vehicle removeWeapon "weapon_AGM_65Launcher";
        //====select random loadout=====
        private _outerpylon = selectRandom ["PylonRack_Missile_AGM_02_x1","PylonMissile_Bomb_GBU12_x1","PylonRack_Missile_BIM9X_x1","PylonRack_Missile_AMRAAM_D_x1","PylonRack_Missile_AMRAAM_D_x2","PylonRack_Missile_BIM9X_x2"];
        switch (_outerpylon) do {
            case "PylonMissile_Bomb_GBU12_x1":{
                _AMRAAMcount = selectRandom ["2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x2","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_AMRAAM_D_x2"];
            };
            case "PylonRack_Missile_AGM_02_x1":{
                _AMRAAMcount = selectRandom ["2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x2","PylonRack_Missile_AGM_02_x1","PylonRack_Bomb_GBU12_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_AMRAAM_D_x1"];
            };
            case "PylonRack_Missile_BIM9X_x1":{
                _AMRAAMcount = selectRandom ["2","2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x2","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Bomb_GBU12_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1"];
            };
            case "PylonRack_Missile_BIM9X_x2":{
                _AMRAAMcount = selectRandom ["2","2","2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x2","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Bomb_GBU12_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1"];
            };
            case "PylonRack_Missile_AMRAAM_D_x1":{
                _AMRAAMcount = selectRandom ["2","2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x2","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Bomb_GBU12_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1"];
            };
            case "PylonRack_Missile_AMRAAM_D_x2":{
                _AMRAAMcount = selectRandom ["2","2","2","4"];
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x2","PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x1","PylonRack_Bomb_GBU12_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1"];
            };
            default {
                _innerpylon = selectRandom ["PylonRack_Missile_AGM_02_x1","PylonRack_Missile_AGM_02_x2","PylonMissile_Bomb_GBU12_x1","PylonMissile_Bomb_GBU12_x1","PylonRack_Missile_BIM9X_x1","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_AMRAAM_D_x1","PylonRack_Missile_AMRAAM_D_x2"];
            };
        };
        //======outer pylons=========
        _vehicle setPylonLoadOut [1, _outerpylon,false,[]];
        _vehicle setPylonLoadOut [2, _outerpylon,false,[]];
        //========inner pylons=========
        _vehicle setPylonLoadOut [3, _innerpylon,false,[]];
        _vehicle setPylonLoadOut [4, _innerpylon,false,[]];
        //========outer AA bays=========
        _vehicle setPylonLoadOut [5, "PylonRack_Missile_BIM9X_x1",false,[]];
        _vehicle setPylonLoadOut [6, "PylonRack_Missile_BIM9X_x1",false,[]];
        //=====outer and middle inner bay
        if (_AMRAAMcount == "2")then {
            _vehicle setPylonLoadOut [7, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];
            _vehicle setPylonLoadOut [8, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];
            _vehicle setPylonLoadOut [9, "",false,[]];
            _vehicle setPylonLoadOut [10, "",false,[]];
        };
        if (_AMRAAMcount == "4")then {
            for "_i" from 7 to 10 do{_vehicle setPylonLoadOut [_i, "PylonMissile_Missile_AMRAAM_D_INT_x1",false,[]];};
        };
        //=====inner pylons inner bay====
        _vehicle setPylonLoadOut [11, "PylonMissile_Bomb_GBU12_x1",false,[]];
        _vehicle setPylonLoadOut [12, "PylonMissile_Bomb_GBU12_x1",false,[]];

        _vehicle setVehicleReportRemoteTargets true;
    };

    case "I_Plane_Fighter_04_F": { //an A-149 Gryphon
        _vehicle setObjectTextureGlobal[0, 'a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_01_co.paa'];
        _vehicle setObjectTextureGlobal[1, 'a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_02_co.paa'];
        _vehicle removeMagazine "240Rnd_CMFlare_Chaff_Magazine";
        _vehicle addMagazine "120Rnd_CMFlare_Chaff_Magazine";
        {_vehicle removeWeapon _x} forEach ["weapon_AGM_65Launcher","weapon_AMRAAMLauncher","weapon_GBU12Launcher","weapon_BIM9xLauncher"];
        //=======random loadout=========
        private _innerpylon = selectRandom ["PylonRack_Missile_BIM9X_x2","PylonRack_Missile_AMRAAM_C_x2"];
        if (_innerpylon == "PylonRack_Missile_BIM9X_x2")then {
            _wingtipAA = selectRandom ["PylonMissile_Missile_BIM9X_x1","PylonRack_Missile_AMRAAM_C_x1"];
            _middlepylon = selectRandom ["PylonRack_Missile_AMRAAM_C_x1"];
        };
        if (_innerpylon == "PylonRack_Missile_AMRAAM_C_x2")then {
            _wingtipAA = selectRandom ["PylonMissile_Missile_BIM9X_x1"];
            _middlepylon = selectRandom ["PylonRack_Missile_AMRAAM_C_x1","PylonRack_Missile_BIM9X_x1"];
        };
        //=========wingtips===========
        _vehicle setPylonLoadOut [1, _wingtipAA,false,[]];
        _vehicle setPylonLoadOut [2, _wingtipAA,false,[]];
        //======middle pylons=========
        _vehicle setPylonLoadOut [3, _middlepylon,false,[]];
        _vehicle setPylonLoadOut [4, _middlepylon,false,[]];
        //======inner pylons===========
        _vehicle setPylonLoadOut [5, _innerpylon,false,[]];
        _vehicle setPylonLoadOut [6, _innerpylon,false,[]];

        _vehicle setVehicleReportRemoteTargets true;
    };
    case "I_Plane_Fighter_03_dynamicLoadout_F": {  //a buzzard
    	{_vehicle removeWeapon _x} forEach ["missiles_SCALPEL","missiles_ASRAAM","GBU12BombLauncher_Plane_Fighter_03_F","GBU12BombLauncher","weapon_GBU12Launcher"];
    	//=======random loadout=========
    	_maingun = "PylonWeapon_300Rnd_20mm_shells";
    	_wingtipAA = selectRandom ["PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_Missile_AA_04_F"];
    	_middlepylon = selectRandom ["PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_Missile_AA_04_F","PylonRack_1Rnd_GAA_missiles"];
    	_innerpylon = "PylonRack_1Rnd_GAA_missiles";
    	//=========wingtips===========
    	_vehicle setPylonLoadOut [1, _wingtipAA,false,[]];
    	_vehicle setPylonLoadOut [7, _wingtipAA,false,[]];
    	//======middle pylons=========
    	_vehicle setPylonLoadOut [2, _middlepylon,false,[]];
    	_vehicle setPylonLoadOut [6, _middlepylon,false,[]];
    	//======inner pylons===========
    	_vehicle setPylonLoadOut [3, _innerpylon,false,[]];
    	_vehicle setPylonLoadOut [5, _innerpylon,false,[]];
    	//==========main gun==========
    	_vehicle setPylonLoadOut [1, _maingun,false,[]];
    };

    case "O_Plane_Fighter_02_F"; //shikra
    case "O_Plane_Fighter_02_Stealth_F": {
        [
            _vehicle,
            ["CamoGreyHex",1],
            true
        ] call BIS_fnc_initVehicle;
    };

     case "O_T_VTOL_02_infantry_dynamicLoadout_F": { //an Y-32 Xi'an (Infantry Transport, unarmed)
        for "_i" from 0 to 5 do {
           _vehicle setPylonLoadOut [_i, "",false,[]];
        };
        _vehicle removeWeapon ("gatling_30mm_VTOL_02");
        _vehicle removeWeapon ("missiles_SCALPEL");
        _vehicle removeWeapon ("rockets_Skyfire");

        _vehicle setVehicleReportRemoteTargets true;
        {
           _vehicle setObjectTextureGlobal [_forEachIndex, _x];
        } forEach ["\A3\Air_F_Exp\VTOL_02\Data\VTOL_02_EXT01_CO.paa","\A3\Air_F_Exp\VTOL_02\Data\VTOL_02_EXT02_CO.paa","\A3\Air_F_Exp\VTOL_02\Data\VTOL_02_EXT03_L_CO.paa","\A3\Air_F_Exp\VTOL_02\Data\VTOL_02_EXT03_R_CO.paa"];
    };

    case "B_Heli_Light_01_F";
    case "B_Heli_Light_01_armed_F": { //humming
        private _camo = selectRandom [
            'A3\Air_F\Heli_Light_01\Data\Heli_Light_01_ext_BLUFOR_CO.paa',
            'A3\Air_F\Heli_Light_01\Data\Heli_Light_01_ext_ION_CO.paa',
            'A3\Air_F\Heli_Light_01\Data\skins\Heli_Light_01_ext_wasp_co.paa',
            'A3\Air_F\Heli_Light_01\Data\skins\heli_light_01_ext_digital_co.paa',
            'A3\Air_F\Heli_Light_01\Data\skins\heli_light_01_ext_digital_co.paa'
        ];
        _vehicle setObjectTextureGlobal[0, _camo];
    };

    case "B_Heli_Transport_03_unarmed_F";
    case "B_Heli_Transport_03_black_F";
    case "B_Heli_Transport_03_unarmed_green_F";
    case "B_Heli_Transport_03_F": { //huron
    	private _camo = selectRandom ["black","green"];
    	if (_camo == "green") then {
            _vehicle setObjectTextureGlobal [0, "A3\Air_f_heli\Heli_Transport_03\data\Heli_Transport_03_ext01_CO.paa"];
            _vehicle setObjectTextureGlobal [1, "A3\Air_f_heli\Heli_Transport_03\data\Heli_Transport_03_ext02_CO.paa"];
    	} else  {
            _vehicle setObjectTextureGlobal [0, "A3\Air_f_heli\Heli_Transport_03\data\Heli_Transport_03_ext01_black_CO.paa"];
            _vehicle setObjectTextureGlobal [1, "A3\Air_f_heli\Heli_Transport_03\data\Heli_Transport_03_ext02_black_CO.paa"];
    	};
    };
    case "I_Heli_light_03_F": { //hellcat
        _vehicle setObjectTextureGlobal [0, "\a3\air_F_EPB\Heli_Light_03\Data\Heli_Light_03_base_CO.paa"];
    };
    case "O_Heli_Light_02_F";
    case "O_Heli_Light_02_unarmed_F": { //orca
        _vehicle setObjectTextureGlobal [0, "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_co.paa"];
    };
    case "O_Heli_Attack_02_dynamicLoadout_F";
    case "O_Heli_Attack_02_dynamicLoadout_black_F": { //kajman
        _vehicle removeWeapon "rockets_Skyfire";
        _vehicle setPylonLoadOut [1, "PylonRack_3Rnd_LG_scalpel",false,[0]];
        _vehicle setPylonLoadOut [2, "PylonRack_20Rnd_Rocket_03_AP_F",false,[]];
        _vehicle setPylonLoadOut [3, "PylonRack_20Rnd_Rocket_03_HE_F",false,[]];
        _vehicle setPylonLoadOut [4, "PylonRack_3Rnd_LG_scalpel",false,[0]];
    };
    case "B_Heli_Transport_01_camo_F";
    case "B_Heli_Transport_01_F": { //ghost
        [_vehicle, ["LMG_Minigun_Transport", [1]]] remoteExecCall ["removeWeaponTurret", 0, false];
        [_vehicle, ["LMG_Minigun_Transport2", [2]]] remoteExecCall ["removeWeaponTurret", 0, false];
        _vehicle setVariable ['turretStatus', false, true];
        [_vehicle, ["Enable turrets", {_this spawn turretFunction}, [], -20, false, true, "", "(_this == (driver _target))", -1, false]] remoteExecCall ["addAction", 0, true];

        private _camo = selectRandom ["black","green", "sand", "tropic"];
        switch (_camo) do {
            case "black": {
                _vehicle setObjectTextureGlobal [0, "A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_CO.paa"];
                _vehicle setObjectTextureGlobal [1, "A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext02_CO.paa"];
            };
            case "green": {
                _vehicle setObjectTextureGlobal [0, "A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext01_BLUFOR_CO.paa"];
                _vehicle setObjectTextureGlobal [1, "A3\Air_F_Beta\Heli_Transport_01\Data\Heli_Transport_01_ext02_BLUFOR_CO.paa"];
            };
            case "sand": {
                _vehicle setObjectTextureGlobal [0, "\A3\Air_F_Exp\Heli_Transport_01\Data\Heli_Transport_01_ext01_sand_CO.paa"];
                _vehicle setObjectTextureGlobal [1, "\A3\Air_F_Exp\Heli_Transport_01\Data\Heli_Transport_01_ext02_sand_CO.paa"];
            };
            case "tropic": {
                _vehicle setObjectTextureGlobal [0, "A3\Air_F_Exp\Heli_Transport_01\Data\Heli_Transport_01_ext01_tropic_CO.paa"];
                _vehicle setObjectTextureGlobal [1, "\A3\Air_F_Exp\Heli_Transport_01\Data\Heli_Transport_01_ext02_tropic_CO.paa"];
            };
        }
    };

    case "I_APC_Wheeled_03_cannon_F": { //gorgon
        _vehicle setObjectTextureGlobal [0, "A3\Armor_F_Gamma\APC_Wheeled_03\Data\apc_wheeled_03_ext_co.paa"];
        _vehicle setObjectTextureGlobal [1, "A3\Armor_F_Gamma\APC_Wheeled_03\Data\apc_wheeled_03_ext2_co.paa"];
        _vehicle setObjectTextureGlobal [2, "A3\Armor_F_Gamma\APC_Wheeled_03\Data\rcws30_co.paa"];
        _vehicle setObjectTextureGlobal [3, "A3\Armor_F_Gamma\APC_Wheeled_03\Data\apc_wheeled_03_ext_alpha_co.paa"];
    };
    case "I_MRAP_03_F";
    case "I_MRAP_03_hmg_F";
    case "I_MRAP_03_gmg_F": { //strider
        _vehicle setObjectTextureGlobal [0,'\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa'];
        _vehicle setObjectTextureGlobal [1,'\A3\data_f\vehicles\turret_co.paa'];
    };
    case "O_T_LSV_02_armed_F": { //qilin
        _vehicle setObjectTextureGlobal[0, '\A3\soft_f_exp\LSV_02\data\CSAT_LSV_01_black_CO.paa'];
        _vehicle setObjectTextureGlobal[1, '\A3\soft_f_exp\LSV_02\data\CSAT_LSV_02_black_CO.paa'];
        _vehicle setObjectTextureGlobal[2, '\A3\soft_f_exp\LSV_02\data\CSAT_LSV_03_black_CO.paa'];
    };
    case "C_Van_02_medevac_F": { //van => ambulance
        [
        	_vehicle,
        	["CivAmbulance",1],
        	["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",0,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",0,"rearsteps_hide",1,"side_protective_frame_hide",1,"front_protective_frame_hide",1,"beacon_front_hide",1,"beacon_rear_hide",1]
        ] call BIS_fnc_initVehicle;
    };
    case "B_LSV_01_armed_F":{
        private _doors = round(random 1);
        private _camo = selectRandom ["Black", "Olive", "Sand"];
        [
        	_vehicle,
        	[_camo,1],
        	["HideDoor1",_doors,"HideDoor2",_doors,"HideDoor3",_doors,"HideDoor4",_doors]
        ] call BIS_fnc_initVehicle;
    };
};
//==========general stuff

[   _vehicle,
    ["<t color='#1eff65'>Refuel vehicle</t>",{
        params ["_veh"];
        if (fuel _veh < 0.2) then {
            [_veh, 0.21] remoteExec ["setFuel", owner _veh];
            _veh vehicleChat "Engineer refuelled your vehicle";
        }else {
            _veh vehicleChat "Engineer tried to refuel but fuel is not required";
        };
    },"",0,true,true,"","(player isKindOf 'B_soldier_repair_F'|| player isKindOf 'B_engineer_F') &&(fuel _target <0.2) ",5]
] remoteExecCall ["addAction", 0, true]; //fuel function

//========Other general stuff for some vehicles
if (_vehicle isKindOf "Helicopter") then { //killed message
    _vehicle addEventHandler ["killed",{
        [] spawn {
            sleep 3;
            private _artyMessageArray = ['mp_groundsupport_65_chopperdown_BHQ_0','mp_groundsupport_65_chopperdown_BHQ_1','mp_groundsupport_65_chopperdown_BHQ_2'];
            private _artyMessage = selectRandom _artyMessageArray;
            [[west, 'Base'],_artyMessage] remoteExec ['sideRadio',0,false];
        };
    }];
} else {
    [   _vehicle,
        ["<t color='#1eff65'>Flip vehicle</t>", {
        _targetVehicle = _this select 0;
        //_targetVehicle setPos (getPos _targetVehicle vectorAdd [0,0,1]);
        _targetVehicle setVectorUp surfaceNormal position _targetVehicle;
        _targetVehicle setPosATL [(getPosATL _targetVehicle) select 0,(getPosATL _targetVehicle) select 1,0.1];
        }, nil, -20, true, true, "", "
        ((speed _target) < 1) && ( ((count (_target nearEntities ['Man', 15])) > 3) ||  ((count (_target nearEntities ['B_APC_Tracked_01_CRV_F', 15])) > 0) ) && ((count (crew _target)) < 2)", 7]
    ] remoteExecCall ["addAction", 0, true]; //flip function
};
if (_vehicle isKindOf "UAV")then { //UAV crew
    {deleteVehicle _x;} forEach (crew _vehicle);
    [_vehicle] spawn {
        _vehicle = _this select 0;
        sleep 2;
        createVehicleCrew _vehicle;
        {_x addCuratorEditableObjects [(crew _vehicle),true];} count allCurators;
    };

    _vehicle setVehicleReportRemoteTargets true;
    _vehicle setVehicleReportOwnPosition true;
};
if ( _vehicle isKindOf "Air" ) then { //remove certain weapons from all air vehicles:
	{
		_weaponlist = weapons _vehicle;
		if (_x in _weaponlist) then {
			_vehicle removeWeapon _x
		};
	} forEach ["Laserdesignator_pilotCamera","Laserdesignator_mounted"];
}; 

//Add a nato flag for non-nato ground vehicles
if ( _vehicle isKindOf "LandVehicle" && ((_vehicleType find "B_" == -1) || (_vehicleType find "B_G_" != -1))) then {
	_vehicle forceFlagTexture "\A3\Data_F\Flags\Flag_nato_CO.paa";
};

_vehicle setVehicleReceiveRemoteTargets true;

//=== Zues
{_x addCuratorEditableObjects [[_vehicle],true];} count allCurators;