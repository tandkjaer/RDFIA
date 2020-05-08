//Items, optics and accessories all slots have access to.
generalItems = [
    //Optics:
    "optic_Aco", "optic_ACO_grn", "optic_ACO_grn_smg", "optic_Aco_smg", "optic_Arco", "optic_Arco_blk_F", "optic_Arco_ghex_F", "optic_ERCO_blk_F",
    "optic_ERCO_khk_F", "optic_ERCO_snd_F", "optic_Hamr", "optic_Hamr_khk_F", "optic_Holosight", "optic_Holosight_blk_F", "optic_Holosight_khk_F",
    "optic_Holosight_smg", "optic_Holosight_smg_blk_F", "optic_Holosight_smg_khk_F", "optic_MRCO", "optic_NVS", "optic_Arco_arid_F",
    "optic_Arco_lush_F", "optic_Arco_AK_arid_F", "optic_Arco_AK_blk_F", "optic_Arco_AK_lush_F", "optic_Holosight_arid_F", "optic_Holosight_lush_F",
    "optic_MRD_black", "optic_ico_01_f", "optic_ico_01_black_f", "optic_ico_01_camo_f", "optic_ico_01_sand_f",

    //Accessories:
    "acc_flashlight", "acc_flashlight_smg_01", "acc_pointer_IR",
    //Suppressors:
    "muzzle_snds_338_black", "muzzle_snds_338_green", "muzzle_snds_338_sand", "muzzle_snds_58_blk_F", "muzzle_snds_58_ghex_F", "muzzle_snds_58_hex_F",
    "muzzle_snds_65_TI_blk_F", "muzzle_snds_65_TI_ghex_F", "muzzle_snds_65_TI_hex_F", "muzzle_snds_93mmg", "muzzle_snds_93mmg_tan", "muzzle_snds_acp",
    "muzzle_snds_B", "muzzle_snds_B_khk_F", "muzzle_snds_B_snd_F", "muzzle_snds_H", "muzzle_snds_H_khk_F", "muzzle_snds_H_snd_F", "muzzle_snds_H_MG",
    "muzzle_snds_H_MG_blk_F", "muzzle_snds_H_MG_khk_F", "muzzle_snds_L", "muzzle_snds_M", "muzzle_snds_m_khk_F", "muzzle_snds_m_snd_F", "muzzle_snds_570",
    "muzzle_snds_B_lush_F", "muzzle_snds_B_arid_F",
    //Bipods:
    "bipod_01_F_blk", "bipod_01_F_khk", "bipod_01_F_mtp", "bipod_01_F_snd", "bipod_02_F_blk", "bipod_02_F_hex", "bipod_02_F_tan", "bipod_03_F_blk", "bipod_03_F_oli", "bipod_02_F_lush", "bipod_02_F_arid",
    //Handgun Optics:
    "optic_MRD", "optic_Yorris",
    //Handgun Accessories:
    "acc_flashlight_pistol",
    //Night Vision Goggles:
    "NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR", "NVGoggles_tna_F",
    //Binoculars:
    "Binocular", "Rangefinder", "Laserdesignator", "Laserdesignator_01_khk_F", "Laserdesignator_03",
    //Map, GPS, Radio, Compass, Watch:
    "ItemMap", "ItemGPS", "ItemCompass", "ItemWatch",
    //Other:
    "FirstAidKit", "Medikit", "ToolKit", "MineDetector"
];

if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    generalItems = generalItems + ["TFAR_rf7800str", "TFAR_anprc152", "TFAR_microdagr"];

    commandRadios = [
    ];
    radioBackPack = [
        "TFAR_rt1523g", "TFAR_rt1523g_big", "TFAR_rt1523g_black", "TFAR_rt1523g_fabric", "TFAR_rt1523g_green", "TFAR_rt1523g_rhs", "TFAR_rt1523g_sage", "TFAR_anarc210"
    ];
} else {
    generalItems = generalItems + ["ItemRadio"];
};

//Magazines all slots have access to.
generalMagazines = [
    "10Rnd_127x54_Mag", "10Rnd_338_Mag", "10Rnd_50BW_Mag_F", "10Rnd_762x51_Mag", "10Rnd_762x54_Mag", "10Rnd_93x64_DMR_05_Mag", "10Rnd_9x21_Mag", "11Rnd_45ACP_Mag",
    "130Rnd_338_Mag", "150Rnd_762x54_Box", "150Rnd_762x54_Box_Tracer", "150Rnd_93x64_Mag", "16Rnd_9x21_green_Mag", "200Rnd_556x45_Box_F", "200Rnd_556x45_Box_Red_F",
    "200Rnd_556x45_Box_Tracer_F", "200Rnd_556x45_Box_Tracer_Red_F", "200Rnd_65x39_cased_Box", "200Rnd_65x39_cased_Box_Tracer", "20Rnd_556x45_UW_mag",
    "20Rnd_762x51_Mag", "30Rnd_45ACP_Mag_SMG_01", "30Rnd_45ACP_Mag_SMG_01_Tracer_Green", "30Rnd_45ACP_Mag_SMG_01_Tracer_Red", "30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow",
    "30Rnd_65x39_caseless_green", "30Rnd_65x39_caseless_green_mag_Tracer", "30Rnd_9x21_Mag_SMG_02_Tracer_Green", "30Rnd_9x21_Mag_SMG_02_Tracer_Yellow",
    "5Rnd_127x108_APDS_Mag", "5Rnd_127x108_Mag", "6Rnd_45ACP_Cylinder", "6Rnd_GreenSignal_F", "6Rnd_RedSignal_F", "7Rnd_408_Mag", "9Rnd_45ACP_Mag", "50Rnd_570x28_SMG_03",
    "30Rnd_545x39_Mag_F", "30Rnd_545x39_Mag_Green_F", "30Rnd_545x39_Mag_Tracer_F", "30Rnd_545x39_Mag_Tracer_Green_F", "30Rnd_65x39_caseless_black_mag",
    "30Rnd_65x39_caseless_mag", "30Rnd_65x39_caseless_khaki_mag", "30Rnd_65x39_caseless_mag_Tracer", "30Rnd_65x39_caseless_khaki_mag_Tracer",
    "30Rnd_65x39_caseless_black_mag_Tracer", "100Rnd_65x39_caseless_mag", "100Rnd_65x39_caseless_khaki_mag", "100Rnd_65x39_caseless_black_mag",
    "100Rnd_65x39_caseless_mag_Tracer", "100Rnd_65x39_caseless_khaki_mag_tracer", "100Rnd_65x39_caseless_black_mag_tracer", "30Rnd_762x39_AK12_Mag_F",
    "30Rnd_762x39_Mag_F", "30Rnd_762x39_Mag_Green_F", "30Rnd_762x39_Mag_Tracer_F", "30Rnd_762x39_Mag_Tracer_Green_F", "30Rnd_762x39_AK12_Mag_Tracer_F",
    "100Rnd_580x42_Mag_F", "100Rnd_580x42_Mag_Tracer_F", "30Rnd_580x42_Mag_F", "30Rnd_580x42_Mag_Tracer_F", "100Rnd_580x42_hex_Mag_F", "100Rnd_580x42_hex_Mag_Tracer_F",
    "100Rnd_580x42_ghex_Mag_F", "100Rnd_580x42_ghex_Mag_Tracer_F", "20Rnd_650x39_Cased_Mag_F", "30Rnd_556x45_Stanag", "30Rnd_556x45_Stanag_Tracer_Red",
    "30Rnd_556x45_Stanag_Tracer_Green", "30Rnd_556x45_Stanag_Tracer_Yellow", "30Rnd_556x45_Stanag_red", "30Rnd_556x45_Stanag_green", "30Rnd_556x45_Stanag_Sand",
    "30Rnd_556x45_Stanag_Sand_green", "30Rnd_556x45_Stanag_Sand_red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Green",
    "30Rnd_556x45_Stanag_Sand_Tracer_Yellow", "30Rnd_9x21_Mag", "30Rnd_9x21_Red_Mag", "30Rnd_9x21_Yellow_Mag", "30Rnd_9x21_Green_Mag", "16Rnd_9x21_Mag",
    "16Rnd_9x21_red_Mag", "16Rnd_9x21_green_Mag", "16Rnd_9x21_yellow_Mag", "30Rnd_9x21_Mag_SMG_02", "30Rnd_9x21_Mag_SMG_02_Tracer_Red", "30Rnd_556x45_Stanag_Sand",
    "30Rnd_556x45_Stanag_Sand_green", "30Rnd_556x45_Stanag_Sand_red", "30Rnd_556x45_Stanag_Sand_Tracer_Red", "30Rnd_556x45_Stanag_Sand_Tracer_Green",
    "30Rnd_556x45_Stanag_Sand_Tracer_Yellow", "30Rnd_556x45_Stanag", "150Rnd_556x45_Drum_Mag_F", "150Rnd_556x45_Drum_Mag_Tracer_F", "150Rnd_556x45_Drum_Sand_Mag_F",
    "150Rnd_556x45_Drum_Sand_Mag_Tracer_F", "150Rnd_556x45_Drum_Green_Mag_F", "150Rnd_556x45_Drum_Green_Mag_Tracer_F", "30Rnd_556x45_Stanag_green", "30Rnd_556x45_Stanag_red",
    "30Rnd_556x45_Stanag_Tracer_Red", "30Rnd_556x45_Stanag_Tracer_Green", "30Rnd_556x45_Stanag_Tracer_Yellow", "30rnd_762x39_AK12_Arid_Mag_F",
    "30rnd_762x39_AK12_Arid_Mag_Tracer_F", "30Rnd_762x39_Mag_F", "30Rnd_762x39_Mag_Green_F", "30Rnd_762x39_Mag_Tracer_F", "30Rnd_762x39_Mag_Tracer_Green_F",
    "30Rnd_762x39_AK12_Mag_F", "30Rnd_762x39_AK12_Mag_Tracer_F", "75Rnd_762x39_Mag_F", "75Rnd_762x39_Mag_Tracer_F", "30rnd_762x39_AK12_Lush_Mag_F",
    "30rnd_762x39_AK12_Lush_Mag_Tracer_F", "75rnd_762x39_AK12_Mag_F", "75rnd_762x39_AK12_Mag_Tracer_F", "75rnd_762x39_AK12_Lush_Mag_F", "75rnd_762x39_AK12_Lush_Mag_Tracer_F",
    "75rnd_762x39_AK12_Arid_Mag_F", "75rnd_762x39_AK12_Arid_Mag_Tracer_F", "2Rnd_12Gauge_Pellets", "2Rnd_12Gauge_Slug", "10Rnd_Mk14_762x51_Mag",
    "20Rnd_762x51_Mag", "200Rnd_65x39_cased_Box", "200Rnd_65x39_cased_Box_Tracer", "200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red",
    "30Rnd_65x39_caseless_msbs_mag_Tracer", "30Rnd_65x39_caseless_msbs_mag", "6Rnd_12Gauge_Pellets", "6Rnd_12Gauge_Slug",

    //Underbarrel Grenade Launcher Rounds:
    "1Rnd_HE_Grenade_shell", "1Rnd_Smoke_Grenade_shell", "1Rnd_SmokeBlue_Grenade_shell", "1Rnd_SmokeGreen_Grenade_shell", "1Rnd_SmokeOrange_Grenade_shell",
    "1Rnd_SmokePurple_Grenade_shell", "1Rnd_SmokeRed_Grenade_shell", "1Rnd_SmokeYellow_Grenade_shell", "3Rnd_HE_Grenade_shell", "3Rnd_Smoke_Grenade_shell",
    "3Rnd_SmokeBlue_Grenade_shell", "3Rnd_SmokeGreen_Grenade_shell", "3Rnd_SmokeOrange_Grenade_shell", "3Rnd_SmokePurple_Grenade_shell", "3Rnd_SmokeRed_Grenade_shell",
    "3Rnd_SmokeYellow_Grenade_shell", "3Rnd_UGL_FlareCIR_F", "3Rnd_UGL_FlareGreen_F", "3Rnd_UGL_FlareRed_F", "3Rnd_UGL_FlareWhite_F", "3Rnd_UGL_FlareYellow_F",
    "UGL_FlareCIR_F", "UGL_FlareGreen_F", "UGL_FlareRed_F", "UGL_FlareWhite_F", "UGL_FlareYellow_F",

    //Mines and Explosives:
    "DemoCharge_Remote_Mag",

    //Grenades:
    "B_IR_Grenade", "Chemlight_blue", "Chemlight_green", "Chemlight_red", "Chemlight_yellow", "HandGrenade", "MiniGrenade", "SmokeShell", "SmokeShellBlue",
    "SmokeShellGreen", "SmokeShellOrange", "SmokeShellPurple", "SmokeShellRed", "SmokeShellYellow",

    //Rockets and Missiles:
    "MRAWS_HE_F", "MRAWS_HEAT55_F", "MRAWS_HEAT_F", "NLAW_F", "RPG32_F", "RPG32_HE_F", "RPG7_F", "Titan_AA", "Titan_AP", "Titan_AT", "Vorona_HE", "Vorona_HEAT",

    //Other:
    "Laserbatteries"
];

//Marksman optics most slots do not have access to.
restrictedOpticsMarksman = [
	"optic_AMS", "optic_AMS_khk", "optic_AMS_snd", "optic_DMS", "optic_DMS_ghex_F", "optic_KHS_blk", "optic_KHS_hex", "optic_KHS_tan", "optic_KHS_old", "optic_SOS",
	"optic_SOS_khk_F", "optic_DMS_weathered_F", "optic_DMS_weathered_Kir_F"
];

//Sniper optics most slots do not have access to.
restrictedOpticsSniper = [
	"optic_LRPS", "optic_LRPS_ghex_F", "optic_LRPS_tna_F", "optic_Nightstalker", "optic_tws", "optic_tws_mg"
];

//Mines and explosives most slots do not have access to.
restrictedExplosives = [
	"APERSBoundingMine_Range_Mag", "APERSMine_Range_Mag", "APERSTripMine_Wire_Mag", "ATMine_Range_Mag", "ClaymoreDirectionalMine_Remote_Mag",
	"IEDLandBig_Remote_Mag", "IEDLandSmall_Remote_Mag", "IEDUrbanBig_Remote_Mag", "IEDUrbanSmall_Remote_Mag", "SatchelCharge_Remote_Mag", "SLAMDirectionalMine_Wire_Mag",
	"TrainingMine_Mag"
];
//"APERSMineDispenser_Mag",

//UW gun
underWaterGun = ["arifle_SDAR_F"];

//Pistols all slots have access to.
generalPistols = [
	"hgun_ACPC2_F", "hgun_P07_F", "hgun_P07_khk_F", "hgun_Pistol_01_F", "hgun_Pistol_Signal_F", "hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_02_F", "hgun_Rook40_F", "hgun_Rook40_snds_F", "hgun_Pistol_heavy_01_green_F"
];
afterGeneralPistols = [
	"hgun_ACPC2_snds_F", "hgun_P07_snds_F", "hgun_P07_khk_Snds_F", "hgun_Pistol_heavy_01_snds_F", "hgun_Pistol_heavy_01_MRD_F", "hgun_Pistol_heavy_02_Yorris_F"
];
generalPistols = generalPistols + afterGeneralPistols;

//Submachine guns most slots have access to.
generalSMGs = [
	"hgun_PDW2000_F", "SMG_01_F", "SMG_02_F", "SMG_05_F", "SMG_03_black", "SMG_03_khaki", "SMG_03_TR_black", "SMG_03_TR_khaki", "SMG_03C_black", "SMG_03C_khaki",
	"SMG_03C_TR_black", "SMG_03C_TR_khaki", "sgun_HunterShotgun_01_sawedoff_F"
];
afterGeneralSMGs = [
	"hgun_PDW2000_snds_F", "hgun_PDW2000_Holo_F", "hgun_PDW2000_Holo_snds_F", "SMG_01_Holo_F", "SMG_01_Holo_pointer_snds_F", "SMG_01_ACO_F", 
	"SMG_02_ACO_F", "SMG_02_ARCO_pointg_F"
];
generalSMGs = generalSMGs + afterGeneralSMGs;

//Carbines many slots have access to.
generalCarbines = [
	"arifle_AKS_F", "arifle_Katiba_C_F", "arifle_Mk20C_F", "arifle_Mk20C_plain_F", "arifle_MXC_Black_F", "arifle_MXC_F", "arifle_MXC_khk_F", "arifle_TRG20_F",
	"arifle_AK12U_F", "arifle_AK12U_arid_F", "arifle_AK12U_lush_F", "sgun_HunterShotgun_01_F", "arifle_MSBS65_F", "arifle_MSBS65_black_F",
	"arifle_MSBS65_camo_F", "arifle_MSBS65_sand_F"
];
afterGeneralCarbines = [
	"arifle_Katiba_C_ACO_pointer_F", "arifle_Katiba_C_ACO_F", "arifle_Katiba_C_ACO_pointer_snds_F", "arifle_Mk20C_ACO_F", "arifle_Mk20C_ACO_pointer_F", 
	"rifle_MXC_khk_Holo_Pointer_F", "arifle_MXC_khk_ACO_F", "arifle_MXC_khk_ACO_Pointer_Snds_F", "arifle_MXC_Holo_F", "arifle_MXC_Holo_pointer_F",
	"arifle_MXC_ACO_F", "arifle_MXC_Holo_pointer_snds_F", "arifle_MXC_ACO_pointer_snds_F", "arifle_MXC_ACO_pointer_F", "arifle_TRG20_Holo_F", 
	"arifle_TRG20_ACO_pointer_F", "arifle_TRG20_ACO_Flash_F", "arifle_TRG20_ACO_F"
];
generalCarbines = generalCarbines + afterGeneralCarbines;

//Assault rifles many slots have access to.
generalAssaultRifles = [
	"arifle_AK12_F", "arifle_AK12_arid_F", "arifle_AK12_lush_F", "arifle_AKM_F", "arifle_AKM_FL_F", "arifle_CTAR_blk_F", "arifle_CTAR_ghex_F", "arifle_CTAR_hex_F", 
	"arifle_Katiba_F", "arifle_Mk20_F", "arifle_Mk20_plain_F", "arifle_MX_Black_F", "arifle_MX_F", "arifle_MX_khk_F", "arifle_SPAR_01_blk_F", "arifle_SPAR_01_khk_F", 
	"arifle_SPAR_01_snd_F", "arifle_TRG21_F", "arifle_MSBS65_Mark_F", "arifle_MSBS65_Mark_black_F", "arifle_MSBS65_Mark_camo_F", "arifle_MSBS65_Mark_sand_F",
	"arifle_MSBS65_UBS_F", "arifle_MSBS65_UBS_black_F", "arifle_MSBS65_UBS_camo_F", "arifle_MSBS65_UBS_sand_F"
];
afterGeneralAssaultRifles = [
	"arifle_CTAR_blk_ACO_Pointer_F", "arifle_CTAR_blk_Pointer_F", "arifle_CTAR_blk_ACO_F", "arifle_CTAR_blk_ARCO_Pointer_F", "arifle_CTAR_blk_ACO_Pointer_Snds_F",
	"arifle_CTAR_blk_ARCO_Pointer_Snds_F", "arifle_CTAR_blk_ARCO_F", "arifle_Katiba_ACO_F", "arifle_Katiba_pointer_F", "arifle_Katiba_ACO_pointer_F",
	"arifle_Katiba_ARCO_F", "arifle_Katiba_ARCO_pointer_F", "arifle_Katiba_ACO_pointer_snds_F", "arifle_Katiba_ARCO_pointer_snds_F", "arifle_Mk20_pointer_F",
	"arifle_Mk20_Holo_F", "arifle_Mk20_ACO_F", "arifle_Mk20_ACO_pointer_F", "arifle_Mk20_MRCO_F", "arifle_Mk20_MRCO_plain_F", "arifle_Mk20_MRCO_pointer_F",
	"arifle_MX_pointer_F", "arifle_MX_Holo_pointer_F", "arifle_MX_Hamr_pointer_F", "arifle_MX_ACO_pointer_F", "arifle_MX_ACO_F", "arifle_MX_ACO_pointer_snds_F",
	"arifle_MX_RCO_pointer_snds_F", "arifle_MX_Black_Hamr_pointer_F", "arifle_SPAR_01_blk_ERCO_Pointer_F", "arifle_SPAR_01_blk_ACO_Pointer_F", 
	"arifle_TRG21_ACO_pointer_F", "arifle_TRG21_ARCO_pointer_F", "arifle_TRG21_MRCO_F"
];

//Assault rifles with underbarrel grenade launchers most slots do not have access to.
restrictedAssaultRiflesUGL = [
    "arifle_AK12_GL_F", "arifle_AK12_GL_arid_F", "arifle_AK12_GL_lush_F", "arifle_CTAR_GL_blk_F", "arifle_CTAR_GL_ghex_F", "arifle_CTAR_GL_hex_F", "arifle_Katiba_GL_F",
    "arifle_Mk20_GL_F", "arifle_Mk20_GL_plain_F", "arifle_MX_GL_Black_F", "arifle_MX_GL_F", "arifle_MX_GL_khk_F", "arifle_SPAR_01_GL_blk_F", "arifle_SPAR_01_GL_khk_F",
    "arifle_SPAR_01_GL_snd_F", "arifle_TRG21_GL_F", "arifle_MSBS65_GL_F", "arifle_MSBS65_GL_black_F", "arifle_MSBS65_GL_camo_F", "arifle_MSBS65_GL_sand_F"
];
afterRestrictedAssaultRiflesUGL = [
	"arifle_CTAR_GL_blk_ACO_F", "arifle_CTAR_GL_blk_ARCO_Pointer_F", "arifle_CTAR_GL_blk_ACO_Pointer_Snds_F", "arifle_CTAR_GL_blk_aco_flash_F", 
	"arifle_CTAR_GL_blk_arco_flash_F", "arifle_Katiba_GL_ACO_F", "arifle_Katiba_GL_ARCO_pointer_F", "arifle_Katiba_GL_ACO_pointer_F", 
	"arifle_Katiba_GL_Nstalker_pointer_F", "arifle_Katiba_GL_ACO_pointer_snds_F", "arifle_Mk20_GL_MRCO_pointer_F", "arifle_Mk20_GL_ACO_F",
	"arifle_MX_GL_ACO_F", "arifle_MX_GL_ACO_pointer_F", "arifle_MX_GL_Hamr_pointer_F", "arifle_MX_GL_Holo_pointer_snds_F", 
	"arifle_MX_GL_Black_Hamr_pointer_F", "arifle_MX_GL_khk_ACO_F", "arifle_MX_GL_khk_Hamr_Pointer_F", "arifle_MX_GL_khk_Holo_Pointer_Snds_F",
	"arifle_SPAR_01_GL_blk_ACO_Pointer_F", "arifle_SPAR_01_GL_blk_ERCO_Pointer_F", "arifle_TRG21_GL_MRCO_F", "arifle_TRG21_GL_ACO_pointer_F"
];
restrictedAssaultRiflesUGL = restrictedAssaultRiflesUGL + afterRestrictedAssaultRiflesUGL;

//Light / Medium Machine Guns most slots do not have access to.
restrictedMGs = [
    "arifle_CTARS_blk_F", "arifle_CTARS_ghex_F", "arifle_CTARS_hex_F", "arifle_MX_SW_Black_F", "arifle_MX_SW_F", "arifle_MX_SW_khk_F", "arifle_SPAR_02_blk_F",
    "arifle_SPAR_02_khk_F", "arifle_SPAR_02_snd_F", "LMG_03_F", "LMG_Mk200_F", "LMG_Mk200_black_F", "LMG_Zafir_F", "MMG_01_hex_F", "MMG_01_tan_F", "MMG_02_black_F", "MMG_02_camo_F",
    "MMG_02_sand_F", "arifle_RPK12_F", "arifle_RPK12_arid_F", "arifle_RPK12_lush_F", "LMG_Zafir_pointer_F"
];

afterRestrictedMGs = [
    "arifle_CTARS_blk_Pointer_F"
];

//Designated Marksman Rifles most slots do not have access to.
restrictedDMRs = [
    "arifle_MXM_Black_F", "arifle_MXM_F", "arifle_MXM_khk_F", "arifle_SPAR_03_blk_F", "arifle_SPAR_03_khk_F", "arifle_SPAR_03_snd_F", "srifle_DMR_01_F",
    "srifle_DMR_02_camo_F", "srifle_DMR_02_F", "srifle_DMR_02_sniper_F", "srifle_DMR_03_F", "srifle_DMR_03_khaki_F", "srifle_DMR_03_multicam_F", "srifle_DMR_03_tan_F",
    "srifle_DMR_03_woodland_F", "srifle_DMR_05_blk_F", "srifle_DMR_05_hex_F", "srifle_DMR_05_tan_f", "srifle_DMR_06_camo_F", "srifle_DMR_06_olive_F",
    "srifle_DMR_07_blk_F", "srifle_DMR_07_ghex_F", "srifle_DMR_07_hex_F", "srifle_EBR_F", "srifle_DMR_06_hunter_F", "srifle_DMR_05_KHS_LP_F", "srifle_DMR_05_DMS_F",
    "srifle_DMR_05_SOS_F", "srifle_DMR_05_MRCO_F", "srifle_DMR_05_ACO_F", "srifle_DMR_05_DMS_snds_F", "srifle_DMR_05_ARCO_F",
    "arifle_MSBS65_Mark_F", "arifle_MSBS65_Mark_black_F", "arifle_MSBS65_Mark_sand_F", "arifle_MSBS65_Mark_camo_F"
];

//Sniper rifles most slots do not have access to.
restrictedSniperRifles = [
    "srifle_DMR_02_camo_F", "srifle_DMR_02_F", "srifle_DMR_02_sniper_F", "srifle_GM6_camo_F", "srifle_GM6_F", "srifle_GM6_ghex_F", "srifle_LRR_camo_F", "srifle_LRR_F",
    "srifle_LRR_tna_F"
];

restrictedLAT = ["launch_RPG32_F", "launch_RPG32_green_F", "launch_RPG7_F", "launch_MRAWS_green_rail_F", "launch_MRAWS_olive_rail_F", "launch_MRAWS_sand_rail_F"];

afterRestrictedLAT = ["launch_RPG32_ghex_F"];

restrictedMAT = ["launch_MRAWS_green_F", "launch_MRAWS_olive_F", "launch_MRAWS_sand_F", "launch_NLAW_F"];

restrictedHAT = ["launch_B_Titan_F", "launch_I_Titan_eaf_F", "launch_B_Titan_olive_F", "launch_B_Titan_short_F", "launch_B_Titan_short_tna_F", "launch_B_Titan_tna_F", "launch_O_Vorona_brown_F", "launch_O_Vorona_green_F"];

//Weapons most slots do not have access to.
restrictedWeaponsRecon = [
	"arifle_ARX_blk_F", "arifle_ARX_ghex_F", "arifle_ARX_hex_F", "srifle_DMR_04_F", "srifle_DMR_04_Tan_F"
];

//Glasses all slots have access to.
generalGlasses = [
	"G_Aviator", "G_B_Diving", "G_Balaclava_blk", "G_Balaclava_combat", "G_Balaclava_lowprofile", "G_Balaclava_oli", "G_Balaclava_TI_blk_F", "G_Balaclava_TI_G_blk_F",
	"G_Balaclava_TI_G_tna_F", "G_Balaclava_TI_tna_F", "G_Bandanna_aviator", "G_Bandanna_beast", "G_Bandanna_blk", "G_Bandanna_khk", "G_Bandanna_oli",
	"G_Bandanna_shades", "G_Bandanna_sport", "G_Bandanna_tan", "G_Combat", "G_Combat_Goggles_tna_F", "G_Diving", "G_EyeProtectors_Earpiece_F", "G_EyeProtectors_F",
	"G_Goggles_VR", "G_Lady_Blue", "G_Lowprofile", "G_Respirator_blue_F", "G_Respirator_white_F", "G_Respirator_yellow_F", "G_Shades_Black", "G_Shades_Blue",
	"G_Shades_Green", "G_Shades_Red", "G_Spectacles", "G_Spectacles_Tinted", "G_Sport_Blackred", "G_Sport_BlackWhite", "G_Sport_Blackyellow", "G_Sport_Checkered",
	"G_Sport_Greenblack", "G_Sport_Red", "G_Squares", "G_Squares_Tinted", "G_Tactical_Black", "G_Tactical_Clear", "G_WirelessEarpiece_F",
	"G_AirPurifyingRespirator_01_F", "G_RegulatorMask_F", "G_AirPurifyingRespirator_02_black_F", "G_AirPurifyingRespirator_02_olive_F",
	"G_AirPurifyingRespirator_02_sand_F"
];

//Headgear most slots have access to.
generalHeadgear = [
	"H_Bandanna_blu", "H_Bandanna_camo", "H_Bandanna_cbr", "H_Bandanna_gry", "H_Bandanna_khk", "H_Bandanna_khk_hs", "H_Bandanna_mcamo", "H_Bandanna_sand",
	"H_Bandanna_sgg", "H_Bandanna_surfer", "H_Bandanna_surfer_blk", "H_Bandanna_surfer_grn", "H_Beret_02", "H_Beret_blk", "H_Beret_Colonel", "H_Booniehat_khk",
	"H_Booniehat_khk_hs", "H_Booniehat_mcamo", "H_Booniehat_oli", "H_Booniehat_tan", "H_Booniehat_tna_F", "H_Cap_blk", "H_Cap_blu", "H_Cap_grn", "H_Cap_grn_BI",
	"H_Cap_headphones", "H_Cap_khaki_specops_UK", "H_Cap_oli", "H_Cap_oli_hs", "H_Cap_red", "H_Cap_surfer", "H_Cap_tan", "H_Cap_tan_specops_US", "H_Cap_usblack",
	"H_EarProtectors_black_F", "H_EarProtectors_orange_F", "H_EarProtectors_red_F", "H_EarProtectors_white_F", "H_EarProtectors_yellow_F", "H_Hat_blue", "H_Hat_brown",
	"H_Hat_camo", "H_Hat_checker", "H_Hat_grey", "H_Hat_Safari_olive_F", "H_Hat_Safari_sand_F", "H_Hat_tan", "H_HeadBandage_bloody_F", "H_HeadBandage_clean_F",
	"H_HeadBandage_stained_F", "H_HeadSet_black_F", "H_HeadSet_orange_F", "H_HeadSet_red_F", "H_HeadSet_white_F", "H_HeadSet_yellow_F", "H_MilCap_blue", "H_MilCap_gry",
	"H_MilCap_mcamo", "H_MilCap_tna_F", "H_StrawHat", "H_StrawHat_dark", "H_Watchcap_blk", "H_Watchcap_camo", "H_Watchcap_cbr", "H_Watchcap_khk",
	"H_WirelessEarpiece_F", "H_Booniehat_mgrn", "H_Booniehat_wdl", "H_MilCap_grn", "H_MilCap_wdl", "H_Hat_Tinfoil_F", "H_Booniehat_taiga", "H_Booniehat_eaf",
	"H_MilCap_taiga", "H_MilCap_eaf", "H_Beret_EAF_01_F", "H_Shemag_olive", "H_Shemag_olive_hs", "H_ShemagOpen_tan", "H_ShemagOpen_khk"
];

//Helmets most slots have access to.
generalHeadgearHelmets = [
	"H_Helmet_Skate", "H_HelmetB", "H_HelmetB_black", "H_HelmetB_camo", "H_HelmetB_desert", "H_HelmetB_Enh_tna_F", "H_HelmetB_grass",
	"H_HelmetB_light", "H_HelmetB_light_black", "H_HelmetB_light_desert", "H_HelmetB_light_grass", "H_HelmetB_light_sand", "H_HelmetB_light_snakeskin",
	"H_HelmetB_Light_tna_F", "H_HelmetB_sand", "H_HelmetB_snakeskin", "H_HelmetB_TI_tna_F", "H_HelmetB_tna_F", "H_HelmetCrew_B", "H_HelmetSpecB", "H_HelmetSpecB_blk",
	"H_HelmetSpecB_paint1", "H_HelmetSpecB_paint2", "H_HelmetSpecB_sand", "H_HelmetSpecB_snakeskin", "H_PASGT_basic_black_F", "H_PASGT_basic_blue_F",
	"H_PASGT_basic_olive_F", "H_PASGT_basic_white_F", "H_HelmetB_plain_wdl", "H_HelmetSpecB_wdl", "H_HelmetB_light_wdl", "H_HelmetHBK_headset_F",
	"H_HelmetHBK_chops_F", "H_HelmetHBK_ear_F", "H_HelmetHBK_F", "H_HelmetAggressor_cover_F", "H_HelmetAggressor_cover_taiga_F", "H_Tank_eaf_F", "H_HelmetCrew_I_E"
];

//Headgear most slots do not have access to.
restrictedHeadgearEOD = [
	"H_Construction_basic_black_F", "H_Construction_basic_orange_F", "H_Construction_basic_red_F", "H_Construction_basic_white_F", "H_Construction_basic_yellow_F",
	"H_Construction_earprot_black_F", "H_Construction_earprot_orange_F", "H_Construction_earprot_red_F", "H_Construction_earprot_white_F",
	"H_Construction_earprot_yellow_F", "H_Construction_headset_black_F", "H_Construction_headset_orange_F", "H_Construction_headset_red_F",
	"H_Construction_headset_white_F", "H_Construction_headset_yellow_F"
];

heagearOfficer = [
    "H_Beret_EAF_01_F"
];

//Headgear most slots do not have access to.
restrictedHeadgearPilot = [
	"H_CrewHelmetHeli_B", "H_PilotHelmetFighter_B", "H_PilotHelmetHeli_B", "H_CrewHelmetHeli_I_E", "H_PilotHelmetHeli_I_E", "H_PilotHelmetFighter_I_E"
];

//Uniforms most slots have access to.
generalUniforms = [
    "U_I_C_Soldier_Para_1_F", "U_I_C_Soldier_Para_2_F", "U_I_C_Soldier_Para_3_F", "U_I_C_Soldier_Para_4_F", "U_I_C_Soldier_Para_5_F",
	"U_B_CombatUniform_mcam", "U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest", "U_B_CombatUniform_mcam_worn", "U_B_CTRG_1", "U_B_CTRG_2", "U_B_CTRG_3",
	"U_B_CTRG_Soldier_2_F", "U_B_CTRG_Soldier_3_F", "U_B_CTRG_Soldier_F", "U_B_CTRG_Soldier_urb_1_F", "U_B_CTRG_Soldier_urb_2_F", "U_B_CTRG_Soldier_urb_3_F",
	"U_B_survival_uniform", "U_B_Wetsuit", "U_B_CombatUniform_mcam_wdl_f", "U_B_CombatUniform_tshirt_mcam_wdL_f", "U_B_CombatUniform_vest_mcam_wdl_f",
	"U_B_CombatUniform_vest_mcam_wdl_f", "U_I_E_CBRN_Suit_01_EAF_F", "U_C_CBRN_Suit_01_Blue_F", "U_B_CBRN_Suit_01_MTP_F", "U_B_CBRN_Suit_01_Tropic_F",
	"U_B_CBRN_Suit_01_Wdl_F", "U_I_E_CBRN_Suit_01_EAF_F", "U_I_E_Uniform_01_shortsleeve_F", "U_I_E_Uniform_01_sweater_F", "U_I_E_Uniform_01_tanktop_F",
	"U_I_E_Uniform_01_F", "U_I_L_Uniform_01_deserter_F", "U_O_R_Gorka_01_F", "U_O_R_Gorka_01_brown_F", "U_O_R_Gorka_01_camo_F", "U_O_R_Gorka_01_black_F",
	"V_SmershVest_01_F", "V_SmershVest_01_radio_F", "V_CarrierRigKBT_01_heavy_EAF_F", "V_CarrierRigKBT_01_heavy_Olive_F", "V_CarrierRigKBT_01_light_EAF_F",
	"V_CarrierRigKBT_01_light_Olive_F", "V_CarrierRigKBT_01_EAF_F", "V_CarrierRigKBT_01_Olive_F", "U_I_G_resistanceLeader_F"
];

//Uniforms most slots do not have access to.
restrictedUniformsMarksman = [
	"U_B_GhillieSuit", "U_B_T_Sniper_F"
];

//Uniforms most slots do not have access to.
restrictedUniformsPilot = [
	"U_B_HeliPilotCoveralls", "U_B_PilotCoveralls", "U_Marshal", "U_I_E_Uniform_01_coveralls_F"
];

//Uniforms most slots do not have access to.
restrictedUniformsSniper = [
	"U_B_FullGhillie_ard", "U_B_FullGhillie_lsh", "U_B_FullGhillie_sard", "U_B_T_FullGhillie_tna_F"
];

restrictedOfficer = [
    "U_I_E_Uniform_01_officer_F"
];

//Vests most slots have access to.
generalVests = [
	"V_BandollierB_blk", "V_BandollierB_cbr", "V_BandollierB_khk", "V_BandollierB_oli", "V_BandollierB_rgr", "V_Chestrig_blk", "V_Chestrig_khk", "V_Chestrig_oli",
	"V_Chestrig_rgr", "V_DeckCrew_blue_F", "V_DeckCrew_brown_F", "V_DeckCrew_green_F", "V_DeckCrew_red_F", "V_DeckCrew_violet_F", "V_DeckCrew_white_F",
	"V_DeckCrew_yellow_F", "V_I_G_resistanceLeader_F", "V_LegStrapBag_black_F", "V_LegStrapBag_coyote_F", "V_LegStrapBag_olive_F", "V_PlateCarrier1_blk",
	"V_PlateCarrier1_rgr", "V_PlateCarrier1_rgr_noflag_F", "V_PlateCarrier1_tna_F", "V_PlateCarrier2_blk", "V_PlateCarrier2_rgr", "V_PlateCarrier2_rgr_noflag_F",
	"V_PlateCarrier2_tna_F", "V_PlateCarrierGL_blk", "V_PlateCarrierGL_mtp", "V_PlateCarrierGL_rgr", "V_PlateCarrierGL_tna_F", "V_PlateCarrierH_CTRG",
	"V_PlateCarrierIAGL_oli", "V_PlateCarrierL_CTRG", "V_PlateCarrierSpec_blk", "V_PlateCarrierSpec_mtp", "V_PlateCarrierSpec_rgr", "V_PlateCarrierSpec_tna_F",
	"V_Pocketed_black_F", "V_Pocketed_coyote_F", "V_Pocketed_olive_F", "V_Rangemaster_belt", "V_RebreatherB", "V_Safety_blue_F", "V_Safety_orange_F",
	"V_Safety_yellow_F", "V_TacChestrig_cbr_F", "V_TacChestrig_grn_F", "V_TacChestrig_oli_F", "V_TacVest_blk", "V_TacVest_brn", "V_TacVest_camo", "V_TacVest_khk",
	"V_TacVest_oli", "V_TacVestIR_blk", "V_PlateCarrierGL_wdl", "V_PlateCarrier1_wdl", "V_PlateCarrier2_wdl", "V_PlateCarrierSpec_wdl"
];

//Vests most slots do not have access to.
restrictedVestsEOD = [
	"V_EOD_blue_F", "V_EOD_coyote_F", "V_EOD_olive_F"
];

//Vests Pilots are allowed to use.
allowedVestsPilot = [
	"V_BandollierB_blk", "V_BandollierB_oli", "V_BandollierB_rgr", "V_LegStrapBag_black_F", "V_Pocketed_black_F", "V_Pocketed_coyote_F", "V_Pocketed_olive_F",
	"V_Rangemaster_belt", "V_Safety_blue_F", "V_Safety_orange_F", "V_Safety_yellow_F", "V_TacVest_blk", "V_TacVest_oli"
];

//Backpacks all slots have access to.
generalBackpacks = [
	"B_AssaultPack_blk", "B_AssaultPack_cbr", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_AssaultPack_tna_F",
	"B_Bergen_mcamo_F", "B_Bergen_tna_F", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_oli", "B_FieldPack_blk", "B_FieldPack_cbr",
	"B_FieldPack_khk", "B_FieldPack_oli", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_sgg", "B_LegStrapBag_black_F", "B_LegStrapBag_coyote_F",
	"B_LegStrapBag_olive_F", "B_Messenger_Black_F", "B_Messenger_Coyote_F", "B_Messenger_Gray_F", "B_Messenger_Olive_F", "B_Parachute", "B_TacticalPack_blk",
	"B_TacticalPack_mcamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "B_ViperHarness_blk_F", "B_ViperHarness_khk_F", "B_ViperHarness_oli_F",
	"B_ViperLightHarness_blk_F", "B_ViperLightHarness_khk_F", "B_ViperLightHarness_oli_F", "B_AssaultPack_wdl_F", "B_Carryall_green_F", "B_Carryall_wdl_F", 
	"B_FieldPack_green_F", "B_AssaultPack_eaf_F", "B_Carryall_eaf_F", "B_Carryall_taiga_F", "B_FieldPack_taiga_F", "B_RadioBag_01_black_F", "B_RadioBag_01_mtp_F",
	"B_RadioBag_01_tropic_F", "B_RadioBag_01_wdl_F", "B_RadioBag_01_eaf_F", "B_SCBA_01_F", "B_CombinationUnitRespirator_01_F"
];

afterArsenalBackpacks = [
	"B_AssaultPack_blk_DiverExp", "B_Kitbag_rgr_Exp", "B_AssaultPack_mcamo_AT", "B_AssaultPack_rgr_ReconMedic", "B_AssaultPack_rgr_ReconExp",
	"B_AssaultPack_rgr_ReconLAT", "B_AssaultPack_mcamo_AA", "B_AssaultPack_mcamo_AAR", "B_AssaultPack_mcamo_Ammo", "B_Kitbag_mcamo_Eng", "B_Carryall_mcamo_AAA",
	"B_Carryall_mcamo_AAT", "B_Kitbag_rgr_AAR", "B_FieldPack_blk_DiverExp", "B_FieldPack_cbr_AT", "B_FieldPack_cbr_AAT", "B_FieldPack_cbr_AA", "B_FieldPack_cbr_AAA",
	"B_FieldPack_cbr_Medic", "B_FieldPack_cbr_RPG_AT", "I_Fieldpack_oli_Ammo", "I_Fieldpack_oli_Medic", "I_Fieldpack_oli_Repair", "I_Fieldpack_oli_LAT",
	"I_Fieldpack_oli_AT", "I_Fieldpack_oli_AAR", "I_Carryall_oli_AAT", "I_Carryall_oli_Exp", "I_Carryall_oli_AAA", "I_Carryall_oli_Eng", "G_TacticalPack_Eng",
	"G_FieldPack_Medic", "G_FieldPack_LAT", "G_Carryall_Ammo", "G_Carryall_Exp", "B_TacticalPack_oli_AAR"
];
generalBackpacks = generalBackpacks + afterArsenalBackpacks;

//UAV backpacks all slots have access to.
generalDroneBackpacks = [
	"B_UAV_01_backpack_F", "B_UAV_06_backpack_F", "B_UAV_06_medical_backpack_F", "B_W_Static_Designator_01_weapon_F", "B_UGV_02_Demining_backpack_F", "B_UGV_02_Science_backpack_F"
];

//Static weapon backpacks all slots have access to.
generalStaticWeapons = [
	"B_AA_01_weapon_F", "B_AT_01_weapon_F", "B_GMG_01_A_weapon_F", "B_GMG_01_high_weapon_F", "B_GMG_01_weapon_F", "B_HMG_01_A_weapon_F", "B_HMG_01_high_weapon_F",
	"B_HMG_01_support_F", "B_HMG_01_support_high_F", "B_HMG_01_weapon_F", "B_Mortar_01_support_F", "B_Mortar_01_weapon_F", "B_Static_Designator_01_weapon_F"
];

blacklistArray = ["APERSMineDispenser_Mag"];
